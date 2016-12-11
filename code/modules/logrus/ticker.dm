/datum/logrus/ticker
	var
		ticking = 1
		ticks = 1
		tick_delay = 3
		last_tick_time
		list/spell_list = list()
		list/logrus_list = list()


//So ticker should have 1 tick delays in itself betwen triggers processing
//signallers processing and effects processing. Should be thinked about.
/datum/logrus/ticker/proc/TICK()
	for()
		sleep(tick_delay)
		if(!ticking) continue

		for(var/obj/logrus/effect/S in spell_list)//triggers processing
			S.auxilary.perform(ticks)

		sleep(1)

		for(var/obj/logrus/effect/S in spell_list)//effects processing
			S.perform(ticks)

		sleep(1)

		for(var/obj/logrus/spellcraft/S in logrus_list)
			S.Mana(ticks)
			for(var/obj/logrus/effect/targeted/ileus/I in S.ileus)
				I.perform(ticks)

		ticks += 1
		//last_tick_time = world.time