parameters msistema ,musua
Public PbIngreso

PbIngreso  = .F.  

*****************************************************************
* Busco el id del Sistema que se va a utilizar					*
*****************************************************************
Select sis_ids 													;
	From &W_sistemas 											;
	Where alltrim(upper(sis_nom)) = alltrim(upper(Msistema)) 	;
	Into cursor  _sistemid
*****************************************************************
* Busco si el usuario que ingresa puede acceder a pantallas de  *
* este sistema													*
***************************************************************** 	

Selec Pan_Nom 													;
	From &W_usuarios,&W_usuacc,&W_pantalla						;
	Where 	upper(Usu_nom) = upper(Musua) 	and					;
			usu_ids	= acc_usu 				and					;
			acc_scr	= pan_ids 									;
	Into Cursor _usuPan

*****************************************************************
* Genero una variable para el manejo de los menues del usuario	*
*  seleccionado													*
*****************************************************************
If _Tally <> 0
	Selec _usuPan
	Do While !Eof('_usuPan')
		WWWA="M"+ALLTRIM(_usuPan.Pan_Nom)
		PUBLIC &WWWA
		&WWWA	=	.T.
		Skip 1 in _usuPan				
	Enddo
	PbIngreso = .T.
	Close Data All
Else
	Do Form FrmIngreso
EndIF
*** en el menu type('mfrmdetpagos') = 'U' 