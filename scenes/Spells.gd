extends CanvasLayer

signal spell_change

var deadzone := 0.1
var has_flipped := false
var current_spell := 0


# Called when the node enters the scene tree for the first time.
func _ready():
	var children_spells = self.get_children()
	for i in range(len(children_spells)):
		if i == current_spell:
			children_spells[i].set_visible(true)
		else:
			children_spells[i].set_visible(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_change_spell(name, value):
	if value.x >= deadzone and not has_flipped:
		var children_spells = self.get_children()
		if current_spell >= len(children_spells) - 1:
			has_flipped = true
			return
		var next_spell = current_spell
		for i in range(len(children_spells)):
			if i == (current_spell + 1):
				children_spells[i].set_visible(true)
				next_spell = i
				has_flipped = true
			else:
				children_spells[i].set_visible(false)
		current_spell = next_spell
	elif value.x <= -deadzone and not has_flipped:
		if current_spell == 0:
			has_flipped = true
			return
		var children_spells = self.get_children()
		for i in range(len(children_spells)):
			if i == (current_spell - 1):
				children_spells[i].set_visible(true)
				current_spell = i
				has_flipped = true
			else:
				children_spells[i].set_visible(false)
	elif abs(value.x) < deadzone and has_flipped:
		has_flipped = false
