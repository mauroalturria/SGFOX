select vales
set step on
scan
	mnrovale = vale
	ment = ent
	mcpre = codigo
	mfec = ctot(dtoc(date())+" " + strtran(hora,".",":"))
	musua = alltrim(idusuario)
	mcmed= prestador
	mnroreg = nroreg
	mprot_aux = left(allt(mwkusuario.idusuario),5)+padl(int(seconds()),5,'0')

	do sp_grabo_ambulatorio with mnroreg,ctot("01/01/1900"), mfec, ment, ;
		mcpre, mcmed, mnrovale, 1, musua,1,'',0

endscan
set step on


select cons1015.*,idusuario from cons1015, tabusuario where codigovax = operador into cursor vales

delete from cons1015 where serv = "LA"
select distinct serv from cons1015
delete from cons1015 where serv = "BA"
delete from cons1015 where serv = "RX"
delete from cons1015 where serv = "TC"
select distinct serv from cons1015
delete from cons1015 where serv = "KI"
delete from cons1015 where serv = "RM"
delete from cons1015 where left(serv,1) = "E"
delete from cons1015 where serv = "VA"
delete from cons1015 where serv = "PC"
delete from cons1015 where serv = "NP"
delete from cons1015 where serv = "NC"
delete from cons1015 where serv = "HT"
delete from cons1015 where serv = "HD"
select * from cons1015 where vale not in (select nrovale from tabambula) into cursor cosa
select distinct serv from cosa
delete from cons1015 where vale in (select nrovale from tabambula) 
select * from cons1015 where vale not in (select nrovale from tabambula)
select * from cons1015 where vale not in (select nrovale from tabambula) into cursor cosa
select distinct serv from cosa
select * from cons1015 where vale not in (select nrovale from tabambula) into cursor cosa
select distinct serv from cosa


select  cons1015
scan
	mnrohclin = cons1015.h_clin_
	 mret = sqlexec(mcon1, "select REG_nroregistrac "+;
		" FROM Registracio "+ ;
		" where  REG_nrohclinica  = ?mnrohclin " ,"mwkbuspacie")
	if reccount( "mwkbuspacie")>0
		go bott
		mnr   =REG_nroregistrac 
		select  cons1015
		replace nroreg with mnr
	endif
endscan



select  protos
set step on
do while !eof()
	mprot = protos.protocolo
	requery('tabam')
	if reccount( "tabam")>0
		mnr  = tabam.REG_nrohclinica
		select  protos
		replace hc with mnr
	endif
	select  protos
	skip 1
enddo