# coding: utf-8

def txt2yml(ext)
  # ファイルの読み込み（一行）
  files = Dir.glob("*.#{ ext }")
  files.each do |f|
    File.open("#{ f }") do |finst|
      ins = finst.read
      ## テキストを整える。イレギュラーを処理する。
      # 空行を削除。
      ins.gsub!(/^$\n/, '')
      # 2つ以上あるスペースを一つにする。
      ins.gsub!(/  ?/, ' ')
      # 会員番号の先頭の「0（ゼロ）」を削除。
      ins.gsub!(/0(?=\d{5})/, '')
      # キーの後ろに全角スペースが来た場合の対処
      ins.gsub!(/([事務所名称]+|[郵便番号]+|[住所]+\d|[電話番号]+1|[FAX番号]+1)[　 ][　 ]?/, '\1 ')
      # 氏名を「苗字+全角スペース+名前」で揃える。
      ins.gsub!(/(?<=\d{5} )([^\t\r\n]{1,3}) ([^\t\r\n]{1,3})(?=（)/, '\1　\2')
      # 読みがなを「氏名+全角スペース+名前」で揃え、囲っている「()（カッコ）」を削除。
      ins.gsub!(/（(\p{Hiragana}+)[ |　](\p{Hiragana}+)）/, ' \1　\2')
      # 日時の不要な「0（ゼロ）」を削除。
      ins.gsub!(/(?<=年|月)0(?=\d[月|日])/, '')

      ## キーになるテキストをそれぞれ修正する。
      ins.gsub!(/^[郵便番号]+/, "  address:\n    pcode:")
      ins.gsub!(/^[事務所名称]+/, "  office:")
      ins.gsub!(/^[住所]+1/, "    zip1:")
      ins.gsub!(/^[住所]+2/, "    zip2:")
      ins.gsub!(/^[電話番号]+1/, "  contact:\n    tel:")
      ins.gsub!(/^[FAX番号]+1/, "    fax:")
      ins.gsub!(/^\d{5}.+$/).each do |str|
        arr = str.split(' ')
        "#{ arr[0] }:\n  name: #{ arr[1] }\n  ruby: #{ arr[2] }\n  date: #{ arr[3] }"
      end
  
      # txtをymlに別名保存するための下準備
      file = File.basename(f, ".*")
      # 修正を終えたインスタンスをファイルに書き込む。
      File.open("#{ file }.yml", 'w+') do |finst|
        finst.write(ins)
      end
    end
  end
end
