# 代码测试

# 函数：创建线线弹性材料(名称, 弹性模量, 泊松比)->材料ID
proc createElasticMaterial {mat_name value_E value_NU} {
	
	# 删除同名材料
	catch {
		hm_createmark materials 1 "by name only" "$mat_name"
		*deletemark materials 1
	}
	
	# 创建材料
	*collectorcreate materials "$mat_name" "" 11
	hm_createmark materials 1 "by name only" "$mat_name"
	set mat_id [hm_getmark materials 1]
	*setvalue mats id=$mat_id cardimage="ABAQUS_MATERIAL"
	
	# 设置材料类型：Elastic
	*setvalue mats id=$mat_id STATUS=2 104=1
	# 设置模量和泊松比
	*setvalue mats id=$mat_id STATUS=2 3=$value_E
	*setvalue mats id=$mat_id STATUS=2 4=$value_NU

	return $mat_id
}

# 函数：创建Solid截面属性（材料名称）->属性ID
proc create_properties_solid {mat_name} {
	
	# 删除同名属性
	catch {
		hm_createmark properties 1 "by name only" "$mat_name"
		*deletemark properties 1
	}
	
	*collectorcreate properties "$mat_name" "$mat_name" 11
	hm_createmark properties 1  "$mat_name"
	set prop_id [hm_getmark properties 1]
	
	# 设置截面类型：SOLIDSECTION
	*setvalue props id=$prop_id cardimage="SOLIDSECTION"
	return $prop_id
}

# 函数：创建接触对属性（材料名称）->属性ID
proc create_properties_contact {name} { 
	# 删除同名属性
	catch {
		hm_createmark properties 1 "by name only" "$name"
		*deletemark properties 1
	}
	set propCont_id [hm_entityinfo maxid props]
	*createentity props cardimage=SURFACE_INTERACTION includeid=0 name=$name
	*setvalue props id=$propCont_id STATUS=2 336=1
	*setvalue props id=$propCont_id STATUS=2 83=0
	*setvalue props id=$propCont_id STATUS=2 337=1
	*setvalue props id=$propCont_id STATUS=2 4705=0
	*setvalue props id=$propCont_id STATUS=2 2353=0
	*setvalue props id=$propCont_id STATUS=2 4579=0
	*setvalue props id=$propCont_id STATUS=2 337=2
	*setvalue props id=$propCont_id STATUS=2 64=1
	*setvalue props id=$propCont_id STATUS=2 1888=1
	*setvalue props id=$propCont_id STATUS=2 334=0
	*setvalue props id=$propCont_id STATUS=2 93=0
	*setvalue props id=$propCont_id STATUS=2 78=0
	*setvalue props id=$propCont_id STATUS=2 95=0
	*setvalue props id=$propCont_id STATUS=0 133=1
	*setvalue props id=$propCont_id STATUS=2 108={0}
	*setvalue props id=$propCont_id STATUS=2 116={0}
	*setvalue props id=$propCont_id STATUS=2 122={0}
	*setvalue props id=$propCont_id STATUS=2 123={0}
	return $propCont_id
	}

