﻿CREATE DEFINER = 'mobexe'@'172.21.101.40' PROCEDURE `proc_get_account_info`(
        IN `in_token` VARCHAR(20),
        OUT `out_error_code` INTEGER,
        OUT `out_login` VARCHAR(7),
        OUT `out_tariff_id` INTEGER,
        OUT `out_tariff_name` VARCHAR(50),
        OUT `out_start_date` INTEGER,
        OUT `out_end_date` INTEGER,
        OUT `out_status` INTEGER,
        OUT `out_balance` DOUBLE,
        OUT `out_abon_pay` DOUBLE
    )
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
    COMMENT ''
BEGIN
	#параметры используемые внутри функции
	DECLARE p_count_id, p_user_id, p_count INT;
    #параметры использвемые внутри функции
	SELECT COUNT(user_id) INTO p_count_id FROM `AH_TOCKENS` WHERE token=in_token;#Подсчет количества указанных токенов в базе
    CASE p_count_id #Проверка колчиества
    	WHEN 0 THEN
        	SET out_error_code=3;#Токен не существует
        ELSE
        	SELECT user_id INTO p_user_id FROM `AH_TOCKENS` WHERE token=in_token;
            SELECT COUNT(*) INTO p_count FROM users WHERE id=p_user_id AND is_deleted=0;
            CASE p_count
            	WHEN 0 THEN
                	SET out_error_code = 2;
                ELSE
                	SET out_error_code = 0;
                	SELECT u.login, atl.tariff_id, t.name, dp.start_date, dp.end_date, a.block_id, a.balance, SUM(psd.cost) INTO out_login, out_tariff_id, out_tariff_name, out_start_date, out_end_date, out_status, out_balance, out_abon_pay FROM users AS u, accounts AS a, tariffs AS t, account_tariff_link AS atl, discount_periods AS dp, service_links AS sl, periodic_services_data as psd WHERE u.id=p_user_id AND u.basic_account=a.id AND u.is_deleted=0 AND atl.account_id=a.id AND atl.tariff_id=t.id AND atl.is_deleted=0 AND atl.discount_period_id=dp.id AND sl.account_id=u.basic_account AND sl.is_deleted=0 AND psd.id=sl.service_id;
    		END CASE;
    END CASE;
END;
