*
* Alfa Beta - migración de arcnivos // 2020-01-22 - 2020-02-18
*
Lparameters mpath, mzzvolumen

* Set Step On

mPaso = 0

Adir(datos, mpath+"*.*", "D")

For I = 1 To Alen(datos, 1)

	If datos(I,5) = '....D'

		If datos(I,1) <> '.' And datos(I,1) <> '..'

			Set Step On

			mPath2 = mpath + datos(I,1)

			Set Path To &mPath2

			Create Cursor mwkmanual (troquel c(7),nombre c(44),present c(24),ioma1 c(8),ioma2 c(1),ioma3 c(1),labora c(16),precio c(9),fecha c(8),mprdctrl c(1),importado c(1),tipovta c(1),iva c(1),;
				descpami c(1),codlab c(3), nroreg c(5),baja c(1),codbarra c(13),unidades c(4),tamano c(1),heladera c(1),sifar c(1),blanco1 c(1),gravamen c(1),blanco2 c(2))

			Select mwkmanual
			Go Top

			Append From manual.dat Sdf

			Select * From mwkmanual Where nombre Like '%SYMBICORT%' Into Cursor controlar

*

			Create Cursor mwkmanextra (nroreg c(5),codtam c(2),codacc c(5),coddro c(5),codfor c(5),potenc c(16),codupo c(5),codtun c(5),codvia c(5))

			Select mwkmanextra
			Go Top

			Append From manextra.txt Sdf

*

			Create Cursor mwktamanos (codigo c(2), descrp c(32))

			Select mwktamanos
			Go Top

			Append From tamanos.txt Sdf

*
			Create Cursor mwkacciofar (codigo c(5), descrp c(32))

			Select mwkacciofar
			Go Top

			Append From acciofar.txt Sdf

*
			Create Cursor mwkmonodro (codigo c(5), descrp c(32))

			Select mwkmonodro
			Go Top

			Append From monodro.txt Sdf

*
			Create Cursor mwkformas (codigo c(5), descrp c(50))

			Select mwkformas
			Go Top

			Append From formas.txt Sdf

*
			Create Cursor mwkupotenci (codigo c(5), descrp c(50))

			Select mwkupotenci
			Go Top

			Append From upotenci.txt Sdf

*

			Create Cursor mwktipounid (codigo c(5), descrp c(50))

			Select mwktipounid
			Go Top

			Append From tipounid.txt Sdf

*

			Create Cursor mwkvias (codigo c(5), descrp c(50))

			Select mwkvias
			Go Top

			Append From vias.txt Sdf

*

			Create Cursor mwkmultidro (nroreg c(5), coddro c(5))

			Select mwkmultidro
			Go Top

			Append From multidro.txt Sdf

*

			Create Cursor mwkregnueva (nroreg c(5), coddro c(5), potenc c(16), codupo c(5))

			Select mwkregnueva
			Go Top

			Append From regnueva.txt Sdf

*

			Create Cursor mwknuevadro (codigo c(5), descrp c(36))

			Select mwknuevadro
			Go Top

			Append From nuevadro.txt Sdf

