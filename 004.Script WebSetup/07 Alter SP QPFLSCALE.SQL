IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QPFLSCALE') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
drop procedure QPFLSCALE
end
go
create PROCEDURE [dbo].[QPFLSCALE] (@TOC Varchar(30),@FLValue as FLOAT )          
AS          
 BEGIN          
  SELECT * FROM PFLSCALE WHERE TOC=@TOC and FLValue=@FLValue;  
 END   
 go

 insert into PatchVersioning
select '56.8 Alter SP QPFLSCALE',GETDATE()
go