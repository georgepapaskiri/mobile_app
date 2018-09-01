SET @returnstr = '';
SET @allowedChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
SET @i = 0;
WHILE (@i < 20) DO
	SET @returnstr = CONCAT(@returnstr, substring(@allowedChars, FLOOR(RAND() * LENGTH(@allowedChars) + 1), 1));
    SET @i = @i + 1;
END WHILE;
SET out_token = @returnstr;
