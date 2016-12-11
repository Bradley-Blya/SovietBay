////////////////////////effectslist/////////////////////////////////////////////////////////////
//datum/logrus/ticker/proc/initialize_lists()

var/datum/logrus/ticker/list/schools_list(
"projectile",
"missile",
"throwing",
"enchanting",
"imposition",
"misc"
)
////////////////////////wordlists///////////////////////////////////////////////////////////////////////////

var/obj/logrus/spellcraft/list/trigger = list("alpha", "beta", "gamma", "delta")
var/obj/logrus/spellcraft/list/modifiers = list("epsilon", "zeta", "femta", "vatta", "iota", "kappa")
var/obj/logrus/spellcraft/list/main = list("lambda", "munax", "norok", "xino", "omega", "phi", "rho", "sigma")
var/obj/logrus/spellcraft/list/auxilary = list("tau", "upsilon", "chi",  "heim", "jierda", "yrka")
var/obj/logrus/spellcraft/list/level = list("wuth", "qoth")

var/obj/logrus/spellcraft/list/crafting = list("lambda", "munax", "norok", "xino", "omega", "phi", "rho", "sigma", "tau", "upsilon", "chi", "heim", "jierda", "yrka","wuth", "qoth")

var/obj/logrus/spellcraft/list/all = list(
"alpha", "beta", "gamma", "delta",
//1			2		3		4
"epsilon", "zeta", "femta", "vatta", "iota", "kappa",
//5			6		7			8		9		10
"lambda", "munax", "norok", "xino", "omega", "phi", "rho", "sigma",
//11		12		13		  14		15		16		17		18
"tau", "upsilon", "chi", "heim", "jierda", "yrka",
//19		20		21		22		23		24
"wuth", "qoth")
//25		26

var/obj/logrus/spellcraft/list/letters = list(
"a", "b", "g", "d", "f", "z", "e", "v", "i",
"k", "l", "m", "n", "x", "o", "p", "r", "s",
"t", "u", "c", "h", "j", "y", "w", "q"
)

//another redundant wordlist
/*
var/obj/logrus/list/crafting = list("delivery", "targeted", "basic", "auxilary")//1,2,3,4
var/obj/logrus/list/drainer = list("epsilon", "zeta", "eta")
var/obj/logrus/list/trigger = list("theta", "iota", "kappa")
var/obj/logrus/list/modifiers = list("lambda", "mu", "nu", "xi")
var/obj/logrus/list/main = list("omicron", "phi", "rho", "sigma", "tau", "upsilon", "chi",  "omega")
var/obj/logrus/list/all = list(
"alpha", "beta", "gamma", "delta",	//crafting
//1		   2		3		4
"epsilon", "zeta", "eta",			//drainer  || I don't need drainer???
//5			6		7
"theta", "iota", "kappa",			//trigger
//8			9		10
"lambda", "mu", "nu", "xi",			//modifiers
//11	  12	 13	   14
"omicron", "phi", "rho", "sigma", "tau", "upsilon", "chi",  "omega"	//main
//15		16		17		18	  19		20		  21		22
)
*/
								 //"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"
//TODO: Добавить сигналлеры и узлы//

/*old useless wordlist:
var/obj/logrus/list/starting_words = list("start", "begin", "initiate")
var/obj/logrus/list/effect_words = list("infliction")
var/obj/logrus/list/targeted_words = list("imposition")
var/obj/logrus/list/auxilary_words = list("trigger", "drainer", "container")


var/obj/logrus/list/subeffects_words = list(
//"hallucinations", "hulk", "laser",
"brute", "burn", "oxygen", "toxins", "stun", "paralyse", "weaken",
"range", "part", "living", "robot",
)									//imposition //16 parts, two to choose 4legs 4hands 2body head eyes brain heart lungs
//var/obj/logrus/list/auxilary_words = list(
//"magnitude", "step", "extension"
//)
var/obj/logrus/list/magnitude_mod = list("halveten" = 5, "singleten" = 10, "doubleten" = 20, "fivehalveten" = 25)


//TODO: Го пилить урезанный словарь!
*/
