# hypermesh 2021
# 二次开发菜单，运行时创建部位库界面
# 根据各个按钮，调用其他代码

# 变量空间
namespace eval ::bodyGUI {
    variable filepath;
    variable label_width;
    variable button_cloumn 12; 
	variable button_width;
	variable sheet;
	variable currentModule;
}
if {[info exists ::bodyGUI::sheet]==0}				{set ::bodyGUI::sheet 0}
if {[info exists ::bodyGUI::currentModule]==0}		{set ::bodyGUI::currentModule 骨格系统}

set width [expr {$panelWidth / $::bodyGUI::button_cloumn / 10 + 1}]
set ::bodyGUI::button_width $width
set ::bodyGUI::filepath [file dirname [info script]]
set ::bodyGUI::label_width $::matGUI::button_width
set ::bodyGUI::name "部位库"

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
		-font {MS 10}
		if {$n_cur==$num} { break }
		set n_cur [expr $n_cur+1]
	}
}