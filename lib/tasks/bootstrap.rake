# Bootstrap the project

desc "Add the default users"
task :bootstrap => :environment do
  User.new(:name => "agent1", :password => "a1password").save
  User.new(:name => "agent2", :password => "a2password").save
  User.new(:name => "agent3", :password => "a3password").save
  User.new(:name => "agent4", :password => "a3password").save
end
