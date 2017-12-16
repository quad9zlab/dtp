require "nkf"
require '../lib/iArray'
require '../lib/iHash'
require '../lib/iString'
require 'pp'

# エクセルファイルから文字を整形した上で、CSVファイルとして再生成する。
Dir.glob("*.xlsx").xlseiri
# Stringクラスとして処理をしたい。対象のオブジェクトは配列の中にあるので、配列の先頭からオブジェクトを抜き出す。
csvfn = Dir.glob("*.csv").shift
# ファイルのベース名を変数に格納しておく。変換用の器を初期化しておく。
orgfn = File.basename(csvfn, ".*")
renew = []
# 本番
File.open("#{ csvfn }", "r") do |c|
  c.each_line { |l| renew << NKF.nkf("-wXm0", l) }
  File.open("#{ orgfn }.csv", "w+") { |f| f.puts renew }
  # 一行目をヘッダーとして、CSVクラスのテーブルオブジェクトにする。
  # この時点で一旦CSVファイルを作成する。
end

File.open("#{ csvfn }", "r") do |csv|
  table = CSV.table(csv, headers: :first_row)
  # 氏名漢字
  han = []
  table[:name].each do |i|
    if i.class == String
      han << i.split("　")
    else
      han << []
    end
  end
  # 氏名ふりがな
  rubi = []
  table[:ruby].each do |i|
    if i.class == String
      rubi << i.split("　")
    else
      rubi << []
    end
  end
  name_list = [han, rubi].transpose
  name_ruby = []
  name_list.each do |sei_mei|
    if sei_mei[0][0] == nil
      name_ruby << nil
    else
      sei      = sei_mei[0][0]
      sei_size = sei.size
      sei_ruby = sei_mei[1][0]
      mei      = sei_mei[0][1]
      mei_size = mei.size
      mei_ruby = sei_mei[1][1]
      renew_sei = sei + "/" + sei_ruby
      renew_mei = mei + "/" + mei_ruby
      if sei_size == 1 && mei_size == 2 || sei_size == 2 && mei_size == 1
        name_ruby << "[#{ renew_sei }]　[#{ renew_mei }]"
      else
        name_ruby << "[#{ renew_sei }][#{ renew_mei }]"
      end
    end
  end
  pp name_ruby
  pp table[:post]
  pp table[:period]
  pp table[:post]
  pp table[:post]
  pp table[:post]
  pp table[:post]
  pp table[:post]
end

# 列を抜き出してルビの処理がしたい。
## 2列の配列を書き出して、ハッシュに変換
# 列を抜き出して文字列の先頭に丸数字を付与していきたい。
