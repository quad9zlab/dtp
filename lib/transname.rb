class Array
  def transname!
    renw_name = []
    self.each do |i|
      sei_mei = i.split("　")
      sei = sei_mei[0]
      mei = sei_mei[1]
      sei_s = sei_mei[0].size
      mei_s = sei_mei[1].size
      if sei_s >= 3 && mei_s >= 2 || sei_s >= 2 && mei_s >= 3
        renw_name << "#{ sei }#{ mei }"
      elsif sei_s == 1 && mei_s == 2 || sei_s == 2 && mei_s == 1
        renw_name << "#{ sei }　　#{ mei }"
      else
        renw_name << "#{ sei }　#{ mei }"
      end
    end
    renw_name
  end
end
