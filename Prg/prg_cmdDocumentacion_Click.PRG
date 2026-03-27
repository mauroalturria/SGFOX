Parameters loFrm1

*loFrm1 = ThisForm

mccadinfo = loFrm1.name + chr(13)
lcPermiso = PERMISO_MENU(loFrm1.name)
If !Empty(lcPermiso)
	mccadinfo = mccadinfo + "Permiso Menu : " + lcPermiso + chr(13)
Endif 	

i = 1		
lcOnError = on("ERROR")
erase eros
On Error
K = 0

For I = 1 To loFrm1.ControlCount
	if loFrm1.Controls(i).class = "Commandbutton"
		K = K + 1 
		lcN1 = "tx" + Transform(K)
		lo1 = loFrm1.AddObject(lcN1,"textbox")

		lcN1 = Evaluate("loFrm1." + lcN1)
		lcN1.Value = Transform(K)
		lcN1.width = 25
		lcN1.height = 25
		lcN1.left = loFrm1.Controls(i).left
		lcN1.top = loFrm1.Controls(i).top
		lcN1.Visible = .t.
		lcN1.readonly = .t.
		
		mcinv = ''
		if used('mwkcmd')
			select mwkcmd
			locate for upper(cmdnombre) = upper(alltrim(loFrm1.Controls(i).name))
			mcinv = iif(found()," INV","") 
		Endif
		
		mccadinfo = mccadinfo + ;
			iif((type('m' + alltrim(loFrm1.name) + " " + Transform(K) + " - "+ alltrim(loFrm1.Controls(i).name)) # 'U'),"* "," ")+;
			 + " " + Transform(K) + " - " + loFrm1.Controls(i).name  + mcinv + " - " + loFrm1.Controls(i).ToolTipText + chr(13)
			 
	endif
Next 

messagebox(mccadinfo,64,"INFORMACION")

For I = 1 To K
	lofrm1.removeobject("tx" + Transform(I))
Next 



Function PERMISO_MENU
parameters tcForm

	lcsql = "Select PUNTOMENU From TabFrm where nomfrm = ?tcForm"

	If !Prg_EjecutoSql(lcSql,"mwkMenuAux")
		Return .f.
	Endif  

	Local lcResu 	
	lcResu = Alltrim(Nvl(mwkMenuAux.PUNTOMENU,'' ))
	
	Use In Select("mwkMenuAux")
	
	Return (lcResu)

Endfunc  