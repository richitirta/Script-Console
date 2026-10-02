--select distinct location from Scheme_Transaction

--select * from Location


select top 1 * into #loc from location

select * from #loc

Update #loc set Location='N/A',name='NOT AVAILABLE',Last_Opr='CARE',Last_Update='2016-10-05 00:00:00'

INSERT INTO Location 
SELECT * FROM #loc


--SELECT * FROM Scheme_Transaction S,Location L
--WHERE S.LOCATION=L.Name

update Scheme_Transaction set LOCATION=l.location 
FROM Scheme_Transaction S,Location L
WHERE S.LOCATION=L.Name


--SELECT COUNT(*) FROM Scheme_Transaction 
--WHERE LOCATION NOT IN(SELECT LOCATION FROM LOCATION)

update Scheme_Transaction set LOCATION='N/A' 
WHERE LOCATION NOT IN(SELECT LOCATION FROM LOCATION)
