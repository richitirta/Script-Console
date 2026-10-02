

----sp_helpindex ifrs_calculation
----go

IF EXISTS (SELECT * FROM sys.indexes WHERE name='I_IFRS_Calculation_AssumptionID_Method_Branch_Segment_ISType_TOC_Year_Month_NumMonths_Onerous' AND object_id = OBJECT_ID(N'IFRS_Calculation'))
Begin
DROP INDEX [I_IFRS_Calculation_AssumptionID_Method_Branch_Segment_ISType_TOC_Year_Month_NumMonths_Onerous] ON [dbo].[IFRS_Calculation]
END
GO
IF EXISTS (SELECT * FROM sys.indexes WHERE name='I_IFRS_Calculation_ProcessDate' AND object_id = OBJECT_ID(N'IFRS_Calculation'))
Begin
DROP INDEX [I_IFRS_Calculation_ProcessDate] ON [dbo].[IFRS_Calculation]
end
GO

IF EXISTS (SELECT * FROM sys.indexes WHERE name='I_IFRS_Calculation_AssumptionID_Method_Branch_Segment_ISType_TOC_CGroup_Currency_Year_Month_NumMonths_I_T_PGroupTag' AND object_id = OBJECT_ID(N'IFRS_Calculation'))
Begin
DROP INDEX I_IFRS_Calculation_AssumptionID_Method_Branch_Segment_ISType_TOC_CGroup_Currency_Year_Month_NumMonths_I_T_PGroupTag ON [dbo].[IFRS_Calculation]
END
go

/****** Object:  Index [I_IFRS_Calculation_AssumptionID_Method_Branch_Segment_ISType_TOC_CGroup_Currency_Year_Month_NumMonths_I_T_PGroupTag]    Script Date: 8/23/2024 5:39:30 PM ******/
CREATE NONCLUSTERED INDEX [I_IFRS_Calculation_AssumptionID_Method_Branch_Segment_ISType_TOC_CGroup_Currency_Year_Month_NumMonths_PGroupTag] ON [dbo].[IFRS_Calculation]
(
	[AssumptionID] ASC,
	[Method] ASC,
	[Branch] ASC,
	[Segment] ASC,
	[ISType] ASC,
	[TOC] ASC,
	[CGroup] ASC,
	[Currency] ASC,
	[Year] ASC,
	[Month] ASC,
	[NumMonths] ASC,
	[PGroupTag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
GO




----sp_helpindex ifrs_movement
----go

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='IFRS_Movement' AND CONSTRAINT_NAME='I_IFRS_Movement')
Begin
ALTER TABLE [dbo].[IFRS_Movement] DROP CONSTRAINT [I_IFRS_Movement] WITH ( ONLINE = OFF )
END
GO
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='IFRS_Movement' AND CONSTRAINT_NAME='I_IFRS_Movement')
Begin
DROP INDEX I_IFRS_Movement ON [dbo].[IFRS_Movement]
end
go
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name='I_IFRS_Movement' AND object_id = OBJECT_ID(N'IFRS_Movement'))
Begin
CREATE UNIQUE NONCLUSTERED INDEX [I_IFRS_Movement] ON [dbo].[IFRS_Movement]
(
	[GroupID] asc,
	[GroupType] ASC,
	[EffYear] ASC,
	[EffMonth] ASC,
	[ProcessDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
end
GO

IF EXISTS (SELECT * FROM sys.indexes WHERE name='I_IFRS_Movement_GroupID_ProcessDate_GroupType' AND object_id = OBJECT_ID(N'IFRS_Movement'))
Begin
DROP INDEX I_IFRS_Movement_GroupID_ProcessDate_GroupType ON [dbo].[IFRS_Movement]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name='I_IFRS_Movement_GroupID_ProcessDate_GroupType' AND object_id = OBJECT_ID(N'IFRS_Movement'))
Begin
CREATE NONCLUSTERED INDEX I_IFRS_Movement_GroupID_ProcessDate_GroupType ON [dbo].[IFRS_Movement] ([GroupID] ASC, [ProcessDate] ASC, [GroupType] ASC);
END
GO
IF EXISTS (SELECT * FROM sys.indexes WHERE name='I_IFRS_Movement_ProcessDate' AND object_id = OBJECT_ID(N'IFRS_Movement'))
Begin
DROP INDEX [I_IFRS_Movement_ProcessDate] ON [dbo].[IFRS_Movement]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name='I_IFRS_Movement_ProcessDate' AND object_id = OBJECT_ID(N'IFRS_Movement'))
Begin
CREATE NONCLUSTERED INDEX I_IFRS_Movement_ProcessDate ON [dbo].[IFRS_Movement] ([ProcessDate] ASC);
END
GO


  insert into PatchVersioning
select '1145 Update Script - Index IFRS_MOVEMENT - IFRS_Calculation',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1145 Update Script - Index IFRS_MOVEMENT - IFRS_Calculation'


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

	

