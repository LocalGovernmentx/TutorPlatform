import pymysql
import json
import os
from dotenv import load_dotenv
import pymysql.cursors

load_dotenv(verbose=True)

DB_HOST = os.getenv("DB_HOST")
DB_PORT = int(os.getenv("DB_PORT"))
DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")
SCHEMA_NAME = os.getenv("SCHEMA_NAME")

json_path = "./jsondata/{}.json"

sources = ["Afterschool", "Busan", "Daegu", "Incheon"]
sources_name = {
    "Afterschool": "늘봄학교",
    "Busan": "부산",
    "Daegu": "대구",
    "Incheon": "인천",
}

select_sql_temp = "SELECT * FROM after_school_notice"
insert_sql_temp = "INSERT INTO after_school_notice (title, content, region, key_value, file_content, file_name, file_path) VALUES "


# input: dict or list or object (맨 처음 input: dict list)
# output: list - list 내의 dict에서 NULL 또는 empty string 제거, dict - dict에서 NULL 또는 empty string 제거, 그 이외 - object 그대로
def removeNullAndEmpty(data):
    if isinstance(data, dict):
        return {
            k: removeNullAndEmpty(v) for k, v in data.items() if v not in [None, ""]
        }
    elif isinstance(data, list):
        return [removeNullAndEmpty(item) for item in data if item not in [None, ""]]
    else:
        return data


# input: MySQL에 접속하기 위한 파라미터(DB의 host, port, user, password, schema name)
# output: MySQL과 연결된 connection 객체
def connectMySQLUsingParameter(host, port, user, password, schema_name):
    conn = pymysql.connect(
        host=host,
        port=port,
        user=user,
        password=password,
        db=schema_name,
        charset="utf8",
    )

    if conn is None:
        raise Exception("connectMySQLUsingParameter: connection failed")

    return conn


# input: json file의 파일명 (source: 확장자 제외)
# output: json 데이터 (list 형식)
def openJsonFromFilePath(source):
    if not os.path.isfile(json_path.format(source)):
        raise Exception("file not found")
    with open(json_path.format(source), "r", encoding="utf-8") as file:
        data = json.load(file)
        if not isinstance(data, list):
            raise Exception("openJsonFromFilePath: data is not list type")

        return data
    raise Exception("openJsonFromFilePath: can't open file")


# input: file path로부터 얻은 json 데이터
# output: json 데이터를 하나의 string으로 바꿔서 반환
def convertJsonToString(json_data):
    if not isinstance(json_data, dict):
        raise Exception("convertJsonToString: json data is not dict type")
    formatted_content = ", \n".join(
        f"{key}: {value}" for key, value in json_data.items()
    )

    return formatted_content


# input: Tuple로 바꿀 파라미터 값들
# output: 파라미터 값으로 이루어진 Tuple
def getTupleValueForSQLFromJson(source, json_data):
    if source not in sources:
        raise Exception("getTupleValueForSQLFromJson: source is not in region sources")
    if not isinstance(json_data, dict):
        raise Exception("getTupleValueForSQLFromJson: json data is not dict type")

    title, content, key_value = (
        json_data["title"],
        json_data["content"],
        json_data["key_value"],
    )

    if title is None or content is None or key_value is None:
        raise Exception(
            "getTupleValueForSQLFromJson: title, content or key value is not defined"
        )

    del json_data["title"]
    del json_data["content"]
    del json_data["key_value"]

    file_name = None
    file_path = None

    if "file_name" in json_data and "file_path" in json_data:
        file_name = json_data["file_name"]
        file_path = json_data["file_path"]

        del json_data["file_name"]
        del json_data["file_path"]

    formatted_content = convertJsonToString(json_data=json_data)

    tuple_data = (
        title,
        content,
        sources_name[source],
        key_value,
        formatted_content,
        file_name,
        file_path,
    )
    return tuple_data


# input: INSERT할 SQL의 Tuple 개수
# output: tuple 개수에 맞게 변환한 INSERT SQL
def convertSQLFormatFromTupleLength(sql, value_length):
    if not isinstance(sql, str):
        raise Exception("convertSQLFormatFromTupleLength: SQL is not string type")
    if not isinstance(value_length, int):
        raise Exception("convertSQLFormatFromTupleLength: length is not int type")
    sql = sql + ", ".join(["(%s, %s, %s, %s, %s, %s, %s)"] * value_length)

    return sql


# input:
# output:
def executeSQLForDeleteValues(cursor):
    if not isinstance(cursor, pymysql.cursors.Cursor):
        raise Exception(
            "executeSQLForDelete: cursor is not cursor type or cursor is not connected"
        )
    sql = "DELETE FROM after_school_notice"
    cnt = cursor.execute(sql)

    return cnt


