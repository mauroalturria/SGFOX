SELECT   QM_accionesFC, QM_cantidadDevFC, QM_cantidadDevQF, apv_cantso as QM_cantidadSol,;
  QM_codinsumo, QM_codproveedor, QM_fechaAccionFC, apv_fechac as QM_fechaCX,;
  QM_fechaDevFC, QM_fechaDevQF, QM_fechaFarma, QM_fecpasiva, QM_idAutprevias,;
 0 as  QM_idTabautprevias,apv_regist as  QM_idquiro, QM_lote, QM_lugarDev, QM_lugarOrigen,apv_descri as  QM_material,;
  QM_materialOK,nroregistr as  QM_nroregistrac,;
  QM_proveedor, QM_provistox,;
  QM_remito, apv_operso as QM_usuarioAccion,;
  QM_usuarioFarma, QM_usuarioIngreso,;
  QM_vencim FROM tabquiromate,autmate INTO CURSOR nuevo readwrite