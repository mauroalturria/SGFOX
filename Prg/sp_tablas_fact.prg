****
** Tablas para Facturacion
****
Use In Select("mwkptosvt1")
Use In Select("mwkptosvta")

mret = SQLExec(mcon1,"select Descripcion, FechaAlta, FechaPasiva,PuntodeVenta " + ;
	" from Puntosdeventa where TipoPuntoVenta = 1 ", "mwkptosvt1")
Select *,Iif(At('Ambulatorio',Descripcion)>0,"0016",Iif(At('Guardia',Descripcion)>0,"0017","0019")) As origen ;
	from mwkptosvt1 Into Cursor mwkptosvta

mret = SQLExec(mcon1,"select  Puntosdeventa.Descripcion, Puntosdeventa.FechaAlta,"+;
	" Puntosdeventa.FechaPasiva, Puntosdeventa.PuntodeVenta,"+;
	" Tabctromedpv.FecPasiva,Tabctromedpv.TipoPac ,Tabctromedico.abreviatura,"+;
	" Tabctromedico.activo, Tabctromedico.ambito, Tabctromedico.centromedico,"+;
	" Tabctromedico.centromedicoMK, Tabctromedico.centros,"+;
	" Tabctromedico.descripcion, Tabctromedico.orden, Tabctromedico.web,IDCentroMedico " + ;
	" from Puntosdeventa "+;
	" INNER JOIN Tabctromedpv ON  Puntosdeventa.ID = Tabctromedpv.IDPtoVta "+;
	" INNER JOIN Tabctromedico ON  Tabctromedpv.IDCentroMedico = Tabctromedico.ID "+;
	" where Tabctromedpv.FecPasiva='1900-01-01' and Puntosdeventa.FechaPasiva is null "+;
	"   ", "mwkptosvt1")
Select *,Transform(PuntodeVenta,"@L 9999") As origen ;
	from mwkptosvt1 Into Cursor mwkptosvta

mret = SQLExec(mcon1,"select  Descripcion, Motivo, ID " + ;
	"from MotivosDespacho order by Descripcion", "mwkmotivos")

mret = SQLExec(mcon1,"select descrip, ID, iva1, iva2, tipofacc, tipofacp " + ;
	" from TabIva ", "mwkTabIva")
Do sp_busco_estados With 57,' and tipo = 59 ','mwkhabiva'&&
If mwkhabiva.estado = 1
	mret = SQLExec(mcon1,"select ZIC_DescCondicion , ZIC_EquipvSAP , ZIC_IdCondicion,ZIC_Porcentaje,id FROM ZabIvaCondicion " + ;
		" order by ZIC_IdCondicion  ", "mwkZabIvaCondicion")
Endif
Create Cursor mwkFpago (Descrip c(50),Id N(2))
Insert Into mwkFpago (Descrip,Id ) Values ("CONTADO",1)
Insert Into mwkFpago (Descrip,Id ) Values ("30 DIAS CORRIDOS FECHA FACTURA",2)

mret = SQLExec(mcon1,"select descrip, abrevio, ID, codafip " + ;
	" from tabformularios where codafip >0 and abrevio<>'' order by codafip ", "mwkTCte")
If mret < 0
	Messagebox("ERROR EN LA GENERACION DEL CURSOR DE TABLAS, AVISAR A SISTEMAS",16, "Validacion")
	Do sp_desconexion With "error"
	Cancel
Endif
