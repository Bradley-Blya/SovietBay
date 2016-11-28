/obj/item/logrus/spell
	var/list
		deflectors = list()
		effects = list()
		auxilary = list()
		allocation = list()
		spectrum = list()
		
	
/obj/item/logrus/spell/proc/refresh_deflectors()
	for(var/datum/logrus/effect/E in effects)
		for(var/datum/deflector/D in E.deflectors)
			deflectors.Add(D)
			
/obj/item/logrus/spell/proc/refresh_spectrum()
	var/R = 12/deflectors.len
	var/j = 1
	for(var/datum/deflector/D in deflectors)
		for(var/i = 1, i <= R, i++)
			
			
			
		