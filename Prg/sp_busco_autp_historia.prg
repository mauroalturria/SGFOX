*********
** Busco Historial de la admision
*********
Parameters mcodAdmision,mbusca
If Vartype(mbusca)<>"C"
	mbusca=''
Endif
mret = SQLExec(mcon1," select APV_FechaSolicitud,APV_subestadopend->descrip,"+;
" APV_CodInsuSolic->INS_descriinsumo, APV_CodPrestSolic->PRE_descriprest,"+;
" apv_cantSolicitada,apv_cantAutorizada,apv_presinsu, APV_estado->descrip as descest"+;
",APV_CodPrestSolic->PRE_CargaQuirofano "+;
" from AutPrevias,coberturas,entidades, sectores  "+;
" where COB_pacientes = APV_CodAdmision and COB_codentidad   = ENT_codent "+;
" and APV_CodAdmision->PAC_sectorinternac = sec_codsector "+;
" and APV_CodAdmision->PAC_codadmision = ?mcodAdmision "+mbusca,"mwkHistorial")

If mret<1
	=Aerr(eros)
	Messagebox(eros(3))
Endif

Select APV_FechaSolicitud As fecha,Iif(Empty(Nvl(Descrip,'')+Nvl(descest,'')),Space(20);
,Iif(Empty(Nvl(Descrip,'')),descest,Descrip)) As estado,;
iif(Isnull(PRE_descriprest),Space(20),PRE_descriprest) As Solicitado ;
,apv_cantSolicitada As CantSolic,Iif(Isnull(apv_cantAutorizada),0,apv_cantAutorizada) As CantAut;
from mwkhistorial Where apv_presinsu = 'P' Union All;
select APV_FechaSolicitud As fecha,Iif(Isnull(Descrip),'',Descrip) As estado,;
iif(Isnull(INS_descriinsumo),Space(20),INS_descriinsumo) As Solicitado ;
,apv_cantSolicitada As CantSolic,Iif(Isnull(apv_cantAutorizada),0,apv_cantAutorizada) As CantAut;
from mwkHistorial Where apv_presinsu = 'I' Into Cursor mwkHistorial2

