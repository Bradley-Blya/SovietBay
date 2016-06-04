/mob/living/bot/gutsy
	name = "Mr. Gutsy"
	icon='gutsy.dmi'
	desc = "Mister Gutsy is a combat variant of the popular Mister Handy."
	icon_state = "gutsy_active"
	maxHealth = 500
	health = 500
	var/fuel = 50.0
	var/fuelCoeff = 2
	var/maxFuel = 50.0
	var/fuelPortion = 0.001
	var/gutsyChipMode = 0
	var/list/path = list()
	var/mob/living/carbon/human/target = null
//----------------------------------------------------------------------
/mob/living/bot/gutsy/New()
	..()
	return null
//----------------------------------------------------------------------
/mob/living/bot/gutsy/Destroy()
	kick_ai()
	..()
	return null
//----------------------------------------------------------------------
// End of file gutsy.dm //----------------------------------------------
//----------------------------------------------------------------------