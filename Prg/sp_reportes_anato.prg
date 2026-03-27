Parameters mCFILEPDF

Public mRVale,mRDV,mRAdmision,mRHC,mRFechaVale,mRHabitacion,mRCama,mRPaciente,mREdad,mRSexo,mRProtocolo,mRRemite,mRFecha,;
	mROSocial,mRAfiliado,mRMaterial,mROrigen,mRMacro,mRMicro,mRdiag,mRFirma,mRMatricula,mRNombreFirma,mRTipoPac,mRTitulo,;
	mRProce,mRPatoProf,mLogo,mRInfo

*mLogo = "bmp\0.gif"
mRVale = mwkValeAnato.Tje_codvale
mMedico = mwkValeAnato.Tje_codmed
mMaterial = mwkValeAnato.Tje_material
mOrgano = mwkValeAnato.Tje_Organo
mVaxMicro = mwkValeAnato.TJE_VaxMicro


lcSQL = "Select * from VALESASIST where Val_Codvaleasist = ?mRVale"
If !prg_EjecutoSql(lcSQL,"mwkRVales",.F.)
	Return .F.
Endif
mRDV = mwkRVales.VAL_verficasolicit
mRAdmision = mwkRVales.Val_codadmision
mRFechaVale = mwkRVales.Val_fechasolicitud


lcSQL = "Select * from pacientes where pac_codadmision = ?mRAdmision"
If !prg_EjecutoSql(lcSQL,"mwkHabitacama",.F.)
	Return .F.
Endif
mRHabitacion = Nvl(mwkHabitacama.pac_habitacion,Nvl(mwkRVales.Val_habitacion,''))
mRCama = Nvl(mwkHabitacama.pac_cama,Nvl(mwkRVales.Val_cama,''))


midValesasist = mwkRVales.Valesasist
lcSQL = "Select TOP 1 PIA_codprest from PRESINSUVAS where PIA_VALESASIST = ?midValesasist order by PIA_secuen_carga asc"
If !prg_EjecutoSql(lcSQL,"mwkRPresinsuva",.F.)
	Return .F.
Endif

* Armmo Protocolo

mRProtocolo = mwkRVales.Val_NroProtocolo
mRProtocoloint = mwkValeAnato.TJE_protoint

If !Empty(mMaterial)
	mProto1 = "M"
	If mMaterial = 3
		mProto1 = "P"
	Endif
	mRProtocolo = Substr(Dtoc(mwkValeAnato.TJE_FecHorRec),9,2)+"-"+mProto1+"-"+Alltrim(Str(mRProtocoloint))
Endif



lcSQL = "Select * from PACIENTES where PAC_Codadmision = ?mRAdmision"
If !prg_EjecutoSql(lcSQL,"mwkRPacientes",.F.)
	Return .F.
Endif

mRPaciente = Alltrim(mwkRPacientes.pac_nombrepaciente)
mTipoPac = Alltrim(mwkRPacientes.pac_tipopaciente)

mROrigen = ""
Do Case
Case mTipoPac = "AMB"
	mROrigen = "AMBULATORIO"
Case mTipoPac = "GUA"
	mROrigen = "GUARDIA"
Case mTipoPac = "INT"
	mROrigen = "INTERNADO"
Otherwise
	mROrigen = "INTERNADO"
Endcase

mREdad = mwkRPacientes.pac_edad
mRSexo = Alltrim(mwkRPacientes.pac_sexo)
mRHC = mwkRPacientes.pac_codhce

lcSQL = "Select * from PRESTADORES where ID = ?mMedico"
If !prg_EjecutoSql(lcSQL,"mwkRPrestadores",.F.)
	Return .F.
Endif

*** Titulo Dr/Dra del Prestador (Remite)
mTit = "Dr. "
If Alltrim(mwkRPrestadores.sexo)="F"
	mTit = "Dra. "
Endif
mRRemite = mTit + Alltrim(mwkRPrestadores.nombre)

