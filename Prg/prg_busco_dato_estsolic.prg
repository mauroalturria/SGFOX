Parameters cadmision,nIdAutPrev,ncodpr,nvale,miopc,mcursor
If Vartype(ncodpr)<>"N"
	ncodpr = 0
ENDIF
If Vartype(nIdAutPrev)<>"N"
	nIdAutPrev= 0
ENDIF
IF VARTYPE(mcursor)<>"C"
mcursor = "mwkEstSolic"
endif
cbuscop = ''
mclado = Space(20)
If ncodpr>0
	cbuscop  = ' and EP_codprest = '+ Transform(ncodpr)
Endif
If Vartype(miopc)<>"N"
	miopc=1  &&Lateralnidad
Endif
If nIdAutPrev>0
	cbuscop  = cbuscop  + " and  Ep_IdAc = "+Transform(nIdAutPrev)
Endif
If VAL(TRANSFORM(nvale))>0
	cbuscop  = cbuscop  + " and  Ep_vale = "+Transform(nvale)
Endif
lcSQL = "Select * from TabEstudiosSolic Where EP_admision =?cadmision  "+ cbuscop + " order by id desc "

If !Prg_EjecutoSql(lcSQL,mcursor )
	Return .F.
Endif
mnlado = 0
mnlado = Nvl(EP_lateralidad,1)-1
If Reccount(mcursor )>0
	Do Case
	Case miopc =1
		mclado = Iif(mnlado<=0,Space(20), " - Lado: "+ Iif(mnlado =1,"Izquierdo",Iif(mnlado =2,"Derecho","Ambos")))
	Case miopc =2
		mclado = Iif(mnlado<=0,Space(20), Iif(mnlado =1,"Izquierdo",Iif(mnlado =2,"Derecho","Ambos")))
	Endcase
Endif
Return mclado

