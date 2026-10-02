alter TABLE [dbo].[ClaimantType]
alter column	[ClaimantType] [varchar](10) NOT NULL
go
IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_ClaimantType' AND object_id = OBJECT_ID('ClaimantType'))
BEGIN
ALTER TABLE [dbo].[ClaimantType] DROP CONSTRAINT [I_ClaimantType]
end
GO

IF not EXISTS (SELECT *  FROM sys.indexes WHERE name='I_ClaimantType' AND object_id = OBJECT_ID('ClaimantType'))
BEGIN

ALTER TABLE [dbo].[ClaimantType] ADD  CONSTRAINT [I_ClaimantType] PRIMARY KEY CLUSTERED 
(
	[ClaimantType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF)on [Primary]
end
GO

 insert into PatchVersioning
select '56.11 index Claimantype & alter column claimantype',GETDATE()
go