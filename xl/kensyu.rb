require 'csv'
require 'roo'
require '../lib/iArray'

# 下準備
# エクセルファイルからCSVファイルを生成する。
Dir.glob("*.xlsx").xlseiri
# 対象は1ファイルなので、先頭のファイルを配列から抜き出す。
csv = Dir.glob("*.csv").shift
# CSVファイルを読み込む。
orgfn = File.basename(csv, ".*")
# 一行目をヘッダーとして、CSVクラスのテーブルオブジェクトにする。
table = CSV.table(csv, headers: :first_row)
# 別名で書き込むCSVのcoloumnを配列で初期化する。
daytime_col = []; credit_col  = []; content_col = []; require_col = [];

# 本番。再生産するCSVファイルのコラムの中身を生成する。
# => daytime_col
table[:kind].zip(table[:consult], table[:month], table[:day], table[:time]) do |kind, consult, month, day, time|
  daytime = "【#{ kind }】【#{ consult }】▼#{ month }#{ day }▼#{ time }"
  # 文字列の検索置換
  daytime.gsub!(/(\d\d?)月(\d\d?)日（(月|火|水|木|金|土|日)）/,'\1/\2\3')
  # daytimeコラムに配列を書き込んでいく。
  daytime_col << daytime
end
# => credit_col
credit_col = table[:credit]
# => content_col
table[:content].zip(table[:speaker]) do |content, speaker|
  # 文字列の検索置換
  speaker = speaker.to_s
  speaker.gsub!(/▼/, '、')
  speaker.gsub!(/^/, '◇')
  # content_colコラムに配列を書き込んでいく。
  content_col << "#{ content }▼#{ speaker }"
end

# => require_col
table[:committe].zip(table[:requ], table[:charge], table[:nursery], table[:place]) do |committe, requ, charge, nursery, place|
  # 文字列の検索置換
  committe.to_s.gsub!(/^/, '◆')   # ピクトグラムに置換えるための記号を行頭に挿入する。
  committe.to_s.gsub!(/▼/, '●')  # 強制改行のマークを付与する。
  requ.to_s.gsub!(/^/, '□')       # ピクトグラムに置換えるための記号を行頭に挿入する。
  requ.to_s.gsub!(/▼/, '●')      # 強制改行のマークを付与する。
  charge.to_s.gsub!(/▼/, '●')    # 強制改行のマークを付与する。
  place.to_s.gsub!(/^/, '■')      # ピクトグラムに置換えるための記号を行頭に挿入する。
  # 保育の有り無しで文字列を変更する。
  if nursery =~ /○/
    require_col << "#{ committe }▼#{ requ }／#{ charge }▼保育あり▼#{ place }"
   else
    require_col << "#{ committe }▼#{ requ }／#{ charge }▼#{ place }"
  end
end

# CSVを生成する。
# ヘッダーを生成する。
renew_header = ["daytime", "credit", "contents", "require"]
# まずは、コラムのカテゴリーごとに配列に収集して行の状態になっている内容を組み込む。
contents = [daytime_col, credit_col, content_col, require_col]
# 二次配列の列と行を入れ替えて本来の状態にする。
trsp_arr = contents.transpose
# ヘッダーと内容をCSVとして生成する。
renew_csv = CSV.generate('', write_headers: true, headers: renew_header) do |csv|
  trsp_arr.each { |i| csv << i }
end
# CSVファイルに上書きして保存する。
File.open("#{ orgfn }.csv", 'w+') do |file|
  file.puts renew_csv
end

exit

# -----------------------------------------------------------------------

# 列のインデックスの覚え書き
# table[:month] # 開催月
# table[:day] # 開催日
# table[:time] # 開催時間
# table[:live_or_dvd] # 開催形態
# table[:for_hour] # 研修所要時間
# table[:kind] # 種別
# table[:credit] # 単位
# table[:place] # 開催場所
# table[:content] # 内容
# table[:speaker] # 講演者
# table[:committe] # 主催委員会
# table[:charge] # 料金
# table[:requ] # 参加資格
# table[:nursery] # 保育室の利用の有無
# table[:consult] # 専門相談研修
