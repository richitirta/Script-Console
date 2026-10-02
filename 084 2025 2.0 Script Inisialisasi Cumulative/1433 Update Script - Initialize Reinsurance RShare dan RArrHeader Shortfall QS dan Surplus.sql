Update R Set RShare=RPart.RShare
from Reinsurance R
cross apply (
	Select sum(RPArt.Share) as RShare from RPart Where RNO=R.RNO
) RPart
Where R.RShare=0

Update RArrHeader Set 
QSSFAmount=(R.QAmount*(100-coalesce(Rq.RShare,0))/100),
QSSFShare=(R.QAmount*(100-coalesce(Rq.RShare,0))/100)/R.TAmount*100,
SPRAmount=(R.SP1AMOUNT*(100-coalesce(R1.RShare,0))/100+R.SP2AMOUNT*(100-coalesce(R2.RShare,0))/100+R.SP3AMOUNT*(100-coalesce(R3.RShare,0))/100),
SPRShare=(R.SP1AMOUNT*(100-coalesce(R1.RShare,0))/100+R.SP2AMOUNT*(100-coalesce(R2.RShare,0))/100+R.SP3AMOUNT*(100-coalesce(R3.RShare,0))/100)/R.TAMOUNT*100
from RArrHeader R
Left Join Reinsurance Rq on (Rq.RID=R.QID)
Left Join Reinsurance R1 on (R1.RID=R.SP1ID)
Left Join Reinsurance R2 on (R2.RID=R.SP2ID)
Left Join Reinsurance R3 on (R3.RID=R.SP3ID)
Where R.TAmount<>0
