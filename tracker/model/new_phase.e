note
	description: "Summary description for {NEW_PHASE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	NEW_PHASE

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

	make (args: TUPLE [pid: STRING; pn: STRING; cap: INTEGER_64; em: ARRAY [INTEGER_64]])
		do
			Precursor ([])
			i := model.i
			phase_id := args.pid
			phase_name := args.pn
			capacity := args.cap
			expected_materials := args.em
			prev_status := model.status
		end

feature{NONE} -- attributes

	phase_id: STRING

	phase_name: STRING

	capacity: INTEGER_64

	expected_materials: ARRAY [INTEGER_64]

feature -- commands

	execute
		do
				-- check for invalid input errors
			if model.containers.count > 0 then
				model.set_status (model.errors.e1)
			elseif not phase_id.at (1).is_alpha_numeric then
				model.set_status (model.errors.e5)
			elseif model.phases.has (phase_id) then
				model.set_status (model.errors.e6)
			elseif not phase_name.at (1).is_alpha_numeric then
				model.set_status (model.errors.e5)
			elseif capacity < 1 then
				model.set_status (model.errors.e7)
			elseif expected_materials.count < 1 then
				model.set_status (model.errors.e8)
			else
				model.phases.put (create {PHASE}.make (phase_id, phase_name, capacity, expected_materials), phase_id)
				model.set_status (model.errors.ok) -- set status to ok
				input_incorrect := false -- input is correct
			end
		end

	undo
		do
			if not input_incorrect then
				model.phases.remove (phase_id) -- remove phase from phases list
			end
			model.set_status (prev_status) -- set status to previous
		end

	redo
		do
			execute
		end

end
