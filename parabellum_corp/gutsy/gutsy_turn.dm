/mob/living/bot/gutsy/turn_on()
	if(stat)
		return 0
	on = 1
	set_light(light_strength)
	update_icons()
	return 1

/mob/living/bot/gutsy/turn_off()
	on = 0
	set_light(0)
	kick_ai()
	update_icons()