extends PlayerStructure

class_name Turret

export var damage: float = 10
export var projectile: PackedScene
export var _projectile_point_np: NodePath

onready var projectiles_manager: Node = $Projectiles
onready var _projectile_point: Node2D = get_node(_projectile_point_np) as Node2D
onready var attacker_part: Attacker = $AttackerPart

func _ready():
	# warning-ignore:return_value_discarded
	attacker_part.connect("cast_attack", self, "start_casting")
	# warning-ignore:return_value_discarded
	attacker_part.connect("finished_casting", self, "finish_casting")
	# warning-ignore:return_value_discarded
	attacker_part.connect("finished_reloading", self, "finish_reloading")

# warning-ignore:unused_argument
func start_casting(target_: Node2D):
	fire(target_)

func finish_casting(target_: Node2D):
	pass

func finish_reloading():
	pass

func fire(target_: Node2D):
	var p = projectile.instance() as Projectile
	projectiles_manager.add_projectile(p)
	p.global_position = _projectile_point.global_position
	p.launch(projectiles_manager, damage, target_)
