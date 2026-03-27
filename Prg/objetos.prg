LParameters lObjeto

Local I

If !used("cObj")
	Create Cursor cObj (Desc c(80), Class c(40), Parent c(40), Valor c(60))
Endif 	


Do Case
	Case lObjeto.BaseClass = "Pageframe"
		For I = 1 to lObjeto.PageCount
			Insert into cObj ("Desc", "Class", "Parent") Values ;
			(lObjeto.Pages(I).Name, lObjeto.Pages(I).BaseClass, lObjeto.Name )
			=Objetos(lObjeto.Pages(I))
		Next 

	Case lObjeto.baseclass = "Form"	Or lObjeto.baseclass = "Container" Or lObjeto.baseclass = "Page"
		For I = 1 to lObjeto.ControlCount
			Insert into cObj ("Desc", "Class", "Parent") Values ;
			(lObjeto.Objects(I).Name, lObjeto.Objects(I).BaseClass, lObjeto.Name)
			=Objetos(lObjeto.Objects(I))
		Next 
		
	OtherWise
		If lObjeto.baseclass = "Textbox"	Or lObjeto.baseclass = "Editbox" Or ;
			lObjeto.baseclass = "Listbox" Or lObjeto.baseclass = "Combobox"
			
			Select cObj 
			Replace Valor With transform(lObjeto.Value)
			
		Endif 		
	
	
EndCase