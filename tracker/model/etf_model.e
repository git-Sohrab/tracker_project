note
	description: "A default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_MODEL

inherit

	ANY
		redefine
			out
		end

create {ETF_MODEL_ACCESS}
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			i := 0
			create status.make_from_string ("ok")
			create phases.make (0)
			create containers.make (0)
			create command_manager.make
		end

feature -- model attributes

	i: INTEGER

	phases: HASH_TABLE [PHASE, STRING]

	max_phase_radiation: VALUE

	containers: HASH_TABLE [WASTE_CONTAINER, STRING]

	max_container_radiation: VALUE

	materials: MATERIALS

	errors: ERRORS

	status: STRING -- ouput status. either "ok" or one of e1 to e20

	use_past_state: BOOLEAN -- a state representing whether or not we use the substring "(to x)" in output

	command_manager: OPERATION_MANAGER

	i_of_nt: INTEGER -- integer representing the state (i) of new_tracker command

feature -- model operations

	default_update
			-- Perform update to the model state.
		do
			i := i + 1
		end

	reset
			-- Reset model state.
		do
			make
		end

	new_tracker (m_p_r: VALUE; m_c_r: VALUE)
		do
			default_update
			command_manager.execute_command (create {NEW_TRACKER}.make ([m_p_r, m_c_r]))
			if i_of_nt > 0 then
				command_manager.clear_lists
			end
			set_past_state (false)
		end

	new_phase (pid: STRING; pn: STRING; cap: INTEGER_64; em: ARRAY [INTEGER_64])
		do
			default_update
			command_manager.execute_command (create {NEW_PHASE}.make ([pid, pn, cap, em]))
			set_past_state (false) -- do not use "(to x)" in output
		end

	new_container (cid: STRING; c: TUPLE [material: INTEGER_64; radioactivity: VALUE]; pid: STRING)
		do
			default_update
			command_manager.execute_command (create {NEW_CONTAINER}.make ([cid, c.material, c.radioactivity, pid]))
			set_past_state (false) -- do not use "(to x)" in output
		end

	move_container (cid: STRING; pid1: STRING; pid2: STRING)
		do
			default_update
			command_manager.execute_command (create {MOVE_CONTAINER}.make ([cid, pid1, pid2]))
			set_past_state (false) -- do not use "(to x)" in output
		end

	remove_phase (pid: STRING)
		do
			default_update
			command_manager.execute_command (create {REMOVE_PHASE}.make ([pid]))
			set_past_state (false) -- do not use "(to x)" in output
		end

	remove_container (cid: STRING)
		do
			default_update
			command_manager.execute_command (create {REMOVE_CONTAINER}.make ([cid]))
			set_past_state (false) -- do not use "(to x)" in output
		end

	undo
		do
			set_past_state (true) -- use "(to x)" in output
			default_update
			if command_manager.undo_list.count > 0 then
				command_manager.undo
			else
				set_status (errors.e19)
				set_past_state (false)
			end
		end

	redo
		do
			set_past_state (true) -- use "(to x)" in output
			default_update
			if command_manager.redo_list.count > 0 then
				command_manager.redo
			else
				set_status (errors.e20)
				set_past_state (false)
			end
		end

	set_status (s: STRING) -- setter for output status
		do
			status := s
		end

	set_max_radiation (mpr: VALUE; mcr: VALUE) -- setter for max radiation use by new_tracker command
		do
			max_phase_radiation := mpr
			max_container_radiation := mcr
		end

	set_past_state (b: BOOLEAN) -- setter for allowing us to use the past state substring "(to x)" in output
		do
			use_past_state := b
		end

	set_iont (f: INTEGER)
		do
			i_of_nt := f
		end

feature -- queries

	to_state: STRING
		local
			ps: INTEGER
		do
			if command_manager.undo_list.count > 0 then
				check attached command_manager.undo_list.item as cmd then
					ps := cmd.i
				end
			else
				ps := i_of_nt
			end
			if use_past_state then
				create Result.make_from_string ("(to " + ps.out + ") ")
			else
				create Result.make_empty
			end
		end

	print_phases: STRING
		local
			sorted_list: SORTED_TWO_WAY_LIST [STRING]
			pids: ARRAY [STRING]
		do
			create Result.make_from_string ("")
			create sorted_list.make
			create pids.make_from_array (phases.current_keys)

				-- add phase IDs to sorted list

			across
				pids as pid
			loop
				sorted_list.extend (pid.item)
			end

				-- use sorted list of phase IDs to print the phases

			across
				sorted_list as phase
			loop
				if attached phases.item (phase.item) as ph then
					Result.append (ph.out)
					Result.append ("%N")
				end
			end
		end

	print_containers: STRING
		local
			sorted_list: SORTED_TWO_WAY_LIST [STRING]
			cids: ARRAY [STRING]
		do
			create Result.make_from_string ("")
			if containers.count > 0 then
				create sorted_list.make
				create cids.make_from_array (containers.current_keys)

					-- add container IDs to sorted list

				across
					cids as cid
				loop
					sorted_list.extend (cid.item)
				end

					-- use sorted list of container IDs to print the containers

				across
					sorted_list as c
				loop
					if attached containers.item (c.item) as co then
						Result.append ("%N")
						Result.append (co.out)
					end
				end
			end
		end

	out: STRING
		do
			create Result.make_from_string ("  state " + i.out)
			Result.append (" " + to_state + status)
			if status.is_equal (errors.ok) then
				Result.append ("%N")
				Result.append ("  max_phase_radiation: " + max_phase_radiation.out + ", max_container_radiation: " + max_container_radiation.out + "%N")
				Result.append ("  phases: pid->name:capacity,count,radiation" + "%N")
				Result.append (print_phases)
				Result.append ("  containers: cid->pid->material,radioactivity")
				Result.append (print_containers)
			end
		end

end
