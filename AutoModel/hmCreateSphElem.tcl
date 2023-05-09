# HWVERSION_2021.0.0.33_Jan 14 2021_21:19:15 
##  Filename:   hmCreateSphElem.tcl
##  Purpose:    TCL file to run SPH ELEMENT Creation For Abaqus user profile
##  Version:    HyperWorks 12.0-110
##  Copyright:  2002 Altair Engineering Inc., All rights reserved.
##############################################################################
source [file join [hm_info -appinfo SPECIFIEDPATH hw_tcl_common] "hw" "collector" "hwcollector.tcl"]
namespace  eval ::CreateSphElem_gui:: {
    variable rowUp;
    variable rowDown;
    variable status;
    array set ::CreateSphElem_gui::_Sphvars {};
    set ::CreateSphElem_gui::_Sphvars(title) "SPH Meshing Tool";
    set ::CreateSphElem_gui::_Sphvars(window) .dlgSph;
}

proc ::CreateSphElem_gui::CreateSphElemDialog {} {
    variable _Sphvars;
    set minWidth [hwt::DluWidth 500 [hwt::AppFont]];
    set minHeight [::hwt::DluHeight 200 [::hwt::AppFont]];
    set nspace [namespace current];
    if {[winfo exists $_Sphvars(window)]} {
	return;
        #catch {destroy $_Sphvars(window)}
    }
    set ::CreateSphElem_gui::_Sphvars(sphdlg) [::hwtk::dialog $_Sphvars(window) \
            -title      $::CreateSphElem_gui::_Sphvars(title) \
			-destroyonunpost 1 \
            -minheight  $minHeight \
            -minwidth   $minWidth \
            -x 100 \
            -y 150 ]
    
    set seframe	[$::CreateSphElem_gui::_Sphvars(sphdlg) recess]
    ::CreateSphElem_gui::PopulateSphDlg $seframe $nspace;
    $_Sphvars(window) hide apply
    $_Sphvars(window) buttonconfigure ok -text Mesh -command ::CreateSphElem_gui::Mesh
    $_Sphvars(window) post;
    
}
proc ::CreateSphElem_gui::HelpCommand {W I C E} {
    switch -- $C {
        1 {
            return "Select Components to Mesh"
        }
        2 {
            return "Components Entry"
        }
        3 {
            return "Meshing Methods"
        }
        4 {
            return "Enter Pitch Value"
        }
        5 {
            return "Enter Material Density"
        }
        6 {
            return "Meshing Status"
        }
    }
    return "[info level 0]"
}
####################################################################
#populate proc of SPH create element window
####################################################################
proc ::CreateSphElem_gui::PopulateSphDlg {seframe nspace} {
    variable rowUp;
    variable rowDown;
    variable status;
    set ::CreateSphElem_gui::CreatePropComp 0;
    set ::CreateSphElem_gui::CreateSurface 0;
    set topFrame [::hwtk::frame $seframe.f1 ]
    pack $topFrame -side top -anchor nw
    
    set sel_lbl [::hwtk::label $topFrame.b1 -text "Select Components:" -justify center -padding 5]
    pack $sel_lbl -side left
    
    set components [ Collector $topFrame.components entity 1 HmMarkCol \
            -types "Components" \
            -withtype 0 \
            -withReset 0 \
            -callback ::CreateSphElem_gui::Gopanels]
    pack $topFrame.components -side left -anchor nw -padx 4 -pady 4;
    
    set tableFrame [::hwtk::frame $seframe.f2 ]
    pack $tableFrame -side left -anchor nw -fill both -expand true
    
    set ::CreateSphElem_gui::SphTable [::hwtk::table $tableFrame.tbl1 -helpcommand "::CreateSphElem_gui::HelpCommand %W %I %C %E" -closeeditor 1]
    pack $::CreateSphElem_gui::SphTable -side top -anchor nw -expand 1 -fill both
    $::CreateSphElem_gui::SphTable columncreate select -text "Selection" -type boolcheck
    $::CreateSphElem_gui::SphTable columncreate comp -text "Component Name" -type combobox -validatecommand "::CreateSphElem_gui::ValidateComps %I {%V}"  -valuelistcommand "::CreateSphElem_gui::GetComps"
    $::CreateSphElem_gui::SphTable columncreate mesh -text "Meshing Method" -type combobox  -valuelistcommand "::CreateSphElem_gui::GetValues"
    $::CreateSphElem_gui::SphTable columncreate pitch -text "Pitch" -type real -validatecommand "::CreateSphElem_gui::ValidatePitch %I %C %V"
    $::CreateSphElem_gui::SphTable columncreate density -text "Material Density" -type real -validatecommand "::CreateSphElem_gui::DensityValidate %I %V"
    $::CreateSphElem_gui::SphTable columncreate status -text "Status" -image palette-16.png -type intcolor -editable 0
    
    set chk_btn_prop [::hwtk::checkbutton $tableFrame.chk_btn1 -text "Create Property and Material" -variable ::CreateSphElem_gui::CreatePropComp ]
    set chk_btn_surf [::hwtk::checkbutton $tableFrame.chk_btn2 -text "Create Surface" -variable ::CreateSphElem_gui::CreateSurface ]
    pack $chk_btn_prop -side top -anchor nw
    pack $chk_btn_surf -side top -anchor nw
    
    set butFrame [::hwtk::frame $seframe.f3 ]
    pack $butFrame -side right -anchor center -padx {2 0}
    
    set addRow [hwtk::toolbutton $butFrame.addRow -image tableAppendRow-24.png -help "Add Row" -command ::CreateSphElem_gui::AddRow ]
    set delRow [hwtk::toolbutton $butFrame.deleteRow -image tableDeleteSelected-24.png -help "Delete Selected Row" -command ::CreateSphElem_gui::DeleteRow ]
    #set rowUp [hwtk::button $butFrame.rowUp -image arrowUp-7.png -help "Move the Selcted Row Up" -state disabled -command ::CreateSphElem_gui::RowUp ]
    #set rowDown [hwtk::button $butFrame.rowdown -image arrowDown-16.png -help "Move Selcted RowDown" -state disabled -command ::CreateSphElem_gui::RowDown ]
    
    ##### Right click action on Selection button
    set selectall [hwtk::menu $::CreateSphElem_gui::SphTable.s]
    $selectall item selectall -caption "Select All" -command "::CreateSphElem_gui::UnSelectAll 1"
    $selectall item Unselectall -caption "Unselect All" -command "::CreateSphElem_gui::UnSelectAll 0"
    $::CreateSphElem_gui::SphTable  columnconfigure select -headermenu $selectall
    
    ##### Right click action on Meshing method
    set meshing [hwtk::menu $::CreateSphElem_gui::SphTable.m]
    $meshing item FaceCenteredCubic -caption " Face-Centered-Cubic" -command "::CreateSphElem_gui::MeshingMethod Face-Centered-Cubic"
    $meshing item NodetoSPH -caption " Node-to-SPH" -command "::CreateSphElem_gui::MeshingMethod Node-to-SPH "
    $meshing item SimpleCubic -caption " Simple-Cubic" -command "::CreateSphElem_gui::MeshingMethod Simple-Cubic"
    $::CreateSphElem_gui::SphTable columnconfigure mesh -headermenu $meshing 
    
    pack $addRow $delRow 
    
}

