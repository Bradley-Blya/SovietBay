/////////////////////////////////////////////////////////////////////////////////////////////
/obj/logrus/effect/genetic
	name = "Genetic"
	desc = "This spell inflicts a set of mutations and disabilities upon the target."

	var/disabilities = 0 //bits
	var/mutation
	var/duration = 100 //deciseconds
	/*
		Disabilities
			1st bit - ?
			2nd bit - ?
			3rd bit - ?
			4th bit - ?
			5th bit - ?
			6th bit - ?
	*/

/obj/logrus/effect/genetic/perform(mob/living/target)
	target.mutations.Add(mutation)
	target.disabilities |= disabilities
	target.update_mutations()	//update target's mutation overlays
	spawn(duration)
		target.mutations.Remove(mutation)
		target.disabilities &= ~disabilities
		target.update_mutations()
	return

/obj/logrus/effect/genetic/setting(mob/M as mob, text)
	if(src/mutation)
		return 0
	switch(text)
		if("hallucinations") 	mutation = mHallucination
		if("hulk") 				mutation = HULK
		if("laser") 			mutation = LASER
		else return 0
	return 1