*

			Select mwkmanual.*, mwkmanextra.*;
				From mwkmanual;
				Inner Join mwkmanextra On mwkmanextra.nroreg = mwkmanual.nroreg;
				Into Cursor mwkdatos


			Select mwkdatos.*, mwkmonodro.*, mwkmultidro.*, mwknuevadro.*,;
				mwkacciofar.descrp As accionfarma, mwktamanos.descrp As tamanio, ;
				mwkupotenci.descrp As unidadpotencia, mwkformas.descrp As formas, ;
				mwktipounid.descrp As tipounidades, mwkvias.descrp As vias  ;
				From mwkdatos ;
				join mwkmonodro On mwkmonodro.codigo = mwkdatos.coddro ;
				join mwkmultidro On mwkmultidro.nroreg = mwkdatos.nroreg_a ;
				join mwknuevadro On mwknuevadro.codigo = mwkmultidro.coddro ;
				JOIN mwkacciofar On mwkacciofar.codigo = mwkdatos.codacc;
				join mwktamanos On mwktamanos.codigo = mwkdatos.codtam;
				join mwkupotenci On mwkupotenci.codigo = mwkdatos.codupo;
				join mwkformas On mwkformas.codigo = mwkdatos.codfor;
				join mwktipounid On mwktipounid.codigo = mwkdatos.codtun;
				join mwkvias On mwkvias.codigo = mwkdatos.codvia;
				Order By  mwkdatos.nroreg_a Into Cursor mwkdatos2

			Select nroreg_a, troquel, codigo_a, Descrp_a, nombre, present, accionfarma, labora,;
				ROUND((Val(precio)/100),2) As lprecio, fecha, baja, tamanio, potenc, unidadpotencia, Int(Val(unidades)) As lunidades,;
				formas, tipounidades, vias, coddro_b, Descrp_b As drogas  ;
				FROM mwkdatos2 Order By  nroreg_a Into Cursor mwkdatos3

			If mPaso = 0

				mPaso = 1
				mArchivo = Alltrim(mzzvolumen)+"\qepd1a1\xlt\alfabeta.xlt"

				oleapp = Createobject("Excel.Application")
				oleapp.workbooks.Open(mArchivo)

				mfil = 2

			Endif

			Select mwkdatos3
			Go Top

			Do While !Eof()

				mfil = mfil + 1

				Wait "Registro : "+Transform(mfil-2) Window Nowait

				oleapp.cells(mfil,02).Value = mwkdatos3.nroreg_a
				oleapp.cells(mfil,03).Value = mwkdatos3.troquel
				oleapp.cells(mfil,04).Value = mwkdatos3.codigo_a
				oleapp.cells(mfil,05).Value = mwkdatos3.Descrp_a
				oleapp.cells(mfil,06).Value = mwkdatos3.nombre
				oleapp.cells(mfil,07).Value = mwkdatos3.present
				oleapp.cells(mfil,08).Value = mwkdatos3.accionfarma
				oleapp.cells(mfil,09).Value = mwkdatos3.labora
				oleapp.cells(mfil,10).Value = mwkdatos3.lprecio
				oleapp.cells(mfil,11).Value = mwkdatos3.fecha
				oleapp.cells(mfil,12).Value = mwkdatos3.baja
				oleapp.cells(mfil,13).Value = mwkdatos3.tamanio
				oleapp.cells(mfil,14).Value = mwkdatos3.potenc
				oleapp.cells(mfil,15).Value = mwkdatos3.unidadpotencia
				oleapp.cells(mfil,16).Value = mwkdatos3.lunidades
				oleapp.cells(mfil,17).Value = mwkdatos3.formas
				oleapp.cells(mfil,18).Value = mwkdatos3.tipounidades
				oleapp.cells(mfil,19).Value = mwkdatos3.vias

				mCtrl = mwkdatos3.nroreg_a
				mDrug = ""

				Do While !Eof() And mCtrl = mwkdatos3.nroreg_a
					If Len(Alltrim(mDrug))>0
						mDrug = mDrug + ", "
					Endif
					mDrug = mDrug + Alltrim(Transform(mwkdatos3.coddro_b))+" : "+Alltrim(mwkdatos3.drogas)
					Skip
				Enddo

				oleapp.cells(mfil,20).Value = mDrug

			Enddo

		Endif

	Endif

Endfor



*!* manual.dat

*!*	troquel
*!*	nombre
*!*	present
*!*	ioma1
*!*	ioma2
*!*	ioma3
*!*	labora
*!*	precio
*!*	fecha
*!*	prdctrl
*!*	importado
*!*	tipovta
*!*	iva
*!*	descpami
*!*	codlab
*!*	nroreg
*!*	baja
*!*	codbarra
*!*	unidades
*!*	tamano
*!*	heladera
*!*	sifar
*!*	blanco1
*!*	gravamen
*!*	blanco2

*!* Set Path To &mpath


*!*	Create Cursor mwkmanual (troquel c(7),nombre c(44),present c(24),ioma1 c(8),ioma2 c(1),ioma3 c(1),labora c(16),precio c(9),fecha c(8),mprdctrl c(1),importado c(1),tipovta c(1),iva c(1),;
*!*		descpami c(1),codlab c(3), nroreg c(5),baja c(1),codbarra c(13),unidades c(4),tamano c(1),heladera c(1),sifar c(1),blanco1 c(1),gravamen c(1),blanco2 c(2))

*!*	Select mwkmanual
*!*	Go Top

*!*	Append From manual.dat Sdf


*!*	Select * From mwkmanual Where nombre Like '%SYMBICORT%' Into Cursor controlar

*!*	* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ *

