update pacvip  set tpv_audit = .f. where empty(tpv_observa) 
update pacvip  set tpv_audit = .f. where empty(tpv_observa)

update pacvip  set tpv_audit = .f. where alltrim(tpv_observa)='AMB - INGRESO' and tpv_estado = 2
update pacvip  set tpv_audit = .f. where alltrim(tpv_observa)='GUA - INGRESO' and tpv_estado = 2
update pacvip  set tpv_audit = .f. where alltrim(tpv_observa)='INT- INGRESO' and tpv_estado = 2
update pacvip  set tpv_audit = .f. where empty(tpv_observa) and tpv_estado = 2
update pacvip  set tpv_audit = .f. where empty(tpv_observa)
update pacvip  set tpv_audit = .f. where empty(tpv_observa) and id>41193
tablerevert(.t.)