import requests
from bs4 import BeautifulSoup
import json
import os
from urllib.error import HTTPError
from urllib import request
from langchain_teddynote.document_loaders import HWPLoader
import bs4
import re
import ssl
import urllib3
from datetime import datetime, timedelta

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)
ssl._create_default_https_context = ssl._create_unverified_context


prompt_llm = """
The response in the following paragraphs contains the program information in JSON format.
Parameters only return '지역', '대상학교', '프로그램', '요일 및 시간', '모집인원', '모집분야', '운영기간', '계약기간', '공고기간', '보수', '강사지원 자격', '공고 및 신청서 접수기간', "제공기관", "연계기관", "차시", "지역", "학년", "신청기간","모집학급", "활동일".
Below is an example JSON format.
All parameters are returned in Korean.
{
'지역':'남부', 
'대상학교': '인천백학초등학교', 
'프로그램': '놀이체육',
'요일 및 시간': '수 13:40~15:10', 
'모집인원': '1', 
'모집분야': '컴퓨터,  생명과학,  주산암산,  미술,  전자로봇,  방송댄스,  한자,  요리제빵', 
'운영기간': '2024.9.9.(월) ~ 2025.2.21.(금)', 
'계약기간': '2018년 3월 ~ 2019년 2월', 
'공고기간': '2018년 1월 2일(화) ~ 1월 12일(금)', 
'보수': '시급 40,000원',
'강사지원 자격': '- 해당 분야에 전문적인 능력을 가진 자 또는 자격증 소유자',
'공고 및 신청서 접수기간': '2024. 9. 2.(월) ~ 2024. 9. 5.(목) 12:00까지',
"제공기관":"국립창원대학교 산학협력단", 
"연계기관": "컨소시엄", 
"차시": "20 차시", 
"지역": "경북-전체", 
"학년": "1학년", 
"신청기간": "2024. 07. 09(화) ~ 2024. 07. 09(화)",
"모집학급": "3",
"활동일": "2024. 08. 16(금) ~ 2024. 12. 31(화)"
}
All parameter are String type.
If each parameter cannot be found, it returns null.
paragraphs:  '''
"""

parameter_llm = {
    "model": "llama3-custom",
    "prompt": prompt_llm,
    "stream": False,
    "format": "json",
}

url_pattern = re.compile(r"^https?:\/\/\w+(\.\w+)*(:[0-9]+)?(\/.*)?$")
# https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)
file_path_pattern = re.compile(r"^(\\\\[^\\]+\\[^\\]+|https?://[^/]+)")

json_path = f"C:/Users/Minuk/TutorPlatform/CrawlingPost/jsondata"

files_path = f"C:/Users/Minuk/TutorPlatform/CrawlingPost/files"

http_methods = ["GET", "POST"]

url_llm = "http://localhost:11434/api/generate"

sources = ["Afterschool", "Busan", "Daegu", "Incheon"]

parameters = [
    {  # Afterschool
        "url_http_list": "https://afterschool.kofac.re.kr/program/app/view/menu/245?eduPrgrmSn={}",
        "http_list_header": {
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36",
            "referer": "https://afterschool.kosac.re.kr/program/app/list/menu/245",
        },
        "http_list_verify": None,
        "http_list_method": "GET",
        "source": "Afterschool",
        "file_name": f"Afterschool.json",
    },
    {  # Busan
        "url_http_list": "https://home.pen.go.kr/afterschool/na/ntt/selectNttList.do?mi=14360&bbsId=4177&currPage={}",
        "http_list_header": {
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36",
            "referer": "https://home.pen.go.kr/afterschool/na/ntt/selectNttList.do?mi=14360&bbsId=4177",
        },
        "http_list_verify": False,
        "http_list_method": "POST",
        "url_http_detail": "https://home.pen.go.kr/afterschool/na/ntt/selectNttInfo.do?mi=14360&bbsId=4177&nttSn={}&currPage={}",
        "http_detail_header": {
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36",
            "referer": "https://home.pen.go.kr/afterschool/na/ntt/selectNttList.do?mi=14360&bbsId=4177",
        },
        "http_detail_verify": False,
        "http_detail_method": "POST",
        "source": "Busan",
        "file_name": f"Busan.json",
        "url_file": "https://home.pen.go.kr/common/nttFileDownload.do?fileKey={}",
    },
    {  # Daegu, Cookie 변경해줘야 함
        "url_http_list": "https://www.dge.go.kr/afterschool/ad/as/pssrp/extPssrpList.do?mi=1840&currPage={}",
        "http_list_header": {
            "Cookie": """WMONID=z2R3PMp28B1; XTVID=A240707121355882388; xloc=1646X1029; _harry_lang=ko; _harry_fid=hh1474820963; _harry_ref=; JSESSIONID="-mbgp4ppcu41ZG0WhPf_QN-bHf7ceOMwuPjLC2T3.dgedu_slave2:dg22"; _harry_url=https%3A//www.dge.go.kr/afterschool/ad/as/pssrp/extPssrpList.do%23none; _harry_hsid=A241113172247125359; _harry_dsid=A241113172247125848""",
            "connection": "keep-alive",
            "Host": "www.dge.go.kr",
            "Accept-Encoding": "gzip, deflate, br",
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36",
            "referer": "https://www.dge.go.kr/afterschool/ad/as/pssrp/extPssrpList.do",
        },
        "http_list_verify": None,
        "http_list_method": "GET",
        "url_http_detail": "https://www.dge.go.kr/afterschool/ad/as/pssrp/pssrpInfoPage.do?mi=1840&pssrpSn={}&currPage={}",
        "http_detail_header": {
            "Cookie": """WMONID=z2R3PMp28B1; XTVID=A240707121355882388; xloc=1646X1029; _harry_lang=ko; _harry_fid=hh1474820963; _harry_ref=; JSESSIONID="-mbgp4ppcu41ZG0WhPf_QN-bHf7ceOMwuPjLC2T3.dgedu_slave2:dg22"; _harry_url=https%3A//www.dge.go.kr/afterschool/ad/as/pssrp/extPssrpList.do%23none; _harry_hsid=A241113172247125359; _harry_dsid=A241113172247125848""",
            "connection": "keep-alive",
            "Host": "www.dge.go.kr",
            "Accept-Encoding": "gzip, deflate, br",
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36",
            "referer": "https://www.dge.go.kr/afterschool/ad/as/pssrp/extPssrpList.do",
        },
        "http_detail_verify": None,
        "http_detail_method": "POST",
        "source": "Daegu",
        "file_name": f"Daegu.json",
        "url_file": "https://www.dge.go.kr{}",
    },
    {  # Incheon
        "url_http_list": "https://www.ice.go.kr/afterschool/na/ntt/selectNttList.do?currPage={}&mi=10571&bbsId=1534",
        "http_list_header": {
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36",
            "referer": "https://www.ice.go.kr/afterschool/main.do",
        },
        "http_list_verify": None,
        "http_list_method": "POST",
        "url_http_detail": "https://www.ice.go.kr/afterschool/na/ntt/selectNttInfo.do?bbsId=1534&nttSn={}&mi=10571&currPage={}&listCo=10&searchType=all",
        "http_detail_header": {
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36",
            "referer": "https://www.ice.go.kr/afterschool/main.do",
        },
        "http_detail_verify": None,
        "http_detail_method": "POST",
        "source": "Incheon",
        "file_name": f"Incheon.json",
        "url_file": "https://www.ice.go.kr/comm/nttFileDownload.do?fileKey={}",
    },
]


# input: url, header, http method
# output: 가공되지 않은 html
# url이 valid 하지 않을 경우 error
# header의 type이 dict가 아닐 경우 error
# http method가 GET이나 POST가 아닐 경우 error
def getRawHtmlByUrl(url, request_header, http_method, verify=None):
    if url_pattern.match(url) is None:
        print("url pattern not match")
        return False
    elif not isinstance(request_header, dict):
        print("header type is not dict")
        return False
    elif http_method not in http_methods:
        print("http method is not valid")
        return False

    match http_method:
        case "GET":
            html = requests.get(url=url, headers=request_header, verify=verify)
        case "POST":
            html = requests.post(url=url, headers=request_header, verify=verify)

    if html.status_code == requests.codes.ok:
        return html
    else:
        return False


# input: html, region
# output: 방과후 강사 공고의 목록으로부터 각 공고의 태그에 대해 가공하여 나온 속성 값의 리스트
def refineHtmlBySourceForList(raw_html, source):
    if not isinstance(raw_html, requests.models.Response):
        return False
    elif source not in sources:
        return False

    match source:
        case "Afterschool":
            pass
        case "Busan" | "Incheon":
            soup = BeautifulSoup(raw_html.text, "html.parser")
            refined_html = soup.select(".nttInfoBtn")
            if refined_html is None:
                return False
            ntt_list = [ntt["data-id"] for ntt in refined_html]
        case "Daegu":
            soup = BeautifulSoup(raw_html.text, "html.parser")
            refined_html = soup.select("#pssrpView")
            if refined_html is None:
                return False
            ntt_list = [ntt["onclick"].split("'")[1] for ntt in refined_html]

    if "ntt_list" not in locals() or ntt_list is None:
        return False
    return ntt_list


# input:
# output:
def getLastPageNumberFromRawHtml(raw_html, source):
    if not isinstance(raw_html, requests.models.Response):
        return False
    elif source not in sources:
        return False

    match source:
        case "Afterschool":
            pass
        case "Busan":
            soup = BeautifulSoup(raw_html.text, "html.parser")
            refined_html = soup.select("a.last")[1]
            if refined_html is None:
                return False
            ntt_page_number = refined_html["onclick"][9:-1]
        case "Daegu" | "Incheon":
            soup = BeautifulSoup(raw_html.text, "html.parser")
            refined_html = soup.select_one("div > a.bbs_arr.pgeR2")
            if refined_html is None:
                return False
            ntt_page_number = refined_html["onclick"][9:-1]

    if "ntt_page_number" not in locals() or ntt_page_number is None:
        return False
    return int(ntt_page_number)


# input: html, region
# output: 늘봄학교 홈페이지: 방과후 강사 공고에 대해 가공한 html, 나머지: 첨부파일에 대한 속성 값
def refineHtmlBySourceForDetail(raw_html, source):
    if not isinstance(raw_html, requests.models.Response):
        return False
    elif source not in sources:
        return False

    match source:
        case "Afterschool":
            soup = BeautifulSoup(raw_html.text, "html.parser")
            refined_html = soup.select_one(".content_wrap")
        case "Busan":
            pass
        case "Daegu":
            pass
        case "Incheon":
            pass

    if "refined_html" not in locals() or refined_html is None:
        return False
    return refined_html


# input:
# output:
def getDatetimeFromString(string_date):
    if not isinstance(string_date, str):
        return False

    string_form = "%Y.%m.%d"
    filter_date = [k for k in re.split("[^0-9]", string_date) if k]
    if len(filter_date) < 3:
        string_form = "%Y%m%d"
        filter_date_string = filter_date[0]
    else:
        filter_date_string = ".".join(filter_date[:3])

    result_date = datetime.strptime(filter_date_string, string_form)

    return result_date


# input: html, region
# output: 각 공고로부터 title, content에 대한 내용을 list로 반환
def getContentFromHtmlBySource(raw_html, source):
    if not isinstance(raw_html, requests.models.Response):
        return False
    elif source not in sources:
        return False

    match source:
        case "Afterschool":
            soup = BeautifulSoup(raw_html.text, "html.parser")
            refined_html = soup.select_one(".request > p")
            if refined_html is None:
                return False
            title = refined_html.get_text().strip()
            refined_html = soup.select_one(".program_detail")
            if refined_html is None:
                return False
            content = refined_html.get_text().strip()
            deadline = "2020-10-10"
        case "Busan":
            soup = BeautifulSoup(raw_html.text, "html.parser")
            refined_html = soup.select_one(".title")
            deadline = soup.select_one(
                ".BD_table > table > tbody > tr:nth-child(4) > td"
            )
            if refined_html is None or deadline is None:
                return False
            title = refined_html.get_text().strip()
            deadline = getDatetimeFromString(deadline.get_text().strip())
            refined_html = soup.select_one(".nttView")
            if refined_html is None:
                return False
            content = refined_html.get_text().strip()
        case "Daegu":
            soup = BeautifulSoup(raw_html.text, "html.parser")
            refined_html = soup.select_one(".BD_table.mgt10")
            deadline = soup.select_one(
                "div > table > tbody > tr:nth-child(4) > td:nth-child(2)"
            )
            if refined_html is None or deadline is None:
                return False
            refined_html = refined_html.find_all("tr")
            deadline = getDatetimeFromString(deadline.get_text().strip().split("~ ")[1])
            if refined_html is None:
                return False
            for item in refined_html:
                th = item.find("th")
                if th.get_text().strip() == "공모제목":
                    title = item.find("td").get_text().strip()
                if th.get_text().strip() == "내용":
                    content = item.find("td").get_text().strip()
        case "Incheon":
            soup = BeautifulSoup(raw_html.text, "html.parser")
            refined_html = soup.select_one(".bbs_ViewA")
            deadline = soup.select_one("div.bbs_ViewA > ul > li:nth-child(3)")
            if refined_html is None or deadline is None:
                return False
            refined_html = refined_html.select_one("h3")
            deadline = getDatetimeFromString(
                deadline.get_text().strip().split("마감일자")[1].strip()
            )
            if refined_html is None:
                return False
            title = refined_html.get_text().strip()
            refined_html = soup.select_one(".bbsV_cont")
            if refined_html is None:
                return False
            content = refined_html.get_text().strip()

    if (
        "title" not in locals()
        or "content" not in locals()
        or "deadline" not in locals()
        or title is None
        or content is None
        or deadline is None
    ):
        return False
    return [title, content, deadline]


