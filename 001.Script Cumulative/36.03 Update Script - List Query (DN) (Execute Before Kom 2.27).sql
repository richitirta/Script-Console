SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MList11D]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [MList11D] 
end
GO
CREATE FUNCTION  [dbo].[MList11D](@P_ANO AS INTEGER, @value1 as varchar(255) ,@value2 as varchar(255) ,@value3 as varchar(255) ,@value4 as varchar(255) ,@value5 as varchar(255) ,@value6 as varchar(255) ,@Value7 as varchar(255) ,@value8 as varchar(255) ,@value9 as varchar(255),@Value10 as varchar(255), @Value11 as varchar(255))  
returns table  
AS return  
(  
SELECT   
 Cast(0 as bit) as ProcessFlag,   
 Cover.COVERNO,   
 Cast(Acceptance.AName as varchar(128)) as AName,   
 Acceptance.CertificateNo,   
 Cover.CNO,   
 Cover.CStatus,   
 Cover.VSeqNo,   
 Acceptance.LANO,   
 Acceptance.ANO,   
 Acceptance.REGNO,   
 Acceptance.ADATE,   
 Acceptance.USERID,   
 SysTab.Currency,   
 QPCalc.TSI,   
 QPCalc.OurShare,   
 QPCalc.Gross,   
 Acceptance.ASTATUS,   
 Acceptance.ATYPE,   
 Acceptance.SDate,   
 Acceptance.EDate,   
 Year(RArrheader.Rdate) AS RYear  
FROM   
 Acceptance,   
 Cover,   
 RArrHeader,   
 SysTab,   
 QMasterAcceptance_PCalc() AS QPCalc,  
 Profile  
WHERE   
 Cover.CNO=Acceptance.CNO   
 And RArrHeader.ANO=Acceptance.ANO   
 And QPCalc.ANO=Acceptance.ANO   
 And Acceptance.ANO<>Acceptance.LANO   
 And Acceptance.LANO=@P_ANO  
  And Cover.PHOLDER=Profile.ID  
 And (Cover.Insured Like @Value1 Or (Cover.Insured is null))   
 And (Cover.CoverNo Like @Value2 Or (Cover.CoverNo is null))   
 And (cover.coverdate=@Value3 Or (cover.coverdate IS NULL) Or cover.coverdate='' or @Value3='')  
 And (cover.expdate=@Value4 Or (cover.expdate IS NULL) Or cover.expdate='' or @Value4='')    
 And (Acceptance.PolicyNo Like @Value5 Or (Acceptance.PolicyNo is null))   
 And (Acceptance.CertificateNo Like @Value6 Or (Acceptance.CertificateNo is null))   
 And (acceptance.policydate=@Value7 Or (acceptance.policydate IS NULL) Or acceptance.policydate='' or @Value7='')  
 And (Cover.CStatus Like @Value8)   
 And (Acceptance.RegNo Like @Value9)   
 And (Profile.Name like @Value10 or Profile.Name is null)  
 and cover.toc like @Value11  
 And Cover.ISType<>'T'  
)  
  
  
                                              
GO

/****** Object:  UserDefinedFunction [dbo].[MList11E]    Script Date: 12/21/2017 1:43:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MList11E]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [MList11E] 
end
GO
CREATE FUNCTION  [dbo].[MList11E](@P_ANO AS INTEGER, @value1 as varchar(255) ,@value2 as varchar(255) ,@value3 as varchar(255) ,@value4 as varchar(255) ,@value5 as varchar(255) ,@value6 as varchar(255) ,@Value7 as varchar(255) ,@value8 as varchar(255) ,@value9 as varchar(255),@Value10 as varchar(255), @Value11 as varchar(255))  
returns table  
AS return  
(  
SELECT   
 Cast(0 as bit) as ProcessFlag,   
 Q.COVERNO,   
 Q.AName,   
 Q.CertificateNo,   
 Q.CNO,   
 Q.CStatus,   
 Q.VSeqNo,   
 Q.LANO,   
 Q.ANO,   
 Q.REGNO,   
 Q.ADATE,   
 Q.USERID,   
 Q.Currency,   
 Q.TSI,   
 Q.OurShare,   
 Q.Gross,   
 Q.ASTATUS,   
 Q.ATYPE,   
 Q.SDate,   
 Q.EDate,   
 Q.RYear,  
 A.VALUEID1, A.VALUEDESC1,  
 A.VALUEID2, A.VALUEDESC2,  
 A.VALUEID3, A.VALUEDESC3,  
 A.VALUEID4, A.VALUEDESC4,  
 A.VALUEID5, A.VALUEDESC5,  
 A.VALUEID6, A.VALUEDESC6,  
 A.VALUEID7, A.VALUEDESC7,  
 A.VALUEID8, A.VALUEDESC8,  
 A.VALUEID9, A.VALUEDESC9,  
 A.VALUEID10, A.VALUEDESC10,  
 A.VALUEID11, A.VALUEDESC11,  
 A.VALUEID12, A.VALUEDESC12,  
 A.VALUEID13, A.VALUEDESC13,  
 A.VALUEID14, A.VALUEDESC14,  
 A.VALUEID15, A.VALUEDESC15  
FROM   
 MList11D(@P_ANO, @value1, @value2, @value3, @value4, @value5, @value6, @Value7, @value8, @value9, @Value10, @Value11) AS Q,  
 AINFO AS A  
WHERE   
 Q.ANO = A.ANO  
)  
  

GO

/****** Object:  UserDefinedFunction [dbo].[MListQry_3]    Script Date: 12/21/2017 1:43:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MListQry_3]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [MListQry_3] 
end
GO
CREATE FUNCTION  [dbo].[MListQry_3](@value1 as varchar(255) ,@value2 as varchar(255) ,@value3 as varchar(255) ,@value4 as varchar(255) ,@value5 as varchar(255) ,@value6 as varchar(255) ,@value7 as varchar(255) ,@value8 as varchar(255) ,@value9 as varchar(255),@Value10 as varchar(255), @Value11 as varchar(255), @Value12 as varchar(255))   
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
QPCalc.TSI,   
QPCalc.OurShare,   
QPCalc.Gross,   
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
FROM  Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)   
Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab, Profile   
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
and Acceptance.toc like @Value11   
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
From Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO), Cover, SysTab, Profile, acceptance as acceptance_detail   
Where cover.CNO = acceptance.CNO   
And Cover.PHOLDER=Profile.ID   
and acceptance.ano = acceptance_detail.lano   
And (Acceptance_Detail.AName Like @Value1)   
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
And (Acceptance_detail.ANO <> Acceptance_detail.LANO and Acceptance_detail.LANO <> -1)   
And Cover.ISType<>'T'   
)   
   

GO

/****** Object:  UserDefinedFunction [dbo].[MListQry_3_a]    Script Date: 12/21/2017 1:43:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MListQry_3_a]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [MListQry_3_a] 
end
GO
CREATE FUNCTION  [dbo].[MListQry_3_a](@value1 as varchar(255) ,@value2 as varchar(255) ,@value3 as varchar(255) ,@value4 as varchar(255) ,@value5 as varchar(255) ,@value6 as varchar(255) ,@value7 as varchar(255) ,@value8 as varchar(255) ,@value9 as varchar(255),@Value10 as varchar(255), @Value11 as varchar(255), @Value12 as varchar(255))     
returns table    
as return    
(    
SELECT   Cast(0 as bit) as ProcessFlag,     
  q.[CoverNo],     
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
  a.valueid15, a.valuedesc15      
FROM  MListQry_3(@Value1, @Value2, @Value3, @Value4, @Value5, @Value6, @Value7, @Value8, @Value9, @Value10, @Value11, @Value12) as q, ainfo as a    
WHERE  q.ano_info = a.ano    
)  


GO

/****** Object:  UserDefinedFunction [dbo].[MList01_DET]    Script Date: 12/21/2017 1:43:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MList01_DET]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [MList01_DET] 
end
GO
CREATE FUNCTION  [dbo].[MList01_DET](@P_ANO AS INTEGER,@P_USERID as varchar(50)) 
RETURNS TABLE
AS RETURN(
SELECT  Cast(0 as bit) as ProcessFlag, 
	[Cover].[COVERNO], 
	[Acceptance].[AName], 
	[Acceptance].[CertificateNo], 
	[Cover].[CNO], 
	[Cover].[CStatus], 
	[Cover].[VSeqNo], 
	[Acceptance].[LANO], 
	[Acceptance].[ANO], 
	[Acceptance].[REGNO], 
	[Acceptance].[ADATE], 
	[Acceptance].[USERID], 
	[SysTab].[Currency], 
	[QPCalc].[TSI], 
	[QPCalc].[OurShare], 
	[QPCalc].[Gross], 
	[Acceptance].[ASTATUS], 
	[Acceptance].[ATYPE], 
	[Acceptance].[SDate], 
	[Acceptance].[EDate], 
	Year([RArrheader].[Rdate]) AS RYear
FROM 
	Acceptance, 
	Cover, 
	RArrHeader, 
	SysTab, 
	QMasterAcceptance_PCalc() AS QPCalc
WHERE 
	[Cover].[CNO]=[Acceptance].[CNO] 
	And [RArrHeader].[ANO]=[Acceptance].[ANO] 
	And [QPCalc].[ANO]=[Acceptance].[ANO] 
	And [Acceptance].[ANO]<>[Acceptance].[LANO] 
	And [Acceptance].[LANO]=@P_ANO
	And [Acceptance].[LUserID] Like @P_UserID
	And [Cover].[CStatus]='R'
)











GO

/****** Object:  UserDefinedFunction [dbo].[MList01A_DET]    Script Date: 12/21/2017 1:43:54 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MList01A_DET]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [MList01A_DET] 
end
GO
CREATE FUNCTION  [dbo].[MList01A_DET](@P_ANO AS INTEGER,@P_DATE as SmallDatetime) 
RETURNS TABLE
AS RETURN (
SELECT  Cast(0 as bit) as ProcessFlag, 
	[Cover].[COVERNO], 
	[Acceptance].[AName], 
	[Acceptance].[CertificateNo], 
	[Cover].[CNO], 
	[Cover].[CStatus], 
	[Cover].[VSeqNo], 
	[Acceptance].[LANO], 
	[Acceptance].[ANO], 
	[Acceptance].[REGNO], 
	[Acceptance].[ADATE], 
	[Acceptance].[USERID], 
	[SysTab].[Currency], 
	[QPCalc].[TSI], 
	[QPCalc].[OurShare], 
	[QPCalc].[Gross], 
	[Acceptance].[ASTATUS], 
	[Acceptance].[ATYPE], 
	[Acceptance].[SDate], 
	[Acceptance].[EDate], 
	Year([RArrheader].[Rdate]) AS RYear
FROM 
	Acceptance, 
	Cover, 
	RArrHeader, 
	SysTab, 
	QMasterAcceptance_PCalc() AS QPCalc
WHERE 
	[Cover].[CNO]=[Acceptance].[CNO] 
	And [RArrHeader].[ANO]=[Acceptance].[ANO] 
	And [QPCalc].[ANO]=[Acceptance].[ANO] 
	And [Acceptance].[ANO]<>[Acceptance].[LANO] 
	And [Acceptance].[LANO]=@P_ANO
	And [Cover].[CStatus]='R'
	And [Cover].[CDate]+[Cover].[Validation]<=@p_Date
)


GO

/****** Object:  UserDefinedFunction [dbo].[MLIST02_DET]    Script Date: 12/21/2017 1:43:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MLIST02_DET]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [MLIST02_DET] 
end
GO
CREATE FUNCTION  [dbo].[MLIST02_DET] (@P_ANO AS INTEGER) 
RETURNS TABLE
AS RETURN(
SELECT  Cast(0 as bit) as ProcessFlag, 
	[Cover].[COVERNO], 
	[Acceptance].[AName], 
	[Acceptance].[CertificateNo], 
	[Cover].[CNO], 
	[Cover].[CStatus], 
	[Cover].[VSeqNo], 
	[Acceptance].[LANO], 
	[Acceptance].[ANO], 
	[Acceptance].[REGNO], 
	[Acceptance].[ADATE], 
	[Acceptance].[USERID], 
	[SysTab].[Currency], 
	[QPCalc].[TSI], 
	[QPCalc].[OurShare], 
	[QPCalc].[Gross], 
	[Acceptance].[ASTATUS], 
	[Acceptance].[ATYPE], 
	[Acceptance].[SDate], 
	[Acceptance].[EDate], 
	Year([RArrheader].[Rdate]) AS RYear
FROM 
	Acceptance, 
	Cover, 
	RArrHeader, 
	SysTab, 
	QMasterAcceptance_PCalc() AS QPCalc
WHERE 
	[Cover].[CNO]=[Acceptance].[CNO] 
	And [RArrHeader].[ANO]=[Acceptance].[ANO] 
	And [QPCalc].[ANO]=[Acceptance].[ANO] 
	And [Acceptance].[ANO]<>[Acceptance].[LANO] 
	And [Acceptance].[LANO]=@P_ANO 
	And [Acceptance].[AType]='N' 
	And [Acceptance].[AStatus]='W' 
	And [Cover].[CStatus]='A'
)

GO

/****** Object:  UserDefinedFunction [dbo].[MList03_DET]    Script Date: 12/21/2017 1:43:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MList03_DET]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [MList03_DET] 
end
GO
CREATE FUNCTION  [dbo].[MList03_DET]  (@P_ANO AS INTEGER,@P_USERID as varchar(50)) 
RETURNS TABLE
AS RETURN(
SELECT  Cast(0 as bit) as ProcessFlag, 
	[Cover].[COVERNO], 
	[Acceptance].[AName], 
	[Acceptance].[CertificateNo], 
	[Cover].[CNO], 
	[Cover].[CStatus], 
	[Cover].[VSeqNo], 
	[Acceptance].[LANO], 
	[Acceptance].[ANO], 
	[Acceptance].[REGNO], 
	[Acceptance].[ADATE], 
	[Acceptance].[USERID], 
	[SysTab].[Currency], 
	[QPCalc].[TSI], 
	[QPCalc].[OurShare], 
	[QPCalc].[Gross], 
	[Acceptance].[ASTATUS], 
	[Acceptance].[ATYPE], 
	[Acceptance].[SDate], 
	[Acceptance].[EDate], 
	Year([RArrheader].[Rdate]) AS RYear
FROM 
	Acceptance, 
	Cover, 
	RArrHeader, 
	SysTab, 
	QMasterAcceptance_PCalc() AS QPCalc
WHERE 
	[Cover].[CNO]=[Acceptance].[CNO] 
	And [RArrHeader].[ANO]=[Acceptance].[ANO] 
	And [QPCalc].[ANO]=[Acceptance].[ANO] 
	And [Acceptance].[ANO]<>[Acceptance].[LANO] 
	And [Acceptance].[LANO]=@P_ANO 
	And [Acceptance].[AType]='N' 
	And [Acceptance].[AStatus]='C' 
	And [Cover].[CStatus]='C'
	And [Acceptance].[LUserID] Like @P_UserID
)




GO

/****** Object:  UserDefinedFunction [dbo].[MList04_DET]    Script Date: 12/21/2017 1:43:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MList04_DET]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [MList04_DET] 
end
GO
CREATE FUNCTION  [dbo].[MList04_DET](@P_ANO AS INTEGER,@P_USERID as varchar(50))
RETURNS Table
AS RETURN(
SELECT
 Cast(0 as bit) as ProcessFlag, 
 [Cover].[COVERNO],
 [Acceptance].[AName],
 [Acceptance].[CertificateNo],
 [Cover].[CNO],
 [Cover].[CStatus],
 [Cover].[VSeqNo],
 [Acceptance].[LANO],
 [Acceptance].[ANO],
 [Acceptance].[REGNO],
 [Acceptance].[ADATE],
 [Acceptance].[USERID],
 [SysTab].[Currency],
 [QPCalc].[TSI],
 [QPCalc].[OurShare],
 [QPCalc].[Gross],
 [Acceptance].[ASTATUS],
 [Acceptance].[ATYPE],
 [Acceptance].[SDate],
 [Acceptance].[EDate],
 Year([RARRHEADER].[RDATE]) As RYear
From
 Acceptance,
 Cover,
 RArrHeader,
 SysTab,
 QMasterAcceptance_PCalc() As QPCalc
Where
 [cover].[CNO] = [acceptance].[CNO]
 And [RArrHeader].[ANO]=[Acceptance].[ANO]
 And [QPCalc].[ANO]=[Acceptance].[ANO]
 And [Acceptance].[ANO]<>[Acceptance].[LANO]
 And [Acceptance].[LANO]=@P_ANO
 And [Acceptance].[LUserID] Like @P_UserID
 And [Cover].[CStatus]='R'
)
  
  

GO

/****** Object:  UserDefinedFunction [dbo].[MList04a_Det]    Script Date: 12/21/2017 1:43:54 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO


iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MList04a_Det]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [MList04a_Det] 
end
GO
CREATE FUNCTION  [dbo].[MList04a_Det] (@P_ANO AS INTEGER, @p_date as smalldatetime)
RETURNS TABLE
AS RETURN(
SELECT 
	Cast(0 as bit) as ProcessFlag, 
	[Cover].[COVERNO], 
	[Acceptance].[AName], 
	[Acceptance].[CertificateNo], 
	[Cover].[CNO], 
	[Cover].[CStatus], 
	[Cover].[VSeqNo], 
	[Acceptance].[LANO], 
	[Acceptance].[ANO], 
	[Acceptance].[REGNO], 
	[Acceptance].[ADATE], 
	[Acceptance].[USERID], 
	[SysTab].[Currency], 
	[QPCalc].[TSI], 
	[QPCalc].[OurShare], 
	[QPCalc].[Gross], 
	[Acceptance].[ASTATUS], 
	[Acceptance].[ATYPE], 
	[Acceptance].[SDate], 
	[Acceptance].[EDate], 
	Year([RArrheader].[Rdate]) AS RYear
FROM 
	Acceptance, 
	Cover, 
	RArrHeader, 
	SysTab, 
	QMasterAcceptance_PCalc() AS QPCalc
WHERE 
	[Cover].[CNO]=[Acceptance].[CNO] 
	And [RArrHeader].[ANO]=[Acceptance].[ANO] 
	And [QPCalc].[ANO]=[Acceptance].[ANO] 
	And [Acceptance].[ANO]<>[Acceptance].[LANO] 
	And [Acceptance].[LANO]=@P_ANO
	And [Cover].[CStatus]='P' 
	And [Cover].[CDate]+[Cover].[Validation]<=@p_Date
)

GO

/****** Object:  UserDefinedFunction [dbo].[MList04b_DET]    Script Date: 12/21/2017 1:43:54 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO


iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MList04b_DET]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [MList04b_DET] 
end
GO
CREATE FUNCTION  [dbo].[MList04b_DET](@P_ANO AS INTEGER, @p_date as smalldatetime)
RETURNS TABLE
AS RETURN(
SELECT 
	Cast(0 as bit) as ProcessFlag, 
	[Cover].[COVERNO], 
	[Acceptance].[AName], 
	[Acceptance].[CertificateNo], 
	[Cover].[CNO], 
	[Cover].[CStatus], 
	[Cover].[VSeqNo], 
	[Acceptance].[LANO], 
	[Acceptance].[ANO], 
	[Acceptance].[REGNO], 
	[Acceptance].[ADATE], 
	[Acceptance].[USERID], 
	[SysTab].[Currency], 
	[QPCalc].[TSI], 
	[QPCalc].[OurShare], 
	[QPCalc].[Gross], 
	[Acceptance].[ASTATUS], 
	[Acceptance].[ATYPE], 
	[Acceptance].[SDate], 
	[Acceptance].[EDate], 
	Year([RArrheader].[Rdate]) AS RYear
FROM 
	Acceptance, 
	Cover, 
	RArrHeader, 
	SysTab, 
	QMasterAcceptance_PCalc() AS QPCalc
WHERE 
	[Cover].[CNO]=[Acceptance].[CNO] 
	And [RArrHeader].[ANO]=[Acceptance].[ANO] 
	And [QPCalc].[ANO]=[Acceptance].[ANO] 
	And [Acceptance].[ANO]<>[Acceptance].[LANO] 
	And [Acceptance].[LANO]=@P_ANO
	And [Acceptance].[AType]='N' 
	And [Acceptance].[AStatus]='W' 
	And [Cover].[CStatus]='A' 
	And [Cover].[CDate]+[Cover].[Validation]<=@p_Date
)



GO

/****** Object:  UserDefinedFunction [dbo].[MList04c_DET]    Script Date: 12/21/2017 1:43:54 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MList04c_DET]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [MList04c_DET] 
end
GO
CREATE FUNCTION  [dbo].[MList04c_DET](@P_ANO AS INTEGER, @p_date as smalldatetime)
RETURNS TABLE
AS RETURN(
SELECT 
	Cast(0 as bit) as ProcessFlag, 
	[Cover].[COVERNO], 
	[Acceptance].[AName], 
	[Acceptance].[CertificateNo], 
	[Cover].[CNO], 
	[Cover].[CStatus], 
	[Cover].[VSeqNo], 
	[Acceptance].[LANO], 
	[Acceptance].[ANO], 
	[Acceptance].[REGNO], 
	[Acceptance].[ADATE], 
	[Acceptance].[USERID], 
	[SysTab].[Currency], 
	[QPCalc].[TSI], 
	[QPCalc].[OurShare], 
	[QPCalc].[Gross], 
	[Acceptance].[ASTATUS], 
	[Acceptance].[ATYPE], 
	[Acceptance].[SDate], 
	[Acceptance].[EDate], 
	Year([RArrheader].[Rdate]) AS RYear
FROM 
	Acceptance, 
	Cover, 
	RArrHeader, 
	SysTab, 
	QMasterAcceptance_PCalc() AS QPCalc
WHERE 
	[Cover].[CNO]=[Acceptance].[CNO] 
	And [RArrHeader].[ANO]=[Acceptance].[ANO] 
	And [QPCalc].[ANO]=[Acceptance].[ANO] 
	And [Acceptance].[ANO]<>[Acceptance].[LANO] 
	And [Acceptance].[LANO]=@P_ANO
	And [Acceptance].[AType]='N' 
	And [Acceptance].[AStatus]='W' 
	And [Cover].[CStatus]='C' 
	And [Cover].[CDate]+[Cover].[Validation]=@p_Date
	And Cover.Validation<>0 
)


GO

/****** Object:  UserDefinedFunction [dbo].[MList05_DET]    Script Date: 12/21/2017 1:43:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MList05_DET]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [MList05_DET] 
end
GO
CREATE FUNCTION  [dbo].[MList05_DET] (@P_ANO AS INTEGER,@P_USERID as varchar(50)) 
RETURNS TABLE
AS RETURN(
SELECT 
	Cast(0 as bit) as ProcessFlag, 
	[Cover].[COVERNO], 
	[Acceptance].[AName], 
	[Acceptance].[CertificateNo], 
	[Cover].[CNO], 
	[Cover].[CStatus], 
	[Cover].[VSeqNo], 
	[Acceptance].[LANO], 
	[Acceptance].[ANO], 
	[Acceptance].[REGNO], 
	[Acceptance].[ADATE], 
	[Acceptance].[USERID], 
	[SysTab].[Currency], 
	[QPCalc].[TSI], 
	[QPCalc].[OurShare], 
	[QPCalc].[Gross], 
	[Acceptance].[ASTATUS], 
	[Acceptance].[ATYPE], 
	[Acceptance].[SDate], 
	[Acceptance].[EDate], 
	Year([RArrheader].[Rdate]) AS RYear
FROM 
	Acceptance, 
	Cover, 
	RArrHeader, 
	SysTab, 
	QMasterAcceptance_PCalc() AS QPCalc
WHERE 
	[Cover].[CNO]=[Acceptance].[CNO] 
	And [RArrHeader].[ANO]=[Acceptance].[ANO] 
	And [QPCalc].[ANO]=[Acceptance].[ANO] 
	And [Acceptance].[ANO]<>[Acceptance].[LANO] 
	And [Acceptance].[LANO]=@P_ANO
	And [Acceptance].[AType]='N' 
	And [Acceptance].[AStatus]='W' 
	And [Acceptance].[LUserID] Like @P_UserID
	And [Cover].[CStatus]='P'
)


GO

/****** Object:  UserDefinedFunction [dbo].[MList06_DET]    Script Date: 12/21/2017 1:43:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MList06_DET]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [MList06_DET] 
end
GO
CREATE FUNCTION  [dbo].[MList06_DET] (@P_ANO AS INTEGER,@P_USERID as varchar(50)) 
RETURNS TABLE
AS RETURN(
SELECT 
	Cast(0 as bit) as ProcessFlag, 
	[Cover].[COVERNO], 
	[Acceptance].[AName], 
	[Acceptance].[CertificateNo], 
	[Cover].[CNO], 
	[Cover].[CStatus], 
	[Cover].[VSeqNo], 
	[Acceptance].[LANO], 
	[Acceptance].[ANO], 
	[Acceptance].[REGNO], 
	[Acceptance].[ADATE], 
	[Acceptance].[USERID], 
	[SysTab].[Currency], 
	[QPCalc].[TSI], 
	[QPCalc].[OurShare], 
	[QPCalc].[Gross], 
	[Acceptance].[ASTATUS], 
	[Acceptance].[ATYPE], 
	[Acceptance].[SDate], 
	[Acceptance].[EDate], 
	Year([RArrheader].[Rdate]) AS RYear
FROM 
	Acceptance, 
	Cover, 
	RArrHeader, 
	SysTab, 
	QMasterAcceptance_PCalc() AS QPCalc
WHERE 
	[Cover].[CNO]=[Acceptance].[CNO] 
	And [RArrHeader].[ANO]=[Acceptance].[ANO] 
	And [QPCalc].[ANO]=[Acceptance].[ANO] 
	And [Acceptance].[ANO]<>[Acceptance].[LANO] 
	And [Acceptance].[LANO]=@P_ANO
	And [Acceptance].[AType]='N' 
	And [Acceptance].[AStatus]='W' 
	And [Cover].[CStatus]='V'
	And [Acceptance].[LUserID] Like @P_UserID 
)


GO

/****** Object:  UserDefinedFunction [dbo].[MList07_DET]    Script Date: 12/21/2017 1:43:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MList07_DET]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [MList07_DET] 
end
GO
CREATE FUNCTION  [dbo].[MList07_DET] (@P_ANO AS INTEGER,@P_USERID as varchar(50)) 
RETURNS TABLE
AS RETURN(
SELECT 
	Cast(0 as bit) as ProcessFlag, 
	[Cover].[COVERNO], 
	[Acceptance].[AName], 
	[Acceptance].[CertificateNo], 
	[Cover].[CNO], 
	[Cover].[CStatus], 
	[Cover].[VSeqNo], 
	[Acceptance].[LANO], 
	[Acceptance].[ANO], 
	[Acceptance].[REGNO], 
	[Acceptance].[ADATE], 
	[Acceptance].[USERID], 
	[SysTab].[Currency], 
	[QPCalc].[TSI], 
	[QPCalc].[OurShare], 
	[QPCalc].[Gross], 
	[Acceptance].[ASTATUS], 
	[Acceptance].[ATYPE], 
	[Acceptance].[SDate], 
	[Acceptance].[EDate], 
	Year([RArrheader].[Rdate]) AS RYear
FROM 
	Acceptance, 
	Cover, 
	RArrHeader, 
	SysTab, 
	QMasterAcceptance_PCalc() AS QPCalc
WHERE 
	[Cover].[CNO]=[Acceptance].[CNO] 
	And [RArrHeader].[ANO]=[Acceptance].[ANO] 
	And [QPCalc].[ANO]=[Acceptance].[ANO] 
	And [Acceptance].[ANO]<>[Acceptance].[LANO] 
	And [Acceptance].[LANO]=@P_ANO 
	And [Acceptance].[AType]='N' 
	And [Acceptance].[AStatus]='W' 
	And [Acceptance].[Renewal]>0
	And [Acceptance].[LUserID] Like @P_UserID  
)

GO

/****** Object:  UserDefinedFunction [dbo].[MList14_DET]    Script Date: 12/21/2017 1:43:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MList14_DET]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [MList14_DET] 
end
GO
CREATE FUNCTION  [dbo].[MList14_DET](@P_ANO AS INTEGER,@P_USERID as varchar(50)) 
RETURNS TABLE
AS RETURN(
SELECT 
	Cast(0 as bit) as ProcessFlag, 
	[Cover].[COVERNO], 
	[Acceptance].[AName], 
	[Acceptance].[CertificateNo], 
	[Cover].[CNO], 
	[Cover].[CStatus], 
	[Cover].[VSeqNo], 
	[Acceptance].[LANO], 
	[Acceptance].[ANO], 
	[Acceptance].[REGNO], 
	[Acceptance].[ADATE], 
	[Acceptance].[USERID], 
	[SysTab].[Currency], 
	[QPCalc].[TSI], 
	[QPCalc].[OurShare], 
	[QPCalc].[Gross], 
	[Acceptance].[ASTATUS], 
	[Acceptance].[ATYPE], 
	[Acceptance].[SDate], 
	[Acceptance].[EDate], 
	Year([RArrheader].[Rdate]) AS RYear
FROM 
	Acceptance, 
	Cover, 
	RArrHeader, 
	SysTab, 
	QMasterAcceptance_PCalc() AS QPCalc
WHERE 
	[Cover].[CNO]=[Acceptance].[CNO] 
	And [RArrHeader].[ANO]=[Acceptance].[ANO] 
	And [QPCalc].[ANO]=[Acceptance].[ANO] 
	And [Acceptance].[ANO]<>[Acceptance].[LANO] 
	And [Acceptance].[LANO]=@P_ANO
	And (([RArrHeader].[TreatyF]=1 And ([RArrheader].[TShare]<>100 or RArrHeader.RAmount<>0)) or RArrHeader.HoldF=1)
	And [Acceptance].[AStatus]='W'
	And [Acceptance].[LUserID] Like @P_UserID
)


GO

/****** Object:  UserDefinedFunction [dbo].[MList15_DET]    Script Date: 12/21/2017 1:43:54 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MList15_DET]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [MList15_DET] 
end
GO
CREATE FUNCTION  [dbo].[MList15_DET](@P_ANO AS INTEGER, @P_ID as varchar(10)) 
RETURNS TABLE
AS RETURN(
SELECT 
	Cast(0 as bit) as ProcessFlag, 
	[Cover].[COVERNO], 
	[Acceptance].[AName], 
	[Acceptance].[CertificateNo], 
	[Cover].[CNO], 
	[Cover].[CStatus], 
	[Cover].[VSeqNo], 
	[Acceptance].[LANO], 
	[Acceptance].[ANO], 
	[Acceptance].[REGNO], 
	[Acceptance].[ADATE], 
	[Acceptance].[USERID], 
	[SysTab].[Currency], 
	[QPCalc].[TSI], 
	[QPCalc].[OurShare], 
	[QPCalc].[Gross], 
	[Acceptance].[ASTATUS], 
	[Acceptance].[ATYPE], 
	[Acceptance].[SDate], 
	[Acceptance].[EDate], 
	Year([RArrheader].[Rdate]) AS RYear
FROM 
	Acceptance, 
	Payor,
	Cover, 
	RArrHeader, 
	SysTab, 
	QMasterAcceptance_PCalc() AS QPCalc
WHERE 
	[Cover].[CNO]=[Acceptance].[CNO] 
	And [RArrHeader].[ANO]=[Acceptance].[ANO] 
	And [QPCalc].[ANO]=[Acceptance].[ANO] 
	And [Acceptance].[ANO]<>[Acceptance].[LANO] 
	And [Acceptance].[LANO]=@P_ANO 
	And Payor.ANO=Acceptance.ANO
	And Payor.ID=@P_ID
	And [Acceptance].[AType]='N' 
	And [Acceptance].[AStatus]='W' 
	And [Cover].[CStatus]in ('R' ,'P','A')
)


GO

/****** Object:  UserDefinedFunction [dbo].[MList20_DET]    Script Date: 12/21/2017 1:43:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MList20_DET]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [MList20_DET] 
end
GO
CREATE FUNCTION  [dbo].[MList20_DET](@P_ANO AS INTEGER,@P_USERID as varchar(255),@P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_CStatus as varchar(1))
RETURNS Table
AS RETURN(
SELECT
 Cast(0 as bit) as ProcessFlag, 
 Cover.COVERNO,
 Cast(Acceptance.AName as varchar(128)) as AName,
 Acceptance.CertificateNo,
 Cover.CNO,
 Cover.CStatus,
 Cover.VSeqNo,
 Acceptance.LANO,
 Acceptance.ANO,
 Acceptance.REGNO,
 Acceptance.ADATE,
 Acceptance.USERID,
 SysTab.Currency,
 QPCalc.TSI,
 QPCalc.OurShare,
 QPCalc.Gross,
 Acceptance.ASTATUS,
 Acceptance.ATYPE,
 Acceptance.SDate,
 Acceptance.EDate,
 Year(RARRHEADER.RDATE) As RYear
From
 Acceptance
 Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), 
 Cover,
 RArrHeader,
 SysTab 
Where
 cover.CNO = acceptance.CNO
 And RArrHeader.ANO=Acceptance.ANO
 And QPCalc.ANO=Acceptance.ANO
 And Acceptance.ANO<>Acceptance.LANO
 And Acceptance.LANO=@P_ANO
 And Cover.LUserID Like @P_UserID
 And Cover.LDate Between @P_SDate and @P_EDate
 And (Cover.CStatus=@P_CStatus or @P_CStatus='') 
)


GO

/****** Object:  UserDefinedFunction [dbo].[MListQry_1]    Script Date: 12/21/2017 1:43:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MListQry_1]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [MListQry_1] 
end
GO
CREATE FUNCTION  [dbo].[MListQry_1](@value1 as varchar(255) ,@value2 as varchar(255) ,@value3 as varchar(255) ,@value4 as varchar(255) ,@value5 as varchar(255) ,@value6 as varchar(255) ,@Value7 as varchar(255) ,@value8 as varchar(255) ,@value9 as varchar(255),@Value10 as varchar(255), @Value11 as varchar(255))    
returns table    
AS return    
(    
SELECT   Cast(0 as bit) as ProcessFlag,      
  [Cover].[CoverNo] AS [Quotation No],     
  [Cover].[VSeqNo],     
  [Acceptance].[RegNo] AS [CI No],     
  [Acceptance].[PolicyNo] AS [Policy No],     
  [Acceptance].[CertificateNo] AS [Certificate No],     
  [Cover].[Insured],     
  [Profile].[Name] AS [Proposer],    
  [Cover].[CoverDate] AS [Cover Date],     
  [Cover].[Expdate] AS [Expiry Date],     
  [Acceptance].[PolicyDate] AS [Policy Date],     
  [Acceptance].[SDate] AS Start,     
  [Acceptance].[EDate] AS [End],     
  [Acceptance].[AType],     
  [Acceptance].[AStatus],     
  [Acceptance].[ANO],     
  [Acceptance].[LANO],    
  [Cover].[CStatus],    
  acceptance.ano as ano_info    
FROM  Cover, Acceptance, [Profile]    
WHERE  [Cover].[CNO]=[Acceptance].[CNO]     
  And Cover.PHOLDER=[Profile].[ID]    
  And (Acceptance.AName Like @Value1)  
  And ([Cover].[CoverNo] Like @Value2 Or ([Cover].[CoverNo] is null))     
  And (cover.coverdate=@Value3 Or (cover.coverdate IS NULL) Or cover.coverdate='' or @Value3='')    
  And (cover.expdate=@Value4 Or (cover.expdate IS NULL) Or cover.expdate='' or @Value4='')      
  And ([Acceptance].[PolicyNo] Like @Value5 Or ([Acceptance].[PolicyNo] is null))     
  And ([Acceptance].[CertificateNo] Like @Value6 Or ([Acceptance].[CertificateNo] is null))     
  And (acceptance.policydate=@Value7 Or (acceptance.policydate IS NULL) Or acceptance.policydate='' or @Value7='')    
  And ([Cover].[CStatus] Like @Value8)     
  And ([Acceptance].[RegNo] Like @Value9)     
  And ([Profile].[Name] like @Value10 or [Profile].[Name] is null)    
  and acceptance.toc like @Value11    
  and acceptance.ano = acceptance.lano    
  And [Cover].[ISType]<>'T'    
union     
SELECT   Cast(0 as bit) as ProcessFlag,     
  [Cover].[CoverNo] AS [Quotation No],     
  [Cover].[VSeqNo],     
  [Acceptance].[RegNo] AS [CI No],     
  [Acceptance].[PolicyNo] AS [Policy No],     
  [Acceptance].[CertificateNo] AS [Certificate No],     
  [Cover].[Insured],     
  [Profile].[Name] AS [Proposer],    
  [Cover].[CoverDate] AS [Cover Date],     
  [Cover].[Expdate] AS [Expiry Date],     
  [Acceptance].[PolicyDate] AS [Policy Date],     
  [Acceptance].[SDate] AS Start,     
  [Acceptance].[EDate] AS [End],     
  [Acceptance].[AType],     
  [Acceptance].[AStatus],     
  [Acceptance].[ANO],     
  [Acceptance].[LANO],    
  [Cover].[CStatus],    
  acceptance.ano as ano_info    
FROM  Cover, Acceptance, [Profile]    
WHERE  [Cover].[CNO]=[Acceptance].[CNO]     
  And Cover.PHOLDER=[Profile].[ID]    
  And (Acceptance.AName Like @Value1)    
  And ([Cover].[CoverNo] Like @Value2 Or ([Cover].[CoverNo] is null))     
  And (cover.coverdate=@Value3 Or (cover.coverdate IS NULL) Or cover.coverdate='' or @Value3='')    
  And (cover.expdate=@Value4 Or (cover.expdate IS NULL) Or cover.expdate='' or @Value4='')      
  And ([Acceptance].[PolicyNo] Like @Value5 Or ([Acceptance].[PolicyNo] is null))     
  And ([Acceptance].[CertificateNo] Like @Value6 Or ([Acceptance].[CertificateNo] is null))     
  And (acceptance.policydate=@Value7 Or (acceptance.policydate IS NULL) Or acceptance.policydate='' or @Value7='')    
  And ([Cover].[CStatus] Like @Value8)     
  And ([Acceptance].[RegNo] Like @Value9)     
  And ([Profile].[Name] like @Value10 or [Profile].[Name] is null)    
  and acceptance.toc like @Value11    
  and acceptance.lano = -1    
  And [Cover].[ISType]<>'T'    
union    
SELECT   Cast(0 as bit) as ProcessFlag,     
  [Cover].[CoverNo] AS [Quotation No],     
  [Cover].[VSeqNo],     
  [Acceptance_detail].[RegNo] AS [CI No],     
  [Acceptance_detail].[PolicyNo] AS [Policy No],     
  [Acceptance_detail].[CertificateNo] AS [Certificate No],     
  [Cover].[Insured],     
  [Profile].[Name] AS [Proposer],    
  [Cover].[CoverDate] AS [Cover Date],     
  [Cover].[Expdate] AS [Expiry Date],     
  [Acceptance_detail].[PolicyDate] AS [Policy Date],     
  [Acceptance_detail].[SDate] AS Start,     
  [Acceptance_detail].[EDate] AS [End],     
  [Acceptance_detail].[AType],     
  [Acceptance_detail].[AStatus],     
  [Acceptance_detail].[ANO],     
  [acceptance_detail].[LANO],    
  [Cover].[CStatus],    
  acceptance_detail.ano as ano_info    
FROM  Cover, Acceptance, [Profile], acceptance as acceptance_detail    
WHERE  [Cover].[CNO]=[Acceptance_detail].[CNO]     
  And Cover.PHOLDER=[Profile].[ID]    
  and acceptance.ano = acceptance_detail.lano    
  And (Acceptance_detail.AName Like @Value1)  
  And ([Cover].[CoverNo] Like @Value2 Or ([Cover].[CoverNo] is null))     
  And (cover.coverdate=@Value3 Or (cover.coverdate IS NULL) Or cover.coverdate='' or @Value3='')    
  And (cover.expdate=@Value4 Or (cover.expdate IS NULL) Or cover.expdate='' or @Value4='')      
  And ([Acceptance_detail].[PolicyNo] Like @Value5 Or ([Acceptance_detail].[PolicyNo] is null))     
  And ([Acceptance_detail].[CertificateNo] Like @Value6 Or ([Acceptance_detail].[CertificateNo] is null))     
  And (acceptance_detail.policydate=@Value7 Or (acceptance_detail.policydate IS NULL) Or acceptance_detail.policydate='' or @Value7='')    
  And ([Cover].[CStatus] Like @Value8)     
  And ([Acceptance_detail].[RegNo] Like @Value9)     
  And ([Profile].[Name] like @Value10 or [Profile].[Name] is null)    
  and acceptance.toc like @Value11    
  and acceptance_detail.ano <> acceptance_detail.lano and acceptance_detail.lano <> -1    
  And [Cover].[ISType]<>'T'    
)    


GO

/****** Object:  UserDefinedFunction [dbo].[MListQry_1b]    Script Date: 12/21/2017 1:43:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MListQry_1b]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [MListQry_1b] 
end
GO
CREATE FUNCTION  [dbo].[MListQry_1b](@value1 as varchar(255) ,@value2 as varchar(255) ,@value3 as varchar(255) ,@value4 as varchar(255) ,@value5 as varchar(255) ,@value6 as varchar(255) ,@Value7 as varchar(255) ,@value8 as varchar(255) ,@value9 as varchar(255),@Value10 as varchar(255), @Value11 as varchar(255))    
returns table    
AS return    
(    
SELECT    Cast(0 as bit) as ProcessFlag,     
  [Cover].[CoverNo] AS [Quotation No],     
  [Cover].[VSeqNo],     
  [Acceptance].[RegNo] AS [CI No],     
  [Acceptance].[PolicyNo] AS [Policy No],     
  [Acceptance].[CertificateNo] AS [Certificate No],     
  [Cover].[Insured],     
  [Profile].[Name] AS [Proposer],    
  [Cover].[CoverDate] AS [Cover Date],     
  [Cover].[Expdate] AS [Expiry Date],     
  [Acceptance].[PolicyDate] AS [Policy Date],     
  [Acceptance].[SDate] AS Start,     
  [Acceptance].[EDate] AS [End],     
  [Acceptance].[AType],     
  [Acceptance].[AStatus],     
  [Acceptance].[ANO],     
  [Acceptance].[LANO],    
  [Cover].[CStatus]    
FROM  Cover, Acceptance, [Profile]    
WHERE  [Cover].[CNO]=[Acceptance].[CNO]     
  And Cover.PHOLDER=[Profile].[ID]    
  And (Acceptance.AName Like @Value1)  
  And ([Cover].[CoverNo] Like @Value2 Or ([Cover].[CoverNo] is null))     
  And (cover.coverdate=@Value3 Or cover.coverdate is NULL or @Value3='')    
  And (cover.expdate=@Value4 Or cover.expdate is NULL or @Value4='')      
  And ([Acceptance].[PolicyNo] Like @Value5 Or ([Acceptance].[PolicyNo] is null))     
  And ([Acceptance].[CertificateNo] Like @Value6 Or ([Acceptance].[CertificateNo] is null))     
  And (acceptance.policydate=@Value7 Or acceptance.policydate is NULL or @Value7='')    
  And ([Cover].[CStatus] Like @Value8)     
  And ([Acceptance].[RegNo] Like @Value9)     
  And ([Profile].[Name] like @Value10 or [Profile].[Name] is null)    
  and Acceptance.toc like @Value11    
  And ([Acceptance].[ANO] = [Acceptance].[LANO] Or [Acceptance].[LANO] = -1)     
  And [Cover].[ISType]<>'T'    
)   


GO

/****** Object:  UserDefinedFunction [dbo].[MListQry_3b]    Script Date: 12/21/2017 1:43:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MListQry_3b]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [MListQry_3b] 
end
GO
CREATE FUNCTION  [dbo].[MListQry_3b] (@value1 as varchar(255) ,@value2 as varchar(255) ,@value3 as varchar(255) ,@value4 as varchar(255) ,@value5 as varchar(255) ,@value6 as varchar(255) ,@value7 as varchar(255) ,@value8 as varchar(255) ,@value9 as varchar(255),@Value10 as varchar(255), @Value11 as varchar(255), @Value12 as varchar(255))   
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
QPCalc.TSI,   
QPCalc.OurShare,   
QPCalc.Gross,   
Acceptance.ASTATUS,   
Acceptance.ATYPE,   
Acceptance.SDate,   
Acceptance.EDate,   
Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear,   
Cover.ISType,   
Acceptance.Renewal,   
Acceptance.ESeqNo,   
acceptance.PolicyNo   
FROM  Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)   
Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab, Profile   
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
And (Acceptance.ANO=Acceptance.lANO Or Acceptance.lANO=-1)   
And Cover.ISType<>'T'   
) 


GO

/****** Object:  UserDefinedFunction [dbo].[MListSR_Det]    Script Date: 12/21/2017 1:43:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MListSR_Det]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [MListSR_Det] 
end
GO
CREATE FUNCTION  [dbo].[MListSR_Det]
 (@P_ANO as int, @P_ID as int)    
RETURNS Table    
AS RETURN(    
          
SELECT    
 Cast(0 as bit) as ProcessFlag,     
 Cover.COVERNO,    
 Cast(Acceptance.AName as varchar(128)) as AName,    
 Acceptance.CertificateNo,    
 Cover.CNO,    
 Cover.CStatus,    
 Cover.VSeqNo,    
 Acceptance.LANO,    
 Acceptance.ANO,    
 Acceptance.REGNO,    
 Acceptance.ADATE,    
 Acceptance.USERID,    
 SysTab.Currency,    
 QPCalc.TSI,    
 QPCalc.OurShare,    
 QPCalc.Gross,    
 Acceptance.ASTATUS,    
 Acceptance.ATYPE,    
 Acceptance.SDate,    
 Acceptance.EDate,    
 Year(RARRHEADER.RDATE) As RYear    
From    
 Acceptance,    
 RArrHeader,    
 Cover,    
 SysTab,    
 QMasterAcceptance_PCalc() AS QPCalc,    
 TOC,    
 SysRequest    
Where    
 cover.CNO = acceptance.CNO    
 And RArrHeader.ANO=Acceptance.ANO    
 And QPCalc.ANO=Acceptance.ANO    
 And Acceptance.ANO<>Acceptance.LANO    
 And Acceptance.LANO=@P_ANO    
 And SysRequest.ID=@P_ID    
 And SysRequest.Param2 in ('MAR','UND','CLM')    
 And SysRequest.Param3=Acceptance.ANO    
 And TOC.TOC=Acceptance.TOC)
 

GO



/****** Object:  UserDefinedFunction [dbo].[ListQry_1]    Script Date: 12/21/2017 1:43:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ListQry_1]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [ListQry_1] 
end
GO
CREATE FUNCTION  [dbo].[ListQry_1]
 (@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255), @Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255),  @Value10 as varchar(255),@Value11 as varchar(255), @value12 as varchar(255), @value13 as varchar(255), @Value14 as varchar(255),@Value15 as varchar(255),@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255))   
RETURNS Table   
AS RETURN   
(   
SELECT Cast(0 as bit) as ProcessFlag,   
Cover.CoverNo as [Quotation No],   
Acceptance.RegNo as [CI No],   
Acceptance.PolicyNo as [Policy No],   
Acceptance.CertificateNo as [Certificate No],   
Cast(Acceptance.AName as varchar(128)) as Insured,   
Profile.Name as [Policy Holder],   
Cover.CoverDate as [Cover Date],   
Cover.Expdate as [Expiry Date],   
Acceptance.PolicyDate as [Issued Date],   
Acceptance.SDate as Start,   
Acceptance.EDate as [End],   
Acceptance.AStatus,   
Acceptance.AType,   
Acceptance.ANO,   
Acceptance.LANO,   
Acceptance.RefNo,   
Cover.ProformaF,   
cover.CNO   
From cover, acceptance, Profile   
Where cover.CNO = acceptance.CNO And cover.PHolder = Profile.ID   
And (Acceptance.AName Like @Value1)   
And (Cover.CoverNo Like @Value2 Or Cover.CoverNo is null)   
and (Cover.CoverDate = @Value3 Or Cover.CoverDate is null or @Value3 = '')   
And (Cover.ExpDate = @Value4 Or Cover.ExpDate is null or @Value4 = '')   
And (Acceptance.PolicyNo Like @Value5 Or Acceptance.PolicyNo is null)   
And (Acceptance.CertificateNo Like @Value6 Or Acceptance.CertificateNo is null)   
And (Acceptance.PolicyDate = @Value7 Or Acceptance.PolicyDate is null or @Value7 = '' or Acceptance.PolicyDate Between @Value7 and @Value16)   
And (Acceptance.RegDate = @Value17 Or Acceptance.RegDate is null or @Value17 = '' or Acceptance.RegDate Between @Value17 and @Value18)   
And Acceptance.AType Like @Value8   
And Acceptance.AStatus Like @Value9   
And Acceptance.RegNo Like @Value10   
And (Profile.Name Like @Value11 or Profile.Name is null)   
and Acceptance.toc like @Value12   
and (Acceptance.Matters=@Value14 or @Value14='')   
and (Acceptance.Refno like @Value13 or Acceptance.Refno is null)   
And (Cover.ISType<>'T' or Cover.ProformaF=1)   
)   
   

GO

/****** Object:  UserDefinedFunction [dbo].[ListQry_1_a]    Script Date: 12/21/2017 1:43:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ListQry_1_a]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [ListQry_1_a] 
end
GO
CREATE FUNCTION  [dbo].[ListQry_1_a]
 (@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255), @Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),@Value11 as varchar(255), @value12 as varchar(255), @value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255))  
RETURNS Table  
AS RETURN  
(  
SELECT Cast(0 as bit) as ProcessFlag,   
  [q].[Quotation No],  
  [q]. [CI No],  
  [q].[Policy No],  
  [q].[Certificate No],  
  [q].[Insured],  
  [q].[Policy Holder],  
  [q].[Cover Date],  
  [q].[Expiry Date],  
  [q].[Issued Date],  
  [q].[Start],  
  [q].[End],  
  [q].[AStatus],  
  [q].[AType],  
  [q].[ANO],  
  [q].[LANO],  
  q.RefNo,  
  q.ProformaF,  
  q.cno,  
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
  a.VALUEID15 , a.VALUEDESC15  
        
FROM  ListQry_1 (@Value1, @Value2, @Value3, @Value4, @Value5, @Value6, @Value7, @Value8, @Value9, @Value10,@Value11, @value12, @value13, @Value14,@Value15,@Value16,@Value17,@Value18) as q, ainfo as a  
Where [q].[ANO] = [a].[ANO]  
)  


GO

/****** Object:  UserDefinedFunction [dbo].[ListQry_1b]    Script Date: 12/21/2017 1:43:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ListQry_1b]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [ListQry_1b] 
end
GO
CREATE FUNCTION  [dbo].[ListQry_1b]
(@Value1 as varchar(255), @Value2 as   varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as  varchar(255), @Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),@Value11 as varchar(255), @value12 as varchar(255), @value13 as varchar(255), @Value14 as varchar(255),@Value15 as varchar(255),@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255))   
RETURNS Table   
AS RETURN   
(   
SELECT Cast(0 as bit) as ProcessFlag,   
Cover.CoverNo as [Quotation No],   
Acceptance.RegNo as [CI No],   
Acceptance.PolicyNo as [Policy No],   
Acceptance.CertificateNo as [Certificate No],   
Cast(Acceptance.AName as varchar(128)) as Insured,   
Profile.Name as [Policy Holder],   
Cover.CoverDate as [Cover Date],   
Cover.Expdate as [Expiry Date],   
Acceptance.PolicyDate as [Issued Date],   
Acceptance.SDate as Start,   
Acceptance.EDate as [End],   
Acceptance.AStatus,   
Acceptance.AType,   
Acceptance.ANO,   
Acceptance.LANO,   
Acceptance.RefNo,   
Cover.ProformaF,   
acceptance.CNO   
From cover, acceptance, Profile   
Where cover.CNO = acceptance.CNO And cover.PHolder = Profile.ID   
And (Acceptance.AName Like @Value1)   
And (Cover.CoverNo Like @Value2 Or Cover.CoverNo is null)   
and (Cover.CoverDate = @Value3 Or Cover.CoverDate is null or @Value3 = '')   
And (Cover.ExpDate = @Value4 Or Cover.ExpDate is null or @Value4 = '')   
And (Acceptance.PolicyNo Like @Value5 Or Acceptance.PolicyNo is null)   
And (Acceptance.CertificateNo Like @Value6 Or Acceptance.CertificateNo is null)   
And (Acceptance.PolicyDate = @Value7 Or Acceptance.PolicyDate is null or @Value7 = '' or Acceptance.PolicyDate Between @Value7 and @Value16)   
And (Acceptance.RegDate = @Value17 Or Acceptance.RegDate is null or @Value17 = '' or Acceptance.RegDate Between @Value17 and @Value18)   
And Acceptance.AType Like @Value8   
And Acceptance.AStatus Like @Value9   
And Acceptance.RegNo Like @Value10   
And (Profile.Name Like @Value11 or Profile.Name is null)   
and acceptance.toc like @value12   
and (acceptance.refno like @value13 or acceptance.refno is null)   
and (Acceptance.Matters=@Value14 or @Value14='')   
and (acceptance.ano = acceptance.lano or acceptance.lano = -1)   
And (Cover.ISType<>'T' or Cover.ProformaF=1)   
)  


GO

/****** Object:  UserDefinedFunction [dbo].[ListQry_1b_a]    Script Date: 12/21/2017 1:43:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ListQry_1b_a]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [ListQry_1b_a] 
end
GO
CREATE FUNCTION  [dbo].[ListQry_1b_a]
 (@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255), @Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),@Value11 as varchar(255), @value12 as varchar(255), @value13 as varchar(255), @Value14 as varchar(255),@Value15 as varchar(255),@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255))  
RETURNS Table  
AS RETURN  
(  
SELECT Cast(0 as bit) as ProcessFlag,   
  [q].[Quotation No],  
  [q]. [CI No],  
  [q].[Policy No],  
  [q].[Certificate No],  
  [q].[Insured],  
  [q].[Policy Holder],  
  [q].[Cover Date],  
  [q].[Expiry Date],  
  [q].[Issued Date],  
  [q].[Start],  
  [q].[End],  
  [q].[AStatus],  
  [q].[AType],  
  [q].[ANO],  
  [q].[LANO],  
  q.RefNo,  
  q.ProformaF,  
  q.cno,  
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
  a.VALUEID15 , a.VALUEDESC15  
        
FROM  ListQry_1b (@Value1, @Value2, @Value3, @Value4, @Value5, @Value6, @Value7, @Value8, @Value9, @Value10,@Value11, @value12, @value13, @Value14,@Value15,@Value16,@Value17,@Value18) as q, ainfo as a  
Where [q].[ANO] = [a].[ANO]  
)  


GO

/****** Object:  UserDefinedFunction [dbo].[ListDet05_a]    Script Date: 12/21/2017 1:43:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ListDet05_a]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [ListDet05_a] 
end
GO
CREATE FUNCTION  [dbo].[ListDet05_a]
(@P_ANO as integer,     
@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255),     
@Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),    
@Value11 as varchar(255),@Value12 as varchar(255), @Value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),    
@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255),@Value19 as varchar(255),@Value20 as varchar(255),@Value21 as varchar(255), @Value22 as varchar(255), @Value23 as varchar(255)    
)          
RETURNS Table        
AS RETURN        
(        
 SELECT Cast(0 as bit) as ProcessFlag,        
 Acceptance.CertificateNo,        
 Acceptance.ESeqNo,        
 Cast(Acceptance.AName as varchar(128)) as AName,        
 Acceptance.ANO,        
 Acceptance.REGNO,        
 Acceptance.ADATE,        
 Acceptance.LUSERID as UserID,        
 SysTab.Currency,        
 QPCalc.TSI,        
 QPCalc.OurShare,        
 QPCalc.Gross,        
 Acceptance.ASTATUS,        
 Acceptance.ATYPE,        
 Acceptance.SDate,        
 Acceptance.EDate,        
 Year(Acceptance.SDate) AS RYear,        
 Acceptance.ValueID,        
 dbo.get_objectInfo(Acceptance.ANO) as ValueDesc        
From        
 Acceptance,        
 Cover,        
 SysTab,        
 QMasterAcceptance_PCalc() AS QPCalc,        
 Profile        
Where        
 cover.CNO = acceptance.CNO        
 And QPCalc.ANO=Acceptance.ANO        
 And Acceptance.ANO<>Acceptance.LANO        
 And Acceptance.LANO=@P_ANO        
 And Cover.PHOLDER=Profile.ID        
 And ((Cover.Insured Like @Value1 Or Cover.Insured is null) or (Acceptance.AName Like @Value1 Or Acceptance.AName is null))        
 And (Cover.CoverNo Like @Value2 Or Cover.CoverNo is null)        
 and (Cover.CoverDate = @Value3 Or Cover.CoverDate is null or @Value7 = '')        
 And (Cover.ExpDate = @Value4 Or Cover.ExpDate is null or @Value7 = '')        
 And (Acceptance.PolicyNo Like @Value5 Or Acceptance.PolicyNo is null)        
 And (Acceptance.CertificateNo Like @Value6 Or Acceptance.CertificateNo is null)        
 And (Acceptance.PolicyDate = @Value7 Or Acceptance.PolicyDate is null or @Value7 = '' or Acceptance.PolicyDate Between @Value7 and @Value16)        
 And (Acceptance.RegDate = @Value17 Or Acceptance.RegDate is null or @Value17 = '' or Acceptance.RegDate Between @Value17 and @Value18)        
 And Acceptance.AType Like @Value8        
 And Acceptance.AStatus Like @Value9        
 And Acceptance.RegNo Like @Value10        
 And Profile.Name Like @Value11       
 and acceptance.toc like @Value12        
 and (acceptance.refno like @Value13 or acceptance.refno is null)        
 and (Acceptance.Matters=@Value14 or @Value14='')        
 And Cover.ISType<>'T'        
 And (@Value15='%' or @Value15='' or 1 in (SELECT top 1 1 from Service Where ((Service.ANO=Acceptance.pANO and Service.ANO<>-1) or Service.ANO=Acceptance.ANO) and SStatus<>'R' and ServiceNo Like @Value15))        
 And (Acceptance.BatchNo Like @Value19 or (Acceptance.BatchNo is null and @Value19='%'))     
 And ((Acceptance.BackDatedF=1 and @Value20='1') or @Value20='')    
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')    
 And (@Value23<>'1' or (@Value23='1' and Exists (Select ANO from PPrintLog Where PPrintLog.ANO=Acceptance.ANO)))            
)        
  


GO

/****** Object:  UserDefinedFunction [dbo].[ListDet05_b]    Script Date: 12/21/2017 1:43:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ListDet05_b]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [ListDet05_b] 
end
GO
CREATE FUNCTION  [dbo].[ListDet05_b]
(@P_ANO as integer,     
@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255),     
@Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),    
@Value11 as varchar(255),@Value12 as varchar(255), @Value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),    
@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255),@Value19 as varchar(255),@Value20 as varchar(255),@Value21 as varchar(255), @Value22 as varchar(255), @Value23 as varchar(255)    
)          
RETURNS Table      
AS RETURN      
(      
SELECT Cast(0 as bit) as ProcessFlag,      
 q.[CertificateNo],      
 q.ESeqNo,      
 q.[AName],      
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
 q.ValueID,       
 q.ValueDesc,      
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
 a.VALUEID15 , a.VALUEDESC15      
FROM ListDet05_a (@P_ANO, @Value1, @Value2, @Value3, @Value4, @Value5, @Value6, @Value7, @Value8, @Value9, @Value10,@Value11, @Value12, @Value13,@Value14,@Value15,@Value16,@Value17,@Value18,@Value19, @Value20, @Value21, @Value22, @Value23) as q, ainfo as a      
Where q.ANO = a.ANO      
)      


GO

/****** Object:  UserDefinedFunction [dbo].[ListQry_3]    Script Date: 12/21/2017 1:43:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ListQry_3]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [ListQry_3] 
end
GO
CREATE FUNCTION  [dbo].[ListQry_3]
 (        
@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255),         
@Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),        
@Value11 as varchar(255),@Value12 as varchar(255), @Value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),        
@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255),@Value19 as varchar(255),@Value20 as varchar(255),@Value21 as varchar(255), @Value22 as varchar(255), @Value23 as varchar(255), @Value24 as varchar(255)        
)              
RETURNS Table              
AS RETURN              
(              
SELECT     
 Cover.COVERNO,              
 Cast(Acceptance.AName as varchar(128)) as Insured,              
 Cover.CNO,              
 Cover.CStatus,              
 Acceptance.lANO,              
 Acceptance.ANO,              
 Acceptance.REGNO,              
 Acceptance.ADATE,              
 Acceptance.LUSERID as USERID,              
 SysTab.Currency,              
 Acceptance.ASTATUS,              
 Acceptance.ATYPE,              
 Acceptance.SDate,              
 Acceptance.EDate,              
 Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear,              
 Cover.ISType,              
 Acceptance.Renewal,              
 Acceptance.ESeqNo,              
 Acceptance.PolicyNo,              
 Acceptance.CertificateNo,              
 Acceptance.RefNo,              
 Cover.ProformaF,              
 Acceptance.ANO as ANO_INFO   
FROM  Cover, Acceptance   
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO), Profile, SysTab  
WHERE  Cover.CNO=Acceptance.CNO     
 and cover.PHolder = Profile.ID              
 And (@Value1='%' or Acceptance.AName Like @Value1)             
 And (@Value2='%' or Cover.CoverNo Like @Value2)              
 And (Cover.CoverDate = @Value3 or @Value3='')              
 And (Cover.ExpDate = @Value4 or @Value4='')              
 And (@Value5='%' or Acceptance.PolicyNo Like @Value5)              
 And (@Value6='%' or Acceptance.CertificateNo Like @Value6)              
 And (Acceptance.PolicyDate = @Value7 or @Value7='' or Acceptance.PolicyDate Between @Value7 and @Value16)              
 And (Acceptance.RegDate = @Value17 or @Value17='' or Acceptance.RegDate Between @Value17 and @Value18)              
 And Acceptance.AType Like @Value8              
 And Acceptance.AStatus Like @Value9              
 And (@Value10='%' or Acceptance.RegNo Like @Value10)  
 And (@Value11='%' or Profile.Name Like @Value11)             
 and (@Value12='%' or Acceptance.toc like @Value12)              
 and (@Value13='%' or acceptance.refno like @Value13)              
 and (Acceptance.ano = acceptance.lano or Acceptance.LANO=-1)              
 and (Acceptance.Matters=@Value14 or @Value14='')              
 And (Cover.ISType<>'T' or Cover.ProformaF=1)              
 And (Acceptance.BatchNo Like @Value19)         
 And ((Acceptance.BackDatedF=1 and @Value20='1') or @Value20='')        
 And (@Value21<>'1' or (@Value21='1' and Exists (Select CAcceptance.CANO from Acceptance CAcceptance Where CAcceptance.CANO=Acceptance.ANO)))            
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')        
 And (@Value23<>'1' or (@Value23='1' and Exists (Select ANO from PPrintLog Where PPrintLog.ANO=Acceptance.ANO)))            
 And (@Value24='%' or Acceptance.ASource Like @Value24)
        
Union              
        
SELECT     
 Cover.COVERNO,              
 Cast(Acceptance.AName as varchar(128)) as Insured,              
 Cover.CNO,              
 Cover.CStatus,              
 Acceptance.lANO,              
 Acceptance.ANO,              
 Acceptance.REGNO,              
 Acceptance.ADATE,              
 Acceptance.LUSERID as USERID,              
 SysTab.Currency,              
 Acceptance.ASTATUS,              
 Acceptance.ATYPE,              
 Acceptance.SDate,   
 Acceptance.EDate,              
 Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear,              
 Cover.ISType,              
 Acceptance.Renewal,              
 Acceptance.ESeqNo,              
 Acceptance.PolicyNo,              
 Acceptance.CertificateNo,              
 Acceptance.RefNo,              
 Cover.ProformaF,              
 acceptance_detail.ANO as ANO_INFO  
FROM  Cover, Acceptance   
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO), Profile, acceptance as acceptance_detail, SysTab  
Where cover.CNO = acceptance.CNO     
 And cover.PHolder = Profile.ID              
 and acceptance.ano = acceptance_detail.lano              
 And (@Value1='%' or Acceptance_Detail.AName Like @Value1)            
 And (@Value2='%' or Cover.CoverNo Like @Value2)             
 and (Cover.CoverDate = @Value3 or @Value3='')              
 And (Cover.ExpDate = @Value4 or @Value4='')              
 And (@Value5='%' or Acceptance_Detail.PolicyNo Like @Value5)              
 And (@Value6='%' or Acceptance_Detail.CertificateNo Like @Value6)              
 And (Acceptance_Detail.PolicyDate = @Value7 or @Value7='' or Acceptance_Detail.PolicyDate Between @Value7 and @Value16)              
 And (Acceptance_Detail.RegDate = @Value17 or @Value17='' or Acceptance_Detail.RegDate Between @Value17 and @Value18)              
 And Acceptance_Detail.AType Like @Value8              
 And Acceptance_Detail.AStatus Like @Value9              
 And (@Value10='%' or Acceptance_Detail.RegNo Like @Value10)  
 And (@Value11='%' or Profile.Name Like @Value11)  
 and (@Value12='%' or Acceptance.toc like @Value12)  
 and (@Value13='%' or acceptance_detail.refno like @Value13)              
 and (Acceptance_detail.Matters=@Value14 or @Value14='')              
 and acceptance_detail.ano <> acceptance_detail.lano and acceptance_detail.lano <> -1              
 And (Cover.ISType<>'T' or Cover.ProformaF=1)              
 And (Acceptance_Detail.BatchNo Like @Value19)         
 And ((Acceptance_Detail.BackDatedF=1 and @Value20='1') or @Value20='')      
 And (@Value21<>'1' or (@Value21='1' and Exists (Select CAcceptance_Detail.CANO from Acceptance CAcceptance_Detail Where CAcceptance_Detail.CANO=Acceptance_Detail.ANO)))              
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')        
 And (@Value23<>'1' or (@Value23='1' and Exists (Select ANO from PPrintLog Where PPrintLog.ANO=Acceptance_Detail.ANO)))            
 And (@Value24='%' or Acceptance_Detail.ASource Like @Value24)
         
 Union        
         
 SELECT     
 CCover.COVERNO,              
 Cast(CAcceptance.AName as varchar(128)) as Insured,              
 CCover.CNO,              
 CCover.CStatus,              
 CAcceptance.lANO,              
 CAcceptance.ANO,              
 CAcceptance.REGNO,              
 CAcceptance.ADATE,              
 CAcceptance.LUSERID as USERID,              
 SysTab.Currency,              
 CAcceptance.ASTATUS,              
 CAcceptance.ATYPE,              
 CAcceptance.SDate,              
 CAcceptance.EDate,              
 Year(Coalesce(CRArrHeader.RDate,CAcceptance.SDate)) AS RYear,              
 CCover.ISType,              
 CAcceptance.Renewal,              
 CAcceptance.ESeqNo,              
 CAcceptance.PolicyNo,              
 CAcceptance.CertificateNo,              
 CAcceptance.RefNo,              
 CCover.ProformaF,              
 CAcceptance.ANO as ANO_INFO  
FROM  Cover, Acceptance, Profile, SysTab, Cover CCover, Acceptance CAcceptance   
left Join RArrHeader CRArrHeader on (CRArrHeader.ANO=CAcceptance.ANO)   
WHERE @Value21='1' and CAcceptance.CANO=Acceptance.ANO and CCover.CNO=CAcceptance.CNO          
 And (CAcceptance.ano = Cacceptance.lano or CAcceptance.LANO=-1)              
 and Cover.CNO=Acceptance.CNO and cover.PHolder = Profile.ID              
 And (@Value1='%' or Acceptance.AName Like @Value1)             
 And (@Value2='%' or Cover.CoverNo Like @Value2)              
 And (Cover.CoverDate = @Value3 or @Value3='')              
 And (Cover.ExpDate = @Value4 or @Value4='')              
 And (@Value5='%' or Acceptance.PolicyNo Like @Value5)              
 And (@Value6='%' or Acceptance.CertificateNo Like @Value6)              
 And (Acceptance.PolicyDate = @Value7 or @Value7='' or Acceptance.PolicyDate Between @Value7 and @Value16)              
 And (Acceptance.RegDate = @Value17 or @Value17='' or Acceptance.RegDate Between @Value17 and @Value18)              
 And Acceptance.AType Like @Value8              
 And Acceptance.AStatus Like @Value9              
 And (@Value10='%' or Acceptance.RegNo Like @Value10)  
 And (@Value11='%' or Profile.Name Like @Value11)  
 and (@Value12='%' or Acceptance.toc like @Value12)  
 and (@Value13='%' or acceptance.refno like @Value13)              
 and (Acceptance.ano = acceptance.lano or Acceptance.LANO=-1)              
 and (Acceptance.Matters=@Value14 or @Value14='')              
 And (Cover.ISType<>'T' or Cover.ProformaF=1)              
 And (Acceptance.BatchNo Like @Value19)         
 And ((Acceptance.BackDatedF=1 and @Value20='1') or @Value20='')        
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')        
 And (@Value23<>'1' or (@Value23='1' and Exists (Select ANO from PPrintLog Where PPrintLog.ANO=Acceptance.ANO)))            
 And (@Value24='%' or Acceptance.ASource Like @Value24)
        
Union              
        
SELECT     
 CCover.COVERNO,              
 Cast(CAcceptance.AName as varchar(128)) as Insured,              
 CCover.CNO,              
 CCover.CStatus,              
 CAcceptance.lANO,              
 CAcceptance.ANO,              
 CAcceptance.REGNO,              
 CAcceptance.ADATE,              
 CAcceptance.LUSERID as USERID,              
 SysTab.Currency,              
 CAcceptance.ASTATUS,              
 CAcceptance.ATYPE,              
 CAcceptance.SDate,              
 CAcceptance.EDate,              
 Year(Coalesce(CRArrHeader.RDate,CAcceptance.SDate)) AS RYear,              
 CCover.ISType,              
 CAcceptance.Renewal,              
 CAcceptance.ESeqNo,              
 CAcceptance.PolicyNo,              
 CAcceptance.CertificateNo,              
 CAcceptance.RefNo,              
 CCover.ProformaF,              
 Cacceptance_detail.ANO as ANO_INFO  
FROM  Cover, Acceptance, Profile, systab, acceptance as acceptance_detail, Acceptance as Cacceptance_detail, Cover CCover, Acceptance CAcceptance   
left Join RArrHeader CRArrheader on (CRArrHeader.ANO=CAcceptance.ANO)   
Where  @Value21='1' and CAcceptance_Detail.CANO=Acceptance_Detail.ANO and CAcceptance.ANO=CAcceptance_Detail.LANO and CCover.CNO=CAcceptance.CNO        
 and cover.CNO = acceptance.CNO And cover.PHolder = Profile.ID               
 and acceptance.ano = acceptance_detail.lano              
 And (@Value1='%' or Acceptance_Detail.AName Like @Value1)            
 And (@Value2='%' or Cover.CoverNo Like @Value2)             
 and (Cover.CoverDate = @Value3 or @Value3='')              
 And (Cover.ExpDate = @Value4 or @Value4='')              
 And (@Value5='%' or Acceptance_Detail.PolicyNo Like @Value5)              
 And (@Value6='%' or Acceptance_Detail.CertificateNo Like @Value6)              
 And (Acceptance_Detail.PolicyDate = @Value7 or @Value7='' or Acceptance_Detail.PolicyDate Between @Value7 and @Value16)              
 And (Acceptance_Detail.RegDate = @Value17 or @Value17='' or Acceptance_Detail.RegDate Between @Value17 and @Value18)              
 And Acceptance_Detail.AType Like @Value8              
 And Acceptance_Detail.AStatus Like @Value9              
 And (@Value10='%' or Acceptance_Detail.RegNo Like @Value10)  
 And (@Value11='%' or Profile.Name Like @Value11)  
 and (@Value12='%' or Acceptance.toc like @Value12)  
 and (@Value13='%' or acceptance_detail.refno like @Value13)              
 and (Acceptance_detail.Matters=@Value14 or @Value14='')              
 and acceptance_detail.ano <> acceptance_detail.lano and acceptance_detail.lano <> -1              
 And (Cover.ISType<>'T' or Cover.ProformaF=1)              
 And (Acceptance_Detail.BatchNo Like @Value19)         
 And ((Acceptance_Detail.BackDatedF=1 and @Value20='1') or @Value20='')         
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')        
 And (@Value23<>'1' or (@Value23='1' and Exists (Select ANO from PPrintLog Where PPrintLog.ANO=Acceptance_Detail.ANO)))            
 And (@Value24='%' or Acceptance_Detail.ASource Like @Value24)
)              
   

GO

/****** Object:  UserDefinedFunction [dbo].[ListQry_3_A]    Script Date: 12/21/2017 1:43:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ListQry_3_A]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [ListQry_3_A] 
end
GO
CREATE FUNCTION  [dbo].[ListQry_3_A]
 (    
@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255),     
@Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),    
@Value11 as varchar(255),@Value12 as varchar(255), @Value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),    
@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255),@Value19 as varchar(255),@Value20 as varchar(255),@Value21 as varchar(255), @Value22 as varchar(255), @Value23 as varchar(255), @Value24 as varchar(255)      
)          
RETURNS Table      
AS RETURN      
(      
SELECT Cast(0 as bit) as ProcessFlag,      
 Q.[COVERNO],      
 Q.[Insured],      
 Q.[CNO],      
 Q.[CStatus],      
 Q.[lANO],      
 Q.[ANO],      
 Q.[REGNO],      
 Q.[ADATE],      
 Q.[USERID],      
 Q.[Currency],       
 Q.[ASTATUS],      
 Q.[ATYPE],      
 Q.[SDate],      
 Q.[EDate],      
 Q.RYear,      
 Q.[ISType],      
 Q.[Renewal],      
 Q.[ESeqNo],      
 Q.[PolicyNo],      
 Q.[CertificateNo],      
 Q.RefNo,      
 Q.ProformaF,      
 A.FLDID1,      
 A.VALUEID1,      
 A.VALUEDESC1,      
 A.FLDID2,      
 A.VALUEID2,      
 A.VALUEDESC2,      
 A.FLDID3,      
 A.VALUEID3,      
 A.VALUEDESC3,      
 A.FLDID4,      
 A.VALUEID4,      
 A.VALUEDESC4,      
 A.FLDID5,      
 A.VALUEID5,      
 A.VALUEDESC5,      
 A.FLDID6,      
 A.VALUEID6,      
 A.VALUEDESC6,      
 A.FLDID7,      
 A.VALUEID7,      
 A.VALUEDESC7,      
 A.FLDID8,      
 A.VALUEID8,      
 A.VALUEDESC8,      
 A.FLDID9,      
 A.VALUEID9,      
 A.VALUEDESC9,      
 A.FLDID10,      
 A.VALUEID10,      
 A.VALUEDESC10,      
 A.FLDID11,      
 A.VALUEID11,      
 A.VALUEDESC11,      
 A.FLDID12,      
 A.VALUEID12,      
 A.VALUEDESC12,      
 A.FLDID13,      
 A.VALUEID13,      
 A.VALUEDESC13,      
 A.FLDID14,      
 A.VALUEID14,      
 A.VALUEDESC14,      
 A.FLDID15,      
 A.VALUEID15,      
 a.VALUEDESC15      
From      
 LISTQRY_3(@Value1, @Value2, @Value3, @Value4, @Value5, @Value6, @Value7, @Value8, @Value9, @Value10, @Value11, @Value12, @Value13,@Value14,@Value15,@Value16,@Value17,@Value18, @Value19, @Value20, @Value21, @Value22, @Value23, @Value24) AS Q, AINFO AS A      
Where q.ano_info = a.ANO      
)      


GO

/****** Object:  UserDefinedFunction [dbo].[ListQry_3b]    Script Date: 12/21/2017 1:43:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ListQry_3b]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [ListQry_3b] 
end
GO
CREATE FUNCTION  [dbo].[ListQry_3b]
 (            
@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255),             
@Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),            
@Value11 as varchar(255),@Value12 as varchar(255), @Value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),            
@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255),@Value19 as varchar(255),@Value20 as varchar(255),@Value21 as varchar(255), @Value22 as varchar(255), @Value23 as varchar(255), @Value24 as varchar(255)            
)                  
RETURNS Table                  
AS RETURN                  
(                  
SELECT       
 Cover.COVERNO,                  
 Cast(Acceptance.AName as varchar(128)) as Insured,                  
 Cover.CNO,                  
 Cover.CStatus,                  
 Acceptance.lANO,                  
 Acceptance.ANO,                  
 Acceptance.REGNO,                  
 Acceptance.ADATE,                  
 Acceptance.LUSERID as USERID,                  
 SysTab.Currency,                  
 Acceptance.ASTATUS,                  
 Acceptance.ATYPE,                  
 Acceptance.SDate,                  
 Acceptance.EDate,                  
 Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear,                  
 Cover.ISType,                  
 Acceptance.Renewal,                  
 Acceptance.ESeqNo,                  
 Acceptance.PolicyNo,                  
 Acceptance.CertificateNo,                  
 Acceptance.RefNo,                  
 cover.ProformaF    
FROM  Cover, Acceptance     
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO), Profile, systab    
Where cover.CNO = acceptance.CNO       
 And cover.PHolder = Profile.ID                         
 And (@Value1='%' or Acceptance.AName Like @Value1)                
 And (@Value2='%' or Cover.CoverNo Like @Value2)                  
 and (Cover.CoverDate = @Value3 or @Value3='')                  
 And (Cover.ExpDate = @Value4 or @Value4='')                  
 And (@Value5='%' or Acceptance.PolicyNo Like @Value5)                  
 And (@Value6='%' or Acceptance.CertificateNo Like @Value6)                  
 And (Acceptance.PolicyDate = @Value7 or @Value7='' or Acceptance.PolicyDate Between @Value7 and @Value16)                  
 And (Acceptance.RegDate = @Value17 or @Value17='' or Acceptance.RegDate Between @Value17 and @Value18)                  
 And Acceptance.AType Like @Value8                  
 And Acceptance.AStatus Like @Value9                  
 And (@Value10='%' or Acceptance.RegNo Like @Value10)    
 And (@Value11='%' or Profile.Name Like @Value11)    
 and (@Value12='%' or Acceptance.toc like @Value12)    
 and (@Value13='%' or Acceptance.RefNo like @Value13)                  
 and (acceptance.ano = acceptance.lano or acceptance.lano = -1)                  
 and (Acceptance.Matters=@Value14 or @Value14='')                  
 And (Cover.ISType<>'T' or Cover.ProformaF=1)                  
 And (Acceptance.BatchNo Like @Value19)             
 And ((Acceptance.BackDatedF=1 and @Value20='1') or @Value20='')            
 And (@Value21<>'1' or (@Value21='1' and Exists (Select CAcceptance.CANO from Acceptance CAcceptance Where CAcceptance.CANO=Acceptance.ANO)))              
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')            
 And (@Value23<>'1' or (@Value23='1' and Exists (Select ANO from PPrintLog Where PPrintLog.ANO=Acceptance.ANO)))               
 And (@Value24='%' or Acceptance.ASource Like @Value24)
             
 union            
             
 SELECT       
 CCover.COVERNO,                  
 Cast(CAcceptance.AName as varchar(128)) as Insured,                  
 CCover.CNO,                  
 CCover.CStatus,                  
 CAcceptance.lANO,                  
 CAcceptance.ANO,                  
 CAcceptance.REGNO,                  
 CAcceptance.ADATE,                  
 CAcceptance.LUSERID as USERID,                  
 SysTab.Currency,                  
 CAcceptance.ASTATUS,       
 CAcceptance.ATYPE,                  
 CAcceptance.SDate,                  
 CAcceptance.EDate,                  
 Year(Coalesce(CRArrHeader.RDate,CAcceptance.SDate)) AS RYear,                  
 CCover.ISType,                  
 CAcceptance.Renewal,                  
 CAcceptance.ESeqNo,                  
 CAcceptance.PolicyNo,                  
 CAcceptance.CertificateNo,                  
 CAcceptance.RefNo,              
 Ccover.ProformaF    
FROM  Cover, Acceptance, Profile, systab, Cover CCover, Acceptance CAcceptance     
left Join RArrHeader CRArrHeader on (CRArrHeader.ANO=CAcceptance.ANO)     
Where @Value21='1' and CAcceptance.CANO=Acceptance.ANO and CCover.CNO=CAcceptance.CNO              
 and (Cacceptance.ano = Cacceptance.lano or Cacceptance.lano = -1)                           
 and cover.CNO = acceptance.CNO And cover.PHolder = Profile.ID                  
 And (@Value1='%' or Acceptance.AName Like @Value1)                
 And (@Value2='%' or Cover.CoverNo Like @Value2)                  
 and (Cover.CoverDate = @Value3 or @Value3='')                  
 And (Cover.ExpDate = @Value4 or @Value4='')                  
 And (@Value5='%' or Acceptance.PolicyNo Like @Value5)                  
 And (@Value6='%' or Acceptance.CertificateNo Like @Value6)                  
 And (Acceptance.PolicyDate = @Value7 or @Value7='' or Acceptance.PolicyDate Between @Value7 and @Value16)                  
 And (Acceptance.RegDate = @Value17 or @Value17='' or Acceptance.RegDate Between @Value17 and @Value18)                  
 And Acceptance.AType Like @Value8                  
 And Acceptance.AStatus Like @Value9                  
 And (@Value10='%' or Acceptance.RegNo Like @Value10)    
 And (@Value11='%' or Profile.Name Like @Value11)    
 and (@Value12='%' or Acceptance.toc like @Value12)    
 and (@Value13='%' or Acceptance.RefNo like @Value13)                  
 and (acceptance.ano = acceptance.lano or acceptance.lano = -1)                  
 and (Acceptance.Matters=@Value14 or @Value14='')                  
 And (Cover.ISType<>'T' or Cover.ProformaF=1)                  
 And (Acceptance.BatchNo Like @Value19)             
 And ((Acceptance.BackDatedF=1 and @Value20='1') or @Value20='')            
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')            
 And (@Value23<>'1' or (@Value23='1' and Exists (Select ANO from PPrintLog Where PPrintLog.ANO=Acceptance.ANO)))              
 And (@Value24='%' or Acceptance.ASource Like @Value24)
)


GO

/****** Object:  UserDefinedFunction [dbo].[ListQry_3b_a]    Script Date: 12/21/2017 1:43:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ListQry_3b_a]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [ListQry_3b_a] 
end
GO
CREATE FUNCTION  [dbo].[ListQry_3b_a]
 (  
@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255),   
@Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),  
@Value11 as varchar(255),@Value12 as varchar(255), @Value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),  
@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255),@Value19 as varchar(255),@Value20 as varchar(255),@Value21 as varchar(255), @Value22 as varchar(255), @Value23 as varchar(255), @Value24 as varchar(255)    
)        
RETURNS Table    
AS RETURN    
(    
SELECT Cast(0 as bit) as ProcessFlag,    
 [q].[COVERNO],    
 [q].[Insured],    
 [q].[CNO],    
 [q].[CStatus],    
 [q].[lANO],    
 [q].[ANO],    
 [q].[REGNO],    
 [q].[ADATE],    
 [q].[USERID],    
 [q].[Currency],     
 [q].[ASTATUS],    
 [q].[ATYPE],    
 [q].[SDate],    
 [q].[EDate],    
 [q].RYear,    
 [q].[ISType],    
 [q].[Renewal],    
 [q].[ESeqNo],    
 [q].[PolicyNo],    
 [q].[CertificateNo],    
 [q].[RefNo],    
 [q].[ProformaF],    
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
 a.VALUEID15 , a.VALUEDESC15    
FROM  ListQry_3b (@Value1, @Value2, @Value3, @Value4, @Value5, @Value6, @Value7, @Value8, @Value9, @Value10,@Value11, @Value12, @Value13,@Value14,@Value15,@Value16,@Value17,@Value18,@Value19,@Value20,@Value21, @Value22, @Value23, @Value24) as q, ainfo as a    
Where [q].[ANO] = [a].[ANO]    
        
)    




GO

/****** Object:  UserDefinedFunction [dbo].[List_By_Ano_Det]    Script Date: 12/21/2017 1:43:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO
iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[List_By_Ano_Det]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [List_By_Ano_Det] 
end
GO
CREATE FUNCTION  [dbo].[List_By_Ano_Det]
(@P_ANO AS INTEGER,@P_CANO AS INTEGER) 
RETURNS TABLE
AS RETURN(
SELECT Cast(0 as bit) as ProcessFlag,
	[Acceptance].[CertificateNo], 
	Acceptance.ESeqNo,
	[Acceptance].[AName], 
	[Acceptance].[ANO], 
	[Acceptance].[REGNO], 
	[Acceptance].[ADATE], 
	[Acceptance].[LUSERID] as UserID, 
	[SysTab].[Currency], 
	[QPCalc].[TSI], 
	[QPCalc].[OurShare], 
	[QPCalc].[Gross], 
	[Acceptance].[ASTATUS], 
	[Acceptance].[ATYPE], 
	[Acceptance].[SDate], 
	[Acceptance].[EDate], 
	Year([Acceptance].[SDate]) AS RYear,
 	Acceptance.ValueID,
 	Acceptance.ValueDesc
FROM Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc
WHERE 
	[Cover].[CNO]=[Acceptance].[CNO] 
	And [QPCalc].[ANO]=[Acceptance].[ANO] 
	And [Acceptance].[ANO]<>[Acceptance].[LANO] 
	And [Acceptance].[LANO]=@P_ANO
	And [Acceptance].[ANO]=@P_CANO
)


GO

/****** Object:  UserDefinedFunction [dbo].[List_Spc_01_Det]    Script Date: 12/21/2017 1:43:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[List_Spc_01_Det]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [List_Spc_01_Det] 
end
GO
CREATE FUNCTION  [dbo].[List_Spc_01_Det]
 (@P_ANO AS INTEGER) 
RETURNS TABLE
AS RETURN(
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.ESeqNo,
	Cast(Acceptance.AName as varchar(128)) as AName, 
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	QPCalc.TSI, 
	QPCalc.OurShare, 
	QPCalc.Gross, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(Acceptance.SDate) AS RYear,
	QPCalc.ValueID, QPCalc.ValueDesc
FROM Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc, RArrHeader
WHERE 
	Cover.CNO=Acceptance.CNO 
	And QPCalc.ANO=Acceptance.ANO 
	And Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO
	And RArrHeader.ANO=Acceptance.ANO
	And Acceptance.AStatus='I' and Acceptance.AType<>'C'
	And Cover.ISType not in ('C','L','I','T')
	And RArrHeader.TreatyF=1 and (RArrHeader.CAmount<>0 or RArrHeader.DAmount<>0 or RArrHeader.QAmount<>0 or RArrHeader.SP1Amount<>0 or RArrHeader.SP2Amount<>0 or RArrHeader.SP3Amount<>0 or RArrHeader.XPAmount<>0 or RArrHeader.AAmount<>0)
)


GO

/****** Object:  UserDefinedFunction [dbo].[List_Spc_02_Det]    Script Date: 12/21/2017 1:43:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[List_Spc_02_Det]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [List_Spc_02_Det] 
end
GO
CREATE FUNCTION  [dbo].[List_Spc_02_Det]
 (@P_ANO AS INTEGER) 
RETURNS TABLE
AS RETURN(
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.ESeqNo,
	Cast(Acceptance.AName as varchar(128)) as AName, 
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	QPCalc.TSI, 
	QPCalc.OurShare, 
	QPCalc.Gross, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(Acceptance.SDate) AS RYear,
	QPCalc.ValueID, QPCalc.ValueDesc
FROM Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc, RArrHeader
WHERE 
	Cover.CNO=Acceptance.CNO 
	And QPCalc.ANO=Acceptance.ANO 
	And Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO
	And RArrHeader.ANO=Acceptance.ANO
	And Acceptance.AStatus='I' and Acceptance.AType<>'C'
	And Acceptance.ANO not in (SELECT ANO from Classified_Object() C Where C.ANO=Acceptance.ANO)
	And RArrHeader.TreatyF=1 and (RArrHeader.CAmount<>0 or RArrHeader.DAmount<>0 or RArrHeader.QAmount<>0 or RArrHeader.SP1Amount<>0 or RArrHeader.SP2Amount<>0 or RArrHeader.SP3Amount<>0 or RArrHeader.XPAmount<>0 or RArrHeader.AAmount<>0)
)

GO

/****** Object:  UserDefinedFunction [dbo].[List_Spc_03_Det]    Script Date: 12/21/2017 1:43:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[List_Spc_03_Det]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [List_Spc_03_Det] 
end
GO
CREATE FUNCTION  [dbo].[List_Spc_03_Det]
 (@P_ANO AS INTEGER)   
RETURNS TABLE  
AS RETURN(  
SELECT Cast(0 as bit) as ProcessFlag,  
 Acceptance.CertificateNo,   
 Acceptance.ESeqNo,  
 Cast(Acceptance.AName as varchar(128)) as AName,   
 Acceptance.ANO,   
 Acceptance.REGNO,   
 Acceptance.ADATE,   
 Acceptance.LUSERID as UserID,   
 SysTab.Currency,   
 QPCalc.TSI,   
 QPCalc.OurShare,   
 QPCalc.Gross,   
 Acceptance.ASTATUS,   
 Acceptance.ATYPE,   
 Acceptance.SDate,   
 Acceptance.EDate,   
 Year(Acceptance.SDate) AS RYear,  
 QPCalc.ValueID, QPCalc.ValueDesc  
FROM Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc, RArrHeader  
WHERE   
 Cover.CNO=Acceptance.CNO   
 And QPCalc.ANO=Acceptance.ANO   
 And Acceptance.ANO<>Acceptance.LANO   
 And Acceptance.LANO=@P_ANO  
 And RArrHeader.ANO=Acceptance.ANO  
 And Acceptance.AStatus in ('I','W') and Acceptance.AType<>'C'  
 And Acceptance.TOC='0111'  
 And RArrHeader.FAmount=0  
)  
   

GO

/****** Object:  UserDefinedFunction [dbo].[List01_Det]    Script Date: 12/21/2017 1:43:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[List01_Det]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [List01_Det] 
end
GO
CREATE FUNCTION  [dbo].[List01_Det]
 (@P_ANO AS INTEGER, @P_UserID as varchar(255)) 
RETURNS TABLE 
AS RETURN( 
SELECT Cast(0 as bit) as ProcessFlag, 
[Acceptance].[CertificateNo], 
Acceptance.ESeqNo, 
[Acceptance].[AName], 
[Acceptance].[ANO], 
[Acceptance].[REGNO], 
[Acceptance].[ADATE], 
[Acceptance].[LUSERID] as UserID, 
[SysTab].[Currency], 
[QPCalc].[TSI], 
[QPCalc].[OurShare], 
[QPCalc].[Gross], 
[Acceptance].[ASTATUS], 
[Acceptance].[ATYPE], 
[Acceptance].[SDate], 
[Acceptance].[EDate], 
Year([Acceptance].[SDate]) AS RYear, 
Acceptance.ValueID, 
Acceptance.ValueDesc 
FROM Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc 
WHERE 
[Cover].[CNO]=[Acceptance].[CNO] 
And [QPCalc].[ANO]=[Acceptance].[ANO] 
And [Acceptance].[ANO]<>[Acceptance].[LANO] 
And [Acceptance].[LANO]=@P_ANO 
And [Acceptance].[AStatus]='W' 
And [Cover].[ISType]<>'T' 
And [Cover].[CStatus]='A' 
And Acceptance.LuserID Like @P_UserID 
) 
 
 

GO

/****** Object:  UserDefinedFunction [dbo].[List02_Det]    Script Date: 12/21/2017 1:43:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[List02_Det]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [List02_Det] 
end
GO
CREATE FUNCTION  [dbo].[List02_Det]
 (@P_ANO as integer,@P_UserID as varchar(255), @pEDate as smalldatetime) 
RETURNS TABLE 
AS RETURN( 
SELECT Cast(0 as bit) as ProcessFlag, 
[Acceptance].[CertificateNo], 
Acceptance.ESeqNo, 
[Acceptance].[AName], 
[Acceptance].[ANO], 
[Acceptance].[REGNO], 
[Acceptance].[ADATE], 
[Acceptance].[LUSERID] as UserID, 
[SysTab].[Currency], 
[QPCalc].[TSI], 
[QPCalc].[OurShare], 
[QPCalc].[Gross], 
[Acceptance].[ASTATUS], 
[Acceptance].[ATYPE], 
[Acceptance].[SDate], 
[Acceptance].[EDate], 
Year([Acceptance].[SDate]) AS RYear, 
Acceptance.ValueID, 
Acceptance.ValueDesc 
FROM 
Acceptance, 
Cover, 
SysTab, 
QMasterAcceptance_PCalc() AS QPCalc 
WHERE 
[Cover].[CNO]=[Acceptance].[CNO] 
And [QPCalc].[ANO]=[Acceptance].[ANO] 
And [Acceptance].[ANO]<>[Acceptance].[LANO] 
And [Acceptance].[LANO]=@P_ANO 
And [Acceptance].[AStatus]='W' 
And [Cover].[ISType]<>'T' 
And [Cover].[CStatus]='A' 
And [Cover].[CDate]+[Cover].[Validation]<=@pEDate 
And Acceptance.LUserID like @P_UserID 
) 
 
 

GO

/****** Object:  UserDefinedFunction [dbo].[List02A_Det]    Script Date: 12/21/2017 1:43:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[List02A_Det]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [List02A_Det] 
end
GO
CREATE FUNCTION  [dbo].[List02A_Det]
 (@P_ANO as integer,@P_UserID as varchar(255), @pEDate as smalldatetime) 
RETURNS TABLE 
AS RETURN( 
SELECT Cast(0 as bit) as ProcessFlag, 
[Acceptance].[CertificateNo], 
Acceptance.ESeqNo, 
[Acceptance].[AName], 
[Acceptance].[ANO], 
[Acceptance].[REGNO], 
[Acceptance].[ADATE], 
[Acceptance].[LUSERID] as UserID, 
[SysTab].[Currency], 
[QPCalc].[TSI], 
[QPCalc].[OurShare], 
[QPCalc].[Gross], 
[Acceptance].[ASTATUS], 
[Acceptance].[ATYPE], 
[Acceptance].[SDate], 
[Acceptance].[EDate], 
Year([Acceptance].[SDate]) AS RYear, 
Acceptance.ValueID, 
Acceptance.ValueDesc 
FROM 
Acceptance, 
Cover, 
SysTab, 
QMasterAcceptance_PCalc() AS QPCalc, 
RArrHeader 
WHERE 
[Cover].[CNO]=[Acceptance].[CNO] 
And [QPCalc].[ANO]=[Acceptance].[ANO] 
And [Acceptance].[ANO]<>[Acceptance].[LANO] 
And [Acceptance].[LANO]=@P_ANO 
And [Acceptance].[AStatus]='W' 
And [Cover].[ISType]<>'T' 
And [Cover].[CStatus]='A' 
And [Cover].[CDate]+[Cover].[Validation]<=@pEDate 
And RArrHeader.ANO=Acceptance.ANO and RArrHeader.FShare<>0 
And Acceptance.LUserID Like @P_UserID 
) 
 
 

GO

/****** Object:  UserDefinedFunction [dbo].[List03_Det]    Script Date: 12/21/2017 1:43:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[List03_Det]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [List03_Det] 
end
GO
CREATE FUNCTION  [dbo].[List03_Det]
(@P_ANO as integer, @P_USERID as varchar(255)) 
RETURNS TABLE 
AS RETURN( 
 
SELECT Cast(0 as bit) as ProcessFlag, 
[Acceptance].[CertificateNo], 
Acceptance.ESeqNo, 
[Acceptance].[AName], 
[Acceptance].[ANO], 
[Acceptance].[REGNO], 
[Acceptance].[ADATE], 
[Acceptance].[LUSERID] as UserID, 
[SysTab].[Currency], 
[QPCalc].[TSI], 
[QPCalc].[OurShare], 
[QPCalc].[Gross], 
[Acceptance].[ASTATUS], 
[Acceptance].[ATYPE], 
[Acceptance].[SDate], 
[Acceptance].[EDate], 
Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
Acceptance.ValueID, 
Acceptance.ValueDesc 
FROM 
Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) 
Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), 
Cover, 
SysTab 
WHERE 
[Cover].[CNO]=[Acceptance].[CNO] 
And [Acceptance].[ANO]<>[Acceptance].[LANO] 
And [Acceptance].[LANO]=@P_ANO 
And [Acceptance].AStatus Not in ('W','T') 
And [Cover].[ISType]<>'T' 
And [Acceptance].[LUserID] Like @P_UserID 
 
) 
 
 

GO

/****** Object:  UserDefinedFunction [dbo].[List04_Det]    Script Date: 12/21/2017 1:43:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[List04_Det]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [List04_Det] 
end
GO
CREATE FUNCTION  [dbo].[List04_Det]
 (@P_ANO as integer,@P_UserID as varchar(255)) 
RETURNS TABLE 
AS RETURN( 
 
SELECT Cast(0 as bit) as ProcessFlag, 
[Acceptance].[CertificateNo], 
Acceptance.ESeqNo, 
[Acceptance].[AName], 
[Acceptance].[ANO], 
[Acceptance].[REGNO], 
[Acceptance].[ADATE], 
[Acceptance].[LUSERID] as UserID, 
[SysTab].[Currency], 
[QPCalc].[TSI], 
[QPCalc].[OurShare], 
[QPCalc].[Gross], 
[Acceptance].[ASTATUS], 
[Acceptance].[ATYPE], 
[Acceptance].[SDate], 
[Acceptance].[EDate], 
Year([Acceptance].[SDate]) AS RYear, 
Acceptance.ValueID, 
Acceptance.ValueDesc 
FROM 
Acceptance, 
Cover, 
SysTab, 
QMasterAcceptance_PCalc() AS QPCalc 
WHERE 
[Cover].[CNO]=[Acceptance].[CNO] 
And [QPCalc].[ANO]=[Acceptance].[ANO] 
And [Acceptance].[ANO]<>[Acceptance].[LANO] 
And [Acceptance].[LANO]=@P_ANO 
And [Acceptance].[AStatus]='W' 
And [Cover].[ISType]<>'T' 
And [Cover].[CoverNoteF]=1 
And Acceptance.LUserID Like @P_UserID 
) 
 
 

GO

/****** Object:  UserDefinedFunction [dbo].[List05_Det]    Script Date: 12/21/2017 1:43:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[List05_Det]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [List05_Det] 
end
GO
CREATE FUNCTION  [dbo].[List05_Det]
(@P_ANO as integer, @P_UserID as varchar(50), @pSDate as smallDateTime, @pEDate as smallDateTime, @pBranch as varchar(10), @pTOC as varchar(10), @pMO as varchar(10))      
RETURNS Table      
AS RETURN(      
SELECT Cast(0 as bit) as ProcessFlag,      
 Acceptance.CertificateNo,      
 Acceptance.ESeqNo,      
 Cast(Acceptance.AName as varchar(128)) as AName,      
 Acceptance.ANO,      
 Acceptance.REGNO,      
 Acceptance.ADATE,      
 Acceptance.LUSERID as UserID,      
 SysTab.Currency,      
 QPCalc.TSI,      
 QPCalc.OurShare,      
 QPCalc.Gross,      
 Acceptance.ASTATUS,      
 Acceptance.ATYPE,      
 Acceptance.SDate,      
 Acceptance.EDate,      
 Year(Acceptance.SDate) AS RYear,      
 QPCalc.ValueID,      
 QPCalc.ValueDesc      
From      
 Acceptance,      
 Cover,      
 SysTab,      
 QMasterAcceptance_PCalc() AS QPCalc,      
 RARRHEADER      
Where      
 cover.CNO = acceptance.CNO      
 And Rarrheader.ANO = Acceptance.ANO      
 And QPCalc.ANO=Acceptance.ANO      
 And Acceptance.ANO<>Acceptance.LANO      
 And Acceptance.LANO=@P_ANO      
      
 And Cover.CStatus<>'C'      
 And Acceptance.AStatus='I' and Acceptance.AType not in ('A','C')      
 And Acceptance.EDate between @PSDate and @PEDate      
 And Acceptance.RenewableF=1      
 And Cover.ISType in ('I','C','L')      
 And Acceptance.Branch like @pBranch+'%'    
 And Acceptance.TOC Like @pTOC+'%'      
 And Cover.MO like @pMO+'%'    
 And not Exists (SELECT ANO from Claim, CLLOSS Where CLLOSS.CNO=Claim.CNO and CLLOSS.CTLF=1 and Claim.ANO=Acceptance.ANO)      
 and Exists (Select S1.ID from SysUser S1 Left Join SysUserBranch S2 on (S2.ID=S1.ID and S2.AllowedF=1 and S2.Branch=Acceptance.Branch) Where S1.ID=@P_UserID and (coalesce(S2.Branch,'')<>'' or S1.Type='SUPERVISOR'))      
)      
       

GO

/****** Object:  UserDefinedFunction [dbo].[List06_Det]    Script Date: 12/21/2017 1:43:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[List06_Det]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [List06_Det] 
end
GO
CREATE FUNCTION  [dbo].[List06_Det]
 (@P_ANO as integer, @P_UserID as varchar(50), @pSDate as smalldatetime, @pEDate as smallDateTime, @pBranch as varchar(10), @pTOC as varchar(10), @pMO as varchar(10))      
RETURNS TABLE      
AS RETURN(      
      
SELECT Cast(0 as bit) as ProcessFlag,      
 [Acceptance].[CertificateNo],       
 Acceptance.ESeqNo,      
 [Acceptance].[AName],       
 [Acceptance].[ANO],       
 [Acceptance].[REGNO],       
 [Acceptance].[ADATE],       
 [Acceptance].[LUSERID] as UserID,       
 [SysTab].[Currency],       
 [QPCalc].[TSI],       
 [QPCalc].[OurShare],       
 [QPCalc].[Gross],       
 [Acceptance].[ASTATUS],       
 [Acceptance].[ATYPE],       
 [Acceptance].[SDate],       
 [Acceptance].[EDate],       
 Year([Acceptance].[SDate]) AS RYear,      
  Acceptance.ValueID,      
  Acceptance.ValueDesc      
FROM       
 Acceptance,       
 Cover,       
 SysTab,       
 QMasterAcceptance_PCalc() AS QPCalc      
WHERE       
 [Cover].[CNO]=[Acceptance].[CNO]       
 And [QPCalc].[ANO]=[Acceptance].[ANO]       
 And [Acceptance].[ANO]<>[Acceptance].[LANO]       
 And [Acceptance].[LANO]=@P_ANO      
 And [Acceptance].[AStatus]='I'       
 And [Acceptance].[AType]<>'C'       
 And [Cover].[ISType]<>'T'       
 And Acceptance.Branch like @pBranch+'%'    
 And Acceptance.TOC Like @pTOC+'%'      
 And Cover.MO like @pMO+'%'    
 And [Acceptance].[EDate] between @pSDate and @pEDate       
 And Exists (Select S1.ID from SysUser S1 Left Join SysUserBranch S2 on (S2.ID=S1.ID and S2.AllowedF=1 and S2.Branch=Acceptance.Branch) Where S1.ID=@P_UserID and (coalesce(S2.Branch,'')<>'' or S1.Type='SUPERVISOR'))       
)      


GO

/****** Object:  UserDefinedFunction [dbo].[List07_Det]    Script Date: 12/21/2017 1:43:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[List07_Det]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [List07_Det] 
end
GO
CREATE FUNCTION  [dbo].[List07_Det]
  (@P_ANO as integer, @PSDate as SmallDateTime, @pEDAte as smallDateTime,@P_COB as varchar(10))  
RETURNS Table  
AS RETURN(  
    
SELECT Cast(0 as bit) as ProcessFlag,  
 [Acceptance].[CertificateNo],  
 Acceptance.ESeqNo,  
 [Acceptance].[AName],  
 [Acceptance].[ANO],  
 [Acceptance].[REGNO],  
 [Acceptance].[ADATE],  
 [Acceptance].[LUSERID] as UserID,  
 [SysTab].[Currency],  
 [QPCalc].[TSI],  
 [QPCalc].[OurShare],  
 [QPCalc].[Gross],  
 [Acceptance].[ASTATUS],  
 [Acceptance].[ATYPE],  
 [Acceptance].[SDate],  
 [Acceptance].[EDate],  
 Year([acceptance].[SDate]) As RYear,  
 Acceptance.ValueID,  
 Acceptance.ValueDesc  
From  
 Acceptance,  
 Cover,  
 SysTab,  
 QMasterAcceptance_PCalc() AS QPCalc,  
 TOC  
Where  
 [cover].[CNO] = [acceptance].[CNO]  
 And [QPCalc].[ANO]=[Acceptance].[ANO]  
 And [Acceptance].[ANO]<>[Acceptance].[LANO]  
 And [Acceptance].[LANO]=@P_ANO  
 And (([Acceptance].[AType]='C' and Acceptance.AStatus='I' and [Acceptance].[PPDate] between @PSdate and @pEDate)  
 or (Acceptance.AType<>'C' and Acceptance.AStatus='C' And [Acceptance].[CloseDate] between @PSdate and @pEDate)  
 or ([Acceptance].[AType]<>'C' and Acceptance.AStatus='I' and [Acceptance].[EDate] between @PSdate and @pEDate))  
 And [Cover].[ISType]<>'T'  
 And Acceptance.AdjustableF=1  
 And TOC.TOC=Acceptance.TOC  
 And TOC.COB=@P_COB  
)  


GO

/****** Object:  UserDefinedFunction [dbo].[List08_Det]    Script Date: 12/21/2017 1:43:28 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[List08_Det]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [List08_Det] 
end
GO
CREATE FUNCTION  [dbo].[List08_Det]
(@P_ANO as integer, @pSDate as smallDatetime, @pEDate as smalldatetime)
RETURNS TABLE
AS RETURN(

SELECT Cast(0 as bit) as ProcessFlag,
	[Acceptance].[CertificateNo], 
	Acceptance.ESeqNo,
	[Acceptance].[AName], 
	[Acceptance].[ANO], 
	[Acceptance].[REGNO], 
	[Acceptance].[ADATE], 
	[Acceptance].[LUSERID] as UserID, 
	[SysTab].[Currency], 
	[QPCalc].[TSI], 
	[QPCalc].[OurShare], 
	[QPCalc].[Gross], 
	[Acceptance].[ASTATUS], 
	[Acceptance].[ATYPE], 
	[Acceptance].[SDate], 
	[Acceptance].[EDate], 
	Year([Acceptance].[SDate]) AS RYear,
 	Acceptance.ValueID,
 	Acceptance.ValueDesc
FROM 
	Acceptance, 
	Cover, 
	SysTab, 
	QMasterAcceptance_PCalc() AS QPCalc
WHERE 
	[Cover].[CNO]=[Acceptance].[CNO] 
	And [QPCalc].[ANO]=[Acceptance].[ANO] 
	And [Acceptance].[ANO]<>[Acceptance].[LANO] 
	And [Acceptance].[LANO]=@P_ANO
	And [Acceptance].[AType]='A' 
	And [Cover].[ISType]<>'T' 
	And [Acceptance].[ADate]>=@pSDate 
	And [Acceptance].[ADate]<=@pEDate
)


GO

/****** Object:  UserDefinedFunction [dbo].[List09_Det]    Script Date: 12/21/2017 1:43:28 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[List09_Det]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [List09_Det] 
end
GO
CREATE FUNCTION  [dbo].[List09_Det]
(@P_ANO as integer, @pSDate as smalldatetime, @pEDate as smalldatetime)
RETURNS TABLE
AS RETURN(

SELECT Cast(0 as bit) as ProcessFlag,
	[Acceptance].[CertificateNo], 
	Acceptance.ESeqNo,
	[Acceptance].[AName], 
	[Acceptance].[ANO], 
	[Acceptance].[REGNO], 
	[Acceptance].[ADATE], 
	[Acceptance].[LUSERID] as UserID, 
	[SysTab].[Currency], 
	[QPCalc].[TSI], 
	[QPCalc].[OurShare], 
	[QPCalc].[Gross], 
	[Acceptance].[ASTATUS], 
	[Acceptance].[ATYPE], 
	[Acceptance].[SDate], 
	[Acceptance].[EDate], 
	Year([Acceptance].[SDate]) AS RYear,
 	Acceptance.ValueID,
 	Acceptance.ValueDesc
FROM 
	Acceptance, 
	Cover, 
	SysTab, 
	QMasterAcceptance_PCalc() AS QPCalc
WHERE 
	[Cover].[CNO]=[Acceptance].[CNO] 
	And [QPCalc].[ANO]=[Acceptance].[ANO] 
	And [Acceptance].[ANO]<>[Acceptance].[LANO] 
	And [Acceptance].[LANO]=@P_ANO 
	And [Acceptance].[AType]='C' 
	And [Cover].[ISType]<>'T' 
	And [Acceptance].[ADate]>=@pSDate 
	And [Acceptance].[ADate]<=@pEDate
)


GO

/****** Object:  UserDefinedFunction [dbo].[List10_Det]    Script Date: 12/21/2017 1:43:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[List10_Det]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [List10_Det] 
end
GO
CREATE FUNCTION  [dbo].[List10_Det]
(@P_ANO as integer)   
RETURNS Table   
AS RETURN(   
   
SELECT Cast(0 as bit) as ProcessFlag,   
ACCEPTANCE.CNO,ACCEPTANCE.ANO, ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, ACCEPTANCE.ADATE, ACCEPTANCE.SDATE, ACCEPTANCE.EDATE, ACCEPTANCE.REMARKS, ACCEPTANCE.ASTATUS, ACCEPTANCE.BACKDATEDF, AccAss.CURRENCY_OC,   
sum(case accass.code+accass.type   
when 'PIT' then accass.amount_oc   
when 'PIX' then accass.amount_oc   
else 0 end) as Premium,   
   
sum(case accass.code+accass.type   
when 'UIT' then accass.amount_oc   
when 'UIX' then accass.amount_oc   
else 0 end) as UjrohCedant,   
   
sum(case accass.code+accass.type   
when 'AIT' then accass.amount_oc   
when 'AIX' then accass.amount_oc   
else 0 end) as Claim,   
   
sum(case accass.code+accass.type   
when 'RIT' then accass.amount_oc   
when 'RIX' then accass.amount_oc   
else 0 end) as Subrogation,   
   
sum(case accass.code+accass.type   
when 'CIT' then accass.amount_oc   
when 'CIX' then accass.amount_oc   
else 0 end) as Commission,   
   
sum(case accass.code+accass.type   
when 'FIT' then accass.amount_oc   
when 'FIX' then accass.amount_oc   
else 0 end) as Fee,   
   
sum(case accass.code+accass.type   
when 'TIT' then accass.amount_oc   
when 'TIX' then accass.amount_oc   
else 0 end) as Tax,   
   
sum(case accass.code+accass.type   
when 'CBO' then accass.amount_oc   
when 'OIT' then accass.amount_oc   
when 'OIX' then accass.amount_oc   
else 0 end) as Other,   
   
sum(case accass.code+accass.type   
when 'DIT' then accass.amount_oc   
when 'DIX' then accass.amount_oc   
else 0 end) as Fund,   
Max(PCalc.OurShare) as TSI,   
AccAss.Currency   
FROM ACCEPTANCE With (Index (I_ACCEPTANCE_LANO))   
Left Join AccAss with (Index (I_ACCASS_ANO)) on (AccAss.ANO=Acceptance.ANO)   
Left Join PCalc with (index(I_PCalc)) on (PCalc.ANO=Acceptance.ANO and PCalc.Currency=AccAss.Currency)   
WHERE Acceptance.LANO=@P_ANO and Acceptance.ANO<>Acceptance.LANO   
GROUP BY ACCEPTANCE.ANO, ACCEPTANCE.CNO, ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, ACCEPTANCE.ADATE, ACCEPTANCE.SDATE, ACCEPTANCE.EDATE, ACCEPTANCE.REMARKS, ACCEPTANCE.ASTATUS, ACCEPTANCE.BACKDATEDF, AccAss.CURRENCY_OC, AccAss.CURRENCY   
)   
   
   
GO

/****** Object:  UserDefinedFunction [dbo].[List11_Det]    Script Date: 12/21/2017 1:43:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[List11_Det]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [List11_Det] 
end
GO
CREATE FUNCTION  [dbo].[List11_Det]
 (@P_ANO as integer,@P_SDate as smalldatetime, @P_EDate as smalldatetime)
RETURNS Table
AS RETURN(
        
SELECT Cast(0 as bit) as ProcessFlag,
 Acceptance.CertificateNo,
 Acceptance.ESeqNo,
 Cast(Acceptance.AName as varchar(128)) as AName,
 Acceptance.ANO,
 Acceptance.REGNO,
 Acceptance.ADATE,
 Acceptance.LUSERID as UserID,
 SysTab.Currency,
 QPCalc.TSI,
 QPCalc.OurShare,
 QPCalc.Gross,
 Acceptance.ASTATUS,
 Acceptance.ATYPE,
 Acceptance.SDate,
 Acceptance.EDate,
 Year(Acceptance.SDate) AS RYear,
 Acceptance.ValueID,
 Acceptance.ValueDesc
From
 Acceptance,
 Cover,
 SysTab,
 QMasterAcceptance_PCalc() AS QPCalc,
 RARRHEADER
Where
 cover.CNO = acceptance.CNO
 And Rarrheader.ANO = Acceptance.ANO
 And QPCalc.ANO=Acceptance.ANO
 And Acceptance.ANO<>Acceptance.LANO
 And Acceptance.LANO=@P_ANO
 And Cover.CStatus<>'C'
 And (Acceptance.AType Not in ('C','A') and Acceptance.AStatus='I' And RArrHeader.Status='R')
 And Cover.ISType<>'T'
 And Acceptance.ADate Between @P_SDate and @P_EDate
)
        
     
GO

/****** Object:  UserDefinedFunction [dbo].[List11A_Det]    Script Date: 12/21/2017 1:43:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[List11A_Det]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [List11A_Det] 
end
GO
CREATE FUNCTION  [dbo].[List11A_Det]
(@P_ANO as integer, @P_UserID as varchar(255), @P_TOC as varchar(10), @P_Branch as varchar(10), @P_AStatus as varchar(1))   
RETURNS Table   
AS RETURN(   
   
SELECT Cast(0 as bit) as ProcessFlag,   
Acceptance.CertificateNo,   
Acceptance.ESeqNo,   
Cast(Acceptance.AName as varchar(128)) as AName,   
Acceptance.ANO,   
Acceptance.REGNO,   
Acceptance.ADATE,   
Acceptance.LUSERID as UserID,   
SysTab.Currency,   
QPCalc.TSI,   
QPCalc.OurShare,   
QPCalc.Gross,   
Acceptance.ASTATUS,   
Acceptance.ATYPE,   
Acceptance.SDate,   
Acceptance.EDate,   
Year(Acceptance.SDate) AS RYear,   
QPCalc.ValueID,   
QPCalc.ValueDesc   
From   
Acceptance,   
Cover,   
SysTab,   
QMasterAcceptance_PCalc() AS QPCalc,   
RARRHEADER,   
SysUser   
Where   
cover.CNO = acceptance.CNO   
And Rarrheader.ANO = Acceptance.ANO   
And QPCalc.ANO=Acceptance.ANO   
And Acceptance.ANO<>Acceptance.LANO   
And Acceptance.LANO=@P_ANO   
And Cover.CStatus<>'C'   
And Acceptance.AStatus='W'   
And (RArrHeader.RAmount<>0 or RArrHeader.HoldF=1)   
And Cover.ISType<>'T'   
And Acceptance.TOC Like @P_TOC and Acceptance.Branch Like @P_Branch and (Acceptance.AStatus=@P_AStatus or @P_AStatus='')   
And SysUser.ID=@P_UserID   
and (SysUser.Type='SUPERVISOR' or   
(   
EXISTS (Select Branch from SysUserBranch S Where S.ID=@P_UserID and S.Branch=Acceptance.Branch)   
and   
EXISTS (Select TOC from SysUserTOC S Where S.ID=@P_UserID and S.TOC=Acceptance.TOC)   
))   
) 


GO

/****** Object:  UserDefinedFunction [dbo].[List11B_Det]    Script Date: 12/21/2017 1:43:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[List11B_Det]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [List11B_Det] 
end
GO
CREATE FUNCTION  [dbo].[List11B_Det]

(@P_ANO as integer)
RETURNS Table
AS RETURN(
  
SELECT Cast(0 as bit) as ProcessFlag,
 Acceptance.CertificateNo,
 Acceptance.ESeqNo,
 Cast(Acceptance.AName as varchar(128)) as AName,
 Acceptance.ANO,
 Acceptance.REGNO,
 Acceptance.ADATE,
 Acceptance.LUSERID as UserID,
 SysTab.Currency,
 QPCalc.TSI,
 QPCalc.OurShare,
 QPCalc.Gross,
 Acceptance.ASTATUS,
 Acceptance.ATYPE,
 Acceptance.SDate,
 Acceptance.EDate,
 Year(Acceptance.SDate) AS RYear,
 QPCalc.ValueID,
 QPCalc.ValueDesc
From
 Acceptance,
 Cover,
 SysTab,
 QMasterAcceptance_PCalc() AS QPCalc,
 RARRHEADER
Where
 cover.CNO = acceptance.CNO
 And Rarrheader.ANO = Acceptance.ANO
 And QPCalc.ANO=Acceptance.ANO
 And Acceptance.ANO<>Acceptance.LANO
 And Acceptance.LANO=@P_ANO
 And Cover.CStatus<>'C'
 And Acceptance.AStatus='W'
 And Cover.ISType<>'T'
 And RArrheader.ANO in (SELECT ANO from RArrDet Where Status<>'O')
)
  
  


GO

/****** Object:  UserDefinedFunction [dbo].[List11C_Det]    Script Date: 12/21/2017 1:43:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[List11C_Det]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [List11C_Det] 
end
GO
CREATE FUNCTION  [dbo].[List11C_Det]

 (@P_ANO as integer) 
RETURNS TABLE
AS RETURN(

SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.ESeqNo,
	Cast(Acceptance.AName as varchar(128)) as AName, 
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	QPCalc.TSI, 
	QPCalc.OurShare, 
	QPCalc.Gross, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(Acceptance.SDate) AS RYear,
	QPCalc.ValueID,
	QPCalc.ValueDesc
FROM 
	Acceptance, 
	Cover, 
	SysTab, 
	QMasterAcceptance_PCalc() AS QPCalc,
	Rarrheader
WHERE 
	Cover.CNO=Acceptance.CNO 
	And Rarrheader.ANO = Acceptance.ANO
	And QPCalc.ANO=Acceptance.ANO 
	And Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO 
	And Cover.CStatus<>'C'
        And Acceptance.AStatus='W'   
        And Acceptance.EMethod='T'  
)

GO

/****** Object:  UserDefinedFunction [dbo].[List11D_Det]    Script Date: 12/21/2017 1:43:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[List11D_Det]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [List11D_Det] 
end
GO
CREATE FUNCTION  [dbo].[List11D_Det]
 (@P_ANO as integer,@P_SDate as smalldatetime, @P_EDate as smalldatetime) 
RETURNS TABLE
AS RETURN(

SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.ESeqNo,
	Cast(Acceptance.AName as varchar(128)) as AName, 
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	QPCalc.TSI, 
	QPCalc.OurShare, 
	QPCalc.Gross, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(Acceptance.SDate) AS RYear,
 	Acceptance.ValueID,
 	Acceptance.ValueDesc
FROM 
	Acceptance, 
	Cover, 
	SysTab, 
	QMasterAcceptance_PCalc() AS QPCalc,
	Rarrheader
WHERE 
	Cover.CNO=Acceptance.CNO 
	And Rarrheader.ANO = Acceptance.ANO
	And QPCalc.ANO=Acceptance.ANO 
	And Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO 
        And Acceptance.ADate Between @P_SDate and @P_EDate
        And RArrHeader.Status<>'R'   
        And RArrHeader.SAmount<>0
        And Cover.ISType<>'T'
)


GO

/****** Object:  UserDefinedFunction [dbo].[List11E_Det]    Script Date: 12/21/2017 1:43:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[List11E_Det]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [List11E_Det] 
end
GO
CREATE FUNCTION  [dbo].[List11E_Det]

(@P_ANO as integer,@P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_REGID as varchar(10))
RETURNS Table
AS RETURN(
              
SELECT Cast(0 as bit) as ProcessFlag,
 Acceptance.CertificateNo,
 Acceptance.ESeqNo,
 Cast(Acceptance.AName as varchar(128)) as AName,
 Acceptance.ANO,
 Acceptance.REGNO,
 Acceptance.ADATE,
 Acceptance.LUSERID as UserID,
 SysTab.Currency,
 QPCalc.TSI,
 QPCalc.OurShare,
 QPCalc.Gross,
 Acceptance.ASTATUS,
 Acceptance.ATYPE,
 Acceptance.SDate,
 Acceptance.EDate,
 Year(Acceptance.SDate) AS RYear,
 Acceptance.ValueID,
 Acceptance.ValueDesc
From
 Acceptance,
 Cover,
 SysTab,
 QMasterAcceptance_PCalc() AS QPCalc,
 Rarrheader,
 AccRegDet
Where
 cover.CNO = acceptance.CNO
 and Acceptance.REGID=@P_REGID
 And Rarrheader.ANO = Acceptance.ANO
 And QPCalc.ANO=Acceptance.ANO
 And Acceptance.ANO<>Acceptance.LANO
 And Acceptance.LANO=@P_ANO
 And Acceptance.ADate Between @P_SDate and @P_EDate
 And RArrHeader.Status<>'R' And RArrHeader.TAmount<>0
 And Acceptance.AStatus in ('W','I')
 And Cover.ISType<>'T'
 And AccRegDet.RYear=Year(RArrHeader.RDate) and AccRegDet.RegID=Acceptance.RegID and AccRegDet.FLDID=Acceptance.FLDID and AccRegDet.VALUEID=Acceptance.ValueID and AccRegDet.TSI<>0 and RArrHeader.ManualF=0 and AccRegDet.ReAllocF=1
 And ((Rarrheader.CID<>'' or RArrHeader.XPID<>'' or RArrheader.SP1ID<>'' or RArrHeader.SP2ID<>'' or RArrHeader.SP3ID<>'' or (RArrHeader.QID<>'' and RArrHeader.QSRet<>100)))
)
              

GO

/****** Object:  UserDefinedFunction [dbo].[List11F_Det]    Script Date: 12/21/2017 1:43:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[List11F_Det]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [List11F_Det] 
end
GO
CREATE FUNCTION  [dbo].[List11F_Det]
(@P_ANO as integer,@P_UserID as varchar(10), @P_TOC as varchar(10), @P_Branch as varchar(10), @P_PDate as smalldatetime, @P_ManualF as bit)      
RETURNS Table      
AS RETURN(      
          
SELECT Cast(0 as bit) as ProcessFlag,      
 Acceptance.CertificateNo,      
 Acceptance.ESeqNo,      
 Cast(Acceptance.AName as varchar(128)) as AName,      
 Acceptance.ANO,      
 Acceptance.REGNO,      
 Acceptance.ADATE,      
 Acceptance.LUSERID as UserID,      
 SysTab.Currency,      
 QPCalc.TSI,      
 QPCalc.OurShare,      
 QPCalc.Gross,      
 Acceptance.ASTATUS,      
 Acceptance.ATYPE,      
 Acceptance.SDate,      
 Acceptance.EDate,      
 Year(Acceptance.SDate) AS RYear,      
 Acceptance.ValueID,      
 Acceptance.ValueDesc      
From      
 Acceptance,      
 Cover,      
 SysTab,      
 QMasterAcceptance_PCalc() AS QPCalc,      
 RARRHEADER,   
 SysUserTOC,   
 SysUserBranch  
Where      
 cover.CNO = acceptance.CNO      
 And Rarrheader.ANO = Acceptance.ANO      
 And QPCalc.ANO=Acceptance.ANO      
 And Acceptance.ANO<>Acceptance.LANO      
 And Acceptance.LANO=@P_ANO      
 And Cover.CStatus<>'C'      
 And Acceptance.AStatus='I' and Acceptance.AType not in ('A','C')      
 And RArrHeader.NRDate<Acceptance.EDate And RArrHeader.NRDate<=@P_PDate      
 And (@P_ManualF=0 or RArrHeader.ManualF=@P_ManualF)    
 And Cover.ISType<>'T'      
 And SysUserTOC.ID=@P_UserID and Acceptance.TOC=SysUserTOC.TOC and (SysUserTOC.TOC Like @P_TOC+'%' or @P_TOC='')    
 And SysUserBranch.ID=@P_UserID and Acceptance.BRanch=SysUserBranch.Branch and (SysUserBranch.Branch=@P_Branch or @P_Branch='')     
)      


GO

/****** Object:  UserDefinedFunction [dbo].[List11G_Det]    Script Date: 12/21/2017 1:43:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[List11G_Det]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [List11G_Det] 
end
GO
CREATE FUNCTION  [dbo].[List11G_Det]
 (@P_ANO as integer,@P_SDate as smalldatetime, @P_EDate as smalldatetime)
RETURNS Table
AS RETURN(
    
SELECT Cast(0 as bit) as ProcessFlag,
 Acceptance.CertificateNo,
 Acceptance.ESeqNo,
 Cast(Acceptance.AName as varchar(128)) as AName,
 Acceptance.ANO,
 Acceptance.REGNO,
 Acceptance.ADATE,
 Acceptance.LUSERID as UserID,
 SysTab.Currency,
 QPCalc.TSI,
 QPCalc.OurShare,
 QPCalc.Gross,
 Acceptance.ASTATUS,
 Acceptance.ATYPE,
 Acceptance.SDate,
 Acceptance.EDate,
 Year(Acceptance.SDate) AS RYear,
 Acceptance.ValueID,
 Acceptance.ValueDesc
From
 Acceptance,
 Cover,
 SysTab,
 QMasterAcceptance_PCalc() AS QPCalc,
 RARRHEADER
Where
 cover.CNO = acceptance.CNO
 And Rarrheader.ANO = Acceptance.ANO
 And QPCalc.ANO=Acceptance.ANO
 And Acceptance.ANO<>Acceptance.LANO
 And Acceptance.LANO=@P_ANO
 And Acceptance.AStatus<>'W'
 And Acceptance.ANO in
(SELECT AccAss.ANO from AccAss, RArrDet, FPart Where AccAss.ANO=Acceptance.ANO and AccAss.Type='FO' and FPart.ANO=RArrDet.ANO and FPart.FID=RArrDet.FID and AccAss.ANO=RArrDet.ANO and AccAss.ID=FPart.ID and AccAss.RefNo=FPart.SlipNo and (Acceptance.AType='C' or RArrDet.Status='O'))
)
    
   
GO

/****** Object:  UserDefinedFunction [dbo].[List12_Det]    Script Date: 12/21/2017 1:43:28 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[List12_Det]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [List12_Det] 
end
GO
CREATE FUNCTION  [dbo].[List12_Det]

 (@P_ANO as integer) 
RETURNS TABLE
AS RETURN(

SELECT Cast(0 as bit) as ProcessFlag,
	[Acceptance].[CertificateNo], 
	Acceptance.ESeqNo,
	[Acceptance].[AName], 
	[Acceptance].[ANO], 
	[Acceptance].[REGNO], 
	[Acceptance].[ADATE], 
	[Acceptance].[LUSERID] as UserID, 
	[SysTab].[Currency], 
	[QPCalc].[TSI], 
	[QPCalc].[OurShare], 
	[QPCalc].[Gross], 
	[Acceptance].[ASTATUS], 
	[Acceptance].[ATYPE], 
	[Acceptance].[SDate], 
	[Acceptance].[EDate], 
	Year([Acceptance].[SDate]) AS RYear,
 	Acceptance.ValueID,
 	Acceptance.ValueDesc
FROM 
	Acceptance, 
	Cover, 
	SysTab, 
	QMasterAcceptance_PCalc() AS QPCalc,
	Rarrheader
WHERE 
	[Cover].[CNO]=[Acceptance].[CNO] 
	And Rarrheader.ANO = Acceptance.ANO
	And [QPCalc].[ANO]=[Acceptance].[ANO] 
	And [Acceptance].[ANO]<>[Acceptance].[LANO] 
	And [Acceptance].[LANO]=@P_ANO 
	And Cover.CStatus<>'C'
	And [Acceptance].[AStatus]='W' 
	And [RArrHeader].[TreatyF]=1 And RArrHeader.Status='A'
	And [Cover].[ISType]<>'T'
)


GO

/****** Object:  UserDefinedFunction [dbo].[List13_Det]    Script Date: 12/21/2017 1:43:28 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO
iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[List13_Det]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [List13_Det] 
end
GO
CREATE FUNCTION  [dbo].[List13_Det]
(@P_ANO as integer, @pSDate as smalldatetime, @pEDate as smalldatetime)
RETURNS TABLE
as RETURN(

SELECT Cast(0 as bit) as ProcessFlag,
	[Acceptance].[CertificateNo], 
	Acceptance.ESeqNo,
	[Acceptance].[AName], 
	[Acceptance].[ANO], 
	[Acceptance].[REGNO], 
	[Acceptance].[ADATE], 
	[Acceptance].[LUSERID] as UserID, 
	[SysTab].[Currency], 
	[QPCalc].[TSI], 
	[QPCalc].[OurShare], 
	[QPCalc].[Gross], 
	[Acceptance].[ASTATUS], 
	[Acceptance].[ATYPE], 
	[Acceptance].[SDate], 
	[Acceptance].[EDate], 
	Year([Acceptance].[SDate]) AS RYear,
 	Acceptance.ValueID,
 	Acceptance.ValueDesc
FROM 
	Acceptance, 
	Cover, 
	SysTab, 
	QMasterAcceptance_PCalc() AS QPCalc
WHERE 
	[Cover].[CNO]=[Acceptance].[CNO] 
	And [QPCalc].[ANO]=[Acceptance].[ANO] 
	And [Acceptance].[ANO]<>[Acceptance].[LANO] 
	And [Acceptance].[LANO]=@P_ANO
     	And [Acceptance].AStatus='I'
      	And [Cover].[ISType]<>'T' 
      	And [Acceptance].[ADate]>=@pSDate 
      	And [Acceptance].[ADate]<=@pEDate
)


GO

/****** Object:  UserDefinedFunction [dbo].[List14_Det]    Script Date: 12/21/2017 1:43:28 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[List14_Det]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [List14_Det] 
end
GO
CREATE FUNCTION  [dbo].[List14_Det]
(@P_ANO as integer) 
RETURNS TABLE
as RETURN(

SELECT Cast(0 as bit) as ProcessFlag,
	[Acceptance].[CertificateNo], 
	Acceptance.ESeqNo,
	[Acceptance].[AName], 
	[Acceptance].[ANO], 
	[Acceptance].[REGNO], 
	[Acceptance].[ADATE], 
	[Acceptance].[LUSERID] as UserID, 
	[SysTab].[Currency], 
	[QPCalc].[TSI], 
	[QPCalc].[OurShare], 
	[QPCalc].[Gross], 
	[Acceptance].[ASTATUS], 
	[Acceptance].[ATYPE], 
	[Acceptance].[SDate], 
	[Acceptance].[EDate], 
	Year([Acceptance].[SDate]) AS RYear,
 	Acceptance.ValueID,
 	Acceptance.ValueDesc
FROM 
	Acceptance, 
	Cover, 
	SysTab, 
	QMasterAcceptance_PCalc() AS QPCalc
WHERE 
	[Cover].[CNO]=[Acceptance].[CNO] 
	And [QPCalc].[ANO]=[Acceptance].[ANO] 
	And [Acceptance].[ANO]<>[Acceptance].[LANO] 
	And [Acceptance].[LANO]=@P_ANO
	and Cover.OpenFlag=1
      	And [Acceptance].AStatus='I' 
      	And [Cover].[ISType]<>'T' 
)


GO

/****** Object:  UserDefinedFunction [dbo].[List15_Blank_Det]    Script Date: 12/21/2017 1:43:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[List15_Blank_Det]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [List15_Blank_Det] 
end
GO
CREATE FUNCTION  [dbo].[List15_Blank_Det]
(@P_ANO as integer,@P_REGID varchar(10), @P_FLDID varchar(255), @P_VALUEID varchar(255))
RETURNS Table
as RETURN(
  
SELECT Cast(0 as bit) as ProcessFlag,
 [Acceptance].[CertificateNo],
 Acceptance.ESeqNo,
 [Acceptance].[AName],
 [Acceptance].[ANO],
 [Acceptance].[REGNO],
 [Acceptance].[ADATE],
 [Acceptance].[LUSERID] as UserID,
 [SysTab].[Currency],
 [QPCalc].[TSI],
 [QPCalc].[OurShare],
 [QPCalc].[Gross],
 [Acceptance].[ASTATUS],
 [Acceptance].[ATYPE],
 [Acceptance].[SDate],
 [Acceptance].[EDate],
 Year([Acceptance].[SDate]) AS RYear,
 Acceptance.ValueID,
 Acceptance.ValueDesc
From
 Acceptance,
 Cover,
 SysTab,
 QMasterAcceptance_PCalc() AS QPCalc, RArrHeader
Where
 [cover].[CNO] = [acceptance].[CNO]
 And [QPCalc].[ANO]=[Acceptance].[ANO]
 And [Acceptance].[ANO]<>[Acceptance].[LANO]
 And [Acceptance].[LANO]=@P_ANO
 And [Cover].[ISType]<>'T'
 And [RArrHeader].[Status]='A'
 And [RArrHeader].[ANO]=[Acceptance].[ANO]
 And Acceptance.REGID=@P_REGID
 And [Acceptance].[FLDID]=@P_FLDID
 And [Acceptance].[ValueID] Like @P_ValueID + '%')
  
 
GO

/****** Object:  UserDefinedFunction [dbo].[List15_Det]    Script Date: 12/21/2017 1:43:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[List15_Det]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [List15_Det] 
end
GO
CREATE FUNCTION  [dbo].[List15_Det]
(@P_ANO as integer,@P_REGID varchar(10), @P_FLDID varchar(255), @P_VALUEID varchar(255), @P_VALUEID1 varchar(255), @P_VALUEID2 varchar(255), @P_VALUEID3 varchar(255), @P_VALUEID4 varchar(255), @P_VALUEID5 varchar(255), @P_VALUEID6 varchar(255)) 
RETURNS TABLE
as RETURN(

SELECT Cast(0 as bit) as ProcessFlag,
	[Acceptance].[CertificateNo], 
	Acceptance.ESeqNo,
	[Acceptance].[AName], 
	[Acceptance].[ANO], 
	[Acceptance].[REGNO], 
	[Acceptance].[ADATE], 
	[Acceptance].[LUSERID] as UserID, 
	[SysTab].[Currency], 
	[QPCalc].[TSI], 
	[QPCalc].[OurShare], 
	[QPCalc].[Gross], 
	[Acceptance].[ASTATUS], 
	[Acceptance].[ATYPE], 
	[Acceptance].[SDate], 
	[Acceptance].[EDate], 
	Year([Acceptance].[SDate]) AS RYear,
	Acceptance.ValueID,
        Acceptance.ValueDesc
FROM 
	Acceptance, 
	Cover, 
	SysTab, 
	QMasterAcceptance_PCalc() AS QPCalc, RArrHeader, GenDTab
WHERE 
	[Cover].[CNO]=[Acceptance].[CNO] 
	And [QPCalc].[ANO]=[Acceptance].[ANO] 
	And [Acceptance].[ANO]<>[Acceptance].[LANO] 
	And [Acceptance].[LANO]=@P_ANO
	And [RArrHeader].[Status]='A' 
	And [RArrHeader].[ANO]=[Acceptance].[ANO] 
	And Acceptance.REGID=@P_REGID
	And [Acceptance].[FLDID]=[GenDTab].[FLDID] 
	And [Acceptance].[ValueID]=[GenDTab].[ValueID] 
	And [GenDTab].[FLDID]=@P_FLDID 
	And [GenDTab].[ValueID] Like @P_ValueID + '%' 
	And ([GenDTab].[ValueID1] Like @P_ValueID1 + '%' or [GenDTab].[ValueDesc1] Like @P_ValueID1 + '%')
	And ([GenDTab].[ValueID2] Like @P_ValueID2 + '%' or [GenDTab].[ValueDesc2] Like @P_ValueID2 + '%')
	And ([GenDTab].[ValueID3] Like @P_ValueID3 + '%' or [GenDTab].[ValueDesc3] Like @P_ValueID3 + '%')
	And ([GenDTab].[ValueID4] Like @P_ValueID4 + '%' or [GenDTab].[ValueDesc4] Like @P_ValueID4 + '%')
	And ([GenDTab].[ValueID5] Like @P_ValueID5 + '%' or [GenDTab].[ValueDesc5] Like @P_ValueID5 + '%')
	And ([GenDTab].[ValueID6] Like @P_ValueID6 + '%' or [GenDTab].[ValueDesc6] Like @P_ValueID6 + '%')
)


GO

/****** Object:  UserDefinedFunction [dbo].[List16_Det]    Script Date: 12/21/2017 1:43:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[List16_Det]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [List16_Det] 
end
GO
CREATE FUNCTION  [dbo].[List16_Det]
 (@P_ANO as integer, @pSDate as smalldatetime,@pEDate as smalldatetime,@P_COB as varchar(10))  
RETURNS TABLE   
as RETURN(  
  
SELECT Cast(0 as bit) as ProcessFlag,  
 [Acceptance].[CertificateNo],   
 Acceptance.ESeqNo,  
 [Acceptance].[AName],   
 [Acceptance].[ANO],   
 [Acceptance].[REGNO],   
 [Acceptance].[ADATE],   
 [Acceptance].[LUSERID] as UserID,   
 [SysTab].[Currency],   
 [QPCalc].[TSI],   
 [QPCalc].[OurShare],   
 [QPCalc].[Gross],   
 [Acceptance].[ASTATUS],   
 [Acceptance].[ATYPE],   
 [Acceptance].[SDate],   
 [Acceptance].[EDate],   
 Year([Acceptance].[SDate]) AS RYear,  
 Acceptance.ValueID,  
        Acceptance.ValueDesc  
FROM   
 Acceptance,   
 Cover,   
 SysTab,   
 QMasterAcceptance_PCalc() AS QPCalc,  
 TOC  
WHERE   
 [Cover].[CNO]=[Acceptance].[CNO]   
 And Acceptance.TOC = TOC.TOC  
 And [QPCalc].[ANO]=[Acceptance].[ANO]   
 And [Acceptance].[ANO]<>[Acceptance].[LANO]   
 And [Acceptance].[LANO]=@P_ANO   
 And [Cover].[ISType]<>'T'   
 And [Acceptance].[ADate]>=@pSDate   
 And [Acceptance].[ADate]<=@pEDate  
 And TOC.TOC=Acceptance.TOC  
 And TOC.COB=@P_COB  
)  


GO

/****** Object:  UserDefinedFunction [dbo].[list16SC_Det]    Script Date: 12/21/2017 1:43:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[list16SC_Det]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [list16SC_Det] 
end
GO
CREATE FUNCTION  [dbo].[list16SC_Det]
 (@P_ANO as integer, @P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_COB as varchar(10),@P_ServiceNo as varchar(20))  
RETURNS Table  
AS RETURN(  
    
SELECT Cast(0 as bit) as ProcessFlag,  
 [Acceptance].[CertificateNo],  
 Acceptance.ESeqNo,  
 [Acceptance].[AName],  
 [Acceptance].[ANO],  
 [Acceptance].[REGNO],  
 [Acceptance].[ADATE],  
 [Acceptance].[LUSERID] as UserID,  
 [SysTab].[Currency],  
 [QPCalc].[TSI],  
 [QPCalc].[OurShare],  
 [QPCalc].[Gross],  
 [Acceptance].[ASTATUS],  
 [Acceptance].[ATYPE],  
 [Acceptance].[SDate],  
 [Acceptance].[EDate],  
 Year([acceptance].[SDate]) As RYear,  
 Acceptance.ValueID,  
 Acceptance.ValueDesc  
From  
 Acceptance,  
 Cover,  
 SysTab,  
 QMasterAcceptance_PCalc() AS QPCalc,  
 TOC,  
 Service  
Where  
 [cover].[CNO] = [acceptance].[CNO]  
 And [QPCalc].[ANO]=[Acceptance].[ANO]  
 And [Acceptance].[ANO]<>[Acceptance].[LANO]  
 And [Acceptance].[LANO]=@P_ANO  
 And Service.SType='CANCELLATION'  
 And Service.PANO=Acceptance.ANO  
 And Service.Cdate Between @P_Sdate and @P_EDate  
 And Service.SStatus='P'  
 And TOC.TOC=Acceptance.TOC  
 And TOC.COB Like @P_COB+'%'  
 And Service.ServiceNo Like @P_ServiceNo+'%'  
)  
    

GO

/****** Object:  UserDefinedFunction [dbo].[list16SD_Det]    Script Date: 12/21/2017 1:43:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[list16SD_Det]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [list16SD_Det] 
end
GO
CREATE FUNCTION  [dbo].[list16SD_Det]
 (@P_ANO as integer, @P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_COB as varchar(10),@P_ServiceNo as varchar(20))  
RETURNS Table  
AS RETURN(  
      
SELECT Cast(0 as bit) as ProcessFlag,  
 [Acceptance].[CertificateNo],  
 Acceptance.ESeqNo,  
 [Acceptance].[AName],  
 [Acceptance].[ANO],  
 [Acceptance].[REGNO],  
 [Acceptance].[ADATE],  
 [Acceptance].[LUSERID] as UserID,  
 [SysTab].[Currency],  
 [QPCalc].[TSI],  
 [QPCalc].[OurShare],  
 [QPCalc].[Gross],  
 [Acceptance].[ASTATUS],  
 [Acceptance].[ATYPE],  
 [Acceptance].[SDate],  
 [Acceptance].[EDate],  
 Year([acceptance].[SDate]) As RYear,  
 Acceptance.ValueID,  
 Acceptance.ValueDesc  
From  
 Acceptance,  
 Cover,  
 SysTab,  
 QMasterAcceptance_PCalc() AS QPCalc,  
 TOC,  
 Service  
Where  
 [cover].[CNO] = [acceptance].[CNO]  
 And [QPCalc].[ANO]=[Acceptance].[ANO]  
 And [Acceptance].[ANO]<>[Acceptance].[LANO]  
 And [Acceptance].[LANO]=@P_ANO  
 And ((Service.PANO=Acceptance.ANO and Service.SType<>'NEW') or (Service.ANO=Acceptance.ANO and Service.SType='NEW'))  
 And Service.Cdate Between @P_Sdate and @P_EDate  
 And Acceptance.AStatus='W'  
 And Service.SStatus='C'  
 And TOC.TOC=Acceptance.TOC  
 And TOC.COB Like @P_COB+'%'  
 And Service.ServiceNo Like @P_ServiceNo+'%'  
)  


GO

/****** Object:  UserDefinedFunction [dbo].[list16SE_Det]    Script Date: 12/21/2017 1:43:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[list16SE_Det]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [list16SE_Det] 
end
GO
CREATE FUNCTION  [dbo].[list16SE_Det]
 (@P_ANO as integer, @P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_COB as varchar(10),@P_ServiceNo as varchar(20))  
RETURNS Table  
AS RETURN(  
    
SELECT Cast(0 as bit) as ProcessFlag,  
 [Acceptance].[CertificateNo],  
 Acceptance.ESeqNo,  
 [Acceptance].[AName],  
 [Acceptance].[ANO],  
 [Acceptance].[REGNO],  
 [Acceptance].[ADATE],  
 [Acceptance].[LUSERID] as UserID,  
 [SysTab].[Currency],  
 [QPCalc].[TSI],  
 [QPCalc].[OurShare],  
 [QPCalc].[Gross],  
 [Acceptance].[ASTATUS],  
 [Acceptance].[ATYPE],  
 [Acceptance].[SDate],  
 [Acceptance].[EDate],  
 Year([acceptance].[SDate]) As RYear,  
 Acceptance.ValueID,  
 Acceptance.ValueDesc  
From  
 Acceptance,  
 Cover,  
 SysTab,  
 QMasterAcceptance_PCalc() AS QPCalc,  
 TOC,  
 Service  
Where  
 [cover].[CNO] = [acceptance].[CNO]  
 And [QPCalc].[ANO]=[Acceptance].[ANO]  
 And [Acceptance].[ANO]<>[Acceptance].[LANO]  
 And [Acceptance].[LANO]=@P_ANO  
 And Service.SType='ENDORSEMENT'  
 And Service.PANO=Acceptance.ANO  
 And Service.Cdate Between @P_Sdate and @P_EDate  
 And Service.SStatus='P'  
 And TOC.TOC=Acceptance.TOC  
 And TOC.COB Like @P_COB+'%'  
 And Service.ServiceNo Like @P_ServiceNo+'%'  
)  


GO

/****** Object:  UserDefinedFunction [dbo].[list16SL_Det]    Script Date: 12/21/2017 1:43:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[list16SL_Det]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [list16SL_Det] 
end
GO
CREATE FUNCTION  [dbo].[list16SL_Det]
(@P_ANO as integer, @P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_COB as varchar(10),@P_ServiceNo as varchar(20))  
RETURNS Table  
AS RETURN(  
      
SELECT Cast(0 as bit) as ProcessFlag,  
 [Acceptance].[CertificateNo],  
 Acceptance.ESeqNo,  
 [Acceptance].[AName],  
 [Acceptance].[ANO],  
 [Acceptance].[REGNO],  
 [Acceptance].[ADATE],  
 [Acceptance].[LUSERID] as UserID,  
 [SysTab].[Currency],  
 [QPCalc].[TSI],  
 [QPCalc].[OurShare],  
 [QPCalc].[Gross],  
 [Acceptance].[ASTATUS],  
 [Acceptance].[ATYPE],  
 [Acceptance].[SDate],  
 [Acceptance].[EDate],  
 Year([acceptance].[SDate]) As RYear,  
 Acceptance.ValueID,  
 Acceptance.ValueDesc  
From  
 Acceptance,  
 Cover,  
 SysTab,  
 QMasterAcceptance_PCalc() AS QPCalc,  
 TOC,  
 Service  
Where  
 [cover].[CNO] = [acceptance].[CNO]  
 And [QPCalc].[ANO]=[Acceptance].[ANO]  
 And [Acceptance].[ANO]<>[Acceptance].[LANO]  
 And [Acceptance].[LANO]=@P_ANO  
 And Service.SType='EXPIRED'  
 And Service.PANO=Acceptance.ANO  
 And Service.Cdate Between @P_Sdate and @P_EDate  
 And Service.SStatus='P'  
 And TOC.TOC=Acceptance.TOC  
 And TOC.COB Like @P_COB+'%'  
 And Service.ServiceNo Like @P_ServiceNo+'%'  
)  


GO

/****** Object:  UserDefinedFunction [dbo].[list16SR_Det]    Script Date: 12/21/2017 1:43:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[list16SR_Det]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [list16SR_Det] 
end
GO
CREATE FUNCTION  [dbo].[list16SR_Det]
 (@P_ANO as integer, @P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_COB as varchar(10),@P_ServiceNo as varchar(20))  
RETURNS Table  
AS RETURN(  
    
SELECT Cast(0 as bit) as ProcessFlag,  
 [Acceptance].[CertificateNo],  
 Acceptance.ESeqNo,  
 [Acceptance].[AName],  
 [Acceptance].[ANO],  
 [Acceptance].[REGNO],  
 [Acceptance].[ADATE],  
 [Acceptance].[LUSERID] as UserID,  
 [SysTab].[Currency],  
 [QPCalc].[TSI],  
 [QPCalc].[OurShare],  
 [QPCalc].[Gross],  
 [Acceptance].[ASTATUS],  
 [Acceptance].[ATYPE],  
 [Acceptance].[SDate],  
 [Acceptance].[EDate],  
 Year([acceptance].[SDate]) As RYear,  
 Acceptance.ValueID,  
 Acceptance.ValueDesc  
From  
 Acceptance,  
 Cover,  
 SysTab,  
 QMasterAcceptance_PCalc() AS QPCalc,  
 TOC,  
 Service  
Where  
 [cover].[CNO] = [acceptance].[CNO]  
 And [QPCalc].[ANO]=[Acceptance].[ANO]  
 And [Acceptance].[ANO]<>[Acceptance].[LANO]  
 And [Acceptance].[LANO]=@P_ANO  
 And Service.SType='RENEWAL'  
 And Service.PANO=Acceptance.ANO  
 And Service.Cdate Between @P_Sdate and @P_EDate  
 And Service.SStatus='P'  
 And TOC.TOC=Acceptance.TOC  
 And TOC.COB Like @P_COB+'%'  
 And Service.ServiceNo Like @P_ServiceNo+'%'  
)  

GO

/****** Object:  UserDefinedFunction [dbo].[List17_Det]    Script Date: 12/21/2017 1:43:28 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[List17_Det]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [List17_Det] 
end
GO
CREATE FUNCTION  [dbo].[List17_Det]

(@P_ANO as integer, @pSDate as smalldatetime,@pEDate as smalldatetime,@P_SEGMENT as varchar(10))
RETURNS TABLE
as RETURN(

SELECT Cast(0 as bit) as ProcessFlag,
	[Acceptance].[CertificateNo], 
	Acceptance.ESeqNo,
	[Acceptance].[AName], 
	[Acceptance].[ANO], 
	[Acceptance].[REGNO], 
	[Acceptance].[ADATE], 
	[Acceptance].[LUSERID] as UserID, 
	[SysTab].[Currency], 
	[QPCalc].[TSI], 
	[QPCalc].[OurShare], 
	[QPCalc].[Gross], 
	[Acceptance].[ASTATUS], 
	[Acceptance].[ATYPE], 
	[Acceptance].[SDate], 
	[Acceptance].[EDate], 
	Year([Acceptance].[SDate]) AS RYear,
	Acceptance.ValueID,
        Acceptance.ValueDesc
FROM 
	Acceptance, 
	Cover, 
	SysTab, 
	QMasterAcceptance_PCalc() AS QPCalc
WHERE 
	[Cover].[CNO]=[Acceptance].[CNO] 
	And [QPCalc].[ANO]=[Acceptance].[ANO] 
	And [Acceptance].[ANO]<>[Acceptance].[LANO] 
	And [Acceptance].[LANO]=@P_ANO 
	And [Cover].[ISType]<>'T' 
	And [Acceptance].[ADate]>=@pSDate 
	And [Acceptance].[ADate]<=@pEDate
	And Cover.Segment=@P_SEGMENT
)

GO

/****** Object:  UserDefinedFunction [dbo].[List18_Det]    Script Date: 12/21/2017 1:43:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[List18_Det]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [List18_Det] 
end
GO
CREATE FUNCTION  [dbo].[List18_Det]
 (@P_ANO as integer, @P_UserID as varchar(10), @P_TOC as varchar(10), @P_Branch as varchar(10), @P_PDate as smalldatetime)      
RETURNS Table      
AS RETURN(      
          
SELECT Cast(0 as bit) as ProcessFlag,     
 [Acceptance].[CertificateNo],      
 Acceptance.ESeqNo,      
 [Acceptance].[AName],      
 [Acceptance].[ANO],      
 [Acceptance].[REGNO],      
 [Acceptance].[ADATE],      
 [Acceptance].[LUSERID] as UserID,      
 [SysTab].[Currency],      
 [QPCalc].[TSI],      
 [QPCalc].[OurShare],      
 [QPCalc].[Gross],      
 [Acceptance].[ASTATUS],      
 [Acceptance].[ATYPE],      
 [Acceptance].[SDate],      
 [Acceptance].[EDate],      
 Year([acceptance].[SDate]) As RYear,  
 Acceptance.ValueID,  
 Acceptance.ValueDesc      
From      
 Acceptance,      
 Cover,      
 SysTab,      
 QMasterAcceptance_PCalc() As QPCalc,      
 SysUserTOC,     
 SysUserBranch    
Where      
 [cover].[CNO] = [acceptance].[CNO]      
 And [QPCalc].[ANO]=[Acceptance].[ANO]      
 And [Acceptance].[ANO]<>[Acceptance].[LANO]      
 And [Acceptance].[LANO]=@P_ANO      
 And [Acceptance].[AStatus]='I'      
 And Acceptance.AType Not in ('C','A')      
And [Cover].[ISType]<>'T'      
AND @P_PDate between Acceptance.PDate and Acceptance.PPDate      
 And SysUserTOC.ID=@P_UserID and Acceptance.TOC=SysUserTOC.TOC and (SysUserTOC.TOC=@P_TOC or @P_TOC='')    
 And SysUserBranch.ID=@P_UserID and Acceptance.BRanch=SysUserBranch.Branch and (SysUserBranch.Branch=@P_Branch or @P_Branch='')    
 And Acceptance.ANO in (SELECT ANO from Claim, CLLOSS Where (Claim.CSTATUS IN ('R','P','T','A') OR Claim.PCSTATUS IN ('A')) and Claim.CNO=CLLOSS.CNO and CLLOSS.CTLF=1 And Claim.ANO=Acceptance.ANO)      
)      
                 

GO

/****** Object:  UserDefinedFunction [dbo].[List19_Det]    Script Date: 12/21/2017 1:43:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[List19_Det]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [List19_Det] 
end
GO
CREATE FUNCTION  [dbo].[List19_Det]
(@P_ANO as integer, @P_Days as smallint, @P_Date as Smalldatetime,@P_COB as varchar(10),@P_Branch as varchar(10), @P_UnPaidOpt as Bit)   
RETURNS TABLE   
as RETURN(   
   
SELECT Cast(0 as bit) as ProcessFlag,   
[Acceptance].[CertificateNo],   
Acceptance.ESeqNo,   
[Acceptance].[AName],   
[Acceptance].[ANO],   
[Acceptance].[REGNO],   
[Acceptance].[ADATE],   
[Acceptance].[LUSERID] as UserID,   
[SysTab].[Currency],   
[QPCalc].[TSI],   
[QPCalc].[OurShare],   
[QPCalc].[Gross],   
[Acceptance].[ASTATUS],   
[Acceptance].[ATYPE],   
[Acceptance].[SDate],   
[Acceptance].[EDate],   
Year([Acceptance].[SDate]) AS RYear,   
Acceptance.ValueID,   
Acceptance.ValueDesc   
   
FROM   
Acceptance,   
Cover,   
SysTab,   
QMasterAcceptance_PCalc() AS QPCalc,   
TOC   
WHERE   
[Cover].[CNO]=[Acceptance].[CNO]   
And TOC.TOC=Acceptance.TOC and TOC.COB=@P_COB And Acceptance.Branch Like @P_Branch+'%'   
And [QPCalc].[ANO]=[Acceptance].[ANO]   
And [Acceptance].[ANO]<>[Acceptance].[LANO]   
And [Acceptance].[LANO]=@P_ANO   
And [Cover].[ISType]<>'T'   
And Acceptance.AStatus='I'  And Acceptance.AType<>'C'   
And EXISTS (SELECT A1.OANO from Acceptance A1, AccAss, Admlink, nVoucher Voucher Where A1.ANO=AccAss.ANO and A1.OANO=Acceptance.OANO and Voucher.Voucher=Admlink.Voucher and Admlink.AdmNo=AccAss.AdmNo and AccAss.Type in ('DI','IC','IR') and Voucher.nDueDate+@P_Days<@P_Date and Voucher.Nominal_CC-Voucher.Diff_CC-Voucher.Payment_CC-Voucher.Payment_OC<>0 and (@P_UnPaidOpt=0 or Voucher.Payment_CC=0))   
)  


GO

/****** Object:  UserDefinedFunction [dbo].[List20_Det]    Script Date: 12/21/2017 1:43:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[List20_Det]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [List20_Det] 
end
GO
CREATE FUNCTION  [dbo].[List20_Det]
(@P_ANO as integer, @P_USERID as varchar(255), @P_SDate as smalldatetime, @P_EDate as smalldatetime, @P_AStatus as varchar(1)) 
RETURNS TABLE 
AS RETURN( 
 
SELECT 
Cast(0 as bit) as ProcessFlag, 
[Acceptance].[CertificateNo], 
Acceptance.ESeqNo, 
[Acceptance].[AName], 
[Acceptance].[ANO], 
[Acceptance].[REGNO], 
[Acceptance].[ADATE], 
[Acceptance].[LUSERID] as UserID, 
[SysTab].[Currency], 
[Acceptance].[ASTATUS], 
[Acceptance].[ATYPE], 
[Acceptance].[SDate], 
[Acceptance].[EDate], 
Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
Acceptance.ValueID, 
Acceptance.ValueDesc, 
QPCalc.TSI, 
QPCalc.OurShare, 
QPCalc.Gross 
FROM 
Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) 
Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), 
Cover, 
SysTab 
WHERE 
[Cover].[CNO]=[Acceptance].[CNO] 
And [Acceptance].[ANO]<>[Acceptance].[LANO] 
And [Acceptance].[LANO]=@P_ANO 
And [Cover].[ISType]<>'T' 
And [Acceptance].[LUserID] Like @P_UserID 
And [Acceptance].[LDate] between @P_SDate and @P_EDate 
And ([Acceptance].AStatus=@P_AStatus or @P_AStatus='') 
) 
 
 

GO

/****** Object:  UserDefinedFunction [dbo].[List21_Det]    Script Date: 12/21/2017 1:43:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[List21_Det]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [List21_Det] 
end
GO
CREATE FUNCTION  [dbo].[List21_Det]
(@P_ANO as integer,@P_UserID varchar(255)) 
RETURNS TABLE 
AS RETURN( 
 
SELECT Cast(0 as bit) as ProcessFlag, 
[Acceptance].[CertificateNo], 
Acceptance.ESeqNo, 
[Acceptance].[AName], 
[Acceptance].[ANO], 
[Acceptance].[REGNO], 
[Acceptance].[ADATE], 
[Acceptance].[LUSERID] as UserID, 
[SysTab].[Currency], 
[QPCalc].[TSI], 
[QPCalc].[OurShare], 
[QPCalc].[Gross], 
[Acceptance].[ASTATUS], 
[Acceptance].[ATYPE], 
[Acceptance].[SDate], 
[Acceptance].[EDate], 
Year([Acceptance].[SDate]) AS RYear, 
Acceptance.ValueID, 
Acceptance.ValueDesc 
FROM 
Acceptance, 
Cover, 
SysTab, 
QMasterAcceptance_PCalc() AS QPCalc 
WHERE 
[Cover].[CNO]=[Acceptance].[CNO] 
And [QPCalc].[ANO]=[Acceptance].[ANO] 
And [Acceptance].[ANO]<>[Acceptance].[LANO] 
And [Acceptance].[LANO]=@P_ANO 
And [Acceptance].[RequestF]=1 and Acceptance.RequestName Like @P_UserID 
) 
 
 

GO

/****** Object:  UserDefinedFunction [dbo].[List22_Det]    Script Date: 12/21/2017 1:43:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[List21_Det]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [List22_Det] 
end
GO
CREATE FUNCTION  [dbo].[List22_Det]

(@P_ANO as integer,@P_SDate as smalldatetime, @P_EDate as smalldatetime)
RETURNS Table
AS RETURN(
    
SELECT Cast(0 as bit) as ProcessFlag,
 Acceptance.CertificateNo,
 Acceptance.ESeqNo,
 Cast(Acceptance.AName as varchar(128)) as AName,
 Acceptance.ANO,
 Acceptance.REGNO,
 Acceptance.ADATE,
 Acceptance.LUSERID as UserID,
 SysTab.Currency,
 QPCalc.TSI,
 QPCalc.OurShare,
 QPCalc.Gross,
 Acceptance.ASTATUS,
 Acceptance.ATYPE,
 Acceptance.SDate,
 Acceptance.EDate,
 Year(Acceptance.SDate) AS RYear,
 Acceptance.ValueID,
 Acceptance.ValueDesc
From
 Acceptance,
 Cover,
 SysTab,
 QMasterAcceptance_PCalc() AS QPCalc,
 RARRHEADER
Where
 cover.CNO = acceptance.CNO
 And Rarrheader.ANO = Acceptance.ANO
 And QPCalc.ANO=Acceptance.ANO
 And Acceptance.ANO<>Acceptance.LANO
 And Acceptance.LANO=@P_ANO
 And Acceptance.AStatus='I'
)
   
GO

/****** Object:  UserDefinedFunction [dbo].[ListSR_Det]    Script Date: 12/21/2017 1:43:28 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
iF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ListSR_Det]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [ListSR_Det] 
end
GO
CREATE FUNCTION  [dbo].[ListSR_Det]
(@P_ANO AS INTEGER, @value1 as varchar(255) ,@value2 as varchar(255) ,@value3 as varchar(255) ,@value4 as varchar(255) ,@value5 as varchar(255) ,@value6 as varchar(255) ,@Value7 as varchar(255) ,@value8 as varchar(255) ,@value9 as varchar(255),@Value10 as varchar(255), @Value11 as varchar(255))    
returns table    
AS return    
(    
SELECT     
 Cast(0 as bit) as ProcessFlag,     
 Cover.COVERNO,     
 Cast(Acceptance.AName as varchar(128)) as AName,     
 Acceptance.CertificateNo,     
 Cover.CNO,     
 Cover.CStatus,     
 Cover.VSeqNo,     
 Acceptance.LANO,     
 Acceptance.ANO,     
 Acceptance.REGNO,     
 Acceptance.ADATE,     
 Acceptance.USERID,     
 SysTab.Currency,     
 QPCalc.TSI,     
 QPCalc.OurShare,     
 QPCalc.Gross,     
 Acceptance.ASTATUS,     
 Acceptance.ATYPE,     
 Acceptance.SDate,     
 Acceptance.EDate,     
 Year(RArrheader.Rdate) AS RYear    
FROM     
 Acceptance,     
 Cover,     
 RArrHeader,     
 SysTab,     
 QMasterAcceptance_PCalc() AS QPCalc,    
 Profile    
WHERE     
 Cover.CNO=Acceptance.CNO     
 And RArrHeader.ANO=Acceptance.ANO     
 And QPCalc.ANO=Acceptance.ANO     
 And Acceptance.ANO<>Acceptance.LANO     
 And Acceptance.LANO=@P_ANO    
  And Cover.PHOLDER=Profile.ID    
 And (Cover.Insured Like @Value1 Or (Cover.Insured is null))     
 And (Cover.CoverNo Like @Value2 Or (Cover.CoverNo is null))     
 And (cover.coverdate=@Value3 Or (cover.coverdate IS NULL) Or cover.coverdate='' or @Value3='')    
 And (cover.expdate=@Value4 Or (cover.expdate IS NULL) Or cover.expdate='' or @Value4='')      
 And (Acceptance.PolicyNo Like @Value5 Or (Acceptance.PolicyNo is null))     
 And (Acceptance.CertificateNo Like @Value6 Or (Acceptance.CertificateNo is null))     
 And (acceptance.policydate=@Value7 Or (acceptance.policydate IS NULL) Or acceptance.policydate='' or @Value7='')    
 And (Cover.CStatus Like @Value8)     
 And (Acceptance.RegNo Like @Value9)     
 And (Profile.Name like @Value10 or Profile.Name is null)    
 and Acceptance.toc like @Value11    
 And Cover.ISType<>'T'    
)  

GO


/****** Object:  StoredProcedure [dbo].[CLLIST01]    Script Date: 12/21/2017 1:40:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[CLLIST01]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [CLLIST01]
end
GO
create PROCEDURE [dbo].[CLLIST01](@P_dbUser as varchar(10)) AS
SELECT  Cast(0 as bit) as ProcessFlag,
 [CLAIM].[CLAIMNO],
 [CLAIM].[REGDATE],
 [CLAIM].[REFNO],
 [CLAIM].[COL],
 [COLTAB].[DESCRIPTION],
 [CLAIM].[LOSSDATE],
 [CLAIM].[TOC],
 [CLAIM].[CSDATE],
 [CLAIM].[LOSSPLACE],
 [CLAIM].[CTYPE],
 [CLAIM].[CSTATUS],
 [CLAIM].[CNO],
 [CLAIM].[ANO],
 [CLAIM].[PCNO],
 [CLAIM].[LUSERID] + '/' + [CLAIM].[AUSERID] AS USERID,
 [SYSTAB].[CURRENCY],
 [CCALC].[LOSS] AS ESTIMATE,
 [CCALC].[CLAIM] AS CLAIM,
 [CCALC].[DEDUCTIBLE] AS DEDUCTIBLE,
 [CCALC].[SALVAGE] AS SALVAGE,
 [CCALC].[COST] AS COST,
 [CCALC].[SUBROGATION] AS SUBROGATION,
 ([CARRHEADER].[TAMOUNT]-[CARRHEADER].[RAMOUNT]) AS RECOVERIES,
 [CLAIM].[VSEQNO],
 [CLAIM].[CSEQNO],
 Cast(Acceptance.AName as varchar(128)) as AName,
 CLAIM.POLICYNO,
 CLAIM.CERTIFICATENO,
 CLAIM.SETTLEDF
FROM  CLAIM LEFT JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO), QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB
Where [CARRHEADER].[CNO] = [CLAIM].[CNO]
 And [CCALC].[CNO]=[CLAIM].[CNO]
 And CLAIM.COL=COLTAB.COL
 And [CLAIM].[CSTATUS]='R'
 AND CLAIM.LUSERID LIKE @P_DBUSER



GO

/****** Object:  StoredProcedure [dbo].[CLLIST02]    Script Date: 12/21/2017 1:40:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[CLLIST02]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [CLLIST02]
end
GO
create PROCEDURE [dbo].[CLLIST02]

(@pSDate as smalldatetime,@pEDate as smalldatetime)
AS
SELECT Cast(0 as bit) as ProcessFlag,
 [CLAIM].[CLAIMNO],
 [CLAIM].[REGDATE],
 [CLAIM].[REFNO],
 [CLAIM].[COL],
 [COLTAB].[DESCRIPTION],
 [CLAIM].[LOSSDATE],
 [CLAIM].[TOC],
 [CLAIM].[CSDATE],
 [CLAIM].[LOSSPLACE],
 [CLAIM].[CTYPE],
 [CLAIM].[CSTATUS],
 [CLAIM].[CNO],
 [CLAIM].[ANO],
 [CLAIM].[PCNO],
 [CLAIM].[LUSERID] + '/' + [CLAIM].[AUSERID] as USERID,
 [SYSTAB].[CURRENCY],
 [CCALC].[LOSS] AS ESTIMATE,
 [CCALC].[CLAIM] AS CLAIM,
 [CCALC].[DEDUCTIBLE] AS DEDUCTIBLE,
 [CCALC].[SALVAGE] AS SALVAGE,
 [CCALC].[COST] AS COST,
 [CCALC].[SUBROGATION] AS SUBROGATION,
 ([CARRHEADER].[TAMOUNT]-[CARRHEADER].[RAMOUNT]) AS RECOVERIES,
 [CLAIM].[VSEQNO],
 [CLAIM].[CSEQNO],
 Cast(Acceptance.AName as varchar(128)) as AName,
 acceptance.policyno,
 acceptance.certificateno,
 CLAIM.SETTLEDF
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance
Where [CARRHEADER].[CNO] = [CLAIM].[CNO]
 And [CCALC].[CNO]=[CLAIM].[CNO]
 And [CLAIM].[CSTATUS]='A'
 And CLAIM.SETTLEDF=1
 And CLAIM.COL=COLTAB.COL
 And [CLAIM].[CSDATE] Between @pSDATE And @pEDATE
 and acceptance.ano = claim.ano



GO

/****** Object:  StoredProcedure [dbo].[CLLIST02_1]    Script Date: 12/21/2017 1:40:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[CLLIST02_1]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [CLLIST02_1]
end
GO
create PROCEDURE [dbo].[CLLIST02_1]

(@pSDate as smalldatetime,@pEDate as smalldatetime,@pBranch as varchar(10))    
AS    
SELECT Cast(0 as bit) as ProcessFlag,    
[CLAIM].[CLAIMNO],    
[CLAIM].[REGDATE],    
[CLAIM].[REFNO],    
[CLAIM].[COL],    
[COLTAB].[DESCRIPTION],    
[CLAIM].[LOSSDATE],    
[CLAIM].[TOC],    
[CLAIM].[CSDATE],    
[CLAIM].[LOSSPLACE],    
[CLAIM].[CTYPE],    
[CLAIM].[CSTATUS],    
[CLAIM].[CNO],    
[CLAIM].[ANO],    
[CLAIM].[PCNO],    
[CLAIM].[LUSERID] + '/' + [CLAIM].[AUSERID] as USERID,    
[SYSTAB].[CURRENCY],    
[CCALC].[LOSS] AS ESTIMATE,    
[CCALC].[CLAIM] AS CLAIM,    
[CCALC].[DEDUCTIBLE] AS DEDUCTIBLE,    
[CCALC].[SALVAGE] AS SALVAGE,    
[CCALC].[COST] AS COST,    
[CCALC].[SUBROGATION] AS SUBROGATION,    
([CARRHEADER].[TAMOUNT]-[CARRHEADER].[RAMOUNT]) AS RECOVERIES,    
[CLAIM].[VSEQNO],    
[CLAIM].[CSEQNO],    
Cast(Acceptance.AName as varchar(128)) as AName,    
acceptance.policyno,    
acceptance.certificateno,    
CLAIM.SETTLEDF    
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance    
Where [CARRHEADER].[CNO] = [CLAIM].[CNO]    
And [CCALC].[CNO]=[CLAIM].[CNO]    
And [CLAIM].[CSTATUS]='A'    
And CLAIM.SETTLEDF=1    
And CLAIM.COL=COLTAB.COL    
And [CLAIM].[CSDATE] Between @pSDATE And @pEDATE    
And [Claim].[Branch] like @pBranch+'%'  
and acceptance.ano = claim.ano    





GO

/****** Object:  StoredProcedure [dbo].[CLLIST03]    Script Date: 12/21/2017 1:40:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[CLLIST03]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [CLLIST03]
end
GO
create PROCEDURE [dbo].[CLLIST03]

 AS
SELECT Cast(0 as bit) as ProcessFlag,
 [CLAIM].[CLAIMNO],
 [CLAIM].[REGDATE],
 [CLAIM].[REFNO],
 [CLAIM].[COL],
 [COLTAB].[DESCRIPTION],
 [CLAIM].[LOSSDATE],
 [CLAIM].[TOC],
 [CLAIM].[CSDATE],
 [CLAIM].[LOSSPLACE],
 [CLAIM].[CTYPE],
 [CLAIM].[CSTATUS],
 [CLAIM].[CNO],
 [CLAIM].[ANO],
 [CLAIM].[PCNO],
 [CLAIM].[LUSERID] + '/' + [CLAIM].[AUSERID] as USERID,
 [SYSTAB].[CURRENCY],
 [CCALC].[LOSS] AS ESTIMATE,
 [CCALC].[CLAIM] AS CLAIM,
 [CCALC].[DEDUCTIBLE] AS DEDUCTIBLE,
 [CCALC].[SALVAGE] AS SALVAGE,
 [CCALC].[COST] AS COST,
 [CCALC].[SUBROGATION] AS SUBROGATION,
 ([CARRHEADER].[TAMOUNT]-[CARRHEADER].[RAMOUNT]) AS RECOVERIES,
 [CLAIM].[VSEQNO],
 [CLAIM].[CSEQNO],
 Cast(Acceptance.AName as varchar(128)) as AName,
 acceptance.policyno,
 acceptance.certificateno,
 CLAIM.SETTLEDF
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance
Where [CARRHEADER].[CNO] = [CLAIM].[CNO]
 And [CCALC].[CNO]=[CLAIM].[CNO]
 And CLAIM.COL=COLTAB.COL
 And [CLAIM].[CSTATUS]='T'
 and acceptance.ano=claim.ano




GO

/****** Object:  StoredProcedure [dbo].[CLLIST04]    Script Date: 12/21/2017 1:40:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[CLLIST04]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [CLLIST04]
end
GO
create PROCEDURE [dbo].[CLLIST04]

(@P_DBUSER AS varchar(10)) AS
SELECT Cast(0 as bit) as ProcessFlag,
 [CLAIM].[CLAIMNO],
 [CLAIM].[REGDATE],
 [CLAIM].[REFNO],
 [CLAIM].[COL],
 [COLTAB].[DESCRIPTION],
 [CLAIM].[LOSSDATE],
 [CLAIM].[TOC],
 [CLAIM].[CSDATE],
 [CLAIM].[LOSSPLACE],
 [CLAIM].[CTYPE],
 [CLAIM].[CSTATUS],
 [CLAIM].[CNO],
 [CLAIM].[ANO],
 [CLAIM].[PCNO],
 [CLAIM].[LUSERID] + '/' + [CLAIM].[AUSERID] as USERID,
 [SYSTAB].[CURRENCY],
 [CCALC].[LOSS] AS ESTIMATE,
 [CCALC].[CLAIM] AS CLAIM,
 [CCALC].[DEDUCTIBLE] AS DEDUCTIBLE,
 [CCALC].[SALVAGE] AS SALVAGE,
 [CCALC].[COST] AS COST,
 [CCALC].[SUBROGATION] AS SUBROGATION,
 ([CARRHEADER].[TAMOUNT]-[CARRHEADER].[RAMOUNT]) AS RECOVERIES,
 [CLAIM].[VSEQNO],
 [CLAIM].[CSEQNO],
 Cast(Acceptance.AName as varchar(128)) as AName,
 CLAIM.POLICYNO,
 CLAIM.CERTIFICATENO,
 CLAIM.SETTLEDF
FROM  CLAIM LEFT JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO), QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB
Where [CARRHEADER].[CNO] = [CLAIM].[CNO]
 And [CCALC].[CNO]=[CLAIM].[CNO]
 And CLAIM.COL=COLTAB.COL
 And [CLAIM].[CSTATUS]='P'
 AND CLAIM.LUSERID LIKE @P_DBUSER



GO

/****** Object:  StoredProcedure [dbo].[CLLIST05]    Script Date: 12/21/2017 1:40:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[CLLIST05]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [CLLIST05]
end
GO
create PROCEDURE [dbo].[CLLIST05]
 AS
SELECT Cast(0 as bit) as ProcessFlag,
 CLAIM.CLAIMNO,
 CLAIM.REGDATE,
 CLAIM.REFNO,
 CLAIM.COL,
 COLTAB.DESCRIPTION,
 CLAIM.LOSSDATE,
 CLAIM.TOC,
 CLAIM.CSDATE,
 CLAIM.LOSSPLACE,
 CLAIM.CTYPE,
 CLAIM.CSTATUS,
 CLAIM.CNO,
 CLAIM.ANO,
 CLAIM.PCNO,
 CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,
 SYSTAB.CURRENCY,
 CCALC.LOSS AS ESTIMATE,
 CCALC.CLAIM AS CLAIM,
 CCALC.DEDUCTIBLE AS DEDUCTIBLE,
 CCALC.SALVAGE AS SALVAGE,
 CCALC.COST AS COST,
 CCALC.SUBROGATION AS SUBROGATION,
 (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,
 CLAIM.VSEQNO,
 CLAIM.CSEQNO,
 Cast(Acceptance.AName as varchar(128)) as AName,
 acceptance.policyno,
 acceptance.certificateno,
 CLAIM.SETTLEDF
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance
Where CARRHEADER.CNO = CLAIM.CNO
 And CCALC.CNO=CLAIM.CNO
 And CLAIM.COL=COLTAB.COL
 And acceptance.ano=claim.ano
 And CLAIM.REGDATE<=getdate() AND CLAIM.CTYPE<>'C' AND CLAIM.CSTATUS<>'R' AND
 ((CLAIM.SETTLEDF=0 AND CLAIM.CSDATE<=getdate() AND CLAIM.CSTATUS<>'C') OR
              (CLAIM.PSETTLEDF=0 AND CLAIM.CSDATE>getdate() AND (CLAIM.SETTLEDF=0 OR CLAIM.ADATE>getdate())))
  


GO

/****** Object:  StoredProcedure [dbo].[CLLIST06]    Script Date: 12/21/2017 1:40:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[CLLIST06]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [CLLIST06]
end
GO
create PROCEDURE [dbo].[CLLIST06]

AS
SELECT Cast(0 as bit) as ProcessFlag,
 CLAIM.CLAIMNO,
 CLAIM.REGDATE,
 CLAIM.REFNO,
 CLAIM.COL,
 COLTAB.DESCRIPTION,
 CLAIM.LOSSDATE,
 CLAIM.TOC,
 CLAIM.CSDATE,
 CLAIM.LOSSPLACE,
 CLAIM.CTYPE,
 CLAIM.CSTATUS,
 CLAIM.CNO,
 CLAIM.ANO,
 CLAIM.PCNO,
 CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,
 SYSTAB.CURRENCY,
 CCALC.LOSS AS ESTIMATE,
 CCALC.CLAIM AS CLAIM,
 CCALC.DEDUCTIBLE AS DEDUCTIBLE,
 CCALC.SALVAGE AS SALVAGE,
 CCALC.COST AS COST,
 CCALC.SUBROGATION AS SUBROGATION,
 (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,
 CLAIM.VSEQNO,
 CLAIM.CSEQNO,
 Cast(Acceptance.AName as varchar(128)) as AName,
 CLAIM.POLICYNO,
 CLAIM.CERTIFICATENO,
 CLAIM.SETTLEDF
FROM  CLAIM LEFT JOIN COLTAB ON (COLTAB.COL=CLAIM.COL) LEFT JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO), QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER
Where CARRHEADER.CNO = CLAIM.CNO
 And CCALC.CNO=CLAIM.CNO
 And (CLAIM.TBAF_1=1 Or CLAIM.TBAF_2=1)
  


GO

/****** Object:  StoredProcedure [dbo].[CLLIST07]    Script Date: 12/21/2017 1:40:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[CLLIST07]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [CLLIST07]
end
GO
create PROCEDURE [dbo].[CLLIST07]
 (@P_EVENTNO AS varchar(255),@P_RYEAR AS INTEGER)
AS
SELECT Cast(0 as bit) as ProcessFlag,
 [CLAIM].[CLAIMNO],
  [CLAIM].[REGDATE],
  [CLAIM].[REFNO],
  [CLAIM].[COL],
  [COLTAB].[DESCRIPTION],
  [CLAIM].[LOSSDATE],
  [CLAIM].[TOC],
  [CLAIM].[CSDATE],
  [CLAIM].[LOSSPLACE],
  [CLAIM].[CTYPE],
  [CLAIM].[CSTATUS],
  [CLAIM].[CNO],
  [CLAIM].[ANO],
  [CLAIM].[PCNO],
  [CLAIM].[LUSERID] + '/' + CLAIM.AUSERID as USERID,
  [SYSTAB].[CURRENCY],
  [CCALC].[LOSS] AS ESTIMATE,
  [CCALC].[CLAIM] AS CLAIM,
  [CCALC].[DEDUCTIBLE] AS DEDUCTIBLE,
  [CCALC].[SALVAGE] AS SALVAGE,
  [CCALC].[COST] AS COST,
  [CCALC].[SUBROGATION] AS SUBROGATION,
  ([CARRHEADER].[TAMOUNT]-[CARRHEADER].[RAMOUNT]) AS RECOVERIES,
  [CLAIM].[VSEQNO],
  [CLAIM].[CSEQNO],
  Cast(Acceptance.AName as varchar(128)) as AName,
  acceptance.policyno,
  acceptance.certificateno,
  CLAIM.SETTLEDF
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance
Where [CARRHEADER].[CNO] = [CLAIM].[CNO]
  And [CCALC].[CNO]=[CLAIM].[CNO]
  And CLAIM.COL=COLTAB.COL
  And [CLAIM].[EVENTNO]=@P_EVENTNO
  And YEAR([CARRHEADER].[RDATE])=@P_RYEAR
  And [CARRHEADER].[STATUS]='A'
  and acceptance.ano = claim.ano
  


GO

/****** Object:  StoredProcedure [dbo].[CLLIST08]    Script Date: 12/21/2017 1:40:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[CLLIST08]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [CLLIST08]
end
GO
create PROCEDURE [dbo].[CLLIST08]
 AS
SELECT Cast(0 as bit) as ProcessFlag,
 [CLAIM].[CLAIMNO],
 [CLAIM].[REGDATE],
 [CLAIM].[REFNO],
 [CLAIM].[COL],
 [COLTAB].[DESCRIPTION],
 [CLAIM].[LOSSDATE],
 [CLAIM].[TOC],
 [CLAIM].[CSDATE],
 [CLAIM].[LOSSPLACE],
 [CLAIM].[CTYPE],
 [CLAIM].[CSTATUS],
 [CLAIM].[CNO],
 [CLAIM].[ANO],
 [CLAIM].[PCNO],
 [CLAIM].[LUSERID] + '/' + [CLAIM].[AUSERID] as USERID,
 [SYSTAB].[CURRENCY],
 [CCALC].[LOSS] AS ESTIMATE,
 [CCALC].[CLAIM] AS CLAIM,
 [CCALC].[DEDUCTIBLE] AS DEDUCTIBLE,
 [CCALC].[SALVAGE] AS SALVAGE,
 [CCALC].[COST] AS COST,
 [CCALC].[SUBROGATION] AS SUBROGATION,
 ([CARRHEADER].[TAMOUNT]-[CARRHEADER].[RAMOUNT]) AS RECOVERIES,
 [CLAIM].[VSEQNO],
 [CLAIM].[CSEQNO],
 Cast(Acceptance.AName as varchar(128)) as AName,
 acceptance.policyno,
 acceptance.certificateno,
 CLAIM.SETTLEDF
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance
Where [CARRHEADER].[CNO] = [CLAIM].[CNO]
 And [CCALC].[CNO]=[CLAIM].[CNO]
 And CLAIM.COL=COLTAB.COL
 And [CLAIM].[CSTATUS]='A'
 And Claim.Settledf=0
 and acceptance.ano = claim.ano



GO

/****** Object:  StoredProcedure [dbo].[CLLIST09]    Script Date: 12/21/2017 1:40:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[CLLIST09]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [CLLIST09]
end
GO
create PROCEDURE [dbo].[CLLIST09]

 AS
SELECT Cast(0 as bit) as ProcessFlag,
 [CLAIM].[CLAIMNO],
 [CLAIM].[REGDATE],
 [CLAIM].[REFNO],
 [CLAIM].[COL],
 [COLTAB].[DESCRIPTION],
 [CLAIM].[LOSSDATE],
 [CLAIM].[TOC],
 [CLAIM].[CSDATE],
 [CLAIM].[LOSSPLACE],
 [CLAIM].[CTYPE],
 [CLAIM].[CSTATUS],
 [CLAIM].[CNO],
 [CLAIM].[ANO],
 [CLAIM].[PCNO],
 [CLAIM].[LUSERID] + '/' + [CLAIM].[AUSERID] as USERID,
 [SYSTAB].[CURRENCY],
 [CCALC].[LOSS] AS ESTIMATE,
 [CCALC].[CLAIM] AS CLAIM,
 [CCALC].[DEDUCTIBLE] AS DEDUCTIBLE,
 [CCALC].[SALVAGE] AS SALVAGE,
 [CCALC].[COST] AS COST,
 [CCALC].[SUBROGATION] AS SUBROGATION,
 ([CARRHEADER].[TAMOUNT]-[CARRHEADER].[RAMOUNT]) AS RECOVERIES,
 [CLAIM].[VSEQNO],
 [CLAIM].[CSEQNO],
 Cast(Acceptance.AName as varchar(128)) as AName,
 acceptance.policyno,
 acceptance.certificateno,
 CLAIM.SETTLEDF
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance
Where [CARRHEADER].[CNO] = [CLAIM].[CNO]
 And [CCALC].[CNO]=[CLAIM].[CNO]
 And CLAIM.COL=COLTAB.COL
 And [CLAIM].[CSTATUS]='P'
 And [CLAIM].[VSEQNO]<>0
 and acceptance.ano = claim.ano
  


GO

/****** Object:  StoredProcedure [dbo].[CLLIST10]    Script Date: 12/21/2017 1:40:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[CLLIST10]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [CLLIST10]
end
GO
create PROCEDURE [dbo].[CLLIST10]
 AS
SELECT Cast(0 as bit) as ProcessFlag,
 CLAIM.CLAIMNO,
 CLAIM.REGDATE,
 CLAIM.REFNO,
 CLAIM.COL,
 COLTAB.DESCRIPTION,
 CLAIM.LOSSDATE,
 CLAIM.TOC,
 CLAIM.CSDATE,
 CLAIM.LOSSPLACE,
 CLAIM.CTYPE,
 CLAIM.CSTATUS,
 CLAIM.CNO,
 CLAIM.ANO,
 CLAIM.PCNO,
 CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,
 SYSTAB.CURRENCY,
 CCALC.LOSS AS ESTIMATE,
 CCALC.CLAIM AS CLAIM,
 CCALC.DEDUCTIBLE AS DEDUCTIBLE,
 CCALC.SALVAGE AS SALVAGE,
 CCALC.COST AS COST,
 CCALC.SUBROGATION AS SUBROGATION,
 (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,
 CLAIM.VSEQNO,
 CLAIM.CSEQNO,
 Cast(Acceptance.AName as varchar(128)) as AName,
 acceptance.policyno,
 acceptance.certificateno,
 CLAIM.SETTLEDF
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance
Where CARRHEADER.CNO = CLAIM.CNO
 And CCALC.CNO=CLAIM.CNO
 And CLAIM.COL=COLTAB.COL
 And CLAIM.CSTATUS='P'
 And CLAIM.CSEQNO<>0
 and acceptance.ano=claim.ano



GO

/****** Object:  StoredProcedure [dbo].[CLLIST11]    Script Date: 12/21/2017 1:40:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[CLLIST11]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [CLLIST11]
end
GO
create PROCEDURE [dbo].[CLLIST11]
AS 
SELECT Cast(0 as bit) as ProcessFlag, 
[CLAIM].[CLAIMNO], 
[CLAIM].[REGDATE], 
[CLAIM].[REFNO], 
[CLAIM].[COL], 
[COLTAB].[DESCRIPTION], 
[CLAIM].[LOSSDATE], 
[CLAIM].[TOC], 
[CLAIM].[CSDATE], 
[CLAIM].[LOSSPLACE], 
[CLAIM].[CTYPE], 
[CLAIM].[CSTATUS], 
[CLAIM].[CNO], 
[CLAIM].[ANO], 
[CLAIM].[PCNO], 
[CLAIM].[LUSERID] + '/' + [CLAIM].[AUSERID] as USERID, 
[SYSTAB].[CURRENCY], 
[CCALC].[LOSS] AS ESTIMATE, 
[CCALC].[CLAIM] AS CLAIM, 
[CCALC].[DEDUCTIBLE] AS DEDUCTIBLE, 
[CCALC].[SALVAGE] AS SALVAGE, 
[CCALC].[COST] AS COST, 
[CCALC].[SUBROGATION] AS SUBROGATION, ([CARRHEADER].[TAMOUNT]-[CARRHEADER].[RAMOUNT]) AS RECOVERIES, 
[CLAIM].[VSEQNO], 
[CLAIM].[CSEQNO], 
Cast(Acceptance.AName as varchar(128)) as AName, 
acceptance.policyno, 
acceptance.certificateno, 
CLAIM.SETTLEDF 
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER, CLAIM AS C1,COLTAB,acceptance 
Where [CARRHEADER].[CNO] = [CLAIM].[CNO] 
And [CCALC].[CNO]=[CLAIM].[CNO] 
And CLAIM.COL=COLTAB.COL 
And [CLAIM].[CNO]=C1.PCNO 
And C1.CSTATUS='P' 
And C1.VSEQNO<>0 
and acceptance.ano=claim.ano 
 
 

GO

/****** Object:  StoredProcedure [dbo].[CLLIST12]    Script Date: 12/21/2017 1:40:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[CLLIST12]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [CLLIST12]
end
GO
create PROCEDURE [dbo].[CLLIST12]
 AS
SELECT Cast(0 as bit) as ProcessFlag,
 CLAIM.CLAIMNO,
 CLAIM.REGDATE,
 CLAIM.REFNO,
 CLAIM.COL,
 COLTAB.DESCRIPTION,
 CLAIM.LOSSDATE,
 CLAIM.TOC,
 CLAIM.CSDATE,
 CLAIM.LOSSPLACE,
 CLAIM.CTYPE,
 CLAIM.CSTATUS,
 CLAIM.CNO,
 CLAIM.ANO,
 CLAIM.PCNO,
 CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,
 SYSTAB.CURRENCY,
 CCALC.LOSS AS ESTIMATE,
 CCALC.CLAIM AS CLAIM,
 CCALC.DEDUCTIBLE AS DEDUCTIBLE,
 CCALC.SALVAGE AS SALVAGE,
 CCALC.COST AS COST,
 CCALC.SUBROGATION AS SUBROGATION,
 (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,
 CLAIM.VSEQNO,
 CLAIM.CSEQNO,
 Cast(Acceptance.AName as varchar(128)) as AName,
 acceptance.policyno,
 acceptance.certificateno,
 CLAIM.SETTLEDF
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER, CLAIM AS C1,COLTAB,acceptance
Where CARRHEADER.CNO = CLAIM.CNO
 And CCALC.CNO=CLAIM.CNO
 And CLAIM.COL=COLTAB.COL
 And CLAIM.CNO=C1.PCNO
 And C1.CSTATUS='P'
 And C1.CSEQNO<>0
 and acceptance.ano = claim.ano



GO

/****** Object:  StoredProcedure [dbo].[CLLIST15]    Script Date: 12/21/2017 1:40:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[CLLIST15]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [CLLIST15]
end
GO
create PROCEDURE [dbo].[CLLIST15]
 AS  
SELECT Cast(0 as bit) as ProcessFlag,  
 [CLAIM].[CLAIMNO],  
 [CLAIM].[REGDATE],  
 [CLAIM].[REFNO],  
 [CLAIM].[COL],  
 [COLTAB].[DESCRIPTION],  
 [CLAIM].[LOSSDATE],  
 [CLAIM].[TOC],  
 [CLAIM].[CSDATE],  
 [CLAIM].[LOSSPLACE],  
 [CLAIM].[CTYPE],  
 [CLAIM].[CSTATUS],  
 [CLAIM].[CNO],  
 [CLAIM].[ANO],  
 [CLAIM].[PCNO],  
 [CLAIM].[LUSERID] + '/' + [CLAIM].[AUSERID] as USERID,  
 [SYSTAB].[CURRENCY],  
 [CCALC].[LOSS] AS ESTIMATE,  
 [CCALC].[CLAIM] AS CLAIM,  
 [CCALC].[DEDUCTIBLE] AS DEDUCTIBLE,  
 [CCALC].[SALVAGE] AS SALVAGE,  
 [CCALC].[COST] AS COST,  
 [CCALC].[SUBROGATION] AS SUBROGATION,  
 ([CARRHEADER].[TAMOUNT]-[CARRHEADER].[RAMOUNT]) AS RECOVERIES,  
 [CLAIM].[VSEQNO],  
 [CLAIM].[CSEQNO],  
 Cast(Acceptance.AName as varchar(128)) as AName,  
 acceptance.policyno,  
 acceptance.certificateno,  
 CLAIM.SETTLEDF  
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance  
Where [CARRHEADER].[CNO] = [CLAIM].[CNO]  
 And [CCALC].[CNO]=[CLAIM].[CNO]  
 And CLAIM.COL=COLTAB.COL  
 And Acceptance.ANO=Claim.ANO  
 And Exists (
  Select D1.DocType, D1.Description from DocList D1, CLLoss C 
  Where C.CNO=Claim.CNO and D1.NOC=C.NOC and D1.TOI=C.TOI and D1.MandatoryF=1 
  and Not Exists (Select DocType from CDocList D2 Where D2.CNO=Claim.OCNO and D2.INO=C.INO and D2.DOCTYPE=D1.DOCTYPE and D2.AVAILABLEF=1)
 )


GO

/****** Object:  StoredProcedure [dbo].[CLLIST16]    Script Date: 12/21/2017 1:40:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[CLLIST16]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [CLLIST16]
end
GO
create PROCEDURE [dbo].[CLLIST16]

 AS
SELECT Cast(0 as bit) as ProcessFlag,
 [CLAIM].[CLAIMNO],
 [CLAIM].[REGDATE],
 [CLAIM].[REFNO],
 [CLAIM].[COL],
 [COLTAB].[DESCRIPTION],
 [CLAIM].[LOSSDATE],
 [CLAIM].[TOC],
 [CLAIM].[CSDATE],
 [CLAIM].[LOSSPLACE],
 [CLAIM].[CTYPE],
 [CLAIM].[CSTATUS],
 [CLAIM].[CNO],
 [CLAIM].[ANO],
 [CLAIM].[PCNO],
 [CLAIM].[LUSERID] + '/' + [CLAIM].[AUSERID] as USERID,
 [SYSTAB].[CURRENCY],
 [CCALC].[LOSS] AS ESTIMATE,
 [CCALC].[CLAIM] AS CLAIM,
 [CCALC].[DEDUCTIBLE] AS DEDUCTIBLE,
 [CCALC].[SALVAGE] AS SALVAGE,
 [CCALC].[COST] AS COST,
 [CCALC].[SUBROGATION] AS SUBROGATION,
 ([CARRHEADER].[TAMOUNT]-[CARRHEADER].[RAMOUNT]) AS RECOVERIES,
 [CLAIM].[VSEQNO],
 [CLAIM].[CSEQNO],
 Cast(Acceptance.AName as varchar(128)) as AName,
 acceptance.policyno,
 acceptance.certificateno,
 CLAIM.SETTLEDF
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance
Where [CARRHEADER].[CNO] = [CLAIM].[CNO]
 And [CCALC].[CNO]=[CLAIM].[CNO]
 And CLAIM.COL=COLTAB.COL
 And [CLAIM].[REQUESTF]=1
 and acceptance.ano=claim.ano
  


GO

/****** Object:  StoredProcedure [dbo].[CLLIST17]    Script Date: 12/21/2017 1:40:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[CLLIST17]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [CLLIST17]
end
GO
create PROCEDURE [dbo].[CLLIST17]
(@P_USERID as varchar(255),@P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_CStatus as varchar(1))     
AS    
SELECT Cast(0 as bit) as ProcessFlag,    
 [CLAIM].[CLAIMNO],    
 [CLAIM].[REGDATE],    
 [CLAIM].[REFNO],    
 [CLAIM].[COL],    
 [COLTAB].[DESCRIPTION],    
 [CLAIM].[LOSSDATE],    
 [CLAIM].[TOC],    
 [CLAIM].[CSDATE],    
 [CLAIM].[LOSSPLACE],    
 [CLAIM].[CTYPE],    
 [CLAIM].[CSTATUS],    
 [CLAIM].[CNO],    
 [CLAIM].[ANO],    
 [CLAIM].[PCNO],    
 [CLAIM].[LUSERID] + '/' + [CLAIM].[AUSERID] as USERID,    
 [SYSTAB].[CURRENCY],    
 [CCALC].[LOSS] AS ESTIMATE,    
 [CCALC].[CLAIM] AS CLAIM,    
 [CCALC].[DEDUCTIBLE] AS DEDUCTIBLE,    
 [CCALC].[SALVAGE] AS SALVAGE,    
 [CCALC].[COST] AS COST,    
 [CCALC].[SUBROGATION] AS SUBROGATION,    
 ([CARRHEADER].[TAMOUNT]-[CARRHEADER].[RAMOUNT]) AS RECOVERIES,    
 [CLAIM].[VSEQNO],    
 [CLAIM].[CSEQNO],    
 Cast(Acceptance.AName as varchar(128)) as AName,    
 acceptance.policyno,    
 acceptance.certificateno,    
 CLAIM.SETTLEDF    
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance    
Where [CARRHEADER].[CNO] = [CLAIM].[CNO]    
 And [CCALC].[CNO]=[CLAIM].[CNO]    
 And CLAIM.COL=COLTAB.COL    
 And Acceptance.ANO=Claim.ANO  
 And Claim.LUserID Like @P_UserID      
 And Claim.LDate Between @P_SDate and @P_EDate
 And (Claim.CStatus=@P_CStatus or @P_CStatus='')
  


GO

/****** Object:  StoredProcedure [dbo].[CLLISTQRY_2]    Script Date: 12/21/2017 1:40:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[CLLISTQRY_2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [CLLISTQRY_2]
end
GO
create PROCEDURE [dbo].[CLLISTQRY_2]

 (@P_CNO AS INTEGER)
AS
SELECT Cast(0 as bit) as ProcessFlag,
 CLAIM.CLAIMNO,
  CLAIM.REGDATE,
  CLAIM.REFNO,
  CLAIM.COL,
  COLTAB.DESCRIPTION,
  CLAIM.LOSSDATE,
  CLAIM.TOC,
  CLAIM.CSDATE,
  CLAIM.LOSSPLACE,
  CLAIM.CTYPE,
  CLAIM.CSTATUS,
  CLAIM.CNO,
  CLAIM.ANO,
  CLAIM.PCNO,
  CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,
  SYSTAB.CURRENCY,
  CCALC.LOSS AS ESTIMATE,
  CCALC.CLAIM AS CLAIM,
  CCALC.DEDUCTIBLE AS DEDUCTIBLE,
  CCALC.SALVAGE AS SALVAGE,
  CCALC.COST AS COST,
  CCALC.SUBROGATION AS SUBROGATION,
  (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,
  CLAIM.VSEQNO,
  CLAIM.CSEQNO,
  CLAIM.LARGEF,
  CLAIM.UNIQUEF,
  Cast(Acceptance.AName as varchar(128)) as AName,
  acceptance.policyno,
  acceptance.certificateno,
  CLAIM.SETTLEDF
FROM  CLAIM, FN_CCALC(@P_CNO) AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance
WHERE  CLAIM.CNO=@P_CNO
  And CCALC.CNO=CLAIM.CNO
  And CLAIM.COL=COLTAB.COL
  And CLAIM.CNO=CARRHEADER.CNO
  and acceptance.ano=claim.ano




GO

/****** Object:  StoredProcedure [dbo].[CLLISTQRY_4]    Script Date: 12/21/2017 1:40:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[CLLISTQRY_4]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [CLLISTQRY_4]
end
GO
create PROCEDURE [dbo].[CLLISTQRY_4]
(@pCNO AS INTEGER)
AS
SELECT Cast(0 as bit) as ProcessFlag,
  [CLAIM].[CLAIMNO],
  [CLAIM].[REGDATE],
  [CLAIM].[REFNO],
  [CLAIM].[COL],
  [COLTAB].[DESCRIPTION],
  [CLAIM].[LOSSDATE],
  [CLAIM].[TOC],
  [CLAIM].[CSDATE],
  [CLAIM].[LOSSPLACE],
  [CLAIM].[CTYPE],
  [CLAIM].[CSTATUS],
  [CLAIM].[CNO],
  [CLAIM].[ANO],
  [CLAIM].[PCNO],
  [CLAIM].[LUSERID] + '/' + [CLAIM].[AUSERID] as USERID,
  [SYSTAB].[CURRENCY],
  [CCALC].[LOSS] AS ESTIMATE,
  [CCALC].[CLAIM] AS CLAIM,
  [CCALC].[DEDUCTIBLE] AS DEDUCTIBLE,
  [CCALC].[SALVAGE] AS SALVAGE,
  [CCALC].[COST] AS COST,
  [CCALC].[SUBROGATION] AS SUBROGATION,
  ([CARRHEADER].[TAMOUNT]-[CARRHEADER].[RAMOUNT]) AS RECOVERIES,
  [CLAIM].[VSEQNO],
  [CLAIM].[CSEQNO],
  Cast(Acceptance.AName as varchar(128)) as AName,
  acceptance.policyno,
  acceptance.certificateno,
  CLAIM.SETTLEDF
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER, CLAIM AS C1,COLTAB,acceptance
WHERE  C1.CNO=@PCNO
  AND [CLAIM].[CNO]=C1.PCNO
  And CLAIM.COL=COLTAB.COL
  And [CCALC].[CNO]=[CLAIM].[CNO]
  And [CLAIM].[CNO]=[CARRHEADER].[CNO]
  and claim.ano=acceptance.ano
  


GO

/****** Object:  StoredProcedure [dbo].[CLLISTQRY_5]    Script Date: 12/21/2017 1:40:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[CLLISTQRY_5]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [CLLISTQRY_5]
end
GO
create PROCEDURE [dbo].[CLLISTQRY_5]

(@pCNO AS INTEGER)
AS
SELECT  Cast(0 as bit) as ProcessFlag,
 [CLAIM].[CLAIMNO],
  [CLAIM].[REGDATE],
  [CLAIM].[REFNO],
  [CLAIM].[COL],
  [COLTAB].[DESCRIPTION],
  [CLAIM].[LOSSDATE],
  [CLAIM].[TOC],
  [CLAIM].[CSDATE],
  [CLAIM].[LOSSPLACE],
  [CLAIM].[CTYPE],
  [CLAIM].[CSTATUS],
  [CLAIM].[CNO],
  [CLAIM].[ANO],
  [CLAIM].[PCNO],
  [CLAIM].[LUSERID] + '/' + [CLAIM].[AUSERID] as USERID,
  [SYSTAB].[CURRENCY],
  [CCALC].[LOSS] AS ESTIMATE,
  [CCALC].[CLAIM] AS CLAIM,
  [CCALC].[DEDUCTIBLE] AS DEDUCTIBLE,
  [CCALC].[SALVAGE] AS SALVAGE,
  [CCALC].[COST] AS COST,
  [CCALC].[SUBROGATION] AS SUBROGATION,
  ([CARRHEADER].[TAMOUNT]-[CARRHEADER].[RAMOUNT]) AS RECOVERIES,
  [CLAIM].[VSEQNO],
  [CLAIM].[CSEQNO],
  Cast(Acceptance.AName as varchar(128)) as AName,
  acceptance.policyno,
  acceptance.certificateno,
  CLAIM.SETTLEDF
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER, CLAIM AS C1,COLTAB,acceptance
WHERE  C1.CNO=@PCNO
  AND [CLAIM].[PCNO]=C1.CNO
  And CLAIM.COL=COLTAB.COL
  And [CCALC].[CNO]=[CLAIM].[CNO]
  And [CLAIM].[CNO]=[CARRHEADER].[CNO]
  and acceptance.ano=claim.ano



GO

/****** Object:  StoredProcedure [dbo].[CLLISTSR]    Script Date: 12/21/2017 1:40:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[CLLISTSR]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [CLLISTSR]
end
GO
create PROCEDURE [dbo].[CLLISTSR]
(@P_ID as int)  
AS  
SELECT  Cast(0 as bit) as ProcessFlag,  
 CLAIM.CLAIMNO,  
 CLAIM.REGDATE,  
 CLAIM.REFNO,  
 CLAIM.COL,  
 COLTAB.DESCRIPTION,  
 CLAIM.LOSSDATE,  
 CLAIM.TOC,  
 CLAIM.CSDATE,  
 CLAIM.LOSSPLACE,  
 CLAIM.CTYPE,  
 CLAIM.CSTATUS,  
 CLAIM.CNO,  
 CLAIM.ANO,  
 CLAIM.PCNO,  
 CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,  
 SYSTAB.CURRENCY,  
 CCALC.LOSS AS ESTIMATE,  
 CCALC.CLAIM AS CLAIM,  
 CCALC.DEDUCTIBLE AS DEDUCTIBLE,  
 CCALC.SALVAGE AS SALVAGE,  
 CCALC.COST AS COST,  
 CCALC.SUBROGATION AS SUBROGATION,  
 (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,  
 CLAIM.VSEQNO,  
 CLAIM.CSEQNO,  
 Cast(Acceptance.AName as varchar(128)) as AName,  
 Claim.policyno,  
 Claim.certificateno,  
 CLAIM.SETTLEDF  
FROM  CLAIM Left Join CArrHeader on (CarrHeader.CNO=Claim.CNO)  
Left Join QClaim_CCalc() as CCalc on (CCalc.CNO=Claim.CNO)  
Left Join Acceptance on (Acceptance.ANO=Claim.ANO)  
inner join COLTAB on (COLTAB.COL=CLAIM.COL)  
, SYSTAB, SysRequest  
WHERE SysRequest.ID=@P_ID  
 And SysRequest.Param2 in ('MAR','UND','CLM')  
 And ((SysRequest.Param4=Claim.CNO and SysRequest.Param2='CLM') or (SysRequest.Param3=Claim.ANO and SysRequest.Param2 in ('MAR','UND')))  
    

GO



/****** Object:  StoredProcedure [dbo].[MList01]    Script Date: 12/21/2017 1:39:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[MList01]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [MList01]
end
GO
create PROCEDURE [dbo].[MList01]
 (@P_UserID as varchar(50))
AS
SELECT Cast(0 as bit) as ProcessFlag, [Cover].[COVERNO], [Cover].[Insured], [Cover].[CNO], [Cover].[CStatus], Cover.VSeqNo, [Acceptance].[lANO], [Acceptance].[ANO], [Acceptance].[REGNO], [Acceptance].[ADATE],[Acceptance].[LUSERID] as USERID,  [SysTab].[Currency], [QPCalc].[TSI], [QPCalc].[OurShare], [QPCalc].[Gross], [Acceptance].[ASTATUS], [Acceptance].[ATYPE], [Acceptance].[SDate], [Acceptance].[EDate], 
  Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
  Cover.ISType, 
  Acceptance.Renewal, 
  Acceptance.ESeqNo, 
  Acceptance.PolicyNo  
FROM Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab
WHERE [Cover].[CNO]=[Acceptance].[CNO] 
	And ([Acceptance].[LANO]=-1 Or [Acceptance].[ANO]=[Acceptance].[LANO]) 
	And [Acceptance].[AType]='N' 
	And [Acceptance].[LUserID] Like @P_UserID
	And [Cover].[CStatus]='R'



GO

/****** Object:  StoredProcedure [dbo].[MList01A]    Script Date: 12/21/2017 1:39:24 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

 
 IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[MList01A]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [MList01A]
end
GO
create PROCEDURE [dbo].[MList01A]
 
 
(@P_Date as Smalldatetime) 
AS 
SELECT Cast(0 as bit) as ProcessFlag, [Cover].[COVERNO], [Cover].[Insured], [Cover].[CNO], [Cover].[CStatus], Cover.VSeqNo, [Acceptance].[lANO], [Acceptance].[ANO], [Acceptance].[REGNO], [Acceptance].[ADATE], [Acceptance].[LUSERID] as USERID, [SysTab].[Currency], [QPCalc].[TSI], [QPCalc].[OurShare], [QPCalc].[Gross], [Acceptance].[ASTATUS], [Acceptance].[ATYPE], [Acceptance].[SDate], [Acceptance].[EDate], 
Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
Cover.ISType, 
Acceptance.Renewal, 
Acceptance.ESeqNo, 
Acceptance.PolicyNo 
FROM Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab 
WHERE [Cover].[CNO]=[Acceptance].[CNO] And ([Acceptance].[LANO]=-1 Or [Acceptance].[ANO]=[Acceptance].[LANO]) And [Acceptance].[AType]='N' And [Cover].[CStatus]='R' And  [Cover].[CDate]+[Cover].[Validation]<=@p_Date; 
 
 
 

GO

/****** Object:  StoredProcedure [dbo].[MLIST02]    Script Date: 12/21/2017 1:39:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[MLIST02]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [MLIST02]
end
GO
create PROCEDURE [dbo].[MLIST02]
 
 
(@P_UserID as varchar(50))
AS
SELECT 		Cast(0 as bit) as ProcessFlag, 
		[Cover].[COVERNO], 
		[Cover].[Insured], 
		[Cover].[CNO], 
		[Cover].[CStatus], 
		[Cover].[VSeqNo], 
		[Acceptance].[lANO], 
		[Acceptance].[ANO], 
		[Acceptance].[REGNO], 
		[Acceptance].[ADATE], 
		[Acceptance].[LUSERID] as USERID, 
		[SysTab].[Currency], 
		[QPCalc].[TSI], 
		[QPCalc].[OurShare], 
		[QPCalc].[Gross], 
		[Acceptance].[ASTATUS], 
		[Acceptance].[ATYPE], 
		[Acceptance].[SDate], 
		[Acceptance].[EDate], 
		Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
		Cover.ISType, 
		Acceptance.Renewal, 
		Acceptance.ESeqNo, 
		Acceptance.PolicyNo		
FROM 	Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab
WHERE 	[Cover].[CNO]=[Acceptance].[CNO] 
		And ([Acceptance].[LANO]=-1 Or [Acceptance].[ANO]=[Acceptance].[LANO]) 
		And [Acceptance].[AType]='N' 
		And [Acceptance].[AStatus]='W' 
		And [Acceptance].[LUserID] Like @P_UserID
		And [Cover].[CStatus]='A'



GO

/****** Object:  StoredProcedure [dbo].[MList03]    Script Date: 12/21/2017 1:39:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[MList03]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [MList03]
end
GO
create PROCEDURE [dbo].[MList03]
 
(@P_USERID as varchar(255)='') 
AS
SELECT   Cast(0 as bit) as ProcessFlag, 
[Cover].[COVERNO], 
[Cover].[Insured], 
[Cover].[CNO], 
[Cover].[CStatus], 
Cover.VSeqNo, 
[Acceptance].[lANO], 
[Acceptance].[ANO], 
[Acceptance].[REGNO], 
[Acceptance].[ADATE], 
[Acceptance].[LUSERID] as USERID, 
[SysTab].[Currency], 
(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
[Acceptance].[ASTATUS], 
[Acceptance].[ATYPE], 
[Acceptance].[SDate], 
[Acceptance].[EDate], 
Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
Cover.ISType, 
Acceptance.Renewal, 
Acceptance.ESeqNo, 
Acceptance.PolicyNo 
FROM  Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO), Cover, SysTab 
WHERE  [Cover].[CNO]=[Acceptance].[CNO] 
And ([Acceptance].[LANO]=-1 Or [Acceptance].[ANO]=[Acceptance].[LANO]) 
And [Acceptance].[AType]='N' 
And [Acceptance].[AStatus]='C' 
And [Cover].[CStatus]='C' 
And Acceptance.LUserID Like @P_UserID 
 
 

GO

/****** Object:  StoredProcedure [dbo].[MList04]    Script Date: 12/21/2017 1:39:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[MList04]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [MList04]
end
GO
create PROCEDURE [dbo].[MList04]
 (@P_UserID as varchar(50))
AS
SELECT Cast(0 as bit) as ProcessFlag, [Cover].[COVERNO], [Cover].[Insured], [Cover].[CNO], [Cover].[CStatus], Cover.VSeqNo, [Acceptance].[lANO], [Acceptance].[ANO], [Acceptance].[REGNO], [Acceptance].[ADATE],[Acceptance].[LUSERID] as USERID,  [SysTab].[Currency], [QPCalc].[TSI], [QPCalc].[OurShare], [QPCalc].[Gross], [Acceptance].[ASTATUS], [Acceptance].[ATYPE], [Acceptance].[SDate], [Acceptance].[EDate], 
  Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
  Cover.ISType, 
  Acceptance.Renewal, 
  Acceptance.ESeqNo, 
  Acceptance.PolicyNo  
FROM Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab
Where [cover].[CNO] = [acceptance].[CNO]
 And ([Acceptance].[LANO]=-1 Or [Acceptance].[ANO]=[Acceptance].[LANO])
 And [Acceptance].[LUserID] Like @P_UserID
 And [Cover].[CStatus]='R'




GO

/****** Object:  StoredProcedure [dbo].[MList04a]    Script Date: 12/21/2017 1:39:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

 IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[MList04a]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [MList04a]
end
GO
create PROCEDURE [dbo].[MList04a]
  (@p_date as smalldatetime) 
AS 
SELECT Cast(0 as bit) as ProcessFlag, [Cover].[COVERNO], [Cover].[Insured], [Cover].[CNO], [Cover].[CStatus], Cover.VSeqNo, [Acceptance].[lANO], [Acceptance].[ANO], [Acceptance].[REGNO], [Acceptance].[ADATE],[Acceptance].[LUSERID] as USERID,  [SysTab].[Currency], [QPCalc].[TSI], [QPCalc].[OurShare], [QPCalc].[Gross], [Acceptance].[ASTATUS], [Acceptance].[ATYPE], [Acceptance].[SDate], [Acceptance].[EDate], 
Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
Cover.ISType, 
Acceptance.Renewal, 
Acceptance.ESeqNo, 
Acceptance.PolicyNo 
FROM Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab 
WHERE [Cover].[CNO]=[Acceptance].[CNO] And ([Acceptance].[LANO]=-1 Or [Acceptance].[ANO]=[Acceptance].[LANO]) And [Cover].[CStatus]='P' And [Cover].[CDate]+[Cover].[Validation]<=@p_Date; 
 
 
 

GO

/****** Object:  StoredProcedure [dbo].[MList04b]    Script Date: 12/21/2017 1:39:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[MList04b]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [MList04b]
end
GO
create PROCEDURE [dbo].[MList04b]
 
(@p_date as smalldatetime) 
AS 
SELECT Cast(0 as bit) as ProcessFlag, Cover.COVERNO, Cover.Insured, Cover.CNO, Cover.CStatus, Cover.VSeqNo, Acceptance.lANO, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE,Acceptance.LUSERID as USERID, SysTab.Currency, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, 
Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
Cover.ISType, 
Acceptance.Renewal, 
Acceptance.ESeqNo, 
Acceptance.PolicyNo 
FROM Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab 
WHERE Cover.CNO=Acceptance.CNO And (Acceptance.LANO=-1 Or Acceptance.ANO=Acceptance.LANO) And Acceptance.AType='N' And Acceptance.AStatus='W' And Cover.CStatus='A' and Cover.ASource='MKT' 
And Acceptance.SDate+Cover.Validation<=@p_Date 
 
 
 
 
 

GO

/****** Object:  StoredProcedure [dbo].[MList04c]    Script Date: 12/21/2017 1:39:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

 IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[MList04c]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [MList04c]
end
GO
create PROCEDURE [dbo].[MList04c]

(@p_date as smalldatetime) 
AS 
SELECT Cast(0 as bit) as ProcessFlag, [Cover].[COVERNO], [Cover].[Insured], [Cover].[CNO], [Cover].[CStatus], Cover.VSeqNo, [Acceptance].[lANO], [Acceptance].[ANO], [Acceptance].[REGNO], [Acceptance].[ADATE], [Acceptance].[LUSERID] as USERID, [SysTab].[Currency], [QPCalc].[TSI], [QPCalc].[OurShare], [QPCalc].[Gross], [Acceptance].[ASTATUS], [Acceptance].[ATYPE], [Acceptance].[SDate], [Acceptance].[EDate], 
Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
Cover.ISType, 
Acceptance.Renewal, 
Acceptance.ESeqNo, 
Acceptance.PolicyNo 
FROM Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab 
WHERE [Cover].[CNO]=[Acceptance].[CNO] And ([Acceptance].[LANO]=-1 Or [Acceptance].[ANO]=[Acceptance].[LANO]) And [Acceptance].[AType]='N' And [Acceptance].[AStatus]='W' And [Cover].[CStatus]='C' And [Cover].[CDate]+[Cover].[Validation]=@p_Date And Cover.Validation<>0 
 
 
 

GO

/****** Object:  StoredProcedure [dbo].[MList05]    Script Date: 12/21/2017 1:39:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[MList05]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [MList05]
end
GO
create PROCEDURE [dbo].[MList05]
 (@P_UserID as varchar(50))
AS
SELECT Cast(0 as bit) as ProcessFlag, [Cover].[COVERNO], [Cover].[Insured], [Cover].[CNO], [Cover].[CStatus], Cover.VSeqNo, [Acceptance].[lANO], [Acceptance].[ANO], [Acceptance].[REGNO], [Acceptance].[ADATE], [Acceptance].[LUSERID] as USERID, [SysTab].[Currency], [QPCalc].[TSI], [QPCalc].[OurShare], [QPCalc].[Gross], [Acceptance].[ASTATUS], [Acceptance].[ATYPE], [Acceptance].[SDate], [Acceptance].[EDate], 
  Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
  Cover.ISType, 
  Acceptance.Renewal, 
  Acceptance.ESeqNo, 
  Acceptance.PolicyNo  
FROM Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab
WHERE [Cover].[CNO]=[Acceptance].[CNO] 
	And ([Acceptance].[LANO]=-1 Or [Acceptance].[ANO]=[Acceptance].[LANO]) 
	And [Acceptance].[AType]='N' And [Acceptance].[AStatus]='W' 
	And [Acceptance].[LUserID] Like @P_UserID
	And [Cover].[CStatus]='P'



GO

/****** Object:  StoredProcedure [dbo].[MList06]    Script Date: 12/21/2017 1:39:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[MList06]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [MList06]
end
GO
create PROCEDURE [dbo].[MList06]
(@P_USERID as varchar(255)='') 
AS
SELECT 		Cast(0 as bit) as ProcessFlag, 
		[Cover].[COVERNO], 
		[Cover].[Insured], 
		[Cover].[CNO], 
		[Cover].[CStatus], 
		Cover.VSeqNo, 
		[Acceptance].[lANO], 
		[Acceptance].[ANO], 
		[Acceptance].[REGNO], 
		[Acceptance].[ADATE], 
		[Acceptance].[LUSERID] as USERID, 
		[SysTab].[Currency], 
		(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
		(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
		(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,	
		[Acceptance].[ASTATUS], 
		[Acceptance].[ATYPE], 
		[Acceptance].[SDate], 
		[Acceptance].[EDate], 
		 Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
		 Cover.ISType, 
		 Acceptance.Renewal, 
		 Acceptance.ESeqNo, 
		 Acceptance.PolicyNo 
FROM 	Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO), Cover, SysTab 
WHERE 	[Cover].[CNO]=[Acceptance].[CNO] 
		And ([Acceptance].[LANO]=-1 Or [Acceptance].[ANO]=[Acceptance].[LANO]) 
		And [Acceptance].[AType]='N' 
		And [Acceptance].[AStatus]='W' 
		And [Cover].[CStatus]='V' 
		And [Acceptance].[LUserID] Like @P_UserID 



GO

/****** Object:  StoredProcedure [dbo].[MList07]    Script Date: 12/21/2017 1:39:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[MList07]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [MList07]
end
GO
create PROCEDURE [dbo].[MList07]
(@P_USERID as varchar(255)='') 
AS
SELECT 		Cast(0 as bit) as ProcessFlag, 
		[Cover].[COVERNO], 
		[Cover].[Insured], 
		[Cover].[CNO], 
		[Cover].[CStatus], 
		Cover.VSeqNo, 
		[Acceptance].[lANO], 
		[Acceptance].[ANO], 
		[Acceptance].[REGNO], 
		[Acceptance].[ADATE], 
		[Acceptance].[LUSERID] as USERID, 
		[SysTab].[Currency], 
		(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
		(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
		(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,	
		[Acceptance].[ASTATUS], 
		[Acceptance].[ATYPE], 
		[Acceptance].[SDate], 
		[Acceptance].[EDate], 
		 Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
		 Cover.ISType, 
		 Acceptance.Renewal, 
		 Acceptance.ESeqNo, 
		 Acceptance.PolicyNo 
FROM 	Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO), Cover, SysTab 
WHERE 	[Cover].[CNO]=[Acceptance].[CNO] 
		And ([Acceptance].[LANO]=-1 Or [Acceptance].[ANO]=[Acceptance].[LANO]) 
		And [Acceptance].[AType]='N' 
		And [Acceptance].[AStatus]='W' 
		And [Acceptance].[Renewal]>0 
		And [Acceptance].[LUserID] Like @P_UserID  


GO

/****** Object:  StoredProcedure [dbo].[MList08]    Script Date: 12/21/2017 1:39:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
 IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[MList08]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [MList08]
end
GO
create PROCEDURE [dbo].[MList08]
(@P_CNO as Integer) 
AS 
SELECT Cast(0 as bit) as ProcessFlag, C1.COVERNO, C1.Insured, C1.CNO, C1.CStatus, C1.VSeqNo, Acceptance.lANO, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,  SysTab.Currency, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, 
Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
C1.ISType, 
Acceptance.Renewal, 
Acceptance.ESeqNo, 
Acceptance.PolicyNo 
FROM Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover AS C1, Cover AS C2, SysTab 
WHERE C1.CNO=Acceptance.CNO And (Acceptance.LANO=-1 Or Acceptance.ANO=Acceptance.LANO) And C1.CNO=C2.PCNO And C2.CNO=@P_CNO; 
 
 
 
 
 

GO

/****** Object:  StoredProcedure [dbo].[MList09]    Script Date: 12/21/2017 1:39:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[MList09]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [MList09]
end
GO
create PROCEDURE [dbo].[MList09]
 
(@P_CNO as Integer) 
AS 
SELECT Cast(0 as bit) as ProcessFlag, C1.COVERNO, C1.Insured, C1.CNO, C1.CStatus, C1.VSeqNo, Acceptance.lANO, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID, SysTab.Currency, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, 
Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
C1.ISType, 
Acceptance.Renewal, 
Acceptance.ESeqNo, 
Acceptance.PolicyNo 
FROM Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover AS C1, SysTab 
WHERE C1.CNO=Acceptance.CNO And (Acceptance.LANO=-1 Or Acceptance.ANO=Acceptance.LANO) And C1.PCNO=@P_CNO 
 
 
 
 
 

GO

/****** Object:  StoredProcedure [dbo].[MList10]    Script Date: 12/21/2017 1:39:24 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO
 IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[MList10]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [MList10]
end
GO
create PROCEDURE [dbo].[MList10]
(@P_ANO as Integer) 
AS 
SELECT Cast(0 as bit) as ProcessFlag, [Cover].[COVERNO], [Cover].[Insured], [Cover].[CNO], [Cover].[CStatus], Cover.VSeqNo, [Acceptance].[lANO], [Acceptance].[ANO], [Acceptance].[REGNO], [Acceptance].[ADATE], [Acceptance].[LUSERID] as USERID,  [SysTab].[Currency], [QPCalc].[TSI], [QPCalc].[OurShare], [QPCalc].[Gross], [Acceptance].[ASTATUS], [Acceptance].[ATYPE], [Acceptance].[SDate], [Acceptance].[EDate], 
Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
Cover.ISType, 
Acceptance.Renewal, 
Acceptance.ESeqNo, 
Acceptance.PolicyNo 
FROM Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab 
WHERE [Cover].[CNO]=[Acceptance].[CNO] And ([Acceptance].[LANO]=-1 Or [Acceptance].[ANO]=[Acceptance].[LANO]) And [Acceptance].[ANO]=@P_ANO 
 
 
 

GO

/****** Object:  StoredProcedure [dbo].[MList12]    Script Date: 12/21/2017 1:39:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
 IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[MList12]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [MList12]
end
GO
create PROCEDURE [dbo].[MList12]
  (@P_ANO as integer) 
AS 
 
Select Cast(0 as bit) as ProcessFlag, [Cover].[COVERNO], [Cover].[Insured], [Cover].[CNO], [Cover].[CStatus], Cover.VSeqNo, [Acceptance].[lANO], [Acceptance].[ANO], [Acceptance].[REGNO], [Acceptance].[ADATE], [Acceptance].[LUSERID] as USERID,[SysTab].[Currency], [QPCalc].[TSI], [QPCalc].[OurShare], [QPCalc].[Gross], [Acceptance].[ASTATUS], [Acceptance].[ATYPE], [Acceptance].[SDate], [Acceptance].[EDate], 
Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
Cover.ISType, 
Acceptance.Renewal, 
Acceptance.ESeqNo, 
Acceptance.PolicyNo 
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab 
WHERE Cover.CNO=Acceptance.CNO And Acceptance.ANO=@P_ANO 
 
 

GO

/****** Object:  StoredProcedure [dbo].[MList13]    Script Date: 12/21/2017 1:39:24 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[MList13]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [MList13]
end
GO
create PROCEDURE [dbo].[MList13]
 (@P_ID varchar(255)) AS 
SELECT Cast(0 as bit) as ProcessFlag, [Cover].[COVERNO], [Cover].[Insured], [Cover].[CNO], [Cover].[CStatus], Cover.VSeqNo, [Acceptance].[lANO], [Acceptance].[ANO], [Acceptance].[REGNO], [Acceptance].[ADATE], [Acceptance].[LUSERID] as USERID,[SysTab].[Currency], [QPCalc].[TSI], [QPCalc].[OurShare], [QPCalc].[Gross], [Acceptance].[ASTATUS], [Acceptance].[ATYPE], [Acceptance].[SDate], [Acceptance].[EDate], 
Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
Cover.ISType, 
Acceptance.Renewal, 
Acceptance.ESeqNo, 
Acceptance.PolicyNo 
FROM Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab, Payor 
WHERE [Cover].[CNO]=[Acceptance].[CNO] And ([Acceptance].[LANO]=-1 Or [Acceptance].[ANO]=[Acceptance].[LANO]) And [Acceptance].[AType]='N' And [Acceptance].[AStatus]='W' And [Cover].[CStatus] In ('R','P') And [Payor].[ANO]=[Acceptance].[ANO] And [Payor].[ID]=@P_ID 
 
 
 

GO

/****** Object:  StoredProcedure [dbo].[MList14]    Script Date: 12/21/2017 1:39:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[MList14]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [MList14]
end
GO
create PROCEDURE [dbo].[MList14]
(@P_USERID as varchar(255)='') 
AS
SELECT 		Cast(0 as bit) as ProcessFlag, 
		[Cover].[COVERNO], 
		[Cover].[Insured], 
		[Cover].[CNO], 
		[Cover].[CStatus], 
		[Cover].[VSeqNo], 
		[Acceptance].[lANO], 
		[Acceptance].[ANO], 
		[Acceptance].[REGNO], 
		[Acceptance].[ADATE], 
		[Acceptance].[LUSERID] as USERID, 
		[SysTab].[Currency], 
		(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
		(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
		(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,	
		[Acceptance].[ASTATUS], 
		[Acceptance].[ATYPE], 
		[Acceptance].[SDate], 
		[Acceptance].[EDate], 
		Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
		Cover.ISType, 
		Acceptance.Renewal, 
		Acceptance.ESeqNo, 
		Acceptance.PolicyNo 
FROM 	Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO), Cover, SysTab 
WHERE 	[Cover].[CNO]=[Acceptance].[CNO] 
		And ([Acceptance].[LANO]=-1 Or [Acceptance].[ANO]=[Acceptance].[LANO]) 
		And (([RArrHeader].[TreatyF]=1 And ([RArrheader].[TShare]<>100 or RArrHeader.RAmount<>0)) or RArrHeader.HoldF=1) 
		And [Acceptance].[AStatus]='W' 
		And [Acceptance].[LUserID] Like @P_UserID



GO

/****** Object:  StoredProcedure [dbo].[MList15]    Script Date: 12/21/2017 1:39:24 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

 IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[MList15]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [MList15]
end
GO
create PROCEDURE [dbo].[MList15]
 (@P_ID as varchar(10)) 
AS 
SELECT 		Cast(0 as bit) as ProcessFlag, 
		[Cover].[COVERNO], 
		[Cover].[Insured], 
		[Cover].[CNO], 
		[Cover].[CStatus], 
		Cover.VSeqNo, 
		[Acceptance].[lANO], 
		[Acceptance].[ANO], 
		[Acceptance].[REGNO], 
		[Acceptance].[ADATE], 
		[Acceptance].[LUSERID] as USERID, 
		[SysTab].[Currency], 
		[QPCalc].[TSI], 
		[QPCalc].[OurShare], 
		[QPCalc].[Gross], 
		[Acceptance].[ASTATUS], 
		[Acceptance].[ATYPE], 
		[Acceptance].[SDate], 
		[Acceptance].[EDate], 
		Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
		Cover.ISType, 
		Acceptance.Renewal, 
		Acceptance.ESeqNo, 
		Acceptance.PolicyNo 
FROM 	Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab, Payor 
WHERE 	[Cover].[CNO]=[Acceptance].[CNO] 
		And Payor.ANO=Acceptance.ANO 
		And Payor.ID=@P_ID 
		And ([Acceptance].[LANO]=-1 Or [Acceptance].[ANO]=[Acceptance].[LANO]) 
		And [Acceptance].[AType]='N' 
		And [Acceptance].[AStatus]='W' 
		And [Cover].[CStatus] in ('R','P','A') 
 
 
 

GO

/****** Object:  StoredProcedure [dbo].[MList20]    Script Date: 12/21/2017 1:39:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[MList20]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [MList20]
end
GO
create PROCEDURE [dbo].[MList20]
 (@P_USERID as varchar(255),@P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_CStatus as varchar(1))   
AS 
SELECT Cast(0 as bit) as ProcessFlag, Cover.COVERNO, Cover.Insured, Cover.CNO, Cover.CStatus, Cover.VSeqNo, Acceptance.lANO, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE,Acceptance.LUSERID as USERID,  
SysTab.Currency, 
(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, 
Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
Cover.ISType, 
Acceptance.Renewal, 
Acceptance.ESeqNo, 
Acceptance.PolicyNo 
FROM Acceptance 
Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO), Cover, SysTab 
Where cover.CNO = acceptance.CNO 
And (Acceptance.LANO=-1 Or Acceptance.ANO=Acceptance.LANO) 
And Cover.LUserID Like @P_UserID
And Cover.LDate Between @P_SDate and @P_EDate
And (Cover.CStatus=@P_CStatus or @P_CStatus='') 
 
GO

/****** Object:  StoredProcedure [dbo].[MListDet_By_ANO]    Script Date: 12/21/2017 1:39:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[MListDet_By_ANO]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [MListDet_By_ANO]
end
GO
create PROCEDURE [dbo].[MListDet_By_ANO]
 (@P_ANO as integer) 
AS 
SELECT Cast(0 as bit) as ProcessFlag, Cover.COVERNO, Cast(Acceptance.AName as varchar(128)) as AName, Acceptance.CertificateNo, Cover.CNO, Cover.CStatus, Cover.VSeqNo, Acceptance.LANO, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, Acceptance.ValueDesc, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross 
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab 
WHERE Cover.CNO=Acceptance.CNO And Acceptance.ANO=@P_ANO 
 
 

GO

/****** Object:  StoredProcedure [dbo].[MListDet01]    Script Date: 12/21/2017 1:39:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[MListDet01]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [MListDet01]
end
GO
create PROCEDURE [dbo].[MListDet01]
(@P_ANO as Integer) 
AS 
SELECT Cast(0 as bit) as ProcessFlag, Cover.COVERNO, Cast(Acceptance.AName as varchar(128)) as AName, Acceptance.CertificateNo, Cover.CNO, Cover.CStatus, Cover.VSeqNo, Acceptance.LANO, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID, SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, Acceptance.ValueDesc, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross 
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab 
WHERE 
Cover.CNO=Acceptance.CNO 
And Acceptance.ANO<>Acceptance.LANO 
And Acceptance.LANO=@P_ANO 
Order By Acceptance.CertificateNo 
 

GO

/****** Object:  StoredProcedure [dbo].[MLISTDET02]    Script Date: 12/21/2017 1:39:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[MLISTDET02]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [MLISTDET02]
end
GO
create PROCEDURE [dbo].[MLISTDET02]
(@P_ANO as Integer) 
AS 
SELECT Cast(0 as bit) as ProcessFlag, Cover.COVERNO, Cast(Acceptance.AName as varchar(128)) as AName, Acceptance.CertificateNo, Cover.CNO, Cover.CStatus, Cover.VSeqNo, Acceptance.LANO, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID, SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, Acceptance.ValueDesc, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross 
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab 
WHERE 
Cover.CNO=Acceptance.CNO 
And Acceptance.ANO<>Acceptance.LANO 
And Acceptance.ANO=@P_ANO 
Order By Acceptance.CertificateNo 
 
 

GO

/****** Object:  StoredProcedure [dbo].[MLISTDET03]    Script Date: 12/21/2017 1:39:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[MLISTDET03]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [MLISTDET03]
end
GO
create PROCEDURE [dbo].[MLISTDET03]
(@P_ANO as Integer, @P_SDATE AS SMALLDATETIME, @P_EDATE AS SMALLDATETIME) 
AS 
SELECT Cast(0 as bit) as ProcessFlag, Cover.COVERNO, Cast(Acceptance.AName as varchar(128)) as AName, Acceptance.CertificateNo, Cover.CNO, Cover.CStatus, Cover.VSeqNo, Acceptance.LANO, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE,Acceptance.LUSERID as USERID,SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, Acceptance.ValueDesc, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross 
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab 
WHERE 
Cover.CNO=Acceptance.CNO 
And Acceptance.ANO<>Acceptance.LANO 
And Acceptance.LANO=@P_ANO 
AND (ACCEPTANCE.SDATE BETWEEN @P_SDATE AND @P_EDATE) 
Order By Acceptance.CertificateNo 
 

GO

/****** Object:  StoredProcedure [dbo].[MListDet04]    Script Date: 12/21/2017 1:39:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[MListDet04]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [MListDet04]
end
GO
create PROCEDURE [dbo].[MListDet04]
(@P_ANO as integer,@P_FCERTNO as varchar(20), @P_LCERTNO as varchar(20)) 
AS 
SELECT Cast(0 as bit) as ProcessFlag, Cover.COVERNO, Cast(Acceptance.AName as varchar(128)) as AName, Acceptance.CertificateNo, Cover.CNO, Cover.CStatus, Cover.VSeqNo, Acceptance.LANO, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, Acceptance.ValueDesc, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross 
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab 
WHERE 
Cover.CNO=Acceptance.CNO 
And Acceptance.ANO<>Acceptance.LANO 
And Acceptance.LANO=@P_ANO 
And Acceptance.CertificateNo Between @P_FCertNo and @P_LCertNo 
Order By Acceptance.CertificateNo 
 
 

GO

/****** Object:  StoredProcedure [dbo].[MListQry_2]    Script Date: 12/21/2017 1:39:24 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

 IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[MListQry_2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [MListQry_2]
end
GO
create PROCEDURE [dbo].[MListQry_2]
 (@P_ANO as Integer) 
AS 
SELECT Cast(0 as bit) as ProcessFlag, [Cover].[COVERNO], [Cover].[Insured], [Cover].[CNO], [Cover].[CStatus], Cover.VSeqNo, [Acceptance].[lANO], [Acceptance].[ANO], [Acceptance].[REGNO], [Acceptance].[ADATE], [Acceptance].[LUSERID] as USERID,[SysTab].[Currency], [QPCalc].[TSI], [QPCalc].[OurShare], [QPCalc].[Gross], [Acceptance].[ASTATUS], [Acceptance].[ATYPE], [Acceptance].[SDate], [Acceptance].[EDate], 
Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
Cover.ISType, 
Acceptance.Renewal, 
Acceptance.ESeqNo, 
Acceptance.PolicyNo 
FROM Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab 
WHERE [Cover].[CNO]=[Acceptance].[CNO] And [Acceptance].[ano]=@P_ANO And [Cover].[ISType]<>'T' 

GO

/****** Object:  StoredProcedure [dbo].[MListSR]    Script Date: 12/21/2017 1:39:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[MListSR]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [MListSR]
end
GO
create PROCEDURE [dbo].[MListSR]
(@P_ID as int) 
AS 
SELECT Cast(0 as bit) as ProcessFlag, Cover.COVERNO, Cover.Insured, Cover.CNO, Cover.CStatus, Cover.VSeqNo, Acceptance.lANO, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID, SysTab.Currency, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, 
		Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
		Cover.ISType, 
		Acceptance.Renewal, 
		Acceptance.ESeqNo, 
		Acceptance.PolicyNo 
FROM  Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab, TOC, SysRequest 
Where cover.CNO = acceptance.CNO 
And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1) 
And SysRequest.ID=@P_ID 
And SysRequest.Param2 in ('MAR','UND','CLM') 
And SysRequest.Param3=Acceptance.ANO 
And TOC.TOC=ACCEPTANCE.TOC 
 
Union 
 
SELECT  Cast(0 as bit) as ProcessFlag, Cover.COVERNO, Cover.Insured, Cover.CNO, Cover.CStatus, Cover.VSeqNo, Acceptance.lANO, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID, SysTab.Currency, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, 
		Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
		Cover.ISType, 
		Acceptance.Renewal, 
		Acceptance.ESeqNo, 
		Acceptance.PolicyNo 
FROM  Acceptance Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab, Acceptance As Acceptance_Detail, TOC, SysRequest 
Where cover.CNO = acceptance.CNO 
And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO 
And SysRequest.ID=@P_ID 
And SysRequest.Param2 in ('MAR','UND','CLM') 
And SysRequest.Param3=Acceptance_Detail.ANO 
And TOC.TOC=Acceptance_Detail.TOC 
 

GO


/****** Object:  StoredProcedure [dbo].[List_By_Ano]    Script Date: 12/21/2017 1:39:03 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List_By_Ano]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [List_By_Ano]
end
GO
create PROCEDURE [dbo].[List_By_Ano]
 (@P_ANO as integer) 
AS
SELECT Cast(0 as bit) as ProcessFlag,	
	Cover.COVERNO, 
	Cast(Acceptance.AName as varchar(128)) as Insured,
	Cover.CNO, 
	Cover.CStatus, 
	Acceptance.lANO, 
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as USERID, 
	SysTab.Currency, 
	QPCalc.TSI, 
	QPCalc.OurShare, 
	QPCalc.Gross, 
	QPCalc.RYear,
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Cover.ISType, 
	Acceptance.Renewal, 
	Acceptance.ESeqNo, 
	Acceptance.PolicyNo, 
	Acceptance.CertificateNo
FROM 	Acceptance, Cover, SysTab, FN_PCALC(@P_ANO) AS QPCalc
WHERE 	Cover.CNO=Acceptance.CNO 
	And QPCalc.ANO=Acceptance.ANO 
	And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1) 
	And Acceptance.ANO=@P_ANO

GO

/****** Object:  StoredProcedure [dbo].[List_Next]    Script Date: 12/21/2017 1:39:03 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List_Next]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [List_Next]
end
GO
create PROCEDURE [dbo].[List_Next]

 (@P_ANO as integer)  
AS  
SELECT Cast(0 as bit) as ProcessFlag,  
 Cover.COVERNO,   
 Cast(Acceptance.AName as varchar(128)) as Insured,   
 Cover.CNO,   
 Cover.CStatus,   
 Acceptance.lANO,   
 Acceptance.ANO,   
 Acceptance.REGNO,   
 Acceptance.ADATE,   
 Acceptance.LUSERID as USERID,   
 SysTab.Currency,   
 QPCalc.TSI,   
 QPCalc.OurShare,   
 QPCalc.Gross,   
 QPCalc.RYear,  
 Acceptance.ASTATUS,   
 Acceptance.ATYPE,   
 Acceptance.SDate,   
 Acceptance.EDate,   
 Cover.ISType,   
 Acceptance.Renewal,   
 Acceptance.ESeqNo,   
 Acceptance.PolicyNo,   
 Acceptance.CertificateNo  
FROM Acceptance, Cover, SysTab, qMasterAcceptance_PCalc() AS QPCalc  
WHERE Cover.CNO=Acceptance.CNO And QPCalc.ANO=Acceptance.ANO And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1) And Cover.ISType<>'T' And (Acceptance.pANO=@P_ANO or Acceptance.RANO=@P_ANO)  
Order by Acceptance.ANO Asc
  
  


GO

/****** Object:  StoredProcedure [dbo].[List_Of_AccReg]    Script Date: 12/21/2017 1:39:03 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List_Of_AccReg]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [List_Of_AccReg]
end
GO
create PROCEDURE [dbo].[List_Of_AccReg]
(@P_REGID varchar(10), @P_FLDID varchar(255), @P_VALUEID varchar(255), @P_VALUEID1 varchar(255), @P_VALUEID2 varchar(255), @P_VALUEID3 varchar(255), @P_VALUEID4 varchar(255), @P_VALUEID5 varchar(255), @P_VALUEID6 varchar(255))  
As  
SELECT DISTINCT Acceptance.ValueID, Acceptance.ValueDesc as Description  
FROM Acceptance, RArrHeader, GenDTab  
WHERE RArrHeader.Status='A' And RArrHeader.ANO=Acceptance.ANO And Acceptance.REGID=@P_REGID and Acceptance.FLDID=GenDTab.FLDID And Acceptance.ValueID=GenDTab.ValueID And GenDTab.FLDID=@P_FLDID 
And (GenDTab.ValueID Like '%'+@P_ValueID + '%' or GenDTab.Description Like '%'+@P_ValueID+'%') 
And (GenDTab.ValueID1 Like @P_ValueID1 + '%' or GenDTab.ValueDesc1 Like @P_ValueID1 + '%')
And (GenDTab.ValueID2 Like @P_ValueID2 + '%' or GenDTab.ValueDesc2 Like @P_ValueID2 + '%')
And (GenDTab.ValueID3 Like @P_ValueID3 + '%' or GenDTab.ValueDesc3 Like @P_ValueID3 + '%')
And (GenDTab.ValueID4 Like @P_ValueID4 + '%' or GenDTab.ValueDesc4 Like @P_ValueID4 + '%')
And (GenDTab.ValueID5 Like @P_ValueID5 + '%' or GenDTab.ValueDesc5 Like @P_ValueID5 + '%')
And (GenDTab.ValueID6 Like @P_ValueID6 + '%' or GenDTab.ValueDesc6 Like @P_ValueID6 + '%')



GO

/****** Object:  StoredProcedure [dbo].[List_Of_Detail_AccReg]    Script Date: 12/21/2017 1:39:03 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List_Of_Detail_AccReg]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [List_Of_Detail_AccReg]
end
GO
create PROCEDURE [dbo].[List_Of_Detail_AccReg]
 (@P_REGID varchar(10),@P_FLDID varchar(255), @P_VALUEID varchar(255), @P_VALUEID1 varchar(255), @P_VALUEID2 varchar(255), @P_VALUEID3 varchar(255), @P_VALUEID4 varchar(255), @P_VALUEID5 varchar(255), @P_VALUEID6 varchar(255)) 
As 
SELECT ACCEPTANCE.FLDID, ACCEPTANCE.VALUEID, ACCEPTANCE.VALUEDESC, ACCEPTANCE.REGNO, ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, Cast(Acceptance.AName as varchar(128)) as Insured, CAMOUNT AS CP, DAMOUNT-CDAMOUNT AS DC, XPAMOUNT-CXPAMOUNT AS XP, QSRAMOUNT+AFRAMOUNT+SAMOUNT as [OR], QAMOUNT AS QS, SP1AMOUNT-CSP1AMOUNT AS SP1, SP2AMOUNT-CSP2AMOUNT AS SP2, SP3AMOUNT-CSP3AMOUNT AS SP3, ACCEPTANCE.ANO 
FROM Cover, Acceptance, RArrHeader, GenDTab 
WHERE Cover.CNO=Acceptance.CNO And RArrHeader.Status='A' And RArrHeader.ANO=Acceptance.ANO And Acceptance.REGID=@P_REGID and Acceptance.FLDID=GenDTab.FLDID And Acceptance.ValueID=GenDTab.ValueID 
And GenDTab.FLDID=@P_FLDID 
And (GenDTab.ValueID Like '%'+@P_ValueID + '%' or GenDTab.Description Like '%'+@P_ValueID+'%') 
And (GenDTab.ValueID1 Like @P_ValueID1 + '%' or GenDTab.ValueDesc1 Like @P_ValueID1 + '%') 
And (GenDTab.ValueID2 Like @P_ValueID2 + '%' or GenDTab.ValueDesc2 Like @P_ValueID2 + '%') 
And (GenDTab.ValueID3 Like @P_ValueID3 + '%' or GenDTab.ValueDesc3 Like @P_ValueID3 + '%') 
And (GenDTab.ValueID4 Like @P_ValueID4 + '%' or GenDTab.ValueDesc4 Like @P_ValueID4 + '%') 
And (GenDTab.ValueID5 Like @P_ValueID5 + '%' or GenDTab.ValueDesc5 Like @P_ValueID5 + '%') 
And (GenDTab.ValueID6 Like @P_ValueID6 + '%' or GenDTab.ValueDesc6 Like @P_ValueID6 + '%') 
 

GO

/****** Object:  StoredProcedure [dbo].[List_Of_Detail_AccReg_Blank]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List_Of_Detail_AccReg_Blank]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [List_Of_Detail_AccReg_Blank]
end
GO
create PROCEDURE [dbo].[List_Of_Detail_AccReg_Blank]
 (@P_REGID varchar(10), @P_FLDID varchar(255), @P_VALUEID varchar(255)) 
As 
SELECT ACCEPTANCE.FLDID, ACCEPTANCE.VALUEID, ACCEPTANCE.VALUEDESC, ACCEPTANCE.REGNO, ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, Cast(Acceptance.AName as varchar(128)) as Insured, CAMOUNT AS CP, DAMOUNT-CDAMOUNT AS DC, XPAMOUNT-CXPAMOUNT AS XP, QSRAMOUNT+AFRAMOUNT+SAMOUNT AS [OR], QAMOUNT AS QS, SP1AMOUNT-CSP1AMOUNT AS SP1, SP2AMOUNT-CSP2AMOUNT AS SP2, SP3AMOUNT-CSP3AMOUNT AS SP3, ACCEPTANCE.ANO 
FROM Cover, Acceptance, RArrHeader 
WHERE Cover.CNO=Acceptance.CNO And RArrHeader.Status='A' And RArrHeader.ANO=Acceptance.ANO And Acceptance.RegID=@P_REGID and Acceptance.FLDID=@P_FLDID and Acceptance.ValueID like @P_VALUEID+'%' 
 
GO

/****** Object:  StoredProcedure [dbo].[List_Of_Summary_AccReg]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List_Of_Summary_AccReg]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [List_Of_Summary_AccReg]
end
GO
create PROCEDURE [dbo].[List_Of_Summary_AccReg]
(@P_REGID varchar(10), @P_FLDID varchar(255), @P_VALUEID varchar(255), @P_VALUEID1 varchar(255), @P_VALUEID2 varchar(255), @P_VALUEID3 varchar(255), @P_VALUEID4 varchar(255), @P_VALUEID5 varchar(255), @P_VALUEID6 varchar(255)) 
As 
SELECT sum(CAMOUNT) AS CP, sum(DAMOUNT-CDAMOUNT) AS DC, sum(XPAMOUNT-CXPAMOUNT) AS XP, sum(QSRAMOUNT+AFRAMOUNT+SAMOUNT) as [OR], sum(QAMOUNT) AS QS, sum(SP1AMOUNT-CSP1AMOUNT) AS SP1, sum(SP2AMOUNT-CSP2AMOUNT) AS SP2, sum(SP3AMOUNT-CSP3AMOUNT) AS SP3 
FROM Cover, Acceptance, RArrHeader, GenDTab 
WHERE Cover.CNO=Acceptance.CNO And RArrHeader.Status='A' And RArrHeader.ANO=Acceptance.ANO And Acceptance.RegID=@P_REGID and Acceptance.FLDID=GenDTab.FLDID And Acceptance.ValueID=GenDTab.ValueID 
And GenDTab.FLDID=@P_FLDID 
And (GenDTab.ValueID Like '%'+@P_ValueID + '%' or GenDTab.Description Like '%'+@P_ValueID+'%') 
And (GenDTab.ValueID1 Like @P_ValueID1 + '%' or GenDTab.ValueDesc1 Like @P_ValueID1 + '%') 
And (GenDTab.ValueID2 Like @P_ValueID2 + '%' or GenDTab.ValueDesc2 Like @P_ValueID2 + '%') 
And (GenDTab.ValueID3 Like @P_ValueID3 + '%' or GenDTab.ValueDesc3 Like @P_ValueID3 + '%') 
And (GenDTab.ValueID4 Like @P_ValueID4 + '%' or GenDTab.ValueDesc4 Like @P_ValueID4 + '%') 
And (GenDTab.ValueID5 Like @P_ValueID5 + '%' or GenDTab.ValueDesc5 Like @P_ValueID5 + '%') 
And (GenDTab.ValueID6 Like @P_ValueID6 + '%' or GenDTab.ValueDesc6 Like @P_ValueID6 + '%') 
 
 
 

GO

/****** Object:  StoredProcedure [dbo].[List_Of_Summary_AccReg_Blank]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List_Of_Summary_AccReg_Blank]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [List_Of_Summary_AccReg_Blank]
end
GO
create PROCEDURE [dbo].[List_Of_Summary_AccReg_Blank]
(@P_REGID varchar(10), @P_FLDID varchar(255), @P_VALUEID varchar(255)) 
As 
SELECT sum(CAMOUNT) AS CP, sum(DAMOUNT-CDAMOUNT) AS DC, sum(XPAMOUNT-CXPAMOUNT) AS XP, sum(QSRAMOUNT+AFRAMOUNT+SAMOUNT) as [OR], sum(QAMOUNT) AS QS, sum(SP1AMOUNT-CSP1AMOUNT) AS SP1, sum(SP2AMOUNT-CSP2AMOUNT) AS SP2, sum(SP3AMOUNT-CSP3AMOUNT) AS SP3 
FROM Cover, Acceptance, RArrHeader 
WHERE Cover.CNO=Acceptance.CNO And RArrHeader.Status='A' And RArrHeader.ANO=Acceptance.ANO And Acceptance.RegID=@P_REGID And Acceptance.FLDID=@P_FLDID And Acceptance.ValueID like @P_VALUEID+'%' 
 
 
 

GO

/****** Object:  StoredProcedure [dbo].[List_Prev]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List_Prev]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [List_Prev]
end
GO
create PROCEDURE [dbo].[List_Prev]

 (@P_ANO as integer)   
AS  
SELECT Cast(0 as bit) as ProcessFlag,  
 Cover.COVERNO,   
 Cast(Acceptance.AName as varchar(128)) as Insured,   
 Cover.CNO,   
 Cover.CStatus,   
 Acceptance.lANO,   
 Acceptance.ANO,   
 Acceptance.REGNO,   
 Acceptance.ADATE,   
 Acceptance.LUSERID as USERID,   
 SysTab.Currency,   
 QPCalc.TSI,   
 QPCalc.OurShare,   
 QPCalc.Gross,   
 QPCalc.RYear,  
 Acceptance.ASTATUS,   
 Acceptance.ATYPE,   
 Acceptance.SDate,   
 Acceptance.EDate,   
 Cover.ISType,   
 Acceptance.Renewal,   
 Acceptance.ESeqNo,   
 Acceptance.PolicyNo,   
 Acceptance.CertificateNo  
FROM Acceptance, Cover, SysTab, qMasterAcceptance_PCalc() AS QPCalc, Acceptance AS A1  
WHERE Cover.CNO=Acceptance.CNO And QPCalc.ANO=Acceptance.ANO And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1) And Cover.ISType<>'T' And (Acceptance.ANO=A1.PANO or Acceptance.ANO=A1.RANO) And A1.ANO=@P_ANO  
Order by Acceptance.ANO Desc



GO

/****** Object:  StoredProcedure [dbo].[List_Spc_01]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List_Spc_01]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [List_Spc_01]
end
GO
create PROCEDURE [dbo].[List_Spc_01]
AS
SELECT Cast(0 as bit) as ProcessFlag,	
	Cover.COVERNO, 
	Cast(Acceptance.AName as varchar(128)) as Insured, 
	Cover.CNO, 
	Cover.CStatus, 
	Acceptance.lANO, 
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.USERID, 
	SysTab.Currency, 
	QPCalc.TSI, 
	QPCalc.OurShare, 
	QPCalc.Gross, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(Acceptance.SDate) AS RYear, 
	Cover.ISType, 
	Acceptance.Renewal, 
	Acceptance.ESeqNo, 
	Acceptance.PolicyNo, 
	Acceptance.CertificateNo
FROM 	Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc, RArrHeader
WHERE 	
	Cover.CNO=Acceptance.CNO 
	And QPCalc.ANO=Acceptance.ANO
	And RArrHeader.ANO=Acceptance.ANO
	And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1) 
	And Acceptance.AStatus='I' and Acceptance.AType<>'C'
	And Cover.ISType not in ('C','L','I','T')
	And RArrHeader.TreatyF=1 and (RArrHeader.CAmount<>0 or RArrHeader.DAmount<>0 or RArrHeader.QAmount<>0 or RArrHeader.SP1Amount<>0 or RArrHeader.SP2Amount<>0 or RArrHeader.SP3Amount<>0 or RArrHeader.XPAmount<>0 or RArrHeader.AAmount<>0)


union

SELECT Cast(0 as bit) as ProcessFlag,	
	Cover.COVERNO, 
	Cast(Acceptance.AName as varchar(128)) as Insured, 
	Cover.CNO, 
	Cover.CStatus, 
	Acceptance.lANO, 
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.USERID, 
	SysTab.Currency, 
	QPCalc.TSI, 
	QPCalc.OurShare, 
	QPCalc.Gross, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(Acceptance.SDate) AS RYear, 
	Cover.ISType, 
	Acceptance.Renewal, 
	Acceptance.ESeqNo, 
	Acceptance.PolicyNo, 
	Acceptance.CertificateNo
FROM 	Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc, RArrHeader, Acceptance As Acceptance_Detail
WHERE 	Cover.CNO=Acceptance.CNO 
	And QPCalc.ANO=Acceptance.ANO 
	And Acceptance.ANO=Acceptance_Detail.LANO 	And Acceptance_Detail.LANO<>Acceptance_Detail.ANO
	And RArrHeader.ANO=Acceptance_Detail.ANO
	And Acceptance_Detail.AStatus='I' and Acceptance_Detail.AType<>'C'
	And Cover.ISType not in ('C','L','I','T')
	And RArrHeader.TreatyF=1 and (RArrHeader.CAmount<>0 or RArrHeader.DAmount<>0 or RArrHeader.QAmount<>0 or RArrHeader.SP1Amount<>0 or RArrHeader.SP2Amount<>0 or RArrHeader.SP3Amount<>0 or RArrHeader.XPAmount<>0 or RArrHeader.AAmount<>0)




GO

/****** Object:  StoredProcedure [dbo].[List_Spc_02]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List_Spc_02]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [List_Spc_02]
end
GO
create PROCEDURE [dbo].[List_Spc_02]

AS  
SELECT Cast(0 as bit) as ProcessFlag,   
 Cover.COVERNO,   
 Cast(Acceptance.AName as varchar(128)) as Insured,   
 Cover.CNO,   
 Cover.CStatus,   
 Acceptance.lANO,   
 Acceptance.ANO,   
 Acceptance.REGNO,   
 Acceptance.ADATE,   
 Acceptance.USERID,   
 SysTab.Currency,   
 QPCalc.TSI,   
 QPCalc.OurShare,   
 QPCalc.Gross,   
 Acceptance.ASTATUS,   
 Acceptance.ATYPE,   
 Acceptance.SDate,   
 Acceptance.EDate,   
 Year(Acceptance.SDate) AS RYear,   
 Cover.ISType,   
 Acceptance.Renewal,   
 Acceptance.ESeqNo,   
 Acceptance.PolicyNo,   
 Acceptance.CertificateNo  
FROM  Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc, RArrHeader  
WHERE    
 Cover.CNO=Acceptance.CNO   
 And QPCalc.ANO=Acceptance.ANO  
 And RArrHeader.ANO=Acceptance.ANO  
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)   
 And left(Acceptance.TOC,2)  in ('03','04')  
 And Acceptance.AStatus='I' and Acceptance.AType<>'C'  
 And Acceptance.ANO not in (SELECT ANO from Classified_Object() C Where C.ANO=Acceptance.ANO)  
 And RArrHeader.TreatyF=1 and (RArrHeader.CAmount<>0 or RArrHeader.DAmount<>0 or RArrHeader.QAmount<>0 or RArrHeader.SP1Amount<>0 or RArrHeader.SP2Amount<>0 or RArrHeader.SP3Amount<>0 or RArrHeader.XPAmount<>0 or RArrHeader.AAmount<>0)  
  
  
union  
  
SELECT Cast(0 as bit) as ProcessFlag,   
 Cover.COVERNO,   
 Cast(Acceptance.AName as varchar(128)) as Insured,   
 Cover.CNO,   
 Cover.CStatus,   
 Acceptance.lANO,   
 Acceptance.ANO,   
 Acceptance.REGNO,   
 Acceptance.ADATE,   
 Acceptance.USERID,   
 SysTab.Currency,   
 QPCalc.TSI,   
 QPCalc.OurShare,   
 QPCalc.Gross,   
 Acceptance.ASTATUS,   
 Acceptance.ATYPE,   
 Acceptance.SDate,   
 Acceptance.EDate,   
 Year(Acceptance.SDate) AS RYear,   
 Cover.ISType,   
 Acceptance.Renewal,   
 Acceptance.ESeqNo,   
 Acceptance.PolicyNo,   
 Acceptance.CertificateNo  
FROM  Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc, RArrHeader, Acceptance As Acceptance_Detail  
WHERE  Cover.CNO=Acceptance.CNO   
 And QPCalc.ANO=Acceptance.ANO   
 And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO  
 And RArrHeader.ANO=Acceptance_Detail.ANO  
 And left(Acceptance.TOC,2)  in ('03','04')  
 And Acceptance_Detail.AStatus='I' and Acceptance_Detail.AType<>'C'  
 And Acceptance_Detail.ANO not in (SELECT ANO from Classified_Object() C Where C.ANO=Acceptance_Detail.ANO)  
 And RArrHeader.TreatyF=1 and (RArrHeader.CAmount<>0 or RArrHeader.DAmount<>0 or RArrHeader.QAmount<>0 or RArrHeader.SP1Amount<>0 or RArrHeader.SP2Amount<>0 or RArrHeader.SP3Amount<>0 or RArrHeader.XPAmount<>0 or RArrHeader.AAmount<>0)      


GO

/****** Object:  StoredProcedure [dbo].[List_Spc_03]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List_Spc_03]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [List_Spc_03]
end
GO
create PROCEDURE [dbo].[List_Spc_03]

AS  
SELECT Cast(0 as bit) as ProcessFlag,   
 Cover.COVERNO,   
 Cast(Acceptance.AName as varchar(128)) as Insured,   
 Cover.CNO,   
 Cover.CStatus,   
 Acceptance.lANO,   
 Acceptance.ANO,   
 Acceptance.REGNO,   
 Acceptance.ADATE,   
 Acceptance.USERID,   
 SysTab.Currency,   
 QPCalc.TSI,   
 QPCalc.OurShare,   
 QPCalc.Gross,   
 Acceptance.ASTATUS,   
 Acceptance.ATYPE,   
 Acceptance.SDate,   
 Acceptance.EDate,   
 Year(Acceptance.SDate) AS RYear,   
 Cover.ISType,   
 Acceptance.Renewal,   
 Acceptance.ESeqNo,   
 Acceptance.PolicyNo,   
 Acceptance.CertificateNo  
FROM  Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc, RArrHeader  
WHERE    
 Cover.CNO=Acceptance.CNO   
 And QPCalc.ANO=Acceptance.ANO  
 And RArrHeader.ANO=Acceptance.ANO  
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)   
 And Acceptance.AStatus in ('I','W') and Acceptance.AType<>'C'  
 And Acceptance.TOC='0111'  
 And RArrHeader.FAmount=0  
  
  
union  
  
SELECT Cast(0 as bit) as ProcessFlag,   
 Cover.COVERNO,   
 Cast(Acceptance.AName as varchar(128)) as Insured,   
 Cover.CNO,   
 Cover.CStatus,   
 Acceptance.lANO,   
 Acceptance.ANO,   
 Acceptance.REGNO,   
 Acceptance.ADATE,   
 Acceptance.USERID,   
 SysTab.Currency,   
 QPCalc.TSI,   
 QPCalc.OurShare,   
 QPCalc.Gross,   
 Acceptance.ASTATUS,   
 Acceptance.ATYPE,   
 Acceptance.SDate,   
 Acceptance.EDate,   
 Year(Acceptance.SDate) AS RYear,   
 Cover.ISType,   
 Acceptance.Renewal,   
 Acceptance.ESeqNo,   
 Acceptance.PolicyNo,   
 Acceptance.CertificateNo  
FROM  Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc, RArrHeader, Acceptance As Acceptance_Detail  
WHERE  Cover.CNO=Acceptance.CNO   
 And QPCalc.ANO=Acceptance.ANO   
 And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO  
 And RArrHeader.ANO=Acceptance_Detail.ANO  
 And Acceptance_Detail.AStatus in ('I','W') and Acceptance_Detail.AType<>'C'  
 And Acceptance.TOC='0111'  
 And RArrHeader.FAmount=0 
 

GO

/****** Object:  StoredProcedure [dbo].[List00]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List00]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [List00]
end
GO
create PROCEDURE [dbo].[List00]
(@P_ANO as integer) AS    
SELECT Cast(0 as bit) as ProcessFlag,  
 Cover.COVERNO,  
 Cover.Insured as Insured,  
 Cover.CNO,  
 Cover.CStatus,  
 Acceptance.lANO,  
 Acceptance.ANO,  
 Acceptance.REGNO,  
 Acceptance.ADATE,  
 Acceptance.LUSERID as USERID,  
 SysTab.Currency,  
 (SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
 (SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
 (SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
 Acceptance.ASTATUS,  
 Acceptance.ATYPE,  
 Acceptance.SDate,  
 Acceptance.EDate,  
 Year(Acceptance.SDate) AS RYear,  
 Cover.ISType,  
 Acceptance.Renewal,  
 Acceptance.ESeqNo,  
 Acceptance.PolicyNo,  
 Acceptance.CertificateNo,  
 Acceptance.RefNo,  
 cover.ProformaF  
FROM  Cover, Acceptance, Profile, systab  
Where cover.CNO = acceptance.CNO And cover.PHolder = Profile.ID And Acceptance.ANO  = @P_ANO



GO

/****** Object:  StoredProcedure [dbo].[List01]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List01]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [List01]
end
GO
create PROCEDURE [dbo].[List01]

(@P_USERID as varchar(255)) 
AS 
SELECT Cast(0 as bit) as ProcessFlag, 
Cover.COVERNO, 
Cast(Acceptance.AName as varchar(128)) as Insured, 
Cover.CNO, 
Cover.CStatus, 
Acceptance.lANO, 
Acceptance.ANO, 
Acceptance.REGNO, 
Acceptance.ADATE, 
Acceptance.LUSERID as USERID, 
SysTab.Currency, 
(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
Acceptance.ASTATUS, 
Acceptance.ATYPE, 
Acceptance.SDate, 
Acceptance.EDate, 
Year(Acceptance.SDate) AS RYear, 
Cover.ISType, 
Acceptance.Renewal, 
Acceptance.ESeqNo, 
Acceptance.PolicyNo, 
Acceptance.CertificateNo 
FROM  Acceptance, Cover, SysTab
WHERE  Cover.CNO=Acceptance.CNO 
And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1) 
And Acceptance.AStatus='W' 
And Cover.ISType<>'T' 
And Cover.CStatus='A' 
And Acceptance.LUserID Like @P_UserID 
 
 


GO

/****** Object:  StoredProcedure [dbo].[List02]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List02]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [List02]
end
GO
create PROCEDURE [dbo].[List02]
(@P_UserID varchar(255), @pEDate as smalldatetime) 
AS 
SELECT Cast(0 as bit) as ProcessFlag, 
Cover.COVERNO, 
Cast(Acceptance.AName as varchar(128)) as Insured, 
Cover.CNO, 
Cover.CStatus, 
Acceptance.lANO, 
Acceptance.ANO, 
Acceptance.REGNO, 
Acceptance.ADATE, 
Acceptance.LUSERID as USERID, 
SysTab.Currency, 
(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
Acceptance.ASTATUS, 
Acceptance.ATYPE, 
Acceptance.SDate, 
Acceptance.EDate, 
Year(Acceptance.SDate) AS RYear, 
Cover.ISType, 
Acceptance.Renewal, 
Acceptance.ESeqNo, 
Acceptance.PolicyNo, 
Acceptance.CertificateNo 
FROM  Acceptance, Cover, SysTab
WHERE  Cover.CNO=Acceptance.CNO 
And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1) 
And Acceptance.AStatus='W' 
And Cover.ISType<>'T' 
And Cover.CStatus='A' 
And Cover.CDate+Cover.Validation<=@pEDate 
And Acceptance.LUserID Like @P_UserID 
 
 


GO

/****** Object:  StoredProcedure [dbo].[List02A]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List02A]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [List02A]
end
GO
create PROCEDURE [dbo].[List02A]

(@P_UserID as varchar(255), @pEDate as smalldatetime) 
AS 
SELECT Cast(0 as bit) as ProcessFlag, 
Cover.COVERNO, 
Cast(Acceptance.AName as varchar(128)) as Insured, 
Cover.CNO, 
Cover.CStatus, 
Acceptance.lANO, 
Acceptance.ANO, 
Acceptance.REGNO, 
Acceptance.ADATE, 
Acceptance.LUSERID as USERID, 
SysTab.Currency, 
(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
Acceptance.ASTATUS, 
Acceptance.ATYPE, 
Acceptance.SDate, 
Acceptance.EDate, 
Year(Acceptance.SDate) AS RYear, 
Cover.ISType, 
Acceptance.Renewal, 
Acceptance.ESeqNo, 
Acceptance.PolicyNo, 
Acceptance.CertificateNo 
FROM  Acceptance, Cover, SysTab, RArrHeader 
WHERE  Cover.CNO=Acceptance.CNO 
And RArrHeader.ANO=Acceptance.ANO 
And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1) 
And Acceptance.AStatus='W' 
And Cover.ISType<>'T' 
And Cover.CStatus='A' 
And Cover.CDate+Cover.Validation<=@pEDate 
And RArrHeader.FShare<>0 
And Acceptance.LUserID Like @P_UserID 
 
union 
 
SELECT Cast(0 as bit) as ProcessFlag, 
Cover.COVERNO, 
Cast(Acceptance.AName as varchar(128)) as Insured, 
Cover.CNO, 
Cover.CStatus, 
Acceptance.lANO, 
Acceptance.ANO, 
Acceptance.REGNO, 
Acceptance.ADATE, 
Acceptance.LUSERID as USERID, 
SysTab.Currency, 
cast(0 as Float) as TSI,
cast(0 as Float) as OurShare,
cast(0 as Float) as Gross,
Acceptance.ASTATUS, 
Acceptance.ATYPE, 
Acceptance.SDate, 
Acceptance.EDate, 
Year(Acceptance.SDate) AS RYear, 
Cover.ISType, 
Acceptance.Renewal, 
Acceptance.ESeqNo, 
Acceptance.PolicyNo, 
Acceptance.CertificateNo 
FROM  Acceptance, Cover, SysTab, RArrHeader, Acceptance As Acceptance_Detail 
WHERE  Cover.CNO=Acceptance.CNO 
And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO 
And RArrHeader.ANO=Acceptance_Detail.ANO 
And Acceptance_Detail.AStatus='W' 
And Cover.ISType<>'T' 
And Cover.CStatus='A' 
And Cover.CDate+Cover.Validation<=@pEDate 
And RArrHeader.FShare<>0 
And Acceptance_Detail.LUserID Like @P_UserID 
 
 


GO

/****** Object:  StoredProcedure [dbo].[List03]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List03]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [List03]
end
GO
create PROCEDURE [dbo].[List03]
(@P_USERID as varchar(255))   
AS   
SELECT Cast(0 as bit) as ProcessFlag,   
Cover.COVERNO,   
Cast(Acceptance.AName as varchar(128)) as Insured,   
Cover.CNO,   
Cover.CStatus,   
Acceptance.lANO,   
Acceptance.ANO,   
Acceptance.REGNO,   
Acceptance.ADATE,   
Acceptance.LUSERID as USERID,   
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
Acceptance.CertificateNo   
FROM  Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO), Cover, SysTab   
WHERE  Cover.CNO=Acceptance.CNO   
And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)   
And Acceptance.AStatus Not in ('W','T')   
And Cover.ISType<>'T'   
And Acceptance.LUserID Like @P_UserID   
   
union   
   
SELECT Cast(0 as bit) as ProcessFlag,   
Cover.COVERNO,   
Cast(Acceptance.AName as varchar(128)) as Insured,   
Cover.CNO,   
Cover.CStatus,   
Acceptance.lANO,   
Acceptance.ANO,   
Acceptance.REGNO,   
Acceptance.ADATE,   
Acceptance.LUSERID as USERID,   
SysTab.Currency,   
cast(0 as Float) as TSI,
cast(0 as Float) as OurShare,
cast(0 as Float) as Gross,
Acceptance.ASTATUS,   
Acceptance.ATYPE,   
Acceptance.SDate,   
Acceptance.EDate,   
Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear,   
Cover.ISType,   
Acceptance.Renewal,   
Acceptance.ESeqNo,   
Acceptance.PolicyNo,   
Acceptance.CertificateNo   
FROM  Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO), Cover, SysTab   
WHERE  Cover.CNO=Acceptance.CNO   
And Cover.ISType<>'T'   
And Exists   
(   
Select Top 1 Acceptance_Detail.LANO from Acceptance as Acceptance_Detail   
Where Acceptance_Detail.LANO=Acceptance.ANO and Acceptance_Detail.LANO<>Acceptance_Detail.ANO 
and Acceptance_Detail.LUserID Like @P_UserID  
And Acceptance_Detail.AStatus Not in ('W','T')   
)   
   
        


GO

/****** Object:  StoredProcedure [dbo].[List04]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List04]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [List04]
end
GO
create PROCEDURE [dbo].[List04]
(@P_UserID as varchar(255)) 
AS 
SELECT Cast(0 as bit) as ProcessFlag, 
Cover.COVERNO, 
Cast(Acceptance.AName as varchar(128)) as Insured, 
Cover.CNO, 
Cover.CStatus, 
Acceptance.lANO, 
Acceptance.ANO, 
Acceptance.REGNO, 
Acceptance.ADATE, 
Acceptance.LUSERID as USERID, 
SysTab.Currency, 
(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
Acceptance.ASTATUS, 
Acceptance.ATYPE, 
Acceptance.SDate, 
Acceptance.EDate, 
Year(Acceptance.SDate) AS RYear, 
Cover.ISType, 
Acceptance.Renewal, 
Acceptance.ESeqNo, 
Acceptance.PolicyNo, 
Acceptance.CertificateNo 
FROM  Acceptance, Cover, SysTab
WHERE  Cover.CNO=Acceptance.CNO 
And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1) 
And Acceptance.AStatus='W' 
And Cover.ISType<>'T' 
And Cover.CoverNoteF=1 
And Acceptance.LUserID Like @P_UserID 
 
 


GO

/****** Object:  StoredProcedure [dbo].[List05]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List05]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [List05]
end
GO
create PROCEDURE [dbo].[List05]
(@P_UserID as varchar(50), @pSDate as smallDateTime, @pEDate as smallDateTime, @pBranch as varchar(10), @pTOC as varchar(10), @pMO as varchar(10))      
AS      
SELECT Cast(0 as bit) as ProcessFlag,       
 Cover.COVERNO,      
 Cast(Acceptance.AName as varchar(128)) as Insured,      
 Cover.CNO,      
 Cover.CStatus,      
 Acceptance.lANO,      
 Acceptance.ANO,      
 Acceptance.REGNO,      
 Acceptance.ADATE,      
 Acceptance.LUSERID as USERID,      
 SysTab.Currency,      
 (SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,  
 (SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE,   
 (SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,  
 Acceptance.ASTATUS,      
 Acceptance.ATYPE,      
 Acceptance.SDate,      
 Acceptance.EDate,      
 Year(Acceptance.SDate) AS RYear,      
 Cover.ISType,      
 Acceptance.Renewal,      
 Acceptance.ESeqNo,      
 Acceptance.PolicyNo,      
 acceptance.CertificateNo      
FROM  Acceptance, Cover, SysTab, RArrHeader  
Where cover.CNO = acceptance.CNO       
 And RArrHeader.ANO=Acceptance.ANO      
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)      
 And Cover.CStatus<>'C'      
 And Acceptance.AStatus='I' and Acceptance.AType not in ('A','C')      
 And Acceptance.EDate between @PSDate and @PEDate      
 And Acceptance.RenewableF=1      
 And Cover.ISType in ('I','C','L')      
 And Acceptance.Branch like @pBranch+'%'    
 And Acceptance.TOC Like @pTOC+'%'      
 And Cover.MO like @pMO+'%'    
 And not Exists (SELECT ANO from Claim, CLLOSS Where CLLOSS.CNO=Claim.CNO and CLLOSS.CTLF=1 and Claim.ANO=Acceptance.ANO)      
 and Exists (Select S1.ID from SysUser S1 Left Join SysUserBranch S2 on (S2.ID=S1.ID and S2.AllowedF=1 and S2.Branch=Acceptance.Branch) Where S1.ID=@P_UserID and (coalesce(S2.Branch,'')<>'' or S1.Type='SUPERVISOR'))      
   
Union      
            
SELECT Cast(0 as bit) as ProcessFlag,       
 Cover.COVERNO,      
 Cast(Acceptance.AName as varchar(128)) as Insured,      
 Cover.CNO,      
 Cover.CStatus,      
 Acceptance.lANO,      
 Acceptance.ANO,      
 Acceptance.REGNO,      
 Acceptance.ADATE,      
 Acceptance.LUSERID as USERID,      
 SysTab.Currency,      
 cast(0 as Float) as TSI,  
 cast(0 as Float) as OurShare,  
 cast(0 as Float) as Gross,  
 Acceptance.ASTATUS,      
 Acceptance.ATYPE,      
 Acceptance.SDate,      
 Acceptance.EDate,      
 Year(Acceptance.SDate) AS RYear,      
 Cover.ISType,      
 Acceptance.Renewal,      
 Acceptance.ESeqNo,      
 Acceptance.PolicyNo,      
 acceptance.CertificateNo      
FROM  Acceptance, Cover, SysTab, RArrHeader, Acceptance As Acceptance_Detail      
Where cover.CNO = acceptance.CNO       
 And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO      
 And RArrHeader.ANO=Acceptance_Detail.ANO      
 And Cover.CStatus<>'C'      
 And Acceptance_Detail.AStatus='I' and Acceptance_Detail.AType not in ('A','C')      
 And Acceptance_Detail.EDate between @PSDate and @PEDate      
 And Acceptance_Detail.RenewableF=1      
 And Cover.ISType in ('I','C','L')      
 And Acceptance_Detail.Branch like @pBranch+'%'    
 And Acceptance.TOC Like @pTOC+'%'      
 And Cover.MO like @pMO+'%'    
 And not exists  (SELECT ANO from Claim, CLLOSS Where CLLOSS.CNO=Claim.CNO and CLLOSS.CTLF=1 and Claim.ANO=Acceptance_Detail.ANO)      
 and Exists (Select S1.ID from SysUser S1 Left Join SysUserBranch S2 on (S2.ID=S1.ID and S2.AllowedF=1 and S2.Branch=Acceptance_Detail.Branch) Where S1.ID=@P_UserID and (coalesce(S2.Branch,'')<>'' or S1.Type='SUPERVISOR'))  
    

GO

/****** Object:  StoredProcedure [dbo].[List06]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List06]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [List06]
end
GO
create PROCEDURE [dbo].[List06]
 (@P_UserID as varchar(50), @pSDate as smalldateTime, @pEDate as smallDateTime, @pBranch as varchar(10), @pTOC as varchar(10), @pMO as varchar(10))      
AS      
SELECT Cast(0 as bit) as ProcessFlag,       
 Cover.COVERNO,      
 Cast(Acceptance.AName as varchar(128)) as Insured,      
 Cover.CNO,      
 Cover.CStatus,      
 Acceptance.lANO,      
 Acceptance.ANO,      
 Acceptance.REGNO,      
 Acceptance.ADATE,      
 Acceptance.LUSERID as USERID,      
 SysTab.Currency,      
 (SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,  
 (SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE,   
 (SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,  
 Acceptance.ASTATUS,      
 Acceptance.ATYPE,      
 Acceptance.SDate,      
 Acceptance.EDate,      
 Year(Acceptance.SDate) AS RYear,      
 Cover.ISType,      
 Acceptance.Renewal,      
 Acceptance.ESeqNo,      
 Acceptance.PolicyNo,      
 acceptance.CertificateNo      
FROM  Acceptance, Cover, SysTab  
Where cover.CNO = acceptance.CNO         
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)      
 And Acceptance.AStatus='I'      
 And Acceptance.AType<>'C'      
 And Cover.ISType<>'T'      
 And Acceptance.Branch like @pBranch+'%'    
 And Acceptance.TOC Like @pTOC+'%'      
 And Cover.MO like @pMO+'%'    
 And Acceptance.EDate between @pSDate and @pEDate      
 and Exists (Select S1.ID from SysUser S1 Left Join SysUserBranch S2 on (S2.ID=S1.ID and S2.AllowedF=1 and S2.Branch=Acceptance.Branch) Where S1.ID=@P_UserID and (coalesce(S2.Branch,'')<>'' or S1.Type='SUPERVISOR'))      
        
Union      
      
SELECT Cast(0 as bit) as ProcessFlag,       
 Cover.COVERNO,      
 Cast(Acceptance.AName as varchar(128)) as Insured,      
 Cover.CNO,      
 Cover.CStatus,      
 Acceptance.lANO,      
 Acceptance.ANO,      
 Acceptance.REGNO,      
 Acceptance.ADATE,      
 Acceptance.LUSERID as USERID,      
 SysTab.Currency,      
 cast(0 as Float) as TSI,  
 cast(0 as Float) as OurShare,  
 cast(0 as Float) as Gross,  
 Acceptance.ASTATUS,      
 Acceptance.ATYPE,      
 Acceptance.SDate,      
 Acceptance.EDate,      
 Year(Acceptance.SDate) AS RYear,      
 Cover.ISType,      
 Acceptance.Renewal,      
 Acceptance.ESeqNo,      
 Acceptance.PolicyNo,      
 acceptance.CertificateNo      
FROM  Acceptance, Cover, SysTab, Acceptance As Acceptance_Detail      
Where cover.CNO = acceptance.CNO      
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)      
 And Acceptance.ANO=Acceptance_Detail.LANO And Acceptance_Detail.LANO<>Acceptance_Detail.ANO      
 And Acceptance_Detail.AStatus='I'      
 And Acceptance_Detail.AType<>'C'      
 And Cover.ISType<>'T'      
 And Acceptance_Detail.Branch like @pBranch+'%'    
 And Acceptance.TOC Like @pTOC+'%'      
 And Cover.MO like @pMO+'%'     
 And Acceptance_Detail.EDate between @pSDate and @pEDate      
 and Exists (Select S1.ID from SysUser S1 Left Join SysUserBranch S2 on (S2.ID=S1.ID and S2.AllowedF=1 and S2.Branch=Acceptance_Detail.Branch) Where S1.ID=@P_UserID and (coalesce(S2.Branch,'')<>'' or S1.Type='SUPERVISOR'))  


GO

/****** Object:  StoredProcedure [dbo].[List07]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List07]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [List07]
end
GO
create PROCEDURE [dbo].[List07]
(@PSDate as SmallDateTime, @pEDAte as smallDateTime,@P_COB as varchar(10))  
AS  
SELECT Cast(0 as bit) as ProcessFlag,   
 Cover.COVERNO,  
 Cast(Acceptance.AName as varchar(128)) as Insured,  
 Cover.CNO,  
 Cover.CStatus,  
 Acceptance.lANO,  
 Acceptance.ANO,  
 Acceptance.REGNO,  
 Acceptance.ADATE,  
 Acceptance.LUSERID as USERID,  
 SysTab.Currency,  
 (SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,  
 (SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE,   
 (SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,  
 Acceptance.ASTATUS,  
 Acceptance.ATYPE,  
 Acceptance.SDate,  
 Acceptance.EDate,  
 Year(Acceptance.SDate) AS RYear,  
 Cover.ISType,  
 Acceptance.Renewal,  
 Acceptance.ESeqNo,  
 Acceptance.PolicyNo,  
 acceptance.CertificateNo  
FROM  Acceptance, Cover, SysTab, TOC  
Where cover.CNO = acceptance.CNO  
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)  
 And ((Acceptance.AType='C' and Acceptance.AStatus='I' and Acceptance.PPDate between @PSdate and @pEDate)  
 or (Acceptance.AType<>'C' and Acceptance.AStatus='C' And Acceptance.CloseDate between @PSdate and @pEDate)  
 or (Acceptance.AType<>'C' and Acceptance.AStatus='I' and Acceptance.EDate between @PSdate and @pEDate))  
 And Cover.ISType<>'T'  
 And Acceptance.AdjustableF=1  
 And TOC.TOC=Acceptance.TOC  
 And TOC.COB=@P_COB  
 

GO

/****** Object:  StoredProcedure [dbo].[List08]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List08]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [List08]
end
GO
create PROCEDURE [dbo].[List08]


 (@pSDate as smallDatetime, @pEDate as smalldatetime)
AS
SELECT Cast(0 as bit) as ProcessFlag,	
	Cover.COVERNO, 
	Cast(Acceptance.AName as varchar(128)) as Insured, 
	Cover.CNO, 
	Cover.CStatus, 
	Acceptance.lANO, 
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as USERID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(Acceptance.SDate) AS RYear, 
	Cover.ISType, 
	Acceptance.Renewal, 
	Acceptance.ESeqNo, 
	Acceptance.PolicyNo, 
	Acceptance.CertificateNo
FROM 	Acceptance, Cover, SysTab
WHERE 	Cover.CNO=Acceptance.CNO  
	And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1) 
	And Acceptance.AType='A' 
	And Cover.ISType<>'T' 
	And Acceptance.ADate>=@pSDate 
	And Acceptance.ADate<=@pEDate




GO

/****** Object:  StoredProcedure [dbo].[List09]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List09]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [List09]
end
GO
create PROCEDURE [dbo].[List09]

(@pSDate as smalldatetime, @pEDate as smalldatetime)
AS
SELECT Cast(0 as bit) as ProcessFlag,	
	Cover.COVERNO, 
	Cast(Acceptance.AName as varchar(128)) as Insured, 
	Cover.CNO, 
	Cover.CStatus, 
	Acceptance.lANO, 
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as USERID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(Acceptance.SDate) AS RYear, 
	Cover.ISType, 
	Acceptance.Renewal, 
	Acceptance.ESeqNo, 
	Acceptance.PolicyNo, 
	Acceptance.CertificateNo
FROM 	Acceptance, Cover, SysTab
WHERE 	Cover.CNO=Acceptance.CNO  
	And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1) 
	And Acceptance.AType='C' 
	And Cover.ISType<>'T' 
	And Acceptance.ADate>=@pSDate 
	And Acceptance.ADate<=@pEDate




GO

/****** Object:  StoredProcedure [dbo].[List10]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List10]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [List10]
end
GO
create PROCEDURE [dbo].[List10]
(@P_TOC as varchar(10), @P_Branch as varchar(10), @P_PolicyNO as varchar(10), @P_SDate as smalldatetime, @P_EDate as smalldatetime, @P_AStatus as varchar(1))             
AS            
SELECT Cast(0 as bit) as ProcessFlag, Acceptance.ANO AS ANO,             
 Cover.CNO,            
 Cover.CoverDate,            
 Cover.ExpDate,            
 Cast(Acceptance.AName as varchar(128)) as Insured,            
 Cover.UserID,            
 Cover.CStatus,            
 ISource.RType,             
 Acceptance.RegNo,             
 Acceptance.PolicyNo,            
 Profile.Name,             
 Acceptance.AStatus,             
 TOC.Description,             
 Acceptance.Branch            
FROM  Cover, ISource, Acceptance, Payor, Profile, TOC            
WHERE  Acceptance.ANO=Acceptance.LANO             
 And Cover.CNO=Acceptance.CNO             
 And ISource.CNO=Cover.CNO             
 And Payor.ANO=Acceptance.ANO             
 And Cover.ISType='T' and Cover.ProformaF=0  
 And Profile.ID=Payor.ID             
 And TOC.TOC=Acceptance.TOC            
 And TOC.TOC Like @P_TOC+'%'        
 And Acceptance.Branch Like @P_Branch+'%'        
 And Acceptance.PolicyNo Like @P_PolicyNo +'%'        
 And (Acceptance.AStatus=@P_AStatus or @P_AStatus='')    
 And (@P_SDate between Cover.CoverDate and Cover.ExpDate  or @P_EDate between Cover.CoverDate and Cover.ExpDate or Cover.CoverDate Between @P_SDate and @P_EDate or Cover.ExpDate Between @P_SDate and @P_EDate)      
 order by ACCEPTANCE.RegNo 
 

GO

/****** Object:  StoredProcedure [dbo].[List11]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List11]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [List11]
end
GO
create PROCEDURE [dbo].[List11]

(@P_SDate as smalldatetime, @P_EDate as smalldatetime)
AS
SELECT Cast(0 as bit) as ProcessFlag, 
 Cover.COVERNO,
 Cast(Acceptance.AName as varchar(128)) as Insured,
 Cover.CNO,
 Cover.CStatus,
 Acceptance.lANO,
 Acceptance.ANO,
 Acceptance.REGNO,
 Acceptance.ADATE,
 Acceptance.LUSERID as USERID,
 SysTab.Currency,
(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
 Acceptance.ASTATUS,
 Acceptance.ATYPE,
 Acceptance.SDate,
 Acceptance.EDate,
 Year(Acceptance.SDate) AS RYear,
 Cover.ISType,
 Acceptance.Renewal,
 Acceptance.ESeqNo,
 Acceptance.PolicyNo,
 acceptance.CertificateNo
FROM  Acceptance, Cover, SysTab, RArrHeader
Where cover.CNO = acceptance.CNO
 And RArrHeader.ANO=Acceptance.ANO
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)
 And Cover.CStatus<>'C'
 And (Acceptance.AType Not in ('C','A') and Acceptance.AStatus='I' And RArrHeader.Status='R')
 And Cover.ISType<>'T'
 And Acceptance.ADate Between @P_SDate and @P_EDate
          
Union
          
SELECT Cast(0 as bit) as ProcessFlag, 
 Cover.COVERNO,
 Cast(Acceptance.AName as varchar(128)) as Insured,
 Cover.CNO,
 Cover.CStatus,
 Acceptance.lANO,
 Acceptance.ANO,
 Acceptance.REGNO,
 Acceptance.ADATE,
 Acceptance.LUSERID as USERID,
 SysTab.Currency,
 cast(0 as Float) as TSI,
 cast(0 as Float) as OurShare,
 cast(0 as Float) as Gross,
 Acceptance.ASTATUS,
 Acceptance.ATYPE,
 Acceptance.SDate,
 Acceptance.EDate,
 Year(Acceptance.SDate) AS RYear,
 Cover.ISType,
 Acceptance.Renewal,
 Acceptance.ESeqNo,
 Acceptance.PolicyNo,
 acceptance.CertificateNo
FROM  Acceptance, Cover, SysTab, RArrHeader, Acceptance As Acceptance_Detail
Where cover.CNO = acceptance.CNO
 And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO
 And RArrHeader.ANO=Acceptance_Detail.ANO
 And Cover.CStatus<>'C'
 And (Acceptance_Detail.AType Not in ('C','A') and Acceptance_Detail.AStatus='I' And RArrHeader.Status='R')
 And Cover.ISType<>'T'
 And Acceptance_Detail.ADate Between @P_SDate and @P_EDate
        
  




GO

/****** Object:  StoredProcedure [dbo].[List11a]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List11a]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [List11a]
end
GO
create PROCEDURE [dbo].[List11a]
(@P_UserID as varchar(255), @P_TOC as varchar(10), @P_Branch as varchar(10), @P_AStatus as varchar(1))   
AS   
SELECT Cast(0 as bit) as ProcessFlag,   
Cover.COVERNO,   
Cast(Acceptance.AName as varchar(128)) as Insured,   
Cover.CNO,   
Cover.CStatus,   
Acceptance.lANO,   
Acceptance.ANO,   
Acceptance.REGNO,   
Acceptance.ADATE,   
Acceptance.LUSERID as USERID,   
SysTab.Currency,   
(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,  
(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE,   
(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,  
Acceptance.ASTATUS,   
Acceptance.ATYPE,   
Acceptance.SDate,   
Acceptance.EDate,   
Year(Acceptance.SDate) AS RYear,   
Cover.ISType,   
Acceptance.Renewal,   
Acceptance.ESeqNo,   
Acceptance.PolicyNo,   
acceptance.CertificateNo   
FROM  Acceptance, Cover, SysTab, RArrHeader, SysUser   
Where cover.CNO = acceptance.CNO   
And RArrHeader.ANO=Acceptance.ANO   
And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)   
And Cover.CStatus<>'C'   
And Acceptance.AStatus='W'   
And (RArrHeader.RAmount<>0 or RArrHeader.HoldF=1)   
And Cover.ISType<>'T'   
And Acceptance.TOC Like @P_TOC and Acceptance.Branch Like @P_Branch and (Acceptance.AStatus=@P_AStatus or @P_AStatus='')   
And SysUser.ID=@P_UserID   
and (SysUser.Type='SUPERVISOR' or   
(   
EXISTS (Select Branch from SysUserBranch S Where S.ID=@P_UserID and S.Branch=Acceptance.Branch)   
and   
EXISTS (Select TOC from SysUserTOC S Where S.ID=@P_UserID and S.TOC=Acceptance.TOC)   
))   
   
Union   
   
SELECT Cast(0 as bit) as ProcessFlag,   
Cover.COVERNO,   
Cast(Acceptance.AName as varchar(128)) as Insured,   
Cover.CNO,   
Cover.CStatus,   
Acceptance.lANO,   
Acceptance.ANO,   
Acceptance.REGNO,   
Acceptance.ADATE,   
Acceptance.LUSERID as USERID,   
SysTab.Currency,   
cast(0 as Float) as TSI,  
cast(0 as Float) as OurShare,  
cast(0 as Float) as Gross,  
Acceptance.ASTATUS,   
Acceptance.ATYPE,   
Acceptance.SDate,   
Acceptance.EDate,   
Year(Acceptance.SDate) AS RYear,   
Cover.ISType,   
Acceptance.Renewal,   
Acceptance.ESeqNo,   
Acceptance.PolicyNo,   
acceptance.CertificateNo   
FROM  Acceptance, Cover, SysTab, RArrHeader, Acceptance As Acceptance_Detail, SysUser   
Where cover.CNO = acceptance.CNO   
And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO   
And RArrHeader.ANO=Acceptance_Detail.ANO   
And Cover.CStatus<>'C'   
And Acceptance_Detail.AStatus='W'   
And (RArrHeader.RAmount<>0 or RArrHeader.HoldF=1)   
And Cover.ISType<>'T'   
And Acceptance_Detail.TOC Like @P_TOC and Acceptance_Detail.Branch Like @P_Branch and (Acceptance_Detail.AStatus=@P_AStatus or @P_AStatus='')   
And SysUser.ID=@P_UserID   
and (SysUser.Type='SUPERVISOR' or   
(   
EXISTS (Select Branch from SysUserBranch S Where S.ID=@P_UserID and S.Branch=Acceptance_Detail.Branch)   
and   
EXISTS (Select TOC from SysUserTOC S Where S.ID=@P_UserID and S.TOC=Acceptance_Detail.TOC)   
))   


GO

/****** Object:  StoredProcedure [dbo].[List11B]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List11B]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [List11B]
end
GO
create PROCEDURE [dbo].[List11B]

AS
SELECT Cast(0 as bit) as ProcessFlag, 
 Cover.COVERNO,
 Cast(Acceptance.AName as varchar(128)) as Insured,
 Cover.CNO,
 Cover.CStatus,
 Acceptance.lANO,
 Acceptance.ANO,
 Acceptance.REGNO,
 Acceptance.ADATE,
 Acceptance.LUSERID as USERID,
 SysTab.Currency,
 (SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
 (SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
 (SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
 Acceptance.ASTATUS,
 Acceptance.ATYPE,
 Acceptance.SDate,
 Acceptance.EDate,
 Year(Acceptance.SDate) AS RYear,
 Cover.ISType,
 Acceptance.Renewal,
 Acceptance.ESeqNo,
 Acceptance.PolicyNo,
 acceptance.CertificateNo
FROM  Acceptance, Cover, SysTab, RArrHeader
Where cover.CNO = acceptance.CNO
 And RArrHeader.ANO=Acceptance.ANO
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)
 And Cover.CStatus<>'C'
 And Acceptance.AStatus='W'
 And Cover.ISType<>'T'
 And Exists (SELECT ANO from RArrDet Where RArrDet.ANO=RArrHeader.ANO and Status<>'O')
    
Union
    
SELECT Cast(0 as bit) as ProcessFlag, 
 Cover.COVERNO,
 Cast(Acceptance.AName as varchar(128)) as Insured,
 Cover.CNO,
 Cover.CStatus,
 Acceptance.lANO,
 Acceptance.ANO,
 Acceptance.REGNO,
 Acceptance.ADATE,
 Acceptance.LUSERID as USERID,
 SysTab.Currency,
 cast(0 as Float) as TSI,
 cast(0 as Float) as OurShare,
 cast(0 as Float) as Gross,
 Acceptance.ASTATUS,
 Acceptance.ATYPE,
 Acceptance.SDate,
 Acceptance.EDate,
 Year(Acceptance.SDate) AS RYear,
 Cover.ISType,
 Acceptance.Renewal,
 Acceptance.ESeqNo,
 Acceptance.PolicyNo,
 acceptance.CertificateNo
FROM  Acceptance, Cover, SysTab, RArrHeader, Acceptance As Acceptance_Detail
Where cover.CNO = acceptance.CNO
 And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO
 And RArrHeader.ANO=Acceptance_Detail.ANO
 And Cover.CStatus<>'C'
 And Acceptance_Detail.AStatus='W'
 And Cover.ISType<>'T'
 And Exists (SELECT ANO from RArrDet Where RArrDet.ANO=RArrHeader.ANO and Status<>'O')
  
  




GO

/****** Object:  StoredProcedure [dbo].[List11C]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List11C]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [List11C]
end
GO
create PROCEDURE [dbo].[List11C]


AS  
SELECT Cast(0 as bit) as ProcessFlag, 
 Cover.COVERNO,   
 Cast(Acceptance.AName as varchar(128)) as Insured,   
 Cover.CNO,   
 Cover.CStatus,   
 Acceptance.lANO,   
 Acceptance.ANO,   
 Acceptance.REGNO,   
 Acceptance.ADATE,   
 Acceptance.LUSERID as USERID,   
 SysTab.Currency,   
 (SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
 (SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
 (SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
 Acceptance.ASTATUS,   
 Acceptance.ATYPE,   
 Acceptance.SDate,   
 Acceptance.EDate,   
 Year(Acceptance.SDate) AS RYear,   
 Cover.ISType,   
 Acceptance.Renewal,   
 Acceptance.ESeqNo,   
 Acceptance.PolicyNo,   
 Acceptance.CertificateNo  
FROM  Acceptance, Cover, SysTab, RArrHeader  
WHERE  Cover.CNO=Acceptance.CNO   
 And RArrHeader.ANO=Acceptance.ANO  
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)   
 And Acceptance.AStatus='W'   
 And Acceptance.EMethod='T'  
  
union  
  
SELECT Cast(0 as bit) as ProcessFlag, 
 Cover.COVERNO,   
 Cast(Acceptance.AName as varchar(128)) as Insured,   
 Cover.CNO,   
 Cover.CStatus,   
 Acceptance.lANO,   
 Acceptance.ANO,   
 Acceptance.REGNO,   
 Acceptance.ADATE,   
 Acceptance.LUSERID as USERID,   
 SysTab.Currency,   
 cast(0 as Float) as TSI,
 cast(0 as Float) as OurShare,
 cast(0 as Float) as Gross,
 Acceptance.ASTATUS,   
 Acceptance.ATYPE,   
 Acceptance.SDate,   
 Acceptance.EDate,   
 Year(Acceptance.SDate) AS RYear,   
 Cover.ISType,   
 Acceptance.Renewal,   
 Acceptance.ESeqNo,   
 Acceptance.PolicyNo,   
 Acceptance.CertificateNo  
FROM  Acceptance, Cover, SysTab, RArrHeader, Acceptance As Acceptance_Detail  
WHERE  Cover.CNO=Acceptance.CNO   
 And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO  
 And RArrHeader.ANO=Acceptance_Detail.ANO  
 And Acceptance_Detail.AStatus='W'   
 And Acceptance_Detail.EMethod='T'







GO

/****** Object:  StoredProcedure [dbo].[List11D]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List11D]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [List11D]
end
GO
create PROCEDURE [dbo].[List11D]

(@P_SDate as smalldatetime, @P_EDate as smalldatetime)
AS  
SELECT Cast(0 as bit) as ProcessFlag, 
 Cover.COVERNO,   
 Cast(Acceptance.AName as varchar(128)) as Insured,   
 Cover.CNO,   
 Cover.CStatus,   
 Acceptance.lANO,   
 Acceptance.ANO,   
 Acceptance.REGNO,   
 Acceptance.ADATE,   
 Acceptance.LUSERID as USERID,   
 SysTab.Currency,   
 (SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
 (SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
 (SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
 Acceptance.ASTATUS,   
 Acceptance.ATYPE,   
 Acceptance.SDate,   
 Acceptance.EDate,   
 Year(Acceptance.SDate) AS RYear,   
 Cover.ISType,   
 Acceptance.Renewal,   
 Acceptance.ESeqNo,   
 Acceptance.PolicyNo,   
 Acceptance.CertificateNo  
FROM  Acceptance, Cover, SysTab, RArrHeader  
WHERE  Cover.CNO=Acceptance.CNO   
 And RArrHeader.ANO=Acceptance.ANO  
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)   
 And Cover.CStatus<>'C'  
 And Acceptance.ADate Between @P_SDate and @P_EDate
 And RArrHeader.Status<>'R'   
 And RArrHeader.SAmount<>0
 And Cover.ISType<>'T'
  
union  
  
SELECT Cast(0 as bit) as ProcessFlag, 
 Cover.COVERNO,   
 Cast(Acceptance.AName as varchar(128)) as Insured,   
 Cover.CNO,   
 Cover.CStatus,   
 Acceptance.lANO,   
 Acceptance.ANO,   
 Acceptance.REGNO,   
 Acceptance.ADATE,   
 Acceptance.LUSERID as USERID,   
 SysTab.Currency,   
 cast(0 as Float) as TSI,
 cast(0 as Float) as OurShare,
 cast(0 as Float) as Gross,
 Acceptance.ASTATUS,   
 Acceptance.ATYPE,   
 Acceptance.SDate,   
 Acceptance.EDate,   
 Year(Acceptance.SDate) AS RYear,   
 Cover.ISType,   
 Acceptance.Renewal,   
 Acceptance.ESeqNo,   
 Acceptance.PolicyNo,   
 Acceptance.CertificateNo  
FROM  Acceptance, Cover, SysTab, RArrHeader, Acceptance As Acceptance_Detail  
WHERE  Cover.CNO=Acceptance.CNO   
 And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO  
 And RArrHeader.ANO=Acceptance_Detail.ANO  
 And Cover.CStatus<>'C'  
 And Acceptance_Detail.ADate Between @P_SDate and @P_EDate
 And RArrHeader.Status<>'R'   
 And RArrHeader.SAmount<>0
 And Cover.ISType<>'T'







GO

/****** Object:  StoredProcedure [dbo].[List11E]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List11E]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [List11E]
end
GO
create PROCEDURE [dbo].[List11E]

(@P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_RegID as varchar(10))
AS
SELECT Cast(0 as bit) as ProcessFlag, 
 Cover.COVERNO,
 Cast(Acceptance.AName as varchar(128)) as Insured,
 Cover.CNO,
 Cover.CStatus,
 Acceptance.lANO,
 Acceptance.ANO,
 Acceptance.REGNO,
 Acceptance.ADATE,
 Acceptance.LUSERID as USERID,
 SysTab.Currency,
 (SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
 (SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
 (SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
 Acceptance.ASTATUS,
 Acceptance.ATYPE,
 Acceptance.SDate,
 Acceptance.EDate,
 Year(Acceptance.SDate) AS RYear,
 Cover.ISType,
 Acceptance.Renewal,
 Acceptance.ESeqNo,
 Acceptance.PolicyNo,
 acceptance.CertificateNo
FROM  Acceptance, Cover, SysTab, RArrHeader, AccRegDet
Where cover.CNO = acceptance.CNO
 And Acceptance.REGID=@P_REGID
 And RArrHeader.ANO=Acceptance.ANO
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)
 And Cover.CStatus<>'C'
 And Acceptance.ADate Between @P_SDate and @P_EDate
 And RArrHeader.Status<>'R' And RArrHeader.TAmount<>0
 And Acceptance.AStatus in ('W','I')
 And Cover.ISType<>'T'
 And AccRegDet.RYear=Year(RArrHeader.RDate) and AccRegDet.RegID=Acceptance.RegID and AccRegDet.FLDID=Acceptance.FLDID and AccRegDet.VALUEID=Acceptance.ValueID and AccRegDet.TSI<>0 and RArrHeader.ManualF=0 and AccRegDet.ReAllocF=1
 And ((Rarrheader.CID<>'' or RArrHeader.XPID<>'' or RArrheader.SP1ID<>'' or RArrHeader.SP2ID<>'' or RArrHeader.SP3ID<>'' or (RArrHeader.QID<>'' and RArrHeader.QSRet<>100)))
                  
Union
                
SELECT Cast(0 as bit) as ProcessFlag, 
 Cover.COVERNO,
 Cast(Acceptance.AName as varchar(128)) as Insured,
 Cover.CNO,
 Cover.CStatus,
 Acceptance.lANO,
 Acceptance.ANO,
 Acceptance.REGNO,
 Acceptance.ADATE,
 Acceptance.LUSERID as USERID,
 SysTab.Currency,
 cast(0 as Float) as TSI,
 cast(0 as Float) as OurShare,
 cast(0 as Float) as Gross,
 Acceptance.ASTATUS,
 Acceptance.ATYPE,
 Acceptance.SDate,
 Acceptance.EDate,
 Year(Acceptance.SDate) AS RYear,
 Cover.ISType,
 Acceptance.Renewal,
 Acceptance.ESeqNo,
 Acceptance.PolicyNo,
 acceptance.CertificateNo
FROM  Acceptance, Cover, SysTab, RArrHeader, Acceptance As Acceptance_Detail, AccRegDet
Where cover.CNO = acceptance.CNO
 And Acceptance.REGID=@P_REGID
 And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO
 And RArrHeader.ANO=Acceptance_Detail.ANO
 And Cover.CStatus<>'C'
 And Acceptance_Detail.ADate Between @P_SDate and @P_EDate
 And RArrHeader.Status<>'R' And RArrHeader.TAmount<>0
 And Acceptance_Detail.AStatus in ('W','I')
 And Cover.ISType<>'T'
 And AccRegDet.RYear=Year(RArrHeader.RDate) and AccRegDet.RegID=Acceptance_Detail.RegID and AccRegDet.FLDID=Acceptance_Detail.FLDID and AccRegDet.VALUEID=Acceptance_Detail.ValueID and AccRegDet.TSI<>0 and RArrHeader.ManualF=0 and AccRegDet.ReAllocF=1
 And ((Rarrheader.CID<>'' or RArrHeader.XPID<>'' or RArrheader.SP1ID<>'' or RArrHeader.SP2ID<>'' or RArrHeader.SP3ID<>'' or (RArrHeader.QID<>'' and RArrHeader.QSRet<>100)))





GO

/****** Object:  StoredProcedure [dbo].[List11F]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List11F]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [List11F]
end
GO
create PROCEDURE [dbo].[List11F]
(@P_UserID as varchar(10), @P_TOC as varchar(10), @P_Branch as varchar(10), @P_PDate as smalldatetime, @P_ManualF as bit)      
AS      
SELECT Cast(0 as bit) as ProcessFlag,       
 Cover.COVERNO,      
 Cast(Acceptance.AName as varchar(128)) as Insured,      
 Cover.CNO,      
 Cover.CStatus,      
 Acceptance.lANO,      
 Acceptance.ANO,      
 Acceptance.REGNO,      
 Acceptance.ADATE,      
 Acceptance.LUSERID as USERID,      
 SysTab.Currency,      
 (SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,  
 (SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE,   
 (SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,  
 Acceptance.ASTATUS,      
 Acceptance.ATYPE,      
 Acceptance.SDate,      
 Acceptance.EDate,      
 Year(Acceptance.SDate) AS RYear,      
 Cover.ISType,      
 Acceptance.Renewal,      
 Acceptance.ESeqNo,      
 Acceptance.PolicyNo,      
 acceptance.CertificateNo      
FROM  Acceptance, Cover, SysTab, RArrHeader, SysUserTOC, SysUserBranch      
Where cover.CNO = acceptance.CNO       
 And RArrHeader.ANO=Acceptance.ANO      
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)      
 And Cover.CStatus<>'C'      
 And Acceptance.AStatus='I' and Acceptance.AType not in ('A','C')      
 And RArrHeader.NRDate<Acceptance.EDate And RArrHeader.NRDate<=@P_PDate      
 And (@P_ManualF=0 or RArrHeader.ManualF=@P_ManualF)    
 And Cover.ISType<>'T'      
 And SysUserTOC.ID=@P_UserID and Acceptance.TOC=SysUserTOC.TOC and (SysUserTOC.TOC Like @P_TOC+'%' or @P_TOC='')    
 And SysUserBranch.ID=@P_UserID and Acceptance.BRanch=SysUserBranch.Branch and (SysUserBranch.Branch=@P_Branch or @P_Branch='')     
  
Union               
  
SELECT Cast(0 as bit) as ProcessFlag,       
 Cover.COVERNO,      
 Cast(Acceptance.AName as varchar(128)) as Insured,      
 Cover.CNO,      
 Cover.CStatus,      
 Acceptance.lANO,      
 Acceptance.ANO,      
 Acceptance.REGNO,      
 Acceptance.ADATE,      
 Acceptance.LUSERID as USERID,      
 SysTab.Currency,      
 cast(0 as Float) as TSI,  
 cast(0 as Float) as OurShare,  
    cast(0 as Float) as Gross,  
 Acceptance.ASTATUS,      
 Acceptance.ATYPE,      
 Acceptance.SDate,      
 Acceptance.EDate,      
 Year(Acceptance.SDate) AS RYear,      
 Cover.ISType,      
 Acceptance.Renewal,      
 Acceptance.ESeqNo,      
 Acceptance.PolicyNo,      
 acceptance.CertificateNo      
FROM  Acceptance, Cover, SysTab, RArrHeader, Acceptance As Acceptance_Detail, SysUserTOC, SysUserBranch  
Where cover.CNO = acceptance.CNO       
 And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO      
 And RArrHeader.ANO=Acceptance_Detail.ANO      
 And Cover.CStatus<>'C'      
 And Acceptance_Detail.AStatus='I' and Acceptance_Detail.AType not in ('A','C')      
 And RArrHeader.NRDate<Acceptance_Detail.EDate And RArrHeader.NRDate<=@P_PDate      
 And (@P_ManualF=0 or RArrHeader.ManualF=@P_ManualF)    
 And Cover.ISType<>'T'      
 And SysUserTOC.ID=@P_UserID and Acceptance_Detail.TOC=SysUserTOC.TOC and (SysUserTOC.TOC Like @P_TOC+'%' or @P_TOC='')    
 And SysUserBranch.ID=@P_UserID and Acceptance_Detail.BRanch=SysUserBranch.Branch and (SysUserBranch.Branch=@P_Branch or @P_Branch='')    
 

GO

/****** Object:  StoredProcedure [dbo].[List11G]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List11G]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [List11G]
end
GO
create PROCEDURE [dbo].[List11G]
(@P_SDate as smalldatetime, @P_EDate as smalldatetime)
AS
SELECT Cast(0 as bit) as ProcessFlag, 
 Cover.COVERNO,
 Cast(Acceptance.AName as varchar(128)) as Insured,
 Cover.CNO,
 Cover.CStatus,
 Acceptance.lANO,
 Acceptance.ANO,
 Acceptance.REGNO,
 Acceptance.ADATE,
 Acceptance.LUSERID as USERID,
 SysTab.Currency,
 (SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
 (SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
 (SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
 Acceptance.ASTATUS,
 Acceptance.ATYPE,
 Acceptance.SDate,
 Acceptance.EDate,
 Year(Acceptance.SDate) AS RYear,
 Cover.ISType,
 Acceptance.Renewal,
 Acceptance.ESeqNo,
 Acceptance.PolicyNo,
 acceptance.CertificateNo
FROM  Acceptance, Cover, SysTab, RArrHeader
Where cover.CNO = acceptance.CNO
 And RArrHeader.ANO=Acceptance.ANO
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)
 And Acceptance.AStatus<>'W'
 And Acceptance.ADate Between @P_SDate and @P_EDate
 And Acceptance.ANO in
(SELECT AccAss.ANO from AccAss, RArrDet, FPart Where AccAss.ANO=Acceptance.ANO and AccAss.Type='FO' and FPart.ANO=RArrDet.ANO and FPart.FID=RArrDet.FID and AccAss.ANO=RArrDet.ANO and AccAss.ID=FPart.ID and AccAss.RefNo=FPart.SlipNo and (Acceptance.AType='C' or RArrDet.Status='O'))

      
Union
      
SELECT Cast(0 as bit) as ProcessFlag, 
 Cover.COVERNO,
 Cast(Acceptance.AName as varchar(128)) as Insured,
 Cover.CNO,
 Cover.CStatus,
 Acceptance.lANO,
 Acceptance.ANO,
 Acceptance.REGNO,
 Acceptance.ADATE,
 Acceptance.LUSERID as USERID,
 SysTab.Currency,
 cast(0 as Float) as TSI,
 cast(0 as Float) as OurShare,
 cast(0 as Float) as Gross,
 Acceptance.ASTATUS,
 Acceptance.ATYPE,
 Acceptance.SDate,
 Acceptance.EDate,
 Year(Acceptance.SDate) AS RYear,
 Cover.ISType,
 Acceptance.Renewal,
 Acceptance.ESeqNo,
 Acceptance.PolicyNo,
 acceptance.CertificateNo
FROM  Acceptance, Cover, SysTab, RArrHeader, Acceptance As Acceptance_Detail
Where cover.CNO = acceptance.CNO
 And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO
 And RArrHeader.ANO=Acceptance_Detail.ANO
 And Acceptance_Detail.AStatus<>'W'
 And Acceptance_Detail.ADate Between @P_SDate and @P_EDate
 And Acceptance_Detail.ANO in
(SELECT AccAss.ANO from AccAss, RArrDet, FPart Where AccAss.ANO=Acceptance_Detail.ANO and AccAss.Type='FO' and FPart.ANO=RArrDet.ANO and FPart.FID=RArrDet.FID and AccAss.ANO=RArrDet.ANO and AccAss.ID=FPart.ID and AccAss.RefNo=FPart.SlipNo and (Acceptance_Detail.AType='C' or RArrDet.Status='O'))

    






GO

/****** Object:  StoredProcedure [dbo].[List12]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List12]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [List12]
end
GO
create PROCEDURE [dbo].[List12]


AS
SELECT Cast(0 as bit) as ProcessFlag,	
	Cover.COVERNO, 
	Cast(Acceptance.AName as varchar(128)) as Insured, 
	Cover.CNO, 
	Cover.CStatus, 
	Acceptance.lANO, 
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as USERID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(Acceptance.SDate) AS RYear, 
	Cover.ISType, 
	Acceptance.Renewal, 
	Acceptance.ESeqNo, 
	Acceptance.PolicyNo, 
	Acceptance.CertificateNo
FROM 	Acceptance, Cover, SysTab, RArrHeader
WHERE 	Cover.CNO=Acceptance.CNO 
	And RArrHeader.ANO=Acceptance.ANO
	And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1) 
	And Cover.CStatus<>'C'
	And Acceptance.AStatus='W' 
	And RArrHeader.TreatyF=1 And RArrHeader.Status='A'
	And Cover.ISType<>'T'

union

SELECT Cast(0 as bit) as ProcessFlag,	
	Cover.COVERNO, 
	Cast(Acceptance.AName as varchar(128)) as Insured, 
	Cover.CNO, 
	Cover.CStatus, 
	Acceptance.lANO, 
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as USERID, 
	SysTab.Currency, 
	cast(0 as Float) as TSI,
	cast(0 as Float) as OurShare,
	cast(0 as Float) as Gross,
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(Acceptance.SDate) AS RYear, 
	Cover.ISType, 
	Acceptance.Renewal, 
	Acceptance.ESeqNo, 
	Acceptance.PolicyNo, 
	Acceptance.CertificateNo
FROM 	Acceptance, Cover, SysTab, RArrHeader, Acceptance As Acceptance_Detail
WHERE 	Cover.CNO=Acceptance.CNO 
	And Acceptance.ANO=Acceptance_Detail.LANO 	And Acceptance_Detail.LANO<>Acceptance_Detail.ANO
	And RArrHeader.ANO=Acceptance_Detail.ANO
	And Cover.CStatus<>'C'
	And Acceptance_Detail.AStatus='W' 
	And RArrHeader.TreatyF=1 And RArrHeader.Status='A'
	And Cover.ISType<>'T'




GO

/****** Object:  StoredProcedure [dbo].[List13]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List13]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [List13]
end
GO
create PROCEDURE [dbo].[List13]


 (@pSDate as smalldatetime,
@pEDate as smalldatetime)
as
SELECT Cast(0 as bit) as ProcessFlag,      
      Cover.COVERNO, 
      Cast(Acceptance.AName as varchar(128)) as Insured, 
      Cover.CNO, 
      Cover.CStatus, 
      Acceptance.lANO, 
      Acceptance.ANO, 
      Acceptance.REGNO, 
      Acceptance.ADATE, 
      Acceptance.LUSERID as USERID, 
      SysTab.Currency, 
      (SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
	  (SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
      (SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
      Acceptance.ASTATUS, 
      Acceptance.ATYPE, 
      Acceptance.SDate, 
      Acceptance.EDate, 
      Year(Acceptance.SDate) AS RYear, 
      Cover.ISType, 
      Acceptance.Renewal, 
      Acceptance.ESeqNo, 
      Acceptance.PolicyNo, 
      Acceptance.CertificateNo
FROM       Acceptance, Cover, SysTab
WHERE       Cover.CNO=Acceptance.CNO 
      And (Acceptance.ANO=Acceptance.LANO Or
Acceptance.LANO=-1) 
      And Acceptance.AStatus='I'
      And Cover.ISType<>'T' 
      And Acceptance.ADate>=@pSDate 
      And Acceptance.ADate<=@pEDate




GO

/****** Object:  StoredProcedure [dbo].[List14]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List14]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [List14]
end
GO
create PROCEDURE [dbo].[List14]

as
SELECT Cast(0 as bit) as ProcessFlag,      
      Cover.COVERNO, 
      Cast(Acceptance.AName as varchar(128)) as Insured, 
      Cover.CNO, 
      Cover.CStatus, 
      Acceptance.lANO, 
      Acceptance.ANO, 
      Acceptance.REGNO, 
      Acceptance.ADATE, 
      Acceptance.LUSERID as USERID, 
      SysTab.Currency, 
	  (SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
	  (SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	  (SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
      Acceptance.ASTATUS, 
      Acceptance.ATYPE, 
      Acceptance.SDate, 
      Acceptance.EDate, 
      Year(Acceptance.SDate) AS RYear, 
      Cover.ISType, 
      Acceptance.Renewal, 
      Acceptance.ESeqNo, 
      Acceptance.PolicyNo, 
      Acceptance.CertificateNo
FROM       Acceptance, Cover, SysTab
WHERE       Cover.CNO=Acceptance.CNO   
      And (Acceptance.ANO=Acceptance.LANO) and Cover.OpenFlag=1
      And Acceptance.AStatus='I' 
      And Cover.ISType<>'T'




GO

/****** Object:  StoredProcedure [dbo].[List15]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List15]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [List15]
end
GO
create PROCEDURE [dbo].[List15]
(@P_REGID varchar(10), @P_FLDID varchar(255), @P_VALUEID varchar(255), @P_VALUEID1 varchar(255), @P_VALUEID2 varchar(255), @P_VALUEID3 varchar(255), @P_VALUEID4 varchar(255), @P_VALUEID5 varchar(255), @P_VALUEID6 varchar(255))
as

SELECT Cast(0 as bit) as ProcessFlag,	
	Cover.COVERNO, 
	Cast(Acceptance.AName as varchar(128)) as Insured, 
	Cover.CNO, 
	Cover.CStatus, 
	Acceptance.lANO, 
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as USERID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(Acceptance.SDate) AS RYear, 
	Cover.ISType, 
	Acceptance.Renewal, 
	Acceptance.ESeqNo, 
	Acceptance.PolicyNo, 
	Acceptance.CertificateNo
FROM 	Acceptance, Cover, SysTab, RArrHeader, GenDTab
WHERE 	Cover.CNO=Acceptance.CNO 
	And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1) 
	And Cover.ISType<>'T' 
	And RArrHeader.Status='A' 
	And RArrHeader.ANO=Acceptance.ANO 
	And Acceptance.RegID=@P_REGID
	And Acceptance.FLDID=GenDTab.FLDID 
	And Acceptance.ValueID=GenDTab.ValueID 
	And GenDTab.FLDID=@P_FLDID 
	And (GenDTab.ValueID Like @P_ValueID + '%'  or @P_ValueID='')
	And (GenDTab.ValueID1 Like @P_ValueID1 + '%' or GenDTab.ValueDesc1 Like @P_ValueID1 + '%')
	And (GenDTab.ValueID2 Like @P_ValueID2 + '%' or GenDTab.ValueDesc2 Like @P_ValueID2 + '%')
	And (GenDTab.ValueID3 Like @P_ValueID3 + '%' or GenDTab.ValueDesc3 Like @P_ValueID3 + '%')
	And (GenDTab.ValueID4 Like @P_ValueID4 + '%' or GenDTab.ValueDesc4 Like @P_ValueID4 + '%')
	And (GenDTab.ValueID5 Like @P_ValueID5 + '%' or GenDTab.ValueDesc5 Like @P_ValueID5 + '%')
	And (GenDTab.ValueID6 Like @P_ValueID6 + '%' or GenDTab.ValueDesc6 Like @P_ValueID6 + '%')
union

SELECT Cast(0 as bit) as ProcessFlag,	
	Cover.COVERNO, 
	Cast(Acceptance.AName as varchar(128)) as Insured, 
	Cover.CNO, 
	Cover.CStatus, 
	Acceptance.lANO, 
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as USERID, 
	SysTab.Currency, 
	cast(0 as Float) as TSI,
	cast(0 as Float) as OurShare,
	cast(0 as Float) as Gross,
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(Acceptance.SDate) AS RYear, 
	Cover.ISType, 
	Acceptance.Renewal, 
	Acceptance.ESeqNo, 
	Acceptance.PolicyNo, 
	Acceptance.CertificateNo
FROM 	Acceptance, Cover, SysTab, Acceptance As Acceptance_Detail, RArrHeader, GenDTab
WHERE 	Cover.CNO=Acceptance.CNO 
	And Acceptance.ANO=Acceptance_Detail.LANO 	And Acceptance_Detail.LANO<>Acceptance_Detail.ANO
	And Cover.ISType<>'T' 
	And RArrHeader.Status='A' 
	And RArrHeader.ANO=Acceptance_Detail.ANO 
	And Acceptance_Detail.RegID=@P_REGID
	And Acceptance_Detail.FLDID=GenDTab.FLDID 
	And Acceptance_Detail.ValueID=GenDTab.ValueID 
	And GenDTab.FLDID=@P_FLDID 
	And GenDTab.ValueID Like @P_ValueID + '%' 
	And (GenDTab.ValueID1 Like @P_ValueID1 + '%' or GenDTab.ValueDesc1 Like @P_ValueID1 + '%')
	And (GenDTab.ValueID2 Like @P_ValueID2 + '%' or GenDTab.ValueDesc2 Like @P_ValueID2 + '%')
	And (GenDTab.ValueID3 Like @P_ValueID3 + '%' or GenDTab.ValueDesc3 Like @P_ValueID3 + '%')
	And (GenDTab.ValueID4 Like @P_ValueID4 + '%' or GenDTab.ValueDesc4 Like @P_ValueID4 + '%')
	And (GenDTab.ValueID5 Like @P_ValueID5 + '%' or GenDTab.ValueDesc5 Like @P_ValueID5 + '%')
	And (GenDTab.ValueID6 Like @P_ValueID6 + '%' or GenDTab.ValueDesc6 Like @P_ValueID6 + '%')






GO

/****** Object:  StoredProcedure [dbo].[List15_BLANK]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List15_BLANK]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [List15_BLANK]
end
GO
create PROCEDURE [dbo].[List15_BLANK]

(@P_REGID varchar(10), @P_FLDID varchar(255), @P_VALUEID varchar(255))
as

SELECT Cast(0 as bit) as ProcessFlag,	
	Cover.COVERNO, 
	Cast(Acceptance.AName as varchar(128)) as Insured, 
	Cover.CNO, 
	Cover.CStatus, 
	Acceptance.lANO, 
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as USERID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(Acceptance.SDate) AS RYear, 
	Cover.ISType, 
	Acceptance.Renewal, 
	Acceptance.ESeqNo, 
	Acceptance.PolicyNo, 
	Acceptance.CertificateNo
FROM 	Acceptance, Cover, SysTab, RArrHeader
WHERE 	Cover.CNO=Acceptance.CNO 
	And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1) 
	And Cover.ISType<>'T' 
	And RArrHeader.Status='A' 
	And RArrHeader.ANO=Acceptance.ANO 
	And Acceptance.REGID=@P_REGID
	And Acceptance.FLDID=@P_FLDID
	And Acceptance.ValueID Like @P_ValueID + '%'

union

SELECT Cast(0 as bit) as ProcessFlag,	
	Cover.COVERNO, 
	Cast(Acceptance.AName as varchar(128)) as Insured, 
	Cover.CNO, 
	Cover.CStatus, 
	Acceptance.lANO, 
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as USERID, 
	SysTab.Currency, 
	cast(0 as Float) as TSI,
	cast(0 as Float) as OurShare,
	cast(0 as Float) as Gross,
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(Acceptance.SDate) AS RYear, 
	Cover.ISType, 
	Acceptance.Renewal, 
	Acceptance.ESeqNo, 
	Acceptance.PolicyNo, 
	Acceptance.CertificateNo
FROM 	Acceptance, Cover, SysTab, Acceptance As Acceptance_Detail, RArrHeader
WHERE 	Cover.CNO=Acceptance.CNO 
	And Acceptance.ANO=Acceptance_Detail.LANO 	And Acceptance_Detail.LANO<>Acceptance_Detail.ANO
	And Cover.ISType<>'T' 
	And RArrHeader.Status='A' 
	And RArrHeader.ANO=Acceptance_Detail.ANO 
	And Acceptance_Detail.REGID=@P_REGID
	And Acceptance_Detail.FLDID=@P_FLDID
	And Acceptance_Detail.ValueID Like @P_ValueID + '%'





GO

/****** Object:  StoredProcedure [dbo].[List16]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List16]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [List16]
end
GO
create PROCEDURE [dbo].[List16]
 (@pSDate as smalldatetime, @pEDate as smalldatetime,@P_COB as varchar(10))
as
SELECT Cast(0 as bit) as ProcessFlag,      
      Cover.COVERNO, 
      Cast(Acceptance.AName as varchar(128)) as Insured, 
      Cover.CNO, 
      Cover.CStatus, 
      Acceptance.lANO, 
      Acceptance.ANO, 
      Acceptance.REGNO, 
      Acceptance.ADATE, 
      Acceptance.LUSERID as USERID, 
      SysTab.Currency, 
	  (SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
	  (SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	  (SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
      Acceptance.ASTATUS, 
      Acceptance.ATYPE, 
      Acceptance.SDate, 
      Acceptance.EDate, 
      Year(Acceptance.SDate) AS RYear, 
      Cover.ISType, 
      Acceptance.Renewal, 
      Acceptance.ESeqNo, 
      Acceptance.PolicyNo, 
      Acceptance.CertificateNo
FROM       Acceptance, Cover, SysTab, TOC
WHERE       Cover.CNO=Acceptance.CNO 
      And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1) 
      And Cover.ISType<>'T' 
      And Acceptance.ADate>=@pSDate 
      And Acceptance.ADate<=@pEDate
      And TOC.TOC=Acceptance.TOC
      And TOC.COB=@P_COB


GO

/****** Object:  StoredProcedure [dbo].[List16SC]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List16SC]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [List16SC]
end
GO
create PROCEDURE [dbo].[List16SC]
(@P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_COB as varchar(10),@P_ServiceNo as varchar(20))
AS
SELECT Cast(0 as bit) as ProcessFlag, 
 Cover.COVERNO,
 Cast(Acceptance.AName as varchar(128)) as Insured,
 Cover.CNO,
 Cover.CStatus,
 Acceptance.lANO,
 Acceptance.ANO,
 Acceptance.REGNO,
 Acceptance.ADATE,
 Acceptance.LUSERID as USERID,
 SysTab.Currency,
 (SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
 (SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
 (SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
 Acceptance.ASTATUS,
 Acceptance.ATYPE,
 Acceptance.SDate,
 Acceptance.EDate,
 Year(Acceptance.SDate) AS RYear,
 Cover.ISType,
 Acceptance.Renewal,
 Acceptance.ESeqNo,
 Acceptance.PolicyNo,
 acceptance.CertificateNo
FROM  Acceptance, Cover, SysTab, TOC, Service
Where cover.CNO = acceptance.CNO
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)
 And Service.SType='CANCELLATION'
 And Service.PANO=Acceptance.ANO
 And Service.Cdate Between @P_Sdate and @P_EDate
 And Service.SStatus='P'
 And TOC.TOC=Acceptance.TOC
 And TOC.COB Like @P_COB+'%'
 And Service.ServiceNo Like @P_ServiceNo+'%'

Union
  
SELECT Cast(0 as bit) as ProcessFlag, 
 Cover.COVERNO,
 Cast(Acceptance.AName as varchar(128)) as Insured,
 Cover.CNO,
 Cover.CStatus,
 Acceptance.lANO,
 Acceptance.ANO,
 Acceptance.REGNO,
 Acceptance.ADATE,
 Acceptance.LUSERID as USERID,
 SysTab.Currency,
 cast(0 as Float) as TSI,
 cast(0 as Float) as OurShare,
 cast(0 as Float) as Gross,
 Acceptance.ASTATUS,
 Acceptance.ATYPE,
 Acceptance.SDate,
 Acceptance.EDate,
 Year(Acceptance.SDate) AS RYear,
 Cover.ISType,
 Acceptance.Renewal,
 Acceptance.ESeqNo,
 Acceptance.PolicyNo,
 acceptance.CertificateNo
FROM  Acceptance, Cover, SysTab, Acceptance As Acceptance_Detail, TOC, Service
Where cover.CNO = acceptance.CNO
 And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO
 And Service.SType='CANCELLATION'
 And Service.PANO=Acceptance_Detail.ANO
 And Service.Cdate Between @P_Sdate and @P_EDate
 And Service.SStatus='P'
 And TOC.TOC=Acceptance_Detail.TOC
 And TOC.COB Like @P_COB+'%'
 And Service.ServiceNo Like @P_ServiceNo+'%'


GO

/****** Object:  StoredProcedure [dbo].[List16SD]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List16SD]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [List16SD]
end
GO
create PROCEDURE [dbo].[List16SD]
(@P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_COB as varchar(10),@P_ServiceNo as varchar(20))
AS
SELECT Cast(0 as bit) as ProcessFlag, 
 Cover.COVERNO,
 Cast(Acceptance.AName as varchar(128)) as Insured,
 Cover.CNO,
 Cover.CStatus,
 Acceptance.lANO,
 Acceptance.ANO,
 Acceptance.REGNO,
 Acceptance.ADATE,
 Acceptance.LUSERID as USERID,
 SysTab.Currency,
 (SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
 (SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
 (SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
 Acceptance.ASTATUS,
 Acceptance.ATYPE,
 Acceptance.SDate,
 Acceptance.EDate,
 Year(Acceptance.SDate) AS RYear,
 Cover.ISType,
 Acceptance.Renewal,
 Acceptance.ESeqNo,
 Acceptance.PolicyNo,
 acceptance.CertificateNo
FROM  Acceptance, Cover, SysTab, TOC, Service
Where cover.CNO = acceptance.CNO
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)
 And ((Service.PANO=Acceptance.ANO and Service.SType<>'NEW') or (Service.ANO=Acceptance.ANO and Service.SType='NEW'))
 And Service.Cdate Between @P_Sdate and @P_EDate
 And Acceptance.AStatus='W'
 And Service.SStatus='C'
 And TOC.TOC=ACCEPTANCE.TOC
 And TOC.COB Like @P_COB+'%'
 And Service.ServiceNo Like @P_ServiceNo+'%'

Union
    
SELECT Cast(0 as bit) as ProcessFlag, 
 Cover.COVERNO,
 Cast(Acceptance.AName as varchar(128)) as Insured,
 Cover.CNO,
 Cover.CStatus,
 Acceptance.lANO,
 Acceptance.ANO,
 Acceptance.REGNO,
 Acceptance.ADATE,
 Acceptance.LUSERID as USERID,
 SysTab.Currency,
 cast(0 as Float) as TSI,
 cast(0 as Float) as OurShare,
 cast(0 as Float) as Gross,
 Acceptance.ASTATUS,
 Acceptance.ATYPE,
 Acceptance.SDate,
 Acceptance.EDate,
 Year(Acceptance.SDate) AS RYear,
 Cover.ISType,
 Acceptance.Renewal,
 Acceptance.ESeqNo,
 Acceptance.PolicyNo,
 acceptance.CertificateNo
FROM  Acceptance, Cover, SysTab, Acceptance As Acceptance_Detail, TOC, Service
Where cover.CNO = acceptance.CNO
 And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO
 And ((Service.PANO=Acceptance_Detail.ANO and Service.SType<>'NEW') or (Service.ANO=Acceptance_Detail.ANO and Service.SType='NEW'))
 And Service.Cdate Between @P_Sdate and @P_EDate
 And Acceptance_Detail.AStatus='W'
 And Service.SStatus='C'
 And TOC.TOC=Acceptance_Detail.TOC
 And TOC.COB Like @P_COB+'%'
 And Service.ServiceNo Like @P_ServiceNo+'%'


GO

/****** Object:  StoredProcedure [dbo].[List16SE]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List16SE]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [List16SE]
end
GO
create PROCEDURE [dbo].[List16SE]
(@P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_COB as varchar(10),@P_ServiceNo as varchar(20))
AS
SELECT Cast(0 as bit) as ProcessFlag, 
 Cover.COVERNO,
 Cast(Acceptance.AName as varchar(128)) as Insured,
 Cover.CNO,
 Cover.CStatus,
 Acceptance.lANO,
 Acceptance.ANO,
 Acceptance.REGNO,
 Acceptance.ADATE,
 Acceptance.LUSERID as USERID,
 SysTab.Currency,
 (SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
 (SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
 (SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
 Acceptance.ASTATUS,
 Acceptance.ATYPE,
 Acceptance.SDate,
 Acceptance.EDate,
 Year(Acceptance.SDate) AS RYear,
 Cover.ISType,
 Acceptance.Renewal,
 Acceptance.ESeqNo,
 Acceptance.PolicyNo,
 acceptance.CertificateNo
FROM  Acceptance, Cover, SysTab, TOC, Service
Where cover.CNO = acceptance.CNO
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)
 And Service.SType='ENDORSEMENT'
 And Service.PANO=Acceptance.ANO
 And Service.Cdate Between @P_Sdate and @P_EDate
 And Service.SStatus='P'
 And TOC.TOC=ACCEPTANCE.TOC
 And TOC.COB Like @P_COB+'%'
 And Service.ServiceNo Like @P_ServiceNo+'%'
Union
  
SELECT Cast(0 as bit) as ProcessFlag, 
 Cover.COVERNO,
 Cast(Acceptance.AName as varchar(128)) as Insured,
 Cover.CNO,
 Cover.CStatus,
 Acceptance.lANO,
 Acceptance.ANO,
 Acceptance.REGNO,
 Acceptance.ADATE,
 Acceptance.LUSERID as USERID,
 SysTab.Currency,
 cast(0 as Float) as TSI,
 cast(0 as Float) as OurShare,
 cast(0 as Float) as Gross,
 Acceptance.ASTATUS,
 Acceptance.ATYPE,
 Acceptance.SDate,
 Acceptance.EDate,
 Year(Acceptance.SDate) AS RYear,
 Cover.ISType,
 Acceptance.Renewal,
 Acceptance.ESeqNo,
 Acceptance.PolicyNo,
 acceptance.CertificateNo
FROM  Acceptance, Cover, SysTab, Acceptance As Acceptance_Detail, TOC, Service
Where cover.CNO = acceptance.CNO
 And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO
 And Service.SType='ENDORSEMENT'
 And Service.PANO=Acceptance_Detail.ANO
 And Service.Cdate Between @P_Sdate and @P_EDate
 And Service.SStatus='P'
 And TOC.TOC=Acceptance_Detail.TOC
 And TOC.COB Like @P_COB+'%'
 And Service.ServiceNo Like @P_ServiceNo+'%'


GO

/****** Object:  StoredProcedure [dbo].[List16SL]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List16SL]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [List16SL]
end
GO
create PROCEDURE [dbo].[List16SL]
(@P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_COB as varchar(10),@P_ServiceNo as varchar(20))
AS
SELECT Cast(0 as bit) as ProcessFlag, 
 Cover.COVERNO,
 Cast(Acceptance.AName as varchar(128)) as Insured,
 Cover.CNO,
 Cover.CStatus,
 Acceptance.lANO,
 Acceptance.ANO,
 Acceptance.REGNO,
 Acceptance.ADATE,
 Acceptance.LUSERID as USERID,
 SysTab.Currency,
 (SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
 (SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
 (SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
 Acceptance.ASTATUS,
 Acceptance.ATYPE,
 Acceptance.SDate,
 Acceptance.EDate,
 Year(Acceptance.SDate) AS RYear,
 Cover.ISType,
 Acceptance.Renewal,
 Acceptance.ESeqNo,
 Acceptance.PolicyNo,
 acceptance.CertificateNo
FROM  Acceptance, Cover, SysTab, TOC, Service
Where cover.CNO = acceptance.CNO
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)
 And Service.SType='EXPIRED'
 And Service.PANO=Acceptance.ANO
 And Service.Cdate Between @P_Sdate and @P_EDate
 And Service.SStatus='P'
 And TOC.TOC=ACCEPTANCE.TOC
 And TOC.COB Like @P_COB+'%'
 And Service.ServiceNo Like @P_ServiceNo+'%'

Union
    
SELECT Cast(0 as bit) as ProcessFlag, 
 Cover.COVERNO,
 Cast(Acceptance.AName as varchar(128)) as Insured,
 Cover.CNO,
 Cover.CStatus,
 Acceptance.lANO,
 Acceptance.ANO,
 Acceptance.REGNO,
 Acceptance.ADATE,
 Acceptance.LUSERID as USERID,
 SysTab.Currency,
 cast(0 as Float) as TSI,
 cast(0 as Float) as OurShare,
 cast(0 as Float) as Gross,
 Acceptance.ASTATUS,
 Acceptance.ATYPE,
 Acceptance.SDate,
 Acceptance.EDate,
 Year(Acceptance.SDate) AS RYear,
 Cover.ISType,
 Acceptance.Renewal,
 Acceptance.ESeqNo,
 Acceptance.PolicyNo,
 acceptance.CertificateNo
FROM  Acceptance, Cover, SysTab, Acceptance As Acceptance_Detail, TOC, Service
Where cover.CNO = acceptance.CNO
 And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO
 And Service.SType='EXPIRED'
 And Service.PANO=Acceptance_Detail.ANO
 And Service.Cdate Between @P_Sdate and @P_EDate
 And Service.SStatus='P'
 And TOC.TOC=Acceptance_Detail.TOC
 And TOC.COB Like @P_COB+'%'
 And Service.ServiceNo Like @P_ServiceNo+'%'


GO

/****** Object:  StoredProcedure [dbo].[List16SR]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List16SR]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [List16SR]
end
GO
create PROCEDURE [dbo].[List16SR]
(@P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_COB as varchar(10),@P_ServiceNo as varchar(20))
AS
SELECT Cast(0 as bit) as ProcessFlag, 
 Cover.COVERNO,
 Cast(Acceptance.AName as varchar(128)) as Insured,
 Cover.CNO,
 Cover.CStatus,
 Acceptance.lANO,
 Acceptance.ANO,
 Acceptance.REGNO,
 Acceptance.ADATE,
 Acceptance.LUSERID as USERID,
 SysTab.Currency,
 (SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
 (SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
 (SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
 Acceptance.ASTATUS,
 Acceptance.ATYPE,
 Acceptance.SDate,
 Acceptance.EDate,
 Year(Acceptance.SDate) AS RYear,
 Cover.ISType,
 Acceptance.Renewal,
 Acceptance.ESeqNo,
 Acceptance.PolicyNo,
 acceptance.CertificateNo
FROM  Acceptance, Cover, SysTab, TOC, Service
Where cover.CNO = acceptance.CNO
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)
 And Service.SType='RENEWAL'
 And Service.PANO=Acceptance.ANO
 And Service.Cdate Between @P_Sdate and @P_EDate
 And Service.SStatus='P'
 And TOC.TOC=ACCEPTANCE.TOC
 And TOC.COB Like @P_COB+'%'
 And Service.ServiceNo Like @P_ServiceNo+'%'

Union
  
SELECT Cast(0 as bit) as ProcessFlag, 
 Cover.COVERNO,
 Cast(Acceptance.AName as varchar(128)) as Insured,
 Cover.CNO,
 Cover.CStatus,
 Acceptance.lANO,
 Acceptance.ANO,
 Acceptance.REGNO,
 Acceptance.ADATE,
 Acceptance.LUSERID as USERID,
 SysTab.Currency,
 cast(0 as Float) as TSI,
 cast(0 as Float) as OurShare,
 cast(0 as Float) as Gross,
 Acceptance.AStatus,
 Acceptance.ATYPE,
 Acceptance.SDate,
 Acceptance.EDate,
 Year(Acceptance.SDate) AS RYear,
 Cover.ISType,
 Acceptance.Renewal,
 Acceptance.ESeqNo,
 Acceptance.PolicyNo,
 acceptance.CertificateNo
FROM  Acceptance, Cover, SysTab, Acceptance As Acceptance_Detail, TOC, Service
Where cover.CNO = acceptance.CNO
 And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO
 And Service.SType='RENEWAL'
 And Service.PANO=Acceptance_Detail.ANO
 And Service.Cdate Between @P_Sdate and @P_EDate
 And Service.SStatus='P'
 And TOC.TOC=Acceptance_Detail.TOC
 And TOC.COB Like @P_COB+'%'
 And Service.ServiceNo Like @P_ServiceNo+'%'


GO

/****** Object:  StoredProcedure [dbo].[List17]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List17]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [List17]
end
GO
create PROCEDURE [dbo].[List17]

(@pSDate as smalldatetime, @pEDate as smalldatetime,@P_SEGMENT as varchar(10))
as
SELECT Cast(0 as bit) as ProcessFlag,      
      Cover.COVERNO, 
      Cast(Acceptance.AName as varchar(128)) as Insured, 
      Cover.CNO, 
      Cover.CStatus, 
      Acceptance.lANO, 
      Acceptance.ANO, 
      Acceptance.REGNO, 
      Acceptance.ADATE, 
      Acceptance.LUSERID as USERID, 
      SysTab.Currency, 
	  (SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
	  (SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	  (SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
      Acceptance.ASTATUS, 
      Acceptance.ATYPE, 
      Acceptance.SDate, 
      Acceptance.EDate, 
      Year(Acceptance.SDate) AS RYear, 
      Cover.ISType, 
      Acceptance.Renewal, 
      Acceptance.ESeqNo, 
      Acceptance.PolicyNo, 
      Acceptance.CertificateNo
FROM       Acceptance, Cover, SysTab
WHERE       Cover.CNO=Acceptance.CNO 
      And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1) 
      And Cover.ISType<>'T' 
      And Acceptance.ADate>=@pSDate 
      And Acceptance.ADate<=@pEDate
      And Cover.Segment=@P_Segment




GO

/****** Object:  StoredProcedure [dbo].[List18]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List18]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [List18]
end
GO
create PROCEDURE [dbo].[List18]
 (@P_UserID as varchar(10), @P_TOC as varchar(10), @P_Branch as varchar(10), @P_PDate as smalldatetime)  
AS  
SELECT Cast(0 as bit) as ProcessFlag, 
 Cover.COVERNO,  
 Cast(Acceptance.AName as varchar(128)) as Insured,  
 Cover.CNO,  
 Cover.CStatus,  
 Acceptance.lANO,  
 Acceptance.ANO,  
 Acceptance.REGNO,  
 Acceptance.ADATE,  
 Acceptance.LUSERID as USERID,  
 SysTab.Currency,  
 (SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
 (SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
 (SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
 Acceptance.ASTATUS,  
 Acceptance.ATYPE,  
 Acceptance.SDate,  
 Acceptance.EDate,  
 Year(Acceptance.SDate) AS RYear,  
 Cover.ISType,  
 Acceptance.Renewal,  
 Acceptance.ESeqNo,  
 Acceptance.PolicyNo,  
 acceptance.CertificateNo  
FROM  Acceptance, Cover, SysTab, SysUserTOC, SysUserBranch
Where cover.CNO = acceptance.CNO  
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)  
 And Acceptance.AStatus='I'  
 And Acceptance.AType Not in ('C','A')  
 And Cover.ISType<>'T'  
 AND @P_PDate between Acceptance.PDate and Acceptance.PPDate  
 And SysUserTOC.ID=@P_UserID and ACCEPTANCE.TOC=SysUserTOC.TOC and (SysUserTOC.TOC=@P_TOC or @P_TOC='')
 And SysUserBranch.ID=@P_UserID and Acceptance.BRanch=SysUserBranch.Branch and (SysUserBranch.Branch=@P_Branch or @P_Branch='')
 And Acceptance.ANO in (SELECT ANO from Claim, CLLOSS Where (Claim.CSTATUS IN ('R','P','T','A') OR Claim.PCSTATUS IN ('A')) and Claim.CNO=CLLOSS.CNO and CLLOSS.CTLF=1 And Claim.ANO=Acceptance.ANO)  
     
Union

SELECT Cast(0 as bit) as ProcessFlag, 
 Cover.COVERNO,  
 Cast(Acceptance.AName as varchar(128)) as Insured,  
 Cover.CNO,  
 Cover.CStatus,  
 Acceptance.lANO,  
 Acceptance.ANO,  
 Acceptance.REGNO,  
 Acceptance.ADATE,  
 Acceptance.LUSERID as USERID,  
 SysTab.Currency,  
 cast(0 as Float) as TSI,
 cast(0 as Float) as OurShare,
 cast(0 as Float) as Gross,
 Acceptance.ASTATUS,  
 Acceptance.ATYPE,  
 Acceptance.SDate,  
 Acceptance.EDate,  
 Year(Acceptance.SDate) AS RYear,  
 Cover.ISType,  
 Acceptance.Renewal,  
 Acceptance.ESeqNo,  
 Acceptance.PolicyNo,  
 acceptance.CertificateNo  
FROM  Acceptance, Cover, SysTab, Acceptance As Acceptance_Detail, SysUserTOC, SysUserBranch
Where cover.CNO = acceptance.CNO  
 And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO  
 And Acceptance.AStatus='I'  
 And Acceptance.AType Not in ('C','A')  
 And Cover.ISType<>'T'  
 AND @P_PDate between Acceptance_Detail.PDate and Acceptance_Detail.PPDate  
 And SysUserTOC.ID=@P_UserID and Acceptance_Detail.TOC=SysUserTOC.TOC and (SysUserTOC.TOC=@P_TOC or @P_TOC='')
 And SysUserBranch.ID=@P_UserID and Acceptance_Detail.BRanch=SysUserBranch.Branch and (SysUserBranch.Branch=@P_Branch or @P_Branch='')
 And Acceptance_Detail.ANO in (SELECT ANO from Claim, CLLOSS Where (Claim.CSTATUS IN ('R','P','T','A') OR Claim.PCSTATUS IN ('A')) and Claim.CNO=CLLOSS.CNO and CLLOSS.CTLF=1 And Claim.ANO=Acceptance_Detail.ANO)  
 

GO

/****** Object:  StoredProcedure [dbo].[List19]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List19]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [List19]
end
GO
create PROCEDURE [dbo].[List19]
(@P_Days as smallint,@P_Date as Smalldatetime,@P_COB as varchar(10),@P_Branch as varchar(10), @P_UnPaidOpt as bit) 
AS 
SELECT Cast(0 as bit) as ProcessFlag, 
Cover.COVERNO, 
Cast(Acceptance.AName as varchar(128)) as Insured, 
Cover.CNO, 
Cover.CStatus, 
Acceptance.lANO, 
Acceptance.ANO, 
Acceptance.REGNO, 
Acceptance.ADATE, 
Acceptance.LUSERID as USERID, 
SysTab.Currency, 
(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
Acceptance.ASTATUS, 
Acceptance.ATYPE, 
Acceptance.SDate, 
Acceptance.EDate, 
Year(Acceptance.SDate) AS RYear, 
Cover.ISType, 
Acceptance.Renewal, 
Acceptance.ESeqNo, 
Acceptance.PolicyNo, 
Acceptance.CertificateNo 
FROM  Acceptance, Cover, SysTab, TOC 
WHERE  Cover.CNO=Acceptance.CNO 
And TOC.TOC=ACCEPTANCE.TOC and TOC.COB=@P_COB And Acceptance.Branch Like @P_Branch+'%' 
And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)And Cover.ISType<>'T' 
And Acceptance.AStatus='I' And Acceptance.AType<>'C' 
And EXISTS (SELECT A1.OANO from Acceptance A1, AccAss, Admlink, nVoucher Voucher Where A1.ANO=AccAss.ANO and A1.OANO=Acceptance.OANO and Voucher.Voucher=Admlink.Voucher and Admlink.AdmNo=AccAss.AdmNo and AccAss.Type in ('DI','IC','IR') and Voucher.nDueDate+@P_Days<@P_Date and Voucher.Nominal_CC-Voucher.Diff_CC-Voucher.Payment_CC-Voucher.Payment_OC<>0 and (@P_UnPaidOpt=0 or Voucher.Payment_CC=0)) 
 
union 
 
SELECT Cast(0 as bit) as ProcessFlag, 
Cover.COVERNO, 
Cast(Acceptance.AName as varchar(128)) as Insured, 
Cover.CNO, 
Cover.CStatus, 
Acceptance.lANO, 
Acceptance.ANO, 
Acceptance.REGNO, 
Acceptance.ADATE, 
Acceptance.LUSERID as USERID, 
SysTab.Currency, 
cast(0 as Float) as TSI,
cast(0 as Float) as OurShare,
cast(0 as Float) as Gross,
Acceptance.ASTATUS, 
Acceptance.ATYPE, 
Acceptance.SDate, 
Acceptance.EDate, 
Year(Acceptance.SDate) AS RYear, 
Cover.ISType, 
Acceptance.Renewal, 
Acceptance.ESeqNo, 
Acceptance.PolicyNo, 
Acceptance.CertificateNo 
FROM  Acceptance, Cover, SysTab, Acceptance As Acceptance_Detail, TOC 
WHERE  Cover.CNO=Acceptance.CNO 
And TOC.TOC=Acceptance_Detail.TOC and TOC.COB=@P_COB And Acceptance_Detail.Branch Like @P_Branch+'%' 
And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO And Cover.ISType<>'T' 
And Acceptance.AStatus='I' And Acceptance.AType<>'C' 
And Acceptance_Detail.AStatus='I'  And Acceptance_Detail.AType<>'C' 
And EXISTS (SELECT A1.OANO from Acceptance A1, AccAss, Admlink, nVoucher Voucher Where A1.ANO=AccAss.ANO and A1.OANO=Acceptance_Detail.OANO and Voucher.Voucher=Admlink.Voucher and Admlink.AdmNo=AccAss.AdmNo and AccAss.Type in ('DI','IC','IR') and Voucher.nDueDate+@P_Days<@P_Date and Voucher.Nominal_CC-Voucher.Diff_CC-Voucher.Payment_CC-Voucher.Payment_OC<>0 and (@P_UnPaidOpt=0 or Voucher.Payment_CC=0)) 
 

GO

/****** Object:  StoredProcedure [dbo].[List20]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List20]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [List20]
end
GO
create PROCEDURE [dbo].[List20]

(@P_USERID as varchar(255),@P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_AStatus as varchar(1))   
AS   
SELECT   
Cast(0 as bit) as ProcessFlag,   
Cover.COVERNO,   
Cast(Acceptance.AName as varchar(128)) as Insured,   
Cover.CNO,   
Cover.CStatus,   
Acceptance.lANO,   
Acceptance.ANO,   
Acceptance.REGNO,   
Acceptance.ADATE,   
Acceptance.LUSERID as USERID,   
SysTab.Currency,   
Acceptance.ASTATUS,   
Acceptance.ATYPE,   
Acceptance.SDate,   
Acceptance.EDate,   
Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear,   
Cover.ISType,   
Acceptance.Renewal,   
Acceptance.ESeqNo,   
Acceptance.PolicyNo,   
Acceptance.CertificateNo,   
(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS
FROM  Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO), Cover, SysTab   
WHERE  Cover.CNO=Acceptance.CNO   
And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)   
And Cover.ISType<>'T'   
And Acceptance.LUserID Like @P_UserID   
And Acceptance.LDate between @P_SDate and @P_EDate   
And (Acceptance.AStatus=@P_AStatus or @P_AStatus='')   
   
union   
   
Select   
Cast(0 as bit) as ProcessFlag,   
Cover.COVERNO,   
Cast(Acceptance.AName as varchar(128)) as Insured,   
Cover.CNO,   
Cover.CStatus,   
Acceptance.lANO,   
Acceptance.ANO,   
Acceptance.REGNO,   
Acceptance.ADATE,   
Acceptance.LUSERID as USERID,   
SysTab.Currency,   
Acceptance.ASTATUS,   
Acceptance.ATYPE,   
Acceptance.SDate,   
Acceptance.EDate,   
Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear,   
Cover.ISType,   
Acceptance.Renewal,   
Acceptance.ESeqNo,   
Acceptance.PolicyNo,   
Acceptance.CertificateNo,   
cast(0 as Float) as TSI,
cast(0 as Float) as OurShare,
cast(0 as Float) as Gross
FROM  Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO), Cover, SysTab
WHERE  Cover.CNO=Acceptance.CNO   
And Cover.ISType<>'T'   
and Exists   
(   
Select Top 1 Acceptance_Detail.LANO from Acceptance as Acceptance_Detail   
Where Acceptance_Detail.LANO=Acceptance.ANO and Acceptance_Detail.LANO<>Acceptance_Detail.ANO 
And Acceptance_Detail.LUserID Like @P_UserID   
And Acceptance_Detail.LDate between @P_SDate and @P_EDate   
And (Acceptance_Detail.AStatus=@P_AStatus or @P_AStatus='')   
)   
   
   



GO

/****** Object:  StoredProcedure [dbo].[List21]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List21]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [List21]
end
GO
create PROCEDURE [dbo].[List21]

 (@P_UserID varchar(255)) 
AS 
SELECT Cast(0 as bit) as ProcessFlag, 
Cover.COVERNO, 
Cast(Acceptance.AName as varchar(128)) as Insured, 
Cover.CNO, 
Cover.CStatus, 
Acceptance.lANO, 
Acceptance.ANO, 
Acceptance.REGNO, 
Acceptance.ADATE, 
Acceptance.LUSERID as USERID, 
SysTab.Currency, 
(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
Acceptance.ASTATUS, 
Acceptance.ATYPE, 
Acceptance.SDate, 
Acceptance.EDate, 
Year(Acceptance.SDate) AS RYear, 
Cover.ISType, 
Acceptance.Renewal, 
Acceptance.ESeqNo, 
Acceptance.PolicyNo, 
Acceptance.CertificateNo 
FROM  Acceptance, Cover, SysTab
WHERE  Cover.CNO=Acceptance.CNO 
And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1) 
And Acceptance.RequestF=1 and Acceptance.RequestName Like @P_UserID 
 
union 
 
SELECT Cast(0 as bit) as ProcessFlag, 
Cover.COVERNO, 
Cast(Acceptance.AName as varchar(128)) as Insured, 
Cover.CNO, 
Cover.CStatus, 
Acceptance.lANO, 
Acceptance.ANO, 
Acceptance.REGNO, 
Acceptance.ADATE, 
Acceptance.LUSERID as USERID, 
SysTab.Currency, 
cast(0 as Float) as TSI,
cast(0 as Float) as OurShare,
cast(0 as Float) as Gross,
Acceptance.ASTATUS, 
Acceptance.ATYPE, 
Acceptance.SDate, 
Acceptance.EDate, 
Year(Acceptance.SDate) AS RYear, 
Cover.ISType, 
Acceptance.Renewal, 
Acceptance.ESeqNo, 
Acceptance.PolicyNo, 
Acceptance.CertificateNo 
FROM  Acceptance, Cover, SysTab, Acceptance As Acceptance_Detail 
WHERE  Cover.CNO=Acceptance.CNO 
And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO 
And Acceptance_Detail.RequestF=1 and Acceptance_Detail.RequestName Like @P_UserID 
 
 


GO

/****** Object:  StoredProcedure [dbo].[List22]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[List22]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [List22]
end
GO
create PROCEDURE [dbo].[List22]
(@P_SDate as smalldatetime, @P_EDate as smalldatetime)
AS
SELECT Cast(0 as bit) as ProcessFlag, 
 Cover.COVERNO,
 Cast(Acceptance.AName as varchar(128)) as Insured,
 Cover.CNO,
 Cover.CStatus,
 Acceptance.lANO,
 Acceptance.ANO,
 Acceptance.REGNO,
 Acceptance.ADATE,
 Acceptance.LUSERID as USERID,
 SysTab.Currency,
 (SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
 (SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
 (SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
 Acceptance.ASTATUS,
 Acceptance.ATYPE,
 Acceptance.SDate,
 Acceptance.EDate,
 Year(Acceptance.SDate) AS RYear,
 Cover.ISType,
 Acceptance.Renewal,
 Acceptance.ESeqNo,
 Acceptance.PolicyNo,
 acceptance.CertificateNo
FROM  Acceptance, Cover, SysTab
Where cover.CNO = acceptance.CNO
 And Acceptance.ANO=Acceptance.LANO
 And Cover.OpenFlag=1
 And (SELECT sum(SI) from ICover I1 Where I1.Category='M' and I1.ANO=Acceptance.ANO)>(SELECT sum(SI) from ICover I1, Acceptance A1 Where I1.Category='M' and A1.ANO=I1.ANO and A1.AStatus='I' and A1.ANO<>A1.LANO and A1.LANO=Acceptance.ANO)
 And ((Acceptance.PDate Between @P_SDate and @P_EDate) or (Acceptance.PPDate Between @P_SDate and @P_EDate)
OR (@P_SDate Between Acceptance.PDate and Acceptance.PPDate) or (@P_EDate Between Acceptance.PDate and Acceptance.PPDate))





GO

/****** Object:  StoredProcedure [dbo].[ListDet_By_ANO]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[ListDet_By_ANO]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [ListDet_By_ANO]
end
GO
create PROCEDURE [dbo].[ListDet_By_ANO]
 (@P_ANO as integer) 
AS 
SELECT Cast(0 as bit) as ProcessFlag, 
Acceptance.CertificateNo, 
Acceptance.ESeqNo, 
Cast(Acceptance.AName as varchar(128)) as AName, 
Acceptance.ANO, 
Acceptance.REGNO, 
Acceptance.ADATE, 
Acceptance.LUSERID as USERID, 
SysTab.Currency, 
QPCalc.TSI, 
QPCalc.OurShare, 
QPCalc.Gross, 
Acceptance.ASTATUS, 
Acceptance.ATYPE, 
Acceptance.SDate, 
Acceptance.EDate, 
Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
Acceptance.ValueID, 
Acceptance.ValueDesc 
FROM 
Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), 
Cover, 
SysTab 
WHERE Cover.CNO=Acceptance.CNO And Acceptance.ANO=@P_ANO 
 
 

GO

/****** Object:  StoredProcedure [dbo].[ListDet_Next]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[ListDet_Next]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [ListDet_Next]
end
GO
create PROCEDURE [dbo].[ListDet_Next]
 (@P_ANO as integer)     
AS    
SELECT Cast(0 as bit) as ProcessFlag,Acceptance.CertificateNo, Acceptance.ESeqNo, Cast(Acceptance.AName as varchar(128)) as AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID, SysTab.Currency, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross, QPCalc.RYear,  
 Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, QPCalc.ValueID, QPCalc.ValueDesc    
FROM Acceptance, Cover, SysTab, qMasterAcceptance_PCalc() AS QPCalc    
WHERE Cover.CNO=Acceptance.CNO And QPCalc.ANO=Acceptance.ANO And Acceptance.LANO<>-1 and ((Acceptance.PANO<>-1 and Acceptance.PANO=@P_ANO) or (Acceptance.RANO<>-1 and Acceptance.RANO=@P_ANO))
    

GO

/****** Object:  StoredProcedure [dbo].[ListDet_Prev]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[ListDet_Prev]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [ListDet_Prev]
end
GO
create PROCEDURE [dbo].[ListDet_Prev]

 (@P_ANO as integer)   
AS  
SELECT Cast(0 as bit) as ProcessFlag,Acceptance.CertificateNo, Acceptance.ESeqNo, Cast(Acceptance.AName as varchar(128)) as AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE,Acceptance.LUSERID as USERID, SysTab.Currency, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross, QPCalc.RYear, 
Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, QPCalc.ValueID, QPCalc.ValueDesc  
FROM Acceptance, Cover, SysTab, qMasterAcceptance_PCalc() AS QPCalc, Acceptance AS A1  
WHERE Cover.CNO=Acceptance.CNO And QPCalc.ANO=Acceptance.ANO And Acceptance.LANO<>-1 and (Acceptance.ANO=A1.PANO or Acceptance.ANO=A1.RANO) And A1.ANO=@P_ANO  
  
  

GO

/****** Object:  StoredProcedure [dbo].[ListDet01]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[ListDet01]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [ListDet01]
end
GO
create PROCEDURE [dbo].[ListDet01]
 (@P_ANO as integer) 
AS 
SELECT Cast(0 as bit) as ProcessFlag, Acceptance.CertificateNo, Acceptance.ESeqNo,Cast(Acceptance.AName as varchar(128)) as AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, dbo.get_objectInfo(Acceptance.ANO) as ValueDesc, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross 
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab, Acceptance MAcceptance 
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO 
And (Acceptance.LANO=MAcceptance.ANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) 
 
Union 
 
SELECT Cast(0 as bit) as ProcessFlag, Acceptance.CertificateNo, Acceptance.ESeqNo,Cast(Acceptance.AName as varchar(128)) as AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, dbo.get_objectInfo(Acceptance.ANO) as ValueDesc, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross 
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab, Acceptance MAcceptance 
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO 
And (MAcceptance.RegNo<>'' and Acceptance.RegNo=MAcceptance.RegNo and Acceptance.PolicyNo<>'' and Acceptance.PolicyNo=MAcceptance.PolicyNo And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) 
 
Union 
 
SELECT Cast(0 as bit) as ProcessFlag, Acceptance.CertificateNo, Acceptance.ESeqNo,Cast(Acceptance.AName as varchar(128)) as AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, dbo.get_objectInfo(Acceptance.ANO) as ValueDesc, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross 
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab, Acceptance MAcceptance 
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO 
And (MAcceptance.AStatus='W' and MAcceptance.AType<>'N' and MAcceptance.PANO<>-1 and Acceptance.LANO=MAcceptance.PANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) 
Order By Acceptance.CertificateNo 
 

GO

/****** Object:  StoredProcedure [dbo].[ListDet02]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[ListDet02]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [ListDet02]
end
GO
create PROCEDURE [dbo].[ListDet02]
(@P_ANO as integer) 
AS 
SELECT Cast(0 as bit) as ProcessFlag, Acceptance.CertificateNo, Acceptance.ESeqNo,Cast(Acceptance.AName as varchar(128)) as AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID, SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, dbo.get_objectInfo(Acceptance.ANO) as ValueDesc, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross 
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab 
WHERE Cover.CNO=Acceptance.CNO And Acceptance.ANO=@P_ANO 
Order By Acceptance.CertificateNo 
 

GO

/****** Object:  StoredProcedure [dbo].[ListDet03]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[ListDet03]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [ListDet03]
end
GO
create PROCEDURE [dbo].[ListDet03]
 (@P_ANO as integer,@P_SDATE as smalldatetime, @P_EDATE as smalldatetime) 
AS 
SELECT Cast(0 as bit) as ProcessFlag, Acceptance.CertificateNo, Acceptance.ESeqNo,Cast(Acceptance.AName as varchar(128)) as AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,  SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, dbo.get_objectInfo(Acceptance.ANO) as ValueDesc, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross 
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab, Acceptance MAcceptance 
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO 
And (Acceptance.LANO=MAcceptance.ANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) 
And Acceptance.ADate Between @P_Sdate and @P_EDate 
 
Union 
 
SELECT Cast(0 as bit) as ProcessFlag, Acceptance.CertificateNo, Acceptance.ESeqNo,Cast(Acceptance.AName as varchar(128)) as AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,  SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, dbo.get_objectInfo(Acceptance.ANO) as ValueDesc, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross 
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab, Acceptance MAcceptance 
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO 
And (MAcceptance.RegNo<>'' and Acceptance.RegNo=MAcceptance.RegNo and Acceptance.PolicyNo<>'' and Acceptance.PolicyNo=MAcceptance.PolicyNo And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) 
And Acceptance.ADate Between @P_Sdate and @P_EDate 
 
Union 
 
SELECT Cast(0 as bit) as ProcessFlag, Acceptance.CertificateNo, Acceptance.ESeqNo,Cast(Acceptance.AName as varchar(128)) as AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,  SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, dbo.get_objectInfo(Acceptance.ANO) as ValueDesc, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross 
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab, Acceptance MAcceptance 
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO 
And (MAcceptance.AStatus='W' and MAcceptance.AType<>'N' and MAcceptance.PANO<>-1 and Acceptance.LANO=MAcceptance.PANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) 
And Acceptance.ADate Between @P_Sdate and @P_EDate 
Order By Acceptance.CertificateNo 
 

GO

/****** Object:  StoredProcedure [dbo].[ListDet04]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[ListDet04]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [ListDet04]
end
GO
create PROCEDURE [dbo].[ListDet04]
 (@P_ANO as integer,@P_FCERTNO as varchar(20), @P_LCERTNO as varchar(20)) 
AS 
SELECT Cast(0 as bit) as ProcessFlag, Acceptance.CertificateNo, Acceptance.ESeqNo,Cast(Acceptance.AName as varchar(128)) as AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,  SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, dbo.get_objectInfo(Acceptance.ANO) as ValueDesc, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross 
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab, Acceptance MAcceptance 
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO 
And (Acceptance.LANO=MAcceptance.ANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) 
And Acceptance.CertificateNo Between @P_FCertNo and @P_LCertNo 
 
Union 
 
SELECT Cast(0 as bit) as ProcessFlag, Acceptance.CertificateNo, Acceptance.ESeqNo,Cast(Acceptance.AName as varchar(128)) as AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,  SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, dbo.get_objectInfo(Acceptance.ANO) as ValueDesc, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross 
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab, Acceptance MAcceptance 
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO 
And (MAcceptance.RegNo<>'' and Acceptance.RegNo=MAcceptance.RegNo and Acceptance.PolicyNo<>'' and Acceptance.PolicyNo=MAcceptance.PolicyNo And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) 
And Acceptance.CertificateNo Between @P_FCertNo and @P_LCertNo 
 
Union 
 
SELECT Cast(0 as bit) as ProcessFlag, Acceptance.CertificateNo, Acceptance.ESeqNo,Cast(Acceptance.AName as varchar(128)) as AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,  SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, dbo.get_objectInfo(Acceptance.ANO) as ValueDesc, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross 
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab, Acceptance MAcceptance 
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO 
And (MAcceptance.AStatus='W' and MAcceptance.AType<>'N' and MAcceptance.PANO<>-1 and Acceptance.LANO=MAcceptance.PANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) 
And Acceptance.CertificateNo Between @P_FCertNo and @P_LCertNo 
Order By Acceptance.CertificateNo 
 
 

GO

/****** Object:  StoredProcedure [dbo].[ListDet05]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[ListDet05]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [ListDet05]
end
GO
create PROCEDURE [dbo].[ListDet05]
 (@P_ANO as integer,@P_FBATCHNO as varchar(20), @P_LBATCHNO as varchar(20)) 
AS 
SELECT Cast(0 as bit) as ProcessFlag, Acceptance.CertificateNo, Acceptance.ESeqNo,Cast(Acceptance.AName as varchar(128)) as AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,  SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, dbo.get_objectInfo(Acceptance.ANO) as ValueDesc, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross 
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab, Acceptance MAcceptance 
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO 
And (Acceptance.LANO=MAcceptance.ANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) 
And Acceptance.BatchNo Between @P_FBatchNo and @P_LBatchNo 
 
Union 
 
SELECT Cast(0 as bit) as ProcessFlag, Acceptance.CertificateNo, Acceptance.ESeqNo,Cast(Acceptance.AName as varchar(128)) as AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,  SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, dbo.get_objectInfo(Acceptance.ANO) as ValueDesc, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross 
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab, Acceptance MAcceptance 
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO 
And (MAcceptance.RegNo<>'' and Acceptance.RegNo=MAcceptance.RegNo and Acceptance.PolicyNo<>'' and Acceptance.PolicyNo=MAcceptance.PolicyNo And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) 
And Acceptance.BatchNo Between @P_FBatchNo and @P_LBatchNo 
 
Union 
 
SELECT Cast(0 as bit) as ProcessFlag, Acceptance.CertificateNo, Acceptance.ESeqNo,Cast(Acceptance.AName as varchar(128)) as AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID,  SysTab.Currency, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, dbo.get_objectInfo(Acceptance.ANO) as ValueDesc, Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) as RYear, QPCalc.TSI, QPCalc.OurShare, QPCalc.Gross 
FROM Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), Cover, SysTab, Acceptance MAcceptance 
WHERE MAcceptance.ANO=@P_ANO and Cover.CNO=MAcceptance.CNO 
And (MAcceptance.AStatus='W' and MAcceptance.AType<>'N' and MAcceptance.PANO<>-1 and Acceptance.LANO=MAcceptance.PANO And Acceptance.ANO<>Acceptance.LANO And Acceptance.LANO<>-1) 
And Acceptance.BatchNo Between @P_FBatchNo and @P_LBatchNo 
Order By Acceptance.CertificateNo 
 

GO

/****** Object:  StoredProcedure [dbo].[ListQry_2]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[ListQry_2]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [ListQry_2]
end
GO
create PROCEDURE [dbo].[ListQry_2]
(@P_ANO as integer)
AS   
SELECT Cast(0 as bit) as ProcessFlag,   
Cover.COVERNO,   
Cast(Acceptance.AName as varchar(128)) as Insured,   
Cover.CNO,   
Cover.CStatus,   
Acceptance.lANO,   
Acceptance.ANO,   
Acceptance.REGNO,   
Acceptance.ADATE,   
Acceptance.LUSERID as USERID,   
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
Acceptance.CertificateNo   
FROM  Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO), Cover, SysTab   
WHERE  Cover.CNO=Acceptance.CNO   
And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)   
And Cover.ISType<>'T'
and Acceptance.ano=@P_ANO 
	

GO

/****** Object:  StoredProcedure [dbo].[ListQry_2_b]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[ListQry_2_b]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [ListQry_2_b]
end
GO
create PROCEDURE [dbo].[ListQry_2_b]
 (@P_ANO as integer, @P_CertificateNo as varchar(255))
AS
SELECT Distinct
Cast(0 as bit) as ProcessFlag,   
Cover.COVERNO,   
Cast(Acceptance.AName as varchar(128)) as Insured,   
Cover.CNO,   
Cover.CStatus,   
Acceptance.lANO,   
Acceptance.ANO,   
Acceptance.REGNO,   
Acceptance.ADATE,   
Acceptance.LUSERID as USERID,   
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
Acceptance.CertificateNo   
FROM  Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO), Cover, SysTab, Acceptance as acceptance_detail
WHERE  Cover.CNO=Acceptance.CNO   
And Cover.ISType<>'T'
and Acceptance.ano=@P_ANO 
and acceptance.ano = acceptance_detail.lano 
and Acceptance_detail.ANO<>Acceptance_detail.LANO
And acceptance_detail.CertificateNo = @P_CertificateNo


GO

/****** Object:  StoredProcedure [dbo].[ListSR]    Script Date: 12/21/2017 1:39:04 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[ListSR]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure [ListSR]
end
GO
create PROCEDURE [dbo].[ListSR]
(@P_ID as int)  
AS  
SELECT Cast(0 as bit) as ProcessFlag,   
 Cover.COVERNO,  
 Cast(Acceptance.AName as varchar(128)) as Insured,  
 Cover.CNO,  
 Cover.CStatus,  
 Acceptance.lANO,  
 Acceptance.ANO,  
 Acceptance.REGNO,  
 Acceptance.ADATE,  
 Acceptance.LUSERID as USERID,  
 SysTab.Currency,  
 QPCalc.TSI,  
 QPCalc.OurShare,  
 QPCalc.Gross,  
 Acceptance.ASTATUS,  
 Acceptance.ATYPE,  
 Acceptance.SDate,  
 Acceptance.EDate,  
 Year(Acceptance.SDate) AS RYear,  
 Cover.ISType,  
 Acceptance.Renewal,  
 Acceptance.ESeqNo,  
 Acceptance.PolicyNo,  
 acceptance.CertificateNo  
FROM  Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc, TOC, SysRequest  
Where cover.CNO = acceptance.CNO  
 And QPCalc.ANO=Acceptance.ANO  
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)  
 And SysRequest.ID=@P_ID  
 And SysRequest.Param2 in ('MAR','UND','CLM')  
 And SysRequest.Param3=Acceptance.ANO  
 And TOC.TOC=ACCEPTANCE.TOC  
    
Union  
    
SELECT Cast(0 as bit) as ProcessFlag,   
 Cover.COVERNO,  
 Cast(Acceptance.AName as varchar(128)) as Insured,  
 Cover.CNO,  
 Cover.CStatus,  
 Acceptance.lANO,  
 Acceptance.ANO,  
 Acceptance.REGNO,  
 Acceptance.ADATE,  
 Acceptance.LUSERID as USERID,  
 SysTab.Currency,  
 QPCalc.TSI,  
 QPCalc.OurShare,  
 QPCalc.Gross,  
 Acceptance.ASTATUS,  
 Acceptance.ATYPE,  
 Acceptance.SDate,  
 Acceptance.EDate,  
 Year(Acceptance.SDate) AS RYear,  
 Cover.ISType,  
 Acceptance.Renewal,  
 Acceptance.ESeqNo,  
 Acceptance.PolicyNo,  
 acceptance.CertificateNo  
FROM  Acceptance, Cover, SysTab, QMasterAcceptance_PCalc() AS QPCalc, Acceptance As Acceptance_Detail, TOC, SysRequest  
Where cover.CNO = acceptance.CNO  
 And QPCalc.ANO=Acceptance.ANO  
 And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO  
 And SysRequest.ID=@P_ID  
 And SysRequest.Param2 in ('MAR','UND','CLM')  
 And SysRequest.Param3=Acceptance_Detail.ANO  
 And TOC.TOC=Acceptance_Detail.TOC 
 

GO



insert into PatchVersioning
select '36.03 Update Script - List Query (DN) (Execute Before Kom 2.27)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='36.02 Update Script - WF TASK (Only CGISS)'
Select @CurrSCript='36.03 Update Script - List Query (DN) (Execute Before Kom 2.27)'


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
