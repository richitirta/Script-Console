-- Update script settingan segment
insert into SysUserSegment(id, Segment)
Select distinct t.id, s.segment
from sysuser t,segment s


