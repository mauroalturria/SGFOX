****
**  Seteos del sistema
****

Public block_ent,mxcentromedico 
mxcentromedico =1

block_ent = ''


do prg_var_public
mxambito = 1
lcTitle = 'MonitorWL'
lcNomExe = 'MONITORWL'

Do prg_set
Do seteos_ip && aca se asigna la MyIp

Do prg_creo_Dirs
Do seteos_public

With _Screen
	.Caption = lcTitle 
	.WindowState = 2
	.KeyPreview = .T. && ver si hace falta
	.icon = 'investiga.ICO'
Endwith 	
 
DO buscoini WITH "MONITOR1"
 
Do sp_busco_server_namespaces
Do prg_setDatabase
 myip = IPAddress()

mresplog = 0
Do sp_busco_server_namespaces
Do sp_conexion With "MONITOR1"

Do form frmmonitorWL


Do sp_desconexion
procedure MF2 
procedure AFECHAS 
procedure EROS 


