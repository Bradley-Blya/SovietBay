/datum/logrus
	var
		ticks
		ticking = 1
		list/spell_list = list()
		list/logrus_list = list()
		list/mana_list = list()

/datum/logrus/proc/TICK()
	for()
		sleep(1)
		if(!ticking) continue

		for(var/obj/logrus/effect/auxilary/S in spell_list)
			S.perform()

		for(var/obj/logrus/effect/S in spell_list)
			if(!istype(S, /obj/logrus/effect/auxilary))
				S.perform(ticks)

		for(var/obj/logrus/spellcraft/S in logrus_list)
			S.Mana(ticks)