# -*- coding:utf-8 -*-
require 'io/console'

def getpass(prompt:["id", "password"], is_display:[true, false], sub_char:"*")
  ## -----*----- 安全なパスワード入力 -----*----- ##
  raise ArgumentError unless prompt.length == is_display.length
  ret = Array.new(prompt.length)

  prompt.length.times do |i|
    print "#{prompt[i]}："
    ret[i] = ''

    if is_display[i]
      # エコーバック有り
      ret[i] = gets.strip

    else
      # エコーバック無し
      STDIN.noecho {
        loop do
          c = STDIN.raw(&:getc)
          break if c == "\r"
          ret[i] += c
          putc sub_char
        end
      }
      print "\n"
    end
  end

  ret
end
