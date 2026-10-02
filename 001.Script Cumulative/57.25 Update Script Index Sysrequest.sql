IF EXISTS (SELECT * FROM sys.indexes WHERE name='I_SysRequest_Param1' AND object_id = OBJECT_ID(N'SysRequest'))
Begin
DROP INDEX [I_SysRequest_Param1] ON [dbo].[SysRequest]
END
GO
IF EXISTS (SELECT * FROM sys.indexes WHERE name='I_SysRequest_Param2' AND object_id = OBJECT_ID(N'SysRequest'))
Begin
DROP INDEX [I_SysRequest_Param2] ON [dbo].[SysRequest]
END
GO
IF EXISTS (SELECT * FROM sys.indexes WHERE name='I_SysRequest_Param3' AND object_id = OBJECT_ID(N'SysRequest'))
Begin
DROP INDEX [I_SysRequest_Param3] ON [dbo].[SysRequest]
END
GO
IF EXISTS (SELECT * FROM sys.indexes WHERE name='I_SysRequest_Param4' AND object_id = OBJECT_ID(N'SysRequest'))
Begin
DROP INDEX [I_SysRequest_Param4] ON [dbo].[SysRequest]
END
GO
IF EXISTS (SELECT * FROM sys.indexes WHERE name='I_SysRequest_Param5' AND object_id = OBJECT_ID(N'SysRequest'))
Begin
DROP INDEX [I_SysRequest_Param5] ON [dbo].[SysRequest]
END
GO
IF EXISTS (SELECT * FROM sys.indexes WHERE name='I_SysRequest_UserID' AND object_id = OBJECT_ID(N'SysRequest'))
Begin
DROP INDEX [I_SysRequest_UserID] ON [dbo].[SysRequest]
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name='I_SysRequest_Param1_Param2_Param5' AND object_id = OBJECT_ID(N'SysRequest'))
Begin
CREATE NONCLUSTERED INDEX I_SysRequest_Param1_Param2_Param5 ON [dbo].[SysRequest]
(

	[Param1] ASC,
	Param2 ASC,
	Param5 ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name='I_SysRequest_Param1_Param2_USERID' AND object_id = OBJECT_ID(N'SysRequest'))
Begin
CREATE NONCLUSTERED INDEX I_SysRequest_Param1_Param2_USERID ON [dbo].[SysRequest]
(

	[Param1] ASC,
	Param2 ASC,
	UserID ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
END
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name='I_SysRequest_Param3_Param2' AND object_id = OBJECT_ID(N'SysRequest'))
Begin
CREATE NONCLUSTERED INDEX I_SysRequest_Param3_Param2 ON [dbo].[SysRequest]
(

	[Param3] ASC,
	Param2 ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name='I_SysRequest_Param4_Param2' AND object_id = OBJECT_ID(N'SysRequest'))
Begin
CREATE NONCLUSTERED INDEX I_SysRequest_Param4_Param2 ON [dbo].[SysRequest]
(

	[Param4] ASC,
	Param2 ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name='I_SysRequest_Param6_Param2' AND object_id = OBJECT_ID(N'SysRequest'))
Begin
CREATE NONCLUSTERED INDEX I_SysRequest_Param6_Param2 ON [dbo].[SysRequest]
(

	[Param6] ASC,
	Param2 ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
END
GO



IF not EXISTS (SELECT *  FROM sys.indexes WHERE name='i_ActionList' AND object_id = OBJECT_ID('ActionList'))
BEGIN
ALTER TABLE [dbo].ActionList  ADD  CONSTRAINT [i_ActionList] PRIMARY KEY CLUSTERED 
(
	ActionCode ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
end
GO
IF NOT EXISTS (SELECT *  FROM sys.indexes WHERE name='I_ActionUser' AND object_id = OBJECT_ID('ActionUser'))
BEGIN
CREATE NONCLUSTERED INDEX I_ActionUser ON [dbo].ActionUser
(

	ActionCode ASC,
	ActionUser ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
END
GO

insert into PatchVersioning
select '57.24 Update Script Index Sysrequest',GETDATE()
go

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='57.25 Update Script Index Sysrequest'


Declare @ExecScript varchar(100)
Declare @ExecScriptStatus varchar(100)
Declare @Error varchar(200)

Select @Error=''

Begin 
       Select @ExecScript=Execscript,  @ExecScriptStatus=ExecScriptStatus from systab 
       if @PrevScript<>'' and @ExecSCript<>@PrevScript
              THROW 51000, 'Not the Next Sequence Script', 1;
       else 
              if @ExecScriptStatus<>'' and @ExecScriptStatus<>'DONE'
              THROW 51000, 'Pending Script Execution', 1;

       Update SysTab Set ExecScript=@CurrScript, ExecScriptStatus='PENDING'             
       
       BEGIN TRY            
			PRINT '--EXECUTE DONE--'
       END TRY  
       BEGIN CATCH  
       END CATCH;


       Update SysTab Set ExecScript=@CurrScript, ExecScriptStatus='DONE'         
End
