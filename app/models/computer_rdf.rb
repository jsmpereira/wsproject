class ComputerRdf
  include Spira::Resource
  
  base_uri "http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl"
  type RDF::URI("Computer")
  
  default_vocabulary URI.new('http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl')
  Spira.add_repository! :hardware, RDF::Mongo::Repository.new
  
  default_source :hardware

  property :motherboard, :predicate => RDF::URI("http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#hasMotherboard"), :type => "MotherboardRdf"
  property :processor, :predicate => RDF::URI("http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#hasProcessor"), :type => "ProcessorRdf"
  property :videocard, :predicate => RDF::URI("http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#hasVideoCard"), :type => "VideocardRdf"
  property :memory, :predicate => RDF::URI("http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#hasMemory"), :type => "MemoryRdf"
end
