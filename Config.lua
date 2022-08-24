--[[

    💬 Export from PSW => discord:🧠PSPW#2993
	
    🐌 @Copyright PSW
    ☕ Thanks For Coffee Tips https://ko-fi.com/pondsuphawit

]]--

--[[ 

สนใจตัวแท้+ไม่เข้ารหัสใดๆ ดีกว่านี้เยอะ ติดต่อเลยย
discord https://discord.gg/n7htcQj6sU

]]


PSW = {}

PSW['จุดสำหรับเปิดร้าน'] = vector3(563.33, 2751.28, 42.85)
PSW['จุดสปาวโมเดลตอนเปิดร้าน'] = vector3(564.9, 2745.11, 41.85)

PSW['มุมกล้อง'] = {
	["x"] = 562.55,
	["y"] = 2744.85,
	["z"] = 43.88,
	["rotationX"] = -27.560733795166,
	["rotationY"] = 0.0,
	["rotationZ"] = 274.0
}


--[[ จุดบนแมพ Blilps ]]
PSW['เปิดจุดบนแมพไหม'] = true
PSW['เลขBlip'] = 442
PSW['ขนาดBlip'] = 1.2
PSW['สีBlip'] = 1
PSW['ระยะการมองเห็น'] = 3
PSW['ชื่อบนแมพ'] =  "<font face='ThaiFont'> ร้านค้าสัตว์เลี้ยง"


PSW['ปุ่มเปิดเมนู'] = 'L'


PSW['ไอเทมชุบสัตว์เลี้ยง'] = ''

PSW.Hunger = 48*3600		
PSW.FoodHunger = 10*3600	


PSW['สัตว์เลี้ยงในร้าน'] = {
	{name = 'Cat',			model = `a_c_cat_01`,		price = 100000,		type = 'cat'},
	{name = 'Chop',			model = `a_c_chop`,			price = 300000,		type = 'dog'},
	{name = 'Husky',		model = `a_c_husky`,		price = 280000,		type = 'dog'},
	{name = 'Poodle',		model = `a_c_poodle`,		price = 200000,		type = 'dog'},
	{name = 'Pug',			model = `a_c_pug`,			price = 220000,		type = 'dog'},
	{name = 'Retriever',	model = `a_c_retriever`,	price = 230000,		type = 'dog'},
	{name = 'Rottweiler',	model = `a_c_rottweiler`,	price = 300000,		type = 'dog'},
	{name = 'Shepherd',		model = `a_c_shepherd`,		price = 270000,		type = 'dog'},
	{name = 'Westy',		model = `a_c_westy`,		price = 200000,		type = 'dog'},
	{name = 'Chickenhawk',	model = `a_c_chickenhawk`,	price = 170000,		type = 'bird'},
	{name = 'Crow',			model = `a_c_crow`,			price = 170000,		type = 'bird'},
	{name = 'Cormorant',	model = `a_c_cormorant`,	price = 140000,		type = 'bird'},
	{name = 'Pigeon',		model = `a_c_pigeon`,		price = 140000,		type = 'bird'},
	{name = 'Seagull',		model = `a_c_seagull`,		price = 140000,		type = 'bird'},
	{name = 'Cow',			model = `a_c_cow`,			price = 400000,		type = 'other'},
	{name = 'Chimp',		model = `a_c_chimp`,		price = 500000,		type = 'other'},
	{name = 'Hen',			model = `a_c_hen`,			price = 140000,		type = 'other'},
	{name = 'Pig',			model = `a_c_pig`,			price = 300000,		type = 'other'},
	{name = 'Rat',			model = `a_c_rat`,			price = 100000,		type = 'other'},
	{name = 'Rabbit',		model = `a_c_rabbit_01`,	price = 100000,		type = 'other'},
	{name = 'Boar',			model = `a_c_boar`,			price = 400000,		type = 'other'},
	{name = 'Deer',			model = `a_c_deer`,			price = 400000,		type = 'other'},
	{name = 'Mtlion',		model = `a_c_mtlion`,		price = 5000000,	type = 'other'},
	{name = 'Rhesus',		model = `a_c_rhesus`,		price = 500000,		type = 'other'},
}

