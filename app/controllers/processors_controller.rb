class ProcessorsController < ApplicationController
  # GET /processors
  # GET /processors.json
  def index
    
    if params[:q]
      @search = Processor.search do
        fulltext params[:q]
        order_by :name, :asc
        paginate :page => params[:page], :per_page => 20
      end
      @processors = @search.results
      @search_total = @search.total
    else
      @processors = Processor.asc(:name).page(params[:page]).per(20)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @processors }
    end
  end

  # GET /processors/1
  # GET /processors/1.json
  def show
    @processor = Processor.find(params[:id])

    Spira.add_repository! :hardware, RDF::Repository.new << RDF::Mongo::Repository.new
    @processor_rdf = SPARQL.execute("SELECT * WHERE { <#{ProcessorRdf.for(@processor.item).subject.to_s}> ?p ?o }", ProcessorRdf.repository)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @processor }
    end
  end

  # GET /processors/new
  # GET /processors/new.json
  def new
    @processor = Processor.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @processor }
    end
  end

  # GET /processors/1/edit
  def edit
    @processor = Processor.find(params[:id])
  end

  # POST /processors
  # POST /processors.json
  def create
    @processor = Processor.new(params[:processor])

    respond_to do |format|
      if @processor.save
        format.html { redirect_to @processor, :notice => 'Processor was successfully created.' }
        format.json { render :json => @processor, :status => :created, :location => @processor }
      else
        format.html { render :action => "new" }
        format.json { render :json => @processor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /processors/1
  # PUT /processors/1.json
  def update
    @processor = Processor.find(params[:id])

    respond_to do |format|
      if @processor.update_attributes(params[:processor])
        format.html { redirect_to @processor, :notice => 'Processor was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @processor.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /processors/1
  # DELETE /processors/1.json
  def destroy
    @processor = Processor.find(params[:id])
    @processor.destroy

    respond_to do |format|
      format.html { redirect_to processors_url }
      format.json { head :ok }
    end
  end
end
