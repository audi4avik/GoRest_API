*** Settings ***
Documentation    These are the test cases for post method
Library  RequestsLibrary
Library  Collections
Library  JSONLibrary
Library  String
Library  DataDriver    ./InputData/TestData.xlsx  sheet_name=POST-Operation

Resource    ../InputData/Input Data.robot

Test Template    Verify POST Operation Tests

*** Variables ***
# external csv file

*** Test Cases ***
Validate Test Scenarios For POST Operation
    [Tags]  POST Tests

*** Keywords ***
Verify POST Operation Tests
    [Arguments]   ${token}  ${baseUrl}	${postUrl}	 ${userName}  ${email}    ${gender}    ${status}    ${httpCode}
    # Passing Bearer Token in header
    
    run keyword if    '${email}' == 'example.com'    Create New User With Random Email    ${token}  ${baseUrl}	${postUrl}	 ${userName}  ${email}    ${gender}    ${status}    ${httpCode}
    ...    ELSE     Create User For Other Scenario      ${token}  ${baseUrl}	${postUrl}	 ${userName}  ${email}    ${gender}    ${status}    ${httpCode}

Create New User With Random Email
    [Arguments]    ${token}  ${baseUrl}	${postUrl}	 ${userName}  ${email}    ${gender}    ${status}    ${httpCode}
    ${username} =    generate random string    8    [LOWER]
    ${emailId} =     catenate    SEPARATOR=    ${username}    ${email}

    ${header}    create dictionary     Authorization=${token}   Accept=application/json   Content-Type=application/json
    ${body}      create dictionary     name=${userName}    email=${emailId}     gender=${gender}     status=${status}
    create session    postSession    ${baseUrl}    verify=true
    ${response}    post request    postSession    ${postUrl}   headers=${header}   data=${body}   json=true

    ${statusCode} =  convert to string    ${response.status_code}
    should be equal    ${statusCode}    ${httpCode}

    ${responseBody} =    convert to string    ${response.content}
    should contain    ${responseBody}    "code":201


Create User For Other Scenario
    [Arguments]   ${token}  ${baseUrl}	${postUrl}	 ${userName}  ${email}    ${gender}    ${status}    ${httpCode}
    ${header}    create dictionary     Authorization=${token}   Accept=application/json   Content-Type=application/json
    ${body}      create dictionary     name=${userName}    email=${email}     gender=${gender}   status=${status}
    create session    postSession    ${baseUrl}    verify=true
    ${response}    post request    postSession    ${postUrl}   headers=${header}   data=${body}   json=true

    ${statusCode} =  convert to string    ${response.status_code}
    should be equal    ${statusCode}    ${httpCode}

    ${responseBody} =    convert to string    ${response.content}
    should contain    ${responseBody}    "field":"email","message":"can't be blank"