

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='BSOpex' AND CONSTRAINT_NAME='FK_BSOPEX_Profile')
Begin
alter table BSOpex drop constraint FK_BSOPEX_Profile
end
GO


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QGet_BSOPEX') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE QGet_BSOPEX  END 
GO
CREATE Procedure QGet_BSOPEX(@P_ANO as integer, @P_TOC as varchar(10), @P_Source as varchar(10))
AS
SELECT top 1 @P_SOURCE as ID, BSOPEX.FDID, BSOPEX.REMARK, BSOPEX.CURRENCY, BSOPEX.AMOUNT, coalesce(BSOPEXDET.AMOUNTPCT, BSOPEX.AMOUNTPCT) AS AMOUNTPCT, BSOPEX.AMOUNTPCTBASED 
From Acceptance
Inner Join AInfo on (AInfo.ANO=Acceptance.ANO)
Inner Join BSOPEX on (BSOPEX.TOC=@P_TOC and (BSOPEX.ID='<All>' or BSOPEX.ID=@P_SOURCE))
Left Join BSOPEXDET on (
	BSOPEXDET.TOC=@P_TOC 
	and (BSOPEXDET.ID=BSOPEX.ID)
	And ((BSOPEXDET.ValueID1='' and Ainfo.ValueDesc1 Like BSOPEXDET.ValueDesc1+'%') or (BSOPEXDET.ValueID1<>'' and AInfo.ValueID1 Like BSOPEXDET.ValueID1+'%') or (BSOPEXDET.ValueID1 is null))                    
	And ((BSOPEXDET.ValueID2='' and Ainfo.ValueDesc2 Like BSOPEXDET.ValueDesc2+'%') or (BSOPEXDET.ValueID2<>'' and AInfo.ValueID2 Like BSOPEXDET.ValueID2+'%') or (BSOPEXDET.ValueID2 is null))                    
	And ((BSOPEXDET.ValueID3='' and Ainfo.ValueDesc3 Like BSOPEXDET.ValueDesc3+'%') or (BSOPEXDET.ValueID3<>'' and AInfo.ValueID3 Like BSOPEXDET.ValueID3+'%') or (BSOPEXDET.ValueID3 is null))                    
	And ((BSOPEXDET.ValueID4='' and Ainfo.ValueDesc4 Like BSOPEXDET.ValueDesc4+'%') or (BSOPEXDET.ValueID4<>'' and AInfo.ValueID4 Like BSOPEXDET.ValueID4+'%') or (BSOPEXDET.ValueID4 is null))                    
	And ((BSOPEXDET.ValueID5='' and Ainfo.ValueDesc5 Like BSOPEXDET.ValueDesc5+'%') or (BSOPEXDET.ValueID5<>'' and AInfo.ValueID5 Like BSOPEXDET.ValueID5+'%') or (BSOPEXDET.ValueID5 is null))                    
	And ((BSOPEXDET.ValueID6='' and Ainfo.ValueDesc6 Like BSOPEXDET.ValueDesc6+'%') or (BSOPEXDET.ValueID6<>'' and AInfo.ValueID6 Like BSOPEXDET.ValueID6+'%') or (BSOPEXDET.ValueID6 is null))                    
	And ((BSOPEXDET.ValueID7='' and Ainfo.ValueDesc7 Like BSOPEXDET.ValueDesc7+'%') or (BSOPEXDET.ValueID7<>'' and AInfo.ValueID7 Like BSOPEXDET.ValueID7+'%') or (BSOPEXDET.ValueID7 is null))                    
	And ((BSOPEXDET.ValueID8='' and Ainfo.ValueDesc8 Like BSOPEXDET.ValueDesc8+'%') or (BSOPEXDET.ValueID8<>'' and AInfo.ValueID8 Like BSOPEXDET.ValueID8+'%') or (BSOPEXDET.ValueID8 is null))                    
	And ((BSOPEXDET.ValueID9='' and Ainfo.ValueDesc9 Like BSOPEXDET.ValueDesc9+'%') or (BSOPEXDET.ValueID9<>'' and AInfo.ValueID9 Like BSOPEXDET.ValueID9+'%') or (BSOPEXDET.ValueID9 is null))                    
	And ((BSOPEXDET.ValueID10='' and Ainfo.ValueDesc10 Like BSOPEXDET.ValueDesc10+'%') or (BSOPEXDET.ValueID10<>'' and AInfo.ValueID10 Like BSOPEXDET.ValueID10+'%') or (BSOPEXDET.ValueID10 is null))                    
	And ((BSOPEXDET.ValueID11='' and Ainfo.ValueDesc11 Like BSOPEXDET.ValueDesc11+'%') or (BSOPEXDET.ValueID11<>'' and AInfo.ValueID11 Like BSOPEXDET.ValueID11+'%') or (BSOPEXDET.ValueID11 is null))                    
	And ((BSOPEXDET.ValueID12='' and Ainfo.ValueDesc12 Like BSOPEXDET.ValueDesc12+'%') or (BSOPEXDET.ValueID12<>'' and AInfo.ValueID12 Like BSOPEXDET.ValueID12+'%') or (BSOPEXDET.ValueID12 is null))                    
	And ((BSOPEXDET.ValueID13='' and Ainfo.ValueDesc13 Like BSOPEXDET.ValueDesc13+'%') or (BSOPEXDET.ValueID13<>'' and AInfo.ValueID13 Like BSOPEXDET.ValueID13+'%') or (BSOPEXDET.ValueID13 is null))                    
	And ((BSOPEXDET.ValueID14='' and Ainfo.ValueDesc14 Like BSOPEXDET.ValueDesc14+'%') or (BSOPEXDET.ValueID14<>'' and AInfo.ValueID14 Like BSOPEXDET.ValueID14+'%') or (BSOPEXDET.ValueID14 is null))     
	And ((BSOPEXDET.ValueID15='' and Ainfo.ValueDesc15 Like BSOPEXDET.ValueDesc15+'%') or (BSOPEXDET.ValueID15<>'' and AInfo.ValueID15 Like BSOPEXDET.ValueID15+'%') or (BSOPEXDET.ValueID15 is null))      
)
WHERE Acceptance.ANO=@P_ANO
Order by case when BSOPEX.ID='<All>' then 0 else 1 end Desc, coalesce(BSOPEXDET.PriorityF,0) Desc

GO


 insert into PatchVersioning
select '219 Update Script - 12 April 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='219 Update Script - 12 April 2022'


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



	