# input: MySQL과 연결된 cursor, 기본 SQL문, INSERT에 사용할 value list
# output: Insert된 value 개수
def executeSQLForInsertValues(cursor, sql, value_list):
    if not isinstance(cursor, pymysql.cursors.Cursor):
        raise Exception(
            "executeSQLForInsertValues: cursor is not cursor type or cursor is not connected"
        )
    if not isinstance(sql, str) or len(sql) < 6 or sql[:6].lower() != "insert":
        raise Exception(
            "executeSQLForInsertValues: sql is not string type or sql is not insert statement"
        )
    if not isinstance(value_list, list):
        raise Exception("executeSQLForInsertValues: value list is not list type")
    cnt = cursor.execute(sql, [item for sublist in value_list for item in sublist])

    return cnt


# input: MySQL과 연결된 cursor, 기본 SQL문, SELECT에 사용할 value list (없을 경우 NULL)
# output: select 결과로 나온 header와 rows
def executeSQLForSelect(cursor, sql, value_list=None):
    if not isinstance(cursor, pymysql.cursors.Cursor):
        raise Exception(
            "executeSQLForSelect: cursor is not cursor type or cursor is not connected"
        )
    if not isinstance(sql, str) or sql[:6].lower == "select":
        raise Exception(
            "executeSQLForSelect: sql is not string type or sql is not select statement"
        )
    if not isinstance(value_list, list) and value_list is not None:
        raise Exception("executeSQLForSelect: value list is not list type or None")
    cursor.execute(sql)

    return cursor.fetchall()


# input: DB와 연결된 connect 객체
# output: X
# side: commit한 내용을 DB에 저장하고 DB와 연결된 connect 객체 종료
def disconnectDB(conn):
    conn.commit()  # -> Transaction 처리해야 할 경우 따로 처리
    conn.close()


if __name__ == "__main__":
    try:
        conn = connectMySQLUsingParameter(
            DB_HOST, DB_PORT, DB_USER, DB_PASSWORD, SCHEMA_NAME
        )
        try:
            with conn.cursor() as cursor:
                # drop
                cnt = executeSQLForDeleteValues(cursor=cursor)
                print(cnt)
                for source in sources:
                    insert_data = []
                    data = openJsonFromFilePath(source=source)
                    if len(data) == 0:
                        continue

                    refined_data = removeNullAndEmpty(data)

                    for item in refined_data:
                        # print(len(content))
                        insert_data.append(
                            getTupleValueForSQLFromJson(source=source, json_data=item)
                        )

                    insert_sql = convertSQLFormatFromTupleLength(
                        insert_sql_temp, len(insert_data)
                    )

                    cnt = executeSQLForInsertValues(
                        cursor=cursor, sql=insert_sql, value_list=insert_data
                    )
                    print(cnt)

                rows = executeSQLForSelect(cursor=cursor, sql=select_sql_temp)
                for row in rows:
                    # print(row)
                    pass

                # column_names = [desc[0] for desc in cursor.description]
                # print(column_names)

        except Exception as e:
            print(e)
        finally:
            disconnectDB(conn)
    except Exception as e:
        print(e)


"""
try:
    conn = connectMySQLUsingParameter(DB_HOST, DB_USER, DB_PASSWORD, SCHEMA_NAME)

    with conn.cursor() as cursor:
        for source in sources:
            with open(json_path.format(source), "r", encoding="utf-8") as file:
                final_data = []
                data = json.load(file)
                if not isinstance(data, list):
                    raise Exception("data is not list type")
                refined_data = removeNullAndEmpty(data)

                for item in refined_data:
                    title, content, key_value = (
                        item["title"],
                        item["content"],
                        item["key_value"],
                    )

                    if title is None or content is None or key_value is None:
                        raise Exception("title, content or key value is not defined")

                    del item["title"]
                    del item["content"]
                    del item["key_value"]

                    file_name = None
                    file_path = None

                    if "file_name" in item and "file_path" in item:
                        file_name = item["file_name"]
                        file_path = item["file_path"]

                        del item["file_name"]
                        del item["file_path"]

                    formatted_content = ", \n".join(
                        f"{key}: {value}" for key, value in item.items()
                    )
                    # print(len(content))
                    final_data.append(
                        (
                            title,
                            content,
                            source,
                            key_value,
                            formatted_content,
                            file_name,
                            file_path,
                        )
                    )

                sql = (
                    "INSERT INTO after_school_notice (title, content, region, key_value, file_content, file_name, file_path) VALUES "
                    + ", ".join(["(%s, %s, %s, %s, %s, %s, %s)"] * len(final_data))
                )

                cursor.execute(
                    sql, [item for sublist in final_data for item in sublist]
                )

        cursor.execute("SELECT * FROM after_school_notice")

        column_names = [desc[0] for desc in cursor.description]
        # print(column_names)

        rows = cursor.fetchall()
        for row in rows:
            # print(row)
            pass

except Exception as e:
    print(e)

finally:
    conn.commit()
    conn.close()
"""
