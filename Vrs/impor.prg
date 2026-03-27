create cursor anula (TELEFONO n(10),RTA c(20),CONFIRMA c(20),CANCELA c(20),NOMBRE c(50),HCLIN c(20),N_REF n(10);
	,FECHA_TURNO D,TIPO_TEL c(20),FECHA_LLAMADO D,TURNO c(20))

append from "c:\desaguemes\TURNOS_31.07_C_noche.xlsx" type xls