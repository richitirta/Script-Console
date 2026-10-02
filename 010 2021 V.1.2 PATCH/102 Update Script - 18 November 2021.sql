IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QGetPreCedeFacCessionAmount') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN
 DROP PROCEDURE  QGetPreCedeFacCessionAmount 
end
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QFacCessionShare') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN 
DROP PROCEDURE  QFacCessionShare 
end
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QFacCessionShare') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN
drop Procedure QFacCessionShare
end
go

CREATE Procedure QFacCessionShare(@P_ANO integer)     
as     
Select 
sum(Case When RArrDet.Limit<>0 and RArrHeader.TAmount<>0 then RArrDet.Limit/RArrHeader.TAmount else 1 end *(RArrDet.Share-RArrDet.JPShare)) as FShare,
sum(Case When RArrDet.PrecedeFacCessionF=1 or TOC.PrecedeFacCessionF=1 Then (Case When RArrDet.Limit<>0 and RArrHeader.TAmount<>0 then RArrDet.Limit/RArrHeader.TAmount else 1 end *(RArrDet.Share-RArrDet.JPShare)) else 0 end) as PrecedeFShare
from RArrDet     
Inner Join RArrHeader on (RArrHeader.ANO=RArrDet.ANO)
Inner Join Acceptance on (Acceptance.ANO=RArrDet.ANO)     
Inner Join TOC on (TOC.TOC=Acceptance.TOC)     
Where (RArrDet.FullCoverF=1 or Exists (Select RCover.Category from FPartDet, RCover Where RCover.ANO=FPartDet.ANO and RCover.Code=FPartDet.Code and RCover.Category='M' and FPartDet.ANO=RArrDet.ANO and FPartDet.FID=RArrDet.FID))     
and RArrDet.Status<>'O' 
and RArrDet.ANO=@P_ANO
go


--VERSIONING
insert into PatchVersioning
select '102 Update Script - 18 November 2021',GETDATE()
go


