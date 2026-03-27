*!*
*!*	 Generacion de planilla de Turnos
*!*

parameters mfecturno

if !used('mwkdatos')
	do sp_busco_datos
endif
mfechafiltro = ctod(trans(mwkdatos.valorfloat2,"99/99/9999"))
mfiltraesp = ''

mret = sqlexec(mcon1, "select Reg_nombrepac, Reg_nrohclinica, Reg_numdocumento," + ;
	" REG_telefonos, REG_nroregistrac ,hca_registrac,hca_fechaInic " + ;
	" from turnos , registracio " + ;
	" left outer join TabHCArchivo on registracio.REG_nroregistrac = TabHCArchivo.hca_registrac " + ;
	" where " + ;
	" CODprest not in (42010181,78010600,78010601,67010201,22020300) and (not (CODprest like '28010%') or CODprest = 28010602 ) and " + ;
	" not (CODprest like '20012%') and " + ;
	' codserv<>1130 and ' + ;
	" codesp not in("+mfiltraesp +" 'CLIN','DERI','DERM','CARD','CARI','PEDI', 'CIRG', 'TRAU','KINE', 'NFII', 'NEUF', 'HOLT', 'ECGR', 'ECIN', 'ECOC', 'ECOO', 'ECOG', 'ECOI', 'ERGO', 'LABO', 'RADI',"+;
	" 'RESO', 'TOMO') and " + ;
	" turnos.afiliado = registracio.REG_nroregistrac and " + ;
	" fechatur = ?mfecturno and confirmado = 1 "+;
	" group by afiliado order by REG_nombrepac ", "mwkphorario1")

if mret < 0
	=aerr(eros)
	do prg_error with eros,'sp_busco_phorarios'
	cancel
endif
