# 创建材料及对应截面属性

# 函数：创建线弹性材料(名称, 弹性模量, 泊松比)->材料ID
proc createElasticMaterial {mat_name value_E value_NU {noCompress 0}} {
	
	set mat_id [expr [hm_entityinfo maxid mats] + 1]
	catch {
		# 如有同名材料，替换数据
		hm_createmark materials 1 "by name only" "$mat_name"
		set mat_id [hm_entityinfo id mats $mat_name]
		*deletemark materials 1
	} 
	
	*createentity mats cardimage=ABAQUS_MATERIAL includeid=0 name="$mat_name"
	hm_createmark materials 1 "by name only" "$mat_name"
	set matId [hm_entityinfo id mats $mat_name]
	catch {
		*setvalue mats id=$matId id=$mat_id 
	}

	# 设置材料类型：Elastic
	*setvalue mats id=$mat_id STATUS=2 105=1
	*setvalue mats id=$mat_id STATUS=0 26=1
	*setvalue mats id=$mat_id STATUS=2 104=1
	
	# 设置模量和泊松比
	*setvalue mats id=$mat_id STATUS=2 3=$value_E
	*setvalue mats id=$mat_id STATUS=2 4=$value_NU
	
	if {$noCompress == 1} {
		*setvalue mats id=$mat_id STATUS=2 3837=1
	}

	return $mat_id
}

# 函数：创建弹塑性材料(名称, 弹性模量, 泊松比, 屈服强度)->材料ID
proc createPlasticMaterial {mat_name value_E value_NU yield_SS} {
	
	set mat_id [expr [hm_entityinfo maxid mats] + 1]
	catch {
		# 如有同名材料，替换数据
		hm_createmark materials 1 "by name only" "$mat_name"
		set mat_id [hm_entityinfo id mats $mat_name]
		*deletemark materials 1
	} 
	
	*createentity mats cardimage=ABAQUS_MATERIAL includeid=0 name="$mat_name"
	hm_createmark materials 1 "by name only" "$mat_name"
	set matId [hm_entityinfo id mats $mat_name]
	catch {
		*setvalue mats id=$matId id=$mat_id 
	}

	# 设置材料类型：Plastic
	*setvalue mats id=$mat_id STATUS=2 105=1
	*setvalue mats id=$mat_id STATUS=0 26=1
	*setvalue mats id=$mat_id STATUS=2 104=1
	*setvalue mats id=$mat_id STATUS=2 421=1
	*setvalue mats id=$mat_id STATUS=2 6980=3
	*setvalue mats id=$mat_id STATUS=2 532=1
	*setvalue mats id=$mat_id STATUS=2 425=1
	
	# 设置模量和泊松比
	*setvalue mats id=$mat_id STATUS=2 3=$value_E
	*setvalue mats id=$mat_id STATUS=2 4=$value_NU
	
	# 设置屈服强度
	set yield_Stress [lindex $yield_SS 0]
	set yield_Strain [lindex $yield_SS 1]
	*setvalue mats id=$mat_id STATUS=2 426=$yield_Stress
	*setvalue mats id=$mat_id STATUS=2 427=$yield_Strain

	return $mat_id
}

# 函数：创建Solid截面属性（材料名称）->属性ID
proc createPropertiesSolid {mat_name} {
	
	set prop_id [expr [hm_entityinfo maxid props] + 1]
	catch {
		# 如有同名属性，替换数据
		hm_createmark properties 1 "by name only" "$mat_name"
		set prop_id [hm_entityinfo id props $mat_name]
		*deletemark props 1
	}
	
	# 设置截面类型：SOLIDSECTION
	*createentity props cardimage=SOLIDSECTION includeid=0 name="$mat_name"
	set propId [hm_entityinfo id props $mat_name]
	catch {
		*setvalue props id=$propId id=$prop_id
	}
	hm_createmark properties 1  "$mat_name"
	set mat_id [hm_entityinfo id mats $mat_name]
	*setvalue props id=$prop_id materialid={mats $mat_id}
	
	return $prop_id
}

# 函数：创建1D-Solid截面属性（材料名称）->属性ID
proc createPropertiesSolid1D {mat_name Area} {
	
	set prop_id [expr [hm_entityinfo maxid props] + 1]
	catch {
		# 如有同名属性，替换数据
		hm_createmark properties 1 "by name only" "$mat_name"
		set prop_id [hm_entityinfo id props $mat_name]
		*deletemark props 1
	}
	
	# 设置截面类型：SOLIDSECTION
	*createentity props cardimage=SOLIDSECTION includeid=0 name="$mat_name"
	set propId [hm_entityinfo id props $mat_name]
	catch {
		*setvalue props id=$propId id=$prop_id
	}
	hm_createmark properties 1  "$mat_name"
	set mat_id [hm_entityinfo id mats $mat_name]
	*setvalue props id=$prop_id materialid={mats $mat_id}
	*setvalue props id=$prop_id STATUS=2 1625=1
	*setvalue props id=$prop_id STATUS=1 111=$Area
	
	return $prop_id
}

	
	
	
	



