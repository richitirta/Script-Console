ALTER FUNCTION fn_toval(@sValue varchar(255))          
RETURNS FLOAT AS            
BEGIN          
    DECLARE @temp FLOAT  
    SET @temp = 0            

    SET @sValue = REPLACE(@sValue, ',', '.')

    IF (LEN(@sValue) > 1 AND ISNUMERIC(@sValue) = 1) 
       OR (LEN(@sValue) = 1 AND CHARINDEX(@sValue,'1234567890') <> 0)  
    BEGIN
        SET @temp = CAST(@sValue AS FLOAT)
    END
    ELSE  
        SET @temp = 0            

    RETURN @temp        
END
