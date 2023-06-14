set serveraddress "127.0.0.1"
set serverport 9999

wm title . "Socket Demo"
menu .menubar
. configure -menu .menubar -width  400 -height 400
menu .menubar.file
.menubar add cascade -menu .menubar.file -label File
.menubar.file add command -label "Connect to server" -command showMyPreferencesDialog
.menubar.file add command -label "Exit" -command {exit 0}
entry .e -textvariable msg_str
text .t -height 22 -wrap word

#set serverSocket [socket -myaddr $serveraddress $serveraddress 8282]
set serverSocket [socket -async $serveraddress $serverport]
fconfigure $serverSocket -buffering line
gets $serverSocket line1
.t insert 1.0 "Connected to server as : $line1\n" ;# get ip and client port as the userID
fileevent $serverSocket readable [list svcHandler $serverSocket]
button .b -text "Send" -command {send_message $serverSocket $msg_str}
bind .e <Return> ".b invoke"
place .b -x 290 -y 350 -width 100 -height 34
place .t -x 10 -y 10 -width 380
place .e -x 10 -y 350 -width 280 -height 34

proc tk::mac::ShowPreferences {} {
    showMyPreferencesDialog
}

# UNUSED  not used yet
proc showMyPreferencesDialog {} {
       #set default values
      set server_ip "172.0.0.1"
      set server_port_var 8585

       set w .dialog_window
       catch { destroy $w }
       toplevel $w
       wm title $w "New Connection"
       # place all widgets here ..
       label $w.lbl_remote_addr -text "Server IP"
       entry $w.remote_addr -textvariable server_ip
       label $w.lbl_server_port -text "Server Port"
       entry $w.server_port -textvariable server_port_var
       button $w.btn_connect -text "Connect" -command {connect_server server_ip server_port_var}

       place  $w.lbl_remote_addr -x 10 -y 10
       place  $w.remote_addr -x 10 -y 40 -width 180 -height 32
       place  $w.lbl_server_port -x 10 -y 80
       place  $w.server_port -x 10 -y 100 -width 180 -height 32
       place  $w.btn_connect -x 50 -y 140 -width 100 -height 34

       catch {tkwait visibility $w}
       catch {grab $w}


}

proc send_message {serverSocket msg_str} {
     if { [string length $msg_str] > 0} {
       puts $serverSocket $msg_str
     }
}

proc displayMessage {msg} {
      .t insert end "$msg\n"
      .e delete 0 end
      .t see end
}

proc  svcHandler {serverSocket} {
  set msg [gets $serverSocket]
  puts $msg
  if {[eof $serverSocket]} {
     .t insert end "\nServer Closed."
     close $serverSocket
  } else {
    displayMessage $msg
  }
}