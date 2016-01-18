//var/list/logrus = typesof(/obj/logrus) //needed for the badmin verb for now

/obj/logrus
	name = "Spell"
	desc = "A logrus spell"
	density = 0
	opacity = 0

	var/school = "evocation"

	var/overlay = 0		//should be a separate effect object
	var/overlay_icon = 'icons/obj/wizard.dmi'
	var/overlay_icon_state = "spell"
	var/overlay_lifespan = 0

	var/centcomm_cancast = 1 //Whether or not the spell should be allowed on z2
	var/vocation = "HURP DURP"

	var/mana				//So any spell can be charged with mana
	var/mob/caster			//Like admin access to the spell
	var/obj/logrus/source				//Where the spell takes power

/obj/logrus/Click()
    return

/obj/logrus/New()
	..()
	caster = loc
	source = loc
	spawn(0)
		mana()

/obj/logrus/Destroy()//yep, i need this
	del src

/obj/logrus/effect
	var/focus			//how user affects the waste of the spell
	var/detoration		//how much mana passed through the spell
	var/waste			//how much mana is wasted by the spell
	var/constraint		//how much mana costs the spells vocation,
	var/obj/logrus/effect/auxilary/auxilary		//an auxilary spell one per effect

/obj/logrus/effect/proc/perform()
	conversion()					//this calculates how much mana is wasted due to imperfection of the spell, or if it's going to work at all
	cast()						//this is the actual spell in acion
	trigger()						//here spell handles spells inside of it

/obj/logrus/effect/proc/conversion()
	var/loss1 = mana*(1-(100+((-0.5)*(detoration)))/100)
	var/loss2 = mana*(1-(100+((-0.5)*(detoration+mana)))/100)
	waste = (loss1+loss2)/2
	mana -= waste
//	waste = round(waste, 1)
//	mana = round(mana, 1)

/obj/logrus/effect/proc/cast()
	return

/obj/logrus/effect/proc/cost()
	return

/obj/logrus/effect/proc/trigger()
	return

/obj/logrus/effect/proc/setting(mob/M as mob, text)
	return

/obj/logrus/effect/Del()
	for(var/obj/logrus/effect/S in contents)
		S.loc = loc


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/obj/logrus/effect/targeted
	var/target


/obj/logrus/effect/targeted/shpt



/atom/proc/isspell(S)
	if(istype(S, /obj/logrus))
		return 1
	return 0