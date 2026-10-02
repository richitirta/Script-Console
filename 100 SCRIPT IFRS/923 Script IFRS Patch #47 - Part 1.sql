IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Beginning' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_Beginning float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_GainLoss_DiscRate' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_BEL ADD BEL_GainLoss_DiscRate float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_Beginning' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_Beginning float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BEL_GainLoss_DiscRate' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_BEL'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_BEL ADD BEL_GainLoss_DiscRate float(53) NULL
END
GO





IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RA_Beginning' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_RA'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_RA ADD RA_Beginning float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RA_GainLoss_DiscRate' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_RA'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_RA ADD RA_GainLoss_DiscRate float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RA_Beginning' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_RA'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_RA ADD RA_Beginning float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RA_GainLoss_DiscRate' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_RA'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_RA ADD RA_GainLoss_DiscRate float(53) NULL
END
GO






IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CSM_Start' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_CSM'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_CSM ADD CSM_Start float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CSM_End' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_CSM'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_CSM ADD CSM_End float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CSM_Start' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_CSM'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_CSM ADD CSM_Start float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CSM_End' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_CSM'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_CSM ADD CSM_End float(53) NULL
END
GO






IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'LOSS_Start' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_LOSS'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_LOSS ADD LOSS_Start float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'LOSS_End' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_LOSS'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_LOSS ADD LOSS_End float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'LOSS_Start' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_LOSS'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_LOSS ADD LOSS_Start float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'LOSS_End' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_LOSS'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_LOSS ADD LOSS_End float(53) NULL
END
GO



IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PAA_Start' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_PAA'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_PAA ADD PAA_Start float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PAA_End' AND Object_ID = Object_ID(N'IFRS_Calculation_Detail_PAA'))
BEGIN
ALTER TABLE IFRS_Calculation_Detail_PAA ADD PAA_End float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PAA_Start' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_PAA'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_PAA ADD PAA_Start float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PAA_End' AND Object_ID = Object_ID(N'IFRS_Initial_Detail_PAA'))
BEGIN
ALTER TABLE IFRS_Initial_Detail_PAA ADD PAA_End float(53) NULL
END
GO




Select I.DataID, (((I.EffYear*12+I.EffMonth)-(I.Year*12+I.Month)+1)-1) / 12+1 as EffYearN into #DataID
from 
IFRS_Initial I

Select I2.GroupID, I2.GroupType, I2.EffMonth, I2.EffYear, (((I2.EffYear*12+I2.EffMonth)-(I1.Year*12+I1.Month)+1)-1) / 12+1 as EffYearN into #GroupID
from 
IFRS_Calculation I1 Inner Join IFRS_Calculation_Detail I2 on (I1.GroupID=I2.GroupID)


Update I set BEL_Beginning=
case 
When G.EffYearN=1 Then I.BEL_Beginning_1
When G.EffYearN=2 Then I.BEL_Beginning_2
When G.EffYearN=3 Then I.BEL_Beginning_3
When G.EffYearN=4 Then I.BEL_Beginning_4
When G.EffYearN=5 Then I.BEL_Beginning_5
When G.EffYearN=6 Then I.BEL_Beginning_6
When G.EffYearN=7 Then I.BEL_Beginning_7
When G.EffYearN=8 Then I.BEL_Beginning_8
When G.EffYearN=9 Then I.BEL_Beginning_9
When G.EffYearN=10 Then I.BEL_Beginning_10
When G.EffYearN=11 Then I.BEL_Beginning_11
When G.EffYearN=12 Then I.BEL_Beginning_12
When G.EffYearN=13 Then I.BEL_Beginning_13
When G.EffYearN=14 Then I.BEL_Beginning_14
When G.EffYearN=15 Then I.BEL_Beginning_15
When G.EffYearN=16 Then I.BEL_Beginning_16
When G.EffYearN=17 Then I.BEL_Beginning_17
When G.EffYearN=18 Then I.BEL_Beginning_18
When G.EffYearN=19 Then I.BEL_Beginning_19
When G.EffYearN=20 Then I.BEL_Beginning_20
When G.EffYearN=21 Then I.BEL_Beginning_21
When G.EffYearN=22 Then I.BEL_Beginning_22
When G.EffYearN=23 Then I.BEL_Beginning_23
When G.EffYearN=24 Then I.BEL_Beginning_24
When G.EffYearN=25 Then I.BEL_Beginning_25
When G.EffYearN=26 Then I.BEL_Beginning_26
When G.EffYearN=27 Then I.BEL_Beginning_27
When G.EffYearN=28 Then I.BEL_Beginning_28
When G.EffYearN=29 Then I.BEL_Beginning_29
When G.EffYearN=30 Then I.BEL_Beginning_30
else 0
End 
from #DataID G
Inner Join ifrs_initial_Detail_BEL I on (I.DataID=G.DataID)


