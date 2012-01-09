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
    
    def for_processor(processor)
      recommendations_processors = SPARQL.execute("SELECT * WHERE { ?s a <#{ProcessorRdf.type}> . ?s <http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#hasCpuSocket> \"#{processor.cpu_socket}\" FILTER (?s != <http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#Processor/#{processor.item.to_s}>) } ", repository)
      
      recommendations_motherboards = SPARQL.execute("SELECT * WHERE { ?s a <#{MotherboardRdf.type}> . ?s <http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#hasCpuSocket> \"#{processor.cpu_socket}\"}", repository)

      recommendations = recommendations_processors.collect {|r| rdf_to_mongo_model(r.s).where(:item => rdf_to_mongo_id(r.s)).first}.shuffle[0..2] + recommendations_motherboards.collect {|r| rdf_to_mongo_model(r.s).where(:item => rdf_to_mongo_id(r.s)).first}.shuffle[0..1]
    end
    
    def for_motherboard(motherboard)
      recommendations_motherboards = SPARQL.execute("SELECT * WHERE { ?s a <#{MotherboardRdf.type}> . ?s <http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#hasCpuSocket> \"#{motherboard.cpu_socket}\" . ?s <http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#hasGraphSlot> \"#{motherboard.graph_slot}\" . ?s <http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#hasMemoryType> \"#{motherboard.memory_type}\" FILTER (?s != <http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#Motherboard/#{motherboard.item.to_s}>) } ", repository)
      
      recommendations_memories = SPARQL.execute("SELECT * WHERE { ?s a <#{MemoryRdf.type}> . ?s <http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#hasMemoryType> \"#{motherboard.memory_type}\"}", repository)
      
      recommendations_videocards = SPARQL.execute("SELECT * WHERE { ?s a <#{VideocardRdf.type}> . ?s <http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#hasGraphSlot> \"#{motherboard.graph_slot}\"}", repository)
      
      recommendations_processors = SPARQL.execute("SELECT * WHERE { ?s a <#{ProcessorRdf.type}> . ?s <http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#hasCpuSocket> \"#{motherboard.cpu_socket}\"}", repository)
      
      recommendations = recommendations_motherboards.collect {|r| rdf_to_mongo_model(r.s).where(:item => rdf_to_mongo_id(r.s)).first}.shuffle[0..2] + recommendations_memories.collect {|r| rdf_to_mongo_model(r.s).where(:item => rdf_to_mongo_id(r.s)).first}.shuffle[0..1] + recommendations_videocards.collect {|r| rdf_to_mongo_model(r.s).where(:item => rdf_to_mongo_id(r.s)).first}.shuffle[0..1] + recommendations_processors.collect {|r| rdf_to_mongo_model(r.s).where(:item => rdf_to_mongo_id(r.s)).first}.shuffle[0..1]
    end
    
    private
    
    def rdf_to_mongo_model(s)
  		s.to_s.split("#")[1].split("/")[0].capitalize.constantize
  	end

  	def rdf_to_mongo_id(s)
  		s.to_s.split("#")[1].split("/")[1]
  	end
  end
end