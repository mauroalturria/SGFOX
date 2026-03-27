parameters mfechad,mfechah,mbusco,mcodmed

mfiltro = iif(mcodmed = 0,''," and EGM_codmed = ?mcodmed ") + mbusco
if used('mwksinexcel')
	use in mwksinexcel
endif
create cursor mwksinexcel (codmed n(9),nombre C(50),fecha1 t,fecha2 t,diferencia C(8),codpresta n(9),;
	detpresta C(45))
mfd  = prg_dtoc( mfechad )
mfh  = prg_dtoc( mfechah + 1)
mfd1 = prg_dtoc( mfechad - 1)
if used('mwkMedicoExterno')
	use in mwkMedicoExterno
endif
if used('mwkMedicoPrest')
	use in mwkMedicoPrest
endif
mret = SQLExec(mcon1,"SELECT ID as CodMedT , nombre FROM TabMedExterno where gerenciadora = 0 ", "mwkMedicoExterno" )
mret = SQLExec(mcon1,"select ID as CodMedT , nombre from prestadores ", "mwkMedicoPrest" )
if used('mwkMedicTodos')
	use in mwkMedicTodos
endif
select CodMedT,nombre from mwkMedicoExterno;
	union all ;
	select CodMedT,nombre from mwkMedicoPrest;
	into cursor mwkMedicTodos
if used('mwkguardia')
	use in mwkguardia
endif

mret = SQLExec(mcon1, "select protocolo,fechahoraing,codprest," + ;
	"fechahoraate,codestado,guardia.id,prioridad," + ;
	"codent,nroregistrac,codmed,EGM_fechaH,EGM_codmed " + ;
	"from prestacions,guardia,TabGuaEvolMed " + ;
	"where codprest = PRE_codprest and " + ;
	"( fechahoraing > ?mfd1 and fechahoraing < ?mfh and pre_codservicio = 8000 ) " + ;
	"and protocolo = EGM_proto" + mfiltro , "mwkguardia")
if mret > 0
	if used('mwkProduccMedic')
		use in mwkProduccMedic
	endif

	select * from  mwkguardia left join mwkMedicTodos on mwkMedicTodos.CodMedT = EGM_codmed ;
		where EGM_fechaH >= dtot(mfechad) and EGM_fechaH < dtot(mfechah+1) and EGM_codmed <> 1 ;
		order by EGM_codmed,EGM_fechaH ;
		into cursor mwkProduccMedic
	if reccount('mwkProduccMedic') > 0
		if used('mwkProduccMedic0')
			use in mwkProduccMedic0
		endif
		select distinct(EGM_codmed) as bcodmed from mwkProduccMedic into cursor mwkProduccMedic0
		select mwkProduccMedic0
		go top
		do while !eof()
			mbusca = mwkProduccMedic0.bcodmed
			if used('mwksinate')
				use in mwksinate
			endif
			select * from mwkProduccMedic where EGM_codmed = mbusca order by EGM_fechaH into cursor mwksinate
			if reccount('mwksinate')>1
				select mwksinate
				go top
				mnombre = mwksinate.nombre
				mfectrl = mwksinate.EGM_fechaH
				mcodpre = mwksinate.codprest
				skip
				do while !eof()
					if day(mwksinate.EGM_fechaH) = day(mfectrl)
						mhct = mwksinate.EGM_fechaH
						mdif = mhct - mfectrl
						if mdif >= 3600
							mretorno = ''
							do prg_dif_horaria with mfectrl,mhct,'H'
							mdiferen = mretorno
							if used('mwkdetpre')
								use in mwkdetpre
							endif
							mret = SQLExec(mcon1,"select PRE_descriprest from prestacions "+;
								"where PRE_codprest = ?mcodpre","mwkdetpre")
							if mret > 0
								select mwkdetpre
								go top
								mprestacion = mwkdetpre.PRE_descriprest
								insert into mwksinexcel (codmed,nombre,fecha1,fecha2,diferencia,codpresta,detpresta) ;
									values (mbusca,mnombre,mfectrl,mhct,mdiferen,mcodpre,mprestacion)
							else
								messagebox("EN BUSQUEDA DE PRESTACION",16,"ERROR")
							endif
						endif
					endif
					select mwksinate
					mfectrl = mwksinate.EGM_fechaH
					mcodpre = mwksinate.codprest
					skip
				enddo
			endif
			select mwkProduccMedic0
			skip
		enddo
	endif
else
	messagebox("EN CONSULTA DE PRODUCCION DE MEDICOS"+chr(10)+"AVISE A SISTEMAS",16,"ERROR")
endif
