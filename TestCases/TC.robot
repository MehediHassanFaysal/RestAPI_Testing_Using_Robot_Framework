*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    os
Library    JSONLibrary

*** Variables ***
${base_url}     https://fakerestapi.azurewebsites.net
${relative_uli}     /api/v1/Books
${param}    2

*** Test Cases ***
TC1: Return the list of all books along with description (GET)
    Create Session    mysession     ${base_url}
    ${response}=    Get Request    mysession    ${relative_uli}

    Log To Console    ${response.status_code}

    #Validations
    Should Be Equal As Strings    ${response.status_code}       200
    ${contentTypeValue}=     Get From Dictionary    ${response.headers}     Content-Type
    Should Be Equal As Strings    ${contentTypeValue}       application/json; charset=utf-8; v=1.0

TC2: Add a new book resource (POST)
    Create Session    mysession     ${base_url}
    ${body}=    Create Dictionary    id=200    title=Robot Framework    description=RestAPI Automation in python usibg robot framework      pageCount=50    excerpt=string    publishDate=2022-12-16T05:43:22.937Z
    ${header}=  Create Dictionary    Content-Type=application/json
    ${response}=    Post Request    mysession   ${relative_uli}       data=${body}       headers=${header}

    Log To Console    ${response.status_code}
    Log To Console    ${response.headers}
    Log To Console    ${response.content}

    # Validations
    ${status_code}=     Convert To String    ${response.status_code}
    Should Be Equal    ${status_code}       200

    ${server}=      Get From Dictionary    ${response.headers}      Server
    Should Be Equal As Strings    ${server}     Kestrel

    ${apiVersion}=      Get From Dictionary    ${response.headers}      api-supported-versions
    Should Be Equal As Strings    ${apiVersion}     1.0

    ${title}=   Convert To String    ${response.content}
    Should Contain    ${title}     Robot Framework
    Should Not Contain    ${title}     Robot Framework in py

TC3: Returns a specific book along with details (GET)
    Create Session    mysession     ${base_url}
    ${response}=    Get Request    mysession    ${relative_uli}/${param}

    Log To Console    ${response.status_code}
    Log To Console    ${response.content}


    #Validations
    Should Be Equal As Strings    ${response.status_code}       200

    ${contentTypeValue}=     Get From Dictionary    ${response.headers}     Content-Type
    Should Be Equal As Strings    ${contentTypeValue}       application/json; charset=utf-8; v=1.0

    ${title}=   Convert To String    ${response.content}
    Should Contain Any    ${title}  Book 2     2

TC4: Update a particular book info (PUT)
    Create Session    mysession     ${base_url}
    ${body}=    Create Dictionary    id=2    title=Robot Framework    description=RestAPI Automation in python usibg robot framework      pageCount=50    excerpt=string    publishDate=2022-12-16T05:43:22.937Z
    ${header}=  Create Dictionary    Content-Type=application/json
    ${response}=    Put Request    mysession   ${relative_uli}/${param}       data=${body}       headers=${header}

    Log To Console    ${response.status_code}
    Log To Console    ${response.headers}
    Log To Console    ${response.content}

    # Validations
    ${status_code}=     Convert To String    ${response.status_code}
    Should Be Equal    ${status_code}       200

    ${transferEncoding}=      Get From Dictionary    ${response.headers}      Transfer-Encoding
    Should Be Equal As Strings    ${transferEncoding}     chunked

    ${apiVersion}=      Get From Dictionary    ${response.headers}      api-supported-versions
    Should Be Equal As Strings    ${apiVersion}     1.0

    ${title}=   Convert To String    ${response.content}
    Should Contain    ${title}     RestAPI Automation in python usibg robot framework
    Should Not Contain    ${title}     Robot Framework in py

TC5: Delete all info of a specific book (DELETE)
    Create Session    mysession     ${base_url}
    ${response}=    Delete Request    mysession    ${relative_uli}/206

    Log To Console    ${response.status_code}

    # Validation
    Should Be Equal As Strings    ${response.status_code}   200






