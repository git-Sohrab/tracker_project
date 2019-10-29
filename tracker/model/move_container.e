note
	description: "Summary description for {MOVE_CONTAINER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MOVE_CONTAINER

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

	make (args: TUPLE [c_id: STRING; p_id1: STRING; p_id2: STRING])
		do
			Precursor ([])
			i := model.i
			cid := args.c_id
			pid1 := args.p_id1
			pid2 := args.p_id2
			prev_status := model.status
		end

feature{NONE} -- attributes

	cid: STRING

	pid1: STRING

	pid2: STRING

feature -- commands

	execute
		do
				-- check for invalid input errors
			if not model.containers.has (cid) then
				model.set_status (model.errors.e15)
			elseif pid1.is_equal (pid2) then
				model.set_status (model.errors.e16)
			elseif not (model.phases.has (pid1) and model.phases.has (pid2)) then
				model.set_status (model.errors.e9)
			else
					-- check to see if execution will result in error
				if attached model.phases.item (pid1) as ph1 and attached model.phases.item (pid2) as ph2 and attached model.containers.item (cid) as cn then
					if not cn.pid.is_equal (pid1) then
						model.set_status (model.errors.e17)
					elseif ph2.will_exceed_capacity then
						model.set_status (model.errors.e11)
					elseif ph2.rad_count + cn.rad_count > model.max_phase_radiation then
						model.set_status (model.errors.e12)
					elseif not ph2.accepts_material (cn.material) then
						model.set_status (model.errors.e13)
					else
						cn.transfer_to_phase (pid2) -- move container to this phase
						ph1.remove_material (cn.rad_count) -- remove container from old phase
						ph2.add_material (cn.rad_count)
						model.set_status (model.errors.ok) -- set status to ok
						input_incorrect := false -- input is correct
					end
				end
			end
		end

	undo
		do
			if not input_incorrect then
				if attached model.phases.item (pid1) as ph1 and attached model.phases.item (pid2) as ph2 and attached model.containers.item (cid) as cn then
					cn.transfer_to_phase (pid1) -- move container to this phase
					ph1.add_material (cn.rad_count)
					ph2.remove_material (cn.rad_count) -- remove container from old phase
				end
			end
			model.set_status (prev_status) -- set status to previous
		end

	redo
		do
			execute
		end

end
