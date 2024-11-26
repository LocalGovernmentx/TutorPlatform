import requests
from bs4 import BeautifulSoup
import json
import os
from urllib.error import HTTPError
from urllib import request
from langchain_teddynote.document_loaders import HWPLoader
from langchain_community.document_loaders import PyPDFLoader
import re


prompt_llm1 = """The response in the following paragraphs contains the certification in JSON format.
Parameters only return '일련번호', '성명', '생년월일', '전공', '복수전공', '학위', '입학일자', '발급일자', '재학학년', '학교명'.
Below is an example JSON format.
All parameters are returned in Korean.
{
'일련번호':'제2020-0123456호', 
'성명': '홍길동', 
'생년월일': '1990년 3월 2일',
'전공': '정보통신공학과', 
'복수전공': '심리학과', 
'학위': '학사과정',
'입학일자': '2021.02.03',
'발급일자': '2022년 04월 05일',
'재학학년': '제 3학년',
'학교명': '서울대학교'
}
All parameter are String type.
If each parameter cannot be found, it returns null.
paragraphs:  '''
"""

"""
{
'일련번호':<String>, 
'성명': <String>, 
'생년월일': <String>,
'전공': <String>, 
'복수전공': <String>, 
'학위': <String>,
'입학일자': <String>,
'발급일자': <String>,
'재학학년': <String>,
'학교명': <String>
}
"""

prompt_llm = """다음 단락의 내용을 바탕으로 JSON 포맷으로 증명서 내용을 응답해준다.
파라미터는 '일련번호', '성명', '생년월일', '전공', '복수전공', '학위', '입학일자', '발급일자', '재학학년', '학교명' 만을 받는다.
다음은 샘플 응답 JSON 포맷으로, 다음과 같은 카테고리에 맞는 값을 단락으로부터 찾아서 반환한다. 
{
'일련번호':'제**-**호', 
'성명': '***', 
'생년월일': '****년 **월 **일',
'전공': '**학과', 
'복수전공': '**학과', 
'학위': '**과정',
'입학일자': '****.**.**',
'발급일자': '*년 *월 *일',
'재학학년': '*학년',
'학교명': '**대학교'
}
파라미터는 모두 한국어로 반환한다. 
모든 파라미터는 문자열 타입이다.
만약 단락에서 각 파라미터를 찾을 수 없다면 해당 파라미터는 null을 반환한다. 
단락:  '''
"""

prompt_llm3 = """다음 단락의 내용을 바탕으로 JSON 포맷으로 증명서 내용을 응답해준다.
파라미터는 '일련번호', '성명', '생년월일', '전공', '복수전공', '학위', '입학일자', '발급일자', '재학학년', '학교명' 만을 받는다.
다음은 샘플 응답 JSON 포맷으로, 다음과 같은 카테고리에 맞는 값을 단락으로부터 찾아서 반환한다. 
{
'일련번호':<String>, 
'성명': <String>, 
'생년월일': <String>,
'전공': <String>, 
'복수전공': <String>, 
'학위': <String>,
'입학일자': <String>,
'발급일자': <String>,
'재학학년': <String>,
'학교명': <String>
}
파라미터는 모두 한국어로 반환한다. 
모든 파라미터는 문자열 타입이다.
만약 단락에서 각 파라미터를 찾을 수 없다면 해당 파라미터는 null을 반환한다. 
단락:  '''
"""


parameter_llm = {
    "model": "llama3",
    "prompt": prompt_llm,
    "stream": False,
    "format": "json",
}

pdf_filepath = "김민욱_재학증명서.pdf"

url_llm = "http://localhost:11434/api/generate"

url_pattern = re.compile(r"^https?:\/\/\w+(\.\w+)*(:[0-9]+)?(\/.*)?$")

file_path_pattern = re.compile(r"^(\\\\[^\\]+\\[^\\]+|https?://[^/]+)")

json_path = f"C:/Users/Minuk/TutorPlatform/CrawlingPost/pdfjsondata"


def getDownload(url, fname, directory):
    try:
        os.chdir(directory)
        request.urlretrieve(url, fname)
        print("다운로드 완료\n")
    except HTTPError as e:
        print("error")
        return


# input: file_path
# output: file path로부터 읽어온 hwp 파일의 내용, <String>
def openPDFFileFromFilePath(file_path):
    if not os.path.isfile(file_path):
        return False
    loader = PyPDFLoader(file_path)
    docs = loader.load()

    return docs[0].page_content


# input: html, url_llm, url_http, id
# output: LLM을 통해서 추출한 데이터로 만든 json 파일
def getJsonByContentUsingLLM(content, url_llm, url_http, json_id, t):
    # print(type(content))
    if not isinstance(content, str):
        return False
    elif url_pattern.match(url_llm) is None:
        return False
    elif not isinstance(json_id, int):
        return False

    parameter_llm["prompt"] = t + content + "'''"
    # parameter_llm["prompt"] = prompt_llm + content + "'''"
    response = requests.post(url_llm, json=parameter_llm)

    json_data = json.loads(response.json()["response"])
    json_data["id"] = json_id
    json_data["address"] = url_http

    return json_data


# input: json 파일, 파일 경로, 파일 이름
# output: null
# side: json 형식으로 파일 저장
def saveJsonToFilePath(json_data_list, json_path, json_name):
    if not isinstance(json_data_list, list):
        return False
    if file_path_pattern.match(json_path):
        return False

    with open(f"{json_path}/{json_name}", "w", encoding="utf-8") as f:
        json.dump(json_data_list, f, ensure_ascii=False, indent=4)


if __name__ == "__main__":
    page_content = openPDFFileFromFilePath(pdf_filepath)

    """json_data = getJsonByContentUsingLLM(
        content=page_content[0:1700], url_llm=url_llm, url_http=pdf_filepath, json_id=1
    )

    result = [json_data]"""

    json_data1 = getJsonByContentUsingLLM(
        content=page_content[0:1700],
        url_llm=url_llm,
        url_http=pdf_filepath,
        json_id=1,
        t=prompt_llm,
    )

    json_data2 = getJsonByContentUsingLLM(
        content=page_content[0:1700],
        url_llm=url_llm,
        url_http=pdf_filepath,
        json_id=1,
        t=prompt_llm1,
    )

    json_data3 = getJsonByContentUsingLLM(
        content=page_content[0:1700],
        url_llm=url_llm,
        url_http=pdf_filepath,
        json_id=1,
        t=prompt_llm3,
    )

    result = [json_data1, json_data2, json_data3]

    saveJsonToFilePath(
        json_data_list=result,
        json_path=json_path,
        json_name=(pdf_filepath[:-4] + ".json"),
    )

    print(result)
