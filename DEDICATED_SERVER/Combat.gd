extends Node

func FetchSkillDamage(s_name):
	var damage = ServerData.skill_data[s_name].Damage
	return damage
