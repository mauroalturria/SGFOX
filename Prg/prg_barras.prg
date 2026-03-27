*** graficos en barras ***

Lparameters nBarra

Local nTotal1, nTotal2, nTotal3, nTotal4, nVmin, nVmax, nVmulti

nTotal1=0
nTotal2=0
nTotal3=0
nTotal4=0
nTotal5=0

Select mwkTablero
Go Top

	Sum Iif(Empty(mwkTablero.admision),0,mwkTablero.admision) To nTotal1
	Sum Iif(Empty(mwkTablero.altas),0,mwkTablero.altas) To nTotal2
	Sum Iif(Empty(mwkTablero.derivarech),0,mwkTablero.derivarech) To nTotal3
	Sum Iif(Empty(mwkTablero.derivtotal),0,mwkTablero.derivtotal) To nTotal4
	Sum Iif(Empty(mwkTablero.guardiatotal),0,mwkTablero.guardiatotal) To nTotal5
	Sum Iif(Empty(mwkTablero.derivaing),0,mwkTablero.derivaing) To nTotal6
	

	*Select Sum(mwkTablero.admision) As nTotal1,;
		Sum(mwkTablero.altas) As nTotal2, ;
		Sum(mwkTablero.deriva) As nTotal3, ;
		Sum(mwkTablero.derivtotal) As nTotal4, ;
		Sum(mwkTablero.guardiatotal) As nTotal5 ;
		From mwkTablero Into Cursor mwkBarras


* Top = 145 (Defecto)
* Height = 300 (Defecto)
* Min y Max

nVmin = Min(100000,nTotal1,nTotal2,nTotal3,nTotal4,nTotal5,nTotal6)
nVmax = Max(1,nTotal1,nTotal2,nTotal3,nTotal4,nTotal5,nTotal6)

Do Case
Case nVmax>0 And nVmax<1001
	nVmulti = 1000
Case nVmax>1000 And nVmax<10001
	nVmulti = 10000
Case nVmax>10000 And nVmax<100001
	nVmulti = 100000
Case nVmax>100000 And nVmax<1000001
	nVmulti = 1000000
Endcase

Do Case
Case nBarra=1
	nValor = nTotal1*100
	nValor = nValor/nVmulti
	nValor = nValor*300
	nValor = nValor/100
Case nBarra=2
	nValor = nTotal2*100
	nValor = nValor/nVmulti
	nValor = nValor*300
	nValor = nValor/100
Case nBarra=3
	nValor = nTotal3*100
	nValor = nValor/nVmulti
	nValor = nValor*300
	nValor = nValor/100
Case nBarra=4
	nValor = nTotal4*100
	nValor = nValor/nVmulti
	nValor = nValor*300
	nValor = nValor/100
Case nBarra=5
	nValor = nTotal5*100
	nValor = nValor/nVmulti
	nValor = nValor*300
	nValor = nValor/100
Case nBarra=6
	nValor = nTotal6*100
	nValor = nValor/nVmulti
	nValor = nValor*300
	nValor = nValor/100
Endcase

Return nValor