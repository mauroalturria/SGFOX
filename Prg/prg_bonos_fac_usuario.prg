************************
* AUTOR: Claudia Antoniow
************************
* Fecha : 22/01/2004
************************
*Fecha Ultima Modif: 22/01/2004
*******************************
parameters vr_dfecha, vr_dfecha2,vr_usuario,vr_group

vr_fecha   = datetime(year(vr_dfecha),month(vr_dfecha),day(vr_dfecha),0,0,0)
vr_fecha2  = datetime(year(vr_dfecha2),month(vr_dfecha2),day(vr_dfecha2),23,59,59)

if vr_usuario =''
	mret =sqlexec(mcon1," SELECT a.tipobono,b.denominacion,a.bonodesde, "+;
		" a.bonohasta, a.cantidad, "+;
		" a.valorUni, a.Importeb,a.usuario,a.fechagraba, a.id "+;
		" FROM tabdetallefac as a, tabbono as b " +;
		" WHERE b.id= a.tipobono "+;
		" and a.fechagraba between ?vr_fecha and ?vr_fecha2 " +;
		" UNION "+;
		" SELECT h.tipobono,c.denominacion,h.bonodesde, "+;
		" h.bonohasta, h.cantidad, "+;
		" h.valorUni, h.Importeb,h.usuario,h.fechagraba,h.id "+;
		" FROM tabdetallefachist as h, tabbono as c " +;
		" WHERE c.id= h.tipobono "+;
		" and h.fechagraba between ?vr_fecha and ?vr_fecha2 " ,"MWKFActBonos")
else
	mret =sqlexec(mcon1," SELECT a.tipobono,b.denominacion,a.bonodesde, "+;
		" a.bonohasta, a.cantidad, "+;
		" a.valorUni, a.Importeb, a.usuario, a.fechagraba "+;
		" FROM tabdetallefac as a, tabbono as b " +;
		" WHERE b.id= a.tipobono and a.usuario = ?vr_usuario "+;
		" and a.fechagraba between ?vr_fecha and ?vr_fecha2 " +;
		" UNION "+;
		" SELECT h.tipobono,c.denominacion,h.bonodesde, "+;
		" h.bonohasta, h.cantidad, "+;
		" h.valorUni, h.Importeb, h.usuario, h.fechagraba "+;
		" FROM tabdetallefachist as h, tabbono as c " +;
		" WHERE c.id= h.tipobono and h.usuario = ?vr_usuario "+;
		" and h.fechagraba between ?vr_fecha and ?vr_fecha2 ","MWKFActBonos")
endif
if mret < 0
	messagebox('NO pudo resolverlo','Cache')
	do prg_cancelo
