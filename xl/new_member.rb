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
  name_only = []
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
        name_only << "#{ sei }　#{ mei }"
      else
        name_ruby << "[#{ renew_sei }][#{ renew_mei }]"
        name_only << "#{ sei }#{ mei }"
      end
    end
  end

  # photo_name = Dir.glob("*.psd").plus_photoname

  # 写真の名前を取得して配列に格納する。
  psds = Dir.glob("*.psd")
  renew_fn = ""
  photo_name = []
  name = name_only.dup
  psds.map! { |fn|
    psdfn = File.basename(fn, ".psd")
    renew_fn = psdfn + "_" + name.shift + ".psd"
    FileUtils.mv(fn, renew_fn )
    photo_name << renew_fn
  }

  # CSVを生成する。
  # ヘッダーを生成する。
  renew_header = ["num", "name_only", "ruby", "zip_code", "zip1", "zip2", "office", "tel", "fax", "name_ruby", "entry_num", "place", "@photo_name"]

  # まずは、コラムのカテゴリーごとに配列に収集して行の状態になっている内容を組み込む。
  contents = [table[:num], name_only, table[:ruby], table[:zip_code], table[:zip1], table[:zip2], table[:office], table[:tel], table[:fax], name_ruby, table[:entry_num], table[:place], photo_name]

  # 二次配列の列と行を入れ替えて本来の状態にする。
  trsp_arr = contents.transpose
  # ヘッダーと内容をCSVとして生成する。
  renew_csv = CSV.generate('', write_headers: true, headers: renew_header) do |csv|
    trsp_arr.each { |i| csv << i }
  end
  # CSVファイルに上書きして保存する。
  File.open("#{ orgfn }.csv", "w+:UTF-16:UTF-8") do |file|
    file.puts renew_csv
  end
end
