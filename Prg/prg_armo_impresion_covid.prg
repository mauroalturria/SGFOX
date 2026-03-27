* Impresión de Ficha Epidemiológica COVID-19
Parameters tipoimpresion,nroregistro,ordenimpre,firma,medico,matricula

&&Do sp_conexion

&&nroregistro = 960346 && prueba
&&nroregistro = 3143240 && prueba
&&nroregistro = 2992417 && real
&&tipoimpresion = 2

Local lntipoimpresion,cfile,lnordenimpre,ldFechaImp

lntipoimpresion = 0
cfile = 'c:\tempdoc\covid'+Sys(2015)
cfile1 = cfile + '.pdf'
cfile2 = cfile +'_1.pdf'

If !Vartype(nroregistro)='N'
	Return .F.
Endif

If nroregistro = 0
	Return .F.
Endif

lntipoimpresion = tipoimpresion
mnroregistro = nroregistro
lnordenimpre = ordenimpre

If !Vartype(ordenimpre)='N'
	lnordenimpre = 1
Endif

Do SP_BUSCO_PLANILLA_EPIDE_COV19 With  "", mnroregistro

If !Used('mwkEpidemioCov19')
	Return .F.
Endif

If Reccount('mwkEpidemioCov19')=0
	Return .F.
Endif


Create Cursor mwkReporte (titulo c(180), Descrip c(120), valor l,firma l)

Select * From mwkEpidemioCov19  Into Cursor mwkECov Readwrite
Use In Select("mwkEpidemioCov19")

* Datos del Paciente
Public mPaciente, mDomicilio, mCiudad, mProvincia, mPais, mFechaNac, mSexo, mEdad, mDNI, mOcupacion, mDomilabo,;
	mTellabo,mTelefono,mMedico,mFecImpresion,mfirma,mfirmadoc,mmatricula,mdoc
lcSQL = "select * from registracio where REG_nroregistrac = ?mnroregistro"
If !Prg_EjecutoSql(lcSQL,'mwkDatosPac')
	Return .F.
Endif
Select mwkDatosPac
ldFechaImp = sp_busco_fecha_serv('DD')
mFecImpresion = Dtoc(ldFechaImp)
mPaciente = Alltrim(mwkDatosPac.reg_nombrepac)
mFechaNac = Dtoc(mwkDatosPac.reg_fecnacimiento)
mDomicilio = Alltrim(mwkDatosPac.reg_domicilio)
mCiudad = Alltrim(mwkDatosPac.reg_localidad)
mProvincia = Alltrim(mwkDatosPac.reg_provincia)
mSexo = Iif(mwkDatosPac.reg_sexo='M','Masculino',Iif(mwkDatosPac.reg_sexo='F','Femenino',''))
mEdad = prg_edad(Ctod(mFechaNac))
mDNI = mwkDatosPac.reg_numdocumento
mTelefono = mwkDatosPac.reg_telefonos
mfirma = File(firma)
mdoc = Alltrim(medico)
mmatricula = 'Matrícula ' + Alltrim(matricula)
mfirmadoc = firma

Select mwkECov
mMedico = Alltrim(medico)
mPais = Alltrim(Nvl(mwkECov.cov_pais,''))
mOcupacion = Nvl(Alltrim(mwkECov.cov_ocupacion),'')
mDomilabo = Nvl(Alltrim(mwkECov.cov_domicilio),'')
mTellabo = Nvl(Alltrim(mwkECov.cov_telefono),'')

