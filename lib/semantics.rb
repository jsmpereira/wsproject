require 'rdf' 
require 'rdf/mongo'
require 'sparql'

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
  
  class Recommendations
    
    def initialize
      @repo = RDF::Mongo::Repository.new
    end
    
    def repository
      @repo
    end
    
    def build_computer(instance)
      
      if instance.is_a?(Motherboard)
        self.for_motherboard(instance, 0, 0, 0, 0, true)
      else
        mb = Motherboard.where(:item => rdf_to_mongo_id(rec_motherboards(instance)[0].s)) # pick one motherboard
        rec = []
        rec << instance
        rec << mb.first
        
        if instance.is_a?(Processor)
          if !rec_memories(mb.first).empty?
            rec << rec_memories(mb.first).collect {|r| rdf_to_mongo_model(r.s).where(:item => rdf_to_mongo_id(r.s)).first}.shuffle[0]
          end
          if !rec_videocards(mb.first).empty?
            rec << rec_videocards(mb.first).collect {|r| rdf_to_mongo_model(r.s).where(:item => rdf_to_mongo_id(r.s)).first}.shuffle[0]
          end
          rec
        elsif instance.is_a?(Videocard)
          if !rec_memories(mb.first).empty?
            rec << rec_memories(mb.first).collect {|r| rdf_to_mongo_model(r.s).where(:item => rdf_to_mongo_id(r.s)).first}.shuffle[0]
          end
          if !rec_processors(mb.first).empty?
            rec << rec_processors(mb.first).collect {|r| rdf_to_mongo_model(r.s).where(:item => rdf_to_mongo_id(r.s)).first}.shuffle[0]
          end
          rec
        elsif instance.is_a?(Memory)
          if !rec_videocards(mb.first).empty?
            rec << rec_videocards(mb.first).collect {|r| rdf_to_mongo_model(r.s).where(:item => rdf_to_mongo_id(r.s)).first}.shuffle[0]
          end
          if !rec_processors(mb.first).empty?
            rec << rec_processors(mb.first).collect {|r| rdf_to_mongo_model(r.s).where(:item => rdf_to_mongo_id(r.s)).first}.shuffle[0]
          end
          rec
        end
      end
    end
    
    def for_memory(memory)
      recommendations_memories = SPARQL.execute("SELECT * WHERE { ?s a <#{MemoryRdf.type}> . ?s <http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#hasSpeed> \"#{memory.speed}\" . ?s <http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#hasMemoryType> \"#{memory.memory_type}\" FILTER (?s != <http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#Memory/#{memory.item.to_s}>) }", repository)

      recommendations_motherboards = SPARQL.execute("SELECT * WHERE { ?s a <#{MotherboardRdf.type}> . ?s <http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#hasMemoryType> \"#{memory.memory_type}\" }", repository)

      recommendations = recommendations_memories.collect {|r| rdf_to_mongo_model(r.s).where(:item => rdf_to_mongo_id(r.s)).first}.shuffle[0..2] + recommendations_motherboards.collect {|r| rdf_to_mongo_model(r.s).where(:item => rdf_to_mongo_id(r.s)).first}.shuffle[0..1]
    end
    
    def for_videocard(videocard)
      recommendations_videocards = SPARQL.execute("SELECT * WHERE { ?s a <#{VideocardRdf.type}> . ?s <http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#hasGraphSlot> \"#{videocard.graph_slot}\" FILTER (?s != <http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#VideoCard/#{videocard.item.to_s}>) }", repository)
      
      recommendations_motherboards = SPARQL.execute("SELECT * WHERE { ?s a <#{MotherboardRdf.type}> . ?s <http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#hasGraphSlot> \"#{videocard.graph_slot}\"}", repository)

      recommendations = recommendations = recommendations_videocards.collect {|r| rdf_to_mongo_model(r.s).where(:item => rdf_to_mongo_id(r.s)).first}.shuffle[0..2] + recommendations_motherboards.collect {|r| rdf_to_mongo_model(r.s).where(:item => rdf_to_mongo_id(r.s)).first}.shuffle[0..1]
    end
    
    def for_processor(processor, mb = 1, proc = 2, computer = false)
      recommendations_processors = SPARQL.execute("SELECT * WHERE { ?s a <#{ProcessorRdf.type}> . ?s <http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#hasCpuSocket> \"#{processor.cpu_socket}\" FILTER (?s != <http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#Processor/#{processor.item.to_s}>) } ", repository)
      
      recommendations_motherboards = rec_motherboards(processor)
      
      recommendations = recommendations_processors.collect {|r| rdf_to_mongo_model(r.s).where(:item => rdf_to_mongo_id(r.s)).first}.shuffle[0..2] + recommendations_motherboards.collect {|r| rdf_to_mongo_model(r.s).where(:item => rdf_to_mongo_id(r.s)).first}.shuffle[0..mb]
    end
    
    def for_motherboard(motherboard, mb = 2, mem = 1, proc = 1, vid = 1, computer = false, processor = nil)
      recommendations_motherboards = SPARQL.execute("SELECT * WHERE { ?s a <#{MotherboardRdf.type}> . ?s <http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#hasCpuSocket> \"#{motherboard.cpu_socket}\" . ?s <http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#hasGraphSlot> \"#{motherboard.graph_slot}\" . ?s <http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#hasMemoryType> \"#{motherboard.memory_type}\" FILTER (?s != <http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#Motherboard/#{motherboard.item.to_s}>) } ", repository)
      
      recommendations_memories = rec_memories(motherboard)
      
      recommendations_videocards = rec_videocards(motherboard)
      
      recommendations_processors = rec_processors(motherboard)
      
      recommendations =  recommendations_memories.collect {|r| rdf_to_mongo_model(r.s).where(:item => rdf_to_mongo_id(r.s)).first}.shuffle[0..mem] + recommendations_videocards.collect {|r| rdf_to_mongo_model(r.s).where(:item => rdf_to_mongo_id(r.s)).first}.shuffle[0..vid] + recommendations_processors.collect {|r| rdf_to_mongo_model(r.s).where(:item => rdf_to_mongo_id(r.s)).first}.shuffle[0..proc]
      
      if computer
        recommendations << motherboard
      else
        recommendations += recommendations_motherboards.collect {|r| rdf_to_mongo_model(r.s).where(:item => rdf_to_mongo_id(r.s)).first}.shuffle[0..mb]
      end
    end
    
    private
    
    def rec_motherboards(instance)
      
      if instance.is_a?(Processor)
        SPARQL.execute("SELECT * WHERE { ?s a <#{MotherboardRdf.type}> . ?s <http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#hasCpuSocket> \"#{instance.cpu_socket}\"}", repository)
      elsif instance.is_a?(Videocard)
        SPARQL.execute("SELECT * WHERE { ?s a <#{MotherboardRdf.type}> . ?s <http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#hasGraphSlot> \"#{instance.graph_slot}\"}", repository)
      elsif instance.is_a?(Memory)
        SPARQL.execute("SELECT * WHERE { ?s a <#{MotherboardRdf.type}> . ?s <http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#hasMemoryType> \"#{instance.memory_type}\" }", repository)
      end
    end
    
    def rec_processors(instance)
      if instance.is_a?(Motherboard)
        SPARQL.execute("SELECT * WHERE { ?s a <#{ProcessorRdf.type}> . ?s <http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#hasCpuSocket> \"#{instance.cpu_socket}\"}", repository)
      end
    end
    
    def rec_videocards(instance)
      if instance.is_a?(Motherboard)
        SPARQL.execute("SELECT * WHERE { ?s a <#{VideocardRdf.type}> . ?s <http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#hasGraphSlot> \"#{instance.graph_slot}\"}", repository)
      end
    end
    
    def rec_memories(instance)
      if instance.is_a?(Motherboard)
        SPARQL.execute("SELECT * WHERE { ?s a <#{MemoryRdf.type}> . ?s <http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#hasMemoryType> \"#{instance.memory_type}\"}", repository)
      end
    end
    
    def rdf_to_mongo_model(s)
  		s.to_s.split("#")[1].split("/")[0].capitalize.constantize
  	end

  	def rdf_to_mongo_id(s)
  		s.to_s.split("#")[1].split("/")[1]
  	end
  end
end