### Week1
总结
* 1.	解压 PostgreSQL 源码
* 2.	进入解压后的目录
* 3.	配置编译路径
* 4.	编译源码 （make)
* 5.	安装 PostgreSQL (make install)
 
* login
ssh YourZID@vxdb01.cse.unsw.edu.au
ls -al /localstorage/z5525533

```
cd /localstorage/$USER
// 1.	解压 PostgreSQL 源码
// This extracts the contents of postgresql-15.11.tar.bz2 in the current directory.
// x → Extract files from the archive
// 	f → Specify the filename of the archive
// 	j → Use bzip2 for decompression
tar xfj /web/cs9315/25T1/postgresql/postgresql-15.11.tar.bz2
```

2.进入解压后的目录 
3 配置编译路径
```
 // 进入解压后的PostgreSQL 源码目录，接下来需要配置编译参数。
// configure 用于检测系统环境，它会检查系统是否具备必要的编译工具、库（如 gcc、readline、zlib 等）。
// 生成合适的 Makefile，以便后续的 make 编译。
cd /localstorage/$USER/postgresql-15.11
./configure --prefix=/localstorage/$USER/pgsql
// 指定 PostgreSQL 的安装目录，所有的可执行文件、库文件等都会安装到 /localstorage/$USER/pgsql
```

4.	编译源码 （make)
   这个命令的作用是根据 configure 生成的 Makefile 规则，调用编译器（如 gcc）来编译 PostgreSQL 的所有源代码，并生成可执行文件。
  	* make 读取 Makefile 并解析依赖关系，确定哪些文件需要编译。
   * 编译 C 代码,make 会调用 gcc 或 clang 编译 PostgreSQL 源码。这会把 C 语言源码（.c 文件）编译成二进制目标文件（.o 文件）。
   * 编译完所有 .o 文件后，make 会执行 链接（linking），生成可执行文件.
   * 默认情况下，make 只使用 单核 编译，这会比较慢。你可以使用 -j 选项启用多线程并行编译，加快速度
```
make
```

5 安装 PostgreSQL (make install)
在 make 编译完成后，我们需要运行 make install 命令来安装 PostgreSQL。
```
// 该命令的主要作用: 	1.	创建安装目录 /localstorage/$USER/pgsql（如果不存在）
// 2.	复制可执行文件（如 pg_ctl启动停止、psql命令行客户端用于与数据库交互、initdb 初始化数据库存储等）,最终在 /localstorage/$USER/pgsql/bin/ 下会看到这些核心可执行文件
// 	3.	安装库文件（.so、.a 等动态和静态库）,用于 PostgreSQL 服务器及其扩展
// 	4.	安装文档和配置文件.安装完成后，可以检查 bin/ 目录是否包含 PostgreSQL 可执行文件
// [?] 为了方便使用 PostgreSQL，可将 bin/ 目录添加到 PATH 变量中.这样，你可以直接运行 psql 和 pg_ctl，而不必输入完整路径。
make install
```



