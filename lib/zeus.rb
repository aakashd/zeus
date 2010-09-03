require 'rubygems'
require 'wrest'
require 'mysql'

require 'yaml'

module Zeus
  
  def self.logger
    @logger ||= Logger.new(File.expand_path(File.dirname(__FILE__) + '/../log/zeus.log'))
  end

  def self.config
    @config ||= YAML::load_file(File.dirname(__FILE__) + '/../config/database.yml')
  end
  
  def self.connection
    @db_conn ||= Mysql.real_connect(config['db_host'],config['db_user'],config['db_password'],config['db_database'])
  end

  def self.instance_id
    @instance_id ||= "http://169.254.169.254/latest/meta-data/instance-id".to_uri.get.body
  end

  def self.is_admin
    get_admin_instance_id == instance_id
  end

  def self.all_live_instances
    res = Zeus.connection.query("select instance_id from zeus.instances where status != 'terminated'")
    instance_ids = []
    while row = res.fetch_row do
      instance_ids << row[0]
    end
  end

  def self.get_admin_instance_id
    Zeus.connection.query("select instance_id from admin_instance").fetch_row[0]
  end

  def self.get_attribute_for_instance(column_name,other_instance_id)
    Zeus.connection.query("select #{column_name} from instances where instance_id = '#{other_instance_id}'").fetch_row[0]
  end

end
