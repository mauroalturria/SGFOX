lParameters lnMemoryType 

Local lcResu
Store "" To lcResu

Do Case && lnMemoryType
	Case lnMemoryType = 0 
		lcResu = "Unknown"
	Case lnMemoryType = 1
		lcResu = "Other"
 	Case lnMemoryType = 2
 		lcResu = "DRAM"
 	Case lnMemoryType = 3
 		lcResu = "Synchronous DRAM"
 	Case lnMemoryType = 4
 		lcResu = "Cache DRAM"
 	Case lnMemoryType = 5
 		lcResu = "EDO"
 	Case lnMemoryType = 6
 		lcResu = "EDRAM"
 	Case lnMemoryType = 7
 		lcResu = "VRAM"
 	Case lnMemoryType = 8
 		lcResu = "SRAM"
 	Case lnMemoryType = 9
 		lcResu = "RAM"
 	Case lnMemoryType = 10
 		lcResu = "ROM"
 	Case lnMemoryType = 11
 		lcResu = "Flash"
 	Case lnMemoryType = 12
 		lcResu = "EEPROM"
 	Case lnMemoryType = 13
 		lcResu = "FEPROM"
 	Case lnMemoryType = 14
 		lcResu = "EPROM"
 	Case lnMemoryType = 15
 		lcResu = "CDRAM"
 	Case lnMemoryType = 16
 		lcResu = "3DRAM"
 	Case lnMemoryType = 17
 		lcResu = "SDRAM"
 	Case lnMemoryType = 18
 		lcResu = "SGRAM"
 	Case lnMemoryType = 19
 		lcResu = "RDRAM"
 	Case lnMemoryType = 20
 		lcResu = "DDR"
 	Case lnMemoryType = 21
 		lcResu = "DDR-2"
 	Otherwise 
 		lcResu = "NUEVO"
Endcase 		

Return lcResu