proc creatCompMesh {compId index} {
	# 设置Component的材料、网格划分
	
	if {$index == 0} {
			set suffix "_Bot"
			set color #7F7F7F
			set mat_id $::Test::matHold_id
			set mesh $::Test::mesh3D
		}
	if {$index == 1} {
			set suffix "_Top"
			set color #7F7F7F
			set mat_id $::Test::matHold_id
			set mesh $::Test::mesh3D
		}
	if {$index == 2} {
			set suffix "_Frame"
			set color #F79646
			set mat_id $::Test::matFrame_id
			set mesh $::Test::mesh2D
		}
	if {$index == 3} {
			set suffix "_Porous"
			set color #9BBB59
			set mat_id $::Test::matPorous_id
			set mesh $::Test::mesh2D
		}

	set cName "$::Test::prefix$::Test::stpName$suffix"
	catch {
		*setvalue comps id=$compId name=$cName
	}
	catch {
		*setvalue comps id=$compId color=$color 
	}
	catch {
		*setvalue comps id=$compId materialid=$mat_id
	}
	catch {
		*setvalue comps id=$compId propertyid=$mat_id
	}
	
	*startnotehistorystate {isolateonly Component $cName}
	*createmark components 2 $cName
	*createstringarray 2 "elements_on" "geometry_on"
	*showentitybymark 3 1 2
	# 网格划分
	catch {
	
		if {$mesh == $::Test::mesh3D} {
			# 3D网格划分
			*createmark solids 1 $compId
			*createstringarray 3 "pars: post_cln fix_comp_bdr tet_clps='0.100000,1.000000,0' max_size='0,0,1.79769e+308'" \
			"tet: 355 1.3 -1 0 0.8 0 0" "2d: 1 0 4 2.5 0.5 30 1"
			*tetmesh solids 1 1 elements 0 -1 1 3
			puts \t网格划分:$cName
			}
			
		if {$mesh == $::Test::mesh2D} {
			# 2D网格划分
			set surfList [hm_getsurfacesfromsolid $compId]
			set minId [lindex $surfList 0]
			set maxId [lindex $surfList end]
			*setedgedensitylinkwithaspectratio -1
			*elementorder 1
			*createmark surfaces 1 $minId-$maxId
			*interactiveremeshsurf 1 0.3 0 0 2 1 1
			set i 0
			foreach surfId $surfList {
				set params [hm_getsurfaceedges $surfId]
				set shape_type [llength [split $params]]
				catch {
					*set_meshfaceparams $i 2 0 0 0 1 0.3 1 1
					*automesh $i 2 0
				}
				catch {
					*set_meshfaceparams $i 5 0 0 0 1 0.3 1 1
					*automesh $i 5 0
				}
				catch {
					*set_meshfaceparams $i 3 0 0 0 1 0.3 1 1
					*automesh $i 3 0
				}
				incr i 1
				}
			*storemeshtodatabase 1
			*ameshclearsurface 
			puts \t网格划分:$cName
			}
	}
	
	*hideentitybymark 3 1 2
	*isolateonlyentitybymark 2 1 2
	*endnotehistorystate {isolateonly Component $cName}
}

proc meshSet {partId} {
	# 设置Part下Comps的网格：网格布尔、Group设置等
	set compID [hm_getvalue modules id = $partId dataname = HW_CID]
	
	# 网格布尔
	*clearmark components 2
	*clearmark components 1
	set index 0
	foreach cID $compID {
		# 对Part下的Component循环
		if {$index == 2} {
		set cName1 [hm_getvalue comps id=$cID dataname=name]
			*createmark components 1 $cName1
		}
		if {$index == 3} {
		set cName2 [hm_getvalue comps id=$cID dataname=name]
			*createmark components 2 $cName2
		}
		incr index 1
	}
	catch {
		*remesh_master_slave_boolean components 1 components 2 "do_boolean_difference 0 remove_new_duplicates 1 angle 30 tria_remesh_growth_ratio 1.35 tria_remesh_span_angle 30 use_adaptive_tria_remesh 1 num_remesh_layers 1 keep_intersect_edges 0 break_shell_along_component_boundaries 0"
		puts \t网格布尔:$cName2,$cName1
		}                       
	
	# 2D网格->3D网格划分
	catch {
		*createstringarray 2 "pars: upd_shell fix_comp_bdr tet_clps='0.100000,1.000000,0' max_size='0,0,1.79769e+308'" "tet: 611 1.3 -1 0 0.5 0 0"
		*createmark elements 2 "by collector" $cName1 $cName2
		*tetmesh elements 2 1 elements 0 -1 1 2
	
		# 删除2D网格
		*clearmark elements 2 
		*createmark elements 2 "by config" tria3 quad4
		*deletemark elements 2
		puts \t网格2D转3D，删除2D网格
		}
	
	# 删除错误网格
	foreach set [hm_entitylist sets name] {
		set setName $set
		if {[lindex [split $set {}] 0] == "^"} {
			*clearmark sets 1
			*createmark sets 1 $setName
			*deletemark sets 1
		}
	}
	
}

