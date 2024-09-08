extends Node
class_name EasySavefiles

static func get_project_settings(
	include:PackedStringArray,
	exclude:PackedStringArray = [],
	settings:Array[Dictionary] = ProjectSettings.get_property_list()
)->PackedStringArray:
	var paths:PackedStringArray = []
	for path in include:
		var exclude_valid:PackedStringArray = []
		for p in exclude:
			if( p.begins_with(path) && p.length()>path.length() ):
				exclude_valid.append(p)
		var is_exclude = func(test)->bool:
			for p in exclude_valid:
				if(test.begins_with(p)): return true
			return false
		
		for property in settings:
			assert(property.has("name"), "property dict has no <name> key : %s"%JSON.stringify(property, '\t'))
			assert(property.has("type"), "property dict has no <type> key : %s"%JSON.stringify(property, '\t'))
			assert(property["name"] is String, "property dict's <name> is not of type <String> : %s"%JSON.stringify(property, '\t'))
			assert(property["type"] is int, "property dict's <type> is not of type <int> : %s"%JSON.stringify(property, '\t'))
			assert(property["type"] >= 0, "property dict's <type> of invalid type <%s> : %s"%[property["type"], JSON.stringify(property, '\t')])
			assert(property["type"] < TYPE_MAX, "property dict's <type> of invalid type <%s> : %s"%[property["type"], JSON.stringify(property, '\t')])
			
			var property_name:String = property["name"]
			if(
				property_name.begins_with(path) && 
				!is_exclude.call(property_name) &&
				property["type"] != 0
			):
				paths.append(property_name)
	return paths
static func save_project_settings(
	directory:String,
	paths_include:PackedStringArray,
	paths_exclude:PackedStringArray = [],
	password:String = ''
)->int:
	var file:ConfigFile = ConfigFile.new()
	for path in get_project_settings(paths_include, paths_exclude):
		var section:String = path.get_slice('/', 0)
		var key:String = path.trim_prefix("%s/"%section)
		var value = ProjectSettings.get(path) if !section.matchn("input") else InputMap.action_get_events(key)
		file.set_value(section,key,value)
		print("saved <%s> as %10s"%[path, ProjectSettings.get(path)])
	return (file.save(directory) if password.is_empty() else
			file.save_encrypted_pass(directory, password) )
static func load_project_settings(
	directory:String,
	paths_include:PackedStringArray = [""],
	paths_exclude:PackedStringArray = [],
	password:String = ''
)->int:
	var file:ConfigFile = ConfigFile.new()
	var error:int =(file.load(directory) if password.is_empty() else
					file.load_encrypted_pass(directory, password) )
	if(error == OK):
		for section in file.get_sections():
			for key in file.get_section_keys(section):
				var path:String = "%s/%s"%[section, key]
				ProjectSettings.set_setting(path, file.get_value(section, key))
				if( section == "input"):
					var a = ProjectSettings.get_setting(path)
					InputMap.action_set_deadzone(key, ProjectSettings.get_setting(path)["deadzone"])
					InputMap.action_erase_events(key)
					for event in file.get_value(section, key):
						InputMap.action_add_event(key, event)
	else:
		print_debug("<%s> failed to load <error : %s>"%[directory, error])
	return error

# <_reset_project_settings()> is unusable for added settings
# in the current state of Godot, since custom settings set to
# their "initial_value" are not saved in the project.godot and
# not loaded into the project once ran.
# The work around is to create a "default" files for all settings
# that are to be customized from inside the project.

# This reverts project settings to their default settings
# <input/> settings are resetted too and loaded into
# the cleared InputMap
#static func _reset_project_settings(
	#paths_include:PackedStringArray,
	#paths_exclude:PackedStringArray
#)->void:
	#const INPUT:String = "input/"
	#var input_includes:PackedStringArray = []
	#for path:String in get_project_settings(paths_include, paths_exclude):
		#ProjectSettings.set_setting(path, ProjectSettings.property_get_revert(path))
		#if(path.begins_with(INPUT)): input_includes.append(path)
	#
	## Loads the default ProjectSettings into the InputMap singleton.
	#for path:String in get_project_settings(input_includes, paths_exclude):
		#var action:String = path.trim_prefix(INPUT)
		#InputMap.action_erase_events(action)
		#InputMap.action_set_deadzone(action, ProjectSettings.get_setting(path)["deadzone"])
		#for event:InputEvent in ProjectSettings.get_setting(path)["events"]:
			#InputMap.action_add_event(action, event)

