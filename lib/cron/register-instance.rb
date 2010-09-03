#!ruby
require File.expand_path(File.dirname(__FILE__) + '/../zeus')

logger = Zeus.logger

insert_stmt = "insert into instances(instance_id,created_at,last_updated_at,status) values('#{Zeus.instance_id}',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'running')"

logger.info(insert_stmt)

Zeus.connection.query(insert_stmt)

logger.info("affected rows for previous insert - #{Zeus.connection.affected_rows}")

admin_id = Zeus.get_admin_instance_id

if admin_id.nil? || admin_id.empty?
  Zeus.connection.query("delete from admin_instance")
  Zeus.connection.query("insert into admin_instance values('#{Zeus.instance_id}')")
end
