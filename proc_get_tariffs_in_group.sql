CREATE DEFINER = 'root'@'%' PROCEDURE `proc_get_tariffs_in_group`(
        IN `in_tariff_group_id` INTEGER,
        OUT `out_error_code` INTEGER,
        OUT `out_xml` TEXT CHARACTER SET utf8
    )
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
    COMMENT ''
BEGIN
	DECLARE p_tariff_id INT;
    DECLARE p_tariff_name VARCHAR(50) CHARACTER SET utf8;
    DECLARE x TEXT CHARACTER SET utf8;
    DECLARE fin int default 0;
    DECLARE cur1 CURSOR FOR SELECT t.`id`, t.`name` FROM `AH_TARIFF_GROUPS` AS atg, `tariffs` AS t WHERE atg.`tariff_group_id`=in_tariff_group_id AND atg.`tariff_id`=t.id AND t.`is_deleted`=0;
    DECLARE continue HANDLER for not found set fin = 1;
    SET x = "";
    IF (in_tariff_group_id = 1 or in_tariff_group_id = 2) THEN
    	OPEN cur1;
        get_res: LOOP
	    	FETCH cur1 INTO p_tariff_id, p_tariff_name;
        	#SET x = CONCAT(x,1);
    		IF fin=1 THEN
        		LEAVE get_res;
        	END IF;
        	SET x = CONCAT(x,"<tariff><tariff_id>",p_tariff_id,"</tariff_id><tariff_name>",p_tariff_name,"</tariff_name></tariff>");
    	END LOOP get_res;
    	CLOSE cur1;
        SET out_error_code = 0;
    ELSE
        SET out_error_code = 4;
    END IF;
    SET out_xml = CONCAT("<tariffs>",x,"</tariffs>");
END;