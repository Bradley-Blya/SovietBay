/*
Asset cache quick users guide:

Make a datum at the bottom of this file with your assets for your thing.
The simple subsystem will most like be of use for most cases.
Then call get_asset_datum() with the type of the datum you created and store the return
Then call .send(client) on that stored return value.

You can set verify to TRUE if you want send() to sleep until the client has the assets.
*/


// Amount of time(ds) MAX to send per asset, if this get exceeded we cancel the sleeping.
// This is doubled for the first asset, then added per asset after
#define ASSET_CACHE_SEND_TIMEOUT 7

//When sending mutiple assets, how many before we give the client a quaint little sending resources message
#define ASSET_CACHE_TELL_CLIENT_AMOUNT 8

/client
	var/list/cache = list() // List of all assets sent to this client by the asset cache.
	var/list/completed_asset_jobs = list() // List of all completed jobs, awaiting acknowledgement.
	var/list/sending = list()
	var/last_asset_job = 0 // Last job done.

//This proc sends the asset to the client, but only if it needs it.
//This proc blocks(sleeps) unless verify is set to false
/proc/send_asset(var/client/client, var/asset_name, var/verify = TRUE)
	if(!istype(client))
		if(ismob(client))
			var/mob/M = client
			if(M.client)
				client = M.client

			else
				return 0

		else
			return 0

	if(client.cache.Find(asset_name) || client.sending.Find(asset_name))
		return 0

	client << browse_rsc(asset_cache.cache[asset_name], asset_name)
	if(!verify || !winexists(client, "asset_cache_browser")) // Can't access the asset cache browser, rip.
		if (client)
			client.cache += asset_name
		return 1
	if (!client)
		return 0

	client.sending |= asset_name
	var/job = ++client.last_asset_job

	client << browse({"
	<script>
		window.location.href="?asset_cache_confirm_arrival=[job]"
	</script>
	"}, "window=asset_cache_browser")

	var/t = 0
	var/timeout_time = (ASSET_CACHE_SEND_TIMEOUT * client.sending.len) + ASSET_CACHE_SEND_TIMEOUT
	while(client && !client.completed_asset_jobs.Find(job) && t < timeout_time) // Reception is handled in Topic()
		sleep(1) // Lock up the caller until this is received.
		t++

	if(client)
		client.sending -= asset_name
		client.cache |= asset_name
		client.completed_asset_jobs -= job

	return 1

//This proc blocks(sleeps) unless verify is set to false
/proc/send_asset_list(var/client/client, var/list/asset_list, var/verify = TRUE)
	if(!istype(client))
		if(ismob(client))
			var/mob/M = client
			if(M.client)
				client = M.client

			else
				return 0

		else
			return 0

	var/list/unreceived = asset_list - (client.cache + client.sending)
	if(!unreceived || !unreceived.len)
		return 0
	if (unreceived.len >= ASSET_CACHE_TELL_CLIENT_AMOUNT)
		client << "Sending Resources..."
	for(var/asset in unreceived)
		if (asset in asset_cache.cache)
			client << browse_rsc(asset_cache.cache[asset], asset)

	if(!verify || !winexists(client, "asset_cache_browser")) // Can't access the asset cache browser, rip.
		if (client)
			client.cache += unreceived
		return 1
	if (!client)
		return 0
	client.sending |= unreceived
	var/job = ++client.last_asset_job

	client << browse({"
	<script>
		window.location.href="?asset_cache_confirm_arrival=[job]"
	</script>
	"}, "window=asset_cache_browser")

	var/t = 0
	var/timeout_time = ASSET_CACHE_SEND_TIMEOUT * client.sending.len
	while(client && !client.completed_asset_jobs.Find(job) && t < timeout_time) // Reception is handled in Topic()
		sleep(1) // Lock up the caller until this is received.
		t++

	if(client)
		client.sending -= unreceived
		client.cache |= unreceived
		client.completed_asset_jobs -= job

	return 1

//This proc will download the files without clogging up the browse() queue, used for passively sending files on connection start.
//The proc calls procs that sleep for long times.
/proc/getFilesSlow(var/client/client, var/list/files, var/register_asset = TRUE)
	for(var/file in files)
		if (!client)
			break
		if (register_asset)
			register_asset(file,files[file])
		send_asset(client,file)
		sleep(0) //queuing calls like this too quickly can cause issues in some client versions

//This proc "registers" an asset, it adds it to the cache for further use, you cannot touch it from this point on or you'll fuck things up.
//if it's an icon or something be careful, you'll have to copy it before further use.
/proc/register_asset(var/asset_name, var/asset)
	asset_cache.cache[asset_name] = asset

//These datums are used to populate the asset cache, the proc "register()" does this.

//all of our asset datums, used for referring to these later
/var/global/list/asset_datums = list()

//get a assetdatum or make a new one
/proc/get_asset_datum(var/type)
	if (!(type in asset_datums))
		return new type()
	return asset_datums[type]

/datum/asset/New()
	asset_datums[type] = src

/datum/asset/proc/register()
	return

/datum/asset/proc/send(client)
	return

//If you don't need anything complicated.
/datum/asset/simple
	var/assets = list()
	var/verify = FALSE

/datum/asset/simple/register()
	for(var/asset_name in assets)
		register_asset(asset_name, assets[asset_name])
/datum/asset/simple/send(client)
	send_asset_list(client,assets,verify)


//DEFINITIONS FOR ASSET DATUMS START HERE.

/datum/asset/simple/pda
	assets = list(
		"pda_atmos.png"			= 'icons/pda_icons/pda_atmos.png',
		"pda_back.png"			= 'icons/pda_icons/pda_back.png',
		"pda_bell.png"			= 'icons/pda_icons/pda_bell.png',
		"pda_blank.png"			= 'icons/pda_icons/pda_blank.png',
		"pda_boom.png"			= 'icons/pda_icons/pda_boom.png',
		"pda_bucket.png"		= 'icons/pda_icons/pda_bucket.png',
		"pda_chatroom.png"      = 'icons/pda_icons/pda_chatroom.png',
		"pda_crate.png"         = 'icons/pda_icons/pda_crate.png',
		"pda_cuffs.png"         = 'icons/pda_icons/pda_cuffs.png',
		"pda_eject.png"			= 'icons/pda_icons/pda_eject.png',
		"pda_exit.png"			= 'icons/pda_icons/pda_exit.png',
		"pda_honk.png"			= 'icons/pda_icons/pda_honk.png',
		"pda_locked.png"        = 'icons/pda_icons/pda_locked.png',
		"pda_mail.png"			= 'icons/pda_icons/pda_mail.png',
		"pda_medical.png"		= 'icons/pda_icons/pda_medical.png',
		"pda_menu.png"			= 'icons/pda_icons/pda_menu.png',
		"pda_mule.png"			= 'icons/pda_icons/pda_mule.png',
		"pda_notes.png"			= 'icons/pda_icons/pda_notes.png',
		"pda_power.png"			= 'icons/pda_icons/pda_power.png',
		"pda_rdoor.png"			= 'icons/pda_icons/pda_rdoor.png',
		"pda_reagent.png"		= 'icons/pda_icons/pda_reagent.png',
		"pda_refresh.png"		= 'icons/pda_icons/pda_refresh.png',
		"pda_scanner.png"		= 'icons/pda_icons/pda_scanner.png',
		"pda_signaler.png"		= 'icons/pda_icons/pda_signaler.png',
		"pda_status.png"		= 'icons/pda_icons/pda_status.png'
	)

/datum/asset/simple/tgui
	assets = list(
		"tgui.css"	= 'tgui/assets/tgui.css',
		"tgui.js"	= 'tgui/assets/tgui.js'
	)

/datum/asset/nanoui
	var/list/common = list()

	var/list/common_dirs = list(
		"nano/css/",
		"nano/images/",
		"nano/images/status_icons/",
		"nano/js/"
	)
	var/list/uncommon_dirs = list(
		"nano/templates/"
	)

/datum/asset/nanoui/register()
	if(config.nanoui_legacy)
		common = legacy_common
		asset_cache.cache = legacy_uncommon
		return
	// Crawl the directories to find files.
	for (var/path in common_dirs)
		var/list/filenames = flist(path)
		for(var/filename in filenames)
			if(copytext(filename, length(filename)) != "/") // Ignore directories.
				if(fexists(path + filename))
					common[filename] = fcopy_rsc(path + filename)
					register_asset(filename, common[filename])
	for (var/path in uncommon_dirs)
		var/list/filenames = flist(path)
		for(var/filename in filenames)
			if(copytext(filename, length(filename)) != "/") // Ignore directories.
				if(fexists(path + filename))
					register_asset(filename, fcopy_rsc(path + filename))

/datum/asset/nanoui/send(client, uncommon)
	if(!islist(uncommon))
		uncommon = list(uncommon)

	send_asset_list(client, uncommon, FALSE)
	send_asset_list(client, common, TRUE)

/*
	Asset cache
*/
var/decl/asset_cache/asset_cache = new()

/decl/asset_cache
	var/list/cache

/decl/asset_cache/New()
	..()
	cache = new

/hook/roundstart/proc/send_assets()
	for(var/type in typesof(/datum/asset) - list(/datum/asset, /datum/asset/simple))
		var/datum/asset/A = new type()
		A.register()

	for(var/client/C in clients)
		// Doing this to a client too soon after they've connected can cause issues, also the proc we call sleeps.
		spawn(10)
			getFilesSlow(C, asset_cache.cache, FALSE)

	return TRUE

var/global/list/legacy_common = list(
"icons.css" = 'nano/css/icons.css',
"layout_basic.css" = 'nano/css/layout_basic.css',
"layout_default.css" = 'nano/css/layout_default.css',
"shared.css" = 'nano/css/shared.css',
"c_charging.gif" = 'nano/images/c_charging.gif',
"c_discharging.gif" = 'nano/images/c_discharging.gif',
"c_max.gif" = 'nano/images/c_max.gif',
"nanomapBackground.png" = 'nano/images/nanomapBackground.png',
"nanomap_z1.png" = 'nano/images/nanomap_z1.png',
"uiBackground-Syndicate.png" = 'nano/images/uiBackground-Syndicate.png',
"uiBackground.png" = 'nano/images/uiBackground.png',
"uiBasicBackground.png" = 'nano/images/uiBasicBackground.png',
"uiIcons16.png" = 'nano/images/uiIcons16.png',
"uiIcons16Green.png" = 'nano/images/uiIcons16Green.png',
"uiIcons16Red.png" = 'nano/images/uiIcons16Red.png',
"uiIcons24.png" = 'nano/images/uiIcons24.png',
"uiLinkPendingIcon.gif" = 'nano/images/uiLinkPendingIcon.gif',
"uiMaskBackground.png" = 'nano/images/uiMaskBackground.png',
"uiNoticeBackground.jpg" = 'nano/images/uiNoticeBackground.jpg',
"uiTitleFluff-Syndicate.png" = 'nano/images/uiTitleFluff-Syndicate.png',
"uiTitleFluff.png" = 'nano/images/uiTitleFluff.png',
"alarm_green.gif" = 'nano/images/status_icons/alarm_green.gif',
"alarm_red.gif" = 'nano/images/status_icons/alarm_red.gif',
"batt_100.gif" = 'nano/images/status_icons/batt_100.gif',
"batt_20.gif" = 'nano/images/status_icons/batt_20.gif',
"batt_40.gif" = 'nano/images/status_icons/batt_40.gif',
"batt_5.gif" = 'nano/images/status_icons/batt_5.gif',
"batt_60.gif" = 'nano/images/status_icons/batt_60.gif',
"batt_80.gif" = 'nano/images/status_icons/batt_80.gif',
"charging.gif" = 'nano/images/status_icons/charging.gif',
"downloader_finished.gif" = 'nano/images/status_icons/downloader_finished.gif',
"downloader_running.gif" = 'nano/images/status_icons/downloader_running.gif',
"ntnrc_idle.gif" = 'nano/images/status_icons/ntnrc_idle.gif',
"ntnrc_new.gif" = 'nano/images/status_icons/ntnrc_new.gif',
"power_norm.gif" = 'nano/images/status_icons/power_norm.gif',
"power_warn.gif" = 'nano/images/status_icons/power_warn.gif',
"sig_high.gif" = 'nano/images/status_icons/sig_high.gif',
"sig_lan.gif" = 'nano/images/status_icons/sig_lan.gif',
"sig_low.gif" = 'nano/images/status_icons/sig_low.gif',
"sig_none.gif" = 'nano/images/status_icons/sig_none.gif',
"libraries.min.js" = 'nano/js/libraries.min.js',
"nano_base_callbacks.js" = 'nano/js/nano_base_callbacks.js',
"nano_base_helpers.js" = 'nano/js/nano_base_helpers.js',
"nano_state.js" = 'nano/js/nano_state.js',
"nano_state_default.js" = 'nano/js/nano_state_default.js',
"nano_state_manager.js" = 'nano/js/nano_state_manager.js',
"nano_template.js" = 'nano/js/nano_template.js',
"nano_utility.js" = 'nano/js/nano_utility.js'
)
var/global/list/legacy_uncommon = list(
"icons.css" = 'nano/css/icons.css',
"layout_basic.css" = 'nano/css/layout_basic.css',
"layout_default.css" = 'nano/css/layout_default.css',
"shared.css" = 'nano/css/shared.css',
"c_charging.gif" = 'nano/images/c_charging.gif',
"c_discharging.gif" = 'nano/images/c_discharging.gif',
"c_max.gif" = 'nano/images/c_max.gif',
"nanomapBackground.png" = 'nano/images/nanomapBackground.png',
"nanomap_z1.png" = 'nano/images/nanomap_z1.png',
"uiBackground-Syndicate.png" = 'nano/images/uiBackground-Syndicate.png',
"uiBackground.png" = 'nano/images/uiBackground.png',
"uiBasicBackground.png" = 'nano/images/uiBasicBackground.png',
"uiIcons16.png" = 'nano/images/uiIcons16.png',
"uiIcons16Green.png" = 'nano/images/uiIcons16Green.png',
"uiIcons16Red.png" = 'nano/images/uiIcons16Red.png',
"uiIcons24.png" = 'nano/images/uiIcons24.png',
"uiLinkPendingIcon.gif" = 'nano/images/uiLinkPendingIcon.gif',
"uiMaskBackground.png" = 'nano/images/uiMaskBackground.png',
"uiNoticeBackground.jpg" = 'nano/images/uiNoticeBackground.jpg',
"uiTitleFluff-Syndicate.png" = 'nano/images/uiTitleFluff-Syndicate.png',
"uiTitleFluff.png" = 'nano/images/uiTitleFluff.png',
"alarm_green.gif" = 'nano/images/status_icons/alarm_green.gif',
"alarm_red.gif" = 'nano/images/status_icons/alarm_red.gif',
"batt_100.gif" = 'nano/images/status_icons/batt_100.gif',
"batt_20.gif" = 'nano/images/status_icons/batt_20.gif',
"batt_40.gif" = 'nano/images/status_icons/batt_40.gif',
"batt_5.gif" = 'nano/images/status_icons/batt_5.gif',
"batt_60.gif" = 'nano/images/status_icons/batt_60.gif',
"batt_80.gif" = 'nano/images/status_icons/batt_80.gif',
"charging.gif" = 'nano/images/status_icons/charging.gif',
"downloader_finished.gif" = 'nano/images/status_icons/downloader_finished.gif',
"downloader_running.gif" = 'nano/images/status_icons/downloader_running.gif',
"ntnrc_idle.gif" = 'nano/images/status_icons/ntnrc_idle.gif',
"ntnrc_new.gif" = 'nano/images/status_icons/ntnrc_new.gif',
"power_norm.gif" = 'nano/images/status_icons/power_norm.gif',
"power_warn.gif" = 'nano/images/status_icons/power_warn.gif',
"sig_high.gif" = 'nano/images/status_icons/sig_high.gif',
"sig_lan.gif" = 'nano/images/status_icons/sig_lan.gif',
"sig_low.gif" = 'nano/images/status_icons/sig_low.gif',
"sig_none.gif" = 'nano/images/status_icons/sig_none.gif',
"libraries.min.js" = 'nano/js/libraries.min.js',
"nano_base_callbacks.js" = 'nano/js/nano_base_callbacks.js',
"nano_base_helpers.js" = 'nano/js/nano_base_helpers.js',
"nano_state.js" = 'nano/js/nano_state.js',
"nano_state_default.js" = 'nano/js/nano_state_default.js',
"nano_state_manager.js" = 'nano/js/nano_state_manager.js',
"nano_template.js" = 'nano/js/nano_template.js',
"nano_utility.js" = 'nano/js/nano_utility.js',
"accounts_terminal.tmpl" = 'nano/templates/accounts_terminal.tmpl',
"advanced_airlock_console.tmpl" = 'nano/templates/advanced_airlock_console.tmpl',
"agent_id_card.tmpl" = 'nano/templates/agent_id_card.tmpl',
"aicard.tmpl" = 'nano/templates/aicard.tmpl',
"air_alarm.tmpl" = 'nano/templates/air_alarm.tmpl',
"alarm_monitor.tmpl" = 'nano/templates/alarm_monitor.tmpl',
"apc.tmpl" = 'nano/templates/apc.tmpl',
"appearance_changer.tmpl" = 'nano/templates/appearance_changer.tmpl',
"atmos_alert.tmpl" = 'nano/templates/atmos_alert.tmpl',
"atmos_control.tmpl" = 'nano/templates/atmos_control.tmpl',
"botany_editor.tmpl" = 'nano/templates/botany_editor.tmpl',
"botany_isolator.tmpl" = 'nano/templates/botany_isolator.tmpl',
"canister.tmpl" = 'nano/templates/canister.tmpl',
"chem_disp.tmpl" = 'nano/templates/chem_disp.tmpl',
"communication.tmpl" = 'nano/templates/communication.tmpl',
"computer_fabricator.tmpl" = 'nano/templates/computer_fabricator.tmpl',
"crew_monitor.tmpl" = 'nano/templates/crew_monitor.tmpl',
"crew_monitor_map_content.tmpl" = 'nano/templates/crew_monitor_map_content.tmpl',
"crew_monitor_map_header.tmpl" = 'nano/templates/crew_monitor_map_header.tmpl',
"cryo.tmpl" = 'nano/templates/cryo.tmpl',
"disease_splicer.tmpl" = 'nano/templates/disease_splicer.tmpl',
"dish_incubator.tmpl" = 'nano/templates/dish_incubator.tmpl',
"dnaforensics.tmpl" = 'nano/templates/dnaforensics.tmpl',
"dna_modifier.tmpl" = 'nano/templates/dna_modifier.tmpl',
"docking_airlock_console.tmpl" = 'nano/templates/docking_airlock_console.tmpl',
"door_access_console.tmpl" = 'nano/templates/door_access_console.tmpl',
"door_control.tmpl" = 'nano/templates/door_control.tmpl',
"engines_control.tmpl" = 'nano/templates/engines_control.tmpl',
"escape_pod_berth_console.tmpl" = 'nano/templates/escape_pod_berth_console.tmpl',
"escape_pod_console.tmpl" = 'nano/templates/escape_pod_console.tmpl',
"escape_shuttle_control_console.tmpl" = 'nano/templates/escape_shuttle_control_console.tmpl',
"file_manager.tmpl" = 'nano/templates/file_manager.tmpl',
"freezer.tmpl" = 'nano/templates/freezer.tmpl',
"gas_pump.tmpl" = 'nano/templates/gas_pump.tmpl',
"generator.tmpl" = 'nano/templates/generator.tmpl',
"geoscanner.tmpl" = 'nano/templates/geoscanner.tmpl',
"hardsuit.tmpl" = 'nano/templates/hardsuit.tmpl',
"helm.tmpl" = 'nano/templates/helm.tmpl',
"identification_computer.tmpl" = 'nano/templates/identification_computer.tmpl',
"isolation_centrifuge.tmpl" = 'nano/templates/isolation_centrifuge.tmpl',
"janitorcart.tmpl" = 'nano/templates/janitorcart.tmpl',
"jukebox.tmpl" = 'nano/templates/jukebox.tmpl',
"laptop_configuration.tmpl" = 'nano/templates/laptop_configuration.tmpl',
"laptop_mainscreen.tmpl" = 'nano/templates/laptop_mainscreen.tmpl',
"law_manager.tmpl" = 'nano/templates/law_manager.tmpl',
"layout_basic.tmpl" = 'nano/templates/layout_basic.tmpl',
"layout_default.tmpl" = 'nano/templates/layout_default.tmpl',
"mechfab.tmpl" = 'nano/templates/mechfab.tmpl',
"multi_docking_console.tmpl" = 'nano/templates/multi_docking_console.tmpl',
"news_browser.tmpl" = 'nano/templates/news_browser.tmpl',
"ntnet_chat.tmpl" = 'nano/templates/ntnet_chat.tmpl',
"ntnet_dos.tmpl" = 'nano/templates/ntnet_dos.tmpl',
"ntnet_downloader.tmpl" = 'nano/templates/ntnet_downloader.tmpl',
"ntnet_monitor.tmpl" = 'nano/templates/ntnet_monitor.tmpl',
"ntnet_relay.tmpl" = 'nano/templates/ntnet_relay.tmpl',
"ntnet_transfer.tmpl" = 'nano/templates/ntnet_transfer.tmpl',
"nuclear_bomb.tmpl" = 'nano/templates/nuclear_bomb.tmpl',
"omni_filter.tmpl" = 'nano/templates/omni_filter.tmpl',
"omni_mixer.tmpl" = 'nano/templates/omni_mixer.tmpl',
"pacman.tmpl" = 'nano/templates/pacman.tmpl',
"pai_atmosphere.tmpl" = 'nano/templates/pai_atmosphere.tmpl',
"pai_directives.tmpl" = 'nano/templates/pai_directives.tmpl',
"pai_doorjack.tmpl" = 'nano/templates/pai_doorjack.tmpl',
"pai_interface.tmpl" = 'nano/templates/pai_interface.tmpl',
"pai_manifest.tmpl" = 'nano/templates/pai_manifest.tmpl',
"pai_medrecords.tmpl" = 'nano/templates/pai_medrecords.tmpl',
"pai_messenger.tmpl" = 'nano/templates/pai_messenger.tmpl',
"pai_radio.tmpl" = 'nano/templates/pai_radio.tmpl',
"pai_secrecords.tmpl" = 'nano/templates/pai_secrecords.tmpl',
"pai_signaller.tmpl" = 'nano/templates/pai_signaller.tmpl',
"pathogenic_isolator.tmpl" = 'nano/templates/pathogenic_isolator.tmpl',
"pda.tmpl" = 'nano/templates/pda.tmpl',
"portpump.tmpl" = 'nano/templates/portpump.tmpl',
"portscrubber.tmpl" = 'nano/templates/portscrubber.tmpl',
"power_monitor.tmpl" = 'nano/templates/power_monitor.tmpl',
"pressure_regulator.tmpl" = 'nano/templates/pressure_regulator.tmpl',
"radio_basic.tmpl" = 'nano/templates/radio_basic.tmpl',
"rcon.tmpl" = 'nano/templates/rcon.tmpl',
"request_console.tmpl" = 'nano/templates/request_console.tmpl',
"revelation.tmpl" = 'nano/templates/revelation.tmpl',
"robot_control.tmpl" = 'nano/templates/robot_control.tmpl',
"sec_camera.tmpl" = 'nano/templates/sec_camera.tmpl',
"sec_camera_map_content.tmpl" = 'nano/templates/sec_camera_map_content.tmpl',
"sec_camera_map_header.tmpl" = 'nano/templates/sec_camera_map_header.tmpl',
"shuttle_control_console.tmpl" = 'nano/templates/shuttle_control_console.tmpl',
"shuttle_control_console_exploration.tmpl" = 'nano/templates/shuttle_control_console_exploration.tmpl',
"simple_airlock_console.tmpl" = 'nano/templates/simple_airlock_console.tmpl',
"simple_docking_console.tmpl" = 'nano/templates/simple_docking_console.tmpl',
"simple_docking_console_pod.tmpl" = 'nano/templates/simple_docking_console_pod.tmpl',
"sleeper.tmpl" = 'nano/templates/sleeper.tmpl',
"smartfridge.tmpl" = 'nano/templates/smartfridge.tmpl',
"smes.tmpl" = 'nano/templates/smes.tmpl',
"supermatter_crystal.tmpl" = 'nano/templates/supermatter_crystal.tmpl',
"tanks.tmpl" = 'nano/templates/tanks.tmpl',
"telescience_console.tmpl" = 'nano/templates/telescience_console.tmpl',
"TemplatesGuide.txt" = 'nano/templates/TemplatesGuide.txt',
"transfer_valve.tmpl" = 'nano/templates/transfer_valve.tmpl',
"turret_control.tmpl" = 'nano/templates/turret_control.tmpl',
"uplink.tmpl" = 'nano/templates/uplink.tmpl',
"vending_machine.tmpl" = 'nano/templates/vending_machine.tmpl'
)