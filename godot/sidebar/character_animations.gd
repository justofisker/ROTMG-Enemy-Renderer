extends Control

@export var animation_selector: OptionButton

func _ready() -> void:
	GlobalSettings.export_setting_changed.connect(_add_frames)

var character: Character :
	set(value):
		character = value
		visible = character.animations.size() != 0
		if visible:
			_setup_animations()

func _setup_animations() -> void:
	animation_selector.selected = 0
	_setup_animation_selector()
	_add_frames()
	if animation_selector.item_count != 0:
		animation_selector.item_selected.emit(0)

func _setup_animation_selector() -> void:
	animation_selector.clear()
	for idx in character.animations.size():
		var anim : CharacterAnimation = character.animations[idx]
		var animation := anim.id
		if animation == "":
			animation = "Unnamed " + str(idx)
		animation_selector.add_item(animation)

func _add_frames() -> void:
	if character == null:
		return
	var sprite_frames := SpriteFrames.new()
	var outline_size : int = GlobalSettings.export_outline_size
	var export_scale : int = GlobalSettings.export_scale
	for idx in character.animations.size():
		var anim : CharacterAnimation = character.animations[idx]
		var animation := anim.id
		if animation == "":
			animation = "Unnamed " + str(idx)
		sprite_frames.add_animation(animation)
		for jdx in anim.frames.size():
			var tex : AtlasTexture = anim.frames[jdx].texture_export
			sprite_frames.add_frame(animation, tex, anim.frame_durations[jdx])
	%Sprite.sprite_frames = sprite_frames
	%Sprite.play()
	animation_selector.select(animation_selector.selected)

func _on_animation_selector_item_selected(index: int) -> void:
	%Sprite.play(animation_selector.get_item_text(animation_selector.selected))
