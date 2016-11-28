/obj/logrus/spellcraft
	name = "Logrus"
	desc = "Summon it!"  //2/(1+(x/50))
	//icon = 'icons/effects/magic.dmi'
	icon_state = "logrus"

	var/stage = 0									//Stage of spellcrafting
	/*
	stage=0 - logrus is idle, the state it has after you unsummon it
	stage=1 - logrus is summoned
	stage=2 - spellcrafting is initiated
	stage=[in crafting] - spell's name has been specified
	*/

	var/vocation_spell = ""							//Text, wich will activate the spell
	var/spell_name = "name"							//The name of the spell
	var/effects = list()							//Spell effects, wich will be added to the spell
	var/obj/logrus/effect/effect					//spell effect. Will be added to effects list of the spell
	var/obj/logrus/effect/auxilary/auxilary			//curently editing auxilary spell
	var/effect_type									//The type of effect wich is being created (in effect var)
	var/option = 1								//from 1 to 99 for effects and from 100 to 199 for auxilary; i probably need somthing better than this
												//used by magnitude proc to determine, wich stat is tweaked

/mob/Stat()
	..()
	for(var/obj/logrus/spellcraft/S in contents)
		statpanel("Logrus", "Magic Power: [round(S.mana, 1)]", S)

/mob/verb/gl() // TESTING PURPOSES
	set usr = src

	if(logrus_check())
		return

	var/obj/logrus/spellcraft/L = new(src)
	if(!L.ticker)
		L.ticker = new/datum/logrus()

	L.ticker.logrus_list.Add(src)


/obj/logrus/spellcraft/proc/logrus_check()
	if(istype(get_active_hand(), /obj/item/logrus/rein)) return 3
	var/obj/logrus/spellcraft/logrus = locate() in src
	if(logrus)
		if(logrus.stage)
			if(istext(logrus.stage))
				return 3
			return 2
		else 	return 1
	else 	return 0


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


//;1;2;in crafting;3;4;5;6;7;8;
/////////////////////////////////////////////////////////////////////////////////////
////////////////////Main spellcrafting proc./////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////
/obj/logrus/spellcraft/hear_talk(mob/M, text)
	if(caster != M)	//Other people ignored.
		return

	var/n = all.Find(text)		//the number of the word
	
	if(stage == 0)		//logrus is idle and spellcrafting is off
		return
	
	else if(stage == 1)
		begin_cast(M, text)
	
	else if(stage == 2)
		if(!spell_name)
			Spell_name(M, text)
			
		else if(text in crafting)
			compile(M, text)
			stage = 3
			effect_type = crafting.Find(text)
			
		else if(effect)
			setting(M, text, n)
			
		else
			wrongword(M, text)
			
	else if(stage == 3)
		effect_add(M, text, n)
		
	else wrongword(M, text)
/*
	if(text in auxilary_words && effect) //Affect only other spells and make power transfers and targeting much faster
		auxilary(M, text)

	//if(3) setting(M, text)
	if(text in subeffects_words && effect)
		setting(M, text)

	//if(4) magnitude(M, text)
	if(text in magnitude_mod && effect)
		magnitude(M, text)
*/



//stage 1
/obj/logrus/spellcraft/proc/begin_cast(mob/M, text)//Used!
	if(text in all)
		stage = 2

//stage = 2
/obj/logrus/spellcraft/proc/Spell_name(mob/M, text)//gives a name to the spell
	if(text && lentext(text) <= 15)
		var/list/replacechars = list("\"" = "", ">" = "", "<" = "", "(" = "", ")" = "", "-" = "", "_" = "", " "="")
		text = replace_characters(text, replacechars)
		spell_name = text
		vocation_spell = text
	worngword(M, text)

//stage = in crafting
/obj/logrus/spellcraft/proc/effect_add(mob/M, text, n)//Creating an effect
	if(effect_type == 2) //targeted
		return
	if(effect_type == 3) //basic
		switch(n)
			if(16) 	effect = new /obj/logrus/effect/infliction(src)
			else
				wrongword(M, text)
				return
	if(effect_type == 1)//delivery
		switch(n)
			if(16) 	effect = new /obj/logrus/effect/targeted/shpt/imposition(src)
			else
				wrongword(M, text)
				return
				
	stage = 2
	option = 1


/obj/logrus/spellcraft/proc/compile(mob/M, text)
	if(effect)
		if(effect_type == 1)//delivery 
			effect.contents += effects
			effects = effect
		if(effect_type == 2 | effect_type == 3)// targeted|basic
			effects += effect
		addspace()		//Each effect is a separate word in the vocation, so here goes space.
	


