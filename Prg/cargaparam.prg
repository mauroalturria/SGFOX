** Procedimiento: CargaParam
*     Carga parametros de Startup del módulo en variables PUBLICAS
*     Por convención, definidas como ZZnombreVariable  (public, char)
*     Devuelve: si encontró el file y lo pudo abrir: OK -> .T.
*                  y además carga las variables ZZvar con su valor correspondiente
*               sino: Ok -> .F.
*
parameter Ok,minfo

private FileParam, Handle, row, variable, valor

m.FileParam = alltrim(minfo)+".prm" &&  GetFileParam(minfo)   && Obtiene el path+nombre del file de parametros
m.Handle = fopen(m.FileParam)
if m.Handle < 0
	m.Ok = .F.    && fracaso
else
	do while not feof(m.Handle)
		m.row = fget(m.Handle, 600)
		m.row = alltrim(m.row)
		if left(m.row,1) <> '*' and '=' $ m.row && comentarios y rows vacios se saltean
			m.variable = alltrim(substr(m.row,1,at('=',m.row)-1))
			m.valor    = alltrim(substr(m.row,at('=',m.row)+1))
			if not empty(m.variable) and not empty(m.valor)
*				messagebox(m.variable+"-"+m.valor)
				public &variable
				&variable = m.valor
			endif
		endif
	enddo
	fclose(m.Handle)
	m.Ok = .T.   && Exito
endif
return

