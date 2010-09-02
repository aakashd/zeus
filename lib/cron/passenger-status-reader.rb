require 'rubygems'
require 'wrest'
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

p passenger_status

free_memory = `free -m`.split("\n").find(){ |l| l.include? "Mem" }.split("\s")[3]

p "free_memory => " + free_memory

instance_id = "http://169.254.169.254/latest/meta-data/instance-id".to_uri.get.body

p instance_id
