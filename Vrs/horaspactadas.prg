public vr_fecha1,vr_fecha2
do sp_conexion
vr_fecha1 = ctod("01/12/2011")
vr_fecha2 = ctod("31/12/2011")

Create cursor dias (fechatur D,diasem n )
For i = 0 to vr_fecha2 - vr_fecha1
	mdias = vr_fecha1 + i
	mret=sqlexec(mcon1,"SELECT dia FROM feriaturnosA WHERE dia =?mdias",'MWKFeriados')
	If reccount('MWKFeriados')=0
		Insert into dias ( fechatur,diasem  ) values ( mdias, dow(mdias) )
	Endif
Next
mret = sqlexec(mcon1, "select codmed ,diasem, hhmmdes,hhmmhas, fecvigend, fecvigenh, tiposervicio,estructura,tipoturno "+;
	" from franjahoraria "+;
	" where diasem > 0 "  +;
	" and fecvigenh > ?vr_fecha1 and fecvigend <= ?vr_fecha2 "+;
	" and fecvigenh <> fecvigend "+;
	" group by codmed, diasem, fecvigenh, hhmmdes,hhmmhas,tipoturno ","Mwkfran0")

mret = sqlexec(mcon1, " select codmed, diasem, fecvigend,medpresta.codesp "+;
	", fecvigenh,  hdesde1, hhasta1, horadesde, horahasta, bloquedesde , bloquehasta  "+;
	", hhmmDes, hhmmHas,demanda,ESP_descripcion ,nombre as nn,generaagen,codserv,pre_descriprest  " +;
	" from especialid,medpresta,prestacions "+;
	" left join prestadores on medpresta.codmed = prestadores.id "+;
	" where medpresta.codesp = trim(especialid.ESP_codesp) " +;
	" and medpresta.codprest = prestacions.pre_codprest "+;	
	" and fecvigenh > ?vr_fecha1 and fecvigend <= ?vr_fecha2 "+;
	" and fecvigenh <> fecvigend "+;
	" ","Mwkmedpre0")

*!*		Select * from Mwkfran0  ;
*!*			left join Mwkmedpre0 on ;
*!*			Mwkmedpre0.codmed  = Mwkfran0.codmed   and ;
*!*			Mwkmedpre0.diasem  = Mwkfran0.diasem   and ;
*!*			int(Mwkmedpre0.hhmmdes/100) = int(Mwkfran0.hhmmdes/100) and ;
*!*			Mwkmedpre0.hhmmhas = Mwkfran0.hhmmhas and ;
*!*			Mwkmedpre0.fecvigend <= Mwkfran0.fecha and ;
*!*			Mwkmedpre0.fecvigenh >= Mwkfran0.fecha ;
*!*			left join mwkbloqueo on ;
*!*			mwkbloqueo.codmed  = Mwkfran0.codmed     and ;
*!*			mwkbloqueo.diasem  = dow(Mwkfran0.fecha) and ;
*!*			int(mwkbloqueo.hhmmdes/100) = int(mwkbloqueo.hhmmdes/100) and ;
*!*			mwkbloqueo.hhmmhas = Mwkfran0.hhmmhas and ;
*!*			mwkbloqueo.fvigend <= Mwkfran0.fecha 	 and ;
*!*			mwkbloqueo.fvigenh >= Mwkfran0.fecha ;
*!*			group by nombre, fecha, Mwkfran0.horadesde, Mwkfran0.horahasta ;
*!*			order by nombre, fecha, Mwkfran0.horadesde, Mwkfran0.horahasta ;
*!*			into cursor MwkControlM1

	Select Mwkfran0.*,Mwkmedpre0.*,nombre from Mwkfran0 ;
		left join Mwkmedpre0 on ;
		Mwkmedpre0.codmed  = Mwkfran0.codmed   and ;
		Mwkmedpre0.diasem  = Mwkfran0.diasem   and ;
		Mwkmedpre0.hhmmdes = Mwkfran0.hhmmdes and ;
		Mwkmedpre0.hhmmhas = Mwkfran0.hhmmhas and ;
		Mwkmedpre0.fecvigend >= Mwkfran0.fecvigend and ;
		Mwkmedpre0.fecvigenh <= Mwkfran0.fecvigenh ;
		inner join prestadores on prestadores.id = Mwkfran0.codmed;
		order by nombre, Mwkfran0.fecvigend, Mwkfran0.hhmmdes, Mwkfran0.hhmmhas ;
		into cursor MwkControlM1

	Select * from dias,MwkControlM1;
		where ;
		MwkControlM1.diasem_a  = dias.diasem   and ;
		MwkControlM1.fecvigend_a <= dias.fechatur and ;
		MwkControlM1.fecvigenh_a >= dias.fechatur ;
		group by nombre, fechatur, hhmmdes_a, hhmmhas_a,fecvigenh_a ;
		into cursor MwkControl
		
do sp_desconexion
		
		
