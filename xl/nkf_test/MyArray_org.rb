require 'csv'
require 'roo'
require "./MyString"

class Array
  # ==========
  # 読み込んだエクセルファイルの内容を正規表現で整理、セル内改行を調整して
  # CSVファイルとして書き出すメソッド
  def xlseiri
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
          cell.gsub!(/\n/, '▼') if cell.class == String
          cell.clean_char! if cell.class == String
          table[h] << cell
        end
        File.open("#{ origin_name }.csv", 'w+') do |file|
          file.puts table
        end
      end
    end
  end
end


exit

########## Original Code
class Array
  # ==========
  # 読み込んだエクセルファイルの内容を正規表現で整理、セル内改行を調整して
  # CSVファイルとして書き出すメソッド
  def xlseiri
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
            table[h] << NKF.nkf("-wXm0", cell)
          end
        end
        File.open("#{ origin_name }.csv", 'w+') do |file|
          file.puts table
        end
      end
    end
  end
end
