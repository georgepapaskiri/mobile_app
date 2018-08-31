CREATE DEFINER = 'mobexe'@'172.21.101.40' PROCEDURE `proc_get_payments`(
        IN `in_token` VARCHAR(20) CHARACTER SET utf8,
        IN `in_month` VARCHAR(2) CHARACTER SET utf8,
        IN `in_year` VARCHAR(4) CHARACTER SET utf8,
        OUT `out_error_code` INTEGER,
        OUT `out_xml` TEXT CHARACTER SET utf8
    )
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
    COMMENT ''
BEGIN
	DECLARE p_user_id, p_account_id, p_date INT;
    DECLARE p_amount DOUBLE;
    DECLARE x TEXT CHARACTER SET utf8;
    DECLARE p_start_date VARCHAR(50) CHARACTER SET utf8 DEFAULT CONCAT(in_year,"-",in_month,"-01 00:00:00");
    DECLARE p_end_date VARCHAR(50) CHARACTER SET utf8 DEFAULT CONCAT(in_year,"-",in_month+1,"-01 00:00:00");
    DECLARE fin int default 0;
    DECLARE cur1 CURSOR FOR SELECT payment_enter_date ,payment_incurrency FROM `payment_transactions` WHERE account_id=p_account_id AND payment_enter_date BETWEEN UNIX_TIMESTAMP(p_start_date) and UNIX_TIMESTAMP(p_end_date);
    DECLARE cur2 CURSOR FOR SELECT payment_enter_date ,payment_incurrency FROM `payment_transactions_1461238933_1535011087` WHERE account_id=p_account_id AND payment_enter_date BETWEEN UNIX_TIMESTAMP(p_start_date) and UNIX_TIMESTAMP(p_end_date);
    DECLARE continue HANDLER for not found set fin = 1;
    SET p_user_id = (SELECT user_id INTO p_user_id FROM `AH_TOCKENS` WHERE token=in_token);
	CASE COALESCE(p_user_id,0)
    	WHEN 0 THEN
        	SET out_error_code = 3;
        ELSE
            SET p_account_id = (SELECT basic_account INTO p_account_id FROM `users` WHERE id=p_user_id AND is_deleted=0);
            CASE COALESCE(p_account_id,0)
            	WHEN 0 THEN
                	SET out_error_code = 2;
                ELSE
                	SET out_error_code = 0;
                    SET x = '';
                    OPEN cur1;
                    get_res: LOOP
                    	FETCH cur1 INTO p_date, p_amount;
                        IF fin=1 THEN
        					LEAVE get_res;
        				END IF;
        				SET x = CONCAT(x,"<payment><name>Пополнение счета</name><date>",p_date,"</date><amount>",p_amount,"</amount></payment>");
                    END LOOP get_res;
                    CLOSE cur1;
                    SET fin=0;
                    OPEN cur2;
                    get_res: LOOP
                    	FETCH cur2 INTO p_date, p_amount;
                        IF fin=1 THEN
        					LEAVE get_res;
        				END IF;
        				SET x = CONCAT(x,"<payment><name>Пополнение счета</name><date>",p_date,"</date><amount>",p_amount,"</amount></payment>");
                    END LOOP get_res;
                    CLOSE cur2;
                    SET out_xml = CONCAT("<payments>",x,"</payments>");
			END CASE;
    END CASE;
END;