*** Settings ***
Resource    keyword.robot

*** Test Cases ***
Generate Token and Submit Payment
    [Documentation]    สร้าง Token ด้วย API และทำรายการสำเร็จที่หน้า Whitelable
    [Tags]    positive
    API Get Current Date And Catenate Whitelabel
    API Register Token Whitelabel
    Open Browser Whitelabel
    Input Creadit Card information Whitelabel    4773760188009704    008
    Submit Whitelabel
    
Generate Token and Open New Browser
    [Documentation]    ใช้ Tokenid เดียวนำมาจ่าย 2 ครั้งที่หน้า Whitelable
    [Tags]    negative
    API Get Current Date And Catenate Whitelabel
    API Register Token Whitelabel
    Open Browser Whitelabel
    Input Creadit Card information Whitelabel    4773760188009704    008
    Submit Whitelabel
    Open Browser Whitelabel

Genarate 2 Token with the same channelreftid
    [Documentation]    ใช้เลข Channelreftid เดิมทำการสร้าง Tokenid สองครั้ง จะได้ Tokenid xxx และ Tokenid xxx ที่มาจาก Channelreftid เดียวกัน โดยให้นำเลขทั้งสองมาทำรายการที่หน้า Whitelable
    [Tags]    negative
    API Get Current Date And Catenate Whitelabel
    API Register Token Whitelabel
    Open Browser Whitelabel
    Input Creadit Card information Whitelabel    4773760188009704    008
    API Register Token Whitelabel

API Register3DPayment
    [Documentation]    case #1 ในเอกสารพี่เจษ

API Register3DPayment
    [Documentation]    case #2 ในเอกสารพี่เจษ

WhiteLabel3D
    [Documentation]    case #3 ในเอกสารพี่เจษ
    [Tags]    issue
    API Get Current Date And Catenate Whitelabel
    API Register Token Whitelabel
    Open Browser Whitelabel
    Input Creadit Card information Whitelabel    4773760188009704    008
    Submit Whitelabel
    Open Browser Whitelabel

