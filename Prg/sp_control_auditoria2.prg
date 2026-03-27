****
** inserto datos de alta transitoria
****
Parameter mnumdoc,mnombre,mreg,pasa

Do sp_busco_entidad_afiliado1 with mreg
mnom = alltrim(mnombre)
mbusco1 = " where REG_nombrepac = '"+ alltrim(mnom)+"' and  "
Do sp_busco_nombre_paciente_1 with mbusco1,1
Select distinct reg_nrohclinica from mwkbuspacie into cursor mwkbuspa
Select mwkbuspacie
If reccount("mwkbuspa")>1
	pasa = 3
Endif
If mnumdoc=0
	pasa = pasa +20
Else
	mbusco1 = " where REG_numdocumento = "+ str(mnumdoc)+ " and "
	Do sp_busco_nombre_paciente_1 with mbusco1,1
	Select distinct reg_nrohclinica from mwkbuspacie into cursor mwkbuspa
	If val(mwkbuspacie.reg_tipodocumento) = 0
		pasa = pasa +30
	Else
		If reccount("mwkbuspa")>1
			pasa = pasa +10
		Endif
	Endif
Endif
If used ('vales')
	Use in vales
Endif
If pasa < 10
	msql1 = ''
	Do sp_busco_entidad_afiliado1 with mreg
	&msql1
	nafimal = .f.
	lcontrolnro  = .f.
	ltodok = .t.
	If used('mwkafient1')
		Select mwkafient1
		Scan
			If isnull(mwkafient1.ENT_fecpas)
				mcodent = mwkafient1.afi_codentidad
				mafiliado = mwkafient1.afi_nroafiliado
				Do case
				Case inlist( mcodent, 175, 75)
					mafiliado = chrtran(mafiliado ,"-/","")
					lcontrolnro=.t.
				Case inlist( mcodent, 149)
					mafiliado = chrtran(mafiliado ,"-/","")
					lcontrolnro=.t.
				Otherwise
					lcontrolnro=.f.
				Endcase

				If lcontrolnro
					ltodok = .t.
					Do sp_valido_afiliado with mafiliado, mcodent, ltodok,1
				Endif
				If !ltodok
					nafimal = .t.
				Endif
				mnroafi  = mwkafient1.afi_nroafiliado
				mbusco1  = "afi_nroafiliado = ?mnroafi and afi_codentidad = ?mcodent and "

				Do sp_busco_por_tipynro with mbusco1
				Select * from mwkbuscopa where REG_nroregistrac # mreg into cursor mwkotroafi
				If reccount("mwkotroafi")>0
					pasa = pasa +300
				Else
					Select * from entidades where ent_codent = mcodent into cursor enti1
					If nvl(enti1.Ent_codagrup,0)>0 and nvl(enti1.Ent_codagrup,0) # enti1.ent_codent 
						micodi  = enti1.Ent_codagrup
						Select * from entidades where ent_codent # mcodent and Ent_codagrup = micodi  into cursor enti2
						Select enti2
						mbusco1  = "afi_nroafiliado = ?mnroafi and afi_codentidad in ( "
						Scan
							mbusco1 = mbusco1 + str(ent_codent,5,0)+ ", "
						Endscan
						mbusco1 = substr(mbusco1 ,1,len(mbusco1 )-2) + " ) and "
						Do sp_busco_por_tipynro with mbusco1

						Select * from mwkbuscopa where REG_nroregistrac # mreg into cursor mwkotroafi
						If reccount("mwkotroafi")>0
							pasa = pasa +200
						Endif
					Endif
				Endif

			Endif
		Endscan
		If nafimal
			pasa = pasa + 2000
		Endif
		If pasa<10
			Create cursor vales ;
				(paciente  c(50),cuenta c(10))

			lseomite = .f.
			msql_reg	= ''
			msql_pac = ''
			msql_cons = ''

			mnroreg 	= mreg
			mbusco1 	= "pac_codhci = ?mnroreg and "
			mfecdes 	= ctod('01/01/1900')
			mfechas 	= sp_busco_fecha_serv('DD')
			mtfhoy = mfechas
			Do sp_busco_pac_alta_his with mbusco1, , ,msql_pac
			Select * from mwkpacalta1 into cursor mwkpacalta

			Do sp_busco_consumos_paciente with mnroreg, msql_cons ,1

			&msql_cons
			Select mwkpacalta
			Go top
			msql_reg	= ''
			msql_con	= ''
			msql_ent	= ''
			Scan
				mpac 			= chrtran(pac_nombrepaciente,",.","  ")
				mcodadmision	= pac_codadmision
				Insert into vales (paciente  ,cuenta ) values (mpac ,mcodadmision)
			Endscan
			Select mwkpacalta
			Go top

			Select * from mwkconsu group by val_codadmision into cursor mwkconsu
			Select mwkconsu
			mhasta = reccount('mwkconsu')
			Go top
			If reccount('mwkpacalta') > 0
				mpac 			= mwkpacalta.pac_nombrepaciente
			Else
				mpac 			= mnombre
			Endif
			Scan
				mtipopac = iif(mwkconsu.val_tipopaciente='AMB',mwkconsu.val_tipopaciente,mwkconsu.pac_sectorinternac)
				If  mtipopac = "GUA" or mtipopac = "AMB"
					mcodadmision = mwkconsu.val_codadmision
					a = 1
					midigito = right(alltrim(mcodadmision),1)
					If isalpha(midigito)
						mret = sqlexec(mcon1, "select pac_nombrepaciente from pacientes " + ;
							"where   pac_codadmision = ?mcodadmision " ,"mwkpacconsu")
						mpac = chrtran(pac_nombrepaciente,",.","  ")
						Insert into vales (paciente ,cuenta) values (mpac,mcodadmision )
					Endif
				Endif
				Select mwkconsu
			Endscan

			Select distinct paciente  from vales into cursor valespac

			If reccount("valespac")>1
				pasa = pasa +1000
			Endif
		Endif
	Endif
Endif
