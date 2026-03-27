****
** Busqueda de Protocolo
****
parameter mnroadm,msec,msect,lsololectura
lsololectura = IIF(VARTYPE(lsololectura)#"N",0,lsololectura)
lnuevo = .f.
releo = .f.
if msec = 0

	mret = sqlexec(mcon1, "select pac_codadmision as pin_codadmision, Tabinthce.ID, IH_admision, IH_codcie, "+;
		"IH_codestado, IH_codmed, IH_codmedcie, IH_fechaHoraIng, IH_horaCierre,"+;
	  	"IH_motIngreso, IH_procedencia, IH_reingre, IH_secagrup, IH_secuencia, IH_usuario,EI_idevol "+;
		" from pacientes "+;
		" left join TabintHCE on pac_codadmision   = tabintHCE.IH_admision " + ;
		" left join TabintEvol on tabintHCE.id = tabintevol.EI_idevol " + ;
		" where pac_codadmision  = ?mnroadm " , "mwkinterna010")
	select mwkinterna010.*,SectorAgrup,mwksecagrup.descripcion  ;
		from mwkinterna010 ;
		left join mwksecagrup on mwksecagrup.Sectoragrup = IH_secagrup ;
		into cursor mwkinterna01
	go bott

	if 	SectorAgrup # msect AND lsololectura = 0
		lnuevo = .t.
	endif
else
	mret = sqlexec(mcon1, "select pac_codadmision as pin_codadmision, Tabinthce.ID, IH_admision, IH_codcie, "+;
		" IH_codestado, IH_codmed, IH_codmedcie, IH_fechaHoraIng, IH_horaCierre,"+;
	  	" IH_motIngreso, IH_procedencia, IH_reingre, IH_secagrup, IH_secuencia, IH_usuario,EI_idevol "+;
		" from pacientes "+;
		" left join TabintHCE on pac_codadmision   = tabintHCE.IH_admision " + ;
		" left join TabintEvol on tabintHCE.id = tabintevol.EI_idevol " + ;
		" where pac_codadmision  = ?mnroadm and IH_secuencia = ?msec " , "mwkinterna010")
	select mwkinterna010.*,SectorAgrup,mwksecagrup.descripcion  ;
		from mwkinterna010 ;
		left join mwksecagrup on mwksecagrup.Sectoragrup = IH_secagrup ;
		into cursor mwkinterna01
	go bott

endif
if mret<1
	=aerr(eros)
	messagebox(eros(3))
endif
mfecnul = ctot("01/01/1900")
musu = iif(used('mwkusuarios'),mwkusuarios.codigovax,mwkusuario.codigovax)
if (isnull(mwkinterna01.IH_admision) or lnuevo) AND lsololectura = 0  &&& genero el registro inicial
*	SET STEP ON 
endif
select * from mwkinterna01 ;
	group by IH_secuencia;
	order by IH_secuencia desc into cursor mwkinterna
return releo  