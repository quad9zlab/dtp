# coding: utf-8
require 'date'
require 'csv'

def this_month_cal(year, month)
  # 指定月の最初と最後の日を取得
  first_date = Date.new(year, month,1)
  last_date = Date.new(year, month,-1)

  # 指定月の日を配列にする
  p monthy_day = [*first_date.day..last_date.day]

  # 指定付きのwdayを取得し、その数だけゼロをmonthy_day配列の最初に挿入
  case first_date.wday
  when 1
    monthy_day.unshift(0)
  when 2
    monthy_day.unshift(0, 0)
  when 3
    monthy_day.unshift(0, 0, 0)
  when 4
    monthy_day.unshift(0, 0, 0, 0)
  when 5
    monthy_day.unshift(0, 0, 0, 0, 0)
  when 6
    monthy_day.unshift(0, 0, 0, 0, 0, 0)
  end

  # 一週間ごとに区切った二次配列にする。
  data = monthy_day.each_slice(7).to_a

  # CSVに書き込み
  CSV.open("this_month_cal.csv", "w") do |csv|
    data.each do |d|
      csv << d
    end
  end
end

this_month_cal(2016, 10)

exit

# html作成バージョン。他の方が作成したものコピー。参考にさせていただいた。
def make_calender(_year,_month)
  first_date = Date.new(_year,_month,1) #指定した月の1日をDateオブジェクトとして保存
  last_date = Date.new(_year,_month,-1) #指定した月の最終日をDateオブジェクトとして保存

  calender_size = last_date.day + first_date.wday - last_date.wday + 6 #テーブルのカラム数を保存

  calender = "" #この変数にtableの中身を追加していく
  calender << '<table>' + "\n"
  calender << "\t" + '<tr><td>日</td><td>月</td><td>火</td><td>水</td><td>木</td><td>金</td><td>土</td></tr>' + "\n"

  #n週目まである月はn回<tr>タグを出力
  (calender_size / 7).times do |n|
    calender << "\t" + '<tr>'
    #<td>タグを7回出力
    7.times do |i|
      cal_count = n*7 + i #cal_countは直後に出力する<td>タグが全カラムのうち何番目かを保存(0から開始)
      calender << '<td>'
      calender << (cal_count - first_date.wday + 1).to_s if first_date.wday <= cal_count && last_date.day > cal_count - first_date.wday
      calender << '</td>'
    end
    calender << '</tr>' + "\n"
  end
  calender << '</table>'

  return calender
end

print make_calender(2016, 10), "\n\n"

