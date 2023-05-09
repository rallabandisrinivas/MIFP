# 自动划分网格,并将网格分配至Solids各自所在components
namespace eval ::hmGUI {
    variable filepath;
    variable label_width;
    variable button_width 20; 
}

puts "step1:自动几何清理\n"
*createmarkpanel solids 1 "select the comps"
set solidsID [hm_getmark solids 1]
if {$solidsID == []} { return [] }

# 创建列空间
proc create_label_button {loc line} {

	set line_title [lindex $line 0]
	set line_button [lrange $line 1 end]

	label .f.top.$loc.0  -text "$line_title" -width $::hmGUI::label_width -font {MS 10}  -compound center  -height 1
	set num [llength $line_button]
	set n_cur 1
	foreach button_data $line_button {
		set name [lindex $button_data 0]
		set file_command [lindex $button_data 1]
		button .f.top.$loc.$n_cur -text "$name" -command [format "source %s/%s" $::hmGUI::filepath $file_command] -bg #99ff99 -width $::hmGUI::button_width -font {MS 10}
		if {$n_cur==$num} { break }
		set n_cur [expr $n_cur+1]
	}	
}

set Elesize [hm_getstring "Element Size:" "input string"]

foreach solidsID $solidsID {
	puts "几何编号：$solidsID —— 网格尺寸：$Elesize\n"
}

puts "step2:自动划分网格\n" 