require 'rdf/mongo'
class VideocardRdf
  include Spira::Resource
  
  base_uri "http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#VideoCard"
  type RDF::URI("VideoCard")
  
  default_vocabulary URI.new('http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl')
  
  default_source :hardware

  property :hasModelName, :predicate => RDF::URI("http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#hasModelName")#, :type => String
  property :hasBrand, :predicate => RDF::URI("http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#hasBrand")#, :type => String
  property :hasGraphSlot, :predicate => RDF::URI("http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#hasGraphSlot")#, :type => String
  property :computer, :predicate => RDF::URI("http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#isVideoCardOf"), :type => "ComputerRdf"
end
