extends Node

var score = 0
var combo = 0
var wallBounce = false
var wallBounceCount = 0
var wallBounceDir = ""
var switch = 0
var frozen = false
var weapon_mode := 0  # 0 = fist, 1 = bat, 2 = pistol
var unlocked = [0, 1]
var mute = false
var particles = true
var shake = true

var achievements = {
	0 : ["The first of many", "Reach a score of 1", false],
	1 : ["It's over 1000!", "Reach a score of 1,001", false],
	2 : ["Where did all the time go?", "Reach a score of 10,000", false],
	3 : ["Going, Going, Gone...", "Reach a score of 100,000", false],
	4 : ["Go outside", "Reach a score of 1,000,000", false],
	5 : ["Switching is faster than reloading", "Switch from any weapon to the pistol", false],
	6 : ["WOMBO COMBO", "Get a combo of 50", false],
	7 : ["THAT AIN'T FALCO", "Get a combo of 200", false],
	8 : ["Boing Boing Boing", "Wall bounce 4 times in a row", false],
	9 : ["Now you're playing with power", "Switch to 3 different weapons while the computer is in the air", false],
	10 : ["I'm Batman", "Unlock the bat", false],
	11 : ["Bring a gun to a sword fight", "Unlock the pistol", false],
	12 : ["He's in CT", "Unlock the AK-47", false],
	13 : ["Wumbotized", "Get a combo of 1000", false],
	14 : ["Dopamine Maxing", "Wall bounce 100 times while having a combo of 150 or under", false],
	15 : ["Saving for AWP", "Unlock the sniper", false],
	16 : ["Skill Issue TBH", "Get a combo of 1000 while making at least 15 different weapon switches", false]
}
