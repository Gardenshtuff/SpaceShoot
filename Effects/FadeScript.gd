extends ColorRect

func FadeIn():
	self.visible = true
	$Tween.interpolate_property(self, 'color',
		Color(0,0,0,1), Color(0,0,0,0), 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	
func FadeToBlack():
	$Tween.interpolate_property(self, 'color',
		Color(0,0,0,0), Color(0,0,0,1),3,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
