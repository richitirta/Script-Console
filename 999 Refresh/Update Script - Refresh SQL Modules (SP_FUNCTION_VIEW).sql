SET NOCOUNT ON;

DECLARE @RowIndex AS SMALLINT = 1
Declare @ObjectType as NVARCHAR(128)
Declare @ObjectName AS NVARCHAR(128)
Declare @Sql AS NVARCHAR(MAX)
       

-- Get list of objects (stored procedures, functions) to be refreshed
DECLARE @ObjectsTable AS Table (RowIndex SMALLINT IDENTITY(1,1), ObjectType nvarchar(60), ObjectName NVARCHAR(128), IsRefreshed BIT, Error NVARCHAR(MAX))
INSERT INTO @ObjectsTable (ObjectType, ObjectName, IsRefreshed)
SELECT O.type_desc, SCHEMA_NAME(O.schema_id) + '.' + O.name, 1
FROM
        sys.sql_modules M
        INNER JOIN sys.objects O ON O.object_id = M.object_id
WHERE
        O.is_ms_shipped = 0
        AND O.type_desc NOT IN ('RULE')
ORDER BY O.type_desc, O.name

-- For each function/sp...
WHILE @RowIndex <= (SELECT COUNT(*) FROM @ObjectsTable)
BEGIN  
        SELECT @ObjectType = ObjectType, @ObjectName = ObjectName        
        FROM @ObjectsTable
        WHERE RowIndex = @RowIndex
       
        if @ObjectType='VIEW'
        BEGIN
			SET @Sql = 'EXEC sp_refreshview ''' + @ObjectName + ''''
		END
		ELSE
		BEGIN
			SET @Sql = 'EXEC sp_refreshsqlmodule ''' + @ObjectName + ''''
		END
		
        BEGIN TRY
                EXEC sp_executesql @Sql
        END TRY
        BEGIN CATCH
                UPDATE @ObjectsTable
                SET
                        IsRefreshed = 0,
                        Error = ERROR_MESSAGE()
                WHERE RowIndex = @RowIndex
               
                IF @@TRANCOUNT > 0
                        ROLLBACK TRAN
        END CATCH
                                                               
        -- Process next object
        SET @RowIndex = @RowIndex + 1
END


-- List all objects not refreshed
SELECT ObjectType, ObjectName, IsRefreshed, Error
FROM @ObjectsTable
WHERE IsRefreshed = 0
GO