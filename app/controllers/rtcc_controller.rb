require 'rtcc_client'

class RtccController < ApplicationController

  def initialize
    @client = RTCCClient.new(RTCC_CLIENT_ID, RTCC_CLIENT_SECRET)
    super
  end

  def callback
    if user_signed_in?
      obj = @client.usertoken(current_user.rtcc_uid,
                              current_user.rtcc_domain,
                              current_user.rtcc_profile)
    else
      obj = { "error" => 500, "error_description" => "unauthenticated user" }
    end

    logger.debug "RTCC#callback #{obj}"

    render :json => obj
  end

  def csrftest
      obj = @client.auth("csrftestuser",
                         "tsheffler.wauth9",
                         "premium")
    logger.debug "RTCC#csrftest #{obj}"

    render :json => obj
  end
end
