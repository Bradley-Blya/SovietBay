/mob/living/bot/gutsy/attackby(var/obj/item/O, var/mob/user)
	..()
	return null
//----------------------------------------------------------------------
/mob/living/bot/gutsy/attack_ai(var/mob/user)
	return attack_hand(user)
//----------------------------------------------------------------------
// End of file gutsy_attack.dm //---------------------------------------
//----------------------------------------------------------------------