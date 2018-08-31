CREATE TABLE `AH_TOCKENS` (
  `user_id` INTEGER(11) NOT NULL,
  `token` VARCHAR(20) COLLATE utf8_general_ci NOT NULL,
  UNIQUE KEY `user_id` USING BTREE (`user_id`),
  UNIQUE KEY `token` USING BTREE (`token`)
) ENGINE=InnoDB
CHARACTER SET 'utf8' COLLATE 'utf8_general_ci'
;