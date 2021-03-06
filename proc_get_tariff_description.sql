CREATE DEFINER = 'root'@'%' PROCEDURE `proc_get_tariff_description`(
        IN `in_tariff_id` INTEGER,
        OUT `out_error_code` INTEGER,
        OUT `out_name` VARCHAR(50) CHARACTER SET utf8,
        OUT `out_desc` VARCHAR(255) CHARACTER SET utf8,
        OUT `out_abon` DOUBLE,
        OUT `out_speed` VARCHAR(10) CHARACTER SET utf8
    )
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
    COMMENT ''
BEGIN
	DECLARE p_count INT;
    SET p_count = (SELECT COUNT(*) FROM `tariffs` WHERE id=in_tariff_id AND is_deleted=0);
	CASE p_count
    	WHEN 0 THEN 
        	SET out_error_code = 5;
        ELSE
        	SET out_error_code = 0;
            SELECT t.`name`, t.`comments`, SUBSTRING(t.`name`, INSTR(t.`name`,' ')+1), SUM(psd.`cost`) INTO out_name, out_desc, out_speed, out_abon FROM `tariffs` AS t, `tariffs_services_link` AS tsl, `periodic_services_data` AS psd WHERE t.`id`=in_tariff_id AND t.`id`=tsl.`tariff_id` AND `tsl`.`service_id` = psd.`id` AND t.`is_deleted`=0 AND psd.`is_deleted`=0;
    END CASE;
END;