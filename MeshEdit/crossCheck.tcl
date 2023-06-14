# Hypermesh2021
namespace eval ::crossCheck {
    variable recess
    variable compID_1
    variable compID_2
    variable tolerance
}

if {[info exists ::crossCheck::tolerance]==0} {set ::crossCheck::tolerance 0.001}


# Hypermesh 语法格式
# *tetmesh entity_type1 mark_id1 mode1 entity_type2 mark_id2 mode2 string_array number_of_strings
# mode1
	# -1 - Ignored (inactive input)
	# 0 - Float without boundary layer
	# 1 - Fixed without boundary layer
	# 2 - Float with boundary layer
	# 3 - Fixed with boundary layer
	# 4 - Size control boxes
	# 5 - Anchor nodes
	# 6 - 3D re-mesh
	# 7 - 3D re-mesh with free boundary swappable-float.
	# 8 - 3D re-mesh with free boundary remeshable-float.
	# 9 - Remeshable-float without BL
	# 10 - Remeshable-float with BL,
	# 11 - Elem input for fluid volume selection. Either touched (or normal pointed into) are fluid volumes.
# mode2
	# -1 - Ignored (inactive input)
	# 0 - Float without boundary layer
	# 1 - Fixed without boundary layer
	# 2 - Float with boundary layer
	# 3 - Fixed with boundary layer
	# 4 - Size control boxes
	# 5 - Anchor nodes
	# 6 - 3D re-mesh
	# 7 - 3D re-mesh with free boundary swappable-float.
	# 8 - 3D re-mesh with free boundary remeshable-float.
	# 9 - Remeshable-float without BL
	# 10 - Remeshable-float with BL,
	# 11 - Elem input for fluid volume selection. Either touched (or normal pointed into) are fluid volumes.

proc crossCheck {elemMarkId mode tolerance angle} {
	*createstringarray 1 "shchk: $mode $tolerance $angle"
	*tetmesh elements $elemMarkId 3 elements $elemMarkId 1 1 1
}

proc ::crossCheck::GUI { args } {
    variable recess;

    set minx [winfo pixel . 225p];
    set miny [winfo pixel . 225p];
    if {![OnPc]} {set miny [winfo pixel . 240p];}
    set graphArea [hm_getgraphicsarea];
    set x [lindex $graphArea 0];
    set y [lindex $graphArea 1];
    
    # 主窗口
    ::hwt::CreateWindow crossCheckWin \
        -windowtitle "交叉检查" \
        -cancelButton "取消" \
        -cancelFunc ::crossCheck::Quit \
        -addButton OK ::crossCheck::OkExit no_icon \
        -resizeable 1 1 \
        -propagate 1 \
        -minsize $minx $miny \
        -geometry ${minx}x${miny}+${x}+${y} \
         noGeometrySaving;
    ::hwt::KeepOnTop .crossCheckWin;

    set recess [::hwt::WindowRecess crossCheckWin];

    grid columnconfigure $recess 1 -weight 1;
    grid rowconfigure    $recess 20 -weight 1;

    # ===================
    label $recess.baseLabel -text "2D Elements" -font {MS 10} ;
    grid $recess.baseLabel -row 3 -column 0 -padx 2 -pady 2 -sticky nw;

    button $recess.baseButton \
        -text "Elems" \
        -command ::crossCheck::fun_elemButton \
        -width 16 \
        -font {MS 10} \
		-relief groove
    grid $recess.baseButton -row 4 -column 0 -padx 2 -pady 2 -sticky nw;


    # ===================
    ::hwt::LabeledLine $recess.end_line "";
    grid $recess.end_line -row 5 -column 0 -pady 6 -sticky ew -columnspan 2;

    label $recess.vDelEntry_label -text "Tolerance" -font {MS 10} ;
    grid $recess.vDelEntry_label -row 6 -column 0 -padx 2 -pady 2 -sticky nw;
    entry $recess.vDelEntry -width 16 -textvariable ::crossCheck::tolerance -text $::crossCheck::tolerance
    grid $recess.vDelEntry -row 6 -column 1 -padx 2 -pady 2 -sticky nw;

    ::hwt::RemoveDefaultButtonBinding $recess;
    ::hwt::PostWindow crossCheckWin -onDeleteWindow ::crossCheck::Quit;
}

proc ::crossCheck::elemButton {args} {
	*createmarkpanel elems 1 "select elements"
	set ::crossCheck::elems [hm_getmark elems 1]
}

proc ::crossCheck::Quit { args } {
	*clearmarkall 1
	*clearmarkall 2
	::hwt::UnpostWindow crossCheckWin;
}

proc ::crossCheck::OkExit { args } {
	crossCheck $::crossCheck::compId_1 $::crossCheck::compId_2 $::crossCheck::tolerance
}

*clearmarkall 1
*clearmarkall 2
::crossCheck::GUI;

