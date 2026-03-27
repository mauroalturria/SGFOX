****
**  Busco Observaciones anteriores del paciente
****

parameter mnroregistra

mret = sqlexec(mcon1,"select id,TROObserva, TRO_FechaHora  from Tabregobs " + ;
	"where TRO_Registracio = ?mnroregistra " , "mwkregobs")
