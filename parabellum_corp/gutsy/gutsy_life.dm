/mob/living/bot/gutsy/Life()
	..()
	update_icons()
	if(!on)
		return null
	update_icons()
	if(client)
		return null
	if(fuel<0.0)
		fuel=0.0
		icon_state="gutsy_a2i"
		return null
	if(fuel>maxFuel)
		fuel=maxFuel
	fuel-=fuelPortion
	return null
/mob/living/bot/gutsy/self_destruct()
	set name="Self destruct"
	set category="Bot"
	if(alert("You sure?","Self destruct","Yes","No")=="Yes")
		explode()

/mob/living/bot/gutsy/updatehealth()
	if(status_flags & GODMODE)
		health = maxHealth
		stat = CONSCIOUS
	else
		health = maxHealth - getFireLoss() - getBruteLoss()
	oxyloss = 0
	toxloss = 0
	cloneloss = 0
	halloss = 0

/mob/living/bot/gutsy/death()
	explode()
//----------------------------------------------------------------------
// End of file gutsy_life.dm //-----------------------------------------
//----------------------------------------------------------------------