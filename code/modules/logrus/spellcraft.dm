/obj/logrus/spellcraft
	name = "Logrus"
	desc = "Summon it!"  //2/(1+(x/50))
	//icon = 'icons/effects/magic.dmi'
	icon_state = "logrus"

	var/stage = 0 as num									//Stage of spellcrafting
	/*
	stage=0 - logrus is idle, the state it has after you unsummon it
	stage=1 - logrus is summoned
	stage=2 - spellcrafting is initiated
	stage=[in crafting] - spell's name has been specified
	*/

	var/vocation_spell = ""							//Text, wich will activate the spell
	var/spell_name = "name"							//The name of the spell
	var/list/effects = list()							//Spell effects, wich will be added to the spell
	var/obj/logrus/effect/effect					//spell effect. Will be added to effects list of the spell
	var/obj/logrus/effect/auxilary/auxilary			//curently editing auxilary spell
	var/effect_type									//The type of effect wich is being created (in effect var)
	var/option = 1								//1 - trigger, 2 - scanner, 3 - signaller
												//used by magnitude proc to determine, wich stat is tweaked

	var/list/ileus()			//the list of knots

/mob/Stat()
	..()
	for(var/obj/logrus/spellcraft/S in contents)
		statpanel("S", "Magic Power: [round(S.mana, 1)]", S)

/mob/verb/gl() // TESTING PURPOSES
	set usr = src

	if(logrus_check())
		return

	var/obj/logrus/spellcraft/L = new(src)
	if(!L.ticker)
		L.ticker = new/datum/logrus/ticker/ticker()

	L.ticker.logrus_list.Add(src)


/mob/proc/logrus_check()
	if(istype(get_active_hand(), /obj/item/logrus/rein)) return 3 //sprout is being used
	var/obj/logrus/spellcraft/logrus = locate() in src
	if(logrus)
		if(logrus.stage)
			if(istext(logrus.stage))
				return 3 //stage is text
			return 2 //stage isn't zero - logrus is summoned
		else return 1 //there's logrus
	else 	return 0 //there's no logrus


mob/proc/get_logrus()	//this will be needed when staff mages introduced
						//needs to be adjusted for internal logrus being found before staff one
	var/obj/logrus/spellcraft/logrus = locate() in src
	return logrus

mob/proc/get_logrus_probe()	//this will be needed when staff mages are introduced
	var/obj/item/logrus/rein/rein = locate() in src
	return rein.probe

/*/obj/logrus/spellcraft/see_emote(mob/M, text)//For gesturing spells. Nice thing, but later.
	if(*/

/obj/logrus/spellcraft/Click()
	if(usr == caster)
		toggle()

/obj/screen/logrus
	screen_loc = "WEST,SOUTH to EAST,NORTH"
//	icon = 'icons/480x480.dmi'
	icon_state = "druggy"
	layer = 17
	mouse_opacity = 0

/obj/logrus/spellcraft/proc/toggle()
	if(stage = 2)
		compile()
	else if(stage)
		stage = 0
		/*if(istype(effect, /obj/logrus/shpt))
			var/obj/logrus/shpt/E = effect
			E.effects = effects
			E.name = spell_name*/
		effects = list()

		for(var/obj/item/logrus/rein/rein in caster.contents)
			del rein
		caster << "You let logrus away."
		for(var/obj/screen/logrus/screen in caster.client.screen)
			del screen
	else if(!stage)
		stage = 1
		caster << "You summon logrus"
		var/screen = new /obj/screen/logrus()
		caster.client.screen += screen




