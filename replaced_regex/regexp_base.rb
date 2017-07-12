require "../lib/iString"
require "pp"

fn = Dir.glob("*.txt").shift
orgfn = File.basename(fn, ".*")
ns = File.open(fn).read.clean_char!.empty_line!

File.open(fn, "r") do |f|
  rf = f.read.empty_line!.clean_char!
  File.open("#{ orgfn }_formed.txt", "w+") { |doc| doc.puts rf }
end

exit
