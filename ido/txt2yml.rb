# coding: utf-8
require "../lib/txto"

class Array
  def txt2yml
    # ファイル毎に処理をする。
    self.each do |fn|
      # 元ファイル名を変数に格納する。
      orgfn = File.basename(fn, ".*")
      # YAMLファイルを新規作成して、テキストの内容を整理して保存する。
      File.open("#{ fn }", "r") do |f|
        i = f.read
        # 空行を削除する。
        i.gsub!(/^\n/, "")
        # txtoのメソッドでテキストを整理する。
        i.clean_char!
        # 年月日の記述、体裁を合わせるために付けている不要な0を取り去る。
        i.gsub!(/0(?=\d[年月日])/, '')
        # 会員番号を5桁にする。不要な先頭の0を取り去る。
        i.gsub!(/^0(?=\d{5})/, '')
        # ymlファイルに格納する内容を配列で初期化する。
        trans_yml = []
        # ファイルの内容を配列に変換する。
        i.each_line do |l|
          # 数字から始まるラインの処理と配列化して置き換える。
          if l =~ /^\d/
            # 正規表現パターン『先頭の5つの数字列と直後の空白』
            l.gsub!(/(?<=\d{5})[[:blank:]]+/, ","+"  name: ")
            # 正規表現パターン『括弧に囲まれたふりがなと直後の空白』
            l.gsub!(/（(.+?)）[[:blank:]]+/, ","+"  ruby: "+'\1'+","+"  date: ")
            l.chomp!
            l = l.split(",")
          # それ以外のラインの処理。
          else
            l.gsub!(/事務所名称[[:blank:]]+|事務所名称/, "  office: ")
            l.gsub!(/郵便番号[[:blank:]]+|郵便番号/, "  zipcode: ")
            l.gsub!(/住所1[[:blank:]]+|住所1/, "  zip1: ")
            l.gsub!(/住所2[[:blank:]]+|住所2/, "  zip2: ")
            l.gsub!(/電話番号1[[:blank:]]+|電話番号1/, "  tel: ")
            l.gsub!(/FAX番号1[[:blank:]]+|FAX番号1/, "  fax: ")
            l.chomp!
          end
          # 一行毎に変換用の配列に読み込ませる。
          trans_yml << l
        end
        # yamlファイルを新規で作成し、配列の内容を書き込む。
        File.open("#{ orgfn }.yml", "w") { |f| f.puts trans_yml.flatten! }
      end
    end
  end
end
