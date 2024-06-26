*** Settings ***
Resource    variable.robot

*** Keywords ***
API Get Current Date And Catenate Whitelabel
     # Get Current Date: คำสั่งนี้ใช้ในการเรียกข้อมูลวันที่และเวลาปัจจุบันโดยใช้รูปแบบที่กำหนด ในที่นี้คือ %Y%m%d%H%M%S ซึ่งจะให้ผลลัพธ์เป็นวันที่และเวลาในรูปแบบปี-เดือน-วัน-ชั่วโมง-นาที-วินาที
    ${current_datetime}=    Get Current Date    result_format=%Y%m%d%H%M%S

    # Catenate: คำสั่งนี้ใช้ในการรวมข้อความหลายๆ ส่วนเข้าด้วยกัน โดยมีตัวแยกที่กำหนดไว้ ในที่นี้คือ CRID ซึ่งจะทำให้ข้อความถูกเชื่อมต่อเข้าด้วยกันโดยใส่ CRID ระหว่าง ${current_datetime} กับ ${channelRefID} ซึ่งเมื่อคำสั่งถูกเรียกใช้ ${channelRefID} จะมีค่าเป็น CRID20230507123456 หรือวันที่และเวลาปัจจุบัน
    ${channelRefID}=    Catenate    SEPARATOR=    CRID    ${current_datetime}

    # กำหนดค่าตัวแปร ${channelRefID} ให้เป็นตัวแปร global ซึ่งสามารถถูกเข้าถึงได้จากทุกที่ใน test suite นั้น
    Set Global Variable    ${channelRefID}

API Register Token Whitelabel
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
    ...    channelRefID=${channelRefID}    # robotcode: ignore
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
    
    # กำหนดค่าตัวแปร ${token_id} ให้เป็นตัวแปร global ซึ่งสามารถถูกเข้าถึงได้จากทุกที่ใน test suite นั้น
    Set Global Variable    ${token_id}

Open Browser Whitelabel
    Open Browser    https://dev0-pci-api.adldigitalservice.com/web/dev/superduper?token=${token_id}&channelName=SuperDuper    ${browser}    # robotcode: ignore

Input Creadit Card information Whitelabel
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

Submit Whitelabel
    [Documentation]    คำสั่งสำหรับกดปุ่ม ตกลง ในหน้า White lable
    Click Element                    ${locator_btn_submit}
    Wait Until Page Contains         ${locator_Google_check_success}    15s

Send API Enquiry Whitelabel
    # สร้าง headers โดยกำหนด Content-Type และ Authorization
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Basic ZGV2LWNoYW5uZWwtc2RwZzpQQHNzdzByZA==

    # สร้าง payload ของ request โดยมีค่า api, channelName และ channelRefID
    ${payload}=    Create Dictionary
    ...    api=EnquiryPaymentCreditCard
    ...    channelName=SuperDuper
    ...    channelRefID=${channelRefID}    # robotcode: ignore

    # ส่งคำขอ HTTP POST ไปยัง URL ที่กำหนด โดยใช้ headers และ payload ที่สร้างขึ้น
    ${response}=    Post    dev_superduper_payment    https://dev0-pci-api.adldigitalservice.com/api-intra/dev/superduper/v1/payment    json=${payload}    headers=${headers}

    # แสดงผลลัพธ์ของการตอบกลับ
    Log    Status Code: ${response.status_code}
    Log    Response Body: ${response.text}

    # ตรวจสอบสถานะการตอบกลับ
    Should Be Equal As Strings    ${response.status_code}    200

API Void Whitelabel
    # รอถามวิธีการใช้ API เส้นนี้ก่อน
    # สร้าง headers โดยกำหนด Content-Type และ Authorization
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=Basic ZGV2LWNoYW5uZWwtc2RwZzpQQHNzdzByZA==

    # สร้าง channelRefID และ apiRefID โดยใช้วันที่และเวลาในรูปแบบ %Y%m%d%H%M%S
    ${current_datetime}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${channelRefID}=    Catenate    SEPARATOR=    CRID    ${current_datetime}
    ${apiRefID}=    Set Variable    ${channelRefID}  # คุณสามารถปรับเปลี่ยนค่าตามที่ต้องการได้

    # สร้าง payload ของ request โดยมีค่า amount, api, apiRefID, channelName, channelRefID, commandName และ data
    ${payload}=    Create Dictionary
    ...    amount=5000
    ...    api=RefundPaymentCreditAmount
    ...    apiRefID=${apiRefID}
    ...    channelName=SuperDuper
    ...    channelRefID=${channelRefID}
    ...    commandName=VoidCreditAmount
    ...    data={'refundRefID': 'VOID${channelRefID}'}

    # ส่งคำขอ HTTP POST ไปยัง URL ที่กำหนด โดยใช้ headers และ payload ที่สร้างขึ้น
    ${response}=    Post    dev_superduper_payment    https://dev0-pci-api.adldigitalservice.com/api-intra/dev/superduper/v1/payment    json=${payload}    headers=${headers}

    # แสดงผลลัพธ์ของการตอบกลับ
    Log    Status Code: ${response.status_code}
    Log    Response Body: ${response.text}

    # ตรวจสอบสถานะการตอบกลับ
    Should Be Equal As Strings    ${response.status_code}    200

