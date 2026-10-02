
ALTER TABLE Profile_IncomeSource ALTER COLUMN allowedf bit not NULL
go

ALTER TABLE Profile_IncomeSource ALTER COLUMN corporatef bit not NULL
go

IF not EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='Profile_IncomeSource' AND CONSTRAINT_NAME='I_Profile_IncomeSource')
Begin
ALTER TABLE [dbo].Profile_IncomeSource ADD  CONSTRAINT [I_Profile_IncomeSource] PRIMARY KEY CLUSTERED 
(
	IncomeSource ASC,
	description asc,
	allowedf asc,
	corporatef asc
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
end
GO




