*       *********************************************************
*       *                                                         
*       * 17/08/2006           menu1.MPR            15:24:56  
*       *                                                         
*       *********************************************************
*       *                                                         
*       * Nombre del autor                                        
*       *                                                         
*       * Copyright (C) 2006 Sanatorio Güemes                     
*       * Dirección                                               
*       * Ciudad,     Código pos                                  
*       * País                                              
*       *                                                         
*       * Descripción:                                            
*       * Este PROGRAMA lo ha generado automáticamente GENMENU.    
*       *                                                         
*       *********************************************************


*       *********************************************************
*       *                                                         
*       *                    Definición de menú                   
*       *                                                         
*       *********************************************************
*
LPARAMETERS oFormRef, getMenuName, lUniquePopups, parm4, parm5, parm6, parm7, parm8, parm9
LOCAL cMenuName, nTotPops, a_menupops, cTypeParm2, cSaveFormName
IF TYPE("m.oFormRef") # "O" OR ;
  LOWER(m.oFormRef.BaseClass) # 'form' OR ;
  m.oFormRef.ShowWindow # 2
	MESSAGEBOX([Sólo puede llamar a este menú desde un formulario de nivel superior.  Confirme que la propiedad ShowWindow del formulario es 2.  Más información en la sección de encabezado del archivo MPR del menú.])
	RETURN
ENDIF
m.cTypeParm2 = TYPE("m.getMenuName")
m.cMenuName = "Menu1"  && SYS(2015)
m.cSaveFormName = m.oFormRef.Name
IF m.cTypeParm2 = "C" OR (m.cTypeParm2 = "L" AND m.getMenuName)
	m.oFormRef.Name = m.cMenuName
ENDIF
IF m.cTypeParm2 = "C" AND !EMPTY(m.getMenuName)
	m.cMenuName = m.getMenuName
ENDIF

*       *********************************************************
*       *                                                         
*       *                    Definición de menú                   
*       *                                                         
*       *********************************************************
*

DEFINE MENU menu1 IN (m.oFormRef.Name) BAR

DEFINE PAD _1vj0x1h5m OF menu1 PROMPT "Salir" COLOR SCHEME 3 ;
	KEY ALT+S, ""
DEFINE PAD _1vj0x1h62 OF menu1 PROMPT "Tablas Varias" COLOR SCHEME 3 ;
	KEY ALT+T, ""
DEFINE PAD _1vj0x1h63 OF menu1 PROMPT "Presupuesto" COLOR SCHEME 3 ;
	KEY ALT+P, ""
DEFINE PAD _1vj0x1h64 OF menu1 PROMPT "Consultas" COLOR SCHEME 3 ;
	KEY ALT+C, ""
DEFINE PAD _1vj0x1h65 OF menu1 PROMPT "Usuarios" COLOR SCHEME 3 ;
	KEY ALT+U, ""
ON PAD _1vj0x1h5m OF menu1 ACTIVATE POPUP salir
ON PAD _1vj0x1h62 OF menu1 ACTIVATE POPUP tablasvari
ON PAD _1vj0x1h63 OF menu1 ACTIVATE POPUP _1sy0tnw2j
ON PAD _1vj0x1h64 OF menu1 ACTIVATE POPUP consultas
ON PAD _1vj0x1h65 OF menu1 ACTIVATE POPUP usuarios

DEFINE POPUP salir MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 1 OF salir PROMPT "Cerrar aplicacion"
DEFINE BAR 2 OF salir PROMPT "Acerca de.." ;
	SKIP FOR type('mfrmacercade') = 'U'
ON SELECTION BAR 1 OF salir ;
	DO _1vj0x1h66 ;
	IN LOCFILE("MNU\menu1" ,"MPX;MPR|FXP;PRG" ,"DÓNDE está menu1?")
ON SELECTION BAR 2 OF salir do form frmacercade

DEFINE POPUP tablasvari MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 1 OF tablasvari PROMPT "Cambio de Password"
DEFINE BAR 2 OF tablasvari PROMPT "Condiciones de Pago"
DEFINE BAR 3 OF tablasvari PROMPT "Conceptos"
DEFINE BAR 4 OF tablasvari PROMPT "ModulosPrestaciones"
DEFINE BAR 5 OF tablasvari PROMPT "Modulos Integrales"
ON SELECTION BAR 1 OF tablasvari do form frmpass_amb
ON SELECTION BAR 2 OF tablasvari do form frmpresu01
ON SELECTION BAR 3 OF tablasvari do form frmpresu02
ON SELECTION BAR 4 OF tablasvari do form frmpresu04
ON SELECTION BAR 5 OF tablasvari do form frmpresu05

DEFINE POPUP _1sy0tnw2j MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 1 OF _1sy0tnw2j PROMPT "Crear Presupuesto"
DEFINE BAR 2 OF _1sy0tnw2j PROMPT "Cambio de Estado"
ON SELECTION BAR 1 OF _1sy0tnw2j do form frmpresu11
ON SELECTION BAR 2 OF _1sy0tnw2j do form frmpresu18

DEFINE POPUP consultas MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 1 OF consultas PROMPT "Consulta por Estado"
DEFINE BAR 2 OF consultas PROMPT "Consulta por Modulo o Paciente"
ON SELECTION BAR 1 OF consultas do form frmpresu16
ON SELECTION BAR 2 OF consultas do form frmpresu17

DEFINE POPUP usuarios MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 1 OF usuarios PROMPT "Alta Usuario"
ON SELECTION BAR 1 OF usuarios do form frmpresu20

ACTIVATE MENU menu1 NOWAIT


*       *********************************************************
*       *                                                         
*       * _1VJ0X1H66  ON SELECTION BAR 1 OF POPUP salir           
*       *                                                         
*       * Procedure Origin:                                       
*       *                                                         
*       * From Menu:  menu1.MPR,            Record:    5      
*       * Called By:  ON SELECTION BAR 1 OF POPUP salir           
*       * Prompt:     Cerrar aplicacion                           
*       * Snippet:    1                                           
*       *                                                         
*       *********************************************************
*
PROCEDURE _1vj0x1h66
frmpresu00.release()
clear events
do sp_desconexion with "Presupuestos"
do sp_logoff
quit

