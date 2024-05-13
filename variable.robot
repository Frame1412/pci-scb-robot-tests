*** Settings ***
Library           SeleniumLibrary
Library           RequestsLibrary
Library           DateTime
# Suite Setup       set Selenium Speed    0.2

*** Variables ***
${API_Base_Url}                    https://dev0-pci-api.adldigitalservice.com/api-intra/dev/superduper/v1/payment
${API_Authorization}               ZGV2LWNoYW5uZWwtc2RwZzpQQHNzdzByZA==  
${browser}                         gc
${locator_input_cc}                id=cc-number-input
${locator_input_expiredmonth_cc}   id=expiredMonth
${locator_input_expiredYear_cc}    id=expiredYear
${locator_input_cvv_cc}            id=cvv
${locator_btn_submit}              id=cc-submit-btn
${locator_pay_to_key}              id=pay-to-key
${locator_Google_check_success}    แสดง Google ใน: