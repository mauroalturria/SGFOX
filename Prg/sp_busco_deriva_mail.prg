*
* Busqueda de mail maestro de usuario contando con el codigo vax
*

Lparameters mbcodigo

If used('mwkusunail')
	Use in mwkusumail
Endif

mret = sqlexec(mcon1,"select email from TabUsuario"+;
" where codigovax = ?mbcodigo","mwkusumail")

If mret < 0
	messagebox("EN BUSQUEDA DE EMAIL MAESTRO DE USUARIOS",16,"ERROR")
Endif
