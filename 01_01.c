//  这个 C 代码的主要功能是：
//  	1.	从命令行参数获取缓冲区大小和输入文件名
//  	2.	以指定的缓冲区大小逐块读取文件，并统计总共读取的块数和字节数
//  	3.	在读取过程中，打印每次读取的字节数，最后输出统计信息

#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

	// •	stdlib.h：提供 malloc() 和 exit()
	// •	stdio.h：提供 printf() 和 fprintf()
	// •	unistd.h：提供 read() 和 close()
	// •	sys/types.h 和 sys/stat.h：用于文件操作（但这里实际上没有使用到）
	// •	fcntl.h：提供 open() 用于文件操作
void giveUp(char **msg) {
    fprintf(stderr, "Error: %s\n", msg);
    printf(stderr, "Usage: ./blocks BlockSize InputFile\n");
    exit(EXIT_FAILURE);
}

int main(int argc, char **argv) {
    char *buf;
    int inf;
    int bufSize;
    ssize_t nread;
    int nblocks = 0, nbytes = 0;

    if (argc < 3) giveUp("Insufficient args");
    bufSize = atoi(argv[1]);

    if (bufSize < 100) giveUp("Invalid size");

    buf = malloc(bufSize * sizeof(char));
    if (buf == NULL) giveUp("Can't create buffer");

    if (inf = open(argv[2], O_RDONLY) < 0) giveUp("Can't read file");

    while ((nread = read(inf, buf, bufSize)) != 0) {
        nblocks++;
        nbytes += nread;
        printf("%d bythes read in current block\n", nread);
    }

    printf("Read %d blocks and %ld bytes\n", nblocks, nbytes);

    exit(EXIT_SUCCESS);
}
