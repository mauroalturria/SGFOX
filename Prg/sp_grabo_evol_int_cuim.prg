************
*   grabacion de cuidados complementarios
**********

lparameters midevolhce
min_idevol 		= midevolhce
if reccount('mwkindCCDind')>0
	mfechoy = sp_busco_fecha_serv("DT")
	mdia = ttod(mfechoy)
	mret = sqlexec(mcon1, "SELECT id,icc_cuidado  FROM TabIntCuiCom " + ;
		" where ICC_idevol = ?midevolhce and ICC_fechaBaja = '2100-01-01' ", "mwkVercui")

	if mret < 0
		=aerr(eros)
		messagebox(eros(3), 48, "Validacion")
	endif
	select * from mwkvercui where icc_cuidado not in (select estado from mwkindccdind) ;
		into cursor mwkbajacui
	select mwkbajacui
	scan
		mid = mwkbajacui.id
		mret = sqlexec(mcon1, "update TabIntCuiCom set ICC_fechaBaja = ?mfechoy " + ;
			" where id = ?mid ")
	endscan
	select * from mwkindccdind where estado not in (select icc_cuidado  from mwkvercui ) ;
		into cursor mwkaltacui
	if reccount('mwkaltacui')>0
		mimed = 1
		if used('mwkusuarios')
			mimed = mwkusuarios.idcodmed
		endif
		if mimed <2
			if used('mwkmedicoint')
				mimed = mwkmedicoint.id
			endif
		endif
		select mwkaltacui
		scan
			mprest = estado
			mret = sqlexec(mcon1, "insert into TabIntcuicom " + ;
				"(ICC_codmed,ICC_cuidado,ICC_fechaHora,ICC_fechaBaja, ICC_idevol )"+;
				" values (?mimed , ?mprest , ?mfechoy , '2100-01-01',  ?midevolhce)")

			if mret < 0
				mret=aerr(eros)
				messagebox(eros(3),"Validacion")
			endif
		endscan
	endif

endif
USE IN SELECT('mwkVercui')
USE IN SELECT('mwkaltacui')
USE IN SELECT('mwkbajacui')
