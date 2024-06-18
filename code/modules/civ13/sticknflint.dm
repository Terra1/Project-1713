/obj/item/stick
	name = "stick"
	desc = "A tree branch without leaves and twigs."
	icon = 'icons/civ13/obj/old_weapons.dmi'
	lefthand_file = 'icons/civ13/mob/items/lefthand_weapons.dmi'
	righthand_file = 'icons/civ13/mob/items/righthand_weapons.dmi'
	icon_state = "debranched_stick"
	inhand_icon_state = "debranched_stick"
	force = 6
	resistance_flags = FLAMMABLE
	throwforce = 4
	throw_speed = 1
	throw_range = 3
	var/sharpened = FALSE

/obj/item/stick/proc/sharpen()
	name = "sharpened stick"
	desc = "A tree branch sharpened using flint."
	icon = 'icons/civ13/obj/old_weapons.dmi'
	lefthand_file = 'icons/civ13/mob/items/lefthand_weapons.dmi'
	righthand_file = 'icons/civ13/mob/items/righthand_weapons.dmi'
	icon_state = "sharpened_stick"
	inhand_icon_state = "sharpened_stick"
	hitsound = 'sound/weapons/bladeslice.ogg'
	force = 8
	throwforce = 8
	throw_speed = 4
	throw_range = 8
	sharpness = SHARP_POINTY
	embedding = list("pain_mult" = 4, "embed_chance" = 35, "fall_chance" = 10)
	attack_verb_continuous = list("attacks", "pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("attack", "poke", "jab", "tear", "lacerate", "gore")
	sharpened = TRUE
	update_icon_state()

/obj/item/stick/attackby(var/obj/item/flint/I, mob/living/user, params)
	if(!istype(I))
		return ..()
	if(sharpened)
		return ..()
	if (!I.sharpened)
		return ..()
	balloon_alert(user, span_notice("You begin sharpening \the [src]."))
	if(!do_after(user, 5 SECONDS, src))
		return
	balloon_alert(user, span_notice("You sharpen \the [src]."))
	sharpen()

/obj/item/flint
	name = "flint"
	desc = "A small piece of flint rock."
	force = 5
	throwforce = 7
	throw_speed = 2
	throw_range = 6
	icon = 'icons/civ13/obj/old_weapons.dmi'
	icon_state = "flint"
	var/sharpened = FALSE

/obj/item/flint/proc/sharpen()
	name = "sharpened flint"
	desc = "A small piece of sharpened flint rock."
	force = 8
	throwforce = 8
	throw_speed = 4
	throw_range = 8
	sharpness = SHARP_EDGED
	icon_state = "sharpened_flint"
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb_continuous = list("attacks", "pokes", "jabs", "tears", "lacerates", "gores")
	attack_verb_simple = list("attack", "poke", "jab", "tear", "lacerate", "gore")
	sharpened = TRUE

/obj/structure/flora/tree
	var/branch_num
	var/desc2

/obj/structure/flora/tree/Initialize(mapload)
	. = ..()
	branch_num = rand(1,6)

/obj/structure/flora/tree/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(branch_num)
		balloon_alert(user, span_notice("You begin removing a branch from \the tree..."))
		if(!do_after(user, 5 SECONDS, src))
			return
		var/obj/item/stick/G = new /obj/item/stick(src)
		user.put_in_hands(G)
		branch_num--
	else
		balloon_alert(user, span_warning("There are no branches left on \the tree!"))

/obj/structure/flora/tree/examine(mob/user)
	. = ..()
	if(branch_num > 1)
		. += "There are [branch_num] branches on \the tree."
	else if (branch_num == 1)
		. += "There is [branch_num] branch on \the tree."
	else
		. += "There are no branches left on \the tree."

/obj/structure/flora/rock/attack_hand(mob/living/user, list/modifiers)
	balloon_alert(user, span_notice("You begin looking for flint in \the [src]..."))
	if(!do_after(user, 5 SECONDS, src))
		return
	var/obj/item/flint/G = new /obj/item/flint(src)
	user.put_in_hands(G)
	return ..()

/obj/structure/flora/rock/attackby(var/obj/item/flint/I, mob/living/user, params)
	if(!istype(I))
		return ..()
	if(I.sharpened)
		return ..()
	user.changeNext_move(CLICK_CD_SLOW)
	balloon_alert(user, span_notice("You hit \the [src] with \the [I]."))
	playsound(src,'sound/effects/chop.ogg',100,1)
	if(prob(20))
		balloon_alert(user, span_notice("The [I] chips away, exposing a sharp edge!"))
		I.sharpen()

// flint hatchets in hatchets.dm
