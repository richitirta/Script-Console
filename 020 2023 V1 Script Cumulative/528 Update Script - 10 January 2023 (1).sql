IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QGetClaimSubrogationByAccumulationRegister') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QGetClaimSubrogationByAccumulationRegister
end
GO
CREATE PROCEDURE QGetClaimSubrogationByAccumulationRegister (@P_AsAt as smalldatetime, @P_TOC as varchar(10), @P_FLDID as varchar(255), @P_ValueID as varchar(255))   
AS

Declare @Claim as table(ClaimNo varchar(20), OCNO Int, CNO Int, ANO int)

insert into @Claim
Select C1.ClaimNo, C1.OCNO, C1.CNO, C1.ANO
From Claim C1
Inner Join Acceptance A on (A.ANO=C1.ANO)
Where A.TOC=@P_TOC and A.FLDID=@P_FLDID and A.VALUEID=@P_VALUEID and C1.RecoverableF=1 
AND C1.CType<>'C' and C1.AUserID<>'' and C1.ADate<=@P_AsAt
and not exists (Select pCNO from Claim Where Claim.pCNO=C1.CNO and Claim.AUserID<>'' and Claim.ADate<=@P_AsAt)


Select C.*, datediff(day,C.First_Approval_Date,@P_AsAt) as Lapse
from
(
	Select C.ClaimNo, C.OCNO, C.CNO, (Select Top 1 ADate from Claim Where AUserID<>'' and ADate<=@P_AsAt and Claim.OCNO=C.OCNO order by ADate) as First_Approval_Date, sum(Claim) as Claim, sum(Subrogation) as Subrogation
	from
	(

		Select C1.ClaimNo, C1.OCNO, C1.CNO, cast(0 as Float) as Claim, SUM(C3.AMOUNT*CCALC.RATE) as SUBROGATION
		from @Claim C1, CLSUB C2, CLSUBDET C3, ACCEPTANCE A1, ACCCOLLATERAL A2, CCALC
		Where C1.CNO=C2.CNO and C2.CNO=C3.CNO and C2.ID=C3.ID and C2.CURRENCY=C3.CURRENCY and C2.REFNO=C3.REFNO AND C2.STATUS='P'
		AND A1.ANO=C1.ANO AND A2.ANO=A1.OANO AND A2.COLLATERALNO=C3.ITEM AND A2.CURRENCY=C2.CURRENCY
		AND CCALC.CNO=C2.CNO AND CCALC.CURRENCY=C2.CURRENCY
		GROUP BY C1.ClaimNo, C1.OCNO, C1.CNO

		union all

		Select C1.ClaimNo, C1.OCNO, C1.CNO, SUM(C2.AMOUNT*CCALC.RATE) AS CLAIM, cast(0 as FLoat) as Subrogation
		from @Claim C1, CLLOSS C2, ACCEPTANCE A1, CCALC
		WHERE C1.CNO=C2.CNO AND C2.STATUS='P'
		AND A1.ANO=C1.ANO 
		AND CCALC.CNO=C2.CNO AND CCALC.CURRENCY=C2.CURRENCY
		GROUP BY C1.ClaimNo, C1.OCNO, C1.CNO
	) C
	Group by C.ClaimNo, C.OCNO, C.CNO
) C
go




 insert into PatchVersioning	
select '528 Update Script - 10 January 2023 (1)',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='528 Update Script - 10 January 2023 (1)'


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

