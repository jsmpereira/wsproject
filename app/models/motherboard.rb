class Motherboard < Hardware
  include Mongoid::Document
  field :item

  field :name
  field :brand
  field :cpu_socket
  field :graph_slot
  field :memory_type

  field :details
  
  include Sunspot::Mongo
  searchable do
    string :name
    string :brand
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
