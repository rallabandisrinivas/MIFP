# Hypermesh 2021
# 求两个Comps的单元对称差集，即A△B={x|x∈A∪B,x∉A∩B}

proc {compID_1 compID_2} {
	# 网格布尔求并集
	*createmark components 1 "by id only"  $compID_1
	*createmark components 2 "by id only"  $compID_2
	*remesh_master_slave_boolean components 1 components 2 "do_boolean_difference 0 remove_new_duplicates 1 angle 30 tria_remesh_growth_ratio 1.35 tria_remesh_span_angle 30 use_adaptive_tria_remesh 1 num_remesh_layers 2 keep_intersect_edges 0 break_shell_along_component_boundaries 0"
	
	# 创建对应的new comps，并记录ID
	# 复制单元到new comps
	*createmark elements 1 "by comps id" $compID_1
	*createentitysameas components $compID1
	set compID_1_1 [hm_entitymaxid comps]
	set compName_1_1 [hm_getvalue comps id=$compID_1_1 dataname=name]
	*copymark elements 1 $compName_1_1
	*clearmark elements 1
	
	*createmark elements 1 "by comps id" $compID_1
	*createentitysameas components $compID1
	set compID_1_2 [hm_entitymaxid comps]
	set compName_1_2 [hm_getvalue comps id=$compID_1_2 dataname=name]
	*copymark elements 1 $compName_1_2
	*clearmark elements 1
	
	*createmark elements 1 "by comps id" $compID_2
	*createentitysameas components $compID2
	set compID_2_1 [hm_entitymaxid comps]
	set compName_2_1 [hm_getvalue comps id=$compID_2_1 dataname=name]
	*copymark elements 1 $compName_2_1
	*clearmark elements 1
	
	*createmark elements 1 "by comps id" $compID_2
	*createentitysameas components $compID2
	set compID_2_2 [hm_entitymaxid comps]
	set compName_2_2 [hm_getvalue comps id=$compID_2_2 dataname=name]
	*copymark elements 1 $compName_2_2
	*clearmark elements 1
	
	# 使用New comps中的单元做网格布尔求差集（不变动单元）
	*createmark components 1 "by id only"  $compID_1_1
	*createmark components 2 "by id only"  $compID_2_1
	*remesh_master_slave_boolean components 1 components 2 "do_boolean_difference 1 remove_new_duplicates 1 num_remesh_layers -1 keep_intersect_edges 0 break_shell_along_component_boundaries 0"
	
	*createmark components 1 "by id only"  $compID_1_2
	*createmark components 2 "by id only"  $compID_2_2
	*remesh_master_slave_boolean components 1 components 2 "do_boolean_difference 1 remove_new_duplicates 1 num_remesh_layers -1 keep_intersect_edges 0 break_shell_along_component_boundaries 0"
	
	# 合并两个差集(1_1和2_2)
	*createmark elements 1 "by comps id" $compID_2_2
	*copymark elements 1 $compName_1_1
	*clearmark elements 1
	
	# 删除多余的comps
	*createmark components 1 $compName_1_2
	*deletemark components 1
	
	*createmark components 1 $compName_2_1
	*deletemark components 1
	
	*createmark components 1 $compName_2_2
	*deletemark components 1
	}