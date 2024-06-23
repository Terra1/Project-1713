/*
//Wall frames! A variation on girders for low-tech construction.
*/
/obj/structure/wall_frame
	name = "wood frame"
	icon = 'icons/civ13/obj/structures.dmi'
	icon_state = "wall_frame"
	desc = "A wooden wall frame, add something like paper, bamboo bundles or wood to it..."
	anchored = TRUE
	density = TRUE
	max_integrity = 200
	rad_insulation = RAD_VERY_LIGHT_INSULATION
	var/girderpasschance = 30 // percentage chance that a projectile passes through the frame.
	/// The material cost to construct something on the frame
	var/static/list/construction_cost = list(
		/obj/item/stack/sheet/mineral/wood = 5
	)

/obj/structure/wall_frame/wood
	name = "wood frame"
	icon_state = "wall_frame"
	desc = "A wooden wall frame, add something like paper, bamboo bundles or wood to it..."
	anchored = TRUE
	density = TRUE
	max_integrity = 200
	rad_insulation = RAD_VERY_LIGHT_INSULATION

/obj/structure/wall_frame/attackby(obj/item/W, mob/user, params)
	add_fingerprint(user)
	if(istype(W, /obj/item/stack/sheet/mineral/wood))
		var/obj/item/stack/sheet/mineral/wood = W
		var/amount = construction_cost[wood.type]
		if(wood.get_amount() < amount)
			balloon_alert(user, "need [amount] wooden planks!")
			return
		balloon_alert(user, "adding plating...")
		if (do_after(user, 4 SECONDS, target = src))
			wood.use(amount)
			var/turf/T = get_turf(src)
			if(wood.walltype)
				var/turf/closed/wall/newturf = T.place_on_top(wood.walltype)
				newturf.girder_type = src.type
			else
				var/turf/closed/wall/newturf = T.place_on_top(/turf/closed/wall/material)
				newturf.girder_type = src.type
				var/list/material_list = list()
				material_list[GET_MATERIAL_REF(wood.material_type)] = SHEET_MATERIAL_AMOUNT * 2
				if(material_list)
					newturf.set_custom_materials(material_list)
			transfer_fingerprints_to(T)
			qdel(src)
			return
	if(istype(W, /obj/item/pipe))
		var/obj/item/pipe/P = W
		if (P.pipe_type in list(0, 1, 5)) //simple pipes, simple bends, and simple manifolds.
			if(!user.transferItemToLoc(P, drop_location()))
				return
			balloon_alert(user, "inserted pipe")
	if(!istype(W, /obj/item/stack/sheet))
		return ..()
	add_hiddenprint(user)

/obj/structure/wall_frame/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	if((mover.pass_flags & PASSGRILLE) || isprojectile(mover))
		return prob(girderpasschance)

/obj/structure/wall_frame/CanAStarPass(to_dir, datum/can_pass_info/pass_info)
	if(!density)
		return TRUE
	if(pass_info.pass_flags & PASSGRILLE)
		return TRUE
	return FALSE

/obj/structure/wall_frame/atom_deconstruct(disassembled = TRUE)
	var/remains = /obj/item/stack/sheet/mineral/wood
	new remains(loc)

/obj/structure/wall_frame/rcd_vals(mob/user, obj/item/construction/rcd/the_rcd)
	switch(the_rcd.mode)
		if(RCD_TURF)
			if(the_rcd.rcd_design_path != /turf/open/floor/plating/rcd)
				return FALSE

			return rcd_result_with_memory(
				list("delay" = 2 SECONDS, "cost" = 8),
				get_turf(src), RCD_MEMORY_WALL,
			)
		if(RCD_DECONSTRUCT)
			return list("delay" = 2 SECONDS, "cost" = 13)
	return FALSE

/obj/structure/wall_frame/rcd_act(mob/user, obj/item/construction/rcd/the_rcd, list/rcd_data)
	switch(rcd_data["[RCD_DESIGN_MODE]"])
		if(RCD_TURF)
			if(the_rcd.rcd_design_path != /turf/open/floor/plating/rcd)
				return FALSE

			var/turf/T = get_turf(src)
			T.place_on_top(/turf/closed/wall)
			qdel(src)
			return TRUE
		if(RCD_DECONSTRUCT)
			qdel(src)
			return TRUE
	return FALSE

/obj/structure/wall_frame/hammer_act(mob/living/user, obj/item/tool)
	. = ..()
	balloon_alert(user, "disassembling frame...")
	if(tool.use_tool(src, user, 40, volume=100))
		var/obj/item/stack/sheet/mineral/wood/M = new (loc, 2)
		if (!QDELETED(M))
			M.add_fingerprint(user)
		qdel(src)
	return TRUE

/obj/structure/wall_frame/proc/deconstruction_hints(mob/user)
	return span_notice("The wall is held together by <b>nails</b>.")

/obj/structure/wall_frame/examine(mob/user)
	. += ..()
	. += deconstruction_hints(user)

/*
//Walls of all types + modifications
*/
/turf/closed/wall/mineral/wood/deconstruction_hints(mob/user)
	return span_notice("The wall is held together by <b>nails</b>.")

/turf/closed/wall/mineral/wood/hammer_act(mob/living/user, obj/item/tool)
	. = ..()
	if(tool.use_tool(src, user, 40, volume=100))
		disassemble_wall()
		return TRUE

/turf/closed/wall/proc/disassemble_wall()
	playsound(src, 'sound/effects/wooddoorhit.ogg', 100, TRUE)
	var/newgirder = break_wall()
	if(newgirder) //maybe we don't /want/ a girder!
		transfer_fingerprints_to(newgirder)
	for(var/obj/O in src.contents) //Eject contents!
		if(istype(O, /obj/structure/sign/poster))
			var/obj/structure/sign/poster/P = O
			INVOKE_ASYNC(P, TYPE_PROC_REF(/obj/structure/sign/poster, roll_and_drop), src)
	if(decon_type)
		ChangeTurf(decon_type, flags = CHANGETURF_INHERIT_AIR)
	else
		ScrapeAway()
	QUEUE_SMOOTH_NEIGHBORS(src)
