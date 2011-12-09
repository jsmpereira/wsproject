require 'rdf/mongo'
class ProcessorRdf
  include Spira::Resource
  
  base_uri "http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#Processor"
  type RDF::URI("Processor")
  
  default_vocabulary URI.new('http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl')
  
  default_source :hardware

  property :hasModelName, :predicate => RDF::URI("http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#hasModelName")#, :type => String
  property :hasBrand, :predicate => RDF::URI("http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#hasBrand")#, :type => String
  property :hasCpuSocket, :predicate => RDF::URI("http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#hasCpuSocket")#, :type => String
  property :computer, :predicate => RDF::URI("http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#isProcessorOf"), :type => "ComputerRdf"
end
