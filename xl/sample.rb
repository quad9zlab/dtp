# require "nkf"
require "../lib/iString"

str = "１３()[]ｱｲｳｴｵｶﾞｷﾞｸﾞｹﾞｺﾞﾊﾟﾋﾟﾌﾟﾍﾟﾎﾟ"
# str = NKF.nkf("-wXm0", str)
str.clean_char!
File.open("formed.txt", "w") do |f|
  f.puts str
end
