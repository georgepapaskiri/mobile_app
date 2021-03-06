CREATE DEFINER = 'root'@'%' PROCEDURE `proc_get_token`(
        IN `in_login` VARCHAR(7) CHARACTER SET utf8,
        IN `in_pass` VARCHAR(255) CHARACTER SET utf8,
        OUT `out_error_code` INTEGER,
        OUT `out_token` VARCHAR(20) CHARACTER SET utf8
    )
    NOT DETERMINISTIC
    CONTAINS SQL
    SQL SECURITY DEFINER
    COMMENT 'Procedure for creatung token and given it to user'
BEGIN
	#параметры использвемые внутри функции
	DECLARE p_user_id, p_id_count, p_count, p_error_code INT;
    DECLARE p_token VARCHAR(20) CHARACTER SET utf8;
    #параметры использвемые внутри функции
	SELECT id INTO p_user_id FROM users WHERE login=in_login AND password=in_pass AND is_deleted=0;#Поиск ID абонента
    CASE COALESCE(p_user_id, 0)#Проверка существования ID
    	WHEN 0 THEN
            SET out_error_code = 1;#1 - неверный логин пароль
        ELSE
        	SET out_error_code=0;#Успешно
            REPEAT
            	#Генерация токена
            	SET @returnstr = '';
            	SET @allowedChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
            	SET @i = 0;
            	WHILE (@i < 20) DO
 	          		SET @returnstr = CONCAT(@returnstr, substring(@allowedChars, FLOOR(RAND() * LENGTH(@allowedChars) + 1), 1));
                	SET @i = @i + 1;
            	END WHILE;
            	SET p_token = @returnstr;
            	#Генерация токена
                SELECT COUNT(*) INTO p_count FROM `AH_TOCKENS` WHERE token=p_token;#Поиск сгенерированного токена среди существующих
            UNTIL p_count=0
            END REPEAT;
            SELECT COUNT(*) INTO p_id_count FROM `AH_TOCKENS` WHERE user_id=p_user_id; #Проверка наличия записи о данном user_id
            CASE p_id_count
            	WHEN 0 THEN
                    INSERT INTO `AH_TOCKENS`(user_id,token) VALUES (p_user_id, p_token);#Вставка новой записи
                    SET out_token = p_token;
                WHEN 1 THEN
                    UPDATE `AH_TOCKENS` SET token=p_token WHERE user_id=p_user_id;#Обновление существующей записи
                    SET out_token = p_token;
                ELSE
                    SET out_error_code = 300;
                END CASE;
    END CASE;
END;