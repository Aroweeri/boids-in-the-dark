extends Node2D

onready var boidScene = preload("res://scenes/Boid.tscn");
var util = load("res://scrips/Util.gd").new();
var numBoids = 100;
var rng = RandomNumberGenerator.new();
var boids = [];


func _ready():
	rng.randomize();
	var angle;
	var radius;
	var x;
	var y;
	
	for boid in get_tree().get_nodes_in_group("boids"):
		boid.connect("playerkilled", self, "playerKilled");

func _on_Area2D_body_entered(body):
	if(body == $Player):
		$Player.set_hidden(true);
		$CanvasLayer/Vignette.modulate.a8 = 128;
		for boid in get_tree().get_nodes_in_group("boids"):
			boid.get_node("BreatheSound").volume_db = -15;


func _on_Area2D_body_exited(body):
	if(body == $Player):
		$Player.set_hidden(false);
		$CanvasLayer/Vignette.modulate.a = 0;
		for boid in get_tree().get_nodes_in_group("boids"):
			boid.get_node("BreatheSound").volume_db = -10;


func playerKilled():
	$Player/DeathSound.play();
	$RestartTimer.start();
	$CanvasLayer/DeathScreen.visible = true;
	for boid in get_tree().get_nodes_in_group("boids"):
		boid.queue_free();
	

func _on_WinArea_body_entered(body):
	if(body == $Player):
		get_tree().reload_current_scene();

		#update unlocked levels
		var data = util.load_data("res://data.json");
		data["levels"]["level1"]["unlocked"] = true;
		util.save_data(data, "res://data.json");
		
		get_tree().change_scene("res://scenes/Title.tscn");

func _on_RestartTimer_timeout():
	get_tree().reload_current_scene();
