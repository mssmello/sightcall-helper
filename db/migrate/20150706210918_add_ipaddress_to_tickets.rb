class AddIpaddressToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :ipaddress, :string
  end
end
