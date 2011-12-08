class Videocard < Hardware
  include Mongoid::Document
  
  field :item
  
  field :name
  field :brand
  field :graph_slot
  
  field :details
  
  include Sunspot::Mongo
  searchable do
    string :name
    string :brand
    text :name
    text :item
    text :details
  end
end