PSW['ท่าทางสัตว์'] = {
	['Cat'] = {
		{label = "Sleep", dict = "creatures@cat@amb@world_cat_sleeping_ground@base", name = "base"},
		{label = "Sit", dict = "creatures@cat@amb@world_cat_sleeping_ledge@base", name = "base"},
		{label = "Itching", dict = "creatures@cat@player_action@", name = "action_a"}
	},
	['Chop'] = {
		{label = "Sit", dict = "creatures@rottweiler@amb@world_dog_sitting@base", name = "base"},
		{label = "Sit Down", dict = "creatures@rottweiler@amb@sleep_in_kennel@", name = "sleep_in_kennel"},
		{label = "Itching", dict = "creatures@rottweiler@amb@world_dog_sitting@idle_a", name = "idle_a"}
	},
	['Husky'] = {
		{label = "Sit", dict = "creatures@retriever@amb@world_dog_sitting@base", name = "base"},
		{label = "Sit Down", dict = "creatures@rottweiler@amb@sleep_in_kennel@", name = "sleep_in_kennel"},
		{label = "Itching", dict = "creatures@rottweiler@amb@world_dog_sitting@idle_a", name = "idle_a"}
	},
	['Pug'] = {
		{label = "Sit", dict = "creatures@pug@amb@world_dog_sitting@idle_a", name = "idle_b"}
	},
	['Retriever'] = {
		{label = "Sit", dict = "creatures@retriever@amb@world_dog_sitting@base", name = "base"},
		{label = "Sit Down", dict = "creatures@rottweiler@amb@sleep_in_kennel@", name = "sleep_in_kennel"},
		{label = "Itching", dict = "creatures@rottweiler@amb@world_dog_sitting@idle_a", name = "idle_a"}
	},
	['Rottweiler'] = {
		{label = "Sit", dict = "creatures@retriever@amb@world_dog_sitting@base", name = "base"},
		{label = "Sit Down", dict = "creatures@rottweiler@amb@sleep_in_kennel@", name = "sleep_in_kennel"},
		{label = "Itching", dict = "creatures@rottweiler@amb@world_dog_sitting@idle_a", name = "idle_a"}
	},
	['Shepherd'] = {
		{label = "Sit", dict = "creatures@retriever@amb@world_dog_sitting@base", name = "base"},
		{label = "Sit Down", dict = "creatures@rottweiler@amb@sleep_in_kennel@", name = "sleep_in_kennel"},
		{label = "Itching", dict = "creatures@rottweiler@amb@world_dog_sitting@idle_a", name = "idle_a"}
	},
	['Chickenhawk'] = {
		{label = "Idle", dict = "creatures@chickenhawk@amb@world_chickenhawk_feeding@idle_a", name = "idle_c"}
	},
	['Crow'] = {
		{label = "Idle", dict = "creatures@crow@amb@world_crow_feeding@base", name = "base"}
	},
	['Cormorant'] = {
		{label = "Idle", dict = "creatures@cormorant@amb@world_cormorant_standing@base", name = "base"},
        {label = "Idle 2", dict = "creatures@cormorant@amb@world_cormorant_standing@idle_a", name = "idle_b"}
	},
	['Pigeon'] = {
		{label = "Eat", dict = "creatures@pigeon@amb@world_pigeon_feeding@base", name = "base"},
        {label = "Fly Aroun", dict = "creatures@pigeon@move", name = "flapping_bank_l"}
	},
	['Cow'] = {
		{label = "Look Ground", dict = "creatures@cow@amb@world_cow_grazing@base", name = "base"}
	},
	['Chimp'] = {
		{label = "Bring It On", dict = "misscommon@response", name = "bring_it_on"},
		{label = "Sit Chair 1", dict = "timetable@reunited@ig_10", name = "base_amanda"},
		{label = "Sit Chair 2", dict = "timetable@ron@ig_3_couch", name = "base"},
		{label = "Wave1", dict = "anim@mp_player_intcelebrationfemale@wave", name = "wave"},
		{label = "Wave2", dict = "friends@fra@ig_1", name = "over_here_idle_a"},
		{label = "Fall Asleep", dict = "mp_sleep", name = "sleep_loop"},
		{label = "Boi", dict = "special_ped@jane@monologue_5@monologue_5c", name = "brotheradrianhasshown_2"},
		{label = "Hug", dict = "mp_ped_interaction", name = "kisses_guy_a"},
		{label = "Slap", dict = "melee@unarmed@streamed_variations", name = "plyr_takedown_front_slap"},
		{label = "Dance Upper", dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@", name = "high_center"},
		{label = "Dance Upper 2", dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@", name = "high_center_up"}
	},
	['Hen'] = {
		{label = "Eat", dict = "creatures@hen@amb@world_hen_pecking@base", name = "base"}
	},
	['Pig'] = {
		{label = "Eat", dict = "creatures@pig@amb@world_pig_grazing@base", name = "base"}
	},
	['Rat'] = {
		{label = "Eat", dict = "creatures@rat@amb@world_rats_eating@base", name = "base"}
	},
	['Rabbit'] = {
		{label = "Itching", dict = "creatures@rabbit@amb@peyote@enter", name = "enter"},
		{label = "Eat", dict = "creatures@rabbit@amb@world_rabbit_eating@enter", name = "enter"}
	},
	['Deer'] = {
		{lable = "Look Ground", dict = "creatures@deer@amb@world_deer_grazing@idle_a", name = "idle_b"}
	},
	['Rhesus'] = {
		{label = "Bring It On", dict = "misscommon@response", name = "bring_it_on"},
		{label = "Sit Chair 1", dict = "timetable@reunited@ig_10", name = "base_amanda"},
		{label = "Sit Chair 2", dict = "timetable@ron@ig_3_couch", name = "base"},
		{label = "Wave1", dict = "anim@mp_player_intcelebrationfemale@wave", name = "wave"},
		{label = "Wave2", dict = "friends@fra@ig_1", name = "over_here_idle_a"},
		{label = "Fall Asleep", dict = "mp_sleep", name = "sleep_loop"},
		{label = "Boi", dict = "special_ped@jane@monologue_5@monologue_5c", name = "brotheradrianhasshown_2"},
		{label = "Hug", dict = "mp_ped_interaction", name = "kisses_guy_a"},
		{label = "Slap", dict = "melee@unarmed@streamed_variations", name = "plyr_takedown_front_slap"},
		{label = "Dance Upper", dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@", name = "high_center"},
		{label = "Dance Upper 2", dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@", name = "high_center_up"}
	},
}

PSW.CanSitShoulder = {
	['Chickenhawk']	= true,
	['Crow']		= true,
	['Pigeon']		= true,
	['Hen']			= true,
	['Rat']			= true
}

PSW.Customization = {
	'Face',
	'Mask',
	'Hair',
	'Torso',
	'Legs',
	'Parachute/Bags',
	'Shoes',
	'Accessory',
	'Undershirt',
	'Kevlar',
	'Badge',
	'Torso 2'
}

PSW['อาหารสัตว์'] = {
	['cat']		= {name = 'pet_food1', label = 'Cat Food'},
	['dog']		= {name = 'pet_food2', label = 'Dog Food'},
	['bird']	= {name = 'pet_food3', label = 'Bird Food'},
	['other']	= {name = 'pet_food4', label = 'Other Food'},
}

PSW['จุดโชว์สัตว์ในร้าน'] = {
	{model = `a_c_chop`,		coords = vector3(552.53, 2749.21, 44.10),	heading = 275.00},
	{model = `a_c_husky`,		coords = vector3(552.53, 2747.96, 44.10),	heading = 275.00},
	{model = `a_c_poodle`,		coords = vector3(552.53, 2750.47, 44.10),	heading = 275.00},
	{model = `a_c_retriever`,	coords = vector3(552.53, 2751.77, 44.10),	heading = 275.00},
	
	{model = `a_c_pug`,			coords = vector3(552.53, 2749.21, 43.00),	heading = 275.00},
	{model = `a_c_rottweiler`,	coords = vector3(552.53, 2747.96, 43.00),	heading = 275.00},
	{model = `a_c_shepherd`,	coords = vector3(552.53, 2750.47, 43.00),	heading = 275.00},
	{model = `a_c_rabbit_01`,	coords = vector3(552.53, 2751.77, 43.00),	heading = 275.00},
	
	{model = `a_c_cat_01`,		coords = vector3(552.53, 2749.21, 42.00),	heading = 275.00},
	{model = `a_c_cormorant`,	coords = vector3(552.53, 2747.96, 42.00),	heading = 275.00},
	{model = `a_c_crow`,		coords = vector3(552.53, 2750.47, 42.00),	heading = 275.00},
	{model = `a_c_westy`,		coords = vector3(552.53, 2751.77, 42.00),	heading = 275.00},
}