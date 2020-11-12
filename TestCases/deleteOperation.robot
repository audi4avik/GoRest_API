*** Settings ***
Documentation    These are the test cases for delete method
Library  RequestsLibrary
Library  Collections
Library  ExcelLibrary
Library  JSONLibrary
Library  String
Library  DataDriver    ../InputData/TestData.xlsx  sheet_name=DELETE-Operation

Resource    ../InputData/Input Data.robot

Test Template    Verify Delete Operation Tests

*** Variables ***
# external csv file

*** Test Cases ***
Validate Test Scenarios For Delete Operation
    [Tags]  DELETE Tests

*** Keywords ***
Verify Delete Operation Tests
    [Arguments]   ${token}  ${baseUrl}	${deleteUrl}    ${id}	${httpCode}    ${reasonCode}

    run keyword if    '${id}'== ''    Run Without User Id   ${token}  ${baseUrl}	${deleteUrl}    ${id}	${httpCode}    ${reasonCode}
    ...    ELSE    Run With User Id     ${token}  ${baseUrl}	${deleteUrl}    ${id}	${httpCode}    ${reasonCode}

Run Without User Id
    [Arguments]    ${token}  ${baseUrl}	${deleteUrl}    ${id}	${httpCode}    ${reasonCode}
    # Passing Bearer Token in header - OAuth 2
    ${header}    create dictionary     Authorization=${token}
    create session    deleteSession    ${baseUrl}    verify=true
    ${response}    delete request    deleteSession    ${deleteUrl}${id}   headers=${header}    json=true

    ${responseBody}    convert to string    ${response.content}

    should contain    ${responseBody}    ${reasonCode}


Run With User Id
    [Arguments]    ${token}  ${baseUrl}	${deleteUrl}    ${id}	${httpCode}    ${reasonCode}
     # Passing Bearer Token in header - OAuth 2
    ${header}    create dictionary     Authorization=${token}
    create session    deleteSession    ${baseUrl}    verify=true
    ${response}    delete request    deleteSession    ${deleteUrl}${id}   headers=${header}    json=true

    ${jsonResponse}    to json    ${response.content}


    # Get value from json and validate

    ${messageText}    get value from json    ${jsonResponse}   $..message
    ${messageStr}    convert to string    ${messageText}
    should contain      ${messageStr}    ${reasonCode}