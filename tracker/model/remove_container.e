note
	description: "Summary description for {REMOVE_CONTAINER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REMOVE_CONTAINER

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

	make (args: TUPLE [c_id: STRING])
		do
			Precursor ([])
			i := model.i
			cid := args.c_id
			check attached model.containers.item (cid) as cn then
				container := cn
				check attached model.phases.item (cn.pid) as ph then
					phase := ph
				end
			end
			prev_status := model.status
		end

feature{NONE} -- attributes

	cid: STRING

	phase: PHASE

	container: WASTE_CONTAINER

feature -- commands

	execute
		do
			if not model.containers.has (cid) then
				model.set_status (model.errors.e15)
			else
				if attached model.containers.item (cid) as cn then
					if attached model.phases.item (cn.pid) as ph then
						ph.remove_material (cn.rad_count) -- remove container from phase
						model.containers.remove (cid) -- remove from containers hash map
						model.set_status (model.errors.ok) -- set status to ok
						input_incorrect := false
					end
				end
			end
		end

	undo
		do
			if not input_incorrect then
				phase.add_material (container.rad_count) -- add material to phase
				model.containers.put (container, cid) -- add container to containers list
			end
			model.set_status (prev_status) -- set status to previous
		end

	redo
		do
			execute
		end

end
