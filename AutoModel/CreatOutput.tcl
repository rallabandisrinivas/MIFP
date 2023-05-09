# -------------------------------------
# CreatOutput.tcl
# 变量空间

# 创建场变量输出
set fieldOutputId [expr [hm_entityinfo maxid outputblocks]+1]
*createentity outputblocks includeid=0 name="Field"
*startnotehistorystate {Attached attributes to outputblock "Field"}
*setvalue outputblocks id=$fieldOutputId STATUS=2 1564=1
*setvalue outputblocks id=$fieldOutputId STATUS=2 1565="FIELD"
*setvalue outputblocks id=$fieldOutputId STATUS=2 1568=1
*setvalue outputblocks id=$fieldOutputId STATUS=2 1569="PRESELECT"
*endnotehistorystate {Attached attributes to outputblock "Field"}
*mergehistorystate "" ""

# 创建历程变量输出
set historyOutputId [expr [hm_entityinfo maxid outputblocks]+1]
*createentity outputblocks includeid=0 name="History"
*startnotehistorystate {Attached attributes to outputblock "History"}
*setvalue outputblocks id=$historyOutputId STATUS=2 1564=1
*setvalue outputblocks id=$historyOutputId STATUS=2 1565="History"
*setvalue outputblocks id=$historyOutputId STATUS=2 1568=1
*setvalue outputblocks id=$historyOutputId STATUS=2 1569="PRESELECT"
*endnotehistorystate {Attached attributes to outputblock "History"}
*mergehistorystate "" ""