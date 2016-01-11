/obj/effect/proc_holder/logrus/shpt/imposition
	name = "Imposition"
	desc = "A spell effect, wich triggers other effects on any targets instantly."

	range = 7

/obj/effect/proc_holder/logrus/shpt/imposition/cast(list/targets)
	for(var/target in targets)
		if(target in range(range))
			var/amt = get_dist(src, target)*4
			var/a = consume(amt)
			if(a != amt)
				return
			for(var/obj/effect/proc_holder/logrus/effect in effects)
				effect.loc = target
				effect.trigger(target)
				transfer(effect, effect.magnitude)

/obj/effect/proc_holder/logrus/shpt/imposition/setting(mob/M, text)
	if(magnitude_mod.Find(text,1,0))
		switch(text)
			if("halveten")		magnitude += 5
			if("singleten")		magnitude += 10
			if("doubleten")		magnitude += 20
			if("fivehalveten")	magnitude += 25
			else return 0
	if(subeffects_words.Find(text,1,0) && selection_type)
		return 0
	else if(subeffects_words.Find(text,1,0))
		selection_type = text
	else return 0
	return 1

