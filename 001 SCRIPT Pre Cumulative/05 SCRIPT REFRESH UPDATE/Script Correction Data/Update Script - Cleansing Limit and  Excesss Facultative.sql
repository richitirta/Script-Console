
Update RArrDet Set Limit=0, Excess=0, Amount=RArrHeader.TAmount*RArrDet.Share/100 
from RArrDet, RArrHeader 
Where RArrHeader.ANO=RArrDet.ANO and (RArrDet.Limit<>0 or RArrDet.Excess<>0)
and exists 
(
Select R1.ANO
from RArrDet R1, RARRHEADER R2 Where R2.ANO=R1.ANO AND R1.Status<>'O'
and R1.ANO=RArrDet.ANO
Group by R1.ANO
Having abs(sum(R1.share)-MAX(R2.FSHARE))>0.1
)

