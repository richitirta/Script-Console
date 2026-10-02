
DECLARE @Table_Name varchar(255)
Declare @SQLStatement nvarchar(255)

Declare SQL_cursor Cursor For 
SELECT object_name (t.object_id) as table_name
FROM sys.tables t, sys.schemas s
WHERE s.name = 'dbo' 
and s.schema_id = t.schema_id 
and t.lock_escalation_desc<>'DISABLE'

Open SQL_cursor
FETCH FROM SQL_cursor into @Table_Name
WHILE @@FETCH_STATUS = 0  
BEGIN  
	Select @SQLStatement='Alter Table ['+ @Table_Name +'] SET (LOCK_ESCALATION = DISABLE) '

	execute sp_executesql @SQLStatement
	FETCH Next FROM SQL_cursor into @Table_Name
End  
Close SQL_cursor  
Deallocate SQL_cursor




