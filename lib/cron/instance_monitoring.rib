#!ruby
require File.expand_path(File.dirname(__FILE__) + '/../zeus')


logger = Zeus.logger

# if this instance is admin check health of other instances
if Zeus.is_admin
  logger.info("the instance is admin instance")
  instance_ids = Zeus.all_live_instances
  logger.debug("all instances - #{instance_ids}")
  now = Time.now
  instance_ids.each{ |instance_id|
    last_updated_at = Zeus.get_attribute_for_instance('last_updated_at',instance_id)
    logger.debug("instance #{instance_id} last updated at #{last_updated_at}")

    # if the snapshot is not updated in last 10 min
    if (now - Time.parse(last_updated_at)) > 600
      logger.debug("terminating instance #{instance_id}")
      Zeus.connection.query("update instances set status = 'terminated' where instance_id = '#{instance_id}'")
    end
  }
else # check if the admin instance is running or not, else try to take control of the cloud
  logger.info("the instance is not an admin instance")
  admin_instance_id = Zeus.get_admin_instance_id
  admin_last_updated_at = Zeus.get_attribute_for_instance('last_updated_at',admin_instance_id)
  logger.info("admin #{admin_instance_id} last updated at #{admin_last_updated_at}")
  if (Time.now - Time.parse(admin_last_updated_at)) > 600
    logger.debug("making myself admin")
    Zeus.connection.query("update admin_instance set instance_id = '#{Zeus.instance_id}' where instance_id = '#{admin_instance_id}'")
    logger.debug("Am I admin? - #{Zeus.is_admin}")
  end
end
