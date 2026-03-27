select * from packine where at("AKR",val_observaciones)>0 or at("RESP",pre_descriprest)>0 group by pac_codadmision into cursor AKR
select * from packine where !at("RESP",pre_descriprest)>0 group by pac_codadmision into cursor AKM
