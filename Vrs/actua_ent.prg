select entid
scan
	mcodent = ent_codent
	msigla = alltrim(ent_sigla)
	mdesco = alltrim(ent_descco)
	murl = alltrim(ent_url)
	memail = alltrim(ent_email)
	mweb = alltrim(ent_web)
	mturnos = alltrim(ent_turnos)
	mret = sqlexec(mcon1,"update entidades set ENT_desccomp = ?mdesco  , ent_email = ?memail, "+;
		"ent_sigla = ?msigla , ent_turnosweb =?mturnos, ent_url =?murl  , ent_web = ?mweb "+;
		" where ent_codent = ?mcodent ")
	if mret<1
		=aerr(eros)
		messagebox(eros(3))
		set step on
	endif
endscan
=sqldisconnect(mcon1)
