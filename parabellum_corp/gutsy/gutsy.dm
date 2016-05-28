/mob/living/bot/gutsy
	name = "Mr. Gutsy"
	icon='parabellum_corp/gutsy/gutsy.dmi'
	desc = "Робот Gutsy. Всегда поможет в любом деле!"
	icon_state = "gutsy_active"
	maxHealth = 500
	health = 500
	var/fuel = 50.0
	var/fuel_coeff = 2
	var/maxFuel = 50.0
	var/fuel_portion = 0.001
//----------------------------------------------------------------------
/mob/living/bot/gutsy/New()
	..()
//----------------------------------------------------------------------
// End of file gutsy.dm //----------------------------------------------
//----------------------------------------------------------------------