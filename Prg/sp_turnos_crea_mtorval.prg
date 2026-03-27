if used('VapHead1')
  use in VapHead1
endif

if used('VapHead2')
  use in VapHead2
endif

if used('VapPres3')
  use in VapPres3
endif

*  cursor VAPHEAD1  = 1er. row del header: Datos inherentes al vale
create cursor VapHead1 ;
	( TipoReg N(1,0), Pun N(8,0), NroVale N(8,0), SeqVerif N(3,0), SqMae N(3,0), ;
		NroAjuste N(3,0), ModoImpre N(1,0), Prioridad N(2,0), FechaSolic D, ;
		HoraSolic C(5,0), Urgencia N(1,0), IdOperador N(5,0), NomOperador C(40), IdPrstdor C(6), ;
		NomPrstdor C(40), Comentario C(60), Bono C(10), MnemoServ C(2), ;
		IdServ N(4,0), NomServ C(25), NroProtoc C(10), OrdDup c(1) )


*  cursor VAPHEAD2  = 2do. row del header: Datos inherentes al Paciente
create cursor VapHead2 ;
	( TipoReg N(1,0), TipoPac C(3), NroAdm C(8), NombrePac C(40), Sexo C(1), Edad N(3,0), ;
		NroHClinica C(10), CodSector C(3), NomSector C(35), Habitacion C(5), Cama C(3), ;
		CodEntidad N(6,0), NomEntidad C(45), CodContrato N(6,0), NomContrato C(45), NroAfiliado C(20) )


*  cursor VAPPRES3
create cursor VapPres3 ;
	( TipoReg N(1,0), CodPrest N(10,0), DescPrest C(40), Cantidad N(4,0),MarcaEsp C(1) )

Return



