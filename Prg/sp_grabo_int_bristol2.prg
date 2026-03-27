*
* Graba protocolo de la atencion
*
parameters  mtipomov,mcursor,micodent 

mfHoy   = prg_dtoc(sp_busco_fecha_serv('DT'))
mfecorden = left(mfHoy  ,10)
musua 	= alltrim(mwkusuario.idusuario)

mfechaingr = prg_dtoc(ctot(dtoc(&mcursor->pac_fechaadmision)+" "+ttoc(&mcursor->pac_horaadmision,2)))
if !isnull(&mcursor->PAC_fechaalta)
	mfechaegr = prg_dtoc(ctot(dtoc(&mcursor->pac_fechaalta)+" "+ttoc(&mcursor->pac_horaalta,2)))
else
	mfechaegr = '2100-01-01 00:00:00'
endif
msector = &mcursor->PAC_sectorinternac
mcodadm	= &mcursor->PAC_codadmision
ctipomov = iif(mtipomov=1,"I",iif(mtipomov=2,"E",iif(mtipomov=3,"M","N" ) ) )

mdiagno = alltrim(iif(inlist(mtipomov,1,3), &mcursor->PAC_descripdiagn,&mcursor->PAC_diagegreso))
mnroreg = &mcursor->PAC_codhce
mctexto = alltrim(mnroreg )
mbusco1 = "where registracio.REG_nrohclinica = ?mctexto and "
do sp_busco_nombre_paciente_1 with mbusco1, 1, ''
select * from mwkbuspacie where ENT_codent = micodent;
	into cursor mwkbuspacie1
mnrodoc = round(mwkbuspacie1.REG_numdocumento,0)
mtipodoc = round(val(mwkbuspacie1.REG_tipodocumento),0)
mnroafil = alltrim(prg_saca_char(mwkbuspacie1.AFI_nroafiliado))
mapel = alltrim(left(mwkbuspacie1.reg_nombrepac,at(",",mwkbuspacie1.reg_nombrepac)-1))
mnombre = alltrim(substr(mwkbuspacie1.reg_nombrepac,at(",",mwkbuspacie1.reg_nombrepac)+1))
msex = alltrim(mwkbuspacie1.reg_sexo)
mfecnac = left(prg_dtoc(mwkbuspacie1.REG_fecnacimiento),10)
if micodent=948
	mret = sqlexec(mcon1,"select * from SQLUser.PadCabe "+;
		" left join padotrosdatos on padotrosdatos.idpadcabe=padcabe.id "+;
		" where padcabe.Documento = ?mnrodoc ","mwkctrlpad")
	if mret < 0
		=aerror(merror)
		messagebox("EN CONSULTA PADRONES"+chr(10)+;
			alltrim(merror(3)),16,"ERROR")
		do log_errores with error(), message(), message(1), program(), lineno()
		micodent = 948
	else
		menttipo = val(mwkctrlpad.contenido)
		if menttipo >0
			micodent = menttipo
		else
			micodent = iif(alltrim(mwkctrlpad.contenido)='GASMBA',19,;
				iif(alltrim(mwkctrlpad.contenido)='GASTRO',11,948 ) )
		endif
	endif
endif
mret = sqlexec(mcon1, "insert into Bristol.SG_INTERNACION (" + ;
	"nromov,OS_ID,NROAFIL,TIPODOC,NRODOC,APELLIDO,NOMBRE,SEXO,FECHANAC "+;
	",FECHORAING,DIAGNOSTICO,FECHORAEGR,FECHAORDEN,LUGARINTERNAC"+;
	",CODADMISION,TIPOMOV,USUARIO,FECHAHORA ) "+;
	"values(" + ;
	"1,?micodent ,?mnroafil ,?mtipodoc , ?mnrodoc , ?mapel  " + ;
	",?mnombre, ?msex, ?mfecnac, ?mfechaingr, ?mdiagno,?mfechaegr,?mfecorden "+;
	",?msector,?mcodadm,?ctipomov,?musua, ?mfHoy )")
if mret<1
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
endif
