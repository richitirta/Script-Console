if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_GetTotalSumInsuredByProduct') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function fn_GetTotalSumInsuredByProduct
END
GO
CREATE Function fn_GetTotalSumInsuredByProduct(@P_AsAt as smalldatetime,@P_TOPRO as varchar(10),@P_RegID as varchar(10),@P_FLDID as varchar(255),@P_ValueID as varchar(255),@P_OANO as Int)
RETURNS Float AS        
BEGIN      
	Declare @Total as Float
	if @P_FLDID<>'' and @P_ValueID<>''
	Begin
		Select @Total=sum((RArrHeader.TAmount)*Case When coalesce(A.PCTLOSS,100)<>0 Then coalesce(A.PCTLOSS,100) Else 100 End/100*coalesce(P.InstSIPCT,100)/100)
		from
		(
			Select Acceptance.ANO, (Select Top 1 RCover.PCTLOSS from RCover Where RCover.ANO=Acceptance.ANO and RCover.Category='M' and RCover.SDate<=@P_AsAt and ((RCover.EDate=Acceptance.EDate and @P_AsAt<=RCover.EDate) or (@P_AsAt<RCover.EDate))) as PCTLOSS
			from Acceptance, Cover
			Where Cover.CNO=Acceptance.CNO 
			and Acceptance.ADate<=@P_AsAt and Acceptance.PolicyNo<>'' and Acceptance.AType not in ('C','A') and Acceptance.AStatus not in ('W','T') and Cover.CStatus<>'C' and Acceptance.pAStatus<>'W'
			and @P_AsAt between Acceptance.PDate and Acceptance.EDate
			and Acceptance.OANO<>@P_OANO and Acceptance.TOPRO=@P_TOPRO and Acceptance.RegID=@P_RegID and Acceptance.FLDID=@P_FLDID and Acceptance.ValueID=@P_VALUEID 
			and not exists (
				Select A.PANO
				from Acceptance A, Cover C
				Where A.PANO=Acceptance.ANO and C.CNO=A.CNO 
				and A.ADate<=@P_AsAt and A.PolicyNo<>'' and A.AType not in ('A') and A.AStatus not in ('W','T') and C.CStatus<>'C'
				and @P_AsAt between A.PDate and A.EDate
			)
			and not exists (
				Select A.RANO
				from Acceptance A, Cover C
				Where A.RANO=Acceptance.ANO and C.CNO=A.CNO 
				and A.ADate<=@P_AsAt and A.PolicyNo<>'' and A.AType not in ('A') and A.AStatus not in ('W','T') and C.CStatus<>'C'
				and @P_AsAt between A.PDate and A.EDate
			) 
			and not exists (
				Select Claim.ANO
				from Claim, CLLOSS
				WHere Claim.ANO=Acceptance.ANO and CLLOSS.CNO=Claim.CNO and CLLOSS.CTLF=1 
				and Claim.RegDate<=@P_AsAt
				and Claim.CStatus in ('P','T','A','C') and Claim.CType in ('N','E')
				and Not (Claim.CStatus in ('C') and Claim.pCStatus in ('P') and Claim.CSDate<=@P_AsAt)
				and Not Exists (Select pCNO from Claim C Where C.pCNO=Claim.CNO and C.CStatus in ('P','T','A','C') and Claim.RegDate<=@P_AsAt)
			)
		) A
		Inner Join Acceptance A1 on (A1.ANO=A.ANO)
		Left Join Payor_Schedule P on (P.ANO=A1.ANO and P.InstDate<=@P_AsAt and (P.InstLDate>@P_AsAt or (P.InstLDate=@P_AsAt and P.InstLDate=A1.EDate)))
		Inner Join RArrHeader on (RArrHeader.ANO=A1.ANO)

	End

	if @Total is null 
		Select @Total=0

	Return @Total
END     

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_GetTotalSumInsuredByPHolder') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function fn_GetTotalSumInsuredByPHolder
END
GO
CREATE Function fn_GetTotalSumInsuredByPHolder(@P_AsAt as smalldatetime, @P_PHolder as varchar(10),@P_RegID as varchar(10),@P_FLDID as varchar(255),@P_ValueID as varchar(255),@P_OANO as Int)
RETURNS Float AS        
BEGIN      
	Declare @Total as Float
	if @P_FLDID<>'' and @P_ValueID<>''
	Begin
		Select @Total=sum((RArrHeader.TAmount)*Case When coalesce(A.PCTLOSS,100)<>0 Then coalesce(A.PCTLOSS,100) Else 100 End/100*coalesce(P.InstSIPCT,100)/100)
		from
		(
			Select Acceptance.ANO, (Select Top 1 RCover.PCTLOSS from RCover Where RCover.ANO=Acceptance.ANO and RCover.Category='M' and RCover.SDate<=@P_AsAt and ((RCover.EDate=Acceptance.EDate and @P_AsAt<=RCover.EDate) or (@P_AsAt<RCover.EDate))) as PCTLOSS
			from Acceptance, Cover
			Where Cover.CNO=Acceptance.CNO 
			and Acceptance.ADate<=@P_AsAt and Acceptance.PolicyNo<>'' and Acceptance.AType not in ('C','A') and Acceptance.AStatus not in ('W','T') and Cover.CStatus<>'C' and Acceptance.pAStatus<>'W'
			and @P_AsAt between Acceptance.PDate and Acceptance.EDate
			and Acceptance.OANO<>@P_OANO and Cover.PHolder=@P_PHolder and Acceptance.RegID=@P_RegID and Acceptance.FLDID=@P_FLDID and Acceptance.ValueID=@P_VALUEID 
			and not exists (
				Select A.PANO
				from Acceptance A, Cover C
				Where A.PANO=Acceptance.ANO and C.CNO=A.CNO 
				and A.ADate<=@P_AsAt and A.PolicyNo<>'' and A.AType not in ('A') and A.AStatus not in ('W','T') and C.CStatus<>'C'
				and @P_AsAt between A.PDate and A.EDate
			)
			and not exists (
				Select A.RANO
				from Acceptance A, Cover C
				Where A.RANO=Acceptance.ANO and C.CNO=A.CNO 
				and A.ADate<=@P_AsAt and A.PolicyNo<>'' and A.AType not in ('A') and A.AStatus not in ('W','T') and C.CStatus<>'C'
				and @P_AsAt between A.PDate and A.EDate
			) 
			and not exists (
				Select Claim.ANO
				from Claim, CLLOSS
				WHere Claim.ANO=Acceptance.ANO and CLLOSS.CNO=Claim.CNO and CLLOSS.CTLF=1 
				and Claim.RegDate<=@P_AsAt
				and Claim.CStatus in ('P','T','A','C') and Claim.CType in ('N','E')
				and Not (Claim.CStatus in ('C') and Claim.pCStatus in ('P') and Claim.CSDate<=@P_AsAt)
				and Not Exists (Select pCNO from Claim C Where C.pCNO=Claim.CNO and C.CStatus in ('P','T','A','C') and Claim.RegDate<=@P_AsAt)
			)
		) A
		Inner Join Acceptance A1 on (A1.ANO=A.ANO)
		Left Join Payor_Schedule P on (P.ANO=A1.ANO and P.InstDate<=@P_AsAt and (P.InstLDate>@P_AsAt or (P.InstLDate=@P_AsAt and P.InstLDate=A1.EDate)))
		Inner Join RArrHeader on (RArrHeader.ANO=A1.ANO)
	End

	if @Total is null 
		Select @Total=0

	Return @Total