##########################################################################
#proc to validate the pitch entry for negavtive values
##########################################################################
proc ::CreateSphElem_gui::ValidatePitch {row col value} {
    if {$value == ""} { return 0;}
    set val [expr abs($value)]
    if {$value < 0} {
	    $::CreateSphElem_gui::SphTable cellset $row,$col $val
	    return 0;
    } else {
	    return 1;
    }
}
#########################################################################
proc ::CreateSphElem_gui::GetValues args {
    return "Simple-Cubic Face-Centered-Cubic Node-to-SPH"
}
#########################################################################

#########################################################################
proc ::CreateSphElem_gui::GetComps {args} {
    *createmark comps 1 all
    set compnames [hm_getvalue comps mark=1 dataname=name]
    return $compnames
}
##########################################################################

#########################################################################
proc ::CreateSphElem_gui::Gopanels args {
    variable _Sphvars;
	set ::CreateSphElem_gui::newElems "";
	    switch -- [lindex $args 0] {
            "getadvselmethods" {
				wm withdraw $_Sphvars(window);
				set entity_type [lindex $args 1]
				hm_markclear components 1
				*createmarkpanel components 1 "Select Components"
				if { [hm_marklength comps 1] ne 0 } { 
				  set ::CreateSphElem_gui::newElems [hm_getmark $entity_type 1]
				}
				hm_markclear $entity_type 1
				wm deiconify $_Sphvars(window);
            }
			"reset" {
				set ::CreateSphElem_gui::newElems "";
			}
			default {
                return 0;
            }
        }
		if {[llength $::CreateSphElem_gui::newElems] != 0}  {
			::CreateSphElem_gui::AddCompsToTable;
		}
    return 1;
}

