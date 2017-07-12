require 'csv'
require 'roo'
require '../lib/iArray'
require 'pp'

# 下準備
# エクセルファイルからCSVファイルを生成する。
Dir.glob("*.xlsx").xlseiri
# 対象は1ファイルなので、先頭のファイルを配列から抜き出す。
csv = Dir.glob("*.csv").shift
# CSVファイルを読み込む。
orgfn = File.basename(csv, ".*")
# 一行目をヘッダーとして、CSVクラスのテーブルオブジェクトにする。
# この時点で一旦CSVファイルを作成する。
table = CSV.table(csv, headers: :first_row)
# 別名で書き込むCSVのcoloumnを配列で初期化する。
content = table[:content]
day_place = []
# 本番。再生産するCSVファイルのコラムの中身を生成する。
table[:day].zip(table[:time], table[:place]) do |day, time, place|
  day_place = "【日時】#{ day }#{ time }▼【場所】#{ place }"
  # 文字列の検索置換
  # daytime.gsub!(/(\d\d?)月(\d\d?)日（(月|火|水|木|金|土|日)）/,'\1/\2\3')
  # daytimeコラムに配列を書き込んでいく。
  day_place << day_place
end

renew_csv = []
content.zip(day_place) { |e| renew_csv << content.shift + "▼" + day_place.shift }
# さきほど作成したCSVファイルに、内容を上書きして保存する。
File.open("#{ orgfn }.csv", 'w+') { |file| file.puts renew_csv }
