
insert into SysUserForm
select s.TYPE,f.fname,1,1,1,1,1
from SysUserType s, SysForm f
where f.FName in('ALLOWCHANGEVOUCHERWITHPRINTLOG')
and 1 not in(Select 1 from SysUserForm S1 Where S1.type=S.type and S1.fname=f.fname)
go

