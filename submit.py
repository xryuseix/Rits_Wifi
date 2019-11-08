from crawling import Crawling

url = "https://webauth.ritsumei.ac.jp/fs/customwebauth/login.html"

agent = Crawling(url)
print(len(agent.css('input')))
agent.send(name='username', value='is------')
agent.send(name='password', value='00000000')
