require 'rtcc_auth'

VISITOR_DOMAIN = "yourdomain.com"
VISITOR_PROFILE = "standard"

class VisitorController < ApplicationController

  skip_before_filter :authorize

  def initialize
    @client = RTCCAuth.new(RTCC_AUTH_URL, RTCC_CACERT, RTCC_CLIENTCERT, RTCC_CLIENTCERT_KEY, RTCC_CERTPASSWORD, RTCC_CLIENT_ID, RTCC_CLIENT_SECRET)
    super
  end

  #
  # POST: params[uid]
  #   retrieve a SightCall token for the UID
  #

  def callback
    puts "VisitorParams:", params
    obj = @client.auth(params['uid'], VISITOR_DOMAIN, VISITOR_PROFILE)
    logger.debug "Visitor#callback #{obj}"
    render :json => obj
  end

  #
  # The WAIT page is rendered and generates the unique ID
  #

  def wait
    @randomUid = SecureRandom.hex(3)
    @loadrtcc = true            # load the javascript on page load

    session[:visitorUid] = @randomUid

    @ticket = Ticket.new
    @ticket.uid = @randomUid
    @ticket.useragent = request.env['HTTP_USER_AGENT']
    @ticket.progress = "created"
    @ticket.served = false
    if params[:skill]
      @ticket.skill = params[:skill]
    end
    @ticket.save!

    session[:visitorKey] = @ticket.key

    render :layout => "visitor_nonav_layout"

  end

  #
  # Update our progress by pushing a note to the database
  #   Visitor is unauthenticated, but has a session.  Retrieve the key from there.
  #

  def update
    puts "Update Progress:#{params}"

    key = session[:visitorKey]

    @ticket = Ticket.where("key = ?", key).first
    if params[:progress]
      @ticket.update_attributes({ :progress => params[:progress] })
    end

    render json: @ticket

  end
  
end
