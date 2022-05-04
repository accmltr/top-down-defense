extends PlayerStructure

class_name Turret

export var damage: float = 10

onready var projectile_manager: Node = $Projectiles
onready var attacker_part: Attacker = $AttackerPart
onready var attack_execution: AttackExecution = $AttackExecution

func _ready():
	attack_execution.setup(self)
