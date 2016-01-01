/obj/effect/proc_holder/logrus/spellcraft
	name = "Logrus"
	desc = "Summon it!"  //2/(1+(x/50))
	icon = 'icons/effects/magic.dmi'
	icon_state = "logrus"

	var/stage = 0									//Stage of spellcrafting

	var/vocation_spell = ""							//Text, wich will activate the spell
	var/spell_name = "name"							//The name of the spell
	var/effects = list()							//Spell effects, wich will be added to the spell
	var/obj/effect/proc_holder/logrus/effect		//spell effect. Will be added to effects list of the spell
	var/option = "main"
	var/sprout
	var/gyrus


/*/obj/effect/proc_holder/logrus/spellcraft/see_emote(mob/M as mob, text)
	if(*/
/obj/screen/logrus_overlay
	layer = 19
	icon = 'icons/480x480.dmi'
	icon_state = "yellow_overlay"

/obj/effect/proc_holder/logrus/spellcraft/Click()
	if(usr == caster)
		toggle()

/obj/effect/proc_holder/logrus/spellcraft/proc/toggle()
	if(stage)
		stage = 0
		if(istype(effect, /obj/effect/proc_holder/logrus/shpt))
			var/obj/effect/proc_holder/logrus/shpt/E = effect
			E.effects = effects
			E.name = spell_name
		effects = list()
		caster << "You let logrus away."
		overlay = null
		//if(caster.client)
		//	var/obj/screen/logrus_overlay/overlay = new(caster.client.screen)
	else if(!stage)
		stage = 1
		caster << "You summon logrus"
		overlay = global_hud.druggy
		gyrys = new/obj/item/logrus(caster)

////////////////////Main spellcrafting proc./////////////////////////////////////////
/obj/effect/proc_holder/logrus/spellcraft/hear_talk(mob/M as mob, text)
	if(caster != M)	//Other people ignored.
		return

	switch(stage)						//This is where "stage" is used.
		//if(0) begin_cast(M, text)

		if(1) Spell_name(M, text)

		if(2) effect(M, text)

		if(3) setting(M, text)

		//if(4) magnitude(M, text)

		else log_debug("Stage bug, report it! [__LINE__]")
	return


/obj/effect/proc_holder/logrus/spellcraft/proc/begin_cast(mob/M as mob, text)//not used for now
	if(active)//text == "start" || text == "begin" || text == "initiate")
		stage = 1
		effects = list()

/obj/effect/proc_holder/logrus/spellcraft/proc/Spell_name(mob/M as mob, text)//gives a name to the spell
	if(text && lentext(text) <= 30)
		var/list/replacechars = list("\"" = "",">" = "","<" = "","(" = "",")" = "", "-" = " ", "_" = " ")
		text = sanitize_simple(text, replacechars)
		spell_name = text
		vocation_spell = text
		stage = 2

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


/obj/effect/proc_holder/logrus/spellcraft/setting(mob/M as mob, text)//Here we adjust effects' vars.
	//This thing only adjusts stage.
	if(subeffects_words.Find(text,1,0) || modifiers_words.Find(1,0))//Magnitude is the amount of mana the effect will be using.//This thing only adjusts stage.
		if(!isspell(effect))
			log_debug("it's not a spell in logrus.dm on [__LINE__]")
			return
		if(effect.setting(M, text))
			log_debug("thats 1 in spellcraft on [__LINE__]")
		else
			log_debug("thats 0 in spellcraft on [__LINE__]")
			wrongword(M, text)

		/*switch(effect.name)
			if("genetic") stage = 110
			if("infliction") stage = 120


			if("imposition") stage = 910*/

	else if(magnitude_mod.Find(text,1,0))


	else if(effects_words.Find(text,1,0))//When the next effect is being called, this one needs to be compilated.
		effect(M, text)
	//else if(text == "end")//End of spellcrafting, compiles the last effect.
		//compile_effect(M)
	else wrongword(M, text)


/*obj/effect/proc_holder/logrus/spellcraft/proc/magnitude(mob/M, text)
	switch(text)
		if("halveten") effect.magnitude += 5
		if("singleten") effect.magnitude += 10
		if("doubleten") effect.magnitude += 20
		if("fivehalveten") effect.magnitude += 25
	addletter(text)*/


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
/obj/effect/proc_holder/logrus/New()
	..()
	sprout = new/obj/effect/proc_holder/logrus/probe(src)


///////////////////////////////////////////////////////////////////////////////////////////////////////////////
var/obj/effect/proc_holder/logrus/list/starting_words = list("start", "begin", "initiate")
var/obj/effect/proc_holder/logrus/list/effects_words = list("genetic", "imposition", "infliction")
var/obj/effect/proc_holder/logrus/list/subeffects_words = list(
"hallucinations", "hulk", "laser",												//genetic
"brute", "burn", "oxygen", "toxins", "stun", "paralyse", "weaken",				//infliction
"select", "point", "human", "living", "robot")																//imposition
var/obj/effect/proc_holder/logrus/list/modifiers_words = list(

"duration")
var/list/magnitude_mod = list("halveten" = 5, "singleten" = 10, "doubleten" = 20, "fivehalveten" = 25, "stretch", "snail")
//####,

//TODO: Переписать код триггера и маджикмиссела. Нужно определение целей и вызов спеллов получше.
//		Окей, есть вызов и определение. Теперь мана. И все это вставить в спелкрафт.
//		Спелкрафт - говно. Перепилить спелкрафт.
//		Окей, настройку эффектов переносим в сами эффекты.