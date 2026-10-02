
/****** Object:  Index [I_get_SysRequest]    Script Date: 7/5/2024 1:25:43 PM ******/
DROP INDEX [I_get_SysRequest] ON [dbo].[SysRequest]
GO

/****** Object:  Index [I_get_SysRequest]    Script Date: 7/5/2024 1:25:43 PM ******/
CREATE NONCLUSTERED INDEX [I_get_SysRequest] ON [dbo].[SysRequest]
(
	[Param1] ASC,
	[UserID] ASC,
	[Status] ASC,
	[Param2] ASC
)
INCLUDE ( 	[ID],
	[Remarks],
	[Param3],
	[Param4],
	[Param5],
	[Param6],
	[UserDate],
	[UserTime],
	[ActionCode],
	[DueDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO



/****** Object:  Index [I_SysRequest_Param5_Param2_Param1]    Script Date: 7/5/2024 1:24:46 PM ******/
DROP INDEX [I_SysRequest_Param5_Param2_Param1] ON [dbo].[SysRequest]
GO

/****** Object:  Index [I_SysRequest_Param5_Param2_Param1]    Script Date: 7/5/2024 1:24:46 PM ******/
CREATE NONCLUSTERED INDEX [I_SysRequest_Param5_Param2_Param1] ON [dbo].[SysRequest]
(
	[Param5] ASC,
	[Param2] ASC,
	[Param1] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF, FILLFACTOR = 80) ON [PRIMARY]
GO



/****** Object:  Index [I_SysRequest_UserID_Param2_Param1]    Script Date: 7/5/2024 1:23:51 PM ******/
DROP INDEX [I_SysRequest_UserID_Param2_Param1] ON [dbo].[SysRequest]
GO

/****** Object:  Index [I_SysRequest_UserID_Param2_Param1]    Script Date: 7/5/2024 1:23:51 PM ******/
CREATE NONCLUSTERED INDEX [I_SysRequest_UserID_Param2_Param1] ON [dbo].[SysRequest]
(
	[UserID] ASC,
	[Param2] ASC,
	[Param1] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF, FILLFACTOR = 80) ON [PRIMARY]
GO



insert into PatchVersioning
select '1102 UPDATE SCRIPT - INDEX SYSREQUEST',GETDATE()
go
	

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1102 UPDATE SCRIPT - INDEX SYSREQUEST'


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




go