##########################################################################

##########################################################################
#proc to select component entity from the panel
##########################################################################
proc ::CreateSphElem_gui::SelectEntity { type label args} {
    switch [string tolower $type] {
        "comps" -
        "components" {
            set entity "components"
        }
        default {
            Message "'$type' is not a valid enity type for ::AbaqusCW::SelectEntity function"
            return "";
        }
    }
    switch [lindex $args 0] {
        SELECT_ONE {
            set Max 1
            set Min 1
        }
        SELECT_ANY {
            set Max -1
            set Min 1
        }
        SELECT_UP_TO_ONE {
            set Max 1
            set Min 0
        }
        default {
            set Max -1
            set Min 0
        }
    }
    
    while {1} {
        hm_markclear $entity 1
        if {[string tolower $type] == "node"} {
            #*nodecleartempmark
        }
        *createmarkpanel $entity 1 $label
        
        set entity1List  [ hm_getmark $entity 1 ]
        set numentity1  [ llength $entity1List]
        set error_msg "none";
        
        if {$numentity1 < $Min} {
            if {$Min == 1} {
                set error_msg "No $entity selected."
            } else {
                set error_msg "Not enough $entity selected. At least $Min $entity should be selected."
            }
        } elseif {($Max != -1) && ($numentity1 > $Max)} {
            set error_msg "Too many $entity selected. No more then $Max $entity should be selected."
        }
        if {$error_msg != "none"} {
            set error_msg "$error_msg \n Do you want to go back to the $entity selection?"
            if { [ Message msgTheme   msgReplyTheme \
                        msgAccept  "   Yes   " \
                        msgCancel  "   No" \
                        msgText    $error_msg ] } {
                continue;
            } else {
                set entity1List {};
                break;
            }
        } else {
            break;
        }
    }
    set entity1List;
}

