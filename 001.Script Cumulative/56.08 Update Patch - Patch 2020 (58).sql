
insert into PatchVersioning
select '56.8 Update Patch - Patch 2020 (58)',GETDATE()
go

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='56.7 Update Patch - Patch 2020 (57)'
Select @CurrSCript='56.8 Update Patch - Patch 2020 (58)'


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
			DROP PROCEDURE QRENEWALRULE
       END TRY  
       BEGIN CATCH  
       END CATCH;


       Update SysTab Set ExecScript=@CurrScript, ExecScriptStatus='DONE'         
End


GO
CREATE PROCEDURE QRENEWALRULE(@P_TOC as varchar(10),@P_POLICYTYPE as varchar(10),@P_SEGMENT as varchar(10),@P_ValueID1 as varchar(15), @P_ValueID2 as varchar(15), @P_ValueID3 as varchar(15), @P_ValueID4 as varchar(15), @P_ValueID5 as varchar(15), @P_Code 
as varchar(10), @P_LOSSRATIO as Float, @P_CLAIMFREQ as Float, @P_OWNFAULT as Float,@P_INSPERIOD as Float, @P_SUMINSURED as Float, @P_OUTGO as Float, @P_FacOpt as int, @P_PHOLDER as varchar(10))                        
AS                        
SELECT TOP 1 coalesce(R2.RCode, R1.RCode) as RCode, coalesce(R2.RenewalF, R1.RenewalF) as RenewalF, R3.Notes, R1.OtherVar1, R1.OtherVar2, R1.OtherVar3,          
coalesce(R2.LOSSRATIOL, R1.LOSSRATIOL) as LOSSRATIOL,           
coalesce(R2.LOSSRATIOU, R1.LOSSRATIOU) as LOSSRATIOU,          
coalesce(R2.CLAIMFREQL, R1.CLAIMFREQL) as CLAIMFREQL,          
coalesce(R2.CLAIMFREQU, R1.CLAIMFREQU) as CLAIMFREQU,          
coalesce(R2.OWNFAULTL, R1.OWNFAULTL) as OWNFAULTL,          
coalesce(R2.OWNFAULTU, R1.OWNFAULTU) as OWNFAULTU,        
R1.INSPERIODL, R1.INSPERIODU,        
R1.SUMINSUREDL, R1.SUMINSUREDU,        
R1.OUTGOL, R1.OUTGOU        
FROM RENEWALRULE R1        
LEFT JOIN RENEWALRULEDET R2 ON (R2.RID=R1.RID 
 AND ((@P_LOSSRATIO BETWEEN R2.LOSSRATIOL AND R2.LOSSRATIOU) OR (R2.LOSSRATIOL=0 AND R2.LOSSRATIOU=0))                  
 AND ((@P_CLAIMFREQ BETWEEN R2.CLAIMFREQL AND R2.CLAIMFREQU) OR (R2.CLAIMFREQL=0 AND R2.CLAIMFREQU=0))                  
 AND ((@P_OWNFAULT BETWEEN R2.OWNFAULTL AND R2.OWNFAULTU) OR (R2.OWNFAULTL=0 AND R2.OWNFAULTU=0)) 
)               
LEFT JOIN RENEWALRIGHT R3 on (R3.TOC=@P_TOC and R3.RCODE=coalesce(R2.RCode, R1.RCode))                  
WHERE R1.TOC=@P_TOC                  
 AND (R1.POLICYTYPE=@P_POLICYTYPE or R1.POLICYTYPE in ('<All>',''))                   
 AND (R1.SEGMENT=@P_SEGMENT OR R1.SEGMENT='<All>')                    
 AND right(space(15)+@P_ValueID1,15) Between(Case When ValueID1L in ('<All>','') then right(space(15)+@P_ValueID1,15) When ValueID1L in ('N/A') then right(space(15),15) else right(space(15)+ValueID1L,15) end) and (Case When (Case When ValueID1U='' Then ValueID1L ELSE ValueID1U End) in ('<All>','') then right(space(15)+@P_ValueID1,15) When (Case When ValueID1U='' Then ValueID1L ELSE ValueID1U End) in ('N/A') then right(space(15),15) else right(space(15)+(Case When ValueID1U='' Then ValueID1L ELSE ValueID1U End),15) end) 
 AND right(space(15)+@P_ValueID2,15) Between(Case When ValueID2L in ('<All>','') then right(space(15)+@P_ValueID2,15) When ValueID2L in ('N/A') then right(space(15),15) else right(space(15)+ValueID2L,15) end) and (Case When (Case When ValueID2U='' Then ValueID2L ELSE ValueID2U End) in ('<All>','') then right(space(15)+@P_ValueID2,15) When (Case When ValueID2U='' Then ValueID2L ELSE ValueID2U End) in ('N/A') then right(space(15),15) else right(space(15)+(Case When ValueID2U='' Then ValueID2L ELSE ValueID2U End),15) end) 
 AND right(space(15)+@P_ValueID3,15) Between(Case When ValueID3L in ('<All>','') then right(space(15)+@P_ValueID3,15) When ValueID3L in ('N/A') then right(space(15),15) else right(space(15)+ValueID3L,15) end) and (Case When (Case When ValueID3U='' Then ValueID3L ELSE ValueID3U End) in ('<All>','') then right(space(15)+@P_ValueID3,15) When (Case When ValueID3U='' Then ValueID3L ELSE ValueID3U End) in ('N/A') then right(space(15),15) else right(space(15)+(Case When ValueID3U='' Then ValueID3L ELSE ValueID3U End),15) end) 
 AND right(space(15)+@P_ValueID4,15) Between(Case When ValueID4L in ('<All>','') then right(space(15)+@P_ValueID4,15) When ValueID4L in ('N/A') then right(space(15),15) else right(space(15)+ValueID4L,15) end) and (Case When (Case When ValueID4U='' Then ValueID4L ELSE ValueID4U End) in ('<All>','') then right(space(15)+@P_ValueID4,15) When (Case When ValueID4U='' Then ValueID4L ELSE ValueID4U End) in ('N/A') then right(space(15),15) else right(space(15)+(Case When ValueID4U='' Then ValueID4L ELSE ValueID4U End),15) end) 
 AND right(space(15)+@P_ValueID5,15) Between(Case When ValueID5L in ('<All>','') then right(space(15)+@P_ValueID5,15) When ValueID5L in ('N/A') then right(space(15),15) else right(space(15)+ValueID5L,15) end) and (Case When (Case When ValueID5U='' Then ValueID5L ELSE ValueID5U End) in ('<All>','') then right(space(15)+@P_ValueID5,15) When (Case When ValueID5U='' Then ValueID5L ELSE ValueID5U End) in ('N/A') then right(space(15),15) else right(space(15)+(Case When ValueID5U='' Then ValueID5L ELSE ValueID5U End),15) end) 
 AND (R1.Code=@P_Code OR R1.Code in ('<All>',''))                   
 AND ((@P_LOSSRATIO BETWEEN R1.LOSSRATIOL AND R1.LOSSRATIOU) OR (R1.LOSSRATIOL=0 AND R1.LOSSRATIOU=0))                  
 AND ((@P_CLAIMFREQ BETWEEN R1.CLAIMFREQL AND R1.CLAIMFREQU) OR (R1.CLAIMFREQL=0 AND R1.CLAIMFREQU=0))                  
 AND ((@P_OWNFAULT BETWEEN R1.OWNFAULTL AND R1.OWNFAULTU) OR (R1.OWNFAULTL=0 AND R1.OWNFAULTU=0))                  
 AND ((@P_INSPERIOD BETWEEN R1.INSPERIODL AND R1.INSPERIODU) OR (R1.INSPERIODL=0 AND R1.INSPERIODU=0))                  
 AND ((@P_SUMINSURED BETWEEN R1.SUMINSUREDL AND R1.SUMINSUREDU) OR (R1.SUMINSUREDL=0 AND R1.SUMINSUREDU=0))                  
 AND ((@P_OUTGO BETWEEN R1.OUTGOL AND R1.OUTGOU) OR (R1.OUTGOL=0 AND R1.OUTGOU=0))                  
 AND (R1.FACOPT=0 or R1.FACOPT=@P_FACOPT)    
 AND (R1.PHOLDER=@P_PHOLDER or R1.PHOLDER in ('<All>',''))                   
