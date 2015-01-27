class AddRecordingsToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :webm_s3url, :string
    add_column :tickets, :mp4_s3url, :string
    add_column :tickets, :vb_fileurl, :string
  end
end
