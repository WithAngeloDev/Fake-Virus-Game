# Easy Savefiles

An easy way to save and load project settings. The plugin provides a simple singleton interface to manage project settings, import or export them to a .cfg file.

The way it works is that, it adds the class EasySavefiles on save_settings() or save_game() it parses all of the ProjectSettings settings (even the user-added ones) and filters through them with the "addons/easy_settings/[game_data/settings]/include" setting and excludes whatever matches with "addons/easy_settings/[game_data/settings]/exclude" (as long as the include filter is shorter than the exclude filter), this gets saved to a file ("addons/easy_settings/[game_data/settings]/file/modified") which can then be loaded with load_game() or load_settings().

Every time the engine is started, the singleton EasySavefileSingleton saves included settings to the "addons/easy_settings/[game_data/settings]/file/default" file, as doing a set_initial_value() is not feasable with user-made values (since values wont be saved in the project.godot file if this value is the same as its initial value). This is essentially a workaround to give an easy interface for resetting settings to their default values, or the value when the game first loads.

Some variables should not be tampered with, and will cause the editor to crash, just edit what you know will work... or just make a different project and fuck around, but you know, be careful with your computer ☻.

## TLDR:
- Adds the EasySavefiles class to save/load/reset a set of project settings (through static methods) (with a pretty nice interface).

## EasySavefiles's variables
### settings
- **const _SETTINGS_MODIFIED:String = "addons/easy_savefiles/settings/file/modified"**
  - Directory where the settings will be saved and loaded by default.
- **const _SETTINGS_DEFAULT:String = "addons/easy_savefiles/settings/file/default"**
  - Directory where the default settings will be saved and loaded by default.
- **const _SETTINGS_INCLUDE:String = "addons/easy_savefiles/settings/include"**
- **const _SETTINGS_EXCLUDE:String = "addons/easy_savefiles/settings/exclude"**
  - Default settings used by save_settings, load_settings and reset_settings.
### game
- **const _GAMEFILE_MODIFIED:String = "addons/easy_savefiles/game_data/file/modified"**
  - Directory where the settings will be saved and loaded by default.
- **const _GAMEFILE_INCLUDE:String = "addons/easy_savefiles/game_data/include"**
  - Directory where the default settings will be saved and loaded by default.
- **const _GAMEFILE_EXCLUDE:String = "addons/easy_savefiles/game_data/exclude"**
- **const _GAMEFILE_DEFAULT:String = "addons/easy_savefiles/game_data/file/default"**
  - Default settings used by save_settings and load_settings.
### passwords
- **static var _SETTINGS_PASSWORD:String = ""**
- **static var _GAMEFILE_PASSWORD:String = ""**
  - Default passwords used to encrypt files.
- **const _SECRETS:String = "addons/easy_savefiles/secrets/file"**
  - File directory from where the passwords are to be loaded from. by default it will look for "res://secrets.txt", in there, it will look for the contents between both "addons_easy_savefiles_settings_password" and/or "addons_easy_savefiles_gamefile_password" followed by any number of spaces, and the next closest linebreak, between these mentioned elements should be the encryption password.
  - Each password will be loaded to its respective variable.
  - The file could look like the following example:
```shell
# secrets.txt
addons_easy_savefiles_settings_password encryption activated
addons_easy_savefiles_gamefile_password       any spaces, dont forget the line break

```

## EasySettings's methods
- **get_project_settings( include:PackedStringArray, exclude:PackedStringArray = [], settings:Array[Dictionary] = ProjectSettings.get_property_list() ) -> PackedStringArray**
  - This method just filters over an Array of Dictionaries (shaped after Object's [get_property_list()](https://docs.godotengine.org/en/stable/classes/class_object.html#class-object-method-get-property-list)) and includes settings that match any string in the include variable, unless it also matches any of the strings on the exclude variable (exclude string is ignored if its shorter than the include string). Then returns the variables as a PackedStringArray.
  - In other words, the following happens though every iteration:
    1. *Setting* is included if it matches any *Include* string.
    2. *Exclude* string is ignored if its shorter than the *Include* being evaluated.
    3. *Setting* string is ignored if it matches any valid *Exclude* string.
    4. All valid *Setting* strings are returned.
- **save_project_settings( directory:String, paths_include:PackedStringArray, paths_exclude:PackedStringArray = [], password:String = '' ) -> int**
  - Calls "get_project_settings" with paths_include, paths_exclude and the default ProjectSettings.get_property_list() as settings, then saves every setting to a ConfigFile, and saved to "directory", if a password is provided, the saved file will be encryped. 
- **load_project_settings( directory:String, paths_include:PackedStringArray = [""], paths_exclude:PackedStringArray = [], password:String = '' ) -> int**
  - Loads file at "directory" (if a password is provided, it will decrypt the file with said password) and sets settings that match strings at "paths_include" unless they also match "paths_exclude" (by default in includes everything and excludes nothing).
### Interface methods
- Both game/settings have a save_, load_ and reset_, and they essentially do the same, just with different variables, these apply to both cases, but one calls GAMEFILE variables, and the other SETTINGS ones.
  - **save_( directory:String = ProjectSettings.get_setting(_MODIFIED) ) -> void**
	- Calls save_project_settings with the directory, and either game_data or settings's include, exclude and _PASSWORD
  - **load_( directory:String = ProjectSettings.get_setting(_MODIFIED) ) -> void**
	- Calls load_project_settings with the directory, and either game_data or settings's include, exclude and _PASSWORD
  - **reset_( include:PackedStringArray = ProjectSettings.get_setting(_INCLUDE), exclude:PackedStringArray = ProjectSettings.get_setting(_EXCLUDE) ) -> void**
	- Calls load_project_settings with either game_data or settings's _DEFAULT, and local include, exclude and _PASSWORD
- **_ready()**
  - Loads the passwords from "secrets.txt" if such file exists
  - Runs save_settings and save_game on the _DEFAULT directory, creating the file for the reset_settings and reset_game method. 
  - Loads saved settings and game files, if they exist.

## Notes
- Hopefully everything is easy to understand, its a very small addon, and I wanted to be the bare minimum, credit would be appreciated, but since its such a simple script, its not really necessary hahaha.
