//var/list/logrus = typesof(/obj/logrus) //needed for the badmin verb for now

/obj/logrus
	name = "Spell"
	desc = "A logrus spell"
	density = 0
	opacity = 0

//	var/school = "evocation"

//	var/centcomm_cancast = 1 	//Whether or not the spell should be allowed on z2
	var/vocation = ""
	var/active
	var/mana					//So any spell can be charged with mana
	var/mob/caster				//Like admin access to the spell
	var/datum/logrus/ticker/ticker		//a ref to the magic ticker

/obj/logrus/Click()
    return

/obj/logrus/Destroy()//yep, i need this     I don't remember, why, though maybe to have mana transfered upon destruction
	del src


/proc/GetSeenSpells(var/turf/T)
	var/list/spells = list()
	spells.Add(GetAtomSpells(T))
	for(var/atom/movable/At in T)
		if(isspell(At))
			continue
		spells.Add(GetAtomSpells(At))
	return spells

/proc/GetAllSpells(var/atom/A)
	var/list/spells = list()
	spells.Add(GetAtomSpells(A))
	for(var/atom/At in A)
		if(isspell(At))
			continue
		spells.Add(GetAllSpells(At))
	return spells

/proc/GetAtomSpells(var/atom/A)
	var/list/spells = list()
	for(var/obj/logrus/S in A)
		spells.Add(A)
	return spells

/proc/GetTurfLoc(var/atom/A)
	if(isturf(A))
		return A
	else
		. = GetTurfLoc(A.loc)


/obj/logrus/effect
	var/focus					//how user affects the waste of the spell
	var/detoration				//how much mana the spell can get trough it before it brokes up
	var/waste					//how much mana is wasted by the spell
	var/constraint = 1			//how much mana costs the spells vocation
	var/mode					//customisation purposes
	var/obj/logrus/source	//Where the spell takes power ftom (should be remade)
	var/obj/logrus/effect/auxilary/auxilary		//an auxilary spell, one per effect  //should be trigger only
//	var/school					//four schools, one per each delivery exept imposition

/obj/logrus/effect/proc/School()
	return "projectile"
	
/obj/logrus/effect/proc/perform()
	conversion()			//this wastes some mana due to imperfection of the spell
	if(!cost())					//used to determine, if the spell has enough power to do it's job: mostly for auxilary
		cast()					//this is the actual spell in action

/obj/logrus/effect/proc/conversion()
	var/loss1 = mana*(1-(100+((-0.5)*(detoration)))/100)
	var/loss2 = mana*(1-(100+((-0.5)*(detoration+1.1*mana)))/100)
	waste = (loss1+loss2)/2
//	mana -= waste
//	waste = round(waste, 1)
//	mana = round(mana, 1)

/obj/logrus/effect/proc/cast()

/obj/logrus/effect/proc/cost()

/obj/logrus/effect/proc/setting(mob/M as mob, text)

/obj/logrus/effect/proc/set_target(atom/A)

/obj/logrus/effect/proc/Add_Aux(var/obj/logrus/effect/auxilary/S)
	if(auxilary)
		auxilary.Add_Aux(S)
	auxilary = S
	S.holder = src
	S.loc = src

/obj/logrus/effect/Del()
	for(var/obj/logrus/effect/S in contents)
		S.loc = loc


/obj/logrus/proc/point(mob/M, atom/A)
	return

///////////////////////////////////////////////////////////////////////////////////////////////////////

/obj/logrus/effect/auxilary
	var/obj/logrus/effect/holder
	var/portion
	var/powered
	var/cost

	New()
		..()
		if(isspell(loc))
			holder = loc
			holder.auxilary = src
		else
			del src

	Destroy()
		if(auxilary)
			Destroy(auxilary)


/*obj/logrus/effect/auxilary/perform(var/ticks)//has to be moved into the ticker
	if(ticks%10)  //if there's a remainder = if it doesn't divide into ten (yeah, my memory is like that)
		return
	..()*/

/obj/logrus/effect/auxilary/conversion(var/portion)
	cost()
	..()

/obj/logrus/effect/auxilary/set_target(atom/A)
	holder.set_target(A)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/obj/logrus/effect/targeted
	var/target
	var/XT
	var/YT

/obj/logrus/effect/targeted/set_target(atom/A)
	target = A
	XT = GetOffset(src, A, "x")
	XT = GetOffset(src, A, "y")


/obj/logrus/effect/targeted/shpt



/proc/isspell(var/atom/S)
	if(istype(S, /obj/logrus))
		return 1
	return 0