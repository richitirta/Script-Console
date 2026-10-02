
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ConjunctExcessClaimF' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE TOC ADD
	ConjunctExcessClaimF bit NULL
DECLARE @v sql_variant 
SET @v = N'Include Excess from Claim Conjunction (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOC', N'COLUMN', N'ConjunctExcessClaimF'
end
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QGetConjunctionERetentionClaim') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure QGetConjunctionERetentionClaim
end
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QGetConjunctionRetentionClaim') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure QGetConjunctionRetentionClaim
end
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QGetConjunctionClaimXOLCession') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure QGetConjunctionClaimXOLCession
end
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QGetConjunctionClaimXOLCession') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure QGetConjunctionClaimXOLCession 
end
go
Create Procedure QGetConjunctionClaimXOLCession(@P_CNO as integer)
as
Select 
sum(CArrHeader.RAmount) as RAmount,
sum(CArrHeader.ERAmount) as ERAmount,
sum(CArrHeader.XL1Amount) as XL1Amount,
sum(CArrHeader.XL2Amount) as XL2Amount,
sum(CArrHeader.XL3Amount) as XL3Amount,
sum(CArrHeader.XL4Amount) as XL4Amount,
sum(CArrHeader.XL5Amount) as XL5Amount,
sum(CArrHeader.XL6Amount) as XL6Amount,
sum(CArrHeader.XL7Amount) as XL7Amount,
sum(CArrHeader.XL1EAmount) as XL1EAmount,
sum(CArrHeader.XL2EAmount) as XL2EAmount,
sum(CArrHeader.XL3EAmount) as XL3EAmount,
sum(CArrHeader.XL4EAmount) as XL4EAmount,
sum(CArrHeader.XL5EAmount) as XL5EAmount,
sum(CArrHeader.XL6EAmount) as XL6EAmount,
sum(CArrHeader.XL7EAmount) as XL7EAmount
from Claim C1
Inner Join Acceptance A1 on (A1.ANO=C1.ANO)
Inner Join Acceptance A2 on (A1.ANO = A2.CANO Or A1.CANO = A2.ANO)
Inner Join Claim C2 on (C2.PolicyNo=A2.PolicyNo and C2.CERTIFICATENO=A2.CERTIFICATENO)
Inner Join CArrHeader on (CArrHeader.CNO=C2.CNO)
Inner Join TOC on (TOC.TOC=C2.TOC and TOC.ConjunctExcessClaimF=1)
Where C1.CNO=@P_CNO 
and C2.CType<>'C' and C2.CStatus<>'R' and (C2.CStatus<>'C' or C2.PCstatus='A') 
and not exists (Select pCNO from Claim Where Claim.pCNO=C2.CNO and Claim.CStatus<>'R') 
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCheckConjunctionClaim') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure QCheckConjunctionClaim
end
go
Create Procedure QCheckConjunctionClaim(@P_CNO as integer)
as
Select Top 1 C2.ClaimNo
from Claim C1
Inner Join Acceptance A1 on (A1.ANO=C1.ANO)
Inner Join Acceptance A2 on (A1.CANO = A2.ANO)
Inner Join Claim C2 on (C2.PolicyNo=A2.PolicyNo and C2.CERTIFICATENO=A2.CERTIFICATENO)
Inner Join TOC on (TOC.TOC=C2.TOC and TOC.ConjunctExcessClaimF=1)
Where C1.CNO=@P_CNO 
and C2.CType<>'C' and C2.CStatus<>'R' and (C2.CStatus<>'C' or C2.PCstatus='A') 
--Not Yet Approved
and not (C2.CStatus='A' or C2.pCStatus='A')
and not exists (Select pCNO from Claim Where Claim.pCNO=C2.CNO and Claim.CStatus<>'R') 

GO

insert into PatchVersioning
select '61 Update Script - 28 June 2021',GETDATE()
go