GO

Update I set RA_Beginning=
case 
When G.EffYearN=1 Then I.RA_Beginning_1
When G.EffYearN=2 Then I.RA_Beginning_2
When G.EffYearN=3 Then I.RA_Beginning_3
When G.EffYearN=4 Then I.RA_Beginning_4
When G.EffYearN=5 Then I.RA_Beginning_5
When G.EffYearN=6 Then I.RA_Beginning_6
When G.EffYearN=7 Then I.RA_Beginning_7
When G.EffYearN=8 Then I.RA_Beginning_8
When G.EffYearN=9 Then I.RA_Beginning_9
When G.EffYearN=10 Then I.RA_Beginning_10
When G.EffYearN=11 Then I.RA_Beginning_11
When G.EffYearN=12 Then I.RA_Beginning_12
When G.EffYearN=13 Then I.RA_Beginning_13
When G.EffYearN=14 Then I.RA_Beginning_14
When G.EffYearN=15 Then I.RA_Beginning_15
When G.EffYearN=16 Then I.RA_Beginning_16
When G.EffYearN=17 Then I.RA_Beginning_17
When G.EffYearN=18 Then I.RA_Beginning_18
When G.EffYearN=19 Then I.RA_Beginning_19
When G.EffYearN=20 Then I.RA_Beginning_20
When G.EffYearN=21 Then I.RA_Beginning_21
When G.EffYearN=22 Then I.RA_Beginning_22
When G.EffYearN=23 Then I.RA_Beginning_23
When G.EffYearN=24 Then I.RA_Beginning_24
When G.EffYearN=25 Then I.RA_Beginning_25
When G.EffYearN=26 Then I.RA_Beginning_26
When G.EffYearN=27 Then I.RA_Beginning_27
When G.EffYearN=28 Then I.RA_Beginning_28
When G.EffYearN=29 Then I.RA_Beginning_29
When G.EffYearN=30 Then I.RA_Beginning_30
else 0
End 
from #DataID G
Inner Join ifrs_initial_Detail_RA I on (I.DataID=G.DataID)

GO

Update I set CSM_Start=
case 
When G.EffYearN=1 Then I.CSM_Start_1
When G.EffYearN=2 Then I.CSM_Start_2
When G.EffYearN=3 Then I.CSM_Start_3
When G.EffYearN=4 Then I.CSM_Start_4
When G.EffYearN=5 Then I.CSM_Start_5
When G.EffYearN=6 Then I.CSM_Start_6
When G.EffYearN=7 Then I.CSM_Start_7
When G.EffYearN=8 Then I.CSM_Start_8
When G.EffYearN=9 Then I.CSM_Start_9
When G.EffYearN=10 Then I.CSM_Start_10
When G.EffYearN=11 Then I.CSM_Start_11
When G.EffYearN=12 Then I.CSM_Start_12
When G.EffYearN=13 Then I.CSM_Start_13
When G.EffYearN=14 Then I.CSM_Start_14
When G.EffYearN=15 Then I.CSM_Start_15
When G.EffYearN=16 Then I.CSM_Start_16
When G.EffYearN=17 Then I.CSM_Start_17
When G.EffYearN=18 Then I.CSM_Start_18
When G.EffYearN=19 Then I.CSM_Start_19
When G.EffYearN=20 Then I.CSM_Start_20
When G.EffYearN=21 Then I.CSM_Start_21
When G.EffYearN=22 Then I.CSM_Start_22
When G.EffYearN=23 Then I.CSM_Start_23
When G.EffYearN=24 Then I.CSM_Start_24
When G.EffYearN=25 Then I.CSM_Start_25
When G.EffYearN=26 Then I.CSM_Start_26
When G.EffYearN=27 Then I.CSM_Start_27
When G.EffYearN=28 Then I.CSM_Start_28
When G.EffYearN=29 Then I.CSM_Start_29
When G.EffYearN=30 Then I.CSM_Start_30
else 0
End 
from #DataID G
Inner Join ifrs_initial_Detail_CSM I on (I.DataID=G.DataID)

