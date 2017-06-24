# coding: utf-8
# 以下のファイル「doc, docx, xls, xlsx, ppt, pptx, rtf, pdf」の
# 中身を任意の整形機能を付与してからテキストに書き出すコード

require "yomu"
require "../../rblib/txto"

# $bundle exec ruby yomu.rb [ext（ドッドは要らない、拡張子だけ）]
# ext =>doc, docx, xls, xlsx, ppt, pptx, rtf, pdf

## 初期化
# 第一引数を拡張子としてインスタンス化する。
ext = ARGV[0]

# カレントディレクトリにある拡張子によって任意に選択された
# ファイルのインスタンスをeachで回す。
Dir.glob("*.#{ ext }").each do |fn|
  # テキスト書き出し時のファイル名としてベースネームをインスタンス化する。
  bn = File.basename(fn, ".#{ ext }")
  # Yomuでファイルをインスタンス化する。
  yins = Yomu.new "#{ fn }"
  # Textファイルとして書き込む。
  # いちいち変数に格納するのが気に入らない。
  File.open("#{ bn }.txt", "w+") do |file|
    yins.text.each_line do |line|
      case ext
      when /docx|rtf/
        # # インスタンスをlineに代入しないとNKFの変換が反映出来ない。
        # # そのため、下記2行のように書くか、
        # line = line.clean_copy!
        # file.puts line
        # # もしくは、1行で下記のように書く方法になる。
        file.puts line.clean_copy!
      when /pdf|xls|xlsx|ppt|pptx/
        line = line.clean_copy!
        # gsub!では、出来たインスタンスが何もしなくてもリターンされる。
        line.empty_line!
        file.puts line
      end
    end
  end
end


exit

# yomuを使ったyondeの原型。
# yomu
require 'yomu'

ext = ARGV[0]

Dir.glob("*.#{ ext }").each do |f|
  data = File.read("#{ f }")
  doc = Yomu.read :text, data
  # ファイルのベース名を付けた新規ファイルを作成
  base_name = File.basename(f, ".#{ ext }")
  renewal_f = f.gsub(/(.+)#{ ext }/, "\\1txt")
  FileUtils.cp(f, renewal_f)
  
  # 書き込み
  File.open("#{ renewal_f }", "w+") do |file|
    doc.each_line do |line|
      file << line
    end
  end
end



# 以下は他のgemを使うか検討段階の残骸。--------------------
require 'spreadsheet'
require 'parseexcel'

# $be ruby yonde.rb [拡張子]
# Excelから読み込む場合のサンプル

ext = ARGV[0]

Dir.glob("*.#{ ext }").each do |f|
  workbook = Spreadsheet::ParseExcel.parse(f)
  #Get the first worksheet
  worksheet = workbook.worksheet(0)
  
  #cycle over every row
  j = 0
  worksheet.each do |row|
    i = 0
    if row != nil
    #cycle over each cell in this row if it's not an empty row
      row.each do |cell|
        if cell != nil
          #Get the contents of the cell as a string
          #contents = cell.to_s('latin1')
          contents = cell.to_s('utf-8')
          puts "Row: #{ j } Cell: #{ i }> #{contents}"
        end
        i = i + 1
      end
    end
    j = j + 1
  end
end



# spreadsheet
require 'spreadsheet'

xls = Spreadsheet.open('tests.xls', 'rb') #Excelファイルの読み込み
sheet = xls.worksheet(0) #0番目つまり1番始めのsheetを読み込む

#読み込みの開始が'０'から始まる。
print sheet[0,1] #実際のExcelでは、1行目の2列目の値を読み込み
print "\n"

#行単位で読み込む事も出来ます。
row = sheet.row(2) #3行目のデータを読み込み
print row[2] #3行目の3列目のデータを読み込み
print "\n"
