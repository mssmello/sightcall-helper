class AddAgentAndProgressToTicket < ActiveRecord::Migration
  def change
    add_column :tickets, :progress, :string
    add_column :tickets, :useragent, :string
  end
end
