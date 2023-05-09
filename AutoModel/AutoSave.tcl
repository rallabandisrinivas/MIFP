
namespace eval ::Setting {
    # 监控参数
	# 定义变量标记用户是否进行操作
	variable user_ineraction 0
	variable has_been_saved 0
}
# 设置时间间隔1min(60000ms)
set interval_time 60000

puts "开启自动保存，在无操作1分钟时自动保存文件"

set current_file [hm_info currentfile]
if {[string match "*.hm" $current_file]} {
	set current_dir [file dirname $current_file]
}


# 定义一个保存文件的函数
proc save_file {ineraction file} {
    # 判断当前是否有操作正在进行
    if {$ineraction == 0} {
        # 当前没有操作，执行保存操作
		puts "1分钟未操作，自动保存模型"
		hm_answernext yes
		*writefile "$file" 1
		puts "文件已保存:$file"
		set ::Setting::has_been_saved 1
    }
}

# 定义一个定时器，每隔一定时间执行保存操作
set timer_id [after $interval_time save_file $::Setting::user_ineraction $current_file]

# 监听用户键盘操作事件
bind . <Any-KeyPress> {
    # 用户进行了操作，标志变量设置为1，取消定时器
    after cancel $timer_id
    # 重新设置定时器
	if {$::Setting::has_been_saved == 0} {
		set timer_id [after $interval_time save_file $::Setting::user_ineraction $current_file]
		set ::Setting::user_ineraction 0
	} else {
		set ::Setting::has_been_saved 0
	}
}

# 监听用户鼠标操作事件
bind . <Motion> {
	# 用户进行了操作，标志变量设置为1，取消定时器
    after cancel $timer_id
}