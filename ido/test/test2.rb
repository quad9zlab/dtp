File.open("会員異動平成29年6月分その他.txt", "r") do |f|
  inst = f.read.gsub!(/^\n/, "")
  File.open("sample.txt", "w") { |f| f.puts inst }
end
