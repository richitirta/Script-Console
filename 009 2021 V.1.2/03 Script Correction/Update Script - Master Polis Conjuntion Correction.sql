
--script cleansing 
--Data Master Polis yang Conjunct ke Certificate harus diubah Conjuct-nya ke Master Polis-nya

--Koreksi Data-nya

Update A Set CANO=CA.LANO

from Acceptance A, Acceptance CA

Where CA.ANO=A.CANO

--Master Polis

and A.ANO=A.LANO

--Conjunct ke Certificate

and CA.ANO<>CA.LANO and CA.LANO<>-1