require 'highline'

hl = HighLine.new
order = []
lambda_obj = ->(pnum) {
  i = pnum.to_i
  m = i / 4
  if i >= 4 && (i % 4).zero?
    [*1..i].zip([2, 0, 1, -3] * m) { |row| order << row[0] + row[1] }
    p order
  else
    p "4P以上か、4の倍数になるページ数でPDFを作成して入力をやり直してください。。"
  end
}
ins = hl.ask("4折の面付です。配置するPDFのページ数を入力してください。", lambda_obj)



exit

#### Old Version
# 左・平綴じで配置するPDFのページ順を作成するコード
# 初期化
dai = 6                            #=> 折
pglength = dai * 2                 #=> 面付けするページの総数
pattern = [3, 2, 4, 1]             #=> 4折平綴じパターンの元をフォーマットとする
plpp_hira = []                     #=> "plpp"とは"Place PDF Page"の意

# 配置するPDFのページ順を作成する。
(dai).times do |n|
  if n == 0
    plpp_hira << pattern
  else
    plpp_hira << plpp_hira[0].map { |i| i + (4 * n) }
  end
end

p plpp_hira  # .flatten            #=>一次配列にするオプション


# 左・中綴じで配置するPDFのページ順を作成するコード
# 初期化
dai = 6                            #=> 折
pdflength = dai * 4                #=> PDFの総ページ数
pattern = (1..pdflength / 2).to_a  #=> 4折中綴じパターンの元をフォーマットとする
                                   #=> 対向頁のページ数の配列
CONST = pdflength + 1              #=> 定数
pair = []                          #=> 対になる頁の配列を初期化
plpp_naka = []                     #=> "plpp"とは"Place PDF Page"の意

# 配置するPDFのページ順を作成する。
pattern.map { |a| pair << CONST - a }
pattern.zip(pair).each_slice 2 do |a, b|
  plpp_naka << [a, b].flatten
end

p plpp_naka  # .flatten            #=>一次配列にするオプション

exit

# 最初のヒントになったコード
plpp = [1, 2, 3, 4, 5];
plpp.length.times do |n|
  p plpp.shift
  p plpp
end
