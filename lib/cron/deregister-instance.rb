#!ruby
require File.expand_path(File.dirname(__FILE__) + '/../zeus')

logger = Zeus.logger

if Zeus.record_for_this_instance_exists

  Zeus.connection.query("update instances set status = 'terminated', last_updated_at = CURRENT_TIMESTAMP where instance_id = '#{Zeus.instance_id}'")

end
