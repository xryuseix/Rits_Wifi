from crawling import Crawling
import yaml

## ------*----- config -----*----- ##
# Webauth URL
url = "https://webauth.ritsumei.ac.jp/fs/customwebauth/login.html"
# RainbowID
account = open("./config/rainbow.yml", "r+")
account = yaml.load(account)

agent = Crawling(url)
# フォーム送信
agent.send(name='username', value=account['ID'])
agent.send(name='password', value=account['PW'])
agent.submit(method='post')
print(agent.html)
