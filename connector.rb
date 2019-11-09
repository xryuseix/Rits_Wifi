require './lib/crawling.rb'
require 'yaml'

## -----*----- config -----*----- ##
# Webauth URL
url = "https://webauth.ritsumei.ac.jp/fs/customwebauth/login.html"
# RainbowID
file = './config/rainbow.yml'
unless File.exist?(file)
  rainbow = {}
  print "Input your ID: "; rainbow[:ID] = gets.chop
  print "Input your PW: "; rainbow[:PW] = gets.chop
  Dir.mkdir('config')
  YAML.dump(rainbow, File.open('./config/rainbow.yml', 'w'))
end
p File.exist?(file)
p url
p YAML.load(open(file, 'r'))
