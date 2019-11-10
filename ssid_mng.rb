require 'yaml'

data = YAML.load(open('./config/login.yml', 'r'))

# ===== Select Mode ==========
puts " | 1: Change SSID config"
puts " | 2: Add    SSID config"
print "Select Mode: "
mode = gets.to_i
# ===============

# ===== Select SSID ==========
puts "\n"
data.keys.each_with_index do  |ssid, i|
  puts " | #{i+1}: #{ssid}"
end

print "Select SSID Number: "
ssid = data.values[gets.to_i-1]
# ===============


data = YAML.load(open('./config/login.yml', 'r'))

# ===== Select Mode ==========
puts " | 1: Change SSID config"
puts " | 2: Add    SSID config"
print "Select Mode: "
mode = gets.to_i
# ===============

# ===== Select SSID ==========
puts "\n"
data.keys.each_with_index do  |ssid, i|
puts " | #{i+1}: #{ssid}"
end

print "Select SSID Number: "
ssid = data.values[gets.to_i-1]
# ===============


p mode
p ssid

