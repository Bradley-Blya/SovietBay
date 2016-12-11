/mob/living/bot/gutsy/update_icons()
	if(on)
		if(icon_state == "gutsy_inactive")
			flick("gutsy_i2a", src)
			icon_state = "gutsy_active"
			set_light(4, 4, "#00FF00")
			return null
		else
			return null
	else
		if(icon_state == "gutsy_active")
			flick("gutsy_a2i", src)
			icon_state = "gutsy_inactive"
			set_light(0)
			return null
		else
			return null
//----------------------------------------------------------------------
// End of file gutsy_update_icons.dm //---------------------------------
//----------------------------------------------------------------------