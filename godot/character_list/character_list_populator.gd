extends Node

@export var sprite_panel: PackedScene
@export var xml_selector: NativeFileDialog

const ObjectParser = preload("res://parsers/objects/object_parser.gd")

func _ready() -> void:
	if DirAccess.dir_exists_absolute("./assets/xml/"):
		xml_selector.root_subfolder = "./assets/xml/"
	else:
		xml_selector.root_subfolder = "./"
	xml_selector.add_filter("*.xml", "RotMG Object XML (*.xml)")
	xml_selector.show()

func _on_native_file_dialog_file_selected(path: String) -> void:
	var parser := ObjectParser.new()
	var characters := parser.parse_objects(path)
	
	for c in characters:
		var panel = sprite_panel.instantiate()
		panel.character = c
		get_parent().add_child.call_deferred(panel)
