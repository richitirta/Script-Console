if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'MListQry_3') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function MListQry_3
END
GO
CREATE function MListQry_3 (@value1 as varchar(255) ,@value2 as varchar(255) ,@value3 as varchar(255) ,@value4 as varchar(255) ,@value5 as varchar(255) ,@value6 as varchar(255) ,@value7 as varchar(255) ,@value8 as varchar(255) ,@value9 as varchar(255),@Value10 as varchar(255), @Value11 as varchar(255), @Value12 as varchar(255), @Value13 as varchar(255))   
RETURNS Table   
AS return   
(   
SELECT   
Cast(0 as bit) as ProcessFlag,   
Cover.COVERNO,   
Cover.Insured,   
Cover.CNO,   
Cover.CStatus,   
Cover.VSeqNo,   
Acceptance.lANO,   
Acceptance.ANO,   
Acceptance.REGNO,   
Acceptance.ADATE,   
Acceptance.USERID,   
SysTab.Currency,   
(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
Acceptance.ASTATUS,   
Acceptance.ATYPE,   
Acceptance.SDate,   
Acceptance.EDate,   
Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear,   
Cover.ISType,   
Acceptance.Renewal,   
Acceptance.ESeqNo,   
Acceptance.PolicyNo,   
acceptance.ano as ano_info   
FROM  Acceptance 
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Profile on (Profile.ID=Cover.PHolder), SysTab
Where (Acceptance.AName Like @Value1)   
And (Cover.CoverNo Like @Value2 Or (Cover.CoverNo is null))   
and (Cover.CoverDate = @Value3 Or (Cover.CoverDate is null) or @Value3 = '')   
And (Cover.ExpDate = @Value4 Or (Cover.ExpDate is null) or @Value4 = '')   
And (Acceptance.PolicyNo Like @Value5 Or (Acceptance.PolicyNo is null))   
And (Acceptance.CertificateNo Like @Value6 Or (Acceptance.CertificateNo is null))   
and (Acceptance.PolicyDate = @Value7 Or (Acceptance.PolicyDate is null) or @Value7 = '')   
And (Cover.CStatus Like @Value8)   
And (Acceptance.RegNo Like @Value9)   
And (Profile.Name Like @Value10 or Profile.ID is null)   
and Acceptance.toc like @Value11   
And (Acceptance.RefNo Like @Value13)   
And (Acceptance.LANO = -1)   
And Cover.ISType<>'T'   
   
Union All   
   
SELECT   
Cast(0 as bit) as ProcessFlag,   
Cover.COVERNO,   
Cover.Insured,   
Cover.CNO,   
Cover.CStatus,   
Cover.VSeqNo,   
Acceptance.lANO,   
Acceptance.ANO,   
Acceptance.REGNO,   
Acceptance.ADATE,   
Acceptance.USERID,   
SysTab.Currency,   
0 as TSI,   
0 as OurShare,   
0 as Gross,   
Acceptance.ASTATUS,   
Acceptance.ATYPE,   
Acceptance.SDate,   
Acceptance.EDate,   
Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear,   
Cover.ISType,   
Acceptance.Renewal,   
Acceptance.ESeqNo,   
Acceptance.PolicyNo,   
acceptance_detail.ano as ano_info   
FROM  
acceptance as acceptance_detail   
Inner Join Acceptance on (Acceptance.ANO=Acceptance_Detail.LANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Profile on (Profile.ID=Cover.PHolder), SysTab
Where (Acceptance_Detail.AName Like @Value1)   
And (Cover.CoverNo Like @Value2 Or (Cover.CoverNo is null))   
and (Cover.CoverDate = @Value3 Or (Cover.CoverDate is null) or @Value3 = '')   
And (Cover.ExpDate = @Value4 Or (Cover.ExpDate is null) or @Value4 = '')   
And (Acceptance_Detail.PolicyNo Like @Value5 Or (Acceptance_Detail.PolicyNo is null))   
And (Acceptance_Detail.CertificateNo Like @Value6 Or (Acceptance_Detail.CertificateNo is null))   
and (Acceptance_Detail.PolicyDate = @Value7 Or (Acceptance_Detail.PolicyDate is null) or @Value7 = '')   
And (Cover.CStatus Like @Value8)   
And (Acceptance_Detail.RegNo Like @Value9)   
And (Profile.Name Like @Value10 or Profile.ID is null)   
and Acceptance.toc like @Value11   
And (Acceptance.RefNo Like @Value13)   
And (Acceptance_detail.ANO <> Acceptance_detail.LANO and Acceptance_detail.LANO <> -1)   
And Cover.ISType<>'T'   
)   
   

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'MListQry_3_a') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function MListQry_3_a
END
GO
CREATE function MListQry_3_a(@value1 as varchar(255) ,@value2 as varchar(255) ,@value3 as varchar(255) ,@value4 as varchar(255) ,@value5 as varchar(255) ,@value6 as varchar(255) ,@value7 as varchar(255) ,
@value8 as varchar(255), @value9 as varchar(255),@Value10 as varchar(255), @Value11 as varchar(255), @Value12 as varchar(255), @Value13 as varchar(255))     
returns table    
as return    
(    
SELECT   Cast(0 as bit) as ProcessFlag,     
  q.CoverNo,     
  q.Insured,     
  q.CNO,     
  q.CStatus,     
  q.VSeqNo,     
  q.lANO,     
  q.ANO,     
  q.REGNO,     
  q.ADATE,     
  q.USERID,     
  q.Currency,     
  q.TSI,     
  q.OurShare,     
  q.Gross,     
  q.ASTATUS,     
  q.ATYPE,     
  q.SDate,     
  q.EDate,     
  q.RYear,     
  q.ISType,     
  q.Renewal,     
  q.ESeqNo,     
  q.PolicyNo,    
  a.valueid1, a.valuedesc1,    
  a.valueid2, a.valuedesc2,    
  a.valueid3, a.valuedesc3,    
  a.valueid4, a.valuedesc4,    
  a.valueid5, a.valuedesc5,    
  a.valueid6, a.valuedesc6,    
  a.valueid7, a.valuedesc7,    
  a.valueid8, a.valuedesc8,    
  a.valueid9, a.valuedesc9,    
  a.valueid10, a.valuedesc10,    
  a.valueid11, a.valuedesc11,    
  a.valueid12, a.valuedesc12,    
  a.valueid13, a.valuedesc13,    
  a.valueid14, a.valuedesc14,    
  a.valueid15, a.valuedesc15,
  b.valueid16, b.valuedesc16,  
  b.valueid17, b.valuedesc17,  
  b.valueid18, b.valuedesc18,  
  b.valueid19, b.valuedesc19,  
  b.valueid20, b.valuedesc20,  
  b.valueid21, b.valuedesc21,  
  b.valueid22, b.valuedesc22,  
  b.valueid23, b.valuedesc23,  
  b.valueid24, b.valuedesc24,  
  b.valueid25, b.valuedesc25,  
  b.valueid26, b.valuedesc26,  
  b.valueid27, b.valuedesc27,  
  b.valueid28, b.valuedesc28,  
  b.valueid29, b.valuedesc29,  
  b.VALUEID30 , b.VALUEDESC30           
FROM  MListQry_3(@Value1, @Value2, @Value3, @Value4, @Value5, @Value6, @Value7, @Value8, @Value9, @Value10, @Value11, @Value12, @Value13) q
Inner Join ainfo a on (a.ano=q.ano_info)
Left Join Ainfo_Ext b on (b.ano=q.ano_info)    
)  

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'MListQry_3_b') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function MListQry_3_b
END
GO
CREATE function MListQry_3_b(@value1 as varchar(255) ,@value2 as varchar(255) ,@value3 as varchar(255) ,@value4 as varchar(255) ,@value5 as varchar(255) ,@value6 as varchar(255) ,@value7 as varchar(255) ,
@value8 as varchar(255), @value9 as varchar(255),@Value10 as varchar(255), @Value11 as varchar(255), @Value12 as varchar(255), @Value13 as varchar(255), @Value14 as varchar(255))
returns table    
as return    
(    
SELECT   Cast(0 as bit) as ProcessFlag,     
  q.CoverNo,     
  q.Insured,     
  q.CNO,     
  q.CStatus,     
  q.VSeqNo,     
  q.lANO,     
  q.ANO,     
  q.REGNO,     
  q.ADATE,     
  q.USERID,     
  q.Currency,     
  q.TSI,     
  q.OurShare,     
  q.Gross,     
  q.ASTATUS,     
  q.ATYPE,     
  q.SDate,     
  q.EDate,     
  q.RYear,     
  q.ISType,     
  q.Renewal,     
  q.ESeqNo,     
  q.PolicyNo,    
  a.valueid1, a.valuedesc1,    
  a.valueid2, a.valuedesc2,    
  a.valueid3, a.valuedesc3,    
  a.valueid4, a.valuedesc4,    
  a.valueid5, a.valuedesc5,    
  a.valueid6, a.valuedesc6,    
  a.valueid7, a.valuedesc7,    
  a.valueid8, a.valuedesc8,    
  a.valueid9, a.valuedesc9,    
  a.valueid10, a.valuedesc10,    
  a.valueid11, a.valuedesc11,    
  a.valueid12, a.valuedesc12,    
  a.valueid13, a.valuedesc13,    
  a.valueid14, a.valuedesc14,    
  a.valueid15, a.valuedesc15,
  b.valueid16, b.valuedesc16,  
  b.valueid17, b.valuedesc17,  
  b.valueid18, b.valuedesc18,  
  b.valueid19, b.valuedesc19,  
  b.valueid20, b.valuedesc20,  
  b.valueid21, b.valuedesc21,  
  b.valueid22, b.valuedesc22,  
  b.valueid23, b.valuedesc23,  
  b.valueid24, b.valuedesc24,  
  b.valueid25, b.valuedesc25,  
  b.valueid26, b.valuedesc26,  
  b.valueid27, b.valuedesc27,  
  b.valueid28, b.valuedesc28,  
  b.valueid29, b.valuedesc29,  
  b.VALUEID30 , b.VALUEDESC30           
FROM  MListQry_3(@Value1, @Value2, @Value3, @Value4, @Value5, @Value6, @Value7, @Value8, @Value9, @Value10, @Value11, @Value12, @Value13) q
Inner Join ainfo a on (a.ano=q.ano_info)
Left Join Ainfo_Ext b on (b.ano=q.ano_info)    
Where '|'+VALUEID1+'|'+VALUEDESC1+'|'+VALUEID2+'|'+VALUEDESC2+'|'+VALUEID3+'|'+VALUEDESC3+'|'+VALUEID4+'|'+VALUEDESC4+'|'+VALUEID5+'|'+VALUEDESC5+'|'+VALUEID6+'|'+VALUEDESC6+'|'+VALUEID7+'|'+VALUEDESC7+'|'+VALUEID8+'|'+VALUEDESC8+'|'+VALUEID9+'|'+VALUEDESC9+'|'+VALUEID10+'|'+VALUEDESC10+'|'+VALUEID11+'|'+VALUEDESC11+'|'+VALUEID12+'|'+VALUEDESC12+'|'+VALUEID13+'|'+VALUEDESC13+'|'+VALUEID14+'|'+VALUEDESC14+'|'+VALUEID15+'|'+VALUEDESC15 LIKE '|%'+@Value14+'%'
)  

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'MListQry_3b') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function MListQry_3b 
END
GO
CREATE function MListQry_3b (@value1 as varchar(255) ,@value2 as varchar(255) ,@value3 as varchar(255) ,@value4 as varchar(255) ,@value5 as varchar(255) ,@value6 as varchar(255) ,@value7 as varchar(255) ,@value8 as varchar(255) ,@value9 as varchar(255),@Value10 as varchar(255), @Value11 as varchar(255), @Value12 as varchar(255), @Value13 as varchar(255))   
RETURNS Table   
as return   
(   
SELECT   
Cast(0 as bit) as ProcessFlag,   
Cover.COVERNO,   
Cover.Insured,   
Cover.CNO,   
Cover.CStatus,   
Cover.VSeqNo,   
Acceptance.lANO,   
Acceptance.ANO,   
Acceptance.REGNO,   
Acceptance.ADATE,   
Acceptance.USERID,   
SysTab.Currency,   
(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
Acceptance.ASTATUS,   
Acceptance.ATYPE,   
Acceptance.SDate,   
Acceptance.EDate,   
Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear,   
Cover.ISType,   
Acceptance.Renewal,   
Acceptance.ESeqNo,   
acceptance.PolicyNo   
FROM  Acceptance 
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Profile on (Profile.ID=Cover.PHolder), SysTab
Where cover.CNO = acceptance.CNO   
And Cover.PHOLDER=Profile.ID   
And (Acceptance.AName Like @Value1)   
And (Cover.CoverNo Like @Value2 Or (Cover.CoverNo is null))   
and (Cover.CoverDate = @Value3 Or (Cover.CoverDate is null) or @Value3 = '')   
And (Cover.ExpDate = @Value4 Or (Cover.ExpDate is null) or @Value4 = '')   
And (Acceptance.PolicyNo Like @Value5 Or (Acceptance.PolicyNo is null))   
And (Acceptance.CertificateNo Like @Value6 Or (Acceptance.CertificateNo is null))   
and (Acceptance.PolicyDate = @Value7 Or (Acceptance.PolicyDate is null) or @Value7 = '')   
And (Cover.CStatus Like @Value8)   
And (Acceptance.RegNo Like @Value9)   
And (Profile.Name Like @Value10 or Profile.ID is null)   
And (Acceptance.TOC Like @Value11)   
And (Acceptance.RefNo Like @Value13)   
And (Acceptance.ANO=Acceptance.lANO Or Acceptance.lANO=-1)   
And Cover.ISType<>'T'   
) 

GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'MListQry_3b_a') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function MListQry_3b_a 
END
GO
CREATE function MListQry_3b_a (@value1 as varchar(255) ,@value2 as varchar(255) ,@value3 as varchar(255) ,@value4 as varchar(255) ,@value5 as varchar(255) ,@value6 as varchar(255) ,@value7 as varchar(255) ,@value8 as varchar(255) ,@value9 as varchar(255),
@Value10 as varchar(255), @Value11 as varchar(255), @Value12 as varchar(255), @Value13 as varchar(255)) 
returns table
as return
(
SELECT 		Cast(0 as bit) as ProcessFlag, 
		q.[COVERNO], 
		q.[Insured], 
		q.[CNO], 
		q.[CStatus], 
		q.VSeqNo, 
		q.[lANO], 
		q.[ANO], 
		q.[REGNO], 
		q.[ADATE], 
		q.[USERID], 
		q.[Currency], 
		q.[TSI], 
		q.[OurShare], 
		q.[Gross], 
		q.[ASTATUS], 
		q.[ATYPE], 
		q.[SDate], 
		q.[EDate], 
		q.RYear, 
		q.[ISType], 
		q.[Renewal], 
		q.[ESeqNo], 
		q.[PolicyNo],
		a.valueid1, a.valuedesc1,
		a.valueid2, a.valuedesc2,
		a.valueid3, a.valuedesc3,
		a.valueid4, a.valuedesc4,
		a.valueid5, a.valuedesc5,
		a.valueid6, a.valuedesc6,
		a.valueid7, a.valuedesc7,
		a.valueid8, a.valuedesc8,
		a.valueid9, a.valuedesc9,
		a.valueid10, a.valuedesc10,
		a.valueid11, a.valuedesc11,
		a.valueid12, a.valuedesc12,
		a.valueid13, a.valuedesc13,
		a.valueid14, a.valuedesc14,
		a.valueid15, a.valuedesc15,
		b.valueid16, b.valuedesc16,  
		b.valueid17, b.valuedesc17,  
		b.valueid18, b.valuedesc18,  
		b.valueid19, b.valuedesc19,  
		b.valueid20, b.valuedesc20,  
		b.valueid21, b.valuedesc21,  
		b.valueid22, b.valuedesc22,  
		b.valueid23, b.valuedesc23,  
		b.valueid24, b.valuedesc24,  
		b.valueid25, b.valuedesc25,  
		b.valueid26, b.valuedesc26,  
		b.valueid27, b.valuedesc27,  
		b.valueid28, b.valuedesc28,  
		b.valueid29, b.valuedesc29,  
		b.VALUEID30 , b.VALUEDESC30   
FROM 	MListQry_3b(@Value1,@Value2,@Value3,@Value4,@Value5,@Value6,@Value7,@Value8,@Value9,@Value10,@Value11,@Value12, @value13) q
Inner Join ainfo a on (a.ANO=q.ANO) 
Left Join Ainfo_Ext b on (b.ANO=q.ANO) 
)

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'MListQry_3b_b') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function MListQry_3b_b
END
GO
CREATE function MListQry_3b_b (@value1 as varchar(255) ,@value2 as varchar(255) ,@value3 as varchar(255) ,@value4 as varchar(255) ,@value5 as varchar(255) ,@value6 as varchar(255) ,@value7 as varchar(255) ,@value8 as varchar(255) ,@value9 as varchar(255),
@Value10 as varchar(255), @Value11 as varchar(255), @Value12 as varchar(255), @Value13 as varchar(255), @Value14 as varchar(255)) 
returns table
as return
(
SELECT 		Cast(0 as bit) as ProcessFlag, 
		q.[COVERNO], 
		q.[Insured], 
		q.[CNO], 
		q.[CStatus], 
		q.VSeqNo, 
		q.[lANO], 
		q.[ANO], 
		q.[REGNO], 
		q.[ADATE], 
		q.[USERID], 
		q.[Currency], 
		q.[TSI], 
		q.[OurShare], 
		q.[Gross], 
		q.[ASTATUS], 
		q.[ATYPE], 
		q.[SDate], 
		q.[EDate], 
		q.RYear, 
		q.[ISType], 
		q.[Renewal], 
		q.[ESeqNo], 
		q.[PolicyNo],
		a.valueid1, a.valuedesc1,
		a.valueid2, a.valuedesc2,
		a.valueid3, a.valuedesc3,
		a.valueid4, a.valuedesc4,
		a.valueid5, a.valuedesc5,
		a.valueid6, a.valuedesc6,
		a.valueid7, a.valuedesc7,
		a.valueid8, a.valuedesc8,
		a.valueid9, a.valuedesc9,
		a.valueid10, a.valuedesc10,
		a.valueid11, a.valuedesc11,
		a.valueid12, a.valuedesc12,
		a.valueid13, a.valuedesc13,
		a.valueid14, a.valuedesc14,
		a.valueid15, a.valuedesc15,
		b.valueid16, b.valuedesc16,  
		b.valueid17, b.valuedesc17,  
		b.valueid18, b.valuedesc18,  
		b.valueid19, b.valuedesc19,  
		b.valueid20, b.valuedesc20,  
		b.valueid21, b.valuedesc21,  
		b.valueid22, b.valuedesc22,  
		b.valueid23, b.valuedesc23,  
		b.valueid24, b.valuedesc24,  
		b.valueid25, b.valuedesc25,  
		b.valueid26, b.valuedesc26,  
		b.valueid27, b.valuedesc27,  
		b.valueid28, b.valuedesc28,  
		b.valueid29, b.valuedesc29,  
		b.VALUEID30 , b.VALUEDESC30   
FROM 	MListQry_3b(@Value1,@Value2,@Value3,@Value4,@Value5,@Value6,@Value7,@Value8,@Value9,@Value10,@Value11,@Value12, @value13) q
Inner Join ainfo a on (a.ANO=q.ANO) 
Left Join Ainfo_Ext b on (b.ANO=q.ANO) 
Where '|'+VALUEID1+'|'+VALUEDESC1+'|'+VALUEID2+'|'+VALUEDESC2+'|'+VALUEID3+'|'+VALUEDESC3+'|'+VALUEID4+'|'+VALUEDESC4+'|'+VALUEID5+'|'+VALUEDESC5+'|'+VALUEID6+'|'+VALUEDESC6+'|'+VALUEID7+'|'+VALUEDESC7+'|'+VALUEID8+'|'+VALUEDESC8+'|'+VALUEID9+'|'+VALUEDESC9+'|'+VALUEID10+'|'+VALUEDESC10+'|'+VALUEID11+'|'+VALUEDESC11+'|'+VALUEID12+'|'+VALUEDESC12+'|'+VALUEID13+'|'+VALUEDESC13+'|'+VALUEID14+'|'+VALUEDESC14+'|'+VALUEID15+'|'+VALUEDESC15 LIKE '|%'+@Value14+'%'
)

GO

insert into PatchVersioning
select '55.36 Update Script - Patch 2020 (36)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='55.35 Update Script - Patch 2020 (35)'
Select @CurrSCript='55.36 Update Script - Patch 2020 (36)'


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


