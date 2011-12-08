class Processor < Hardware
  include Mongoid::Document

  field :item
  
  field :name
  field :brand
  field :cpu_socket
  
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
