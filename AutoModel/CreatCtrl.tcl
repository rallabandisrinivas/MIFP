# hypermesh 2021
# 二次开发菜单，根据选择的接触对创建对应的接触控制

*createmarkpanel groups 1 "select the groups"
set groupsId [hm_getmark groups 1]
if {$groupsId == []} { return [] }
foreach groupId $groupsId {
	set cardIamge [hm_getvalue groups id=$groupId dataname=cardimage]
	set groupName [hm_getvalue groups id=$groupId dataname=name]
	if {$cardIamge=="CONTACT_PAIR"} {
		set ctrlName Ctrl_$groupName
		set MasterSurfID [hm_getvalue groups id=$groupId dataname=masterentityids]
		set SlaveSurfID [hm_getvalue groups id=$groupId dataname=slaveentityids]
		if {$MasterSurfID == 0} {
			puts "\tNo Master Surf in $groupName"
			continue
		}
		if {$SlaveSurfID == 0} {
			puts "\tNo Slave Surf in $groupName"
			continue
		}
	} else {
		continue
	}
	*createentity groups cardimage=CONTACT_CONTROLS includeid=0 name=$ctrlName
	set ctrlID [hm_entityinfo id groups $ctrlName]
	
	# 设置主从面
	*setvalue groups id=$ctrlID STATUS=2 2109=1
	*setvalue groups id=$ctrlID STATUS=2 2110={sets $MasterSurfID}
	*setvalue groups id=$ctrlID STATUS=2 2115=1
	*setvalue groups id=$ctrlID STATUS=2 2116={sets $SlaveSurfID}
	
	# 设置稳定因子
	*setvalue groups id=$ctrlID STATUS=2 4366=1
	*setvalue groups id=$ctrlID STATUS=2 4377=1
	*setvalue groups id=$ctrlID STATUS=2 4367=1
 } 