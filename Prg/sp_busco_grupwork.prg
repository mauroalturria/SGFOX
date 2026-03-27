lparameters mbandera,mnroreg

if mbandera = 1
	mret = sqlexec(mcon1,"select nomape,tabusuario.id,ST_fechadesde,ST_fechahasta,ST_nroregis,ST_perfil "+;
		" ,ST_usuarioid from tabusuario  "+;
		" left join Zabsegteam  on Zabsegteam.ST_usuarioid = tabusuario.Id "+;
		" where tabusuario.fecpasiva = '1900-01-01'   "+;
	 	" group by tabusuario.id order by nomape " ,"mwkGrupUsu" )
else

		mret = sqlexec(mcon1,"select nomape,tabusuario.id,ST_fechadesde,ST_fechahasta,ST_nroregis,ST_perfil "+;
		" ,ST_usuarioid from tabusuario  "+;
		" inner join Zabsegteam  on Zabsegteam.ST_usuarioid = tabusuario.Id "+;
		" where  tabusuario.fecpasiva = '1900-01-01' and  ST_fechahasta> {fn curdate()} "+;
		" and ST_nroregis = ?mnroreg group by tabusuario.id order by nomape ","mwkGrupUsu2" )
endif
if mret < 0
	=aerr(eros)
	messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SISTEMAS",16, "Validacion")
	mret=0
	cancel
endif





