# -*- coding: utf-8 -*-
require 'active_record'


class Model
  def initialize(db_file)
    ## -----*----- コンストラクタ -----*----- ##
    # ファイルが存在しない場合
    unless File.exist?(db_file)
      File.open(db_file, 'w')
    end

    # DBに接続
    ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: db_file)

    to_model()
  end


  def create_table(table)
    ## -----*----- テーブル作成 -----*----- ##
    # テーブルがすでに存在する場合
    if ActiveRecord::Base.connection.table_exists?(table)
      return
    end

    ActiveRecord::Migration.create_table(table) do |t|
      yield(t)
    end

    to_model()

    # ====== テーブル作成例  ==========
    #
    # Model.create_table(:テーブル名) do |t|
    #   t.string  :name
    #   t.integer :price
    # end
    #
    # =================================
  end


  def drop_table(table, all=true)
    ## -----*----- テーブル削除 -----*----- ##
    ActiveRecord::Migration.drop_table(table)

    to_model()
  end


  def tables
    ## -----*----- テーブル一覧を取得 -----*----- ##
    return ActiveRecord::Base.connection.tables
  end


  def to_model
    ## -----*----- テーブル全てをモデルに変換 -----*----- ##
    tables = tables()
    # 各モデルのインスタンス変数を宣言
    tables.each do |t|
      eval("class #{t.capitalize} < ActiveRecord::Base; end
            @#{t} = #{t.capitalize}")
    end
  end


  def method_missing(method, *args)
    # -----*----- ゴーストメソッド -----*----- ##
    # モデルの参照用
    return eval("@#{method}")
  end
end