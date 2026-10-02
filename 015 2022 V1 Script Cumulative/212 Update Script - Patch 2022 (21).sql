
IF not EXISTS (SELECT * FROM sys.indexes WHERE name='I_SysUserSegment' AND object_id = OBJECT_ID(N'SysUserSegment'))
Begin
Create Unique Index I_SysUserSegment on SysUserSegment(ID, Segment)
end
GO

DROP FUNCTION FN_UserSegment 
GO
CREATE FUNCTION FN_UserSegment (@P_UserID as varchar(50))          
RETURNS TABLE          
as RETURN(          
 SELECT Segment.*     
 from Segment     
 Inner join SysUser on (SysUser.ID=@P_UserID)    
 Left Join SysUserSegment on (SysUserSegment.ID=SysUser.ID and SysUserSegment.Segment=Segment.Segment)
 Where (SysUser.Type='SUPERVISOR' or coalesce(SysUserSegment.Segment,'')<>'' or dbo.GetPrivileges(@P_UserID,'ALLOWPASSUSERSEGMENT')=1)
)        
        

go





 insert into PatchVersioning
select '212 Update Script - Patch 2022 (21)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='212 Update Script - Patch 2022 (21)'


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