proc createContactPair {name masterId masterId propContId} {
	# 设置接触对
	set ContPairId [expr [hm_entityinfo maxid group]+1]
	*createentity groups cardimage=CONTACT_PAIR includeid=0 name=$name
	*setvalue groups id=$ContPairId masterentityids={sets $masterId}
	*setvalue groups id=$ContPairId slaveentityids={sets $masterId}
	*setvalue groups id=$ContPairId STATUS=2 81={props $propContId}
	# 设置小滑移
	*setvalue groups id=$ContPairId STATUS=2 323=1
	*setvalue groups id=$ContPairId STATUS=2 2122=2
	*setvalue groups id=$ContPairId STATUS=2 2123=0
	return $ContPairId
}

proc createContactCtrl {name masterId slaveId} {
	# 设置接触控制
	set CtrlId [expr [hm_entityinfo maxid group]+1]
	*createentity groups cardimage=CONTACT_CONTROLS includeid=0 name=$name
	# 设置主从面
	*setvalue groups id=$CtrlId STATUS=2 2109=1
	*setvalue groups id=$CtrlId STATUS=2 2110={sets $masterId}
	*setvalue groups id=$CtrlId STATUS=2 2115=1
	*setvalue groups id=$CtrlId STATUS=2 2116={sets $slaveId}
	# 设置稳定因数
	*setvalue groups id=$CtrlId STATUS=2 4366=1
	*setvalue groups id=$CtrlId STATUS=2 4377=1
	*setvalue groups id=$CtrlId STATUS=2 4367=1
	return $CtrlId
}

# 变量空间
namespace eval ::Test {
	
	# Part id列表
	variable modulesIDList [hm_entitylist modules id]
	# 删除第一个partId(祖Modules)
	variable modulesIDList [lrange $modulesIDList 1 end]
	variable prefix RT05_
	
	# 记录ID
	variable RP_LoadId
	variable RP_BCId
	variable Node_LoadId
	variable Node_BCId
	
	variable LoadId
	variable BCId
	
	variable Surf_Hold_TopId
	variable Surf_Hold_BotId
	variable Surf_Hold_SideId
	variable Surf_Frame_TopId
	variable Surf_Frame_BotId
	variable Surf_Frame_SideId
	variable Surf_Porous_TopId
	variable Surf_Porous_BotId
	
	variable cont_Frame_TopId
	variable cont_Frame_BotId
	variable cont_Frame_SideId
	variable cont_Porous_TopId
	variable cont_Porous_BotId
	
	variable ctrl_Frame_TopId
	variable ctrl_Frame_BotId
	variable ctrl_Frame_SideId
	variable ctrl_Porous_TopId
	variable ctrl_Porous_BotId
	
	variable stepId
	
	variable fieldOutputId
	variable historyOutputId
	
	# 创建材料/属性
	variable matHold_id [createElasticMaterial "Hold" 220000 0.3]
	variable propHold_id [create_properties_solid "Hold"]

	variable matFrame_id [createElasticMaterial "Frame" 114000 0.3]
	variable propFrame_id [create_properties_solid "Frame"]

	variable matPorous_id [createElasticMaterial "Porous" 1985.96 0.3]
	variable propPorous_id [create_properties_solid "Porous"]
	
	variable propCont_id [create_properties_contact "Cont"]
	# 网格划分设置
	variable mesh3D mesh3D
	variable mesh2D mesh2D
}

# 创建参考点
catch {
	set nodeId [expr [hm_entityinfo maxid node]+1]
	set ::Test::RP_LoadId [expr [hm_entityinfo maxid set]+1]
	*createnode 0 6 20 0 0 0
	*createentity sets cardimage=NSET includeid=0 name="RP_Load"
	*setvalue sets id=$::Test::RP_LoadId ids=$nodeId
	}

catch {
	set nodeId [expr [hm_entityinfo maxid node]+1]
	set ::Test::RP_BCId [expr [hm_entityinfo maxid set]+1]
	*createnode 0 6 -20 0 0 0
	*createentity sets cardimage=NSET includeid=0 name="RP_BC"
	*setvalue sets id=$::Test::RP_BCId ids=$nodeId
	}
	
# 创建NodeSet
catch {
	set ::Test::Node_LoadId [expr [hm_entityinfo maxid set]+1]
	*createentity sets cardimage=SURFACE_NODE includeid=0 name="Node_Load"
	}
	
