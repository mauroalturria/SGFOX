
*!* ------------------------- BUSCAMOS DATOS EN TABLA TABESTADOS ----------------------------------

mret=SQLExec(mcon1,"select * from tabestados where propietario=15 and estado>=1 and estado<=46","mwkgeneral")

If mret<1
    Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
    Messagebox("ERROR DE LECTURA",48,"VALIDACION")
    Return .F.
Endif

*!* ------------------------- BUSCAMOS DATOS EN TABLA MOTIVOS ---------------------------------------

mret=SQLExec(mcon1,"select id,motivotext from MOTIVOS where MOTIVOS.ID>=33 AND MOTIVOS.ID<=57 order by id asc","mwkmotiv")

If mret<1
    Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
    Messagebox("ERROR DE LECTURA",48,"VALIDACION")
    Return .F.
Endif

*!* ------------------------- BUSCAMOS DATOS EN TABLA TABAREADES --------------------------------------------------------

mret=SQLExec(mcon1,"select * from tabareades where ID>=1 AND id<=3","mwksector")

If mret<1
    Do Log_errores With Error(), Message(), Message(1), Program(), Lineno()
    Messagebox("ERROR DE LECTURA",48,"VALIDACION")
    Return .F.
Endif

*!* ------------------------ GENERAMOS CURSORES DE ESCRITURA-LECTURA DE TABLA TABESTADOS ---------------------------------

Select * From mwkgeneral Where estado>=4 And estado<=7 Into Cursor mwkcateg Readwrite  &&Cursor de categorías
Select * From mwkgeneral Where estado>=1 And estado<=3 Into Cursor mwkdev Readwrite    &&Cursor devolución
Select * From mwkgeneral Where tipo = 1 Into Cursor mwkareas Readwrite                 &&Cursor de Areas
Select * From mwkgeneral Where tipo = 2 Into Cursor mwksubadmi Readwrite               &&Cursor de Subarea Administrativa
Select * From mwkgeneral Where tipo = 3 Into Cursor mwksubmedica Readwrite             && Cursor de SubArea Medica
Select * From mwkgeneral Where tipo = 4 Into Cursor mwkrespo Readwrite                 && Cursor de Responsable

*!* ----------------------- GENERAMOS CURSORES DE ESCRITURA-LECTURA DE TABLA MOTIVOS -------------------------------------

* ESTOS CURSORES CONTIENEN LOS MOTIVOS Y DECISIONES DE DIRECCION A LA FECHA 2013-02-26

Select * From mwkmotiv Where Id<=52 Into Cursor MWKMOTIVO Readwrite                    &&Cursor de Motivo
Select * From mwkmotiv Where Id>=53 Into Cursor MWKDECISDIR Readwrite		           &&Cursor de Decisión Dirección

*!* ----------------------- GENERAMOS CURSORES DE ESCRITURA-LECTURA DE TABLA TABAREADES ------------------------------------

Select * From mwksector Into Cursor mwksector Readwrite  						       &&Cursor de sectores

*!* ---------------------- AGREGAMOS 1 REGISTRO EN BLANCO A CADA CURSOR ----------------------------------------------------

* LA AGREGACION SIRVE PARA QUE SE PUEDA GUARDAR SIN TENER TODOS LOS DATOS COMPLETOS; LOS FALTANTES SE GUARDAN EN BLANCO QUE
* ES ESTE REGISTRO QUE SE AGREGA AL CURSOR


Append Blank In mwksubmedica
Append Blank In mwkareas
Append Blank In mwkcateg
Append Blank In mwksubadmi
Append Blank In MWKDECISDIR
Append Blank In MWKMOTIVO
Append Blank In mwkdev
Append Blank In mwkrespo
Append Blank In mwksector