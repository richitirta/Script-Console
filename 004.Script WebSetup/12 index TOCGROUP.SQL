select  * into Temp_SegmentGroup2021035 from [TOCGROUP]
go
delete from [TOCGROUP]
go
insert into [TOCGROUP]
select distinct * from Temp_SegmentGroup2021035
go

IF not EXISTS (SELECT *  FROM sys.indexes WHERE name='I_TOCGROUP' AND object_id = OBJECT_ID('TOCGROUP'))
BEGIN
ALTER TABLE [dbo].[TOCGROUP] ADD  CONSTRAINT [I_TOCGROUP] PRIMARY KEY CLUSTERED 
(
	[TOCGROUP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
 
ALTER TABLE [dbo].[TOCGROUP] ADD  CONSTRAINT [DF_TOCGROUP_AllowedF]  DEFAULT 0 FOR [AllowedF]
end
GO

drop table Temp_SegmentGroup2021035
go

 insert into PatchVersioning
select '56.14 index TOCGROUP',GETDATE()
go