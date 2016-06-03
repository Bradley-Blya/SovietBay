/mob/living/bot/gutsy/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "", var/italics = 0, var/mob/speaker = null, var/sound/speech_sound, var/sound_vol)
	..()
	if(findtext(message, "gutsy") == 0)
		return null
	if(findtext(message, "test") == 0)
		say("God, if I had hands I would strangle the life out of you!")
		playsound(loc, 'gutsy_DNU.ogg', 100)
	else if(findtext(message, "test2") == 0)
		say("TEST2")
		playsound(loc, 'gutsy_DNU.ogg', 100)
	else
		world << "Found!"
		//targetname = copytext(message, 5)
	//if(speaker.real_name == targetname)
		//target = speaker
	return null
//----------------------------------------------------------------------
// End of file gutsy_IO.dm //-------------------------------------------
//----------------------------------------------------------------------