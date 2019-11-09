require './lib/scripts/crawling'
require 'yaml'

def check_ssid
  ## -----*----- 現在接続中のSSID検出 -----*----- ##
  ret = `/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport -I | /usr/bin/grep -ie '^\s*ssid'  | cut -d ":" -f 2`
  ret.strip!
  return ret
end

def connect(ssid, url, userdata)
  ## -----*----- Wi-Fi接続 -----*----- ##
  p 'ここはconnect関数'
end

def fetch_account
  ## -----*----- config -----*----- ##
  file = './config/login.yml'
  rainbow = {}

  # configが存在しない場合 => 新規作成
  if File.exist?(file)
    rainbow = YAML.load(open(file,'r'))
  else
    print "Input your ID: "; rainbow[:ID] = gets.chop
    print "Input your PW: "; rainbow[:PW] = gets.chop
    Dir.mkdir(File.dirname(file))
    YAML.dump(rainbow, File.open(file, 'w'))
  end

  rainbow
end


# rainbowIDの読み込み
url = "https://webauth.ritsumei.ac.jp/fs/customwebauth/login.html"
login = fetch_account
ssid = check_ssid

p ssid
p url
p login

connect(ssid, url, login)
