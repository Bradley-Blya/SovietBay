/mob/living/bot/gutsy/update_icons()
	if(on)
		icon_state = "gutsy_active"
	if(on)
		set_light(4, 4, "#00FF00")
	else
		set_light(0)
		icon_state = "gutsy_inactive"
//----------------------------------------------------------------------
// End of file gutsy_update_icons.dm //---------------------------------
//----------------------------------------------------------------------