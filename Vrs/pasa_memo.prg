****
** Pasa dato en cursor mwklista a archivo de texto
****



mcArch = Getfile("txt", 'Nombre Archivo:','Aceptar')

mnarch = Fcreate(mcArch)
Select mwklista
Scan
*!*		mccad =  Transform(Id)+ Chr(9)+Transform(av_codent)+ Chr(9)+Transform(av_codcont)+ Chr(9)+Transform(av_prestacion);
*!*		+ Chr(9)+Dtoc(av_fecha)+ Chr(9)+Ttoc(av_fechaum)+ Chr(9)+Nvl(ent_descrient,'') +Chr(9)+ Nvl(pre_descriprest,'') +Chr(9)
	mccad =  Transform(Id)+ Chr(9)+Transform(av_codent)+ Chr(9)+Transform(av_codcont)+ Chr(9)+Transform(av_prestacion);
	+ Chr(9)+Dtoc(av_fecha)+ Chr(9)+Ttoc(av_fechaum)+ Chr(9)+Nvl(ent_descrient,'')  +Chr(9)

	mlinea = Alines(cavi,av_aviso)
 
	For i= 1 To mlinea
		mccad =mccad +cavi(i)+IIF(i<mlinea,CHR(1),'')
	Next
	Fputs(mnarch, mccad)
Endscan
Fclose(mnarch)




SELECT id,codmed,mensjes,turnos,web,nombre FROM mensajes INNER JOIN prestadores ON codmed = prestadores.id INTO CURSOR mensajesmedicos
SELECT id,codmed,mensaje,turnos,web,nombre FROM tabmensajes INNER JOIN prestadores ON codmed = prestadores.id INTO CURSOR mensajesmedicos
SELECT tabmensajes.id,codmed,mensaje,turnos,web,nombre FROM tabmensajes INNER JOIN prestadores ON codmed = prestadores.id INTO CURSOR mensajesmedicos
BROWSE LAST
SELECT tabmensajes.id,codmed,LEFT(mensaje,250) as mensa,turnos,web,nombre FROM tabmensajes INNER JOIN prestadores ON codmed = prestadores.id INTO CURSOR mensajesmedicos
BROWSE LAST
COPY TO mens_medicos TYPE csv
SELECT LEN(ALLTRIM(mensaje)) as lar,tabmensajes.id,codprest,LEFT(mensaje,250) as mensa,turnos,web;
,pre_descriprest FROM tabmensajes INNER JOIN prestaciones ON codprest = pre_codprest INTO CURSOR mpresta
SELECT LEN(ALLTRIM(mensaje)) as lar,tabmensajes.id,codprest,LEFT(mensaje,250) as mensa,turnos,web;
,pre_descriprest FROM tabmensajes INNER JOIN prestacion ON codprest = pre_codprest INTO CURSOR mpresta
BROWSE LAST
SELECT MAX(lar) FROM mpresta
SELECT tabmensajes.id,codprest,LEFT(mensaje,250) as mensa,turnos,web;
,pre_descriprest FROM tabmensajes INNER JOIN prestacion ON codprest = pre_codprest INTO CURSOR mpresta
BROWSE LAST
COPY TO mens_presta TYPE csv
SELECT distinct codespm,codservm FROM tabmensajes
SELECT * FROM tabmensajes WHERE codserv>0
BROWSE LAST
SELECT * FROM tabmensajes WHERE codserv>0
SELECT * FROM tabmensajes WHERE codservm>0
MODIFY VIEW servicios
SELECT tabmensajes.id,codservm,LEFT(mensaje,250) as mensa,turnos,web;
,SER_descripserv FROM tabmensajes INNER JOIN prestacion ON codprest = SER_codserv INTO CURSOR mserv
SELECT tabmensajes.id,codservm,LEFT(mensaje,250) as mensa,turnos,web;
,SER_descripserv FROM tabmensajes INNER JOIN servicios ON codprest = SER_codserv INTO CURSOR mserv
BROWSE LAST
SELECT tabmensajes.id,codservm,LEFT(mensaje,250) as mensa,turnos,web;
,SER_descripserv FROM tabmensajes INNER JOIN servicios ON codservm= SER_codserv INTO CURSOR mserv
BROWSE LAST
COPY TO mens_servicio TYPE csv
MODIFY VIEW especialidad
SELECT tabmensajes.id,codespm,LEFT(mensaje,250) as mensa,turnos,web;
,esp_descriesp  FROM tabmensajes INNER JOIN servicios ON codespm= esp_codesp INTO CURSOR mesp
SELECT 24
SELECT 18
BROWSE LAST
SELECT tabmensajes.id,codespm,LEFT(mensaje,250) as mensa,turnos,web;
,esp_descripcion  FROM tabmensajes INNER JOIN especialidad ON codespm= esp_codesp INTO CURSOR mesp
BROWSE LAST
SELECT  LEN(ALLTRIM(mensaje)) as lar,tabmensajes.id,codespm,LEFT(mensaje,250) as mensa,turnos,web;
,esp_descripcion  FROM tabmensajes INNER JOIN especialidad ON codespm= esp_codesp INTO CURSOR mesp
BROWSE LAST
SELECT  tabmensajes.id,codespm,LEFT(mensaje,250) as mensa,turnos,web;
,esp_descripcion  FROM tabmensajes INNER JOIN especialidad ON codespm= esp_codesp INTO CURSOR mesp
COPY TO mens_espec TYPE csv
SELECT * FROM tabmnsajes WHERE codmed>0
SELECT * FROM tabmensajes WHERE codmed>0
SELECT 14
BROWSE LAST
 INNER JOIN especialidad ON codespm= esp_codesp INTO CURSOR mesp
