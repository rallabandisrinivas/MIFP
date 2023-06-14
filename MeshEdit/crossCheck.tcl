# Hypermesh2021



# Hypermesh 语法格式
# *tetmesh entity_type1 mark_id1 mode1 entity_type2 mark_id2 mode2 string_array number_of_strings
# mode1
	# -1 - Ignored (inactive input)
	# 0 - Float without boundary layer
	# 1 - Fixed without boundary layer
	# 2 - Float with boundary layer
	# 3 - Fixed with boundary layer
	# 4 - Size control boxes
	# 5 - Anchor nodes
	# 6 - 3D re-mesh
	# 7 - 3D re-mesh with free boundary swappable-float.
	# 8 - 3D re-mesh with free boundary remeshable-float.
	# 9 - Remeshable-float without BL
	# 10 - Remeshable-float with BL,
	# 11 - Elem input for fluid volume selection. Either touched (or normal pointed into) are fluid volumes.
# mode2
	# -1 - Ignored (inactive input)
	# 0 - Float without boundary layer
	# 1 - Fixed without boundary layer
	# 2 - Float with boundary layer
	# 3 - Fixed with boundary layer
	# 4 - Size control boxes
	# 5 - Anchor nodes
	# 6 - 3D re-mesh
	# 7 - 3D re-mesh with free boundary swappable-float.
	# 8 - 3D re-mesh with free boundary remeshable-float.
	# 9 - Remeshable-float without BL
	# 10 - Remeshable-float with BL,
	# 11 - Elem input for fluid volume selection. Either touched (or normal pointed into) are fluid volumes.

proc crossCheck {elemMarkId } {
	*createstringarray 1 "shchk: 49 0.001 0.5"
	*tetmesh elements $elemMarkId 3 elements $elemMarkId 1 1 1
}
*createmark elements 2 170758-208455

