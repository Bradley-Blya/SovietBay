var/list/logrus = typesof(/obj/effect/proc_holder/logrus) //needed for the badmin verb for now

/obj/effect/proc_holder/logrus
	name = "Spell"
	desc = "A logrus spell"
	density = 0
	opacity = 0

	var/school = "evocation" //not relevant at now, but may be important later if there are changes to how spells work. the ones I used for now will probably be changed... maybe spell presets? lacking flexibility but with some other benefit?

	var/stat_allowed = 1 //see if it requires being conscious/alive, need to set to 1 for ghostpells
	var/invocation = "HURP DURP" //what is uttered when the wizard casts the spell
	var/invocation_type = "none" //can be none, whisper and shout
	var/range = 7 //the range of the spell; outer radius for aoe spells
	var/message = "" //whatever it says to the guy affected by it
	var/selection_type = "view" //can be "range" or "view" or "point"

	var/overlay = 0
	var/overlay_icon = 'icons/obj/wizard.dmi'
	var/overlay_icon_state = "spell"
	var/overlay_lifespan = 0

	var/sparks_spread = 0
	var/sparks_amt = 0 //cropped at 10
	var/smoke_spread = 0 //1 - harmless, 2 - harmful
	var/smoke_amt = 0 //cropped at 10

	var/critfailchance = 0
	var/centcomm_cancast = 1 //Whether or not the spell should be allowed on z2
	var/vocation = "HURP DURP"
	var/magnitude = 0		//Magnitude is the amount of mana the effect will be using.

	var/mana				//So any spell can be charged with mana
	var/mob/living/caster
	var/source				//Where the spell takes power
	var/charges				//Each time the spell is triggered, it uses one charge.
	var/active = 0
	var/word

/obj/effect/proc_holder/logrus/proc/cast_check(skipcharge = 0, mob/user = usr) //checks if the spell can be cast based on its settings; skipcharge is used when an additional cast_check is called inside the spell

	if(usr.z == 2 && !centcomm_cancast) //Certain spells are not allowed on the centcomm zlevel
		return 0

	if(usr.stat && !stat_allowed)
		usr << "Not when you're incapacitated."
		return 0

	return 1


obj/effect/proc_holder/logrus/Click()
    return 1

/obj/effect/proc_holder/logrus/hear_talk(mob/M as mob, text)
	var/list/replacechars = list("'" = "","\"" = "",">" = "","<" = "","(" = "",")" = "")
	text = replace_characters(text, replacechars)
	if(text == vocation && M == caster)
		trigger()



/*obj/effect/proc_holder/logrus/proc/start_recharge()
	while(charge_counter < charge_max)
		sleep(1)
		charge_counter++*/

/obj/effect/proc_holder/logrus/proc/trigger(given_target)//scenery
	var/target
	if(!cast_check())
		return
	//caster_scenery()
	active = 1
	//perform(given_target)


//	before_cast()
	target = choose_targets(given_target)
	if(!target && selection_type == "point")
		while(!target)
			sleep(1)

	if(!target)
		return

	cast(target)
	after_cast(target)


/obj/effect/proc_holder/logrus/proc/perform(given_target, var/target)
	//before_cast()
	target = choose_targets(given_target) //If the target doesn't fit, returns null, so it's also a target check.
	if(!target)
		return // TODO: add abort/skip cast.
	else
		cast(target)
	//after_cast(target)


/obj/effect/proc_holder/logrus/proc/choose_targets(given_target)//TODO: target check for effects. Or no need for it?
	return given_target

/*obj/effect/proc_holder/logrus/proc/before_cast(list/targets)//Do i need this shit?
	if(overlay)												  //Makes stuff on a tile, where spell was casted.
		for(var/atom/target in targets)
			var/location
			if(istype(target,/mob/living))
				location = target.loc
			else if(istype(target,/turf))
				location = target
			var/obj/effect/overlay/spell = new /obj/effect/overlay(location)
			spell.icon = overlay_icon
			spell.icon_state = overlay_icon_state
			spell.anchored = 1
			spell.density = 0
			spawn(overlay_lifespan)
				del(spell)*/

/obj/effect/proc_holder/logrus/proc/after_cast(list/targets)//Should make stuff on the target's tile, or on the target.
	return

/obj/effect/proc_holder/logrus/proc/cast(list/targets)
	return

/obj/effect/proc_holder/logrus/proc/setting(mob/M as mob, text)
	return

/obj/effect/proc_holder/logrus/proc/magnitude(mob/M as mob, text)




/*/obj/effect/proc_holder/logrus/proc/critfail(list/targets)
	return

/obj/effect/proc_holder/logrus/proc/revert_cast(mob/user = usr) //resets recharge or readds a charge
	switch(charge_type)
		if("recharge")
			charge_counter = charge_max
		if("charges")
			charge_counter++
		if("holdervar")
			adjust_var(user, holder_var_type, -holder_var_amount)

	return

obj/effect/proc_holder/logrus/proc/adjust_var(mob/living/target = usr, type, amount) //handles the adjustment of the var when the spell is used. has some hardcoded types
	switch(type)
		if("bruteloss")
			target.adjustBruteLoss(amount)
		if("fireloss")
			target.adjustFireLoss(amount)
		if("toxloss")
			target.adjustToxLoss(amount)
		if("oxyloss")
			target.adjustOxyLoss(amount)
		if("stunned")
			target.AdjustStunned(amount)
		if("weakened")
			target.AdjustWeakened(amount)
		if("paralysis")
			target.AdjustParalysis(amount)
		else
			target.vars[type] += amount //They bear no responsibility for the runtimes that'll happen if you try to adjust non-numeric or even non-existant vars
	return*/

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/obj/effect/proc_holder/logrus/New()
	..()
	caster = loc
	source = loc
	spawn(0)
		mana()




//////////////////////############/////////////////////////
/////////////////////###^^####^^###////////////////////////
////////////////////################///////////////////////
////////////////////#######00#######///////////////////////  This thing supposed to show, where shipment spells starting.
/////////////////////##############////////////////////////  Should be in a separate file, but ther's not much code yet.
/////////////////////####______####////////////////////////
//////////////////////############/////////////////////////

/obj/effect/proc_holder/logrus/shpt
	name = "fireball"

	var/effects = list()
	var/target



/obj/effect/proc_holder/logrus/shpt/choose_targets(mob/user = usr)
	//if(1)//don't remember, what this supposed to mean
	switch(selection_type)
		if("point to")	//TODO: finish this shit.
			selection_type = "point"
			return
		//if("verbal")
		if("select")	//testing purposes
			var/possible_targets = list()
			for(var/mob/living/M in view_or_range(range, user, selection_type))
				possible_targets += M
			target = input("Choose the target for the spell.", "Targeting") as mob in possible_targets
			return
		if("human" || "living" || "robot")
			target = automatic(text)

/obj/effect/proc_holder/logrus/shpt/proc/point_to(text)


/obj/effect/proc_holder/logrus/shpt/proc/pointed(T)
	if(active && selection_type == "point" && usr == caster)
		target = T

/obj/effect/proc_holder/logrus/shpt/proc/automatic(text)
	var T
	switch(text)
		if("living")
			T = pick(/mob/living in view(range))
		if("human")
			T = pick(/mob/living/carbon/human in view(range))
		if("robot")
			T = pick(/mob/living/silicon in view(range))

	return T


/proc/isspell(S)
	if(istype(S, /obj/effect/proc_holder/logrus))
		return 1
	return 0

/obj/effect/proc_holder/logrus/trigger
	name = "trigger"
