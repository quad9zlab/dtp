# coding: utf-8
require 'csv'
require 'roo'
require '../lib/txto'

# =====
# エクセルファイルの内容をCSVに書き出すコード。
# セル内改行を置き換え文字に変換し、セル内の文字列を整理するコード。
# ruby seiri.rb
# =====

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