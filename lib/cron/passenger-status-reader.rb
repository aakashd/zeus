require File.dirname(__FILE__) + '/../zeus'

# reading passenger-status
status = `passenger-status`
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

p passenger_status

# reading the system free memory
free_memory = `free -m`.split("\n").find(){ |l| l.include? "Mem" }.split("\s")[3]

p "free_memory => " + free_memory

# reading instance meta-data
instance_id = "http://169.254.169.254/latest/meta-data/instance-id".to_uri.get.body

p instance_id

# dumping all info into DB
insert_stmt = "insert into #{Zeus.config['db_database']}.instance_snapshot(instance_id,max_processes,active_processes,process_count,requests_in_queues,requests_in_global_queue,free_memory,date_time) values('#{instance_id}',#{passenger_status['max']},#{passenger_status['active']},#{passenger_status['count']},#{passenger_status['requests_in_queues']},#{passenger_status['global_queue']},#{free_memory},CURRENT_TIMESTAMP)"

p insert_stmt

Zeus.connection.query(insert_stmt)

p Zeus.connection.affected_rows
