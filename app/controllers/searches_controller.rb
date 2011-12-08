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
        fulltext params[:q]
        order_by :name, :asc
        paginate :page => params[content+"_page".to_s], :per_page => 10
      end
      
      return search, search.results, search.total
    end
  end
end
