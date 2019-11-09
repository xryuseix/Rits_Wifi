# -*- coding: utf-8 -*-
require 'mechanize'
require 'nokogiri'
require 'net/http'
require 'kconv'


class Crawling
  attr_reader :url, :html, :tables, :params

  # 特殊配列
  class CrawlArray < Array

    def find(search)
      ## -----*----- 検索 -----*----- ##
      self.each do |e|
        if search.keys[0].to_s == 'inner'
          # innerTextが一致するか
          return e if e.innerText == search.values[0]
        else
          # 属性が一致するか
          return e if e.attr(search.keys[0].to_s) == search.values[0]
        end
      end
    end

    def method_missing(method, *args)
      if self == []
        return eval("Crawling.new(doc: nil).#{method}(*#{args})")
      end

      return eval("self[0].#{method}(*#{args})")
    end
  end

  def initialize(url = nil, doc: nil, html: nil)
    ## -----*----- コンストラクタ -----*----- ##
    @agent = Mechanize.new
    @agent.keep_alive = false

    if !url.nil?
      get(url)
    elsif !doc.nil?
      @html = doc.to_html
      @doc = doc
      table_to_hash
    else
      update_params(html)
      @html = html
    end

    @params = []
  end

  def get(url)
    ## -----*----- ページ推移 -----*----- ##
    @url = url
    page = @agent.get(@url)
    html = page.content.toutf8
    update_params(html)
  end

  def send(opts)
    ## -----*----- フォームデータ指定 -----*----- ##
    #
    # テキスト，数値など　  => value（String）を指定
    # チェックボックス　　  => check（Bool）を指定
    # ファイルアップロード  => file（String）を指定
    @params << {}
    opts.each {|key, value| @params[-1][key.to_sym] = value}
  end

  def submit(url = @url, opt)
    ## -----*----- フォーム送信 -----*----- ##
    @agent.get(url) do |page|
      # フォーム指定
      if opt.kind_of?(Integer)
        form = page.forms[opt]
      else
        form = page.form(**opt)
      end
      return if form.nil?

      @params.each do |param|
        # テキスト，数値など
        if param.include?(:value) && !param.include?(:check)
          value = param.delete(:value)
          next if value.nil?
          form.field_with(**param).value = value unless form.field_with(**param).nil?
        end

        # チェックボックス
        if param.include?(:check)
          check = param.delete(:check)
          next if check.nil?
          if check
            form.checkbox_with(**param).check unless form.checkbox_with(**param).nil?
          else
            form.checkbox_with(**param).uncheck unless form.checkbox_with(**param).nil?
          end
        end

        # ファイルアップロード
        if param.include?(:file)
          file = param.delete(:file)
          next if file.nil? || !File.exist?(file)
          form.file_upload_with(**param).file_name = file unless form.file_upload_with(**param).nil?
        end
      end

      form = form.submit
      update_params(form.content.toutf8)
    end
    @params = []
  end

  def xpath(locator, single = false)
    ## -----*----- HTMLからXPath指定で要素取得 -----*----- ##
    elements = CrawlArray.new(@doc.xpath(locator).map {|el| Crawling.new(doc: el)})
    if single
      # シングルノード
      if elements[0] == nil
        return CrawlArray.new()
      else
        return elements[0]
      end
    else
      # 複数ノード
      return elements
    end
  end

  def css(locator, single = false)
    ## -----*----- HTMLからCSSセレクタで要素取得 -----*----- ##
    elements = CrawlArray.new(@doc.css(locator).map {|el| Crawling.new(doc: el)})
    if single
      # シングルノード
      if elements[0] == nil
        return CrawlArray.new()
      else
        return elements[0]
      end
    else
      # 複数ノード
      return elements
    end
  end

  def innerText(shaping = true)
    ## -----*----- タグ内の文字列を取得 -----*----- ##
    if shaping
      return shaping_string(@doc.inner_text)
    else
      @doc.inner_text
    end
  end

  def text(shaping = true)
    ## -----*----- タグ内の文字列（その他タグ除去）を取得 -----*----- ##
    if shaping
      return shaping_string(@doc.text)
    else
      @doc.text
    end
  end

  def attr(name)
    ## -----*----- ノードの属性情報取得 -----*----- ##
    ret = @doc.attr(name)
    if ret.nil?
      return ''
    else
      return ret
    end
  end

  def url()
    ## -----*----- カレントURLの取得 -----*----- ##
    return @agent.get(@url).uri.to_s
  end


  private


  def update_params(html)
    ## -----*----- パラメータを更新 -----*----- ##
    @html = html
    @doc = Nokogiri::HTML.parse(@html)
    table_to_hash
  end

  def table_to_hash
    ## -----*----- テーブル内容をHashに変換 -----*----- ##
    @tables = {}
    @doc.css('tr').each do |tr|
      @tables[tr.css('th').inner_text.gsub("\n", "").gsub(" ", "")] = shaping_string(tr.css('td').inner_text)
    end
    @doc.css('dl').each do |el|
      @tables[el.css('dt').inner_text.gsub("\n", "").gsub(" ", "")] = shaping_string(el.css('dd').inner_text)
    end
  end

  def shaping_string(str)
    ## -----*----- 文字例の整形 -----*----- ##
    # 余計な改行，空白を全て削除
    str = str.to_s
    return str.gsub(" ", ' ').squeeze(' ').gsub("\n \n", "\n").gsub("\n ", "\n").gsub("\r", "\n").squeeze("\n").gsub("\t", "").strip
  end
end