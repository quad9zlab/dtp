require "nkf"
require './MyArray'
require './MyString'

# エクセルファイルから文字を整形した上で、CSVファイルとして再生成する。
Dir.glob("*.xlsx").xlseiri
# 対象は1ファイルなので、先頭のファイルを配列から抜き出す。
csvfn = Dir.glob("*.csv").shift
# CSVファイルを読み込む。
orgfn = File.basename(csvfn, ".*")
# 一行目をヘッダーとして、CSVクラスの
renew = []
File.open("#{ csvfn }", "r") do |c|
  c.each_line { |l| renew << NKF.nkf("-wXm0", l) }
  File.open("#{ orgfn }.csv", "w+") { |f| f.puts renew }
end
