CLOUDRECORDER_BASE = "https://recording.sightcall.com/api"

class TicketsController < ApplicationController
  before_action :set_ticket, only: [:show, :edit, :update, :destroy, :newrecording, :recordingdetail]

  # GET /tickets
  # GET /tickets.json
  def index
    @tickets = Ticket.order('id ASC').where("served = ?", false)
  end

  def closed
    @tickets = Ticket.paginate(:page => params[:page]).order('id DESC').where("served = ?", true)
  end

  # GET /tickets/1
  # GET /tickets/1.json
  def show
  end

  # GET /tickets/new
  def new
    @ticket = Ticket.new
  end

  # GET /tickets/1/edit
  def edit
  end

  # POST /tickets
  # POST /tickets.json
  def create
    @ticket = Ticket.new(ticket_params)

    respond_to do |format|
      if @ticket.save
        format.html { redirect_to @ticket, notice: 'Ticket was successfully created.' }
        format.json { render action: 'show', status: :created, location: @ticket }
      else
        format.html { render action: 'new' }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tickets/1
  # PATCH/PUT /tickets/1.json
  def update
    respond_to do |format|
      if @ticket.update(ticket_params)
        format.html { redirect_to @ticket, notice: 'Ticket was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tickets/1
  # DELETE /tickets/1.json
  def destroy
    @ticket.destroy
    respond_to do |format|
      format.html { redirect_to tickets_url }
      format.json { head :no_content }
    end
  end

  #
  # TAKE a ticket and work on it.  Mark it served.
  #   Use a transaction and a lock to ensure only one agent retrieves this ticket.
  #

  def take
    Ticket.transaction do
      begin
        if params[:id]
          # then this ticket
          @ticket = Ticket.find(params[:id])
        else
          # select first unserved ticket and redirect there
          @ticket = Ticket.order('id ASC').where("served = ?", false).lock(true).first
          redirect_to take_ticket_url(@ticket)
        end
        @ticket.lock!
        @ticket.served = true
        @ticket.user = current_user
        # sleep 5 # simulate slow system and observe blocking
        @ticket.save!

        @loadrtcc = true        # load the javascript on page load
      rescue
        @ticket = nil
      end
    end
  end

  #
  # Allocate a new recording on the Cloud Recorder linked to this @ticket.key.
  #   Return the JSON including the upload key
  #

  def newrecording

    if @ticket.cr_id
      render :json => { :error => "Recording already captured for this ticket" }
    end

    if CLOUDRECORDER_TOKEN
      begin

        Logger.info "Ticket:newrecording: #{params[:title]}: #{@ticket.key}"

        response = RestClient.post("#{CLOUDRECORDER_BASE}/recordings",
                                   { :title => params[:title], :remote_key => @ticket.key  },
                                   'authorization' => "Token token=#{CLOUDRECORDER_TOKEN}"
                                   )

        jdata = JSON.parse(response.body)

        # Logger.info "Ticket:newrecording: #{jdata.inspect}"

        # store the cloudrecorder ID of the new recording
        @ticket.update_attributes(:cr_id => jdata["id"])

        render :json => {
          :id => jdata["id"],
          :upload_key => jdata["upload_key"]
        }
      rescue => e
        render :json => {
          :error => e.message
        }
      end
    else
      render :json => { :error => "CloudRecorder not configured" }
    end
  end

  #
  # Return the ticket fields related to the cloud recorder.
  #  The Cloud Recorder will be asynchronously updating these via a callback_url.
  #  See Cloudrecorderreceiver_controller.

  def recordingdetail

    render :json => {
      :status => @ticket.cr_status,
      :webm_duration => @ticket.cr_webm_duration,
      :webm_s3url => @ticket.cr_webm_s3url,
      :mp4_duration => @ticket.cr_mp4_duration,
      :mp4_s3url => @ticket.cr_mp4_s3url,
      :vb_state => @ticket.cr_vb_state,
      :vb_fileurl => @ticket.cr_vb_fileurl
    }

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ticket
      @ticket = Ticket.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ticket_params
      params.permit(:created_at, :updated_at, :key, :uid, :displayname, :skill, :served)
    end
end
