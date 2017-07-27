require 'csv'
require 'roo'
require "../lib/iString"

class Array

  # ==========
  # テキストをYAMLファイルとして書き出すメソッド
  # ただし、このコードは『ido.rb』に特化しているので汎用的には使えない。
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
            # 先頭のIDをキーにする。
            l.sub!(/(\d{5})/, '\1' + ":")
            # 正規表現パターン『先頭の5つの数字列と直後の空白』
            l.gsub!(/(?<=\d{5}:)[[:blank:]]+/, "," + "  name: ")
            # 正規表現パターン『括弧に囲まれたふりがなと直後の空白』
            l.gsub!(/（(.+?)）[[:blank:]]+/, "," + "  ruby: " + '\1' + "," + "  date: ")
            l.chomp!
            l = l.split(",")
          # それ以外のラインの処理。
          else
            l.gsub!(/事務所名称[[:blank:]]+|事務所名称/, "  office: ")
            l.gsub!(/郵便番号[[:blank:]]+|郵便番号/, "  pcode: ")
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

  # ==========
  # 読み込んだエクセルファイルの内容を正規表現で整理、セル内改行を調整して
  # CSVファイルとして書き出すメソッド
  def xlseiri
    renw_row = []
    # ExcelファイルをCSVファイルに変換して保存する。(ファイルが単一か複数かは問わない。)
    self.each do |xl|
      # 読み込んだファイルの拡張子より前の名前をオブジェクト化する。
      origin_name = File.basename(xl, ".*")
      # Excelx to CSV file out
      Roo::Excelx.new("#{ origin_name }.xlsx").to_csv("#{ origin_name }.csv")
      # ここからはcsvの世界
      table = CSV.table("#{ origin_name }.csv", headers: :first_row)
      table.headers.each do |h|
        # # セル内の改行を取り去る
        table[h].each do |cell|
          if cell.class == String
            cell.gsub!(/\n/, '▼')
            cell.clean_char!
          end
          table[h] << cell
        end
      end
      File.open("#{ origin_name }.csv", 'w+') do |file|
        file.puts table
      end
    end
  end
end