*!*	*!* manextra.txt
*!*	*!*	nroreg
*!*	*!*	codtam
*!*	*!*	codacc
*!*	*!*	coddro
*!*	*!*	codfor
*!*	*!*	potenc
*!*	*!*	codupo
*!*	*!*	codtun
*!*	*!*	codvia

*!*	Create Cursor mwkmanextra (nroreg c(5),codtam c(2),codacc c(5),coddro c(5),codfor c(5),potenc c(16),codupo c(5),codtun c(5),codvia c(5))

*!*	Select mwkmanextra
*!*	Go Top

*!*	Append From manextra.txt Sdf

*!*	* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ *

*!*	*!* tamanos.txt
*!*	*!* codigo
*!*	*!* descrp

*!*	Create Cursor mwktamanos (codigo c(2), descrp c(32))

*!*	Select mwktamanos
*!*	Go Top

*!*	Append From tamanos.txt Sdf

*!*	* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ *

*!*	*!* acciofar.txt
*!*	*!* codigo
*!*	*!* descrp

*!*	Create Cursor mwkacciofar (codigo c(5), descrp c(32))

*!*	Select mwkacciofar
*!*	Go Top

*!*	Append From acciofar.txt Sdf

*!*	*!*	* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ *

*!*	*!* monodro.txt
*!*	*!* codigo
*!*	*!* descrp

*!*	Create Cursor mwkmonodro (codigo c(5), descrp c(32))

*!*	Select mwkmonodro
*!*	Go Top

*!*	Append From monodro.txt Sdf


*!*	*!*	* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ *

*!*	*!* formas.txt
*!*	*!* codigo
*!*	*!* descrp

*!*	Create Cursor mwkformas (codigo c(5), descrp c(50))

*!*	Select mwkformas
*!*	Go Top

*!*	Append From formas.txt Sdf

*!*	* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ *

*!*	*!* upotenci.txt
*!*	*!* codigo
*!*	*!* descrp

*!*	Create Cursor mwkupotenci (codigo c(5), descrp c(50))

*!*	Select mwkupotenci
*!*	Go Top

*!*	Append From upotenci.txt Sdf

*!*	* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ *

*!*	*!* tipounid.txt
*!*	*!* codigo
*!*	*!* descrp

*!*	Create Cursor mwktipounid (codigo c(5), descrp c(50))

*!*	Select mwktipounid
*!*	Go Top

*!*	Append From tipounid.txt Sdf

*!*	* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ *

*!*	*!* vias.txt
*!*	*!* codigo
*!*	*!* descrp

*!*	Create Cursor mwkvias (codigo c(5), descrp c(50))

*!*	Select mwkvias
*!*	Go Top

*!*	Append From vias.txt Sdf

*!*	*!*	* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ *

*!*	*!* multidro.txt
*!*	*!* nroreg
*!*	*!* coddro -> de nuevadro.txt


*!*	Create Cursor mwkmultidro (nroreg c(5), coddro c(5))

*!*	Select mwkmultidro
*!*	Go Top

*!*	Append From multidro.txt Sdf

*!*	*!*	* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ *

*!*	*!* regnueva.txt
*!*	*!* nroreg
*!*	*!* coddro
*!*	*!* potenc
*!*	*!* codupo

*!*	Create Cursor mwkregnueva (nroreg c(5), coddro c(5), potenc c(16), codupo c(5))

*!*	Select mwkregnueva
*!*	Go Top

*!*	Append From regnueva.txt Sdf

*!*	* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ *

*!*	*!* nuevadro.txt
*!*	*!* codigo
*!*	*!* descrp

*!*	Create Cursor mwknuevadro (codigo c(5), descrp c(36))

*!*	Select mwknuevadro
*!*	Go Top

*!*	Append From nuevadro.txt Sdf

*!*	* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ *

*!*	*!* 2020-01-22 Analisis de la info.

*!*	*!* Base Manual completa

*!*	Select mwkmanual.*, mwkmanextra.*;
*!*		From mwkmanual;
*!*		Inner Join mwkmanextra On mwkmanextra.nroreg = mwkmanual.nroreg;
*!*		Into Cursor mwkdatos


