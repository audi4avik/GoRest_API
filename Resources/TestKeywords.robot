*** Settings ***
Documentation    This holds the custom keywords for API tests
Library     RequestsLibrary
Library     Collections
Library     JSONLibrary
Library     String

*** Keywords ***
Post Method Test Steps
    [Arguments]   ${token}  ${baseUrl}	&{postInputs}
    ${username} =    generate random string    6    [LOWER]

    ${header}    create dictionary     Authorization=${token}   Accept=application/json   Content-Type=application/json
    ${body}      create dictionary     name=${postInputs.name}    email=${username}@example.com    gender=${postInputs.gender}  status=${postInputs.status}
    create session    postSession    ${baseUrl}    verify=true
    ${response}    post request    postSession    ${postInputs.url}   headers=${header}   data=${body}   json=true

    ${statusCode} =  convert to string    ${response.status_code}
    should be equal    ${statusCode}    ${postInputs.httpCode}

    ${responseBody} =    convert to string    ${response.content}
    should contain    ${responseBody}    "code":201

    # Convert the raw response to JSON object for assertions/validations
    ${jsonResponse}    to json    ${response.content}

    ${userId}    get value from json    ${jsonResponse}    $..id
    ${userId}    convert to string      ${userId}
    #${userId}    remove string    ${userId}     [   ]
    ${userId}    get substring    ${userId}     1   -1
    set global variable    ${userId}


Get Method Test Steps
    [Arguments]    ${token}    ${baseUrl}    ${userId}    @{getInputs}
    # Create a dictionary for header content
    ${header}    create dictionary     Authorization=${token}    Accept=application/json
    # Create a session with the baseUrl
    create session    getSession    ${baseUrl}    verify=true
    # Run the API operation and save the raw response
    ${response}    get request    getSession    ${getInputs}[0]${userId}    headers=${header}    json=true

    # Convert the raw response to string for assertions/validations
    ${statusCode}   convert to string    ${response.status_code}
    should be equal    ${statusCode}    ${getInputs}[1]


Put Method Test Steps
    [Arguments]  ${token}    ${baseUrl}    ${userId}   &{updateInputs}
    ${header}    create dictionary     Authorization=${token}    Accept=application/json     Content-Type=application/json
    ${body}      create dictionary     id=${userId}     name=${updateInputs.name}    email=${updateInputs.email}     gender=${updateInputs.gender}    status=${updateInputs.status}

    create session    putSession    ${baseUrl}    verify=true
    ${response}    put request    putSession    ${updateInputs.url}${userId}   headers=${header}   data=${body}   json=true

    ${statusCode}   convert to string    ${response.status_code}
    should be equal    ${statusCode}     ${updateInputs.httpCode}


Delete Method Test Steps
    [Arguments]    ${token}  ${baseUrl}	  ${userId}    @{delInputs}
    ${header}    create dictionary     Authorization=${token}
    create session    deleteSession    ${baseUrl}    verify=true
    ${response}    delete request    deleteSession    ${delInputs}[0]${userId}    headers=${header}    json=true

    ${jsonResp}     to json    ${response.content}

    dictionary should contain key    ${jsonResp}     code
    ${responseCode}     get from dictionary    ${jsonResp}     code
    should be equal as strings    ${responseCode}     ${delInputs}[1]