catch {
	set ::Test::Node_BCId [expr [hm_entityinfo maxid set]+1]
	*createentity sets cardimage=SURFACE_NODE includeid=0 name="Node_BC"
	}

# 创建SurfSet	
catch {
	set ::Test::Surf_Hold_TopId [expr [hm_entityinfo maxid set]+1]
	*createentity sets cardimage=SURFACE_ELEMENT includeid=0 name="Surf_Hold_Top"
	}
	
catch {
	set ::Test::Surf_Hold_BotId [expr [hm_entityinfo maxid set]+1]
	*createentity sets cardimage=SURFACE_ELEMENT includeid=0 name="Surf_Hold_Bot"
	}
	
catch {
	set ::Test::Surf_Hold_SideId [expr [hm_entityinfo maxid set]+1]
	*createentity sets cardimage=SURFACE_ELEMENT includeid=0 name="Surf_Hold_Side"
	}
	
catch {
	set ::Test::Surf_Frame_TopId [expr [hm_entityinfo maxid set]+1]
	*createentity sets cardimage=SURFACE_ELEMENT includeid=0 name="Surf_Frame_Top"
	}
	
catch {
	set ::Test::Surf_Frame_BotId [expr [hm_entityinfo maxid set]+1]
	*createentity sets cardimage=SURFACE_ELEMENT includeid=0 name="Surf_Frame_Bot"
	}
	
catch {
	set ::Test::Surf_Frame_SideId [expr [hm_entityinfo maxid set]+1]
	*createentity sets cardimage=SURFACE_ELEMENT includeid=0 name="Surf_Frame_Side"
	}
	
catch {
	set ::Test::Surf_Porous_TopId [expr [hm_entityinfo maxid set]+1]
	*createentity sets cardimage=SURFACE_ELEMENT includeid=0 name="Surf_Porous_Top"
	}
	
catch {
	set ::Test::Surf_Porous_BotId [expr [hm_entityinfo maxid set]+1]
	*createentity sets cardimage=SURFACE_ELEMENT includeid=0 name="Surf_Porous_Bot"
	}
	
catch {
	# 创建载荷Load
	set ::Test::LoadId [expr [hm_entityinfo maxid load]+1]
	*createentity loadcols cardimage=HISTORY includeid=0 name="Load"
	*currentcollector loadcols "Load"
	*createmark sets 1 "RP_Load"
	*loadcreateonentity_curve sets 1 1 1 0 0 -150 0 0 150 0 0 0 0 0
	}
	
catch {
	# 创建边界BC
	set ::Test::BCId [expr [hm_entityinfo maxid load]+1]
	*createentity loadcols cardimage=INITIAL_CONDITION includeid=0 name="BC"
	*currentcollector loadcols "BC"
	*createmark sets 1 "RP_BC"
	*loadcreateonentity_curve sets 1 3 1 0 0 0 0 0 0 0 0 0 0 0
	}
	
catch {
	# 创建Coup-Load
	set ::Test::Coup_LoadId [expr [hm_entityinfo maxid group]+1]
	*createentity groups cardimage=COUPLING includeid=0 name="Coup_Load"
	*setvalue groups id=$::Test::Coup_LoadId STATUS=2 6653=1
	*setvalue groups id=$::Test::Coup_LoadId STATUS=2 6654={sets $::Test::RP_LoadId}
	*setvalue groups id=$::Test::Coup_LoadId STATUS=2 1814={sets $::Test::Node_LoadId}
	*setvalue groups id=$::Test::Coup_LoadId STATUS=2 2045=1
	*setvalue groups id=$::Test::Coup_LoadId STATUS=2 2046=2
	*setvalue groups id=$::Test::Coup_LoadId STATUS=2 2047=3
	*setvalue groups id=$::Test::Coup_LoadId STATUS=2 2049=4
	*setvalue groups id=$::Test::Coup_LoadId STATUS=2 2049=5
	*setvalue groups id=$::Test::Coup_LoadId STATUS=2 2050=6
	}

