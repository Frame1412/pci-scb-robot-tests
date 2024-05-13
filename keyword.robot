*** Settings ***
Resource    variable.robot

*** Keywords ***
Get Current Date And Catenate
     # Get Current Date: คำสั่งนี้ใช้ในการเรียกข้อมูลวันที่และเวลาปัจจุบันโดยใช้รูปแบบที่กำหนด ในที่นี้คือ %Y%m%d%H%M%S ซึ่งจะให้ผลลัพธ์เป็นวันที่และเวลาในรูปแบบปี-เดือน-วัน-ชั่วโมง-นาที-วินาที
    ${current_datetime}=    Get Current Date    result_format=%Y%m%d%H%M%S
    # Catenate: คำสั่งนี้ใช้ในการรวมข้อความหลายๆ ส่วนเข้าด้วยกัน โดยมีตัวแยกที่กำหนดไว้ ในที่นี้คือ CRID ซึ่งจะทำให้ข้อความถูกเชื่อมต่อเข้าด้วยกันโดยใส่ CRID ระหว่าง ${current_datetime} กับ ${channelRefID} ซึ่งเมื่อคำสั่งถูกเรียกใช้ ${channelRefID} จะมีค่าเป็น CRID20230507123456 หรือวันที่และเวลาปัจจุบัน
    ${channelRefID}=    Catenate    SEPARATOR=    CRID    ${current_datetime}
    Set Global Variable    ${channelRefID}

Register Token WL with API
    # [Arguments]    ${channelRefID}
    [Documentation]    Register Token via API and open the web page with the token ID.
    # Create Dictionary เพื่อสร้างพจนานุกรมที่เก็บค่าหลายๆ คีย์-ค่า (key-value pairs) 
    # Content-Type: กำหนดค่า Content-Type ให้เป็น application/json เพื่อระบุว่าข้อมูลที่จะส่งใน request เป็นประเภท JSON format.
    # Authorization: กำหนดค่า Authorization โดยใช้ Basic Authentication และใช้ค่า ${API_Authorization} ที่ถูกกำหนดในตัวแปรไว้ล่วงหน้า เพื่อให้สามารถใช้งาน API ได้ตามที่กำหนดไว้ในรายการคำขอ (request) 
    ${headers}=    Create Dictionary    Content-Type    application/json    Authorization    Basic ${API_Authorization}
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

    # ใช้คำสั่ง Evaluate เพื่อดึงข้อมูล JSON จาก response ที่ได้จาก API โดยใช้ฟังก์ชัน json.loads() เพื่อแปลงข้อมูล JSON ให้อยู่ในรูปแบบของ Python dictionary จากนั้น เรากำหนดค่าให้กับตัวแปร ${json_response}
    ${json_response}=    Evaluate    json.loads($response.content)    json

    # Set Variable เพื่อกำหนดค่าของตัวแปร ${token_id} โดยดึงค่าของ key 'tokenID' จาก ${json_response} ซึ่งเป็นข้อมูล token ID ที่ได้จาก response
    ${token_id}=    Set Variable    ${json_response['tokenID']}
    # แสดงค่า Token ID ที่ได้
    Log To Console    \nToken ID: ${token_id}
    Set Global Variable    ${token_id}
    # RETURN    ${token_id}

    # นำค่า Token id ที่ได้จาก Response มาเปิดบนเว็บ Browser โดยนำเลข Token ที่ได้ไปแทรกในลิงค์ 
    # Open Browser    
    # ...    https://dev0-pci-api.adldigitalservice.com/web/dev/superduper?token=${token_id}&channelName=SuperDuper
    # ...    ${browser}
    # ...    options=add_experimental_option("detach", True)
    # Maximize Browser Window

Open Browser WhiteLabe
    Open Browser    https://dev0-pci-api.adldigitalservice.com/web/dev/superduper?token=${token_id}&channelName=SuperDuper    ${browser}

