--sp_helptext QBRRuleMin
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QBRRuleMin') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
drop procedure QBRRuleMin
end
go
 CREATE procedure QBRRuleMin (@TOC varchar(10),@Branch varchar(10),@BizMapID varchar(10),@FACOPT varchar(10) )       

as        

select  * from BRRuleMin where TOC = @TOC  and Branch=@Branch and BizMapID=@BizMapID and FACOPT=@FACOPT;
go


insert into PatchVersioning
select 'Update script 21 Okt 2020 BrRuleMin',GETDATE()
go
