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

drop table if exists `zeus`.`instances`;

create table `zeus`.`instances`(
  `instance_id` varchar(30) not null primary key,
  `created_at` timestamp not null,
  `last_updated_at` timestamp not null,
  `status` varchar(15) not null
)
ENGINE = MyISAM;

drop table if exists `zeus`.`admin_instance`;
create table `zeus`.`admin_instance`(
  `instance_id` varchar(30) not null primary key
)
ENGINE = MyISAM;