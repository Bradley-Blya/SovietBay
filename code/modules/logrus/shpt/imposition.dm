/obj/logrus/effect/targeted/shpt/imposition
	name = "Imposition"
	desc = "A spell effect, wich triggers other effects on any targets instantly."

	var/range = 7

/obj/logrus/effect/targeted/shpt/imposition/perform(list/targets)
	for(var/target in targets)
		if(target in range(range))
			var/amt = get_dist(src, target)*4
			var/a = consume(amt)
			if(a != amt)
				return
			for(var/obj/logrus/effect/effect in contents)
				effect.loc = loc
				//effect.trigger()

/obj/logrus/effect/targeted/shpt/imposition/setting(mob/M, text)
	return

