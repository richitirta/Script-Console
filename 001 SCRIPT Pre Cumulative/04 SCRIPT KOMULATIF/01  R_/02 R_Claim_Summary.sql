
Drop Function R_Claim_Detail
GO
Create FUNCTION R_Claim_Detail(@P_SDate as SmallDatetime, @P_EDate as  smalldatetime)
RETURNS @TCLAIM TABLE (Remarks varchar(50), Date smalldatetime, CNO int, ClaimNo varchar(20), Branch varchar(10), UWYear Int, ACYear Int, Currency varchar(10), TOC varchar(10), Claim_OS_Previous Float Default 0,Claim_Register Float Default 0, Claim_Settle Float Default 0, Claim_Close Float Default 0, Claim_OS_Current Float Default 0)
AS
BEGIN
Declare @P_PEDATE as SmallDatetime
Set @P_PEDATE=dateadd(day,-1,@P_SDATE)


insert into @TClaim(Remarks, Date, CNO, ClaimNo, Branch, UWYear, ACYear, Currency, TOC, Claim_OS_Previous, Claim_Register, Claim_Settle, Claim_Close, Claim_OS_Current)

Select Remarks, Date, CNO, ClaimNo, Branch, UWYear, ACYear, Currency, TOC, sum(Claim_OS_Previous) as Claim_OS_Previous, sum(Claim_Register) as Claim_Register, sum(Claim_Settle) as Claim_Settle, sum(Claim_Close) as Claim_Close, sum(Claim_OS_Current) as Claim_OS_Current

From (

Select 'Previous Claim Oustanding' as Remarks, @P_PEDate as Date, C1.CNO as CNO, C1.ClaimNo, C1.Branch, year(A1.SDate) as UWYear, year(A1.ADate) as ACYear, C1.Currency, C1.TOC, sum(Gross_OS) as Claim_OS_Previous, 0 as Claim_Register, 0 as Claim_Settle, 0 as Claim_Close, 0 as Claim_OS_Current
from OS_Net_Claim_By_Detail(@P_PEDate) C1, Acceptance A1 Where A1.ANO=C1.ANO
Group By C1.CNO, C1.ClaimNo, C1.Branch, Year(A1.SDate), year(A1.ADate), C1.Currency, C1.TOC

union all

Select 
Max(
Case 
When PClaim.CNO is null Then 'Register Claim Estimatino (New)'
When  PClaim.CStatus='C' and PClaim.PCStatus='A' Then 'Re-Open Claim'
else 'Register Claim Estimation (Correction)'
end) as Remarks,
C1.Date, C1.CCNO as CNO, C1.ClaimNo, C1.Branch, year(A1.SDate) as UWYear, year(A1.ADate) as ACYear, C1.Currency, C1.TOC, 0 as Claim_OS_Previous, sum(Claim_Register) as Claim_Register, 0 as Claim_Settle, 0 as Claim_Close, 0 as Claim_OS_Current
from Claim_Register_By_Detail(@P_Sdate,@P_EDate) C1 Inner Join Claim C2 on (C2.CNO=C1.CCNO) Left Join Claim PClaim on (PClaim.CNO=C2.PCNO), Acceptance A1 Where A1.ANO=C1.ANO
Group By C1.Date, C1.CCNO, C1.ClaimNo, C1.Branch, Year(A1.SDate), year(A1.ADate), C1.Currency, C1.TOC

union all

Select
Max(
Case 
When PClaim.CNO is null Then 'Claim Paid Settlement'
When  PClaim.CStatus='C' and PClaim.PCStatus='A' Then 'Claim Paid Settlement'
else 'Claim Paid Settlement'
end) as Remarks, 
C1.Date, C1.CCNO as CNO, C1.ClaimNo, C1.Branch, year(A1.SDate) as UWYear, year(A1.ADate) as ACYear, C1.Currency, C1.TOC, 0 as Claim_OS_Previous, 0 as Claim_Register, sum(Claim_Settle) as Claim_Settle, 0 as Claim_Close, 0 as Claim_OS_Current
from Claim_Settle_By_Detail(@P_Sdate,@P_EDate) C1 Inner Join Claim C2 on (C2.CNO=C1.CCNO) Left Join Claim PClaim on (PClaim.CNO=C2.PCNO), Acceptance A1 Where A1.ANO=C1.ANO
Group By C1.Date, C1.CCNO, C1.ClaimNo, C1.Branch, Year(A1.SDate), year(A1.ADate), C1.Currency, C1.TOC

union all

Select 'Claim Close/Declined' as Remarks, C1.Date, C1.CCNO as CNO, C1.ClaimNo, C1.Branch, year(A1.SDate) as UWYear, year(A1.ADate) as ACYear, C1.Currency, C1.TOC, 0 as Claim_OS_Previous, 0 as Claim_Register, 0 as Claim_Settle, sum(Claim_Close) as Claim_Close, 0 as Claim_OS_Current
from Claim_Close_By_Detail(@P_Sdate,@P_EDate) C1, Acceptance A1 Where A1.ANO=C1.ANO
Group By C1.Date, C1.CCNO, C1.ClaimNo, C1.Branch, Year(A1.SDate), year(A1.ADate), C1.Currency, C1.TOC

union all

Select 'Current Claim Oustanding' as Remarks,  @P_EDate as Date, C1.CNO as CNO, C1.ClaimNo, C1.Branch, year(A1.SDate) as UWYear, year(A1.ADate) as ACYear, C1.Currency, C1.TOC, 0 as Claim_OS_Previous, 0 as Claim_Register, 0 as Claim_Settle, 0 as Claim_Close, sum(Gross_OS) as Claim_OS_Current
from OS_Net_Claim_By_Detail(@P_EDate) C1, Acceptance A1 Where A1.ANO=C1.ANO
Group By C1.CNO, C1.ClaimNo, C1.Branch, Year(A1.SDate), year(A1.ADate), C1.Currency, C1.TOC
) C

