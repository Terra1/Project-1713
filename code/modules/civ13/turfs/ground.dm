/turf/open/chasm/planet
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	planetary_atmos = TRUE

/turf/open/openspace/planet
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	planetary_atmos = TRUE

/turf/open/misc/dirt/planet
	name = "dirt"
	desc = "It's dirt."
	baseturfs = /turf/open/chasm/planet
	icon = 'icons/civ13/turf/floors.dmi'
	icon_state = "dirt"
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	planetary_atmos = TRUE

/turf/open/misc/grass/planet
	name = "grass"
	desc = "It's grass."
	baseturfs = /turf/open/misc/dirt/planet
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	planetary_atmos = TRUE

/turf/open/misc/beach/sand/planet
	name = "beach sand"
	desc = "It's beach sand."
	baseturfs = /turf/open/misc/dirt/planet
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
	planetary_atmos = TRUE

/turf/open/misc/beach/sand/planet/desert
	desc = "It's sand."
	icon_state = "desert"

/turf/closed/mineral/random/planet
	baseturfs = /turf/open/misc/dirt/planet
	/* Not doing this for now, we need smooth sprites.
	icon = 'icons/civ13/turf/rocks.dmi'
	icon_state = "rocky"
	*/
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS
