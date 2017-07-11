require "./iString"
require "pp"

fn = Dir.glob("*.txt").shift
File.open(fn, "r") do |f|
  renw_arr = []
  f.each_line do |l|
    l.clean_char!
    l.empty_line!
    renw_arr << l
  end
  File.open("wform.txt", "w+") { |nf| nf.puts renw_arr }
end


exit