SELECT  LEN(ALLTRIM(av_aviso)) as lar,*  FROM avisos
SELECT  avisos.*,ent_descrient  FROM avisos INNER JOIN entidades ON av_codent = ent_codent INTO CURSOR aventi
BROWSE LAST
SELECT  avisos.*,ent_descrient  FROM avisos left JOIN entidades ON av_codent = ent_codent ;
BROWSE LAST
SELECT  avisos.*,ent_descrient  FROM avisos left JOIN entidades ON av_codent = ent_codent ;
LEFT JOIN prestacion ON av_prestacion = pre_codprest INTO CURSOR avisos
BROWSE LAST
MODIFY VIEW avisos
SELECT  ID, AV_codent, AV_codcont, AV_prestacion, AV_aviso,;
  AV_Fecha, AV_FechaUM, ent_descrient ,pre_descriprest  ;
 FROM avisos left JOIN entidades ON av_codent = ent_codent ;
LEFT JOIN prestacion ON av_prestacion = pre_codprest INTO CURSOR avis
BROWSE LAST
SELECT * FROM avis WHERE !(av_codent>0 AND !ISNULL(ent_descrient))
SELECT * FROM avis WHERE !(av_codent>0 AND ISNULL(ent_descrient))
BROWSE LAST
SELECT * FROM avis WHERE !((av_codent>0 AND ISNULL(ent_descrient)) OR (av_prestacion>0 AND ISNULL(pre_descriprest)))
SELECT * FROM avis WHERE !((av_codent>0 AND ISNULL(ent_descrient)) OR (av_prestacion>0 AND ISNULL(pre_descriprest)));
AND av_codent = 948
COPY TO aviss TYPE sdf
COPY TO aviss
Do prg_pasa_listado With "avisos.txt"
SELECT * FROM avis WHERE !((av_codent>0 AND ISNULL(ent_descrient)) OR (av_prestacion>0 AND ISNULL(pre_descriprest)));
AND av_codent = 948 INTO cursro mwklista
SELECT * FROM avis WHERE !((av_codent>0 AND ISNULL(ent_descrient)) OR (av_prestacion>0 AND ISNULL(pre_descriprest)));
AND av_codent = 948 INTO cursor mwklista
Do prg_pasa_listado With "avisos.txt"
BROWSE LAST
Do prg_pasa_listado With "avis.txt"
MODIFY COMMAND c:\desaguemes\prg\prg_pasa_listado_cons.prg AS 1252
SELECT 28
BROWSE LAST
DO c:\desaguemes\vrs\pasa_memo.prg
SELECT * FROM avis WHERE !((av_codent>0 AND ISNULL(ent_descrient)) OR (av_prestacion>0 AND ISNULL(pre_descriprest)));
 INTO cursor mwklista
DO c:\desaguemes\vrs\pasa_memo.prg
MODIFY COMMAND c:\desaguemes\vrs\pasa_memo.prg AS 1252
DO c:\desaguemes\vrs\pasa_memo.prg
RESUME
DO c:\desaguemes\vrs\pasa_memo.prg
MODIFY VIEW tabusuario