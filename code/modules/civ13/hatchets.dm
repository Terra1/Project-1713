/obj/structure/flora/tree/attackby(var/obj/item/hatchet/flint/I, mob/living/user, params)
	if(!istype(I))
		return ..()
	user.do_attack_animation(src)
	playsound(src,'sound/effects/wood_cutting.ogg',100)
	balloon_alert(user, span_notice("You begin to chop down \the [src]..."))
	if(!do_after(user, 30 SECONDS/I.force*2.8, src))
		return
	harvest()
	qdel(src)

/obj/item/hatchet/flint
	name = "flint hatchet"
	desc = "A very crude hatchet, made with wood and flint."
	icon = 'icons/civ13/obj/old_weapons.dmi'
	icon_state = "flint_axe"
	inhand_icon_state = "flinthatchet"
	lefthand_file = 'icons/civ13/mob/items/lefthand_weapons.dmi'
	righthand_file = 'icons/civ13/mob/items/righthand_weapons.dmi'
	obj_flags = NONE
	force = 10
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 10
	throw_speed = 2
	throw_range = 7
	embedding = list("pain_mult" = 4, "embed_chance" = 35, "fall_chance" = 10)
	custom_materials = list(/datum/material/wood = SHEET_MATERIAL_AMOUNT*0.5)
	attack_verb_continuous = list("chops", "tears", "lacerates", "cuts")
	attack_verb_simple = list("chop", "tear", "lacerate", "cut")
	hitsound = 'sound/weapons/bladeslice.ogg'
	sharpness = SHARP_EDGED

/datum/crafting_recipe/flint_hatchet
	reqs = list(
		/obj/item/stick = 1,
		/obj/item/flint = 1
	)
	result = /obj/item/hatchet/flint
	time = 5 SECONDS
	parts = list(
		/obj/item/stick = 1,
		/obj/item/flint = 1
	)
	category = CAT_TOOLS

/datum/crafting_recipe/flint_hatchet/check_requirements(mob/user, list/collected_requirements)
	var/obj/item/stick/S = collected_requirements[/obj/item/stick][1]
	var/obj/item/flint/F = collected_requirements[/obj/item/flint][1]
	return S.sharpened && F.sharpened
