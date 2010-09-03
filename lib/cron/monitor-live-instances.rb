#!ruby
require File.dirname(__FILE__) + '/../zeus'

logger = Zeus.logger

# if this instance is admin check health of other instances
if Zeus.is_admin

  logger.info("I am an admin")

  instance_ids = Zeus.all_live_instances
  logger.info("instance_ids #{instance_ids}")

  now = Time.now
  instance_ids.each{ |instance_id|
    last_updated_at = Zeus.get_attribute_for_instance('last_updated_at',instance_id)
    # if the snapshot is not updated in last 10 min
    if (now - Time.parse(last_updated_at)) > 600
      Zeus.connection.query("update instances set status = 'terminated' where instance_id = '#{instance_id}'")
    end
  }
else # check if the admin instance is running or not, else try to take control of the cloud
  admin_instance_id = Zeus.get_admin_instance_id
  admin_last_updated_at = Zeus.get_attribute_for_instance('last_updated_at',admin_instance_id)

  if (Time.now - Time.parse(admin_last_updated_at)) > 600
    Zeus.connection.query("update admin_instance set instance_id = #{Zeus.instance_id} where instance_id = #{admin_instance_id}")
  end
end
