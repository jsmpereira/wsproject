class VideocardsController < ApplicationController
  # GET /videocards
  # GET /videocards.json
  def index

    @videocards = Videocard.search do
      order_by :name, :asc
      paginate :page => params[:page], :per_page => 10
      brand_filter = with(:brand, params[:brand]) if params[:brand]
      facet :brand, :sort => :count, :exclude => brand_filter
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @videocards }
    end
  end

  # GET /videocards/1
  # GET /videocards/1.json
  def show
    @videocard = Videocard.find(params[:id])
    
    Spira.add_repository! :hardware, RDF::Repository.new << RDF::Mongo::Repository.new
    @videocard_rdf = SPARQL.execute("SELECT * WHERE { <#{VideocardRdf.for(@videocard.item).subject.to_s}> ?p ?o }", VideocardRdf.repository)
    
    @recommendations_sparql = SPARQL.execute("SELECT * WHERE { ?s <http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#hasGraphSlot> \"#{@videocard.graph_slot}\" FILTER (?s != <http://www.semanticweb.org/ontologies/2011/10/Ontology1321532209875.owl#VideoCard/#{@videocard.item.to_s}>) } LIMIT 5", VideocardRdf.repository)
    
    @recommendations = @recommendations_sparql.collect {|r| r.s.to_s.split("#")[1].split("/")[0].capitalize.constantize.where(:item => r.s.to_s.split("#")[1].split("/")[1]).first}

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @videocard }
    end
  end

  # GET /videocards/new
  # GET /videocards/new.json
  def new
    @videocard = Videocard.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @videocard }
    end
  end

  # GET /videocards/1/edit
  def edit
    @videocard = Videocard.find(params[:id])
  end

  # POST /videocards
  # POST /videocards.json
  def create
    @videocard = Videocard.new(params[:videocard])

    respond_to do |format|
      if @videocard.save
        format.html { redirect_to @videocard, :notice => 'Videocard was successfully created.' }
        format.json { render :json => @videocard, :status => :created, :location => @videocard }
      else
        format.html { render :action => "new" }
        format.json { render :json => @videocard.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /videocards/1
  # PUT /videocards/1.json
  def update
    @videocard = Videocard.find(params[:id])

    respond_to do |format|
      if @videocard.update_attributes(params[:videocard])
        format.html { redirect_to @videocard, :notice => 'Videocard was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @videocard.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /videocards/1
  # DELETE /videocards/1.json
  def destroy
    @videocard = Videocard.find(params[:id])
    @videocard.destroy

    respond_to do |format|
      format.html { redirect_to videocards_url }
      format.json { head :ok }
    end
  end
end
