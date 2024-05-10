*** Settings ***
Resource    keyword.robot

*** Test Cases ***
Generate Token and Submit Payment
    [Documentation]    Generate token via API and submit payment.
    [Tags]    positive
    Register Token WL with API
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
    [Documentation]    Create a token via API. Open 2 browsers with the same token and enter credit card information.
    [Tags]    negative
    Register Token WL with API
    Input Creadit Card information    4773760188009704    008
    Open Browser    https://dev0-pci-api.adldigitalservice.com/web/dev/superduper?token=${token_id}&channelName=SuperDuper    ${browser}
    ...    options=add_experimental_option("detach", True)
    Input Creadit Card information    4773760188009704    008
    Submit