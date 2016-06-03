/mob/living/bot/gutsy/attackby(var/obj/item/stack/material/phoron/O, var/mob/user)
	//..()
	fuel += fuel_coeff * O.amount
	qdel(O)
	icon_state = "gutsy_i2a"
	return
//----------------------------------------------------------------------
// End of file gutsy_fuel.dm //-----------------------------------------
//----------------------------------------------------------------------