GO



Update I set LOSS_Start=
case 
When G.EffYearN=1 Then I.LOSS_Start_1
When G.EffYearN=2 Then I.LOSS_Start_2
When G.EffYearN=3 Then I.LOSS_Start_3
When G.EffYearN=4 Then I.LOSS_Start_4
When G.EffYearN=5 Then I.LOSS_Start_5
When G.EffYearN=6 Then I.LOSS_Start_6
When G.EffYearN=7 Then I.LOSS_Start_7
When G.EffYearN=8 Then I.LOSS_Start_8
When G.EffYearN=9 Then I.LOSS_Start_9
When G.EffYearN=10 Then I.LOSS_Start_10
When G.EffYearN=11 Then I.LOSS_Start_11
When G.EffYearN=12 Then I.LOSS_Start_12
When G.EffYearN=13 Then I.LOSS_Start_13
When G.EffYearN=14 Then I.LOSS_Start_14
When G.EffYearN=15 Then I.LOSS_Start_15
When G.EffYearN=16 Then I.LOSS_Start_16
When G.EffYearN=17 Then I.LOSS_Start_17
When G.EffYearN=18 Then I.LOSS_Start_18
When G.EffYearN=19 Then I.LOSS_Start_19
When G.EffYearN=20 Then I.LOSS_Start_20
When G.EffYearN=21 Then I.LOSS_Start_21
When G.EffYearN=22 Then I.LOSS_Start_22
When G.EffYearN=23 Then I.LOSS_Start_23
When G.EffYearN=24 Then I.LOSS_Start_24
When G.EffYearN=25 Then I.LOSS_Start_25
When G.EffYearN=26 Then I.LOSS_Start_26
When G.EffYearN=27 Then I.LOSS_Start_27
When G.EffYearN=28 Then I.LOSS_Start_28
When G.EffYearN=29 Then I.LOSS_Start_29
When G.EffYearN=30 Then I.LOSS_Start_30
else 0
End 
from #DataID G
Inner Join ifrs_initial_Detail_LOSS I on (I.DataID=G.DataID)

GO


Update I set PAA_Start=
case 
When G.EffYearN=1 Then I.PAA_Start_1
When G.EffYearN=2 Then I.PAA_Start_2
When G.EffYearN=3 Then I.PAA_Start_3
When G.EffYearN=4 Then I.PAA_Start_4
When G.EffYearN=5 Then I.PAA_Start_5
When G.EffYearN=6 Then I.PAA_Start_6
When G.EffYearN=7 Then I.PAA_Start_7
When G.EffYearN=8 Then I.PAA_Start_8
When G.EffYearN=9 Then I.PAA_Start_9
When G.EffYearN=10 Then I.PAA_Start_10
When G.EffYearN=11 Then I.PAA_Start_11
When G.EffYearN=12 Then I.PAA_Start_12
When G.EffYearN=13 Then I.PAA_Start_13
When G.EffYearN=14 Then I.PAA_Start_14
When G.EffYearN=15 Then I.PAA_Start_15
When G.EffYearN=16 Then I.PAA_Start_16
When G.EffYearN=17 Then I.PAA_Start_17
When G.EffYearN=18 Then I.PAA_Start_18
When G.EffYearN=19 Then I.PAA_Start_19
When G.EffYearN=20 Then I.PAA_Start_20
When G.EffYearN=21 Then I.PAA_Start_21
When G.EffYearN=22 Then I.PAA_Start_22
When G.EffYearN=23 Then I.PAA_Start_23
When G.EffYearN=24 Then I.PAA_Start_24
When G.EffYearN=25 Then I.PAA_Start_25
When G.EffYearN=26 Then I.PAA_Start_26
When G.EffYearN=27 Then I.PAA_Start_27
When G.EffYearN=28 Then I.PAA_Start_28
When G.EffYearN=29 Then I.PAA_Start_29
When G.EffYearN=30 Then I.PAA_Start_30
else 0
End 
from #DataID G
Inner Join ifrs_initial_Detail_PAA I on (I.DataID=G.DataID)

