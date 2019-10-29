note
	description: "Summary description for {MATERIALS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

expanded class
	MATERIALS

feature

	m: ARRAY[STRING]
		once
			create Result.make_empty
			Result.force ("glass", 1)
			Result.force ("metal", 2)
			Result.force ("plastic", 3)
			Result.force ("liquid", 4)
		end

invariant
	m = m

end