const _SETTINGS_DEFAULT:String	= "addons/easy_savefiles/settings/file/default"
const _SETTINGS_MODIFIED:String	= "addons/easy_savefiles/settings/file/modified"
const _SETTINGS_INCLUDE:String	= "addons/easy_savefiles/settings/include"
const _SETTINGS_EXCLUDE:String	= "addons/easy_savefiles/settings/exclude"
static var _SETTINGS_PASSWORD:String = ""
static func save_settings(directory:String = ProjectSettings.get_setting(_SETTINGS_MODIFIED))->void:
	save_project_settings(
		directory,
		ProjectSettings.get_setting(_SETTINGS_INCLUDE),
		ProjectSettings.get_setting(_SETTINGS_EXCLUDE),
		_SETTINGS_PASSWORD,
	)
static func load_settings(directory:String = ProjectSettings.get_setting(_SETTINGS_MODIFIED))->void:
	load_project_settings(
		directory,
		ProjectSettings.get_setting(_SETTINGS_INCLUDE),
		ProjectSettings.get_setting(_SETTINGS_EXCLUDE),
		_SETTINGS_PASSWORD,
	)
static func reset_settings(
	include:PackedStringArray = ProjectSettings.get_setting(_SETTINGS_INCLUDE),
	exclude:PackedStringArray = ProjectSettings.get_setting(_SETTINGS_EXCLUDE),
)->void:
	load_project_settings(
		ProjectSettings.get_setting(_SETTINGS_DEFAULT),
		include,
		exclude,
		_SETTINGS_PASSWORD,
	)

const _GAMEFILE_DEFAULT:String	= "addons/easy_savefiles/game_data/file/default"
const _GAMEFILE_MODIFIED:String	= "addons/easy_savefiles/game_data/file/modified"
const _GAMEFILE_INCLUDE:String	= "addons/easy_savefiles/game_data/include"
const _GAMEFILE_EXCLUDE:String	= "addons/easy_savefiles/game_data/exclude"
static var _GAMEFILE_PASSWORD:String = ""
static func save_game(directory:String = ProjectSettings.get_setting(_GAMEFILE_MODIFIED))->void:
	save_project_settings(
		directory,
		ProjectSettings.get_setting(_GAMEFILE_INCLUDE),
		ProjectSettings.get_setting(_GAMEFILE_EXCLUDE),
		_GAMEFILE_PASSWORD,
	)
static func load_game(directory:String = ProjectSettings.get_setting(_GAMEFILE_MODIFIED))->void:
	load_project_settings(
		directory,
		ProjectSettings.get_setting(_GAMEFILE_INCLUDE),
		ProjectSettings.get_setting(_GAMEFILE_EXCLUDE),
		_GAMEFILE_PASSWORD,
	)
static func reset_game(
	include:PackedStringArray = ProjectSettings.get_setting(_GAMEFILE_INCLUDE),
	exclude:PackedStringArray = ProjectSettings.get_setting(_GAMEFILE_EXCLUDE),
)->void:
	load_project_settings(
		ProjectSettings.get_setting(_GAMEFILE_DEFAULT),
		include,
		exclude,
		_GAMEFILE_PASSWORD,
	)

const _SECRETS:String = "addons/easy_savefiles/secrets/file"
func _ready()->void:
	var secrets_file:String = ProjectSettings.get_setting(_SECRETS)
	if(FileAccess.file_exists(secrets_file)):
		const SETTINGS_PASSWORD_NAME:String = "addons_easy_savefiles_settings_password"
		const GAMEFILE_PASSWORD_NAME:String = "addons_easy_savefiles_gamefile_password"
		var secrets_file_string:String = FileAccess.get_file_as_string(secrets_file)
		var get_secret:Callable = func(variable:String, secrets:String = secrets_file_string)->String:
			var start:int = secrets.rfind(variable)
			var end:int = secrets.rfind('\n', start)
			assert( !secrets.substr(start, end).replace("%s"%variable, '').lstrip(' ').is_empty(),
					"<%s> has no definition, either add one or remove the variable from your secrets file!")
			return secrets.substr(start, end).replace("%s"%variable, '').lstrip(' ')
		if( secrets_file_string.contains( SETTINGS_PASSWORD_NAME ) ):
			_SETTINGS_PASSWORD = get_secret.call( SETTINGS_PASSWORD_NAME )
		if( secrets_file_string.contains( GAMEFILE_PASSWORD_NAME ) ):
			_GAMEFILE_PASSWORD = get_secret.call( GAMEFILE_PASSWORD_NAME )
	save_settings( ProjectSettings.get_setting(_SETTINGS_DEFAULT) )
	save_game( ProjectSettings.get_setting(_GAMEFILE_DEFAULT) )
	load_settings()
	load_game()