GO



Update I set BEL_Beginning=
case 
When G.EffYearN=1 Then I.BEL_Beginning_1
When G.EffYearN=2 Then I.BEL_Beginning_2
When G.EffYearN=3 Then I.BEL_Beginning_3
When G.EffYearN=4 Then I.BEL_Beginning_4
When G.EffYearN=5 Then I.BEL_Beginning_5
When G.EffYearN=6 Then I.BEL_Beginning_6
When G.EffYearN=7 Then I.BEL_Beginning_7
When G.EffYearN=8 Then I.BEL_Beginning_8
When G.EffYearN=9 Then I.BEL_Beginning_9
When G.EffYearN=10 Then I.BEL_Beginning_10
When G.EffYearN=11 Then I.BEL_Beginning_11
When G.EffYearN=12 Then I.BEL_Beginning_12
When G.EffYearN=13 Then I.BEL_Beginning_13
When G.EffYearN=14 Then I.BEL_Beginning_14
When G.EffYearN=15 Then I.BEL_Beginning_15
When G.EffYearN=16 Then I.BEL_Beginning_16
When G.EffYearN=17 Then I.BEL_Beginning_17
When G.EffYearN=18 Then I.BEL_Beginning_18
When G.EffYearN=19 Then I.BEL_Beginning_19
When G.EffYearN=20 Then I.BEL_Beginning_20
When G.EffYearN=21 Then I.BEL_Beginning_21
When G.EffYearN=22 Then I.BEL_Beginning_22
When G.EffYearN=23 Then I.BEL_Beginning_23
When G.EffYearN=24 Then I.BEL_Beginning_24
When G.EffYearN=25 Then I.BEL_Beginning_25
When G.EffYearN=26 Then I.BEL_Beginning_26
When G.EffYearN=27 Then I.BEL_Beginning_27
When G.EffYearN=28 Then I.BEL_Beginning_28
When G.EffYearN=29 Then I.BEL_Beginning_29
When G.EffYearN=30 Then I.BEL_Beginning_30
else 0
End 
from #GroupID G
Inner Join ifrs_calculation_Detail_BEL I on (I.GroupID=G.GroupID and I.GroupType=G.GroupType and I.EffMonth=G.EffMonth and I.EffYear=G.EffYear)


GO

Update I set RA_Beginning=
case 
When G.EffYearN=1 Then I.RA_Beginning_1
When G.EffYearN=2 Then I.RA_Beginning_2
When G.EffYearN=3 Then I.RA_Beginning_3
When G.EffYearN=4 Then I.RA_Beginning_4
When G.EffYearN=5 Then I.RA_Beginning_5
When G.EffYearN=6 Then I.RA_Beginning_6
When G.EffYearN=7 Then I.RA_Beginning_7
When G.EffYearN=8 Then I.RA_Beginning_8
When G.EffYearN=9 Then I.RA_Beginning_9
When G.EffYearN=10 Then I.RA_Beginning_10
When G.EffYearN=11 Then I.RA_Beginning_11
When G.EffYearN=12 Then I.RA_Beginning_12
When G.EffYearN=13 Then I.RA_Beginning_13
When G.EffYearN=14 Then I.RA_Beginning_14
When G.EffYearN=15 Then I.RA_Beginning_15
When G.EffYearN=16 Then I.RA_Beginning_16
When G.EffYearN=17 Then I.RA_Beginning_17
When G.EffYearN=18 Then I.RA_Beginning_18
When G.EffYearN=19 Then I.RA_Beginning_19
When G.EffYearN=20 Then I.RA_Beginning_20
When G.EffYearN=21 Then I.RA_Beginning_21
When G.EffYearN=22 Then I.RA_Beginning_22
When G.EffYearN=23 Then I.RA_Beginning_23
When G.EffYearN=24 Then I.RA_Beginning_24
When G.EffYearN=25 Then I.RA_Beginning_25
When G.EffYearN=26 Then I.RA_Beginning_26
When G.EffYearN=27 Then I.RA_Beginning_27
When G.EffYearN=28 Then I.RA_Beginning_28
When G.EffYearN=29 Then I.RA_Beginning_29
When G.EffYearN=30 Then I.RA_Beginning_30
else 0
End 
from #GroupID G
Inner Join ifrs_calculation_Detail_RA I on (I.GroupID=G.GroupID and I.GroupType=G.GroupType and I.EffMonth=G.EffMonth and I.EffYear=G.EffYear)