# input: html, region
# output: 첨부파일에 대한 속성 ID 값과 파일 이름 리스트
def getFileIdFromHtmlBySource(raw_html, source):
    if not isinstance(raw_html, requests.models.Response):
        return False
    elif source not in sources:
        return False

    match source:
        case "Afterschool":
            pass
        case "Busan":
            soup = BeautifulSoup(raw_html.text, "html.parser")
            refined_html = soup.select_one(".file")
            if refined_html is None:
                return False
            refined_html = refined_html.find_all("li")
            if refined_html is None:
                return False
            file_id = None
            for item in refined_html:
                a = item.find("a")
                if (
                    item.get_text().find("공고") == -1
                    or item.get_text().find("hwpx") != -1
                ):
                    continue
                file_id = a["href"].split("%3d")[-1]
                file_name = item.get_text().split(".hwp")[0].strip()
        case "Daegu":
            soup = BeautifulSoup(raw_html.text, "html.parser")
            refined_html = soup.select(".pdt5.pdb5")
            if refined_html is None:
                return False
            file_id = None
            for item in refined_html:
                a = item.find("a")
                if a.get_text().find("공고") == -1 or a.get_text()[-1] == "x":
                    continue
                file_id = a["href"]
                file_name = a.get_text().split(".hwp")[0]
        case "Incheon":
            soup = BeautifulSoup(raw_html.text, "html.parser")
            refined_html = soup.select_one("#nttViewForm")
            if refined_html is None:
                return False
            refined_html = refined_html.select(".fileName")
            if refined_html is None:
                return False
            file_id = None
            for item in refined_html:
                if (
                    item["title"].find("공고") == -1
                    or item["title"].find("hwpx") != -1
                    or item["title"].find("pdf") != -1
                ):
                    continue
                file_id = item["href"].split("'")[1]
                file_name = item["title"].split(".hwp")[0]

    if "file_id" not in locals() or file_id is None:
        return False
    return [file_id, file_name]


# input: url_file, file_name, file_path
# output: 저장 성공 여부에 따른 Boolean
# side: 공고 홈페이지로부터 공고에 대한 첨부파일 저장
def getDownloadFromUrlToFilePath(url_file, file_name, file_path):
    try:
        os.chdir(file_path)
        request.urlretrieve(url_file, file_name)
        # print("다운로드 완료\n")
        return True
    except HTTPError as e:
        # print("error")
        return False


# input: file_path
# output: file path로부터 읽어온 hwp 파일의 내용, <String>
def openHwpFileFromFilePath(file_path):
    if not os.path.isfile(file_path):
        return False
    loader = HWPLoader(file_path)
    docs = loader.load()

    return docs[0].page_content


