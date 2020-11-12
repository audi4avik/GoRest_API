*** Settings ***
Documentation    These are the test cases for put method
Library  RequestsLibrary
Library  Collections
Library  ExcelLibrary
Library  JSONLibrary
Library  String

Resource    ../InputData/Input Data.robot


*** Variables ***
# external csv file

*** Test Cases ***
Validate Test Scenarios For Update Operation
    [Tags]  Update Tests
    Get User Data Prior Running Update    ${token}  ${baseUrl}
    Verify Update Operation Tests   ${token}  ${baseUrl}

*** Keywords ***
Get User Data Prior Running Update
    [Arguments]   ${token}  ${baseUrl}
    ${header}    create dictionary     Authorization=${token}    Accept=application/json     Content-Type=application/json

    # Get the user details
    create session    getSession    ${baseUrl}     verify=true
    ${getResponse}    get request    getSession   /public-api/users    headers=${header}    json=true

    log    ${getResponse.content}

    should be equal as integers    ${getResponse.status_code}    200

    ${jsonResponse}    to json    ${getResponse.content}

    FOR    ${index}   IN RANGE    5
           @{id}    get value from json    ${jsonResponse}    $..id
           append to list      ${idList}     ${id}[${index}]
           @{userName}      get value from json    ${jsonResponse}    $..name
           @{userEmail}     get value from json    ${jsonResponse}    $..email
           @{userGender}    get value from json    ${jsonResponse}    $..gender
           @{userStatus}    get value from json    ${jsonResponse}    $..status

           ${userData} =   catenate   SEPARATOR=,  ${userName}[${index}]    ${userEmail}[${index}]    ${userGender}[${index}]    ${userStatus}[${index}]

           log    ${userData}

           # ExcelLibrary - Open, Read, Write & Close
           open excel document    ${excelPath}    useTempDir=True
           write excel column     5    ${idList}    row_offset=1    sheet_name=PUT-Operation
           save excel document    ${excelPath}
           close current excel document
    END


Verify Update Operation Tests
    [Arguments]     ${token}  ${baseUrl}

    # Read data from excel
    open excel document    ${excelPath}    useTempDir=True
    ${updateUrl}   read excel cell    2  4   sheet_name=PUT-Operation
    ${idList}      read excel column    5    row_offset=1    max_num=5    sheet_name=PUT-Operation
    ${userName}    read excel column    6    row_offset=1    max_num=5    sheet_name=PUT-Operation
    ${email}       read excel column    7    row_offset=1    max_num=5    sheet_name=PUT-Operation
    ${gender}      read excel column    8    row_offset=1    max_num=5    sheet_name=PUT-Operation
    ${status}      read excel column    9    row_offset=1    max_num=5    sheet_name=PUT-Operation
    ${listlength}    get length    ${idList}

    FOR    ${i}   IN RANGE    ${listlength}
        ${header}    create dictionary     Authorization=${token}    Accept=application/json     Content-Type=application/json
        ${body}      create dictionary     name=${userName}[${i}]    email=${email}[${i}]      gender=${gender}[${i}]    status=${status}[${i}]
        create session    putSession    ${baseUrl}    verify=true
        ${response}    put request    putSession    ${updateUrl}${idList}[${i}]   headers=${header}   data=${body}   json=true

        ${jsonResponse}    to json    ${response.content}
        @{statusCode}  get value from json   ${jsonResponse}    $..code
        append to list    ${resultList}    @{statusCode}

        # ExcelLibrary - Open, Read, Write & Close
        open excel document    ${excelPath}    useTempDir=False
        write excel column     10    ${resultList}    row_offset=1    sheet_name=PUT-Operation
        save excel document    ${excelPath}
        close current excel document
    END