else
	create cursor MwkBonoVen;
		(tipobono n(3), denominacion c(50), bonodesde n(10), bonohasta n(10), ;
		cantidad n(6), valorUni n(3,2), Importeb n(6,2), usuario c(30), fechagraba t,fechacte D)


	if vr_usuario =''
	do case
			case vr_group = 0
				sele * from MWKFActBonos where !isnull(bonodesde);
					order by tipobono,bonodesde  ;
					into cursor MWKFActBono
			case vr_group = 1
				sele *,ttod(fechagraba) as fechacte from MWKFActBonos where !isnull(bonodesde);
					order by usuario,fechacte,tipobono,bonodesde  ;
					into cursor MWKFActBono
		endcase
	else
		do case
			case vr_group = 0
				sele * from MWKFActBonos where !isnull(bonodesde);
					order by usuario,tipobono,bonodesde  ;
					into cursor MWKFActBono
			case vr_group = 1
				sele *,ttod(fechagraba) as fechacte from MWKFActBonos where !isnull(bonodesde);
					order by usuario,fechacte,tipobono,bonodesde  ;
					into cursor MWKFActBono
		endcase
	endif
	go top
	do while !eof('MWKFActBono')
		mimpot = 0
		mcantt = 0

		if vr_usuario <>'' or vr_group = 1
			musuario = MWKFActBono.usuario
			mimpo     = 0
			mcant     = 0
			mnrocon   = 0
			do while MWKFActBono.usuario = musuario and !eof('MWKFActBono')
				if vr_group = 0
					mtipobono =MWKFActBono.tipobono
					mdeno     =allt(MWKFActBono.denominacion)
					mvalUni   =MWKFActBono.valorUni
					mnrodesde = nvl(MWKFActBono.bonodesde,0)
					mnrohasta = nvl(MWKFActBono.bonodesde,0)
					mfechaGra =MWKFActBono.fechagraba
					musua     =allt(MWKFActBono.usuario)

					do while MWKFActBono.tipobono = mtipobono

						mnrocon  = consecutivos(mnrohasta,nvl(MWKFActBono.bonodesde,0))
						mbonosig = nvl(MWKFActBono.bonodesde,0)

						do while mnrocon = mbonosig

							mnrohasta = nvl(MWKFActBono.bonohasta,0)
							mimpo     = mimpo + MWKFActBono.importeb
							mcant     = mcant + MWKFActBono.cantidad

							skip in MWKFActBono
							if eof('MWKFActBono')
								exit
							else
								if  MWKFActBono.tipobono = mtipobono
									mnrocon =consecutivos(mnrohasta,nvl(MWKFActBono.bonodesde,0))
									mbonosig = nvl(MWKFActBono.bonodesde,0)
									loop
								else
									exit
								endif
							endif
						enddo
						insert into MwkBonoVen values(mtipobono,mdeno,mnrodesde,;
							mnrohasta,mcant,mvalUni,mimpo,musua,mfechaGra,ttod(mfechaGra))
						mnrocon   =0
						mimpo     =0
						mcant     =0
						sele MWKFActBono
						mtipobono =MWKFActBono.tipobono
						mdeno     =allt(MWKFActBono.denominacion)
						mvalUni   =MWKFActBono.valorUni
						mnrodesde = nvl(MWKFActBono.bonodesde,0)
						mnrohasta = nvl(MWKFActBono.bonodesde,0)
						mfechaGra =MWKFActBono.fechagraba
						musua     =allt(MWKFActBono.usuario)

						if eof('MWKFActBono')
							exit
						else
							loop
						endif

					enddo
				else
					mtipobono =MWKFActBono.tipobono
					mdeno     =allt(MWKFActBono.denominacion)
					mfechaGra =MWKFActBono.fechagraba
					mvalUni = MWKFActBono.valorUni
					musua     =allt(MWKFActBono.usuario)
					midia = fechacte
					do while  midia = fechacte and MWKFActBono.usuario = musuario and !eof('MWKFActBono')
						do while  midia = fechacte and  MWKFActBono.usuario = musuario and !eof('MWKFActBono') and mtipobono =MWKFActBono.tipobono
							mimpo     = mimpo + MWKFActBono.importeb
							mcant     = mcant + MWKFActBono.cantidad
							skip in MWKFActBono
							sele MWKFActBono

						enddo
						insert into MwkBonoVen values(mtipobono,mdeno,0,0,mcant,mvalUni,mimpo,musua,midia,midia )
						mvalUni = MWKFActBono.valorUni
						mtipobono = MWKFActBono.tipobono
						mdeno     = allt(MWKFActBono.denominacion)
						mfechaGra = MWKFActBono.fechagraba
						musua     = allt(MWKFActBono.usuario)
						midia = fechacte
						mimpo     = 0
						mcant     = 0
						sele MWKFActBono

					enddo
					insert into MwkBonoVen values(mtipobono,mdeno,0,0,mcant,mvalUni,mimpo,musua,midia,midia )
					mtipobono = MWKFActBono.tipobono
					mvalUni = MWKFActBono.valorUni
					mdeno     = allt(MWKFActBono.denominacion)
					mfechaGra = MWKFActBono.fechagraba
					musua     = allt(MWKFActBono.usuario)
					midia = fechacte
					mimpo     =0
					mcant     =0
					sele MWKFActBono

				endif
			enddo
		else
* POR BONO SOLAMENTE
			sele MWKFActBono
			go top


			mnrocon   = 0
			mdeno     =allt(MWKFActBono.denominacion)
			mvalUni   =MWKFActBono.valorUni
			mimpo     = 0
			mcant     = 0
			mnrodesde = nvl(MWKFActBono.bonodesde,0)
			mnrohasta = nvl(MWKFActBono.bonodesde,0)
			mfechaGra =MWKFActBono.fechagraba
			mtipobono =MWKFActBono.tipobono

			do while MWKFActBono.tipobono = mtipobono

				mnrocon  = consecutivos(mnrohasta,nvl(MWKFActBono.bonodesde,0))
				mbonosig = nvl(MWKFActBono.bonodesde,0)

				do while mnrocon = mbonosig

					mnrohasta = nvl(MWKFActBono.bonohasta,0)
					mimpo     = mimpo + MWKFActBono.importeb
					mcant     = mcant + MWKFActBono.cantidad

					skip in MWKFActBono
					if eof('MWKFActBono')
						exit
					else
						if  MWKFActBono.tipobono = mtipobono
							mnrocon =consecutivos(mnrohasta,nvl(MWKFActBono.bonodesde,0))
							mbonosig = nvl(MWKFActBono.bonodesde,0)
							loop
						else
							exit
						endif
					endif
				enddo

				insert into MwkBonoVen values(mtipobono,mdeno,mnrodesde,mnrohasta;
					,mcant,mvalUni,mimpo,'TODOS',datetime(),ttod(mfechaGra))

				sele MWKFActBono
				mnrocon   =0
				mtipobono =MWKFActBono.tipobono
				mdeno     =allt(MWKFActBono.denominacion)
				mvalUni   =MWKFActBono.valorUni
				mimpo     =0
				mcant     =0
				mnrodesde = nvl(MWKFActBono.bonodesde,0)
				mnrohasta = nvl(MWKFActBono.bonodesde,0)
				mfechaGra =MWKFActBono.fechagraba
*	musua     =ALLT(MWKFActBono.usuario)

				if eof('MWKFActBono')
					exit
				else
					loop
				endif

			enddo

		endif
	enddo
endif


function Consecutivos
	parameter vr_nroAcum, vr_nroComp
	nroAcum1 = vr_nroAcum + 1

	if nroAcum1 = vr_nroComp
		return nroAcum1
	else
		if vr_nroAcum= vr_nroComp
			return vr_nroComp
		else
			return 0
		endif
	endif

endfunc
