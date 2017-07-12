require "csv"
require "../lib/iString"
require "../lib/iArray"

# ディレクトリ内のテキストファイルを抽出
files = Dir.glob("*.txt")
# 変数の定義
lines = []
pattern1 = /(?<=\d{6})[[:blank:]]+/
pattern2 = /[[:blank:]]+(?=平成)/
pattern3 = /(?<=平成[\d{1}|\d{2}]年[\d{1}|\d{2}]月[\d{1}|\d{2}]日)[[:blank:]]+/
pattern3 = /(?<=[\d{1}|\d{2}]日)[[:blank:]]+/
my_headers = ["number", "name", "date", "assoc"]
renw_number = []
renw_name = []
renw_date = []
renw_assoc = []
# 作業開始
files.each do |fn|
  # 元ファイル名を変数に格納する。
  orgfn = File.basename(fn, ".*")
  # 空行削除するなどテキストの体裁を整えて上書き保存する。
  File.open("#{ fn }", "r") do |f|
    i = f.read
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
    # 元のファイルに上書き保存。
    File.open("#{ fn }", "w") { |f| f.puts i }
  end
  # 配列にするために正規表現で内容を整理する。
  File.open("#{ fn }", "r") do |f|
    # ファイルの内容を配列に格納する。
    f.each_line do |l|
      # 行末の改行を削除
      l.chomp!
      # CSV化するための下準備。配列に変換する。
      lines << l.split(",")
    end
    # CSVに変換する。
    csv = CSV.generate('', write_headers: true, headers: my_headers) do |c|
      lines.each { |i| c << i }
    end
    File.open("#{ orgfn }.csv", 'w+') { |f| f.puts csv }
    # CSVから列を抽出してよしなに内容を変更していく。
    table = CSV.table("#{ orgfn }.csv", headers: :first_row)
    table[:number].each { |i| renw_number << "【会員番号 #{ i.to_i }】" }
    table[:name].each { |i| renw_name << "#{ i.to_s.namaezoroe! }氏" }
    table[:date].each { |i| renw_date << "▼#{ i.to_s }付" }
    table[:assoc].each do |i|
      unless i == nil
        renw_assoc << "　#{ i.to_s }弁護士会"
      else
        renw_assoc << nil
      end
    end
  end
  contents = [renw_name, renw_number, renw_date, renw_assoc].transpose
  renw_csv = CSV.generate() do |csv|
    contents.each { |i| csv << i }
  end
  # CSVファイルに上書きして保存する。
  File.open("#{ orgfn }.csv", 'w+') do |file|
    file.puts renw_csv
  end
end
