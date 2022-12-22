*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    os
Library    JSONLibrary

*** Variables ***
${base_url}     http://localhost:8080
${relative_uri}     /app/videogames
${param}    201

*** Test Cases ***
TC1: Returns all the videos games in the DB (GET)
    Create Session    mysession     ${base_url}
    ${response}=    Get Request    mysession    ${relative_uri}

#    Log To Console    ${response.status_code}
#    Log To Console    ${response.headers}

    # Validations
    Should Be Equal As Strings    ${response.status_code}   200
    ${contentType}=   Get From Dictionary    ${response.headers}   Content-Type
    Should Contain    ${contentType}    application/xml;charset=UTF-8
    Should Be Equal As Strings    ${contentType}    application/xml;charset=UTF-8


TC2: Add a new video game to the DB (POST)
    Create Session    mysession     ${base_url}
    ${body}=    Create Dictionary     id=${param}    name=Faysal     releaseDate=2022-12-22T07:35:37.466Z    reviewScore=100     category=Action     rating=*****
    ${contentType}=     Create Dictionary    Content-Type=application/json
    ${response}=    Post Request    mysession    ${relative_uri}    data=${body}    headers=${contentType}

#    Log To Console    ${response.status_code}
#    Log To Console    ${response.content}

    # Validations
    ${status_code}=     Convert To String    ${response.status_code}
    Should Be Equal    ${status_code}   200
    ${contentType}=   Get From Dictionary    ${response.headers}   Content-Type
    Should Be Equal As Strings    ${contentType}    application/xml
    ${status}=    Convert To String    ${response.content}
    Should Contain    ${status}     Record Added Successfully

TC3: Returns the details of a single game by ID (GET)
    Create Session    mysession     ${base_url}
    ${response}=    Get Request    mysession    ${relative_uri}/${param}

#    Log To Console    ${response.status_code}
#    Log To Console    ${response.headers}

    # Validations
    Should Be Equal As Strings    ${response.status_code}   200
    ${contentType}=   Get From Dictionary    ${response.headers}   Content-Type
    Should Contain    ${contentType}    application/xml;charset=UTF-8
    Should Be Equal As Strings    ${contentType}    application/xml;charset=UTF-8

TC4: Update an existing video game in the DB by specifying a new body (PUT)
    Create Session    mysession     ${base_url}
    ${body}=    Create Dictionary     id=${param}    name=Faysal Sarder   releaseDate=2022-12-22T07:35:37.466Z    reviewScore=100     category=Action     rating=5 STAR
    ${contentType}=     Create Dictionary    Content-Type=application/json
    ${response}=    Put Request    mysession    ${relative_uri}/${param}    data=${body}    headers=${contentType}

#    Log To Console    ${response.status_code}
#    Log To Console    ${response.content}

    # Validations
    ${status_code}=     Convert To String    ${response.status_code}
    Should Be Equal    ${status_code}   200
    ${contentType}=   Get From Dictionary    ${response.headers}   Content-Type
    Should Be Equal As Strings    ${contentType}    application/xml
    ${res_body}=    Convert To String    ${response.content}
    Should Contain      ${res_body}    Faysal Sarder

    ${json_object}=    To Json    ${response.content}
    ${user_name}=  Get Value From Json    ${json_object}       $.name
    ${user_Nm}=  Convert To List     ${user_name}         # convert string to List format

    Log To Console     ${user_name}

    # Validation
    Should Be Equal    ${user_name}    ${user_Nm}

TC5: Deletes a video game from the DB by ID (DELETE)
    Create Session    mysession     ${base_url}
    ${response}=    Delete Request    mysession     ${relative_uri}/${param}

#    Log To Console    ${response.status_code}
#    Log To Console    ${response.content}

    # VALIDATIONS
    ${status_code}=     Convert To String    ${response.status_code}
    Should Be Equal    ${status_code}   200               # 200

    ${res_body}=    Convert To String    ${response.content}
    Should Contain      ${res_body}    Record Deleted Successfully
