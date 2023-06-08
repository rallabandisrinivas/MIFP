# hypermesh 2021
# 二次开发菜单，运行时创建部位库界面
# 根据各个按钮，调用其他代码

# 变量空间
namespace eval ::curveGUI {
    variable filepath;
    variable label_width;
    variable button_cloumn 12; 
	variable button_width;
	variable sheet;
	variable currentModule;
}
if {[info exists ::curveGUI::sheet]==0}				{set ::curveGUI::sheet 0}
if {[info exists ::curveGUI::currentModule]==0}		{set ::curveGUI::currentModule 标准测试-步态}

set panelWidth [lindex [hm_getpanelarea] 2]
set width [expr {$panelWidth / $::curveGUI::button_cloumn / 10 + 1}]
set ::curveGUI::button_width $width
set ::curveGUI::filepath [file dirname [info script]]
set ::curveGUI::label_width $::curveGUI::button_width
set ::curveGUI::name "加载曲线"

# 创建按键阵列：函数{位置，列表}
proc create_label_button {loc line} {

	set line_title [lindex $line 0]
	set line_button [lrange $line 1 end]

	label .f.top.$loc.0  -text "$line_title" -width $::curveGUI::label_width -font {MS 10}  -compound center -height 1 -fg #A00000
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
		-command [format "source %s/%s" $::curveGUI::filepath $file_command]\
		-state $BTstate\
		-background #F0F0F0 \
		-fg #000000 \
		-height 1\
		-width $::curveGUI::button_width\
		-font {MS 10}
		if {$n_cur==$num} { break }
		set n_cur [expr $n_cur+1]
	}
	set loc [expr $loc+1]
	return $loc
}

proc pushPanel {module} {
	if {$module=="标准测试-步态"} { set ::curveGUI::sheet 0}
	if {$module=="生理工况-步态"} { set ::curveGUI::sheet 1}
	creatBodyPanel $::curveGUI::sheet
}

proc creatBodyPanel {sheet} {
	destroy  .f.top
	frame .f.top
	pack .f.top -side left -fill both
	
	# Entity矩阵
	for { set j 0 } { $j < 12 } { incr j 1 } {
		frame .f.top.$j
		pack .f.top.$j -side left -fill x -anchor nw -padx 0 -pady 0
	}
	
	# 第一页：标准测试-步态
	if {$sheet==0} {
		set 	col 0
		
		set 	line "髋关节"
		lappend line "{矢状面-位移} {}"
		lappend line "{冠状面-位移} {}"
		lappend line "{水平面-位移} {}"
		lappend line "{矢状面-力} {}"
		lappend line "{冠状面-力} {}"
		lappend line "{水平面-力} {}"
		set col [create_label_button $col $line]
		
		set 	line "膝关节"
		lappend line "{矢状面-位移} {}"
		lappend line "{冠状面-位移} {}"
		lappend line "{水平面-位移} {}"
		lappend line "{矢状面-力} {}"
		lappend line "{冠状面-力} {}"
		lappend line "{水平面-力} {}"
		set col [create_label_button $col $line]
		
		set 	line "踝关节"
		lappend line "{矢状面-位移} {}"
		lappend line "{冠状面-位移} {}"
		lappend line "{水平面-位移} {}"
		lappend line "{矢状面-力} {}"
		lappend line "{冠状面-力} {}"
		lappend line "{水平面-力} {}"
		set col [create_label_button $col $line]
	}
	
	# 第二页：生理工况
	if {$sheet==1} {
		set 	col 0
		
		set 	line "髋关节"
		lappend line "{矢状面-位移} {}"
		lappend line "{冠状面-位移} {}"
		lappend line "{水平面-位移} {}"
		lappend line "{矢状面-力} {}"
		lappend line "{冠状面-力} {}"
		lappend line "{水平面-力} {}"
		set col [create_label_button $col $line]
		
		set 	line "膝关节"
		lappend line "{矢状面-位移} {}"
		lappend line "{冠状面-位移} {}"
		lappend line "{水平面-位移} {}"
		lappend line "{矢状面-力} {}"
		lappend line "{冠状面-力} {}"
		lappend line "{水平面-力} {}"
		set col [create_label_button $col $line]
		
		set 	line "踝关节"
		lappend line "{矢状面-位移} {}"
		lappend line "{冠状面-位移} {}"
		lappend line "{水平面-位移} {}"
		lappend line "{矢状面-力} {}"
		lappend line "{冠状面-力} {}"
		lappend line "{水平面-力} {}"
		set col [create_label_button $col $line]
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
foreach module {标准测试-步态 生理工况-步态} {
    pack [radiobutton .f.side.$i -text $module -variable ::curveGUI::currentModule \
        -value $module \
		-height 1\
		-width $::curveGUI::button_width\
		-font {MS 12}\
        -command "pushPanel $module" ]
	incr i
}
pushPanel ::curveGUI::currentModule

# -----------------------
# 界面Panel推送
hm_framework addpanel .f $::curveGUI::name
hm_framework drawpanel .f
