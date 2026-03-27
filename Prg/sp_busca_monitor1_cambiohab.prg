Parameters lcodadm
msec = ''
mhab = ''
mcam = ''
mretorno = ''
If used("mwkchab")
	Use in mwkchab
Endif
mcodadm = lcodadm
mret = sqlexec(mcon1,"select LUG_codsector,LUG_habitacion,LUG_cama,LUG_fechaingreso,LUG_horaingreso from LUGARINTERN "+;
	"where LUG_pacientes=?mcodadm order by LUG_fechaingreso, LUG_horaingreso","mwkchab")
If mret < 0
	Messagebox("EN LA CONSULTA DE PACIENTES, REGISTRO DE HABITACIONES",0+48,"ERROR")
	Return
Endif
If reccount("mwkchab") > 0
	Select mwkchab
	Go bottom
	msec = alltrim(mwkchab.LUG_codsector)
	mhab = alltrim(mwkchab.LUG_habitacion)
	mcam = alltrim(mwkchab.LUG_cama)
	mretorno = alltrim(msec)+','+alltrim(mhab)+','+mcam
	*messagebox(dtoc(LUG_fechaingreso),0,"")
	*messagebox(right(ttoc(LUG_horaingreso),8),0,"")	
	mretorno = mretorno+space(14-len(mretorno))+':'+dtoc(LUG_fechaingreso)+' '+right(ttoc(LUG_horaingreso),8)
Endif
Return mretorno
