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
# 半角カタカナは、ここで変換。
# 変換用の器からCSVに書き出す。
File.open("#{ csvfn }", "r") do |c|
  c.each_line { |l| renew << NKF.nkf("-wXm0", l) }
  File.open("#{ orgfn }.csv", "w+") { |f| f.puts renew }
end
# 名前の文字列が姓名で全角スペースで区切られている場合を想定している。
File.open("#{ csvfn }", "r") do |csv|
  table = CSV.table(csv, headers: :first_row)
  # 氏名漢字
  name = []
  fullname = []
  table[:name].each do |i|
    if i.class == String
      name << i.split("　")
    else
      name << []
    end
  end
  pp name

  name.each do |sei_mei|
    if sei_mei[0] == nil
      fullname << nil
    else
      sei      = sei_mei[0]
      sei_size = sei.size
      mei      = sei_mei[1]
      mei_size = mei.size
      if sei_size == 1 && mei_size == 1
        fullname << "#{ sei } 　　#{ mei }"
      elsif sei_size == 1 && mei_size == 2 || sei_size == 2 && mei_size == 1
        fullname << "#{ sei }　　#{ mei }"
      elsif sei_size == 2 && mei_size == 2 || sei_size == 1 && mei_size == 3 || sei_size == 3 && mei_size == 1
        fullname << "#{ sei }　#{ mei }"
      else
        fullname << "#{ sei }#{ mei }"
      end
    end
  end
  pp fullname
end


# csvfn = Dir.glob("*.csv").shift
# File.open("#{ csvfn }", "r") do |csv|
#   table = CSV.table(csv, headers: :first_row)
#   pp table
#   # name = tablename_only.dup
#   # name.plus_photoname
#
# end