/obj/logrus/spellcraft/proc/setting(mob/M, text, n)//Here we adjust effects' vars.
	if(text in drainer || text in trigger)
		auxilary_add(M, text, n)

	else if(text in main)
		effect.setting(M, n, n)
		
	else if(text in magnitude)
		if(abs(option) < 100)
			effect.magnitude(M, text, option)
		else
			auxilary.magnitude(M, text, option)
			
	
	else wrongword(M, text)



/*/obj/logrus/spellcraft/proc/auxilary_check(text)//I'm not sure what it does. Srsly.
	if(text in drainer)
		if(effect.auxilary)
			if(istype(effect.auxilary, /obj/logrus/effect/auxilary/drainer))
				return 1
		else
			return effect

	if(text in trigger)
		if(effect.auxilary)
			if(istype(effect.auxilary, /obj/logrus/effect/auxilary/trigger))
				return 1
			else if(istype(effect.auxilary.auxilary, /obj/logrus/effect/auxilary/trigger))
				return 2
			else
				return effect.auxilary
		else
			return effect

	return 0
	*/


/obj/logrus/spellcraft/proc/auxilary_add(mob/M, text, n)
	var/r = auxilary_check(text)
	if(r)
		if(isnum(r))

		else
			var/obj/logrus/effect/Holder = r
			if(text in drainer)		Holder.auxilary = new /obj/logrus/effect/auxilary/drainer(r)
			if(text in trigger)		Holder.auxilary = new /obj/logrus/effect/auxilary/trigger(r)
			stage = 2 + auxilary_check(text)

		Holder.auxilary.setting(M, text, n)
		option = 100
		addletter(text)
	else
		wrongword(M, text)


/*/obj/logrus/spellcraft/proc/magnitude(mob/M, text)  //useless
	var/r
	if(option < 100)	//so its effects option
		r = effect.setting(M, text, option)
		if(!isnum(r))
			wrongword(M, text)

	if(option > 100)		//so its auxilary option
		r = effect.auxilary.setting(M, text, option)
		if(!isnum(r) && r)
			wrongword(M, text)

	else if(effect_words.Find(text,1,0))//When the next effect is being called, this one needs to be compilated.
		effect(M, text)
	//else if(text == "end")//End of spellcrafting, compiles the last effect.
		//compile_effect(M)
	else
*/


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
	mana -= 10

////////////////////////wordlists///////////////////////////////////////////////////////////////////////////
var/obj/logrus/list/crafting = list("delivery", "targeted", "basic", "auxilary")//1,2,3,4
var/obj/logrus/list/drainer = list("epsilon", "zeta", "eta")
var/obj/logrus/list/trigger = list("theta", "iota", "kappa")
var/obj/logrus/list/modifiers = list("lambda", "mu", "nu", "xi")
var/obj/logrus/list/main = list("omicron", "phi", "rho", "sigma", "tau", "upsilon", "chi",  "omega")
var/obj/logrus/list/all = list(
"alpha", "beta", "gamma", "delta",	//crafting
//1		   2		3		4
"epsilon", "zeta", "eta",			//drainer
//5			6		7
"theta", "iota", "kappa",			//trigger
//8			9		10
"lambda", "mu", "nu", "xi",			//modifiers
//11	  12	 13	   14
"omicron", "phi", "rho", "sigma", "tau", "upsilon", "chi",  "omega"	//main
//15		16		17		18	  19		20		  21		22
)

var/obj/logrus/list/letters = list("a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","o","r","p","u","v","w","x","y","z")


/*old useless wordlist:
var/obj/logrus/list/starting_words = list("start", "begin", "initiate")
var/obj/logrus/list/effect_words = list("infliction")
var/obj/logrus/list/targeted_words = list("imposition")
var/obj/logrus/list/auxilary_words = list("trigger", "drainer", "container")


var/obj/logrus/list/subeffects_words = list(
//"hallucinations", "hulk", "laser",
"brute", "burn", "oxygen", "toxins", "stun", "paralyse", "weaken",
"range", "part", "living", "robot",
)									//imposition //16 parts, two to choose 4legs 4hands 2body head eyes brain heart lungs
//var/obj/logrus/list/auxilary_words = list(
//"magnitude", "step", "extension"
//)
var/obj/logrus/list/magnitude_mod = list("halveten" = 5, "singleten" = 10, "doubleten" = 20, "fivehalveten" = 25)


//TODO: �� ������ ��������� �������!
*/

