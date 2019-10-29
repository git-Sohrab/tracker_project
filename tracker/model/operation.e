note
	description: "deferred class representing the common operations of the program."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	OPERATION

feature

	make (arg: TUPLE [])
		local
			model_access: ETF_MODEL_ACCESS
		do
			model := model_access.m
			input_incorrect := true
		end

feature

	i: INTEGER

	model: ETF_MODEL

	prev_status: STRING

	input_incorrect: BOOLEAN

feature

	execute
		deferred
		end

	undo
		deferred
		end

	redo
		deferred
		end
invariant
	model = model

end
