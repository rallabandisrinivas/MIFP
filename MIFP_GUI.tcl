# hypermesh 2021
# 二次开发菜单，运行时创建Panel-GUI界面
# 根据各个按钮，调用其他代码

# 变量空间
namespace eval ::hmGUI {
	variable name
    variable filepath;
    variable label_width;
    variable button_cloumn 11;
	variable button_width;
}
set panelWidth [lindex [hm_getpanelarea] 2]
set width [expr {$panelWidth / $::hmGUI::button_cloumn / 10 + 1}]
set ::hmGUI::filepath [file dirname [info script]]
set ::hmGUI::label_width $width
set ::hmGUI::button_width $width
set ::hmGUI::name "MIFP:快速建模平台"

# 设置面板高度
hm_setpanelheight 240

# 禁止向command文件写入view命令
hm_writeviewcommands 0

namespace eval ::annotation {
	variable label
}
set ::annotation::label [dict create]

# 定义鼠标进入Button时的事件处理函数
proc enterButton {annotation} {
	set ann [dict get $::annotation::label $annotation]
	
	if {[string length $ann] == 0 } {
		return
	}

	# 创建对应的Tooltip控件
	toplevel .f.top.tooltip 
	wm overrideredirect .f.top.tooltip 1
	label .f.top.tooltip.label -text $ann
	pack .f.top.tooltip.label -padx 5 -pady 5
	# 显示对应的Tooltip控件
	wm deiconify .f.top.tooltip
	# 将Tooltip控件移动到鼠标位置
	set x [winfo pointerx .]
	set y [winfo pointery .]
	wm geometry .f.top.tooltip +[expr $x+10]+[expr $y+10]
}

# 定义鼠标离开Button时的事件处理函数
proc leaveButton {} {
	# 隐藏对应的Tooltip控件
	catch {
		destroy .f.top.tooltip
	}
}

# 创建按键阵列：函数{位置，列表}
proc create_label_button {loc line} {

	set line_title [lindex $line 0]
	set line_button [lrange $line 1 end]

	label .f.top.$loc.0  -text "$line_title" -width $::hmGUI::label_width -font {MS 10}  -compound center -height 1 -fg #A00000
	set num [llength $line_button]
	set n_cur 1
	foreach button_data $line_button {
		set name [lindex $button_data 0]
		set prefix [string index $name 0]
		if {$prefix == "_"} {
			set BTstate disabled
		} else {
			set BTstate normal
		}
		set file_command [lindex $button_data 1]
		
		# 创建Button属性
		button .f.top.$loc.$n_cur \
		-text "$name" \
		-command [format "source %s/%s" $::hmGUI::filepath $file_command]\
		-state $BTstate\
		-background #F0F0F0 \
		-fg #000000 \
		-height 1\
		-width $::hmGUI::button_width\
		-font {MS 9} \
		-relief groove

		global .f.top.$loc.$n_cur.annotation 
		set .f.top.$loc.$n_cur.annotation [lindex $button_data 2]
		dict set ::annotation::label .f.top.$loc.$n_cur.annotation [lindex $button_data 2] 
		# 将事件处理函数绑定到Button的鼠标进入和离开事件
		bind .f.top.$loc.$n_cur <Enter> {enterButton %W.annotation}
		bind .f.top.$loc.$n_cur <Leave> {leaveButton}
		
		if {$n_cur==$num} { break }
		set n_cur [expr $n_cur+1]
	}
	set loc [expr $loc+1]
	return $loc
}

# 初始设置
destroy .f
frame .f

# frame .f.title
# pack .f.title -side top -fill both
# label .f.title.tLabel -text "MIFP:有限元建模平台" -font {MS 10}  -compound center -height 1 -fg #A00000
# catch {pack .f.title.tLabel -side top}

frame .f.top
pack .f.top -side top -fill both

for { set i 0 } { $i < 12 } { incr i 1 } {
	frame .f.top.$i
	pack .f.top.$i -side left -fill x -anchor nw -padx 0 -pady 0
}

# -------------------------------------
set col 0

# 按钮内容及调用代码
set 	line "自动化"
lappend line "{_创建流程} {}"
lappend line "{自动保存} {AutoModel/AutoSave.tcl} {检测无操作1min自动保存修改模型}"
lappend line "{批量导入} {AutoModel/BatchImport.tcl} {批量导入模型文件：inp或stl}"
lappend line "{批量导出} {AutoModel/BatchExport.tcl} {批量导出模型文件：stl}"
lappend line "{项目定制} {AutoModel/projectModel.tcl}"
set col [create_label_button $col $line]

