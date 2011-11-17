class Motherboard
  include Mongoid::Document
  key :name, String
  key :item, String
  key :details, Array
  
  include Sunspot::Mongo
  searchable do
    text :name
    text :item
    text :details
  end

end
