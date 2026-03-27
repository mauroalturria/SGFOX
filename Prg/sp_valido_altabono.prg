******************************
* AUTOR: Claudia C. Antoniow
******************************
* Fecha :21/10/2003
********************
parameter v_nonbono, v_imp, v_tipobono, v_fecdesde, v_fechasta

mret = sqlexec(mcon1,"SELECT * FROM TabBono WHERE trim(denominacion)  =?v_nonbono  "+;
	"AND  tipobono = ?v_tipobono AND fecvigend =?v_fecdesde "+;
	"AND fecvigenh = ?v_fechasta AND importe =?v_imp ","MWKExisteBono")

if mret < 0
	messagebox('ERROR AL ACTUALIZAR LOS DATOS, AVISAR A SITEMAS',16,'VALIDACION')
	mret = 0
	cancel
else
	if eof('MWKExisteBono')
		mret = sqlexec(mcon1,"SELECT * FROM TabBono WHERE denominacion  = ?v_nonbono "+;
			"AND tipobono = ?v_tipobono AND (?v_fecdesde BETWEEN fecvigend "+;
			"AND fecvigenh OR ?v_fechasta BETWEEN fecvigend AND fecvigenh ) ",+;
			"MWKAntBono")

		if mret < 0
			messagebox('ERROR AL ACTUALIZAR LOS DATOS, AVISAR A SITEMAS',16,'VALIDACION')
			mret = 0
			cancel
		else
* Dar de baja la encontrada anterior
			if !eof("MWKAntBono")
				v_id = MWKAntBono.id
				mret = sqlexec(mcon1,"UPDATE TabBono SET fecvigenh =?v_fecdesde "+;
					" WHERE TabBono.id = ?v_id ")
				mret = sqlexec(mcon1,"insert into TabBono "+;
					"( CodMotivo , Denominacion , Importe , TipoBono , Usuario , fechagraba , "+;
					"fecvigend , fecvigenh , idbonoasoc)"+;
					"  select CodMotivo , Denominacion , Importe , TipoBono , Usuario , fechagraba , "+;
					"fecvigend , fecvigenh , idbonoasoc  from tabbono where id = ?v_id")
					
				mret = sqlexec(mcon1,"UPDATE TabBono SET fecvigenh = '2100-01-01'  "+;
					" WHERE TabBono.id = ?v_id ")

				if mret < 0
					messagebox('ERROR AL ACTUALIZAR LOS DATOS, AVISAR A SITEMAS',16,'VALIDACION')
					mret = 0
					cancel
				else
*!*						mret = sqlexec(mcon1,"UPDATE TabBonoenti SET fecvigenh =?v_fecdesde "+;
*!*									 " WHERE TabBonoenti.idbono = ?v_id ")

*!*						if mret < 0
*!*							messagebox('NO SE ACTUALIZARON LOS DATOS BONOENTIDAD, AVISAR A SITEMAS',16,'VALIDACION')
*!*							mret = 0
*!*							Cancel
*!*						endif
					messagebox('BAJA DE DATOS ANTERIORES ACTUALIZADOS, VERIFIQUE',64,'VALIDACION')
				endif
			endif
		endif
	else
		v_id = MWKExisteBono.id
		mret = sqlexec(mcon1,"UPDATE TabBono SET fecvigenh =?v_fecdesde "+;
			" WHERE TabBono.id = ?v_id ")
		mret = sqlexec(mcon1,"insert into TabBono "+;
			"( CodMotivo , Denominacion , Importe , TipoBono , Usuario , fechagraba , "+;
			"fecvigend , fecvigenh , idbonoasoc)"+;
			"  select CodMotivo , Denominacion , Importe , TipoBono , Usuario , fechagraba , "+;
			"fecvigend , fecvigenh , idbonoasoc  from tabbono where id = ?v_id")

		mret = sqlexec(mcon1,"UPDATE TabBono SET fecvigenh = '2100-01-01'  "+;
			" WHERE TabBono.id = ?v_id ")


		if mret < 0
			messagebox('ERROR AL ACTUALIZAR LOS DATOS, AVISAR A SITEMAS',16,'VALIDACION')
			mret = 0
			cancel
		else
*				DELETE ALL IN MWKExisteBono
			messagebox('BAJA DE DATOS ANTERIORES ACTUALIZADOS, VERIFIQUE',64,'VALIDACION')

*!*					mret = sqlexec(mcon1,"UPDATE TabBonoenti SET fecvigenh =?v_fecdesde "+;
*!*									 " WHERE TabBonoenti.idbono = ?v_id ")
*!*					if mret < 0
*!*						messagebox('NO SE ACTUALIZARON LOS DATOS BONOENTIDAD, AVISAR A SITEMAS',16,'VALIDACION')
*!*						mret = 0
*!*						Cancel
*!*					endif
		endif
	endif
endif


