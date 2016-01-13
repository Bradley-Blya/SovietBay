/obj/item/logrus
	name = "Logrus Sprout"
	desc = "Yellow glowing transparent thing it the air"
	icon = 'icons/effects/logrus/probe.dmi'
	icon_state = "logrus"
	level = 2
	layer = 2.1
	density = 0
	anchored = 1
	var/atom/movable/focus = null
	var/mob/living/host = null
	var/canmove = 1
	var/mob/caster

/obj/item/logrus/rein
	icon_state = "rein"
	var/obj/item/logrus/probe/probe

	Del()
		del probe
		..()

	dropped()
		del src

/obj/item/logrus/probe
	icon_state = "probe"
	var/obj/item/logrus/rein/rein
	var/obj/pulled
	var/beam

	proc/Probe_Beam()
		beam = 1
		while(beam)
			Beam(caster, time = 1)
			sleep(1)

	Del()
		beam = 0
		sleep(1)
		..()



/*obj/item/logrus/probe/ClickOn()
	return*/
/mob/proc/PickSprout()
	if(2 == logrus_check())
		var/obj/logrus/spellcraft/logrus = locate() in src
		logrus.pick_sprout()



/obj/logrus/spellcraft/proc/pick_sprout()
	var/obj/item/logrus/probe/probe = new/obj/item/logrus/probe(caster.loc)
	var/obj/item/logrus/rein/rein = new/obj/item/logrus/rein(caster)
	caster.put_in_active_hand(rein)
	probe.caster = caster
	rein.caster = caster
	probe.rein = rein
	rein.probe = probe

	probe.Probe_Beam()
	probe.SpinAnimation(speed = 40, loops = -1)
	caster.client.eye = src



/*obj/item/logrus/rein/equipped(var/mob/user, var/slot)
		del(src)*/

/obj/item/logrus/probe/proc/logrus_attack(var/atom/A)
	if(isturf(A) || isturf(A.loc))
		if(loc == A || loc == A.loc)
			if(isobj(A))
				var/obj/object = A
				object.logrus_attacked(src, caster)

	logrus_Move(A)

/obj/item/logrus/probe/proc/logrus_Pull(var/obj/p as obj)
	if(!istype(p,/obj))	return//Cant throw non objects atm might let it do mobs later
	if(p.anchored || !isturf(p.loc))
		return
	if(p == pulled)
		pulled = null
		return
	pulled = p

/obj/item/logrus/probe/proc/logrus_Drop(var/p as obj)
	pulled = null

/obj/item/logrus/probe/proc/logrus_Move(var/atom/A)
	if(isturf(A))
		forceMove(A)
	else if(isturf(A.loc))
		forceMove(A.loc)
	else return

	if(pulled)
		if(!pulled.Move(loc))
			pulled = null




	/*if(isturf(A))
		loc = A
	else if(isturf(A.loc))
		loc = A.loc
	else return*/



/obj/item/logrus/probe/proc/logrus_Click(var/atom/A, var/params)
	/*var/list/modifiers = params2list(params)
		if(modifiers["shift"] && modifiers["ctrl"])
			CtrlShiftClickOn(A)
			return
		if(modifiers["middle"])
			MiddleClickOn(A)
			return
		if(modifiers["shift"])
			ShiftClickOn(A)
			return
		if(modifiers["alt"]) // alt and alt-gr (rightalt)
			AltClickOn(A)
			return
		if(modifiers["ctrl"])
			CtrlClickOn(A)
			return*/

	logrus_attack(A)

/obj/item/logrus/probe/proc/logrus_DblClick(var/atom/A, var/params)
	return

/obj/item/rein/moved(mob/user as mob, old_loc as turf)
	..()
	world << "moved [old_loc]"


/obj/proc/logrus_attacked(var/p, var/caster as mob)
	var/obj/item/logrus/probe/probe = p
	probe.logrus_Pull(src)