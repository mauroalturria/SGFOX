*
* Correccion de horarios Medicos Ambulatorio
*

do sp_conexion

for mdias = 1 to 12
	use in select("mwkambarre")
	use in select("mwkambarre2")
	use in select("mwkambarre3")
	use in select("mwkmedicoamb")
	mfecha = ctod("05/10/2011") +mdias

	do sp_medicos_amb with mfecha

	if used('mwkmedicoamb')
		if reccount('mwkmedicoamb') > 0

			select mwkmedicoamb
			scan all

*			mlmedico = 3179

				mlmedico = mwkmedicoamb.id

				do sp_busco_pacientes_ambu_arreg with mfecha,;
					mlmedico, " and codmed = "+transf(mlmedico), '', 'mwkambarre'

				if used("mwkambarre")

					select max(fechahoraate) as egreso,* from mwkambarre;
						where fechahoraate > ctot("  /  /    ") and fechahoraate > ctot("01/01/1900") and !empty(sala);
						group by codmed, sala;
						into cursor mwkambarre2

					if reccount("mwkambarre2") > 0

						mihora  = ctot( dtoc(mfecha) + " 00:00:00" )
						mcodmed = mlmedico

						do sp_busco_medprestam with mfecha, " and medpresta.codmed = ?mcodmed and medpresta.diasem = "+;
							str(dow(mihora)), ,"S"

						select distinct left(sala,20) as sala, idfranja, hhmmdes, hhmmhas,codmed;
							from mwkMPfecha ;
							group by codmed, sala, idfranja ;
							order by hhmmdes,hhmmhas ;
							into cursor mwkconsultorios

						select mwkambarre2.*, mwkconsultorios.idfranja, mwkconsultorios.hhmmhas ,mwkconsultorios.hhmmdes from mwkambarre2 ;
							join mwkconsultorios on mwkconsultorios.sala = mwkambarre2.sala ;
							and mwkconsultorios.codmed = mwkambarre2.codmed ;
							into cursor mwkambarre3

						if reccount("mwkambarre3") > 0

							select mwkambarre3
							scan all

								mlmed    = mwkambarre3.codmed
								mlfra    = mwkambarre3.idfranja
								mcons    = mwkambarre3.sala
								mhoraini = mwkambarre3.hhmmhas
								mcini = transf(mhoraini,"99:99")
								mhat     = val(strtran(left(right(ttoc(mwkambarre3.egreso ),8),5) ,":",""))
*							set step on
								mht1     = left(right(ttoc(mwkambarre3.egreso ),8),5) && Hora de primera atención menos 15 minutos
								mhoracar = val(strtran(mht1,":",""))
								mht1 = iif(mhoracar> mhoraini and mhat>mhoraini ,mht1 ,mcini)
								mhor1    = left(mht1,2) + right(mht1,2)
								mhoratur = int(val(mhor1))

								use in select("mwkiemed")

								mret = sqlexec(mcon1,"select * from TabAmbIEMed"+;
									" where tai_codmed = ?mlmed and tai_idfranja = ?mlfra and tai_fecha = ?mfecha", "mwkiemed")
								if reccount("mwkiemed") = 0
									mret = sqlexec(mcon1,"select * from TabAmbIEMed"+;
										" where tai_codmed = ?mlmed and tai_fecha = ?mfecha"+;
										" and TAI_consultorio = ?mcons ", "mwkiemed")
								endif
								if reccount("mwkiemed") > 0
									select mwkiemed
									scan all
										mllid = mwkiemed.id
										if mwkiemed.tai_hhmmegr < mhoratur or mwkiemed.tai_hhmmegr = 9999&& mingr
											mret  = sqlexec(mcon1,"update TabAmbIEMed "+;
												" set tai_hhmmegr = ?mhoratur "+;
												" where id = ?mllid")
										endif
									endscan
								else
									set step on
									mret = sqlexec(mcon1, "insert into TabAmbIEMed " +;
										"(TAI_codmed,TAI_consultorio,TAI_fecha,TAI_hhmming,TAI_hhmmegr,TAI_idfranja)" +;
										" values " +;
										"(?mlmed ,?mcons,?mfecha,?mhoratur,?mhoratur ,?mlfra )")

								endif
								select mwkambarre3

							endscan
						endif
					endif
				endif
				select mwkmedicoamb

			endscan
		endif
	endif

	use in select("mwkambarre")
	use in select("mwkambarre2")
	use in select("mwkambarre3")
	use in select("mwkmedicoamb")
next
do sp_desconexion

