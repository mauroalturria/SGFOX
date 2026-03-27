*!*	Médico de Cabecera

*!*	GetMedCabe(ENT,NRODOC,FECHA) ; Obtiene medico de cabecera en funcion de entidad-nro.documento
*!*   Tabla zabpadgrupofam
*!*	devuelve:
*!*	P0 := Status: "" o 0 -> Ok
*!*	P1 := GRUPOFAM
*!*	P2 := CUIT
*!*	P3 := FDES
*!*	P4 := FHAS
*!*	Si el grupo familiar existe pero no tiene medico de cabecera asociado, devuelve solo P0 y P1

*!*	ActuMedCabe(ENT,NRODOC,CUIT,FDES,FHAS); Actualiza medico de cabecera en funcion de entidad-nro.documento
*!*   Tabla zabpadgrupofam
*!*	Si no se envía FHAS, asume 01/01/2100
*!*	Si se envía una fecha posterios a la existente, genera un nuevo registro y modifica la fecha hasta del registro anterior
*!*	devuelve:
*!*	P0 := Status: "" o 0 -> Ok

*!*	GrupoFam(ENT,NRODOC) ; Obtiene grupo familiar en funcion a entidad-nro.documento
*!*   Tabla padcabe
*!*	P0 := Status: "" o 0 -> Ok
*!*	P1 := GRUPOFAM

Parameters entidad,dni,codmed,tipo,espe

Create Cursor mwkdatmf (nombre c(100), telefono c(20), Mail c(20))
Create Cursor mwkcuil (cuil c(20))

*!*	 entidad = 948
*!*	 codmed = 4224
*!*	 entidad = 100
*!*	 dni = 2900395
*!*	 dni = 12345678
*!*	 dni = 25251068
*!*    dni = 21738726
*!*	 fecha = "01/05/2021"
*!*	 tipo = 3
*!*	 espe = 'MFAM'
*!*   mfecha = fecha

mcuilmed = ''
mentidad = Alltrim(Str(entidad))
mdni = Alltrim(Str(dni))
mcodmed = codmed
mfecha = Dtoc(sp_busco_fecha_serv('DD'))
mespe = espe && MFAM

lhaymedfam = .F.
lhaygrupofam = .F.
lhaydatos = .F.

lhaygrupofam = medicocab (3,mentidad,mdni,mfecha,mcuilmed)

If lhaygrupofam && existe en el grupo familiar
	lhaymedfam = medicocab (1,mentidad,mdni,mfecha,mcuilmed)
	If lhaymedfam
		lccuilmedact = medicoactual (mcodmed)
		mcursor = datosmedicos(Alltrim(mwkcuil.cuil))
		Select &mcursor
		If Reccount(mcursor)>0
			lhaydatos = .T.
		Else
			lhaydatos = .F.
		Endif
	Else
		If Alltrim(Upper(mespe)) = 'MFAM'
			lccuilmedact = medicoactual (mcodmed)
			medicocab (2,mentidad,mdni,mfecha,lccuilmedact)
			Use In Select('mwkcuil')
			medicocab (1,mentidad,mdni,mfecha,'')
			datosmedicos(Alltrim(mwkcuil.cuil))
			Select &mcursor
			If Reccount(mcursor)>0
				lhaydatos = .T.
			Else
				lhaydatos = .F.
			Endif
		Endif
	Endif
Else
* se graba en grupo de familia (padcabe) ?
Endif

Return lhaydatos

**********************************
* Fn. Devuelve errores
**********************************

Function decirerror (nroerror)
Do Case
Case nroerror =	438
	lcmsg = "Grupo familiar con médico de cabecera en fecha futura."
Case nroerror =	437
	lcmsg = "Error al actualizar médico de cabecera de grupo."
Case nroerror =	436
	lcmsg = "Sin médico de cabecera para ese documento."
Case nroerror =	435
	lcmsg = "Grupo familiar sin médico de cabecera."
Endcase
Messagebox(lcmsg + Chr(10) + 'Msg Tipo '+Transform(tipo),48,'Aviso')
Endfunc

