# coding: utf-8
require 'yaml'
require 'pp'
require 'csv'
require '../lib/iString'
require '../lib/iArray'
require '../lib/iHash'

# ディレクトリ内の該当テキストファイルを収集する。
files = Dir.glob("*.txt")
# ido.rb用に調整したYAMLに変換する。
files.txt2yml
# ディレクトリ内の該当YAMLファイルを収集する。
yamls = Dir.glob("*.yml")
# 変数の初期化。形成したデータを配列に格納する。
form = []
# YAMLをIndesignデータ結合用のCSVに変換する。
yamls.each do |y|
  orgfn = File.basename(y, ".yml")
  member = YAML.load_file(y)
  # iHash#rubyfuriメソッド
  name_ruby = member.rubyfuri
  # iHash#rubyfuriメソッド
  photo_name = member.photonawa
  member.each do |k, v|
    form << [name_ruby.shift,
             k,
             v["date"],
             v["office"],
             v["pcode"],
             v["zip1"],
             v["zip2"],
             v["tel"],
             v["fax"],
             photo_name.shift
            ]
  end
  # CSV用にヘッダーを入れた配列を下準備する。
  my_headers = %w[name_ruby id date office pcode zip1 zip2 tel fax @photo_name]
  # CSV用にインスタンスを作成。
  contents = CSV.generate("", :headers => my_headers, :write_headers => true) do |csv|
    form.each { |i| csv << i }
  end
  # CSVファイルとして書き込む。
  File.open("#{ orgfn }.csv", "w+:UTF-16:UTF-8") do |f|
    f.puts contents
  end
end
