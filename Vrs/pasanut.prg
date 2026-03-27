select * from tab_nut_arr into cursor colac
use dbf('colac') in 0 again alias colaciones
set step on
select colaciones
go top
select tab_nut350
do while !eof()
	select tab_nut350
	miadmi = TNP_codadmision
	skip 1
	select colaciones
	replace tnp_codadmision with miadmi
	skip 1
enddo



select colaciones
set step on
go top
do while !eof()
	miid = colaciones.id
	madmi= tnp_codadmision 

	requery('tab_nut')
	requery('tab_nut350')
	mnid = tab_nut350.id
	select TND_NroVale,TND_observa, mnid as TND_idPaciente,TND_codPrest, TND_FHoraCarga,TND_fecBaja, TND_usuario,;
		TND_Cantidad, TND_Hora from tab_nut into cursor detalle
	select vista9
	append from dbf('detalle')
	select colaciones
	skip 1
enddo
