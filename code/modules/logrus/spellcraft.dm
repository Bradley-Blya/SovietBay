/obj/logrus/spellcraft
	name = "Logrus"
	desc = "Summon it!"  //2/(1+(x/50))
	//icon = 'icons/effects/magic.dmi'
	icon_state = "logrus"

	var/stage = 0									//Stage of spellcrafting

	var/vocation_spell = ""							//Text, wich will activate the spell
	var/spell_name = "name"							//The name of the spell
	var/effects = list()							//Spell effects, wich will be added to the spell
	var/obj/logrus/effect/effect		//spell effect. Will be added to effects list of the spell
	var/option = "main"

mob/Stat()
	..()
	for(var/obj/logrus/spellcraft/S in contents)
		statpanel("Logrus", "Magic Power: [round(S.mana, 1)]", S)

mob/verb/gl() // TESTING PURPOSES
	set usr = src

	new/obj/logrus/spellcraft(usr)

mob/proc/logrus_check()
	if(istype(get_active_hand(), /obj/item/logrus/rein)) return 3
	var/obj/logrus/spellcraft/logrus = locate() in src
	if(logrus)
		if(logrus.stage)	return 2
		else 				return 1
	else 					return 0


mob/proc/get_logrus()//this will be needed when staff mages introduced
	var/obj/logrus/spellcraft/logrus = locate() in src
	return logrus

mob/proc/get_logrus_probe()//this will be needed when staff mages introduced
	var/obj/item/logrus/rein/rein = locate() in src
	return rein.probe

/*/obj/logrus/spellcraft/see_emote(mob/M, text)
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
	if(stage)
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

/////////////////////////////////////////////////////////////////////////////////////
////////////////////Main spellcrafting proc./////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////
/obj/logrus/spellcraft/hear_talk(mob/M, text)
	if(caster != M)	//Other people ignored.
		return

	switch(stage)						//This is where stage is used.
		//if(0) begin_cast(M, text)

		if(1) Spell_name(M, text)

		if(2) effect(M, text)

		if(3) setting(M, text)

		//if(4) magnitude(M, text)

		else log_debug("Stage bug, report it! [__LINE__]")
	return

//stage 0
/*obj/logrus/spellcraft/proc/begin_cast(mob/M, text)//not used for now
	if(stage)//text == "start" || text == "begin" || text == "initiate")
		stage = 1
		effects = list()*/

//stage 1
/obj/logrus/spellcraft/proc/Spell_name(mob/M, text)//gives a name to the spell
	if(text && lentext(text) <= 30)
		var/list/replacechars = list("\"" = "",">" = "","<" = "","(" = "",")" = "", "-" = " ", "_" = " ")
		text = replace_characters(text, replacechars)
		spell_name = text
		vocation_spell = text
		stage = 2

//stage 2
/obj/logrus/spellcraft/proc/effect(mob/M, text)//So adding effects.
	switch(text)

		//The actual effects.
		if("infliction") 	effect = new /obj/logrus/effect/infliction(M)	//infliction@123


		//The way, how the effects from above are being delivered to their targets, eg. fireball or trigger.
		if("imposition") 	effect = new /obj/logrus/effect/targeted/shpt/imposition(M) //imposition@123

		else
			wrongword(M, text)


	if(istype(effect, /obj/logrus/effect/targeted/shpt))
		var/obj/logrus/effect/targeted/shpt/E = effect
		for(var/EF in effects)
			E.contents += EF
		effects = E
	else if(istype(effect, /obj/logrus))
		effects += effect

	stage = 3
	addspace()		//Each effect is a separate word in the vocation, so here goes space.
	addletter(text)

//stage 3
/obj/logrus/spellcraft/proc/setting(mob/M, text)//Here we adjust effects' vars.
	var/r
	if(text == "'")
		option = "main"

	if(magnitude_mod.Find(text))			//Magnitude assigns a value to the option.

		if(subeffects_words.Find(option))	//so its the effects option
			r = effect.setting(M, text, option)
			if(!isnum(r))
				wrongword(M, text)

		if(auxilary_words.Find(option))		//so its an effects' auxilary spell option
			r = effect.auxilary.setting(M, text, option)
			if(!isnum(r))
				wrongword(M, text)

	if(subeffects_words.Find(text))			//Here we choose wich option to edit

		if(subeffects_words.Find(option))	//so its the effects option
			r = effect.setting(M, text, option)
			if(!istext(r))
				wrongword(M, text)

		if(auxilary_words.Find(option))		//so its an effects' auxilary spell option
			if(!effect.auxilary)
				effect.auxilary = new /obj/logrus/effect/auxilary/drainer(effect)
			r = effect.auxilary.setting(M, text, option)
			if(!istext(r))
				wrongword(M, text)



	else if(effects_words.Find(text,1,0))//When the next effect is being called, this one needs to be compilated.
		effect(M, text)
	//else if(text == "end")//End of spellcrafting, compiles the last effect.
		//compile_effect(M)
	else wrongword(M, text)


/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
/obj/logrus/spellcraft/proc/addletter(text)
	var/L
	L = copytext(text,1,2)
	effect.vocation += L
	vocation_spell += L
	caster << "<span class='notice'>[vocation_spell]</span>"
	effect.constraint += 1
	return L

/obj/logrus/spellcraft/proc/addspace()
	vocation_spell += " "

/obj/logrus/spellcraft/proc/wrongword()
	caster << "<span class='warning'>You feel some magic energy dissipating into nowhere.</span>"
	text = ""
	transfer(10)

////////////////////////wordlists///////////////////////////////////////////////////////////////////////////
var/obj/logrus/list/starting_words = list("start", "begin", "initiate")
var/obj/logrus/list/effects_words = list("genetic", "imposition", "infliction")
var/obj/logrus/list/subeffects_words = list(
//"hallucinations", "hulk", "laser",												//genetic
"brute", "burn", "oxygen", "toxins", "stun", "paralyse", "weaken",				//infliction
"range", "part", "living", "robot",
)									//imposition //16 parts, two to choose 4legs 4hands 2body head eyes brain heart lungs
var/obj/logrus/list/auxilary_words = list(
"magnitude", "step", "extension"
)
var/obj/logrus/list/magnitude_mod = list("halveten" = 5, "singleten" = 10, "doubleten" = 20, "fivehalveten" = 25)


//TODO: Все заклинания в ебеня.