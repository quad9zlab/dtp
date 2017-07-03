require 'yaml'
require 'pp'
require 'csv'
require './txt2yml'
require '../lib/txto'


texts = Dir.glob("*.txt")
p texts

exit

# カレントディレクトリにあるExcelファイルの読み込みをする。
msexcels = Dir.glob("*.xlsx")
renw_row = []
# ExcelファイルをCSVファイルに変換して保存する。(ファイルが単一か複数かは問わない。)
msexcels.each do |msxls|
  # 読み込んだファイルの拡張子より前の名前をオブジェクト化する。
  origin_name = File.basename(msxls, ".*")
  # Excelx to CSV file out
  Roo::Excelx.new("#{ origin_name }.xlsx").to_csv("#{ origin_name }.csv")
  # ここからはcsvの世界
  table = CSV.table("#{ origin_name }.csv", headers: :first_row)
  table.headers.each do |h|
    # # セル内の改行を取り去る
    table[h].each do |cell|
      cell.gsub!(/\n/, '▼') if cell.class == String
      cell.clean_char! if cell.class == String
      table[h] << cell
    end
  end
  File.open("#{ origin_name }.csv", 'w+') do |file|
    file.puts table
  end
end

files = Dir.glob("*.#{ ext }")
files.each do |f|
  File.open("#{ f }") do |finst|
    ins = finst.read
  end
end

# coding: utf-8
require 'yaml'
require 'pp'
require 'csv'
require './txt2yml'

# 第一引数にファイル拡張子を渡す。
# bundle exec ruby ido.rb txt
ext = ARGV[0]

# 外部ファイルのメソッドでベースのテキスト処理
txt2yml(ext)

# YAMLファイルの読み込み。
ymls = Dir.glob("*.yml")

ymls.each do |y|
  ## 初期化
  # hash形式で書いたYAMLファイルをハッシュとして書き出す。
  hash = YAML.load_file(y)
  # CSV書き出し用にベースファイル名を取得。
  fn = File.basename(y, ".yml")
  # 配列を初期化。
  arr = []
  ## 2次配列を作る。思いっきりベタなやり方だけれどこれしか思いつかない。
  hash.each do |key, val|
    arr << [key,
            val["name"],
            val["ruby"],
            val["date"],
            val["office"],
            val["address"]["pcode"],
            val["address"]["zip1"],
            val["address"]["zip2"],
            val["contact"]["tel"],
            val["contact"]["fax"]
           ]
  end
  # CSV用にヘッダーを入れた配列を下準備する。
  header = %w[id name ruby date office pcode zip1 zip2 tel fax @psd]
  # CSV用にインスタンスを作成。
  contents = CSV.generate("", :headers => header, :write_headers => true) do |csv|
    arr.each { |a| csv << a }
  end
  # CSVファイルとして書き込む。
  File.open("#{ fn }.csv", 'w+:UTF-16:UTF-8') do |f|
    f.puts contents
  end
end
