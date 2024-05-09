*** Settings ***
Library           Selenium2Library
Library           RequestsLibrary
Library           DateTime
Library           XML
Library           String
Library           urllib.parse
Suite Setup    set Selenium Speed    0.2

*** Variables ***
${API_Base_Url}                    https://dev0-pci-api.adldigitalservice.com/api-intra/dev/superduper/v1/payment
${API_Authorization}               ZGV2LWNoYW5uZWwtc2RwZzpQQHNzdzByZA==  
${browser}                         gc
${locator_input_cc}                id=cc-number-input
${locator_input_expiredmonth_cc}   id=expiredMonth
${locator_input_expiredYear_cc}    id=expiredYear
${locator_input_cvv_cc}            id=cvv
${locator_btn_submit}              id=cc-submit-btn

*** Keywords ***
Register Token WL with API
    ${headers}=    Create Dictionary    Content-Type    application/json    Authorization    Basic ${API_Authorization}
    ${current_datetime}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${channelRefID}=    Catenate    SEPARATOR=    CRID    ${current_datetime}
    ${option}=    Create Dictionary
    ...    msisdn=FrameSCB125
    ...    mobile=0821997434
    ...    ba=SCB
    ...    amount=1500
    ...    bankAcquireID=014
    ...    lang=en
    ...    currency=thb
    ...    ipAddress=192.168.1.104
    ...    capture=I
    ...    merchantCode=2024000202
    ...    channelRefID=${channelRefID}
    ...    subChannelId=Frametest230229No112
    ...    terminalId=10110
    ...    bankIssuer=SCB
    ...    productType=MERABS
    ...    productCode=A
    ...    rmbFlag=Y
    ...    city=BKK
    ...    postCode=10240
    ...    installmentTerm=3
    ...    computeMethod=3
    ${payload}=    Create Dictionary
    ...    api=registerToken
    ...    commandName=WLRegisterPayment3D
    ...    channelName=Superduper
    ...    skinCode=mpay-th
    ...    callbackType=json
    ...    option=${option}
    ${response}=    Post    ${API_Base_Url}    json=${payload}    headers=${headers}
    Should Be Equal As Strings    ${response.status_code}    200
    Log To Console    \n${response.content}

    ${json_response}=    Evaluate    json.loads($response.content)    json
    ${token_id}=    Set Variable    ${json_response['tokenID']}
    Log To Console    \nToken ID: ${token_id}

    # นำค่า Token id ที่ได้จาก Response มาเปิดบนเว็บ Browser โดยนำเลข Token ที่ได้ไปแทรกในลิงค์ 
    Open Browser    
    ...    https://dev0-pci-api.adldigitalservice.com/web/dev/superduper?token=${token_id}&channelName=SuperDuper
    ...    ${browser}
    Maximize Browser Window

Input Creadit Card
    Wait Until Element Is Visible    ${locator_input_cc}
    # ประกาศตัวแปร Argument ไว้สำหรับกรอกข้อมูล Cardnumber และ รหัส CVV
    [Arguments]    ${Card_number}    ${Card_CVV}
    Input Text    ${locator_input_cc}    ${Card_number}
    
    #เลือก expiredMont โดยระบุแบบเจาะจงข้อมูลตามบัตร
    Wait Until Element Is Visible    ${locator_input_expiredmonth_cc}
    Click Element    ${locator_input_expiredmonth_cc}    
    Wait Until Element Is Visible    xpath://*[@id="expiredMonth"]/option[3]
    Click Element    xpath://*[@id="expiredMonth"]/option[3]
    
    # เลือก expiredYear โดยระบุแบบเจาะจงข้อมูลตามบัตร
    Wait Until Element Is Visible    ${locator_input_expiredYear_cc}
    Click Element    ${locator_input_expiredYear_cc}
    Wait Until Element Is Visible    xpath://*[@id="expiredYear"]/option[6]
    Click Element    xpath://*[@id="expiredYear"]/option[6]

    # ระบุวันหมดอายุของบัตร
    Input Text    ${locator_input_cvv_cc}    ${Card_CVV}

*** Test Cases ***
Generate Token with API
    Register Token WL with API
    Input Creadit Card    4773760188009704    008
    Click Element    ${locator_btn_submit}
