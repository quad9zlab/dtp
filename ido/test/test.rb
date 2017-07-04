# coding: utf-8
require "csv"
require "../../lib/txto"

files = Dir.glob("*.txt")
lines = []
renew_lines = []
pattern1 = /(?<=\d{6})[[:blank:]]+/
pattern2 = /[[:blank:]]+(?=平成)/
pattern3 = /(?<=平成\d\d年\d\d月\d\d日)[[:blank:]]+/
my_headers = ["number", "name", "date", "assoc"]
files.each do |fn|
  orgn = File.basename(fn, ".*")
  File.open("#{ fn }", "r") do |f|
    f.each_line do |l|
      l.clean_char!
      l.gsub!(pattern1, ",")
      l.gsub!(pattern2, ",")
      l.gsub!(pattern3, ",") if l =~ pattern3
      lines << l
    end
    lines.each { |l| renew_lines << l.split(",") }
    csv_string = CSV.generate('', write_headers: true, headers: my_headers) do |csv|
      renew_lines.each do |i| csv << i
      end
    end
    File.open("#{ orgn }.csv", 'w+') { |f| f.puts csv_string }
    table = CSV.table("#{ orgn }.csv", headers: :first_row)
    p table.class
    p table[:number]
    p table[:name]
    p table[:date]
    p table[:assoc]
  end

end

exit
