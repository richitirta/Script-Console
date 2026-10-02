IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FN_QTOPDedCode') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION FN_QTOPDedCode
end
go
CREATE FUNCTION FN_QTOPDedCode (@p_TOPRO varchar(10), @p_DCode varchar(10))
RETURNS TABLE  
AS RETURN (  
	Select Distinct Dedtab.DCODE, Dedtab.REMARKS, Dedtab.REMARKS_1,Dedtab.TOR, Dedtab.PCTTSI, PCTCL, FIXEDMIN, FIXEDMAX,FixedMin_AOE,FixedMax_AOE, CURRENCY, IUNIT,STRTSI
	From Rclass, DedTAB, TOPRO
	Where TOPRO.TOPRO=@P_TOPRO AND Rclass.TOC=TOPRO.TOC and Rclass.TOR=DedTAB.TOR and DedTAB.DCode Like @P_DCode
) 

GO

insert into PatchVersioning
select 'Update Script WebSetup 13 Nov 2020 (Top_Deductible)',GETDATE()
go
