extends Label

var st
func _ready():
	st = $Timer.time_left
	$FadeTween.interpolate_property(self, "custom_colors/font_color",
	Color(1,1,1,1), Color(1,1,1,0), 3,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$FadeTween2.interpolate_property(self, "custom_colors/font_color_shadow",
	Color(0,0,0,1), Color(0,0,0,0), 3,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	
func _process(_delta):
	self.percent_visible = 1 - $Timer.time_left / st

func _on_Timer_timeout():
	$FadeTween.start()
	$FadeTween2.start()

func _on_FadeTween_tween_completed(object, key):
	get_parent().remove_child(self)
