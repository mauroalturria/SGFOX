
Public mfecfin
Select * From prestadores Where cuil In (Select cuit From franjamk) And !Inlist(Id,7547,6770) Into Cursor presta
Select presta
Scan
	mid = presta.Id
	micuil = presta.cuil
	Update franjamk Set codmed = mid,regis=Recno() Where cuit = micuil

Endscan

Update franjamk Set FECVIGEND = FECVIGEND -1
Update franjamk Set FECVIGENh = FECVIGENh +1 Where  FECVIGENh <>Ctod("01/01/2100")
Update franjamk Set hhmmhas =Val(Strtran(Left(hmhas,5),":",""))
Update franjamk Set hhmmdes =Val(Strtran(Left(hmdes,5),":",""))
mfecfin = Ctod("01/01/2100")

Select * From franja,franjamk;
	WHERE  franjamk.codmed =  franja.codmed ;
	AND    franjamk.diasem = franja.diasem ;
	AND    franjamk.hhmmdes = franja.hhmmdes ;
	AND    franjamk.hhmmhas = franja.hhmmhas ;
	AND  franjamk.fecvigenh = franja.fecvigenh ;
	AND  franjamk.fecvigend = franja.fecvigend;
	into Cursor bienfrmk


Select * From franjamk Where franjamk.fecvigenh = mfecfin And  regis  Not In (Select regis From bienfrmk) Into Cursor sobrafran
Select * From franja,franjamk;
	WHERE  franjamk.codmed =  franja.codmed ;
	AND    franjamk.diasem = franja.diasem ;
	AND    franjamk.hhmmdes = franja.hhmmdes ;
	AND    franjamk.hhmmhas = franja.hhmmhas ;
	AND  franjamk.fecvigenh < mfecfin ;
	AND franjamk.fecvigenh  = franja.fecvigenh;
	AND franjamk.fecvigend  = franja.fecvigend;
	into Cursor bienfrmktemp


Select * From bienfrmk Where FECVIGEND_a <> FECVIGEND_b Into Cursor diffr
Select diffr
Set Step On
Scan

Endscan


Set Step On
Select * From franja,medpresta;
	WHERE  Medpresta.codmed =  franja.codmed ;
	AND    Medpresta.diasem = franja.diasem ;
	AND    Medpresta.hhmmdes = franja.hhmmdes ;
	AND    Medpresta.hhmmhas = franja.hhmmhas ;
	AND Medpresta.fecvigenh <= franja.fecvigenh;
	AND Medpresta.fecvigend >= franja.fecvigend;
	into Cursor bienbien
Set Step On
Select * From franja Where Id Not In (Select id_a From bienbien) Into Cursor sobrafran
Select * From Medpresta Where Id Not In (Select id_b From bienbien) Into Cursor sobramedp
Select  * From franjamk,bienbien;
	WHERE  franjamk.codmed =  bienbien.codmed_a ;
	AND    franjamk.diasem = bienbien.diasem_a ;
	AND    franjamk.hhmmdes = bienbien.hhmmdes_a ;
	AND    franjamk.hhmmhas = bienbien.hhmmhas_a ;
	AND franjamk.fhasta  = bienbien.fecvigenh_a;
	AND franjamk.fdesde  = bienbien.fecvigend_a;
	into Cursor bienmk


Select * From franja  Where Isnull(tpf_filtro) And Transform(codmed,"@L 9999")+Transform(diasem,"@L 9999")+Transform(hhmmdes,"@L 9999")+Dtos(fecvigenh)+Dtos(fecvigend);
	In (Select Transform(codmed,"@L 9999")+Transform(diasem,"@L 9999")+Transform(hhmmdes,"@L 9999")+Dtos(fecvigenh)+Dtos(fecvigend) From franjamk);
	order By  codmed,diasem,hhmmdes,fecvigenh Group By  codmed,diasem,hhmmdes,fecvigenh  Into Cursor estanbien

