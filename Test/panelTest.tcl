# 创建面板-测试模块
namespace eval ::panelGUI {
    variable filepath;
    variable label_width;
    variable button_cloumn 12; 
	variable button_width;
	variable sheet
	variable currentModule
}

set panelWidth [lindex [hm_getpanelarea] 2]
set width [expr {$panelWidth / $::panelGUI::button_cloumn / 10 + 1}]
set ::panelGUI::filepath [file dirname [info script]]
set ::panelGUI::label_width $width
set ::panelGUI::button_width $width
set ::panelGUI::name "面板测试"

# -----------------------
# 初始设置
destroy .f
frame .f
frame .f.title
pack .f.title -side top -fill both
catch {pack .f.title.tLabel -side top}

# destroy  .f.top
frame .f.top


for { set j 0} { $j < 6 } { incr j 1 } {
		frame .f.top.$j
		pack .f.top.$j -side top -fill x -anchor nw -padx 1 -pady 0
	}

label .f.top.0.0 -text "[string totitle Text]" -width 15 -font {MS 10}
entry .f.top.0.1 -width 15 -font {MS 10}
button .f.top.1.2 -text "提交" -width 15 -font {MS 10}


pack .f.top.0.0 -side left -anchor w -padx 1 -pady 0
pack .f.top.0.1 -side left -anchor w -padx 1 -pady 0
pack .f.top.1.2 -side left -anchor w -padx 1 -pady 0

pack .f.top.0 -side top -fill both
pack .f.top.1 -side top -fill both
pack .f.top -side top -fill both

# -----------------------
# 界面Panel推送
hm_framework addpanel .f $::panelGUI::name
hm_framework drawpanel .f