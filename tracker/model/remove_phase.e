note
	description: "Summary description for {REMOVE_PHASE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REMOVE_PHASE

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

	make (args: TUPLE [p_id: STRING])
		do
			Precursor ([]) -- call to superclass
			i := model.i -- set the i (state value) of this command
			pid := args.p_id
			check attached model.phases.at (pid) as ph then -- save the phase for undoing
				phase := ph
			end
			prev_status := model.status -- set previous output status incase we undo this command
		end

feature{NONE} -- attributes

	pid: STRING -- phase id for removal

	phase: PHASE -- phase for undoing removal

feature -- commands

	execute
		do
			if model.containers.count > 0 then
				model.set_status (model.errors.e1) -- current tracker in use
			elseif not model.phases.has (pid) then
				model.set_status (model.errors.e9) -- phase id not in system
			else
				model.phases.remove (pid) -- remove the phase from the phases list
				model.set_status (model.errors.ok) -- set status to ok
				input_incorrect := false -- input is correct
			end
		end

	undo
		do
			if not input_incorrect then
				model.phases.put (phase, pid) -- add the phase to the phases list
			end
			model.set_status (prev_status) -- set status to previous
		end

	redo
		do
			execute
		end

end
