# hypermesh 2021
# 二次开发菜单，运行时创建材料库界面
# 根据各个按钮，调用其他代码

# 变量空间
namespace eval ::matGUI {
    variable filepath;
    variable label_width;
    variable button_cloumn 12; 
	variable button_width;
	variable sheet
	variable currentModule
}
if {[info exists ::matGUI::sheet]==0}		{set ::matGUI::sheet 0}
if {[info exists ::matGUI::currentModule]==0}		{set ::matGUI::currentModule 线弹性体}

set width [expr {$panelWidth / $::matGUI::button_cloumn / 10 + 1}]
set ::matGUI::button_width $width
set ::matGUI::filepath [file dirname [info script]]
set ::matGUI::label_width $::matGUI::button_width
set ::matGUI::name "材料库"

# 创建按键阵列：函数{位置，列表}
proc create_label_button {loc line} {

	set line_title [lindex $line 0]
	set line_button [lrange $line 1 end]

	label .f.top.$loc.0  -text "$line_title" -width $::matGUI::label_width -font {MS 10}  -compound center -height 1 -fg #A00000
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
		-command [format "source %s/%s" $::matGUI::filepath $file_command]\
		-state $BTstate\
		-background #F0F0F0 \
		-fg #000000 \
		-height 1\
		-width $::matGUI::button_width\
		-font {MS 9}\
		-relief groove
		if {$n_cur==$num} { break }
		set n_cur [expr $n_cur+1]
	}
}

proc pushPanel {module} {
	if {$module=="线弹性体"} { set ::matGUI::sheet 0}
	if {$module=="弹塑性体"} { set ::matGUI::sheet 1}
	if {$module=="超弹性体"} { set ::matGUI::sheet 2}
	if {$module=="其他材料"} { set ::matGUI::sheet 3}
	creatMatPanel $::matGUI::sheet
}