END     

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_GetTotalSumInsured') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function fn_GetTotalSumInsured
END
GO
CREATE Function fn_GetTotalSumInsured(@P_AsAt as smalldatetime,@P_RegID as varchar(10),@P_FLDID as varchar(255),@P_ValueID as varchar(255),@P_OANO as Int)
RETURNS Float AS        
BEGIN      
	Declare @Total as Float
	if @P_FLDID<>'' and @P_ValueID<>''
	Begin
		Select @Total=sum((RArrHeader.TAmount)*Case When coalesce(A.PCTLOSS,100)<>0 Then coalesce(A.PCTLOSS,100) Else 100 End/100*coalesce(P.InstSIPCT,100)/100)
		from
		(
			Select Acceptance.ANO, (Select Top 1 RCover.PCTLOSS from RCover Where RCover.ANO=Acceptance.ANO and RCover.Category='M' and RCover.SDate<=@P_AsAt and ((RCover.EDate=Acceptance.EDate and @P_AsAt<=RCover.EDate) or (@P_AsAt<RCover.EDate))) as PCTLOSS
			from Acceptance, Cover
			Where Cover.CNO=Acceptance.CNO 
			and Acceptance.ADate<=@P_AsAt and Acceptance.PolicyNo<>'' and Acceptance.AType not in ('C','A') and Acceptance.AStatus not in ('W','T') and Cover.CStatus<>'C' and Acceptance.pAStatus<>'W'
			and @P_AsAt between Acceptance.PDate and Acceptance.EDate
			and Acceptance.OANO<>@P_OANO and Acceptance.RegID=@P_RegID and Acceptance.FLDID=@P_FLDID and Acceptance.ValueID=@P_VALUEID 
			and not exists (
				Select A.PANO
				from Acceptance A, Cover C
				Where A.PANO=Acceptance.ANO and C.CNO=A.CNO 
				and A.ADate<=@P_AsAt and A.PolicyNo<>'' and A.AType not in ('A') and A.AStatus not in ('W','T') and C.CStatus<>'C'
				and @P_AsAt between A.PDate and A.EDate
			)
			and not exists (
				Select A.RANO
				from Acceptance A, Cover C
				Where A.RANO=Acceptance.ANO and C.CNO=A.CNO 
				and A.ADate<=@P_AsAt and A.PolicyNo<>'' and A.AType not in ('A') and A.AStatus not in ('W','T') and C.CStatus<>'C'
				and @P_AsAt between A.PDate and A.EDate
			) 
			and not exists (
				Select Claim.ANO
				from Claim, CLLOSS
				WHere Claim.ANO=Acceptance.ANO and CLLOSS.CNO=Claim.CNO and CLLOSS.CTLF=1 
				and Claim.RegDate<=@P_AsAt
				and Claim.CStatus in ('P','T','A','C') and Claim.CType in ('N','E')
				and Not (Claim.CStatus in ('C') and Claim.pCStatus in ('P') and Claim.CSDate<=@P_AsAt)
				and Not Exists (Select pCNO from Claim C Where C.pCNO=Claim.CNO and C.CStatus in ('P','T','A','C') and Claim.RegDate<=@P_AsAt)
			)
		) A
		Inner Join Acceptance A1 on (A1.ANO=A.ANO)
		Left Join Payor_Schedule P on (P.ANO=A1.ANO and P.InstDate<=@P_AsAt and (P.InstLDate>@P_AsAt or (P.InstLDate=@P_AsAt and P.InstLDate=A1.EDate)))
		Inner Join RArrHeader on (RArrHeader.ANO=A1.ANO)
	End

	if @Total is null 
		Select @Total=0

	Return @Total
END     


GO

insert into PatchVersioning
select '55.40 Update Script - Patch 2020 (41)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='55.39 Update Script - Patch 2020 (40)'
Select @CurrSCript='55.40 Update Script - Patch 2020 (41)'


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


