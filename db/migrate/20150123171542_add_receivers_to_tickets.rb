class AddReceiversToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :cr_id, :string
    add_column :tickets, :cr_title, :string
    add_column :tickets, :cr_status, :string
    add_column :tickets, :cr_webm_duration, :string
    add_column :tickets, :cr_webm_s3url, :string
    add_column :tickets, :cr_mp4_duration, :string
    add_column :tickets, :cr_mp4_s3url, :string
    add_column :tickets, :cr_vb_state, :string
    add_column :tickets, :cr_vb_fileurl, :string
  end
end
