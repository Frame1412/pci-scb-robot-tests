*** Settings ***
Resource    keyword.robot

*** Test Cases ***
Generate Token and Submit Payment
    [Documentation]    Generate token via API and submit payment.
    [Tags]    positive
    Get Current Date And Catenate
    Register Token WL with API
    Open Browser WhiteLabe
    Input Creadit Card information    4773760188009704    008
    Submit
    
Generate Token and Open New Browser
    [Documentation]    ใช้ Tokenid เดียวนำมาจ่าย 2 ครั้ง
    [Tags]    negative
    Get Current Date And Catenate
    Register Token WL with API
    Open Browser WhiteLabe
    Input Creadit Card information    4773760188009704    008
    Submit
    Open Browser WhiteLabe

Genarate 2 Token with the same channelreftid
    [Documentation]    ทำการสร้าง Tokenid สองครั้งด้วย Channelreftid เดียวกันแต่คนละเลข Tokenid
    [Tags]    negative
    Get Current Date And Catenate
    Register Token WL with API
    Open Browser WhiteLabe
    Input Creadit Card information    4773760188009704    008
    Register Token WL with API

WhiteLabel3D
    [Documentation]    case #3 ในเอกสารพี่เจษ
    [Tags]    issue
    Get Current Date And Catenate
    Register Token WL with API
    Open Browser WhiteLabe
    Input Creadit Card information    4773760188009704    008
    Submit
    Open Browser WhiteLabe