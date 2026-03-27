****
** Armo evolucion del paciente
****

Parameter mnroreg, mnroprot,mevoluc,mmedico,ntope
If Vartype(mnroprot)#"C"
	mnroprot = ''
	cbusp = ''
Else
	cbusp = " and guardia.protocolo ='"+Alltrim(mnroprot)+"' "
ENDIF
If Vartype(block_ent)# "C"
	Public block_ent
	block_ent =''
Endif
If !Empty(block_ent) AND block_ent <> "ALL" 
	cbusp = cbusp + " and guardia.codent IN ("+block_ent+") "
Endif

If Vartype(mevoluc)#"C"
	mevoluc= ''
Endif
If Vartype(mmedico)#"N"
	mmedico = 359
Endif
If Vartype(ntope)#"N"
	ctope = ''
	cbusfecha = ''
Else
	ctope = " top "+Transform(ntope)
	mifecha = prg_dtoc(sp_busco_fecha_serv("DD")-ntope*30)
	cbusfecha = " and guardia.fechahoraing>= ?mifecha "
Endif
If mwkexe.nomexe = 'TELECONSULTA'
	mret = SQLExec(mcon1,"SELECT id, nombre,CAST(matriculas  as integer) as matricula, codesp  FROM prestadores  " + ;
		"  " +;
		" union  select id , nombre,matricula,'    ' as codesp  from tabmedexterno " + ;
		" where gerenciadora = 0 "  +;
		"order by nombre", "mwkMedicoguall" )
Else
	mret = SQLExec(mcon1,"SELECT id, nombre,CAST(matriculas  as integer) as matricula, codesp  FROM prestadores  " + ;
		"where dguardia = 1 " +;
		" union  select id , nombre,matricula,'    ' as codesp  from tabmedexterno " + ;
		" where gerenciadora = 0 "  +;
		"order by nombre", "mwkMedicoguall" )
Endif
*!*	mret = sqlexec(mcon1, "SELECT * FROM TabGuaEvol "+;
*!*		"left join TabGuaEvolmed on TabGuaEvol.EG_protocolo = TabGuaEvolmed.EGM_proto " + ;
*!*		" where EG_nroregistrac = ?mnroreg "+;
*!*		"", "mwkEvolReg01")


mret = SQLExec(mcon1, "SELECT TabGuaEvol.*,TabGuaEvolmed.*,"+;
	" guardia.fechahoraing,guardia.codprest,guardia.fechahoraate,guardia.codestado "+;
	" FROM TabGuaEvol"+;
	" left join tabguaevolmed on tabguaevolmed.egm_proto = tabguaevol.eg_protocolo" + ;
	" left join guardia on guardia.protocolo = tabguaevol.eg_protocolo"+;
	" where eg_nroregistrac = ?mnroreg "+cbusfecha+cbusp , "mwkEvolReg01")


*!*	mret = sqlexec(mcon1, "SELECT * FROM TabGuaEvol "+;
*!*		"left join TabGuaEvolnurse on TabGuaEvol.EG_protocolo = TabGuaEvolnurse.EGN_proto " + ;
*!*		" where EG_nroregistrac = ?mnroreg "+;
*!*		" order by EGN_fechaH ", "mwkEvolRegNur")

mret = SQLExec(mcon1, "SELECT TabGuaEvol.*,TabGuaEvolnurse.*,guardia.fechahoraing,guardia.codprest,guardia.fechahoraate,guardia.codestado "+;
	" FROM TabGuaEvol"+;
	" left join tabguaevolnurse on tabguaevolnurse.egn_proto = tabguaevol.eg_protocolo" + ;
	" left join guardia on guardia.protocolo = tabguaevol.eg_protocolo"+;
	" where eg_nroregistrac = ?mnroreg "+cbusfecha+cbusp +;
	" order by egn_fechah ", "mwkEvolRegNur")


*set step on