# input: html, url_llm, url_http, id
# output: LLM을 통해서 추출한 데이터로 만든 json 파일
def getJsonByContentUsingLLM(content, url_llm, url_http, json_id):
    # print(type(content))
    if not isinstance(content, str):
        return False
    elif url_pattern.match(url_llm) is None:
        return False
    elif url_pattern.match(url_http) is None:
        return False
    elif not isinstance(json_id, int):
        return False

    parameter_llm["prompt"] = content
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
    result = []

    print(
        """
          0. Afterschool
          1. Busan
          2. Daegu
          3. Incheon
          """
    )
    n = int(input())
    if n > 3:
        pass
    now_parameter = parameters[n]
    match n:
        case 0:
            for code in range(1641, 1643):
                # print(code)
                # code = "1642"

                url_http = now_parameter["url_http_list"].format(str(code))

                raw_html = getRawHtmlByUrl(
                    url=url_http,
                    request_header=now_parameter["http_list_header"],
                    http_method=now_parameter["http_list_method"],
                    verify=now_parameter["http_list_verify"],
                )
                if raw_html is False:
                    continue

                content = getContentFromHtmlBySource(
                    raw_html=raw_html, source=now_parameter["source"]
                )

                if content is False:
                    continue

                refined_html = refineHtmlBySourceForDetail(
                    raw_html=raw_html, source=now_parameter["source"]
                )

                if refined_html is False:
                    continue

                json_data = getJsonByContentUsingLLM(
                    content=refined_html.text,
                    url_llm=url_llm,
                    url_http=url_http,
                    json_id=code,
                )

                if json_data is not False:
                    json_data["title"] = content[0]
                    json_data["content"] = content[1]
                    json_data["key_value"] = now_parameter["source"] + str(code)
                    result.append(json_data)

            saveJsonToFilePath(
                json_data_list=result,
                json_path=json_path,
                json_name=now_parameter["file_name"],
            )

            print(result)

        case 1 | 2 | 3:
            url_http_list = now_parameter["url_http_list"].format(1)
            raw_html_list = getRawHtmlByUrl(
                url=url_http_list,
                request_header=now_parameter["http_list_header"],
                http_method=now_parameter["http_list_method"],
                verify=now_parameter["http_list_verify"],
            )
            if raw_html_list is False:
                pass
            last_page_number = getLastPageNumberFromRawHtml(
                raw_html=raw_html_list, source=now_parameter["source"]
            )

            check_end = 0

            for code in range(1, last_page_number + 1):
                if check_end:
                    break
                # print(code)
                # code = "1642"

                url_http_list = now_parameter["url_http_list"].format(code)

                raw_html_list = getRawHtmlByUrl(
                    url=url_http_list,
                    request_header=now_parameter["http_list_header"],
                    http_method=now_parameter["http_list_method"],
                    verify=now_parameter["http_list_verify"],
                )
                if raw_html_list is False:
                    continue

                ntt_list = refineHtmlBySourceForList(
                    raw_html_list, now_parameter["source"]
                )

                if ntt_list is False:
                    continue

                for ntt in ntt_list:
                    url_http_detail = now_parameter["url_http_detail"].format(ntt, code)
                    raw_html_detail = getRawHtmlByUrl(
                        url=url_http_detail,
                        request_header=now_parameter["http_detail_header"],
                        http_method=now_parameter["http_detail_method"],
                        verify=now_parameter["http_detail_verify"],
                    )
                    if raw_html_detail is False:
                        continue

                    ## 날짜 확인하여 활성화 여부 체크

                    content = getContentFromHtmlBySource(
                        raw_html=raw_html_detail, source=now_parameter["source"]
                    )

                    if content is False:
                        continue

                    if content[2] < datetime.now():
                        if datetime.now() - content[2] > timedelta(180):
                            check_end = 1
                            break
                        continue
                    file_info = getFileIdFromHtmlBySource(
                        raw_html_detail, now_parameter["source"]
                    )

                    if file_info is False:
                        continue

                    url_file = now_parameter["url_file"].format(file_info[0])
                    file_name = f"{file_info[1]}.hwp"
                    status = getDownloadFromUrlToFilePath(
                        url_file=url_file, file_name=file_name, file_path=files_path
                    )

                    if not status:
                        continue

                    page_content = openHwpFileFromFilePath(f"{files_path}/{file_name}")
                    if page_content is False:
                        continue

                    page_end = page_content.find("붙임")
                    if page_end == -1:
                        page_end = len(page_content)
                    # print(page_content[: min(1500, page_end)])
                    print(len(page_content[: min(1500, page_end)]))
                    json_data = getJsonByContentUsingLLM(
                        content="<<" + page_content[: min(1500, page_end)] + ">>",
                        url_llm=url_llm,
                        url_http=url_http_detail,
                        json_id=code,
                    )

                    if json_data is not False:
                        json_data["title"] = content[0] + " "
                        json_data["content"] = content[1] + " "
                        json_data["key_value"] = now_parameter["source"] + file_info[0]
                        json_data["file_name"] = file_name
                        json_data["file_path"] = url_file
                        result.append(json_data)

                    # print(json_data)

            saveJsonToFilePath(
                json_data_list=result,
                json_path=json_path,
                json_name=now_parameter["file_name"],
            )

            print(result)

# print()
