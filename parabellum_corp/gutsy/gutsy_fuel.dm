/mob/living/bot/gutsy/attackby(var/obj/item/stack/material/phoron/O, var/mob/user)
	..()
	fuel += fuelCoeff * O.amount
	qdel(O)
	return null
//----------------------------------------------------------------------
// End of file gutsy_fuel.dm //-----------------------------------------
//----------------------------------------------------------------------