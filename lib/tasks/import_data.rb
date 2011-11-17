namespace :import_data do
  #desc "Import scrapped data."
  #task :import_all => :environment do
  #  Rake::Task['import_data:motherboards'].invoke
  #end
  
  task :motherboards => :environment do
    
    motherboards = ActiveSupport::JSON.decode(File.read('/Users/josesantos/Documents/LEI/WS/project/data/motherboards.json'))
    puts motherboards.each{|m| m.second['details'].collect{|x, y| x}.inspect}
  end
end