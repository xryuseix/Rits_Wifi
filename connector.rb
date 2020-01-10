require 'yaml'
require 'selenium-webdriver'
require './getpass.rb'

def check_ssid
  ## -----*----- 現在接続中のSSID検出 -----*----- ##
  ret = `/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport -I | /usr/bin/grep -ie '^\s*ssid'  | cut -d ":" -f 2`
  ret.strip!
  return ret
end

def connect(data, ssid)
  ## -----*----- Wi-Fi接続 -----*----- ##
  data = data[check_ssid]

  # Seleniumの初期化
  @timeout = 0
  Selenium::WebDriver.logger.level = :warn
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless')
  driver = Selenium::WebDriver.for :chrome, options: options
  driver.manage.timeouts.implicit_wait = @timeout

  # サイトを開く
  driver.get(data[:URL])

  begin
    username = driver.find_element(:name, 'username')
    password = driver.find_element(:name, 'password')
    button = driver.find_element(:name, 'Submit')
  rescue Selenium::WebDriver::Error::NoSuchElementError
    p 'no such element error!!'
    return
  end

  username.send_keys data[:ID]
  password.send_keys data[:PW]
  button.click

  # ドライバーを閉じる
  driver.quit
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
    id, pw, url = getpass(prompt:["ID", "PW", "URL"], is_display:[true, false, true])
    ssid = check_ssid

    data[ssid] = {ID: id, PW: pw, URL: url}
    Dir.mkdir(File.dirname(file)) unless Dir.exist?(File.dirname(file))
    YAML.dump(data, File.open(file, 'w'))
  end

  data
end


# rainbowIDの読み込み
login = fetch_account

# url = "https://webauth.ritsumei.ac.jp/fs/customwebauth/login.html"

connect(login, 'Rits-Webauth')
