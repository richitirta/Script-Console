DROP Procedure QCheckObjectInsured_Upload
GO
CREATE Procedure QCheckObjectInsured_Upload(@REGID as varchar(10),@FLDID AS varchar(255),@VALUEID AS varchar(255),@PDate AS smalldatetime,@PPDate AS smalldatetime,@REFNO varchar(255),@PExclusiveF as Bit=0, @PTOC as varchar(10)='', @M_RegNo as varchar(50)='', @PolicyNo as varchar(50)='', @CertificateNo as varchar(20)='') 
as 

Declare @UniqueRefNoF as Bit
Declare @MaxNumDuplReg as int
Declare @EachAccRegF as bit
Declare @M_OANO as Int

Select @UniqueRefNoF=UniqueRefNoF, @MaxNumDuplReg=MaxNumDuplReg, @EachAccRegF=EachAccRegF from TOC Where TOC.TOC=@PTOC

if @M_RegNo<>''
	Select Top 1 @M_OANO=OANO from Acceptance mA Where mA.ANO=mA.LANO and @M_RegNo<>'' and mA.RegNo=@M_RegNo
Else
	Select @M_OANO=Null

if @M_OANO is null
	Select @M_OANO=-1

if @UniqueRefNoF=0
	if @EachAccRegF=0 
		Select 
		C1.CoverNo as [Quotation No], 
		A1.RegNo as [CI No], 
		A1.PolicyNo + case when A1.CertificateNo='' then '' else '-' + A1.CertificateNo end as [Policy No], 
		C1.Insured, 
		A1.SDate as Inception, 
		A1.EDate as Expiry, 
		A1.ANO, 
		A1.RefNo, 
		@UniqueRefNoF as UniqueRefNoF
		from
		(
			Select min(A1.ANO) as ANO
			from Acceptance A1
			Left Join Acceptance mA1 on (mA1.ANO=mA1.LANO and mA1.ANO=A1.LANO)
			Inner Join Cover C1 on (C1.CNO=A1.CNO)
			Where A1.RegID=@REGID and A1.FLDID<>'' and A1.FLDID=@FLDID and A1.ValueID=@VALUEID and (@M_OANO=-1 or mA1.OANO=@M_OANO)
			and A1.AType not in ('A','C') 
			and A1.LANO<>A1.ANO and Not (A1.AType='N' and A1.AStatus='C' and ((C1.CStatus='A' and C1.ASource='MKT') or C1.CStatus='C')) 
			and A1.PDate<A1.PPDate 
			and ( 
				(A1.pDate<=@PDate and ((A1.PPDate>@PDate) or (A1.PPDate>=@PDate and A1.ExclusiveF=0 and @PExclusiveF=1))) or 
				(@PDate<=A1.PDate and ((@PPDate>A1.PDate) or (@PPDate>=A1.PDate and @PExclusiveF=0 and A1.ExclusiveF=1))) 
				) 
			having count(A1.ANO)>=@MaxNumDuplReg+1
		) A
		Inner Join Acceptance A1 on (A1.ANO=A.ANO)
		Inner Join Cover C1 on (C1.CNO=A1.CNO)
		Where (A1.PolicyNo<>@PolicyNo or A1.CERTIFICATENO<>@CERTIFICATENO)
	else
		Select 
		C1.CoverNo as [Quotation No], 
		A1.RegNo as [CI No], 
		A1.PolicyNo + case when A1.CertificateNo='' then '' else '-' + A1.CertificateNo end as [Policy No], 
		C1.Insured, 
		A1.SDate as Inception, 
		A1.EDate as Expiry, 
		A1.ANO, 
		A1.RefNo, 
		@UniqueRefNoF as UniqueRefNoF
		from
		(
			Select min(A1.ANO) as ANO
			from Acceptance A1
			Left Join Acceptance mA1 on (mA1.ANO=mA1.LANO and mA1.ANO=A1.LANO)
			Inner Join Cover C1 on (C1.CNO=A1.CNO)
			Where A1.RegID=@REGID and A1.FLDID<>'' and charindex(@FLDID,A1.FLDID)<>0 and charindex(@ValueID,A1.ValueID)<>0 and (@M_OANO=-1 or mA1.OANO=@M_OANO)
			and A1.AType not in ('A','C') 
			and A1.LANO<>A1.ANO and Not (A1.AType='N' and A1.AStatus='C' and ((C1.CStatus='A' and C1.ASource='MKT') or C1.CStatus='C')) 
			and A1.PDate<A1.PPDate 
			and ( 
				(A1.pDate<=@PDate and ((A1.PPDate>@PDate) or (A1.PPDate>=@PDate and A1.ExclusiveF=0 and @PExclusiveF=1))) or 
				(@PDate<=A1.PDate and ((@PPDate>A1.PDate) or (@PPDate>=A1.PDate and @PExclusiveF=0 and A1.ExclusiveF=1))) 
				) 
			having count(A1.ANO)>=@MaxNumDuplReg+1
		) A
		Inner Join Acceptance A1 on (A1.ANO=A.ANO)
		Inner Join Cover C1 on (C1.CNO=A1.CNO)
		Where (A1.PolicyNo<>@PolicyNo or A1.CERTIFICATENO<>@CERTIFICATENO)
else
	Select 
	C1.CoverNo as [Quotation No], 
	A1.RegNo as [CI No], 
	A1.PolicyNo + case when A1.CertificateNo='' then '' else '-' + A1.CertificateNo end as [Policy No], 
	C1.Insured, 
	A1.SDate as Inception, 
	A1.EDate as Expiry, 
	A1.ANO, 
	A1.RefNo,
	@UniqueRefNoF as UniqueRefNoF 
	from
	(
		Select min(A1.ANO) as ANO
		from Acceptance A1
		Left Join Acceptance mA1 on (mA1.ANO=mA1.LANO and mA1.ANO=A1.LANO)
		Inner Join Cover C1 on (C1.CNO=A1.CNO)
		Where A1.TOC=@PTOC and A1.RefNo=@RefNo and (@M_OANO=-1 or mA1.OANO=@M_OANO)
		and A1.AType not in ('A','C') 
		and A1.LANO<>A1.ANO and Not (A1.AType='N' and A1.AStatus='C' and ((C1.CStatus='A' and C1.ASource='MKT') or C1.CStatus='C')) 
		and A1.PDate<A1.PPDate 
		and ( 
			(A1.pDate<=@PDate and ((A1.PPDate>@PDate) or (A1.PPDate>=@PDate and A1.ExclusiveF=0 and @PExclusiveF=1))) or 
			(@PDate<=A1.PDate and ((@PPDate>A1.PDate) or (@PPDate>=A1.PDate and @PExclusiveF=0 and A1.ExclusiveF=1))) 
			) 
		having count(A1.ANO)>=@MaxNumDuplReg+1
	) A
	Inner Join Acceptance A1 on (A1.ANO=A.ANO)
	Inner Join Cover C1 on (C1.CNO=A1.CNO)
	Where (A1.PolicyNo<>@PolicyNo or A1.CERTIFICATENO<>@CERTIFICATENO)
	
GO



 insert into PatchVersioning
select '898 Update Script - Patch 2023 (131)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='898 Update Script - Patch 2023 (131)'


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


