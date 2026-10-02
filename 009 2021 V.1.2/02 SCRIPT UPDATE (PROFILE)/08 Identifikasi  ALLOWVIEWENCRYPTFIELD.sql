
--jika ALLOWVIEWENCRYPTFIELD di allow semua(1), tidak akan di encrypt,
--
--jika (0) atau tidak di allow akan ter-encrypt

-- cek ALLOWVIEWENCRYPTFIELD
select * from sysform where FName = 'ALLOWVIEWENCRYPTFIELD'
go

select * from SysUserForm where fname = 'ALLOWVIEWENCRYPTFIELD'
go

--jika 0 (R,W,A,D,C,M), (untuk aig only), 
--maka jalankan script berikut

--insert into SysUserForm
--select s.TYPE,f.fname,1,1,1,1,1,1
--from SysUserType s, SysForm f
--where f.FName in

--('ALLOWVIEWENCRYPTFIELD')

--and 1 not in(Select 1 from SysUserForm S1 Where S1.type=S.type and S1.fname=f.fname)
--go