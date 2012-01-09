require 'rdf/mongo'
class MemoryRdf
  include Spira::Resource
  
  base_uri "http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#Memory"
  type RDF::URI(base_uri)
  
  default_vocabulary URI.new('http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl')
  
  default_source :hardware

  property :hasModelName, :predicate => RDF::URI("http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#hasModelName")#, :type => String
  property :hasBrand, :predicate => RDF::URI("http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#hasBrand")#, :type => String
  property :hasCapacity, :predicate => RDF::URI("http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#hasCapacity")#, :type => String
  property :hasMemoryType, :predicate => RDF::URI("http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#hasMemoryType")#, :type => String
  property :hasSpeed, :predicate => RDF::URI("http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#hasSpeed")#, :type => String
end
