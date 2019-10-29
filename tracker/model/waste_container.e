note
	description: "A container of nuclear waste."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	WASTE_CONTAINER

inherit

	COMPARABLE
		redefine
			out
		end

create
	make

feature {NONE} -- creation

	make (cid: STRING; c: TUPLE [material: INTEGER; radioactivity: VALUE]; p_id: STRING)
		do
			create id.make_from_string (cid)
			create pid.make_from_string (p_id)
			material := c.material
			rad_count := c.radioactivity
		end

feature -- attributes

	id: STRING -- container identification

	pid: STRING -- phase identification

	rad_count: VALUE -- perliminary radiation count

	material: INTEGER -- material in container

	materials: MATERIALS

feature -- commands

	transfer_to_phase (p: STRING)
		do
			pid := p
		end

feature -- queries
	-- getters below are for information hidding.

	get_material: STRING
		do
			create Result.make_from_string (materials.m.at (material))
		end

	out: STRING
		do
			create Result.make_from_string ("    " + id.out + "->" + pid.out + "->" + materials.m.at (material) + "," + rad_count.out)
		end
			-- Comparable. Comparing the ids of containers

	infix "<" (other: like Current): BOOLEAN
		do
			Result := current.id.is_less (other.id)
		end

end
