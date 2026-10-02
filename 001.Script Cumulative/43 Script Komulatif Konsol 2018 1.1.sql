--Perubahan Length
IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_ID_TYPE' AND object_id = OBJECT_ID('ID_TYPE'))
BEGIN
ALTER TABLE ID_TYPE DROP CONSTRAINT I_ID_TYPE
END
GO
alter table id_type alter column id_type varchar(100) not null
go

alter table profile_ext alter column id_type varchar(100)
go
ALTER TABLE ID_TYPE ADD  CONSTRAINT I_ID_TYPE PRIMARY KEY CLUSTERED 
(
	ID_TYPE ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

--penambahan ecutype
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ECUTYPE') AND type in (N'U'))
BEGIN
CREATE TABLE ECUTYPE(
	ECUTYPE varchar(50) NOT NULL,
	Description varchar(512),
	PolicyF bit,
	CoverF bit,
 CONSTRAINT I_ECUTYPE PRIMARY KEY CLUSTERED 
(
	ECUTYPE ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS(SELECT * FROM ECUTYPE WHERE ECUTYPE='LEADER')
BEGIN
INSERT INTO ECUTYPE VALUES('LEADER','LEADER',1,1)
END
GO
IF NOT EXISTS(SELECT * FROM ECUTYPE WHERE ECUTYPE='MARKETING')
BEGIN
INSERT INTO ECUTYPE VALUES('MARKETING','MARKETING',0,1)
END
GO
IF NOT EXISTS(SELECT * FROM ECUTYPE WHERE ECUTYPE='TECHNICAL STAFF')
BEGIN
INSERT INTO ECUTYPE VALUES('TECHNICAL STAFF','TECHNICAL STAFF',1,1)
END
GO
IF NOT EXISTS(SELECT * FROM ECUTYPE WHERE ECUTYPE='UNDERWRITER 1')
BEGIN
INSERT INTO ECUTYPE VALUES('UNDERWRITER 1','UNDERWRITER 1',1,0)
END
GO
IF NOT EXISTS(SELECT * FROM ECUTYPE WHERE ECUTYPE='UNDERWRITER 2')
BEGIN
INSERT INTO ECUTYPE VALUES('UNDERWRITER 2','UNDERWRITER 2',1,0)
END
GO

--20 feb 2018
IF NOT EXISTS(SELECT * FROM SysForm WHERE FName='ALLOWEXCEEDREQUEST')
BEGIN
insert into SysForm(FName, Description, FCode) Select 'ALLOWEXCEEDREQUEST','ALLOW Realization Amount Exceed Request Amount','ACTIVITIES'
END
GO

Alter Table ARBucket Alter Column eAccount varchar(10)
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Charges' AND Object_ID = Object_ID(N'RPBucket'))
BEGIN
Alter Table RPBucket Add Charges Float
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'sAccount' AND Object_ID = Object_ID(N'RPBucket'))
BEGIN
Alter Table RPBucket Add sAccount varchar(10)
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'eAccount' AND Object_ID = Object_ID(N'RPBucket'))
BEGIN
Alter Table RPBucket Add eAccount varchar(10)
END
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


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='42 Script Komulatif Konsol 2018 1.0'
Select @CurrSCript='43 Script Komulatif Konsol 2018 1.1'


Declare @ExecScript varchar(100)
Declare @ExecScriptStatus varchar(100)
Declare @Error varchar(200)

Select @Error=''

Begin 
       Select @ExecScript=Execscript,  @ExecScriptStatus=ExecScriptStatus from systab 
       if @PrevScript<>'' and @ExecSCript<>@PrevScript
              THROW 51000, 'Not the Next Sequence Script', 1;
       else 
              if @ExecScriptStatus<>'' and @ExecScriptStatus<>'DONE'
              THROW 51000, 'Pending Script Execution', 1;

       Update SysTab Set ExecScript=@CurrScript, ExecScriptStatus='PENDING'             
       
       BEGIN TRY            
			PRINT '--EXECUTE DONE--'
       END TRY  
       BEGIN CATCH  
       END CATCH;


       Update SysTab Set ExecScript=@CurrScript, ExecScriptStatus='DONE'         
End
