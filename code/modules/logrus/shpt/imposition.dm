/obj/logrus/effect/targeted/shpt/imposition
	name = "Imposition"
	desc = "A spell effect, wich triggers other effects on any targets instantly."

	var/range = 1

/obj/logrus/effect/targeted/shpt/imposition/cast()
	var/cost = cost()
	if(cost)
		mana -= cost
		loc = target

/obj/logrus/effect/targeted/shpt/imposition/cost()
	var/td = get_dist(src, target)
	switch(td)
		if(2 to 10)
			return 1.5*td
		if(11 to 30)
			return (1.3*(td+1))
		if(31 to 127)
			return (1.3*(td+25) - 1.03*td)

/obj/logrus/effect/targeted/shpt/imposition/Destroy()
	auxilary.Destroy()
	var/portion = constraint/contents.len
	for(var/obj/logrus/effect/E in contents)
		if(istype(E, /obj/logrus/effect/auxilary))
			E.loc = loc
			E.trigger(portion)
	del src


/obj/logrus/effect/targeted/shpt/imposition/setting(mob/M, text, option)
	if(subeffects_words.Find(text))
		switch(text)
			if("part")	return "part"
	if(magnitude_mod.Find(text))
		switch(option)
			if("main") range = magnitude_mod["text"]/5
			//if("part")




