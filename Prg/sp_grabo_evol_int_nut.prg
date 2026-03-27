************
*   grabacion de pedido de nutricion dl paciente
**********

lparameters midevolhce,mobser,lactualizo,tfecha,tadmision,mcfechora,mprest,mimed,misec,mobsernut
min_idevol 		= midevolhce
if vartype(lactualizo)#"N"
	lactualizo = 0
endif
mfh = sp_busco_fecha_serv("DT")
mfechoy = iif(vartype(mcfechora)="T",mcfechora,mfh )
mdia = ttod(mfechoy)
do case
	case lactualizo = 0 &&&lo normal
		if reccount('mwkprestaInd')>0
			mret = sqlexec(mcon1, "SELECT tabinthce.id FROM TabIntNut,tabinthce " + ;
				" where ih_admision  = ?tadmision and IN_fechaBaja = '2100-01-01' "+;
				" and tabinthce.id = IN_idevol "+;
				" group by ih_secuencia ", "mwkVernut")

			if mret < 0
				=aerr(eros)
				messagebox(eros(3), 48, "Validacion")
			endif

			if reccount('mwkVernut')>0
				select mwkVernut
				scan
					midevolhce  = mwkVernut.id
					mret = sqlexec(mcon1, "update TabIntNut set IN_fechaBaja = ?mfechoy " + ;
						" where IN_idevol = ?midevolhce and IN_fechaBaja = '2100-01-01' ")
				endscan
			endif
		endif

		mimed = 1
		if used('mwkusuarios')
			mimed = mwkusuarios.idcodmed
		endif
		if mimed <2
			if used('mwkmedicoint')
				mimed = mwkmedicoint.id
			endif
		endif
		midevolhce = min_idevol
		select mwkprestaInd
		scan
			mprest = pre_codprest
			mret = sqlexec(mcon1, "insert into TabIntNut " + ;
				"(IN_codmed ,IN_codprest ,IN_fechaHoraIni ,IN_fechaBaja ,IN_idevol ,IN_observa,IN_fechaHoraApli,IN_observanut )"+;
				" values (?mimed , ?mprest , ?mfechoy , '2100-01-01',  ?midevolhce, ?mobser,'1900-01-01',?mobsernut)")

			if mret < 0
				mret=aerr(eros)
				messagebox(eros(3),"Validacion")
			endif
		endscan
	case lactualizo = 1 &&&lo normal
&&& actualizo desde nutricion
		mret = sqlexec(mcon1, "SELECT tabinthce.id FROM TabIntNut,tabinthce " + ;
			" where ih_admision  = ?tadmision and IN_fechaBaja = '2100-01-01' "+;
			" and tabinthce.id = IN_idevol "+;
			" group by ih_secuencia ", "mwkVernut")
		if mret < 0
			=aerr(eros)
			messagebox(eros(3), 48, "Validacion")
		endif
		if reccount('mwkVernut')>0
			select mwkVernut
			scan
				midevolhce  = mwkVernut.id
				mret = sqlexec(mcon1, "update TabIntNut set IN_fechaHoraApli = ?tfecha " + ;
					" where IN_idevol = ?midevolhce and IN_fechaBaja = '2100-01-01' ")
			endscan
		endif

	case lactualizo = 2 &&&inserto
		mret = sqlexec(mcon1, "insert into TabIntNut " + ;
			"(IN_codmed ,IN_codprest ,IN_fechaHoraIni ,IN_fechaBaja ,IN_idevol ,IN_observa,IN_fechaHoraApli,IN_observanut )"+;
			" values (?mimed , ?mprest , ?mfechoy , '2100-01-01',  ?midevolhce, ?mobser,'1900-01-01',?mobsernut)")
		if mret < 0
			mret=aerr(eros)
			messagebox(eros(3),"Validacion")
		endif
	case lactualizo = 3  &&& desde nutri29
&&& actualizo desde nutricion
		mret = sqlexec(mcon1, "SELECT tabinthce.id FROM TabIntNut,tabinthce " + ;
			" where ih_admision  = ?tadmision and IN_fechaBaja = '2100-01-01' "+;
			" and tabinthce.id = IN_idevol "+;
			" group by ih_secuencia ", "mwkVernut")
		if mret < 0
			=aerr(eros)
			messagebox(eros(3), 48, "Validacion")
		endif
		if reccount('mwkVernut')>0
			select mwkVernut
			scan
				midevolhce  = mwkVernut.id
				mret = sqlexec(mcon1, "update TabIntNut set IN_fechaHoraApli = ?tfecha " + ;
					" where IN_idevol = ?midevolhce and IN_fechaBaja = '2100-01-01' and IN_fechaHoraIni<?mcfechora ")
			endscan
		endif

endcase
use in select('mwkVernut')
