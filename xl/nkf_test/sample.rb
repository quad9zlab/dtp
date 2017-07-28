require "./MyString"

str = "１２３４５ＡＢＣＤＥＦ\n(英数のパーレン)\n[英数のブラケット]\nｱｲｳｴｵｶﾞｷﾞｸﾞｹﾞｺﾞﾊﾟﾋﾟﾌﾟﾍﾟﾎﾟ"
str.clean_char!        #=> 半角カナが変換出来ない。
str = str.clean_char!  #=> 変数に代入して半角カナが変換出来る。
File.open("formed.txt", "w") do |f|
  f.puts str
end
