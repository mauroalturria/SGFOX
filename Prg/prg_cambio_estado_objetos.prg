* Cambia el estado de los objetos: Enable/Disable y los limpia
* Fabián 2017-05
* mopcion = 1: Deshabilito y limpio todos los objetos
* mopcion = 2: Habilito todos los objetos
* mopcion = x: Deshabilita los objetos pero no los limpia

Parameters mobjeto,mopcion

If mopcion = 2
	For N = 1 To mobjeto.ControlCount
		mobjeto.Controls(N).Enabled = .T.
	Endfor
	For nvar = 1 To mobjeto.Objects.Count
		If Upper(mobjeto.Objects(nvar).BaseClass) = "OPTIONGROUP"
			mopnombre = mobjeto.Objects(nvar).Name
			For e = 1 To mobjeto.Objects(nvar).ButtonCount
				mobjeto.Objects(nvar).Buttons(e).Enabled = .T.
			Endfor
		Endif
	Endfor
Else
	For N = 1 To mobjeto.ControlCount
		mobjeto.Controls(N).Enabled = .F.
		mNomClase = Upper(mobjeto.Objects(N).BaseClass)
		Do Case
		Case mNomClase = "OPTIONGROUP" Or mNomClase = "CHECKBOX"
			mobjeto.Controls(N).Value = 0
		Case mNomClase = "TEXTBOX" Or mNomClase = "EDITBOX"
			If mopcion = 1
				mobjeto.Controls(N).Value = ""
			Endif
		Endcase
	Endfor
	For nvar = 1 To mobjeto.Objects.Count
		If Upper(mobjeto.Objects(nvar).BaseClass) = "OPTIONGROUP"
			mopnombre = mobjeto.Objects(nvar).Name
			For e = 1 To mobjeto.Objects(nvar).ButtonCount
				If mopcion = 1
					mobjeto.Objects(nvar).Buttons(e).Value = 0
				Endif
				mobjeto.Objects(nvar).Buttons(e).Enabled = .F.
			Endfor
		Endif
	Endfor
Endif
