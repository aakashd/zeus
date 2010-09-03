#!ruby
require File.expand_path(File.dirname(__FILE__) + '/../zeus')

logger = Zeus.logger

# reading passenger-status
status = `/opt/ruby-enterprise-1.8.7-2010.02/bin/passenger-status`
status_lines = status.split("\n")

passenger_status = {}
status_lines.each{ |line|
  if line.include? "="
    key_value_pair = line.split("=")
    passenger_status[key_value_pair[0].strip] = key_value_pair[1].strip
  elsif line.include? "Waiting on global queue:"
    passenger_status["global_queue"] = line.split(":")[1].strip
  elsif line.include? "PID"
    requests_in_queues = passenger_status["requests_in_queues"] || 0
    request_in_queue_for_process = line.split("\s")[3].to_i
    requests_in_queues += (request_in_queue_for_process - 1) if request_in_queue_for_process > 0
    passenger_status["requests_in_queues"] = requests_in_queues
  end
}

passenger_status["requests_in_queues"] = 0 if passenger_status["requests_in_queues"].nil?

logger.info("passenger status - #{passenger_status}")

# reading the system free memory
free_memory = `free -m`.split("\n").find(){ |l| l.include? "Mem" }.split("\s")[3]

logger.info("free_memory => #{free_memory}")

# reading instance meta-data
instance_id = Zeus.instance_id

logger.debug("updating the snapshot for instance #{instance_id}")
# dumping all info into DB
insert_stmt = "insert into #{Zeus.config['db_database']}.instance_snapshot(instance_id,max_processes,active_processes,process_count,requests_in_queues,requests_in_global_queue,free_memory,date_time) values('#{instance_id}',#{passenger_status['max']},#{passenger_status['active']},#{passenger_status['count']},#{passenger_status['requests_in_queues']},#{passenger_status['global_queue']},#{free_memory},CURRENT_TIMESTAMP)"

Zeus.connection.query(insert_stmt)

update_stmt = "update instances set last_updated_at = CURRENT_TIMESTAMP where instance_id = '#{Zeus.instance_id}'"

logger.debug("updating the las updated time")

Zeus.connection.query(update_stmt)