lcSQL = "Select top 1 * from COBERTURAS where COB_PACIENTES = ?mRAdmision"
If !prg_EjecutoSql(lcSQL,"mwkRCobertura",.F.)
	Return .F.
Endif

mRCobEntidad = mwkRCobertura.Cob_codentidad

lcSQL = "Select * from ENTIDADES where ENT_codent = ?mRCobEntidad"
If !prg_EjecutoSql(lcSQL,"mwkREntidad",.F.)
	Return .F.
Endif

mRFecha = mwkValeAnato.Tje_FHMicro
mROSocial = Alltrim(mwkREntidad.Ent_descrient)

mCodHCI = mwkRPacientes.Pac_codhci

lcSQL = "Select * from AFILIACION where AFI_codentidad = ?mRCobEntidad and REGISTRACIO = ?mCodHCI"
If !prg_EjecutoSql(lcSQL,"mwkRAfi",.F.)
	Return .F.
Endif

mRAfiliado = mwkRAfi.Afi_nroafiliado

lcSQL = "Select * from TabEstados where Propietario = 127 and Tipo = 0 and Estado = ?mMaterial"
If !prg_EjecutoSql(lcSQL,"mwkREstado",.F.)
	Return .F.
Endif

lcSQL = "Select * from TabJeOrganos where ID = ?mOrgano"
If !prg_EjecutoSql(lcSQL,"mwkROrgano",.F.)
	Return .F.
Endif

mRMaterial = Alltrim(mwkROrgano.Tjo_descrip) + " - " + Alltrim(mwkREstado.Descrip)

mRMacro = mwkValeAnato.Tje_macro
mRMicro = mwkValeAnato.Tje_micro
mRdiag = mwkValeAnato.Tje_diagFin

lcSQL = "Select * from TabUsuario where codigovax = ?mVaxMicro"
If !prg_EjecutoSql(lcSQL,"mwkRUsuario",.F.)
	Return .F.
Endif

mIdCodMed = mwkRUsuario.idCodMed

lcSQL = "Select * from PRESTADORES where ID = ?mIdCodMed"
If !prg_EjecutoSql(lcSQL,"mwkRPresta",.F.)
	Return .F.
Endif


*** Nombre del Médico Patólogo
mRMatricula = mwkRPresta.matriculas
mPresSexo = "Dr."
mPresTitu = "Anatomo Patólogo"
If mwkRPresta.sexo = "F"
	mPresSexo = "Dra. "
	mPresTitu = "Anatomo Patóloga"
Endif
mRNombreFirma = mPresSexo + Alltrim(mwkRPresta.nombre) + Chr(13) + mPresTitu + Chr(13) + "MN " + Alltrim(mRMatricula)


*** Titulo del informe
mRTitulo = ""
If mwkValeAnato.Tje_material = 2
	mRTitulo = "Citológico"
Else
	mRTitulo = "Histopatológico"
Endif

mRTitulo = "INFORME " + Upper(mRTitulo)



*** Procedimiento y Profesional interviniente
mRProce = ""
mPPato = mwkValeAnato.TJE_PresPato
If !Isnull(mPPato)
	If mPPato>0
		If mPPato = 1
			mRProce = 'Procedimiento: Estudio intraoperatorio y diferido, con presencia de patólogo en quirófano.'
		Else
			mRProce = 'Procedimiento: Estudio intrapunción, con presencia de patólogo en sala de diagnóstico por imágenes.'
		Endif
	Endif
Endif
mRPatoProf = ""
mRPProf = mwkValeAnato.TJE_PresProf
If !Isnull(mRPProf)
	If mRPProf>0
*Busco Prestador que participó
		lcSQL = "Select nombre from PRESTADORES where ID = ?mRPProf"
		If !prg_EjecutoSql(lcSQL,"mwkRPresta2",.F.)
			Return .F.
		Endif
		mRPatoProf = Alltrim(mwkRPresta2.nombre)
	Endif
Endif

