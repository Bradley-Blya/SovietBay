/obj/logrus/effect/infliction
	name = "Infliction"
	desc = "This spell blinds and/or destroys/damages/heals and/or weakens/stuns the target."

	var/dmgtype

/obj/logrus/effect/infliction/cast()
	if(!(ismob(loc) || isobj(loc) || isturf(loc)))
		return

	var/atom/holder = loc
	waste += holder.infliction(src, mana)

/atom/proc/infliction()
	return 0

/mob/living/infliction(spell, mana, dmgtype)
	switch(dmgtype)
		if("brute")
			adjustBruteLoss(mana)
		if("burn")
			adjustFireLoss(mana)

/obj/logrus/effect/infliction/setting(mob/caster, text, option)
	if(subeffects_words.Find(text))
		switch(dmgtype)
			if("brute")	dmgtype = text
			if("burn")	dmgtype = text
		return 1
