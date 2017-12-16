require "csv"


str = "(1,a),(1,d),(2,m),(2,e),(2,k),(3,f),(3,m),(4,a)"
arr = []
headers = ["pagenum", "content"]

str.gsub!(/\((.+?)\)/, '\1').split(',').each_slice 2 { |a, b| arr << [a,b] }
CSV.open("formed.csv", "w", write_headers: true, headers: headers) do |f|
  arr.each { |a| f << a }
end

hash = Hash.new { |h,k| h[k] = [] }
CSV.table("formed.csv").each { |t| hash[t[:pagenum]] << t[:content] }
hash.each do |key, arr|
  puts "#{ key }\t#{ arr.join(',') }"
end

exit



# 集計するスクリプトはこんな感じ
# #!/usr/bin/env ruby
# require "csv"
# hash = Hash.new {|h,k| h[k]=[]}
# CSV.read("a.txt",:col_sep => "\t").each do |x, y|
# hash[x] << y
# end
# hash.each do |key,ar|
# puts "#{key}\t#{ar.join(',')}"
# end
#
# 結果：
# 1	a,d
# 2	m,e,k
# 3	t,m
# 4	a

# text = table[:pagenum].zip(table[:content]).flatten.uniq.join("\n")
# File.open("formed.txt", "w") { |f| f.puts text }
