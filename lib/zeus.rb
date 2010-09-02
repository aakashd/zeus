require 'rubygems'
require 'right_aws'
require 'active_record'

require 'yml'
config = YAML::load_file('../config/zeus.yml')

ActiveRecord::Base.establish_connection(
  :adapter => config["db_adapter"],
  :host => config["db_host"],
  :username => config["db_user"],
  :password => config["db_password"],
  :database => config[":db_database"]
)


