/obj/logrus/effect/auxilary
	var/obj/logrus/effect/holder

	conversion()

	New()
		..()
		if(isspell(loc))
			holder = loc
			holder.auxilary = src
		else
			del src



/obj/logrus/effect/auxilary/drainer
	var/magnitude	//amount of mana will be drained
	var/extention = 1	//the number of steps
	var/step		//time between power drains
	var/mode

/obj/logrus/effect/auxilary/Destroy()
	holder.mana += constraint
	del src

/obj/logrus/effect/auxilary/drainer/cast()
	var/p = magnitude/extention
	for(extention)
		extention -= 1
		sleep(step)
		source.transfer(src, p)
		holder.mana += mana
		mana = 0
	if(mode)
		Destroy()

/obj/logrus/effect/auxilary/drainer/setting(mob/caster, text, option)
	if(magnitude_mod.Find(text))
		switch("option")
			if("main") 		magnitude = magnitude_mod["text"]
			if("extension")	extention = magnitude_mod["text"]/5
			if("step")		step = magnitude_mod["text"]/5
			else return 0
	else if(subeffects_words.Find(text))
		switch(text)
			if("mode")
				mode = 1
				return 1
			if("extension")	return text
			if("step")		return text
			else return 0
	return 1


