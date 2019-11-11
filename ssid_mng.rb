require 'yaml'

def check_ssid
  # ===== 現在接続中のSSID検出 ==========
  ret = `/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport -I | /usr/bin/grep -ie '^\s*ssid'  | cut -d ":" -f 2`
  ret.strip!
  return ret
end

data = YAML.load(open('./config/login.yml', 'r'))

# ===== Select Mode ==========
puts " | 1: Change SSID config"
puts " | 2: Add    SSID config"
puts " | 3: Exit"
print "Select Mode: "
mode = gets.to_i
# ===============

case mode
when 1 then
  # ===== Select SSID ==========
  puts "\n"
  data.keys.each_with_index do  |ssid, i|
    puts " | #{i+1}: #{ssid}"
  end
  print "Select SSID Number: "
  datanum = gets.to_i-1
  account = data.values[datanum]

  puts "\n"
  account.keys.each_with_index do  |value, i|
    puts " | #{i+1}: #{value}"
  end
  print "Select Change Item Number: "
  changenum = gets.to_i-1

  print "Imput the value \"#{account.values[changenum]}\" ->: "
  data[data.keys[datanum]][account.keys[changenum]] = gets.chomp
# ===============

when 2 then
  # ===== Add SSID ==========
  print "Input your ID: "; id = gets.chop
  print "Input your PW: "; pw = gets.chop
  print "Input URL: "; url = gets.chop
  ssid = check_ssid
  
  data[ssid] = {'ID' => id, 'PW' => pw, 'URL' => url}

when 3 then
  # ===== Exit ==========
  exit
end

file = './config/login.yml'
YAML.dump(data, File.open(file, 'w'))
