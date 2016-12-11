//;1;2;;3;4;5;6;7;8;
/////////////////////////////////////////////////////////////////////////////////////
////////////////////Main spellcrafting proc./////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////
/obj/logrus/spellcraft/hear_talk(mob/M, text)
	if(caster != M)	//Other people ignored.
		return

	var/n = all.Find(text)		//the number of the word

	switch(stage)
		if(0)		//logrus is idle and spellcrafting is off
			return

		if(1)//right after you summoned logrus
			begin_cast(M, text)//Changes sets stage to 2 or -1

		if(-1)//here goes "knot" creation

		if(2)//here goes spell creation
			if(!spell_name)
				Spell_name(M, text)

			else if(text in crafting)//changed
				compile(M, text)

			else if(effect)
				setting(M, text, n)

			else
				wrongword(M, text)

		if(3)//Adding a new effect
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
/obj/logrus/spellcraft/proc/begin_cast(mob/M, text)//this should chose whether you are creating a spell or a knot
	if(text in all)
		stage = "2"

//stage = 2
/obj/logrus/spellcraft/proc/Spell_name(mob/M, text)//gives a name to the spell
	if(text && lentext(text) <= 15)
		var/list/replacechars = list("\"" = "", ">" = "", "<" = "", "(" = "", ")" = "", "-" = "", "_" = "", " "="")
		text = replace_characters(text, replacechars)
		spell_name = text
		vocation_spell = text
	wrongword(M, text)

//stage = 3
/obj/logrus/spellcraft/proc/effect_add(mob/M, text, n)//Creating an effect
	if(10<n<27)
		if(!option)
			option = n
		else
			if(10<n<21||10<option<21)
				if(20<n<27||20<option<27)
					var/a
					var/b
					if(n < option)
						a = n
						b = option
					else
						a = option
						b = name

					a -= 10
					b -= 20

					for(var/t in )

		addletter(text)
	else
		wrongword()

/obj/logrus/spellcraft/proc/compile(mob/M, text) //it decides, where to put the newly created spell
	if(effect)
		if(effect_type == 1)//delivery - In this case all previosly created spells are put into this one and it becpmes the only current one
			effect.contents += effects
			effects = effect
		if(effect_type == 2 | effect_type == 3)// targeted|basic - in this cse spells are imply stacked near one another
			effects += effect
		addspace()		//Each effect is a separate word in the vocation, so here goes space.


	stage = 3
	option = null
	effect_type = null


/obj/logrus/spellcraft/proc/setting(mob/M, text, n)//Here we adjust effects' vars.
	if(text in trigger)
		auxilary_add(M, text, n)

	else if(text in main)
		effect.setting(M, n)

	else if(text in modifiers)
		if(abs(option) < 100)
			effect.magnitude(M, text, option)
		else
			auxilary.magnitude(M, text, option)


	else wrongword(M, text)



//So this should be changed to swap aux instead of like this
/obj/logrus/spellcraft/proc/auxilary_add(mob/M, text, n)
	var/obj/logrus/effect/auxilary/trigger/A = new()
	effect.auxilary = A
	A.contents += auxilary
	auxilary = A



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
