/obj/effect/proc_holder/logrus/infliction
	name = "Infliction"
	desc = "This spell blinds and/or destroys/damages/heals and/or weakens/stuns the target."

	var/duration = 1
	var/dmgtype
	var/organ
	var/internal_organ

	//these are vars for brute damage aplying and limbs cutting
	sharp = 0	//to 1 to add limb cutting effect
	edge = 0	//to 1 to add higher chance of cutting a limb with high brute damage

/obj/effect/proc_holder/logrus/infliction/cast(mob/living/target)
	var/energy = magnitude
	var/y
	var/d

	if(edge) 				energy -= consume(10)
	if(sharp) 				energy -= consume(30)
	if(dmgtype == "stun") 	energy -= consume(25)
	if(dmgtype == "paralyse") energy -= consume(35)

	energy += 2*duration
	y = energy/duration

	for(var/i = 0, i < duration, i++)
		d = consume(y)
		energy -= d

		switch(dmgtype)
			if("brute")
				d /= 3.3
				if(organ && ishuman(target))
					if(organ == "head") d /= 1.5
					else d /= 1.1
					d = round(d, 1)
					target:adjustBruteLossByPart(d, organ, src)
				if(internal_organ && ishuman(target))
					if(internal_organ == "brain") d /= 3
					else d /= 2
					d = round(d, 1)
					var/datum/organ/internal/O = target:internal_organs_by_name[internal_organ]
					O.take_damage(d, silent=0)
				else
					d = round(d, 1)
					target.adjustBruteLoss(d)
			if("burn")
				d /= 2.5
				if(organ && ishuman(target))
					if(organ == "head") d /= 1.5
					else d /= 1.1
					d = round(d, 1)
					target:adjustFireLossByPart(d, organ, src)
				if(internal_organ && ishuman(target))
					if(internal_organ == "brain") d /= 3
					else d /= 2
					d = round(d, 1)
					var/datum/organ/internal/O = target:internal_organs_by_name[internal_organ]
					O.take_damage(d, silent=0)
				else
					d = round(d, 1)
					target.adjustFireLoss(d)
			if("toxins")
				d /= 1.5
				target.adjustToxLoss(d)
			if("oxyloss")
				d /= 1
				target.adjustOxyLoss(d)
			if("stun")
				d /= 4
				target.Stun(d)
			if("paralyse")
				d /= 6
				target.Paralyse(d)


/obj/effect/proc_holder/logrus/infliction/setting(mob/M, text)
	if(magnitude_mod.Find(text,1,0))
		magnitude += magnitude_mod["[text]"]

	if(subeffects_words.Find(text,1,0))
		if(dmgtype) return 0
		switch(text)
			if("brute")		dmgtype = "brute"
			if("burn")		dmgtype = "burn"
			if("oxygen")	dmgtype = "oxy"
			if("toxins")	dmgtype = "tox"
			if("stun")		dmgtype = "stuned"
			if("paralyse")	dmgtype = "paralysis"
			if("weaken")	dmgtype = "weakened"
			else
				log_debug("not added subeffect word to the list in infliction.dm [__LINE__]")
				return 0

	return 1



	/*for(var/mob/living/target in targets)
		switch(destroys)
			if("gib")
				target.gib()
			if("gib_brain")
				if(ishuman(target) || ismonkey(target))
					var/mob/living/carbon/C = target
					if(!C.has_brain()) // Their brain is already taken out
						var/obj/item/organ/brain/B = new(C.loc)
						B.transfer_identity(C)
				target.gib()
			if("disintegrate")
				target.dust()

		if(!target)
			continue
		//damage
		if(amt_dam_brute > 0)
			if(amt_dam_fire >= 0)
				target.take_overall_damage(amt_dam_brute,amt_dam_fire)
			else if (amt_dam_fire < 0)
				target.take_overall_damage(amt_dam_brute,0)
				target.heal_overall_damage(0,amt_dam_fire)
		else if(amt_dam_brute < 0)
			if(amt_dam_fire > 0)
				target.take_overall_damage(0,amt_dam_fire)
				target.heal_overall_damage(amt_dam_brute,0)
			else if (amt_dam_fire <= 0)
				target.heal_overall_damage(amt_dam_brute,amt_dam_fire)
		target.adjustToxLoss(amt_dam_tox)
		target.oxyloss += amt_dam_oxy
		//disabling
		target.Weaken(amt_weakened)
		target.Paralyse(amt_paralysis)
		target.Stun(amt_stunned)

		target.eye_blind += amt_eye_blind
		target.eye_blurry += amt_eye_blurry*/