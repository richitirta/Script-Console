-- TAMBAH DI PACKAGE SCRIPT INI
IF NOT EXISTS(SELECT * FROM RELIGION WHERE RELIGION in ('XXXXXXXXX','XXXXXXXX','XXXXXX'))
BEGIN
insert into RELIGION values ('XXXXXXXXX')
insert into RELIGION values ('XXXXXXXX')
insert into RELIGION values ('XXXXXX')
end
go
IF NOT EXISTS(SELECT * FROM GENDER WHERE GENDER in ('X','XX','XXXX','XXXXXX'))
BEGIN
insert into GENDER values ('X',1)
insert into GENDER values ('XX',1)
insert into GENDER values ('XXXX',1)
insert into GENDER values ('XXXXXX',1)
end
go
IF NOT EXISTS(SELECT * FROM Profile_Income WHERE Income in ('XXXXXXXXX','XXXXXXXXXX','XXXXXXXXXXXX','XXXXXXXXXXXXX'))
BEGIN
insert into Profile_Income values ('XXXXXXXXX','XXXXXXXXX',1,0)
insert into Profile_Income values ('XXXXXXXXXX','XXXXXXXXXX',1,0)
insert into Profile_Income values ('XXXXXXXXXXXX','XXXXXXXXXXXX',1,0)
insert into Profile_Income values ('XXXXXXXXXXXXX','XXXXXXXXXXXXX',1,0)
end
go

