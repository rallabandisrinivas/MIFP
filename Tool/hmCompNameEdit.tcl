# -------------------------------------
# hypermesh
# 针对component 名称进行更改
# 可增加前缀 、 后缀 、 替换
# -------------------------------------


proc nameEdit {entityType opera} {

	# 选择Entities
	*createmarkpanel $entityType 1 "select the entities"
	set entitiesId [hm_getmark $entityType 1]
	if {$entitiesId == []} { return [] }

	# 增加前缀
	if {[string equal $opera "addFront"]} {
		set str [hm_getstring "Addfront=" "input string"]
		foreach entityId $entitiesId {
			set entityName [hm_entityinfo name $entityType $entityId]
			set fullStr "$str $entityName"
			set fullStr [join $fullStr "_"]
			*renamecollector $entityType "$entityName" "$fullStr"
		 }
	}

	# 增加后缀
	if {[string equal $opera "addRear"]} {
		set str [hm_getstring "AddRear=" "input string"]
		foreach entityId $entitiesId {
			set entityName [hm_entityinfo name $entityType $entityId]
			set fullStr "$entityName $str"
			set fullStr [join $fullStr "_"]
			*renamecollector $entityType "$entityName" "$fullStr"
		 } 
	}
	
	# 删除前缀
	if {[string equal $opera "delFront"]} {
		set str [hm_getstring "delFront=" "input string"]
		set strLength [string length $str]
		foreach entityId $entitiesId {
			set entityName [hm_entityinfo name $entityType $entityId]
			set entityNameLength [string length $entityName]
			if {$entityNameLength > $strLength} {
				set prefix [string range $entityName 0 $strLength-1]
				if {$prefix == $str} {
					set fullStr [string range $entityName $strLength end]
				} else {
					return
				}
			}
			*renamecollector $entityType "$entityName" "$fullStr"
		 } 
	}
	
	# 删除后缀
	if {[string equal $opera "delRear"]} {
		set str [hm_getstring "delRear=" "input string"]
		set strLength [string length $str]
		foreach entityId $entitiesId {
			set entityName [hm_entityinfo name $entityType $entityId]
			set entityNameLength [string length $entityName]
			set index [expr $entityNameLength - $strLength]
			if {$entityNameLength > $strLength} {
				set suffix [string range $entityName $index end]
				if {$suffix == $str} {
					set fullStr [string range $entityName 0 $index-1]
				} else {
					return
				}
			}
			*renamecollector $entityType "$entityName" "$fullStr"
		 } 
	}
	
	# 删除文本
	if {[string equal $opera "delRear"]} {
		set str [hm_getstring "delRear=" "input string"]
		set strLength [string length $str]
		foreach entityId $entitiesId {
			set entityName [hm_entityinfo name $entityType $entityId]
			set entityNameLength [string length $entityName]
			set index [expr $entityNameLength - $strLength]
			if {$entityNameLength > $strLength} {
				set suffix [string range $entityName $index end]
				if {$suffix == $str} {
					set fullStr [string range $entityName 0 $index-1]
				} else {
					return
				}
			}
			*renamecollector $entityType "$entityName" "$fullStr"
		 } 
	}
}
	

proc comp_edit {type} {
	# type : front rear replace

	# 替换Comp文档
	if {[string equal $type "replaceComp"]} {

		*createmarkpanel comps 1 "select the comps"
		set compsId [hm_getmark comps 1]
		if {$compsId == []} { return [] }
		set inputStr [hm_getstring "旧String 新String=" "input string"]
		set oldString [lindex $inputStr 0]
		set newString [lindex $inputStr 1]

		foreach compId $compsId {
			set compName [hm_entityinfo name comps $compId]
			catch {
				set fullStr [string map "$oldString $newString" $compName]
				*renamecollector components "$compName" "$fullStr"
			}
		 }

	}
	
	# 替换Group文档
	if {[string equal $type "replaceGroup"]} {

		*createmarkpanel groups 1 "select the groups"
		set groupsId [hm_getmark groups 1]
		if {$groupsId == []} { return [] }
		set inputStr [hm_getstring "查找 替换" "input string"]
		set oldString [lindex $inputStr 0]
		set newString [lindex $inputStr 1]

		foreach groupId $groupsId {
			set groupName [hm_entityinfo name groups $groupId]
			catch {
				set fullStr [string map "$oldString $newString" $groupName]
				*renamecollector groups "$groupName" "$fullStr"
			}
		 }

	}

	if {[string equal $type "help"]} {
		puts "compEdit front"
		puts "compEdit rear"
		puts "compEdit delfront"
		puts "compEdit replace"
	}
	# 指定替换字符 replace
	# 增加前缀 front
	# 增加后缀 rear

}

