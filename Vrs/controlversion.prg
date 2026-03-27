select * from tabctrsrversion group by tcs_ipaddress into cursor algo
select * from algo order by tcs_device,tcs_ipaddress ;
	where  !inlist(tcs_memoria,'1.15.9', '1.15.8')
