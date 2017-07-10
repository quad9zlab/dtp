require "fileutils"
require "../lib/iString"

class Hash
  def rubyfuri
    form = []
    self.each do |key, val|

      han = val["name"].split("　")
      rub = val["ruby"].split("　")

      sei_mei  = [han, rub].transpose
      sei      = sei_mei[0][0]
      sei_size = sei.size
      sei_ruby = sei_mei[0][1]

      mei      = sei_mei[1][0]
      mei_size = mei.size
      mei_ruby = sei_mei[1][1]

      renew_sei = sei + "/" + sei_ruby
      renew_mei = mei + "/" + mei_ruby

      if sei_size >= 3 && mei_size >= 2 || sei_size >= 2 && mei_size >= 3
        form << "[#{ renew_sei }][#{ renew_mei }]"
      elsif sei_size == 1 && mei_size == 2 || sei_size == 2 && mei_size == 1
        form << "[#{ renew_sei }]　　[#{ renew_mei }]"
      else
        form << "[#{ renew_sei }]　[#{ renew_mei }]"
      end
    end
    return form
  end

  def photonawa
    psds = Dir.glob("*.psd")
    # orgfn = File.basename(y, ".psd")
    name = []; form = []
    self.each { |key, val| name << val["name"].namaezoroe! }

    psds.map! { |fn|
      orgfn = File.basename(fn, ".psd")
      renew_fn = "img" + orgfn+ "_" + name.shift + ".psd"
      FileUtils.mv(fn, renew_fn )
      form << renew_fn
    }
    form
  end
end
