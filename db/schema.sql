
DROP TABLE IF EXISTS `zeus`.`instance_snapshot`;

CREATE TABLE `zeus`.`instance_snapshot` (
  `id` BIGINT  NOT NULL AUTO_INCREMENT,
  `instance_id` VARCHAR(30)  NOT NULL,
  `max_processes` TINYINT  NOT NULL,
  `active_processes` TINYINT  NOT NULL,
  `process_count` TINYINT  NOT NULL,
  `requests_in_queues` TINYINT  NOT NULL,
  `global_queues` TINYINT  NOT NULL,
  `free_memory` TINYINT  NOT NULL,
  `date_time` TIMESTAMP  NOT NULL,
  PRIMARY KEY (`id`)
)
ENGINE = MyISAM;

