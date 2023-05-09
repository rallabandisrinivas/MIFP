namespace eval ::jobSettingParameter {
    # 监控参数
	variable nCpu
	variable memory
	variable version
	variable type
	variable jobPath
	variable tempPath
}

if {[info exists ::jobSettingParameter::nCpu]==0}		{set ::jobSettingParameter::nCpu 12}
if {[info exists ::jobSettingParameter::memory]==0} 	{set ::jobSettingParameter::memory 90}
if {[info exists ::jobSettingParameter::version]==0}	{set ::jobSettingParameter::version 2021}
if {[info exists ::jobSettingParameter::type]==0} 		{set ::jobSettingParameter::type 1}
if {[info exists ::jobSettingParameter::jobPath]==0} 	{set ::jobSettingParameter::jobPath "Z:\\0\\INP"}
if {[info exists ::jobSettingParameter::tempPath]==0} 	{set ::jobSettingParameter::tempPath "Z:\\temp"}


# ==================================
# GUI
if {[grab current] != ""} { return; }
namespace eval ::jobSetting {
    variable recess
	variable filepath
}

# 路径定义
set ::jobSetting::filepath [file dirname [info script]]

proc ::jobSetting::GUI { args } {
	variable recess

	set minx [winfo pixel . 260p];
    set miny [winfo pixel . 300p];
	if {![OnPc]} {set miny [winfo pixel . 300p];}
    set graphArea [hm_getgraphicsarea];
    set x [lindex $graphArea 0];
    set y [lindex $graphArea 1];
    
    # 主窗口
    ::hwt::CreateWindow jobSettingWin \
        -windowtitle "Job设置" \
        -cancelButton "取消" \
		-cancelFunc ::jobSetting::Quit \
		-addButton "提交" ::jobSetting::OKQuit no_icon \
		-resizeable 1 1 \
        -propagate 1 \
        -minsize $minx $miny \
		-geometry ${minx}x${miny}+${x}+${y} \
         noGeometrySaving;
    ::hwt::KeepOnTop .jobSettingWin;
	
	set recess [::hwt::WindowRecess jobSettingWin];

    grid columnconfigure $recess 4 -weight 5;
    grid rowconfigure    $recess 30 -weight 1;
	
	# ===================
	# 控件布局
	label $recess.versionLabel -text "ABAQUS版本：" -font {MS 10} ;
    grid $recess.versionLabel -row 4 -column 0 -padx 1 -pady 2 -sticky nw;
	radiobutton $recess.versionradio_1 -text "2021"  -variable ::jobSettingParameter::version -value 2021 -anchor w -font {MS 8}
	grid $recess.versionradio_1 -row 5 -column 1 -padx 0 -pady 2 -sticky nw;
	radiobutton $recess.versionradio_2 -text "2017"  -variable ::jobSettingParameter::version -value 2017 -anchor w -font {MS 8}
	grid $recess.versionradio_2 -row 5 -column 2 -padx 0 -pady 2 -sticky nw;
	radiobutton $recess.versionradio_3 -text "2016"  -variable ::jobSettingParameter::version -value 2016 -anchor w -font {MS 8}
	grid $recess.versionradio_3 -row 5 -column 3 -padx 0 -pady 2 -sticky nw;
	
	label $recess.margin5 -text "" -font {MS 2} ;
    grid $recess.margin5 -row 6 -column 0 -padx 2 -pady 2 -sticky ew -columnspan 4;
	
	radiobutton $recess.radio_1 -text "Full analysis"  -variable ::jobSettingParameter::type -value 1 -anchor w -font {MS 10}
	grid $recess.radio_1 -row 7 -column 0 -padx 2 -pady 2 -sticky nw;
	
	label $recess.margin0 -text "" -font {MS 10} ;
    grid $recess.margin0 -row 9 -column 0 -padx 2 -pady 2 -sticky ew -columnspan 4;
	
    label $recess.jobPathLabel -text "Job路径（远程）" -font {MS 10}
    grid $recess.jobPathLabel -row 10 -column 0 -padx 2 -pady 2 -sticky nw;
	hwtk::choosedirentry $recess.jobPathEntry -width 16 -textvariable ::jobSettingParameter::jobPath
	grid $recess.jobPathEntry -row 11 -column 0 -padx 2 -pady 2 -sticky w -columnspan 4;
	grid configure $recess.jobPathEntry -sticky ew;
	
	
	label $recess.margin1 -text "" -font {MS 10} ;
    grid $recess.margin1 -row 12 -column 0 -padx 2 -pady 2 -sticky ew -columnspan 4;
	
	label $recess.tempPathLabel -text "Temp路径（远程）" -font {MS 10}
    grid $recess.tempPathLabel -row 13 -column 0 -padx 2 -pady 2 -sticky nw
	hwtk::choosedirentry $recess.tempPathEntry -width 16 -textvariable ::jobSettingParameter::tempPath
	grid $recess.tempPathEntry -row 14 -column 0 -padx 2 -pady 2 -sticky ew -columnspan 4;
	grid configure $recess.jobPathEntry -sticky ew;
	
	label $recess.margin2 -text "" -font {MS 10} ;
    grid $recess.margin2	 -row 15 -column 0 -padx 2 -pady 2 -sticky ew -columnspan 4;
	::hwt::LabeledLine $recess.end_line "";
    grid $recess.end_line -row 16 -column 0 -pady 6 -sticky ew -columnspan 4;
	
	label $recess.nCpuLabel -text "CPU核数" -font {MS 10} ;
    grid $recess.nCpuLabel -row 17 -column 0 -padx 2 -pady 2 -sticky nw;
    entry $recess.nCpuEntry -width 16 -textvariable ::jobSettingParameter::nCpu
    grid $recess.nCpuEntry -row 17 -column 3 -padx 2 -pady 2 -sticky nw;
	
	label $recess.margin3 -text "" -font {MS 2} ;
    grid $recess.margin3 -row 18 -column 0 -padx 2 -pady 2 -sticky ew -columnspan 4;
	
	label $recess.memoryLabel -text "内存百分比" -font {MS 10} ;
    grid $recess.memoryLabel -row 19 -column 0 -padx 2 -pady 2 -sticky nw;
    entry $recess.memoryEntry -width 16 -textvariable ::jobSettingParameter::memory
    grid $recess.memoryEntry -row 19 -column 3 -padx 2 -pady 2 -sticky nw;
	
	label $recess.margin4 -text "" -font {MS 2} ;
    grid $recess.margin4 -row 20 -column 0 -padx 2 -pady 2 -sticky ew -columnspan 4;
	
	label $recess.motion -text "*请确认已开启远程监控" -font {MS 8} ; 
	grid $recess.motion -row 22 -column 0 -padx 2 -pady 2 -sticky nw;
	
	# ===================
	::hwt::RemoveDefaultButtonBinding $recess;
	::hwt::PostWindow jobSettingWin -onDeleteWindow ::jobSettingWin::Quit;
}

# 退出
proc ::jobSetting::Quit { args } {
	*clearmarkall 1
	*clearmarkall 2
	::hwt::UnpostWindow jobSettingWin;
}

# 提交
proc ::jobSetting::OKQuit { args } {
	*clearmarkall 1
	*clearmarkall 2
	set nCpu $::jobSettingParameter::nCpu
	set memory $::jobSettingParameter::memory
	set version $::jobSettingParameter::version
	set type $::jobSettingParameter::type
	set jobPath $::jobSettingParameter::jobPath
	set tempPath $::jobSettingParameter::tempPath
	source $::jobSetting::filepath$jobSubmit.tcl 
	# jobSubmit $nCpu $memory $version $type $jobPath $tempPath
	::hwt::UnpostWindow jobSettingWin;
}

::jobSetting::GUI
