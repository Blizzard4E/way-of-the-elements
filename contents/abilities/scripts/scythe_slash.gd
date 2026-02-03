class_name ScytheSlash
extends AbilityData

@export var scythe_range: float = 6.0 
@export var skill_damage_multiplier: float = 1.5
@export var ability_instance_scene: PackedScene
@export var attack_speed: float = 1.0
@export var anim_name: String= "scythe_slash" 

func _init() -> void:
	pass;

func tick(slot: AbilitySlot, delta: float, owner: Node) -> void:
	super.tick(slot, delta, owner) 

func activate(slot: AbilitySlot, owner: Node) -> void:
	if not ability_instance_scene:
		push_error("Ability instance scene not assigned for ScytheSlash.")
		return

	var base_dmg := 0.0
	if owner.has_node("Damage"):
		base_dmg = (owner.get_node("Damage") as Damage).damage

	var skill_dmg := base_dmg * skill_damage_multiplier

	var ability_instance = ability_instance_scene.instantiate()
	owner.get_parent().add_child(ability_instance)

	# --- Hitbox damage ---
	var hitbox := ability_instance.get_node_or_null("Hitbox") as Hitbox
	if hitbox:
		hitbox.damage = skill_dmg

	# --- Follow owner ---
	var follow_owner := ability_instance.get_node_or_null("FollowOwner") as FollowOwner
	if follow_owner:
		follow_owner.follow_target = owner
		follow_owner.offset = Vector3.ZERO

	# --- Animation + lifetime sync ---
	var animation_player := ability_instance.get_node_or_null("AnimationPlayer") as AnimationPlayer
	var lifetime := ability_instance.get_node_or_null("Lifetime") as Lifetime

	if animation_player:
		var anim := animation_player.get_animation(anim_name)

		if anim:
			animation_player.play(anim_name)
			animation_player.speed_scale = attack_speed

			if lifetime:
				var adjusted_duration := anim.length / attack_speed
				lifetime.duration = adjusted_duration
