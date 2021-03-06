require 'csv'
require 'roo'
require '../lib/iArray'
require 'pp'

# 下準備
# エクセルファイルから文字を整形した上で、CSVファイルとして再生成する。
Dir.glob("*.xlsx").xlseiri
# 対象は1ファイルなので、先頭のファイルを配列から抜き出す。
csv = Dir.glob("*.csv").shift
# CSVファイルを読み込む。
orgfn = File.basename(csv, ".*")
# 一行目をヘッダーとして、CSVクラスのテーブルオブジェクトにする。
# この時点で一旦CSVファイルを作成する。
table = CSV.table(csv, headers: :first_row)
# dayコラムの書式を変更する。
table[:day].each { |s| s.gsub!(/(\/)(\d\d?)(?=（.+?）)/, '月\2日') }
# 別名で書き込むCSVのcoloumnを配列で初期化する。
# 内容を納めるコラム。行頭に正規表現スタイル用の印を付与する。
mark = []
table[:content].each { |s| mark << "■" + s }
content = mark
# 日時と場所のコラムを初期化しておく。
day_place = []
# 本番。再生産するCSVファイルのコラムの中身を生成する。
table[:day].zip(table[:time], table[:place]) do |day, time, place|
  day_place << "【日時】#{ day }#{ time }▼【場所】#{ place }"
end
# CSVに書き込むための配列に2つの配列を統合したものを格納する。
renew_csv = []
content.zip(day_place) {|a| renew_csv << a.join("▼") }
# さきほど作成したCSVファイルに、内容を上書きして保存する。
File.open("#{ orgfn }.csv", 'w+') { |file| file.puts renew_csv }
