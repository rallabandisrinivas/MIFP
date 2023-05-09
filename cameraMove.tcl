package require twapi 

namespace eval hk { 
	variable hotkeys; 
	proc add {hk script} { 
		variable hotkeys 
		if {[info exists hotkeys($hk)]} { 
			remove $hk 
		} 
		set hotkeys($hk) [twapi::register_hotkey $hk $script] 
	} 
	proc remove {hk} { 
		variable hotkeys 
		if {[info exists hotkeys($hk)]} { 
			twapi::unregister_hotkey $hotkeys($hk) 
			unset hotkeys($hk) 
		} 
	} 
	proc list {} { 
		variable hotkeys 
		return [array names hotkeys] 
	} 
	namespace export add remove list 
	namespace ensemble create 
} 
 
 hk add SHIFT-e { 
	foreach hotkey [hk list] { 
		hk remove $hotkey 
	} 
	exit 
} 
 
proc startMouse {} { 
	global mouse 
	set mouse [twapi::get_mouse_location] 
	twapi::move_mouse 999999 999999 
} 

proc stopMouse {} { 
	global mouse 
	twapi::move_mouse [lindex $mouse 0] [lindex $mouse 1] 
}
 
proc forward {} { 
	startMouse 
	set viewMatrix [hm_winfo viewmatrix] 
   
	set editMatrixPart "[expr [lindex $viewMatrix 13] + 8]" 
   
	set firstMatrixPart "[lindex $viewMatrix 0] [lindex $viewMatrix 1] [lindex $viewMatrix 2] [lindex $viewMatrix 3] [lindex $viewMatrix 4] [lindex $viewMatrix 5] [lindex $viewMatrix 6] [lindex $viewMatrix 7] [lindex $viewMatrix 8] [lindex $viewMatrix 9] [lindex $viewMatrix 10] [lindex $viewMatrix 11] [lindex $viewMatrix 12] " 
 
	set secondMatrixPart " [lindex $viewMatrix 14] [lindex $viewMatrix 15] [lindex $viewMatrix 16] [lindex $viewMatrix 17] [lindex $viewMatrix 18] [lindex $viewMatrix 19]" 
   
	append firstMatrixPart $editMatrixPart $secondMatrixPart 
   
	eval *viewset $firstMatrixPart 
	stopMouse 
 } 
 
hk add SHIFT-UP forward

proc backward {} { 
	startMouse 
	set viewMatrix [hm_winfo viewmatrix] 
   
	set editMatrixPart "[expr [lindex $viewMatrix 13] - 8]" 
   
	set firstMatrixPart "[lindex $viewMatrix 0] [lindex $viewMatrix 1] [lindex $viewMatrix 2] [lindex $viewMatrix 3] [lindex $viewMatrix 4] [lindex $viewMatrix 5] [lindex $viewMatrix 6] [lindex $viewMatrix 7] [lindex $viewMatrix 8] [lindex $viewMatrix 9] [lindex $viewMatrix 10] [lindex $viewMatrix 11] [lindex $viewMatrix 12] " 
	set secondMatrixPart " [lindex $viewMatrix 14] [lindex $viewMatrix 15] [lindex $viewMatrix 16] [lindex $viewMatrix 17] [lindex $viewMatrix 18] [lindex $viewMatrix 19]" 
   
	append firstMatrixPart $editMatrixPart $secondMatrixPart 
   
	eval *viewset $firstMatrixPart 
	stopMouse 
} 
   
hk add SHIFT-DOWN backward 
   
proc right {} { 
	startMouse 
	set viewMatrix [hm_winfo viewmatrix] 
   
	set editMatrixPart "[expr [lindex $viewMatrix 12] + 8]" 
   
	set firstMatrixPart "[lindex $viewMatrix 0] [lindex $viewMatrix 1] [lindex $viewMatrix 2] [lindex $viewMatrix 3] [lindex $viewMatrix 4] [lindex $viewMatrix 5] [lindex $viewMatrix 6] [lindex $viewMatrix 7] [lindex $viewMatrix 8] [lindex $viewMatrix 9] [lindex $viewMatrix 10] [lindex $viewMatrix 11] " 
	set secondMatrixPart " [lindex $viewMatrix 13] [lindex $viewMatrix 14] [lindex $viewMatrix 15] [lindex $viewMatrix 16] [lindex $viewMatrix 17] [lindex $viewMatrix 18] [lindex $viewMatrix 19]" 
   
	append firstMatrixPart $editMatrixPart $secondMatrixPart 
   
	eval *viewset $firstMatrixPart 
 
	stopMouse 
} 
   
hk add SHIFT-RIGHT right 
   
proc left {} { 
	startMouse 
	set viewMatrix [hm_winfo viewmatrix] 
   
	set editMatrixPart "[expr [lindex $viewMatrix 12] - 8]" 
   
	set firstMatrixPart "[lindex $viewMatrix 0] [lindex $viewMatrix 1] [lindex $viewMatrix 2] [lindex $viewMatrix 3] [lindex $viewMatrix 4] [lindex $viewMatrix 5] [lindex $viewMatrix 6] [lindex $viewMatrix 7] [lindex $viewMatrix 8] [lindex $viewMatrix 9] [lindex $viewMatrix 10] [lindex $viewMatrix 11] " 
	set secondMatrixPart " [lindex $viewMatrix 13] [lindex $viewMatrix 14] [lindex $viewMatrix 15] [lindex $viewMatrix 16] [lindex $viewMatrix 17] [lindex $viewMatrix 18] [lindex $viewMatrix 19]" 
   
	append firstMatrixPart $editMatrixPart $secondMatrixPart 
   
	eval *viewset $firstMatrixPart  
	stopMouse 
}
 
hk add SHIFT-LEFT left