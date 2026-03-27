* muestro mail/numero/inserto

Parameters Mail,tipo

Public oform As Form
oform = Newobject('form')
With oform
	.BorderStyle = 1
	.MaxButton = .F.
	.MinButton = .F.
	.Closable = .F.
	.Caption = 'Verificar E-mail'
	.Width = 300
	.Height = 150
	.AutoCenter = .T.
	.TitleBar = 0
Endwith

* Texto Mail
oform.AddObject('texto1','emailinfo')
With oform.texto1
	.Top = (oform.Height/2)-25
	.Left = (oform.Width/2)-100
	.Width = 200
	.MaxLength = 200
	.Visible = .T.
	If !Empty(Mail)
		.Value = Mail
	Endif
Endwith

oform.AddObject('label','label1')
With oform.Label
	.Caption = 'Ingrese el E-mail'
	.Top = (oform.Height/2)-(oform.Label.Width/2)
	.Left = (oform.Width/2)-100
	.Visible = .T.
Endwith

* Botón Aceptar
oform.AddObject('cmdAceptar','botonacept')
With oform.cmdAceptar
	.Visible = .T.
	.Height = 25
	.Width = 55
	.Top = (oform.Height/2)+20
	.Left = (oform.Width/2)-100
	.Caption = 'Ingresar'
Endwith

* Botón Salir
oform.AddObject('cmdSalir','botonsalir')
With oform.cmdSalir
	.Visible = .T.
	.Height = 25
	.Width = 50
	.Top = (oform.Height/2)+20
	.Left = (oform.Width/2)+(oform.cmdSalir.Width)
	.Caption = 'Salir'
Endwith

oform.Show

Read Events

Define Class 'botonacept' As CommandButton
	Procedure Click()
	mvalidoelmail = '@' $ Alltrim(oform.texto1.Value)
	If !mvalidoelmail
		Messagebox('Coloque un mail válido por favor',48,'Aviso')
		oform.texto1.Value = ''
		oform.texto1.SetFocus
		Return .F.
	Endif
	Create Cursor mwkDatMail (email c(50))
	Insert Into mwkDatMail (email) Values (Alltrim(oform.texto1.Value))
	Endproc
Enddefine

Define Class 'botonsalir' As CommandButton
	Procedure Click()
	If Messagebox('Desea salir ?',68,'Aviso') = 7
		Return .F.
	Endif
	Clear Events
	oform.Release
	Endproc
Enddefine

Define Class 'emailinfo' As TextBox
Enddefine

Define Class 'label1' As Label
Enddefine
