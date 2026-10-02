

Update I1
Set Init_Claim_NPR=
Case 
When BEL_Claim_Expected_1 <>0 then BEL_Claim_NPR_Expected_1/BEL_Claim_Expected_1*100
When BEL_Claim_Expected_2 <>0 then BEL_Claim_NPR_Expected_2/BEL_Claim_Expected_2*100
When BEL_Claim_Expected_3 <>0 then BEL_Claim_NPR_Expected_3/BEL_Claim_Expected_3*100
When BEL_Claim_Expected_4 <>0 then BEL_Claim_NPR_Expected_4/BEL_Claim_Expected_4*100
When BEL_Claim_Expected_5 <>0 then BEL_Claim_NPR_Expected_5/BEL_Claim_Expected_5*100
When BEL_Claim_Expected_6 <>0 then BEL_Claim_NPR_Expected_6/BEL_Claim_Expected_6*100
When BEL_Claim_Expected_7 <>0 then BEL_Claim_NPR_Expected_7/BEL_Claim_Expected_7*100
When BEL_Claim_Expected_8 <>0 then BEL_Claim_NPR_Expected_8/BEL_Claim_Expected_8*100
When BEL_Claim_Expected_9 <>0 then BEL_Claim_NPR_Expected_9/BEL_Claim_Expected_9*100
When BEL_Claim_Expected_10 <>0 then BEL_Claim_NPR_Expected_10/BEL_Claim_Expected_10*100
When BEL_Claim_Expected_11 <>0 then BEL_Claim_NPR_Expected_11/BEL_Claim_Expected_11*100
When BEL_Claim_Expected_12 <>0 then BEL_Claim_NPR_Expected_12/BEL_Claim_Expected_12*100
When BEL_Claim_Expected_13 <>0 then BEL_Claim_NPR_Expected_13/BEL_Claim_Expected_13*100
When BEL_Claim_Expected_14 <>0 then BEL_Claim_NPR_Expected_14/BEL_Claim_Expected_14*100
When BEL_Claim_Expected_15 <>0 then BEL_Claim_NPR_Expected_15/BEL_Claim_Expected_15*100
When BEL_Claim_Expected_16 <>0 then BEL_Claim_NPR_Expected_16/BEL_Claim_Expected_16*100
When BEL_Claim_Expected_17 <>0 then BEL_Claim_NPR_Expected_17/BEL_Claim_Expected_17*100
When BEL_Claim_Expected_18 <>0 then BEL_Claim_NPR_Expected_18/BEL_Claim_Expected_18*100
When BEL_Claim_Expected_19 <>0 then BEL_Claim_NPR_Expected_19/BEL_Claim_Expected_19*100
When BEL_Claim_Expected_20 <>0 then BEL_Claim_NPR_Expected_20/BEL_Claim_Expected_20*100
When BEL_Claim_Expected_21 <>0 then BEL_Claim_NPR_Expected_21/BEL_Claim_Expected_21*100
When BEL_Claim_Expected_22 <>0 then BEL_Claim_NPR_Expected_22/BEL_Claim_Expected_22*100
When BEL_Claim_Expected_23 <>0 then BEL_Claim_NPR_Expected_23/BEL_Claim_Expected_23*100
When BEL_Claim_Expected_24 <>0 then BEL_Claim_NPR_Expected_24/BEL_Claim_Expected_24*100
When BEL_Claim_Expected_25 <>0 then BEL_Claim_NPR_Expected_25/BEL_Claim_Expected_25*100
When BEL_Claim_Expected_26 <>0 then BEL_Claim_NPR_Expected_26/BEL_Claim_Expected_26*100
When BEL_Claim_Expected_27 <>0 then BEL_Claim_NPR_Expected_27/BEL_Claim_Expected_27*100
When BEL_Claim_Expected_28 <>0 then BEL_Claim_NPR_Expected_28/BEL_Claim_Expected_28*100
When BEL_Claim_Expected_29 <>0 then BEL_Claim_NPR_Expected_29/BEL_Claim_Expected_29*100
When BEL_Claim_Expected_30 <>0 then BEL_Claim_NPR_Expected_30/BEL_Claim_Expected_30*100
Else 0
End
from ifrs_initial I1, IFRS_Initial_Detail_BEL I2
Where I2.DataID=I1.DataID and I2.GroupType='R'
GO

Update I1 set Init_Claim_NPR=I2.Init_Claim_NPR
from IFRS_Calculation I1, Ifrs_Initial I2
Where I1.GroupID=I2.GroupID
GO

insert into PatchVersioning
select '1373.1 Update Script - Inisialisasi IFRS Patch #54',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1373.1 Update Script - Inisialisasi IFRS Patch #54'


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
