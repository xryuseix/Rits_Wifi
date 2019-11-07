from selenium import webdriver
from selenium.webdriver.chrome.options import Options

# path = './pass.conf'
path = '/Users/ryuse/Programming/Python/scraping/pass.txt'
password = ''
id = 'is0493kk'                     # userid

with open(path) as f:               # read password
    s = f.read()
    password = s

option = Options()                  # prepare opetions
option.add_argument('--headless')   # add headless-setting
driver = webdriver.Chrome(options=option)

driver.get("https://webauth.ritsumei.ac.jp/fs/customwebauth/login.html")
driver.find_element_by_name('username').send_keys(id)
driver.find_element_by_name('password').send_keys(password)
driver.find_element_by_name('Submit').click()
driver.close()
