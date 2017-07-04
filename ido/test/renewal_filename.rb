# coding: utf-8

require 'csv'
require 'fileutils'

# 引数（この場合は、拡張子psd）を格納する。
# ruby renewal_filename.rb psd
ext = ARGV[0]
add_char = ARGV[1]
## 初期化
# ディレクトリ内のpsdファイルをインスタンスにする。
picts = Dir.glob("*.#{ ext }") if /psd/ =~ ext

# CSVファイルを抽出する。
# ディレクトリにCSVファイルは1つしか無いと云う前提で進める。
csv = Dir.glob("*.csv").shift
# テーブルを抽出する。
table = CSV.table("#{ csv }", headers: :first_row, encoding: "UTF-16:UTF-8")# テーブルの:nameにある氏名を配列として抽出する。
persons = table[:name]

## zipdで二つの配列を[[写真名, 氏名], [写真名, 氏名]...]二重配列にしてから、mapする。
fnames = []
picts.zip(persons).map do |i|
  origin_bn = File.basename("#{ i[0] }", ".psd")

  if add_char
    fn = origin_bn +"_" + add_char +"_" + i[1] + ".#{ ext }"
  else
    fn = origin_bn +"_" + i[1] + ".#{ ext }"
  end

  FileUtils.mv(i[0], fn)
  fnames << fn
end
puts fnames
# Csv.open("#{ csv }", 'w+:UTF-16:UTF-8') do
#   table[:@psd] << fns
#   # c.puts table[:@psd] << fns psd_name
# end

