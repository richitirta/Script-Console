if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Get_ClaimSubrogation_Monitoring') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function Get_ClaimSubrogation_Monitoring
END
GO
Create function Get_ClaimSubrogation_Monitoring(@DocStatus as Int)  
RETURNS Table  
AS RETURN  
(  
	Select cast(0 as Bit) as ProcessFlag, C1.CType, C1.CStatus,
	C1.CNO, C1.TOC, TOC.Description as TOC_Desc, C1.ClaimNo, C4.RegDate, C1.ADate, C2.RefDate, C2.RefNo, C2.Remark as Interest, 
	C2.Currency, C2.Estimate, C2.Amount as Indemnity, 
	C2.Payment as PaymentID, 
	PProfile.Name as PaymentName, 
	C5.Amount as SubrogationAmount, C5.ID+'-'+SProfile.Name as SubrogationName,
	C6.Amount as ExpenseAmount, C6.ID+'-'+CProfile.Name as ExpenseName,
	S.Document, C3.Remarks, C3.UserID, C3.Date, C3.Time, C3.Last_Opr, C3.Last_Update, C3.Last_Time, C3.Actionby, C3.Actiondate, C3.ActionTime, C3.AcceptedBy, C3.AcceptedDate, C3.AcceptedTime, C3.ImageID
	From Claim C1
	Inner Join CLLOSS C2 on (C2.CNO=C1.CNO)
	Inner Join Profile PProfile on (PProfile.ID=C2.Payment)
	Inner Join (
		Select S.Description as Document, S.ClaimCType, S.ClaimCStatus 
		from Docstat D, SysClass S 
		Where D.Purpose='SUBRO' and D.AllowedF=1 and S.CATEGORY='Claim' and S.Class=D.Class
		) S on (
			exists (Select Top 1 Document from CLNotify C3 Where C3.CNO=C1.CNO and C3.Type='OP' and C3.ID=C2.Payment and S.Document=C3.Document)
			or
			(charindex(C1.CType, S.ClaimCType)>0 and charindex(C1.CStatus, S.ClaimCStatus)>0)
		)
	Left Join CLNotify C3 on (C3.CNO=C1.CNO and C3.Type='OP' and C3.ID=C1.Payment and S.Document=C3.Document)
	Inner Join Claim C4 on (C4.CNO=C1.OCNO)
	Inner join TOC on (TOC.TOC=C1.TOC)
	Left Join CLSUB C5 on (C5.CNO=C2.CNO and C5.RefNo=C2.RefNo and C5.Currency=C2.Currency)
	Left Join Profile SProfile on (SProfile.ID=C5.ID)
	Left Join CLCOST C6 on (C6.CNO=C2.CNO and C6.RefNo=C2.RefNo and C6.Currency=C2.Currency)
	Left Join Profile CProfile on (CProfile.ID=C6.ID)
	Where C1.RecoverableF=1
	--and C1.CType<>'C' and (C1.CStatus in ('P','T','A') or C1.pCStatus in ('A')) 
	and not exists (Select pCNO from Claim Where Claim.pCNO=C1.CNO and Claim.CStatus<>'R')
	and (@DocStatus=0 or (@DocStatus=1 and coalesce(C3.ImageID,0)=0) or (@DocStatus=2 and coalesce(C3.ImageID,0)<>0))
)  

GO





 insert into PatchVersioning
select '329 Update Script - 30 September 2022 (1)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='329 Update Script - 30 September 2022 (1)'


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


