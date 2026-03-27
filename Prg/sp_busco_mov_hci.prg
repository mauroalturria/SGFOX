****
** busco  evolucion de pacientes
****


parameter mdesde,mhasta,mfiltros,mpac,minsu

mfd = prg_dtoc(ttod(mdesde))
mfh = prg_dtoc(ttod(mhasta)+1)

mfiltrof = ' 1 = 1 ' && " ((PAC_fechaalta is null or PAC_fechaalta >= ?mfh) and PAC_fechaadmision < ?mfh ) "
msolointerna = ''
if empty(mpac)
	msolointerna = ' inner join pacinternad on pacinternad.pin_codadmision = pacientes.PAC_codadmision'
endif
mfhd = prg_dtoc(mdesde)
mfhh = prg_dtoc(mhasta)
mfiltroinsu = ''
mfiltroinsun = ''

if !empty(minsu)
	mfiltroinsu  = ' and at(minsu,INS_descriinsumo)> 0 '
	mfiltroinsun  = ' where at(minsu,INS_descriinsumo)> 0  or at(minsu,ICI_detalle)> 0  '
endif

mfiltrofi= " and ICI_fechaHora >=?mfhd and ICI_fechaHora <=?mfhh "

IF !USED("mwkMedicointall")
	do sp_busco_med_pisos
	select  id, nombre,codesp,matricula as matriculas  from mwkmedicoint where 1=2 into cursor mwkMedicouno
	use in select("mwksinmed")
	use dbf('mwkMedicouno') in 0 again alias mwksinmed
	select mwksinmed
	insert into mwksinmed (id, nombre,codesp,matriculas  ) values (1,"MEDICO INTERNACION","",0)
	select  id, nombre,codesp,matricula as matriculas  from mwkmedicoint union all;
		select * from mwksinmed into cursor mwkMedicointall
	use in select("mwksinmed")
	use in select("mwkMedicouno")
endif
mret = sqlexec(mcon1, "SELECT Tabinthce.ID, PAC_sectorinternac,IH_secuencia, IH_fechaHoraIng,PAC_nombrepaciente, ih_horacierre ,"+;
	" PAC_fechaadmision, PAC_codadmision, PAC_fechaalta,PAC_habitacion,PAC_cama "+;
	" FROM pacientes "+msolointerna +;
	" inner join TabintHCE on pacientes.pac_codadmision = tabintHCE.IH_admision " + ;
	" where  "+mfiltrof  +mfiltros+ mpac +" group by Tabinthce.id", "mwkmovhci01")


if reccount("mwkmovhci01")>0
	select * from mwkmovhci01 where IH_fechaHoraIng <= mhasta  and (IH_horaCierre=ctot("01/01/1900") or IH_horaCierre>mdesde)order by PAC_codadmision,id into cursor mwkmovhci

	mret = sqlexec(mcon1, "SELECT PAC_sectorinternac,PAC_nombrepaciente, VAL_fechaconforme, VAL_horaconforme,"+;
		" PAC_fechaadmision, PAC_codadmision, PAC_fechaalta,val_estado,VAL_codsector,VAL_habitacion, VAL_cama"+;
		",VAL_fechasolicitud, VAL_horasolicitud, VAL_codvaleasist, Insumos.INS_descriinsumo,Insumos.INS_tipo "+;
		",INS_codinsumo, INS_codpuntero, PIA_cantsolicitada, VAL_observaciones,VAL_horacargasolic, VAL_fechacargasoli "+;
		" FROM pacientes "+msolointerna +;
		" inner join Valesasist on pacientes.pac_codadmision = Valesasist.VAL_codadmision " + ;
		" inner join Presinsuvas on VAL_codpun = PIA_VALESASIST " + ;
		" inner join Insumos on PIA_codinsumo = INS_codpuntero " + ;
		" where  "+mfiltrof  +mfiltros+ mpac +" and VAL_codservvale = 5410 ", "mwkmovvale01")
	select * from mwkmovvale01 where ctot(dtoc(VAL_fechacargasoli)+" " + ttoc(VAL_horacargasolic,2)) >= mdesde;
		and ctot(dtoc(VAL_fechacargasoli)+" " + ttoc(VAL_horacargasolic,2)) <= mhasta;
		 &mfiltroinsu order by PAC_codadmision,VAL_codvaleasist into cursor mwkmovvale

	mret = sqlexec(mcon1, "SELECT Tabinthce.ID, PAC_sectorinternac,IH_secuencia, IH_fechaHoraIng,PAC_nombrepaciente, "+;
		" PAC_fechaadmision, PAC_codadmision, PAC_fechaalta,INS_descriinsumo ,nomape,Insumos.INS_tipo,Insumos.INS_codinsumo "+;
		",ICI_comentario , ICI_detalle , ICI_fechaHora , ICI_horaIndica , ICI_idevol , ICI_insumo , ICI_usuario"+;
		" FROM pacientes "+msolointerna +;
		" inner join TabintHCE on pacientes.pac_codadmision = tabintHCE.IH_admision " + ;
		" inner join Tabintcuiins on tabintHCE.id = Tabintcuiins.ICI_idevol " + ;
		" inner join tabusuario on Tabintcuiins.ICI_usuario  = tabusuario.id " + ;
		" inner join Insumos on Tabintcuiins.ICI_insumo = Insumos.INS_codpuntero " + ;
		" where  " + mfiltrof  + mfiltros + mpac + mfiltrofi , "mwkmovins01")
	select ttod(ICI_fechaHora) as fechains, * from mwkmovins01 &mfiltroinsun ;
	order by PAC_codadmision,ICI_idevol,ICI_fechaHora into cursor mwkmovins
endif
if mret < 0
	=aerr(eros)
	messagebox("ERROR de LECTURA , AVISAR A SISTEMAS", 48, "Validacion")
else

endif


