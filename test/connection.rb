require './lib/scripts/crawling'

ssid = 0
url = 'https://webauth.ritsumei.ac.jp/fs/customwebauth/login.html'
account = {ID:'0123', PW:'qwerty'}


agent = Crawling.new(url)
agent.send(name:'username', value:account[:ID])
agent.send(name:'password', value:account[:PW])
agent.submit(method:'post')
print(agent.html)
