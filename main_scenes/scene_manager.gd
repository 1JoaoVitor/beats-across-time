extends Node

enum MainScene {
	MENU,
	RHYTHM_TEST,
}

const MAIN_SCENES_UIDS: Dictionary = {
	MainScene.MENU: "uid://lo2gkq41mho5",
	MainScene.RHYTHM_TEST: "uid://b2xko7dyhrx7s"
}


func _ready() -> void:
	# ATTENTION: call_deferred is necessary to load the initial scene safely only after the bootloader scene has been properly initialized.
	# INFO: Change the initial scene here    vvv
	self.call_deferred("change_scene_to", MainScene.MENU)
	print(get_tree().current_scene)


func change_scene_to(next_scene: MainScene) -> void:
	# TODO: Add transition scene animation
	get_tree().change_scene_to_file(MAIN_SCENES_UIDS[next_scene])
