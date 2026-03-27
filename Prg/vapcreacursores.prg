

*  cursor VAPHEAD1  = 1er. row del header: Datos inherentes al vale
create cursor VapHead1 ;
	( TipoReg N(1,0), Pun N(8,0), NroVale N(8,0), SeqVerif N(3,0), SqMae N(3,0), ;
		NroAjuste N(3,0), ModoImpre N(1,0), Prioridad N(2,0), FechaSolic D, ;
		HoraSolic C(5,0), Urgencia N(1,0), IdOperador N(5,0), NomOperador C(40), ;
		IdPrstdor C(40), ;
		NomPrstdor C(40), Comentario C(250), Bono C(10), MnemoServ C(2), ;
		IdServ N(4,0), NomServ C(25), NroProtoc C(10), OrdDup c(1), MotUrg c(2)  )

*  cursor VAPHEAD2  = 2do. row del header: Datos inherentes al Paciente
create cursor VapHead2 ;
	( TipoReg N(1,0), TipoPac C(3), NroAdm C(8), NombrePac C(40), Sexo C(1), Edad N(3,0), ;
		NroHClinica C(10), CodSector C(3), NomSector C(35), Habitacion C(5), Cama C(3), ;
		CodEntidad N(6,0), NomEntidad C(45), CodContrato N(6,0), NomContrato C(45), ;
		NroAfiliado C(20), Categoria  C(1) ,NroDocumento n(12))

*  cursor VAPPRES3  = Prestaciones principales (tipo 3) (NO vales de Farmacia)
create cursor VapPres3 ;
	( TipoReg N(1,0), CodPrest N(10,0), DescPrest C(100), Cantidad N(4,0),MarcaEsp C(1),codlado c(40) )

*  cursor VAPINSU4  = Insumos principales (tipo 4) (vales de Farmacia)
create cursor VapInsu4 ;
	( TipoReg N(1,0), CodInsumo C(15), DescInsumo C(100), Cantidad N(4,0) )

*  cursor VAPPASO5  = Prestaciones Asociadas (tipo 5) (NO vales de Farmacia)
create cursor VapPAso5 ;
	( TipoReg N(1,0), CodPrest N(10,0), DescPrest C(100), Cantidad N(4,0), MarcaEsp C(1) )

*  cursor VAPIASO6  = Insumos Asociados (tipo 6) (NO vales de Farmacia)
create cursor VapIAso6 ;
	( TipoReg N(1,0), CodInsumo C(15), DescInsumo C(100), Cantidad N(4,0) )

*  cursor VAPPESP7  = Prestaciones Especiales Asociadas al VALE (tipo 7) (NO vales de Farmacia)
create cursor VapPEsp7 ;
	( TipoReg N(1,0), CodPrest N(10,0), DescPrest C(100), Cantidad N(4,0), MarcaEsp C(1) )

return

*********************************

