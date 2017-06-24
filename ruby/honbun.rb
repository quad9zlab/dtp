txt = Dir.glob("*.txt")
txt.each do |t|
  origin_name = File.basename(t, ".*")
  File.open("#{ origin_name }.txt", "r") do |f|
    renew_t = f.read.gsub!(/(\p{Han}+)/) { "[#{ $1 }/]" }
    File.open("#{ origin_name }_formed.txt", "w") { |f| f.puts renew_t }
  end
end
