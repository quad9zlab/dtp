# coding: utf-8
require 'yaml'
require 'pp'
require 'csv'
require '../lib/iString'
require '../lib/iArray'
require '../lib/iHash'

files = Dir.glob("*.txt")
files.txt2yml
yamls = Dir.glob("*.yml")
form = []
yamls.each do |y|
  orgfn = File.basename(y, ".yml")
  member_info = YAML.load_file(y)
  # name_ruby = member_info.rubyfuri
  p member_info.photonawa
  # member_info.each do |k, v|
  #   form << [name_ruby.shift,
  #            k,
  #            v["date"],
  #            v["office"],
  #            v["pcode"],
  #            v["zip1"],
  #            v["zip2"],
  #            v["tel"],
  #            v["fax"],
  #           ]  # photo_name.shift
  # end
  # # CSV用にヘッダーを入れた配列を下準備する。
  # my_headers = %w[name_ruby id date office pcode zip1 zip2 tel fax @psd]
  # # CSV用にインスタンスを作成。
  # contents = CSV.generate("", :headers => my_headers, :write_headers => true) do |csv|
  #   form.each { |i| csv << i }
  # end
  # # CSVファイルとして書き込む。
  # File.open("#{ orgfn }.csv", 'w+:UTF-16:UTF-8') do |f|
  #   f.puts contents
  # end
end

exit
