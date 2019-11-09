from crawling import Crawling
import yaml
import os

## ------*----- config -----*----- ##
# Webauth URL
url = "https://webauth.ritsumei.ac.jp/fs/customwebauth/login.html"
# RainbowID
if os.path.exists("./config/rainbow.yml"):
    print('hello')
    account = open("./config/rainbow.yml", "r+")
    account = yaml.load(account)
else:
    print('file not exist')
    os.makedirs('./config/', exist_ok=True)
    with open('./config/rainbow.yml', 'w') as f:
        yaml.dump({
            "ID": input('your rainbow ID:'),
            "PW": input('your rainbow PW:')
        }, f, default_flow_style=False)


exit()

agent = Crawling(url)
# フォーム送信
agent.send(name='username', value=account['ID'])
agent.send(name='password', value=account['PW'])
agent.submit(method='post')
print(agent.html)
