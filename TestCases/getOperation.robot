*** Settings ***
Documentation    These are the test cases for get method
Library  RequestsLibrary
Library  Collections
Library  ExcelLibrary
Library  JSONLibrary
Library  String
Library  DataDriver    ../InputData/TestData.xlsx  sheet_name=GET-Operation

Resource    ../InputData/Input Data.robot

Test Template    Verify Get Operation Tests

*** Variables ***
# external csv file

*** Test Cases ***
Validate Test Scenarios For GET Operation
    [Tags]  GET Tests

*** Keywords ***
Verify Get Operation Tests
    [Arguments]   ${token}  ${baseUrl}	${getUrl}	${httpCode}    ${email}
    # Passing Bearer Token in header - OAuth 2
    ${header}    create dictionary     Authorization=${token}    Accept=application/json
    create session    getSession    ${baseUrl}    verify=true
    ${response}    get request    getSession    ${getUrl}   headers=${header}    json=true

    ${statusCode} =  convert to string    ${response.status_code}
    should be equal    ${statusCode}    ${httpCode}

#    ${responseBody} =    convert to string    ${response.content}
#    should contain    ${responseBody}    OK. Everything worked as expected.

    ${jsonResponse}    to json    ${response.content}

    #get value from json
    @{userEmail}    get value from json    ${jsonResponse}    $..email
    append to list      ${emailList}     @{userEmail}[0]

    # ExcelLibrary - Open, Read, Write & Close
    open excel document    ${excelPath}    useTempDir=True
    write excel column     6    ${emailList}    row_offset=1    sheet_name=GET-Operation
    save excel document    ${excelPath}
    close current excel document
