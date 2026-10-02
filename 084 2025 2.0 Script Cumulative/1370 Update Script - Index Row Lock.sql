
DECLARE @Table_Name varchar(255)
DECLARE @Index_Name varchar(255)
Declare @SQLStatement nvarchar(255)

Declare SQL_cursor Cursor For 
Select S2.Name as Table_Name, S1.Name as Index_Name
from sys.indexes S1, sys.objects S2 
Where S2.object_id=S1.object_id 
and S2.Type_Desc='USER_TABLE'
and S2.Name Not Like 'X%'
and S2.Name Not Like 'Z%'
and S2.Name Not Like 'dtprop%'
and S2.Name Not Like 'dtprop%'
and S2.Name Not Like 'sysdiagram%'
and not S1.Name is null
and S1.allow_page_locks=1


Open SQL_cursor
FETCH FROM SQL_cursor into @Table_Name, @Index_Name
WHILE @@FETCH_STATUS = 0  
BEGIN  
	Select @SQLStatement='ALTER INDEX [' + @Index_Name + '] ON [' + @Table_Name +'] REBUILD WITH (ALLOW_PAGE_LOCKS = OFF, ALLOW_ROW_LOCKS = ON)' 

	execute sp_executesql @SQLStatement
	FETCH Next FROM SQL_cursor into @Table_Name, @Index_Name
End  
Close SQL_cursor  
Deallocate SQL_cursor




