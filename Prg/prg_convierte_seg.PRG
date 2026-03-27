**
** CONVIERTE SEGUNDOS NO FORMATO HHH:MM:SS
**
** parm1 = segundos  m.dummy,
**
Lparameters m.parm1
Local m.hora,m.minuto,m.segundo,m.dias
m.parm1   = INT(m.parm1)
m.hora    = INT(m.parm1/3600)
m.parm1   = m.parm1 - (m.hora*3600)
m.minuto  = INT(m.parm1/60)
m.segundo = m.parm1 - (m.minuto*60)
If m.hora > 24
	m.dias = int(m.hora / 24)
	m.hora = int(m.hora - (m.dias * 24))
	m.parm1 = STRTRAN( str(m.dias,2,0)+"d:"+STR(m.hora,2,0)+"h:"+STR(m.minuto,2,0)+"m:"+STR(m.segundo,2,0)+"s"," ","0")
Else
	m.parm1 = STRTRAN( STR(m.hora,2,0)+"h:"+STR(m.minuto,2,0)+"m:"+STR(m.segundo,2,0)+"s"," ","0")
Endif
If m.parm1 = "0"
	m.parm1 = SUBSTR(m.parm1,3)
	If m.parm1 = "0"
		m.parm1 = SUBSTR(m.parm1,2)
	Endif
Endif
Return m.parm1