GO

Update I set CSM_Start=
case 
When G.EffYearN=1 Then I.CSM_Start_1
When G.EffYearN=2 Then I.CSM_Start_2
When G.EffYearN=3 Then I.CSM_Start_3
When G.EffYearN=4 Then I.CSM_Start_4
When G.EffYearN=5 Then I.CSM_Start_5
When G.EffYearN=6 Then I.CSM_Start_6
When G.EffYearN=7 Then I.CSM_Start_7
When G.EffYearN=8 Then I.CSM_Start_8
When G.EffYearN=9 Then I.CSM_Start_9
When G.EffYearN=10 Then I.CSM_Start_10
When G.EffYearN=11 Then I.CSM_Start_11
When G.EffYearN=12 Then I.CSM_Start_12
When G.EffYearN=13 Then I.CSM_Start_13
When G.EffYearN=14 Then I.CSM_Start_14
When G.EffYearN=15 Then I.CSM_Start_15
When G.EffYearN=16 Then I.CSM_Start_16
When G.EffYearN=17 Then I.CSM_Start_17
When G.EffYearN=18 Then I.CSM_Start_18
When G.EffYearN=19 Then I.CSM_Start_19
When G.EffYearN=20 Then I.CSM_Start_20
When G.EffYearN=21 Then I.CSM_Start_21
When G.EffYearN=22 Then I.CSM_Start_22
When G.EffYearN=23 Then I.CSM_Start_23
When G.EffYearN=24 Then I.CSM_Start_24
When G.EffYearN=25 Then I.CSM_Start_25
When G.EffYearN=26 Then I.CSM_Start_26
When G.EffYearN=27 Then I.CSM_Start_27
When G.EffYearN=28 Then I.CSM_Start_28
When G.EffYearN=29 Then I.CSM_Start_29
When G.EffYearN=30 Then I.CSM_Start_30
else 0
End 
from #GroupID G
Inner Join ifrs_calculation_Detail_CSM I on (I.GroupID=G.GroupID and I.GroupType=G.GroupType and I.EffMonth=G.EffMonth and I.EffYear=G.EffYear)

GO



