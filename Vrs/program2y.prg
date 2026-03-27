PROCEDURE cargagrid
************************************************
PROCEDURE cmdfind.Click
With Thisform
	If mwkusuario.idusuario = 'CFUNES'
		Set step on
	Endif
	.lhistorial = .t.
*.cmdexcel.enabled = .f.
	.timer1.Enabled = .F.
*.pg.pgCatalogo.txtcant.value  = 0
	.pg.pgCatalogo.txtcant.Value = 0
	.pg.pgcambios.txtcant.value = 0


	.pg.pgCatalogo.label3.Caption ='Cantidad De Personas Atendidas:'
	do sp_busco_socio  With 2,,'mwkAtendidos',.txtfechad.Value,.txtfechah.Value
*	select * from mwkAtendidos where

	Sele mwkAtendidos
	Go Top
	.cargagrid('mwkAtendidos',3, .corden)
	.mcursor = 'mwkAtendidos'
	.mformu  = 3
	If .pg.ActivePage < 3
		.cmdundo.Enabled = .T.
		.pg.pgCatalogo.SetFocus()
	Endif
	.timer1.Reset()
*	.timer1.Enabled = .t.

Endwith

ENDPROC
PROCEDURE Pg.PgCatalogo.Deactivate
this.FontBold = .f.
ENDPROC
PROCEDURE Pg.PgCatalogo.Activate
this.FontBold = .t.
do sp_busco_socio  With 1,,'mwkLLegadas', mhoy, mhoy
With Thisform
	.cmdsave.Enabled = .F.
	.cmdmodif.Enabled = .F.
	.cargagrid(1,'mwkLLegadas', 1, .corden)
	.cargagrid(2,'mwkLLegadas', 1, .corden)
	.cmdundo.Enabled = Iif(.mformu=3,.T.,.F.)
	.cmdfind.Enabled = Iif(.mformu=3,.F.,.T.)
Endwith

ENDPROC
PROCEDURE Pg.PGCambios.Activate
this.FontBold = .t.

ENDPROC
PROCEDURE Pg.PGCambios.Deactivate
this.FontBold = .f.

ENDPROC
PROCEDURE Pg.PgDatos.Activate
this.FontBold = .f.
with thisform
	with .pg.Pgdatos
		.cbomotivos.setfocus
	endwith	
	if .mformu = 3
		.cmdfind.enabled = .t.
	endif
endwith
ENDPROC
PROCEDURE Pg.PgDatos.Deactivate
this.FontBold = .f.
ENDPROC
cbosectores

PROCEDURE Click
With ThisForm
*!*	100112
	.cbosectores.Enabled = This.Value
	IF this.Value = 1
		.cbosectores.SetFocus()
	endif
Endwith 
ENDPROC
