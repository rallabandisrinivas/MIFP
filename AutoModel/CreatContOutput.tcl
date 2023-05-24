# hypermesh 2021
# 二次开发菜单，根据选择的接触对创建对应的接触历程输出

*createmarkpanel groups 1 "select the groups"
set groupsId [hm_getmark groups 1]
if {$groupsId == []} { return [] }
foreach groupId $groupsId {
	set cardIamge [hm_getvalue groups id=$groupId dataname=cardimage]
	set groupName [hm_getvalue groups id=$groupId dataname=name]
	if {$cardIamge=="CONTACT_PAIR"} {
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
	# 创建历程输出
	set historyOutputId [expr [hm_entityinfo maxid outputblocks]+1]
	*createentity outputblocks includeid=0 name=$groupName
	*setvalue outputblocks id=$historyOutputId STATUS=2 1564=1
	*setvalue outputblocks id=$historyOutputId STATUS=2 1565="HISTORY"
	*setvalue outputblocks id=$historyOutputId STATUS=2 1603=1
	*setvalue outputblocks id=$historyOutputId STATUS=0 1616=1
	# 设置输出参数
	*setvalue outputblocks id=$historyOutputId STATUS=2 ROW=0 1617= {CFN1, CFN2, CFN3, CFNM}
	
	# 设置主从面
	*setvalue outputblocks id=$historyOutputId STATUS=2 1608=1
	*setvalue outputblocks id=$historyOutputId STATUS=2 1609={sets $MasterSurfID}
	*setvalue outputblocks id=$historyOutputId STATUS=2 1610=1
	*setvalue outputblocks id=$historyOutputId STATUS=2 1611={sets $SlaveSurfID}
 } 