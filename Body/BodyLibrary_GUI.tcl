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

proc pushPanel {module} {
	if {$module=="骨格系统"} { set ::bodyGUI::sheet 0}
	if {$module=="软骨韧带"} { set ::bodyGUI::sheet 1}
	if {$module=="肌肉系统"} { set ::bodyGUI::sheet 2}
	if {$module=="病变组织"} { set ::bodyGUI::sheet 3}
	creatBodyPanel $::bodyGUI::sheet
}

proc creatBodyPanel {sheet} {
	destroy  .f.top
	frame .f.top
	pack .f.top -side left -fill both
	
	# Entity矩阵
	for { set j 1 } { $j < 12 } { incr j 1 } {
		frame .f.top.$j
		pack .f.top.$j -side left -fill x -anchor nw -padx 0 -pady 0
	}
	
	# 第一页：骨格系统
	if {$sheet==0} {
		set 	line "头部"
		create_label_button 1 $line
		
		set 	line "口腔"
		create_label_button 2 $line
		
		set 	line "颈椎"
		create_label_button 3 $line
		
		set 	line "胸椎"
		create_label_button 4 $line
		
		set 	line "腰椎"
		create_label_button 5 $line
		
		set 	line "骨盆"
		create_label_button 6 $line
		
		set 	line "四肢"
		create_label_button 7 $line
		
		set 	line "手"
		create_label_button 8 $line
		
		set 	line "足"
		create_label_button 9 $line
		}
	
	# 第二页：软骨韧带	
	if {$sheet==1} {
		set 	line "头部"
		create_label_button 1 $line
		
		set 	line "口腔"
		create_label_button 2 $line
		
		set 	line "颈椎"
		create_label_button 3 $line
		
		set 	line "胸椎"
		create_label_button 4 $line
		
		set 	line "腰椎"
		create_label_button 5 $line
		
		set 	line "骨盆"
		create_label_button 6 $line
		
		set 	line "四肢"
		create_label_button 7 $line
		
		set 	line "手"
		create_label_button 8 $line
		
		set 	line "足"
		create_label_button 9 $line
		}
		
	# 第三页：肌肉系统	
	if {$sheet==2} {
		set 	line "头部"
		create_label_button 1 $line
		
		set 	line "口腔"
		create_label_button 2 $line
		
		set 	line "颈椎"
		create_label_button 3 $line
		
		set 	line "胸椎"
		create_label_button 4 $line
		
		set 	line "腰椎"
		create_label_button 5 $line
		
		set 	line "骨盆"
		create_label_button 6 $line
		
		set 	line "四肢"
		create_label_button 7 $line
		
		set 	line "手"
		create_label_button 8 $line
		
		set 	line "足"
		create_label_button 9 $line
		}
		
	# 第四页：病变组织	
	if {$sheet==3} {
		set 	line "头部"
		create_label_button 1 $line
		
		set 	line "口腔"
		create_label_button 2 $line
		
		set 	line "颈椎"
		create_label_button 3 $line
		
		set 	line "胸椎"
		create_label_button 4 $line
		
		set 	line "腰椎"
		create_label_button 5 $line
		
		set 	line "骨盆"
		create_label_button 6 $line
		
		set 	line "四肢"
		create_label_button 7 $line
		
		set 	line "手"
		create_label_button 8 $line
		
		set 	line "足"
		create_label_button 9 $line
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
foreach module {骨格系统 软骨韧带 肌肉系统 病变组织} {
    pack [radiobutton .f.side.$i -text $module -variable ::bodyGUI::currentModule \
        -value $module \
		-height 1\
		-width $::bodyGUI::button_width\
		-font {MS 12}\
        -command "pushPanel $module" ]
	incr i
}
pushPanel ::bodyGUI::currentModule

# -----------------------
# 界面Panel推送
hm_framework addpanel .f $::bodyGUI::name
hm_framework drawpanel .f