Group By Currency, Date, CNO, ClaimNo, Branch, UWYear, ACYear, TOC, Remarks

Return
END


GO

Drop Function R_Claim_Summary
GO
Create FUNCTION R_Claim_Summary(@P_SDate as SmallDatetime, @P_EDate as  smalldatetime)
RETURNS @TCLAIM TABLE (Branch varchar(10), UWYear Int, ACYear Int, Currency varchar(10), TOC varchar(10), Claim_OS_Previous Float Default 0,Claim_Register Float Default 0, Claim_Settle Float Default 0, Claim_Close Float Default 0, Claim_OS_Current Float Default 0)
AS
BEGIN
Declare @P_PEDATE as SmallDatetime
Set @P_PEDATE=dateadd(day,-1,@P_SDATE)


insert into @TClaim(Branch, UWYear, ACYear, Currency, TOC, Claim_OS_Previous, Claim_Register, Claim_Settle, Claim_Close, Claim_OS_Current)

Select Branch, UWYear, ACYear, Currency, TOC, sum(Claim_OS_Previous) as Claim_OS_Previous, sum(Claim_Register) as Claim_Register, sum(Claim_Settle) as Claim_Settle, sum(Claim_Close) as Claim_Close, sum(Claim_OS_Current) as Claim_OS_Current

