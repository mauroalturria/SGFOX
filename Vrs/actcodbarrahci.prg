select * from ctrlhciarch where val(expression_5)# val(alltrim(strtran(hci_nroadm,"-","")))
copy to vererror type xls
update ctrlhciarch set '*' + alltrim( strtran( hci_nroadm , '-', '' )) + '*' where val(expression_5)# val(alltrim(strtran(hci_nroadm,"-","")))
update ctrlhciarch set hca_codbarra = '*' + alltrim( strtran( hci_nroadm , '-', '' )) + '*' where val(expression_5)# val(alltrim(strtran(hci_nroadm,"-","")))
select * from ctrlhciarch where val(expression_5)# val(alltrim(strtran(hci_nroadm,"-","")))
