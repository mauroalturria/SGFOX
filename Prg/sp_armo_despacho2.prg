* CALCULO PARA LA GRILLA

Create Cursor mwkdespachofinal (fechahoraing d, paciente c(50), nroprotocolo c(10) , tipopac c(3), admision c(10), vale N(10), codprest n(10), entidad n(4), hc c(10), PAC_fechaadmision d)

Select mwkdespacho
Use In Select('mwkTemp0')
Scan All

	mAdmision = Alltrim(mwkdespacho.admision)
	mDesde = mwkdespacho.desde - 1
	mHasta = mwkdespacho.hasta + 1
	mTipo = Alltrim(mwkdespacho.tipo)
	mEntidad = mwkdespacho.entidad
	mHC = mwkdespacho.hc
	mpaciente = Alltrim(mwkdespacho.nombre)
	Do Case
	Case mTipo = 'AMB'
		SQLExec(mcon1,'select * from pacientes left join tabambulatorio on tabambulatorio.nroregistrac = pacientes.PAC_codhci ' +;
			'where (TabAmbulatorio.fechahoraing BETWEEN ?mDesde AND ?mHasta) and pacientes.PAC_codadmision = ?mAdmision','mwkTemp0')
	Case mTipo = 'GUA'
		Sqlexec(mcon1,'select * from pacientes left join guardia on pacientes.pac_codhci = guardia.nroregistrac ' +;
		'left join guardiavale on guardiavale.protocolo = guardia.protocolo '+;
		'where (guardia.fechahoraing BETWEEN ?mDesde AND ?mHasta) and pacientes.PAC_codadmision = ?mAdmision','mwkTemp0')
		
		*left join guardiavale
	Endcase

	If Used('mwkTemp0')
		Select mwkTemp0
		Scan All
			mfechaing = Ttod(mwkTemp0.fechahoraing)
			mprotocolo = mwkTemp0.protocolo
			mtipopac = mTipo
			mAdmision = mAdmision
			mVale = mwkTemp0.nrovale
			mCodPrest = mwkTemp0.codprest
			mfadmision = mwkTemp0.pac_fechaadmision
			Insert Into mwkdespachofinal Values (mfechaing,mpaciente,mprotocolo,mtipopac,mAdmision,mVale,mCodPrest,mEntidad,mHC,mfadmision)
			Select mwkTemp0
		Endscan
	Endif
	Select mwkdespacho
Endscan



