# hypermesh 2021

# 变量空间
namespace eval ::changeGUI {
	variable name
    variable filepath;
    variable label_width;
    variable button_cloumn 11;
	variable button_width;
}
set panelWidth [lindex [hm_getpanelarea] 2]
set width [expr {$panelWidth / $::changeGUI::button_cloumn / 10 + 1}]
set ::changeGUI::filepath [file dirname [info script]]
set ::changeGUI::label_width $width
set ::changeGUI::button_width $width
set ::changeGUI::name "模型变换"

# 创建按键阵列：函数{位置，列表}
proc create_label_button {loc line} {

	set line_title [lindex $line 0]
	set line_button [lrange $line 1 end]

	label .f.top.$loc.0  -text "$line_title" -width $::changeGUI::label_width -font {MS 10}  -compound center -height 1 -fg #A00000
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
		-command [format "source %s/%s" $::changeGUI::filepath $file_command]\
		-state $BTstate\
		-background #F0F0F0 \
		-fg #000000 \
		-height 1\
		-width $::changeGUI::button_width\
		-font {MS 9} \
		-relief groove
		if {$n_cur==$num} { break }
		set n_cur [expr $n_cur+1]
	}
	set loc [expr $loc+1]
	return $loc
}

# 初始设置
destroy .f
frame .f
frame .f.top
pack .f.top -side top -fill both

for { set i 0 } { $i < 12 } { incr i 1 } {
	frame .f.top.$i
	pack .f.top.$i -side left -fill x -anchor nw -padx 0 -pady 0
}

# -------------------------------------
set col 0

set 	line "调整节点位置"
lappend line "{By .INP} {moveNodeByInp.tcl}"
lappend line "{By .Odb} {moveNodeByOdb.tcl}"
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
hm_framework addpanel .f $::changeGUI::name
hm_framework drawpanel .f