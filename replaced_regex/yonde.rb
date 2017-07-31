# ==========
# 以下のファイル「doc, docx, xls, xlsx, ppt, pptx, rtf, pdf」の
# 中身を任意の整形機能を付与してからテキストに書き出すコード
# ==========

require "yomu"
require "../lib/iString"

# $ruby yomu.rb [ext（ドッドは要らない、拡張子だけ）]
# ext =>doc, docx, xls, xlsx, ppt, pptx, rtf, pdf

## 初期化
# 第一引数を拡張子としてインスタンス化する。
ext = ARGV[0]
# 拡張子によって選択する。
Dir.glob("*.#{ ext }").each do |fn|
  # テキスト書き出し時のファイル名としてベースネームを変数に確保する。
  orgfn = File.basename(fn, ".#{ ext }")
  # YomuGemを使ってファイルをインタンス化する。
  yomu = Yomu.new "#{ fn }"
  # 主戦場。書類によって空行を生かすか取るかを変えて処理する。
  case ext
  when /docx?|rtf/
    rf = yomu.text.clean_char!
  when /pdf|xlsx?|pptx?/
    rf = yomu.text.clean_char!.empty_line!
  end

  # 別名でテキストファイルとして書き出しをする。
  File.open("#{ orgfn }_formed.txt", "w+") { |doc| doc.puts rf }
end

exit