# -------------------
set 	line "快速创建"
lappend line "{部位库} {Body/BodyLibrary_GUI.tcl} {一键导入部位2D面网格}"
lappend line "{材料库} {Material/MatLibrary_GUI.tcl} {一键创建常用的材料属性和对应截面属性}"
lappend line "{_接触对} {AutoModel/CreatContPair.tcl}"
lappend line "{接触控制} {AutoModel/CreatCtrl.tcl} {选择接触并创建对应的默认接触控制}"
lappend line "{默认输出} {AutoModel/CreatOutput.tcl} {创建Abaqus默认的场输出和历程输出}"
lappend line "{接触历程输出} {AutoModel/CreatContOutput.tcl} {选择接触并创建对应的接触面积、接触力等历程输出(注意，导入ABAQUS/CAE会丢失该设置！)}"
lappend line "{新建Step} {AutoModel/CreatStaticStep.tcl} {创建默认属性的Static Step}"
set col [create_label_button $col $line]

# -------------------
set 	line "2D网格"
lappend line "{批量创建：faces} {MeshEdit/batchCreatFaces.tcl} {在comps上创建该comps单元的faces}"
lappend line "{包络网格} {MeshEdit/wrapMesh.tcl} {创建2D面网格，将所选comps完全包络}"
lappend line "{交叉检查} {}"
lappend line "{_网格修复} {MeshEdit/wrapMesh.tcl}"
lappend line "{_质量优化} {MeshEdit/optimizeElement.tcl}"
lappend line "{对称差集A△B} {MeshEdit/SymDiffBoolean.tcl}"
set col [create_label_button $col $line]

# -------------------
set		line "3D网格"
lappend line "{体素化} {MeshEdit/meshVoxelization.tcl} {将comps体素化为C3D8立方体单元网格}"
lappend line "{_范围选取} {MeshEdit/selectElement.tcl}"
set col [create_label_button $col $line]

# -------------------
set		line "分析"
lappend line "{_标准实验} {}"
lappend line "{加载曲线} {Analysis/curveGUI.tcl}"
set col [create_label_button $col $line]

# -------------------
set		line "视图"
lappend line "{_NoFitView} {View/NoFitViewGUI.tcl} {不缩放的标准视图}"
lappend line "{_用户视图} {} {保存和调用视图状态}"
set col [create_label_button $col $line]

# -------------------
set		line "工具"
lappend line "{_材料曲线} {Tools/MatEdit.tcl} {根据输入的材料属性绘制对应的应力应变曲线}"
lappend line "{名称编辑} {Tools/nameEditGUI.tcl}"
lappend line "{模型变换} {Tools/modelChangeGUI.tcl} {基于Inp或Odb等，变换模型网格结构}"
lappend line "{模型检查} {Tools/ModelCheck.tcl}"
set col [create_label_button $col $line]

# -------------------
set		line "Abaqus脚本"
lappend line "{_运行Abaqus} {}"
lappend line "{_循环计算} {}"
lappend line "{_骨生长设置} {}"
lappend line "{_骨吸收设置} {}"
set col [create_label_button $col $line]

# -------------------
set		line "Abaqus子程序"
lappend line "{_Standard} {}"
lappend line "{_Explicit} {}"
set col [create_label_button $col $line]

# -------------------
set		line "作业计算"
lappend line "{Job设置} {Analysis/jobSet.tcl} {在对应目录下生成.inp和一系列.py文件}"
lappend line "{_Job提交} {Analysis/jobSubmit.tcl}"
lappend line "{_Job监控} {Analysis/jobMonitor.tcl}"
lappend line "{_Job批处理} {Analysis/jobBatch.tcl}"
set col [create_label_button $col $line]

# -------------------
set		line "接口"
lappend line "{设置} {Setting/settingGUI.tcl} {MIFP平台设置}"
lappend line "{更新} {Setting/update.tcl} {检查并下载更新}"
set col [create_label_button $col $line]


# pack小部件设置
for { set hloc 0 } { $hloc < 12 } { incr hloc 1 } {
	for { set vloc 0 } { $vloc < 12 } { incr vloc 1 } {
		catch {
			pack .f.top.$vloc.$hloc -side top -anchor nw -padx 0 -pady 0
		}
	}
}

# -----------------------
hm_framework addpanel .f $::hmGUI::name
hm_framework drawpanel .f