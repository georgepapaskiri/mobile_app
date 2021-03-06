CREATE DEFINER = 'root'@'%' PROCEDURE `proc_get_tariff_groups`(
        OUT `out_error_code` INTEGER,
        OUT `out_xml` TEXT
    )
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
    COMMENT ''
BEGIN
	DECLARE p_tariff_group_id INT;
    DECLARE p_tariff_group_name VARCHAR(50) CHARACTER SET utf8;
    DECLARE x TEXT CHARACTER SET utf8;
    DECLARE fin int default 0;
    DECLARE cur1 CURSOR FOR SELECT * FROM `view_tariff_groups`;
    DECLARE continue HANDLER for not found set fin = 1;
    SET x = "";
    OPEN cur1;
    get_res: LOOP
	    FETCH cur1 INTO p_tariff_group_id, p_tariff_group_name;
    	#SET x = CONCAT(x,1);
    	IF fin=1 THEN
        	LEAVE get_res;
        END IF;
        SET x = CONCAT(x,"<tariff_group><tariff_group_id>",p_tariff_group_id,"</tariff_group_id><tariff_group_name>",p_tariff_group_name,"</tariff_group_name></tariff_group>");
    END LOOP get_res;
    CLOSE cur1;
   	SET out_error_code = 0;
    SET out_xml = CONCAT("<tariff_groups>",x,"</tariff_groups>");
END;