From (

Select C1.Branch, year(A1.SDate) as UWYear, year(A1.ADate) as ACYear, C1.Currency, C1.TOC, sum(Gross_OS) as Claim_OS_Previous, 0 as Claim_Register, 0 as Claim_Settle, 0 as Claim_Close, 0 as Claim_OS_Current
from OS_Net_Claim_By_Detail(@P_PEDate) C1, Acceptance A1 Where A1.ANO=C1.ANO
Group By C1.Branch, Year(A1.SDate), year(A1.ADate), C1.Currency, C1.TOC

union all

Select C1.Branch, year(A1.SDate) as UWYear, year(A1.ADate) as ACYear, C1.Currency, C1.TOC, 0 as Claim_OS_Previous, sum(Claim_Register) as Claim_Register, 0 as Claim_Settle, 0 as Claim_Close, 0 as Claim_OS_Current
from Claim_Register_By_Detail(@P_Sdate,@P_EDate) C1, Acceptance A1 Where A1.ANO=C1.ANO
Group By C1.Branch, Year(A1.SDate), year(A1.ADate), C1.Currency, C1.TOC

union all

Select C1.Branch, year(A1.SDate) as UWYear, year(A1.ADate) as ACYear, C1.Currency, C1.TOC, 0 as Claim_OS_Previous, 0 as Claim_Register, sum(Claim_Settle) as Claim_Settle, 0 as Claim_Close, 0 as Claim_OS_Current
from Claim_Settle_By_Detail(@P_Sdate,@P_EDate) C1, Acceptance A1 Where A1.ANO=C1.ANO
Group By C1.Branch, Year(A1.SDate), year(A1.ADate), C1.Currency, C1.TOC

union all

Select C1.Branch, year(A1.SDate) as UWYear, year(A1.ADate) as ACYear, C1.Currency, C1.TOC, 0 as Claim_OS_Previous, 0 as Claim_Register, 0 as Claim_Settle, sum(Claim_Close) as Claim_Close, 0 as Claim_OS_Current
from Claim_Close_By_Detail(@P_Sdate,@P_EDate) C1, Acceptance A1 Where A1.ANO=C1.ANO
Group By C1.Branch, Year(A1.SDate), year(A1.ADate), C1.Currency, C1.TOC

union all

Select C1.Branch, year(A1.SDate) as UWYear, year(A1.ADate) as ACYear, C1.Currency, C1.TOC, 0 as Claim_OS_Previous, 0 as Claim_Register, 0 as Claim_Settle, 0 as Claim_Close, sum(Gross_OS) as Claim_OS_Current
from OS_Net_Claim_By_Detail(@P_EDate) C1, Acceptance A1 Where A1.ANO=C1.ANO
Group By C1.Branch, Year(A1.SDate), year(A1.ADate), C1.Currency, C1.TOC
) C

Group By Branch, UWYear, ACYear,Currency, TOC

Return
END



GO

Drop Function R_Claim_Detail_Net
GO

      
    
GO


CREATE FUNCTION R_Claim_Detail_Net(@P_SDate as SmallDatetime, @P_EDate as  smalldatetime)  
RETURNS @TCLAIM TABLE (Date SmallDateTime, CNO int, ClaimNo varchar(20), Branch varchar(10), UWYear Int, ACYear Int, Currency varchar(10), TOC varchar(10), Claim_OS_Previous Float Default 0,Claim_Register Float Default 0, Claim_Settle Float Default 0, Claim_Close Float Default 0, Claim_OS_Current Float Default 0)  
AS  
BEGIN  
Declare @P_PEDATE as SmallDatetime  
Set @P_PEDATE=dateadd(day,-1,@P_SDATE)  
  
  
insert into @TClaim(Date, CNO, ClaimNo, Branch, UWYear, ACYear, Currency, TOC, Claim_OS_Previous, Claim_Register, Claim_Settle, Claim_Close, Claim_OS_Current)  
  
Select Date, CNO, ClaimNo, Branch, UWYear, ACYear, Currency, TOC, sum(Claim_OS_Previous) as Claim_OS_Previous, sum(Claim_Register) as Claim_Register, sum(Claim_Settle) as Claim_Settle, sum(Claim_Close) as Claim_Close, sum(Claim_OS_Current) as Claim_OS_Current  
  
