namespace eval ::preSetting {
    # 监控参数
	variable type
	variable files
}

if {[info exists ::preSetting::type]==0}		{set ::preSetting::type stl}

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
        -windowtitle "批量导出" \
        -cancelButton "取消" \
		-cancelFunc ::jobSetting::Quit \
		-addButton "导出" ::jobSetting::OKQuit no_icon \
		-resizeable 1 1 \
        -propagate 1 \
        -minsize $minx $miny \
		-geometry ${minx}x${miny}+${x}+${y} \
         noGeometrySaving;
    ::hwt::KeepOnTop .jobSettingWin;
	
	set recess [::hwt::WindowRecess jobSettingWin];

    grid columnconfigure $recess 4 -weight 5;
    grid rowconfigure    $recess 30 -weight 1;
	
	label $recess.versionLabel -text "项目类型：" -font {MS 10} ;
    grid $recess.versionLabel -row 4 -column 0 -padx 1 -pady 2 -sticky nw;
	radiobutton $recess.typeRadio_stl -text "stl"  -variable ::preSetting::type -value stl -anchor w -font {MS 8}
	grid $recess.typeRadio_stl -row 5 -column 1 -padx 0 -pady 2 -sticky nw;

	radiobutton $recess.typeRadio_inp -text "inp"  -variable ::preSetting::type -value inp -anchor w -font {MS 8}
	grid $recess.typeRadio_inp -row 5 -column 2 -padx 0 -pady 2 -sticky nw;
	
	label $recess.jobPathLabel -text "选择文件" -font {MS 10}
    grid $recess.jobPathLabel -row 6 -column 0 -padx 2 -pady 2 -sticky nw;
	hwtk::openfileentry $recess.filesEntry -multiple 1 -width 40 -textvariable ::preSetting::files
	grid $recess.filesEntry -row 7 -column 0 -padx 2 -pady 2 -sticky w -columnspan 4;
	grid configure $recess.filesEntry -sticky ew;
	# ===================
	::hwt::RemoveDefaultButtonBinding $recess;
	::hwt::PostWindow jobSettingWin -onDeleteWindow ::jobSettingWin::Quit;
}

proc inputFiles { filesDir {type "stl"}} {
	# 导入
	*clearmark collections 1
	*clearmark collections 2
	*clearmark controllers 1

	if {$type == "stl"} {
		set inputType \#stl\\stl
		*createstringarray 11 "Abaqus " "Standard3D " "ALESMOOTHINGS_DISPLAY_SKIP " \
		"EXTRANODES_DISPLAY_SKIP " "ACCELEROMETERS_DISPLAY_SKIP " "SOLVERMASSES_DISPLAY_SKIP " \
		"LOADCOLS_DISPLAY_SKIP " "RETRACTORS_DISPLAY_SKIP " "VECTORCOLS_DISPLAY_SKIP " \
		"SYSTCOLS_DISPLAY_SKIP " "PRIMITIVES_DISPLAY_SKIP " "BLOCKS_DISPLAY_SKIP " \
		"CONSTRAINEDRIGIDBODY_DISPLAY_SKIP " "ELEMENTCLUSTERS_DISPLAY_SKIP " "CROSSSECTION_DISPLAY_SKIP " \
		"RIGIDWALLS_DISPLAY_SKIP " "SLIPRINGS_DISPLAY_SKIP " "CONTACTSURF_DISPLAY_SKIP " \
		"\[DRIVE_MAPPING=\] " "IDRULES_SKIP " "BOM_SUBSYSTEMS_SKIP " "CREATE_PART_HIERARCHY " \
		"IMPORT_MATERIAL_METADATA "
	}
	if {$type == "inp"} {
		set inputType \#abaqus\\abaqus
		*createstringarray 11 "Abaqus " "Standard3D " "LOADCOLS_DISPLAY_SKIP " "SYSTCOLS_DISPLAY_SKIP " \
		"PRIMITIVES_DISPLAY_SKIP " "CROSSSECTION_DISPLAY_SKIP " "CONTACTSURF_DISPLAY_SKIP " \
		"\[DRIVE_MAPPING=\] " "IDRULES_SKIP " "BOM_SUBSYSTEMS_SKIP " "IMPORT_MATERIAL_METADATA "
	}

	foreach fileName $filesDir {
		set partName [split $fileName .]
		set partName [lindex $partName 0]
		set partName [split $partName /]
		set partName [lindex $partName end]
		*feinputwithdata2 "$inputType" "$fileName" 0 0 0 0 0 1 11 1 0
		*drawlistresetstyle 
		
		# 更改名称：与fileName[-1]一致
		set compId [expr [hm_entityinfo maxid comps]]
		*setvalue comps id=$compId name=$partName
		*clearmarkall 1
		*clearmarkall 2
	}
}

# 退出
proc ::jobSetting::Quit { args } {
	catch {
		*clearmarkall 1
		*clearmarkall 2
	}
	::hwt::UnpostWindow jobSettingWin;
}

# 导入
proc ::jobSetting::OKQuit { args } {
	*clearmarkall 1
	*clearmarkall 2
	inputFiles $::preSetting::files $::preSetting::type
	::hwt::UnpostWindow jobSettingWin;
}

::jobSetting::GUI