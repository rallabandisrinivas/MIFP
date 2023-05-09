# -------------------------------------
# CreatStaticStep.tcl
# 变量空间


# 创建分析步
set stepId [expr [hm_entityinfo maxid loadstep]+1]
*createentity loadsteps includeid=0 name="Step-1"
# 包含全部outputblock, group, load
set loadIds [hm_entitylist loadcols id]
set groupIds [hm_entitylist group id]
set outputIds [hm_entitylist outputblocks id]
*setvalue loadsteps id=$stepId ids={loadcols $loadIds}
*setvalue loadsteps id=$stepId groups_ids={groups $groupIds}
*setvalue loadsteps id=$stepId ob_ids={outputblocks $outputIds}
# 设置Step参数
*startnotehistorystate {Attached attributes to loadstep "Step"}
*setvalue loadsteps id=1 STATUS=2 1425=2
*setvalue loadsteps id=1 STATUS=2 1563=1
*setvalue loadsteps id=1 STATUS=2 154=1
*setvalue loadsteps id=1 STATUS=1 118=0.1
*setvalue loadsteps id=1 STATUS=0 119=1
*setvalue loadsteps id=1 STATUS=0 1789=1e-05
*setvalue loadsteps id=1 STATUS=0 1790=0.1
*endnotehistorystate {Attached attributes to loadstep "Step"}
*mergehistorystate "" ""
