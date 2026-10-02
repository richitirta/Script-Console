IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'GENDER') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[GENDER](
	[GENDER] [varchar](50) NOT NULL,
	[AllowedF] [bit] NULL,
 CONSTRAINT [I_GENDER] PRIMARY KEY CLUSTERED 
(
	[GENDER] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

SET ANSI_PADDING OFF
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Allow Selection Flag (0  : No, 1 : Yes)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'GENDER', @level2type=N'COLUMN',@level2name=N'AllowedF'
end
GO


IF NOT EXISTS(SELECT * FROM gender WHERE gender in ('L'))
BEGIN
insert into gender values ('L',1)
end
go
IF NOT EXISTS(SELECT * FROM gender WHERE gender in ('P'))
BEGIN
insert into gender values ('P',1)
end
go
IF NOT EXISTS(SELECT * FROM gender WHERE gender in ('MALE'))
BEGIN
insert into gender values ('MALE',1)
end
go
IF NOT EXISTS(SELECT * FROM gender WHERE gender in ('FEMALE'))
BEGIN
insert into gender values ('FEMALE',1)
end
go
IF NOT EXISTS(SELECT * FROM gender WHERE gender in ('NA'))
BEGIN
insert into gender values ('NA',1)
END
go
