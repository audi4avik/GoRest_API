*** Settings ***
Documentation    These are the test cases for all API operations
Library  RequestsLibrary
Library  Collections
Library  JSONLibrary
Library  String
Resource    ../Resources/Common.robot
Resource    ../Resources/TestKeywords.robot
Resource    ../InputData/Input Data.robot

Test Setup     Common.Begin Test
Test Teardown   Common.End Test

# Run: robot -d results -T -i get testcases\API*robot

*** Test Cases ***
TC01_Validate Create Operation
    [Documentation]    This will create a new resource on the given URI
    [Tags]    post
    TestKeywords.Post Method Test Steps   ${token}    ${baseUrl}	&{postInputs}

TC02_Validate Retrieve operation
    [Documentation]    This will retrieve details of a resource from the given URI
    [Tags]    get
    TestKeywords.Get Method Test Steps    ${token}    ${baseUrl}    ${userId}    @{getInputs}

TC03_Validate Update Operation
    [Documentation]    This will update details of an existing resource
    [Tags]    put
    TestKeywords.Put Method Test Steps    ${token}    ${baseUrl}   ${userId}    &{updateInputs}

TC04_Validate Remove Operation
    [Tags]    del
    [Documentation]    This will delete an existing resource
    TestKeywords.Delete Method Test Steps    ${token}  ${baseUrl}	  ${userId}    @{delInputs}
