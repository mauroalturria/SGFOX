****
** busco internados
****
parameters mfecha

mret = sqlexec(mcon1,"SELECT   idusuario,nomape  from TabHCMovsT "+;
	" left join tabusuario on TabHCMovsT.hcm_usuario = tabusuario.idusuario "+;
	" where hcm_fechaingr =  ?mfecha ","mwkhcxopera01")
mret = sqlexec(mcon1,"SELECT   idusuario,nomape  from TabHCMovcT "+;
	" left join tabusuario on TabHCMovcT.hcm_usuario = tabusuario.idusuario "+;
	" where hcm_fechaingr =  ?mfecha ","mwkhcxopera02")

select * from mwkhcxopera01  ;
	union all ;
	select * from mwkhcxopera02  ;
	into cursor mwkhcxTotalDatos


select *,count(idusuario ) as cantidad ;
	from mwkhcxTotalDatos group  by idusuario order by nomape ;
	into cursor mwkhcxTotal

if mret<1
	=aerr(eros)
	messagebox(eros(2))
endif

