drop PROCEDURE PI20
go

CREATE procedure PI20 (@P_ANO as integer)                



as                



Begin                



	Declare @P_AsAt as smalldatetime



	Declare @P_Currency as varchar(10)



	Declare @P_MOANO as int



	Declare @P_OANO as Int



	Declare @P_Limit as float







	Declare @P_FLDID as varchar(255)



	Declare @P_VALUEID as varchar(255)



	Declare @P_VALUEDESC as varchar(255)











	Select Top 1 @P_AsAt=A.PDate, @P_OANO=A.OANO, @P_MOANO=A1.OANO, @P_Currency=A2.Currency, @P_Limit=A2.Limit, @P_FLDID=A.FLDID, @P_VALUEID=A.VALUEID, @P_VALUEDESC=A.VALUEDESC



	from Acceptance A



	Left Join Acceptance A1 on (A1.ANO=A.LANO)



	Left Join AInfoDet A2 on (A2.ANO=A1.ANO and A2.FLDID=A.FLDID and (A2.VALUEID='<All>' or A2.VALUEID=A.VALUEID) and A2.Limit<>0 and A2.Status='A')



	Where A.ANO=@P_ANO



	Order By Case When A2.VALUEID='<All>' Then 1 else 0 end











	Declare @PI20 table(INO Int, ValueID varchar(255), Description varchar(255), RefNo Varchar(255), RefDate smalldatetime, DocNo varchar(255), DocDate smalldatetime, Liability Float, Limit Float)







	insert into @PI20(INO, ValueID, Description, RefNo, Liability, Limit)



	Select 0, @P_VALUEID, @P_VALUEDESC, 'Total Limit', 0, @P_Limit











	insert into @PI20(INO, ValueID, Description, RefNo, RefDate, DocNo, DocDate, Liability, Limit)



	Select I.INO, @P_VALUEID, @P_VALUEDESC, I.RefNo, I.RefDate, I.DocNo, I.DocDate, I.Liability, 0 as Limit



	from



	(



		Select I.INO, I.RefNo, I.RefDate, I.DocNo, I.DocDate, I.Amount*coalesce(P.InstSIPCT,100)/100 as Liability



		from Acceptance mA



		Inner Join Acceptance A on (A.LANO=mA.ANO and A.LANO<>A.ANO)



		Left Join Payor_Schedule P on (P.ANO=A.ANO and P.InstDate<=@P_AsAt and (P.InstLDate>@P_AsAt or (P.InstLDate=@P_AsAt and P.InstLDate=A.EDate)))



		Inner Join ICover I on (I.ANO=A.ANO and I.Currency=@P_Currency)



		Left Join AccInvoice Av on (Av.INO=I.INO and Av.InvoiceNominal>0)



		Where MA.OANO=@P_MOANO and A.OANO<>@P_OANO and A.FLDID=@P_FLDID and A.VALUEID=@P_VALUEID



		and A.ADate<=@P_AsAt and A.AType not in ('C','A') and A.AStatus not in ('W','T') 



		and @P_AsAt between A.PDate and Case When coalesce(Av.InvoiceDate,A.EDate)<= A.EDate Then coalesce(Av.InvoiceDate,A.EDate) else A.EDate end



		and not exists (



			  Select B.PANO



			  from Acceptance B



			  Where B.PANO = A.ANO



			  and B.ADate<=@P_AsAt and B.AType not in ('A') and B.AStatus not in ('W','T')



			  and @P_AsAt between B.PDate and Case When coalesce(Av.InvoiceDate,B.EDate)<= B.EDate Then coalesce(Av.InvoiceDate,B.EDate) else B.EDate end



		)







		Union All







		Select I.INO, I.RefNo, I.RefDate, I.DocNo, I.DocDate, I.Amount*coalesce(P.InstSIPCT,100)/100 as Liability



		from Acceptance A



		Left Join Payor_Schedule P on (P.ANO=A.ANO and P.InstDate<=@P_AsAt and (P.InstLDate>@P_AsAt or (P.InstLDate=@P_AsAt and P.InstLDate=A.EDate)))



		Inner Join ICover I on (I.ANO=A.ANO and I.Currency=@P_Currency)



		Where A.ANO=@P_ANO and A.AType not in ('C','A')



	) I











	Select ValueID, Description, RefNo, RefDate, DocNo, DocDate, Liability, sum(Limit-Liability) OVER (ORDER BY INO) AS Limit



	from @PI20 I



	Order by I.INO







end   


GO




 insert into PatchVersioning
select '792 Update Script - PI20',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='792 Update Script - PI20'


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


