*!*	Gustavo Fittipaldi, 23/04/2013
*!*	BUSCO LOS ESTADOS DE MPPS A PARTIR DE UN PROTOCOLO
*!*	tnNroProtocolo = 1924701 && PRUEBA
Parameter tnNroProtocolo
nintento = 0
Do While nintento < 3
	mret = SQLExec(mcon1, "SELECT DBO.MWL_H_STATUS.* " + ;
		"FROM dbo.MWL_H " + ;
		"Left join DBO.MWL_H_STATUS on Dbo.MWL_H.StudyUID = DBO.MWL_H_STATUS.StudyUID  " + ;
		"where dbo.mwl_h.AccessionNumber = ?tnNroProtocolo ", "mwkMWLH")
	If mret <= 0
		mierr = Error()
		mimsg =  Transform(nintento)+ "-"+Message()
		mimsg1 = Message(1)
		miprg = Program()
		miline =  Lineno()
		nintento = nintento +1
		Do sp_desconexion
		Do sp_conexion With mwkexe.nomexe
	Else
		Return .T.
	Endif
Enddo
Do Log_errores With mierr ,mimsg ,mimsg1 ,miprg ,miline
Return .F.

