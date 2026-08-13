@tool
extends EditorPlugin

var confirm_dialog: ConfirmationDialog

var create_confirm_dialog: ConfirmationDialog
var pending_folders: Array = []

func _enter_tree():
	add_tool_menu_item("Create 2D Setup", _on_create_2d)
	add_tool_menu_item("Create 3D Setup", _on_create_3d)
	add_tool_menu_item("Delete Generated Setup", _show_delete_confirmation)

	confirm_dialog = ConfirmationDialog.new()
	confirm_dialog.title = "Confirm Delete"
	confirm_dialog.dialog_text = "This will permanently delete the generated scenes, scripts, and assets folders (and anything inside them). Continue?"
	confirm_dialog.confirmed.connect(_on_delete_setup)
	EditorInterface.get_base_control().add_child(confirm_dialog)

	create_confirm_dialog = ConfirmationDialog.new()
	create_confirm_dialog.title = "Folders Already Exist"
	create_confirm_dialog.confirmed.connect(_on_create_confirmed)
	EditorInterface.get_base_control().add_child(create_confirm_dialog)

func _exit_tree():
	remove_tool_menu_item("Create 2D Setup")
	remove_tool_menu_item("Create 3D Setup")
	remove_tool_menu_item("Delete Generated Setup")
	confirm_dialog.queue_free()
	create_confirm_dialog.queue_free()

func _show_delete_confirmation():
	confirm_dialog.popup_centered()

func _on_create_2d():
	var folders = [
		"res://scenes",
		"res://scripts",
		"res://assets/sprites",
		"res://assets/audio",
		"res://assets/textures"
	]
	_try_create_folders(folders)

func _on_create_3d():
	var folders = [
		"res://scenes",
		"res://scripts",
		"res://assets/models",
		"res://assets/textures",
		"res://assets/audio"
	]
	_try_create_folders(folders)

func _create_folders(folders: Array):
	for folder in folders:
		var err = DirAccess.make_dir_recursive_absolute(folder)
		if err == OK:
			print("Created: ", folder)
		else:
			print("Failed to create: ", folder, " (error code ", err, ")")
	
	EditorInterface.get_resource_filesystem().scan()
	
func _delete_folder_recursive(path: String):
	var dir = DirAccess.open(path)
	if dir == null:
		return  # folder doesn't exist, nothing to do

	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if file_name != "." and file_name != "..":
			var full_path = path + "/" + file_name
			if dir.current_is_dir():
				_delete_folder_recursive(full_path)
			else:
				dir.remove(file_name)
		file_name = dir.get_next()
	dir.list_dir_end()

	DirAccess.remove_absolute(path)
	print("Deleted: ", path)
	
func _on_delete_setup():
	var folders = [
		"res://scenes",
		"res://scripts",
		"res://assets/sprites",
		"res://assets/models",
		"res://assets/textures",
		"res://assets/audio",
		"res://assets"
	]
	for folder in folders:
		_delete_folder_recursive(folder)

	EditorInterface.get_resource_filesystem().scan()
	
func _get_existing_folders(folders: Array) -> Array:
	var existing = []
	for folder in folders:
		if DirAccess.dir_exists_absolute(folder):
			existing.append(folder)
	return existing
	
func _try_create_folders(folders: Array):
	var existing = _get_existing_folders(folders)
	if existing.is_empty():
		_create_folders(folders)
	else:
		pending_folders = folders
		create_confirm_dialog.dialog_text = "Some folders already exist:\n" + "\n".join(existing) + "\n\nProceed anyway?"
		create_confirm_dialog.popup_centered()

func _on_create_confirmed():
	_create_folders(pending_folders)
	
