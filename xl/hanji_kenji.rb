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
# create CSV file
File.open("#{ csvfn }", "r") do |c|
  c.each_line { |l| renew << NKF.nkf("-wXm0", l) }
  File.open("#{ orgfn }.csv", "w+") { |f| f.puts renew }
  # 一行目をヘッダーとして、CSVクラスのテーブルオブジェクトにする。
  # この時点で一旦CSVファイルを作成する。
end
#------------------------------------------------------------------------------
# modify table
File.open("#{ csvfn }", "r") do |csv|
  table = CSV.table(csv, headers: :first_row)
  # modify Photo file
  # 名前を5文字揃えにする。
  name_soroe = []
  table[:name].each do |n|
    # 氏と名で姓名を分ける
    han = n.split("　")
    # 姓
    sei      = han[0]
    sei_size = sei.size
    # 名
    mei      = han[1]
    mei_size = mei.size
    # 5文字で揃える
    if sei_size >= 3 && mei_size >= 2 || sei_size >= 2 && mei_size >= 3
      name_soroe << "#{ sei }#{ mei }"
    elsif sei_size == 1 && mei_size == 2 || sei_size == 2 && mei_size == 1
      name_soroe << "#{ sei }　　#{ mei }"
    else
      name_soroe << "#{ sei }　#{ mei }"
    end
  end
  # here is name_soroe ただし、このインスタンスはat_photoを生成したらいりません。
  # get Photo file name as Array
  at_photo = []
  psds = Dir.glob("*.psd").sort
  psds.map! { |fn|
    orgfn = File.basename(fn, ".psd")
    renew_fn = "img_#{orgfn}_#{name_soroe.shift}.psd"
    FileUtils.mv(fn, renew_fn )
    at_photo << renew_fn
  }
  # here is at_photo
  #-----------------------------------------------------------------------------
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
  # confirm table contents
  # pp name_ruby
  # pp table[:post]
  # pp table[:period]
  # pp table[:before_post]
  # pp table[:after_before_post]
  # pp table[:greet]
  # pp at_photo

  # CSVを生成する。
  # ヘッダーを生成する。
  my_headers = %w[name_ruby post period before_post after_before_post greet @photo]
  # まずは、コラムのカテゴリーごとに配列に収集して行の状態になっている内容を組み込む。
  contents = [name_ruby, table[:post], table[:period], table[:before_post], table[:after_before_post], table[:greet], at_photo]
  # 二次配列の列と行を入れ替えて本来の状態にする。
  trsp_arr = contents.transpose
  # ヘッダーと内容をCSVとして生成する。
  renew_csv = CSV.generate('', write_headers: true, headers: my_headers) do |csv|
    trsp_arr.each { |i| csv << i }
  end
  # CSVファイルに上書きして保存する。
  File.open("#{ orgfn }.csv", "w+:UTF-16:UTF-8") do |f|
    f.puts renew_csv
  end
end

# 列を抜き出してルビの処理がしたい。
## 2列の配列を書き出して、ハッシュに変換
# 列を抜き出して文字列の先頭に丸数字を付与していきたい。




exit


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

# get CSV file
File.open("#{ csvfn }", "r") do |csv|
  table = CSV.table(csv, headers: :first_row)
  p table
  # get Photo file name as Array
  psds = Dir.glob("*.psd").sort
  # 名前を5文字揃えにする。
  name_soroe = []
  table[:name].each do |n|
    # 氏と名で姓名を分ける
    han = n.split("　")
    # 姓
    sei      = han[0]
    sei_size = sei.size
    # 名
    mei      = han[1]
    mei_size = mei.size
    # 5文字で揃える
    if sei_size >= 3 && mei_size >= 2 || sei_size >= 2 && mei_size >= 3
      name_soroe << "#{ sei }#{ mei }"
    elsif sei_size == 1 && mei_size == 2 || sei_size == 2 && mei_size == 1
      name_soroe << "#{ sei }　　#{ mei }"
    else
      name_soroe << "#{ sei }　#{ mei }"
    end
  end
  pp name_soroe
  pp psds

  at_photo = []
  psds.map! { |fn|
    orgfn = File.basename(fn, ".psd")
    renew_fn = "img" + orgfn + "_" + name_soroe.shift + ".psd"
    FileUtils.mv(fn, renew_fn )
    at_photo << renew_fn
  }
  pp at_photo
end
