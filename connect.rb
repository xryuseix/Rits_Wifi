#!/usr/bin/env ruby
#coding: utf-8
#
require 'mechanize'

def check_ssid
    ret = `/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport -I | /usr/bin/grep -ie '^\s*ssid'  | cut -d ":" -f 2`
    ret.strip!
    return ret
end



def login( user, pass)
    return 0;

end

ssid = check_ssid

exit if ssid == ""

puts ssid

case ssid

when /starbucks/i
    puts login("******", "*******")
when /grapic/i
    puts login("*******", "******")
when /wi2/i
    puts login("*****", "*******")
end