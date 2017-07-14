# coding: utf-8
# traverse.rb

require 'fileutils'
require 'nkf'

# Dirクラスのメソッドglob版
def traverse(path)
  Dir.glob(["#{path}/**/*"]).each do |fp|
    unless File.directory?(fp)
      form_filename(fp) if /.+(jpg|jpeg|png|doc|docx|xls|xlsx|ppt|pptx|pdf)$/i =~ fp
    end
  end
end

# jpg|jpeg doc|docx
# ファイル名を更新後に格納するディレクトリを作成
# Dir.mkdir("process_files")
# save_dir = FileUtils.mkdir_p("/Users/quad9/process_files")

# require 'fileutils', FileUtils.mkdir_p("process_files")
# ex) FileUtils.mkdir_p("/Users/User_name/optional/classes/etc")
# FileUtilsを使うと任意の階層に深さを持ったディレクトリを作成することができる。

def form_filename(fp)
  dir_name, base_name = File.split(fp)
  # # ファイル名を抽出
  # base_name = File.basename(fp)
  #
  # # 相対パスを伴ったディレクトリ名の抽出
  # dir_name = File.dirname(fp)
  #
  # 抽出したファイル名
  extract_fn = "#{dir_name}_#{base_name}"

  # ファイル名の丸数字を変換
  extract_fn.tr!("①②③④⑤⑥⑦⑧⑨", "1-9")

  # ファイル名のwinの数字を変換
  extract_fn.tr!("㈰㈪㈫㈬㈭㈮㈯", "1-7")

  # カレントディレクトリ「.」を「doc」に変換
  extract_fn.gsub!(/^\./, "doc")

  # Pathのつなぎ「/」をアンダーバー「_」に変更
  extract_fn.gsub!(/\//, "_")

  # 拡張子を「jpg」標記に統一
  extract_fn.gsub!(/(jpg|jpeg)$/i, "jpg")

  # 1バイト仮名を2バイトに変換
  extract_fn = NKF.nkf("-w -Xm0", extract_fn)

  # 全角数字を半角に変換
  extract_fn.tr!("０-９", "0-9")

  # 全角英字を半角（大文字）に変換
  extract_fn.tr!("Ａ-Ｚ", "A-Z")

  # 全角英字を半角（小文字）に変換
  extract_fn.tr!("ａ-ｚ", "a-z")

  # 半角のカッコ等を全角に変換
  extract_fn.tr!("()[];:", "（）［］；：")

  File.rename("#{dir_name}/#{base_name}", "#{extract_fn}")

end

# ターミナルに「ruby traverse .」を入力で作業開始
traverse(ARGV[0])

# FileUtils.mkdir_p("process/tmp")
# File.rename("111.txt", "process/tmp/222.txt")



# # 再開発版
# def traverse(path)
#   if File.directory?(path)
#     dir = Dir.open(path)
#     while name = dir.read
#       next if name == "."
#       next if name == ".."
#       next if name == ".DS_Store"
#       traverse(path + "/" + name)
#     end
#     dir.close
#   else
#     process_filename(path)
#   end
# end

# puts base_name.instance_of?(String)
# puts dir_name.instance_of?(String)
# puts extract_fn.instance_of?(String)




# words
# extract/ɪkstrǽkt 抽出する