#############################################################################
#proc to add comps to table
#############################################################################
proc ::CreateSphElem_gui::AddCompsToTable args {
    set comp_nam {}
    set rows [lsort [$::CreateSphElem_gui::SphTable rowlist]]
    ###existing comps in table
    foreach single_row $rows {
        lappend comp_nam [$::CreateSphElem_gui::SphTable cellget $single_row,comp]
    }
    
    ####newly selected comps
    foreach id $::CreateSphElem_gui::newElems {
        lappend comp_list [hm_getvalue comps id=$id dataname=name ]
    }
    incr row [llength $rows]
    
    foreach item $comp_list {
        #####avoiding duplicates
        if {$item ni $comp_nam} {
            if { [::CreateSphElem_gui::CheckSPHelems \"$item\"] } {
                set statusColor 5;
            } else {
                set statusColor 2;
            }
            set values "select 0 comp {$item} mesh Simple-Cubic pitch 1.000 density 0.1 status $statusColor"
            $::CreateSphElem_gui::SphTable rowinsert end row$row -values $values
            incr row
        }
    }
}

###############################################################################
#procedure to Add,Delete,MoveUp,MoveDown the selected row
###############################################################################
proc ::CreateSphElem_gui::AddRow args {
    set row_desc [lindex [$::CreateSphElem_gui::SphTable rowlist] end]
	if {$row_desc != ""} {
		set row_desc [expr [regsub -all row $row_desc ""] + 1]; 
	} else {
		set row_desc 1;
	}
	
    $::CreateSphElem_gui::SphTable rowinsert end row$row_desc -values [list select 0 comp "" mesh "Simple-Cubic" pitch 1.000 density 0.1 status 2]
}


################################################################################
#procedure to Delete selected rows
################################################################################
proc ::CreateSphElem_gui::DeleteRow {args} {
    set row_list [lsort [$::CreateSphElem_gui::SphTable rowlist]]
    if {[llength $row_list] == 0} {
        return;
    }
    set lst {}
    foreach rownumb $row_list {
        set status [$::CreateSphElem_gui::SphTable cellget $rownumb,select]
        if {bool($status)} {
            lappend lst $rownumb
        }
    }
    set lst [list $lst]
    uplevel $::CreateSphElem_gui::SphTable rowdelete $lst
}


#################################################################################
#Procedure to Move the selectec row one Position Up
#################################################################################
proc ::CreateSphElem_gui::RowUp {args} {
    variable rowUp;
    variable _Sphvars;
    
    event generate [lindex [winfo ch $::CreateSphElem_gui::SphTable] 0] <Configure>
    set sel_list {};
    set num_rows [$::CreateSphElem_gui::SphTable rowlist]
    if {$num_rows != ""} {
        foreach var $num_rows {
            set status [$::CreateSphElem_gui::SphTable cellget $var,select]
            if {bool($status)} {
                lappend sel_list $var
            }
        }
        
        if {[llength $sel_list] >= 2} {
            $_Sphvars(window) statusmessage "please select the one row to move" error
            return;
        } elseif  {[llength $sel_list] == 1} {
            set pos [lsearch $num_rows $sel_list ]
            if {$pos != 0} {
                $::CreateSphElem_gui::SphTable rowmove [lindex $num_rows [expr $pos - 1]] $sel_list
                $_Sphvars(window) statusmessage "row moved up succesfuly"
            }
        }
    }
}

######################################################################################
#Procedure to Move the selectec row one Position Down
######################################################################################
proc ::CreateSphElem_gui::RowDown {args} {
    variable rowdown;
    variable _Sphvars;
    event generate [lindex [winfo ch $::CreateSphElem_gui::SphTable] 0] <Configure>
    set sel_list {};
    set num_rows [$::CreateSphElem_gui::SphTable rowlist]
    if {$num_rows != ""} {
        foreach var $num_rows {
            set status [$::CreateSphElem_gui::SphTable cellget $var,select]
            if {bool($status)} {
                lappend sel_list $var
            }
        }
        
        if {[llength $sel_list] >= 2} {
            $_Sphvars(window) statusmessage "PLEASE SELECT THE ONE ROW TO MOVE" error
            return;
        } elseif {[llength $sel_list] == 1} {
            set pos [lsearch $num_rows $sel_list ]
            if {[expr $pos + 1] != [llength $num_rows]} {
                $::CreateSphElem_gui::SphTable rowmove $sel_list [lindex $num_rows [expr $pos + 1] ]
                $_Sphvars(window) statusmessage "ROW MOVED DOWN SUCCESFULY"
            }
        }
    }
}


#####################################################################################
#Procdure to Select all the rows
#####################################################################################
proc ::CreateSphElem_gui::UnSelectAll {args} {
    set list [lsort [$::CreateSphElem_gui::SphTable rowlist]]
    if {$list == ""} {
        return;
    }
    foreach row $list {
        $::CreateSphElem_gui::SphTable cellset $row,select $args
    }
}

#####################################################################################
#
#####################################################################################
proc ::CreateSphElem_gui::MeshingMethod args {
    set list [lsort [$::CreateSphElem_gui::SphTable rowlist]]
    if {$list == ""} {
        return;
    }
    foreach row $list {
        $::CreateSphElem_gui::SphTable cellset $row,mesh $args
    }
}

#######################################################################################
#This proc is to restrict user to add duplicate component
#And also it gives the meshing status of the component
########################################################################################
proc ::CreateSphElem_gui::ValidateComps {I V} {
    variable _Sphvars;
    $_Sphvars(window) statusmessage ""
    set row_list [$::CreateSphElem_gui::SphTable rowlist]
    foreach row $row_list {
        lappend poulated_list [$::CreateSphElem_gui::SphTable cellget $row,comp]
    }
	regsub -all -- {"} $V {} V1
    if {[lsearch -regexp $poulated_list $V1] == -1} {
        if { [::CreateSphElem_gui::CheckSPHelems $V] } {
            set statusColor 5;
        } else {
            set statusColor 2;
        }
        $::CreateSphElem_gui::SphTable cellset $I,status $statusColor;
        return 1;
    } else {
        return 0;
    }
}


#########################################################################################
#proc to mesh selected comps
##########################################################################################
proc ::CreateSphElem_gui::Mesh args {
    variable _Sphvars;
    variable table_values;
    variable Meshcomparr;
    $_Sphvars(window) statusmessage ""
    ##check if any comps selected
    set Comps_list [lsort [$::CreateSphElem_gui::SphTable rowlist]]
    if {[llength $Comps_list] == 0} {
        return;
    }
    array unset Meshcomparr;
    foreach selected_comps $Comps_list {
        set status [$::CreateSphElem_gui::SphTable cellget $selected_comps,select]
        if {bool($status)} {
            set compname "";
            set pitch "";
            set method "";
            set density "";
            set compname [$::CreateSphElem_gui::SphTable cellget $selected_comps,comp]
            set pitch [$::CreateSphElem_gui::SphTable cellget $selected_comps,pitch]
            set method   [$::CreateSphElem_gui::SphTable cellget $selected_comps,mesh]
            set density   [$::CreateSphElem_gui::SphTable cellget $selected_comps,density]
            
            update idletasks;
            set Meshcomparr($compname) [list $pitch $method $density $selected_comps];
        }
        hm_setpanelproc "::CreateSphElem_gui::SPHMesh;";
        update idletasks;
        hm_setpanelproc "::CreateSphElem_gui::OrganizeCompElems;";
        update idletasks;
    }
}

############################################################################################
# Procedure is to Organize the PC3D elems into props and updating existing props and mats
#############################################################################################
proc ::CreateSphElem_gui::OrganizeCompElems args {
    variable Meshcomparr;
    variable CompPropMaparr;
    set compNameIndex [array names Meshcomparr];
    
    foreach compName $compNameIndex {
        set pitch [lindex $Meshcomparr($compName) 0];
        set method [lindex $Meshcomparr($compName) 1];
        set density [lindex $Meshcomparr($compName) 2];
        set halfpitch [expr $pitch*0.5];
        
        if {bool($::CreateSphElem_gui::CreatePropComp)} {
            if { [::CreateSphElem_gui::CheckSPHelems \"$compName\"] } {
				set tmpPropName ""
				set tmpMatName ""
				append tmpPropName HM_SPH_ $compName ;
				append tmpMatName HM_SPH_ $compName ;
				set propname [::hwat::utils::GetUniqueName properties $tmpPropName];
				set matname [::hwat::utils::GetUniqueName material $tmpMatName];
				if {[llength [file extension $propname]]} {
					set propname [join [split $propname "."] ""]
					set matname [join [split $matname "."] ""]
				}
				*createmark props 1 "by card image name" "SOLIDSECTION"
				if { [hm_marklength props 1] } {
					set proplist [hm_getvalue props mark=1 dataname=name]
					if {[lsearch $proplist $propname] == -1} {
						::CreateSphElem_gui::CreatePropertyMaterail $propname $matname;
					}
				} else {
					::CreateSphElem_gui::CreatePropertyMaterail $propname $matname;
				}
					::CreateSphElem_gui::AssignPropertyMaterial $propname $halfpitch $density;
					::CreateSphElem_gui::OrganizeElements $compName $propname;
					$::CreateSphElem_gui::SphTable cellset [lindex $Meshcomparr($compName) 3],status 3 
            }
        } else {
            if { [::CreateSphElem_gui::CheckSPHelems \"$compName\"] } {
                $::CreateSphElem_gui::SphTable cellset [lindex $Meshcomparr($compName) 3],status 3
            } 
        }
        if {bool($::CreateSphElem_gui::CreateSurface)} {
            if { [::CreateSphElem_gui::CheckSPHelems \"$compName\"] } {
               ::CreateSphElem_gui::CreateSurfaceNode $compName
            }
        }
    }
}

##############################################################################################
# This proc contains the Switch statement of Meshing method.
#*sphgenerate and *admascreatemultentselectwithsets commands executes here
###############################################################################################
proc ::CreateSphElem_gui::SPHMesh args {
    variable Meshcomparr;
    variable CompPropMaparr;

    set elemType 8;        #SPH Element [PC3D, Supported for Explicit only]
    set attachSetsFlag 0;  #by default we not creating node set, if user wants turn ON the flag
    set magnitude 1;       #Default Magnitude
    set vizNodeID 0;       #Default viznodeID = 0, if it is set then only @ that node id string will be displayed
    
    set x 0;
    set y 0;
    set z 0;
    set fillpercentage 100;
    set compNameIndex [array names Meshcomparr];
    array unset CompPropMaparr;
    
    foreach compName $compNameIndex {
        set pitch [lindex $Meshcomparr($compName) 0];
        set method [lindex $Meshcomparr($compName) 1];
        set density [lindex $Meshcomparr($compName) 2];
        set halfpitch [expr $pitch*0.5];

		# if {bool($::CreateSphElem_gui::CreatePropComp)} {
			# #set CompPropMaparr($compName) [::CreateSphElem_gui::GetElementProperty $compName];
		# }
        switch $method {
            "Simple-Cubic" {
                ::CreateSphElem_gui::DeleteSPHelems $compName
                set meshmethod 0;
                set fillpercent 100;
                *clearmark components 1;
                *createmark components 1 "$compName"
                if { [hm_marklength comps 1] } {
                    *currentcollector components "$compName";
                    *sphgenerate components 1 $pitch $meshmethod $fillpercent 0 0 0 0 $density 0 0 0;
                }
                update idletasks;
            }
            "Face-Centered-Cubic" {
                ::CreateSphElem_gui::DeleteSPHelems $compName
                set meshmethod 1;
                set fillpercent 100;
                *clearmark components 1;
                *createmark components 1 "$compName"
                if { [hm_marklength comps 1] } {
                    *currentcollector components "$compName"
                    *sphgenerate components 1 $pitch $meshmethod $fillpercent 0 0 0 0 $density 0 0 0;
                }
                update idletasks;
            }
            "Node-to-SPH" {
                #::CreateSphElem_gui::DeleteSPHelems $compName
                *clearmark nodes 1;
                *clearmark nodes 2;
                *createmark nodes 1 "by comp" $compName;
                if { [hm_marklength nodes 1] } {
                    *currentcollector components "$compName"
                    *admascreatemultentselectwithsets nodes 1 2 $vizNodeID $elemType $magnitude $attachSetsFlag;
                }
				*clearmark nodes 1
                update idletasks;
            }
        }
        update idletasks;
    }
	::CreateSphElem_gui::FailedSphGenerate
}

#######################################################################
#This proc creates the Props and mats
#######################################################################
proc ::CreateSphElem_gui::CreatePropertyMaterail {propname matname} {
	
    set color [expr {int(rand() * 63)}]
    *clearmark props 1
    *collectorcreateonly properties "$propname" "" $color
    *createmark properties 1 $propname
    *dictionaryload properties 1 [hm_info templatefilename] "SOLIDSECTION";
    *clearmark materials 1
    *collectorcreateonly materials "$matname" "" $color
    *createmark materials 1 $matname
    *dictionaryload materials 1 [hm_info templatefilename] "ABAQUS_MATERIAL"
    *materialupdate properties 1 "$matname" #assign material to props
    *clearmark props 1
    *clearmark materials 1
}

##########################################################################
#Assigning props into comps
#########################################################################
proc ::CreateSphElem_gui::OrganizeElements { compname propname } {
    *clearmark elems 1
    *clearmark elems 2
    *createmark elems 1 "by comps" "$compname"
    *createmark elems 2 "by config type" 1 mass PC3D
    *markintersection elems 1 elems 2;
    if { [hm_marklength elems 1] } {
        *propertyupdate elements 1 $propname
    }
}

############################################################################
#Assigning props into PC3D elems [direct assign] and maetrial to props
############################################################################
proc ::CreateSphElem_gui::AssignPropertyMaterial { propname pitch density } {
    #Property edit
    set propID [hm_getvalue props name=$propname dataname=id];
    if { $propID } {
        *attributeupdateint properties "$propID" 1625 2 2 0 1
        *attributeupdatedouble properties "$propID" 111 2 1 0 $pitch;
        
        ##Material Density Update
        set matID [hm_getvalue props name=$propname dataname=materialid];
		if {$matID} {
			*attributeupdateint materials $matID 182 2 2 0 1
            *createdoublearray 1 $density;
            *attributeupdatedoublearray materials $matID 183 2 2 0 1 1
			*attributeupdateint materials1 $matID 184 2 2 0 1
		}
    }
}

##########################################################################
#Proc to get the Selcected row
##########################################################################
proc ::CreateSphElem_gui::GetSelectedItems {} {
    set rows  [$::CreateSphElem_gui::SphTable rowlist]
    set returnList "";
    foreach selected_comps $rows {
        set status [$::CreateSphElem_gui::SphTable cellget $selected_comps,select]
        if {bool($status)} {
            lappend returnList $selected_comps;
        }
    }
    return $returnList;
}
########################################################################
#Based on Selection of rows this validation command will be
#executed.
#########################################################################
proc ::CreateSphElem_gui::ValidateSelection {x y} {
    variable rowUp;
    variable rowDown;
    variable status "";
    variable val "";
    set status disabled;
    if {[llength [GetSelectedItems]] > 1} { set status disabled}
        $rowUp configure -state $status;
        $rowDown configure -state $status;
    return 1;
}

###########################################################################
#proc to delete the selected rows
###########################################################################
proc ::CreateSphElem_gui::DeleteSPHelems {comp } {
    *clearmark elems 1
    *clearmark elems 2
    *createmark elems 1 "by comps" "$comp"
    *createmark elems 2 "by config type" 1 mass PC3D
    *markintersection elems 1 elems 2;
    if { [hm_marklength elems 1] } {
        *deletemark elems 1
    }
}

############################################################################
#Proc to check for SPH elems
############################################################################
proc ::CreateSphElem_gui::CheckSPHelems {comp } {
	if {[string length $comp] == 2 } {
		return 0;
	}
    set comp_id [hm_getvalue comps name=$comp dataname=id]
    set sph_elem [hm_entityincollector comps $comp_id elems 1 8 -byid]
    if { $sph_elem } {
        return 1;
    } else {
        return 0;
    }
}

###########################################################################
#proc
###########################################################################
proc ::CreateSphElem_gui::DensityValidate {I V} {
    variable _Sphvars;
    if {$V <= 0} {
        return 0;
    }
	return 1;
}

#############################################################################
#Proc to get the assigned props to comps directly and indirectly
#############################################################################
proc ::CreateSphElem_gui::GetElementProperty {comp} {
    variable n_propid "";
    set var 0;
    array set arr_propComp {};
    # *clearmark elems 1
    # *clearmark elems 2
    # *createmark elems 1 "by comps" "$comp"
    # *createmark elems 2 "by config type" 1 mass PC3D
    # *markintersection elems 1 elems 2;
	set comp_id [hm_getvalue comps name="$comp" dataname=id]
    set sph_elem [hm_entityincollector comps $comp_id elems 1 8 -byid]
    if { [llength $sph_elem] } {
        #Get PropID for SPH ELemes
        set prop_idList [ hm_getmarkvalue elems 1 property.id 0];
        foreach propid $prop_idList {
            if { $propid } {
                set arr_propComp($propid) $comp;
            }
        }
    }
   # # set n_propid [hm_getvalue comps name=$comp dataname=propertyid];
    # if {$n_propid} {
        # set cardimage [ hm_getvalue props id=$n_propid dataname=cardimage]
        # if {bool([string match $cardimage "SOLIDSECTION"])} {
           # # return 1;
        # } else {
            # set n_propid 0;
        # }
    # }
    
    set finalPropList {};
    if { [llength [array names arr_propComp]] } {
        set finalPropList [array names arr_propComp];
    }
    if { [llength $n_propid] && $n_propid != 0 } {
        lappend finalPropList $n_propid;
    }
    return $finalPropList;
}


##################################################################################
#Proc to create surface and assign components node
##################################################################################
proc ::CreateSphElem_gui::CreateSurfaceNode {CompName} {
    *clearmark groups 1 all
    *createmark groups 1 "by card image name"  "SURFACE_NODE"
    if { [hm_marklength groups 1] } {
        set groupList [hm_getvalue groups mark=1 dataname=name]
		append group_name HM_SPH_ $CompName 
        set GroupExists [lsearch $groupList "$group_name"];
            if {$GroupExists != -1} {
                set group "";
                #append group HM_ $CompName _surface
                *interfacedefinition "$group_name" 0 "node"
                *createmark nodes 1 "by comp" $CompName
                *interfaceadd "$group_name" 0 node  1 0
                *displaycollectorwithfilter groups "on" "$group_name" 1 0
                return;
            } else {
                ::CreateSphElem_gui::CreateSurface $CompName
            }
    } else {
       ::CreateSphElem_gui::CreateSurface $CompName 
       return;
    }
    
}


####################################################################################
#proc to create surface
####################################################################################
proc ::CreateSphElem_gui::CreateSurface {CompName } {
    set contact_name ""
    append contact_name HM_SPH_ $CompName 
    set contact_name [::hwat::utils::GetUniqueName groups $contact_name];
    if {[llength [file extension $contact_name]]} {
	    set contact_name [join [split $contact_name "."] ""]
    }
    set color [expr {int(rand() * 63)}]
    if { $contact_name != "" } {
        *clearmark node 1 all
        *interfacecreate "$contact_name" 4 1 $color
        *createmark groups 1 $contact_name
        *dictionaryload groups 1 [hm_info templatefilename] "SURFACE_NODE"
        
        *interfacedefinition "$contact_name" 0 "node"
		*clearmark elems 1
		*clearmark elems 2
		*createmark elems 1 "by comps" "$CompName"
		*createmark elems 2 "by config type" 1 mass PC3D
		*markintersection elems 1 elems 2;
	    if { [hm_marklength elems 1] } {
			set Id_list [hm_getmark elems 1]
			hm_createmark nodes 1 "by elements" $Id_list;
			*interfaceadd "$contact_name" 0 node  1 0
			*displaycollectorwithfilter groups "on" "$contact_name" 1 0
	    }
    }
}


###################################################################################
#proc to create property of Section Control card Image
###################################################################################
proc ::CreateSphElem_gui::CreateSectionProperty {compname} {
    set propname "";
    append propname HM_ $compname _Property
    set color [expr {int(rand() * 63)}]
    *clearmark props 1
    *collectorcreateonly properties "$propname" "" $color
    *createmark properties 1 $propname
    *dictionaryload properties 1 [hm_info templatefilename] "SECTION_CONTROLS";
    *attributeupdatedouble properties 1 4667 2 1 0 1
    *attributeupdatedouble properties 1 4668 2 1 0 1
}
####################################################################################
#proc to check component has section property
####################################################################################
proc ::CreateSphElem_gui::CreateSectionProperty compname {
    return 1;
}

###################################################################################
proc ::CreateSphElem_gui::FailedSphGenerate args {
	variable _Sphvars;
	set FailedList1 "";
	set Comps_list [lsort [$::CreateSphElem_gui::SphTable rowlist]]
    if {[llength $Comps_list] == 0} {
        return;
    }
	foreach selected_comps $Comps_list {
        set status [$::CreateSphElem_gui::SphTable cellget $selected_comps,select]
        if {bool($status)} {
			set compname [$::CreateSphElem_gui::SphTable cellget $selected_comps,comp]
			if { ![::CreateSphElem_gui::CheckSPHelems \"$compname\"] } {
				$::CreateSphElem_gui::SphTable cellset $selected_comps,status 2
				lappend FailedList1 "$compname,"
			}
		}
	}
	$_Sphvars(window) statusmessage "Failed Component List :$FailedList1";
	
}