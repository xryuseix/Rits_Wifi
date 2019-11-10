require 'yaml'

data = YAML.load(open('./config/login.yml', 'r'))

# ===== Select Mode ==========
puts " | 1: Change SSID config"
puts " | 2: Add    SSID config"
puts " | 3: Exit"
print "Select Mode: "
mode = gets.to_i
# =====

case mode
when 1 then
  ## -----*----- Select SSID -----*----- ##
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

when 2 then
  ## -----*----- Add SSID -----*----- ##


when 3 then
  ## -----*----- Exit -----*----- ##
  exit
end

file = './config/login.yml'
YAML.dump(data, File.open(file, 'w'))