ORDER BY 
R1.PRIORITYF DESC,
coalesce(R2.RenewalF, R1.RenewalF),
Case When R1.POLICYTYPE in ('<All>','') THEN 'zz' ELSE R1.POLICYTYPE END,
Case When R1.SEGMENT in ('<All>','') THEN 'zzzzzzzzzz' ELSE R1.SEGMENT END,
R1.FACOPT,
right(space(15)+Case When R1.VALUEID1L in ('<All>','') THEN 'zzzzzzzzzzzzzzz' ELSE R1.VALUEID1L END,15), 
right(space(15)+Case When R1.VALUEID1U in ('<All>','') THEN 'zzzzzzzzzzzzzzz' ELSE R1.VALUEID1U END,15), 
right(space(15)+Case When R1.VALUEID2L in ('<All>','') THEN 'zzzzzzzzzzzzzzz' ELSE R1.VALUEID2L END,15), 
right(space(15)+Case When R1.VALUEID2U in ('<All>','') THEN 'zzzzzzzzzzzzzzz' ELSE R1.VALUEID2U END,15), 
right(space(15)+Case When R1.VALUEID3L in ('<All>','') THEN 'zzzzzzzzzzzzzzz' ELSE R1.VALUEID3L END,15), 
right(space(15)+Case When R1.VALUEID3U in ('<All>','') THEN 'zzzzzzzzzzzzzzz' ELSE R1.VALUEID3U END,15), 
right(space(15)+Case When R1.VALUEID4L in ('<All>','') THEN 'zzzzzzzzzzzzzzz' ELSE R1.VALUEID4L END,15), 
right(space(15)+Case When R1.VALUEID4U in ('<All>','') THEN 'zzzzzzzzzzzzzzz' ELSE R1.VALUEID4U END,15), 
right(space(15)+Case When R1.VALUEID5L in ('<All>','') THEN 'zzzzzzzzzzzzzzz' ELSE R1.VALUEID5L END,15), 
right(space(15)+Case When R1.VALUEID5U in ('<All>','') THEN 'zzzzzzzzzzzzzzz' ELSE R1.VALUEID5U END,15), 
R1.LOSSRATIOL, R1.LOSSRATIOU,
R1.CLAIMFREQL, R1.CLAIMFREQU,
R1.OWNFAULTL,R1.OWNFAULTU,
R1.INSPERIODL, R1.INSPERIODU,
R1.SUMINSUREDU, R1.SUMINSUREDL,
R1.OUTGOL,R1.OUTGOU,
Case When R1.PHOLDER in ('<All>','') THEN 'zzzzzzzzzz' ELSE R1.PHOLDER END



