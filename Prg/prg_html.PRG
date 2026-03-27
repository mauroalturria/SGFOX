Clear
On Error
?''


Define Class loHtml As Custom

	Evol = ''
	Nivel = 0
	Html = ''
	lcSep = Chr(10)
	Dimension aHtml[6]
	*!* ---------------------------------------------------------------------------  
	Procedure Init
		For I = 1 To ALEN(This.aHtml)
			This.aHtml[I] = ''
		Next 	

	Endproc
	*!* ---------------------------------------------------------------------------  
	Procedure AddTag
	Parameters tcTipo, tbCierro, tcTexto, tcId, tcClass, tcTag, tcAdic
	This.Nivel = This.Nivel + 1
	This.Html = This.Html + "<" + tcTipo + ;
		Iif(Empty(tcId)   ,'',' id = "' + tcId + '"' + Space(1) )  + ;
		Iif(Empty(tcClass),'',' class = "' + tcClass + '"'  + Space(1)) + ;
		Iif(Empty(tcTag)  ,'',' tag = "' + tcTag + '"'+ Space(1)) + ;
		Iif(Empty(tcAdic) ,'',tcAdic + Space(1)) + ;
		">" + ;
		Iif(Empty(tcTexto),'', tcTexto + Space(1) )

	Iif(tbCierro,This.CloseTag(tcTipo),'')

	This.Html = This.Html + This.lcSep

	Endproc
	*!* ---------------------------------------------------------------------------  
	Procedure CloseTag
	Parameters tcTipo
	This.Html = This.Html + '</' + tcTipo + '>' + This.lcSep
	Endproc
	*!* ---------------------------------------------------------------------------  
	Procedure AddText
	Parameters tcTexto
	This.Html = This.Html + tcTexto
	This.Html = This.Html + This.lcSep
	Endproc
	*!* ---------------------------------------------------------------------------  
	Procedure AddHTMLInt
	Parameters tnTipo, tcText
	Do Case
		Case tnTipo = 1
			lcTit = '&nbsp;Neurológico'
			lcCla = 'comuncss apaneu'
			lcClaImg = 'fa fa-pinterest'
			tnPos = 2
		Case tnTipo = 2
			lcTit = '&nbsp;Aparato Respiratorio'
			lcCla = 'comuncss apares'
			lcClaImg = 'fa fa-renren'
			tnPos = 3
		Case tnTipo = 3
			lcTit = '&nbsp;Aparato Cardiovascular'
			lcCla = 'comuncss apacar'
			lcClaImg = 'fa fa-stethoscope'
			tnPos = 4
			
		Case tnTipo = 4
			lcTit = '&nbsp;Ap.Genito Urinario - Abdomen'
			lcCla = 'comuncss apauri'
			lcClaImg = 'fa fa-plus-square'
			tnPos = 5

		Case tnTipo = 5
			lcTit = '&nbsp;Evolución'
			lcCla = 'comuncss evolucion'
			lcClaImg = 'fa fa-user-md'
			tnPos = 1

		Case tnTipo = 6
			lcTit = '&nbsp;Scores'
			lcCla = 'comuncss scores'
			lcClaImg = 'fa fa-user-md'
			tnPos = 6

		Otherwise

	endcase
	
	This.AddTag("div", .F. ,'',"div" + Transform(tnTipo) + "_??ID??", lcCla ,''," data-estado='1' onclick=" + '"' + "_viewdat('div" + Transform(tnTipo) + "_??ID??','mdiv" + + Transform(tnTipo) + "_??ID??') " + '"' )
		
		This.AddTag("i", .f. ,'','',lcClaImg,'','')
		This.AddTag("h1", .T. ,lcTit,'','clsh1','','')
		This.CloseTag("i")	
		This.AddTag("br" , .F. ,'','','','','')
*		This.AddTag("br" , .F. ,'','','','','')
		This.AddTag("div", .F. ,'','mdiv' + Transform(tnTipo) + '_??ID??','ocultadiv','','')
		This.AddText(Strtran(tcText,Chr(10),'<br>'))
			This.CloseTag("div")
		This.CloseTag("div")	
		This.AddTag("br" , .F. ,'','','','','')
		
		If tnPos > 0
			This.aHtml[tnPos] = This.Html
			This.Html = ''
		Endif 
	Endproc 
	
	Procedure HTMLInt_Merge
		This.Html = ''
		For I = 1 To ALEN(This.aHtml)
			This.Html = This.Html + Iif(Vartype(This.aHtml[I]) <> 'C','',This.aHtml[I] )
		Next 	
	Endproc 

	Procedure Destroy

	Endproc


	Procedure Error(nerror, Cmethod, Nline)
		Messagebox("Error " + Transform(nerror) + Chr(13) + ;
					"Metodo " + Transform(Cmethod) + Chr(13) + ;
					"Linea " + Transform(Nline))

	Endproc

Enddefine
