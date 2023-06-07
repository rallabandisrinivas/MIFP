set port 8000

# 创建服务器套接字
set server [socket -server accept $port]

# 创建客户端套接字
set client [socket localhost $port]

# 发送消息到服务器
puts $client "Hello, server!"
flush $client

# 接收消息并打印
set message [gets $server]
puts "Server said: $message"

# 关闭套接字
close $client
close $server