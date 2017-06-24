require 'csv'
require 'roo'

# カレントディレクトリにあるExcelファイルの読み込みをする。
msexcels = Dir.glob("*.xlsx")
# ExcelファイルをCSVファイルに変換して保存する。(ファイルが単一か複数かは問わない。)
msexcels.each do |msxls|
  # 読み込んだファイルの拡張子より前の名前をオブジェクト化する。
  origin_name = File.basename(msxls, ".*")
  # Excelx to CSV file out
  Roo::Excelx.new("#{ origin_name }.xlsx").to_csv("#{ origin_name }.csv")
  # ここからはcsvの世界
  table = CSV.table("#{ origin_name }.csv", headers: :first_row)
  # 配列で初期化する。
  han = []
  rub = []
  form = []
  table.headers.each do |h|
    # セル内の改行を取り去る
    table[h].each do |cell|
      cell.gsub!(/\n/, '▼') if cell.class == String
      table[h] << "#{ cell }"
    end
    if h == :name
      # to csv coloumn 'name' and 'ruby'
      table[h].each do |cell|
        han << cell.split(/　/)
      end
    elsif h == :ruby
      table[h].each do |cell|
        rub << cell.split(/　/)
      end
    end
  end
  name = [han, rub].transpose
  name.size.times do |n|
    fn =      name[n][0][0]  #first name
    fn_ruby = name[n][1][0]  #first name ruby
    ln =      name[n][0][1]  #last name
    ln_ruby = name[n][1][1]  #last name ruby
    first_name = fn + "/" + fn_ruby
    last_name  = ln + "/" + ln_ruby
    fn_s = fn.size
    ln_s = ln.size
    if fn_s >= 3 && ln_s >= 2 || fn_s >= 2 && ln_s >= 3
      form << "[#{ first_name }][#{ last_name }]"
    elsif fn_s == 1 && ln_s == 2 || fn_s == 2 && ln_s == 1
      form << "[#{ first_name }]　　[#{ last_name }]"
    else
      form << "[#{ first_name }]　[#{ last_name }]"
    end
  end
  # CSVを生成する。
  ## ヘッダーを生成する。
  renew_header = ["name", "ruby", "form", "post", "class", "before_post", "after_before_post", "greet", "@photo"]
  # まずは、コラムのカテゴリーごとに配列に収集して行の状態になっている内容を組み込む。
  cells = [table[:name], table[:ruby], form, table[:post], table[:class], table[:before_post], table[:after_before_post], table[:greet], table[:@photo]]
  # 二次配列の列と行を入れ替えて本来の状態にする。
  trsp_arr = cells.transpose
  # ヘッダーと内容をCSVとして生成する。
  renew_csv = CSV.generate('', write_headers: true, headers: renew_header) do |csv|
    trsp_arr.each { |i| csv << i }
  end
  # CSVファイルに上書きして保存する。
  File.open("#{ origin_name }_formed.csv", 'w+') do |file|
    file.puts renew_csv
  end
end

exit

# 前提条件
# 間に全角スペースを0個入れる
# 3文字以上　＋　2文字以上
# 2文字以上　＋　3文字以上
#
# 間に全角スペースを2個入れる
# 1文字　＋　2文字
# 2文字　＋　1文字
#
# 間に全角スペースを1個入れる（上記2つの条件以外つまり　else）
# 2文字　＋　2文字
# 1文字　＋　3文字
# 3文字　＋　1文字
