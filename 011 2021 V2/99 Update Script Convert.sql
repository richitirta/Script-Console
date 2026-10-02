IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'qConvert_KPR') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
Drop Procedure qConvert_KPR
end
go
CREATE Procedure qConvert_KPR(@Batchno varchar(30))                                      
as                                      
select '' as 'Ref No', '' as 'Nama', '' as 'Nilai Pertanggungan', '' as 'Periode Pertanggungan', '' as 'Tgl Buka', '' as 'Tgl Akhir', '' as 'Kode Cabang', '' as 'Nama Cabang','' as  'Nominal Premi','' as  'Imbalan Jasa Asuransi', 
                                     '' as 'Additional Premium', '' as 'Insurance Type', '' as 'Warranty Type', '' as 'Okupasi', '' as 'Telepon1', '' as 'Telepon2', '' as 'No HP', '' as 'Telepon1 Kantor', '' as 'Telepon2 Kantor', '' as 'Alamat email', '' as 'Alamat Tertanggung', 
                                     '' as 'Kelurahan Tertanggung', '' as 'Kecamatan Tertanggung', '' as 'Dati II Tertanggung', '' as 'Propinsi Tertanggung', '' as 'KodePos Tertanggung', '' as 'Alamat Koresponden', '' as 'Kelurahan Koresponden', '' as 'Kecamatan Koresponden', '' as 'Dati II Koresponden', 
                                     '' as 'Propinsi Koresponden', '' as 'KodePos Koresponden', '' as 'Alamat ObjPertanggungan', '' as 'Kelurahan ObjPertanggungan', '' as 'Kecamatan ObjPertanggungan', '' as 'Dati II ObjPertanggungan', '' as 'Propinsi ObjPertanggungan', '' as 'KodePos ObjPertanggungan'
WHERE 1<>1
go


--VERSIONING
insert into PatchVersioning
select '99 Update Script Convert',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='99 Update Script Convert'


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

