SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_D_COLLECT]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN DROP FUNCTION [dbo].[CL_D_COLLECT] END
GO

CREATE function [dbo].[CL_D_COLLECT](@P_CollNo as varchar(50)) 
RETURNS TABLE 
AS RETURN 
( 
Select C1.Collno, C1.RefNo as Collection_RefNo, Admlink.Voucher, Admlink.Type, Admlink.Remarks, Admlink.A_PolicyNo as A_PolicyNo, Admlink.RefNo as Policy_RefNo, C2.Currency, C2.Amount
from CollectionH C1, CollectionV C2, CollAmount C3, Admlink 
Where C2.CollNo=C1.CollNo and C3.CollNo=C1.CollNo and C3.Currency=C2.Currency and Admlink.Voucher=C2.Voucher 
and C1.CollNo=@P_CollNo 
) 

GO


insert into PatchVersioning
select '1434 Update Script - Patch 2025 (44)',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrScript='1434 Update Script - Patch 2025 (44)'


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