From (  
  
Select @P_PEDate Date, C1.CNO, C1.ClaimNo, C1.Branch, year(A1.SDate) as UWYear, year(A1.ADate) as ACYear, C1.Currency, C1.TOC, sum(C1.GROSS_OS_NET+C1.EXPENSE_OS) as Claim_OS_Previous, 0 as Claim_Register, 0 as Claim_Settle, 0 as Claim_Close, 0 as Claim_OS_Current  
from OS_Claim_By_Detail(@P_PEDate) C1, Acceptance A1 Where A1.ANO=C1.ANO 
Group By C1.CNO, C1.ClaimNo, C1.Branch, Year(A1.SDate), year(A1.ADate), C1.Currency, C1.TOC  
  
union all  
  
Select C1.Date, C1.CCNO as CNO, C1.ClaimNo, C1.Branch, year(A1.SDate) as UWYear, year(A1.ADate) as ACYear, C1.Currency, C1.TOC, 0 as Claim_OS_Previous, sum(Claim_Register_Net) as Claim_Register, 0 as Claim_Settle, 0 as Claim_Close, 0 as Claim_OS_Current  
from Claim_Register_By_Detail(@P_Sdate,@P_EDate) C1, Acceptance A1 Where A1.ANO=C1.ANO  
Group By C1.Date, C1.CCNO, C1.ClaimNo, C1.Branch, Year(A1.SDate), year(A1.ADate), C1.Currency, C1.TOC  
  
union all  
  
Select C1.Date, C1.CCNO as CNO, C1.ClaimNo, C1.Branch, year(A1.SDate) as UWYear, year(A1.ADate) as ACYear, C1.Currency, C1.TOC, 0 as Claim_OS_Previous, 0 as Claim_Register, sum(Claim_Settle_Net) as Claim_Settle, 0 as Claim_Close, 0 as Claim_OS_Current  
from Claim_Settle_By_Detail(@P_Sdate,@P_EDate) C1, Acceptance A1 Where A1.ANO=C1.ANO  
Group By C1.Date, C1.CCNO, C1.ClaimNo, C1.Branch, Year(A1.SDate), year(A1.ADate), C1.Currency, C1.TOC  
  
union all  
  
Select C1.Date, C1.CCNO as CNO, C1.ClaimNo, C1.Branch, year(A1.SDate) as UWYear, year(A1.ADate) as ACYear, C1.Currency, C1.TOC, 0 as Claim_OS_Previous, 0 as Claim_Register, 0 as Claim_Settle, sum(Claim_Close_Net) as Claim_Close, 0 as Claim_OS_Current  
from Claim_Close_By_Detail(@P_Sdate,@P_EDate) C1, Acceptance A1 Where A1.ANO=C1.ANO  
Group By C1.Date, C1.CCNO, C1.ClaimNo, C1.Branch, Year(A1.SDate), year(A1.ADate), C1.Currency, C1.TOC  
  
union all  
  
Select @P_EDate as Date, C1.CNO, C1.ClaimNo, C1.Branch, year(A1.SDate) as UWYear, year(A1.ADate) as ACYear, C1.Currency, C1.TOC, 0 as Claim_OS_Previous, 0 as Claim_Register, 0 as Claim_Settle, 0 as Claim_Close, sum(C1.GROSS_OS_NET+C1.EXPENSE_OS) as Claim_OS_Current  
from OS_Claim_By_Detail(@P_EDate) C1, Acceptance A1 Where A1.ANO=C1.ANO 
Group By C1.CNO, C1.ClaimNo, C1.Branch, Year(A1.SDate), year(A1.ADate), C1.Currency, C1.TOC  
) C  
  
Group By Date, CNO, ClaimNo, Branch, UWYear, ACYear, Currency, TOC  
  
Return  
END  
  
GO



Drop FUNCTION R_Claim_Summary_Net


GO


Create FUNCTION R_Claim_Summary_Net(@P_SDate as SmallDatetime, @P_EDate as  smalldatetime)  
RETURNS @TCLAIM TABLE (Branch varchar(10), UWYear Int, ACYear Int, Currency varchar(10), TOC varchar(10), Claim_OS_Previous Float Default 0,Claim_Register Float Default 0, Claim_Settle Float Default 0, Claim_Close Float Default 0, Claim_OS_Current Float Default 0)  
AS  
BEGIN  
Declare @P_PEDATE as SmallDatetime  
Set @P_PEDATE=dateadd(day,-1,@P_SDATE)  
  
  
insert into @TClaim(Branch, UWYear, ACYear, Currency, TOC, Claim_OS_Previous, Claim_Register, Claim_Settle, Claim_Close, Claim_OS_Current)  
  
