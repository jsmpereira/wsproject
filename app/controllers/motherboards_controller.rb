class MotherboardsController < ApplicationController
  # GET /motherboards
  # GET /motherboards.json
  def index
    
    if params[:q]
      search = Motherboard.solr_search do
        fulltext params[:q]
      end
      @motherboards = search.results
    else
      @motherboards = Motherboard.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @motherboards }
    end
  end

  # GET /motherboards/1
  # GET /motherboards/1.json
  def show
    @motherboard = Motherboard.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @motherboard }
    end
  end

  # GET /motherboards/new
  # GET /motherboards/new.json
  def new
    @motherboard = Motherboard.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @motherboard }
    end
  end

  # GET /motherboards/1/edit
  def edit
    @motherboard = Motherboard.find(params[:id])
  end

  # POST /motherboards
  # POST /motherboards.json
  def create
    @motherboard = Motherboard.new(params[:motherboard])

    respond_to do |format|
      if @motherboard.save
        format.html { redirect_to @motherboard, :notice => 'Motherboard was successfully created.' }
        format.json { render :json => @motherboard, :status => :created, :location => @motherboard }
      else
        format.html { render :action => "new" }
        format.json { render :json => @motherboard.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /motherboards/1
  # PUT /motherboards/1.json
  def update
    @motherboard = Motherboard.find(params[:id])

    respond_to do |format|
      if @motherboard.update_attributes(params[:motherboard])
        format.html { redirect_to @motherboard, :notice => 'Motherboard was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @motherboard.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /motherboards/1
  # DELETE /motherboards/1.json
  def destroy
    @motherboard = Motherboard.find(params[:id])
    @motherboard.destroy

    respond_to do |format|
      format.html { redirect_to motherboards_url }
      format.json { head :ok }
    end
  end
end
