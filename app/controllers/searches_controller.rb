class SearchesController < ApplicationController
  
  def index
    
    @target = params[:target]
    
    @motherboards_search, @motherboards, @motherboards_search_total = search("motherboard")
    @processors_search, @processors, @processors_search_total = search("processor")
    @videocards_search, @videocards, @videocards_search_total = search("videocard")
    @memories_search, @memories, @memories_search_total = search("memory")
    
    respond_to do |format|
      format.html {  }
    end
  end
  
  def browse
    
    browse = Sunspot.search Motherboard, Processor, Videocard, Memory do
      order_by :name, :asc
      paginate :page => params[:page], :per_page => 15
      brand_filter = with(:brand, params[:brand]) if params[:brand]
      facet :brand, :sort => :count, :exclude => brand_filter
    end
    
    @results = browse.results
    @browse_search = browse
    
    respond_to do |format|
      format.html {  }
    end
  end
  
  def rdf

    repo = RDF::Repository.new << RDF::Mongo::Repository.new

    if params[:member] && params[:class]
      @member_query = "select ?s ?p ?o where {<http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl##{params[:class]}/#{params[:member]}> ?p ?o}"
      @member = SPARQL.execute(@member_query, repo)
    elsif params[:class]
      @members_query = "select * where {?type a <#{params[:class]}>}"
      @members = SPARQL.execute(@members_query, repo)
    else
      @classes_query = "PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
      SELECT ?subClass WHERE {
       ?subClass rdfs:subClassOf <http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#Hardware> . 
      }"
      @classes = SPARQL.execute(@classes_query, repo)
    end
    
    respond_to do |format|
      format.html {  }
    end
  end
  
  def semantic

    tokens = params[:sq].split(" ")
    
    klass = tokens.select{|t| ["motherboard", "processor", "videocard", "memory"].include?(t)}.uniq
    the_klass = "select * where {?type a <#{klass.first.capitalize}>"
    
    if tokens.include?("from")
      property = params[:sq].split("from")[1].split(" ")[0]
      q = " ; <http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#hasBrand> \"#{property}\"}"
    else
      q = "}"
    end
    
    repo = RDF::Repository.new << RDF::Mongo::Repository.new
     
    @semantic_query = the_klass + q
    
    logger.debug @semantic_query.inspect
    @semantic_result = SPARQL.execute(@semantic_query, repo)
    
    @results = @semantic_result.collect {|r| r.type.to_s.split("#")[1].split("/")[0].capitalize.constantize.where(:item => r.type.to_s.split("#")[1].split("/")[1]).first}
    
    respond_to do |format|
      format.html {  }
    end
    
  end
  
  def sparql
    
    if params[:query]
      repo = RDF::Repository.new << RDF::Mongo::Repository.new
      @results = SPARQL.execute(params[:query], repo)
    end

    respond_to do |format|
      format.html
    end
  end
  
  private
  
  def search(content)
    
    if @target.blank? || @target.include?(content)
      search = content.capitalize.constantize.search do
        fulltext (params[:q] == "Search everything ..." ? "" : params[:q])
        order_by :name, :asc
        paginate :page => params[content+"_page".to_s], :per_page => 10
        brand_filter = with(:brand, params[:brand]) if params[:brand]
        facet :brand, :sort => :count, :exclude => brand_filter
      end
      
      return search, search.results, search.total
    end
  end
end