*** Macro
mRMacro = "Macroscopía" + Chr(13) + Chr(13) + mRMacro
mRMacro = Strtran(mRMacro,"&nbsp;","")
mRMacro = Strtran(mRMacro,"<div>",Chr(13))
mRMacro = Strtran(mRMacro,"</div>","")
mRMacro = Strtran(mRMacro,"<p>","")
mRMacro = Strtran(mRMacro,"</p>","")
mRMacro = prg_html2texto(mRMacro)

*** Micro
mRMicro = "Microscopía" + Chr(13) + Chr(13) + mRMicro
mRMicro = Strtran(mRMicro,"&nbsp;","")
mRMicro = Strtran(mRMicro,"<div>",Chr(13))
mRMicro = Strtran(mRMicro,"</div>","")
mRMicro = Strtran(mRMicro,"<p>","")
mRMicro = Strtran(mRMicro,"</p>","")
mRMicro = prg_html2texto(mRMicro)

*** Diagnóstico
mRdiag = "Diagnóstico" + Chr(13) + Chr(13) + mRMaterial + Chr(13) + mRdiag
mRdiag = Strtran(mRdiag,"&nbsp;","")
mRdiag = Strtran(mRdiag,"<div>",Chr(13))
mRdiag = Strtran(mRdiag,"</div>","")
mRdiag = Strtran(mRdiag,"<p>","")
mRdiag = Strtran(mRdiag,"</p>","")
mRdiag = prg_html2texto(mRdiag)

*** Detalle
mRInfo = mRMacro + Chr(13) + Chr(13) + mRMicro + Chr(13) + Chr(13) + mRdiag
*mRInfo = mRMacro



*** Firma del Médico Patólogo
mRFirma = ""

lcSQL = "SELECT IMAGEN FROM TABMEDFOTO WHERE IDMEDICO = ?mIdCodMed AND TIPO = 3 and fechabaja = '1900-01-01'"

mret = SQLExec(mcon1,lcSQL,"mwkImagenFirma")

* Busco Imágen de Firmas

lcdirectorio = 'C:\temp\imagenes\firmas'
If !Directory(lcdirectorio)
	Md &lcdirectorio
Endif

Select mwkImagenFirma
lcnombre = ''
If Reccount("mwkImagenFirma")>0
	mSub = Alltrim(Sys(2015))
	Copy To "C:\temp\imagenes\firmas\firm_"+mSub+".dbf"
	mBorroArchivo1 = "C:\temp\imagenes\firmas\firm_"+mSub+".dbf"
	mBorroArchivo2 = "C:\temp\imagenes\firmas\firm_"+mSub+".fpt"
	Use In mwkImagenFirma
	imagen = Fopen("C:\temp\imagenes\firmas\firm_"+mSub+".dbf",12)
	Fseek(imagen,43)
	Fwrite(imagen,'M')
	Fclose(imagen)
	Use "C:\temp\imagenes\firmas\firm_"+mSub+".dbf"
	lcRun = "Select firm_"+mSub
	&lcRun
	lcImagen = imagen
	Strtofile(lcImagen,"C:\temp\imagenes\firmas\fanato_"+mSub+".jpg")
	lcRun = "Use In firm_"+mSub
	&lcRun
	lcnombre = "C:\temp\imagenes\firmas\fanato_"+mSub+".jpg"
	If Used("mwkBorrar")
		Insert Into mwkBorrar (archivo) Values (mBorroArchivo1)
		Insert Into mwkBorrar (archivo) Values (mBorroArchivo2)
		Insert Into mwkBorrar (archivo) Values (lcnombre)
	Endif
Endif

mRFirma = ''
If !Empty(lcnombre)
	If File(lcnombre)
		mRFirma = lcnombre
	Endif
Endif


Select mwkValeAnato
*Do Locfile("FoxyPreviewer.App")
cFILE = mCFILEPDF
Report Form repanatomia2 Object Type 10 To File &cFILE
Return 1
