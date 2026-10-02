--Perubahan Length
ALTER TABLE [dbo].[ID_TYPE] DROP CONSTRAINT [I_ID_TYPE]
GO
alter table id_type alter column id_type varchar(100) not null
go

alter table profile_ext alter column id_type varchar(100)
go
ALTER TABLE [dbo].[ID_TYPE] ADD  CONSTRAINT [I_ID_TYPE] PRIMARY KEY CLUSTERED 
(
	[ID_TYPE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

--penambahan ecutype
CREATE TABLE [dbo].[ECUTYPE](
	[ECUTYPE] [varchar](50) NOT NULL,
	[Description] [varchar](512),
	[PolicyF] [bit],
	[CoverF] [bit],
 CONSTRAINT [I_ECUTYPE] PRIMARY KEY CLUSTERED 
(
	[ECUTYPE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

INSERT INTO ECUTYPE VALUES('LEADER','LEADER',1,1)
GO
INSERT INTO ECUTYPE VALUES('MARKETING','MARKETING',0,1)
GO
INSERT INTO ECUTYPE VALUES('TECHNICAL STAFF','TECHNICAL STAFF',1,1)
GO
INSERT INTO ECUTYPE VALUES('UNDERWRITER 1','UNDERWRITER 1',1,0)
GO
INSERT INTO ECUTYPE VALUES('UNDERWRITER 2','UNDERWRITER 2',1,0)
GO

--20 feb 2018
insert into SysForm(FName, Description, FCode) Select 'ALLOWEXCEEDREQUEST','ALLOW Realization Amount Exceed Request Amount','ACTIVITIES'
go


Alter Table ARBucket Alter Column eAccount varchar(10)
GO
Alter Table RPBucket Add Charges Float
GO
Alter Table RPBucket Add sAccount varchar(10)
GO
Alter Table RPBucket Add eAccount varchar(10)
go

--inisialisasi proforma policy
select top 1 * into #prof from PolicyType

--select * from #prof

update #prof set PolicyType='', Description='Proforma Policy', Last_Update=GETDATE()
go

insert into policytype select * from #prof
go

--Perubahan Length
ALTER TABLE [dbo].inparty alter column ID_NO varchar(30) not null
GO

--VERSIONING
insert into versioning
select '2018 V.1.1.0',GETDATE(),'2018 V.1.1.0',GETDATE(),'K: 2018 V.1.1.0',GETDATE()
go
