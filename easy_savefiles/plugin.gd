@tool
extends EditorPlugin

static func create_setting(
	name:String,
	default_value:Variant,
	hint:PropertyHint	= PROPERTY_HINT_NONE,
	hint_string:String	= "",
	#basic:bool			= true, # removed for 4.0 compativility
	#internal:bool		= false, # removed for 4.0 compativility
	restart:bool		= false,
	position:int		= 0,
)->void:
	if(!ProjectSettings.has_setting(name)):
		ProjectSettings.set_setting(name,default_value)
	#ProjectSettings.set_initial_value(name,default_value)
#	ProjectSettings.set_as_basic(name,basic) # removed for 4.0 compativility
#	ProjectSettings.set_as_internal(name,internal) # removed for 4.0 compativility
	ProjectSettings.set_order(name,position)
	ProjectSettings.set_restart_if_changed(name,restart)
	ProjectSettings.add_property_info({
		"name": name,
		"type": typeof(default_value),
		"hint": hint,
		"hint_string": hint_string,
	})
static func delete_setting(name:String)->void:
	ProjectSettings.set_setting(name, null)

const SETTINGS_DEFAULT:String	= "addons/easy_savefiles/settings/file/default"
const SETTINGS_MODIFIED:String	= "addons/easy_savefiles/settings/file/modified"
const SETTINGS_INCLUDE:String	= "addons/easy_savefiles/settings/include"
const SETTINGS_EXCLUDE:String	= "addons/easy_savefiles/settings/exclude"

const GAMEFILE_DEFAULT:String	= "addons/easy_savefiles/game_data/file/default"
const GAMEFILE_MODIFIED:String	= "addons/easy_savefiles/game_data/file/modified"
const GAMEFILE_INCLUDE:String	= "addons/easy_savefiles/game_data/include"
const GAMEFILE_EXCLUDE:String	= "addons/easy_savefiles/game_data/exclude"

const SECRETS:String = "addons/easy_savefiles/secrets/file"
const MANAGER:String = "EasySavefilesSingleton"

func _enter_tree():
	create_setting(SETTINGS_DEFAULT, String("res://default-settings.cfg") )
	create_setting(SETTINGS_MODIFIED,String("user://config.cfg") )
	create_setting(SETTINGS_INCLUDE, PackedStringArray([
		"custom/",
		"input/",
		"addons/",
		"input/ui_accept",
		"input/ui_cancel",
		"input/ui_up",
		"input/ui_down",
		"input/ui_left",
		"input/ui_right",
		"input/ui_home",
		"input/ui_menu",
	]) )
	create_setting(SETTINGS_EXCLUDE, PackedStringArray(["input/ui_", SECRETS]) )
	
	create_setting(GAMEFILE_DEFAULT, String("res://default-game.cfg") )
	create_setting(GAMEFILE_MODIFIED,String("user://savefile.cfg") )
	create_setting(GAMEFILE_INCLUDE, PackedStringArray(["game_data/"]) )
	create_setting(GAMEFILE_EXCLUDE, PackedStringArray([]) )
	
	create_setting(SECRETS, String("res://secrets.txt"))
	add_autoload_singleton(MANAGER, "res://addons/easy_savefiles/easy_savefiles.gd")
	ProjectSettings.save()
func _exit_tree():
	delete_setting(SETTINGS_DEFAULT)
	delete_setting(SETTINGS_MODIFIED)
	delete_setting(SETTINGS_INCLUDE)
	delete_setting(SETTINGS_EXCLUDE)
	
	delete_setting(GAMEFILE_DEFAULT)
	delete_setting(GAMEFILE_MODIFIED)
	delete_setting(GAMEFILE_INCLUDE)
	delete_setting(GAMEFILE_EXCLUDE)
	
	delete_setting(SECRETS)
	remove_autoload_singleton(MANAGER)
	ProjectSettings.save()
