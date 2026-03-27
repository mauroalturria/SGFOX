Select insu_restric

SET STEP ON
Scan
	minsu = tir_codpuntero
	mifecha = Ctod("04/11/2020")
	For i= 1 To 6
		midia = mifecha + i
		mdant = midia -1
		Select Sum(pia_cantsolicitada) As salida,* From inspsicorec  Where ipr_insumo = minsu And val_fechaconforme  < midia Into Cursor sale
		Select Sum(cantconformada) As salida,* From inspsicbolsa  Where ipr_insumo = minsu And TTOD(fechahoraconforme)  < midia Into Cursor saleb
		Select Sum(IPRM_cantidad) As salida,* From inspsicRecman Where ipr_insumo = minsu And IPRM_fecha  < midia Into Cursor salerm
	
		Select Sum(ip_cantidad) As entrada,* From inspsico ;
			WHERE ip_insumo = minsu And ip_fecha<midia Into Cursor entra  && And tipomov>-1 
		transp = entra.entrada -sale.salida-saleb.salida-salerm.salida
		Insert Into inspsicoudt  (ip_cantidad, IP_drogueria, ip_fecha, IP_fecpasiva, ip_insumo, tipomov,  IP_valeMSAL) Values ;
			(transp,"Transporte del día:"+Transform(mdant),midia,Ctod("01/01/1900"),minsu,-9,0)
	Next
Endscan
Set Step On



a
Select zabinsreceta
Do While !Eof()
	Locate For ipr_receta = 99999
	minsu = ipr_insumo
	Skip -1
	minrorec = Iif(minsu = ipr_insumo,ipr_receta,0) +1
	Skip 1
	Do While minsu = ipr_insumo
		Replace  ipr_receta With  minrorec
		minrorec = minrorec+1
		Skip
	Enddo
	minsu = ipr_insumo
Enddo
Set Step On
Select libro
Scan
	micod = material
	Select insumos
	Locate For INS_codinsumo=micod
	Select libro
	Replace  codinsu With insumos.INS_codpuntero
Endscan
Create Cursor COSA (DATO C(100))
Append From  C:\desaguemes\LIBRO1.TXT Delimited With Tab
SET STEP ON
Create Cursor recetas (insumo C(50),vale N(10),admision C(10),nrorec N(10))
i=1
Select rece
GO top
DO WHILE !EOF()
	Do While i<5
		Do Case
			Case i= 1
				minsu = DATO
			Case i=2
				nvale =Val(DATO)
			Case i=3
				cadm = Substr(DATO,5,8)
			Case i = 4
				nrec = Val(DATO)
		Endcase
		i=i+1
		SKIP 1
	Enddo
	i=1
	Insert Into recetas (insumo ,vale ,admision ,nrorec ) Values ( minsu,nvale,cadm,nrec)
Select rece
enddo
COPY TO recetas_manuales TYPE xl5