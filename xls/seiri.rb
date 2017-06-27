# coding: utf-8
require 'csv'
require 'roo'
require '../lib/txto'

# カレントディレクトリにあるExcelファイルの読み込みをする。
msexcels = Dir.glob("*.xlsx")
# ExcelファイルをCSVファイルに変換して保存する。(ファイルが単一か複数かは問わない。)
msexcels.each do |msxls|
  # 読み込んだファイルの拡張子より前の名前をオブジェクト化する。
  origin_name = File.basename(msxls, ".*")
  # Excelx to CSV file out
  Roo::Excelx.new("#{ origin_name }.xlsx").to_csv("#{ origin_name }.csv")
  # ここからはcsvの世界
  table = CSV.table("#{ origin_name }.csv", headers: :first_row)
  table.headers.each do |h|
    # セル内の改行を取り去る
    table[h].each do |cell|
      cell.gsub!(/\n/, '▼') if cell.class == String
      cell.clean_char! if cell.class == String
      table[h] << "#{ cell }"
    end
    p table[h]
   end
end


exit
  # CSVを生成する。
  # ヘッダーを生成する。
  renew_header = ["committee", "requirement", "contents", "count", "date"]
  # まずは、コラムのカテゴリーごとに配列に収集して行の状態になっている内容を組み込む。
  cells = [committee, requirement, contents, count, date]
  # 二次配列の列と行を入れ替えて本来の状態にする。
  trsp_arr = cells.transpose
  # ヘッダーと内容をCSVとして生成する。
  renew_csv = CSV.generate('', write_headers: true, headers: renew_header) do |csv|
    trsp_arr.each { |i| csv << i }
  end
  # CSVファイルに上書きして保存する。
  File.open("#{ origin_name }.csv", 'w+') do |file|
    file.puts renew_csv
  end
