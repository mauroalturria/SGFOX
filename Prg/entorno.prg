public _p         && _P es el Objeto que contiene todas las variables de
&& entorno del sistema
_p = createobject("PARAM")
set confirm off
set score   off
set status  off
set century off
set safety  off
set talk    off
set date    british
set memowidth to 100
set exclusive off
set multilocks on
set deleted on

define class param as custom
	*   PROTECTED LogonTime, AccessLevel
	xx_usuario = '0'  && OJO NO SE GRABA ESTA SOLO PARA TENERLO PUBLICO
&& LO GRABA LA PANTALLA DE LOGIN
	xx_perdiolinkeo = .f.  && para saber si perdio el linkeo por salir a DOS
	xx_nomusu  = " "
	xx_nivelusu = 255
	xx_chgnivel = .f.
	xx_es_admin = .f.
	xx_impresor =	"Ninguno"
	xx_nhandler =  -1
	xx_puerto	=	0
	xx_memoria	=	""
	xx_irq		=	0	&&  Los actualiza en impfic()
	xx_sql      =   -1
	xx_usuario_unico = .f.
	xx_sqlerror =   .f.   && Indica Error en Conexión SQL
	xx_seteomenu =  .f.  && Indica si las opciones de acceso al menu fueron seteadas
	xp_sqlconn   =  " "
	xp_sqlserv	 =  " "
	xx_sqlotrosrv = " "  && Conexion con otro servidor 
	xp_sqluser	 =  " "
	xp_sqlpass	 =  " "
	xp_sqlwsid	 =  " "
	xp_sqlbase	 =  " "
	xp_sqllang	 =  " "
	xp_backup    =  "C:\MSSQL\BACKUPS\"
	xp_pbmpath   =  " "
	xp_osecacpath = " "
	xp_siemensPath = " "
	xp_kvales = 0
	xp_kncr   = 0
	xp_adonde = " "
	xp_altp   = .t.
	xp_avance = 0
	xp_barra  =  .t.
	xp_bdonde =  0
	xp_blank  =  0
	xp_nrodisk = 0
	xp_caja   =  .t.
	xp_sinvend = .f.
	xp_total_ticket = .f.
	xp_cartel =  .t.
	xp_cfport =  0
	xp_comodin=  " "
	xp_credit =  .t.
	xp_descast=  .t.
	xp_desofet=  .t.
	xp_destarj=  .t.
	xp_con_segur= .f.
	xp_empresa=  " "
	xp_fac    =  " "
	xp_graba  =  .t.
	xp_grupo  =  0
	xp_impre  =  0
	xp_letra  = " "
	xp_margen = .t.
	xp_modem   = " "
	xp_op_vta  = 0
	xp_orden   = 0
	xp_os      = .t.
	xp_of_desde = date()
	xp_of_hasta = date()
	xp_of_min   = 1
	xp_pordond = .t.
	xp_produ   = .t.
	xp_red     = " "
	xp_socio   = 0
	xp_socsud  = 0
	xp_socsui  = 0
	xp_stock   = .t.
	xp_tickea  = .t.
	xp_pbm     = .t.
	xp_imed     = .t.
	xp_osecac   = .t.
	xp_vtaosauto = .t.
	xp_tipo    = " "
	xp_pedval = .t.
	xp_pregval = .f.
	xp_tipvale  = .t.
	xp_discriva = .f.
	xp_concata = .f.


	xp_pregtipvale = .f.
	xp_ctcj1 = 0
	xp_ctcj2 = 0
	xp_ctcj3 = 0
	xp_ctcj4 = 0
	
	xp_ctcj1x = 0
	xp_ctcj2x = 0
	xp_ctcj3x = 0
	xp_ctcj4x = 0
	
	xp_vtaacu_ped = 30
	xp_nombre = " "
	xp_nomfant = " "
	xp_direccion = " "
	xp_cuit = " "
	xp_civa = 0
	xp_ciudad = " "
	xp_provincia = " "
	xp_pais = " "
	xp_telefo = "0"
	xp_version  = " "
	xp_email   = " "
	xp_texto1 = " "
	xp_texto2 = " "
	xp_texto3 = " "
	xp_texto4 = " "
	xp_texto5 = " "
	xp_pie1 = " "
	xp_pie2 = " "
	xp_pie3 = " "
	xp_pie4 = " "

	xp_direct = .t.
	xp_pathorig = " "
	xp_pathdest = " "
	xp_servaux  = " "
	xp_exes = " "
	xp_datos = " "
	xp_estad = " "
	xp_nove  = " "
	*   xp_cintas = " "

	xp_txtf1 = " "
	xp_txtf2 = " "
	xp_txtf3 = " "
	xp_txtf4 = " "
	xp_txtf5 = " "
	xp_txtf6 = " "
	xp_txtf7 = " "
	xp_txtf8 = " "
	xp_txtf9 = " "
	xp_txtf10= " "
	xp_txtf11= " "
	xp_txtf12= " "

	xp_txtfl1 = .t.
	xp_txtfl2 = .t.
	xp_txtfl3 = .t.
	xp_txtfl4 = .t.
	xp_txtfl5 = .t.
	xp_txtfl6 = .t.
	xp_txtfl7 = .t.
	xp_txtfl8 = .t.
	xp_txtfl9 = .t.
	xp_txtfl10= .t.
	xp_txtfl11= .t.
	xp_txtfl12= .t.

	xp_fecha = date()        && Controla la fecha de trabajo
	xp_fechrec = .f.		&& Controla si se pide o no la fecha de la receta
	xp_stkneg = .f.			&& Controla si toma en cuenta los (-) en pedidos
	xp_refri = .t.
	xp_stm	 = .f.
	xp_val   = .t.
	xp_vuelto= .f.

enddefine