Update I set LOSS_Start=
case 
When G.EffYearN=1 Then I.LOSS_Start_1
When G.EffYearN=2 Then I.LOSS_Start_2
When G.EffYearN=3 Then I.LOSS_Start_3
When G.EffYearN=4 Then I.LOSS_Start_4
When G.EffYearN=5 Then I.LOSS_Start_5
When G.EffYearN=6 Then I.LOSS_Start_6
When G.EffYearN=7 Then I.LOSS_Start_7
When G.EffYearN=8 Then I.LOSS_Start_8
When G.EffYearN=9 Then I.LOSS_Start_9
When G.EffYearN=10 Then I.LOSS_Start_10
When G.EffYearN=11 Then I.LOSS_Start_11
When G.EffYearN=12 Then I.LOSS_Start_12
When G.EffYearN=13 Then I.LOSS_Start_13
When G.EffYearN=14 Then I.LOSS_Start_14
When G.EffYearN=15 Then I.LOSS_Start_15
When G.EffYearN=16 Then I.LOSS_Start_16
When G.EffYearN=17 Then I.LOSS_Start_17
When G.EffYearN=18 Then I.LOSS_Start_18
When G.EffYearN=19 Then I.LOSS_Start_19
When G.EffYearN=20 Then I.LOSS_Start_20
When G.EffYearN=21 Then I.LOSS_Start_21
When G.EffYearN=22 Then I.LOSS_Start_22
When G.EffYearN=23 Then I.LOSS_Start_23
When G.EffYearN=24 Then I.LOSS_Start_24
When G.EffYearN=25 Then I.LOSS_Start_25
When G.EffYearN=26 Then I.LOSS_Start_26
When G.EffYearN=27 Then I.LOSS_Start_27
When G.EffYearN=28 Then I.LOSS_Start_28
When G.EffYearN=29 Then I.LOSS_Start_29
When G.EffYearN=30 Then I.LOSS_Start_30
else 0
End 
from #GroupID G
Inner Join ifrs_calculation_Detail_LOSS I on (I.GroupID=G.GroupID and I.GroupType=G.GroupType and I.EffMonth=G.EffMonth and I.EffYear=G.EffYear)

GO


Update I set PAA_Start=
case 
When G.EffYearN=1 Then I.PAA_Start_1
When G.EffYearN=2 Then I.PAA_Start_2
When G.EffYearN=3 Then I.PAA_Start_3
When G.EffYearN=4 Then I.PAA_Start_4
When G.EffYearN=5 Then I.PAA_Start_5
When G.EffYearN=6 Then I.PAA_Start_6
When G.EffYearN=7 Then I.PAA_Start_7
When G.EffYearN=8 Then I.PAA_Start_8
When G.EffYearN=9 Then I.PAA_Start_9
When G.EffYearN=10 Then I.PAA_Start_10
When G.EffYearN=11 Then I.PAA_Start_11
When G.EffYearN=12 Then I.PAA_Start_12
When G.EffYearN=13 Then I.PAA_Start_13
When G.EffYearN=14 Then I.PAA_Start_14
When G.EffYearN=15 Then I.PAA_Start_15
When G.EffYearN=16 Then I.PAA_Start_16
When G.EffYearN=17 Then I.PAA_Start_17
When G.EffYearN=18 Then I.PAA_Start_18
When G.EffYearN=19 Then I.PAA_Start_19
When G.EffYearN=20 Then I.PAA_Start_20
When G.EffYearN=21 Then I.PAA_Start_21
When G.EffYearN=22 Then I.PAA_Start_22
When G.EffYearN=23 Then I.PAA_Start_23
When G.EffYearN=24 Then I.PAA_Start_24
When G.EffYearN=25 Then I.PAA_Start_25
When G.EffYearN=26 Then I.PAA_Start_26
When G.EffYearN=27 Then I.PAA_Start_27
When G.EffYearN=28 Then I.PAA_Start_28
When G.EffYearN=29 Then I.PAA_Start_29
When G.EffYearN=30 Then I.PAA_Start_30
else 0
End 
from #GroupID G
Inner Join ifrs_calculation_Detail_PAA I on (I.GroupID=G.GroupID and I.GroupType=G.GroupType and I.EffMonth=G.EffMonth and I.EffYear=G.EffYear)

GO


Update I set CSM_END=CSM_Start
from #DataID G
Inner Join ifrs_initial_Detail_CSM I on (I.DataID=G.DataID)

GO
Update I set LOSS_END=LOSS_Start
from #DataID G
Inner Join ifrs_initial_Detail_LOSS I on (I.DataID=G.DataID)

GO

Update I set PAA_End=PAA_Start
from #DataID G
Inner Join ifrs_initial_Detail_PAA I on (I.DataID=G.DataID)


