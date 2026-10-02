IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCheckObjectInsured_Upload') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
Drop Procedure QCheckObjectInsured_Upload
end
go
CREATE Procedure QCheckObjectInsured_Upload(@REGID as varchar(10),@FLDID AS varchar(255),@VALUEID AS varchar(255),@PDate AS smalldatetime,@PPDate AS smalldatetime,@REFNO varchar(255),@PExclusiveF as Bit=0, @PTOC as varchar(10)='') 
as 
 
Select [Quotation No], [CI No], [Policy No], Insured, Inception, Expiry, ANO, UniqueRefNoF
FROM 
( 
Select Top 1 
C1.CoverNo as [Quotation No], 
A1.RegNo as [CI No], 
A1.PolicyNo + case when A1.CertificateNo='' then '' else '-' + A1.CertificateNo end as [Policy No], 
C1.Insured, 
A1.SDate as Inception, 
A1.EDate as Expiry, 
A1.ANO, 
TOC.UniqueRefNoF, 
A1.RefNo 
from Cover C1, Acceptance A1, TOC 
Where C1.CNO=A1.CNO and TOC.TOC=A1.TOC and A1.AType not in ('A','C') 
and A1.LANO<>A1.ANO and Not (A1.AType='N' and A1.AStatus='C' and ((C1.CStatus='A' and C1.ASource='MKT') or C1.CStatus='C')) 
and A1.PDate<A1.PPDate 
and ( 
	(A1.pDate<=@PDate and ((A1.PPDate>@PDate) or (A1.PPDate>=@PDate and A1.ExclusiveF=0 and @PExclusiveF=1))) or 
	(@PDate<=A1.PDate and ((@PPDate>A1.PDate) or (@PPDate>=A1.PDate and @PExclusiveF=0 and A1.ExclusiveF=1))) 
	) 
and TOC.UniqueRefNoF=0 and A1.RegID=@REGID and A1.FLDID<>'' and A1.FLDID=@FLDID and A1.ValueID=@VALUEID 

Union All

Select Top 1 
C1.CoverNo as [Quotation No], 
A1.RegNo as [CI No], 
A1.PolicyNo + case when A1.CertificateNo='' then '' else '-' + A1.CertificateNo end as [Policy No], 
C1.Insured, 
A1.SDate as Inception, 
A1.EDate as Expiry, 
A1.ANO, 
TOC.UniqueRefNoF, 
A1.RefNo 
from Cover C1, Acceptance A1, TOC 
Where C1.CNO=A1.CNO and TOC.TOC=A1.TOC and A1.AType not in ('A','C') 
and A1.LANO<>A1.ANO and Not (A1.AType='N' and A1.AStatus='C' and ((C1.CStatus='A' and C1.ASource='MKT') or C1.CStatus='C')) 
and A1.PDate<A1.PPDate 
and ( 
	(A1.pDate<=@PDate and ((A1.PPDate>@PDate) or (A1.PPDate>=@PDate and A1.ExclusiveF=0 and @PExclusiveF=1))) or 
	(@PDate<=A1.PDate and ((@PPDate>A1.PDate) or (@PPDate>=A1.PDate and @PExclusiveF=0 and A1.ExclusiveF=1))) 
	) 
and TOC.UniqueRefNoF=1 and  ((@PTOC<>'' and A1.TOC=@PTOC) or (@PTOC='' and A1.RegID=@RegID)) and A1.RefNo=@RefNo
) R 

go


  insert into PatchVersioning
select '54.20 Update Script - Patch 2019 (26) QCheckObjectInsured_Upload',GETDATE()
go

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='54.19 Update Script - Patch 2019 (25)'
Select @CurrSCript='54.20 Update Script - Patch 2019 (26) QCheckObjectInsured_Upload'


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





