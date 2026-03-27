Lparameters mopc,mxnroreg,mxidusuario
Do Case
Case mopc = 1
 
	mret = SQLExec(mcon1,"select nomape,TP_fechadesde,TP_fechahasta,TP_nroregis,TP_perfil,tabusuario.id "+;
		" ,TP_usuarioid,tabusuario.idcodmed  from tabusuario    "+;
		" left join ZabTeamPacConf  on ZabTeamPacConf.TP_usuarioid = tabusuario.Id "+;
		" where tabusuario.fecpasiva = '1900-01-01'   "+;
		" group by tabusuario.id order by nomape " ,"mwkGrupUsu" )
Case mopc = 2
	mret = SQLExec(mcon1,"select nomape,TP_fechadesde,TP_fechahasta,TP_nroregis,TP_perfil,tabusuario.id "+;
		" ,TP_usuarioid,tabusuario.idcodmed  from tabusuario   "+;
		" inner join ZabTeamPacConf  on ZabTeamPacConf.TP_usuarioid = tabusuario.Id "+;
		" where  tabusuario.fecpasiva = '1900-01-01' and  TP_fechahasta> {fn curdate()} and TP_fecpasiva = '1900-01-01' "+;
		" and TP_nroregis = ?mxnroreg group by tabusuario.id order by nomape ","mwkGrupUsu2" )
Case mopc = 3
	mret = SQLExec(mcon1,"select ZabTeamPacConf.*  from ZabTeamPacConf      "+;
		" where   TP_fechahasta>= {fn curdate()} and TP_fechadesde<={fn curdate()} and TP_fecpasiva = '1900-01-01' "+;
		" and TP_nroregis = ?mxnroreg and TP_usuarioid = ?mxidusuario  ","mwkUsuTeam" )
Endcase
If mret < 0
	=Aerr(eros)
	Messagebox("ERROR EN LA GENERACION DEL CURSOR, AVISAR A SITPEMAS",16, "Validacion")
	mret=0
	Cancel
Endif





