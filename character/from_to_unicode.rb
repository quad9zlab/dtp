require 'highline'

### 入力した文字を16・2進数に変換して表示するコード
hl = HighLine.new
### 16・2進数の変換部分
trans = ->(i){ i.to_s(16) }
# trans = ->(i){ i.to_s(2) }
### HighLine Gemで入力を促し、入力した文字を変換する実行部分。
unicodes = hl.ask("ユニコード名を知りたい文字を入力してください。",
                  ->(str){ str.codepoints.map &trans })
puts "ユニコードの番号は => #{ unicodes }"
