/datum/antagonist/starfuryop
	name = "Syndicate Operative"
	roundend_category = "starfury battlecruiser operatives"
	antagpanel_category = "Starfury Operative"
	job_rank = ROLE_TRAITOR
	antag_hud_type = ANTAG_HUD_OPS
	antag_hud_name = "synd"
	var/datum/team/starfuryop/sbccrew
	show_to_ghosts = TRUE

/datum/antagonist/starfuryop/apply_innate_effects(mob/living/mob_override)
	var/mob/living/M = mob_override || owner.current
	add_antag_hud(antag_hud_type, antag_hud_name, M)

/datum/antagonist/starfuryop/remove_innate_effects(mob/living/mob_override)
	var/mob/living/M = mob_override || owner.current
	remove_antag_hud(antag_hud_type, M)

/datum/antagonist/starfuryop/greet()
	owner.current.playsound_local(get_turf(owner.current), 'sound/ambience/antag/ops.ogg',100,0) //temporary
	owner.announce_objectives()

/datum/antagonist/starfuryop/get_team()
	return sbccrew

/datum/antagonist/starfuryop/create_team(datum/team/starfuryop/new_team)
	if(!new_team)
		for(var/datum/antagonist/starfuryop/P in GLOB.antagonists)
			if(!P.owner)
				continue
			if(P.sbccrew)
				sbccrew = P.sbccrew
				return
		sbccrew = new /datum/team/starfuryop
		sbccrew.forge_objectives()
		return
	if(!istype(new_team))
		stack_trace("Wrong team type passed to [type] initialization.")
	sbccrew = new_team

/datum/antagonist/starfuryop/on_gain()
	forge_objectives()
	. = ..()

/datum/team/starfuryop
	name = "Starfury Battle Cruiser Operatives"

/datum/team/starfuryop/proc/add_objective(datum/objective/O, needs_target = FALSE)
	O.team = src
	O.update_explanation_text()
	objectives += O

/datum/antagonist/starfuryop/proc/forge_objectives()
	if(sbccrew)
		objectives |= sbccrew.objectives

/datum/team/starfuryop/proc/forge_objectives()
	add_objective(new/datum/objective/syndicatesupermatter, TRUE)
	var/datum/objective/chaos = new
	chaos.name = "Cause Chaos"
	chaos.team_explanation_text = "Cause as much destruction as possible."
	chaos.explanation_text = chaos.team_explanation_text
	chaos.completed = 1
	add_objective(chaos, TRUE)

/datum/team/starfuryop/roundend_report()
	var/list/parts = list("<span class='header'>The crew of the Syndicate battle cruiser were:</span>")
	for(var/datum/mind/M in members)
		parts += printplayer(M)
	var/win = TRUE
	var/objective_count = 1
	for(var/datum/objective/objective in objectives)
		if(objective.check_completion())
			parts += "<B>Objective #[objective_count]</B>: [objective.explanation_text] <span class='greentext'>Success!</span>"
		else
			parts += "<B>Objective #[objective_count]</B>: [objective.explanation_text] <span class='redtext'>Fail.</span>"
			win = FALSE
		objective_count++
	if(win)
		parts += "<span class='greentext'>Crew of the Syndicate battle cruiser was successful!</span>"
	else
		parts += "<span class='redtext'>Crew of the Syndicate battle cruiser has failed!</span>"

	return "<div class='panel redborder'>[parts.Join("<br>")]</div>"
