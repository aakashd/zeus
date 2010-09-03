#!ruby
require File.dirname(__FILE__) + '/../zeus'

logger = Zeus.logger

if Zeus.is_admin

  ten_min_back = Time.now - 600

  logger.info('checking avg_queu for the farm')
  avg_queue = Zeus.connection.query("select avg(s.requests_in_queues + s.requests_in_global_queue) from instance_snapshot s, instances i where s.instance_id = i.instance_id and i.status = 'running' and s.date_time > '#{ten_min_back.strftime('%Y-%m-%d %H:%M:%S')}'").fetch_row[0]
  logger.info("average queue for farm is #{avg_queue}")

  logger.info('checking average max_processes for the farm')
  avg_max_processes = Zeus.connection.query("select avg(max_processes) from instance_snapshot where date_time > '#{ten_min_back.strftime('%Y-%m-%d %H:%M:%S')}'").fetch_row[0]
  logger.info("avg_max_processes - #{avg_max_processes}")

  
  logger.info('checking average active_processes for the farm')
  avg_active_processes = Zeus.connection.query("select avg(active_processes) from instance_snapshot where date_time > '#{ten_min_back.strftime('%Y-%m-%d %H:%M:%S')}'").fetch_row[0]
  logger.info("avg_active_processes - #{avg_active_processes}")

  if !avg_queue.nil? && avg_queue.to_f > 10.0

    logger.debug("starting another 3 instances as avg_queue is more than 10")
    instances = Zeus.ec2.run_instances(Zeus.ec2_config['ami'],1,3,[Zeus.ec2_config['security_group']],Zeus.ec2_config['key'])
    new_instance_ids = instances.collect{|i| i[:aws_instance_id] }
    Zeus.elb.elb.register_instances_with_load_balancer(Zeus.ec2_config['elb-name'], *instance_ids)

  elsif !avg_queue.nil? && avg_queue.to_f == 0
    
    logger.debug("planning to remove instances")

    current_total_instance = Zeus.all_live_instances.size
    logger.debug("current_total_instances - #{current_total_instance}")
    
    required_instances = ((avg_active_processes / avg_max_processes) * current_total_instance).ceil
    logger.debug("required_instances #{required_instances}")

    required_instances = 1 if required_instances == 0

    current_instance_ids = Zeus.elb.describe_load_balancers(Zeus.ec2_config['elb-name'])[0][:instances]
    logger.debug("current_instance_ids - #{current_instance_ids}")

    instances_to_be_removed = current_total_instance[required_instances..current_total_instance.size]
    logger.debug("instances_to_be_removed - #{instances_to_be_removed}")

    Zeus.elb.deregister_instances_with_load_balancer(Zeus.ec2_config['elb-name'],*instances_to_be_removed)
    logger.debug("deregistered instances")

    Zeus.ec2.ec2.terminate_instances(*instances_to_be_removed)
    logger.debug("terminated the instances")
  end

end
