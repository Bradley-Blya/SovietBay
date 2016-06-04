/mob/living/bot/gutsy/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "", var/italics = 0, var/mob/speaker = null, var/sound/speech_sound, var/sound_vol)
	..()
	if(findtext(message, "gutsy") == 0)
		return null
	if(findtext(message, "me") != 0)
		target = speaker
	if(findtext(message, "reset") != 0)
		target = null
	if(findtext(message, "kamikaze") != 0)
		kamikaze = 1
	return null
//----------------------------------------------------------------------
// End of file gutsy_IO.dm //-------------------------------------------
//----------------------------------------------------------------------