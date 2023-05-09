# hypermesh 2021
*createmarkpanel comps 1 "select the comps"
set compsId [hm_getmark comps 1]
if {$compsId == []} { return [] }
set voxelSize [hm_getfloat "VoxelSize" "input string"]

if {$voxelSize == 0.0} {
	return
}

 proc mesh2Voxel {compId voxelSize {mode 3}} {
	*voxel_lattice_hex_mesh_init $voxelSize
	*voxel_lattice_hex_mesh_fill_voids 1
	*createmark comps 1 $compId
	*voxel_lattice_hex_mesh_add_entities comps 1 $mode
	*voxel_lattice_hex_mesh_create
 }
 
 foreach compId $compsId {
	mesh2Voxel $compId $voxelSize
	*createmark components 1 "^voxelizerTesslation"
	*deletemark components 1
} 