Iif(mwkcama.rc_estado_1= 1,RGB(202,243,255),Iif(mwkcama.rc_estado_1= 3, RGB(215,215,255)))
Iif(mwkcama.rc_estado_1= 1,IIF(nvl(COV_HisopaVigilan,0)=1,RGB(253,219,115),RGB(202,243,255)),"+;
	"Iif(mwkcama.rc_estado_1= 3, RGB(215,215,255), Iif(mwkcama.rc_estado_1= 5, RGB(213,253,157), "+;
	"Iif(mwkcama.rc_estado_1= 6, RGB(255,166,255), Iif(mwkcama.rc_estado_1= 7, RGB(240,255,240), RGB(255,255,236)))))))"
This.SetAll("dynamicbackcolor",valor, "Column")
 Iif(mwkcama.rc_estado_1= 1,IIF(COV_hv_1=1,RGB(253,219,115),RGB(202,243,255)),Iif(mwkcama.rc_estado_1= 3, RGB(215,215,255), Iif(mwkcama.rc_estado_1= 5, RGB(213,253,157),Iif(mwkcama.rc_estado_1= 6, RGB(255,166,255), Iif(mwkcama.rc_estado_1= 7, RGB(240,255,240), RGB(255,255,236))))))