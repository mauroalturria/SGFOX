****
** Armo evolucion del paciente si no pongo protocolo busca el ultimo
****
Parameter mnroreg,mnroproto,mevoluc,lhist
If Vartype(lhist)<>"N"
	lhist=0
Endif
mnroprot = ''
mevoluc= ''
cbusp = ''
If Vartype(mnroprot)#"C"
	mnroprot = ''
	cbusp = ''
Endif
If !Empty(mnroprot )
	cbusp = " and tabambulatorio.protocolo = ?mnroprot "
Endif

mccpoamb = ''
lcCodAmbito =  ", Cast(1 as Integer) as CodAmbito "

If mxambito >1
	lcCodAmbito =  ", Tabambulatorio.CodAmbito "
*	If Not tbNoFilAmb
	mccpoamb = Iif(mnroprot = '',"","  and Tabambulatorio.codambito = ?mxambito ")
	mret = SQLExec(mcon1, "SELECT * from  tabambulatorio "+ ;
		" where id = 1 ", "mwkctrlamb")
	Select mwkctrlamb
	Scatter Memvar
	If Vartype(m.codambito)#"N"
		mccpoamb = ''
	Endif
	Use In Select("mwkctrlamb")
Endif
*ndif

mret = SQLExec(mcon1, "SELECT TabAmbEvol.*,TabAmbEvolmed.*,"+;
	" tabambulatorio.fechahoraing,tabambulatorio.codprest,tabambulatorio.fechahoraate " + lcCodAmbito + ;
	" from tabambevol "+;
	" left join tabambevolmed on tabambevolmed.eam_proto = tabambevol.ea_protocolo " + ;
	" left join tabambulatorio on tabambulatorio.protocolo = tabambevol.ea_protocolo "  +;
	" where ea_nroregistrac = ?mnroreg "+ mccpoamb + ;
	"  ", "mwkEvolReg01a")

If mret <= 0
	Messagebox("ERROR de LECTURA , AVISAR A SISTEMAS", 48, "Validacion")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
Endif
If lhist = 1
	mret = SQLExec(mcon1, "SELECT TabAmbEvol.*,TabAmbEvolmed.*,"+;
		" tabambulatorio.fechahoraing,tabambulatorio.codprest,tabambulatorio.fechahoraate " + lcCodAmbito + ;
		" from  TabAmbEvolHis as tabambevol  "+;
		" left join TabAmbEvolMedHis AS tabambevolmed on tabambevolmed.eam_proto = tabambevol.ea_protocolo " + ;
		" left join TabAmbulatorioHis AS  tabambulatorio on tabambulatorio.protocolo = tabambevol.ea_protocolo "  +;
		" where  ea_nroregistrac = ?mnroreg "  + mccpoamb + ;
		" ", "mwkEvolReg01H")

	If Reccount( "mwkEvolReg01H")>0
		Select * From mwkEvolReg01a Union All ;
			SELECT * From mwkEvolReg01H;
			INTO Cursor mwkEvolReg01p
	Else
		Select * From mwkEvolReg01a Into Cursor mwkEvolReg01p
	Endif
Else
	Select * From mwkEvolReg01a Into Cursor mwkEvolReg01p

Endif
Select * From mwkEvolReg01p Group By id1 order by eam_fechah DESC Into Cursor mwkEvolReg01


mret = SQLExec(mcon1, "SELECT TabAmbEvol.*,TabAmbEvolnurse.*,"+;
	" tabambulatorio.fechahoraing,tabambulatorio.codprest,tabambulatorio.fechahoraate,nomape " + lcCodAmbito + ;
	" from tabambevol "+;
	" left join tabambevolnurse on tabambevolnurse.ean_proto = tabambevol.ea_protocolo " + ;
	" left join tabambulatorio on tabambulatorio.protocolo = tabambevol.ea_protocolo "  +;
	" left join tabusuario on tabusuario.codigovax = TabAmbEvolnurse.ean_usuario "  +;
	" where  ea_nroregistrac = ?mnroreg " + cbusp +mccpoamb + ;
	" group by TabAmbEvolnurse.id " + ;
	" ", "mwkEvolRegNurv")

If mret <= 0
	Messagebox("ERROR de LECTURA , AVISAR A SISTEMAS", 48, "Validacion")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
