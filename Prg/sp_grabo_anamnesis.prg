****
** Grabo anamnesis del paciente
****

parameter mabm,mnroreg,ctexto,mFechaActiva,mid,musuario 

mfecha = sp_busco_fecha_serv('DT')
mfechaPasiva = sp_busco_fecha_serv('DD')
  IF mabm = 1
	mret = sqlexec(mcon1, "insert into TabNutHpac (TNH_registracio,TNH_fecha," + ;
					  " TNH_anamnesis,tnh_fechapasiva) " + ;
				 	  " values ( ?mnroreg, ?mfecha ,?ctexto,?mFechaActiva) " )
  ELSE 
	mret = sqlexec(mcon1, "update TabNutHpac set tnh_fechapasiva = ?mfechaPasiva " + ;
					  " ,TNH_usuario = ?musuario where id = ?mid " ) 
  ENDIF 			  
			  
if mret<1
	=aerr(eros)
	messagebox (eros(2))
endif