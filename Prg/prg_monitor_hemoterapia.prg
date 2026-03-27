tcRuta = Addbs(Addbs(Addbs(alltrim(mwkldestinos.path)) + "HT") + "Entrada") 
If !Directory(tcRuta)
	Md (tcRuta)
Endif 

mctexto = Alltrim(mwklistamvbg.nrohclinica)
mbusco1 = "where registracio.REG_nrohclinica = ?mctexto and "
do sp_busco_nombre_paciente_1 with mbusco1, 1, ''

lcNroVale = Alltrim(Transform(Nvl(mwklistamvbg.nrovale,0)))
ltFechaVale = Ctot(Dtoc(Nvl(mwklistamvbg.fechasolic,Ctod(''))) + " " + Alltrim(Nvl(mwklistamvbg.HoraSolic,'')))
lcHCE = Alltrim(Nvl(mwklistamvbg.nrohclinica,'')) && '319689-4' 
*lcAPENOM = Strtran(Alltrim(mwklistamvbg.nombrepac),',',' ') && 'PEREZ, ADELA'
lcAPENOM = Alltrim(Nvl(mwklistamvbg.nombrepac,''))&& 'PEREZ, ADELA'
lcSEX = Alltrim(Nvl(mwklistamvbg.Sexo,'')) && 'F'
lcDNI = Alltrim(Transform(Nvl(mwkbuspacie.REG_numdocumento,0))) && '4337707'
lcNAC = Dtoc(Nvl(mwkbuspacie.REG_fecnacimiento,CTOD(''))) && '09/11/1911'
lcDIR = Alltrim(Nvl(mwkbuspacie.REG_domicilio,'')) && 'CHARCAS  3100 5 C'
lcPAIS = 'ARGENTINA'
lcPROV = Alltrim(Nvl(mwkbuspacie.REG_provincia,'')) && ' '
lcLOCA = Alltrim(Nvl(mwkbuspacie.REG_localidad,'')) && 'CAPITAL FEDERAL'
lcTEL  = Alltrim(Nvl(mwkbuspacie.REG_telefonos,'')) && '4825-9660'
*!*------------------------------------------------------------------------------------------------------------------------------
lchora = Strtran(Ttoc(ltFechaVale,2),":","")
lcF_h = Dtoc(Ttod(ltFechaVale),1) + "_" + lchora


lcArchivo = "" + lcNroVale + "_" + lcF_h + ".txt"

lcSEP = ';'
lcTEXTO = lcHCE + lcSEP + lcAPENOM + lcSEP + lcSEX + lcSEP + 'DNI' + lcSEP + lcDNI + lcSEP + lcNAC + lcSEP + lcDIR + lcSEP + lcPAIS + lcSEP + lcPROV + lcSEP + lcLOCA + lcSEP + lcTEL 

If !File(tcRuta + lcArchivo)
	lnHand = Fcreate(tcRuta + lcArchivo) 
	IF lnHand <= 0
		Messagebox("NO SE PUDO CREAR EL ARCHIVO",32,"ERROR")
		Return .f.
	Else 	
		=Fwrite(lnHand,lcTEXTO)
		=Fclose(lnHand)
	Endif  
Endif 

*!* ?"GUE_HEMOTERAPIA_20032015_172656.txt"
*!*	? '319689-4;PEREZ, ADELA;F;DNI;4337707;09/11/1911;CHARCAS  3100 5 C;ARGENTINA; ;CAPITAL FEDERAL;4825-9660'
*!*	319689-4;PEREZ, ADELA;F;DNI;4337707;09/11/1911;CHARCAS  3100 5 C;ARGENTINA; ;CAPITAL FEDERAL;4825-9660
*!*	123456-4;PEREZ, MARIA;F;DNI;123456;01/11/1970;CHARCAS  3106 5 A;ARGENTINA; ;CAPITAL FEDERAL;4825-9666
*!*	222222-4;PEREZ, JUAN;M;DNI;222222;02/11/1970;CHARCAS  3105 5 B;ARGENTINA; ;CAPITAL FEDERAL;4825-9665
