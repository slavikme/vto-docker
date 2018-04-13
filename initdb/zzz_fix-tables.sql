ALTER TABLE `vto`.`guest` CHANGE COLUMN `useragent` `useragent` VARCHAR(255) NOT NULL DEFAULT '' ;
ALTER TABLE `vto`.`session` CHANGE COLUMN `useragent` `useragent` CHAR(255) NOT NULL DEFAULT '' ;