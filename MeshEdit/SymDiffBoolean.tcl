# Hypermesh 2021
# 求两个Comps的单元对称差集

namespace eval ::SymDiffBoolean {
    variable recess
    variable compID_1
    variable compID_2
    variable tolerance
}

if {[info exists ::SymDiffBoolean::tolerance]==0} {set ::SymDiffBoolean::tolerance 0.001}

# 路径定义
set filepath [file dirname [info script]]

if {[info exists ::SymDiff::tolerance]==0} {set ::SymDiff::tolerance 0.001}


proc symDiffBoolean {compID_1 compID_2 {tolerance 0.001}} {
	### 求两个Comps的单元对称差集，即A△B={x|x∈A∪B,x∉A∩B}

	# 网格布尔求并集
	*createmark components 1 "by id only"  $compID_1
	*createmark components 2 "by id only"  $compID_2
	*remesh_master_slave_boolean components 1 components 2 "do_boolean_difference 0 remove_new_duplicates 1 angle 30 tria_remesh_growth_ratio 1.35 tria_remesh_span_angle 30 use_adaptive_tria_remesh 1 num_remesh_layers 2 keep_intersect_edges 0 break_shell_along_component_boundaries 0"
	
	# 创建对应的new comps，并记录ID
	# 复制单元到new comps
	*createmark elements 1 "by comps id" $compID_1
	*createentitysameas components $compID_1
	set compID_1_1 [hm_entitymaxid comps]
	set compName_1_1 [hm_getvalue comps id=$compID_1_1 dataname=name]
	*copymark elements 1 $compName_1_1
	*clearmark elements 1
	
	*createmark elements 1 "by comps id" $compID_1
	*createentitysameas components $compID_1
	set compID_1_2 [hm_entitymaxid comps]
	set compName_1_2 [hm_getvalue comps id=$compID_1_2 dataname=name]
	*copymark elements 1 $compName_1_2
	*clearmark elements 1
	
	*createmark elements 1 "by comps id" $compID_2
	*createentitysameas components $compID_2
	set compID_2_1 [hm_entitymaxid comps]
	set compName_2_1 [hm_getvalue comps id=$compID_2_1 dataname=name]
	*copymark elements 1 $compName_2_1
	*clearmark elements 1
	
	*createmark elements 1 "by comps id" $compID_2
	*createentitysameas components $compID_2
	set compID_2_2 [hm_entitymaxid comps]
	set compName_2_2 [hm_getvalue comps id=$compID_2_2 dataname=name]
	*copymark elements 1 $compName_2_2
	*clearmark elements 1
	
	# 使用New comps中的单元做网格布尔求差集（不变动单元）
	*createmark components 1 "by id only"  $compID_1_1
	*createmark components 2 "by id only"  $compID_2_1
	*remesh_master_slave_boolean components 1 components 2 "do_boolean_difference 1 remove_new_duplicates 1 num_remesh_layers -1 keep_intersect_edges 0 break_shell_along_component_boundaries 0"
	
	*createmark components 1 "by id only"  $compID_1_2
	*createmark components 2 "by id only"  $compID_2_2
	*remesh_master_slave_boolean components 1 components 2 "do_boolean_difference 1 remove_new_duplicates 1 num_remesh_layers -1 keep_intersect_edges 0 break_shell_along_component_boundaries 0"
	
	# 合并两个差集(1_1和2_2)
	*createmark elements 1 "by comps id" $compID_2_2
	*copymark elements 1 $compName_1_1
	*clearmark elements 1
	
	# 删除多余的comps
	*createmark components 1 $compName_1_2
	*deletemark components 1
	
	*createmark components 1 $compName_2_1
	*deletemark components 1
	
	*createmark components 1 $compName_2_2
	*deletemark components 1
	
	# 合并节点，默认tolerance=0.001
	*createmark elements 1 "by comp id" $compID_1_1
	*equivalence elements 1 $tolerance 1 0 0
	}
	
proc ::SymDiffBoolean::GUI { args } {
    variable recess;

    set minx [winfo pixel . 225p];
    set miny [winfo pixel . 225p];
    if {![OnPc]} {set miny [winfo pixel . 240p];}
    set graphArea [hm_getgraphicsarea];
    set x [lindex $graphArea 0];
    set y [lindex $graphArea 1];
    
    # 主窗口
    ::hwt::CreateWindow symDiffBooleanWin \
        -windowtitle "对称差集" \
        -cancelButton "取消" \
        -cancelFunc ::SymDiffBoolean::Quit \
        -addButton OK ::SymDiffBoolean::OkExit no_icon \
        -resizeable 1 1 \
        -propagate 1 \
        -minsize $minx $miny \
        -geometry ${minx}x${miny}+${x}+${y} \
         noGeometrySaving;
    ::hwt::KeepOnTop .symDiffBooleanWin;

    set recess [::hwt::WindowRecess symDiffBooleanWin];

    grid columnconfigure $recess 1 -weight 1;
    grid rowconfigure    $recess 20 -weight 1;

    # ===================
    label $recess.baseLabel -text "Component 1" -font {MS 10} ;
    grid $recess.baseLabel -row 3 -column 0 -padx 2 -pady 2 -sticky nw;

    button $recess.baseButton \
        -text "comp1" \
        -command ::SymDiffBoolean::fun_comp1Button \
        -width 16 \
        -font {MS 10} \
		-relief groove
    grid $recess.baseButton -row 4 -column 0 -padx 2 -pady 2 -sticky nw;

    # ===================
    label $recess.targetLabel -text "Component 2" -font {MS 10} ;
    grid $recess.targetLabel -row 3 -column 1 -padx 2 -pady 2 -sticky nw;

    button $recess.targetButton \
        -text "comp2" \
        -command ::SymDiffBoolean::fun_comp2Button \
        -width 16 \
        -font {MS 10} \
		-relief groove
    grid $recess.targetButton -row 4 -column 1 -padx 2 -pady 2 -sticky nw;

    # ===================
    ::hwt::LabeledLine $recess.end_line "";
    grid $recess.end_line -row 5 -column 0 -pady 6 -sticky ew -columnspan 2;

    label $recess.vDelEntry_label -text "Tolerance" -font {MS 10} ;
    grid $recess.vDelEntry_label -row 6 -column 0 -padx 2 -pady 2 -sticky nw;
    entry $recess.vDelEntry -width 16 -textvariable ::SymDiffBoolean::tolerance -text $::SymDiffBoolean::tolerance
    grid $recess.vDelEntry -row 6 -column 1 -padx 2 -pady 2 -sticky nw;

    ::hwt::RemoveDefaultButtonBinding $recess;
    ::hwt::PostWindow symDiffBooleanWin -onDeleteWindow ::SymDiffBoolean::Quit;
}

proc ::SymDiffBoolean::fun_comp1Button {args} {
	*createmarkpanel comps 1 "select the components"
	set ::SymDiffBoolean::compId_1 [hm_getmark comps 1]
}

proc ::SymDiffBoolean::fun_comp2Button {args} {
	*createmarkpanel comps 1 "select the components"
	set ::SymDiffBoolean::compId_2 [hm_getmark comps 1]
}

proc ::SymDiffBoolean::Quit { args } {
	*clearmarkall 1
	*clearmarkall 2
	::hwt::UnpostWindow symDiffBooleanWin;
}

proc ::SymDiffBoolean::OkExit { args } {
	symDiffBoolean $::SymDiffBoolean::compId_1 $::SymDiffBoolean::compId_2 $::SymDiffBoolean::tolerance
}

*clearmarkall 1
*clearmarkall 2
::SymDiffBoolean::GUI;