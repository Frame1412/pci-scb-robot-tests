*** Settings ***
Resource    keyword.robot

*** Test Cases ***
Generate Token and Submit Payment
    [Documentation]    Generate token via API and submit payment.
    [Tags]    positive
    Get Current Date And Catenate
    Register Token WL with API
    Open Browser WhiteLabe
    Input Creadit Card information   4773760188009704    008
    Submit

# Generate Token and Click New Tab
#     [Documentation]    Generate token via API and submit payment.
#     [Tags]    Negative
#     Register Token WL with API
#     Input Creadit Card information    4773760188009704    008
#     Execute JavaScript    window.open('https://dev0-pci-api.adldigitalservice.com/web/dev/superduper?token=${token_id}&channelName=SuperDuper','_blank')
#     Wait Until Element Is Visible    ${locator_input_cc}
#     Select    ${locator_pay_to_key}   จ่ายเงินให้กับ
#     Input Creadit Card information    4773760188009704    008
    
Generate Token and Open New Browser
    [Documentation]    ใช้ Tokenid เดียวนำมาจ่าย 2 ครั้ง
    [Tags]    negative
    Get Current Date And Catenate
    Register Token WL with API
    Open Browser WhiteLabe
    Input Creadit Card information    4773760188009704    008
    Submit
    Open Browser WhiteLabe

# Genarate Token
#     [Documentation]    genarate a token 
#     [Tags]    negative
#     Register 2 Token WL with API

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
    Get Current Date And Catenate
    Register Token WL with API
    Open Browser WhiteLabe
    Input Creadit Card information    4773760188009704    008
    Submit
    Open Browser WhiteLabe