class VideocardsController < ApplicationController
  # GET /videocards
  # GET /videocards.json
  def index
    
    if params[:q]
      @search = Videocard.search do
        fulltext params[:q]
        order_by :name, :asc
        paginate :page => params[:page], :per_page => 20
      end
      @videocards = @search.results
      @search_total = @search.total
    else
      @videocards = Videocard.asc(:name).page(params[:page]).per(20)
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
