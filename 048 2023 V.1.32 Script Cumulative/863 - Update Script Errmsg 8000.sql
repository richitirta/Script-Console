--BEGIN TRAN
---UP
ALTER TABLE sysbatchUP ALTER COLUMN errmsg varchar(8000)
go


ALTER TABLE sysbatchoriginalUP ALTER COLUMN errmsg varchar(8000);
go


--BC
ALTER TABLE sysbatchBC ALTER COLUMN errmsg varchar(8000);
go

ALTER TABLE sysbatchoriginalBC ALTER COLUMN errmsg varchar(8000);
go

--BE
ALTER TABLE sysbatchBE ALTER COLUMN errmsg varchar(8000);
go

ALTER TABLE sysbatchoriginalBE ALTER COLUMN errmsg varchar(8000);
go

--SC
ALTER TABLE sysbatchSC ALTER COLUMN errmsg varchar(8000);
go

ALTER TABLE sysbatchoriginalSC ALTER COLUMN errmsg varchar(8000);
go


--COMMIT TRAN
--ROLLBACK