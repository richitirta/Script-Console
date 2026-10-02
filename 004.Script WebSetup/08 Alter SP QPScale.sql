IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[QPScale]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
drop procedure [QPScale]
end
go

create PROCEDURE [dbo].[QPScale] (@TOC Varchar(30),@BASIS as varchar(1),@NOP as FLOAT )          
AS          
BEGIN          
 SELECT  * FROM PScale WHERE TOC=@TOC and BASIS=@BASIS and NOP=@NOP;  
   
END  
  go
   

   
 insert into PatchVersioning
select '56.9 Alter SP QPScale',GETDATE()
go