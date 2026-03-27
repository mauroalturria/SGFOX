LParameters lObjeto, lcCursor, lcCont

Local I, lcAnt

If !used(lcCursor)
	Create Cursor (lcCursor) (index c(100),Desc c(80), Class c(40), Parent c(40), Valor c(60))
Endif 	

Do Case
	Case lObjeto.BaseClass = "Pageframe"

		lcAnt = lcCont + "." + lObjeto.Name
		
		For I = 1 to lObjeto.PageCount
			Insert into (lcCursor) ("Desc", "Class", "Parent", "Index") Values ;
			(lObjeto.Pages(I).Name, lObjeto.Pages(I).BaseClass, lObjeto.Name, lcAnt  )
			=Prg_Obt_Objetos(lObjeto.Pages(I),lcCursor, lcAnt)
		Next 

	Case lObjeto.baseclass = "Form"	
		lcAnt = lObjeto.Name
		For I = 1 to lObjeto.ControlCount
			Insert into (lcCursor) ("Desc", "Class", "Parent", "Index") Values ;
			(lObjeto.Objects(I).Name, lObjeto.Objects(I).BaseClass, lObjeto.Name, lcAnt )
			=Prg_Obt_Objetos(lObjeto.Objects(I),lcCursor, lcAnt )
		Next

	Case lObjeto.baseclass = "Container" Or lObjeto.baseclass = "Page"
		lcAnt = lcCont + "." + lObjeto.Name

		For I = 1 to lObjeto.ControlCount
			Insert into (lcCursor) ("Desc", "Class", "Parent", "Index") Values ;
			(lObjeto.Objects(I).Name, lObjeto.Objects(I).BaseClass, lObjeto.Name, lcAnt )
			=Prg_Obt_Objetos(lObjeto.Objects(I), lcCursor, lcAnt)
		Next

		 
	Case lObjeto.baseclass = "Checkbox" Or lObjeto.baseclass = "Optiongroup"
		Select (lcCursor) 
		If !IsNull(lObjeto.Value)
			Replace Valor With Alltrim(str(lObjeto.Value))
		Endif 
	Case lObjeto.baseclass = "Label" Or lObjeto.baseclass = "Commandbutton"
		Select (lcCursor) 
		Replace Valor With Alltrim(lObjeto.Caption)
		
	OtherWise
		If lObjeto.baseclass = "Textbox"	Or lObjeto.baseclass = "Editbox" Or ;
			lObjeto.baseclass = "Listbox" Or lObjeto.baseclass = "Combobox"  
			
			Select (lcCursor)
			Replace Valor With transform(lObjeto.Value)
		Endif 		
EndCase