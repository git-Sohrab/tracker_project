note
	description: "Summary description for {NEW_TRACKER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	NEW_TRACKER

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

	make (args: TUPLE [m_p_r: VALUE; m_c_r: VALUE])
		do
			Precursor ([])
			i := model.i
			mpr := args.m_p_r
			mcr := args.m_c_r
			prev_status := model.status
		end

feature -- attributes

	mpr: VALUE -- max phase radiation of tracker

	mcr: VALUE -- max container radiation of tracker

feature{NONE} -- commands

	execute
		do
				-- check for invalid input errors
			if model.containers.count > 0 then
				model.set_status (model.errors.e1)
			elseif mpr < 0.000 then
				model.set_status (model.errors.e2)
			elseif mcr < 0.000 then
				model.set_status (model.errors.e3)
			elseif mcr > mpr then
				model.set_status (model.errors.e4)
			else
				model.set_max_radiation (mpr, mcr)
				model.set_status (model.errors.ok) -- set status to ok
				input_incorrect := false -- input is correct
				model.set_iont (i)	-- set the integer representing the state (i) this command
			end
		end

	undo
		do
			if input_incorrect then
				model.set_status (prev_status) -- set status to previous
			else
				model.set_status (model.errors.e19) -- no more undo left
				model.set_past_state (false) -- do not use past state "(to x)" in output
			end
		end

	redo
		do
			if input_incorrect then
				execute
			else
				model.set_status (model.errors.e20) -- no more redo left
				model.set_past_state (false) -- do not use past state "(to x)" in output
			end
		end

end
