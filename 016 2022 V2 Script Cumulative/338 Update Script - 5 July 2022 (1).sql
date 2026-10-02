DROP Function get_ClaimObjectInfo
GO
CREATE Function get_ClaimObjectInfo(@P_CNO int)          
RETURNS varchar(2048) as
  
BEGIN       
Declare @ObjInfo varchar(2048)

Select
@ObjInfo=
cast(
'('
	+Case When C2.FLDID1<>'' Then COB.FLDTAG1+' : '+Case When C2.VALUEID1<>'' Then C2.VALUEID1+'-'+cast(C2.VALUEDESC1 as varchar(100)) ELSE cast(C2.VALUEDESC1 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
	+Case When C2.FLDID2<>'' Then COB.FLDTAG2+' : '+Case When C2.VALUEID2<>'' Then C2.VALUEID2+'-'+cast(C2.VALUEDESC2 as varchar(100)) ELSE cast(C2.VALUEDESC2 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
	+Case When C2.FLDID3<>'' Then COB.FLDTAG3+' : '+Case When C2.VALUEID3<>'' Then C2.VALUEID3+'-'+cast(C2.VALUEDESC3 as varchar(100)) ELSE cast(C2.VALUEDESC3 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
	+Case When C2.FLDID4<>'' Then COB.FLDTAG4+' : '+Case When C2.VALUEID4<>'' Then C2.VALUEID4+'-'+cast(C2.VALUEDESC4 as varchar(100)) ELSE cast(C2.VALUEDESC4 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
	+Case When C2.FLDID5<>'' Then COB.FLDTAG5+' : '+Case When C2.VALUEID5<>'' Then C2.VALUEID5+'-'+cast(C2.VALUEDESC5 as varchar(100)) ELSE cast(C2.VALUEDESC5 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
	+Case When C2.FLDID6<>'' Then COB.FLDTAG6+' : '+Case When C2.VALUEID6<>'' Then C2.VALUEID6+'-'+cast(C2.VALUEDESC6 as varchar(100)) ELSE cast(C2.VALUEDESC6 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
	+Case When C2.FLDID7<>'' Then COB.FLDTAG7+' : '+Case When C2.VALUEID7<>'' Then C2.VALUEID7+'-'+cast(C2.VALUEDESC7 as varchar(100)) ELSE cast(C2.VALUEDESC7 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
	+Case When C2.FLDID8<>'' Then COB.FLDTAG8+' : '+Case When C2.VALUEID8<>'' Then C2.VALUEID8+'-'+cast(C2.VALUEDESC8 as varchar(100)) ELSE cast(C2.VALUEDESC8 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
	+Case When C2.FLDID9<>'' Then COB.FLDTAG9+' : '+Case When C2.VALUEID9<>'' Then C2.VALUEID9+'-'+cast(C2.VALUEDESC9 as varchar(100)) ELSE cast(C2.VALUEDESC9 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
	+Case When C2.FLDID10<>'' Then COB.FLDTAG10+' : '+Case When C2.VALUEID10<>'' Then C2.VALUEID10+'-'+cast(C2.VALUEDESC10 as varchar(100)) ELSE cast(C2.VALUEDESC10 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
	+Case When C2.FLDID11<>'' Then COB.FLDTAG11+' : '+Case When C2.VALUEID11<>'' Then C2.VALUEID11+'-'+cast(C2.VALUEDESC11 as varchar(100)) ELSE cast(C2.VALUEDESC11 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
	+Case When C2.FLDID12<>'' Then COB.FLDTAG12+' : '+Case When C2.VALUEID12<>'' Then C2.VALUEID12+'-'+cast(C2.VALUEDESC12 as varchar(100)) ELSE cast(C2.VALUEDESC12 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
	+Case When C2.FLDID13<>'' Then COB.FLDTAG13+' : '+Case When C2.VALUEID13<>'' Then C2.VALUEID13+'-'+cast(C2.VALUEDESC13 as varchar(100)) ELSE cast(C2.VALUEDESC13 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
	+Case When C2.FLDID14<>'' Then COB.FLDTAG14+' : '+Case When C2.VALUEID14<>'' Then C2.VALUEID14+'-'+cast(C2.VALUEDESC14 as varchar(100)) ELSE cast(C2.VALUEDESC14 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
	+Case When C2.FLDID15<>'' Then COB.FLDTAG15+' : '+Case When C2.VALUEID15<>'' Then C2.VALUEID15+'-'+cast(C2.VALUEDESC15 as varchar(100)) ELSE cast(C2.VALUEDESC15 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
+')'
as varchar(2048))
from CLAIM C1
Inner Join CINFO C2 on (C2.CNO=C1.CNO)
Inner Join TOC T on (T.TOC=C1.TOC)
Inner Join COBEXT COB on (COB.COB=COB.COB and COB.Category='')
Where C1.CNO=@P_CNO

return @ObjInfo
  
END    


GO

DROP function Get_ClaimSubrogation_Monitoring
GO
Create function Get_ClaimSubrogation_Monitoring(@ClaimNo as varchar(20), @Currency as varchar(10), @DocStatus as Int)  
RETURNS Table  
AS RETURN  
(  
	Select cast(0 as Bit) as ProcessFlag, C1.CType, C1.CStatus,
	C1.CNO, C1.TOC, TOC.Description as TOC_Desc, C1.ClaimNo, 
	C1.PolicyNo+Case when C1.CertificateNo<>'' Then '-'+C1.CertificateNo else '' end as PolicyNo, 
	C4.RegDate, C1.ADate, C1.RefNo, 
	dbo.get_ClaimObjectInfo(C1.CNO) as CInfo,
	C2.Currency, C2.Declared, C2.Estimate, C2.Indemnity,
	C2.Payment as PaymentID, 
	C2.Name as PaymentName, 
	C5.Amount as SubrogationAmount, C5.Name as SubrogationName,
	C6.Amount as ExpenseAmount, C6.Name as ExpenseName,
	S.Document, C3.Remarks, C3.UserID, C3.Date, C3.Time, C3.Last_Opr, C3.Last_Update, C3.Last_Time, C3.Actionby, C3.Actiondate, C3.ActionTime, C3.AcceptedBy, C3.AcceptedDate, C3.AcceptedTime, C3.ImageID
	From Claim C1
	Cross apply (
		Select CLLOSS.CNO, CLLOSS.Currency, CLLOSS.Payment, Max(Profile.Name) as Name, sum(CLLOSS.Declared*CLLOSS.Rate) as Declared, sum(CLLOSS.Estimate) as Estimate, sum(CLLOSS.Amount) as Indemnity
		from CLLOSS, Profile
		Where CLLOSS.CNO=C1.CNO and Profile.ID=CLLOSS.Payment
		Group By CLLOSS.CNO, CLLOSS.Currency, CLLOSS.Payment
	) C2
	Inner Join (
		Select S.Description as Document, S.ClaimCType, S.ClaimCStatus 
		from Docstat D, SysClass S 
		Where D.Purpose='SUBRO' and D.AllowedF=1 and S.CATEGORY='Claim' and S.Class=D.Class
		) S on (
			exists (Select Top 1 Document from CLNotify C3 Where C3.CNO=C1.CNO and C3.Type='OP' and C3.ID=C2.Payment and S.Document=C3.Document)
			or
			(charindex(C1.CType, S.ClaimCType)>0 and charindex(C1.CStatus, S.ClaimCStatus)>0)
		)
	Left Join CLNotify C3 on (C3.CNO=C1.CNO and C3.Type='OP' and C3.ID=C2.Payment and S.Document=C3.Document)
	Inner Join Claim C4 on (C4.CNO=C1.OCNO)
	Inner join TOC on (TOC.TOC=C1.TOC)
	Outer Apply (
		Select CLSUB.CNO, CLSUB.Currency, Max(Profile.ID+'-'+Profile.Name) as Name, sum(CLSUB.Amount) as Amount
		from CLSUB, Profile
		Where CLSUB.CNO=C2.CNO and CLSUB.Currency=C2.Currency and Profile.ID=CLSUB.ID
		Group By CLSUB.CNO, CLSUB.Currency
	) C5
	Outer Apply (
		Select CLCOST.CNO, CLCOST.Currency, Max(Profile.ID+'-'+Profile.Name) as Name, sum(CLCOST.Amount) as Amount
		from CLCOST, Profile
		Where CLCOST.CNO=C2.CNO and CLCOST.Currency=C2.Currency and Profile.ID=CLCOST.ID
		Group By CLCOST.CNO, CLCOST.Currency
	) C6
	Where C1.RecoverableF=1
	and (C1.CStatus='A' or C1.pCStatus='A'or C1.CSeqNo>0)
	and C1.ClaimNo Like @ClaimNo+'%'
	and C2.Currency like @Currency+'%'
	and not exists (Select pCNO from Claim Where Claim.pCNO=C1.CNO)
	and (@DocStatus=0 or (@DocStatus=1 and coalesce(C3.ImageID,0)=0) or (@DocStatus=2 and coalesce(C3.ImageID,0)<>0))
)  


go


 insert into PatchVersioning
select '338 Update Script - 5 July 2022 (1)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='338 Update Script - 5 July 2022 (1)'


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

