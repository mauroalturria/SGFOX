****
** actualizo movimiento de Historias SIN Turno
****
Parameter  mhcmnrohCli, mfechasal, mcodmed, mdescMed, mcodesp, mdescEsp, mretira, morigen, musu,;
	mdestino, mnroadm, mhcmregistrac, mcodespe, mfechaIngr

If vartype(mfechaIngr)#"T"
	mfechaIngr = ctod("01/01/1900")
Endif

mret= sqlexec(mcon1," insert into TabHCIMovst (hcmnrohCli,hcmfechasal,hcmcodmed,hcmdescMed,"  +;
	"hcmcodesp,hcmdescEsp,hcmretira,hcmorigen,hcmfechaTur,hcmfechaIngr,hcmusuario,hcmdestino,"+;
	"hcmnroadm,hcmregistrac,hcmcodesp) "+;
	" values (?mhcmnrohCli,?mfechasal,?mcodmed,?mdescMed,?mcodesp,?mdescEsp,?mretira,?morigen,"+;
	"?mfechaTur,?mfechaIngr,?musu,?mdestino,?mnroadm,?mhcmregistrac,?mcodespe)")

If mret < 0
	Messagebox('NO SE ACTUALIZO.  REINTENTE', 16, 'Validacion')
	mret = 0
Endif
