# hypermesh 2021
# 项目界面

# 变量空间
namespace eval ::projGUI {
    variable filepath;
    variable label_width;
    variable button_width 15; 
	variable sheet
	variable currentModule
}
if {[info exists ::projGUI::sheet]==0}		{set ::projGUI::sheet 0}
if {[info exists ::projGUI::currentModule]==0}		{set ::projGUI::currentModule "页-1"}

set ::projGUI::filepath [file dirname [info script]]
set ::projGUI::label_width $::projGUI::button_width
set ::projGUI::name "材料库"

# 创建按键阵列：函数{位置，列表}
proc create_label_button {loc line} {

	set line_title [lindex $line 0]
	set line_button [lrange $line 1 end]

	label .f.top.$loc.0  -text "$line_title" -width $::projGUI::label_width -font {MS 10}  -compound center -height 1 -fg #A00000
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
		-command [format "source %s/%s" $::projGUI::filepath $file_command]\
		-state $BTstate\
		-background #F0F0F0 \
		-fg #000000 \
		-height 1\
		-width $::projGUI::button_width\
		-font {MS 10}
		if {$n_cur==$num} { break }
		set n_cur [expr $n_cur+1]
	}
}

proc pushPanel {module} {
	if {$module=="页-1"} { set ::projGUI::sheet 0}
	if {$module=="页-2"} { set ::projGUI::sheet 1}
	if {$module=="页-3"} { set ::projGUI::sheet 2}
	if {$module=="页-4"} { set ::projGUI::sheet 3}
	creatPanel $::projGUI::sheet
}

proc creatPanel {sheet} {
	
	destroy  .f.top
	frame .f.top
	pack .f.top -side left -fill both
	
	# 矩阵
	for { set j 1 } { $j < 12 } { incr j 1 } {
		frame .f.top.$j
		pack .f.top.$j -side left -fill x -anchor nw -padx 0 -pady 0
	}
	
	# 第一页
	if {$sheet==0} {
		set 	line "615"
		lappend line "{RT01} {project/615/ScriptTest_RT01.tcl}"
		lappend line "{RT02} {project/615/ScriptTest_RT02.tcl}"
		lappend line "{RT04} {project/615/ScriptTest_RT04.tcl}"
		lappend line "{RT05} {project/615/ScriptTest_RT05.tcl}"
		lappend line "{RT08} {project/615/ScriptTest_RT08.tcl}"
		lappend line "{RT09} {project/615/ScriptTest_RT09.tcl}"
		lappend line "{批量输出Inp} {project/outputInp.tcl}" 
		create_label_button 1 $line
		}
		
	# pack小部件设置
	for { set hloc 0 } { $hloc < 15 } { incr hloc 1 } {
		for { set vloc 1 } { $vloc < 15 } { incr vloc 1 } {
			catch {
				pack .f.top.$vloc.$hloc -side top -anchor nw -padx 1 -pady 0
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
foreach module {"页-1" "页-2" "页-3" "页-4"} {
    pack [radiobutton .f.side.$i -text $module -variable ::projGUI::currentModule \
        -value $module \
		-height 1\
		-width $::projGUI::button_width\
		-font {MS 11}\
        -command "pushPanel $module" ]
	incr i
}

pushPanel ::projGUI::currentModule

# -----------------------
# 界面Panel推送
hm_framework addpanel .f $::projGUI::name
hm_framework drawpanel .f