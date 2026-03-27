*
* Log de Mails / Newsletters enviados
*
* De ser necesario concatenar SP_GRABO_AVISO
*
Lparameters morigen,mdestino,mtitulo,mmensaje,murl,mdestinatario,musercon

musuario = mwkusuario.idusuario
mfecmov  = sp_busco_fecha_serv('DT')

mret = sqlexec(mcon1,"insert into TabLogMail "+;
	"(TLM_origen,TLM_destino,TLM_titulo,TLD_mensaje,TLM_url,"+;
	"TLM_destinatario,TLM_usercon,TLM_usuario,TLM_fecmov)"+;
	" values "+;
	"(?morigen,?mdestino,?mtitulo,?mmensaje,?murl,?mdestinatario,"+;
	"?musercon,?musuario,?mfecmov)")

If mret < 0
	Messagebox("EN ARCHIVO LOG DE ENVIO DE MAILS"+chr(10)+;
		"AVISE A SISTEMAS",16,"ERROR")
	mpasoreg = .t.
Endif
