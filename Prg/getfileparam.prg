******************************************
** Obtiene el path + nombre del file de parametros:
*  Si existe la variable entorno (S.O.) MNTPARAM, lo carga de allí.
*  Sino, toma
lparameters miparam
private DefFile, RetValue

** Default:
m.DefFile = miparam

m.RetValue = getenv('MNTPARAM')
if empty(m.RetValue)
	m.RetValue = m.DefFile
endif

return (m.RetValue)

