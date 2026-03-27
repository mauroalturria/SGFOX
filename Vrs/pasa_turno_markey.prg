SELECT Turnos.horatur, Turnos.afiliado, Turnos.codmed, Turnos.codent,;
  Registracio.REG_distrito, Turnos.codprest, Turnos.codserv, Turnos.codesp,;
  Turnos.observa, Turnos.ID, Turnos.tipotomado, Turnos.diasem,;
  Turnos.fechatur, Turnos.hhmmTur;
 FROM ;
     SQLUser.Turnos Turnos,;
    SQLUser.REGISTRACIO Registracio;
 WHERE  Registracio.REG_nroregistrac = Turnos.afiliado;
   AND afiliado>2 AND  Turnos.fechatur >= {fn curdate()} 
   
   
   join con medpresta de Lima
   SELECT Medpresta.ID, Medpresta.diasem, Medpresta.duracion,;
  Medpresta.hhmmDes, Medpresta.hhmmHas, Medpresta.fecVigend,;
  Medpresta.fecVigenH, Medpresta.codmed, Medpresta.cantidad,;
  Medpresta.fechaUltAgenda, Medpresta.codprest,;
  Prestacions.PRE_descriprest, Prestacions.PRE_duracion,;
  Medpresta.codesp, Medpresta.codserv, Prestadores.nombre,;
  Medpresta.demanda, Medpresta.GeneraAgen, Medpresta.canturnos,;
  Prestadores.fecpasivap, Prestacions.PRE_fechapasiva, Medpresta.sala,;
  Prestadores.bloquedesde, Prestadores.bloquehasta;
 FROM ;
     SQLUser.MedPresta Medpresta ;
    INNER JOIN SQLUser.PRESTADORES Prestadores ;
   ON  Medpresta.codmed = Prestadores.ID ;
    INNER JOIN SQLUser.PRESTACIONS Prestacions ;
   ON  Medpresta.codprest = Prestacions.PRE_codprest;
 WHERE  Medpresta.fecVigenH > Medpresta.fecVigend;
   AND  (  Medpresta.fecVigenH >= {fn curdate()};
   AND  (  Medpresta.GeneraAgen = ( 1 );
   AND  Medpresta.sala LIKE ( '%LIMA%' )) );
 ORDER BY Medpresta.codmed, Medpresta.diasem, Medpresta.hhmmDes
 
  Select turnomarkey.horatur,99 as sede, turnomarkey.afiliado, turnomarkey.codmed, turnomarkey.codent,;
   turnomarkey.REG_distrito AS PLAN, turnomarkey.codprest, turnomarkey.codserv, turnomarkey.codesp,;
  PRG_SACA_char(turnomarkey.observa,"≥¡…Õ”⁄¿»Ã“Ÿ‡ËÏÚ˘±ë—–^\'$:Ò•∑ˇü∫?ø!°%&®;.™|¨¬") as observacion,  turnomarkey.id, turnomarkey.tipotomado,turnomarkey.CUIL ;
   From medprestalima,turnomarkey Where medprestalima.codmed = turnomarkey.codmed ;
	AND medprestalima.diasem = turnomarkey.diasem And medprestalima.hhmmdes <= turnomarkey.hhmmtur ;
	AND medprestalima.hhmmhas>  turnomarkey.hhmmtur And medprestalima.fecvigend <= turnomarkey.fechatur ;
	AND medprestalima.fecvigenh>= turnomarkey.fechatur  group By turnomarkey.Id Into Cursor pasaje
	
	COPY TO pasaje TYPE CSv
	
	
  
SELECT id as idturnos,3 as codcancela,'GISEFERNANDEZ' AS usucancela,* FROM  turnoid INTO CURSOR NUEVO

UPDATE turnoidm SET AFILIADO =turnoscancel.afiliado,Tipoturno = turnoscancel.tipoturno,codent = turnoscancel.codent;
,codprest =  turnoscancel.codprest,codesp=turnoscancel.codesp,codreserva=turnoscancel.codreserva,codserv = turnoscancel.codserv ;
,idturnoexterno = turnoscancel.idturnoexterno, ;
usuariosector=turnoscancel.usuariosector,usuario = turnoscancel.usuario ,codserv =turnoscancel.codserv 
SELECT turnoscancel.ID, turnoscancel.afiliado, turnoscancel.bloqueado, turnoscancel.codent,;
  turnoscancel.codesp, turnoscancel.codmed, turnoscancel.codmedsoli, turnoscancel.codprest,;
  turnoscancel.codreserva, turnoscancel.codserv, turnoscancel.confirmado, turnoscancel.diasem,;
  turnoscancel.fechaconfirma, turnoscancel.fechagenera, turnoscancel.fechaobserva,;
  turnoscancel.fechatomado, turnoscancel.fechatur, turnoscancel.hhmmTur, turnoscancel.horatur,;
  turnoscancel.idturnoexterno, turnoscancel.nrovale, turnoscancel.observa,;
  turnoscancel.preregistra, turnoscancel.solicigia, turnoscancel.tipotomado,;
  turnoscancel.tipoturno, turnoscancel.tomado, turnoscancel.usuario, turnoscancel.usuarioconfirma,;
  turnoscancel.usuariogenera, turnoscancel.usuarioobserva, turnoscancel.usuariosector
  
  
  
  update turnoid set afiliado = 0 , usuario = '', codprest = 0, ;
		 codmedsoli = 0, solicigia = 0, codreserva = '',  tipotomado = 0,  ;
		codent = 0, codserv = 0, codesp = '',UsuarioSector = 0 
		
		
		  update agrego set afiliado = 0 , usuario = '', codprest = 0, ;
		 codmedsoli = 0, solicigia = 0, codreserva = '',  tipotomado = 0,  ;
		codent = 0, codserv = 0, codesp = '',UsuarioSector = 0 ,fechatomado = null
		