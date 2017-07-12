require "../lib/iString"
require "pp"

fn = Dir.glob("*.txt").shift
File.open(fn, "r") do |f|
  renewalf = f.read.empty_line!.clean_char!
  File.open("wform.txt", "w+") { |nf| nf.puts renewalf }
end


exit

fn = Dir.glob("*.txt").shift
File.open(fn, "r") do |f|
  renw_arr = []
  f.each_line do |l|
    l.clean_char!
    l.empty_line!
    renw_arr << l
    f.puts renw_arr
  end

end
