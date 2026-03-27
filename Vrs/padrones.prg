
set date french
set century on
set talk on
suspend
*mcon1= SQLCONNECT('Conexion a Desarrollo Padron','_system','sys')
mcon1= sqlconnect('conec01','_system','sys')
i= 0
do while i <= 0
	mentidadagrupadora = 0
	do case
*!*

*!*	CASE i = 21
*!*	SET DEFAULT TO c:\pad\gastro\070912\
*!*	mentidadagrupadora = 948
*!*	mfechaproceso = CTOD('12/09/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-09"
*!*	mfecdesde = CTOD('01/09/2007')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 22
*!*	SET DEFAULT TO c:\pad\gastro\071017\
*!*	mentidadagrupadora = 948
*!*	mfechaproceso = CTOD('17/10/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-10"
*!*	mfecdesde = CTOD('01/10/2007')
*!*	mfechasta = CTOD('01/01/2100')


*!*	CASE i = 23
*!*	SET DEFAULT TO c:\pad\gastro\071112\
*!*	mentidadagrupadora = 948
*!*	mfechaproceso = CTOD('12/11/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-11"
*!*	mfecdesde = CTOD('01/11/2007')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 24
*!*	SET DEFAULT TO c:\pad\gastro\071214\
*!*	mentidadagrupadora = 948
*!*	mfechaproceso = CTOD('14/12/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-12"
*!*	mfecdesde = CTOD('01/12/2007')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 25
*!*	SET DEFAULT TO c:\pad\gastro\080115\
*!*	mentidadagrupadora = 948
*!*	mfechaproceso = CTOD('15/01/2008')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2008-01"
*!*	mfecdesde = CTOD('01/01/2008')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 26
*!*	SET DEFAULT TO c:\pad\gastro\080215\
*!*	mentidadagrupadora = 948
*!*	mfechaproceso = CTOD('15/02/2008')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2008-02"
*!*	mfecdesde = CTOD('01/02/2008')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 27
*!*	SET DEFAULT TO c:\pad\gastro\080314\
*!*	mentidadagrupadora = 948
*!*	mfechaproceso = CTOD('14/03/2008')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2008-03"
*!*	mfecdesde = CTOD('01/03/2008')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 28
*!*	SET DEFAULT TO c:\pad\gastro\080415\
*!*	mentidadagrupadora = 948
*!*	mfechaproceso = CTOD('15/04/2008')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2008-04"
*!*	mfecdesde = CTOD('01/04/2008')
*!*	mfechasta = CTOD('01/01/2100')


*!*	CASE i = 29
*!*	SET DEFAULT TO c:\pad\gastro\080514\
*!*	mentidadagrupadora = 948
*!*	mfechaproceso = CTOD('14/05/2008')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2008-05"
*!*	mfecdesde = CTOD('01/05/2008')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 30
*!*	SET DEFAULT TO c:\pad\gastro\080613\
*!*	mentidadagrupadora = 948
*!*	mfechaproceso = CTOD('13/06/2008')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2008-06"
*!*	mfecdesde = CTOD('01/06/2008')
*!*	mfechasta = CTOD('01/01/2100')



*!*	CASE i = 41
*!*	SET DEFAULT TO c:\pad\ospihym\070910\
*!*	mentidadagrupadora = 988
*!*	mfechaproceso = CTOD('10/09/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-09"
*!*	mfecdesde = CTOD('01/09/2007')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 42
*!*	SET DEFAULT TO c:\pad\ospihym\071009\
*!*	mentidadagrupadora = 988
*!*	mfechaproceso = CTOD('09/10/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-10"
*!*	mfecdesde = CTOD('01/10/2007')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 43
*!*	SET DEFAULT TO c:\pad\ospihym\071112\
*!*	mentidadagrupadora = 988
*!*	mfechaproceso = CTOD('12/11/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-11"
*!*	mfecdesde = CTOD('01/11/2007')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 44
*!*	SET DEFAULT TO c:\pad\ospihym\071214\
*!*	mentidadagrupadora = 988
*!*	mfechaproceso = CTOD('14/12/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-12"
*!*	mfecdesde = CTOD('01/12/2007')
*!*	mfechasta = CTOD('01/01/2100')


*!*	CASE i = 45
*!*	SET DEFAULT TO c:\pad\ospihym\080109\
*!*	mentidadagrupadora = 988
*!*	mfechaproceso = CTOD('09/01/2008')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2008-01"
*!*	mfecdesde = CTOD('01/01/2008')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 46
*!*	SET DEFAULT TO c:\pad\ospihym\080205\
*!*	mentidadagrupadora = 988
*!*	mfechaproceso = CTOD('05/02/2008')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2008-02"
*!*	mfecdesde = CTOD('01/02/2008')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 47
*!*	SET DEFAULT TO c:\pad\ospihym\080304\
*!*	mentidadagrupadora = 988
*!*	mfechaproceso = CTOD('04/03/2008')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2008-03"
*!*	mfecdesde = CTOD('01/03/2008')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 48
*!*	SET DEFAULT TO c:\pad\ospihym\080415\
*!*	mentidadagrupadora = 988
*!*	mfechaproceso = CTOD('15/04/2008')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2008-04"
*!*	mfecdesde = CTOD('01/04/2008')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 49
*!*	SET DEFAULT TO c:\pad\ospihym\080514\
*!*	mentidadagrupadora = 988
*!*	mfechaproceso = CTOD('14/05/2008')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2008-05"
*!*	mfecdesde = CTOD('01/05/2008')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 50
*!*	SET DEFAULT TO c:\pad\ospihym\080609\
*!*	mentidadagrupadora = 988
*!*	mfechaproceso = CTOD('09/06/2008')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2008-06"
*!*	mfecdesde = CTOD('01/06/2008')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 51
*!*	SET DEFAULT TO c:\pad\ospihym\080710\
*!*	mentidadagrupadora = 988
*!*	mfechaproceso = CTOD('10/07/2008')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2008-07"
*!*	mfecdesde = CTOD('01/07/2008')
*!*	mfechasta = CTOD('01/01/2100')




*!*	CASE i = 71
*!*	SET DEFAULT TO c:\pad\papel\070910\
*!*	mentidadagrupadora = 904
*!*	mfechaproceso = CTOD('10/09/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-09"
*!*	mfecdesde = CTOD('01/09/2007')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 72
*!*	SET DEFAULT TO c:\pad\papel\071009\
*!*	mentidadagrupadora = 904
*!*	mfechaproceso = CTOD('09/10/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-10"
*!*	mfecdesde = CTOD('01/10/2007')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 73
*!*	SET DEFAULT TO c:\pad\papel\071112\
*!*	mentidadagrupadora = 904
*!*	mfechaproceso = CTOD('12/11/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-11"
*!*	mfecdesde = CTOD('01/11/2007')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 74
*!*	SET DEFAULT TO c:\pad\papel\071214\
*!*	mentidadagrupadora = 904
*!*	mfechaproceso = CTOD('14/12/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-12"
*!*	mfecdesde = CTOD('01/12/2007')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 75
*!*	SET DEFAULT TO c:\pad\papel\080109\
*!*	mentidadagrupadora = 904
*!*	mfechaproceso = CTOD('09/01/2008')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2008-01"
*!*	mfecdesde = CTOD('01/01/2008')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 76
*!*	SET DEFAULT TO c:\pad\papel\080206\
*!*	mentidadagrupadora = 904
*!*	mfechaproceso = CTOD('06/02/2008')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2008-02"
*!*	mfecdesde = CTOD('01/01/2008')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 77
*!*	SET DEFAULT TO c:\pad\papel\080310\
*!*	mentidadagrupadora = 904
*!*	mfechaproceso = CTOD('10/03/2008')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2008-03"
*!*	mfecdesde = CTOD('01/03/2008')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 78
*!*	SET DEFAULT TO c:\pad\papel\080415\
*!*	mentidadagrupadora = 904
*!*	mfechaproceso = CTOD('15/04/2008')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2008-04"
*!*	mfecdesde = CTOD('01/04/2008')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 79
*!*	SET DEFAULT TO c:\pad\papel\080514\
*!*	mentidadagrupadora = 904
*!*	mfechaproceso = CTOD('14/05/2008')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2008-05"
*!*	mfecdesde = CTOD('01/05/2008')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 80
*!*	SET DEFAULT TO c:\pad\papel\080609\
*!*	mentidadagrupadora = 904
*!*	mfechaproceso = CTOD('09/06/2008')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2008-06"
*!*	mfecdesde = CTOD('01/06/2008')
*!*	mfechasta = CTOD('01/01/2100')




*!*	CASE i = 964001
*!*	SET DEFAULT TO c:\pad\viajantes\060110\
*!*	mentidadagrupadora = 964
*!*	mfechaproceso = CTOD('10/01/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-01"
*!*	mfecdesde = CTOD('01/01/2006')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 964002
*!*	SET DEFAULT TO c:\pad\viajantes\060208\
*!*	mentidadagrupadora = 964
*!*	mfechaproceso = CTOD('08/02/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-02"
*!*	mfecdesde = CTOD('01/02/2006')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 964003
*!*	SET DEFAULT TO c:\pad\viajantes\060309\
*!*	mentidadagrupadora = 964
*!*	mfechaproceso = CTOD('09/03/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-03"
*!*	mfecdesde = CTOD('01/03/2006')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 964004
*!*	SET DEFAULT TO c:\pad\viajantes\060412\
*!*	mentidadagrupadora = 964
*!*	mfechaproceso = CTOD('12/04/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-04"
*!*	mfecdesde = CTOD('01/04/2006')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 964005
*!*	SET DEFAULT TO c:\pad\viajantes\060516\
*!*	mentidadagrupadora = 964
*!*	mfechaproceso = CTOD('16/05/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-05"
*!*	mfecdesde = CTOD('01/05/2006')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 964006
*!*	SET DEFAULT TO c:\pad\viajantes\060607\
*!*	mentidadagrupadora = 964
*!*	mfechaproceso = CTOD('07/06/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-06"
*!*	mfecdesde = CTOD('01/06/2006')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 964007
*!*	SET DEFAULT TO c:\pad\viajantes\060706\
*!*	mentidadagrupadora = 964
*!*	mfechaproceso = CTOD('06/07/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-07"
*!*	mfecdesde = CTOD('01/07/2006')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 964008
*!*	SET DEFAULT TO c:\pad\viajantes\060807\
*!*	mentidadagrupadora = 964
*!*	mfechaproceso = CTOD('07/08/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-08"
*!*	mfecdesde = CTOD('01/08/2006')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 964009
*!*	SET DEFAULT TO c:\pad\viajantes\060905\
*!*	mentidadagrupadora = 964
*!*	mfechaproceso = CTOD('05/09/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-09"
*!*	mfecdesde = CTOD('01/09/2006')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 964010
*!*	SET DEFAULT TO c:\pad\viajantes\061004\
*!*	mentidadagrupadora = 964
*!*	mfechaproceso = CTOD('04/10/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-10"
*!*	mfecdesde = CTOD('01/10/2006')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 964012
*!*	SET DEFAULT TO c:\pad\viajantes\061205\
*!*	mentidadagrupadora = 964
*!*	mfechaproceso = CTOD('05/12/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-12"
*!*	mfecdesde = CTOD('01/12/2006')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 964013
*!*	SET DEFAULT TO c:\pad\viajantes\070119\
*!*	mentidadagrupadora = 964
*!*	mfechaproceso = CTOD('19/01/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-01"
*!*	mfecdesde = CTOD('01/01/2007')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 964014
*!*	SET DEFAULT TO c:\pad\viajantes\070207\
*!*	mentidadagrupadora = 964
*!*	mfechaproceso = CTOD('07/02/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-02"
*!*	mfecdesde = CTOD('01/02/2007')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 964015
*!*	SET DEFAULT TO c:\pad\viajantes\070305\
*!*	mentidadagrupadora = 964
*!*	mfechaproceso = CTOD('05/03/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-03"
*!*	mfecdesde = CTOD('01/03/2007')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 964016
*!*	SET DEFAULT TO c:\pad\viajantes\070409\
*!*	mentidadagrupadora = 964
*!*	mfechaproceso = CTOD('09/04/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-04"
*!*	mfecdesde = CTOD('01/04/2007')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 964017
*!*	SET DEFAULT TO c:\pad\viajantes\070508\
*!*	mentidadagrupadora = 964
*!*	mfechaproceso = CTOD('08/05/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-05"
*!*	mfecdesde = CTOD('01/05/2007')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 964018
*!*	SET DEFAULT TO c:\pad\viajantes\070611\
*!*	mentidadagrupadora = 964
*!*	mfechaproceso = CTOD('11/06/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-06"
*!*	mfecdesde = CTOD('01/06/2007')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 964019
*!*	SET DEFAULT TO c:\pad\viajantes\070704\
*!*	mentidadagrupadora = 964
*!*	mfechaproceso = CTOD('04/07/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-07"
*!*	mfecdesde = CTOD('01/07/2007')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 964020
*!*	SET DEFAULT TO c:\pad\viajantes\070806\
*!*	mentidadagrupadora = 964
*!*	mfechaproceso = CTOD('06/08/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-08"
*!*	mfecdesde = CTOD('01/08/2007')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 964021
*!*	SET DEFAULT TO c:\pad\viajantes\070913\
*!*	mentidadagrupadora = 964
*!*	mfechaproceso = CTOD('13/09/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-09"
*!*	mfecdesde = CTOD('01/09/2007')
*!*	mfechasta = CTOD('01/01/2100')


*!*	CASE i = 964022
*!*	SET DEFAULT TO c:\pad\viajantes\071009\
*!*	mentidadagrupadora = 964
*!*	mfechaproceso = CTOD('09/10/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-10"
*!*	mfecdesde = CTOD('01/10/2007')
*!*	mfechasta = CTOD('01/01/2100')


*!*	CASE i = 964023
*!*	SET DEFAULT TO c:\pad\viajantes\071112\
*!*	mentidadagrupadora = 964
*!*	mfechaproceso = CTOD('12/11/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-11"
*!*	mfecdesde = CTOD('01/11/2007')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 964024
*!*	SET DEFAULT TO c:\pad\viajantes\071214\
*!*	mentidadagrupadora = 964
*!*	mfechaproceso = CTOD('14/12/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-12"
*!*	mfecdesde = CTOD('01/12/2007')
*!*	mfechasta = CTOD('01/01/2100')


*!*	CASE i = 964025
*!*	SET DEFAULT TO c:\pad\viajantes\080109\
*!*	mentidadagrupadora = 964
*!*	mfechaproceso = CTOD('09/01/2008')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2008-01"
*!*	mfecdesde = CTOD('01/01/2008')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 964026
*!*	SET DEFAULT TO c:\pad\viajan\080208\
*!*	mentidadagrupadora = 964
*!*	mfechaproceso = CTOD('08/02/2008')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2008-02"
*!*	mfecdesde = CTOD('01/02/2008')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 964027
*!*	SET DEFAULT TO c:\pad\viajan\080304\
*!*	mentidadagrupadora = 964
*!*	mfechaproceso = CTOD('04/03/2008')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2008-03"
*!*	mfecdesde = CTOD('01/03/2008')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 964028
*!*	SET DEFAULT TO c:\pad\viajan\080415\
*!*	mentidadagrupadora = 964
*!*	mfechaproceso = CTOD('15/04/2008')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2008-04"
*!*	mfecdesde = CTOD('01/04/2008')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 964029
*!*	SET DEFAULT TO c:\pad\viajan\080514\
*!*	mentidadagrupadora = 964
*!*	mfechaproceso = CTOD('14/05/2008')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2008-05"
*!*	mfecdesde = CTOD('01/05/2008')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 964030
*!*	SET DEFAULT TO c:\pad\viajan\080613\
*!*	mentidadagrupadora = 964
*!*	mfechaproceso = CTOD('13/06/2008')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2008-06"
*!*	mfecdesde = CTOD('01/06/2008')
*!*	mfechasta = CTOD('01/01/2100')



*!*	CASE i = 982001
*!*	SET DEFAULT TO c:\pad\ospcra\060113\
*!*	mentidadagrupadora = 982
*!*	mfechaproceso = CTOD('13/01/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-01"
*!*	mfecdesde = CTOD('01/01/2006')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 982002
*!*	SET DEFAULT TO c:\pad\ospcra\060214\
*!*	mentidadagrupadora = 982
*!*	mfechaproceso = CTOD('14/02/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-02"
*!*	mfecdesde = CTOD('01/02/2006')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 982003
*!*	SET DEFAULT TO c:\pad\ospcra\060315\
*!*	mentidadagrupadora = 982
*!*	mfechaproceso = CTOD('15/03/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-03"
*!*	mfecdesde = CTOD('01/03/2006')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 982004
*!*	SET DEFAULT TO c:\pad\ospcra\060417\
*!*	mentidadagrupadora = 982
*!*	mfechaproceso = CTOD('17/04/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-04"
*!*	mfecdesde = CTOD('01/04/2006')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 982005
*!*	SET DEFAULT TO c:\pad\ospcra\060516\
*!*	mentidadagrupadora = 982
*!*	mfechaproceso = CTOD('16/05/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-05"
*!*	mfecdesde = CTOD('01/05/2006')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 982006
*!*	SET DEFAULT TO c:\pad\ospcra\060622\
*!*	mentidadagrupadora = 982
*!*	mfechaproceso = CTOD('22/06/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-06"
*!*	mfecdesde = CTOD('01/06/2006')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 982007
*!*	SET DEFAULT TO c:\pad\ospcra\060719\
*!*	mentidadagrupadora = 982
*!*	mfechaproceso = CTOD('19/07/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-07"
*!*	mfecdesde = CTOD('01/07/2006')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 982008
*!*	SET DEFAULT TO c:\pad\ospcra\060825\
*!*	mentidadagrupadora = 982
*!*	mfechaproceso = CTOD('25/08/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-08"
*!*	mfecdesde = CTOD('01/08/2006')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 982009
*!*	SET DEFAULT TO c:\pad\ospcra\060905\
*!*	mentidadagrupadora = 982
*!*	mfechaproceso = CTOD('05/09/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-09"
*!*	mfecdesde = CTOD('01/09/2006')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 982010
*!*	SET DEFAULT TO c:\pad\ospcra\061004\
*!*	mentidadagrupadora = 982
*!*	mfechaproceso = CTOD('04/10/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-10"
*!*	mfecdesde = CTOD('01/10/2006')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 982012
*!*	SET DEFAULT TO c:\pad\ospcra\061205\
*!*	mentidadagrupadora = 982
*!*	mfechaproceso = CTOD('05/12/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-12"
*!*	mfecdesde = CTOD('01/12/2006')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 982013
*!*	SET DEFAULT TO c:\pad\ospcra\070119\
*!*	mentidadagrupadora = 982
*!*	mfechaproceso = CTOD('19/01/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-01"
*!*	mfecdesde = CTOD('01/01/2007')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 982014
*!*	SET DEFAULT TO c:\pad\ospcra\070221\
*!*	mentidadagrupadora = 982
*!*	mfechaproceso = CTOD('21/02/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-02"
*!*	mfecdesde = CTOD('01/02/2007')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 982015
*!*	SET DEFAULT TO c:\pad\ospcra\070305\
*!*	mentidadagrupadora = 982
*!*	mfechaproceso = CTOD('05/03/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-03"
*!*	mfecdesde = CTOD('01/03/2007')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 982016
*!*	SET DEFAULT TO c:\pad\ospcra\070409\
*!*	mentidadagrupadora = 982
*!*	mfechaproceso = CTOD('09/04/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-04"
*!*	mfecdesde = CTOD('01/04/2007')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 982017
*!*	SET DEFAULT TO c:\pad\ospcra\070515\
*!*	mentidadagrupadora = 982
*!*	mfechaproceso = CTOD('15/05/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-05"
*!*	mfecdesde = CTOD('01/05/2007')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 982018
*!*	SET DEFAULT TO c:\pad\ospcra\070611\
*!*	mentidadagrupadora = 982
*!*	mfechaproceso = CTOD('11/06/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-06"
*!*	mfecdesde = CTOD('01/06/2007')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 982019
*!*	SET DEFAULT TO c:\pad\ospcra\070704\
*!*	mentidadagrupadora = 982
*!*	mfechaproceso = CTOD('04/07/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-07"
*!*	mfecdesde = CTOD('01/07/2007')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 982020
*!*	SET DEFAULT TO c:\pad\ospcra\070822\
*!*	mentidadagrupadora = 982
*!*	mfechaproceso = CTOD('22/08/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-08"
*!*	mfecdesde = CTOD('01/08/2007')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 982021
*!*	SET DEFAULT TO c:\pad\ospcra\070913\
*!*	mentidadagrupadora = 982
*!*	mfechaproceso = CTOD('13/09/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-09"
*!*	mfecdesde = CTOD('01/09/2007')
*!*	mfechasta = CTOD('01/01/2100')


*!*	CASE i = 982022
*!*	SET DEFAULT TO c:\pad\ospcra\071023\
*!*	mentidadagrupadora = 982
*!*	mfechaproceso = CTOD('23/10/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-10"
*!*	mfecdesde = CTOD('01/10/2007')
*!*	mfechasta = CTOD('01/01/2100')


*!*	CASE i = 982023
*!*	SET DEFAULT TO c:\pad\ospcra\071112\
*!*	mentidadagrupadora = 982
*!*	mfechaproceso = CTOD('12/11/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-11"
*!*	mfecdesde = CTOD('01/11/2007')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 982024
*!*	SET DEFAULT TO c:\pad\ospcra\071214\
*!*	mentidadagrupadora = 982
*!*	mfechaproceso = CTOD('14/12/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-12"
*!*	mfecdesde = CTOD('01/12/2007')
*!*	mfechasta = CTOD('01/01/2100')


*!*	CASE i = 982025
*!*	SET DEFAULT TO c:\pad\ospcra\080118\
*!*	mentidadagrupadora = 982
*!*	mfechaproceso = CTOD('18/01/2008')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2008-01"
*!*	mfecdesde = CTOD('01/01/2008')
*!*	mfechasta = CTOD('01/01/2100')



		otherwise
			mentidadagrupadora = 0
	endcase

	if mentidadagrupadora > 0
		do case
			case i <39
				select 0
				use gastrono alias padron
				mbaseok = .t.
			case i >= 41 and i <71
				select 0
				use hielo alias padron
			case i >= 71 and i <81
				select 0
				use papel alias padron
				set filter to val(documento) > 0
				go top
			case i >=81 and i< 101
				select 0
				use pad alias padron
			case i >=964001 and i <=964999
				select 0
				use viajan alias padron
			case i >=982001 and i <=982999
				select 0
				use ospcra alias padron

		endcase


		mret = sqlexec(mcon1, "Update PadCabe set fecegreso =?mfechaproceso " + ;
			"where entidad=?mentidadagrupadora and fecegreso =?mfechatope")
		if mret < 0
			messagebox("ERROR de Escritura padcabe fechaegreso, Reintente", 48, "Validacion")
			susp
		endif
*mret = sqlexec(mcon1, "Update PadDomicilio set fechahasta =?mfechaproceso where fechahasta =?mfechatope")
*IF mret < 0
*	messagebox("ERROR de Escritura paddom fechahasta, Reintente", 48, "Validacion")
*	susp
*ENDIF

		mret = sqlexec(mcon1, "Update PadVigencia set fechahasta =?mfechaproceso " + ;
			"where IdPadCabe->entidad=?mentidadagrupadora and fechahasta =?mfechatope")
		if mret < 0
			messagebox("ERROR de Escritura padvigencia fechahasta, Reintente", 48, "Validacion")
			susp
		endif





		select padron

		do while !eof()
			do case
				case mentidadagrupadora = 948
					mnroaso=val(padron->cuil+padron->parentesco)
					mgrupofamiliar=val(padron->cuil)
				case mentidadagrupadora = 988
					mnroaso=val(alltrim(padron->nroafil)+padron->parentesco)
					mgrupofamiliar=val(alltrim(padron->nroafil))
				case mentidadagrupadora = 904
					mnroaso=val(padron->documento)
					mgrupofamiliar=val(alltrim(padron->nroafil))
				case mentidadagrupadora = 964
					mnroaso=val(padron->cuil)
					mgrupofamiliar=val(alltrim(padron->nroafil))
				otherwise
					mparentesco = padron->parentesco
					if mparentesco = '**'
						mparentesco = '99'
					endif
					mnroaso=val(alltrim(padron->nroafil)+mparentesco)
					mgrupofamiliar=val(alltrim(padron->nroafil))
			endcase
			mapellidosolo =""
			mnombresolo=""
			mapellido = upper(alltrim(chrtran(padron->apellido, "ÑðÐ^/\'$:ñ¥·ÿº?¿!¡%&()=¨;.ª|¬[]{}", "###  ")))
			mtipodocumento = val(padron->tipodoc)
*IF mentidadagrupadora = 948 OR mentidadagrupadora = 988
			if mentidadagrupadora <> 982
				if val(padron->tipodoc) = 3
					mtipodocumento = 4
				else
					if val(padron->tipodoc) = 4
						mtipodocumento = 3
					endif
				endif
			endif
			if val(padron->tipodoc) > 5
				mtipodocumento = 5
			endif



*ENDIF

			if val(padron->documento) = 0 and padron->parentesco = '00'
				mdocumento = val(alltrim(substr(padron->cuil,3,8)))
				mtipodocumento = 4
			else
				mdocumento = val(alltrim(padron->documento))
			endif

			mcuil = val(padron->cuil)
			mfecingreso = mfechaproceso
			mfecnac = iif(empty(padron->c_fecnac) or padron->c_fecnac < ctod('01/01/1900'),ctod('01/01/1900'),padron->c_fecnac)
			msexo = alltrim(iif(padron->sexo,'M','F'))
			mdomicilio = upper(padron->domicilio)
			mlocalidad = upper(padron->localidad)
			mcodigopostal = padron->cp
			mprovincia = upper(padron->provincia)
			mtelefono = padron->telefono

			mret = sqlexec(mcon1," select id,apeynom,cuil,documento,entidad, " + ;
				"fecegreso, fecingreso, fecnac, nroafiliado, sexo, tipodocumento,grupofamiliar " + ;
				"from PadCabe where entidad=?mentidadagrupadora and nroafiliado = ?mnroaso","mwkpadcabe")
			if mret < 0
				messagebox("ERROR de LECTURA , Reintente", 48, "Validacion")
				select padron
				? recno()
				susp
			endif
			select mwkpadcabe
			if eof()
				if insertarpadcabe()
					mret = sqlexec(mcon1," select id from PadCabe where entidad=?mentidadagrupadora and nroafiliado = ?mnroaso","mwkpadcabe")
					if mret < 0
						messagebox("ERROR de LECTURA LUEGO DE GRABAR , Reintente", 48, "Validacion")
						select padron
						? recno()
						susp
					endif
					select mwkpadcabe
					if !eof()
						midpadcabe = mwkpadcabe->id
						mret = sqlexec(mcon1," select id from PadDomicilio where  idpadcabe = ?midpadcabe","mwkpaddomicilio")
						if mret < 0
							messagebox("ERROR de LECTURA EN PADDOM , Reintente", 48, "Validacion")
							select padron
							? recno()
							susp
						endif
						select mwkpaddomicilio
						if eof()
							insertardomicilio()
							insertarvigencia()
							insertarpago()
							insertardocumento()
							insertarotrosdatos()
						else
							messagebox("ERROR de Domicilio existente EN Afiliado nuevo de PADcabe , Reintente", 48, "Validacion")
						endif
					else
						messagebox("ERROR de LECTURA EN cursor luego de insertar , Reintente", 48, "Validacion")
						select padron
						? recno()
						susp
					endif
				endif
			else
*messagebox("ERROR Afiliado duplicado", 48, "Validacion")
*? "Afilido duplicado",mnroaso,RECNO()
				select mwkpadcabe
				midpadcabe = mwkpadcabe->id
				versicambiodatos()
				actualizarvigencia()
				insertarpago()
			endif
			select padron
			skip
		enddo

		select padron
		use
		close tables
	endif
	i=i+1

enddo

SQLDISCONNECT(mcon1)


function versicambiodatos

	if mwkpadcabe->fecegreso = mfechaproceso
		mfecingreso = mwkpadcabe->fecingreso
	else
		mfecingreso = mfechaproceso
	endif
	mrealizocambios = .f.
	if mapellido# upper(alltrim(chrtran(mwkpadcabe->apeynom, "ÑðÐ^/\'$:ñ¥·ÿº?¿!¡%&()=¨;.ª|¬[]{}", "###  "))) ;
			or mdocumento#mwkpadcabe->documento ;
			or mtipodocumento#mwkpadcabe->tipodocumento ;
			or mfecnac#mwkpadcabe->fecnac ;
			or msexo#alltrim(mwkpadcabe->sexo) ;
			or mgrupofamiliar#mwkpadcabe->grupofamiliar
		mrealizocambios = .t.
	endif
	if mrealizocambios
** Actualizacion de cambios y manda log lo anterior
** Falta campos que no se usan
		xid 				= mwkpadcabe->id
		xapeynom			= mwkpadcabe->apeynom
		xcuil				= mwkpadcabe->cuil
		xdocumentoprincipal	= mwkpadcabe->documento
		xentidadagrupadora	= mwkpadcabe->entidad
		xfecegreso			= mwkpadcabe->fecegreso
		xfecingreso			= mwkpadcabe->fecingreso
		xfecnac				= mwkpadcabe->fecnac
		xnroafiliado		= mwkpadcabe->nroafiliado
		xsexo				= mwkpadcabe->sexo
		xtipodocumento		= mwkpadcabe->tipodocumento
		xgrupofamiliar		= mwkpadcabe->grupofamiliar

		mret = sqlexec(mcon1, "insert into PadCabelog set nroafiliado = ?xnroafiliado, " +;
			"apeynom =?xapeynom,  documento =?xdocumentoprincipal, " +;
			"tipodocumento =?xtipodocumento, cuil =?xcuil," +;
			"entidad = ?xentidadagrupadora, fecingreso = ?xfecingreso," +;
			"fecegreso=?xfecegreso, fecnac =?xfecnac, sexo=?xsexo, idpadcabe=?xid, grupofamiliar=?xgrupofamiliar " + ;
			"fechaproceso=?mfechaproceso ")
		if mret<1
			=aerr(eros)
			messagebox(eros(3))
			select padron
			? recno()
			susp
		endif
		mret = sqlexec(mcon1, "Update PadCabe set apeynom =?mapellido, " + ;
			"documento =?mdocumento, tipodocumento =?mtipodocumento, cuil =?mcuil," +;
			"entidad= ?mentidadagrupadora, fecnac =?mfecnac, sexo=?msexo, " + ;
			"fecingreso=?mfecingreso, fecegreso =?mfechatope, grupofamiliar=?mgrupofamiliar where id=?midpadcabe ")
		if mret<1
			=aerr(eros)
			messagebox(eros(3))
		endif


	else
		mret = sqlexec(mcon1, "Update PadCabe set fecegreso =?mfechatope, fecingreso=?mfecingreso where id=?midpadcabe ")
		if mret<1
			=aerr(eros)
			messagebox(eros(3))
			select padron

		endif

		if mret < 0
			select padron
			? recno()
			susp
		endif

		mret = sqlexec(mcon1," select * from PadDomicilio where idpadcabe = ?midpadcabe","mwkpaddom")
		if mret < 0
			messagebox("ERROR de LECTURA EN PADDOM , Reintente", 48, "Validacion")
			select padron
			? recno()
			susp
		endif
		select mwkpaddom
		do while !eof()
			if mwkpaddom->fechahasta = mfechatope
*OR mwkpaddom->fechahasta = mfechaproceso
				midpaddom = mwkpaddom->id
				xdomicilio = mwkpaddom->domicilio
				xlocalidad = mwkpaddom->localidad
				xcodigopostal = mwkpaddom->codigo
				xprovincia = mwkpaddom->provincia
				xtelefono = mwkpaddom->telefono

				if xdomicilio#mdomicilio or xlocalidad#mlocalidad or xcodigopostal#mcodigopostal ;
						or xprovincia#mprovincia or xtelefono#mtelefono

					mret = sqlexec(mcon1, "insert into PadDomicilio set idpadcabe = ?midpadcabe, " + ;
						"domicilio=?mdomicilio, localidad=?mlocalidad, provincia=?mprovincia, " + ;
						"telefono=?mtelefono, codigo=?mcodigopostal, fechadesde =?mfechaproceso, " + ;
						"fechahasta=?mfechatope " )
					if mret < 0
						messagebox("ERROR de ACTUALIZACION PADDOM, Reintente", 48, "Validacion")
						select padron
						? recno()
						susp
					endif
** Actualizar domicilio con fecha hasta
					mret = sqlexec(mcon1, "update PadDomicilio set fechahasta=?mfechaproceso where id =?midpaddom")
				endif
				if mret < 0
					messagebox("ERROR de ACTUALIZACION PADDOM, Reintente", 48, "Validacion")
					select padron
					? recno()
					susp
				endif
			endif
			select mwkpaddom
			skip
		enddo


***--> Documento

		mret = sqlexec(mcon1," select * from PadDocumentos where idpadcabe = ?midpadcabe","mwkpaddoc")
		if mret < 0
			messagebox("ERROR de LECTURA EN PADDOC , Reintente", 48, "Validacion")
			select padron
			? recno()
			susp
		endif
		select mwkpaddoc
		do while !eof()
			if mwkpaddoc->fechahasta = mfechatope
*OR mwkpaddom->fechahasta = mfechaproceso
				midpaddoc = mwkpaddoc->id
				xtipodocumento = mwkpaddoc->tipodocumento
				xdocumento = mwkpaddoc->documento
				if xdocumento#mdocumento or xtipodocumento#mtipodocumento
					insertardocumento()
** Actualizar domicilio con fecha hasta
					mret = sqlexec(mcon1, "update PadDocumentos set fechahasta=?mfechaproceso where id =?midpaddoc")
				endif
				if mret < 0
					messagebox("ERROR de ACTUALIZACION PADDOC, Reintente", 48, "Validacion")
					select padron
					? recno()
					susp
				endif
			endif
			select mwkpaddoc
			skip
		enddo






		return .t.

function actualizarvigencia

	mret = sqlexec(mcon1," select * from Padvigencia where idpadcabe = ?midpadcabe","mwkpadvigencia")

	if mret < 0
		messagebox("ERROR de LECTURA EN PADVigencia , Reintente", 48, "Validacion")
		select padron
		? recno()
		susp
	endif
	select mwkpadvigencia
	if !eof()
		maccionupdate = .f.
		do while !eof()
			if mwkpadvigencia->fechahasta = mfechatope or mwkpadvigencia->fechahasta = mfechaproceso
				midpadvigencia = mwkpadvigencia->id
				maccionupdate = .t.
				exit
			endif
			select mwkpadvigencia
			skip
		enddo
** Accion
		if maccionupdate
			mret = sqlexec(mcon1, "update Padvigencia set fechahasta=?mfechatope where id =?midpadvigencia")
			if mret < 0
				messagebox("ERROR de Actualizacion EN PADVigencia , Reintente", 48, "Validacion")
				select padron
				? recno()
				susp
			endif
		else
			insertarvigencia()
		endif
	else
** Vigencia nueva??
		suspend
		insertarvigencia()
	endif

	return .t.


function insertarpago
	private mret
	mret = sqlexec(mcon1, "insert into Padpagos set idpadcabe = ?midpadcabe, " + ;
		"concepto=?mconcepto, fechadesde=?mfecdesde, fechahasta=?mfechasta ")
	if mret < 0
		messagebox("ERROR de ESCRITURA PADPAGOS, Reintente", 48, "Validacion")
		select padron
		? recno()
		susp
	endif

	return iif(mret<0,.f.,.t.)

function insertardocumento
	private mret
	mret = sqlexec(mcon1, "insert into Paddocumentos set idpadcabe = ?midpadcabe, " + ;
		" tipodocumento=?mtipodocumento, documento=?mdocumento, fechadesde =?mfechaproceso, " + ;
		"fechahasta=?mfechasta " )
	if mret < 0
		messagebox("ERROR de ESCRITURA PADDOCUMENTOS, Reintente", 48, "Validacion")
		select padron
		? recno()
		susp
	endif

	return iif(mret<0,.f.,.t.)

function insertarotrosdatos
	private mret
** Ciclar por cada dato no ingresado
	if type('padron->obrasoc') <> 'U'
		mcampo = "OBRASOC"
		mcontenido = padron->obrasoc
		mret = sqlexec(mcon1, "insert into PadOtrosDatos set idpadcabe = ?midpadcabe, " + ;
			" campo=?mcampo, contenido=?mcontenido, fechadesde =?mfechaproceso, " + ;
			"fechahasta=?mfechasta " )

		if mret < 0
			messagebox("ERROR de ESCRITURA PADOtrosDatos, Reintente", 48, "Validacion")
			mresultado =.f.
			select padron
			? recno()
			susp
		endif
	else
		mret = 0
	endif
	return iif(mret<0,.f.,.t.)

function insertardomicilio
	private mret
	mret = sqlexec(mcon1, "insert into PadDomicilio set idpadcabe = ?midpadcabe, " + ;
		"domicilio=?mdomicilio, localidad=?mlocalidad, provincia=?mprovincia, " + ;
		"telefono=?mtelefono, codigo=?mcodigopostal, fechadesde =?mfechaproceso, " + ;
		"fechahasta=?mfechatope " )
	if mret < 0
		messagebox("ERROR de ESCRITURA PADDOM, Reintente", 48, "Validacion")
		select padron
		? recno()
		susp
	endif
	return iif(mret<0,.f.,.t.)

function insertarvigencia
	private mret
	mret = sqlexec(mcon1, "insert into Padvigencia set idpadcabe = ?midpadcabe, " + ;
		"fechadesde=?mfechaproceso, fechahasta=?mfechatope ")
	if mret < 0
		messagebox("ERROR de ESCRITURA PADVIGENCIAS, Reintente", 48, "Validacion")
		select padron
		? recno()
		susp
	endif
	return iif(mret<0,.f.,.t.)

function insertarpadcabe
	private mret
	mret = sqlexec(mcon1, "insert into PadCabe set nroafiliado = ?mnroaso, " + ;
		"apeynom =?mapellido, documento=?mdocumento, tipodocumento =?mtipodocumento, " + ;
		"cuil =?mcuil, entidad=?mentidadagrupadora, fecingreso = ?mfecingreso," + ;
		"fecegreso=?mfechatope, fecnac =?mfecnac, sexo=?msexo, apellido=?mapellidosolo," + ;
		"nombre=?mnombresolo, grupofamiliar=?mgrupofamiliar ")
	if mret < 0
		messagebox("ERROR de ESCRITURA PADCABE, Reintente", 48, "Validacion")
		select padron
		? recno()
		susp
	endif
	return iif(mret<0,.f.,.t.)




*!*		IF VAL(padron->documento) = 0 AND padron->parentesco = '00'
*!*		mdocumento = ALLTRIM(SUBSTR(padron->cuil,3,8))
*!*		ELSE
*!*		mdocumento = ALLTRIM(padron->documento)
*!*		ENDIF
*!*
*!*		mtipodocumento = VAL(padron->tipodoc)
*!*		mcuil = VAL(padron->cuil)
*!*		*mentidadagrupadora = 948
*!*		mfecingreso = mfechaproceso
*!*		mfecnac = IIF(EMPTY(padron->c_fecnac) or padron->c_fecnac < ctod('01/01/1900'),CTOD('01/01/1900'),padron->c_fecnac)
*!*		msexo = IIF(padron->sexo,'M','F')
*!*		mdomicilio = padron->domicilio
*!*		mlocalidad = padron->localidad
*!*		mcodigopostal = padron->cp
*!*		mprovincia = padron->provincia
*!*		mtelefono = padron->telefono

***** Padrones procesados
*!*	CASE i = 1
*!*	SET DEFAULT TO c:\pad\gastro\060113\
*!*	mentidadagrupadora = 948
*!*	mfechaproceso = CTOD('13/01/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-01"
*!*	mfecdesde = CTOD('01/01/2006')
*!*	mfechasta = CTOD('01/01/2100')
*!*	CASE i = 2
*!*	SET DEFAULT TO c:\pad\gastro\060214\
*!*	mentidadagrupadora = 948
*!*	mfechaproceso = CTOD('14/02/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-02"
*!*	mfecdesde = CTOD('01/02/2006')
*!*	mfechasta = CTOD('01/01/2100')
*!*	CASE i = 3
*!*	SET DEFAULT TO c:\pad\gastro\060317\
*!*	mentidadagrupadora = 948
*!*	mfechaproceso = CTOD('17/03/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-03"
*!*	mfecdesde = CTOD('01/03/2006')
*!*	mfechasta = CTOD('01/01/2100')
*!*	CASE i = 4
*!*	SET DEFAULT TO c:\pad\gastro\060420\
*!*	mentidadagrupadora = 948
*!*	mfechaproceso = CTOD('20/04/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-04"
*!*	mfecdesde = CTOD('01/04/2006')
*!*	mfechasta = CTOD('01/01/2100')
*!*	CASE i = 5
*!*	SET DEFAULT TO c:\pad\gastro\060523\
*!*	mentidadagrupadora = 948
*!*	mfechaproceso = CTOD('23/05/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-05"
*!*	mfecdesde = CTOD('01/05/2006')
*!*	mfechasta = CTOD('01/01/2100')
*!*	CASE i = 6
*!*	SET DEFAULT TO c:\pad\gastro\060615\
*!*	mentidadagrupadora = 948
*!*	mfechaproceso = CTOD('15/06/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-06"
*!*	mfecdesde = CTOD('01/06/2006')
*!*	mfechasta = CTOD('01/01/2100')


*!*	CASE i = 7
*!*	SET DEFAULT TO c:\pad\gastro\060717\
*!*	mentidadagrupadora = 948
*!*	mfechaproceso = CTOD('17/07/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-07"
*!*	mfecdesde = CTOD('01/07/2006')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 8
*!*	SET DEFAULT TO c:\pad\gastro\060815\
*!*	mentidadagrupadora = 948
*!*	mfechaproceso = CTOD('15/08/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-08"
*!*	mfecdesde = CTOD('01/08/2006')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 9
*!*	SET DEFAULT TO c:\pad\gastro\060925\
*!*	mentidadagrupadora = 948
*!*	mfechaproceso = CTOD('25/09/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-09"
*!*	mfecdesde = CTOD('01/09/2006')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 10
*!*	SET DEFAULT TO c:\pad\gastro\061018\
*!*	mentidadagrupadora = 948
*!*	mfechaproceso = CTOD('18/10/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-10"
*!*	mfecdesde = CTOD('01/10/2006')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 11
*!*	SET DEFAULT TO c:\pad\gastro\061116\
*!*	mentidadagrupadora = 948
*!*	mfechaproceso = CTOD('16/11/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-11"
*!*	mfecdesde = CTOD('01/11/2006')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 12
*!*	SET DEFAULT TO c:\pad\gastro\061219\
*!*	mentidadagrupadora = 948
*!*	mfechaproceso = CTOD('19/12/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-12"
*!*	mfecdesde = CTOD('01/12/2006')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 13
*!*	SET DEFAULT TO c:\pad\gastro\070117\
*!*	mentidadagrupadora = 948
*!*	mfechaproceso = CTOD('17/01/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-01"
*!*	mfecdesde = CTOD('01/01/2007')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 14
*!*	SET DEFAULT TO c:\pad\gastro\070213\
*!*	mentidadagrupadora = 948
*!*	mfechaproceso = CTOD('13/02/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-02"
*!*	mfecdesde = CTOD('01/02/2007')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 15
*!*	SET DEFAULT TO c:\pad\gastro\070314\
*!*	mentidadagrupadora = 948
*!*	mfechaproceso = CTOD('14/03/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-03"
*!*	mfecdesde = CTOD('01/03/2007')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 16
*!*	SET DEFAULT TO c:\pad\gastro\070416\
*!*	mentidadagrupadora = 948
*!*	mfechaproceso = CTOD('16/04/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-04"
*!*	mfecdesde = CTOD('01/04/2007')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 17
*!*	SET DEFAULT TO c:\pad\gastro\070515\
*!*	mentidadagrupadora = 948
*!*	mfechaproceso = CTOD('15/05/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-05"
*!*	mfecdesde = CTOD('01/05/2007')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 18
*!*	SET DEFAULT TO c:\pad\gastro\070614\
*!*	mentidadagrupadora = 948
*!*	mfechaproceso = CTOD('14/06/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-06"
*!*	mfecdesde = CTOD('01/06/2007')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 19
*!*	SET DEFAULT TO c:\pad\gastro\070713\
*!*	mentidadagrupadora = 948
*!*	mfechaproceso = CTOD('13/07/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-07"
*!*	mfecdesde = CTOD('01/07/2007')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 20
*!*	SET DEFAULT TO c:\pad\gastro\070813\
*!*	mentidadagrupadora = 948
*!*	mfechaproceso = CTOD('13/08/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-08"
*!*	mfecdesde = CTOD('01/08/2007')
*!*	mfechasta = CTOD('01/01/2100')


*!*	CASE i = 21
*!*	SET DEFAULT TO c:\pad\ospihym\060113\
*!*	mentidadagrupadora = 988
*!*	mfechaproceso = CTOD('13/01/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-01"
*!*	mfecdesde = CTOD('01/01/2006')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 22
*!*	SET DEFAULT TO c:\pad\ospihym\060216\
*!*	mentidadagrupadora = 988
*!*	mfechaproceso = CTOD('16/02/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-02"
*!*	mfecdesde = CTOD('01/02/2006')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 23
*!*	SET DEFAULT TO c:\pad\ospihym\060309\
*!*	mentidadagrupadora = 988
*!*	mfechaproceso = CTOD('09/03/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-03"
*!*	mfecdesde = CTOD('01/03/2006')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 24
*!*	SET DEFAULT TO c:\pad\ospihym\060407\
*!*	mentidadagrupadora = 988
*!*	mfechaproceso = CTOD('07/04/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-04"
*!*	mfecdesde = CTOD('01/04/2006')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 25
*!*	SET DEFAULT TO c:\pad\ospihym\060523\
*!*	mentidadagrupadora = 988
*!*	mfechaproceso = CTOD('23/05/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-05"
*!*	mfecdesde = CTOD('01/05/2006')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 26
*!*	SET DEFAULT TO c:\pad\ospihym\060608\
*!*	mentidadagrupadora = 988
*!*	mfechaproceso = CTOD('08/06/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-06"
*!*	mfecdesde = CTOD('01/06/2006')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 27
*!*	SET DEFAULT TO c:\pad\ospihym\060706\
*!*	mentidadagrupadora = 988
*!*	mfechaproceso = CTOD('06/07/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-07"
*!*	mfecdesde = CTOD('01/07/2006')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 28
*!*	SET DEFAULT TO c:\pad\ospihym\060808\
*!*	mentidadagrupadora = 988
*!*	mfechaproceso = CTOD('08/08/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-08"
*!*	mfecdesde = CTOD('01/08/2006')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 29
*!*	SET DEFAULT TO c:\pad\ospihym\060908\
*!*	mentidadagrupadora = 988
*!*	mfechaproceso = CTOD('08/09/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-09"
*!*	mfecdesde = CTOD('01/09/2006')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 30
*!*	SET DEFAULT TO c:\pad\ospihym\061010\
*!*	mentidadagrupadora = 988
*!*	mfechaproceso = CTOD('10/10/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-10"
*!*	mfecdesde = CTOD('01/10/2006')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 31
*!*	SET DEFAULT TO c:\pad\ospihym\061109\
*!*	mentidadagrupadora = 988
*!*	mfechaproceso = CTOD('09/11/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-11"
*!*	mfecdesde = CTOD('01/11/2006')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 32
*!*	SET DEFAULT TO c:\pad\ospihym\061211\
*!*	mentidadagrupadora = 988
*!*	mfechaproceso = CTOD('11/12/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-12"
*!*	mfecdesde = CTOD('01/12/2006')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 33
*!*	SET DEFAULT TO c:\pad\ospihym\070119\
*!*	mentidadagrupadora = 988
*!*	mfechaproceso = CTOD('19/01/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-01"
*!*	mfecdesde = CTOD('01/01/2007')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 34
*!*	SET DEFAULT TO c:\pad\ospihym\070206\
*!*	mentidadagrupadora = 988
*!*	mfechaproceso = CTOD('06/02/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-02"
*!*	mfecdesde = CTOD('01/02/2007')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 35
*!*	SET DEFAULT TO c:\pad\ospihym\070309\
*!*	mentidadagrupadora = 988
*!*	mfechaproceso = CTOD('09/03/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-03"
*!*	mfecdesde = CTOD('01/02/2007')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 36
*!*	SET DEFAULT TO c:\pad\ospihym\070409\
*!*	mentidadagrupadora = 988
*!*	mfechaproceso = CTOD('09/04/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-04"
*!*	mfecdesde = CTOD('01/02/2007')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 37
*!*	SET DEFAULT TO c:\pad\ospihym\070508\
*!*	mentidadagrupadora = 988
*!*	mfechaproceso = CTOD('08/05/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-05"
*!*	mfecdesde = CTOD('01/02/2007')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 38
*!*	SET DEFAULT TO c:\pad\ospihym\070611\
*!*	mentidadagrupadora = 988
*!*	mfechaproceso = CTOD('11/06/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-06"
*!*	mfecdesde = CTOD('01/02/2007')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 39
*!*	SET DEFAULT TO c:\pad\ospihym\070710\
*!*	mentidadagrupadora = 988
*!*	mfechaproceso = CTOD('10/07/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-07"
*!*	mfecdesde = CTOD('01/07/2007')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 40
*!*	SET DEFAULT TO c:\pad\ospihym\070810\
*!*	mentidadagrupadora = 988
*!*	mfechaproceso = CTOD('10/08/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-08"
*!*	mfecdesde = CTOD('01/08/2007')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 51
*!*	SET DEFAULT TO c:\pad\papel\060113\
*!*	mentidadagrupadora = 904
*!*	mfechaproceso = CTOD('13/01/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-01"
*!*	mfecdesde = CTOD('01/01/2006')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 52
*!*	SET DEFAULT TO c:\pad\papel\060208\
*!*	mentidadagrupadora = 904
*!*	mfechaproceso = CTOD('08/02/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-02"
*!*	mfecdesde = CTOD('01/02/2006')
*!*	mfechasta = CTOD('01/01/2100')
*!*	CASE i = 53
*!*	SET DEFAULT TO c:\pad\papel\060309\
*!*	mentidadagrupadora = 904
*!*	mfechaproceso = CTOD('09/03/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-03"
*!*	mfecdesde = CTOD('01/03/2006')
*!*	mfechasta = CTOD('01/01/2100')
*!*	CASE i = 54
*!*	SET DEFAULT TO c:\pad\papel\060407\
*!*	mentidadagrupadora = 904
*!*	mfechaproceso = CTOD('07/04/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-04"
*!*	mfecdesde = CTOD('01/04/2006')
*!*	mfechasta = CTOD('01/01/2100')
*!*	CASE i = 55
*!*	SET DEFAULT TO c:\pad\papel\060516\
*!*	mentidadagrupadora = 904
*!*	mfechaproceso = CTOD('16/05/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-05"
*!*	mfecdesde = CTOD('01/05/2006')
*!*	mfechasta = CTOD('01/01/2100')
*!*	CASE i = 56
*!*	SET DEFAULT TO c:\pad\papel\060607\
*!*	mentidadagrupadora = 904
*!*	mfechaproceso = CTOD('07/06/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-06"
*!*	mfecdesde = CTOD('01/06/2006')
*!*	mfechasta = CTOD('01/01/2100')


*!*	CASE i = 57
*!*	SET DEFAULT TO c:\pad\papel\060717\
*!*	mentidadagrupadora = 904
*!*	mfechaproceso = CTOD('17/07/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-07"
*!*	mfecdesde = CTOD('01/07/2006')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 58
*!*	SET DEFAULT TO c:\pad\papel\060815\
*!*	mentidadagrupadora = 904
*!*	mfechaproceso = CTOD('15/08/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-08"
*!*	mfecdesde = CTOD('01/08/2006')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 59
*!*	SET DEFAULT TO c:\pad\papel\060905\
*!*	mentidadagrupadora = 904
*!*	mfechaproceso = CTOD('05/09/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-09"
*!*	mfecdesde = CTOD('01/09/2006')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 60
*!*	SET DEFAULT TO c:\pad\papel\061004\
*!*	mentidadagrupadora = 904
*!*	mfechaproceso = CTOD('04/10/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-10"
*!*	mfecdesde = CTOD('01/10/2006')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 61
*!*	SET DEFAULT TO c:\pad\papel\061116\
*!*	mentidadagrupadora = 904
*!*	mfechaproceso = CTOD('16/11/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-11"
*!*	mfecdesde = CTOD('01/11/2006')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 62
*!*	SET DEFAULT TO c:\pad\papel\061219\
*!*	mentidadagrupadora = 904
*!*	mfechaproceso = CTOD('19/12/2006')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2006-12"
*!*	mfecdesde = CTOD('01/12/2006')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 63
*!*	SET DEFAULT TO c:\pad\papel\070119\
*!*	mentidadagrupadora = 904
*!*	mfechaproceso = CTOD('19/01/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-01"
*!*	mfecdesde = CTOD('01/01/2007')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 64
*!*	SET DEFAULT TO c:\pad\papel\070206\
*!*	mentidadagrupadora = 904
*!*	mfechaproceso = CTOD('06/02/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-02"
*!*	mfecdesde = CTOD('01/02/2007')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 65
*!*	SET DEFAULT TO c:\pad\papel\070312\
*!*	mentidadagrupadora = 904
*!*	mfechaproceso = CTOD('12/03/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-03"
*!*	mfecdesde = CTOD('01/03/2007')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 66
*!*	SET DEFAULT TO c:\pad\papel\070413\
*!*	mentidadagrupadora = 904
*!*	mfechaproceso = CTOD('13/04/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-04"
*!*	mfecdesde = CTOD('01/04/2007')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 67
*!*	SET DEFAULT TO c:\pad\papel\070510\
*!*	mentidadagrupadora = 904
*!*	mfechaproceso = CTOD('10/05/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-05"
*!*	mfecdesde = CTOD('01/05/2007')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 68
*!*	SET DEFAULT TO c:\pad\papel\070611\
*!*	mentidadagrupadora = 904
*!*	mfechaproceso = CTOD('11/06/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-06"
*!*	mfecdesde = CTOD('01/06/2007')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 69
*!*	SET DEFAULT TO c:\pad\papel\070714\
*!*	mentidadagrupadora = 904
*!*	mfechaproceso = CTOD('14/07/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-07"
*!*	mfecdesde = CTOD('01/07/2007')
*!*	mfechasta = CTOD('01/01/2100')

*!*	CASE i = 70
*!*	SET DEFAULT TO c:\pad\papel\070806\
*!*	mentidadagrupadora = 904
*!*	mfechaproceso = CTOD('06/08/2007')
*!*	mfechatope = CTOD('01/01/2100')
*!*	mconcepto = "Pago 2007-08"
*!*	mfecdesde = CTOD('01/08/2007')
*!*	mfechasta = CTOD('01/01/2100')