Register 2 Token WL with API
    [Documentation]    Register Token via API and open the web page with the token ID.
    # Create Dictionary เพื่อสร้างพจนานุกรมที่เก็บค่าหลายๆ คีย์-ค่า (key-value pairs) 
    # Content-Type: กำหนดค่า Content-Type ให้เป็น application/json เพื่อระบุว่าข้อมูลที่จะส่งใน request เป็นประเภท JSON format.
    # Authorization: กำหนดค่า Authorization โดยใช้ Basic Authentication และใช้ค่า ${API_Authorization} ที่ถูกกำหนดในตัวแปรไว้ล่วงหน้า เพื่อให้สามารถใช้งาน API ได้ตามที่กำหนดไว้ในรายการคำขอ (request) 
    ${headers}=    Create Dictionary    Content-Type    application/json    Authorization    Basic ${API_Authorization}
    # Get Current Date: คำสั่งนี้ใช้ในการเรียกข้อมูลวันที่และเวลาปัจจุบันโดยใช้รูปแบบที่กำหนด ในที่นี้คือ %Y%m%d%H%M%S ซึ่งจะให้ผลลัพธ์เป็นวันที่และเวลาในรูปแบบปี-เดือน-วัน-ชั่วโมง-นาที-วินาที
    ${current_datetime}=    Get Current Date    result_format=%Y%m%d%H%M%S
    # Catenate: คำสั่งนี้ใช้ในการรวมข้อความหลายๆ ส่วนเข้าด้วยกัน โดยมีตัวแยกที่กำหนดไว้ ในที่นี้คือ CRID ซึ่งจะทำให้ข้อความถูกเชื่อมต่อเข้าด้วยกันโดยใส่ CRID ระหว่าง ${current_datetime} กับ ${channelRefID} ซึ่งเมื่อคำสั่งถูกเรียกใช้ ${channelRefID} จะมีค่าเป็น CRID20230507123456 หรือวันที่และเวลาปัจจุบัน
    ${channelRefID}=    Catenate    SEPARATOR=    CRID    ${current_datetime}
    
    # [Arguments]    ${channelRefID}
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
    # ใช้คำสั่ง Evaluate เพื่อดึงข้อมูล JSON จาก response ที่ได้จาก API โดยใช้ฟังก์ชัน json.loads() เพื่อแปลงข้อมูล JSON ให้อยู่ในรูปแบบของ Python dictionary จากนั้น เรากำหนดค่าให้กับตัวแปร ${json_response}
    ${json_response}=    Evaluate    json.loads($response.content)    json
    # Set Variable เพื่อกำหนดค่าของตัวแปร ${token_id} โดยดึงค่าของ key 'tokenID' จาก ${json_response} ซึ่งเป็นข้อมูล token ID ที่ได้จาก response
    ${token_id}=    Set Variable    ${json_response['tokenID']}
    # แสดงค่า Token ID ที่ได้
    Log To Console    \nToken ID: ${token_id}
    Set Global Variable    ${token_id}


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

    # ใช้คำสั่ง Evaluate เพื่อดึงข้อมูล JSON จาก response ที่ได้จาก API โดยใช้ฟังก์ชัน json.loads() เพื่อแปลงข้อมูล JSON ให้อยู่ในรูปแบบของ Python dictionary จากนั้น เรากำหนดค่าให้กับตัวแปร ${json_response}
    ${json_response}=    Evaluate    json.loads($response.content)    json

    # Set Variable เพื่อกำหนดค่าของตัวแปร ${token_id} โดยดึงค่าของ key 'tokenID' จาก ${json_response} ซึ่งเป็นข้อมูล token ID ที่ได้จาก response
    ${token_id2}=    Set Variable    ${json_response['tokenID']}
    # แสดงค่า Token ID ที่ได้
    Log To Console    \nToken ID: ${token_id2}
    Set Global Variable    ${token_id2}

    # นำค่า Token id ที่ได้จาก Response มาเปิดบนเว็บ Browser โดยนำเลข Token ที่ได้ไปแทรกในลิงค์ 
    Open Browser    
    ...    https://dev0-pci-api.adldigitalservice.com/web/dev/superduper?token=${token_id}&channelName=SuperDuper
    ...    ${browser}
    ...    options=add_experimental_option("detach", True)
    Maximize Browser Window
    

    Open Browser    
    ...    https://dev0-pci-api.adldigitalservice.com/web/dev/superduper?token=${token_id2}&channelName=SuperDuper
    ...    ${browser}
    ...    options=add_experimental_option("detach", True)
    Maximize Browser Window

Input Creadit Card information
    [Documentation]    Input credit card information and submit.
    Wait Until Element Is Visible    ${locator_input_cc}
    # ประกาศตัวแปร Argument ไว้สำหรับกรอกข้อมูล Cardnumber และ รหัส CVV
    [Arguments]                      ${Card_number}    ${Card_CVV}
    Input Text                       ${locator_input_cc}    ${Card_number}
    
    #เลือก expiredMont โดยระบุแบบเจาะจงข้อมูลตามบัตร
    Wait Until Element Is Visible    ${locator_input_expiredmonth_cc}
    Click Element                    ${locator_input_expiredmonth_cc}    
    Wait Until Element Is Visible    xpath://*[@id="expiredMonth"]/option[3]
    Click Element                    xpath://*[@id="expiredMonth"]/option[3]
    
    # เลือก expiredYear โดยระบุแบบเจาะจงข้อมูลตามบัตร
    Wait Until Element Is Visible    ${locator_input_expiredYear_cc}
    Click Element                    ${locator_input_expiredYear_cc}
    Wait Until Element Is Visible    xpath://*[@id="expiredYear"]/option[6]
    Click Element                    xpath://*[@id="expiredYear"]/option[6]

    # ระบุวันหมดอายุของบัตร
    Input Text                       ${locator_input_cvv_cc}    ${Card_CVV}

Submit
    [Documentation]    คำสั่งสำหรับกดปุ่ม ตกลง ในหน้า White lable
    Click Element                    ${locator_btn_submit}
    Wait Until Page Contains         ${locator_Google_check_success}    15s