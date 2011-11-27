class Processor
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
  
end
