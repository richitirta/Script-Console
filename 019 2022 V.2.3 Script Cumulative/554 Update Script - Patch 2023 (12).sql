DROP Procedure QGet_NumberOfEventClaimApproved
GO
Create Procedure QGet_NumberOfEventClaimApproved(@OCNO as Int, @RType as varchar(10), @RID as varchar(20))
AS
Select sum(NEventNo) as NEventNo, sum(Amount) as Amount, sum(LimitPCT) as LimitPCT
from
(
	Select count(Distinct Claim.EventNo) as NEventNo, 
	sum(Case
		When @RType='X1' Then CArrHeader.XL1Amount
		When @RType='X2' Then CArrHeader.XL2Amount
		When @RType='X3' Then CArrHeader.XL3Amount
		When @RType='X4' Then CArrHeader.XL4Amount
		When @RType='X5' Then CArrHeader.XL5Amount
		When @RType='X6' Then CArrHeader.XL6Amount
		When @RType='X7' Then CArrHeader.XL7Amount
		end
		) as Amount,
	sum(Case
		When @RType='X1' Then CArrHeader.XL1Amount
		When @RType='X2' Then CArrHeader.XL2Amount
		When @RType='X3' Then CArrHeader.XL3Amount
		When @RType='X4' Then CArrHeader.XL4Amount
		When @RType='X5' Then CArrHeader.XL5Amount
		When @RType='X6' Then CArrHeader.XL6Amount
		When @RType='X7' Then CArrHeader.XL7Amount
		end /
		(Case When Event.Category='E' and ReClass.ELIMIT<>0 Then ReClass.ELIMIT Else (Case WHEN ReClass.Limit=0 THEN Reinsurance.Limit Else ReClass.Limit end) End)
		*Case When coalesce(R1.CRate,coalesce(R1.Rate,0))=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else dbo.get_Exchange(Acceptance.SDate, Reinsurance.Currency) End) else coalesce(R1.CRate,coalesce(R1.Rate,1))*coalesce(R2.CRate,coalesce(R2.Rate,1)) End		
		*100
		) as LimitPCT
	from Claim
	Inner Join Acceptance on (Acceptance.ANO=Claim.ANO)
	Inner Join Systab on (1=1)
	Inner Join Event On (Event.EventNo=Claim.EventNo)          
	Inner Join CArrHeader on (CArrHeader.CNO=Claim.CNO and CArrHeader.Status='A')
	Inner Join Reinsurance on (Reinsurance.RID=@RID)
	Left Join ReRate R1 on (R1.TOC=Acceptance.TOC and R1.RYear=Reinsurance.RYEAR and R1.Currency=Reinsurance.Currency)
	Left Join ReRate R2 on (R2.TOC=R1.TOC and R2.RYear=R1.RYear and R2.Currency=R1.CCYTo and R1.Currency<>R1.CCYTO)
	Inner Join ReClass on (
		ReClass.RNO=Reinsurance.RNO 
		and 
		ReClass.TOC=
		(		
			Select Top 1 R.TOC
			from ReClass R
			Where R.RNO=Reinsurance.RNO 
			and 
			exists (
				Select Distinct C1.TOC 
				from Claim C1
				Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
				Where C1.EventNo=Event.EventNo and C2.Status='A' and C1.TOC=R.TOC
				and 
				Case 
				When @RType='X1' Then CArrHeader.XL1ID
				When @RType='X2' Then CArrHeader.XL2ID
				When @RType='X3' Then CArrHeader.XL3ID
				When @RType='X4' Then CArrHeader.XL4ID
				When @RType='X5' Then CArrHeader.XL5ID
				When @RType='X6' Then CArrHeader.XL6ID
				When @RType='X7' Then CArrHeader.XL6ID
				End=@RID
			)
			Order by Case When Event.Category='E' and R.ELIMIT<>0 Then R.ELIMIT Else (Case WHEN R.Limit=0 THEN Reinsurance.Limit Else R.Limit end) End
		)
	)
	Where Claim.EventNo>0 and Claim.OCNO<=@OCNO
	and 
	Case 
	When @RType='X1' Then CArrHeader.XL1ID
	When @RType='X2' Then CArrHeader.XL2ID
	When @RType='X3' Then CArrHeader.XL3ID
	When @RType='X4' Then CArrHeader.XL4ID
	When @RType='X5' Then CArrHeader.XL5ID
	When @RType='X6' Then CArrHeader.XL6ID
	When @RType='X7' Then CArrHeader.XL6ID
	End=@RID

	Union All

	Select 0 as NEventNo, 
	sum(Case
		When @RType='X1' Then CArrHeader.XL1Amount
		When @RType='X2' Then CArrHeader.XL2Amount
		When @RType='X3' Then CArrHeader.XL3Amount
		When @RType='X4' Then CArrHeader.XL4Amount
		When @RType='X5' Then CArrHeader.XL5Amount
		When @RType='X6' Then CArrHeader.XL6Amount
		When @RType='X7' Then CArrHeader.XL7Amount
		end
		) as Amount,
	sum(Case
		When @RType='X1' Then CArrHeader.XL1Amount
		When @RType='X2' Then CArrHeader.XL2Amount
		When @RType='X3' Then CArrHeader.XL3Amount
		When @RType='X4' Then CArrHeader.XL4Amount
		When @RType='X5' Then CArrHeader.XL5Amount
		When @RType='X6' Then CArrHeader.XL6Amount
		When @RType='X7' Then CArrHeader.XL7Amount
		end
		/
		(Case WHEN ReClass.Limit=0 THEN Reinsurance.Limit Else ReClass.Limit end)
		*Case When coalesce(R1.CRate,coalesce(R1.Rate,0))=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else dbo.get_Exchange(Acceptance.SDate, Reinsurance.Currency) End) else coalesce(R1.CRate,coalesce(R1.Rate,1))*coalesce(R2.CRate,coalesce(R2.Rate,1)) End		
		*100
		) as LimitPCT
	from Claim
	Inner Join Acceptance on (Acceptance.ANO=Claim.ANO)
	Inner Join Systab on (1=1)
	Inner Join CArrHeader on (CArrHeader.CNO=Claim.CNO and CArrHeader.Status='A')
	Inner Join Reinsurance on (Reinsurance.RID=@RID)
	Inner Join ReClass on (ReClass.RNO=Reinsurance.RNO and ReClass.TOC=Claim.TOC)
	Left Join ReRate R1 on (R1.TOC=Acceptance.TOC and R1.RYear=Reinsurance.RYEAR and R1.Currency=Reinsurance.Currency)
	Left Join ReRate R2 on (R2.TOC=R1.TOC and R2.RYear=R1.RYear and R2.Currency=R1.CCYTo and R1.Currency<>R1.CCYTO)
	Where Claim.EventNo<=0 and Claim.OCNO<=@OCNO
	and 
	Case 
	When @RType='X1' Then CArrHeader.XL1ID
	When @RType='X2' Then CArrHeader.XL2ID
	When @RType='X3' Then CArrHeader.XL3ID
	When @RType='X4' Then CArrHeader.XL4ID
	When @RType='X5' Then CArrHeader.XL5ID
	When @RType='X6' Then CArrHeader.XL6ID
	When @RType='X7' Then CArrHeader.XL6ID
	End=@RID
) C

go


 insert into PatchVersioning	
select '554 Update Script - Patch 2023 (12)',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='554 Update Script - Patch 2023 (12)'


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