catch {
	# 创建Coup-BC
	set ::Test::Coup_BCId [expr [hm_entityinfo maxid group]+1]
	*createentity groups cardimage=COUPLING includeid=0 name="Coup_BC"
	*setvalue groups id=$::Test::Coup_BCId STATUS=2 6653=1
	*setvalue groups id=$::Test::Coup_BCId STATUS=2 6654={sets $::Test::RP_BCId}
	*setvalue groups id=$::Test::Coup_BCId STATUS=2 1814={sets $::Test::Node_BCId}
	*setvalue groups id=$::Test::Coup_BCId STATUS=2 2045=1
	*setvalue groups id=$::Test::Coup_BCId STATUS=2 2046=2
	*setvalue groups id=$::Test::Coup_BCId STATUS=2 2047=3
	*setvalue groups id=$::Test::Coup_BCId STATUS=2 2048=4
	*setvalue groups id=$::Test::Coup_BCId STATUS=2 2049=5
	*setvalue groups id=$::Test::Coup_BCId STATUS=2 2050=6
	}
	
catch {
	# 创建接触对
	set ::Test::cont_Frame_TopId [createContactPair Cont_Frame_Top $::Test::Surf_Hold_TopId $::Test::Surf_Frame_TopId $::Test::propCont_id]
	set ::Test::cont_Frame_BotId [createContactPair Cont_Frame_Bot $::Test::Surf_Hold_BotId $::Test::Surf_Frame_BotId $::Test::propCont_id]
	set ::Test::cont_Frame_SideId [createContactPair Cont_Frame_Side $::Test::Surf_Hold_SideId $::Test::Surf_Frame_SideId $::Test::propCont_id]
	set ::Test::cont_Porous_TopId [createContactPair Cont_Porous_Top $::Test::Surf_Hold_TopId $::Test::Surf_Porous_TopId $::Test::propCont_id]
	set ::Test::cont_Porous_BotId [createContactPair Cont_Porous_Bot $::Test::Surf_Hold_BotId $::Test::Surf_Porous_BotId $::Test::propCont_id]
	}
	
catch {
	# 创建接触控制
	set ::Test::ctrl_Frame_TopId [createContactCtrl Ctrl_Frame_Top $::Test::Surf_Hold_TopId $::Test::Surf_Frame_TopId]
	set ::Test::ctrl_Frame_BotId [createContactCtrl Ctrl_Frame_Bot $::Test::Surf_Hold_BotId $::Test::Surf_Frame_BotId]
	set ::Test::ctrl_Frame_SideId [createContactCtrl Ctrl_Frame_Side $::Test::Surf_Hold_SideId $::Test::Surf_Frame_SideId]
	set ::Test::ctrl_Porous_TopId [createContactCtrl Ctrl_Porous_Top $::Test::Surf_Hold_TopId $::Test::Surf_Porous_TopId]
	set ::Test::ctrl_Porous_BotId [createContactCtrl Ctrl_Porous_Bot $::Test::Surf_Hold_BotId $::Test::Surf_Porous_BotId]
	}
	
catch {
	# 创建fieldOutput
	set ::Test::fieldOutputId [expr [hm_entityinfo maxid outputblocks]+1]
	*createentity outputblocks includeid=0 name="fieldOutput"
	*setvalue outputblocks id=$::Test::fieldOutputId STATUS=2 1564=1
	*setvalue outputblocks id=$::Test::fieldOutputId STATUS=2 1565="FIELD"
	*setvalue outputblocks id=$::Test::fieldOutputId STATUS=2 1568=1
	*setvalue outputblocks id=$::Test::fieldOutputId STATUS=2 1569="PRESELECT"
	}
	
catch {
	# 创建historyOutput
	set ::Test::historyOutputId [expr [hm_entityinfo maxid outputblocks]+1]
	*createentity outputblocks includeid=0 name="historyOutput"
	*setvalue outputblocks id=$::Test::historyOutputId STATUS=2 1564=1
	*setvalue outputblocks id=$::Test::historyOutputId STATUS=2 1565="HISTORY"
	*setvalue outputblocks id=$::Test::historyOutputId STATUS=2 1568=1
	*setvalue outputblocks id=$::Test::historyOutputId STATUS=2 1569="PRESELECT"
	}

