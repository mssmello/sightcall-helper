class Ticket < ActiveRecord::Base

  belongs_to :user

  before_create :set_secrets

  #
  # Set the random key for this object
  #

  def set_secrets
    self.key = SecureRandom.hex
  end

end