Select Branch, UWYear, ACYear, Currency, TOC, sum(Claim_OS_Previous) as Claim_OS_Previous, sum(Claim_Register) as Claim_Register, sum(Claim_Settle) as Claim_Settle, sum(Claim_Close) as Claim_Close, sum(Claim_OS_Current) as Claim_OS_Current  
  
From (  
  
Select C1.Branch, year(A1.SDate) as UWYear, year(A1.ADate) as ACYear, C1.Currency, C1.TOC, sum((C1.GROSS_LOSS* (C2.ERETENTION)/100)-(C1.GROSS_SETTLED* (C2.RETENTION)/100)) as Claim_OS_Previous, 0 as Claim_Register, 0 as Claim_Settle, 0 as Claim_Close, 0 as Claim_OS_Current  
from OS_Claim_By_Detail(@P_PEDate) C1, CArrHeader C2, Acceptance A1 Where A1.ANO=C1.ANO and C1.CNO=C2.CNO
Group By C1.Branch, Year(A1.SDate), year(A1.ADate), C1.Currency, C1.TOC  
  
union all  
  
Select C1.Branch, year(A1.SDate) as UWYear, year(A1.ADate) as ACYear, C1.Currency, C1.TOC, 0 as Claim_OS_Previous, sum(Claim_Register_Net) as Claim_Register, 0 as Claim_Settle, 0 as Claim_Close, 0 as Claim_OS_Current  
from Claim_Register_By_Detail(@P_Sdate,@P_EDate) C1, Acceptance A1 Where A1.ANO=C1.ANO  
Group By C1.Branch, Year(A1.SDate), year(A1.ADate), C1.Currency, C1.TOC  
  
union all  
  
Select C1.Branch, year(A1.SDate) as UWYear, year(A1.ADate) as ACYear, C1.Currency, C1.TOC, 0 as Claim_OS_Previous, 0 as Claim_Register, sum(Claim_Settle_Net) as Claim_Settle, 0 as Claim_Close, 0 as Claim_OS_Current  
from Claim_Settle_By_Detail(@P_Sdate,@P_EDate) C1, Acceptance A1 Where A1.ANO=C1.ANO  
Group By C1.Branch, Year(A1.SDate), year(A1.ADate), C1.Currency, C1.TOC  
  
union all  
  
Select C1.Branch, year(A1.SDate) as UWYear, year(A1.ADate) as ACYear, C1.Currency, C1.TOC, 0 as Claim_OS_Previous, 0 as Claim_Register, 0 as Claim_Settle, sum(Claim_Close_Net) as Claim_Close, 0 as Claim_OS_Current  
from Claim_Close_By_Detail(@P_Sdate,@P_EDate) C1, Acceptance A1 Where A1.ANO=C1.ANO  
Group By C1.Branch, Year(A1.SDate), year(A1.ADate), C1.Currency, C1.TOC  
  
union all  
  
Select C1.Branch, year(A1.SDate) as UWYear, year(A1.ADate) as ACYear, C1.Currency, C1.TOC, 0 as Claim_OS_Previous, 0 as Claim_Register, 0 as Claim_Settle, 0 as Claim_Close, sum((C1.GROSS_LOSS* (C2.ERETENTION)/100)-(C1.GROSS_SETTLED* (C2.RETENTION)/100)) as Claim_OS_Current  
from OS_Claim_By_Detail(@P_EDate) C1, CArrHeader C2, Acceptance A1 Where A1.ANO=C1.ANO and C1.CNO=C2.CNO
Group By C1.Branch, Year(A1.SDate), year(A1.ADate), C1.Currency, C1.TOC  
) C  
  
Group By Branch, UWYear, ACYear,Currency, TOC  
  
Return  
END  
  
  
  
--Examples

-- Select *  from R_Claim_Detail('01/01/2007','12/31/2010')
-- Select * from R_Claim_Detail_Net('01/01/2007','12/31/2010')
-- Select *  from R_Claim_Summary('01/01/2007','12/31/2010')
-- Select * from R_Claim_Summary_Net('01/01/2007','12/31/2010')