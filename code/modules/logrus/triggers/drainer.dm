/obj/logrus/effect/targeted/ileus//Suspitios type of spell, wich is just a shourtct to mana expences
	var/magnitude		//amount of mana will be drained
	/*   no prolonged drains here.
	var/extention = 1	//the number of steps
	var/step = 5		//time between power drains (in ticks?)
	*/
/obj/logrus/effect/targeted/ileus/perform()
	if(active)
		cast()

/obj/logrus/effect/targeted/ileus/cast()
	source.SendMana()


//////#REDUNDANT
/*
/obj/logrus/effect/auxilary/drainer
	var/magnitude		//amount of mana will be drained
	var/extention = 1	//the number of steps
	var/step = 5		//time between power drains

/obj/logrus/effect/auxilary/Destroy()
	holder.mana += constraint
	del src

/obj/logrus/effect/auxilary/drainer/cast()
	var/p = magnitude/extention
	for(extention)
		extention -= 1
		sleep(step)
		Transfer(holder, src,  p)

/obj/logrus/effect/auxilary/drainer/setting(mob/caster, text, option)
	if(magnitude_mod.Find(text))
		switch("option")
			if("main") 		magnitude = magnitude_mod["text"]
			if("extension")	extention = magnitude_mod["text"]/5
			if("step")		step = magnitude_mod["text"]/5
			else return 0
	else if(subeffects_words.Find(text))
		switch(text)
			if("extension")	return text
			if("step")		return text
			else return 0
	return 1*/






