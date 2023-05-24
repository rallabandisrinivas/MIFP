# hypermesh 2021
# 名称编辑模块

# 变量空间
namespace eval ::nameGUI {
    variable filepath;
    variable label_width;
    variable button_cloumn 12; 
	variable button_width;
	variable sheet
	variable currentModule
}

if {[info exists ::nameGUI::sheet]==0}		{set ::nameGUI::sheet 0}
if {[info exists ::nameGUI::currentModule]==0}		{set ::nameGUI::currentModule 添加文本}

set width [expr {$panelWidth / $::nameGUI::button_cloumn / 10 + 1}]
set ::nameGUI::button_width $width
set ::nameGUI::filepath [file dirname [info script]]
set ::nameGUI::label_width $::nameGUI::button_width
set ::nameGUI::name "名称编辑"

# 创建按键阵列：函数{位置，列表}
proc create_label_button {loc line} {

	set line_title [lindex $line 0]
	set line_button [lrange $line 1 end]

	label .f.top.$loc.0  -text "$line_title" -width $::nameGUI::label_width -font {MS 10}  -compound center -height 1 -fg #A00000
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
		-command [format "source %s/%s" $::nameGUI::filepath $file_command]\
		-state $BTstate\
		-background #F0F0F0 \
		-fg #000000 \
		-height 1\
		-width $::nameGUI::button_width\
		-font {MS 10}\
		-relief groove
		if {$n_cur==$num} { break }
		set n_cur [expr $n_cur+1]
	}
}

proc pushPanel {module} {
	if {$module=="添加文本"} { set ::nameGUI::sheet 0}
	if {$module=="删除文本"} { set ::nameGUI::sheet 1}
	if {$module=="替换文本"} { set ::nameGUI::sheet 2}
	if {$module=="规范命名"} { set ::nameGUI::sheet 3}
	if {$module=="其他工具"} { set ::nameGUI::sheet 4}
	creatNamePanel $::nameGUI::sheet
}

proc creatNamePanel {sheet} {
	destroy  .f.top
	frame .f.top
	pack .f.top -side left -fill both
	
	# Entity矩阵
	for { set j 1 } { $j < 12 } { incr j 1 } {
		frame .f.top.$j
		pack .f.top.$j -side left -fill x -anchor nw -padx 0 -pady 0
	}
	
	# 第一页：添加文本
	if {$sheet==0} {
		set 	line "前缀"
		lappend line "{Comps} {hmCompNameEdit.tcl;nameEdit comps addFront}"
		lappend line "{Materials} {hmCompNameEdit.tcl;nameEdit mats addFront}"
		lappend line "{Props} {hmCompNameEdit.tcl;nameEdit props addFront}"
		lappend line "{Groups} {hmCompNameEdit.tcl;nameEdit groups addFront}"
		lappend line "{Loads} {hmCompNameEdit.tcl;nameEdit loads addFront}"
		lappend line "{Sets} {hmCompNameEdit.tcl;nameEdit sets addFront}"
		create_label_button 1 $line
		
		set 	line "后缀"
		lappend line "{Comps} {hmCompNameEdit.tcl;nameEdit comps addRear}"
		lappend line "{Materials} {hmCompNameEdit.tcl;nameEdit mats addFront}"
		lappend line "{Props} {hmCompNameEdit.tcl;nameEdit props addRear}"
		lappend line "{Groups} {hmCompNameEdit.tcl;nameEdit groups addFront}"
		lappend line "{Loads} {hmCompNameEdit.tcl;nameEdit Loads addFront}"
		lappend line "{Sets} {hmCompNameEdit.tcl;nameEdit sets addFront}"
		create_label_button 2 $line
		}
		
	# 第二页：删除文本
	if {$sheet==1} {
		set 	line "前缀"
		lappend line "{Comps} {hmCompNameEdit.tcl;nameEdit comps delFront}"
		lappend line "{Materials} {hmCompNameEdit.tcl;nameEdit mats delFront}"
		lappend line "{Props} {hmCompNameEdit.tcl;nameEdit props delFront}"
		lappend line "{Groups} {hmCompNameEdit.tcl;nameEdit groups delFront}"
		lappend line "{Loads} {hmCompNameEdit.tcl;nameEdit loads delFront}"
		lappend line "{Sets} {hmCompNameEdit.tcl;nameEdit sets delFront}"
		create_label_button 1 $line
		
		set 	line "后缀"
		lappend line "{Comps} {hmCompNameEdit.tcl;nameEdit comps delRear}"
		lappend line "{Materials} {hmCompNameEdit.tcl;nameEdit mats delRear}"
		lappend line "{Props} {hmCompNameEdit.tcl;nameEdit props delRear}"
		lappend line "{Groups} {hmCompNameEdit.tcl;nameEdit groups delRear}"
		lappend line "{Loads} {hmCompNameEdit.tcl;nameEdit loads delRear}"
		lappend line "{Sets} {hmCompNameEdit.tcl;nameEdit sets delRear}"
		create_label_button 2 $line
		
		set 	line "任意位置"
		lappend line "{Comps} {hmCompNameEdit.tcl;nameEdit comps anyWhere}"
		lappend line "{Materials} {hmCompNameEdit.tcl;nameEdit mats anyWhere}"
		lappend line "{Props} {hmCompNameEdit.tcl;nameEdit props anyWhere}"
		lappend line "{Groups} {hmCompNameEdit.tcl;nameEdit groups anyWhere}"
		lappend line "{Loads} {hmCompNameEdit.tcl;nameEdit loads anyWhere}"
		lappend line "{Sets} {hmCompNameEdit.tcl;nameEdit sets anyWhere}"
		create_label_button 3 $line
		}
		
	# 第三页：替换文本
	if {$sheet==2} {
		set 	line "任意位置"
		lappend line "{Comps} {hmCompNameEdit.tcl;nameEdit comps replace}"
		lappend line "{Materials} {hmCompNameEdit.tcl;nameEdit mats replace}"
		lappend line "{Props} {hmCompNameEdit.tcl;nameEdit props replace}"
		lappend line "{Groups} {hmCompNameEdit.tcl;nameEdit groups replace}"
		lappend line "{Loads} {hmCompNameEdit.tcl;nameEdit loads replace}"
		lappend line "{Sets} {hmCompNameEdit.tcl;nameEdit sets replace}"
		create_label_button 1 $line
		}
		
	# 第四页：规范命名
	if {$sheet==3} {
		set 	line "驼峰命名"
		create_label_button 1 $line
		}
		
	# 第五页：其他工具
	if {$sheet==4} {
		set 	line "检查工具"
		create_label_button 1 $line
		}
	
		
	# pack小部件设置
	for { set hloc 0 } { $hloc < 8 } { incr hloc 1 } {
		for { set vloc 1 } { $vloc < 15 } { incr vloc 1 } {
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
foreach module {添加文本 删除文本 替换文本 规范命名 其他工具} {
    pack [radiobutton .f.side.$i -text $module -variable ::nameGUI::currentModule \
        -value $module \
		-height 1\
		-width $::nameGUI::button_width\
		-font {MS 12}\
        -command "pushPanel $module" ]
	incr i
}
pushPanel ::nameGUI::currentModule

# -----------------------
# 界面Panel推送
hm_framework addpanel .f $::nameGUI::name
hm_framework drawpanel .f