Select Id,eg_nroregistrac,eg_protocolo,eg_codmed,eg_fechahora,eg_motconsulta,;
	eg_anteceden,eg_evolucion,eg_exfisico,eg_evolhist,eg_codcienanda,eg_evolnurse,;
	eg_horacierre,eg_indicnurse,eg_paradmf,eg_paralerg,eg_paralergque,eg_parfrecard,;
	eg_parfreresp,eg_pargluc,eg_parotros,eg_parpeso,eg_parsatur,eg_partemaxl,eg_partembuc,;
	eg_partemrct,eg_partensdia,eg_partenssis,eg_usuario,id1,egm_proto,egm_codmed,;
	fechahoraing,egm_fechah,codprest,egm_evol,fechahoraate,codestado ;
	from mwkevolreg01 Into Cursor mwkevolreg01

Select Id,eg_nroregistrac,eg_protocolo,eg_codmed,eg_fechahora,eg_motconsulta,eg_anteceden,;
	eg_evolucion,eg_exfisico,eg_evolhist,eg_codcienanda,eg_evolnurse,eg_horacierre,eg_indicnurse,;
	eg_paradmf,eg_paralerg,eg_paralergque,eg_parfrecard,eg_parfreresp,eg_pargluc,eg_parotros,eg_parpeso,;
	eg_parsatur,eg_partemaxl,eg_partembuc,eg_partemrct,eg_partensdia,eg_partenssis,eg_usuario,id1,egn_codcienanda,;
	egn_evolnurse,fechahoraing,egn_fechah,egn_paradmf,egn_paralerg,egn_paralergque,egn_parfrecard,egn_parfreresp,;
	egn_pargluc,egn_parotros,egn_parpeso,egn_parsatur,egn_partemaxl,egn_partembuc,egn_partemrct,;
	egn_partensdia,egn_partenssis,egn_proto,egn_usuario,fechahoraate,codestado ;
	from mwkevolregnur Into Cursor mwkevolregnur


Select mwkevolregnur
Go Bott

If mret < 0
	=Aerr(eros)
	Messagebox("ERROR de LECTURA , AVISAR A SISTEMAS", 48, "Validacion")
Endif
If Used('mwkmedicoant')
	Select mwkevolreg01.*,nombre,matricula From mwkevolreg01,mwkmedicoant;
		where Nvl(egm_codmed,1) =mwkmedicoant.Id ;
		order By egm_fechah Desc ;
		into Cursor mwkevolreg

Else

	Select mwkevolreg01.*,nombre,matricula From mwkevolreg01,mwkmedicoguall ;
		where Nvl(egm_codmed,1) =mwkmedicoguall.Id ;
		order By egm_fechah Desc ;
		into Cursor mwkevolreg
Endif
Use In mwkevolreg01
If Empty(mnroprot)
	Select mwkevolreg
	Go Top
	mnroprot = eg_protocolo
Endif
Select * From mwkevolreg ;
	where eg_protocolo = mnroprot ;
	group By id1 Order By egm_fechah;
	into Cursor mwkevolprot

*!*	mevoluc =" M.C.:"+ alltrim(EG_motConsulta)+ chr(10)+ "Ant.:"+ alltrim(EG_anteceden)+;
*!*		chr(10)+ "E.F.:"+ alltrim(EG_exFisico)+ chr(10)+ "Evolucion:"
mevoluc = ''
Select mwkevolprot
Scan
	mevoluc = mevoluc + Chr(10)+ Iif(Vartype(egm_fechah)<> "T",Space(19),Ttoc(egm_fechah))+" - "+ Alltrim(nombre)+;
		iif(Val(Transform(matricula))>0," M.N.:"+Transform(matricula),'')+" -> " + Alltrim(egm_evol)
Endscan
Go Bottom
* SELECT ID , EG_nroregistrac , EG_protocolo , EG_codmed , EG_fechaHora ,
*EG_motConsulta , EG_anteceden , EG_evolucion , EG_exFisico , EG_evolHist
* and EG_codmed= mmedico
