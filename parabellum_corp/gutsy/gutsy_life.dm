/mob/living/bot/gutsy/Life()
	..()
	if(!on)
		return
	update_icons()
	if(client)
		return
	if(fuel<0.0)
		fuel=0.0
		icon_state="gutsy_a2i"
		return
	if(fuel>maxFuel)
		fuel=maxFuel
	fuel-=fuel_portion
	return
//----------------------------------------------------------------------
// End of file gutsy_life.dm //-----------------------------------------
//----------------------------------------------------------------------