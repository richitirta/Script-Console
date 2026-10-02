


		insert into Profile_Income values ('XX','XX',1,0)
		go
		insert into Profile_Income values ('XX','XX',1,1)
		go
		insert into religion values('X')
		go


CREATE TABLE [EncryptField]
(
	EncryptID [int] NOT NULL,
	FormName	VarChar (255),
	ControlName	VarChar (255),
	FieldName	VarChar (255),
	StrType	VarChar (255),
	MaskCHar VarChar (1),
	EncryptF bit,
	LPos int,
	RPos int,
	LDate	SmallDateTime,
	LUserID	VarChar (50),
 CONSTRAINT [I_EncryptID] PRIMARY KEY NONCLUSTERED 
(
	EncryptID ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO


insert into [EncryptField]
select 1,'ACCCADLG','TxtPhone_1','PHONE_1','PHONE','*',1,0,0,GETDATE(),'CARE'
GO

insert into [EncryptField]
select 2,'ACCCADLG','TxtEmail','Email','Email','X',1,0,0,GETDATE(),'CARE'
GO

insert into [EncryptField]
select 3,'PROFILEDLG','TxtBirthDate','BirthDate','','*',1,0,0,GETDATE(),'CARE'
GO

insert into [EncryptField]
select 4,'PROFILEDLG','TxtPIDNo','ID_NO','IDNO','*',1,0,0,GETDATE(),'CARE'
GO

insert into [EncryptField]
select 5,'PROFILEDLG','TxtAddress_1','Address_1','','X',1,0,0,GETDATE(),'CARE'
GO

insert into [EncryptField]
select 6,'PROFILEDLG','TxtAddress_2','Address_2','','X',1,0,0,GETDATE(),'CARE'
GO

insert into [EncryptField]
select 7,'PROFILEDLG','TxtAddress_3','Address_3','','X',1,0,0,GETDATE(),'CARE'
GO

insert into [EncryptField]
select 8,'PROFILEDLG','TxtCity','City','','X',1,0,0,GETDATE(),'CARE'
GO

insert into [EncryptField]
select 9,'PROFILEDLG','TxtCountryID','Country','','X',1,0,0,GETDATE(),'CARE'
GO

insert into [EncryptField]
select 10,'PROFILEDLG','TxtPhone_1','Phone_1','PHONE','*',1,0,0,GETDATE(),'CARE'
GO

insert into [EncryptField]
select 11,'PROFILEDLG','TxtPhone_2','Phone_2','PHONE','*',1,0,0,GETDATE(),'CARE'
GO

insert into [EncryptField]
select 12,'PROFILEDLG','TxtMPhone_1','Mobile_1','PHONE','*',1,0,0,GETDATE(),'CARE'
GO

insert into [EncryptField]
select 13,'PROFILEDLG','TxtMPhone_2','Mobile_2','PHONE','*',1,0,0,GETDATE(),'CARE'
GO

insert into [EncryptField]
select 14,'PROFILEDLG','TxtFax_1','Fax_1','FAX','*',1,0,0,GETDATE(),'CARE'
GO

insert into [EncryptField]
select 15,'PROFILEDLG','TxtFax_2','Fax_2','FAX','*',1,0,0,GETDATE(),'CARE'
GO

insert into [EncryptField]
select 16,'PROFILEDLG','TxtEmail_1','Email','EMAIL','*',1,0,0,GETDATE(),'CARE'
GO

insert into [EncryptField]
select 17,'PROFILEDLG','TxtEmail_2','Email','EMAIL','*',1,0,0,GETDATE(),'CARE'
GO


--Select * from EncryptField where EncryptF=1 and FormName='AccCaDlg'


