require 'open-uri'

namespace :iui do
  version = "0.13"
  
  task :download => :environment do
    unless File.exist?("#{RAILS_ROOT}/public/javascripts/iui.js")
      Dir.chdir("#{RAILS_ROOT}/vendor") do
        url = "http://iui.googlecode.com/files/iui-#{version}.tar.gz"
        puts "Loading iUI"
        open("iui-#{version}.tar.gz", 'w').write(open(url).read)
        system "tar zxvf iui-#{version}.tar.gz iui"
        system "rm iui-#{version}.tar.gz"
      end
    end
  end
  
  task :copy => :environment do
    Dir.chdir("#{RAILS_ROOT}/vendor/iui") do
      FileUtils.copy("iui.js", "#{RAILS_ROOT}/public/javascripts")
      FileUtils.copy("iui.css", "#{RAILS_ROOT}/public/stylesheets")
      images = Dir.glob('*.png') + Dir.glob('*.gif')
      images.each do |image|
        FileUtils.copy(image, "#{RAILS_ROOT}/public/images")
      end
    end
  end
  
  task :copy_compact => :environment do
    Dir.chdir("#{RAILS_ROOT}/vendor/iui") do
      FileUtils.copy("iuix.js", "#{RAILS_ROOT}/public/javascripts")
      FileUtils.copy("iuix.css", "#{RAILS_ROOT}/public/stylesheets")
      images = Dir.glob('*.png') + Dir.glob('*.gif')
      images.each do |image|
        FileUtils.copy(image, "#{RAILS_ROOT}/public/images")
      end
    end
  end
  
  task :change_root => :environment do
    text = ""
    File.open("#{RAILS_ROOT}/public/stylesheets/iui.css") do |f|
      text = f.read
      text.gsub!("url(", "url(/images/")
    end
    File.open("#{RAILS_ROOT}/public/stylesheets/iui.css", 'w') do |f|
      f << text
    end
  end
  
  desc "Installs iUI"
  task :install => [:environment, :download, :copy, :change_root]
  
  task :install_compact =>  [:environment, :download, :copy_compact, :change_root]
  
  task :clean => :environment do
    FileUtils.rm_f("#{RAILS_ROOT}/public/javascripts/iui.js")
    FileUtils.rm_f("#{RAILS_ROOT}/public/stylesheets/iui.css")
    FileUtils.rm_f("#{RAILS_ROOT}/public/javascripts/iuix.js")
    FileUtils.rm_f("#{RAILS_ROOT}/public/stylesheets/iuix.css")
    pngs = %w{backButton blueButton cancel grayButton listArrow listArrowSel listGroup
      pinstripes selection thumb toggle}
    pngs.each do |png|
      FileUtils.rm_f("#{RAILS_ROOT}/public/images/#{png}.png")
    end
    FileUtils.rm_f("#{RAILS_ROOT}/public/images/loading.gif")
    FileUtils.rm_f("#{RAILS_ROOT}/vendor/iui-#{version}.tar.gz")
    FileUtils.rm_rf("#{RAILS_ROOT}/vendor/iui")
  end
  
  task :reinstall => [:environment, :clean, :install]
  task :reinstall_compact => [:environment, :clean, :install_compact]
end