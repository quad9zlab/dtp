require 'fileutils'
require 'nkf'
require "../lib/iString"

# Dirクラスのメソッドglob版
def traverse(path)
  Dir.glob(["#{path}/**/*"]).each do |fp|
    unless File.directory?(fp)
      form_filename(fp) if /.+(jpg|jpeg|png|doc|docx|xls|xlsx|ppt|pptx|pdf|txt)$/i =~ fp
    end
  end
end

def form_filename(fp)
  # ファイル名をディレクトリとファイル名に分ける。
  dir_name, base_name = File.split(fp)
  # 抽出したファイル名を標準のテキスト整理。
  extract_fn = "#{dir_name}_#{base_name}".clean_char!
  # ファイル名でよくあるパターンを自分の好きな様に変更する。
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
  File.rename("#{dir_name}/#{base_name}", "#{extract_fn}")
end
# ターミナルに「ruby traverse .」を入力で作業開始
traverse(ARGV[0])
