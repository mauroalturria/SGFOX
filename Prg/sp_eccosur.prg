*=Proc1Vale(mwkVales.Val_CodValeAsist)
*!*------------------------------------------------------------------------------------------------------------------------------
Parameters tnCodVale 

*tnCodVale = 32719136

Do prg_cvalecnt With tnCodVale

&& BUSCO DATOS REGISTRACION
mbusco = " where REG_NroRegistrac = " + Transform(mwkValeAsist.PAC_codhci) + " and "
Do sp_busco_nombre_paciente With mbusco, 1 && mwkbuspacie

ltFecHorSoli = Ctot(Dtoc(mwkValeAsist.Val_fechasolicitud) + " " + Alltrim(Strtran(mwkValeAsist.Val_horasolicitud,".",":")))
lcApePac = Substr(mwkValeAsist.Pac_nombrepaciente,1,-1+At(",",mwkValeAsist.Pac_nombrepaciente,1))
lcNomPac = Alltrim(Substr(mwkValeAsist.Pac_nombrepaciente,1+At(",",mwkValeAsist.Pac_nombrepaciente,1)))

lnPeso = 0
lnAltura = 0
lcTipDocu = 'DNI' && ver
lcDocu = Transform(mwkbuspacie.reg_numdocumento)


lnPostBlanc = At(" ",Alltrim(mwkValeAsist.Des_medicosolicit),1)


lcMdApe = Alltrim(Substr(Alltrim(mwkValeAsist.Des_medicosolicit),1,lnPostBlanc)) && Alltrim(mwkValeAsist.Des_medicosolicit) && '-1' 
lcMdNom = Alltrim(Substr(Alltrim(mwkValeAsist.Des_medicosolicit),lnPostBlanc))&& Alltrim(mwkValeAsist.Des_Prestador) &&'-2' 
lcMdMat = Alltrim(Transform(Nvl(mwkValeAsist.Mat_medicosolicit,0)))&& '-6'

lcMoApe = Alltrim(mwkValeAsist.Des_prestador)
lcMoNom = "" && Alltrim(mwkValeAsist.Des_medicosolicit) && '-5' 
lcMoMat = Alltrim(Transform(Nvl(mwkValeAsist.Mat_Prestador,0)))&&'-3' 

lcOs = Alltrim(mwkValeAsist.Ent_descrient)
lcAfi = Alltrim(mwkValeAsist.Afi_nroafiliado)
lnIdSoft = "1.0"
tnPkInt = tnCodVale 

Select mwkIteAsist
Scan All
	
	lnCodPrest =  tnCodVale  && mwkIteAsist.pre_codprest 
	
	Do EccoSQL With 1, 0, ltFecHorSoli, lnCodPrest,  mwkValeAsist.Pac_codhci, lcNomPac, lcApePac, mwkValeAsist.Pac_fecnacimiento, ;
	mwkValeAsist.Pac_sexo, lnPeso, lnAltura, lcTipDocu, lcDocu , ;
	lcMoApe, lcMoNom, lcMoMat, lcMdApe, lcMdNom, lcMdMat, lcOs, lcAfi, lnIdSoft, tnPkInt

	Use In Select("mwkpac")
	
	Select mwkIteAsist
Endscan 

Use In Select("mwkpac")

*!*------------------------------------------------------------------------------------------------------------------------------
Procedure EccoSQL
Parameters tnOpcion, tnId, tnFecHorEst, tnCodPrest, tnPacCodHCI, tcNomPac, tcApePac, tdFecNac, tcSexo, tnPeso, tnAltu, ;
tcTipDocu, tcDocu, tcMoApe, tcMoNom, tcMoMat, tcMdApe, tcMdNom, tcMdMat, tcOs, tcAfi, tnIdSoft, tnPkInt

Do Case
* Pk_int,
Case tnOpcion = 1
	lcsql = "Insert Into Eccosur.T_INT " + ;
			"(Int_fecha_estudio, Int_id_unico_estudio, Int_id_unico_paciente, Int_paciente_nombre, " + ;
			"Int_paciente_apellido, Int_paciente_fecha_nac, Int_paciente_sexo, Int_paciente_peso, Int_paciente_altura, " + ;
			"Int_paciente_dni_tipo, Int_paciente_dni_nro, Int_mo_apellido, Int_mo_nombre, Int_mo_matricula, " + ;
			"Int_md_apellido, Int_md_nombre, Int_md_matricula, Int_os_nombre, Int_md_nro_afiliado, " + ;
			"Int_id_soft_ekosur, pk_Int) " + ;
			"Values " + ;
			"(?tnFecHorEst, ?tnCodPrest, ?tnPacCodHCI, ?tcNomPac, " + ;
			"?tcApePac, ?tdFecNac, ?tcSexo, ?tnPeso, ?tnAltu, " + ;
			"?tcTipDocu, ?tcDocu, ?tcMoApe, ?tcMoNom, ?tcMoMat, " + ;
			"?tcMdApe, ?tcMdNom, ?tcMdMat, ?tcOs, ?tcAfi, " + ;
			"?tnIdSoft, ?tnPkInt) "

Endcase

If !Prg_EjecutoSql(lcSql,"mwkI")
	Return .f.
Endif  
*!*------------------------------------------------------------------------------------------------------------------------------
