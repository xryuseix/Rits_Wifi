require './lib/crawling.rb'
require 'yaml'

def check_ssid
  ret = `/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport -I | /usr/bin/grep -ie '^\s*ssid'  | cut -d ":" -f 2`
  ret.strip!
  return ret
end

def connect(ssid, url, userdata)
  p 'ここはconnect関数'
end


## -----*----- config -----*----- ##
# Webauth URL
url = "https://webauth.ritsumei.ac.jp/fs/customwebauth/login.html"
# RainbowID
file = './config/rainbow.yml'
# configが存在しない場合 => 新規作成
unless File.exist?(file)
  rainbow = {}
  print "Input your ID: "; rainbow[:ID] = gets.chop
  print "Input your PW: "; rainbow[:PW] = gets.chop
  Dir.mkdir('config')
  YAML.dump(rainbow, File.open('./config/rainbow.yml', 'w'))
end

ssid = check_ssid
userdata = YAML.load(open(file, 'r'))

p ssid
p url
p userdata

connect(ssid, url, userdata)
