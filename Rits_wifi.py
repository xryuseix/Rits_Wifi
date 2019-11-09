from selenium import webdriver
from selenium.webdriver.chrome.options import Options
import yaml


## ------*----- config -----*----- ##
# Webauth URL
url = "https://webauth.ritsumei.ac.jp/fs/customwebauth/login.html"
# RainbowID
account = open("./config/rainbow.yml", "r+")
account = yaml.safe_load(account)

# headlessで実行
option = Options()
#option.add_argument('--headless')
driver = webdriver.Chrome(options=option)

driver.get(url)
driver.find_element_by_name('username').send_keys(account['ID'])
driver.find_element_by_name('password').send_keys(account['PW'])
driver.find_element_by_name('Submit').click()
driver.close()
