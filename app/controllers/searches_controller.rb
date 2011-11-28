class SearchesController < ApplicationController
  
  def index
    
    if params[:query]
      repo = RDF::Repository.new << RDF::Mongo::Repository.new
      @results = SPARQL.execute(params[:query], repo)
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @motherboard }
    end
  end
end
