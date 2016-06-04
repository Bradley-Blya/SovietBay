/mob/living/bot/gutsy
	name = "Mr. Gutsy"
	icon='gutsy.dmi'
	desc = "Mister Gutsy is a combat variant of the popular Mister Handy."
	icon_state = "gutsy_inactive"
	on = 0
	maxHealth = 500
	health = 500
	var/fuel = 50.0 // Оставшееся топливо в баке
	var/fuelCoeff = 2 // Сколько топлива пойдет в бак из единицы форона
	var/maxFuel = 50.0 // Размер топливного бака
	var/fuelPortion = 0.001 // Расход топлива за один жизненный цикл
	var/gutsyChipMode = 0 // Версия прошивки робота
	var/list/path = list() // Путь до цели
	var/kamikaze = 0 // Режим камикадзе
	var/mob/target = null /* Цель - не всегда робот должен уничтожать
	ее, но всегда будет просчитывать путь до нее */
	var/mob/master = null
	var/gutsy_HR = 8 /* Радиус распространения импульса после
	взрыва - heavy_range */
	var/gutsy_LR = 16 /*Радиус распространения импульса после
	взрыва - light_range */
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