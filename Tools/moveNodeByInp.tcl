# hypermesh 2021
# 根据Inp文件中的节点信息调整HM模型的节点位置


# GUI
if {[grab current] != ""} { return; }
namespace eval ::inpFile {
    variable recess
	variable filepath
	variable fileName
}
# 路径定义
set ::inpFile::filepath [file dirname [info script]]

proc ::inpFile::GUI { args } {
	variable recess

	set minx [winfo pixel . 260p];
    set miny [winfo pixel . 300p];
	if {![OnPc]} {set miny [winfo pixel . 300p];}
    set graphArea [hm_getgraphicsarea];
    set x [lindex $graphArea 0];
    set y [lindex $graphArea 1];
    
    # 主窗口
    ::hwt::CreateWindow inpFileWin \
        -windowtitle "选择INP文件" \
        -cancelButton "取消" \
		-cancelFunc ::inpFile::Quit \
		-addButton "选择" ::inpFile::OKQuit no_icon \
		-resizeable 1 1 \
        -propagate 1 \
        -minsize $minx $miny \
		-geometry ${minx}x${miny}+${x}+${y} \
         noGeometrySaving;
    ::hwt::KeepOnTop .inpFileWin;
	
	set recess [::hwt::WindowRecess inpFileWin];

    grid columnconfigure $recess 4 -weight 5;
    grid rowconfigure    $recess 30 -weight 1;
	
	label $recess.jobPathLabel -text "选择文件" -font {MS 10}
    grid $recess.jobPathLabel -row 6 -column 0 -padx 2 -pady 2 -sticky nw;
	hwtk::openfileentry $recess.filesEntry -width 40 -textvariable ::inpFile::fileName
	grid $recess.filesEntry -row 7 -column 0 -padx 2 -pady 2 -sticky w -columnspan 4;
	grid configure $recess.filesEntry -sticky ew;
	# ===================
	::hwt::RemoveDefaultButtonBinding $recess;
	::hwt::PostWindow inpFileWin -onDeleteWindow ::inpFileWin::Quit;
}

proc chooseInpFile { fileName } {
	# 选择文件
	set inp_file [open $fileName r]
	
	# 匹配字段 *Node
	while {[gets $inp_file line] != -1} {
		if {[string match "*NODE" $line]} {
			set node_coords {}
			continue
		}
		
		if {[string match "*Node" $line]} {
			set node_coords {}
			continue
		}
		
		if {[string match "*ELEMENT" $line]} {
			break
		}
		
		if {[string match "*Element" $line]} {
			break
		}
		
		if {[string match "**HWCOLOR" $line]} {
			break
		}

		set fields [regexp -all -inline {\S+} $line]
		if {[llength $fields] == 4} {
			catch {
				lappend node_coords [lindex $fields 0] [lindex $fields 1] [lindex $fields 2] [lindex $fields 3]	
			}
		}
	}
	
	close $inp_file

	foreach {node_id x y z} $node_coords {
		catch {
			# *nodemodify $node_id $x $y $z
			# 计算平移量
			set coords [hm_getvalue nodes id=$node_id dataname=localcoordinates]
			set dx [expr $x - [lindex $coords 0]]
			set dy [expr $y - [lindex $coords 1]]
			set dz [expr $z - [lindex $coords 2]]
			*createmark nodes 1 "by id" $node_id
			# 节点平移
			
		}
	}
}

# 退出
proc ::inpFile::Quit { args } {
	*clearmarkall 1
	*clearmarkall 2
	::hwt::UnpostWindow inpFileWin;
}

# 选择
proc ::inpFile::OKQuit { args } {
	*clearmarkall 1
	*clearmarkall 2
	chooseInpFile $::inpFile::fileName
	::hwt::UnpostWindow inpFileWin;
}

::inpFile::GUI