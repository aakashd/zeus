#!ruby
require File.dirname(__FILE__) + '/../zeus'

insert_stmt = "insert into instances(instance_id,created_at,last_updated_at) values('#{Zeus.instance_id}',CURRENT_TIMESTAMP,CURRENT_TIMESTAMP)"

p insert_stmt

Zeus.connection.query(insert_stmt)

p Zeus.connection.affected_rows
