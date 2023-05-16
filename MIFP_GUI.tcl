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
set ::hmGUI::name "快速建模平台"

hm_setpanelheight 220

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
		button .f.top.$loc.$n_cur \
		-text "$name" \
		-command [format "source %s/%s" $::hmGUI::filepath $file_command]\
		-state $BTstate\
		-background #F0F0F0 \
		-fg #000000 \
		-height 1\
		-width $::hmGUI::button_width\
		-font {MS 10} \
		-relief groove
		if {$n_cur==$num} { break }
		set n_cur [expr $n_cur+1]
	}
}

# 初始设置
destroy .f
frame .f
frame .f.title
pack .f.title -side top -fill both
catch {pack .f.title.tLabel -side top}

frame .f.top
pack .f.top -side bottom -fill both;
# frame .f.bottom
# pack .f.bottom -side bottom -fill x -expand 0;


for { set i 1 } { $i < 12 } { incr i 1 } {
	frame .f.top.$i
	pack .f.top.$i -side left -fill x -anchor nw -padx 0 -pady 0
}
# -------------------------------------

# 按钮内容及调用代码
set 	line "自动化"
lappend line "{_创建流程} {}"
lappend line "{自动保存} {AutoModel/AutoSave.tcl}"
lappend line "{批量导入} {AutoModel/BatchInput.tcl}"
lappend line "{项目定制} {AutoModel/projectModel.tcl}"
create_label_button 1 $line

# -------------------
set 	line "快速创建"
lappend line "{部位库} {Body/BodyLibrary_GUI.tcl}"
lappend line "{材料库} {Material/MatLibrary_GUI.tcl}"
lappend line "{默认场输出} {AutoModel/CreatOutput.tcl}"
lappend line "{Static-Step} {AutoModel/CreatStaticStep.tcl}"
lappend line "{接触控制} {AutoModel/CreatCtrl.tcl}"
create_label_button 2 $line

# -------------------
set 	line "名称编辑"
lappend line "{Comp-添加前缀} {Component/hmCompNameEdit.tcl;comp_edit front}"
lappend line "{Comp-添加后缀} {Component/hmCompNameEdit.tcl;comp_edit rear}"
lappend line "{Comp-删除前缀} {Component/hmCompNameEdit.tcl;comp_edit delCompfront}"
lappend line "{Comp-替换文本} {Component/hmCompNameEdit.tcl;comp_edit replaceComp}"
lappend line "{Prop-删除前缀} {Component/hmCompNameEdit.tcl;comp_edit delPropfront}"
lappend line "{Group-替换文本} {Component/hmCompNameEdit.tcl;comp_edit replaceGroup}"
create_label_button 3 $line

# -------------------
set 	line "2D网格"
lappend line "{_批创建：faces} {MeshEdit/batchCreatFaces.tcl}"
lappend line "{包络网格} {MeshEdit/wrapMesh.tcl}"
lappend line "{_质量优化} {MeshEdit/optimizeElement.tcl}"
create_label_button 4 $line

# -------------------
set		line "3D网格"
lappend line "{体素化} {MeshEdit/meshVoxelization.tcl}"
lappend line "{_范围选取} {MeshEdit/selectElement.tcl}"
create_label_button 5 $line

# -------------------
set		line "视图"
create_label_button 6 $line

# -------------------
set		line "工具"
lappend line "{_材料曲线} {Tool/MatEdit.tcl}"
lappend line "{模型检查} {Tool/ModelCheck.tcl}"
create_label_button 7 $line

# -------------------
set		line "Abaqus脚本"
lappend line "{_运行Abaqus} {}"
lappend line "{_循环计算} {}"
lappend line "{_骨生长设置} {}"
lappend line "{_骨吸收设置} {}"
create_label_button 8 $line

# -------------------
set		line "Abaqus子程序"
create_label_button 9 $line

# -------------------
set		line "作业计算"
lappend line "{Job设置} {Analysis/jobSet.tcl}"
lappend line "{_Job提交} {Analysis/jobSubmit.tcl}"
lappend line "{_Job监控} {Analysis/jobMonitor.tcl}"
lappend line "{_Job批处理} {Analysis/jobBatch.tcl}"
create_label_button 10 $line

# -------------------
set		line "接口"
lappend line "{面板测试} {Test/panelTest.tcl}"
create_label_button 11 $line


# pack小部件设置
for { set hloc 0 } { $hloc < 12 } { incr hloc 1 } {
	for { set vloc 1 } { $vloc < 12 } { incr vloc 1 } {
		catch {
			pack .f.top.$vloc.$hloc -side top -anchor nw -padx 1 -pady 0
		}
	}
}

# -----------------------
hm_framework addpanel .f $::hmGUI::name
hm_framework drawpanel .f