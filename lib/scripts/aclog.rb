require 'logger'

class AcLog
  attr_reader :file

  def initialize(file)
    ## -----*----- コンストラクタ -----*----- ##
    @file = file
    @logger = Logger.new(file)
  end

  def out(opts)
    ## -----*----- ログ出力 -----*----- ##
    #
    # type -> fatal，error，info，warm，debug
    opts.each do |type, txt|
      eval("@logger.#{type}(txt)")
    end
  end
end