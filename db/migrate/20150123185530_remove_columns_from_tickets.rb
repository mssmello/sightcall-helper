class RemoveColumnsFromTickets < ActiveRecord::Migration
  def change
    remove_column :tickets, :webm_s3url
    remove_column :tickets, :mp4_s3url
    remove_column :tickets, :vb_fileurl
  end
end