*!*	Select mwkdatos.*, mwkmonodro.*, mwkmultidro.*, mwknuevadro.*,;
*!*		mwkacciofar.descrp As accionfarma, mwktamanos.descrp As tamanio, ;
*!*		mwkupotenci.descrp As unidadpotencia, mwkformas.descrp As formas, ;
*!*		mwktipounid.descrp As tipounidades, mwkvias.descrp As vias  ;
*!*		From mwkdatos ;
*!*		join mwkmonodro On mwkmonodro.codigo = mwkdatos.coddro ;
*!*		join mwkmultidro On mwkmultidro.nroreg = mwkdatos.nroreg_a ;
*!*		join mwknuevadro On mwknuevadro.codigo = mwkmultidro.coddro ;
*!*		JOIN mwkacciofar On mwkacciofar.codigo = mwkdatos.codacc;
*!*		join mwktamanos On mwktamanos.codigo = mwkdatos.codtam;
*!*		join mwkupotenci On mwkupotenci.codigo = mwkdatos.codupo;
*!*		join mwkformas On mwkformas.codigo = mwkdatos.codfor;
*!*		join mwktipounid On mwktipounid.codigo = mwkdatos.codtun;
*!*		join mwkvias On mwkvias.codigo = mwkdatos.codvia;
*!*		Order By  mwkdatos.nroreg_a Into Cursor mwkdatos2

*!*	Set Step On

*!*	Select nroreg_a, troquel, codigo_a, Descrp_a, nombre, present, accionfarma, labora,;
*!*		ROUND((Val(precio)/100),2) As lprecio, fecha, baja, tamanio, potenc, unidadpotencia, Int(Val(unidades)) As lunidades,;
*!*		formas, tipounidades, vias, coddro_b, Descrp_b As drogas  ;
*!*		FROM mwkdatos2 Order By  nroreg_a Into Cursor mwkdatos3


*!*	IF mPaso = 0

*!*		mPaso = 1
*!*		mArchivo = Alltrim(mzzvolumen)+"\qepd1a1\xlt\alfabeta.xlt"

*!*		oleapp = Createobject("Excel.Application")
*!*		oleapp.workbooks.Open(mArchivo)

*!*		mfil = 2

*!*	ENDIF


*!*	Select mwkdatos3
*!*	Go Top

*!*	Do While !Eof()

*!*		mfil = mfil + 1

*!*		Wait "Registro : "+Transform(mfil-2) Window Nowait

*!*		oleapp.cells(mfil,02).Value = mwkdatos3.nroreg_a
*!*		oleapp.cells(mfil,03).Value = mwkdatos3.troquel
*!*		oleapp.cells(mfil,04).Value = mwkdatos3.codigo_a
*!*		oleapp.cells(mfil,05).Value = mwkdatos3.Descrp_a
*!*		oleapp.cells(mfil,06).Value = mwkdatos3.nombre
*!*		oleapp.cells(mfil,07).Value = mwkdatos3.present
*!*		oleapp.cells(mfil,08).Value = mwkdatos3.accionfarma
*!*		oleapp.cells(mfil,09).Value = mwkdatos3.labora
*!*		oleapp.cells(mfil,10).Value = mwkdatos3.lprecio
*!*		oleapp.cells(mfil,11).Value = mwkdatos3.fecha
*!*		oleapp.cells(mfil,12).Value = mwkdatos3.baja
*!*		oleapp.cells(mfil,13).Value = mwkdatos3.tamanio
*!*		oleapp.cells(mfil,14).Value = mwkdatos3.potenc
*!*		oleapp.cells(mfil,15).Value = mwkdatos3.unidadpotencia
*!*		oleapp.cells(mfil,16).Value = mwkdatos3.lunidades
*!*		oleapp.cells(mfil,17).Value = mwkdatos3.formas
*!*		oleapp.cells(mfil,18).Value = mwkdatos3.tipounidades
*!*		oleapp.cells(mfil,19).Value = mwkdatos3.vias

*!*		mCtrl = mwkdatos3.nroreg_a
*!*		mDrug = ""

*!*		Do While !Eof() And mCtrl = mwkdatos3.nroreg_a
*!*			If Len(Alltrim(mDrug))>0
*!*				mDrug = mDrug + ", "
*!*			Endif
*!*			mDrug = mDrug + Alltrim(Transform(mwkdatos3.coddro_b))+" : "+Alltrim(mwkdatos3.drogas)
*!*			Skip
*!*		Enddo

*!*		oleapp.cells(mfil,20).Value = mDrug

*!*	Enddo

oleapp.Visible = .T.

Release oleapp

Return .T.
