require 'yaml'

data = YAML.load(open('./config/login.yml', 'r'))
p data

data.keys.each_with_index do |ssid, i|
  puts "#{i+1}: #{ssid}"
end


print "Select SSID Number: "
ssid = data.values[gets.to_i-1]
p ssid
