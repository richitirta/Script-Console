/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
GO

ALTER TABLE dbo.PScale
	DROP CONSTRAINT I_PScale
GO
ALTER TABLE dbo.PScale ADD
	VALUEID varchar(15) NULL
GO
DECLARE @v sql_variant 
SET @v = N'Value ID from FieldMap'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'PScale', N'COLUMN', N'VALUEID'
GO
Update PScale Set VALUEID='' Where VALUEID is null
GO
ALTER TABLE dbo.PScale ADD CONSTRAINT
	I_PScale UNIQUE NONCLUSTERED 
	(
	TOC,
	Basis,
	NOP,
	VALUEID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO


DROP Procedure QPREMIUM_SCALE
GO
CREATE Procedure QPREMIUM_SCALE(@P_TOC varchar(255), @P_BASIS varchar(255), @P_NOP float, @P_ValueID varchar(15)='')  
as  
if not exists(Select Top 1 PScale.TOC From PScale Where PSCale.TOC=@P_TOC)  
 SELECT top 1 ScaleTab.*  
 From TOC  
 Inner Join ScaleTab on (ScaleTab.COB=TOC.COB And ScaleTab.Basis=@P_Basis And @P_NOP<=ScaleTab.NOP)  
 WHERE  TOC.TOC=@P_TOC   
 ORDER BY ScaleTab.NOP ASC;  
Else  
 Select top 1 PScale.*  
 From PScale  
 Where PSCale.TOC=@P_TOC And PScale.Basis=@P_Basis And @P_NOP<=PScale.NOP  and PScale.ValueID=@P_ValueID
 Order By PScale.NOP asc;  
 
GO
 
insert into PatchVersioning
select '1503 Update Script - 3 December 2025.sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1503 Update Script - 3 December 2025.sql'


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

GO 