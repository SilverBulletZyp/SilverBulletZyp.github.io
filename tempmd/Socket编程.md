# socket编程

socket是对TCP/IP协议的封装，Socket本身并不是协议，而是一个调用接口(API)。

TCP/IP是一个协议族；Windows上用C实现了TCP/IP协议,称为TCP/IP协议栈。一个是类的概念，一个是对象的概念，协议栈是指网络中各层协议的总和。

注：协议族是一组协议的集合，协议栈是协议的实现，地址族是地址划分的标准集合。






[UDP socket实例的结构]

由图可看出unix把socket设计成文件，DTYPE_VNODE表示普通的文件，DTYPE_SOCKET表示socket，当然还有其他的类型，比如管道、设备等。

通过描述符我们可以定位到具体的file结构体，file结构体中有个f_type属性，标识了文件的类型；f_ops域指向相应的socket类型的驱动；f_data域指向了具体的socket结构体，socket结构体关键域有so_type和so_pcb。下面我们分析socket编程的具体实现。



## socket接口标识

我们知道具体的一个文件可以用一个路径来表示，比如/home/zzy/src_code/client.c，那么具体的socket实例我们该如何表示呢，其实就是使用上面提到的so_pcb的那几个关键属性，也就是使用so_type+ip地址+端口号。如果我们使用so_type+ip地址+端口号实例一个socket，那么互联网上的其他主机就可以与该socket实例进行通信了。所以下面我们看一下socket如何进行实例化，看看socket给我们提供了哪些接口，而我们又该如何组织这些接口。



## socket编程部分

### socket接口

```c
int socket(int protofamily, int so_type, int protocol);
```

* protofamily 指协议族

```
AF_INET           指定so_pcb中的地址要采用ipv4地址类型
AF_INET6          指定so_pcb中的地址要采用ipv6的地址类型
AF_LOCAL/AF_UNIX  指定so_pcb中的地址要使用绝对路径名
```

* so_type 指定socket的类型

```
SOCK_STREAM     流套接字
SOCK_DGRAM      数据报套接字
SOCK_RAW        原始套接字
```

* protocol 指定具体的协议

```
IPPROTO_TCP     TCP协议
IPPROTO_UDP     UPD协议
```

如果指定为0，表示由内核根据so_type指定默认的通信协议


#### socket类型详解

* 流套接字（SOCK_STREAM）

流套接字用于提供面向连接、可靠的数据传输服务。该服务将保证数据能够实现无差错、无重复发送，并按顺序接收。流套接字之所以能够实现可靠的数据服务，原因在于其使用了传输控制协议，即TCP（The Transmission Control Protocol）协议。

* 数据报套接字（SOCK_DGRAM）

数据报套接字提供了一种无连接的服务。该服务并不能保证数据传输的可靠性，数据有可能在传输过程中丢失或出现数据重复，且无法保证顺序地接收到数据。数据报套接字使用UDP（User Datagram Protocol）协议进行数据的传输。由于数据包套接字不能保证数据传输的可靠性，对于有可能出现的数据丢失情况，需要在程序中做相应的处理。

* 原始套接字（SOCK_RAW）

原始套接字与标准套接字（标准套接字指的是前面介绍的流套接字和数据报套接字）的区别在于：原始套接字可以读写内核没有处理的IP数据包，而流套接字只能读取TCP协议的数据，数据报套接字只能读取UDP协议的数据。因此，如果要访问其他协议发送数据必须使用原始套接字。



SOCK_STREAM 这个协议是按照顺序的、可靠的、数据完整的基于字节流的连接。这是一个使用最多的socket类型，这个socket是使用TCP来进行传输。

SOCK_DGRAM 这个协议是无连接的、固定长度的传输调用。该协议是不可靠的，使用UDP来进行它的连接。

SOCK_SEQPACKET 这个协议是双线路的、可靠的连接，发送固定长度的数据包进行传输。必须把这个包完整的接受才能进行读取。

SOCK_RAW 这个socket类型提供单一的网络访问，这个socket类型使用ICMP公共协议。（ping、traceroute使用该协议）

SOCK_RDM 这个类型是很少使用的，在大部分的操作系统上没有实现，它是提供给数据链路层使用，不保证数据包的顺序


### bind接口

```c
int bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen);
```

bind函数就是给图三种so_pcb结构中的地址赋值的接口

```
sockfd      是调用socket()函数创建的socket描述符
addr        是具体的地址
addrlen     表示addr的长度
```

### connect接口

```c
int connect(int sockfd, const struct sockaddr *addr, socklen_t addrlen);
```

这三个参数和bind的三个参数类型一直，只不过此处strcut sockaddr表示对端公开的地址。三个参数都是传入参数。connect顾名思义就是拿来建立连接的函数，只有像tcp这样面向连接、提供可靠服务的协议才需要建立连接

### listen接口

```c
int listen(int sockfd, int backlog)
```

告知内核在sockfd这个描述符上监听是否有连接到来，并设置同时能完成的最大连接数为backlog。当调用listen后，内核就会建立两个队列，一个SYN队列，表示接受到请求，但未完成三次握手的连接；另一个是ACCEPT队列，表示已经完成了三次握手的队列

sockfd 是调用socket()函数创建的socket描述符
backlog 已经完成三次握手而等待accept的连接数

### accept接口

```c
int accept(int listen_sockfd, struct sockaddr *addr, socklen_t *addrlen)
```

这三个参数与bind的三个参数含义一致，不过，此处的后两个参数是传出参数。在使用listen函数告知内核监听的描述符后，内核就会建立两个队列，一个SYN队列，表示接受到请求，但未完成三次握手的连接；另一个是ACCEPT队列，表示已经完成了三次握手的队列。而accept函数就是从ACCEPT队列中拿一个连接，并生成一个新的描述符，新的描述符所指向的结构体so_pcb中的请求端ip地址、请求端端口将被初始化。

从上面可以知道，accpet的返回值是一个新的描述符，我们姑且称之为new_sockfd。那么new_sockfd和listen_sockfd有和不同呢？不同之处就在于listen_sockfd所指向的结构体so_pcb中的请求端ip地址、请求端端口没有被初始化，而new_sockfd的这两个属性被初始化了。



### TCP/IP协议

#### 简介

即传输控制协议或称网络通讯协议，由网络层的IP协议和传输层的TCP协议组成，是Internet最基本的协议、Internet国际互联网络的基础。



#### 常见协议

* Telnet (Remote Login) - 提供远程登录功能

* FTP (FileTransfer Protocol) - 远程文件传输协议，用于与远程计算机传输文件

* SMTP (Simple Messagetransfer Protocol) - 简单信息传输协议，主要用于传输电子邮件

* NFS (Network File Server) - 网络文件服务器，可使多台计算机透明地访问彼此的目录 

### UDP (User DatagramProtocol) - 用户数据报协议




## 参考文献

[socket原理详解](http://www.cnblogs.com/zengzy/p/5107516.html)