Select * From franjamk Where  Transform(codmed,"@L 9999")+Transform(diasem,"@L 9999")+Transform(hhmmdes,"@L 9999")+Dtos(fecvigenh);
	NOT In (Select Transform(codmed,"@L 9999")+Transform(diasem,"@L 9999")+Transform(hhmmdes,"@L 9999")+Dtos(fecvigenh) From franja);
	ORDER By codmed Into Cursor faltan

Select franja
Set Step On

Scan
	If !Inlist(codmed,5074,6822,6823,6824)
*Requery('franja')
		Select franja
		Requery('medprestafran')

		If medprestafran.demanda=0 And medprestafran.GeneraAgen= 0
			Update medprestafran Set cantidad = 11 WHERE NVL(cantidad,0)<> 10 &&& instit
		Endif
		If medprestafran.codserv = 1130
			Update medprestafran Set cantidad = 12  WHERE NVL(cantidad,0)<> 10  && onco
			Loop
		Endif
		mfin =  Iif(franja.fecvigend>Date(), franja.fecvigenD,Date())
		Select medprestafran
		Update medprestafran Set fecvigenh=mfin,cantidad = 13  WHERE NVL(cantidad,0)<> 10 
		Select franja
		Update franja Set fecvigenh=mfin
	Endif
Endscan
Select * From franja Order  By codmed,diasem,hhmmdes,hhmmhas,imparchivo ,fecvigend  Into Cursor varios
Select * From franja Group By codmed,diasem,hhmmdes,hhmmhas,fecvigend Having Count(Id)>1 Into Cursor varios
Select * From franja  Where  Transform(codmed,"@L 9999")+Transform(diasem,"@L 9999")+Transform(hhmmdes,"@L 9999") ;
	In (Select Transform(codmed,"@L 9999")+Transform(diasem,"@L 9999")+Transform(hhmmdes,"@L 9999") From varios);
	order By  Select * From franja Group By codmed,diasem,hhmmdes,hhmmhas,fecvigend Having Count(Id)>1 Into Cursor varios
Select * From franja  Where  Transform(codmed,"@L 9999")+Transform(diasem,"@L 9999")+Transform(hhmmdes,"@L 9999") ;
	In (Select Transform(codmed,"@L 9999")+Transform(diasem,"@L 9999")+Transform(hhmmdes,"@L 9999") From varios) And fecvigend<fecvigenh;
	order By  codmed,diasem,hhmmdes,hhmmhas  Into Cursor masdeuno
Browse Last
Select *,Min(fecvigend) As fechades,Max(fecvigenh) As horahas From masdeuno Group By codmed,diasem,hhmmdes,hhmmhas Into Cursor vale
Select * From masdeuno Where imparchivo = 1 Into Cursor abajar
Select * From franja Where imparchivo = 4 Into Cursor franjnaok
Select franjnaok
Scan
	If !Inlist(codmed,5074,6822,6823,6824)
*!*			Requery('franja')
		Select franjnaok
		Requery('medprestafran')
		Select medprestafran
		Update medprestafran Set cantidad = 10
	Else
		Set Step On
	Endif
	Select franjnaok
Endscan

Select * From medpresta Group By codmed,diasem,hhmmdes,hhmmhas,fecvigenh,codprest Having Count(Id)>1 Into Cursor variosm
Select * From medpresta Where  Transform(codmed,"@L 9999")+Transform(codprest,"@L 999999999")+Transform(diasem,"@L 9999");
	+Transform(hhmmdes,"@L 9999")+Dtos(fecvigenh) ;
	In (Select Transform(codmed,"@L 9999")+Transform(codprest,"@L 999999999")+Transform(diasem,"@L 9999");
	+Transform(hhmmdes,"@L 9999")+Dtos(fecvigenh) From variosm) And fecvigend<fecvigenh;
	order By  codmed,diasem,hhmmdes,hhmmhas  Into Cursor masdeunom
Select * From masdeunom  Group By codmed,diasem,hhmmdes,hhmmhas,fecvigenh,codprest  Into Cursor abajarm

Update medpresta Set fecvigenh= fecvigend Where Id In (Select Id From abajarm)
