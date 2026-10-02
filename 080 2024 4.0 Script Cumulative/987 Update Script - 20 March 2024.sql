IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'MSCode' AND Object_ID = Object_ID(N'Scheme_Transaction'))
BEGIN
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

ALTER TABLE dbo.Scheme_Transaction ADD
	MSCode varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'MSCode (see MSCode Table)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Transaction', N'COLUMN', N'MSCode'
end
GO

DROP Procedure QScheme_Verify_1
GO
CREATE Procedure QScheme_Verify_1(@p_PolicyNo as varchar(50), @p_LANO int=-1)      
as        
if @p_LANO=-1   
	Select top 1 A.CNO, A.LANO, A.STIME, A.ETIME, A.BRANCH, A.CT, A.REGNO, A.MSCODE, A.BizMapID, A.RenewableF, A.PWordingID
	from Acceptance A where ANO = LANO and PolicyNo = @p_PolicyNo and AType in ('N','E') and AStatus='I'  
Else  
	Select top 1 A.CNO, A.LANO, A.STIME, A.ETIME, A.BRANCH, A.CT, A.REGNO, A.MSCODE, A.BizMapID, A.RenewableF, A.PWordingID
	from Acceptance A, Acceptance oA 
	Where oA.ANO=@P_LANO and oA.ANO=oA.LANO and A.OANO=oA.OANO and A.ANO=A.LANO and A.AType in ('N','E') and A.AStatus='I'  


go



insert into PatchVersioning
select '987 Update Script - 20 March 2024',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='987 Update Script - 20 March 2024'


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