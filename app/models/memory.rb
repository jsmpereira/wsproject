class Memory < Hardware
  include Mongoid::Document

  field :item

  field :name
  field :brand
  field :memory_type
  field :speed
  field :capacity

  field :details
  
  include Sunspot::Mongo
  searchable do
    string :name
    string :brand
    string :speed
    text :name
    text :item
    text :brand
    text :speed
    text :capacity
    text :memory_type
    text :details
  end
end
