# coding: utf-8

# 最初に元原稿のエクセルのヘッダーの名称を変更。
# header, content

# ファイル名を変更するコード
require 'csv'
require 'roo'
require 'nkf'
require 'fileutils' #=> 無くても動いているがいいのか。
require '../lib/txto'


# エクセルファイルのオブジェクトを取得
io = Dir.glob("*.xlsx").shift
fn = File.basename(io, ".xlsx")

# エクセルデータのインスタンスをCSVに変換する。オプションとして別名で保存する。
Roo::Excelx.new(io).to_csv("#{ fn }.csv")
# 改めてCSVファイルを開く。
table = CSV.table("#{ fn }.csv", headers: :first_row)
# 各セル内の文字列を整理する。
table.headers.each do |h|
  table[h].each do |cell|
    cell.gsub!(/\n/, '▼') if cell.class == String
    cell.clean_char! if cell.class == String
    table[h] << cell
  end
end

# headerコラム
add = Proc.new { |x, y| x + y }
prefix = add.curry.("■")
header = table[:header].map! { |i| prefix.("#{ i }") }
text = header.zip(table[:content]).flatten.uniq.join("\n")
File.open("#{ fn }.txt", 'w') do |f|
  f.puts text
end

exit

# # 2行バージョン
# prefix = ->(x, y) { x + y }.curry.("■")
# header.map! { |h| prefix.("#{ h }") }

# mapを使って回せば同じことが出来るのだが、
# header.map! { |i| "■#{ i }" }
# Procメソッドと「カリー化」を使ってみたかった。
# mapを!する処理が同じ時点で疑問符なのと行数が増えることについて判断に迷う。
