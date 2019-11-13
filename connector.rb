require './lib/scripts/crawling'
require 'yaml'

def check_ssid
  ## -----*----- 現在接続中のSSID検出 -----*----- ##
  ret = `/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport -I | /usr/bin/grep -ie '^\s*ssid'  | cut -d ":" -f 2`
  ret.strip!
  return ret
end

def connect(ssid, account)
  ## -----*----- Wi-Fi接続 -----*----- ##
  account = account[ssid]

  agent = Crawling.new(account[:URL])
  agent.send(name:'username', value:account[:ID])
  agent.send(name:'password', value:account[:PW])
  agent.submit(method:'POST')
end

def fetch_account
  ## -----*----- config -----*----- ##
  file = './config/login.yml'
  data = {}

  # configが存在しない場合 => 新規作成
  if File.exist?(file)
    data = YAML.load(open(file,'r'))
  else
    # ここ，ssid_mngのadd処理に置換して良さそうだけど一応このままで置いとく
    print "Input your ID: "; id = gets.chop
    print "Input your PW: "; pw = gets.chop
    print "Input URL: "; url = gets.chop
    ssid = check_ssid
  
    data[ssid] = {ID: id, PW: pw, URL: url}
    Dir.mkdir(File.dirname(file))
    YAML.dump(data, File.open(file, 'w'))
  end

  data
end


# rainbowIDの読み込み
login = fetch_account

connect('Rits-Webauth', login)
