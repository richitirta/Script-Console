DROP Function fn_BizMap
GO
CREATE Function fn_BizMap(@P_ANO as int, @P_Source as varchar(10)='') 
RETURNS VarChar(10) 
AS 
 
BEGIN 
Declare @CType varchar(20) 
Declare @PType varchar(20) 
Declare @IType varchar(20) 
Declare @EType varchar(20) 
Declare @CGroup varchar(10) 
Declare @Segment varchar(10) 
Declare @ISType varchar(10) 
Declare @Payor_LOB varchar(10) 
Declare @PHolder_LOB varchar(10) 
Declare @Insured_LOB varchar(10) 
Declare @Source_LOB varchar(10) 
Declare @SegmentGroup varchar(10) 
Declare @BizmapID varchar(10) 
Declare @ID varchar(10) 
 
if @P_ANO>0 
Begin 
	 if @P_Source='' 
	 Begin 
	  Select 
	  @CType=Source.CType, 
	  @PType=case When Source.PType='C' Then 'CAPTIVE' When Source.PType='D' Then 'DIRECT INSURED' When Source.PType='M' Then 'INTERMEDIARIES' else 'OTHERS' end, 
	  @IType=I.IType, 
	  @EType=Case When PHolder.CorporateF=1 Then 'CORPORATE' Else 'INDIVIDUAL' end,
	  @CGroup=PHolder.CGroup, 
	  @Segment=C.Segment, 
	  @ISType=C.ISType, 
	  @Payor_LOB=coalesce(PAPayor.LOB,PMPayor.LOB), 
	  @PHolder_LOB=PHolder.LOB, 
	  @Insured_LOB=Insured.LOB, 
	  @Source_LOB=Source.LOB, 
	  @SegmentGroup=SegmentGroup.SegmentGroup, 
	  @BizmapID=A.BizmapID
	  from Acceptance A
	  Inner join Cover C on (C.CNO=A.CNO)
	  Left Join Segment on (Segment.Segment=C.Segment) 
	  Left join SegmentGroup on (Segment.SegmentGroup=SegmentGroup.SegmentGroup) 
	  Left Join InParty I On (I.CNO=C.CNO)
	  Left Join Payor MPayor on (MPayor.ANO=A.LANO)
	  Left Join Payor APayor on (APayor.ANO=A.ANO)
	  Left Join Profile PMPayor on (PMPayor.ID=MPayor.ID)
	  Left Join Profile PAPayor on (PAPayor.ID=APayor.ID)
	  Left Join Profile PHolder on (PHolder.ID=C.PHolder)
	  Left Join Profile Insured on (Insured.ID=A.AID)
	  Left Join Profile Source on (Source.ID=A.Source)
	  Where A.ANO=@P_ANO 
	 End 
	 Else 
	 Begin 
	  Select 
	  @CType=Source.CType, 
	  @PType=case When Source.PType='C' Then 'CAPTIVE' When Source.PType='D' Then 'DIRECT INSURED' When Source.PType='M' Then 'INTERMEDIARIES' else 'OTHERS' end, 
	  @IType=I.IType, 
	  @EType=Case When PHolder.CorporateF=1 Then 'CORPORATE' Else 'INDIVIDUAL' end,
	  @CGroup=PHolder.CGroup, 
	  @Segment=C.Segment, 
	  @ISType=C.ISType, 
	  @Payor_LOB=coalesce(PAPayor.LOB,PMPayor.LOB), 
	  @PHolder_LOB=PHolder.LOB, 
	  @Insured_LOB=Insured.LOB, 
	  @Source_LOB=Source.LOB, 
	  @SegmentGroup=SegmentGroup.SegmentGroup 
	  from Acceptance A
	  Inner join Cover C on (C.CNO=A.CNO)
	  Left Join Segment on (Segment.Segment=C.Segment) 
	  Left join SegmentGroup on (Segment.SegmentGroup=SegmentGroup.SegmentGroup) 
	  Left Join InParty I On (I.CNO=C.CNO)
	  Left Join Payor MPayor on (MPayor.ANO=A.LANO)
	  Left Join Payor APayor on (APayor.ANO=A.ANO)
	  Left Join Profile PMPayor on (PMPayor.ID=MPayor.ID)
	  Left Join Profile PAPayor on (PAPayor.ID=APayor.ID)
	  Left Join Profile PHolder on (PHolder.ID=C.PHolder)
	  Left Join Profile Insured on (Insured.ID=A.AID)
	  Left Join Profile Source on (Source.ID=@P_Source)
	  Where A.ANO=@P_ANO 
	 End 
End 
ELSE 
BEGIN 
	SELECT 
		@CType=Source.CType, 
		@PType=case When Source.PType='C' Then 'CAPTIVE' When Source.PType='D' Then 'DIRECT INSURED' When Source.PType='M' Then 'INTERMEDIARIES' else 'OTHERS' end, 
		@EType=Case When Source.CorporateF=1 Then 'CORPORATE' Else 'INDIVIDUAL' end,
		@Source_LOB=Source.LOB, 
		@Segment='DIRECT', 
	    @ISType='I' 
	from Profile Source 
	Where Source.ID=@P_Source	 
END 
 
Select Top 1 @ID=B.ID 
from BizMap B 
Where b.Post_Flag = 1 and b.AllowedF=1
and (CType='<ANY>' or CType=@CType) 
and (PType='<ANY>' or PType=@PType) 
and (IType='<ANY>' or IType=@IType) 
and (EType='<ANY>' or EType=@EType) 
and (Cgroup='<ANY>' or CGroup=@CGroup) 
and (EXCgroup='<ANY>' or EXCgroup<>@CGroup) 
and (Segment='<ANY>' or Segment=@Segment) 
and (ISType='<ANY>' or ISType=@ISType) 
and (Payor_LOB='<ANY>' or Payor_LOB=@Payor_LOB) 
and (PHolder_LOB='<ANY>' or PHolder_LOB=@PHolder_LOB) 
and (Insured_LOB='<ANY>' or Insured_LOB=@Insured_LOB) 
and (Source_LOB='<ANY>' or Source_LOB=@Source_LOB) 
and (SegmentGroup='<ANY>' or SegmentGroup=@SegmentGroup) 
Order By OrderNo, ID 

return(coalesce(@ID,@BizMapID)) 
End 



GO


 insert into PatchVersioning	
select '530 Update Script - Patch 2023 (3))',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='530 Update Script - Patch 2023 (3)'


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

