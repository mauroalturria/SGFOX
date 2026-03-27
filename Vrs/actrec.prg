Select lasrecetas
Go Top
SET STEP ON
Skip
Do While !Eof()
	miinsu = ipr_insumo
	mirec = 1
	Do While !Eof() And miinsu = ipr_insumo
		If mirec =ipr_receta
			mirec =mirec +1
			Skip
		Else
			If Inlist(ipr_tipoegreso,1,3)
				Select inspsicorec
			Else
				Select inspsicbolsa
			Endif
			mid= lasrecetas.Id
			LOCATE FOR id = mid
			replace ipr_receta with mirec
			mirec =mirec +1
			Select lasrecetas
			Skip
		Endif
	Enddo

Enddo

MODIFY VIEW inspsicorec
CREATE VIEW REMOTE
SELECT *,TTOD(fechahoraconforme) as fecha frm view1 INTO CURSOR bolsa
SELECT *,TTOD(fechahoraconforme) as fecha from view1 INTO CURSOR bolsa
SELECT *,TTOD(fechahoraconforme) as fecha from inspsicbolsa INTO CURSOR bolsa
SELECT iD, CodAmbito,IPR_insumo, IPR_receta,IPR_tipoEgreso, IPR_valcodpun FROM bolsas;
union ALL SELECT iD, CodAmbito,IPR_insumo, IPR_receta,IPR_tipoEgreso, IPR_valcodpun FROM inspsicorec INTO cursro recetas
SELECT iD, CodAmbito,IPR_insumo, IPR_receta,IPR_tipoEgreso, IPR_valcodpun FROM bolsas;
union ALL SELECT iD, CodAmbito,IPR_insumo, IPR_receta,IPR_tipoEgreso, IPR_valcodpun FROM inspsicorec INTO cursor recetas
SELECT iD, CodAmbito,IPR_insumo, IPR_receta,IPR_tipoEgreso, IPR_valcodpun FROM bolsas;
union ALL SELECT iD, CodAmbito,IPR_insumo, IPR_receta,IPR_tipoEgreso, IPR_valcodpun FROM inspsicorec INTO cursor mrecetas
SELECT 32
BROWSE LAST
SELECT iD, CodAmbito,IPR_insumo, IPR_receta,IPR_tipoEgreso, IPR_valcodpun FROM bolsas;
union ALL SELECT iD, CodAmbito,IPR_insumo, IPR_receta,IPR_tipoEgreso, IPR_valcodpun,val_fhsolicitud as fechi FROM inspsicorec INTO cursor mrecetas
SELECT iD, CodAmbito,IPR_insumo, IPR_receta,IPR_tipoEgreso, IPR_valcodpun,fechahoraconforme as fechi FROM inspsicbolsa;
union ALL SELECT iD, CodAmbito,IPR_insumo, IPR_receta,IPR_tipoEgreso, IPR_valcodpun,val_fhsolicitud as fechi FROM inspsicorec INTO cursor mrecetas
SELECT * FROM  mrecetas ORDER BY ipr_insumo,fechi,ipr_receta INTO CURSOR lasrecetas
BROWSE LAST
MODIFY COMMAND
SELECT 37
BROWSE LAST
DO c:\desaguemes\vrs\actrec.prg
RESUME
DO c:\desaguemes\vrs\actrec.prg
RESUME
DO c:\desaguemes\vrs\actrec.prg
RESUME
BROWSE LAST
RESUME
REQUERY('inspsicbolsa')
SELECT iD, CodAmbito,IPR_insumo, IPR_receta,IPR_tipoEgreso, IPR_valcodpun,fechahoraconforme as fechi FROM inspsicbolsa;
union ALL SELECT iD, CodAmbito,IPR_insumo, IPR_receta,IPR_tipoEgreso, IPR_valcodpun,val_fhsolicitud as fechi FROM inspsicorec INTO cursor mrecetas
SELECT * FROM  mrecetas ORDER BY ipr_insumo,fechi,ipr_receta INTO CURSOR lasrecetas
BROWSE LAST

SELECT * FROM inspsicorec GROUP BY ipr_insumo