
DECLARE @Table_Name varchar(255)
Declare @CONSTRAINT_NAME varchar(255)
Declare @SQLStatement nvarchar(255)

Declare SQL_cursor Cursor For 
SELECT
obj_table.name,
obj_Constraint.NAME AS CONSTRAINT_NAME
FROM sys.objects AS obj_table 
LEFT JOIN sys.objects AS obj_Constraint ON obj_table.object_id = obj_Constraint.parent_object_id 
LEFT JOIN sys.sysconstraints AS constraints ON constraints.constid = obj_Constraint.object_id 
LEFT JOIN sys.columns AS columns ON columns.object_id = obj_table.object_id AND columns.column_id = constraints.colid 
WHERE Obj_Table.Type='U' and obj_Constraint.type_desc='DEFAULT_CONSTRAINT'
ORDER BY obj_table.name,obj_Constraint.type_desc

Open SQL_cursor
FETCH FROM SQL_cursor into @Table_Name, @CONSTRAINT_NAME
WHILE @@FETCH_STATUS = 0  
BEGIN  
	Select @SQLStatement='Alter Table ' + @Table_Name +' Drop Constraint '+ @CONSTRAINT_NAME

	execute sp_executesql @SQLStatement
	FETCH Next FROM SQL_cursor into @Table_Name, @CONSTRAINT_NAME
End  
Close SQL_cursor  
Deallocate SQL_cursor




