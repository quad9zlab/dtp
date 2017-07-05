# coding: utf-8
require "csv"
require "../../lib/txto"

# ディレクトリ内のテキストファイルを抽出
files = Dir.glob("*.txt")
# 変数の定義
lines = []
pattern1 = /(?<=\d{6})[[:blank:]]+/
pattern2 = /[[:blank:]]+(?=平成)/
pattern3 = /(?<=平成\d\d?年\d\d?月\d\d?日)[[:blank:]]+/
my_headers = ["number", "name", "date", "assoc"]
renw_number = []
renw_name = []
renw_date = []
renw_assoc = []
# 作業開始
files.each do |fn|
  # 元ファイル名を変数に格納する。
  orgn = File.basename(fn, ".*")
  # 空行削除するなどテキストの体裁を整えて上書き保存する。
  File.open("#{ fn }", "r") do |f|
    i = f.read
    # 行末の改行を削除
    i.chomp!
    # 空行を削除
    i.gsub!(/^\n/, "")
    # txtoのメソッドでテキストを整理
    i.clean_char!
    # 年月日の記述を統一
    i.gsub!(/0(?=\d[年月日])/, '')
    # CSV化するためにテキストを調整
    i.gsub!(pattern1, ",")
    i.gsub!(pattern2, ",")
    i.gsub!(pattern3, ",")
    # 上書き保存。
    File.open("#{ fn }", "w") { |f| f.puts i }
  end
  # 配列にするために正規表現で内容を整理する。
  File.open("#{ fn }", "r") do |f|
    # ファイルの内容を配列に格納する。
    f.each_line { |l| lines << l.split(",") }
    # CSVに変換する。
    csv = CSV.generate('', write_headers: true, headers: my_headers) do |c|
      lines.each do |i| c << i
      end
    end
    File.open("#{ orgn }.csv", 'w+') { |f| f.puts csv }
    # CSVから列を抽出してよしなに内容を変更していく。
    table = CSV.table("#{ orgn }.csv", headers: :first_row)
    table[:number].each { |i| renw_number << "【会員番号 #{ i.to_i }】" }
    table[:name].each { |i| renw_name << "#{ i.to_s }氏" }
    table[:date].each { |i| renw_date << "▼#{ i.to_s }付" }
    table[:assoc].each { |i|
      unless i == nil
        renw_assoc << "　#{ i.to_s }弁護士会"
      else
        renw_assoc << ""
      end
    }
  end
  contents = [renw_name, renw_number, renw_date, renw_assoc].transpose
  renw_csv = CSV.generate() do |csv|
    contents.each { |i| csv << i }
  end
  # CSVファイルに上書きして保存する。
  File.open("#{ orgn }.csv", 'w+') do |file|
    file.puts renw_csv
  end
end


exit
# CSVを生成する。
# ヘッダーを生成する。
renew_header = ["daytime", "credit", "contents", "require"]
# まずは、コラムのカテゴリーごとに配列に収集して行の状態になっている内容を組み込む。
contents = [daytime_col, credit_col, content_col, require_col]
# 二次配列の列と行を入れ替えて本来の状態にする。
trsp_arr = contents.transpose
# ヘッダーと内容をCSVとして生成する。
renew_csv = CSV.generate('', write_headers: true, headers: renew_header) do |csv|
  trsp_arr.each { |i| csv << i }
end
