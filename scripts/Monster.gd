extends KinematicBody2D

var linear_vel = Vector2()
var speed = 400
var g = 800
onready var playback = $AnimationTree.get("parameters/playback")

func play(animation):
	return $AnimationPlayer.play(animation)
	
# Called when the node enters the scene tree for the first time
#func _ready():
#	$AnimationPlayer.play("idle")
	
func _physics_process(delta):
	linear_vel.y += g * delta
	linear_vel = move_and_slide(linear_vel, Vector2.UP)
	var on_floor = is_on_floor()
	
	var target_vel = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"), 
		0)
		
	linear_vel.x = lerp(linear_vel.x, target_vel.x * speed, 0.5)
	
	if on_floor:
		if linear_vel.length_squared() > 10:
			playback.travel("run")
		if linear_vel.length_squared() <= 10:
			playback.travel("idle")
		if Input.is_action_just_pressed("jump"):
			linear_vel.y -= speed
			playback.travel("jump")
		if Input.is_action_pressed("crouch"):
			playback.travel("crouch")
		
	if target_vel.x < 0:
		$Sprite.flip_h = true
	if target_vel.x > 0:
		$Sprite.flip_h = false