* Información Clínica
Insert Into mwkReporte (titulo,Descrip,valor) Values ("INFORMACION CLINICA","",.T.)
Insert Into mwkReporte (titulo,Descrip) Values ('Hisopado de Vigilancia ' , Iif(mwkECov.COV_HisopaVigilan=1,'(X)','( )'))
Insert Into mwkReporte (titulo,Descrip) Values ('Estado del paciente: ' , Iif(Nvl(mwkECov.COV_Sintoasinto,0)=1,'SINTOMATICO',Iif(Nvl(mwkECov.COV_Sintoasinto,0)=2,'ASINTOMATICO','')))
Insert Into mwkReporte (titulo,Descrip) Values ("Fecha de Inicio de 1º síntoma (FIS): " , Iif(mwkECov.cov_inisintoma=Ctod('01/01/1900'),'',Dtoc(mwkECov.cov_inisintoma)))
Insert Into mwkReporte (titulo,Descrip) Values ('Síndrome Inflamatorio Multisistémico ' , Iif(Nvl(mwkECov.cov_Sinfmultisis,0)=1,'(X)','( )'))
Insert Into mwkReporte (titulo,Descrip) Values ("Semana epidemiológica de FIS: " , Alltrim(Str(mwkECov.cov_semanaepi)))
Insert Into mwkReporte (titulo,Descrip) Values ("Fecha de 1º Consulta: " , Iif(mwkECov.cov_primconsulta=Ctod('01/01/1900'),'',Dtoc(mwkECov.cov_primconsulta)))
Insert Into mwkReporte (titulo,Descrip) Values ("Establecimiento de 1º Consulta: " , Alltrim(Upper(mwkECov.cov_estabprimconsul)))
Insert Into mwkReporte (titulo,Descrip) Values ("Ambulatorio: " , Iif(mwkECov.cov_ambulat1 = 1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("Internado: " , Iif(mwkECov.cov_internado = 1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("Fecha de Internación: " , Iif(mwkECov.cov_fechInterna=Ctod('01/01/1900'),'',Dtoc(mwkECov.cov_fechInterna)))
Insert Into mwkReporte (titulo,Descrip) Values ("Establecimiento de Internación: " , Alltrim(Upper(mwkECov.cov_estabinternac)))
Insert Into mwkReporte (titulo,Descrip) Values ("Terapia Intensiva: " , Iif(mwkECov.cov_internaUTI=1,"Si",Iif(mwkECov.cov_internaUTI=2,"No","")))
Insert Into mwkReporte (titulo,Descrip) Values ("Fecha de Internación UTI: " , Iif(mwkECov.cov_fechInternaUTI=Ctod('01/01/1900'),'',Dtoc(mwkECov.cov_fechInternaUTI)))
Insert Into mwkReporte (titulo,Descrip) Values ("Requerimiento de ARM: " , Iif(mwkECov.cov_requierearm=1,"(X)","( )"))
For nvar = 1 To 3
	Insert Into mwkReporte (titulo,Descrip) Values ("","")
Endfor

* Signos y Sintomas
Insert Into mwkReporte (titulo,Descrip) Values ("SIGNOS Y SINTOMAS","")
Insert Into mwkReporte (titulo,Descrip) Values ("Fiebre (>=38ºC):" , Iif(mwkECov.COV_fiebremasmenos38=1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("Tos:" , Iif(mwkECov.COV_tos=1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("Dolor de Garganta:" , Iif(mwkECov.COV_dolorgaganta=1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("Odinofagia:" , Iif(mwkECov.COV_odinofagia=1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("Taquipnea/Disnea:" , Iif(mwkECov.COV_taquipnea=1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("Tiraje:" , Iif(mwkECov.COV_tiraje=1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("Insuficiencia ,Respiratoria:" , Iif(mwkECov.COV_insufrespirat=1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("Dolor Torácico:" , Iif(mwkECov.COV_dolortoracico=1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("Diarrea:" , Iif(mwkECov.COV_diarrea=1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("Vómitos:" , Iif(mwkECov.COV_vomitos=1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("Dolor Abdominal:" , Iif(mwkECov.COV_dolorabdominal=1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("Rechazo del ,Alimento:" , Iif(mwkECov.COV_rechaaliemnt=1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("Artralgias:" , Iif(mwkECov.COV_artalgias=1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("Mialgias:" , Iif(mwkECov.COV_mialgias=1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("Cefalea:" , Iif(mwkECov.COV_cefalea=1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("Irritabilidad / ,Confusión:" , Iif(mwkECov.COV_irritabconfu=1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("Malestar General:" , Iif(mwkECov.COV_malestargral=1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("Evidencia ,Radiologica de Neumonía:" , Iif(mwkECov.COV_rxneumonia=1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("Inyección ,Conjuntival:" , Iif(mwkECov.COV_inyecconjuntival=1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("Convulsiones:" , Iif(mwkECov.COV_convulsiones=1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("Coma:" , Iif(mwkECov.COV_coma=1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("Anosmia: " , Iif(Nvl(mwkECov.COV_Anosmia,0)=1,'(X)','( )'))
Insert Into mwkReporte (titulo,Descrip) Values ("Rinitis: " , Iif(Nvl(mwkECov.COV_Rinitis,0)=1,'(X)','( )'))
Insert Into mwkReporte (titulo,Descrip) Values ("Disgeusia: " , Iif(Nvl(mwkECov.COV_Disgeusia,0)=1,'(X)','( )'))

Insert Into mwkReporte (titulo,Descrip) Values ("Otros:" , Iif(!Empty(mwkECov.COV_otrossint),Alltrim(mwkECov.COV_otrossint),""))
For nvar = 1 To 3
	Insert Into mwkReporte (titulo,Descrip) Values ("","")
Endfor

* Enfermedades Previas
Insert Into mwkReporte (titulo,Descrip) Values ("ENFERMEDADES PREVIAS / COMORBILIDADES","")
*insert into mwkReporte (titulo,descrip) values ("Presenta enfermedades previas:",Iif(mwkECov.COV_enfermprev=1,"Si",Iif(mwkECov.COV_enfermprev=2,"No",""))
Insert Into mwkReporte (titulo,Descrip) Values ("Inmunosupresión Congénita o Adquirida:",Iif(mwkECov.COV_inmunSupres=1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("Diabetes:",Iif(mwkECov.COV_diabetes=1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("Obesidad:",Iif(mwkECov.COV_obesidad=1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("Embarazo:",Iif(mwkECov.COV_embarazo=1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("Puerperio:",Iif(mwkECov.COV_puerperio=1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("Prematuridad:",Iif(mwkECov.COV_prematuridad=1,"X (" + Alltrim(Str(mwkECov.COV_prematsemana)) + " Semanas )",""))
Insert Into mwkReporte (titulo,Descrip) Values ("Bajo Peso al Nacer:",Iif(mwkECov.COV_bajopesonac=1,"X (" + Alltrim(Str(mwkECov.COV_bajopesogr)) + " Grs. )",""))
Insert Into mwkReporte (titulo,Descrip) Values ("Enfermedad Neurológica:",Iif(mwkECov.COV_endfneurolog=1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("Enfermedad Hepática:",Iif(mwkECov.COV_enferpatica=1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("Enfermedad Renal Crónica:",Iif(mwkECov.COV_enfrenal=1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("Hipertensión Arterial:",Iif(mwkECov.COV_hiparterial=1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("Enfermedad Cardíaca:",Iif(mwkECov.COV_insufcardiaca=1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("Enfermedad Oncológica:",Iif(mwkECov.COV_enfoncologica=1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("Bronquiolitis Previa:",Iif(mwkECov.COV_bronquiolitis=1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("N.A.C. Previa:",Iif(mwkECov.COV_nac=1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("EPOC:",Iif(mwkECov.COV_epoc=1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("Asma:",Iif(mwkECov.COV_asma=1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("Tuberculosis:",Iif(mwkECov.COV_tuberculosis=1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("Ninguna de las anteriores:",Iif(mwkECov.COV_ningunaant=1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("Otros:",Alltrim(mwkECov.COV_otrosespec))
Insert Into mwkReporte (titulo,Descrip) Values ("","")
Insert Into mwkReporte (titulo,Descrip) Values ("TRATAMIENTOS","")
Insert Into mwkReporte (titulo,Descrip) Values ("Antibióticos:", Iif(mwkECov.COV_fecAntibiot=Ctod('01/01/1900'),'',"Fecha de Inicio: " + Dtoc(mwkECov.COV_fecAntibiot) + " Resultado: En Curso: " + Iif(mwkECov.COV_resulencurso=1,"(X)","( )") + " Terminado: " + Iif(mwkECov.COV_resulterminado=1,"(X)","( )")))
Insert Into mwkReporte (titulo,Descrip) Values ("Antiviral:", Iif(mwkECov.COV_fecAntiviral=Ctod('01/01/1900'),'',"Fecha de Inicio: " + Dtoc(mwkECov.COV_fecAntiviral) + " Resultado: En Curso: " + Iif(mwkECov.COV_antivencurso=1,"(X)","( )")+ " Terminado: " + Iif(mwkECov.COV_antivterminado=1,"(X)","( )")))
Insert Into mwkReporte (titulo,Descrip) Values ("","")
Insert Into mwkReporte (titulo,Descrip) Values ("ESTADO AL MOMENTO DEL REPORTE","")
Insert Into mwkReporte (titulo,Descrip) Values ("Recuperado:",Iif(mwkECov.COV_estadorepencurso=1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("No Recupeado:",Iif(mwkECov.COV_estadorepnorecup=1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("Fallecido:",Iif(mwkECov.COV_estadorepfallecido=1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("Fecha:","")
Insert Into mwkReporte (titulo,Descrip) Values ("","")
Insert Into mwkReporte (titulo,Descrip) Values ("DIAGNOSTICO","")
Insert Into mwkReporte (titulo,Descrip) Values ("Síndrome Gripal:",Iif(mwkECov.COV_diagsmegripal=1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("Bronquitis:",Iif(mwkECov.COV_diagbronquitis=1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("Neumonía:",Iif(mwkECov.COV_diagneumonia=1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("Otros:",Iif(!Empty(mwkECov.COV_DiagEspecif),"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("Especificar:",Alltrim(mwkECov.COV_DiagEspecif))
For nvar = 1 To 3
	Insert Into mwkReporte (titulo,Descrip) Values ("","")
Endfor

* Antecedentes Epidemiológicos

Insert Into mwkReporte (titulo,Descrip) Values ("ANTECEDENTES EPIDEMIOLÓGICOS","")
Insert Into mwkReporte (titulo,Descrip) Values ("","")
Insert Into mwkReporte (titulo,Descrip) Values ("OCUPACIONES","")
Insert Into mwkReporte (titulo,Descrip) Values ("Trabajador de Atención de la Salud:",Iif(mwkECov.COV_trabsalud=1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("Trabajador de Laboratorio:",Iif(mwkECov.COV_trablaborat=1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("Trabaja con Animales:",Iif(mwkECov.COV_trabanimales=1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("","")
Insert Into mwkReporte (titulo,Descrip) Values ("ANTECEDENTES DE VACUNACIÓN","")
Insert Into mwkReporte (titulo,Descrip) Values ("Antigripal:",Iif(mwkECov.COV_antvacunaAntigrip=1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("Fechas:", Iif(mwkECov.COV_fechavacuantigrip1=Ctod('01/01/1900'),'',Dtoc(mwkECov.COV_fechavacuantigrip1)) + " - " + Iif(mwkECov.COV_antvacunaAntigrip2=Ctod('01/01/1900'),'',Dtoc(mwkECov.COV_antvacunaAntigrip2)))
Insert Into mwkReporte (titulo,Descrip) Values ("","")
If Nvl(mwkECov.COV_Vacucovid,0)>0
	Insert Into mwkReporte (titulo,Descrip) Values ("VACUNACION COVID 19","")
	Do Case
	Case mwkECov.COV_Vacucovid=1
		Insert Into mwkReporte (titulo,Descrip) Values ("Esquema de Vacunación Completa con Refuerzo: ","(X)")
		Insert Into mwkReporte (titulo,Descrip) Values ('Fecha de Vacunación: ',Iif(Nvl(mwkECov.COV_Fecvacucovid,Ctod('01/01/1900'))=Ctod('01/01/1900'),"---",Dtoc(mwkECov.COV_Fecvacucovid)))
	Case mwkECov.COV_Vacucovid=2
		Insert Into mwkReporte (titulo,Descrip) Values ("Esquema de Vacunación Completa sin Refuerzo: ","(X)")
		Insert Into mwkReporte (titulo,Descrip) Values ('Fecha de Vacunación: ',Iif(Nvl(mwkECov.COV_Fecvacucovid,Ctod('01/01/1900'))=Ctod('01/01/1900'),"---",Dtoc(mwkECov.COV_Fecvacucovid)))
	Case mwkECov.COV_Vacucovid=3
		Insert Into mwkReporte (titulo,Descrip) Values ("Esquema de Vacunación Incompleta: ","(X)")
		Insert Into mwkReporte (titulo,Descrip) Values ('Fecha de Vacunación: ',Iif(Nvl(mwkECov.COV_Fecvacucovid,Ctod('01/01/1900'))=Ctod('01/01/1900'),"---",Dtoc(mwkECov.COV_Fecvacucovid)))
	Otherwise
		Insert Into mwkReporte (titulo,Descrip) Values ("Sin Vacunar","(X)")
	Endcase
Endif
Insert Into mwkReporte (titulo,Descrip) Values ("VIAJES Y OTRAS EXPOSICIONES DE RIESGO","")
Insert Into mwkReporte (titulo,Descrip) Values ("¿Ha Viajado o residido en una zona de riesgo conocida fuera del país en los últimos 14 días previos al inicio de los síntomas ?",Iif(mwkECov.COV_viajoresidio=1,"Si",Iif(mwkECov.COV_viajoresidio=2,"No","")))
Insert Into mwkReporte (titulo,Descrip) Values ("¿ País / Ciudad ?",Alltrim(mwkECov.COV_ViajoDonde))
Insert Into mwkReporte (titulo,Descrip) Values ("Fechas:","Desde el " + Iif(mwkECov.COV_viajoDesde=Ctod('01/01/1900'),'',Dtoc(mwkECov.COV_viajoDesde)) + " Hasta el " + Iif(mwkECov.COV_viajoHasta=Ctod('01/01/1900'),'',Dtoc(mwkECov.COV_viajoHasta)))
Insert Into mwkReporte (titulo,Descrip) Values ("Viajó en ","Avión " + Iif(mwkECov.COV_viajoavion=1,"(X)","( )") + " - Barco " + Iif(mwkECov.COV_viajobarco=1,"(X)","( )") + " - Omnibus " + Iif(mwkECov.COV_viajoomnibus=1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("Fecha de Ingreso al País:", Iif(mwkECov.COV_fechaingresopais=Ctod('01/01/1900'),'',Dtoc(mwkECov.COV_fechaingresopais)))
Insert Into mwkReporte (titulo,Descrip) Values ("Compañía de Transporte:",Alltrim(mwkECov.COV_companiaviaje))

Insert Into mwkReporte (titulo,Descrip) Values ("","")
Insert Into mwkReporte (titulo,Descrip) Values ("Ha viajado o residido en zona dentro del País (Distinto del Domicilio) en los últimos 14 días previos al inicio de los síntomas ?",Iif(mwkECov.COV_viajodentropais=1,"Si",Iif(mwkECov.COV_viajodentropais=2,"No","")))
Insert Into mwkReporte (titulo,Descrip) Values ("¿Dónde (Domicilio) ?",Alltrim(mwkECov.COV_dentropaisdonde))
Insert Into mwkReporte (titulo,Descrip) Values ("Fecha:",Iif(mwkECov.COV_viajoresidioDesde=Ctod('01/01/1900'),'',"Desde el " + Dtoc(mwkECov.COV_viajoresidioDesde)) + Iif(mwkECov.COV_dentropaishasta=Ctod('01/01/1900'),""," - Hasta el " +Dtoc(mwkECov.COV_dentropaishasta)))
Insert Into mwkReporte (titulo,Descrip) Values ("País / Ciudad:",Alltrim(mwkECov.COV_ciudadcentronCOV19))

Insert Into mwkReporte (titulo,Descrip) Values ("","")
Insert Into mwkReporte (titulo,Descrip) Values ("¿ Ha concurrido a un centro de Salud que ha asistido casos confirmados COVID-19 dentro de los 14 días previos al inicio de los síntomas ?",Iif(mwkECov.COV_concasosconf=1,"Si",Iif(mwkECov.COV_concasosconf=2,"No","")))
Insert Into mwkReporte (titulo,Descrip) Values ("Nombre del Centro:",Alltrim(mwkECov.COV_nomcentronCOV19))
Insert Into mwkReporte (titulo,Descrip) Values ("Ciudad:",Alltrim(mwkECov.COV_nomcentronCOV19))
Insert Into mwkReporte (titulo,Descrip) Values ("Fecha:",Iif(mwkECov.COV_centroFechanCOV19=Ctod('01/01/1900'),'',Dtoc(mwkECov.COV_centroFechanCOV19)))
Insert Into mwkReporte (titulo,Descrip) Values ("¿ Estuvo en contacto con Animales dentro de los 14 días previos al inicio de síntomas ?","Cerdos " + Iif(mwkECov.COV_Cerdos=1,"(X)","( )") + " - Aves " + Iif(mwkECov.COV_ContactoConAves=1,"(X)","( )") + " - Camelidos " + Iif(mwkECov.COV_Camelidos=1,"(X)","( )") + " - Mercado de animales vivos " + Iif(mwkECov.COV_ContactoMercados=1,"(X)","( )"))
*insert into mwkReporte (titulo,descrip) values ("Otros (Especificar):", - FALTA -

Insert Into mwkReporte (titulo,Descrip) Values ("","")
Insert Into mwkReporte (titulo,Descrip) Values ("¿Tuvo contacto cercano con personas con infección respiratoria aguda dentro de los 14 días previos al inicio de síntomas ?",Iif(mwkECov.COV_ContactoCerc14Prev=1,"Si",Iif(mwkECov.COV_ContactoCerc14Prev=2,"No","")))
Insert Into mwkReporte (titulo,Descrip) Values ("En entornos:","Familiar " + Iif(mwkECov.COV_EnntorFliar14Prev=1,"(X)","( )") + " - Asistencial " + Iif(mwkECov.COV_EntorAsistencial14Prev=1,"(X)","( )") + " - Laboral " + Iif(mwkECov.COV_EntorLaboral14Prev=1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("Otros (Especificar):",Nvl(mwkECov.COV_ContacOtros14Prev,""))

Insert Into mwkReporte (titulo,Descrip) Values ("","")
Insert Into mwkReporte (titulo,Descrip) Values ("Tuvo contacto estrecho con casos probables o confirmados dentro de los 14 días previos al inicio de síntomas ?",Iif(mwkECov.COV_ContacPersoOtros=1,"Si",Iif(mwkECov.COV_ContacPersoOtros=1,"No","")))
Insert Into mwkReporte (titulo,Descrip) Values ("Apellido / Nombre:",Alltrim(mwkECov.COV_ContEstrechoNomApe))
Insert Into mwkReporte (titulo,Descrip) Values ("DNI o DE:",Alltrim(mwkECov.COV_ContEstrechoDNI))
Insert Into mwkReporte (titulo,Descrip) Values ("País / Área en la que tuvo la exposición:",Alltrim(mwkECov.COV_ContEstrechoArea))
For nvar = 1 To 3
	Insert Into mwkReporte (titulo,Descrip) Values ("","")
Endfor

* Laboratorio
Insert Into mwkReporte (titulo,Descrip) Values ("LABORATORIO","")
Insert Into mwkReporte (titulo,Descrip) Values ("","")
Insert Into mwkReporte (titulo,Descrip) Values ("Aspirado:",Iif(mwkECov.COV_MuesAspirado=1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("Hisopado:",Iif(mwkECov.COV_MuesHisopado=1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("Lavado Broncoalveolar:",Iif(mwkECov.COV_MuesBronalv=1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("Estupo:",Iif(mwkECov.COV_MuesEstupo=1,"(X)","( )"))
Insert Into mwkReporte (titulo,Descrip) Values ("Otros (Especificar):",Nvl(mwkECov.COV_MuestraOtro,""))
Insert Into mwkReporte (titulo,Descrip) Values ("Fecha de Toma de Muestra:",Iif(mwkECov.COV_MuestraFecha=Ctod('01/01/1900'),'',Dtoc(mwkECov.COV_MuestraFecha)))
Insert Into mwkReporte (titulo,Descrip) Values ("Fecha de Derivación al LNR:",Iif(mwkECov.COV_MuestraFechaLNR=Ctod('01/01/1900'),'',Dtoc(mwkECov.COV_MuestraFechaLNR)))
*Insert Into mwkReporte (titulo,Descrip,valor) Values ("","",.T.)
Insert Into mwkReporte (titulo,Descrip,valor,firma) Values ("","",.T.,.T.)
Select mwkReporte

Public mlogo
mlogo = '' && Preparar una imagen en blanco por si no encuentra la original.
If File("C:\qepd1a1\xlt\sg1.bmp")
	mlogo = "C:\qepd1a1\xlt\sg1.bmp"
Endif

Do Case
Case lntipoimpresion = 1 && HCEpdf - Pisos23
*	Set Reportbehavior 90
	Select mwkReporte
	Report Form repfichacovid Object Type 10 To File &cfile1
	Insert Into mwkImpreOK (impresion,archivo,hojas,orden) Values ('Ficha Epidemiológica COVID-19',cfile1,1,lnordenimpre)
	Select mwkEpidemioCov19cont
	If Reccount('mwkEpidemioCov19cont')>0
		Report Form repfichacovid_con Object Type 10 To File &cfile2
		Insert Into mwkImpreOK (impresion,archivo,hojas,orden) Values ('Ficha Epidemiológica COVID-19',cfile1,1,lnordenimpre)
	Endif
*	Set Reportbehavior 80
Case lntipoimpresion = 2 && Reporte Impreso en Papel
*	Set Reportbehavior 90
	Select mwkReporte
	Report Form repfichacovid Preview
	Select mwkEpidemioCov19cont
	If Reccount('mwkEpidemioCov19cont')>0
		Report Form repfichacovid_con Preview
	Endif
Case lntipoimpresion = 3 && Reporte Impreso en PDF
	Do prg_copio_archivos
	Do foxypreviewer.App
	If !Directory('C:\tempdoc')
		Md c:\tempdoc
	Endif
	cfile1 = 'C:\tempdoc\FICHA_COVID_'+Strtran(mPaciente,' ','_')+'.pdf'
	cfile2 = 'C:\tempdoc\FICHA_COVID_'+Strtran(mPaciente,' ','_')+'_1.pdf'
	Select mwkReporte
	Report Form repfichacovid Object Type 10 To File (cfile1)
	Select mwkEpidemioCov19cont
	If Reccount('mwkEpidemioCov19cont')>0
		Report Form repfichacovid_con Object Type 10 To File (cfile2)
	Endif
	Do foxypreviewer.App With 'Release'
Case lntipoimpresion = 4 && Armo String para Mail

Endcase

If File(cfile1) Or File(cfile2)
	Return .T.
Else
	Return .F.
Endif

Release mPaciente, mDomicilio, mCiudad, mProvincia, mPais, mFechaNac, mSexo, mEdad, mDNI, mOcupacion, mDomilabo,;
	mTellabo,mTelefono,mMedico,mFecImpresion

Use In Select('mwkECov')
Use In Select('mwkEpidemioCov19cont')
Use In Select('mwkReporte')
Use In Select('mwkDatosPac')



