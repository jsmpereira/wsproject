class SearchesController < ApplicationController
  
  def index
    
    @target = params[:target].downcase if params[:target]
    
    @motherboards_search, @motherboards, @motherboards_search_total = search("motherboard")
    @processors_search, @processors, @processors_search_total = search("processor")
    @videocards_search, @videocards, @videocards_search_total = search("videocard")
    @memories_search, @memories, @memories_search_total = search("memory")
    
    respond_to do |format|
      format.html {  }
    end
  end
  
  def browse
    
    if params[:target]
      target = params[:target].constantize
    else
      target = [Motherboard, Processor, Videocard, Memory]
    end
    
    query = params.reject{|k, v| k == "action" || k == "target" || k == "controller"}.values[0]
    
    browse = Sunspot.search target do
      fulltext query
      order_by :name, :asc
      paginate :page => params[:page], :per_page => 15
      brand_filter = with(:brand, params[:brand]) if params[:brand]
      facet :brand, :sort => :count, :exclude => brand_filter
    end
    
    @results = browse
    @browse_search = browse
    
    respond_to do |format|
      format.html {  }
    end
  end
  
  def rdf

    repo = RDF::Mongo::Repository.new

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
    the_klass = "select * where {?type a <#{mongo_model_to_spira_model(klass.first)}>"
    
    if tokens.include?("from")
      property = params[:sq].split("from")[1].split(" ")[0]
      q = " ; <http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#hasBrand> \"#{property}\"}"
    else
      q = "}"
    end
    
    repo = RDF::Mongo::Repository.new
     
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
      repo = RDF::Mongo::Repository.new
      @results = SPARQL.execute(params[:query], repo)
    end

    respond_to do |format|
      format.html
    end
  end
  
  def traverse
    
    target = params[:target].constantize
    if params[:brand]
      rel = "#hasBrand"
      obj = params[:brand]
    elsif params[:graph_slot]
      rel = "#hasGraphSlot"
      obj = params[:graph_slot]
    elsif params[:cpu_socket]
      rel = "#hasCpuSocket"
      obj = params[:cpu_socket] 
    elsif params[:memory_type]
      rel = "#hasMemoryType"
      obj = params[:memory_type]
    elsif params[:speed]
      rel = "#hasSpeed"
      obj = params[:speed]
    elsif params[:capacity]
      rel = "#hasCapacity"
      obj = params[:capacity]
    end
    
    result = SPARQL.execute("SELECT * WHERE { ?s <http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#{rel}> \"#{obj}\"}", RDF::Mongo::Repository.new)
    
    @sol = target.where(:item.in => result.collect{|m| rdf_to_mongo_id(m.s)})
    
    respond_to do |format|
      format.html {  }
    end
  end
  
  private
  
  def search(content)
    
    if @target.blank? || @target.include?(content)
      logger.debug "PORRA #{content.inspect} : #{@target.inspect} #{params[:q]}"
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
