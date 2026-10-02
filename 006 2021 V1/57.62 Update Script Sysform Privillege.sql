IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='ICOVERMDLG')
BEGIN
insert into sysform 
select 'ICOVERMDLG','Interest Coverage Multiple Dialog ','U/R',0
end
go

IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='PLADMDLG')
BEGIN
insert into sysform 
select 'PLADMDLG','Policy Administration Dialog','U/R',0
end
go

IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='PNOTIFYDLG')
BEGIN
insert into sysform 
select 'PNOTIFYDLG','Policy Notify Dialog','U/R',0
end
go


IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='ACCDOCLIST')
BEGIN
insert into sysform 
select 'ACCDOCLIST','Acceptance Document List ','U/R',0
end
go


-- 1 AGST 2021
IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='AInfoDocFrm')
BEGIN
insert into sysform 
select 'AInfoDocFrm','Object Register Attached Document','U/R',0
end
go

IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='AInfoDocDlg')
BEGIN
insert into sysform 
select 'AInfoDocDlg','Object Register Attached Document Detail','U/R',0
end
go

IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='AInfoDocDlg2')
BEGIN
insert into sysform 
select 'AInfoDocDlg2','Object Register Multiple Attached Document Detail','U/R',0
end
go
