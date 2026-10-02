--script untuk cleansing untuk RateCOn, RateCON_M1-7

begin tran
 
Update R Set MINTSI=round(MINTSI,-1)+1
from RateCon R
Where (MINTSI<>0 or MAXTSI<>0)
and round(MINTSI,-1)+1<>MINTSI
 
Update R Set MINTSI=round(MINTSI,-1)+1
from RateCon_M1 R
Where (MINTSI<>0 or MAXTSI<>0)
and round(MINTSI,-1)+1<>MINTSI
 
Update R Set MINTSI=round(MINTSI,-1)+1
from RateCon_M2 R
Where (MINTSI<>0 or MAXTSI<>0)
and round(MINTSI,-1)+1<>MINTSI
 
Update R Set MINTSI=round(MINTSI,-1)+1
from RateCon_M3 R
Where (MINTSI<>0 or MAXTSI<>0)
and round(MINTSI,-1)+1<>MINTSI
 
Update R Set MINTSI=round(MINTSI,-1)+1
from RateCon_M4 R
Where (MINTSI<>0 or MAXTSI<>0)
and round(MINTSI,-1)+1<>MINTSI
 
Update R Set MINTSI=round(MINTSI,-1)+1
from RateCon_M5 R
Where (MINTSI<>0 or MAXTSI<>0)
and round(MINTSI,-1)+1<>MINTSI
 
Update R Set MINTSI=round(MINTSI,-1)+1
from RateCon_M6 R
Where (MINTSI<>0 or MAXTSI<>0)
and round(MINTSI,-1)+1<>MINTSI
 
Update R Set MINTSI=round(MINTSI,-1)+1
from RateCon_M7 R
Where (MINTSI<>0 or MAXTSI<>0)
and round(MINTSI,-1)+1<>MINTSI
 
--rollback
 
commit
