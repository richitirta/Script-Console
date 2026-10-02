IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QBRRule') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
drop procedure QBRRule
end
go

create procedure QBRRule (@TOC varchar(10),@Branch varchar(10),@BizMapID varchar(10),@FACOPT varchar(10))       
as        
select top 1 * from BRRULE where TOC = @TOC  and Branch=@Branch and BizMapID=@BizMapID  and FACOPT=@FACOPT;  
go
  
  
insert into PatchVersioning
select '06 alter SP QBRRule',GETDATE()
go