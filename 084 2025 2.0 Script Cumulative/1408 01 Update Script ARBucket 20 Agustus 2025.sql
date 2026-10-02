SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
BEGIN TRAN

alter table ARBucket add  TAccount varchar(20)
GO
alter table ARBucket add  TaxDeduction float
GO
alter table ARBucket add  TaxCharges float
GO
alter table ARBucket add  ETaxAccount varchar(20)
GO
alter table ARBucket add  VType varchar(10)
GO
alter table ARBucket add  CCPayType varchar(10)
GO
alter table ARBucket add  PayorID varchar(10)
GO
COMMIT TRAN