proc creatMatPanel {sheet} {
	
	destroy  .f.top
	frame .f.top
	pack .f.top -side top -fill both

	# 材料矩阵
	for { set j 1 } { $j < 12 } { incr j 1 } {
		frame .f.top.$j
		pack .f.top.$j -side left -fill x -anchor nw -padx 0 -pady 0
	}
	
	# 第一页：线弹性体
	if {$sheet==0} {
		set 	line "实体"
		lappend line "{默认(空白)} {creatMaterial.tcl;creatElasticMat Defult}"
		lappend line "{Peek(572M)} {creatMaterial.tcl;creatElasticMat Peek}"
		lappend line "{SawBone15(123M)} {creatMaterial.tcl;creatElasticMat SawBone15}"
		lappend line "{钛(114G)} {creatMaterial.tcl;creatElasticMat Ti}"
		lappend line "{不锈钢(220G)} {creatMaterial.tcl;creatElasticMat Steel}"
		create_label_button 1 $line

		set 	line "颈椎"
		lappend line "{皮质骨} {creatMaterial.tcl;creatElasticMat C_Cor}"
		lappend line "{松质骨} {creatMaterial.tcl;creatElasticMat C_Can}"
		lappend line "{终板} {creatMaterial.tcl;creatElasticMat C_EndP}"
		lappend line "{后部} {creatMaterial.tcl;creatElasticMat C_Post}"
		lappend line "{纤维环基质} {creatMaterial.tcl;creatElasticMat C_AF}"
		lappend line "{髓核} {creatMaterial.tcl;creatElasticMat C_NP}"
		lappend line "{关节囊} {creatMaterial.tcl;creatElasticMat C_FACET}"
		create_label_button 2 $line
		
		set 	line "颈椎韧带"
		lappend line "{横韧带(4)} {creatMaterial.tcl;creat1DElasticMat C_TL}"
		lappend line "{翼状韧带(8)} {creatMaterial.tcl;creat1DElasticMat C_AL}"
		lappend line "{前纵韧带(10)} {creatMaterial.tcl;creat1DElasticMat C_ALL}"
		lappend line "{后纵韧带(10)} {creatMaterial.tcl;creat1DElasticMat C_PLL}"
		lappend line "{黄韧带(6)} {creatMaterial.tcl;creat1DElasticMat C_LF}"
		lappend line "{棘间韧带(10)} {creatMaterial.tcl;creat1DElasticMat C_ISL}"
		lappend line "{关节囊韧带(10)} {creatMaterial.tcl;creat1DElasticMat C_JCL}"
		create_label_button 3 $line
		
		set		line "胸椎"
		lappend line "{皮质骨} {creatMaterial.tcl;creatElasticMat T_Cor}"
		lappend line "{松质骨} {creatMaterial.tcl;creatElasticMat T_Can}"
		lappend line "{终板} {creatMaterial.tcl;creatElasticMat T_EndP}"
		lappend line "{后部} {creatMaterial.tcl;creatElasticMat T_Post}"
		lappend line "{纤维环基质} {creatMaterial.tcl;creatElasticMat T_AF}"
		lappend line "{髓核} {creatMaterial.tcl;creatElasticMat T_NP}"
		lappend line "{关节囊} {creatMaterial.tcl;creatElasticMat T_FACET}"
		create_label_button 4 $line
		
		set		line "胸椎韧带"
		create_label_button 5 $line
		
		set		line "腰椎"
		lappend line "{皮质骨} {creatMaterial.tcl;creatElasticMat L_Cor}"
		lappend line "{松质骨} {creatMaterial.tcl;creatElasticMat L_Can}"
		lappend line "{终板} {creatMaterial.tcl;creatElasticMat L_EndP}"
		lappend line "{后部} {creatMaterial.tcl;creatElasticMat L_Post}"
		lappend line "{纤维环基质} {creatMaterial.tcl;creatElasticMat L_AF}"
		lappend line "{髓核} {creatMaterial.tcl;creatElasticMat L_NP}"
		lappend line "{关节囊} {creatMaterial.tcl;creatElasticMat L_FACET}"
		create_label_button 6 $line
		
		set		line "腰椎韧带"
		create_label_button 7 $line
		
		set		line "上肢"
		create_label_button 8 $line
		
		set		line "下肢"
		create_label_button 9 $line
		
		set		line "手"
		create_label_button 10 $line
		
		set		line "足"
		create_label_button 11 $line
	}

	# 第二页：弹塑性体
	if {$sheet==1} {
		set		line "实体"
		create_label_button 1 $line
	
		set		line "多孔材料"
		lappend line "{钻石型} {creatMaterial.tcl;creatPlasticMat Porous_Diamond}"
		lappend line "{十二面体} {creatMaterial.tcl;creatPlasticMat Porous_12hedron}"
		lappend line "{体心立方} {creatMaterial.tcl;creatPlasticMat Porous_BodyCenter}"
		create_label_button 2 $line
	}

	# 第三页：超弹性体
	if {$sheet==2} {
		set		line "实体"
		create_label_button 1 $line
	}
	
	# pack小部件设置
	for { set hloc 0 } { $hloc < 10 } { incr hloc 1 } {
		for { set vloc 0 } { $vloc < 15 } { incr vloc 1 } {
			catch {
				pack .f.top.$vloc.$hloc -side top -anchor nw -padx 0 -pady 0
			}
		}
	}
}

# 初始设置
destroy .f
frame .f
frame .f.side
pack .f.side -side left -fill both

set i 0
foreach module {线弹性体 弹塑性体 超弹性体 其他材料} {
    pack [radiobutton .f.side.$i -text $module -variable ::matGUI::currentModule \
        -value $module \
		-height 1\
		-width $::matGUI::button_width\
		-font {MS 12}\
        -command "pushPanel $module" ]
	incr i
}
pushPanel ::matGUI::currentModule

# -----------------------
# 界面Panel推送
hm_framework addpanel .f $::matGUI::name
hm_framework drawpanel .f