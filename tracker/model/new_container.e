note
	description: "Summary description for {NEW_CONTAINER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	NEW_CONTAINER

inherit

	OPERATION
		redefine
			make,
			execute,
			undo,
			redo
		end

create
	make

feature -- creation

	make (args: TUPLE [cid: STRING; mat: INTEGER_64; rad: VALUE; pid: STRING])
		do
			Precursor ([])
			i := model.i
			container_ID := args.cid
			material := args.mat.as_integer_32
			radiation_count := args.rad
			phase_ID := args.pid
			prev_status := model.status
		end

feature{NONE} -- attributes

	container_ID: STRING

	material: INTEGER

	radiation_count: VALUE

	phase_id: STRING

feature -- commands

	execute
		do
				-- check for invalid input errors
			if not container_ID.at (1).is_alpha_numeric then
				model.set_status (model.errors.e5)
			elseif model.containers.has (container_ID) then
				model.set_status (model.errors.e10)
			elseif not phase_ID.at (1).is_alpha_numeric then
				model.set_status (model.errors.e5)
			elseif not model.phases.has (phase_ID) then
				model.set_status (model.errors.e9)
			elseif radiation_count < 0.000 then
				model.set_status (model.errors.e18)
			else
					-- check to see if execution will result in error
				if attached model.phases.item (phase_ID) as ph then
					if ph.will_exceed_capacity then
						model.set_status (model.errors.e11)
					elseif radiation_count > model.max_container_radiation then
						model.set_status (model.errors.e14)
					elseif ph.rad_count + radiation_count > model.max_phase_radiation then
						model.set_status (model.errors.e12)
					elseif not ph.accepts_material (material) then
						model.set_status (model.errors.e13)
					else
						model.containers.put (create {WASTE_CONTAINER}.make (container_ID, [material, radiation_count], phase_ID), container_ID)
						ph.add_material (radiation_count)
						model.set_status (model.errors.ok) -- set status to ok
						input_incorrect := false -- input is correct
					end
				end
			end
		end

	undo
		do
			if not input_incorrect then
				if attached model.phases.item (phase_ID) as ph then
					model.containers.remove (container_ID) -- remove container from containers list
					ph.remove_material (radiation_count) -- remove container from phase
				end
			end
			model.set_status (prev_status) -- set status to previous
		end

	redo
		do
			execute
		end

end
