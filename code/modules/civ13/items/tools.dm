//Hammers
/obj/item/hammer
	name = "hammer"
	desc = "A hammer with common uses. Can be found in your hand."
	icon = 'icons/civ13/obj/items.dmi'
	icon_state = "hammer"
	inhand_icon_state = "hammer"
	worn_icon_state = "hammer"
	lefthand_file = 'icons/civ13/mob/items/lefthand_weapons.dmi'
	righthand_file = 'icons/civ13/mob/items/righthand_weapons.dmi'
	force = 8
	throwforce = 4
	demolition_mod = 1.25
	w_class = WEIGHT_CLASS_SMALL
	usesound = 'sound/effects/pickaxe.ogg'
	operating_sound = list('sound/effects/pickaxe.ogg', 'sound/effects/pickaxe.ogg')
	custom_materials = list(/datum/material/wood=SMALL_MATERIAL_AMOUNT*1.5)
	attack_verb_continuous = list("bashes", "batters", "bludgeons", "whacks")
	attack_verb_simple = list("bash", "batter", "bludgeon", "whack")
	tool_behaviour = TOOL_HAMMER
	toolspeed = 3

/obj/item/hammer/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/falling_hazard, damage = force, wound_bonus = wound_bonus, hardhat_safety = TRUE, crushes = FALSE, impact_sound = hitsound)

/obj/item/wrench/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] is beating [user.p_them()]self to death with [src]! It looks like [user.p_theyre()] trying to commit suicide!"))
	playsound(loc, 'sound/weapons/genhit.ogg', 50, TRUE, -1)
	return BRUTELOSS

//Called when you left click an object with a hammer
/atom/proc/hammer_act(mob/living/user, obj/item/tool)
	return

//Called when you right click an object with a hammer.
/atom/proc/hammer_act_secondary(mob/living/user, obj/item/tool)
	return
