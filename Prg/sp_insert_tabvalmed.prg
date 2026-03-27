****
** grabo un movimiento cuando hay inconsistencia de datos
****

parameter medex,mvale

	mret = sqlexec(mcon1, 'select id from TabValMedExt '+;
		'where codmed= ?medex and nrovale= ?mvale ','mwkauxi')
	if mret > 0
		if reccount('mwkauxI')=0
			mret = sqlexec(mcon1, 'INSERT INTO TabValMedExt (codmed , estado , nrovale)'+;
				' values ( ?medex,"",?mvale )')
		endif
	endif						
	