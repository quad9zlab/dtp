# coding: utf-8

# 冊子のページネーションのためのコード
# 四折、八折、十六折での区切りのページ数を得るて配列で返す。
# 引数は、開始ページ数 = from,
#        最終ページ数 = max,
#              折数 = ori
# ruby multiple.rb from max ori
#
arg = ARGV

from = arg[0].to_i
max  = arg[1].to_i
ori  = arg[2].to_i
to   = max/ori
pages = []

if from < 0
  1.upto(to) do |n|
    pagenum = (from + n * ori)
    pages << pagenum if pagenum <= max
  end
else
  1.upto(to) do |n|
    pagenum = (from + n * ori) - 1
    pages << pagenum if pagenum <= max
  end
end

p pages

exit

# obj.upto(max){|変数|
#   実行する処理1
#   実行する処理2
# }
