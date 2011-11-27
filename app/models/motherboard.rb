class Motherboard
  include Mongoid::Document
  field :name
  field :item
  field :details
  
  include Sunspot::Mongo
  searchable do
    string :name
    text :name
    text :item
    text :details
  end
  
  #def after_save
  #  m = MotherboardRdf.new
  #  m.name = self.name
  #  m.item = self.item
  #  m.save!
  #end
end
