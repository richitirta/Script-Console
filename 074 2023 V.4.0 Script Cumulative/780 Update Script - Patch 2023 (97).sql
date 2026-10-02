DROP Procedure QCheckObjectClaimed
GO
CREATE Procedure QCheckObjectClaimed(@P_ClaimNo varchar(20), @P_PolicyNo varchar(50), @P_CertificateNo varchar(20),@P_LossDate smalldatetime='01/01/2007', @P_COL varchar(10)='', @P_Location varchar(10)='', @P_RefNo varchar(20)='')   
as   
select C.ClaimNo, C.LossDate,  C.PolicyNo+case When C.CertificateNo='' then '' else '-'+C.CertificateNo end as PolicyNo, C.CStatus, C.CNO, C.ANO, P1.Name as Claimant, c2.DESCRIPTION as 'COL', L.location   
FROM   
(   
 select C1.ClaimNo, C1.LossDate, C1.COL, C1.Location, C1.PolicyNo, C1.CertificateNo, C1.CStatus, C1.CNO, C1.ANO, C1.Claimant 
 from Claim C1 
 LEFT JOIN CLLOSS C2 on (C2.CNO=C1.CNO) 
 LEFT JOIN TOC on (TOC.TOC=C1.TOC)
 LEFT JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=c1.ANO)
 LEFT JOIN RCOVER ON (RCOVER.ANO=ACCEPTANCE.ANO)
 LEFT JOIN ICALC ON (ICALC.ANO=RCOVER.ANO AND ICALC.CODE=RCOVER.CODE AND ICALC.SDATE=RCOVER.SDATE AND ICALC.INO=C2.INO)
 LEFT JOIN COL ON (COL.COL=C1.COL AND COL.TOR=ICALC.TOR)
 LEFT JOIN COL CCOL ON (CCOL.COL=@P_COL AND CCOL.TOR=COL.TOR)
 LEFT JOIN CLAIM nC1 on (nC1.pCNO=C1.CNO and nC1.CStatus<>'R')
 Where C1.ClaimNo<>@P_ClaimNo and C1.ClaimNo<>@P_RefNO and C1.RefNo<>@P_RefNo and C1.PolicyNo=@P_PolicyNo and C1.CertificateNo=@P_CertificateNo 
 and C1.LossDate between dateadd(day,-TOC.CDDAYS,@P_LossDate) and dateadd(day,TOC.CDDAYS,@P_LossDate)   
 and C1.CType<>'C' and (C1.CSTATUS IN ('P','T','A') OR C1.PCSTATUS IN ('A')) 
 and coalesce(nC1.CNO,0)=0
 and (RCover.RetroActiveF=1 or (RCOVER.SDATE<=C1.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<C1.LOSSDATE or (RCOVER.SDATE=C1.LOSSDATE AND ACCEPTANCE.STIME<=C1.LossTime)) AND ACCEPTANCE.ExclusiveF=0))           
 and ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>C1.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>C1.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))=C1.LOSSDATE AND
 ACCEPTANCE.ETIME>C1.LossTime)) AND ACCEPTANCE.ExclusiveF=0))          
 and (@P_COL='' or coalesce(CCOL.COL,'')=@P_COL)   
 --and (@P_Location='' or C1.location=@P_Location)   
) C   
Inner Join Profile P1 on (P1.ID=C.Claimant)   
Inner Join COLTAB C2 on (C2.COL=C.COL)   
Left Join Location L on (L.Location=C.Location)   
go




 insert into PatchVersioning
select '780 Update Script - Patch 2023 (97)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='780 Update Script - Patch 2023 (97)'


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


   

