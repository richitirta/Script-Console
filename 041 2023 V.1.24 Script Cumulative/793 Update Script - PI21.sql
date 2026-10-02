
DROP PROCEDURE PI21
GO
CREATE procedure PI21 (@P_ANO as integer)                



as                



Begin                



Select LANO, ANO, OANO, CertificateNo, ValueDesc, AName, SDate, EDate, TotalLimit, SUM (TotalLimit) OVER (PARTITION BY LANO ORDER BY LANO, ANO) AS Balance



	from



	(



	Select 



		la.LANO, lA.ANO, lA.OANO, lA.CertificateNo, 'BB' as ValueID, 'Beginning Balance' as ValueDesc,'' as AName, lA.SDate, lA.EDate, I1.SI as TotalLimit



		from Acceptance lA



		Inner Join Cover C on (C.CNO=lA.CNO and C.OpenFlag=1)



		Inner Join ICover I1 on (I1.ANO=lA.ANO and I1.Category='M' and I1.SI<>0)



		Where lA.ANO=@P_ANO and lA.ANO=lA.LANO 







	Union All 







	Select 



		la.LANO, A.ANO, A.OANO, A.CertificateNo, A.ValueID, A.ValueDesc, A.AName, A.SDate, A.EDate, -I2.SI as TotalLimit



		from Acceptance lA



		Inner Join Cover C on (C.CNO=lA.CNO and C.OpenFlag=1)



		Inner Join ICover I1 on (I1.ANO=lA.ANO and I1.Category='M' and I1.SI<>0)



		Inner Join Acceptance A on (A.LANO=lA.ANO and A.ANO<>A.LANO and A.AType in ('N','E')  and A.AStatus='I')



		Inner Join ICover I2 on (I2.ANO=A.ANO and I2.TOI=I1.TOI and I2.Currency=I1.Currency)



		Where lA.ANO=@P_ANO and lA.ANO=lA.LANO 



	) S







	Order by LANO, ANO



end   




















GO


 insert into PatchVersioning
select '793 Update Script - PI21',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='793 Update Script - PI21'


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


