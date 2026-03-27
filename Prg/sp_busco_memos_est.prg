
* TRAE LOS MEMOS
******************************
parameters midme
mret=sqlexec(mcon1," select TabMElog.*,prestadores.nombre,tabusuario.nomape,tabestados.descrip "+;
	" from TabMElog "+;
	" inner join prestadores  on MEL_Codmed = prestadores.id "+;
	" left join tabusuario on MEL_usuario = tabusuario.codigovax "+;
	" inner join tabestados ON (MEL_Estado = tabestados.estado and propietario = 106 ) "+;
	" where MEL_idMemo = ?midme " +;
	" Order by TabMElog.id desc","mwkmemolog")
if mret < 0
	messagebox('ERROR DE CURSOR LOG DE MEMOS',64,'VALIDACION')
	mret=0
endif

