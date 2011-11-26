class Memory
  include Mongoid::Document
  field :name
  field :item
  field :details
  
  include Sunspot::Mongo
  searchable do
    text :name
    text :item
    text :details
  end
end
