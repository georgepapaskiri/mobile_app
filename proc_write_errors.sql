CREATE DEFINER = 'root'@'%' PROCEDURE `proc_write_errors`(
        IN `in_error_code` INTEGER,
        IN `in_error_message` VARCHAR(255) CHARACTER SET utf8,
        IN `in_uip` VARCHAR(15) CHARACTER SET utf8,
        OUT `out_error_code` INTEGER
    )
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
    COMMENT ''
BEGIN
	DECLARE p_error_message VARCHAR(255) CHARACTER SET utf8;
	CASE in_error_code
    	WHEN 1 THEN SET p_error_message = 'Неверный логин или пароль';
        WHEN 2 THEN SET p_error_message = 'Пользователь не сущуствует';
        WHEN 3 THEN SET p_error_message = 'Токен не существует';
        WHEN 4 THEN SET p_error_message = 'Неверная группа тарифов';
        WHEN 5 THEN SET p_error_message = 'Неправильный ID тарифа';
        WHEN 300 THEN SET p_error_message = 'Другая ошибка';
        ELSE SET p_error_message = in_error_message;
    END CASE;
    SET out_error_code = 0;
    INSERT INTO `AH_ERRORS_LOG`(error_code,error_message,error_date_time,user_ip_address) VALUES(in_error_code,p_error_message,CONCAT(CURDATE(),' ',CURTIME()),in_uip);
END;