/mob/living/bot/gutsy/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "", var/italics = 0, var/mob/speaker = null, var/sound/speech_sound, var/sound_vol)
	..()
	if(!findtext(message, "gutsy"))
		return null
	if(master != speaker)
		return null
	if(findtext(message, "me"))
		target = speaker
	if(findtext(message, "kamikaze"))
		kamikaze = 1
	if(findtext(message, "reset"))
		path = list()
		kamikaze = 0
		target = null
	return null
//----------------------------------------------------------------------
/mob/living/bot/gutsy/say(var/message)
	var/verb = "whistle"
	message = sanitize(message)
	..(message, null, verb)
	return null
//----------------------------------------------------------------------
// End of file gutsy_IO.dm //-------------------------------------------
//----------------------------------------------------------------------