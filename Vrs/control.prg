select medpresta
	miarc =1
	scan
	mmed = codmed
	mdes = hhmmdes
	mhas = hhmmhas
	mdiasem = diasem

	sqlexec(mcon1,"SELECT Turnos.diasem, Turnos.fechatur, Turnos.horatur, Turnos.tipoturno, Prestadores.nombre from turnos,prestadores "+;
		" where Prestadores.ID = codmed and fechatur>?mcon3 "+;
		" AND codmed = ?mmed and afiliado = 0 and tipoturno <> 9 "+;
		" AND Turnos.diasem = ?mdiasem and hhmmtur>= ?mdes and hhmmtur< ?mhas ", "mwkddd")
	if reccount ("mwkddd")>0
		miarc = miarc +1
		miarchi = "turnos"+alltrim(str(miarc))+".XLS"
		copy to &miarchi type xl5
	endif
endscan
