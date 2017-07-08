


exit


# ここからはcsvの世界
table = CSV.table("#{ origin_name }.csv", headers: :first_row)
# 配列で初期化する。
han = []
rub = []
form = []
table.headers.each do |h|
  # セル内の改行を取り去る
  table[h].each do |cell|
    cell.gsub!(/\n/, '▼') if cell.class == String
    table[h] << "#{ cell }"
  end
  if h == :name
    # to csv coloumn 'name' and 'ruby'
    table[h].each do |cell|
      han << cell.split(/　/)
    end
  elsif h == :ruby
    table[h].each do |cell|
      rub << cell.split(/　/)
    end
  end
end
name = [han, rub].transpose
name.size.times do |n|
  fn =      name[n][0][0]  #first name
  fn_ruby = name[n][1][0]  #first name ruby
  ln =      name[n][0][1]  #last name
  ln_ruby = name[n][1][1]  #last name ruby
  first_name = fn + "/" + fn_ruby
  last_name  = ln + "/" + ln_ruby
  fn_s = fn.size
  ln_s = ln.size
  if fn_s >= 3 && ln_s >= 2 || fn_s >= 2 && ln_s >= 3
    form << "[#{ first_name }][#{ last_name }]"
  elsif fn_s == 1 && ln_s == 2 || fn_s == 2 && ln_s == 1
    form << "[#{ first_name }]　　[#{ last_name }]"
  else
    form << "[#{ first_name }]　[#{ last_name }]"
  end
end
