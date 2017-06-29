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
p text
exit

# 2つの配列をまとめて意図通りに変更してからファイルへ書き出す。
File.open "#{ fn }.txt", 'w' do |f|

  text.each_line do |line|
    line = NKF.nkf("-w Xm0", line)
    # 全角の記号、数字、アルファベットと半角に変換する。
    line.tr!("！-＇０-９：-＠Ａ-Ｚ＿｀ａ-ｚ", "!-'0-9:-@A-Z_`a-z")
    # 上手く変換できない文字とその前後にあったものを含めてユニコードで指定して変換する。
    line.tr!("\uFF0A-\uFF0B", "\u002A-\u002B") #=> 「*」「+」
    line.tr!("\uFF0D", "\u002D") #=> 「-」
    line.tr!("\uFF0F", "\u002F") #=> 「/」
    line.tr!("\uFF3C", "\u005C") #=> 「\」
    line.tr!("\uFF3E", "\u005E") #=> 「^」
    line.tr!("\uFF5B-\uFF5D", "\u007B-\u007D") #=> 「{」「|」「}」
    # 半角の記号を全角に変換する。
    line.tr!("()[]", "（）［］")
    # 行頭行末の不要な全角スペースや\s,\tなどを除去する。
    # 'String#sprit!'では全角のスペースを削除出来ないかったので採用していない。
    line.gsub!(/^[\s　]+|[\s　]+$/,'')
    # 数値の桁区切りが全角であれば、半角に変換する。
    line.gsub!(/(\d+)，(\d{2})/,'\1,\2')
    # 句読点を変換する。
    line.tr!("，", "、")
    line.tr!("．", "。")
  end
  f.puts text
end


# # 2行バージョン
# prefix = ->(x, y) { x + y }.curry.("■")
# header.map! { |h| prefix.("#{ h }") }

# mapを使って回せば同じことが出来るのだが、
# header.map! { |i| "■#{ i }" }
# Procメソッドと「カリー化」を使ってみたかった。
# mapを!する処理が同じ時点で疑問符なのと行数が増えることについて判断に迷う。
