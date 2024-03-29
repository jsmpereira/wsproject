require 'semantics'
class MemoriesController < ApplicationController
  # GET /memories
  # GET /memories.json
  def index

    @memories = Memory.search do
      order_by :name, :asc
      paginate :page => params[:page], :per_page => 10
      brand_filter = with(:brand, params[:brand]) if params[:brand]
      speed_filter = with(:speed, params[:speed]) if params[:speed]
      facet :brand, :sort => :count, :exclude => [brand_filter, speed_filter].compact
      facet :speed, :sort => :count, :exclude => [brand_filter, speed_filter].compact
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @memories }
    end
  end

  # GET /memories/1
  # GET /memories/1.json
  def show
    @memory = Memory.find(params[:id])
    
    Spira.add_repository! :hardware, RDF::Mongo::Repository.new
    @memory_rdf = SPARQL.execute("SELECT * WHERE { <#{MemoryRdf.for(@memory.item).subject.to_s}> ?p ?o }", MemoryRdf.repository)
    
    @recommendations = Semantics::Recommendations.new.for_memory(@memory)

    @computer = Semantics::Recommendations.new.build_computer(@memory)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @memory }
    end
  end

  # GET /memories/new
  # GET /memories/new.json
  def new
    @memory = Memory.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @memory }
    end
  end

  # GET /memories/1/edit
  def edit
    @memory = Memory.find(params[:id])
  end

  # POST /memories
  # POST /memories.json
  def create
    @memory = Memory.new(params[:memory])

    respond_to do |format|
      if @memory.save
        format.html { redirect_to @memory, :notice => 'Memory was successfully created.' }
        format.json { render :json => @memory, :status => :created, :location => @memory }
      else
        format.html { render :action => "new" }
        format.json { render :json => @memory.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /memories/1
  # PUT /memories/1.json
  def update
    @memory = Memory.find(params[:id])

    respond_to do |format|
      if @memory.update_attributes(params[:memory])
        format.html { redirect_to @memory, :notice => 'Memory was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @memory.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /memories/1
  # DELETE /memories/1.json
  def destroy
    @memory = Memory.find(params[:id])
    @memory.destroy

    respond_to do |format|
      format.html { redirect_to memories_url }
      format.json { head :ok }
    end
  end
end
