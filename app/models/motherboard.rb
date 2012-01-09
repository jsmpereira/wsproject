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
    string :cpu_socket
    string :graph_slot
    text :name
    text :item
    text :details
  end
end
