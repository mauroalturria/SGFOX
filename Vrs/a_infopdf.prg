****
** Actualización de Historias Unificadas, Maestros Anexos no actualizados
***
*public mcon1
*do sp_conexion
ides = 12667
ihas = 12667+1000
do while ides < 130000
	mret  = sqlexec(mcon1,'select id,informepdf from informes '+;
		'where id>= ?ides and id<=?ihas and InformePDFGenerado = 1','INFOPDF')
	if mret < 0
		messagebox('errorrororo',0,'ERROR')
		set step on
	endif
	select * from INFOPDF where isnull(informepdf ) into cursor rehacer
	select rehacer
	go top
	scan
		mid = rehacer.id
		mret = sqlexec(mcon1, "update informes set InformePDFGenerado  = 0 "  + ;
			"where id = ?mid")
		if mret < 0
			messagebox('errorrororo',0,'ERROR')
			set step on
		endif
	endscan
	ides=ihas
	ihas = ihas +1000
enddo
