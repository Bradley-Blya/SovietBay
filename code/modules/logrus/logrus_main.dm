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
	var/source				//Where the spell takes power

/obj/logrus/Click()
    return

/obj/logrus/New()
	..()
	caster = loc
	source = loc
	spawn(0)
		mana()

/obj/logrus/Destroy()
	del src

/obj/logrus/effect
	var/focus
	var/detoration

	proc/perform(var/mana as num)
		return
	proc/setting(mob/M as mob, text)
		return
	proc/trigger()
		return

/obj/logrus/effect/targeted
	perform(var/mana as num, var/target as mob|obj|turf)
		return

/obj/logrus/effect/targeted/shpt
	perform(var/mana as num, var/target as mob|obj|turf)
		for(var/obj/logrus/effect/E in src.contents)
			E.trigger()

/obj/logrus/effect/targeted/auxilary

	trigger

	drainer




/atom/proc/isspell(S)
	if(istype(S, /obj/logrus))
		return 1
	return 0