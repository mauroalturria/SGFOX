mret=SQLExec(mcon1,"select TQD_NumeroQueja as NumeroQueja,"+;
	" tqj_estado,"+;
	" TabQuejaRespuestaResponsable.TQRR_EstadoRespuesta AS ESTADORESPU, "+;
	" TQR_Codigovax,"+;
	" TQR_cargo as cargo,"+;
	" TQJ_fechqueja as fechaqueja,"+;
	" tqD_FECHAENVIO As fechenvio,"+;
	" TQRR_Respuestas as respuesta, "+;
	" TabQuejaResponsables.id as nomrespo,"+;
	" tqj_paciente as paciente, "+;
	" estado7.descrip as categoria,"+;
	" TABUSUARIO.email as mail,"+;
	" tqd_decisiondire as decisión "+;
	" from tabquejadetalle"+;
	" inner join tabqueja on tabqueja.id       = TQD_NumeroQueja  "+;
	" left join motivos   on motivos.idmotivo  = tqd_motivo"+;
	" left join  TabQuejaResponsables on TabQuejaResponsables.id = TQD_Responsable "+;
	" left join TabQuejaRespuestaResponsable on TQD_NumeroQueja  = TQRR_NumeroQueja AND TQRR_USUARIO = TQD_Responsable "+;
	" left join TABUSUARIO on TabQuejaResponsables.tqr_Codigovax = TABUSUARIO.Codigovax"+;
	" Left Join tabestados As estado7 On  tabqueja.tqj_categ     = estado7.estado And estado7.tipo=5 and Estado7.propietario = 15"+;
	" WHERE tqj_estado < 4 and TQR_cargo not like 'DIRECCI%'"+;
	" and (tqd_decisiondire = 53 or tqd_decisiondire = 0) "+;
	" order by TQR_Codigovax","mwkavisoquejaspendientes")

&&or tqd_decisiondire = 52

*!*	51	NO SE ENVIA RESPUESTA POR FALTA DE DATOS
*!*	52	RESPONDE DIRECCION
*!*	53	ENVIAR A JEFE / COORDINADOR
*!*	54	DERIVAR A LEGALES
*!*	55	OTRA
*!*	56	REINTEGRO PAGOS /DEP/ COSEG

If mret < 1
	Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Return .F.
Endif

If Used('mwkavisoquejaspendientes')
	Use Dbf('mwkavisoquejaspendientes')  In 0 Again Alias mwkavisoquejaspendientesaux && Compatible VFP 6.0
	Use In mwkavisoquejaspendientes

	Update mwkavisoquejaspendientesaux Set ESTADORESPU = 0 Where Isnull(ESTADORESPU)

	Select * From mwkavisoquejaspendientesaux  Where ESTADORESPU < 2;
		INTO Cursor mwkavisoquejaspendientes 
		
	Use In mwkavisoquejaspendientesaux
Endif

