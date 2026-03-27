****
** Busco admision para modificar datos
****

Parameter mnroadm
If mxcentromedico = 1
	mcm = " and  pac_centromedico <>3 "
Else
	mcm = " and  pac_centromedico = ?mxcentromedico "
Endif
mret = SQLExec(mcon1, "select pacientes.* " + ;
	", Observa, Urgencia , descripdiagn "+;
	"from pacientes  " + ;
	" left join TabProtQuir on pacientes.PAC_codadmision= TabProtQuir.Codadmision"+;
	" where PAC_codadmision = ?mnroadm "+mcm+;
	"  group by PAC_codadmision " , "mwkadmi")

