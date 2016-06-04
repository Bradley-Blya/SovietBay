/mob/living/bot/gutsy/explode()
	empulse(src, gutsy_HR, gutsy_LR)
	visible_message(message = "<span class='danger'>ЭМИ! Пора бы бежать, кажется, робот скоро взорвется.</span>", self_message = "А вот и нет.", blind_message = "", translation = null)
	sleep(30)
	explosion(get_turf(loc), 0.2 * gutsy_LR, 0.2 * gutsy_LR, 0.2 * gutsy_LR, 0.2 * gutsy_HR)
	..()
	return null
//----------------------------------------------------------------------
// End of file gutsy_explode.dm //--------------------------------------
//----------------------------------------------------------------------