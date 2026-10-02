IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'TOP_RTERM') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ReferralType](
	[ReferralType] [varchar](100) NOT NULL,
 CONSTRAINT [I_ReferralType] PRIMARY KEY CLUSTERED 
(
	[ReferralType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
SET ANSI_PADDING OFF
end
GO



-- Default Values

IF NOT EXISTS(SELECT * FROM ReferralType WHERE ReferralType in ('N/A','BUSINESS','RELATIVE','FAMILY','SPOUSE'))
BEGIN
insert into ReferralType
Select 'N/A'
union all
Select 'BUSINESS'
union all
Select 'RELATIVE'
union all
Select 'FAMILY'
union all
Select 'SPOUSE'
end
go