
set step on

For mves = 1 to 29

	Do case
	
	Case mves = 1

		*
		* Frecuencia respiratoria
		*
		Dimension vdat[5], vdatb[5]
		mgrp = 1
		mcpo = 'FT_frecResp'

		vdat[01]='Mayor a 29'
		vdat[02]='10 a 29'
		vdat[03]='6 a 9'
		vdat[04]='1 a 5'
		vdat[05]='0'						

		vdatb[01]=4
		vdatb[02]=3
		vdatb[03]=2
		vdatb[04]=1
		vdatb[05]=0
		
	Case mves = 2
		*
		* Tensión arterial sistólica
		*
		Dimension vdat[2]
		mgrp = 2
		mcpo = 'FT_tas'

		vdat[01]='Mayor a 89'
		vdat[02]='76 a 89'
		vdat[03]='50 a 75'
		vdat[04]='1 a 49'
		vdat[05]='0'						

		vdatb[01]=4
		vdatb[02]=3
		vdatb[03]=2
		vdatb[04]=1
		vdatb[05]=0		

	Case mves = 3
		*
		* Antecedentes Traumáticos Personales
		*
		Dimension vdat[4],vdatb[4]
		mgrp = 3
		mcpo = 'FT_antTrauEsp'
		
		vdat[1]='No Tiene'
		vdat[2]='Consulta'
		vdat[3]='Internado'
		vdat[4]='No Sabe/No Contesta'
		
		store 0 to vdatb
		
	Case mves = 4
		*
		* Tipos
		*
		Dimension vdat[9],vdatb[9]
		mgrp = 4
		mcpo = 'FT_tipoTrau'
		
		vdat[1]='Sin datos'
		vdat[2]='Romo'
		vdat[3]='Penetrante H.A.F.'
		vdat[4]='Penetrante H.A.B.'
		vdat[5]='Penetrante Otros'
		vdat[6]='Mixto'
		vdat[7]='Aplastamiento'
		vdat[8]='Ahorcamiento'
		vdat[9]='Otro'
		
		store 0 to vdatb

	Case mves = 5
		*
		* Circustancia
		*
		Dimension vdat[9],vdatb[9]
		mgrp = 5
		mcpo = 'FT_circunst'
		
		vdat[1]='Sin datos'
		vdat[2]='Colisión Vía Pública'
		vdat[3]='Asalto'
		vdat[4]='Agresión Interpersonal'
		vdat[5]='Suicidio'
		vdat[6]='Deporte'
		vdat[7]='Laboral'
		vdat[8]='Abuso'
		vdat[9]='Otro'
		
		store 0 to vdatb

	Case mves = 6
		*
		* Mecanismo
		*
		Dimension vdat[16],vdatb[16]
		mgrp = 6
		mcpo = 'FT_mecanismo'
		
		vdat[01]='Sin datos'
		vdat[02]='Colisión Vehicular'
		vdat[03]='Caída en el mismo nivel'
		vdat[04]='Caída de un nivel a otro'
		vdat[05]='Expo. a fuerzas mecánicas inanimadas'
		vdat[06]='Expo. a fuerzas mecánicas animadas'
		vdat[07]='Ahogamiento y sumergimiento accidentales'
		vdat[08]='Otros incidentes que obstruyen la respiración'
		vdat[09]='Expo. a cte. eléct., radiación y temper., y presión del aire'
		vdat[10]='Expo. al humo, fuego y llamas'
		vdat[11]='Contacto con calor y sustancias calientes'
		vdat[12]='Contacto traumático con animales y plantas venenosos'
		vdat[13]='Expo. a fuerzas de la naturaleza'
		vdat[14]='Envenenamiento por Expo. a sustancias nocivas'
		vdat[15]='Exceso de esfuerzo, viajes y privación'
		vdat[16]='Expo. a otros factores'
		
		store 0 to vdatb

	Case mves = 7
		*
		* Condicion
		*
		Dimension vdat[7],vdatb[7]
		mgrp = 7
		mcpo = 'FT_condicion'
		
		vdat[01]='Sin datos'
		vdat[02]='Peatón'
		vdat[03]='Conductor'
		vdat[04]='Pasajero'
		vdat[05]='Viaja fuera de vehículo'
		vdat[06]='Ciclista'
		vdat[07]='Motociclista'
		
		store 0 to vdatb

	Case mves = 8
		*
		* Si pasajero
		*
		Dimension vdat[5], vdatb[5]
		mgrp = 8
		mcpo = 'FT_pasajero'

		vdat[01]='No corresponde'
		vdat[02]='Asiento delantero'
		vdat[03]='Asiento trasero'
		vdat[04]='Otro'
		vdat[05]='Sin datos'
		
		store 0 to vdatb

	Case mves = 9
		*
		* Tipo incidente
		*
		Dimension vdat[9],vdatb[9]
		mgrp = 9
		mcpo = 'FT_tipoinci'

		vdat[01]='Sin datos'
		vdat[02]='Caída de vehículo'
		vdat[03]='Colisión dos vehículos'
		vdat[04]='Vuelco'
		vdat[05]='Colisión y vuelco'
		vdat[06]='Atropellamiento'
		vdat[07]='Choque con objeto fijo'
		vdat[08]='Colisión con animal'
		vdat[09]='Otro'
		
 		store 0 to vdatb

	Case mves = 10

		*
		* 1er Vehículo
		*
		Dimension vdat[12], vdatb[12]
		mgrp = 10
		mcpo = 'FT_privehicu'

		vdat[01]='Sin datos'
		vdat[02]='Ninguno'
		vdat[03]='Bicicleta'
		vdat[04]='Moto/motociclo'
		vdat[05]='Moto 3 ruedas'
		vdat[06]='Auto'
		vdat[07]='Camioneta'
		vdat[08]='T. pesado'
		vdat[09]='Omnibus'
		vdat[10]='Carro/animal'
		vdat[11]='Tren'
		vdat[12]='Otro'
		
		store 0 to vdatb

	Case mves = 11
		*
		* 2do Vehículo
		*
		Dimension vdat[12], vdatb[12]
		mgrp = 11
		mcpo = 'FT_segvehicu'

		vdat[01]='Sin datos'
		vdat[02]='Ninguno'
		vdat[03]='Bicicleta'
		vdat[04]='Moto/motociclo'
		vdat[05]='Moto 3 ruedas'
		vdat[06]='Auto'
		vdat[07]='Camioneta'
		vdat[08]='T. pesado'
		vdat[09]='Omnibus'
		vdat[10]='Carro/animal'
		vdat[11]='Tren'
		vdat[12]='Otro'
		
		store 0 to vdatb

	Case mves = 12

		*
		* Proteccion
		*
		Dimension vdat[10], vdatb[10]
		mgrp = 12
		mcpo = 'FT_proteccion'

		vdat[01]='Sin datos'
		vdat[02]='Ninguna'
		vdat[03]='Casco'
		vdat[04]='Cinturón Inercial'
		vdat[05]='Cinturón No Inercial'
		vdat[06]='Airbag Frontal'
		vdat[07]='Airbag Lateral'
		vdat[08]='Protección Auditiva'
		vdat[09]='Protección Ocular'
		vdat[10]='Protección Lumbar'
		
		store 0 to vdatb

	Case mves = 13
		*
		* Lugar del incidente
		*
		Dimension vdat[11], vdatb[11]
		mgrp = 13
		mcpo = 'FT_lugarinc'

		vdat[01]='Sin datos'
		vdat[02]='Calle'
		vdat[03]='Ruta'
		vdat[04]='Lugar de recreación'
		vdat[05]='Casa'
		vdat[06]='Institución educativa'
		vdat[07]='Trabajo'
		vdat[08]='Agua dulce (Pileta, Río, Lago)'
		vdat[09]='Mar'
		vdat[10]='Montaña'
		vdat[11]='Otro'
		
		store 0 to vdatb

	Case mves = 14

		*
		* Ambiente
		*
		Dimension vdat[3], vdatb[3]
		mgrp = 14
		mcpo = 'FT_ambiente'

		vdat[01]='Sin datos'
		vdat[02]='Rural'
		vdat[03]='Urbano'
		
		store 0 to vdatb

	Case mves = 15

		*
		* Atendido por
		*
		Dimension vdat[5], vdatb[5]
		mgrp = 15
		mcpo = 'FT_atendido'

		vdat[01]='Sin datos'
		vdat[02]='Enfermero'
		vdat[03]='Médico'
		vdat[04]='Familiar, Amigo'
		vdat[05]='Otro'
		
		store 0 to vdatb

	Case mves = 16
		*
		* Operador
		*
		Dimension vdat[3], vdatb[3]
		mgrp = 16
		mcpo = 'FT_operador'

		vdat[01]='Sin datos'
		vdat[02]='Entrenado'
		vdat[03]='No Entrenado'
		
		store 0 to vdatb

	Case mves = 17
		*
		* Estado al ingreso
		*
		Dimension vdat[3], vdatb[3]
		mgrp = 17
		mcpo = 'FT_estadoing'

		vdat[01]='Vivo al ingreso'
		vdat[02]='Muerto al Ingreso con Reanimación Exitosa'
		vdat[03]='Muerto al Ingreso con Reanimación Fallida'
		
		store 0 to vdatb

	Case mves = 18
		*
		* Lugar de registro de la temperatura
		*
		Dimension vdat[5], vdatb[5]
		mgrp = 18
		mcpo = 'FT_lugartemp'

		vdat[01]='Sin datos'
		vdat[02]='Esofágica'
		vdat[03]='Conducto auditivo externo'
		vdat[04]='Rectal'
		vdat[05]='Axilar'
		
		store 0 to vdatb

	Case mves = 19

		*
		* Respiración
		*
		Dimension vdat[5], vdatb[5]
		mgrp = 19
		mcpo = 'FT_respira'

		vdat[01]='Sin datos'
		vdat[02]='Normal'
		vdat[03]='Tiraje'
		vdat[04]='Ausente'
		vdat[05]='No corresponde'
		
		store 0 to vdatb

	Case mves = 20

		*
		* Apertura Ocultar
		*
		Dimension vdat[4], vdatb[4]
		mgrp = 20
		mcpo = 'FT_aperOcular'

		vdat[01]='Nula (Dolor)'
		vdat[02]='Por Dolor'
		vdat[03]='Por Orden'
		vdat[04]='Espontanea'
		
		store 0 to vdatb


	Case mves = 21

		*
		* Respuesta Verbal
		*
		Dimension vdat[5], vdatb[5]
		mgrp = 21
		mcpo = 'FT_respVerbal'

		vdat[01]='Nula (Dolor)'
		vdat[02]='Sonidos'
		vdat[03]='Palabras'
		vdat[04]='Desorientada'
		vdat[05]='Orientada'
		
		store 0 to vdatb

	Case mves = 22
		*
		* Mejor Respuesta Motora
		*
		Dimension vdat[6], vdatb[6]
		mgrp = 22
		mcpo = 'FT_respMotora'

		vdat[01]='Flaccidez'
		vdat[02]='Extensión anormal al dolor'
		vdat[03]='Flexión anormal al dolor'
		vdat[04]='Retirada (Dolor)'
		vdat[05]='Localiza (Dolor)'
		vdat[06]='Obedece Orden'
		
		store 0 to vdatb

	Case mves = 23

		*
		* Lesion respiratoria
		*
		Dimension vdat[7], vdatb[7]
		mgrp = 23
		mcpo = 'FT_lesionresp'

		vdat[01]='Ninguna'
		vdat[02]='Dolor torácico: hallazgos mínimos'
		vdat[03]='Contusión pared torácica: FX simple costal o esternal'
		vdat[04]='FX 1º costilla o múltiple, hemotórax, neumotórax'
		vdat[05]='Herida abierta, neumotórax a tensión, volet o contusión pulmonar unilateral'
		vdat[06]='IRA, aspiración, volet o contusión pulmonar bilateral, laceración diafragmática'
		vdat[07]='Lesión sin posibilidad de sobrevida'
		
		store 0 to vdatb

	Case mves = 24

		*
		* Lesion abdominal
		*
		Dimension vdat[7], vdatb[7]
		mgrp = 24
		mcpo = 'FT_lesionabdo'

		vdat[01]='Ninguna'
		vdat[02]='Sensibilidad moderada pared abdominal o flancos con signos peritoneales'
		vdat[03]='FX costal 7-12, dolor abdominal moderado'
		vdat[04]='Una lesión <: hepática, intestino delgado, bazo, riñón, páncreas o uréter'
		vdat[05]='Dos lesiones >: rotura hepática, vejiga, páncreas, duodeno o colon'
		vdat[06]='Dos lesiones severas: lesión por aplastamiento hígado, lesión vascular'
		vdat[07]='Lesión sin posibilidad de sobrevida'
		
		store 0 to vdatb

	Case mves = 25

		*
		* Lesion sistema nervioso
		*
		Dimension vdat[7], vdatb[7]
		mgrp = 25
		mcpo = 'FT_lesionNerv'

		* Deprimida
		
		vdat[01]='Ninguna'
		vdat[02]='Trauma cerrado sin FX ni pérdida de consc.'
		vdat[03]='FX craneal, una FX facial, pérdida de consc., GCS 15'
		vdat[04]='Lesión cerebral, FX craneal depr., FX facial múltiple, pérdida de consc., GCS <15'
		vdat[05]='Pérdida de consciencia, GCS <6, FX cervical con paraplejía'
		vdat[06]='Coma >24 h, FX cervical con tetraplejía'
		vdat[07]='Coma, pupilas dilatadas y fijas'
		
		store 0 to vdatb

	Case mves = 26
		*
		* Lesión Musculoesquelética
		*
		Dimension vdat[7], vdatb[7]
		mgrp = 26
		mcpo = 'FT_lesionMusc'

		vdat[01]='Ninguna'
		vdat[02]='Esguince o FX <, no afectación de huesos largos'
		vdat[03]='FX simple: húmero, clavícula, radio, cúbito. tibia, peroné'
		vdat[04]='FX múltiples: simple de fémur, pélvica estable, luxación >'
		vdat[05]='Dos FX >: compleja de fémur, aplast. de un miembro o amput., FX pélvica inest.'
		vdat[06]='Dos FX severas: FX > múltiples'
		vdat[07]='Lesión sin posibilidad de sobrevida'
		
		store 0 to vdatb


	Case mves = 27
		*
		* Lesión Cardiovascular
		*
		Dimension vdat[7], vdatb[7]
		mgrp = 27
		mcpo = 'FT_lesionCardio'

		vdat[01]='Ninguna'
		vdat[02]='Pérdida de sangre 10%'
		vdat[03]='Pérdida de sangre 20-30%, contusión miocárdica'
		vdat[04]='Pérdida de sangre 20-30%, taponamiento con TAS normal'
		vdat[05]='Pérdida de sangre 20-30%, taponamiento con TAS <80'
		vdat[06]='Pérdida de sangre 40-50%, agitación'
		vdat[07]='Pérdida de sangre >50%, coma, PCR'
		
		store 0 to vdatb


	Case mves = 28

		*
		* Lesión de la Piel
		*
		Dimension vdat[7], vdatb[7]
		mgrp = 28
		mcpo = 'FT_lesionPiel'

		vdat[01]='Ninguna'
		vdat[02]='Quemadura <5%, abrasiones, laceraciones'
		vdat[03]='Quemadura 5-15%, contusiones extensas, avulsiones'
		vdat[04]='Quemadura 15-30%, avulsiones severas'
		vdat[05]='Quemadura 30-45%'
		vdat[06]='Quemadura 45-60%'
		vdat[07]='Quemadura >60%'
		
		store 0 to vdatb

	Case mves = 29

		*
		* Estado al egreso
		*
		Dimension vdat[2], vdatb[2]
		mgrp = 29
		mcpo = 'FT_estadoEgr'

		vdat[01]='Vivo'
		vdat[02]='Muerto'
		
		store 0 to vdatb

	Endcase

	For mi = 1 to ALEN(vdat)

		sqlexec(mcon1,"insert into TabFichaTrauVal "+;
			"(FTV_agrupa, FTV_campo, FTV_descripcion, FTV_valor)"+;
			" values "+;
			"(?mgrp, ?mcpo, ?vdat[mi], ?vdatb[mi])")

	Next mi
	Release vdat, vdatb

Next mves
