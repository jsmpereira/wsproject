require 'rdf'
require 'rdf/mongo'

module Semantics
  class Database
    def initialize
      @repo = RDF::Mongo::Repository.new
      @repo.load '/Users/josesantos/Documents/LEI/WS/project/hardware.owl'
    end
    
    def repo
      @repo
    end
    
    def populate
      
      Motherboard.all.each do |m|
        
        mr = MotherboardRdf.for("Motherboard##{m.item}")
        mr.update(:modelName => m.name,
                  :brand => m.details['Brand'],
                  :cpuSocket => m.details['CPU Socket Type'],
                  :graphSlot => m.details['PCI Express x8'] || m.details['PCI Express 3_0 x16'],
                  :memoryType => m.details['Memory Standard'])
        mr.save!
      end
      
      Processor.all.each do |p|
        pr = ProcessorRdf.for("Processor##{p.item}")
        pr.update(:modelName => p.name,
                  :brand => p.details['Brand'],
                  :cpuSocket => p.details['CPU Socket Type'])
        pr.save!
      end
      
      Videocard.all.each do |v|
        vr = VideocardRdf.for("VideoCard##{v.item}")
        vr.update(:modelName => v.name,
                  :brand => v.details['Brand'],
                  :graphSlot => v.details['Interface'])
        vr.save!
      end
      
      Memory.all.each do |m|
        mr = MemoryRdf.for("Memory##{m.item}")
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