Endif
If lhist = 1

	mret = SQLExec(mcon1, "SELECT TabAmbEvol.*,TabAmbEvolnurse.*,"+;
		" tabambulatorio.fechahoraing,tabambulatorio.codprest,tabambulatorio.fechahoraate,nomape " + lcCodAmbito + ;
		" from TabAmbEvolHis  as tabambevol "+;
		" left join tabambevolnurse on tabambevolnurse.ean_proto = tabambevol.ea_protocolo " + ;
		" left join TabAmbulatorioHis  as tabambulatorio on tabambulatorio.protocolo = tabambevol.ea_protocolo "  +;
		" left join tabusuario on tabusuario.codigovax = TabAmbEvolnurse.ean_usuario "  +;
		" where ea_nroregistrac = ?mnroreg " + cbusp +mccpoamb + ;
		" group by TabAmbEvolnurse.id " + ;
		"  ", "mwkEvolRegNurh")

	If mret <= 0
		Messagebox("ERROR de LECTURA , AVISAR A SISTEMAS", 48, "Validacion")
		Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
	Endif
	If Reccount( "mwkEvolRegNurh")>0
		Select * From mwkEvolRegNurh Union All ;
			SELECT * From mwkEvolRegNurv;
			INTO Cursor mwkEvolRegNur
	Else
		Select * From mwkEvolRegNurv   Into Cursor mwkEvolRegNur
	Endif
Else
	Select * From mwkEvolRegNurv   Into Cursor mwkEvolRegNur
Endif

Select Id,ea_antecedentes,ea_evolnurse,ea_evolucion,ea_exfisico,;
	ea_horacierre,ea_indicnurse,ea_motconsulta,ea_newindic,;
	ea_nroregistrac,ea_protocolo,id1,eam_codmed,eam_evol,;
	fechahoraing,eam_fechah,eam_proto,codprest,fechahoraate, codambito ;
	from mwkEvolReg01 ;
	into Cursor mwkEvolReg01

Select Id,ea_antecedentes,ea_evolnurse,ea_evolucion,ea_exfisico,;
	ea_horacierre,ea_indicnurse,ea_motconsulta,ea_newindic,ea_nroregistrac,;
	ea_protocolo,id1,ean_codmed,ean_evolnurse,fechahoraing,ean_fechah,ean_paradmf,ean_paralerg,;
	ean_paralergque,ean_parfrecard,ean_parfreresp,ean_pargluc,ean_parotros,ean_parpeso,;
	ean_parsatur,ean_partalla,ean_partemaxl,ean_partembuc,ean_partensdia,ean_partenssis,;
	ean_proto,ean_usuario,fechahoraate,nomape, codambito;
	from mwkEvolRegNur order by ean_fechah;
	into Cursor mwkEvolRegNur

Select mwkEvolRegNur
Go Bott

If mret <= 0
	Messagebox("ERROR de LECTURA , AVISAR A SISTEMAS", 48, "Validacion")
	Do log_errores With Error(), Message(), Message(1), Program(), Lineno()
Endif

If Used('mwkMedrpzt')
	Select mwkEvolReg01.*,nombre From mwkEvolReg01,mwkmedrpzt;
		where Nvl(eam_codmed,1) = mwkmedrpzt.Id ;
		order By fechahoraing Desc ;
		into Cursor mwkevolreg
Else
	Select mwkEvolReg01.*,nombre From mwkEvolReg01,mwkmedicoamb;
		where Nvl(eam_codmed,1) = mwkmedicoamb.Id ;
		order By fechahoraing Desc ;
		into Cursor mwkevolreg
Endif
Use In mwkEvolReg01
If Empty(mnroprot)
	Select mwkevolreg
	Go Top
	mnroprot = ea_protocolo
Endif

Select * From mwkevolreg Where ea_protocolo = mnroprot Order By eam_fechah Into Cursor mwkevolprot

*!*	mevoluc =" M.C.:"+ alltrim(EA_motConsulta)+ chr(10)+ "Ant.:"+ alltrim(EA_anteceden)+;
*!*		chr(10)+ "E.F.:"+ alltrim(EA_exFisico)+ chr(10)+ "Evolucion:"
mevoluc = ''
Select mwkevolprot
Scan
	mevoluc = mevoluc + Chr(10)+ Ttoc(eam_fechah)+" - "+ Left(nombre,15)+" -> " + Alltrim(eam_evol)
Endscan
Go Bottom
* SELECT ID , EA_nroregistrac , EA_protocolo , EA_codmed , EA_fechaHora ,
*EA_motConsulta , EA_anteceden , EA_evolucion , EA_exFisico , EA_evolHist
* and EA_codmed= mmedico
