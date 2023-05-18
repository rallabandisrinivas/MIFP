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
if {[info exists ::nameGUI::currentModule]==0}		{set ::nameGUI::currentModule 添加前缀}

set width [expr {$panelWidth / $::nameGUI::button_cloumn / 10 + 1}]
set ::nameGUI::button_width $width
set ::nameGUI::filepath [file dirname [info script]]
set ::nameGUI::label_width $::nameGUI::button_width
set ::nameGUI::name "名称编辑"

proc pushPanel {module} {
	if {$module=="添加前缀"} { set ::nameGUI::sheet 0}
	if {$module=="添加后缀"} { set ::nameGUI::sheet 1}
	if {$module=="删除前缀"} { set ::nameGUI::sheet 2}
	if {$module=="删除后缀"} { set ::nameGUI::sheet 3}
	if {$module=="替换文本"} { set ::nameGUI::sheet 3}
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

}

# 初始设置
destroy .f
frame .f
frame .f.side
pack .f.side -side left -fill both

set i 0
foreach module {添加前缀 添加后缀 删除前缀 删除后缀 替换文本} {
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