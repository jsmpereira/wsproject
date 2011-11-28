
require 'rdf'
require 'rdf/mongo'

module Semantics
  class Database
    def initialize
      @repo = RDF::Mongo::Repository.new
    end
    
    def load_ontology(path)
      @repo.load path
    end
    
    def repo
      @repo
    end
    
    def populate
      
      Motherboard.all.each do |m|
        
        mr = MotherboardRdf.for(m.item)
        mr.update(:modelName => m.name,
                  :brand => m.details['Brand'],
                  :cpuSocket => m.details['CPU Socket Type'],
                  :graphSlot => m.details['PCI Express x8'] || m.details['PCI Express 3_0 x16'],
                  :memoryType => m.details['Memory Standard'])
        mr.save!
      end
      
      Processor.all.each do |p|
        pr = ProcessorRdf.for(p.item)
        pr.update(:modelName => p.name,
                  :brand => p.details['Brand'],
                  :cpuSocket => p.details['CPU Socket Type'])
        pr.save!
      end
      
      Videocard.all.each do |v|
        vr = VideocardRdf.for(v.item)
        vr.update(:modelName => v.name,
                  :brand => v.details['Brand'],
                  :graphSlot => v.details['Interface'])
        vr.save!
      end
      
      Memory.all.each do |m|
        mr = MemoryRdf.for(m.item)
        mr.update(:modelName => m.name,
                  :brand => m.details['Brand'],
                  :capacity => m.details['Capacity'],
                  :memoryType => m.details['Type'],
                  :speed => m.details['Speed'])
        mr.save!
      end
    end
    
  end
end