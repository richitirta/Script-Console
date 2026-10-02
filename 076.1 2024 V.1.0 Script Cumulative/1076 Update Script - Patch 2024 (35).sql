IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QGet_AutoApplyFeeDuty') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN 
DROP Procedure QGet_AutoApplyFeeDuty
end
GO
CREATE Procedure QGet_AutoApplyFeeDuty(@P_ANO as integer)
AS
Declare @P_LANO as integer

Select @P_LANO=LANO from Acceptance Where ANO=@P_ANO

if @P_LANO<>@P_ANO -- Individual or Certificate
BEGIN
	Select Top 1 F.FDID, F.FDType, F.DESCRIPTION as REMARK, F.Currency, Fd.Amount
	from Acceptance A
	Inner Join Premium_Calculation(@P_ANO) P on (P.ANO=A.ANO)
	Inner join Cover C on (C.CNO=A.CNO and C.ISType in ('I','L'))
	Inner join FDTAB F on ((F.Atype='ALL' or F.Atype = A.AType) and F.AutoApplyF=1 and F.Currency=P.Currency and F.FDType in ('F','D'))
	Inner Join FDTABDET Fd on (Fd.FDID=F.FDID and (FD.Segment='<All>' or FD.Segment=C.Segment) and (P.Premium-P.Discount) Between fd.Lower and fd.upper and fd.Amount<>0)
	Left Join FDTABTOC on (FDTABTOC.FDID=F.FDID and FDTABTOC.TOC=A.TOC)
	Where A.ANO=@P_ANO
	and (F.ApplyTOCF=0 or coalesce(FDTABTOC.TOC,'')<>'')
End
BEGIN
	Select Top 1 F.FDID, F.FDType, F.DESCRIPTION as REMARK, F.Currency, Fd.Amount
	from Acceptance A
	Inner Join 
	(
	    Select Acceptance.LANO as ANO, P.Currency, sum(P.Premium) as Premium, sum(P.Discount) as Discount
		from Acceptance
		Cross Apply (Select P.Currency, P.Premium, P.Discount from Premium_Calculation(Acceptance.ANO) P) P
		Where Acceptance.AType='N' and Acceptance.LANO=@P_ANO 
		Group by Acceptance.LANO, P.Currency
	) P on (P.ANO=A.ANO)
	Inner join Cover C on (C.CNO=A.CNO and C.ISType in ('I','L'))
	Inner join FDTAB F on ((F.Atype='ALL' or F.Atype = A.AType) and F.AutoApplyF=1 and F.Currency=P.Currency and F.FDType in ('F','D'))
	Inner Join FDTABDET Fd on (Fd.FDID=F.FDID and (FD.Segment='<All>' or FD.Segment=C.Segment) and (P.Premium-P.Discount) Between fd.Lower and fd.upper and fd.Amount<>0)
	Left Join FDTABTOC on (FDTABTOC.FDID=F.FDID and FDTABTOC.TOC=A.TOC)
	Where A.ANO=@P_ANO
	and (F.ApplyTOCF=0 or coalesce(FDTABTOC.TOC,'')<>'')
END
go


insert into PatchVersioning
select '1076 Update Script - Patch 2024 (35)',GETDATE()
go
	

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1076 Update Script - Patch 2024 (35)'


Declare @ExecScript varchar(100)
Declare @ExecScriptStatus varchar(100)
Declare @Error varchar(200)

Select @Error=''

Begin 
       Select @ExecScript=Execscript,  @ExecScriptStatus=ExecScriptStatus from systab 
       if @PrevScript<>'' and @ExecSCript<>@PrevScript
              THROW 51000, 'Not the Next Sequence Script', 1;
       else 
              if @ExecScriptStatus<>'' and @ExecScriptStatus<>'DONE'
              THROW 51000, 'Pending Script Execution', 1;

       Update SysTab Set ExecScript=@CurrScript, ExecScriptStatus='PENDING'             
       
       BEGIN TRY            
			PRINT '--EXECUTE DONE--'
       END TRY  
       BEGIN CATCH  
       END CATCH;


       Update SysTab Set ExecScript=@CurrScript, ExecScriptStatus='DONE'         
End




go	
