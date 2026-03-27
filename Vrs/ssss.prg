select pacientesg
set step on
scan
	proto = nvl(pacientesg.pac_protocorigen,'')
	if val(proto)>0
		requery('guardia')
		if reccount('guardia')>0
			update guardia set diagnostico= pacientesg.pac_codadmision
		endif
	endif
endscan


select pacientesg
set step on
scan
	proto = nvl(pacientesg.pac_protocorigen,'')
	if val(proto)>0
		select guardiaint
		locate for protocolo = proto
		if !eof()
			replace diagnostico with pacientesg.pac_codadmision
		endif
	endif
endscan