Select I.GroupID, I.GroupType, I.EffMonth, I.EffYear,
sum(BEL_Gainloss_DiscRate) as BEL_Gainloss_DiscRate, 
sum(RA_GainLoss_DiscRate) as RA_GainLoss_DiscRate, 
sum(CSM_Adjustment) as CSM_Adjustment, 
sum(CSM_Interest_Accrete) as CSM_Interest_Accrete, 
sum(CSM_Amortization) as CSM_Amortization, 
sum(CSM_GainLoss_NonDiscRate) as CSM_GainLoss_NonDiscRate, 
sum(PAA_Interest_Accrete) as PAA_Interest_Accrete, 
sum(PAA_Amortization) as PAA_Amortization, 
sum(Loss_Adjustment) as Loss_Adjustment,
sum(Loss_GainLoss_NonDiscRate) as Loss_GainLoss_NonDiscRate,
sum(LOSS_Portion_from_GainLoss_DiscRate) as LOSS_Portion_from_GainLoss_DiscRate,
sum(Loss_Portion_from_Claim_Release) as Loss_Portion_from_Claim_Release,
sum(Loss_Portion_from_Expense_Release) as Loss_Portion_from_Expense_Release,
sum(Loss_Portion_from_Cost_Release) as Loss_Portion_from_Cost_Release,
sum(Loss_Portion_from_Others_Release) as Loss_Portion_from_Others_Release,
sum(Loss_Portion_from_Refund_Release) as Loss_Portion_from_Refund_Release,
sum(Loss_Portion_from_RA_Release) as Loss_Portion_from_RA_Release,
sum(Loss_Portion_from_Interest_Accrete) as Loss_Portion_from_Interest_Accrete
into #GroupIDMovement
from IFRS_Movement I
Group By I.GroupID, I.GroupType, I.EffMonth, I.EffYear

Update I set PAA_End=I.PAA_Start+G.PAA_Interest_Accrete+G.PAA_Amortization 
from #GroupIDMovement G
Inner Join ifrs_calculation_Detail_PAA I on (I.GroupID=G.GroupID and I.GroupType=G.GroupType and I.EffMonth=G.EffMonth and I.EffYear=G.EffYear)

Update I set CSM_End=I.CSM_Start+G.CSM_Adjustment+G.CSM_Interest_Accrete+G.CSM_GainLoss_NonDiscRate+G.CSM_Amortization   
from #GroupIDMovement G
Inner Join ifrs_calculation_Detail_CSM I on (I.GroupID=G.GroupID and I.GroupType=G.GroupType and I.EffMonth=G.EffMonth and I.EffYear=G.EffYear)

Update I set LOSS_End=I.LOSS_Start+G.LOSS_Adjustment+G.Loss_GainLoss_NonDiscRate+G.LOSS_Portion_from_GainLoss_DiscRate+G.Loss_Portion_from_Claim_Release+G.Loss_Portion_from_Expense_Release+G.Loss_Portion_from_Cost_Release+G.Loss_Portion_from_Others_Release+G.Loss_Portion_from_Refund_Release+G.Loss_Portion_from_RA_Release+G.Loss_Portion_from_Interest_Accrete
from #GroupIDMovement G
Inner Join ifrs_calculation_Detail_LOSS I on (I.GroupID=G.GroupID and I.GroupType=G.GroupType and I.EffMonth=G.EffMonth and I.EffYear=G.EffYear)

Update I set BEL_GainLoss_DiscRate=G.BEL_Gainloss_DiscRate 
from #GroupIDMovement G
Inner Join ifrs_calculation_Detail_BEL I on (I.GroupID=G.GroupID and I.GroupType=G.GroupType and I.EffMonth=G.EffMonth and I.EffYear=G.EffYear)

Update I set RA_GainLoss_DiscRate=G.RA_Gainloss_DiscRate 
from #GroupIDMovement G
Inner Join ifrs_calculation_Detail_RA I on (I.GroupID=G.GroupID and I.GroupType=G.GroupType and I.EffMonth=G.EffMonth and I.EffYear=G.EffYear)

drop table #DataID
drop table #groupID
drop table #GroupIDMovement

go



insert into PatchVersioning
select '923 Update Script - IFRS Patch #47 Part 1',GETDATE()
go
	

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='923 Update Script - IFRS Patch #47 Part 1'


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