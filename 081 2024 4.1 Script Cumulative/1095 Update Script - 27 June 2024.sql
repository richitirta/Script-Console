IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SysBatchOriginalBC_Ext_1') AND type in (N'U'))
BEGIN
/****** Object:  Table [dbo].[SysBatchOriginalBC_Ext_1]    Script Date: 6/26/2024 8:26:13 PM ******/
SET ANSI_NULLS ON
 

SET QUOTED_IDENTIFIER ON
 

CREATE TABLE [dbo].[SysBatchOriginalBC_Ext_1](
	[bid] [int] NOT NULL
) ON [PRIMARY]



Create Unique index I_SysBatchOriginalBC_Ext_1 on SysBatchOriginalBC_Ext_1(BID)

ALTER TABLE [dbo].[SysBatchOriginalBC_Ext_1] SET (LOCK_ESCALATION = DISABLE)
end
GO


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SysBatchOriginalBE_Ext_1') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SysBatchOriginalBE_Ext_1](
	[bid] [int] NOT NULL
) ON [PRIMARY]


Create Unique index I_SysBatchOriginalBE_Ext_1 on SysBatchOriginalBE_Ext_1(BID)

ALTER TABLE [dbo].[SysBatchOriginalBE_Ext_1] SET (LOCK_ESCALATION = DISABLE)
end
go


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SysBatchOriginalSC_Ext_1') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SysBatchOriginalSC_Ext_1](
	[bid] [int] NOT NULL
) ON [PRIMARY]


Create Unique index I_SysBatchOriginalSC_Ext_1 on SysBatchOriginalSC_Ext_1(BID)

ALTER TABLE [dbo].[SysBatchOriginalSC_Ext_1] SET (LOCK_ESCALATION = DISABLE)
end
go


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SysBatchOriginalUP_Ext_1') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SysBatchOriginalUP_Ext_1](
	[bid] [int] NOT NULL
) ON [PRIMARY]


Create Unique index I_SysBatchOriginalUP_Ext_1 on SysBatchOriginalUP_Ext_1(BID)

ALTER TABLE [dbo].[SysBatchOriginalUP_Ext_1] SET (LOCK_ESCALATION = DISABLE)
end
GO


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SysBatchBC_Ext_1') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SysBatchBC_Ext_1](
	[bid] [int] NOT NULL
) ON [PRIMARY]


Create Unique index I_SysBatchBC_Ext_1 on SysBatchBC_Ext_1(BID)

ALTER TABLE [dbo].[SysBatchBC_Ext_1] SET (LOCK_ESCALATION = DISABLE)
end
GO


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SysBatchBE_Ext_1') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SysBatchBE_Ext_1](
	[bid] [int] NOT NULL
) ON [PRIMARY]


Create Unique index I_SysBatchBE_Ext_1 on SysBatchBE_Ext_1(BID)

ALTER TABLE [dbo].[SysBatchBE_Ext_1] SET (LOCK_ESCALATION = DISABLE)
end
go


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SysBatchSC_Ext_1') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SysBatchSC_Ext_1](
	[bid] [int] NOT NULL
) ON [PRIMARY]


Create Unique index I_SysBatchSC_Ext_1 on SysBatchSC_Ext_1(BID)

ALTER TABLE [dbo].[SysBatchSC_Ext_1] SET (LOCK_ESCALATION = DISABLE)
end
GO

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SysBatchUP_Ext_1') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[SysBatchUP_Ext_1](
	[bid] [int] NOT NULL
) ON [PRIMARY]


Create Unique index I_SysBatchUP_Ext_1 on SysBatchUP_Ext_1(BID)

ALTER TABLE [dbo].[SysBatchUP_Ext_1] SET (LOCK_ESCALATION = DISABLE)
end
GO










insert into PatchVersioning
select '1095 Update Script - 27 June 2024',GETDATE()
go
	

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1093 Update Script - 27 June 2024'


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
