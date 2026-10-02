IF NOT EXISTS(SELECT * FROM SysForm WHERE FName='ALLOCHANGELOSSDATE')
BEGIN
insert into sysform(FName, Description, FCode, RequestF)
Select 'ALLOCHANGELOSSDATE','Allow Change Claim Loss Date','ACTIVITIES',0
end
go

insert into PatchVersioning
select '80 Update Script - 8 October 2021',GETDATE()
go
