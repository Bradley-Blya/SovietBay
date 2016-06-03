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
//----------------------------------------------------------------------
// End of file gutsy_life.dm //-----------------------------------------
//----------------------------------------------------------------------