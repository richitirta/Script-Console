



Update A Set CNO=MA.CNO
from Acceptance MA, Acceptance A
Where A.RegNo=MA.RegNo and A.PolicyNo=MA.PolicyNo and MA.PolicyNo<>'' and MA.RegNo<>'' and MA.ANO=MA.LANO
and A.CNO<>MA.CNO