*!*	select ctot( dtoc(APV_FechaAuditoria) + " " + ttoc(APV_HoraAuditoria ,2) ) as audit,;
*!*	ctot( dtoc(VAL_fechacargasoli) + " " + ttoc( VAL_horacargasolic,2) ) as carga ,;
*!*	ctot( dtoc(APV_FechaSolicitud) + " " + ttoc(APV_HoraSolicitud ,2) ) as sol,*;
*!*	 from autefec where val_estado=2 order by val_codadmision,apv_codinsusolic ;
*!*	 into cursor todossinc
*!*
public d1204
d1204 = ctod("12/04/2011")
select * from autoriz order by APV_CodAdmision,apv_CodInsuAutori,APV_FechaAuditoria desc into cursor autoo
select id,sum(nvl(apv_cantefectuadas,0)) as efec,;
	sum(nvl(apv_cantautorizada,0)) as autori,APV_FechaAuditoria ;
	,APV_CodAdmision,apv_CodInsuAutori;
	from autoo group by APV_CodAdmision,apv_CodInsuAutori order by APV_CodAdmision desc ,apv_CodInsuAutori;
	into cursor autorig
select autorig

set step on
scan
	if autori>efec
		madmi = APV_CodAdmision
		minsu = apv_CodInsuAutori
		mfecha = APV_FechaAuditoria
		requery('vales_real')
		select *,sum(pia_cantsolicitada) as cante  ;
			from vales_real into cursor valessum

		micant = valessum.cante
		select autoriz
		locate for apv_codadmision = madmi and apv_CodInsuAutori = minsu
		do while !eof() and apv_codadmision = madmi and apv_CodInsuAutori = minsu and micant>0
			if apv_cantefectuadas<apv_cantautorizada
				if micant>apv_cantautorizada -apv_cantefectuadas
					micant = micant-(apv_cantautorizada -apv_cantefectuadas)
					replace apv_cantefectuadas with apv_cantautorizada
				else
					replace apv_cantefectuadas with apv_cantefectuadas +micant
					micant = 0
				endif
			endif
			skip
		enddo
	endif
endscan
select * from autoriz order by APV_CodAdmision,apv_CodInsuAutori,APV_FechaAuditoria desc into cursor autoo
select id,sum(nvl(apv_cantefectuadas,0)) as efec,;
	sum(nvl(apv_cantautorizada,0)) as autori,APV_FechaAuditoria ;
	,APV_CodAdmision,apv_CodInsuAutori,0000 as cantvale,space(50) as insumo;
	from autoo group by APV_CodAdmision,apv_CodInsuAutori order by APV_CodAdmision ,apv_CodInsuAutori;
	into cursor autorig
select autorig
Use Dbf('autorig') In 0 Again Alias autorvale
select autorvale
scan
	madmi = APV_CodAdmision
	minsu = apv_CodInsuAutori
	mfecha = APV_FechaAuditoria
	requery('vales_real')
	select *,sum(pia_cantsolicitada) as cante  ;
		from vales_real into cursor valessum

	micant = valessum.cante
	minsu = valessum.INS_descriinsumo
	select autorvale
	replace insumo with minsu,cantvale with micant
	select autorvale
endscan