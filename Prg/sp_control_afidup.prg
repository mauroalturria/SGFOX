****
** Control Afiliaciones duplicadas necesito el cursor entidades
****
parameter mafi  , mcodent,mnumdoc,mreg,pasa
mnroafi  = mafi
mbusco1  = "afi_nroafiliado = ?mnroafi and afi_codentidad = ?mcodent and "

do sp_busco_por_tipynro with mbusco1
select * from mwkbuscopa where REG_nroregistrac # mreg into cursor mwkbuscopa1

select * from entidades where ent_codent = mcodent into cursor enti1
if nvl(enti1.Ent_codagrup,0)>0 and nvl(enti1.Ent_codagrup,0) # enti1.ent_codent 
	micodi  = enti1.Ent_codagrup
	select * from entidades where ent_codent # mcodent and Ent_codagrup = micodi  into cursor enti2
	select enti2
	mbusco1  = "afi_nroafiliado = ?mnroafi and afi_codentidad in ( "
	scan
		mbusco1 = mbusco1 + str(ent_codent,5,0)+ ", "
	endscan
	mbusco1 = substr(mbusco1 ,1,len(mbusco1 )-2) + " ) and "
	do sp_busco_por_tipynro with mbusco1

	select * from mwkbuscopa where REG_nroregistrac # mreg into cursor mwkotroafi
	if reccount("mwkotroafi")>0
		select * from mwkbuscopa1 union all select * from mwkotroafi into cursor mwkbuscopa1
	endif
endif
select * from mwkbuscopa1 group by REG_nroregistrac into cursor mwkbuspacie 
