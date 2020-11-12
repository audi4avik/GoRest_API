*** Settings ***
Documentation    This page holds the gloal variables

*** Variables ***
${baseUrl} =  https://gorest.co.in
${token} =    Bearer 76685a8a1ee5fa4194c7f36676735101842712c88d3676284a9ee8a535595fbc

&{postInputs} =    url=/public-api/users    name=Jane Doe     gender=Female    status=Active    httpCode=200
@{getInputs} =     /public-api/users/    200
&{updateInputs} =  url=/public-api/users/   name=John Doe     email=jdoe@ymail.com      gender=Male      status=Inactive    httpCode=200
@{delInputs} =     /public-api/users/    204

${excelPath} =    C:/Users/ibmadmin/PycharmProjects/GoRest API/InputData/TestData.xlsx
${userId} =
@{idList} =
@{emailList} =
@{addressList} =
@{resultList} =
