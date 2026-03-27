lbResu = .F.
xnentag ='@@'

micodag =99999
Use In Select('mwkambitohabil')
If Used("mwkafient1") And Reccount("mwkafient1")>0
	micodag = Iif(Isnull(mwkafient1.ent_codagrup),mwkafient1.ent_codent,mwkafient1.ent_codagrup)
	xnentag =  Alltrim(Transform(micodag ))
Else
	If Used("mwkbuspacie1")
		If mwkbuspacie1.preacre = 1
			micodag = Iif(Isnull(mwkbuspacie1.ent_codagrup),mwkbuspacie1.ent_codent,mwkbuspacie1.ent_codagrup)
			xnentag = Alltrim(Transform( micodag ))
		Endif
	Endif
Endif
If !Used("mwktabambito")
	Do sp_busco_tabla_id With 'tabambito', ' ','mwktabambito'
	Select mwktabambito
	Locate For Id = mxambito
Endif
msumosg = Iif(mxambito = 1," or id =1 ","")
Select * From  mwktabambito Where xnentag $ tipoent &msumosg  Into Cursor mwkambitohabil
lbResu = (Reccount('mwkambitohabil')>0)
Return  (lbResu)
