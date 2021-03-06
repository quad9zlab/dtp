require "nkf"

class String

  def clean_char!
    #=> 全角の「！」から「｝」までの連続した文字のうち
    #   「，（全角コンマ）」「．（全角ピリオド）」は除いて、半角に変換する。
    self.tr!("\uFF01-\uFF0B", "\u0021-\u002B")  #=> 「！」から「＋」
    self.tr!("\uFF0D", "\u002D")                #=> 「－」
    self.tr!("\uFF0F-\uFF5D", "\u002F-\u007D")  #=> 「／」から「｝」
    # 上記の中から、一部の文字を全角に再変換する。
    self.tr!("!()?[]", "！（）？［］")
    # 行頭行末の不要な全角・半角スペースとタブを除去する。
    self.gsub!(/^[[:blank:]]+|[[:blank:]]+$/, "")
    # 数値の桁区切りが全角であれば、半角に変換する。
    self.gsub!(/(?<=\d)，(?=\d{3})/,'\1,\2')
    # 数字の桁区切りを変換してから、読点、句点を変換する。
    self.tr!("，", "、")
    self.tr!("．", "。") unless self =~ /(?<=\w)．/
    # 時間表示。時間と分を区切る記号を全角に変換する。
    self.gsub!(/(?<!\d|\.)(\d{1,2})(?!\d|,|\.):(?<!\d|\.)(\d{2})(?!\d|,|\.)/, '\1：\2')
    self
    # #### NKFが効かない!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # #### nkfで文字列の変換
    # ## オプション
    # ## 『-w』
    # # UTF-8で出力するオプション
    # ## 『-m0』
    # # MIME decode/encodeのためのオプション。
    # # nkf はデフォルトでMIME encoded-wordのデコードを試みるため、
    # # この動作を望まない場合は-m0を指定する。
    # ## 『-X』
    # # -Xを指定すると、nkfは半角カタカナを自動的に全角カタカナに変換する。
    # # この動作を望まない場合は-xを指定する。
    # # NKF.nkf("-wXm0", self)
  end

  def empty_line!
    self.gsub!(/^\n/, "")
  end

  # 氏名を5文字で整理する。
  def namaezoroe!
    sei_mei = self.split("　")
    sei = sei_mei[0]
    mei = sei_mei[1]
    sei_s = sei_mei[0].size
    mei_s = sei_mei[1].size
    if sei_s >= 3 && mei_s >= 2 || sei_s >= 2 && mei_s >= 3
      "#{ sei }#{ mei }"
    elsif sei_s == 1 && mei_s == 2 || sei_s == 2 && mei_s == 1
      "#{ sei }\u3000\u3000#{ mei }"
    else
      "#{ sei }\u3000#{ mei }"
    end
  end

end
