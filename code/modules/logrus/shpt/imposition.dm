/obj/logrus/effect/targeted/shpt/imposition
	name = "Imposition"
	desc = "A spell effect, wich triggers other effects on any targets instantly."

	var/range = 1

/obj/logrus/effect/targeted/shpt/imposition/cast()
	var/cost = cost()
	if(cost)
		mana -= cost
		loc = target
		Destroy()

/obj/logrus/effect/targeted/shpt/imposition/cost()
	var/cost
	var/td = get_dist(src, target)
	switch(td)
		if(2 to 10)
			cost = 1.5*td
		if(11 to 30)
			cost = (1.3*(td+1))
		if(31 to 127)
			cost = (1.3*(td+25) - 1.03*td)
	if(mana < cost) return 0
	if(mana >= cost) return cost

/obj/logrus/effect/targeted/shpt/imposition/Destroy()
	auxilary.Destroy()
	IncreaseMana(constraint)
	var/portion = constraint/contents.len
	for(var/obj/logrus/effect/E in contents)
		if(istype(E, /obj/logrus/effect/auxilary))//not sure why it's auxilary here
			E.loc = loc
			Transfer(src, E, portion)
	del src


/obj/logrus/effect/targeted/shpt/imposition/setting(mob/M, n, option)
	if(text in main)
		switch(text)
			if("part")	return "part"
	if(modifiers.Find(text))
		switch(option)
			if("main") range = modifiers["text"]/5
			//if("part")




