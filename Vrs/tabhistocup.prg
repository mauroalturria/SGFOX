select * from tabhistocup group by fecha,hora,sector order by fecha,hora,sector having count(id)>1 into cursor dobles

delete * from tabhistocup where id in (select id from dobles)
