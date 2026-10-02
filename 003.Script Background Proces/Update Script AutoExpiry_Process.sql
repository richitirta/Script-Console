IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'AutoExpiry_Process') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure AutoExpiry_Process
end
GO
CREATE Procedure AutoExpiry_Process(@P_PDate as smalldatetime)                                
as                       
Select Acceptance.PolicyNo, Acceptance.CertificateNo, Acceptance.ANO, Acceptance.LANO, Cover.OpenFlag, Cover.CNO, Acceptance.EDate from Acceptance, Cover, TOC           
Where (Cover.CNO = Acceptance.CNO And (Acceptance.LANO = -1 Or (Cover.OpenFlag = 1 And Acceptance.LANO <> Acceptance.ANO) Or (Cover.OpenFlag = 0 And Acceptance.LANO=Acceptance.ANO)))          
and TOC.TOC=Cover.TOC    
and Acceptance.AStatus='I' 
and Acceptance.AType not in ('C','A') 
and datediff(day, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, Acceptance.EDATE),@P_PDate)>=TOC.EltDays and TOC.EltDays<>0          
and Cover.ISType not in ('T') --Exclude Inward Treaty  
and not Exists (Select PANO from Acceptance EA Where EA.PANO=Acceptance.ANO)          
go


  insert into PatchVersioning
select 'Update Script AutoExpiry_Process',GETDATE()
go