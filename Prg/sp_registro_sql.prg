Parameters nxestado,nxerror
miSO = OS(1)

loWMI = Getobject("winmgmts:\\.\root\cimv2") 	
loOS = loWMI.ExecQuery("SELECT * FROM Win32_OperatingSystem") 
For Each objOS In loOS		
lcCaption = Upper(objOS.Caption) 
miSO= lcCaption	
ENDFOR
 
mfechoy = sp_busco_fecha_serv("DT")
mret = SQLExec(mcon1," select id,CS_Estado , CS_IP , CS_Windows   from ZabCtrlSQL "+;
	"where CS_IP = ?myip  " , "mwkBuscoReg")
If mret<1
	=Aerr(eros)
	Messagebox(eros(3))
Endif
If nxestado<0
	nxestado =0
Else
	nxestado =1
Endif
lcSql = ''
If Reccount( "mwkBuscoReg")>0
	If !(miSO = CS_Windows And CS_Estado = nxestado)
		mid = Id
		lcSql =" update ZabCtrlSQL  set CS_Windows = ?miso,CS_Estado =?nxestado,CS_Error = ?nxerror "+;
			",FecHorDbUpd  =?mfechoy  where id = ?mid "
	Endif
Else
	lcSql = "Insert Into ZabCtrlSQL (CS_Error , CS_Estado , CS_IP , CS_Windows ) "+;
		" values (?nxerror, ?nxestado , ?myip  , ?miSO )"
Endif

If !Empty(lcSql )
	If !prg_ejecutosql(lcSql)
		Return .F.
	Endif
Endif
