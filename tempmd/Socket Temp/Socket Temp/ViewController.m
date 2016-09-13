//
//  ViewController.m
//  Socket Temp
//
//  Created by 赵云鹏 on 16/9/11.
//  Copyright © 2016年 赵云鹏. All rights reserved.
//

#import "ViewController.h"
#import <sys/socket.h> // scoket相关
#import <netinet/in.h> // internet相关
#import <arpa/inet.h>  // 地址解析协议相关

@interface ViewController ()
@property (nonatomic, assign) int clientSocket;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self socketConnect];
    [self sendMessage];
    
}

- (void)socketConnect
{
    // 创建socket
    /**
     参数
     domain:    协议域，AF_INET（IPV4的网络开发）
     type:      Socket 类型，SOCK_STREAM(TCP)/SOCK_DGRAM(UDP，报文)
     protocol:  IPPROTO_TCP，协议，如果输入0，可以根据第二个参数，自动选择协议
     
     返回值
     socket，如果 > 0 就表示成功
     */
    
    self.clientSocket = socket(AF_INET, SOCK_STREAM, 0);
    if (self.clientSocket > 0) {
        NSLog(@"socket 创建成功 = %d",self.clientSocket);
    }
    else
    {
        NSLog(@"socket 创建失败");
    }
    
    // host主机
    NSString * hostStr = [NSString stringWithFormat:@"127.0.0.1"];
    
    // port端口
    int port = 6666;
    
    // connection 连接到服务器
    /**
     参数
     1> 客户端socket
     2> 指向数据结构sockaddr的指针，其中包括目的端口和IP地址
     服务器的"结构体"地址，C语言没有对象
     3> 结构体数据长度
     返回值
     0 成功/其他 错误代号，非0即真
     */
    struct sockaddr_in serverAddress;
    
    // IPV4 - 协议
    serverAddress.sin_family = AF_INET;
    
    // inet_addr函数可以把ip地址转换成一个整数
    serverAddress.sin_addr.s_addr = inet_addr(hostStr.UTF8String);
    
    // 端口小端存储
    serverAddress.sin_port = htons(port);
    
    int result = connect(self.clientSocket, (const struct sockaddr *)&serverAddress, sizeof(serverAddress));
    
    NSLog(@"连接结果 = %d",result);
}

- (void)sendMessage
{
    // send发送
    /**
        参数
        1> 客户端socket
        2> 发送内容地址 void * == id
        3> 发送内容长度
        4> 发送方式标志，一般为0
        返回值
        如果成功，则返回发送的字节数，失败则返回SOCKET_ERROR
     */
    
    NSString * message = [NSString stringWithFormat:@"发送消息"];
    ssize_t sendLen = send(self.clientSocket, message.UTF8String, strlen(message.UTF8String), 0);
    
    NSLog(@"消息长度 = %ld", sendLen);
    
    // recv 接收 - 几乎所有的网络访问，都是有来有往的
    /**
     参数
     第一个int :创建的socket
     void *：接收内容的地址
     size_t：接收内容的长度
     第二个int.：接收数据的标记 0，就是阻塞式，一直等待服务器的数据
     返回值 接收到的数据长度
     */
    // unsigned char，字符串的数组
    uint8_t buffer[1024];
    ssize_t recvLen = recv(self.clientSocket, buffer, sizeof(buffer), 0);
    
    // 从buffer中读取服务器发回的数据
    // 按照服务器返回的长度，从 buffer 中，读取二进制数据，建立 NSData 对象
    NSData *data = [NSData dataWithBytes:buffer length:recvLen];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"接受消息为 = %@",str);
    
}

- (void)disconnect
{
    close(self.clientSocket);
    NSLog(@"断开连接");
}

@end
