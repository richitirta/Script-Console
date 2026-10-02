DROP Procedure AutoGenerateBilling_Process
GO
CREATE Procedure AutoGenerateBilling_Process(@P_PDate as smalldatetime)                                            
as                                  
Select C1.CollType, C1.AutoNum, C1.Segment, C1.CGroup, C1.TOC, C1.AutoCollBy, C2.Reminder, C2.Description, C1.DataType, C2.Day_1, C2.Day_2, C2.RuleID, C2.Class, C2.Erule, A.RepName, A.ExeName, A.NeedEmailF, A.NeedPrintF
from CollType C1
Inner Join CollType_RRule C2 on (C2.CollType=C1.CollType and C2.DDay=day(@P_PDate))
Inner Join APDRuleD A on (A.RuleID=C2.RuleID and A.Class=C2.Class)
Where C1.AllowedF=1 and  C1.AutoCollby<>'' 
Order By C1.CollType, C2.Reminder
go