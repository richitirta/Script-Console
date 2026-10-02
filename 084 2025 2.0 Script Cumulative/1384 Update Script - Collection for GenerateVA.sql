SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CL_A_COLLECT_GENERATEVA_GROSS_ALL') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN DROP FUNCTION CL_A_COLLECT_GENERATEVA_GROSS_ALL END
GO

CREATE function CL_A_COLLECT_GENERATEVA_GROSS_ALL (@P_SDate as smalldatetime, @P_EDate as SmallDateTime, @P_ID as Varchar(255))  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher, Admlink.Type, Admlink.BatchNo, Admlink.Bank, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate,   
Voucher.[Currency],  Voucher.Installment, Voucher.DueDate as DueDate, Voucher.AmountDue-Voucher.Payment_CC-Voucher.Payment_OC as Nominal,  
Voucher.Remarks+Voucher.sInstallment as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch  
from ProAcc,[Profile],Voucher_AmountWPCDue(@P_EDate) Voucher,AdmLink  
where  Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('DI','IC','CF','JP','SO')  
and Admlink.ISType in ('I','L','C')
and round(Voucher.AmountDue - (Voucher.Payment_CC+Voucher.Payment_OC),2)>0 and Voucher.DueDate between @P_SDate and @P_EDate  
and Admlink.Subject='Premium'  
and admlink.Source Like @P_ID+'%'
and Not Exists (Select Top 1 CollectionV.Voucher from CollectionV, CollectionH Where CollectionH.CollNo=CollectionV.COllNo and CollectionH.CollStatus<>'C' and (CollectionH.RefType<>'VIRTUAL' or ((CollectionH.EDate>@P_EDate) or (CollectionH.EDate=@P_EDate and CollectionH.ETime>CONVERT(varchar(5), GETDATE(),108)))) and CollectionV.CollNo<>Voucher.CollNo and CollectionV.Voucher=Voucher.Voucher)   
and Not Exists (Select Top 1 SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=Voucher.Voucher)
)  


GO


insert into PatchVersioning
select '1384 Update Script - Collection for GenerateVA',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1384 Update Script - Collection for GenerateVA'


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