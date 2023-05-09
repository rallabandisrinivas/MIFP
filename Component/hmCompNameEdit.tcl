# -------------------------------------
# hypermesh
# 针对component 名称进行更改
# 可增加前缀 、 后缀 、 替换
# -------------------------------------


proc comp_edit {type} {
	# type : front rear replace
	# 增加前缀
	if {[string equal $type "front"]} {

		*createmarkpanel comps 1 "select the comps"
		set compsId [hm_getmark comps 1]
		if {$compsId == []} { return [] }
		set str [hm_getstring "Addfront=" "input string"]

		foreach compId $compsId {
			set compName [hm_entityinfo name comps $compId]
			set fullStr "$str $compName"
			set fullStr [join $fullStr "_"]
			*renamecollector components "$compName" "$fullStr"
		 } 

	}

	# 增加后缀
	if {[string equal $type "rear"]} {

		*createmarkpanel comps 1 "select the comps"
		set compsId [hm_getmark comps 1]
		if {$compsId == []} { return [] }
		set str [hm_getstring "rear=" "input string"]

		foreach compId $compsId {
			set compName [hm_entityinfo name comps $compId]
			set fullStr "$compName $str"
			set fullStr [join $fullStr "_"]
			*renamecollector components "$compName" "$fullStr"
		 } 

	}
	
	# 删除Comp前缀
	if {[string equal $type "delCompfront"]} {
		*createmarkpanel comps 1 "select the comps"
		set compsId [hm_getmark comps 1]
		if {$compsId == []} { return [] }
		set str [hm_getstring "Delfront=" "input string"]
		set strLength [string length $str]
		
		foreach compId $compsId {
			set compName [hm_entityinfo name comps $compId]
			set compNameLength [string length $compName]
			if {$compNameLength > $strLength} {
				set prefix [string range $compName 0 $strLength-1]
				if {$prefix == $str} {
					set fullStr [string range $compName $strLength end]
				} else {
					set fullStr "$compName"
				}
			}
			*renamecollector components "$compName" "$fullStr"
		 }
	}
	
	# 删除Prop前缀
	if {[string equal $type "delPropfront"]} {
		*createmarkpanel props 1 "select the comps"
		set compsId [hm_getmark props 1]
		if {$compsId == []} { return [] }
		set str [hm_getstring "Delfront=" "input string"]
		set strLength [string length $str]
		
		foreach compId $compsId {
			set compName [hm_entityinfo name props $compId]
			set compNameLength [string length $compName]
			if {$compNameLength > $strLength} {
				set prefix [string range $compName 0 $strLength-1]
				if {$prefix == $str} {
					set fullStr [string range $compName $strLength end]
				} else {
					set fullStr "$compName"
				}
			}
			*renamecollector properties "$compName" "$fullStr"
		 }
	}

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

