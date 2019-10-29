note
	description: "Manager class of the operations and the undo-redo lists."
	author: "S Oryakhel"
	date: "$Date$"
	revision: "$Revision$"

class
	OPERATION_MANAGER

create
	make

feature

	make
		do
			create undo_list.make (20)
			create redo_list.make (20)
		end

feature -- attributes

	undo_list: ARRAYED_STACK [detachable OPERATION]

	redo_list: ARRAYED_STACK [detachable OPERATION]

feature -- commands

	execute_command (command: OPERATION)
		do
			command.execute
			undo_list.put (command) -- after execution, put command in undo list
			redo_list.wipe_out -- clear redo list
		ensure
			undo_list.has (command)
			undo_list.count > old undo_list.count
		end

	undo
		do
			check attached undo_list.item as cmd then -- check to see if item to undo is not void
				cmd.undo
				redo_list.put (cmd) -- put undone command in redo list for possible redoing
				if undo_list.count > 0 then
					undo_list.remove
				end -- cannot remove from undo list if its empty
			end
		ensure
			redo_list.count > old redo_list.count
			undo_list.count < old undo_list.count
		end

	redo
		do
			check attached redo_list.item as cmd then -- check to see if item to redo is not void
				cmd.redo
				undo_list.put (cmd) -- put redone command in undo list for possible undoing
				if redo_list.count > 0 then
					redo_list.remove
				end -- cannot remove from redo list if its empty
			end
		ensure
			redo_list.count < old redo_list.count
			undo_list.count > old undo_list.count
		end

	clear_lists
		do
			undo_list.wipe_out
			redo_list.wipe_out
		end

end
