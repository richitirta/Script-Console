DROP Procedure PI07
GO
CREATE Procedure PI07(@P_ANO as integer)  
as  
    
select Claim.CNO, Claim.ClaimNo, Claim.LossDate, Profile.Name, Claim.Description, Claim.CStatus, CCalc.Currency, CCalc.Loss, CCalc.Claim, CCalc.Deductible, CCalc.Cost, CCalc.Salvage, CCalc.Subrogation  
From CLAIM
Left Join Profile on (Profile.ID=Claim.Claimant)
Left Join CCalc on (CCalc.CNO=Claim.CNO),
Cover C, Acceptance A1, Acceptance A2
Where (Claim.Cstatus in ('R','P','T','A') or (Claim.Cstatus='C' and Claim.pCStatus<>''))
and C.CNO=A1.CNO and (A1.ANO=@P_ANO or (C.OpenFlag=0 and A1.LANO=@P_ANO)) and A2.OANO=A1.OANO and A2.ANO=Claim.ANO

Union All

select Claim.CNO, Claim.ClaimNo, Claim.LossDate, Profile.Name, Claim.Description, Claim.CStatus, CCalc.Currency, CCalc.Loss, CCalc.Claim, CCalc.Deductible, CCalc.Cost, CCalc.Salvage, CCalc.Subrogation  
From CLAIM
Left Join Profile on (Profile.ID=Claim.Claimant)
Left Join CCalc on (CCalc.CNO=Claim.CNO),
Cover C, Acceptance A1, Acceptance A2, Acceptance A3 
Where (Claim.Cstatus in ('R','P','T','A') or (Claim.Cstatus='C' and Claim.pCStatus<>''))
and C.CNO=A1.CNO and (A1.ANO=@P_ANO or (C.OpenFlag=0 and A1.LANO=@P_ANO)) and A2.ANO=A1.RANO and A3.OANO=A2.OANO and A3.ANO=Claim.ANO

Union All

select Claim.CNO, Claim.ClaimNo, Claim.LossDate, Profile.Name, Claim.Description, Claim.CStatus, CCalc.Currency, CCalc.Loss, CCalc.Claim, CCalc.Deductible, CCalc.Cost, CCalc.Salvage, CCalc.Subrogation  
From CLAIM
Left Join Profile on (Profile.ID=Claim.Claimant)
Left Join CCalc on (CCalc.CNO=Claim.CNO),
Cover C, Acceptance A1, Acceptance A2, Acceptance A3, Acceptance A4
Where (Claim.Cstatus in ('R','P','T','A') or (Claim.Cstatus='C' and Claim.pCStatus<>''))
and C.CNO=A1.CNO and (A1.ANO=@P_ANO or (C.OpenFlag=0 and A1.LANO=@P_ANO)) and A2.ANO=A1.RANO and A3.ANO=A2.RANO and A4.OANO=A3.OANO and A4.ANO=Claim.ANO

Union All

select Claim.CNO, Claim.ClaimNo, Claim.LossDate, Profile.Name, Claim.Description, Claim.CStatus, CCalc.Currency, CCalc.Loss, CCalc.Claim, CCalc.Deductible, CCalc.Cost, CCalc.Salvage, CCalc.Subrogation  
From CLAIM
Left Join Profile on (Profile.ID=Claim.Claimant)
Left Join CCalc on (CCalc.CNO=Claim.CNO),
Cover C, Acceptance A1, Acceptance A2, Acceptance A3, Acceptance A4, Acceptance A5
Where (Claim.Cstatus in ('R','P','T','A') or (Claim.Cstatus='C' and Claim.pCStatus<>''))
and C.CNO=A1.CNO and (A1.ANO=@P_ANO or (C.OpenFlag=0 and A1.LANO=@P_ANO)) and A2.ANO=A1.RANO and A3.ANO=A2.RANO and A4.ANO=A3.RANO and A5.OANO=A4.OANO and A5.ANO=Claim.ANO

Union All

select Claim.CNO, Claim.ClaimNo, Claim.LossDate, Profile.Name, Claim.Description, Claim.CStatus, CCalc.Currency, CCalc.Loss, CCalc.Claim, CCalc.Deductible, CCalc.Cost, CCalc.Salvage, CCalc.Subrogation  
From CLAIM
Left Join Profile on (Profile.ID=Claim.Claimant)
Left Join CCalc on (CCalc.CNO=Claim.CNO),
Cover C, Acceptance A1, Acceptance A2, Acceptance A3, Acceptance A4, Acceptance A5, Acceptance A6
Where (Claim.Cstatus in ('R','P','T','A') or (Claim.Cstatus='C' and Claim.pCStatus<>''))
and C.CNO=A1.CNO and (A1.ANO=@P_ANO or (C.OpenFlag=0 and A1.LANO=@P_ANO)) and A2.ANO=A1.RANO and A3.ANO=A2.RANO and A4.ANO=A3.RANO and A5.ANO=A4.RANO and A6.OANO=A5.OANO and A6.ANO=Claim.ANO



go



 insert into PatchVersioning	
select '692 Update Script - Patch 2023 (65)',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='692 Update Script - Patch 2023 (65)'


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









