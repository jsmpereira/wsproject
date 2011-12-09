
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
        mr.update(:hasModelName => m.name,
                  :hasBrand => m.brand,
                  :hasCpuSocket => m.cpu_socket,
                  :hasGraphSlot => m.graph_slot,
                  :hasMemoryType => m.memory_type)
        mr.save!
      end
      
      Processor.all.each do |p|
        pr = ProcessorRdf.for(p.item)
        pr.update(:hasModelName => p.name,
                  :hasBrand => p.brand,
                  :hasCpuSocket => p.cpu_socket)
        pr.save!
      end
      
      Videocard.all.each do |v|
        vr = VideocardRdf.for(v.item)
        vr.update(:hasModelName => v.name,
                  :hasBrand => v.brand,
                  :hasGraphSlot => v.graph_slot)
        vr.save!
      end
      
      Memory.all.each do |m|
        mr = MemoryRdf.for(m.item)
        mr.update(:hasModelName => m.name,
                  :hasBrand => m.brand,
                  :hasCapacity => m.capacity,
                  :hasMemoryType => m.memory_type,
                  :hasSpeed => m.speed)
        mr.save!
      end
    end
    
  end
end