DROP DATABASE IF EXISTS `zeus`;
create database `zeus`;

DROP TABLE IF EXISTS `zeus`.`instance_snapshot`;

CREATE TABLE `zeus`.`instance_snapshot` (
  `id` BIGINT  NOT NULL AUTO_INCREMENT,
  `instance_id` VARCHAR(30)  NOT NULL,
  `max_processes` INT  NOT NULL,
  `active_processes` INT  NOT NULL,
  `process_count` INT  NOT NULL,
  `requests_in_queues` INT  NOT NULL,
  `requests_in_global_queue` INT  NOT NULL,
  `free_memory` INTEGER  NOT NULL,
  `date_time` TIMESTAMP  NOT NULL,
  PRIMARY KEY (`id`)
)
ENGINE = MyISAM;