catch {
	# 创建Step
	set ::Test::stepId [expr [hm_entityinfo maxid loadstep]+1]
	*createentity loadsteps includeid=0 name="Step-1"
	set loadIds [hm_entitylist loadcols id]
	set groupIds [hm_entitylist group id]
	set outputIds [hm_entitylist outputblocks id]
	*setvalue loadsteps id=$::Test::stepId ids={loadcols $loadIds}
	*setvalue loadsteps id=$::Test::stepId groups_ids={groups $groupIds}
	*setvalue loadsteps id=$::Test::stepId ob_ids={outputblocks $outputIds}
	
	# 设置分析步参数
	# 195-非线性
	*setvalue loadsteps id=$::Test::stepId STATUS=2 195=1
	*setvalue loadsteps id=$::Test::stepId STATUS=2 214=1
	*setvalue loadsteps id=$::Test::stepId STATUS=2 2287="YES"
	# 425-分析类型(2：静态)，118-开始时间，119-总时间，1789-最小增量步，1790-最大增量
	*setvalue loadsteps id=$::Test::stepId STATUS=2 1425=2
	*setvalue loadsteps id=1 STATUS=0 118=0
	*setvalue loadsteps id=1 STATUS=0 119=1.1
	*setvalue loadsteps id=1 STATUS=0 1789=1e-05
	*setvalue loadsteps id=1 STATUS=0 1790=0.1	
	}

# 在开始处理之前，隐藏所有Part：
foreach partId $::Test::modulesIDList {
	*createmark modules 2 "by id only" $partId
	*createstringarray 2 "elements_on" "geometry_on"
	*hideentitybymark 2 1 2
}

set partNum [llength $::Test::modulesIDList]

# Part循环
set partCount 1
foreach partId $::Test::modulesIDList {
	set filename [hm_getvalue modules id = $partId dataname = {Original filename}]
	set CID [hm_getvalue modules id = $partId dataname = HW_CID]
	set filename [split $filename]
	set ::Test::stpName [lindex $filename end]
	set ::Test::stpName [string range $::Test::stpName 0 end-4]
	# set stpName "$stpName"
	
	puts "\t——————***模型处理： $::Test::stpName ***——————"
	set index 0
	foreach cID $CID {
		# 对Part下的Component循环
		set compId [split $cID ,]
		set compId [lindex $compId 0]
		creatCompMesh $compId $index
		incr index 1
	}
	
	# meshSet $partId
	
	# 显示该Part
	*createmark modules 2 "by id only" $partId
	*createstringarray 2 "elements_on" "geometry_on"
	*showentitybymark 2 1 2
	
	# 显示表面
	# set setIdlist [hm_entitylist set id]
	# foreach id $setIdlist {
		# *showentity set -byid $id
	# }
	
	# 显示载荷与边界
	# set loadIdlist [hm_entitylist loadcols id]
	# foreach id $loadIdlist {
		# *showentity loadcols -byid $id
	# }
	
	# 显示相互作用
	# set groupIdlist [hm_entitylist group id]
	# foreach id $groupIdlist {
		# *showentity group -byid $id
	# }
	
	# 显示Step
	# set stepIdlist [hm_entitylist loadstep id]
	# foreach id $stepIdlist {
		# *showentity loadstep -byid $id
	# }
	
	## 输出Inp
	# set InpPath E:/615/INP/
	# set inpSuffix .inp
	# set InpName "$InpPath$::Test::prefix$::Test::stpName$inpSuffix"
	# *createstringarray 3 "HMMATCOMMENTS_XML" "EXPORTIDS_SKIP" "IDRULES_SKIP"
	# catch {
		## 尝试删除文件（如果存在）
		# file delete $InpName
		# }
	# *feoutputwithdata "D:/Program Files/Altair/2021/hwdesktop/templates/feoutput/abaqus/standard.3d" $InpName 0 0 0 1 3
	# puts \t模型导出:$InpName
	
	## 隐藏该Part
	*createmark modules 2 "by id only" $partId
	*createstringarray 2 "elements_on" "geometry_on"
	*hideentitybymark 2 1 2
	
	# 结束该Part的处理
	incr partCount
	puts \n
}


# hm_getcoordinatesfromnearestsurface
# hm_getnearbyentities