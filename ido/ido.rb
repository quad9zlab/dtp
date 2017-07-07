# coding: utf-8
require 'yaml'
require 'pp'
require 'csv'
require './txt2yml'

files = Dir.glob("*.txt")
files.txt2yml

exit

# =========================================================================================
# coding: utf-8
# YAMLファイルの読み込み。
ymls = Dir.glob("*.yml")

ymls.each do |y|
  ## 初期化
  # hash形式で書いたYAMLファイルをハッシュとして書き出す。
  hash = YAML.load_file(y)
  # CSV書き出し用にベースファイル名を取得。
  fn = File.basename(y, ".yml")
  # 配列を初期化。
  arr = []
  ## 2次配列を作る。思いっきりベタなやり方だけれどこれしか思いつかない。
  hash.each do |key, val|
    arr << [key,
            val["name"],
            val["ruby"],
            val["date"],
            val["office"],
            val["address"]["pcode"],
            val["address"]["zip1"],
            val["address"]["zip2"],
            val["contact"]["tel"],
            val["contact"]["fax"]
           ]
  end
  # CSV用にヘッダーを入れた配列を下準備する。
  header = %w[id name ruby date office pcode zip1 zip2 tel fax @psd]
  # CSV用にインスタンスを作成。
  contents = CSV.generate("", :headers => header, :write_headers => true) do |csv|
    arr.each { |a| csv << a }
  end
  # CSVファイルとして書き込む。
  File.open("#{ fn }.csv", 'w+:UTF-16:UTF-8') do |f|
    f.puts contents
  end
end

# =========================================================================================
# # 配列にするために正規表現で内容を整理する。
# File.open("#{ fn }", "r") do |f|
#   # ファイルの内容を配列に格納する。
#   f.each_line do |l|
#     # 行末の改行を削除
#     l.chomp!
#     # CSV化するための下準備。配列に変換する。
#     lines << l.split(",")
#   end
#   # CSVに変換する。
#   csv = CSV.generate('', write_headers: true, headers: my_headers) do |c|
#     lines.each { |i| c << i }
#   end
#   File.open("#{ orgfn }.csv", 'w+') { |f| f.puts csv }
#   # CSVから列を抽出してよしなに内容を変更していく。
#   table = CSV.table("#{ orgfn }.csv", headers: :first_row)
#   table[:number].each { |i| renw_number << "【会員番号 #{ i.to_i }】" }
#   table[:name].each { |i| renw_name << "#{ i.to_s.namaezoroe! }氏" }
#   table[:date].each { |i| renw_date << "▼#{ i.to_s }付" }
#   table[:assoc].each do |i|
#     unless i == nil
#       renw_assoc << "　#{ i.to_s }弁護士会"
#     else
#       renw_assoc << nil
#     end
#   end
# end
# contents = [renw_name, renw_number, renw_date, renw_assoc].transpose
# renw_csv = CSV.generate() do |csv|
#   contents.each { |i| csv << i }
# end
# # CSVファイルに上書きして保存する。
# File.open("#{ orgfn }.csv", 'w+') do |file|
#   file.puts renw_csv
# end



# ===========================================================================================
# === 一応保存するオリジナル
require "../lib/txto"

# ディレクトリ内のテキストファイルを抽出する。
files = Dir.glob("*.txt")
# ファイル毎に処理をする。
files.each do |fn|
  # 元ファイル名を変数に格納する。
  orgfn = File.basename(fn, ".*")
  # YAMLファイルを新規作成して、テキストの内容を整理して保存する。
  File.open("#{ fn }", "r") do |f|
    i = f.read
    # 空行を削除する。
    i.gsub!(/^\n/, "")
    # txtoのメソッドでテキストを整理する。
    i.clean_char!
    # 年月日の記述、体裁を合わせるために付けている不要な0を取り去る。
    i.gsub!(/0(?=\d[年月日])/, '')
    # 会員番号を5桁にする。不要な先頭の0を取り去る。
    i.gsub!(/^0(?=\d{5})/, '')
    # ymlファイルに格納する内容を配列で初期化する。
    trans_yml = []
    # ファイルの内容を配列に変換する。
    i.each_line do |l|
      # 数字から始まるラインの処理と配列化して置き換える。
      if l =~ /^\d/
        # 正規表現パターン『先頭の5つの数字列と直後の空白』
        l.gsub!(/(?<=\d{5})[[:blank:]]+/, ","+"  name: ")
        # 正規表現パターン『括弧に囲まれたふりがなと直後の空白』
        l.gsub!(/（(.+?)）[[:blank:]]+/, ","+"  ruby: "+'\1'+","+"  date: ")
        l.chomp!
        l = l.split(",")
      # それ以外のラインの処理。
      else
        l.gsub!(/事務所名称[[:blank:]]+|事務所名称/, "  office: ")
        l.gsub!(/郵便番号[[:blank:]]+|郵便番号/, "  zipcode: ")
        l.gsub!(/住所1[[:blank:]]+|住所1/, "  zip1: ")
        l.gsub!(/住所2[[:blank:]]+|住所2/, "  zip2: ")
        l.gsub!(/電話番号1[[:blank:]]+|電話番号1/, "  tel: ")
        l.gsub!(/FAX番号1[[:blank:]]+|FAX番号1/, "  fax: ")
        l.chomp!
      end
      # 一行毎に変換用の配列に読み込ませる。
      trans_yml << l
    end
    # yamlファイルを新規で作成し、配列の内容を書き込む。
    File.open("#{ orgfn }.yml", "w") { |f| f.puts trans_yml.flatten! }
  end
end
