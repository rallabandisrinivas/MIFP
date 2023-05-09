# 按Part输出Inp

# 变量空间
namespace eval ::Test {
	
	# Part id列表
	variable modulesIDList [hm_entitylist modules id]
	# 删除第一个partId(祖Modules)
	variable modulesIDList [lrange $modulesIDList 1 end]
	variable prefix RT04_
	variable InpPath Z:/615/RT04Sub_INP/
	variable inpSuffix _Subside.inp
	
	variable stpName
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
	set filename [split $filename]
	set ::Test::stpName [lindex $filename end]
	set ::Test::stpName [string range $::Test::stpName 0 end-4]
	
	# 显示该Part
	*createmark modules 2 "by id only" $partId
	*createstringarray 2 "elements_on" "geometry_on"
	*showentitybymark 2 1 2
	
	# 输出Inp
	set InpName "$::Test::InpPath$::Test::prefix$::Test::stpName$::Test::inpSuffix"
	*createstringarray 3 "HMMATCOMMENTS_XML" "EXPORTIDS_SKIP" "IDRULES_SKIP"
	catch {
		# 尝试删除文件（如果存在）
		file delete $InpName
		}
	*feoutputwithdata "D:/Program Files/Altair/2021/hwdesktop/templates/feoutput/abaqus/standard.3d" $InpName 0 0 0 1 3
	puts \t模型导出:$InpName
	
	# 隐藏该Part
	*createmark modules 2 "by id only" $partId
	*createstringarray 2 "elements_on" "geometry_on"
	*hideentitybymark 2 1 2
	
	# 结束该Part的处理
	incr partCount
	puts \n
}



