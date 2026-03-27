Parameters Mvar,ntipo,Id

mid = Id

Do Case

Case ntipo = 1

	lcSQL = 'insert into ZabEstratificacion '+;
		'(ZES_registracion,ZES_tasistolica,ZES_tadiastolica,ZES_freccardiaca,ZES_frecrespiratoria,'+;
		'ZES_saturacion,ZES_reqoxigeno,ZES_temperatura,'+;
		'ZES_hipertension,ZES_enfcoronaria,ZES_insuficoronaria,ZES_enfvascular,ZES_enfcerebrovascular,'+;
		'ZES_demencia,ZES_enfpulmonar,ZES_conectivopatias,ZES_ulcerapeptica,ZES_pathepaticaleve,'+;
		'ZES_pathepaticamode,ZES_diabetes,ZES_diabeteslesionorg,ZES_hemiplejia,ZES_patrenal,'+;
		'ZES_neoplasias,ZES_tumorsolido,ZES_sida,ZES_rfdisnea,ZES_rfsrneumonia,ZES_scorenews,'+;
		'ZES_scorecharlson,ZES_evolucion,ZES_medico,ZES_idmedico,ZES_fechahora,ZES_estado,ZES_estadopac) '+;
		'values '+;
		'(?mvar(1),?mvar(2),?mvar(3),?mvar(4),?mvar(5),?mvar(6),?mvar(8),?mvar(9),?mvar(10),'+;
		'?mvar(11),?mvar(12),?mvar(13),?mvar(14),?mvar(15),?mvar(16),?mvar(17),?mvar(18),?mvar(19),'+;
		'?mvar(20),?mvar(21),?mvar(22),?mvar(23),?mvar(24),?mvar(25),?mvar(26),?mvar(27),?mvar(28),'+;
		'?mvar(29),?mvar(30),?mvar(31),?mvar(32),?mvar(33),?mvar(34),?mvar(35),?mvar(36),?mvar(37))'


*!*	lcSQL = 'update ZabEstratificacion '+;
*!*		'ZES_registracion = ?mvar(1), '+;
*!*		'ZES_tasistolica = ?mvar(2), '+;
*!*		'ZES_tadiastolica = ?mvar(3), '+;
*!*		'ZES_freccardiaca = ?mvar(4), '+;
*!*		'ZES_frecrespiratoria = ?mvar(5), '+;
*!*		'ZES_saturacion = ?mvar(6), '+;
*!*		'ZES_reqoxigeno = ?mvar(8), '+;
*!*		'ZES_temperatura = ?mvar(9), '+;
*!*		'ZES_hipertension = ?mvar(10), '+;
*!*		'ZES_enfcoronaria = ?mvar(11), '+;
*!*		'ZES_insuficoronaria = ?mvar(12), '+;
*!*		'ZES_enfvascular = ?mvar(13), '+;
*!*		'ZES_enfcerebrovascular = ?mvar(14), '+;
*!*		'ZES_demencia = ?mvar(15), '+;
*!*		'ZES_enfpulmonar = ?mvar(16), '+;
*!*		'ZES_conectivopatias = ?mvar(17), '+;
*!*		'ZES_ulcerapeptica = ?mvar(18), '+;
*!*		'ZES_pathepaticaleve = ?mvar(19), '+;
*!*		'ZES_pathepaticamode = ?mvar(20), '+;
*!*		'ZES_diabetes = ?mvar(21), '+;
*!*		'ZES_diabeteslesionorg = ?mvar(22), '+;
*!*		'ZES_hemiplejia = ?mvar(23), '+;
*!*		'ZES_patrenal = ?mvar(24), '+;
*!*		'ZES_neoplasias = ?mvar(25), '+;
*!*		'ZES_tumorsolido = ?mvar(26), '+;
*!*		'ZES_sida = ?mvar(27), '+;
*!*		'ZES_rfdisnea = ?mvar(28), '+;
*!*		'ZES_rfsrneumonia = ?mvar(29), '+;
*!*		'ZES_scorenews = ?mvar(30), '+;
*!*		'ZES_scorecharlson = ?mvar(31), '+;
*!*		'ZES_evolucion = ?mvar(32), '+;
*!*		'ZES_medico = ?mvar(33), '+;
*!*		'ZES_usuario = ?mvar(34), '+;
*!*		'ZES_fechahora = ?mvar(35)'

* Se quitó mvar(7) = fio2 a pedido de Nahuel. Mail 2020-06-23

Case ntipo = 2
	lcSQL = 'Update ZabEstratificacion set zes_estado = 0 where id = ?mid' && No Confirmado / Descartado

Case ntipo = 3
	lcSQL = 'Update ZabEstratificacion set zes_estado = 2 where id = ?mid' && Confirmado

Endcase


mret = SQLExec(mcon1,lcSQL,'')
If mret<0
	Messagebox('Avise a sistemas por favor.',16,'Error en la grabación (Estratificación)')
Endif
