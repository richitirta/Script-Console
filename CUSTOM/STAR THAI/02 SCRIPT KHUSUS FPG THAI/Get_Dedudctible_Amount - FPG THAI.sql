drop procedure Get_Dedudctible_Amount
go
CREATE Procedure Get_Dedudctible_Amount(@P_ANO as Int, @Code as varchar(10), @Amount as Float)
as
Declare @DiscAmount as float
Declare @VCode as varchar(10)
If (@Code in ('O05-001')) begin
 Select @VCode=
 A2.ValueID1 from acceptance A1, AInfo A2 where A1.ANO = A2.ANO and A1.TOC = '3201' and A1.ANO = @P_ANO 
 Select @DiscAmount = 
  Case When @VCode in ('110','120','210','220','230','320','340','420','520','540','730','801','802','803','804','805','806') then
   case when @Amount > 5000 then 5000 + (@Amount-5000) * 0.1 
     Else @Amount 
   End
    When @VCode in ('610','620','630') then
   case When @Amount >1000 then 1000 + (@Amount-1000) * 0.2
     Else @Amount
   End
  End
End
Else If (@Code in ('P32-001')) begin
 Select @VCode=
 A2.ValueID1 from acceptance A1, AInfo A2 where A1.ANO = A2.ANO and A1.TOC = '3201' and A1.ANO = @P_ANO 
 Select @DiscAmount = 
  Case When @VCode in ('110','120','210','220','230','320','340','420','520','540','730','801','802','803','804','805','806','610','620','630') then
   case when @Amount > 5000 then (5000*0.1) + ((@Amount-5000) * 0.01)
        When @Amount <= 5000 then (@Amount*0.1) 
     Else @Amount 
   End
  End
end
Else Set @DiscAmount = @Amount
Select @DiscAmount as 'Disc'