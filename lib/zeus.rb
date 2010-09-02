require 'rubygems'
require 'wrest'
require 'mysql'

require 'yaml'
@config = YAML::load_file(File.dirname(__FILE__) + '/../config/database.yml')

@db_conn = Mysql.real_connect(config['db_host'],config['db_user'],config['db_password'],config['db_database'])
