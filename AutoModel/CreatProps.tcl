# -------------------------------------
# CreatStaticStep.tcl
# 快速创建属性（根据已有材料）

# 遍历材料：
set matIds [hm_entitylist mats id]
foreach matId matIds {
	# 根据材料名称设置属性名称
	set matName [hm_entityinfo name mats $matId]
	set propName matName
	# 设置属性Id
	set propId [expr [hm_entityinfo maxid props]+1]
	
	# 删除同名属性
	catch {
		hm_createmark properties 1 "by name only" "$propName"
		*deletemark properties 1
	}
	
	# 创建同材料名的属性
	*collectorcreate properties "$propName" "$matName" 11
	
	# 设置属性类型：SOLIDSECTION
	*setvalue props id=$propId cardimage="SOLIDSECTION"
	}
