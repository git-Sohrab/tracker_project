note
	description: "A phase in the nuclear waste tracking system."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PHASE

inherit

	COMPARABLE
		redefine
			out
		end

create
	make

feature {NONE} -- Initialization

	make (pid: STRING; phase_name: STRING; cap: INTEGER_64; e_materials: ARRAY [INTEGER_64])
		do
			create id.make_from_string (pid)
			create name.make_from_string (phase_name)
			capacity := cap.as_integer_32
			container_count := 0
			create expected_materials.make_from_array (e_materials)
		end

feature -- attributes

	id: STRING -- phsae identification

	name: STRING -- phase name

	capacity: INTEGER -- phase capacity

	container_count: INTEGER -- current containers in phase

	rad_count: VALUE -- perliminary radiation count

	expected_materials: ARRAY [INTEGER_64] -- materials expected by phase

	materials: MATERIALS

feature -- commands

	add_material (rad: VALUE)
		do
			rad_count := rad_count + rad
			container_count := container_count + 1
		end

	remove_material (rad: VALUE)
		do
			rad_count := rad_count - rad
			container_count := container_count - 1
		end

feature -- queries

	accepts_material (material: INTEGER): BOOLEAN
		do
			Result := expected_materials.has (material)
		end

	will_exceed_capacity: BOOLEAN
		do
			Result := (1 + container_count) > capacity
		end

	out: STRING
		do
			create Result.make_from_string ("    " + id + "->" + name + ":" + capacity.out + "," + container_count.out + "," + rad_count.out + "," + materials_list)
		end

	materials_list: STRING
		local
			i: INTEGER
		do
			create Result.make_from_string ("{" + materials.m.at (expected_materials.at (1).as_integer_32).out) -- append the first material in list
				-- then append the rest
			from
				i := 2
			until
				i > expected_materials.count
			loop
				Result.append ("," + materials.m.at (expected_materials.at (i).as_integer_32).out)
				i := i + 1
			end
			Result.append ("}")
		end

	infix "<" (other: like Current): BOOLEAN
		do
			Result := current.id.is_less (other.id)
		end

end
