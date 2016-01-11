/obj/effect/proc_holder/logrus/spellcraft
	name = "Logrus"
	desc = "Summon it!"  //2/(1+(x/50))
	//icon = 'icons/effects/magic.dmi'
	icon_state = "logrus"

	var/stage = 0									//Stage of spellcrafting

	var/vocation_spell = ""							//Text, wich will activate the spell
	var/spell_name = "name"							//The name of the spell
	var/effects = list()							//Spell effects, wich will be added to the spell
	var/obj/effect/proc_holder/logrus/effect		//spell effect. Will be added to effects list of the spell
	var/option = "main"

mob/Stat()
	..()
	for(var/obj/effect/proc_holder/logrus/spellcraft/S in contents)
		statpanel("logrus", "[S][round(S.mana, 1)]", S)

mob/verb/gl() // TESTING PURPOSES
	set usr = src

	new/obj/effect/proc_holder/logrus/spellcraft(usr)

mob/proc/logrus_check()
	if(istype(get_active_hand(), /obj/item/logrus/rein)) return 3
	var/obj/effect/proc_holder/logrus/spellcraft/logrus = locate() in src
	if(logrus)
		if(logrus.stage)	return 2
		else 				return 1
	else 					return 0


mob/proc/get_logrus()
	var/obj/effect/proc_holder/logrus/spellcraft/logrus = locate() in src
	return logrus


mob/proc/get_logrus_probe()
	var/obj/item/logrus/rein/rein = locate() in src
	return rein.probe


/*/obj/effect/proc_holder/logrus/spellcraft/see_emote(mob/M as mob, text)
	if(*/

/obj/effect/proc_holder/logrus/spellcraft/Click()
	if(usr == caster)
		toggle()

/obj/screen/logrus
	screen_loc = "WEST,SOUTH to EAST,NORTH"
//	icon = 'icons/480x480.dmi'
	icon_state = "druggy"
	layer = 17
	mouse_opacity = 0

/obj/effect/proc_holder/logrus/spellcraft/proc/toggle()
	if(stage)
		stage = 0
		/*if(istype(effect, /obj/effect/proc_holder/logrus/shpt))
			var/obj/effect/proc_holder/logrus/shpt/E = effect
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
/obj/effect/proc_holder/logrus/spellcraft/hear_talk(mob/M as mob, text)
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
/obj/effect/proc_holder/logrus/spellcraft/proc/begin_cast(mob/M as mob, text)//not used for now
	if(active)//text == "start" || text == "begin" || text == "initiate")
		stage = 1
		effects = list()

//stage 1
/obj/effect/proc_holder/logrus/spellcraft/proc/Spell_name(mob/M as mob, text)//gives a name to the spell
	if(text && lentext(text) <= 30)
		var/list/replacechars = list("\"" = "",">" = "","<" = "","(" = "",")" = "", "-" = " ", "_" = " ")
		text = replace_characters(text, replacechars)
		spell_name = text
		vocation_spell = text
		stage = 2

//stage 2
/obj/effect/proc_holder/logrus/spellcraft/proc/effect(mob/M as mob, text)//So adding effects.
	switch(text)

		//The actual effects.
		if("genetic") 		effect = new /obj/effect/proc_holder/logrus/genetic(M) 		//genetic@123
		if("infliction") 	effect = new /obj/effect/proc_holder/logrus/infliction(M)	//infliction@123


		//The way, how the effects from above are being delivered to their targets, eg. fireball or trigger.
		if("imposition") 	effect = new /obj/effect/proc_holder/logrus/shpt/imposition(M) //imposition@123

		else
			wrongword(M, text)


	if(istype(effect, /obj/effect/proc_holder/logrus/shpt))
		var/obj/effect/proc_holder/logrus/shpt/E = effect
		for(var/EF in effects)
			E.contents += EF
		E.effects = effects
		effects = E
	else if(istype(effect, /obj/effect/proc_holder/logrus))
		effects += effect

	stage = 3
	addspace()		//Each effect is a separate word in the vocation, so here goes space.
	addletter(text)

//stage 3
/obj/effect/proc_holder/logrus/spellcraft/setting(mob/M as mob, text)//Here we adjust effects' vars.
	if(subeffects_words.Find(text,1,0) || modifiers_words.Find(1,0))//Magnitude is the amount of mana the effect will be using.//This thing only adjusts stage.
		if(!isspell(effect))
			log_debug("it's not a spell in logrus.dm on [__LINE__]")
			return
		if(effect.setting(M, text))
			log_debug("thats 1 in spellcraft on [__LINE__]")
		else
			log_debug("thats 0 in spellcraft on [__LINE__]")
			wrongword(M, text)


	else if(magnitude_mod.Find(text,1,0))


	else if(effects_words.Find(text,1,0))//When the next effect is being called, this one needs to be compilated.
		effect(M, text)
	//else if(text == "end")//End of spellcrafting, compiles the last effect.
		//compile_effect(M)
	else wrongword(M, text)

/obj/effect/proc_holder/logrus/spellcraft/proc/addletter(text)
	var/L
	L = copytext(text,1,2)
	vocation_spell += L
	world << "[vocation_spell]"
	return L

/obj/effect/proc_holder/logrus/spellcraft/proc/addspace()
	vocation_spell += " "

/obj/effect/proc_holder/logrus/spellcraft/proc/wrongword()
	caster << "<span class='warning'>You feel some magic energy dissipating into nowhere.</span>"
	text = ""
	transfer(10)

////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////100/////////////////////////////////////////////////////////////////////////////////


////////////////////////wordlists///////////////////////////////////////////////////////////////////////////
var/obj/effect/proc_holder/logrus/list/starting_words = list("start", "begin", "initiate")
var/obj/effect/proc_holder/logrus/list/effects_words = list("genetic", "imposition", "infliction")
var/obj/effect/proc_holder/logrus/list/subeffects_words = list(
"hallucinations", "hulk", "laser",												//genetic
"brute", "burn", "oxygen", "toxins", "stun", "paralyse", "weaken",				//infliction
"select", "point", "human", "living", "robot")									//imposition
var/obj/effect/proc_holder/logrus/list/modifiers_words = list(

"duration")
var/list/magnitude_mod = list("halveten" = 5, "singleten" = 10, "doubleten" = 20, "fivehalveten" = 25, "stretch", "snail")
//####,

//TODO: ���������� ��� �������� � �������������. ����� ����������� ����� � ����� ������� �������.
//		����, ���� ����� � �����������. ������ ����. � ��� ��� �������� � ���������.
//		��������� - �����. ���������� ���������.
//		����, ��������� �������� ��������� � ���� �������.