**********************************
* Fn. Busca Médico Familia
**********************************

Function medicocab (tipo,mentidad,mdni,mfecha,mcuilmed)

Do Case

Case tipo = 1 && Rutina D GetMedCabe^RTN401(948,12345678,"01/05/2021")
	mimensaje="D GetMedCabe^RTN401("+ mentidad + "," + mdni + ',"' + mfecha + '")'

Case tipo = 2 && Rutina D ActuMedCabe^RTN401(948,12345678,"20-11111111-2","01/05/2021")
	mimensaje = 'D ActuMedCabe^RTN401('+ mentidad + ',' + mdni + ',"' +  mcuilmed + '","' + mfecha +'")'

Case tipo = 3 && Rutina D GrupoFam(948,12345678)
	mimensaje = 'D GrupoFam^RTN401(' + mentidad + ',' + mdni + ')'

Endcase

lcolevismerror = ''
lcolevismdato = ''

olevism = Newobject('vism','lib_olevism')
olevism.olecontrol1.MServer = Allt(mwktabcfg.OLEServer)
olevism.olecontrol1.NameSpace = Allt(mwktabcfg.olespaces)

olevism.olecontrol1.Code = mimensaje
olevism.olecontrol1.execflag = 1

lcdato1 = olevism.olecontrol1.P0 &&
lcdato2 = olevism.olecontrol1.P1 &&
lcdato3 = olevism.olecontrol1.P2 && CUIT médico
lcdato4 = olevism.olecontrol1.P3 &&
lcdato5 = olevism.olecontrol1.P4 &&

olevism.olecontrol1.MServer = ""
olevism.olecontrol1.NameSpace = ""

= prg_olevism_reset(olevism.olecontrol1)

If tipo = 1
	If Empty(lcdato1)
		Insert Into mwkcuil (cuil) Values (lcdato3)
		Return .T.
	Else
		Return .F.
	Endif
Endif

If tipo = 3
	If Empty(lcdato1)
		Return .T.
	Else
		Return .F.
	Endif
Endif

Endfunc

*************************************************
* Fn. Busca info del médico actual
*************************************************

Function medicoactual (mcodmed)
lcsql = "select * from prestadores where id = ?mcodmed"
mret = SQLExec(mcon1,lcsql,'mwkcodmed')
If Used('mwkcodmed')
	Select mwkcodmed
	Return mwkcodmed.cuil
Endif
Use In Select('mwkcodmed')
Endfunc

*************************************************
* Fn. Busca Médico y lo carga en cursor
*************************************************

Function datosmedicos(mcuilmed)
Use In Select('MwkDatMedcuitOA')
Use In Select('MwkDatMedcuit')
Do sp_busco_medico_cuit With mcuilmed
Use In Select('mwkcuil')
If Used('MwkDatMedcuit')
	mcursor = 'MwkDatMedcuit'
Endif
If Used('MwkDatMedcuitOA')
	mcursor = 'MwkDatMedcuitOA'
Endif
Select &mcursor
mape = .F.
For nvar = 1 To Fcount(mcursor)
	If Field(nvar) = 'APE'
		mape = .T.
	Endif
Endfor
If mape
	lcapemed = mcursor + '.ape'
	lcnommed = mcursor + '.nom'
	mmedico = Alltrim(&lcnommed) + ' ' + Alltrim(&lcapemed)
Else
	lcmedico = mcursor + '.nombre'
	mmedico = Alltrim(&lcmedico)
Endif
lcsexomed = mcursor + '.sexo'
mtratomed = Iif(&lcsexomed = 'F','Dra.','Dr.')
mtel = mcursor + '.telcelular'
memail = mcursor + '.email'
If Reccount(mcursor)>0
	Insert Into mwkdatmf (nombre,telefono,Mail) Values (mtratomed + ' ' + Alltrim(mmedico),Alltrim(&mtel),Alltrim(&memail))
Endif
Return mcursor
Endfunc
