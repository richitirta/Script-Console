select  * into Temp_SegmentGroup20210305 from [SegmentGroup]
go
delete from [SegmentGroup]
go
insert into [SegmentGroup]
select distinct * from Temp_SegmentGroup20210305
go
IF not EXISTS (SELECT *  FROM sys.indexes WHERE name='I_SEGMENTGROUP' AND object_id = OBJECT_ID('SegmentGroup'))
BEGIN
ALTER TABLE [dbo].[SegmentGroup] ADD  CONSTRAINT [I_SEGMENTGROUP] PRIMARY KEY NONCLUSTERED 
(
	[SEGMENTGROUP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF)
ALTER TABLE [dbo].[SEGMENTGROUP] ADD  CONSTRAINT [DF_SEGMENTGROUP_AllowedF]  DEFAULT (0) FOR [AllowedF]
end
GO
drop table Temp_SegmentGroup20210305
go


 insert into PatchVersioning
select '56.13 Index Segmentgroup',GETDATE()
go