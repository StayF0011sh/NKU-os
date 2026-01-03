
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
    .globl kern_entry
kern_entry:
    # a0: hartid
    # a1: dtb physical address
    # save hartid and dtb address
    la t0, boot_hartid
ffffffffc0200000:	0000b297          	auipc	t0,0xb
ffffffffc0200004:	00028293          	mv	t0,t0
    sd a0, 0(t0)
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc020b000 <boot_hartid>
    la t0, boot_dtb
ffffffffc020000c:	0000b297          	auipc	t0,0xb
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc020b008 <boot_dtb>
    sd a1, 0(t0)
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)
    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200018:	c020a2b7          	lui	t0,0xc020a
    # t1 := 0xffffffff40000000 即虚实映射偏移量
    li      t1, 0xffffffffc0000000 - 0x80000000
ffffffffc020001c:	ffd0031b          	addiw	t1,zero,-3
ffffffffc0200020:	037a                	slli	t1,t1,0x1e
    # t0 减去虚实映射偏移量 0xffffffff40000000，变为三级页表的物理地址
    sub     t0, t0, t1
ffffffffc0200022:	406282b3          	sub	t0,t0,t1
    # t0 >>= 12，变为三级页表的物理页号
    srli    t0, t0, 12
ffffffffc0200026:	00c2d293          	srli	t0,t0,0xc

    # t1 := 8 << 60，设置 satp 的 MODE 字段为 Sv39
    li      t1, 8 << 60
ffffffffc020002a:	fff0031b          	addiw	t1,zero,-1
ffffffffc020002e:	137e                	slli	t1,t1,0x3f
    # 将刚才计算出的预设三级页表物理页号附加到 satp 中
    or      t0, t0, t1
ffffffffc0200030:	0062e2b3          	or	t0,t0,t1
    # 将算出的 t0(即新的MODE|页表基址物理页号) 覆盖到 satp 中
    csrw    satp, t0
ffffffffc0200034:	18029073          	csrw	satp,t0
    # 使用 sfence.vma 指令刷新 TLB
    sfence.vma
ffffffffc0200038:	12000073          	sfence.vma
    # 从此，我们给内核搭建出了一个完美的虚拟内存空间！
    #nop # 可能映射的位置有些bug。。插入一个nop
    
    # 我们在虚拟内存空间中：随意将 sp 设置为虚拟地址！
    lui sp, %hi(bootstacktop)
ffffffffc020003c:	c020a137          	lui	sp,0xc020a

    # 我们在虚拟内存空间中：随意跳转到虚拟地址！
    # 跳转到 kern_init
    lui t0, %hi(kern_init)
ffffffffc0200040:	c02002b7          	lui	t0,0xc0200
    addi t0, t0, %lo(kern_init)
ffffffffc0200044:	04a28293          	addi	t0,t0,74 # ffffffffc020004a <kern_init>
    jr t0
ffffffffc0200048:	8282                	jr	t0

ffffffffc020004a <kern_init>:
void grade_backtrace(void);

int kern_init(void)
{
    extern char edata[], end[];
    memset(edata, 0, end - edata);
ffffffffc020004a:	000a6517          	auipc	a0,0xa6
ffffffffc020004e:	26e50513          	addi	a0,a0,622 # ffffffffc02a62b8 <buf>
ffffffffc0200052:	000aa617          	auipc	a2,0xaa
ffffffffc0200056:	70a60613          	addi	a2,a2,1802 # ffffffffc02aa75c <end>
{
ffffffffc020005a:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc020005c:	8e09                	sub	a2,a2,a0
ffffffffc020005e:	4581                	li	a1,0
{
ffffffffc0200060:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc0200062:	1fa050ef          	jal	ra,ffffffffc020525c <memset>
    dtb_init();
ffffffffc0200066:	4d6000ef          	jal	ra,ffffffffc020053c <dtb_init>
    cons_init(); // init the console
ffffffffc020006a:	0d7000ef          	jal	ra,ffffffffc0200940 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
    cprintf("%s\n\n", message);
ffffffffc020006e:	00005597          	auipc	a1,0x5
ffffffffc0200072:	62258593          	addi	a1,a1,1570 # ffffffffc0205690 <etext+0x6>
ffffffffc0200076:	00005517          	auipc	a0,0x5
ffffffffc020007a:	63a50513          	addi	a0,a0,1594 # ffffffffc02056b0 <etext+0x26>
ffffffffc020007e:	062000ef          	jal	ra,ffffffffc02000e0 <cprintf>

    print_kerninfo();
ffffffffc0200082:	248000ef          	jal	ra,ffffffffc02002ca <print_kerninfo>

    // grade_backtrace();

    pmm_init(); // init physical memory management
ffffffffc0200086:	00b010ef          	jal	ra,ffffffffc0201890 <pmm_init>

    pic_init(); // init interrupt controller
ffffffffc020008a:	129000ef          	jal	ra,ffffffffc02009b2 <pic_init>
    idt_init(); // init interrupt descriptor table
ffffffffc020008e:	133000ef          	jal	ra,ffffffffc02009c0 <idt_init>

    vmm_init();  // init virtual memory management
ffffffffc0200092:	2d7020ef          	jal	ra,ffffffffc0202b68 <vmm_init>
    proc_init(); // init process table
ffffffffc0200096:	587040ef          	jal	ra,ffffffffc0204e1c <proc_init>

    clock_init();  // init clock interrupt
ffffffffc020009a:	053000ef          	jal	ra,ffffffffc02008ec <clock_init>
    intr_enable(); // enable irq interrupt
ffffffffc020009e:	117000ef          	jal	ra,ffffffffc02009b4 <intr_enable>

    cpu_idle(); // run idle process
ffffffffc02000a2:	713040ef          	jal	ra,ffffffffc0204fb4 <cpu_idle>

ffffffffc02000a6 <cputch>:
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt)
{
ffffffffc02000a6:	1141                	addi	sp,sp,-16
ffffffffc02000a8:	e022                	sd	s0,0(sp)
ffffffffc02000aa:	e406                	sd	ra,8(sp)
ffffffffc02000ac:	842e                	mv	s0,a1
    cons_putc(c);
ffffffffc02000ae:	095000ef          	jal	ra,ffffffffc0200942 <cons_putc>
    (*cnt)++;
ffffffffc02000b2:	401c                	lw	a5,0(s0)
}
ffffffffc02000b4:	60a2                	ld	ra,8(sp)
    (*cnt)++;
ffffffffc02000b6:	2785                	addiw	a5,a5,1
ffffffffc02000b8:	c01c                	sw	a5,0(s0)
}
ffffffffc02000ba:	6402                	ld	s0,0(sp)
ffffffffc02000bc:	0141                	addi	sp,sp,16
ffffffffc02000be:	8082                	ret

ffffffffc02000c0 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int vcprintf(const char *fmt, va_list ap)
{
ffffffffc02000c0:	1101                	addi	sp,sp,-32
ffffffffc02000c2:	862a                	mv	a2,a0
ffffffffc02000c4:	86ae                	mv	a3,a1
    int cnt = 0;
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc02000c6:	00000517          	auipc	a0,0x0
ffffffffc02000ca:	fe050513          	addi	a0,a0,-32 # ffffffffc02000a6 <cputch>
ffffffffc02000ce:	006c                	addi	a1,sp,12
{
ffffffffc02000d0:	ec06                	sd	ra,24(sp)
    int cnt = 0;
ffffffffc02000d2:	c602                	sw	zero,12(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc02000d4:	21e050ef          	jal	ra,ffffffffc02052f2 <vprintfmt>
    return cnt;
}
ffffffffc02000d8:	60e2                	ld	ra,24(sp)
ffffffffc02000da:	4532                	lw	a0,12(sp)
ffffffffc02000dc:	6105                	addi	sp,sp,32
ffffffffc02000de:	8082                	ret

ffffffffc02000e0 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int cprintf(const char *fmt, ...)
{
ffffffffc02000e0:	711d                	addi	sp,sp,-96
    va_list ap;
    int cnt;
    va_start(ap, fmt);
ffffffffc02000e2:	02810313          	addi	t1,sp,40 # ffffffffc020a028 <boot_page_table_sv39+0x28>
{
ffffffffc02000e6:	8e2a                	mv	t3,a0
ffffffffc02000e8:	f42e                	sd	a1,40(sp)
ffffffffc02000ea:	f832                	sd	a2,48(sp)
ffffffffc02000ec:	fc36                	sd	a3,56(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc02000ee:	00000517          	auipc	a0,0x0
ffffffffc02000f2:	fb850513          	addi	a0,a0,-72 # ffffffffc02000a6 <cputch>
ffffffffc02000f6:	004c                	addi	a1,sp,4
ffffffffc02000f8:	869a                	mv	a3,t1
ffffffffc02000fa:	8672                	mv	a2,t3
{
ffffffffc02000fc:	ec06                	sd	ra,24(sp)
ffffffffc02000fe:	e0ba                	sd	a4,64(sp)
ffffffffc0200100:	e4be                	sd	a5,72(sp)
ffffffffc0200102:	e8c2                	sd	a6,80(sp)
ffffffffc0200104:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
ffffffffc0200106:	e41a                	sd	t1,8(sp)
    int cnt = 0;
ffffffffc0200108:	c202                	sw	zero,4(sp)
    vprintfmt((void *)cputch, &cnt, fmt, ap);
ffffffffc020010a:	1e8050ef          	jal	ra,ffffffffc02052f2 <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
ffffffffc020010e:	60e2                	ld	ra,24(sp)
ffffffffc0200110:	4512                	lw	a0,4(sp)
ffffffffc0200112:	6125                	addi	sp,sp,96
ffffffffc0200114:	8082                	ret

ffffffffc0200116 <cputchar>:

/* cputchar - writes a single character to stdout */
void cputchar(int c)
{
    cons_putc(c);
ffffffffc0200116:	02d0006f          	j	ffffffffc0200942 <cons_putc>

ffffffffc020011a <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int cputs(const char *str)
{
ffffffffc020011a:	1101                	addi	sp,sp,-32
ffffffffc020011c:	e822                	sd	s0,16(sp)
ffffffffc020011e:	ec06                	sd	ra,24(sp)
ffffffffc0200120:	e426                	sd	s1,8(sp)
ffffffffc0200122:	842a                	mv	s0,a0
    int cnt = 0;
    char c;
    while ((c = *str++) != '\0')
ffffffffc0200124:	00054503          	lbu	a0,0(a0)
ffffffffc0200128:	c51d                	beqz	a0,ffffffffc0200156 <cputs+0x3c>
ffffffffc020012a:	0405                	addi	s0,s0,1
ffffffffc020012c:	4485                	li	s1,1
ffffffffc020012e:	9c81                	subw	s1,s1,s0
    cons_putc(c);
ffffffffc0200130:	013000ef          	jal	ra,ffffffffc0200942 <cons_putc>
    while ((c = *str++) != '\0')
ffffffffc0200134:	00044503          	lbu	a0,0(s0)
ffffffffc0200138:	008487bb          	addw	a5,s1,s0
ffffffffc020013c:	0405                	addi	s0,s0,1
ffffffffc020013e:	f96d                	bnez	a0,ffffffffc0200130 <cputs+0x16>
    (*cnt)++;
ffffffffc0200140:	0017841b          	addiw	s0,a5,1
    cons_putc(c);
ffffffffc0200144:	4529                	li	a0,10
ffffffffc0200146:	7fc000ef          	jal	ra,ffffffffc0200942 <cons_putc>
    {
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
    return cnt;
}
ffffffffc020014a:	60e2                	ld	ra,24(sp)
ffffffffc020014c:	8522                	mv	a0,s0
ffffffffc020014e:	6442                	ld	s0,16(sp)
ffffffffc0200150:	64a2                	ld	s1,8(sp)
ffffffffc0200152:	6105                	addi	sp,sp,32
ffffffffc0200154:	8082                	ret
    while ((c = *str++) != '\0')
ffffffffc0200156:	4405                	li	s0,1
ffffffffc0200158:	b7f5                	j	ffffffffc0200144 <cputs+0x2a>

ffffffffc020015a <getchar>:

/* getchar - reads a single non-zero character from stdin */
int getchar(void)
{
ffffffffc020015a:	1141                	addi	sp,sp,-16
ffffffffc020015c:	e406                	sd	ra,8(sp)
    int c;
    while ((c = cons_getc()) == 0)
ffffffffc020015e:	019000ef          	jal	ra,ffffffffc0200976 <cons_getc>
ffffffffc0200162:	dd75                	beqz	a0,ffffffffc020015e <getchar+0x4>
        /* do nothing */;
    return c;
}
ffffffffc0200164:	60a2                	ld	ra,8(sp)
ffffffffc0200166:	0141                	addi	sp,sp,16
ffffffffc0200168:	8082                	ret

ffffffffc020016a <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
ffffffffc020016a:	715d                	addi	sp,sp,-80
ffffffffc020016c:	e486                	sd	ra,72(sp)
ffffffffc020016e:	e0a6                	sd	s1,64(sp)
ffffffffc0200170:	fc4a                	sd	s2,56(sp)
ffffffffc0200172:	f84e                	sd	s3,48(sp)
ffffffffc0200174:	f452                	sd	s4,40(sp)
ffffffffc0200176:	f056                	sd	s5,32(sp)
ffffffffc0200178:	ec5a                	sd	s6,24(sp)
ffffffffc020017a:	e85e                	sd	s7,16(sp)
    if (prompt != NULL) {
ffffffffc020017c:	c901                	beqz	a0,ffffffffc020018c <readline+0x22>
ffffffffc020017e:	85aa                	mv	a1,a0
        cprintf("%s", prompt);
ffffffffc0200180:	00005517          	auipc	a0,0x5
ffffffffc0200184:	53850513          	addi	a0,a0,1336 # ffffffffc02056b8 <etext+0x2e>
ffffffffc0200188:	f59ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
readline(const char *prompt) {
ffffffffc020018c:	4481                	li	s1,0
    while (1) {
        c = getchar();
        if (c < 0) {
            return NULL;
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc020018e:	497d                	li	s2,31
            cputchar(c);
            buf[i ++] = c;
        }
        else if (c == '\b' && i > 0) {
ffffffffc0200190:	49a1                	li	s3,8
            cputchar(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
ffffffffc0200192:	4aa9                	li	s5,10
ffffffffc0200194:	4b35                	li	s6,13
            buf[i ++] = c;
ffffffffc0200196:	000a6b97          	auipc	s7,0xa6
ffffffffc020019a:	122b8b93          	addi	s7,s7,290 # ffffffffc02a62b8 <buf>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc020019e:	3fe00a13          	li	s4,1022
        c = getchar();
ffffffffc02001a2:	fb9ff0ef          	jal	ra,ffffffffc020015a <getchar>
        if (c < 0) {
ffffffffc02001a6:	00054a63          	bltz	a0,ffffffffc02001ba <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02001aa:	00a95a63          	bge	s2,a0,ffffffffc02001be <readline+0x54>
ffffffffc02001ae:	029a5263          	bge	s4,s1,ffffffffc02001d2 <readline+0x68>
        c = getchar();
ffffffffc02001b2:	fa9ff0ef          	jal	ra,ffffffffc020015a <getchar>
        if (c < 0) {
ffffffffc02001b6:	fe055ae3          	bgez	a0,ffffffffc02001aa <readline+0x40>
            return NULL;
ffffffffc02001ba:	4501                	li	a0,0
ffffffffc02001bc:	a091                	j	ffffffffc0200200 <readline+0x96>
        else if (c == '\b' && i > 0) {
ffffffffc02001be:	03351463          	bne	a0,s3,ffffffffc02001e6 <readline+0x7c>
ffffffffc02001c2:	e8a9                	bnez	s1,ffffffffc0200214 <readline+0xaa>
        c = getchar();
ffffffffc02001c4:	f97ff0ef          	jal	ra,ffffffffc020015a <getchar>
        if (c < 0) {
ffffffffc02001c8:	fe0549e3          	bltz	a0,ffffffffc02001ba <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc02001cc:	fea959e3          	bge	s2,a0,ffffffffc02001be <readline+0x54>
ffffffffc02001d0:	4481                	li	s1,0
            cputchar(c);
ffffffffc02001d2:	e42a                	sd	a0,8(sp)
ffffffffc02001d4:	f43ff0ef          	jal	ra,ffffffffc0200116 <cputchar>
            buf[i ++] = c;
ffffffffc02001d8:	6522                	ld	a0,8(sp)
ffffffffc02001da:	009b87b3          	add	a5,s7,s1
ffffffffc02001de:	2485                	addiw	s1,s1,1
ffffffffc02001e0:	00a78023          	sb	a0,0(a5)
ffffffffc02001e4:	bf7d                	j	ffffffffc02001a2 <readline+0x38>
        else if (c == '\n' || c == '\r') {
ffffffffc02001e6:	01550463          	beq	a0,s5,ffffffffc02001ee <readline+0x84>
ffffffffc02001ea:	fb651ce3          	bne	a0,s6,ffffffffc02001a2 <readline+0x38>
            cputchar(c);
ffffffffc02001ee:	f29ff0ef          	jal	ra,ffffffffc0200116 <cputchar>
            buf[i] = '\0';
ffffffffc02001f2:	000a6517          	auipc	a0,0xa6
ffffffffc02001f6:	0c650513          	addi	a0,a0,198 # ffffffffc02a62b8 <buf>
ffffffffc02001fa:	94aa                	add	s1,s1,a0
ffffffffc02001fc:	00048023          	sb	zero,0(s1)
            return buf;
        }
    }
}
ffffffffc0200200:	60a6                	ld	ra,72(sp)
ffffffffc0200202:	6486                	ld	s1,64(sp)
ffffffffc0200204:	7962                	ld	s2,56(sp)
ffffffffc0200206:	79c2                	ld	s3,48(sp)
ffffffffc0200208:	7a22                	ld	s4,40(sp)
ffffffffc020020a:	7a82                	ld	s5,32(sp)
ffffffffc020020c:	6b62                	ld	s6,24(sp)
ffffffffc020020e:	6bc2                	ld	s7,16(sp)
ffffffffc0200210:	6161                	addi	sp,sp,80
ffffffffc0200212:	8082                	ret
            cputchar(c);
ffffffffc0200214:	4521                	li	a0,8
ffffffffc0200216:	f01ff0ef          	jal	ra,ffffffffc0200116 <cputchar>
            i --;
ffffffffc020021a:	34fd                	addiw	s1,s1,-1
ffffffffc020021c:	b759                	j	ffffffffc02001a2 <readline+0x38>

ffffffffc020021e <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void __panic(const char *file, int line, const char *fmt, ...)
{
    if (is_panic)
ffffffffc020021e:	000aa317          	auipc	t1,0xaa
ffffffffc0200222:	4c230313          	addi	t1,t1,1218 # ffffffffc02aa6e0 <is_panic>
ffffffffc0200226:	00033e03          	ld	t3,0(t1)
{
ffffffffc020022a:	715d                	addi	sp,sp,-80
ffffffffc020022c:	ec06                	sd	ra,24(sp)
ffffffffc020022e:	e822                	sd	s0,16(sp)
ffffffffc0200230:	f436                	sd	a3,40(sp)
ffffffffc0200232:	f83a                	sd	a4,48(sp)
ffffffffc0200234:	fc3e                	sd	a5,56(sp)
ffffffffc0200236:	e0c2                	sd	a6,64(sp)
ffffffffc0200238:	e4c6                	sd	a7,72(sp)
    if (is_panic)
ffffffffc020023a:	020e1a63          	bnez	t3,ffffffffc020026e <__panic+0x50>
    {
        goto panic_dead;
    }
    is_panic = 1;
ffffffffc020023e:	4785                	li	a5,1
ffffffffc0200240:	00f33023          	sd	a5,0(t1)

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
ffffffffc0200244:	8432                	mv	s0,a2
ffffffffc0200246:	103c                	addi	a5,sp,40
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc0200248:	862e                	mv	a2,a1
ffffffffc020024a:	85aa                	mv	a1,a0
ffffffffc020024c:	00005517          	auipc	a0,0x5
ffffffffc0200250:	47450513          	addi	a0,a0,1140 # ffffffffc02056c0 <etext+0x36>
    va_start(ap, fmt);
ffffffffc0200254:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc0200256:	e8bff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    vcprintf(fmt, ap);
ffffffffc020025a:	65a2                	ld	a1,8(sp)
ffffffffc020025c:	8522                	mv	a0,s0
ffffffffc020025e:	e63ff0ef          	jal	ra,ffffffffc02000c0 <vcprintf>
    cprintf("\n");
ffffffffc0200262:	00006517          	auipc	a0,0x6
ffffffffc0200266:	38650513          	addi	a0,a0,902 # ffffffffc02065e8 <commands+0xcb0>
ffffffffc020026a:	e77ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
#endif
}

static inline void sbi_shutdown(void)
{
	SBI_CALL_0(SBI_SHUTDOWN);
ffffffffc020026e:	4501                	li	a0,0
ffffffffc0200270:	4581                	li	a1,0
ffffffffc0200272:	4601                	li	a2,0
ffffffffc0200274:	48a1                	li	a7,8
ffffffffc0200276:	00000073          	ecall
    va_end(ap);

panic_dead:
    // No debug monitor here
    sbi_shutdown();
    intr_disable();
ffffffffc020027a:	740000ef          	jal	ra,ffffffffc02009ba <intr_disable>
    while (1)
    {
        kmonitor(NULL);
ffffffffc020027e:	4501                	li	a0,0
ffffffffc0200280:	174000ef          	jal	ra,ffffffffc02003f4 <kmonitor>
    while (1)
ffffffffc0200284:	bfed                	j	ffffffffc020027e <__panic+0x60>

ffffffffc0200286 <__warn>:
    }
}

/* __warn - like panic, but don't */
void __warn(const char *file, int line, const char *fmt, ...)
{
ffffffffc0200286:	715d                	addi	sp,sp,-80
ffffffffc0200288:	832e                	mv	t1,a1
ffffffffc020028a:	e822                	sd	s0,16(sp)
    va_list ap;
    va_start(ap, fmt);
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc020028c:	85aa                	mv	a1,a0
{
ffffffffc020028e:	8432                	mv	s0,a2
ffffffffc0200290:	fc3e                	sd	a5,56(sp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc0200292:	861a                	mv	a2,t1
    va_start(ap, fmt);
ffffffffc0200294:	103c                	addi	a5,sp,40
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc0200296:	00005517          	auipc	a0,0x5
ffffffffc020029a:	44a50513          	addi	a0,a0,1098 # ffffffffc02056e0 <etext+0x56>
{
ffffffffc020029e:	ec06                	sd	ra,24(sp)
ffffffffc02002a0:	f436                	sd	a3,40(sp)
ffffffffc02002a2:	f83a                	sd	a4,48(sp)
ffffffffc02002a4:	e0c2                	sd	a6,64(sp)
ffffffffc02002a6:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc02002a8:	e43e                	sd	a5,8(sp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
ffffffffc02002aa:	e37ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    vcprintf(fmt, ap);
ffffffffc02002ae:	65a2                	ld	a1,8(sp)
ffffffffc02002b0:	8522                	mv	a0,s0
ffffffffc02002b2:	e0fff0ef          	jal	ra,ffffffffc02000c0 <vcprintf>
    cprintf("\n");
ffffffffc02002b6:	00006517          	auipc	a0,0x6
ffffffffc02002ba:	33250513          	addi	a0,a0,818 # ffffffffc02065e8 <commands+0xcb0>
ffffffffc02002be:	e23ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    va_end(ap);
}
ffffffffc02002c2:	60e2                	ld	ra,24(sp)
ffffffffc02002c4:	6442                	ld	s0,16(sp)
ffffffffc02002c6:	6161                	addi	sp,sp,80
ffffffffc02002c8:	8082                	ret

ffffffffc02002ca <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void)
{
ffffffffc02002ca:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
ffffffffc02002cc:	00005517          	auipc	a0,0x5
ffffffffc02002d0:	43450513          	addi	a0,a0,1076 # ffffffffc0205700 <etext+0x76>
{
ffffffffc02002d4:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc02002d6:	e0bff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  entry  0x%08x (virtual)\n", kern_init);
ffffffffc02002da:	00000597          	auipc	a1,0x0
ffffffffc02002de:	d7058593          	addi	a1,a1,-656 # ffffffffc020004a <kern_init>
ffffffffc02002e2:	00005517          	auipc	a0,0x5
ffffffffc02002e6:	43e50513          	addi	a0,a0,1086 # ffffffffc0205720 <etext+0x96>
ffffffffc02002ea:	df7ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  etext  0x%08x (virtual)\n", etext);
ffffffffc02002ee:	00005597          	auipc	a1,0x5
ffffffffc02002f2:	39c58593          	addi	a1,a1,924 # ffffffffc020568a <etext>
ffffffffc02002f6:	00005517          	auipc	a0,0x5
ffffffffc02002fa:	44a50513          	addi	a0,a0,1098 # ffffffffc0205740 <etext+0xb6>
ffffffffc02002fe:	de3ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  edata  0x%08x (virtual)\n", edata);
ffffffffc0200302:	000a6597          	auipc	a1,0xa6
ffffffffc0200306:	fb658593          	addi	a1,a1,-74 # ffffffffc02a62b8 <buf>
ffffffffc020030a:	00005517          	auipc	a0,0x5
ffffffffc020030e:	45650513          	addi	a0,a0,1110 # ffffffffc0205760 <etext+0xd6>
ffffffffc0200312:	dcfff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  end    0x%08x (virtual)\n", end);
ffffffffc0200316:	000aa597          	auipc	a1,0xaa
ffffffffc020031a:	44658593          	addi	a1,a1,1094 # ffffffffc02aa75c <end>
ffffffffc020031e:	00005517          	auipc	a0,0x5
ffffffffc0200322:	46250513          	addi	a0,a0,1122 # ffffffffc0205780 <etext+0xf6>
ffffffffc0200326:	dbbff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc020032a:	000ab597          	auipc	a1,0xab
ffffffffc020032e:	83158593          	addi	a1,a1,-1999 # ffffffffc02aab5b <end+0x3ff>
ffffffffc0200332:	00000797          	auipc	a5,0x0
ffffffffc0200336:	d1878793          	addi	a5,a5,-744 # ffffffffc020004a <kern_init>
ffffffffc020033a:	40f587b3          	sub	a5,a1,a5
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc020033e:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc0200342:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200344:	3ff5f593          	andi	a1,a1,1023
ffffffffc0200348:	95be                	add	a1,a1,a5
ffffffffc020034a:	85a9                	srai	a1,a1,0xa
ffffffffc020034c:	00005517          	auipc	a0,0x5
ffffffffc0200350:	45450513          	addi	a0,a0,1108 # ffffffffc02057a0 <etext+0x116>
}
ffffffffc0200354:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200356:	b369                	j	ffffffffc02000e0 <cprintf>

ffffffffc0200358 <print_stackframe>:
 * jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the
 * boundary.
 * */
void print_stackframe(void)
{
ffffffffc0200358:	1141                	addi	sp,sp,-16
    panic("Not Implemented!");
ffffffffc020035a:	00005617          	auipc	a2,0x5
ffffffffc020035e:	47660613          	addi	a2,a2,1142 # ffffffffc02057d0 <etext+0x146>
ffffffffc0200362:	04f00593          	li	a1,79
ffffffffc0200366:	00005517          	auipc	a0,0x5
ffffffffc020036a:	48250513          	addi	a0,a0,1154 # ffffffffc02057e8 <etext+0x15e>
{
ffffffffc020036e:	e406                	sd	ra,8(sp)
    panic("Not Implemented!");
ffffffffc0200370:	eafff0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc0200374 <mon_help>:
    }
}

/* mon_help - print the information about mon_* functions */
int mon_help(int argc, char **argv, struct trapframe *tf)
{
ffffffffc0200374:	1141                	addi	sp,sp,-16
    int i;
    for (i = 0; i < NCOMMANDS; i++)
    {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc0200376:	00005617          	auipc	a2,0x5
ffffffffc020037a:	48a60613          	addi	a2,a2,1162 # ffffffffc0205800 <etext+0x176>
ffffffffc020037e:	00005597          	auipc	a1,0x5
ffffffffc0200382:	4a258593          	addi	a1,a1,1186 # ffffffffc0205820 <etext+0x196>
ffffffffc0200386:	00005517          	auipc	a0,0x5
ffffffffc020038a:	4a250513          	addi	a0,a0,1186 # ffffffffc0205828 <etext+0x19e>
{
ffffffffc020038e:	e406                	sd	ra,8(sp)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc0200390:	d51ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
ffffffffc0200394:	00005617          	auipc	a2,0x5
ffffffffc0200398:	4a460613          	addi	a2,a2,1188 # ffffffffc0205838 <etext+0x1ae>
ffffffffc020039c:	00005597          	auipc	a1,0x5
ffffffffc02003a0:	4c458593          	addi	a1,a1,1220 # ffffffffc0205860 <etext+0x1d6>
ffffffffc02003a4:	00005517          	auipc	a0,0x5
ffffffffc02003a8:	48450513          	addi	a0,a0,1156 # ffffffffc0205828 <etext+0x19e>
ffffffffc02003ac:	d35ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
ffffffffc02003b0:	00005617          	auipc	a2,0x5
ffffffffc02003b4:	4c060613          	addi	a2,a2,1216 # ffffffffc0205870 <etext+0x1e6>
ffffffffc02003b8:	00005597          	auipc	a1,0x5
ffffffffc02003bc:	4d858593          	addi	a1,a1,1240 # ffffffffc0205890 <etext+0x206>
ffffffffc02003c0:	00005517          	auipc	a0,0x5
ffffffffc02003c4:	46850513          	addi	a0,a0,1128 # ffffffffc0205828 <etext+0x19e>
ffffffffc02003c8:	d19ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    }
    return 0;
}
ffffffffc02003cc:	60a2                	ld	ra,8(sp)
ffffffffc02003ce:	4501                	li	a0,0
ffffffffc02003d0:	0141                	addi	sp,sp,16
ffffffffc02003d2:	8082                	ret

ffffffffc02003d4 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int mon_kerninfo(int argc, char **argv, struct trapframe *tf)
{
ffffffffc02003d4:	1141                	addi	sp,sp,-16
ffffffffc02003d6:	e406                	sd	ra,8(sp)
    print_kerninfo();
ffffffffc02003d8:	ef3ff0ef          	jal	ra,ffffffffc02002ca <print_kerninfo>
    return 0;
}
ffffffffc02003dc:	60a2                	ld	ra,8(sp)
ffffffffc02003de:	4501                	li	a0,0
ffffffffc02003e0:	0141                	addi	sp,sp,16
ffffffffc02003e2:	8082                	ret

ffffffffc02003e4 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int mon_backtrace(int argc, char **argv, struct trapframe *tf)
{
ffffffffc02003e4:	1141                	addi	sp,sp,-16
ffffffffc02003e6:	e406                	sd	ra,8(sp)
    print_stackframe();
ffffffffc02003e8:	f71ff0ef          	jal	ra,ffffffffc0200358 <print_stackframe>
    return 0;
}
ffffffffc02003ec:	60a2                	ld	ra,8(sp)
ffffffffc02003ee:	4501                	li	a0,0
ffffffffc02003f0:	0141                	addi	sp,sp,16
ffffffffc02003f2:	8082                	ret

ffffffffc02003f4 <kmonitor>:
{
ffffffffc02003f4:	7115                	addi	sp,sp,-224
ffffffffc02003f6:	ed5e                	sd	s7,152(sp)
ffffffffc02003f8:	8baa                	mv	s7,a0
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc02003fa:	00005517          	auipc	a0,0x5
ffffffffc02003fe:	4a650513          	addi	a0,a0,1190 # ffffffffc02058a0 <etext+0x216>
{
ffffffffc0200402:	ed86                	sd	ra,216(sp)
ffffffffc0200404:	e9a2                	sd	s0,208(sp)
ffffffffc0200406:	e5a6                	sd	s1,200(sp)
ffffffffc0200408:	e1ca                	sd	s2,192(sp)
ffffffffc020040a:	fd4e                	sd	s3,184(sp)
ffffffffc020040c:	f952                	sd	s4,176(sp)
ffffffffc020040e:	f556                	sd	s5,168(sp)
ffffffffc0200410:	f15a                	sd	s6,160(sp)
ffffffffc0200412:	e962                	sd	s8,144(sp)
ffffffffc0200414:	e566                	sd	s9,136(sp)
ffffffffc0200416:	e16a                	sd	s10,128(sp)
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc0200418:	cc9ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
ffffffffc020041c:	00005517          	auipc	a0,0x5
ffffffffc0200420:	4ac50513          	addi	a0,a0,1196 # ffffffffc02058c8 <etext+0x23e>
ffffffffc0200424:	cbdff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    if (tf != NULL)
ffffffffc0200428:	000b8563          	beqz	s7,ffffffffc0200432 <kmonitor+0x3e>
        print_trapframe(tf);
ffffffffc020042c:	855e                	mv	a0,s7
ffffffffc020042e:	77a000ef          	jal	ra,ffffffffc0200ba8 <print_trapframe>
ffffffffc0200432:	00005c17          	auipc	s8,0x5
ffffffffc0200436:	506c0c13          	addi	s8,s8,1286 # ffffffffc0205938 <commands>
        if ((buf = readline("K> ")) != NULL)
ffffffffc020043a:	00005917          	auipc	s2,0x5
ffffffffc020043e:	4b690913          	addi	s2,s2,1206 # ffffffffc02058f0 <etext+0x266>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc0200442:	00005497          	auipc	s1,0x5
ffffffffc0200446:	4b648493          	addi	s1,s1,1206 # ffffffffc02058f8 <etext+0x26e>
        if (argc == MAXARGS - 1)
ffffffffc020044a:	49bd                	li	s3,15
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc020044c:	00005b17          	auipc	s6,0x5
ffffffffc0200450:	4b4b0b13          	addi	s6,s6,1204 # ffffffffc0205900 <etext+0x276>
        argv[argc++] = buf;
ffffffffc0200454:	00005a17          	auipc	s4,0x5
ffffffffc0200458:	3cca0a13          	addi	s4,s4,972 # ffffffffc0205820 <etext+0x196>
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc020045c:	4a8d                	li	s5,3
        if ((buf = readline("K> ")) != NULL)
ffffffffc020045e:	854a                	mv	a0,s2
ffffffffc0200460:	d0bff0ef          	jal	ra,ffffffffc020016a <readline>
ffffffffc0200464:	842a                	mv	s0,a0
ffffffffc0200466:	dd65                	beqz	a0,ffffffffc020045e <kmonitor+0x6a>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc0200468:	00054583          	lbu	a1,0(a0)
    int argc = 0;
ffffffffc020046c:	4c81                	li	s9,0
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc020046e:	e1bd                	bnez	a1,ffffffffc02004d4 <kmonitor+0xe0>
    if (argc == 0)
ffffffffc0200470:	fe0c87e3          	beqz	s9,ffffffffc020045e <kmonitor+0x6a>
        if (strcmp(commands[i].name, argv[0]) == 0)
ffffffffc0200474:	6582                	ld	a1,0(sp)
ffffffffc0200476:	00005d17          	auipc	s10,0x5
ffffffffc020047a:	4c2d0d13          	addi	s10,s10,1218 # ffffffffc0205938 <commands>
        argv[argc++] = buf;
ffffffffc020047e:	8552                	mv	a0,s4
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc0200480:	4401                	li	s0,0
ffffffffc0200482:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0)
ffffffffc0200484:	57f040ef          	jal	ra,ffffffffc0205202 <strcmp>
ffffffffc0200488:	c919                	beqz	a0,ffffffffc020049e <kmonitor+0xaa>
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc020048a:	2405                	addiw	s0,s0,1
ffffffffc020048c:	0b540063          	beq	s0,s5,ffffffffc020052c <kmonitor+0x138>
        if (strcmp(commands[i].name, argv[0]) == 0)
ffffffffc0200490:	000d3503          	ld	a0,0(s10)
ffffffffc0200494:	6582                	ld	a1,0(sp)
    for (i = 0; i < NCOMMANDS; i++)
ffffffffc0200496:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0)
ffffffffc0200498:	56b040ef          	jal	ra,ffffffffc0205202 <strcmp>
ffffffffc020049c:	f57d                	bnez	a0,ffffffffc020048a <kmonitor+0x96>
            return commands[i].func(argc - 1, argv + 1, tf);
ffffffffc020049e:	00141793          	slli	a5,s0,0x1
ffffffffc02004a2:	97a2                	add	a5,a5,s0
ffffffffc02004a4:	078e                	slli	a5,a5,0x3
ffffffffc02004a6:	97e2                	add	a5,a5,s8
ffffffffc02004a8:	6b9c                	ld	a5,16(a5)
ffffffffc02004aa:	865e                	mv	a2,s7
ffffffffc02004ac:	002c                	addi	a1,sp,8
ffffffffc02004ae:	fffc851b          	addiw	a0,s9,-1
ffffffffc02004b2:	9782                	jalr	a5
            if (runcmd(buf, tf) < 0)
ffffffffc02004b4:	fa0555e3          	bgez	a0,ffffffffc020045e <kmonitor+0x6a>
}
ffffffffc02004b8:	60ee                	ld	ra,216(sp)
ffffffffc02004ba:	644e                	ld	s0,208(sp)
ffffffffc02004bc:	64ae                	ld	s1,200(sp)
ffffffffc02004be:	690e                	ld	s2,192(sp)
ffffffffc02004c0:	79ea                	ld	s3,184(sp)
ffffffffc02004c2:	7a4a                	ld	s4,176(sp)
ffffffffc02004c4:	7aaa                	ld	s5,168(sp)
ffffffffc02004c6:	7b0a                	ld	s6,160(sp)
ffffffffc02004c8:	6bea                	ld	s7,152(sp)
ffffffffc02004ca:	6c4a                	ld	s8,144(sp)
ffffffffc02004cc:	6caa                	ld	s9,136(sp)
ffffffffc02004ce:	6d0a                	ld	s10,128(sp)
ffffffffc02004d0:	612d                	addi	sp,sp,224
ffffffffc02004d2:	8082                	ret
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc02004d4:	8526                	mv	a0,s1
ffffffffc02004d6:	571040ef          	jal	ra,ffffffffc0205246 <strchr>
ffffffffc02004da:	c901                	beqz	a0,ffffffffc02004ea <kmonitor+0xf6>
ffffffffc02004dc:	00144583          	lbu	a1,1(s0)
            *buf++ = '\0';
ffffffffc02004e0:	00040023          	sb	zero,0(s0)
ffffffffc02004e4:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc02004e6:	d5c9                	beqz	a1,ffffffffc0200470 <kmonitor+0x7c>
ffffffffc02004e8:	b7f5                	j	ffffffffc02004d4 <kmonitor+0xe0>
        if (*buf == '\0')
ffffffffc02004ea:	00044783          	lbu	a5,0(s0)
ffffffffc02004ee:	d3c9                	beqz	a5,ffffffffc0200470 <kmonitor+0x7c>
        if (argc == MAXARGS - 1)
ffffffffc02004f0:	033c8963          	beq	s9,s3,ffffffffc0200522 <kmonitor+0x12e>
        argv[argc++] = buf;
ffffffffc02004f4:	003c9793          	slli	a5,s9,0x3
ffffffffc02004f8:	0118                	addi	a4,sp,128
ffffffffc02004fa:	97ba                	add	a5,a5,a4
ffffffffc02004fc:	f887b023          	sd	s0,-128(a5)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL)
ffffffffc0200500:	00044583          	lbu	a1,0(s0)
        argv[argc++] = buf;
ffffffffc0200504:	2c85                	addiw	s9,s9,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL)
ffffffffc0200506:	e591                	bnez	a1,ffffffffc0200512 <kmonitor+0x11e>
ffffffffc0200508:	b7b5                	j	ffffffffc0200474 <kmonitor+0x80>
ffffffffc020050a:	00144583          	lbu	a1,1(s0)
            buf++;
ffffffffc020050e:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL)
ffffffffc0200510:	d1a5                	beqz	a1,ffffffffc0200470 <kmonitor+0x7c>
ffffffffc0200512:	8526                	mv	a0,s1
ffffffffc0200514:	533040ef          	jal	ra,ffffffffc0205246 <strchr>
ffffffffc0200518:	d96d                	beqz	a0,ffffffffc020050a <kmonitor+0x116>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL)
ffffffffc020051a:	00044583          	lbu	a1,0(s0)
ffffffffc020051e:	d9a9                	beqz	a1,ffffffffc0200470 <kmonitor+0x7c>
ffffffffc0200520:	bf55                	j	ffffffffc02004d4 <kmonitor+0xe0>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc0200522:	45c1                	li	a1,16
ffffffffc0200524:	855a                	mv	a0,s6
ffffffffc0200526:	bbbff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
ffffffffc020052a:	b7e9                	j	ffffffffc02004f4 <kmonitor+0x100>
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc020052c:	6582                	ld	a1,0(sp)
ffffffffc020052e:	00005517          	auipc	a0,0x5
ffffffffc0200532:	3f250513          	addi	a0,a0,1010 # ffffffffc0205920 <etext+0x296>
ffffffffc0200536:	babff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    return 0;
ffffffffc020053a:	b715                	j	ffffffffc020045e <kmonitor+0x6a>

ffffffffc020053c <dtb_init>:

// 保存解析出的系统物理内存信息
static uint64_t memory_base = 0;
static uint64_t memory_size = 0;

void dtb_init(void) {
ffffffffc020053c:	7119                	addi	sp,sp,-128
    cprintf("DTB Init\n");
ffffffffc020053e:	00005517          	auipc	a0,0x5
ffffffffc0200542:	44250513          	addi	a0,a0,1090 # ffffffffc0205980 <commands+0x48>
void dtb_init(void) {
ffffffffc0200546:	fc86                	sd	ra,120(sp)
ffffffffc0200548:	f8a2                	sd	s0,112(sp)
ffffffffc020054a:	e8d2                	sd	s4,80(sp)
ffffffffc020054c:	f4a6                	sd	s1,104(sp)
ffffffffc020054e:	f0ca                	sd	s2,96(sp)
ffffffffc0200550:	ecce                	sd	s3,88(sp)
ffffffffc0200552:	e4d6                	sd	s5,72(sp)
ffffffffc0200554:	e0da                	sd	s6,64(sp)
ffffffffc0200556:	fc5e                	sd	s7,56(sp)
ffffffffc0200558:	f862                	sd	s8,48(sp)
ffffffffc020055a:	f466                	sd	s9,40(sp)
ffffffffc020055c:	f06a                	sd	s10,32(sp)
ffffffffc020055e:	ec6e                	sd	s11,24(sp)
    cprintf("DTB Init\n");
ffffffffc0200560:	b81ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc0200564:	0000b597          	auipc	a1,0xb
ffffffffc0200568:	a9c5b583          	ld	a1,-1380(a1) # ffffffffc020b000 <boot_hartid>
ffffffffc020056c:	00005517          	auipc	a0,0x5
ffffffffc0200570:	42450513          	addi	a0,a0,1060 # ffffffffc0205990 <commands+0x58>
ffffffffc0200574:	b6dff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc0200578:	0000b417          	auipc	s0,0xb
ffffffffc020057c:	a9040413          	addi	s0,s0,-1392 # ffffffffc020b008 <boot_dtb>
ffffffffc0200580:	600c                	ld	a1,0(s0)
ffffffffc0200582:	00005517          	auipc	a0,0x5
ffffffffc0200586:	41e50513          	addi	a0,a0,1054 # ffffffffc02059a0 <commands+0x68>
ffffffffc020058a:	b57ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc020058e:	00043a03          	ld	s4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc0200592:	00005517          	auipc	a0,0x5
ffffffffc0200596:	42650513          	addi	a0,a0,1062 # ffffffffc02059b8 <commands+0x80>
    if (boot_dtb == 0) {
ffffffffc020059a:	120a0463          	beqz	s4,ffffffffc02006c2 <dtb_init+0x186>
        return;
    }
    
    // 转换为虚拟地址
    uintptr_t dtb_vaddr = boot_dtb + PHYSICAL_MEMORY_OFFSET;
ffffffffc020059e:	57f5                	li	a5,-3
ffffffffc02005a0:	07fa                	slli	a5,a5,0x1e
ffffffffc02005a2:	00fa0733          	add	a4,s4,a5
    const struct fdt_header *header = (const struct fdt_header *)dtb_vaddr;
    
    // 验证DTB
    uint32_t magic = fdt32_to_cpu(header->magic);
ffffffffc02005a6:	431c                	lw	a5,0(a4)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005a8:	00ff0637          	lui	a2,0xff0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005ac:	6b41                	lui	s6,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005ae:	0087d59b          	srliw	a1,a5,0x8
ffffffffc02005b2:	0187969b          	slliw	a3,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005b6:	0187d51b          	srliw	a0,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005ba:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005be:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005c2:	8df1                	and	a1,a1,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005c4:	8ec9                	or	a3,a3,a0
ffffffffc02005c6:	0087979b          	slliw	a5,a5,0x8
ffffffffc02005ca:	1b7d                	addi	s6,s6,-1
ffffffffc02005cc:	0167f7b3          	and	a5,a5,s6
ffffffffc02005d0:	8dd5                	or	a1,a1,a3
ffffffffc02005d2:	8ddd                	or	a1,a1,a5
    if (magic != 0xd00dfeed) {
ffffffffc02005d4:	d00e07b7          	lui	a5,0xd00e0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005d8:	2581                	sext.w	a1,a1
    if (magic != 0xd00dfeed) {
ffffffffc02005da:	eed78793          	addi	a5,a5,-275 # ffffffffd00dfeed <end+0xfe35791>
ffffffffc02005de:	10f59163          	bne	a1,a5,ffffffffc02006e0 <dtb_init+0x1a4>
        return;
    }
    
    // 提取内存信息
    uint64_t mem_base, mem_size;
    if (extract_memory_info(dtb_vaddr, header, &mem_base, &mem_size) == 0) {
ffffffffc02005e2:	471c                	lw	a5,8(a4)
ffffffffc02005e4:	4754                	lw	a3,12(a4)
    int in_memory_node = 0;
ffffffffc02005e6:	4c81                	li	s9,0
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005e8:	0087d59b          	srliw	a1,a5,0x8
ffffffffc02005ec:	0086d51b          	srliw	a0,a3,0x8
ffffffffc02005f0:	0186941b          	slliw	s0,a3,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005f4:	0186d89b          	srliw	a7,a3,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005f8:	01879a1b          	slliw	s4,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005fc:	0187d81b          	srliw	a6,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200600:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200604:	0106d69b          	srliw	a3,a3,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200608:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020060c:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200610:	8d71                	and	a0,a0,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200612:	01146433          	or	s0,s0,a7
ffffffffc0200616:	0086969b          	slliw	a3,a3,0x8
ffffffffc020061a:	010a6a33          	or	s4,s4,a6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020061e:	8e6d                	and	a2,a2,a1
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200620:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200624:	8c49                	or	s0,s0,a0
ffffffffc0200626:	0166f6b3          	and	a3,a3,s6
ffffffffc020062a:	00ca6a33          	or	s4,s4,a2
ffffffffc020062e:	0167f7b3          	and	a5,a5,s6
ffffffffc0200632:	8c55                	or	s0,s0,a3
ffffffffc0200634:	00fa6a33          	or	s4,s4,a5
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200638:	1402                	slli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc020063a:	1a02                	slli	s4,s4,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc020063c:	9001                	srli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc020063e:	020a5a13          	srli	s4,s4,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200642:	943a                	add	s0,s0,a4
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200644:	9a3a                	add	s4,s4,a4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200646:	00ff0c37          	lui	s8,0xff0
        switch (token) {
ffffffffc020064a:	4b8d                	li	s7,3
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020064c:	00005917          	auipc	s2,0x5
ffffffffc0200650:	3bc90913          	addi	s2,s2,956 # ffffffffc0205a08 <commands+0xd0>
ffffffffc0200654:	49bd                	li	s3,15
        switch (token) {
ffffffffc0200656:	4d91                	li	s11,4
ffffffffc0200658:	4d05                	li	s10,1
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc020065a:	00005497          	auipc	s1,0x5
ffffffffc020065e:	3a648493          	addi	s1,s1,934 # ffffffffc0205a00 <commands+0xc8>
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200662:	000a2703          	lw	a4,0(s4)
ffffffffc0200666:	004a0a93          	addi	s5,s4,4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020066a:	0087569b          	srliw	a3,a4,0x8
ffffffffc020066e:	0187179b          	slliw	a5,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200672:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200676:	0106969b          	slliw	a3,a3,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020067a:	0107571b          	srliw	a4,a4,0x10
ffffffffc020067e:	8fd1                	or	a5,a5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200680:	0186f6b3          	and	a3,a3,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200684:	0087171b          	slliw	a4,a4,0x8
ffffffffc0200688:	8fd5                	or	a5,a5,a3
ffffffffc020068a:	00eb7733          	and	a4,s6,a4
ffffffffc020068e:	8fd9                	or	a5,a5,a4
ffffffffc0200690:	2781                	sext.w	a5,a5
        switch (token) {
ffffffffc0200692:	09778c63          	beq	a5,s7,ffffffffc020072a <dtb_init+0x1ee>
ffffffffc0200696:	00fbea63          	bltu	s7,a5,ffffffffc02006aa <dtb_init+0x16e>
ffffffffc020069a:	07a78663          	beq	a5,s10,ffffffffc0200706 <dtb_init+0x1ca>
ffffffffc020069e:	4709                	li	a4,2
ffffffffc02006a0:	00e79763          	bne	a5,a4,ffffffffc02006ae <dtb_init+0x172>
ffffffffc02006a4:	4c81                	li	s9,0
ffffffffc02006a6:	8a56                	mv	s4,s5
ffffffffc02006a8:	bf6d                	j	ffffffffc0200662 <dtb_init+0x126>
ffffffffc02006aa:	ffb78ee3          	beq	a5,s11,ffffffffc02006a6 <dtb_init+0x16a>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
        // 保存到全局变量，供 PMM 查询
        memory_base = mem_base;
        memory_size = mem_size;
    } else {
        cprintf("Warning: Could not extract memory info from DTB\n");
ffffffffc02006ae:	00005517          	auipc	a0,0x5
ffffffffc02006b2:	3d250513          	addi	a0,a0,978 # ffffffffc0205a80 <commands+0x148>
ffffffffc02006b6:	a2bff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc02006ba:	00005517          	auipc	a0,0x5
ffffffffc02006be:	3fe50513          	addi	a0,a0,1022 # ffffffffc0205ab8 <commands+0x180>
}
ffffffffc02006c2:	7446                	ld	s0,112(sp)
ffffffffc02006c4:	70e6                	ld	ra,120(sp)
ffffffffc02006c6:	74a6                	ld	s1,104(sp)
ffffffffc02006c8:	7906                	ld	s2,96(sp)
ffffffffc02006ca:	69e6                	ld	s3,88(sp)
ffffffffc02006cc:	6a46                	ld	s4,80(sp)
ffffffffc02006ce:	6aa6                	ld	s5,72(sp)
ffffffffc02006d0:	6b06                	ld	s6,64(sp)
ffffffffc02006d2:	7be2                	ld	s7,56(sp)
ffffffffc02006d4:	7c42                	ld	s8,48(sp)
ffffffffc02006d6:	7ca2                	ld	s9,40(sp)
ffffffffc02006d8:	7d02                	ld	s10,32(sp)
ffffffffc02006da:	6de2                	ld	s11,24(sp)
ffffffffc02006dc:	6109                	addi	sp,sp,128
    cprintf("DTB init completed\n");
ffffffffc02006de:	b409                	j	ffffffffc02000e0 <cprintf>
}
ffffffffc02006e0:	7446                	ld	s0,112(sp)
ffffffffc02006e2:	70e6                	ld	ra,120(sp)
ffffffffc02006e4:	74a6                	ld	s1,104(sp)
ffffffffc02006e6:	7906                	ld	s2,96(sp)
ffffffffc02006e8:	69e6                	ld	s3,88(sp)
ffffffffc02006ea:	6a46                	ld	s4,80(sp)
ffffffffc02006ec:	6aa6                	ld	s5,72(sp)
ffffffffc02006ee:	6b06                	ld	s6,64(sp)
ffffffffc02006f0:	7be2                	ld	s7,56(sp)
ffffffffc02006f2:	7c42                	ld	s8,48(sp)
ffffffffc02006f4:	7ca2                	ld	s9,40(sp)
ffffffffc02006f6:	7d02                	ld	s10,32(sp)
ffffffffc02006f8:	6de2                	ld	s11,24(sp)
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc02006fa:	00005517          	auipc	a0,0x5
ffffffffc02006fe:	2de50513          	addi	a0,a0,734 # ffffffffc02059d8 <commands+0xa0>
}
ffffffffc0200702:	6109                	addi	sp,sp,128
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc0200704:	baf1                	j	ffffffffc02000e0 <cprintf>
                int name_len = strlen(name);
ffffffffc0200706:	8556                	mv	a0,s5
ffffffffc0200708:	2b3040ef          	jal	ra,ffffffffc02051ba <strlen>
ffffffffc020070c:	8a2a                	mv	s4,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc020070e:	4619                	li	a2,6
ffffffffc0200710:	85a6                	mv	a1,s1
ffffffffc0200712:	8556                	mv	a0,s5
                int name_len = strlen(name);
ffffffffc0200714:	2a01                	sext.w	s4,s4
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc0200716:	30b040ef          	jal	ra,ffffffffc0205220 <strncmp>
ffffffffc020071a:	e111                	bnez	a0,ffffffffc020071e <dtb_init+0x1e2>
                    in_memory_node = 1;
ffffffffc020071c:	4c85                	li	s9,1
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc020071e:	0a91                	addi	s5,s5,4
ffffffffc0200720:	9ad2                	add	s5,s5,s4
ffffffffc0200722:	ffcafa93          	andi	s5,s5,-4
        switch (token) {
ffffffffc0200726:	8a56                	mv	s4,s5
ffffffffc0200728:	bf2d                	j	ffffffffc0200662 <dtb_init+0x126>
                uint32_t prop_len = fdt32_to_cpu(*struct_ptr++);
ffffffffc020072a:	004a2783          	lw	a5,4(s4)
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc020072e:	00ca0693          	addi	a3,s4,12
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200732:	0087d71b          	srliw	a4,a5,0x8
ffffffffc0200736:	01879a9b          	slliw	s5,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020073a:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020073e:	0107171b          	slliw	a4,a4,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200742:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200746:	00caeab3          	or	s5,s5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020074a:	01877733          	and	a4,a4,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020074e:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200752:	00eaeab3          	or	s5,s5,a4
ffffffffc0200756:	00fb77b3          	and	a5,s6,a5
ffffffffc020075a:	00faeab3          	or	s5,s5,a5
ffffffffc020075e:	2a81                	sext.w	s5,s5
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200760:	000c9c63          	bnez	s9,ffffffffc0200778 <dtb_init+0x23c>
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + prop_len + 3) & ~3);
ffffffffc0200764:	1a82                	slli	s5,s5,0x20
ffffffffc0200766:	00368793          	addi	a5,a3,3
ffffffffc020076a:	020ada93          	srli	s5,s5,0x20
ffffffffc020076e:	9abe                	add	s5,s5,a5
ffffffffc0200770:	ffcafa93          	andi	s5,s5,-4
        switch (token) {
ffffffffc0200774:	8a56                	mv	s4,s5
ffffffffc0200776:	b5f5                	j	ffffffffc0200662 <dtb_init+0x126>
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200778:	008a2783          	lw	a5,8(s4)
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc020077c:	85ca                	mv	a1,s2
ffffffffc020077e:	e436                	sd	a3,8(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200780:	0087d51b          	srliw	a0,a5,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200784:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200788:	0187971b          	slliw	a4,a5,0x18
ffffffffc020078c:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200790:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200794:	8f51                	or	a4,a4,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200796:	01857533          	and	a0,a0,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020079a:	0087979b          	slliw	a5,a5,0x8
ffffffffc020079e:	8d59                	or	a0,a0,a4
ffffffffc02007a0:	00fb77b3          	and	a5,s6,a5
ffffffffc02007a4:	8d5d                	or	a0,a0,a5
                const char *prop_name = strings_base + prop_nameoff;
ffffffffc02007a6:	1502                	slli	a0,a0,0x20
ffffffffc02007a8:	9101                	srli	a0,a0,0x20
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc02007aa:	9522                	add	a0,a0,s0
ffffffffc02007ac:	257040ef          	jal	ra,ffffffffc0205202 <strcmp>
ffffffffc02007b0:	66a2                	ld	a3,8(sp)
ffffffffc02007b2:	f94d                	bnez	a0,ffffffffc0200764 <dtb_init+0x228>
ffffffffc02007b4:	fb59f8e3          	bgeu	s3,s5,ffffffffc0200764 <dtb_init+0x228>
                    *mem_base = fdt64_to_cpu(reg_data[0]);
ffffffffc02007b8:	00ca3783          	ld	a5,12(s4)
                    *mem_size = fdt64_to_cpu(reg_data[1]);
ffffffffc02007bc:	014a3703          	ld	a4,20(s4)
        cprintf("Physical Memory from DTB:\n");
ffffffffc02007c0:	00005517          	auipc	a0,0x5
ffffffffc02007c4:	25050513          	addi	a0,a0,592 # ffffffffc0205a10 <commands+0xd8>
           fdt32_to_cpu(x >> 32);
ffffffffc02007c8:	4207d613          	srai	a2,a5,0x20
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007cc:	0087d31b          	srliw	t1,a5,0x8
           fdt32_to_cpu(x >> 32);
ffffffffc02007d0:	42075593          	srai	a1,a4,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007d4:	0187de1b          	srliw	t3,a5,0x18
ffffffffc02007d8:	0186581b          	srliw	a6,a2,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007dc:	0187941b          	slliw	s0,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007e0:	0107d89b          	srliw	a7,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007e4:	0187d693          	srli	a3,a5,0x18
ffffffffc02007e8:	01861f1b          	slliw	t5,a2,0x18
ffffffffc02007ec:	0087579b          	srliw	a5,a4,0x8
ffffffffc02007f0:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007f4:	0106561b          	srliw	a2,a2,0x10
ffffffffc02007f8:	010f6f33          	or	t5,t5,a6
ffffffffc02007fc:	0187529b          	srliw	t0,a4,0x18
ffffffffc0200800:	0185df9b          	srliw	t6,a1,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200804:	01837333          	and	t1,t1,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200808:	01c46433          	or	s0,s0,t3
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020080c:	0186f6b3          	and	a3,a3,s8
ffffffffc0200810:	01859e1b          	slliw	t3,a1,0x18
ffffffffc0200814:	01871e9b          	slliw	t4,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200818:	0107581b          	srliw	a6,a4,0x10
ffffffffc020081c:	0086161b          	slliw	a2,a2,0x8
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200820:	8361                	srli	a4,a4,0x18
ffffffffc0200822:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200826:	0105d59b          	srliw	a1,a1,0x10
ffffffffc020082a:	01e6e6b3          	or	a3,a3,t5
ffffffffc020082e:	00cb7633          	and	a2,s6,a2
ffffffffc0200832:	0088181b          	slliw	a6,a6,0x8
ffffffffc0200836:	0085959b          	slliw	a1,a1,0x8
ffffffffc020083a:	00646433          	or	s0,s0,t1
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020083e:	0187f7b3          	and	a5,a5,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200842:	01fe6333          	or	t1,t3,t6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200846:	01877c33          	and	s8,a4,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020084a:	0088989b          	slliw	a7,a7,0x8
ffffffffc020084e:	011b78b3          	and	a7,s6,a7
ffffffffc0200852:	005eeeb3          	or	t4,t4,t0
ffffffffc0200856:	00c6e733          	or	a4,a3,a2
ffffffffc020085a:	006c6c33          	or	s8,s8,t1
ffffffffc020085e:	010b76b3          	and	a3,s6,a6
ffffffffc0200862:	00bb7b33          	and	s6,s6,a1
ffffffffc0200866:	01d7e7b3          	or	a5,a5,t4
ffffffffc020086a:	016c6b33          	or	s6,s8,s6
ffffffffc020086e:	01146433          	or	s0,s0,a7
ffffffffc0200872:	8fd5                	or	a5,a5,a3
           fdt32_to_cpu(x >> 32);
ffffffffc0200874:	1702                	slli	a4,a4,0x20
ffffffffc0200876:	1b02                	slli	s6,s6,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc0200878:	1782                	slli	a5,a5,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc020087a:	9301                	srli	a4,a4,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc020087c:	1402                	slli	s0,s0,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc020087e:	020b5b13          	srli	s6,s6,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc0200882:	0167eb33          	or	s6,a5,s6
ffffffffc0200886:	8c59                	or	s0,s0,a4
        cprintf("Physical Memory from DTB:\n");
ffffffffc0200888:	859ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
        cprintf("  Base: 0x%016lx\n", mem_base);
ffffffffc020088c:	85a2                	mv	a1,s0
ffffffffc020088e:	00005517          	auipc	a0,0x5
ffffffffc0200892:	1a250513          	addi	a0,a0,418 # ffffffffc0205a30 <commands+0xf8>
ffffffffc0200896:	84bff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc020089a:	014b5613          	srli	a2,s6,0x14
ffffffffc020089e:	85da                	mv	a1,s6
ffffffffc02008a0:	00005517          	auipc	a0,0x5
ffffffffc02008a4:	1a850513          	addi	a0,a0,424 # ffffffffc0205a48 <commands+0x110>
ffffffffc02008a8:	839ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc02008ac:	008b05b3          	add	a1,s6,s0
ffffffffc02008b0:	15fd                	addi	a1,a1,-1
ffffffffc02008b2:	00005517          	auipc	a0,0x5
ffffffffc02008b6:	1b650513          	addi	a0,a0,438 # ffffffffc0205a68 <commands+0x130>
ffffffffc02008ba:	827ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("DTB init completed\n");
ffffffffc02008be:	00005517          	auipc	a0,0x5
ffffffffc02008c2:	1fa50513          	addi	a0,a0,506 # ffffffffc0205ab8 <commands+0x180>
        memory_base = mem_base;
ffffffffc02008c6:	000aa797          	auipc	a5,0xaa
ffffffffc02008ca:	e287b123          	sd	s0,-478(a5) # ffffffffc02aa6e8 <memory_base>
        memory_size = mem_size;
ffffffffc02008ce:	000aa797          	auipc	a5,0xaa
ffffffffc02008d2:	e367b123          	sd	s6,-478(a5) # ffffffffc02aa6f0 <memory_size>
    cprintf("DTB init completed\n");
ffffffffc02008d6:	b3f5                	j	ffffffffc02006c2 <dtb_init+0x186>

ffffffffc02008d8 <get_memory_base>:

uint64_t get_memory_base(void) {
    return memory_base;
}
ffffffffc02008d8:	000aa517          	auipc	a0,0xaa
ffffffffc02008dc:	e1053503          	ld	a0,-496(a0) # ffffffffc02aa6e8 <memory_base>
ffffffffc02008e0:	8082                	ret

ffffffffc02008e2 <get_memory_size>:

uint64_t get_memory_size(void) {
    return memory_size;
}
ffffffffc02008e2:	000aa517          	auipc	a0,0xaa
ffffffffc02008e6:	e0e53503          	ld	a0,-498(a0) # ffffffffc02aa6f0 <memory_size>
ffffffffc02008ea:	8082                	ret

ffffffffc02008ec <clock_init>:
 * and then enable IRQ_TIMER.
 * */
void clock_init(void) {
    // divided by 500 when using Spike(2MHz)
    // divided by 100 when using QEMU(10MHz)
    timebase = 1e7 / 100;
ffffffffc02008ec:	67e1                	lui	a5,0x18
ffffffffc02008ee:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_obj___user_exit_out_size+0xd580>
ffffffffc02008f2:	000aa717          	auipc	a4,0xaa
ffffffffc02008f6:	e0f73723          	sd	a5,-498(a4) # ffffffffc02aa700 <timebase>
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc02008fa:	c0102573          	rdtime	a0
	SBI_CALL_1(SBI_SET_TIMER, stime_value);
ffffffffc02008fe:	4581                	li	a1,0
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc0200900:	953e                	add	a0,a0,a5
ffffffffc0200902:	4601                	li	a2,0
ffffffffc0200904:	4881                	li	a7,0
ffffffffc0200906:	00000073          	ecall
    set_csr(sie, MIP_STIP);
ffffffffc020090a:	02000793          	li	a5,32
ffffffffc020090e:	1047a7f3          	csrrs	a5,sie,a5
    cprintf("++ setup timer interrupts\n");
ffffffffc0200912:	00005517          	auipc	a0,0x5
ffffffffc0200916:	1be50513          	addi	a0,a0,446 # ffffffffc0205ad0 <commands+0x198>
    ticks = 0;
ffffffffc020091a:	000aa797          	auipc	a5,0xaa
ffffffffc020091e:	dc07bf23          	sd	zero,-546(a5) # ffffffffc02aa6f8 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc0200922:	fbeff06f          	j	ffffffffc02000e0 <cprintf>

ffffffffc0200926 <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200926:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc020092a:	000aa797          	auipc	a5,0xaa
ffffffffc020092e:	dd67b783          	ld	a5,-554(a5) # ffffffffc02aa700 <timebase>
ffffffffc0200932:	953e                	add	a0,a0,a5
ffffffffc0200934:	4581                	li	a1,0
ffffffffc0200936:	4601                	li	a2,0
ffffffffc0200938:	4881                	li	a7,0
ffffffffc020093a:	00000073          	ecall
ffffffffc020093e:	8082                	ret

ffffffffc0200940 <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc0200940:	8082                	ret

ffffffffc0200942 <cons_putc>:
#include <riscv.h>
#include <assert.h>

static inline bool __intr_save(void)
{
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0200942:	100027f3          	csrr	a5,sstatus
ffffffffc0200946:	8b89                	andi	a5,a5,2
	SBI_CALL_1(SBI_CONSOLE_PUTCHAR, ch);
ffffffffc0200948:	0ff57513          	zext.b	a0,a0
ffffffffc020094c:	e799                	bnez	a5,ffffffffc020095a <cons_putc+0x18>
ffffffffc020094e:	4581                	li	a1,0
ffffffffc0200950:	4601                	li	a2,0
ffffffffc0200952:	4885                	li	a7,1
ffffffffc0200954:	00000073          	ecall
    return 0;
}

static inline void __intr_restore(bool flag)
{
    if (flag)
ffffffffc0200958:	8082                	ret

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) {
ffffffffc020095a:	1101                	addi	sp,sp,-32
ffffffffc020095c:	ec06                	sd	ra,24(sp)
ffffffffc020095e:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0200960:	05a000ef          	jal	ra,ffffffffc02009ba <intr_disable>
ffffffffc0200964:	6522                	ld	a0,8(sp)
ffffffffc0200966:	4581                	li	a1,0
ffffffffc0200968:	4601                	li	a2,0
ffffffffc020096a:	4885                	li	a7,1
ffffffffc020096c:	00000073          	ecall
    local_intr_save(intr_flag);
    {
        sbi_console_putchar((unsigned char)c);
    }
    local_intr_restore(intr_flag);
}
ffffffffc0200970:	60e2                	ld	ra,24(sp)
ffffffffc0200972:	6105                	addi	sp,sp,32
    {
        intr_enable();
ffffffffc0200974:	a081                	j	ffffffffc02009b4 <intr_enable>

ffffffffc0200976 <cons_getc>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0200976:	100027f3          	csrr	a5,sstatus
ffffffffc020097a:	8b89                	andi	a5,a5,2
ffffffffc020097c:	eb89                	bnez	a5,ffffffffc020098e <cons_getc+0x18>
	return SBI_CALL_0(SBI_CONSOLE_GETCHAR);
ffffffffc020097e:	4501                	li	a0,0
ffffffffc0200980:	4581                	li	a1,0
ffffffffc0200982:	4601                	li	a2,0
ffffffffc0200984:	4889                	li	a7,2
ffffffffc0200986:	00000073          	ecall
ffffffffc020098a:	2501                	sext.w	a0,a0
    {
        c = sbi_console_getchar();
    }
    local_intr_restore(intr_flag);
    return c;
}
ffffffffc020098c:	8082                	ret
int cons_getc(void) {
ffffffffc020098e:	1101                	addi	sp,sp,-32
ffffffffc0200990:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc0200992:	028000ef          	jal	ra,ffffffffc02009ba <intr_disable>
ffffffffc0200996:	4501                	li	a0,0
ffffffffc0200998:	4581                	li	a1,0
ffffffffc020099a:	4601                	li	a2,0
ffffffffc020099c:	4889                	li	a7,2
ffffffffc020099e:	00000073          	ecall
ffffffffc02009a2:	2501                	sext.w	a0,a0
ffffffffc02009a4:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc02009a6:	00e000ef          	jal	ra,ffffffffc02009b4 <intr_enable>
}
ffffffffc02009aa:	60e2                	ld	ra,24(sp)
ffffffffc02009ac:	6522                	ld	a0,8(sp)
ffffffffc02009ae:	6105                	addi	sp,sp,32
ffffffffc02009b0:	8082                	ret

ffffffffc02009b2 <pic_init>:
#include <picirq.h>

void pic_enable(unsigned int irq) {}

/* pic_init - initialize the 8259A interrupt controllers */
void pic_init(void) {}
ffffffffc02009b2:	8082                	ret

ffffffffc02009b4 <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
ffffffffc02009b4:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc02009b8:	8082                	ret

ffffffffc02009ba <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void) { clear_csr(sstatus, SSTATUS_SIE); }
ffffffffc02009ba:	100177f3          	csrrci	a5,sstatus,2
ffffffffc02009be:	8082                	ret

ffffffffc02009c0 <idt_init>:
void idt_init(void)
{
    extern void __alltraps(void);
    /* Set sscratch register to 0, indicating to exception vector that we are
     * presently executing in the kernel */
    write_csr(sscratch, 0);
ffffffffc02009c0:	14005073          	csrwi	sscratch,0
    /* Set the exception vector address */
    write_csr(stvec, &__alltraps);
ffffffffc02009c4:	00000797          	auipc	a5,0x0
ffffffffc02009c8:	48078793          	addi	a5,a5,1152 # ffffffffc0200e44 <__alltraps>
ffffffffc02009cc:	10579073          	csrw	stvec,a5
    /* Allow kernel to access user memory */
    set_csr(sstatus, SSTATUS_SUM);
ffffffffc02009d0:	000407b7          	lui	a5,0x40
ffffffffc02009d4:	1007a7f3          	csrrs	a5,sstatus,a5
}
ffffffffc02009d8:	8082                	ret

ffffffffc02009da <print_regs>:
    cprintf("  cause    0x%08x\n", tf->cause);
}

void print_regs(struct pushregs *gpr)
{
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02009da:	610c                	ld	a1,0(a0)
{
ffffffffc02009dc:	1141                	addi	sp,sp,-16
ffffffffc02009de:	e022                	sd	s0,0(sp)
ffffffffc02009e0:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02009e2:	00005517          	auipc	a0,0x5
ffffffffc02009e6:	10e50513          	addi	a0,a0,270 # ffffffffc0205af0 <commands+0x1b8>
{
ffffffffc02009ea:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc02009ec:	ef4ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc02009f0:	640c                	ld	a1,8(s0)
ffffffffc02009f2:	00005517          	auipc	a0,0x5
ffffffffc02009f6:	11650513          	addi	a0,a0,278 # ffffffffc0205b08 <commands+0x1d0>
ffffffffc02009fa:	ee6ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc02009fe:	680c                	ld	a1,16(s0)
ffffffffc0200a00:	00005517          	auipc	a0,0x5
ffffffffc0200a04:	12050513          	addi	a0,a0,288 # ffffffffc0205b20 <commands+0x1e8>
ffffffffc0200a08:	ed8ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc0200a0c:	6c0c                	ld	a1,24(s0)
ffffffffc0200a0e:	00005517          	auipc	a0,0x5
ffffffffc0200a12:	12a50513          	addi	a0,a0,298 # ffffffffc0205b38 <commands+0x200>
ffffffffc0200a16:	ecaff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc0200a1a:	700c                	ld	a1,32(s0)
ffffffffc0200a1c:	00005517          	auipc	a0,0x5
ffffffffc0200a20:	13450513          	addi	a0,a0,308 # ffffffffc0205b50 <commands+0x218>
ffffffffc0200a24:	ebcff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc0200a28:	740c                	ld	a1,40(s0)
ffffffffc0200a2a:	00005517          	auipc	a0,0x5
ffffffffc0200a2e:	13e50513          	addi	a0,a0,318 # ffffffffc0205b68 <commands+0x230>
ffffffffc0200a32:	eaeff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc0200a36:	780c                	ld	a1,48(s0)
ffffffffc0200a38:	00005517          	auipc	a0,0x5
ffffffffc0200a3c:	14850513          	addi	a0,a0,328 # ffffffffc0205b80 <commands+0x248>
ffffffffc0200a40:	ea0ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc0200a44:	7c0c                	ld	a1,56(s0)
ffffffffc0200a46:	00005517          	auipc	a0,0x5
ffffffffc0200a4a:	15250513          	addi	a0,a0,338 # ffffffffc0205b98 <commands+0x260>
ffffffffc0200a4e:	e92ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc0200a52:	602c                	ld	a1,64(s0)
ffffffffc0200a54:	00005517          	auipc	a0,0x5
ffffffffc0200a58:	15c50513          	addi	a0,a0,348 # ffffffffc0205bb0 <commands+0x278>
ffffffffc0200a5c:	e84ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc0200a60:	642c                	ld	a1,72(s0)
ffffffffc0200a62:	00005517          	auipc	a0,0x5
ffffffffc0200a66:	16650513          	addi	a0,a0,358 # ffffffffc0205bc8 <commands+0x290>
ffffffffc0200a6a:	e76ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc0200a6e:	682c                	ld	a1,80(s0)
ffffffffc0200a70:	00005517          	auipc	a0,0x5
ffffffffc0200a74:	17050513          	addi	a0,a0,368 # ffffffffc0205be0 <commands+0x2a8>
ffffffffc0200a78:	e68ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc0200a7c:	6c2c                	ld	a1,88(s0)
ffffffffc0200a7e:	00005517          	auipc	a0,0x5
ffffffffc0200a82:	17a50513          	addi	a0,a0,378 # ffffffffc0205bf8 <commands+0x2c0>
ffffffffc0200a86:	e5aff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc0200a8a:	702c                	ld	a1,96(s0)
ffffffffc0200a8c:	00005517          	auipc	a0,0x5
ffffffffc0200a90:	18450513          	addi	a0,a0,388 # ffffffffc0205c10 <commands+0x2d8>
ffffffffc0200a94:	e4cff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc0200a98:	742c                	ld	a1,104(s0)
ffffffffc0200a9a:	00005517          	auipc	a0,0x5
ffffffffc0200a9e:	18e50513          	addi	a0,a0,398 # ffffffffc0205c28 <commands+0x2f0>
ffffffffc0200aa2:	e3eff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc0200aa6:	782c                	ld	a1,112(s0)
ffffffffc0200aa8:	00005517          	auipc	a0,0x5
ffffffffc0200aac:	19850513          	addi	a0,a0,408 # ffffffffc0205c40 <commands+0x308>
ffffffffc0200ab0:	e30ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc0200ab4:	7c2c                	ld	a1,120(s0)
ffffffffc0200ab6:	00005517          	auipc	a0,0x5
ffffffffc0200aba:	1a250513          	addi	a0,a0,418 # ffffffffc0205c58 <commands+0x320>
ffffffffc0200abe:	e22ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc0200ac2:	604c                	ld	a1,128(s0)
ffffffffc0200ac4:	00005517          	auipc	a0,0x5
ffffffffc0200ac8:	1ac50513          	addi	a0,a0,428 # ffffffffc0205c70 <commands+0x338>
ffffffffc0200acc:	e14ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc0200ad0:	644c                	ld	a1,136(s0)
ffffffffc0200ad2:	00005517          	auipc	a0,0x5
ffffffffc0200ad6:	1b650513          	addi	a0,a0,438 # ffffffffc0205c88 <commands+0x350>
ffffffffc0200ada:	e06ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc0200ade:	684c                	ld	a1,144(s0)
ffffffffc0200ae0:	00005517          	auipc	a0,0x5
ffffffffc0200ae4:	1c050513          	addi	a0,a0,448 # ffffffffc0205ca0 <commands+0x368>
ffffffffc0200ae8:	df8ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc0200aec:	6c4c                	ld	a1,152(s0)
ffffffffc0200aee:	00005517          	auipc	a0,0x5
ffffffffc0200af2:	1ca50513          	addi	a0,a0,458 # ffffffffc0205cb8 <commands+0x380>
ffffffffc0200af6:	deaff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc0200afa:	704c                	ld	a1,160(s0)
ffffffffc0200afc:	00005517          	auipc	a0,0x5
ffffffffc0200b00:	1d450513          	addi	a0,a0,468 # ffffffffc0205cd0 <commands+0x398>
ffffffffc0200b04:	ddcff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc0200b08:	744c                	ld	a1,168(s0)
ffffffffc0200b0a:	00005517          	auipc	a0,0x5
ffffffffc0200b0e:	1de50513          	addi	a0,a0,478 # ffffffffc0205ce8 <commands+0x3b0>
ffffffffc0200b12:	dceff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc0200b16:	784c                	ld	a1,176(s0)
ffffffffc0200b18:	00005517          	auipc	a0,0x5
ffffffffc0200b1c:	1e850513          	addi	a0,a0,488 # ffffffffc0205d00 <commands+0x3c8>
ffffffffc0200b20:	dc0ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc0200b24:	7c4c                	ld	a1,184(s0)
ffffffffc0200b26:	00005517          	auipc	a0,0x5
ffffffffc0200b2a:	1f250513          	addi	a0,a0,498 # ffffffffc0205d18 <commands+0x3e0>
ffffffffc0200b2e:	db2ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc0200b32:	606c                	ld	a1,192(s0)
ffffffffc0200b34:	00005517          	auipc	a0,0x5
ffffffffc0200b38:	1fc50513          	addi	a0,a0,508 # ffffffffc0205d30 <commands+0x3f8>
ffffffffc0200b3c:	da4ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc0200b40:	646c                	ld	a1,200(s0)
ffffffffc0200b42:	00005517          	auipc	a0,0x5
ffffffffc0200b46:	20650513          	addi	a0,a0,518 # ffffffffc0205d48 <commands+0x410>
ffffffffc0200b4a:	d96ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc0200b4e:	686c                	ld	a1,208(s0)
ffffffffc0200b50:	00005517          	auipc	a0,0x5
ffffffffc0200b54:	21050513          	addi	a0,a0,528 # ffffffffc0205d60 <commands+0x428>
ffffffffc0200b58:	d88ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc0200b5c:	6c6c                	ld	a1,216(s0)
ffffffffc0200b5e:	00005517          	auipc	a0,0x5
ffffffffc0200b62:	21a50513          	addi	a0,a0,538 # ffffffffc0205d78 <commands+0x440>
ffffffffc0200b66:	d7aff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc0200b6a:	706c                	ld	a1,224(s0)
ffffffffc0200b6c:	00005517          	auipc	a0,0x5
ffffffffc0200b70:	22450513          	addi	a0,a0,548 # ffffffffc0205d90 <commands+0x458>
ffffffffc0200b74:	d6cff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc0200b78:	746c                	ld	a1,232(s0)
ffffffffc0200b7a:	00005517          	auipc	a0,0x5
ffffffffc0200b7e:	22e50513          	addi	a0,a0,558 # ffffffffc0205da8 <commands+0x470>
ffffffffc0200b82:	d5eff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc0200b86:	786c                	ld	a1,240(s0)
ffffffffc0200b88:	00005517          	auipc	a0,0x5
ffffffffc0200b8c:	23850513          	addi	a0,a0,568 # ffffffffc0205dc0 <commands+0x488>
ffffffffc0200b90:	d50ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b94:	7c6c                	ld	a1,248(s0)
}
ffffffffc0200b96:	6402                	ld	s0,0(sp)
ffffffffc0200b98:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b9a:	00005517          	auipc	a0,0x5
ffffffffc0200b9e:	23e50513          	addi	a0,a0,574 # ffffffffc0205dd8 <commands+0x4a0>
}
ffffffffc0200ba2:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200ba4:	d3cff06f          	j	ffffffffc02000e0 <cprintf>

ffffffffc0200ba8 <print_trapframe>:
{
ffffffffc0200ba8:	1141                	addi	sp,sp,-16
ffffffffc0200baa:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200bac:	85aa                	mv	a1,a0
{
ffffffffc0200bae:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
ffffffffc0200bb0:	00005517          	auipc	a0,0x5
ffffffffc0200bb4:	24050513          	addi	a0,a0,576 # ffffffffc0205df0 <commands+0x4b8>
{
ffffffffc0200bb8:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200bba:	d26ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    print_regs(&tf->gpr);
ffffffffc0200bbe:	8522                	mv	a0,s0
ffffffffc0200bc0:	e1bff0ef          	jal	ra,ffffffffc02009da <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc0200bc4:	10043583          	ld	a1,256(s0)
ffffffffc0200bc8:	00005517          	auipc	a0,0x5
ffffffffc0200bcc:	24050513          	addi	a0,a0,576 # ffffffffc0205e08 <commands+0x4d0>
ffffffffc0200bd0:	d10ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc0200bd4:	10843583          	ld	a1,264(s0)
ffffffffc0200bd8:	00005517          	auipc	a0,0x5
ffffffffc0200bdc:	24850513          	addi	a0,a0,584 # ffffffffc0205e20 <commands+0x4e8>
ffffffffc0200be0:	d00ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  tval 0x%08x\n", tf->tval);
ffffffffc0200be4:	11043583          	ld	a1,272(s0)
ffffffffc0200be8:	00005517          	auipc	a0,0x5
ffffffffc0200bec:	25050513          	addi	a0,a0,592 # ffffffffc0205e38 <commands+0x500>
ffffffffc0200bf0:	cf0ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200bf4:	11843583          	ld	a1,280(s0)
}
ffffffffc0200bf8:	6402                	ld	s0,0(sp)
ffffffffc0200bfa:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200bfc:	00005517          	auipc	a0,0x5
ffffffffc0200c00:	24c50513          	addi	a0,a0,588 # ffffffffc0205e48 <commands+0x510>
}
ffffffffc0200c04:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200c06:	cdaff06f          	j	ffffffffc02000e0 <cprintf>

ffffffffc0200c0a <interrupt_handler>:

extern struct mm_struct *check_mm_struct;

void interrupt_handler(struct trapframe *tf)
{
    intptr_t cause = (tf->cause << 1) >> 1;
ffffffffc0200c0a:	11853783          	ld	a5,280(a0)
ffffffffc0200c0e:	472d                	li	a4,11
ffffffffc0200c10:	0786                	slli	a5,a5,0x1
ffffffffc0200c12:	8385                	srli	a5,a5,0x1
ffffffffc0200c14:	08f76363          	bltu	a4,a5,ffffffffc0200c9a <interrupt_handler+0x90>
ffffffffc0200c18:	00005717          	auipc	a4,0x5
ffffffffc0200c1c:	2e870713          	addi	a4,a4,744 # ffffffffc0205f00 <commands+0x5c8>
ffffffffc0200c20:	078a                	slli	a5,a5,0x2
ffffffffc0200c22:	97ba                	add	a5,a5,a4
ffffffffc0200c24:	439c                	lw	a5,0(a5)
ffffffffc0200c26:	97ba                	add	a5,a5,a4
ffffffffc0200c28:	8782                	jr	a5
        break;
    case IRQ_H_SOFT:
        cprintf("Hypervisor software interrupt\n");
        break;
    case IRQ_M_SOFT:
        cprintf("Machine software interrupt\n");
ffffffffc0200c2a:	00005517          	auipc	a0,0x5
ffffffffc0200c2e:	29650513          	addi	a0,a0,662 # ffffffffc0205ec0 <commands+0x588>
ffffffffc0200c32:	caeff06f          	j	ffffffffc02000e0 <cprintf>
        cprintf("Hypervisor software interrupt\n");
ffffffffc0200c36:	00005517          	auipc	a0,0x5
ffffffffc0200c3a:	26a50513          	addi	a0,a0,618 # ffffffffc0205ea0 <commands+0x568>
ffffffffc0200c3e:	ca2ff06f          	j	ffffffffc02000e0 <cprintf>
        cprintf("User software interrupt\n");
ffffffffc0200c42:	00005517          	auipc	a0,0x5
ffffffffc0200c46:	21e50513          	addi	a0,a0,542 # ffffffffc0205e60 <commands+0x528>
ffffffffc0200c4a:	c96ff06f          	j	ffffffffc02000e0 <cprintf>
        cprintf("Supervisor software interrupt\n");
ffffffffc0200c4e:	00005517          	auipc	a0,0x5
ffffffffc0200c52:	23250513          	addi	a0,a0,562 # ffffffffc0205e80 <commands+0x548>
ffffffffc0200c56:	c8aff06f          	j	ffffffffc02000e0 <cprintf>
{
ffffffffc0200c5a:	1141                	addi	sp,sp,-16
ffffffffc0200c5c:	e406                	sd	ra,8(sp)
/* 时间片轮转： 
*(1) 设置下一次时钟中断（clock_set_next_event）
*(2) ticks 计数器自增
*(3) 每 TICK_NUM 次中断（如 100 次），进行判断当前是否有进程正在运行，如果有则标记该进程需要被重新调度（current->need_resched）	
*/
	clock_set_next_event();
ffffffffc0200c5e:	cc9ff0ef          	jal	ra,ffffffffc0200926 <clock_set_next_event>
            if (++ticks % TICK_NUM == 0 && current) {
ffffffffc0200c62:	000aa697          	auipc	a3,0xaa
ffffffffc0200c66:	a9668693          	addi	a3,a3,-1386 # ffffffffc02aa6f8 <ticks>
ffffffffc0200c6a:	629c                	ld	a5,0(a3)
ffffffffc0200c6c:	06400713          	li	a4,100
ffffffffc0200c70:	0785                	addi	a5,a5,1
ffffffffc0200c72:	02e7f733          	remu	a4,a5,a4
ffffffffc0200c76:	e29c                	sd	a5,0(a3)
ffffffffc0200c78:	eb01                	bnez	a4,ffffffffc0200c88 <interrupt_handler+0x7e>
ffffffffc0200c7a:	000aa797          	auipc	a5,0xaa
ffffffffc0200c7e:	ac67b783          	ld	a5,-1338(a5) # ffffffffc02aa740 <current>
ffffffffc0200c82:	c399                	beqz	a5,ffffffffc0200c88 <interrupt_handler+0x7e>
                current->need_resched = 1;
ffffffffc0200c84:	4705                	li	a4,1
ffffffffc0200c86:	ef98                	sd	a4,24(a5)
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200c88:	60a2                	ld	ra,8(sp)
ffffffffc0200c8a:	0141                	addi	sp,sp,16
ffffffffc0200c8c:	8082                	ret
        cprintf("Supervisor external interrupt\n");
ffffffffc0200c8e:	00005517          	auipc	a0,0x5
ffffffffc0200c92:	25250513          	addi	a0,a0,594 # ffffffffc0205ee0 <commands+0x5a8>
ffffffffc0200c96:	c4aff06f          	j	ffffffffc02000e0 <cprintf>
        print_trapframe(tf);
ffffffffc0200c9a:	b739                	j	ffffffffc0200ba8 <print_trapframe>

ffffffffc0200c9c <exception_handler>:
void kernel_execve_ret(struct trapframe *tf, uintptr_t kstacktop);
void exception_handler(struct trapframe *tf)
{
    int ret;
    switch (tf->cause)
ffffffffc0200c9c:	11853783          	ld	a5,280(a0)
{
ffffffffc0200ca0:	1141                	addi	sp,sp,-16
ffffffffc0200ca2:	e022                	sd	s0,0(sp)
ffffffffc0200ca4:	e406                	sd	ra,8(sp)
ffffffffc0200ca6:	473d                	li	a4,15
ffffffffc0200ca8:	842a                	mv	s0,a0
ffffffffc0200caa:	0cf76463          	bltu	a4,a5,ffffffffc0200d72 <exception_handler+0xd6>
ffffffffc0200cae:	00005717          	auipc	a4,0x5
ffffffffc0200cb2:	41270713          	addi	a4,a4,1042 # ffffffffc02060c0 <commands+0x788>
ffffffffc0200cb6:	078a                	slli	a5,a5,0x2
ffffffffc0200cb8:	97ba                	add	a5,a5,a4
ffffffffc0200cba:	439c                	lw	a5,0(a5)
ffffffffc0200cbc:	97ba                	add	a5,a5,a4
ffffffffc0200cbe:	8782                	jr	a5
        // cprintf("Environment call from U-mode\n");
        tf->epc += 4;
        syscall();
        break;
    case CAUSE_SUPERVISOR_ECALL:
        cprintf("Environment call from S-mode\n");
ffffffffc0200cc0:	00005517          	auipc	a0,0x5
ffffffffc0200cc4:	35850513          	addi	a0,a0,856 # ffffffffc0206018 <commands+0x6e0>
ffffffffc0200cc8:	c18ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
        tf->epc += 4;
ffffffffc0200ccc:	10843783          	ld	a5,264(s0)
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200cd0:	60a2                	ld	ra,8(sp)
        tf->epc += 4;
ffffffffc0200cd2:	0791                	addi	a5,a5,4
ffffffffc0200cd4:	10f43423          	sd	a5,264(s0)
}
ffffffffc0200cd8:	6402                	ld	s0,0(sp)
ffffffffc0200cda:	0141                	addi	sp,sp,16
        syscall();
ffffffffc0200cdc:	45e0406f          	j	ffffffffc020513a <syscall>
        cprintf("Environment call from H-mode\n");
ffffffffc0200ce0:	00005517          	auipc	a0,0x5
ffffffffc0200ce4:	35850513          	addi	a0,a0,856 # ffffffffc0206038 <commands+0x700>
}
ffffffffc0200ce8:	6402                	ld	s0,0(sp)
ffffffffc0200cea:	60a2                	ld	ra,8(sp)
ffffffffc0200cec:	0141                	addi	sp,sp,16
        cprintf("Instruction access fault\n");
ffffffffc0200cee:	bf2ff06f          	j	ffffffffc02000e0 <cprintf>
        cprintf("Environment call from M-mode\n");
ffffffffc0200cf2:	00005517          	auipc	a0,0x5
ffffffffc0200cf6:	36650513          	addi	a0,a0,870 # ffffffffc0206058 <commands+0x720>
ffffffffc0200cfa:	b7fd                	j	ffffffffc0200ce8 <exception_handler+0x4c>
        cprintf("Instruction page fault\n");
ffffffffc0200cfc:	00005517          	auipc	a0,0x5
ffffffffc0200d00:	37c50513          	addi	a0,a0,892 # ffffffffc0206078 <commands+0x740>
ffffffffc0200d04:	b7d5                	j	ffffffffc0200ce8 <exception_handler+0x4c>
        cprintf("Load page fault\n");
ffffffffc0200d06:	00005517          	auipc	a0,0x5
ffffffffc0200d0a:	38a50513          	addi	a0,a0,906 # ffffffffc0206090 <commands+0x758>
ffffffffc0200d0e:	bfe9                	j	ffffffffc0200ce8 <exception_handler+0x4c>
        cprintf("Store/AMO page fault\n");
ffffffffc0200d10:	00005517          	auipc	a0,0x5
ffffffffc0200d14:	39850513          	addi	a0,a0,920 # ffffffffc02060a8 <commands+0x770>
ffffffffc0200d18:	bfc1                	j	ffffffffc0200ce8 <exception_handler+0x4c>
        cprintf("Instruction address misaligned\n");
ffffffffc0200d1a:	00005517          	auipc	a0,0x5
ffffffffc0200d1e:	21650513          	addi	a0,a0,534 # ffffffffc0205f30 <commands+0x5f8>
ffffffffc0200d22:	b7d9                	j	ffffffffc0200ce8 <exception_handler+0x4c>
        cprintf("Instruction access fault\n");
ffffffffc0200d24:	00005517          	auipc	a0,0x5
ffffffffc0200d28:	22c50513          	addi	a0,a0,556 # ffffffffc0205f50 <commands+0x618>
ffffffffc0200d2c:	bf75                	j	ffffffffc0200ce8 <exception_handler+0x4c>
        cprintf("Illegal instruction\n");
ffffffffc0200d2e:	00005517          	auipc	a0,0x5
ffffffffc0200d32:	24250513          	addi	a0,a0,578 # ffffffffc0205f70 <commands+0x638>
ffffffffc0200d36:	bf4d                	j	ffffffffc0200ce8 <exception_handler+0x4c>
        cprintf("Breakpoint\n");
ffffffffc0200d38:	00005517          	auipc	a0,0x5
ffffffffc0200d3c:	25050513          	addi	a0,a0,592 # ffffffffc0205f88 <commands+0x650>
ffffffffc0200d40:	ba0ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
        if (tf->gpr.a7 == 10)
ffffffffc0200d44:	6458                	ld	a4,136(s0)
ffffffffc0200d46:	47a9                	li	a5,10
ffffffffc0200d48:	04f70663          	beq	a4,a5,ffffffffc0200d94 <exception_handler+0xf8>
}
ffffffffc0200d4c:	60a2                	ld	ra,8(sp)
ffffffffc0200d4e:	6402                	ld	s0,0(sp)
ffffffffc0200d50:	0141                	addi	sp,sp,16
ffffffffc0200d52:	8082                	ret
        cprintf("Load address misaligned\n");
ffffffffc0200d54:	00005517          	auipc	a0,0x5
ffffffffc0200d58:	24450513          	addi	a0,a0,580 # ffffffffc0205f98 <commands+0x660>
ffffffffc0200d5c:	b771                	j	ffffffffc0200ce8 <exception_handler+0x4c>
        cprintf("Load access fault\n");
ffffffffc0200d5e:	00005517          	auipc	a0,0x5
ffffffffc0200d62:	25a50513          	addi	a0,a0,602 # ffffffffc0205fb8 <commands+0x680>
ffffffffc0200d66:	b749                	j	ffffffffc0200ce8 <exception_handler+0x4c>
        cprintf("Store/AMO access fault\n");
ffffffffc0200d68:	00005517          	auipc	a0,0x5
ffffffffc0200d6c:	29850513          	addi	a0,a0,664 # ffffffffc0206000 <commands+0x6c8>
ffffffffc0200d70:	bfa5                	j	ffffffffc0200ce8 <exception_handler+0x4c>
        print_trapframe(tf);
ffffffffc0200d72:	8522                	mv	a0,s0
}
ffffffffc0200d74:	6402                	ld	s0,0(sp)
ffffffffc0200d76:	60a2                	ld	ra,8(sp)
ffffffffc0200d78:	0141                	addi	sp,sp,16
        print_trapframe(tf);
ffffffffc0200d7a:	b53d                	j	ffffffffc0200ba8 <print_trapframe>
        panic("AMO address misaligned\n");
ffffffffc0200d7c:	00005617          	auipc	a2,0x5
ffffffffc0200d80:	25460613          	addi	a2,a2,596 # ffffffffc0205fd0 <commands+0x698>
ffffffffc0200d84:	0bd00593          	li	a1,189
ffffffffc0200d88:	00005517          	auipc	a0,0x5
ffffffffc0200d8c:	26050513          	addi	a0,a0,608 # ffffffffc0205fe8 <commands+0x6b0>
ffffffffc0200d90:	c8eff0ef          	jal	ra,ffffffffc020021e <__panic>
            tf->epc += 4;
ffffffffc0200d94:	10843783          	ld	a5,264(s0)
ffffffffc0200d98:	0791                	addi	a5,a5,4
ffffffffc0200d9a:	10f43423          	sd	a5,264(s0)
            syscall();
ffffffffc0200d9e:	39c040ef          	jal	ra,ffffffffc020513a <syscall>
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200da2:	000aa797          	auipc	a5,0xaa
ffffffffc0200da6:	99e7b783          	ld	a5,-1634(a5) # ffffffffc02aa740 <current>
ffffffffc0200daa:	6b9c                	ld	a5,16(a5)
ffffffffc0200dac:	8522                	mv	a0,s0
}
ffffffffc0200dae:	6402                	ld	s0,0(sp)
ffffffffc0200db0:	60a2                	ld	ra,8(sp)
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200db2:	6589                	lui	a1,0x2
ffffffffc0200db4:	95be                	add	a1,a1,a5
}
ffffffffc0200db6:	0141                	addi	sp,sp,16
            kernel_execve_ret(tf, current->kstack + KSTACKSIZE);
ffffffffc0200db8:	aaa9                	j	ffffffffc0200f12 <kernel_execve_ret>

ffffffffc0200dba <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe *tf)
{
ffffffffc0200dba:	1101                	addi	sp,sp,-32
ffffffffc0200dbc:	e822                	sd	s0,16(sp)
    // dispatch based on what type of trap occurred
    //    cputs("some trap");
    if (current == NULL)
ffffffffc0200dbe:	000aa417          	auipc	s0,0xaa
ffffffffc0200dc2:	98240413          	addi	s0,s0,-1662 # ffffffffc02aa740 <current>
ffffffffc0200dc6:	6018                	ld	a4,0(s0)
{
ffffffffc0200dc8:	ec06                	sd	ra,24(sp)
ffffffffc0200dca:	e426                	sd	s1,8(sp)
ffffffffc0200dcc:	e04a                	sd	s2,0(sp)
    if ((intptr_t)tf->cause < 0)
ffffffffc0200dce:	11853683          	ld	a3,280(a0)
    if (current == NULL)
ffffffffc0200dd2:	cf1d                	beqz	a4,ffffffffc0200e10 <trap+0x56>
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200dd4:	10053483          	ld	s1,256(a0)
    {
        trap_dispatch(tf);
    }
    else
    {
        struct trapframe *otf = current->tf;
ffffffffc0200dd8:	0a073903          	ld	s2,160(a4)
        current->tf = tf;
ffffffffc0200ddc:	f348                	sd	a0,160(a4)
    return (tf->status & SSTATUS_SPP) != 0;
ffffffffc0200dde:	1004f493          	andi	s1,s1,256
    if ((intptr_t)tf->cause < 0)
ffffffffc0200de2:	0206c463          	bltz	a3,ffffffffc0200e0a <trap+0x50>
        exception_handler(tf);
ffffffffc0200de6:	eb7ff0ef          	jal	ra,ffffffffc0200c9c <exception_handler>

        bool in_kernel = trap_in_kernel(tf);

        trap_dispatch(tf);

        current->tf = otf;
ffffffffc0200dea:	601c                	ld	a5,0(s0)
ffffffffc0200dec:	0b27b023          	sd	s2,160(a5)
        if (!in_kernel)
ffffffffc0200df0:	e499                	bnez	s1,ffffffffc0200dfe <trap+0x44>
        {
            if (current->flags & PF_EXITING)
ffffffffc0200df2:	0b07a703          	lw	a4,176(a5)
ffffffffc0200df6:	8b05                	andi	a4,a4,1
ffffffffc0200df8:	e329                	bnez	a4,ffffffffc0200e3a <trap+0x80>
            {
                do_exit(-E_KILLED);
            }
            if (current->need_resched)
ffffffffc0200dfa:	6f9c                	ld	a5,24(a5)
ffffffffc0200dfc:	eb85                	bnez	a5,ffffffffc0200e2c <trap+0x72>
            {
                schedule();
            }
        }
    }
}
ffffffffc0200dfe:	60e2                	ld	ra,24(sp)
ffffffffc0200e00:	6442                	ld	s0,16(sp)
ffffffffc0200e02:	64a2                	ld	s1,8(sp)
ffffffffc0200e04:	6902                	ld	s2,0(sp)
ffffffffc0200e06:	6105                	addi	sp,sp,32
ffffffffc0200e08:	8082                	ret
        interrupt_handler(tf);
ffffffffc0200e0a:	e01ff0ef          	jal	ra,ffffffffc0200c0a <interrupt_handler>
ffffffffc0200e0e:	bff1                	j	ffffffffc0200dea <trap+0x30>
    if ((intptr_t)tf->cause < 0)
ffffffffc0200e10:	0006c863          	bltz	a3,ffffffffc0200e20 <trap+0x66>
}
ffffffffc0200e14:	6442                	ld	s0,16(sp)
ffffffffc0200e16:	60e2                	ld	ra,24(sp)
ffffffffc0200e18:	64a2                	ld	s1,8(sp)
ffffffffc0200e1a:	6902                	ld	s2,0(sp)
ffffffffc0200e1c:	6105                	addi	sp,sp,32
        exception_handler(tf);
ffffffffc0200e1e:	bdbd                	j	ffffffffc0200c9c <exception_handler>
}
ffffffffc0200e20:	6442                	ld	s0,16(sp)
ffffffffc0200e22:	60e2                	ld	ra,24(sp)
ffffffffc0200e24:	64a2                	ld	s1,8(sp)
ffffffffc0200e26:	6902                	ld	s2,0(sp)
ffffffffc0200e28:	6105                	addi	sp,sp,32
        interrupt_handler(tf);
ffffffffc0200e2a:	b3c5                	j	ffffffffc0200c0a <interrupt_handler>
}
ffffffffc0200e2c:	6442                	ld	s0,16(sp)
ffffffffc0200e2e:	60e2                	ld	ra,24(sp)
ffffffffc0200e30:	64a2                	ld	s1,8(sp)
ffffffffc0200e32:	6902                	ld	s2,0(sp)
ffffffffc0200e34:	6105                	addi	sp,sp,32
                schedule();
ffffffffc0200e36:	2180406f          	j	ffffffffc020504e <schedule>
                do_exit(-E_KILLED);
ffffffffc0200e3a:	555d                	li	a0,-9
ffffffffc0200e3c:	5c6030ef          	jal	ra,ffffffffc0204402 <do_exit>
            if (current->need_resched)
ffffffffc0200e40:	601c                	ld	a5,0(s0)
ffffffffc0200e42:	bf65                	j	ffffffffc0200dfa <trap+0x40>

ffffffffc0200e44 <__alltraps>:
    LOAD x2, 2*REGBYTES(sp)
    .endm

    .globl __alltraps
__alltraps:
    SAVE_ALL
ffffffffc0200e44:	14011173          	csrrw	sp,sscratch,sp
ffffffffc0200e48:	00011463          	bnez	sp,ffffffffc0200e50 <__alltraps+0xc>
ffffffffc0200e4c:	14002173          	csrr	sp,sscratch
ffffffffc0200e50:	712d                	addi	sp,sp,-288
ffffffffc0200e52:	e002                	sd	zero,0(sp)
ffffffffc0200e54:	e406                	sd	ra,8(sp)
ffffffffc0200e56:	ec0e                	sd	gp,24(sp)
ffffffffc0200e58:	f012                	sd	tp,32(sp)
ffffffffc0200e5a:	f416                	sd	t0,40(sp)
ffffffffc0200e5c:	f81a                	sd	t1,48(sp)
ffffffffc0200e5e:	fc1e                	sd	t2,56(sp)
ffffffffc0200e60:	e0a2                	sd	s0,64(sp)
ffffffffc0200e62:	e4a6                	sd	s1,72(sp)
ffffffffc0200e64:	e8aa                	sd	a0,80(sp)
ffffffffc0200e66:	ecae                	sd	a1,88(sp)
ffffffffc0200e68:	f0b2                	sd	a2,96(sp)
ffffffffc0200e6a:	f4b6                	sd	a3,104(sp)
ffffffffc0200e6c:	f8ba                	sd	a4,112(sp)
ffffffffc0200e6e:	fcbe                	sd	a5,120(sp)
ffffffffc0200e70:	e142                	sd	a6,128(sp)
ffffffffc0200e72:	e546                	sd	a7,136(sp)
ffffffffc0200e74:	e94a                	sd	s2,144(sp)
ffffffffc0200e76:	ed4e                	sd	s3,152(sp)
ffffffffc0200e78:	f152                	sd	s4,160(sp)
ffffffffc0200e7a:	f556                	sd	s5,168(sp)
ffffffffc0200e7c:	f95a                	sd	s6,176(sp)
ffffffffc0200e7e:	fd5e                	sd	s7,184(sp)
ffffffffc0200e80:	e1e2                	sd	s8,192(sp)
ffffffffc0200e82:	e5e6                	sd	s9,200(sp)
ffffffffc0200e84:	e9ea                	sd	s10,208(sp)
ffffffffc0200e86:	edee                	sd	s11,216(sp)
ffffffffc0200e88:	f1f2                	sd	t3,224(sp)
ffffffffc0200e8a:	f5f6                	sd	t4,232(sp)
ffffffffc0200e8c:	f9fa                	sd	t5,240(sp)
ffffffffc0200e8e:	fdfe                	sd	t6,248(sp)
ffffffffc0200e90:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0200e94:	100024f3          	csrr	s1,sstatus
ffffffffc0200e98:	14102973          	csrr	s2,sepc
ffffffffc0200e9c:	143029f3          	csrr	s3,stval
ffffffffc0200ea0:	14202a73          	csrr	s4,scause
ffffffffc0200ea4:	e822                	sd	s0,16(sp)
ffffffffc0200ea6:	e226                	sd	s1,256(sp)
ffffffffc0200ea8:	e64a                	sd	s2,264(sp)
ffffffffc0200eaa:	ea4e                	sd	s3,272(sp)
ffffffffc0200eac:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc0200eae:	850a                	mv	a0,sp
    jal trap
ffffffffc0200eb0:	f0bff0ef          	jal	ra,ffffffffc0200dba <trap>

ffffffffc0200eb4 <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0200eb4:	6492                	ld	s1,256(sp)
ffffffffc0200eb6:	6932                	ld	s2,264(sp)
ffffffffc0200eb8:	1004f413          	andi	s0,s1,256
ffffffffc0200ebc:	e401                	bnez	s0,ffffffffc0200ec4 <__trapret+0x10>
ffffffffc0200ebe:	1200                	addi	s0,sp,288
ffffffffc0200ec0:	14041073          	csrw	sscratch,s0
ffffffffc0200ec4:	10049073          	csrw	sstatus,s1
ffffffffc0200ec8:	14191073          	csrw	sepc,s2
ffffffffc0200ecc:	60a2                	ld	ra,8(sp)
ffffffffc0200ece:	61e2                	ld	gp,24(sp)
ffffffffc0200ed0:	7202                	ld	tp,32(sp)
ffffffffc0200ed2:	72a2                	ld	t0,40(sp)
ffffffffc0200ed4:	7342                	ld	t1,48(sp)
ffffffffc0200ed6:	73e2                	ld	t2,56(sp)
ffffffffc0200ed8:	6406                	ld	s0,64(sp)
ffffffffc0200eda:	64a6                	ld	s1,72(sp)
ffffffffc0200edc:	6546                	ld	a0,80(sp)
ffffffffc0200ede:	65e6                	ld	a1,88(sp)
ffffffffc0200ee0:	7606                	ld	a2,96(sp)
ffffffffc0200ee2:	76a6                	ld	a3,104(sp)
ffffffffc0200ee4:	7746                	ld	a4,112(sp)
ffffffffc0200ee6:	77e6                	ld	a5,120(sp)
ffffffffc0200ee8:	680a                	ld	a6,128(sp)
ffffffffc0200eea:	68aa                	ld	a7,136(sp)
ffffffffc0200eec:	694a                	ld	s2,144(sp)
ffffffffc0200eee:	69ea                	ld	s3,152(sp)
ffffffffc0200ef0:	7a0a                	ld	s4,160(sp)
ffffffffc0200ef2:	7aaa                	ld	s5,168(sp)
ffffffffc0200ef4:	7b4a                	ld	s6,176(sp)
ffffffffc0200ef6:	7bea                	ld	s7,184(sp)
ffffffffc0200ef8:	6c0e                	ld	s8,192(sp)
ffffffffc0200efa:	6cae                	ld	s9,200(sp)
ffffffffc0200efc:	6d4e                	ld	s10,208(sp)
ffffffffc0200efe:	6dee                	ld	s11,216(sp)
ffffffffc0200f00:	7e0e                	ld	t3,224(sp)
ffffffffc0200f02:	7eae                	ld	t4,232(sp)
ffffffffc0200f04:	7f4e                	ld	t5,240(sp)
ffffffffc0200f06:	7fee                	ld	t6,248(sp)
ffffffffc0200f08:	6142                	ld	sp,16(sp)
    # return from supervisor call
    sret
ffffffffc0200f0a:	10200073          	sret

ffffffffc0200f0e <forkrets>:
 
    .globl forkrets
forkrets:
    # set stack to this new process's trapframe
    move sp, a0
ffffffffc0200f0e:	812a                	mv	sp,a0
    j __trapret
ffffffffc0200f10:	b755                	j	ffffffffc0200eb4 <__trapret>

ffffffffc0200f12 <kernel_execve_ret>:

    .global kernel_execve_ret
kernel_execve_ret:
    // adjust sp to beneath kstacktop of current process
    addi a1, a1, -36*REGBYTES
ffffffffc0200f12:	ee058593          	addi	a1,a1,-288 # 1ee0 <_binary_obj___user_faultread_out_size-0x7cd0>

    // copy from previous trapframe to new trapframe
    LOAD s1, 35*REGBYTES(a0)
ffffffffc0200f16:	11853483          	ld	s1,280(a0)
    STORE s1, 35*REGBYTES(a1)
ffffffffc0200f1a:	1095bc23          	sd	s1,280(a1)
    LOAD s1, 34*REGBYTES(a0)
ffffffffc0200f1e:	11053483          	ld	s1,272(a0)
    STORE s1, 34*REGBYTES(a1)
ffffffffc0200f22:	1095b823          	sd	s1,272(a1)
    LOAD s1, 33*REGBYTES(a0)
ffffffffc0200f26:	10853483          	ld	s1,264(a0)
    STORE s1, 33*REGBYTES(a1)
ffffffffc0200f2a:	1095b423          	sd	s1,264(a1)
    LOAD s1, 32*REGBYTES(a0)
ffffffffc0200f2e:	10053483          	ld	s1,256(a0)
    STORE s1, 32*REGBYTES(a1)
ffffffffc0200f32:	1095b023          	sd	s1,256(a1)
    LOAD s1, 31*REGBYTES(a0)
ffffffffc0200f36:	7d64                	ld	s1,248(a0)
    STORE s1, 31*REGBYTES(a1)
ffffffffc0200f38:	fde4                	sd	s1,248(a1)
    LOAD s1, 30*REGBYTES(a0)
ffffffffc0200f3a:	7964                	ld	s1,240(a0)
    STORE s1, 30*REGBYTES(a1)
ffffffffc0200f3c:	f9e4                	sd	s1,240(a1)
    LOAD s1, 29*REGBYTES(a0)
ffffffffc0200f3e:	7564                	ld	s1,232(a0)
    STORE s1, 29*REGBYTES(a1)
ffffffffc0200f40:	f5e4                	sd	s1,232(a1)
    LOAD s1, 28*REGBYTES(a0)
ffffffffc0200f42:	7164                	ld	s1,224(a0)
    STORE s1, 28*REGBYTES(a1)
ffffffffc0200f44:	f1e4                	sd	s1,224(a1)
    LOAD s1, 27*REGBYTES(a0)
ffffffffc0200f46:	6d64                	ld	s1,216(a0)
    STORE s1, 27*REGBYTES(a1)
ffffffffc0200f48:	ede4                	sd	s1,216(a1)
    LOAD s1, 26*REGBYTES(a0)
ffffffffc0200f4a:	6964                	ld	s1,208(a0)
    STORE s1, 26*REGBYTES(a1)
ffffffffc0200f4c:	e9e4                	sd	s1,208(a1)
    LOAD s1, 25*REGBYTES(a0)
ffffffffc0200f4e:	6564                	ld	s1,200(a0)
    STORE s1, 25*REGBYTES(a1)
ffffffffc0200f50:	e5e4                	sd	s1,200(a1)
    LOAD s1, 24*REGBYTES(a0)
ffffffffc0200f52:	6164                	ld	s1,192(a0)
    STORE s1, 24*REGBYTES(a1)
ffffffffc0200f54:	e1e4                	sd	s1,192(a1)
    LOAD s1, 23*REGBYTES(a0)
ffffffffc0200f56:	7d44                	ld	s1,184(a0)
    STORE s1, 23*REGBYTES(a1)
ffffffffc0200f58:	fdc4                	sd	s1,184(a1)
    LOAD s1, 22*REGBYTES(a0)
ffffffffc0200f5a:	7944                	ld	s1,176(a0)
    STORE s1, 22*REGBYTES(a1)
ffffffffc0200f5c:	f9c4                	sd	s1,176(a1)
    LOAD s1, 21*REGBYTES(a0)
ffffffffc0200f5e:	7544                	ld	s1,168(a0)
    STORE s1, 21*REGBYTES(a1)
ffffffffc0200f60:	f5c4                	sd	s1,168(a1)
    LOAD s1, 20*REGBYTES(a0)
ffffffffc0200f62:	7144                	ld	s1,160(a0)
    STORE s1, 20*REGBYTES(a1)
ffffffffc0200f64:	f1c4                	sd	s1,160(a1)
    LOAD s1, 19*REGBYTES(a0)
ffffffffc0200f66:	6d44                	ld	s1,152(a0)
    STORE s1, 19*REGBYTES(a1)
ffffffffc0200f68:	edc4                	sd	s1,152(a1)
    LOAD s1, 18*REGBYTES(a0)
ffffffffc0200f6a:	6944                	ld	s1,144(a0)
    STORE s1, 18*REGBYTES(a1)
ffffffffc0200f6c:	e9c4                	sd	s1,144(a1)
    LOAD s1, 17*REGBYTES(a0)
ffffffffc0200f6e:	6544                	ld	s1,136(a0)
    STORE s1, 17*REGBYTES(a1)
ffffffffc0200f70:	e5c4                	sd	s1,136(a1)
    LOAD s1, 16*REGBYTES(a0)
ffffffffc0200f72:	6144                	ld	s1,128(a0)
    STORE s1, 16*REGBYTES(a1)
ffffffffc0200f74:	e1c4                	sd	s1,128(a1)
    LOAD s1, 15*REGBYTES(a0)
ffffffffc0200f76:	7d24                	ld	s1,120(a0)
    STORE s1, 15*REGBYTES(a1)
ffffffffc0200f78:	fda4                	sd	s1,120(a1)
    LOAD s1, 14*REGBYTES(a0)
ffffffffc0200f7a:	7924                	ld	s1,112(a0)
    STORE s1, 14*REGBYTES(a1)
ffffffffc0200f7c:	f9a4                	sd	s1,112(a1)
    LOAD s1, 13*REGBYTES(a0)
ffffffffc0200f7e:	7524                	ld	s1,104(a0)
    STORE s1, 13*REGBYTES(a1)
ffffffffc0200f80:	f5a4                	sd	s1,104(a1)
    LOAD s1, 12*REGBYTES(a0)
ffffffffc0200f82:	7124                	ld	s1,96(a0)
    STORE s1, 12*REGBYTES(a1)
ffffffffc0200f84:	f1a4                	sd	s1,96(a1)
    LOAD s1, 11*REGBYTES(a0)
ffffffffc0200f86:	6d24                	ld	s1,88(a0)
    STORE s1, 11*REGBYTES(a1)
ffffffffc0200f88:	eda4                	sd	s1,88(a1)
    LOAD s1, 10*REGBYTES(a0)
ffffffffc0200f8a:	6924                	ld	s1,80(a0)
    STORE s1, 10*REGBYTES(a1)
ffffffffc0200f8c:	e9a4                	sd	s1,80(a1)
    LOAD s1, 9*REGBYTES(a0)
ffffffffc0200f8e:	6524                	ld	s1,72(a0)
    STORE s1, 9*REGBYTES(a1)
ffffffffc0200f90:	e5a4                	sd	s1,72(a1)
    LOAD s1, 8*REGBYTES(a0)
ffffffffc0200f92:	6124                	ld	s1,64(a0)
    STORE s1, 8*REGBYTES(a1)
ffffffffc0200f94:	e1a4                	sd	s1,64(a1)
    LOAD s1, 7*REGBYTES(a0)
ffffffffc0200f96:	7d04                	ld	s1,56(a0)
    STORE s1, 7*REGBYTES(a1)
ffffffffc0200f98:	fd84                	sd	s1,56(a1)
    LOAD s1, 6*REGBYTES(a0)
ffffffffc0200f9a:	7904                	ld	s1,48(a0)
    STORE s1, 6*REGBYTES(a1)
ffffffffc0200f9c:	f984                	sd	s1,48(a1)
    LOAD s1, 5*REGBYTES(a0)
ffffffffc0200f9e:	7504                	ld	s1,40(a0)
    STORE s1, 5*REGBYTES(a1)
ffffffffc0200fa0:	f584                	sd	s1,40(a1)
    LOAD s1, 4*REGBYTES(a0)
ffffffffc0200fa2:	7104                	ld	s1,32(a0)
    STORE s1, 4*REGBYTES(a1)
ffffffffc0200fa4:	f184                	sd	s1,32(a1)
    LOAD s1, 3*REGBYTES(a0)
ffffffffc0200fa6:	6d04                	ld	s1,24(a0)
    STORE s1, 3*REGBYTES(a1)
ffffffffc0200fa8:	ed84                	sd	s1,24(a1)
    LOAD s1, 2*REGBYTES(a0)
ffffffffc0200faa:	6904                	ld	s1,16(a0)
    STORE s1, 2*REGBYTES(a1)
ffffffffc0200fac:	e984                	sd	s1,16(a1)
    LOAD s1, 1*REGBYTES(a0)
ffffffffc0200fae:	6504                	ld	s1,8(a0)
    STORE s1, 1*REGBYTES(a1)
ffffffffc0200fb0:	e584                	sd	s1,8(a1)
    LOAD s1, 0*REGBYTES(a0)
ffffffffc0200fb2:	6104                	ld	s1,0(a0)
    STORE s1, 0*REGBYTES(a1)
ffffffffc0200fb4:	e184                	sd	s1,0(a1)

    // acutually adjust sp
    move sp, a1
ffffffffc0200fb6:	812e                	mv	sp,a1
ffffffffc0200fb8:	bdf5                	j	ffffffffc0200eb4 <__trapret>

ffffffffc0200fba <pa2page.part.0>:
{
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa)
ffffffffc0200fba:	1141                	addi	sp,sp,-16
{
    if (PPN(pa) >= npage)
    {
        panic("pa2page called with invalid pa");
ffffffffc0200fbc:	00005617          	auipc	a2,0x5
ffffffffc0200fc0:	14460613          	addi	a2,a2,324 # ffffffffc0206100 <commands+0x7c8>
ffffffffc0200fc4:	06900593          	li	a1,105
ffffffffc0200fc8:	00005517          	auipc	a0,0x5
ffffffffc0200fcc:	15850513          	addi	a0,a0,344 # ffffffffc0206120 <commands+0x7e8>
pa2page(uintptr_t pa)
ffffffffc0200fd0:	e406                	sd	ra,8(sp)
        panic("pa2page called with invalid pa");
ffffffffc0200fd2:	a4cff0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc0200fd6 <pte2page.part.0>:
{
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte)
ffffffffc0200fd6:	1141                	addi	sp,sp,-16
{
    if (!(pte & PTE_V))
    {
        panic("pte2page called with invalid pte");
ffffffffc0200fd8:	00005617          	auipc	a2,0x5
ffffffffc0200fdc:	15860613          	addi	a2,a2,344 # ffffffffc0206130 <commands+0x7f8>
ffffffffc0200fe0:	07f00593          	li	a1,127
ffffffffc0200fe4:	00005517          	auipc	a0,0x5
ffffffffc0200fe8:	13c50513          	addi	a0,a0,316 # ffffffffc0206120 <commands+0x7e8>
pte2page(pte_t pte)
ffffffffc0200fec:	e406                	sd	ra,8(sp)
        panic("pte2page called with invalid pte");
ffffffffc0200fee:	a30ff0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc0200ff2 <alloc_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0200ff2:	100027f3          	csrr	a5,sstatus
ffffffffc0200ff6:	8b89                	andi	a5,a5,2
ffffffffc0200ff8:	e799                	bnez	a5,ffffffffc0201006 <alloc_pages+0x14>
{
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
ffffffffc0200ffa:	000a9797          	auipc	a5,0xa9
ffffffffc0200ffe:	72e7b783          	ld	a5,1838(a5) # ffffffffc02aa728 <pmm_manager>
ffffffffc0201002:	6f9c                	ld	a5,24(a5)
ffffffffc0201004:	8782                	jr	a5
{
ffffffffc0201006:	1141                	addi	sp,sp,-16
ffffffffc0201008:	e406                	sd	ra,8(sp)
ffffffffc020100a:	e022                	sd	s0,0(sp)
ffffffffc020100c:	842a                	mv	s0,a0
        intr_disable();
ffffffffc020100e:	9adff0ef          	jal	ra,ffffffffc02009ba <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201012:	000a9797          	auipc	a5,0xa9
ffffffffc0201016:	7167b783          	ld	a5,1814(a5) # ffffffffc02aa728 <pmm_manager>
ffffffffc020101a:	6f9c                	ld	a5,24(a5)
ffffffffc020101c:	8522                	mv	a0,s0
ffffffffc020101e:	9782                	jalr	a5
ffffffffc0201020:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0201022:	993ff0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
    }
    local_intr_restore(intr_flag);
    return page;
}
ffffffffc0201026:	60a2                	ld	ra,8(sp)
ffffffffc0201028:	8522                	mv	a0,s0
ffffffffc020102a:	6402                	ld	s0,0(sp)
ffffffffc020102c:	0141                	addi	sp,sp,16
ffffffffc020102e:	8082                	ret

ffffffffc0201030 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201030:	100027f3          	csrr	a5,sstatus
ffffffffc0201034:	8b89                	andi	a5,a5,2
ffffffffc0201036:	e799                	bnez	a5,ffffffffc0201044 <free_pages+0x14>
void free_pages(struct Page *base, size_t n)
{
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc0201038:	000a9797          	auipc	a5,0xa9
ffffffffc020103c:	6f07b783          	ld	a5,1776(a5) # ffffffffc02aa728 <pmm_manager>
ffffffffc0201040:	739c                	ld	a5,32(a5)
ffffffffc0201042:	8782                	jr	a5
{
ffffffffc0201044:	1101                	addi	sp,sp,-32
ffffffffc0201046:	ec06                	sd	ra,24(sp)
ffffffffc0201048:	e822                	sd	s0,16(sp)
ffffffffc020104a:	e426                	sd	s1,8(sp)
ffffffffc020104c:	842a                	mv	s0,a0
ffffffffc020104e:	84ae                	mv	s1,a1
        intr_disable();
ffffffffc0201050:	96bff0ef          	jal	ra,ffffffffc02009ba <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0201054:	000a9797          	auipc	a5,0xa9
ffffffffc0201058:	6d47b783          	ld	a5,1748(a5) # ffffffffc02aa728 <pmm_manager>
ffffffffc020105c:	739c                	ld	a5,32(a5)
ffffffffc020105e:	85a6                	mv	a1,s1
ffffffffc0201060:	8522                	mv	a0,s0
ffffffffc0201062:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc0201064:	6442                	ld	s0,16(sp)
ffffffffc0201066:	60e2                	ld	ra,24(sp)
ffffffffc0201068:	64a2                	ld	s1,8(sp)
ffffffffc020106a:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc020106c:	949ff06f          	j	ffffffffc02009b4 <intr_enable>

ffffffffc0201070 <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201070:	100027f3          	csrr	a5,sstatus
ffffffffc0201074:	8b89                	andi	a5,a5,2
ffffffffc0201076:	e799                	bnez	a5,ffffffffc0201084 <nr_free_pages+0x14>
{
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc0201078:	000a9797          	auipc	a5,0xa9
ffffffffc020107c:	6b07b783          	ld	a5,1712(a5) # ffffffffc02aa728 <pmm_manager>
ffffffffc0201080:	779c                	ld	a5,40(a5)
ffffffffc0201082:	8782                	jr	a5
{
ffffffffc0201084:	1141                	addi	sp,sp,-16
ffffffffc0201086:	e406                	sd	ra,8(sp)
ffffffffc0201088:	e022                	sd	s0,0(sp)
        intr_disable();
ffffffffc020108a:	931ff0ef          	jal	ra,ffffffffc02009ba <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc020108e:	000a9797          	auipc	a5,0xa9
ffffffffc0201092:	69a7b783          	ld	a5,1690(a5) # ffffffffc02aa728 <pmm_manager>
ffffffffc0201096:	779c                	ld	a5,40(a5)
ffffffffc0201098:	9782                	jalr	a5
ffffffffc020109a:	842a                	mv	s0,a0
        intr_enable();
ffffffffc020109c:	919ff0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
    }
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc02010a0:	60a2                	ld	ra,8(sp)
ffffffffc02010a2:	8522                	mv	a0,s0
ffffffffc02010a4:	6402                	ld	s0,0(sp)
ffffffffc02010a6:	0141                	addi	sp,sp,16
ffffffffc02010a8:	8082                	ret

ffffffffc02010aa <get_pte>:
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create)
{
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc02010aa:	01e5d793          	srli	a5,a1,0x1e
ffffffffc02010ae:	1ff7f793          	andi	a5,a5,511
{
ffffffffc02010b2:	7139                	addi	sp,sp,-64
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc02010b4:	078e                	slli	a5,a5,0x3
{
ffffffffc02010b6:	f426                	sd	s1,40(sp)
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc02010b8:	00f504b3          	add	s1,a0,a5
    if (!(*pdep1 & PTE_V))
ffffffffc02010bc:	6094                	ld	a3,0(s1)
{
ffffffffc02010be:	f04a                	sd	s2,32(sp)
ffffffffc02010c0:	ec4e                	sd	s3,24(sp)
ffffffffc02010c2:	e852                	sd	s4,16(sp)
ffffffffc02010c4:	fc06                	sd	ra,56(sp)
ffffffffc02010c6:	f822                	sd	s0,48(sp)
ffffffffc02010c8:	e456                	sd	s5,8(sp)
ffffffffc02010ca:	e05a                	sd	s6,0(sp)
    if (!(*pdep1 & PTE_V))
ffffffffc02010cc:	0016f793          	andi	a5,a3,1
{
ffffffffc02010d0:	892e                	mv	s2,a1
ffffffffc02010d2:	8a32                	mv	s4,a2
ffffffffc02010d4:	000a9997          	auipc	s3,0xa9
ffffffffc02010d8:	64498993          	addi	s3,s3,1604 # ffffffffc02aa718 <npage>
    if (!(*pdep1 & PTE_V))
ffffffffc02010dc:	efbd                	bnez	a5,ffffffffc020115a <get_pte+0xb0>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc02010de:	14060c63          	beqz	a2,ffffffffc0201236 <get_pte+0x18c>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02010e2:	100027f3          	csrr	a5,sstatus
ffffffffc02010e6:	8b89                	andi	a5,a5,2
ffffffffc02010e8:	14079963          	bnez	a5,ffffffffc020123a <get_pte+0x190>
        page = pmm_manager->alloc_pages(n);
ffffffffc02010ec:	000a9797          	auipc	a5,0xa9
ffffffffc02010f0:	63c7b783          	ld	a5,1596(a5) # ffffffffc02aa728 <pmm_manager>
ffffffffc02010f4:	6f9c                	ld	a5,24(a5)
ffffffffc02010f6:	4505                	li	a0,1
ffffffffc02010f8:	9782                	jalr	a5
ffffffffc02010fa:	842a                	mv	s0,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc02010fc:	12040d63          	beqz	s0,ffffffffc0201236 <get_pte+0x18c>
    return page - pages + nbase;
ffffffffc0201100:	000a9b17          	auipc	s6,0xa9
ffffffffc0201104:	620b0b13          	addi	s6,s6,1568 # ffffffffc02aa720 <pages>
ffffffffc0201108:	000b3503          	ld	a0,0(s6)
ffffffffc020110c:	00080ab7          	lui	s5,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0201110:	000a9997          	auipc	s3,0xa9
ffffffffc0201114:	60898993          	addi	s3,s3,1544 # ffffffffc02aa718 <npage>
ffffffffc0201118:	40a40533          	sub	a0,s0,a0
ffffffffc020111c:	8519                	srai	a0,a0,0x6
ffffffffc020111e:	9556                	add	a0,a0,s5
ffffffffc0201120:	0009b703          	ld	a4,0(s3)
ffffffffc0201124:	00c51793          	slli	a5,a0,0xc
}

static inline void
set_page_ref(struct Page *page, int val)
{
    page->ref = val;
ffffffffc0201128:	4685                	li	a3,1
ffffffffc020112a:	c014                	sw	a3,0(s0)
ffffffffc020112c:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc020112e:	0532                	slli	a0,a0,0xc
ffffffffc0201130:	16e7f763          	bgeu	a5,a4,ffffffffc020129e <get_pte+0x1f4>
ffffffffc0201134:	000a9797          	auipc	a5,0xa9
ffffffffc0201138:	5fc7b783          	ld	a5,1532(a5) # ffffffffc02aa730 <va_pa_offset>
ffffffffc020113c:	6605                	lui	a2,0x1
ffffffffc020113e:	4581                	li	a1,0
ffffffffc0201140:	953e                	add	a0,a0,a5
ffffffffc0201142:	11a040ef          	jal	ra,ffffffffc020525c <memset>
    return page - pages + nbase;
ffffffffc0201146:	000b3683          	ld	a3,0(s6)
ffffffffc020114a:	40d406b3          	sub	a3,s0,a3
ffffffffc020114e:	8699                	srai	a3,a3,0x6
ffffffffc0201150:	96d6                	add	a3,a3,s5
}

// construct PTE from a page and permission bits
static inline pte_t pte_create(uintptr_t ppn, int type)
{
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0201152:	06aa                	slli	a3,a3,0xa
ffffffffc0201154:	0116e693          	ori	a3,a3,17
        *pdep1 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0201158:	e094                	sd	a3,0(s1)
    }

    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc020115a:	77fd                	lui	a5,0xfffff
ffffffffc020115c:	068a                	slli	a3,a3,0x2
ffffffffc020115e:	0009b703          	ld	a4,0(s3)
ffffffffc0201162:	8efd                	and	a3,a3,a5
ffffffffc0201164:	00c6d793          	srli	a5,a3,0xc
ffffffffc0201168:	10e7ff63          	bgeu	a5,a4,ffffffffc0201286 <get_pte+0x1dc>
ffffffffc020116c:	000a9a97          	auipc	s5,0xa9
ffffffffc0201170:	5c4a8a93          	addi	s5,s5,1476 # ffffffffc02aa730 <va_pa_offset>
ffffffffc0201174:	000ab403          	ld	s0,0(s5)
ffffffffc0201178:	01595793          	srli	a5,s2,0x15
ffffffffc020117c:	1ff7f793          	andi	a5,a5,511
ffffffffc0201180:	96a2                	add	a3,a3,s0
ffffffffc0201182:	00379413          	slli	s0,a5,0x3
ffffffffc0201186:	9436                	add	s0,s0,a3
    if (!(*pdep0 & PTE_V))
ffffffffc0201188:	6014                	ld	a3,0(s0)
ffffffffc020118a:	0016f793          	andi	a5,a3,1
ffffffffc020118e:	ebad                	bnez	a5,ffffffffc0201200 <get_pte+0x156>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0201190:	0a0a0363          	beqz	s4,ffffffffc0201236 <get_pte+0x18c>
ffffffffc0201194:	100027f3          	csrr	a5,sstatus
ffffffffc0201198:	8b89                	andi	a5,a5,2
ffffffffc020119a:	efcd                	bnez	a5,ffffffffc0201254 <get_pte+0x1aa>
        page = pmm_manager->alloc_pages(n);
ffffffffc020119c:	000a9797          	auipc	a5,0xa9
ffffffffc02011a0:	58c7b783          	ld	a5,1420(a5) # ffffffffc02aa728 <pmm_manager>
ffffffffc02011a4:	6f9c                	ld	a5,24(a5)
ffffffffc02011a6:	4505                	li	a0,1
ffffffffc02011a8:	9782                	jalr	a5
ffffffffc02011aa:	84aa                	mv	s1,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc02011ac:	c4c9                	beqz	s1,ffffffffc0201236 <get_pte+0x18c>
    return page - pages + nbase;
ffffffffc02011ae:	000a9b17          	auipc	s6,0xa9
ffffffffc02011b2:	572b0b13          	addi	s6,s6,1394 # ffffffffc02aa720 <pages>
ffffffffc02011b6:	000b3503          	ld	a0,0(s6)
ffffffffc02011ba:	00080a37          	lui	s4,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc02011be:	0009b703          	ld	a4,0(s3)
ffffffffc02011c2:	40a48533          	sub	a0,s1,a0
ffffffffc02011c6:	8519                	srai	a0,a0,0x6
ffffffffc02011c8:	9552                	add	a0,a0,s4
ffffffffc02011ca:	00c51793          	slli	a5,a0,0xc
    page->ref = val;
ffffffffc02011ce:	4685                	li	a3,1
ffffffffc02011d0:	c094                	sw	a3,0(s1)
ffffffffc02011d2:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc02011d4:	0532                	slli	a0,a0,0xc
ffffffffc02011d6:	0ee7f163          	bgeu	a5,a4,ffffffffc02012b8 <get_pte+0x20e>
ffffffffc02011da:	000ab783          	ld	a5,0(s5)
ffffffffc02011de:	6605                	lui	a2,0x1
ffffffffc02011e0:	4581                	li	a1,0
ffffffffc02011e2:	953e                	add	a0,a0,a5
ffffffffc02011e4:	078040ef          	jal	ra,ffffffffc020525c <memset>
    return page - pages + nbase;
ffffffffc02011e8:	000b3683          	ld	a3,0(s6)
ffffffffc02011ec:	40d486b3          	sub	a3,s1,a3
ffffffffc02011f0:	8699                	srai	a3,a3,0x6
ffffffffc02011f2:	96d2                	add	a3,a3,s4
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc02011f4:	06aa                	slli	a3,a3,0xa
ffffffffc02011f6:	0116e693          	ori	a3,a3,17
        *pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc02011fa:	e014                	sd	a3,0(s0)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc02011fc:	0009b703          	ld	a4,0(s3)
ffffffffc0201200:	068a                	slli	a3,a3,0x2
ffffffffc0201202:	757d                	lui	a0,0xfffff
ffffffffc0201204:	8ee9                	and	a3,a3,a0
ffffffffc0201206:	00c6d793          	srli	a5,a3,0xc
ffffffffc020120a:	06e7f263          	bgeu	a5,a4,ffffffffc020126e <get_pte+0x1c4>
ffffffffc020120e:	000ab503          	ld	a0,0(s5)
ffffffffc0201212:	00c95913          	srli	s2,s2,0xc
ffffffffc0201216:	1ff97913          	andi	s2,s2,511
ffffffffc020121a:	96aa                	add	a3,a3,a0
ffffffffc020121c:	00391513          	slli	a0,s2,0x3
ffffffffc0201220:	9536                	add	a0,a0,a3
}
ffffffffc0201222:	70e2                	ld	ra,56(sp)
ffffffffc0201224:	7442                	ld	s0,48(sp)
ffffffffc0201226:	74a2                	ld	s1,40(sp)
ffffffffc0201228:	7902                	ld	s2,32(sp)
ffffffffc020122a:	69e2                	ld	s3,24(sp)
ffffffffc020122c:	6a42                	ld	s4,16(sp)
ffffffffc020122e:	6aa2                	ld	s5,8(sp)
ffffffffc0201230:	6b02                	ld	s6,0(sp)
ffffffffc0201232:	6121                	addi	sp,sp,64
ffffffffc0201234:	8082                	ret
            return NULL;
ffffffffc0201236:	4501                	li	a0,0
ffffffffc0201238:	b7ed                	j	ffffffffc0201222 <get_pte+0x178>
        intr_disable();
ffffffffc020123a:	f80ff0ef          	jal	ra,ffffffffc02009ba <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc020123e:	000a9797          	auipc	a5,0xa9
ffffffffc0201242:	4ea7b783          	ld	a5,1258(a5) # ffffffffc02aa728 <pmm_manager>
ffffffffc0201246:	6f9c                	ld	a5,24(a5)
ffffffffc0201248:	4505                	li	a0,1
ffffffffc020124a:	9782                	jalr	a5
ffffffffc020124c:	842a                	mv	s0,a0
        intr_enable();
ffffffffc020124e:	f66ff0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
ffffffffc0201252:	b56d                	j	ffffffffc02010fc <get_pte+0x52>
        intr_disable();
ffffffffc0201254:	f66ff0ef          	jal	ra,ffffffffc02009ba <intr_disable>
ffffffffc0201258:	000a9797          	auipc	a5,0xa9
ffffffffc020125c:	4d07b783          	ld	a5,1232(a5) # ffffffffc02aa728 <pmm_manager>
ffffffffc0201260:	6f9c                	ld	a5,24(a5)
ffffffffc0201262:	4505                	li	a0,1
ffffffffc0201264:	9782                	jalr	a5
ffffffffc0201266:	84aa                	mv	s1,a0
        intr_enable();
ffffffffc0201268:	f4cff0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
ffffffffc020126c:	b781                	j	ffffffffc02011ac <get_pte+0x102>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc020126e:	00005617          	auipc	a2,0x5
ffffffffc0201272:	eea60613          	addi	a2,a2,-278 # ffffffffc0206158 <commands+0x820>
ffffffffc0201276:	0fa00593          	li	a1,250
ffffffffc020127a:	00005517          	auipc	a0,0x5
ffffffffc020127e:	f0650513          	addi	a0,a0,-250 # ffffffffc0206180 <commands+0x848>
ffffffffc0201282:	f9dfe0ef          	jal	ra,ffffffffc020021e <__panic>
    pde_t *pdep0 = &((pde_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0201286:	00005617          	auipc	a2,0x5
ffffffffc020128a:	ed260613          	addi	a2,a2,-302 # ffffffffc0206158 <commands+0x820>
ffffffffc020128e:	0ed00593          	li	a1,237
ffffffffc0201292:	00005517          	auipc	a0,0x5
ffffffffc0201296:	eee50513          	addi	a0,a0,-274 # ffffffffc0206180 <commands+0x848>
ffffffffc020129a:	f85fe0ef          	jal	ra,ffffffffc020021e <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc020129e:	86aa                	mv	a3,a0
ffffffffc02012a0:	00005617          	auipc	a2,0x5
ffffffffc02012a4:	eb860613          	addi	a2,a2,-328 # ffffffffc0206158 <commands+0x820>
ffffffffc02012a8:	0e900593          	li	a1,233
ffffffffc02012ac:	00005517          	auipc	a0,0x5
ffffffffc02012b0:	ed450513          	addi	a0,a0,-300 # ffffffffc0206180 <commands+0x848>
ffffffffc02012b4:	f6bfe0ef          	jal	ra,ffffffffc020021e <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc02012b8:	86aa                	mv	a3,a0
ffffffffc02012ba:	00005617          	auipc	a2,0x5
ffffffffc02012be:	e9e60613          	addi	a2,a2,-354 # ffffffffc0206158 <commands+0x820>
ffffffffc02012c2:	0f700593          	li	a1,247
ffffffffc02012c6:	00005517          	auipc	a0,0x5
ffffffffc02012ca:	eba50513          	addi	a0,a0,-326 # ffffffffc0206180 <commands+0x848>
ffffffffc02012ce:	f51fe0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc02012d2 <get_page>:

// get_page - get related Page struct for linear address la using PDT pgdir
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store)
{
ffffffffc02012d2:	1141                	addi	sp,sp,-16
ffffffffc02012d4:	e022                	sd	s0,0(sp)
ffffffffc02012d6:	8432                	mv	s0,a2
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc02012d8:	4601                	li	a2,0
{
ffffffffc02012da:	e406                	sd	ra,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc02012dc:	dcfff0ef          	jal	ra,ffffffffc02010aa <get_pte>
    if (ptep_store != NULL)
ffffffffc02012e0:	c011                	beqz	s0,ffffffffc02012e4 <get_page+0x12>
    {
        *ptep_store = ptep;
ffffffffc02012e2:	e008                	sd	a0,0(s0)
    }
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc02012e4:	c511                	beqz	a0,ffffffffc02012f0 <get_page+0x1e>
ffffffffc02012e6:	611c                	ld	a5,0(a0)
    {
        return pte2page(*ptep);
    }
    return NULL;
ffffffffc02012e8:	4501                	li	a0,0
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc02012ea:	0017f713          	andi	a4,a5,1
ffffffffc02012ee:	e709                	bnez	a4,ffffffffc02012f8 <get_page+0x26>
}
ffffffffc02012f0:	60a2                	ld	ra,8(sp)
ffffffffc02012f2:	6402                	ld	s0,0(sp)
ffffffffc02012f4:	0141                	addi	sp,sp,16
ffffffffc02012f6:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc02012f8:	078a                	slli	a5,a5,0x2
ffffffffc02012fa:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02012fc:	000a9717          	auipc	a4,0xa9
ffffffffc0201300:	41c73703          	ld	a4,1052(a4) # ffffffffc02aa718 <npage>
ffffffffc0201304:	00e7ff63          	bgeu	a5,a4,ffffffffc0201322 <get_page+0x50>
ffffffffc0201308:	60a2                	ld	ra,8(sp)
ffffffffc020130a:	6402                	ld	s0,0(sp)
    return &pages[PPN(pa) - nbase];
ffffffffc020130c:	fff80537          	lui	a0,0xfff80
ffffffffc0201310:	97aa                	add	a5,a5,a0
ffffffffc0201312:	079a                	slli	a5,a5,0x6
ffffffffc0201314:	000a9517          	auipc	a0,0xa9
ffffffffc0201318:	40c53503          	ld	a0,1036(a0) # ffffffffc02aa720 <pages>
ffffffffc020131c:	953e                	add	a0,a0,a5
ffffffffc020131e:	0141                	addi	sp,sp,16
ffffffffc0201320:	8082                	ret
ffffffffc0201322:	c99ff0ef          	jal	ra,ffffffffc0200fba <pa2page.part.0>

ffffffffc0201326 <unmap_range>:
        tlb_invalidate(pgdir, la);
    }
}

void unmap_range(pde_t *pgdir, uintptr_t start, uintptr_t end)
{
ffffffffc0201326:	7159                	addi	sp,sp,-112
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0201328:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc020132c:	f486                	sd	ra,104(sp)
ffffffffc020132e:	f0a2                	sd	s0,96(sp)
ffffffffc0201330:	eca6                	sd	s1,88(sp)
ffffffffc0201332:	e8ca                	sd	s2,80(sp)
ffffffffc0201334:	e4ce                	sd	s3,72(sp)
ffffffffc0201336:	e0d2                	sd	s4,64(sp)
ffffffffc0201338:	fc56                	sd	s5,56(sp)
ffffffffc020133a:	f85a                	sd	s6,48(sp)
ffffffffc020133c:	f45e                	sd	s7,40(sp)
ffffffffc020133e:	f062                	sd	s8,32(sp)
ffffffffc0201340:	ec66                	sd	s9,24(sp)
ffffffffc0201342:	e86a                	sd	s10,16(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0201344:	17d2                	slli	a5,a5,0x34
ffffffffc0201346:	e3ed                	bnez	a5,ffffffffc0201428 <unmap_range+0x102>
    assert(USER_ACCESS(start, end));
ffffffffc0201348:	002007b7          	lui	a5,0x200
ffffffffc020134c:	842e                	mv	s0,a1
ffffffffc020134e:	0ef5ed63          	bltu	a1,a5,ffffffffc0201448 <unmap_range+0x122>
ffffffffc0201352:	8932                	mv	s2,a2
ffffffffc0201354:	0ec5fa63          	bgeu	a1,a2,ffffffffc0201448 <unmap_range+0x122>
ffffffffc0201358:	4785                	li	a5,1
ffffffffc020135a:	07fe                	slli	a5,a5,0x1f
ffffffffc020135c:	0ec7e663          	bltu	a5,a2,ffffffffc0201448 <unmap_range+0x122>
ffffffffc0201360:	89aa                	mv	s3,a0
        }
        if (*ptep != 0)
        {
            page_remove_pte(pgdir, start, ptep);
        }
        start += PGSIZE;
ffffffffc0201362:	6a05                	lui	s4,0x1
    if (PPN(pa) >= npage)
ffffffffc0201364:	000a9c97          	auipc	s9,0xa9
ffffffffc0201368:	3b4c8c93          	addi	s9,s9,948 # ffffffffc02aa718 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc020136c:	000a9c17          	auipc	s8,0xa9
ffffffffc0201370:	3b4c0c13          	addi	s8,s8,948 # ffffffffc02aa720 <pages>
ffffffffc0201374:	fff80bb7          	lui	s7,0xfff80
        pmm_manager->free_pages(base, n);
ffffffffc0201378:	000a9d17          	auipc	s10,0xa9
ffffffffc020137c:	3b0d0d13          	addi	s10,s10,944 # ffffffffc02aa728 <pmm_manager>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc0201380:	00200b37          	lui	s6,0x200
ffffffffc0201384:	ffe00ab7          	lui	s5,0xffe00
        pte_t *ptep = get_pte(pgdir, start, 0);
ffffffffc0201388:	4601                	li	a2,0
ffffffffc020138a:	85a2                	mv	a1,s0
ffffffffc020138c:	854e                	mv	a0,s3
ffffffffc020138e:	d1dff0ef          	jal	ra,ffffffffc02010aa <get_pte>
ffffffffc0201392:	84aa                	mv	s1,a0
        if (ptep == NULL)
ffffffffc0201394:	cd29                	beqz	a0,ffffffffc02013ee <unmap_range+0xc8>
        if (*ptep != 0)
ffffffffc0201396:	611c                	ld	a5,0(a0)
ffffffffc0201398:	e395                	bnez	a5,ffffffffc02013bc <unmap_range+0x96>
        start += PGSIZE;
ffffffffc020139a:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc020139c:	ff2466e3          	bltu	s0,s2,ffffffffc0201388 <unmap_range+0x62>
}
ffffffffc02013a0:	70a6                	ld	ra,104(sp)
ffffffffc02013a2:	7406                	ld	s0,96(sp)
ffffffffc02013a4:	64e6                	ld	s1,88(sp)
ffffffffc02013a6:	6946                	ld	s2,80(sp)
ffffffffc02013a8:	69a6                	ld	s3,72(sp)
ffffffffc02013aa:	6a06                	ld	s4,64(sp)
ffffffffc02013ac:	7ae2                	ld	s5,56(sp)
ffffffffc02013ae:	7b42                	ld	s6,48(sp)
ffffffffc02013b0:	7ba2                	ld	s7,40(sp)
ffffffffc02013b2:	7c02                	ld	s8,32(sp)
ffffffffc02013b4:	6ce2                	ld	s9,24(sp)
ffffffffc02013b6:	6d42                	ld	s10,16(sp)
ffffffffc02013b8:	6165                	addi	sp,sp,112
ffffffffc02013ba:	8082                	ret
    if (*ptep & PTE_V)
ffffffffc02013bc:	0017f713          	andi	a4,a5,1
ffffffffc02013c0:	df69                	beqz	a4,ffffffffc020139a <unmap_range+0x74>
    if (PPN(pa) >= npage)
ffffffffc02013c2:	000cb703          	ld	a4,0(s9)
    return pa2page(PTE_ADDR(pte));
ffffffffc02013c6:	078a                	slli	a5,a5,0x2
ffffffffc02013c8:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02013ca:	08e7ff63          	bgeu	a5,a4,ffffffffc0201468 <unmap_range+0x142>
    return &pages[PPN(pa) - nbase];
ffffffffc02013ce:	000c3503          	ld	a0,0(s8)
ffffffffc02013d2:	97de                	add	a5,a5,s7
ffffffffc02013d4:	079a                	slli	a5,a5,0x6
ffffffffc02013d6:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc02013d8:	411c                	lw	a5,0(a0)
ffffffffc02013da:	fff7871b          	addiw	a4,a5,-1
ffffffffc02013de:	c118                	sw	a4,0(a0)
        if (page_ref(page) == 0)
ffffffffc02013e0:	cf11                	beqz	a4,ffffffffc02013fc <unmap_range+0xd6>
        *ptep = 0;
ffffffffc02013e2:	0004b023          	sd	zero,0(s1)

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void tlb_invalidate(pde_t *pgdir, uintptr_t la)
{
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02013e6:	12040073          	sfence.vma	s0
        start += PGSIZE;
ffffffffc02013ea:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc02013ec:	bf45                	j	ffffffffc020139c <unmap_range+0x76>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc02013ee:	945a                	add	s0,s0,s6
ffffffffc02013f0:	01547433          	and	s0,s0,s5
    } while (start != 0 && start < end);
ffffffffc02013f4:	d455                	beqz	s0,ffffffffc02013a0 <unmap_range+0x7a>
ffffffffc02013f6:	f92469e3          	bltu	s0,s2,ffffffffc0201388 <unmap_range+0x62>
ffffffffc02013fa:	b75d                	j	ffffffffc02013a0 <unmap_range+0x7a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02013fc:	100027f3          	csrr	a5,sstatus
ffffffffc0201400:	8b89                	andi	a5,a5,2
ffffffffc0201402:	e799                	bnez	a5,ffffffffc0201410 <unmap_range+0xea>
        pmm_manager->free_pages(base, n);
ffffffffc0201404:	000d3783          	ld	a5,0(s10)
ffffffffc0201408:	4585                	li	a1,1
ffffffffc020140a:	739c                	ld	a5,32(a5)
ffffffffc020140c:	9782                	jalr	a5
    if (flag)
ffffffffc020140e:	bfd1                	j	ffffffffc02013e2 <unmap_range+0xbc>
ffffffffc0201410:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0201412:	da8ff0ef          	jal	ra,ffffffffc02009ba <intr_disable>
ffffffffc0201416:	000d3783          	ld	a5,0(s10)
ffffffffc020141a:	6522                	ld	a0,8(sp)
ffffffffc020141c:	4585                	li	a1,1
ffffffffc020141e:	739c                	ld	a5,32(a5)
ffffffffc0201420:	9782                	jalr	a5
        intr_enable();
ffffffffc0201422:	d92ff0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
ffffffffc0201426:	bf75                	j	ffffffffc02013e2 <unmap_range+0xbc>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0201428:	00005697          	auipc	a3,0x5
ffffffffc020142c:	d6868693          	addi	a3,a3,-664 # ffffffffc0206190 <commands+0x858>
ffffffffc0201430:	00005617          	auipc	a2,0x5
ffffffffc0201434:	d9060613          	addi	a2,a2,-624 # ffffffffc02061c0 <commands+0x888>
ffffffffc0201438:	12000593          	li	a1,288
ffffffffc020143c:	00005517          	auipc	a0,0x5
ffffffffc0201440:	d4450513          	addi	a0,a0,-700 # ffffffffc0206180 <commands+0x848>
ffffffffc0201444:	ddbfe0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc0201448:	00005697          	auipc	a3,0x5
ffffffffc020144c:	d9068693          	addi	a3,a3,-624 # ffffffffc02061d8 <commands+0x8a0>
ffffffffc0201450:	00005617          	auipc	a2,0x5
ffffffffc0201454:	d7060613          	addi	a2,a2,-656 # ffffffffc02061c0 <commands+0x888>
ffffffffc0201458:	12100593          	li	a1,289
ffffffffc020145c:	00005517          	auipc	a0,0x5
ffffffffc0201460:	d2450513          	addi	a0,a0,-732 # ffffffffc0206180 <commands+0x848>
ffffffffc0201464:	dbbfe0ef          	jal	ra,ffffffffc020021e <__panic>
ffffffffc0201468:	b53ff0ef          	jal	ra,ffffffffc0200fba <pa2page.part.0>

ffffffffc020146c <exit_range>:
{
ffffffffc020146c:	7119                	addi	sp,sp,-128
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020146e:	00c5e7b3          	or	a5,a1,a2
{
ffffffffc0201472:	fc86                	sd	ra,120(sp)
ffffffffc0201474:	f8a2                	sd	s0,112(sp)
ffffffffc0201476:	f4a6                	sd	s1,104(sp)
ffffffffc0201478:	f0ca                	sd	s2,96(sp)
ffffffffc020147a:	ecce                	sd	s3,88(sp)
ffffffffc020147c:	e8d2                	sd	s4,80(sp)
ffffffffc020147e:	e4d6                	sd	s5,72(sp)
ffffffffc0201480:	e0da                	sd	s6,64(sp)
ffffffffc0201482:	fc5e                	sd	s7,56(sp)
ffffffffc0201484:	f862                	sd	s8,48(sp)
ffffffffc0201486:	f466                	sd	s9,40(sp)
ffffffffc0201488:	f06a                	sd	s10,32(sp)
ffffffffc020148a:	ec6e                	sd	s11,24(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc020148c:	17d2                	slli	a5,a5,0x34
ffffffffc020148e:	20079a63          	bnez	a5,ffffffffc02016a2 <exit_range+0x236>
    assert(USER_ACCESS(start, end));
ffffffffc0201492:	002007b7          	lui	a5,0x200
ffffffffc0201496:	24f5e463          	bltu	a1,a5,ffffffffc02016de <exit_range+0x272>
ffffffffc020149a:	8ab2                	mv	s5,a2
ffffffffc020149c:	24c5f163          	bgeu	a1,a2,ffffffffc02016de <exit_range+0x272>
ffffffffc02014a0:	4785                	li	a5,1
ffffffffc02014a2:	07fe                	slli	a5,a5,0x1f
ffffffffc02014a4:	22c7ed63          	bltu	a5,a2,ffffffffc02016de <exit_range+0x272>
    d1start = ROUNDDOWN(start, PDSIZE);
ffffffffc02014a8:	c00009b7          	lui	s3,0xc0000
ffffffffc02014ac:	0135f9b3          	and	s3,a1,s3
    d0start = ROUNDDOWN(start, PTSIZE);
ffffffffc02014b0:	ffe00937          	lui	s2,0xffe00
ffffffffc02014b4:	400007b7          	lui	a5,0x40000
    return KADDR(page2pa(page));
ffffffffc02014b8:	5cfd                	li	s9,-1
ffffffffc02014ba:	8c2a                	mv	s8,a0
ffffffffc02014bc:	0125f933          	and	s2,a1,s2
ffffffffc02014c0:	99be                	add	s3,s3,a5
    if (PPN(pa) >= npage)
ffffffffc02014c2:	000a9d17          	auipc	s10,0xa9
ffffffffc02014c6:	256d0d13          	addi	s10,s10,598 # ffffffffc02aa718 <npage>
    return KADDR(page2pa(page));
ffffffffc02014ca:	00ccdc93          	srli	s9,s9,0xc
    return &pages[PPN(pa) - nbase];
ffffffffc02014ce:	000a9717          	auipc	a4,0xa9
ffffffffc02014d2:	25270713          	addi	a4,a4,594 # ffffffffc02aa720 <pages>
        pmm_manager->free_pages(base, n);
ffffffffc02014d6:	000a9d97          	auipc	s11,0xa9
ffffffffc02014da:	252d8d93          	addi	s11,s11,594 # ffffffffc02aa728 <pmm_manager>
        pde1 = pgdir[PDX1(d1start)];
ffffffffc02014de:	c0000437          	lui	s0,0xc0000
ffffffffc02014e2:	944e                	add	s0,s0,s3
ffffffffc02014e4:	8079                	srli	s0,s0,0x1e
ffffffffc02014e6:	1ff47413          	andi	s0,s0,511
ffffffffc02014ea:	040e                	slli	s0,s0,0x3
ffffffffc02014ec:	9462                	add	s0,s0,s8
ffffffffc02014ee:	00043a03          	ld	s4,0(s0) # ffffffffc0000000 <_binary_obj___user_exit_out_size+0xffffffffbfff4ee0>
        if (pde1 & PTE_V)
ffffffffc02014f2:	001a7793          	andi	a5,s4,1
ffffffffc02014f6:	eb99                	bnez	a5,ffffffffc020150c <exit_range+0xa0>
    } while (d1start != 0 && d1start < end);
ffffffffc02014f8:	12098463          	beqz	s3,ffffffffc0201620 <exit_range+0x1b4>
ffffffffc02014fc:	400007b7          	lui	a5,0x40000
ffffffffc0201500:	97ce                	add	a5,a5,s3
ffffffffc0201502:	894e                	mv	s2,s3
ffffffffc0201504:	1159fe63          	bgeu	s3,s5,ffffffffc0201620 <exit_range+0x1b4>
ffffffffc0201508:	89be                	mv	s3,a5
ffffffffc020150a:	bfd1                	j	ffffffffc02014de <exit_range+0x72>
    if (PPN(pa) >= npage)
ffffffffc020150c:	000d3783          	ld	a5,0(s10)
    return pa2page(PDE_ADDR(pde));
ffffffffc0201510:	0a0a                	slli	s4,s4,0x2
ffffffffc0201512:	00ca5a13          	srli	s4,s4,0xc
    if (PPN(pa) >= npage)
ffffffffc0201516:	1cfa7263          	bgeu	s4,a5,ffffffffc02016da <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc020151a:	fff80637          	lui	a2,0xfff80
ffffffffc020151e:	9652                	add	a2,a2,s4
    return page - pages + nbase;
ffffffffc0201520:	000806b7          	lui	a3,0x80
ffffffffc0201524:	96b2                	add	a3,a3,a2
    return KADDR(page2pa(page));
ffffffffc0201526:	0196f5b3          	and	a1,a3,s9
    return &pages[PPN(pa) - nbase];
ffffffffc020152a:	061a                	slli	a2,a2,0x6
    return page2ppn(page) << PGSHIFT;
ffffffffc020152c:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc020152e:	18f5fa63          	bgeu	a1,a5,ffffffffc02016c2 <exit_range+0x256>
ffffffffc0201532:	000a9817          	auipc	a6,0xa9
ffffffffc0201536:	1fe80813          	addi	a6,a6,510 # ffffffffc02aa730 <va_pa_offset>
ffffffffc020153a:	00083b03          	ld	s6,0(a6)
            free_pd0 = 1;
ffffffffc020153e:	4b85                	li	s7,1
    return &pages[PPN(pa) - nbase];
ffffffffc0201540:	fff80e37          	lui	t3,0xfff80
    return KADDR(page2pa(page));
ffffffffc0201544:	9b36                	add	s6,s6,a3
    return page - pages + nbase;
ffffffffc0201546:	00080337          	lui	t1,0x80
ffffffffc020154a:	6885                	lui	a7,0x1
ffffffffc020154c:	a819                	j	ffffffffc0201562 <exit_range+0xf6>
                    free_pd0 = 0;
ffffffffc020154e:	4b81                	li	s7,0
                d0start += PTSIZE;
ffffffffc0201550:	002007b7          	lui	a5,0x200
ffffffffc0201554:	993e                	add	s2,s2,a5
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc0201556:	08090c63          	beqz	s2,ffffffffc02015ee <exit_range+0x182>
ffffffffc020155a:	09397a63          	bgeu	s2,s3,ffffffffc02015ee <exit_range+0x182>
ffffffffc020155e:	0f597063          	bgeu	s2,s5,ffffffffc020163e <exit_range+0x1d2>
                pde0 = pd0[PDX0(d0start)];
ffffffffc0201562:	01595493          	srli	s1,s2,0x15
ffffffffc0201566:	1ff4f493          	andi	s1,s1,511
ffffffffc020156a:	048e                	slli	s1,s1,0x3
ffffffffc020156c:	94da                	add	s1,s1,s6
ffffffffc020156e:	609c                	ld	a5,0(s1)
                if (pde0 & PTE_V)
ffffffffc0201570:	0017f693          	andi	a3,a5,1
ffffffffc0201574:	dee9                	beqz	a3,ffffffffc020154e <exit_range+0xe2>
    if (PPN(pa) >= npage)
ffffffffc0201576:	000d3583          	ld	a1,0(s10)
    return pa2page(PDE_ADDR(pde));
ffffffffc020157a:	078a                	slli	a5,a5,0x2
ffffffffc020157c:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020157e:	14b7fe63          	bgeu	a5,a1,ffffffffc02016da <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc0201582:	97f2                	add	a5,a5,t3
    return page - pages + nbase;
ffffffffc0201584:	006786b3          	add	a3,a5,t1
    return KADDR(page2pa(page));
ffffffffc0201588:	0196feb3          	and	t4,a3,s9
    return &pages[PPN(pa) - nbase];
ffffffffc020158c:	00679513          	slli	a0,a5,0x6
    return page2ppn(page) << PGSHIFT;
ffffffffc0201590:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0201592:	12bef863          	bgeu	t4,a1,ffffffffc02016c2 <exit_range+0x256>
ffffffffc0201596:	00083783          	ld	a5,0(a6)
ffffffffc020159a:	96be                	add	a3,a3,a5
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc020159c:	011685b3          	add	a1,a3,a7
                        if (pt[i] & PTE_V)
ffffffffc02015a0:	629c                	ld	a5,0(a3)
ffffffffc02015a2:	8b85                	andi	a5,a5,1
ffffffffc02015a4:	f7d5                	bnez	a5,ffffffffc0201550 <exit_range+0xe4>
                    for (int i = 0; i < NPTEENTRY; i++)
ffffffffc02015a6:	06a1                	addi	a3,a3,8
ffffffffc02015a8:	fed59ce3          	bne	a1,a3,ffffffffc02015a0 <exit_range+0x134>
    return &pages[PPN(pa) - nbase];
ffffffffc02015ac:	631c                	ld	a5,0(a4)
ffffffffc02015ae:	953e                	add	a0,a0,a5
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02015b0:	100027f3          	csrr	a5,sstatus
ffffffffc02015b4:	8b89                	andi	a5,a5,2
ffffffffc02015b6:	e7d9                	bnez	a5,ffffffffc0201644 <exit_range+0x1d8>
        pmm_manager->free_pages(base, n);
ffffffffc02015b8:	000db783          	ld	a5,0(s11)
ffffffffc02015bc:	4585                	li	a1,1
ffffffffc02015be:	e032                	sd	a2,0(sp)
ffffffffc02015c0:	739c                	ld	a5,32(a5)
ffffffffc02015c2:	9782                	jalr	a5
    if (flag)
ffffffffc02015c4:	6602                	ld	a2,0(sp)
ffffffffc02015c6:	000a9817          	auipc	a6,0xa9
ffffffffc02015ca:	16a80813          	addi	a6,a6,362 # ffffffffc02aa730 <va_pa_offset>
ffffffffc02015ce:	fff80e37          	lui	t3,0xfff80
ffffffffc02015d2:	00080337          	lui	t1,0x80
ffffffffc02015d6:	6885                	lui	a7,0x1
ffffffffc02015d8:	000a9717          	auipc	a4,0xa9
ffffffffc02015dc:	14870713          	addi	a4,a4,328 # ffffffffc02aa720 <pages>
                        pd0[PDX0(d0start)] = 0;
ffffffffc02015e0:	0004b023          	sd	zero,0(s1)
                d0start += PTSIZE;
ffffffffc02015e4:	002007b7          	lui	a5,0x200
ffffffffc02015e8:	993e                	add	s2,s2,a5
            } while (d0start != 0 && d0start < d1start + PDSIZE && d0start < end);
ffffffffc02015ea:	f60918e3          	bnez	s2,ffffffffc020155a <exit_range+0xee>
            if (free_pd0)
ffffffffc02015ee:	f00b85e3          	beqz	s7,ffffffffc02014f8 <exit_range+0x8c>
    if (PPN(pa) >= npage)
ffffffffc02015f2:	000d3783          	ld	a5,0(s10)
ffffffffc02015f6:	0efa7263          	bgeu	s4,a5,ffffffffc02016da <exit_range+0x26e>
    return &pages[PPN(pa) - nbase];
ffffffffc02015fa:	6308                	ld	a0,0(a4)
ffffffffc02015fc:	9532                	add	a0,a0,a2
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02015fe:	100027f3          	csrr	a5,sstatus
ffffffffc0201602:	8b89                	andi	a5,a5,2
ffffffffc0201604:	efad                	bnez	a5,ffffffffc020167e <exit_range+0x212>
        pmm_manager->free_pages(base, n);
ffffffffc0201606:	000db783          	ld	a5,0(s11)
ffffffffc020160a:	4585                	li	a1,1
ffffffffc020160c:	739c                	ld	a5,32(a5)
ffffffffc020160e:	9782                	jalr	a5
ffffffffc0201610:	000a9717          	auipc	a4,0xa9
ffffffffc0201614:	11070713          	addi	a4,a4,272 # ffffffffc02aa720 <pages>
                pgdir[PDX1(d1start)] = 0;
ffffffffc0201618:	00043023          	sd	zero,0(s0)
    } while (d1start != 0 && d1start < end);
ffffffffc020161c:	ee0990e3          	bnez	s3,ffffffffc02014fc <exit_range+0x90>
}
ffffffffc0201620:	70e6                	ld	ra,120(sp)
ffffffffc0201622:	7446                	ld	s0,112(sp)
ffffffffc0201624:	74a6                	ld	s1,104(sp)
ffffffffc0201626:	7906                	ld	s2,96(sp)
ffffffffc0201628:	69e6                	ld	s3,88(sp)
ffffffffc020162a:	6a46                	ld	s4,80(sp)
ffffffffc020162c:	6aa6                	ld	s5,72(sp)
ffffffffc020162e:	6b06                	ld	s6,64(sp)
ffffffffc0201630:	7be2                	ld	s7,56(sp)
ffffffffc0201632:	7c42                	ld	s8,48(sp)
ffffffffc0201634:	7ca2                	ld	s9,40(sp)
ffffffffc0201636:	7d02                	ld	s10,32(sp)
ffffffffc0201638:	6de2                	ld	s11,24(sp)
ffffffffc020163a:	6109                	addi	sp,sp,128
ffffffffc020163c:	8082                	ret
            if (free_pd0)
ffffffffc020163e:	ea0b8fe3          	beqz	s7,ffffffffc02014fc <exit_range+0x90>
ffffffffc0201642:	bf45                	j	ffffffffc02015f2 <exit_range+0x186>
ffffffffc0201644:	e032                	sd	a2,0(sp)
        intr_disable();
ffffffffc0201646:	e42a                	sd	a0,8(sp)
ffffffffc0201648:	b72ff0ef          	jal	ra,ffffffffc02009ba <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc020164c:	000db783          	ld	a5,0(s11)
ffffffffc0201650:	6522                	ld	a0,8(sp)
ffffffffc0201652:	4585                	li	a1,1
ffffffffc0201654:	739c                	ld	a5,32(a5)
ffffffffc0201656:	9782                	jalr	a5
        intr_enable();
ffffffffc0201658:	b5cff0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
ffffffffc020165c:	6602                	ld	a2,0(sp)
ffffffffc020165e:	000a9717          	auipc	a4,0xa9
ffffffffc0201662:	0c270713          	addi	a4,a4,194 # ffffffffc02aa720 <pages>
ffffffffc0201666:	6885                	lui	a7,0x1
ffffffffc0201668:	00080337          	lui	t1,0x80
ffffffffc020166c:	fff80e37          	lui	t3,0xfff80
ffffffffc0201670:	000a9817          	auipc	a6,0xa9
ffffffffc0201674:	0c080813          	addi	a6,a6,192 # ffffffffc02aa730 <va_pa_offset>
                        pd0[PDX0(d0start)] = 0;
ffffffffc0201678:	0004b023          	sd	zero,0(s1)
ffffffffc020167c:	b7a5                	j	ffffffffc02015e4 <exit_range+0x178>
ffffffffc020167e:	e02a                	sd	a0,0(sp)
        intr_disable();
ffffffffc0201680:	b3aff0ef          	jal	ra,ffffffffc02009ba <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0201684:	000db783          	ld	a5,0(s11)
ffffffffc0201688:	6502                	ld	a0,0(sp)
ffffffffc020168a:	4585                	li	a1,1
ffffffffc020168c:	739c                	ld	a5,32(a5)
ffffffffc020168e:	9782                	jalr	a5
        intr_enable();
ffffffffc0201690:	b24ff0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
ffffffffc0201694:	000a9717          	auipc	a4,0xa9
ffffffffc0201698:	08c70713          	addi	a4,a4,140 # ffffffffc02aa720 <pages>
                pgdir[PDX1(d1start)] = 0;
ffffffffc020169c:	00043023          	sd	zero,0(s0)
ffffffffc02016a0:	bfb5                	j	ffffffffc020161c <exit_range+0x1b0>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02016a2:	00005697          	auipc	a3,0x5
ffffffffc02016a6:	aee68693          	addi	a3,a3,-1298 # ffffffffc0206190 <commands+0x858>
ffffffffc02016aa:	00005617          	auipc	a2,0x5
ffffffffc02016ae:	b1660613          	addi	a2,a2,-1258 # ffffffffc02061c0 <commands+0x888>
ffffffffc02016b2:	13500593          	li	a1,309
ffffffffc02016b6:	00005517          	auipc	a0,0x5
ffffffffc02016ba:	aca50513          	addi	a0,a0,-1334 # ffffffffc0206180 <commands+0x848>
ffffffffc02016be:	b61fe0ef          	jal	ra,ffffffffc020021e <__panic>
    return KADDR(page2pa(page));
ffffffffc02016c2:	00005617          	auipc	a2,0x5
ffffffffc02016c6:	a9660613          	addi	a2,a2,-1386 # ffffffffc0206158 <commands+0x820>
ffffffffc02016ca:	07100593          	li	a1,113
ffffffffc02016ce:	00005517          	auipc	a0,0x5
ffffffffc02016d2:	a5250513          	addi	a0,a0,-1454 # ffffffffc0206120 <commands+0x7e8>
ffffffffc02016d6:	b49fe0ef          	jal	ra,ffffffffc020021e <__panic>
ffffffffc02016da:	8e1ff0ef          	jal	ra,ffffffffc0200fba <pa2page.part.0>
    assert(USER_ACCESS(start, end));
ffffffffc02016de:	00005697          	auipc	a3,0x5
ffffffffc02016e2:	afa68693          	addi	a3,a3,-1286 # ffffffffc02061d8 <commands+0x8a0>
ffffffffc02016e6:	00005617          	auipc	a2,0x5
ffffffffc02016ea:	ada60613          	addi	a2,a2,-1318 # ffffffffc02061c0 <commands+0x888>
ffffffffc02016ee:	13600593          	li	a1,310
ffffffffc02016f2:	00005517          	auipc	a0,0x5
ffffffffc02016f6:	a8e50513          	addi	a0,a0,-1394 # ffffffffc0206180 <commands+0x848>
ffffffffc02016fa:	b25fe0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc02016fe <page_remove>:
{
ffffffffc02016fe:	7179                	addi	sp,sp,-48
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0201700:	4601                	li	a2,0
{
ffffffffc0201702:	ec26                	sd	s1,24(sp)
ffffffffc0201704:	f406                	sd	ra,40(sp)
ffffffffc0201706:	f022                	sd	s0,32(sp)
ffffffffc0201708:	84ae                	mv	s1,a1
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc020170a:	9a1ff0ef          	jal	ra,ffffffffc02010aa <get_pte>
    if (ptep != NULL)
ffffffffc020170e:	c511                	beqz	a0,ffffffffc020171a <page_remove+0x1c>
    if (*ptep & PTE_V)
ffffffffc0201710:	611c                	ld	a5,0(a0)
ffffffffc0201712:	842a                	mv	s0,a0
ffffffffc0201714:	0017f713          	andi	a4,a5,1
ffffffffc0201718:	e711                	bnez	a4,ffffffffc0201724 <page_remove+0x26>
}
ffffffffc020171a:	70a2                	ld	ra,40(sp)
ffffffffc020171c:	7402                	ld	s0,32(sp)
ffffffffc020171e:	64e2                	ld	s1,24(sp)
ffffffffc0201720:	6145                	addi	sp,sp,48
ffffffffc0201722:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0201724:	078a                	slli	a5,a5,0x2
ffffffffc0201726:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0201728:	000a9717          	auipc	a4,0xa9
ffffffffc020172c:	ff073703          	ld	a4,-16(a4) # ffffffffc02aa718 <npage>
ffffffffc0201730:	06e7f363          	bgeu	a5,a4,ffffffffc0201796 <page_remove+0x98>
    return &pages[PPN(pa) - nbase];
ffffffffc0201734:	fff80537          	lui	a0,0xfff80
ffffffffc0201738:	97aa                	add	a5,a5,a0
ffffffffc020173a:	079a                	slli	a5,a5,0x6
ffffffffc020173c:	000a9517          	auipc	a0,0xa9
ffffffffc0201740:	fe453503          	ld	a0,-28(a0) # ffffffffc02aa720 <pages>
ffffffffc0201744:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc0201746:	411c                	lw	a5,0(a0)
ffffffffc0201748:	fff7871b          	addiw	a4,a5,-1
ffffffffc020174c:	c118                	sw	a4,0(a0)
        if (page_ref(page) == 0)
ffffffffc020174e:	cb11                	beqz	a4,ffffffffc0201762 <page_remove+0x64>
        *ptep = 0;
ffffffffc0201750:	00043023          	sd	zero,0(s0)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0201754:	12048073          	sfence.vma	s1
}
ffffffffc0201758:	70a2                	ld	ra,40(sp)
ffffffffc020175a:	7402                	ld	s0,32(sp)
ffffffffc020175c:	64e2                	ld	s1,24(sp)
ffffffffc020175e:	6145                	addi	sp,sp,48
ffffffffc0201760:	8082                	ret
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201762:	100027f3          	csrr	a5,sstatus
ffffffffc0201766:	8b89                	andi	a5,a5,2
ffffffffc0201768:	eb89                	bnez	a5,ffffffffc020177a <page_remove+0x7c>
        pmm_manager->free_pages(base, n);
ffffffffc020176a:	000a9797          	auipc	a5,0xa9
ffffffffc020176e:	fbe7b783          	ld	a5,-66(a5) # ffffffffc02aa728 <pmm_manager>
ffffffffc0201772:	739c                	ld	a5,32(a5)
ffffffffc0201774:	4585                	li	a1,1
ffffffffc0201776:	9782                	jalr	a5
    if (flag)
ffffffffc0201778:	bfe1                	j	ffffffffc0201750 <page_remove+0x52>
        intr_disable();
ffffffffc020177a:	e42a                	sd	a0,8(sp)
ffffffffc020177c:	a3eff0ef          	jal	ra,ffffffffc02009ba <intr_disable>
ffffffffc0201780:	000a9797          	auipc	a5,0xa9
ffffffffc0201784:	fa87b783          	ld	a5,-88(a5) # ffffffffc02aa728 <pmm_manager>
ffffffffc0201788:	739c                	ld	a5,32(a5)
ffffffffc020178a:	6522                	ld	a0,8(sp)
ffffffffc020178c:	4585                	li	a1,1
ffffffffc020178e:	9782                	jalr	a5
        intr_enable();
ffffffffc0201790:	a24ff0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
ffffffffc0201794:	bf75                	j	ffffffffc0201750 <page_remove+0x52>
ffffffffc0201796:	825ff0ef          	jal	ra,ffffffffc0200fba <pa2page.part.0>

ffffffffc020179a <page_insert>:
{
ffffffffc020179a:	7139                	addi	sp,sp,-64
ffffffffc020179c:	e852                	sd	s4,16(sp)
ffffffffc020179e:	8a32                	mv	s4,a2
ffffffffc02017a0:	f822                	sd	s0,48(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc02017a2:	4605                	li	a2,1
{
ffffffffc02017a4:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc02017a6:	85d2                	mv	a1,s4
{
ffffffffc02017a8:	f426                	sd	s1,40(sp)
ffffffffc02017aa:	fc06                	sd	ra,56(sp)
ffffffffc02017ac:	f04a                	sd	s2,32(sp)
ffffffffc02017ae:	ec4e                	sd	s3,24(sp)
ffffffffc02017b0:	e456                	sd	s5,8(sp)
ffffffffc02017b2:	84b6                	mv	s1,a3
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc02017b4:	8f7ff0ef          	jal	ra,ffffffffc02010aa <get_pte>
    if (ptep == NULL)
ffffffffc02017b8:	c961                	beqz	a0,ffffffffc0201888 <page_insert+0xee>
    page->ref += 1;
ffffffffc02017ba:	4014                	lw	a3,0(s0)
    if (*ptep & PTE_V)
ffffffffc02017bc:	611c                	ld	a5,0(a0)
ffffffffc02017be:	89aa                	mv	s3,a0
ffffffffc02017c0:	0016871b          	addiw	a4,a3,1
ffffffffc02017c4:	c018                	sw	a4,0(s0)
ffffffffc02017c6:	0017f713          	andi	a4,a5,1
ffffffffc02017ca:	ef05                	bnez	a4,ffffffffc0201802 <page_insert+0x68>
    return page - pages + nbase;
ffffffffc02017cc:	000a9717          	auipc	a4,0xa9
ffffffffc02017d0:	f5473703          	ld	a4,-172(a4) # ffffffffc02aa720 <pages>
ffffffffc02017d4:	8c19                	sub	s0,s0,a4
ffffffffc02017d6:	000807b7          	lui	a5,0x80
ffffffffc02017da:	8419                	srai	s0,s0,0x6
ffffffffc02017dc:	943e                	add	s0,s0,a5
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc02017de:	042a                	slli	s0,s0,0xa
ffffffffc02017e0:	8cc1                	or	s1,s1,s0
ffffffffc02017e2:	0014e493          	ori	s1,s1,1
    *ptep = pte_create(page2ppn(page), PTE_V | perm);
ffffffffc02017e6:	0099b023          	sd	s1,0(s3) # ffffffffc0000000 <_binary_obj___user_exit_out_size+0xffffffffbfff4ee0>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02017ea:	120a0073          	sfence.vma	s4
    return 0;
ffffffffc02017ee:	4501                	li	a0,0
}
ffffffffc02017f0:	70e2                	ld	ra,56(sp)
ffffffffc02017f2:	7442                	ld	s0,48(sp)
ffffffffc02017f4:	74a2                	ld	s1,40(sp)
ffffffffc02017f6:	7902                	ld	s2,32(sp)
ffffffffc02017f8:	69e2                	ld	s3,24(sp)
ffffffffc02017fa:	6a42                	ld	s4,16(sp)
ffffffffc02017fc:	6aa2                	ld	s5,8(sp)
ffffffffc02017fe:	6121                	addi	sp,sp,64
ffffffffc0201800:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc0201802:	078a                	slli	a5,a5,0x2
ffffffffc0201804:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0201806:	000a9717          	auipc	a4,0xa9
ffffffffc020180a:	f1273703          	ld	a4,-238(a4) # ffffffffc02aa718 <npage>
ffffffffc020180e:	06e7ff63          	bgeu	a5,a4,ffffffffc020188c <page_insert+0xf2>
    return &pages[PPN(pa) - nbase];
ffffffffc0201812:	000a9a97          	auipc	s5,0xa9
ffffffffc0201816:	f0ea8a93          	addi	s5,s5,-242 # ffffffffc02aa720 <pages>
ffffffffc020181a:	000ab703          	ld	a4,0(s5)
ffffffffc020181e:	fff80937          	lui	s2,0xfff80
ffffffffc0201822:	993e                	add	s2,s2,a5
ffffffffc0201824:	091a                	slli	s2,s2,0x6
ffffffffc0201826:	993a                	add	s2,s2,a4
        if (p == page)
ffffffffc0201828:	01240c63          	beq	s0,s2,ffffffffc0201840 <page_insert+0xa6>
    page->ref -= 1;
ffffffffc020182c:	00092783          	lw	a5,0(s2) # fffffffffff80000 <end+0x3fcd58a4>
ffffffffc0201830:	fff7869b          	addiw	a3,a5,-1
ffffffffc0201834:	00d92023          	sw	a3,0(s2)
        if (page_ref(page) == 0)
ffffffffc0201838:	c691                	beqz	a3,ffffffffc0201844 <page_insert+0xaa>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020183a:	120a0073          	sfence.vma	s4
}
ffffffffc020183e:	bf59                	j	ffffffffc02017d4 <page_insert+0x3a>
ffffffffc0201840:	c014                	sw	a3,0(s0)
    return page->ref;
ffffffffc0201842:	bf49                	j	ffffffffc02017d4 <page_insert+0x3a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0201844:	100027f3          	csrr	a5,sstatus
ffffffffc0201848:	8b89                	andi	a5,a5,2
ffffffffc020184a:	ef91                	bnez	a5,ffffffffc0201866 <page_insert+0xcc>
        pmm_manager->free_pages(base, n);
ffffffffc020184c:	000a9797          	auipc	a5,0xa9
ffffffffc0201850:	edc7b783          	ld	a5,-292(a5) # ffffffffc02aa728 <pmm_manager>
ffffffffc0201854:	739c                	ld	a5,32(a5)
ffffffffc0201856:	4585                	li	a1,1
ffffffffc0201858:	854a                	mv	a0,s2
ffffffffc020185a:	9782                	jalr	a5
    return page - pages + nbase;
ffffffffc020185c:	000ab703          	ld	a4,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0201860:	120a0073          	sfence.vma	s4
ffffffffc0201864:	bf85                	j	ffffffffc02017d4 <page_insert+0x3a>
        intr_disable();
ffffffffc0201866:	954ff0ef          	jal	ra,ffffffffc02009ba <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc020186a:	000a9797          	auipc	a5,0xa9
ffffffffc020186e:	ebe7b783          	ld	a5,-322(a5) # ffffffffc02aa728 <pmm_manager>
ffffffffc0201872:	739c                	ld	a5,32(a5)
ffffffffc0201874:	4585                	li	a1,1
ffffffffc0201876:	854a                	mv	a0,s2
ffffffffc0201878:	9782                	jalr	a5
        intr_enable();
ffffffffc020187a:	93aff0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
ffffffffc020187e:	000ab703          	ld	a4,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0201882:	120a0073          	sfence.vma	s4
ffffffffc0201886:	b7b9                	j	ffffffffc02017d4 <page_insert+0x3a>
        return -E_NO_MEM;
ffffffffc0201888:	5571                	li	a0,-4
ffffffffc020188a:	b79d                	j	ffffffffc02017f0 <page_insert+0x56>
ffffffffc020188c:	f2eff0ef          	jal	ra,ffffffffc0200fba <pa2page.part.0>

ffffffffc0201890 <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc0201890:	00005797          	auipc	a5,0x5
ffffffffc0201894:	60078793          	addi	a5,a5,1536 # ffffffffc0206e90 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0201898:	638c                	ld	a1,0(a5)
{
ffffffffc020189a:	7159                	addi	sp,sp,-112
ffffffffc020189c:	f85a                	sd	s6,48(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc020189e:	00005517          	auipc	a0,0x5
ffffffffc02018a2:	95250513          	addi	a0,a0,-1710 # ffffffffc02061f0 <commands+0x8b8>
    pmm_manager = &default_pmm_manager;
ffffffffc02018a6:	000a9b17          	auipc	s6,0xa9
ffffffffc02018aa:	e82b0b13          	addi	s6,s6,-382 # ffffffffc02aa728 <pmm_manager>
{
ffffffffc02018ae:	f486                	sd	ra,104(sp)
ffffffffc02018b0:	e8ca                	sd	s2,80(sp)
ffffffffc02018b2:	e4ce                	sd	s3,72(sp)
ffffffffc02018b4:	f0a2                	sd	s0,96(sp)
ffffffffc02018b6:	eca6                	sd	s1,88(sp)
ffffffffc02018b8:	e0d2                	sd	s4,64(sp)
ffffffffc02018ba:	fc56                	sd	s5,56(sp)
ffffffffc02018bc:	f45e                	sd	s7,40(sp)
ffffffffc02018be:	f062                	sd	s8,32(sp)
ffffffffc02018c0:	ec66                	sd	s9,24(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc02018c2:	00fb3023          	sd	a5,0(s6)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02018c6:	81bfe0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    pmm_manager->init();
ffffffffc02018ca:	000b3783          	ld	a5,0(s6)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc02018ce:	000a9997          	auipc	s3,0xa9
ffffffffc02018d2:	e6298993          	addi	s3,s3,-414 # ffffffffc02aa730 <va_pa_offset>
    pmm_manager->init();
ffffffffc02018d6:	679c                	ld	a5,8(a5)
ffffffffc02018d8:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc02018da:	57f5                	li	a5,-3
ffffffffc02018dc:	07fa                	slli	a5,a5,0x1e
ffffffffc02018de:	00f9b023          	sd	a5,0(s3)
    uint64_t mem_begin = get_memory_base();
ffffffffc02018e2:	ff7fe0ef          	jal	ra,ffffffffc02008d8 <get_memory_base>
ffffffffc02018e6:	892a                	mv	s2,a0
    uint64_t mem_size = get_memory_size();
ffffffffc02018e8:	ffbfe0ef          	jal	ra,ffffffffc02008e2 <get_memory_size>
    if (mem_size == 0)
ffffffffc02018ec:	200505e3          	beqz	a0,ffffffffc02022f6 <pmm_init+0xa66>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc02018f0:	84aa                	mv	s1,a0
    cprintf("physcial memory map:\n");
ffffffffc02018f2:	00005517          	auipc	a0,0x5
ffffffffc02018f6:	93650513          	addi	a0,a0,-1738 # ffffffffc0206228 <commands+0x8f0>
ffffffffc02018fa:	fe6fe0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    uint64_t mem_end = mem_begin + mem_size;
ffffffffc02018fe:	00990433          	add	s0,s2,s1
    cprintf("  memory: 0x%08lx, [0x%08lx, 0x%08lx].\n", mem_size, mem_begin,
ffffffffc0201902:	fff40693          	addi	a3,s0,-1
ffffffffc0201906:	864a                	mv	a2,s2
ffffffffc0201908:	85a6                	mv	a1,s1
ffffffffc020190a:	00005517          	auipc	a0,0x5
ffffffffc020190e:	93650513          	addi	a0,a0,-1738 # ffffffffc0206240 <commands+0x908>
ffffffffc0201912:	fcefe0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    npage = maxpa / PGSIZE;
ffffffffc0201916:	c8000737          	lui	a4,0xc8000
ffffffffc020191a:	87a2                	mv	a5,s0
ffffffffc020191c:	54876163          	bltu	a4,s0,ffffffffc0201e5e <pmm_init+0x5ce>
ffffffffc0201920:	757d                	lui	a0,0xfffff
ffffffffc0201922:	000aa617          	auipc	a2,0xaa
ffffffffc0201926:	e3960613          	addi	a2,a2,-455 # ffffffffc02ab75b <end+0xfff>
ffffffffc020192a:	8e69                	and	a2,a2,a0
ffffffffc020192c:	000a9497          	auipc	s1,0xa9
ffffffffc0201930:	dec48493          	addi	s1,s1,-532 # ffffffffc02aa718 <npage>
ffffffffc0201934:	00c7d513          	srli	a0,a5,0xc
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0201938:	000a9b97          	auipc	s7,0xa9
ffffffffc020193c:	de8b8b93          	addi	s7,s7,-536 # ffffffffc02aa720 <pages>
    npage = maxpa / PGSIZE;
ffffffffc0201940:	e088                	sd	a0,0(s1)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0201942:	00cbb023          	sd	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0201946:	000807b7          	lui	a5,0x80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc020194a:	86b2                	mv	a3,a2
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc020194c:	02f50863          	beq	a0,a5,ffffffffc020197c <pmm_init+0xec>
ffffffffc0201950:	4781                	li	a5,0
 *
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void set_bit(int nr, volatile void *addr) {
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201952:	4585                	li	a1,1
ffffffffc0201954:	fff806b7          	lui	a3,0xfff80
        SetPageReserved(pages + i);
ffffffffc0201958:	00679513          	slli	a0,a5,0x6
ffffffffc020195c:	9532                	add	a0,a0,a2
ffffffffc020195e:	00850713          	addi	a4,a0,8 # fffffffffffff008 <end+0x3fd548ac>
ffffffffc0201962:	40b7302f          	amoor.d	zero,a1,(a4)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0201966:	6088                	ld	a0,0(s1)
ffffffffc0201968:	0785                	addi	a5,a5,1
        SetPageReserved(pages + i);
ffffffffc020196a:	000bb603          	ld	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc020196e:	00d50733          	add	a4,a0,a3
ffffffffc0201972:	fee7e3e3          	bltu	a5,a4,ffffffffc0201958 <pmm_init+0xc8>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0201976:	071a                	slli	a4,a4,0x6
ffffffffc0201978:	00e606b3          	add	a3,a2,a4
ffffffffc020197c:	c02007b7          	lui	a5,0xc0200
ffffffffc0201980:	2ef6ece3          	bltu	a3,a5,ffffffffc0202478 <pmm_init+0xbe8>
ffffffffc0201984:	0009b583          	ld	a1,0(s3)
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc0201988:	77fd                	lui	a5,0xfffff
ffffffffc020198a:	8c7d                	and	s0,s0,a5
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc020198c:	8e8d                	sub	a3,a3,a1
    if (freemem < mem_end)
ffffffffc020198e:	5086eb63          	bltu	a3,s0,ffffffffc0201ea4 <pmm_init+0x614>
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc0201992:	00005517          	auipc	a0,0x5
ffffffffc0201996:	8fe50513          	addi	a0,a0,-1794 # ffffffffc0206290 <commands+0x958>
ffffffffc020199a:	f46fe0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    return page;
}

static void check_alloc_page(void)
{
    pmm_manager->check();
ffffffffc020199e:	000b3783          	ld	a5,0(s6)
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc02019a2:	000a9917          	auipc	s2,0xa9
ffffffffc02019a6:	d6e90913          	addi	s2,s2,-658 # ffffffffc02aa710 <boot_pgdir_va>
    pmm_manager->check();
ffffffffc02019aa:	7b9c                	ld	a5,48(a5)
ffffffffc02019ac:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc02019ae:	00005517          	auipc	a0,0x5
ffffffffc02019b2:	8fa50513          	addi	a0,a0,-1798 # ffffffffc02062a8 <commands+0x970>
ffffffffc02019b6:	f2afe0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc02019ba:	00008697          	auipc	a3,0x8
ffffffffc02019be:	64668693          	addi	a3,a3,1606 # ffffffffc020a000 <boot_page_table_sv39>
ffffffffc02019c2:	00d93023          	sd	a3,0(s2)
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc02019c6:	c02007b7          	lui	a5,0xc0200
ffffffffc02019ca:	28f6ebe3          	bltu	a3,a5,ffffffffc0202460 <pmm_init+0xbd0>
ffffffffc02019ce:	0009b783          	ld	a5,0(s3)
ffffffffc02019d2:	8e9d                	sub	a3,a3,a5
ffffffffc02019d4:	000a9797          	auipc	a5,0xa9
ffffffffc02019d8:	d2d7ba23          	sd	a3,-716(a5) # ffffffffc02aa708 <boot_pgdir_pa>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02019dc:	100027f3          	csrr	a5,sstatus
ffffffffc02019e0:	8b89                	andi	a5,a5,2
ffffffffc02019e2:	4a079763          	bnez	a5,ffffffffc0201e90 <pmm_init+0x600>
        ret = pmm_manager->nr_free_pages();
ffffffffc02019e6:	000b3783          	ld	a5,0(s6)
ffffffffc02019ea:	779c                	ld	a5,40(a5)
ffffffffc02019ec:	9782                	jalr	a5
ffffffffc02019ee:	842a                	mv	s0,a0
    // so npage is always larger than KMEMSIZE / PGSIZE
    size_t nr_free_store;

    nr_free_store = nr_free_pages();

    assert(npage <= KERNTOP / PGSIZE);
ffffffffc02019f0:	6098                	ld	a4,0(s1)
ffffffffc02019f2:	c80007b7          	lui	a5,0xc8000
ffffffffc02019f6:	83b1                	srli	a5,a5,0xc
ffffffffc02019f8:	66e7e363          	bltu	a5,a4,ffffffffc020205e <pmm_init+0x7ce>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc02019fc:	00093503          	ld	a0,0(s2)
ffffffffc0201a00:	62050f63          	beqz	a0,ffffffffc020203e <pmm_init+0x7ae>
ffffffffc0201a04:	03451793          	slli	a5,a0,0x34
ffffffffc0201a08:	62079b63          	bnez	a5,ffffffffc020203e <pmm_init+0x7ae>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc0201a0c:	4601                	li	a2,0
ffffffffc0201a0e:	4581                	li	a1,0
ffffffffc0201a10:	8c3ff0ef          	jal	ra,ffffffffc02012d2 <get_page>
ffffffffc0201a14:	60051563          	bnez	a0,ffffffffc020201e <pmm_init+0x78e>
ffffffffc0201a18:	100027f3          	csrr	a5,sstatus
ffffffffc0201a1c:	8b89                	andi	a5,a5,2
ffffffffc0201a1e:	44079e63          	bnez	a5,ffffffffc0201e7a <pmm_init+0x5ea>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201a22:	000b3783          	ld	a5,0(s6)
ffffffffc0201a26:	4505                	li	a0,1
ffffffffc0201a28:	6f9c                	ld	a5,24(a5)
ffffffffc0201a2a:	9782                	jalr	a5
ffffffffc0201a2c:	8a2a                	mv	s4,a0

    struct Page *p1, *p2;
    p1 = alloc_page();
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc0201a2e:	00093503          	ld	a0,0(s2)
ffffffffc0201a32:	4681                	li	a3,0
ffffffffc0201a34:	4601                	li	a2,0
ffffffffc0201a36:	85d2                	mv	a1,s4
ffffffffc0201a38:	d63ff0ef          	jal	ra,ffffffffc020179a <page_insert>
ffffffffc0201a3c:	26051ae3          	bnez	a0,ffffffffc02024b0 <pmm_init+0xc20>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc0201a40:	00093503          	ld	a0,0(s2)
ffffffffc0201a44:	4601                	li	a2,0
ffffffffc0201a46:	4581                	li	a1,0
ffffffffc0201a48:	e62ff0ef          	jal	ra,ffffffffc02010aa <get_pte>
ffffffffc0201a4c:	240502e3          	beqz	a0,ffffffffc0202490 <pmm_init+0xc00>
    assert(pte2page(*ptep) == p1);
ffffffffc0201a50:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V))
ffffffffc0201a52:	0017f713          	andi	a4,a5,1
ffffffffc0201a56:	5a070263          	beqz	a4,ffffffffc0201ffa <pmm_init+0x76a>
    if (PPN(pa) >= npage)
ffffffffc0201a5a:	6098                	ld	a4,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0201a5c:	078a                	slli	a5,a5,0x2
ffffffffc0201a5e:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0201a60:	58e7fb63          	bgeu	a5,a4,ffffffffc0201ff6 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0201a64:	000bb683          	ld	a3,0(s7)
ffffffffc0201a68:	fff80637          	lui	a2,0xfff80
ffffffffc0201a6c:	97b2                	add	a5,a5,a2
ffffffffc0201a6e:	079a                	slli	a5,a5,0x6
ffffffffc0201a70:	97b6                	add	a5,a5,a3
ffffffffc0201a72:	14fa17e3          	bne	s4,a5,ffffffffc02023c0 <pmm_init+0xb30>
    assert(page_ref(p1) == 1);
ffffffffc0201a76:	000a2683          	lw	a3,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8bb0>
ffffffffc0201a7a:	4785                	li	a5,1
ffffffffc0201a7c:	12f692e3          	bne	a3,a5,ffffffffc02023a0 <pmm_init+0xb10>

    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc0201a80:	00093503          	ld	a0,0(s2)
ffffffffc0201a84:	77fd                	lui	a5,0xfffff
ffffffffc0201a86:	6114                	ld	a3,0(a0)
ffffffffc0201a88:	068a                	slli	a3,a3,0x2
ffffffffc0201a8a:	8efd                	and	a3,a3,a5
ffffffffc0201a8c:	00c6d613          	srli	a2,a3,0xc
ffffffffc0201a90:	0ee67ce3          	bgeu	a2,a4,ffffffffc0202388 <pmm_init+0xaf8>
ffffffffc0201a94:	0009bc03          	ld	s8,0(s3)
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0201a98:	96e2                	add	a3,a3,s8
ffffffffc0201a9a:	0006ba83          	ld	s5,0(a3)
ffffffffc0201a9e:	0a8a                	slli	s5,s5,0x2
ffffffffc0201aa0:	00fafab3          	and	s5,s5,a5
ffffffffc0201aa4:	00cad793          	srli	a5,s5,0xc
ffffffffc0201aa8:	0ce7f3e3          	bgeu	a5,a4,ffffffffc020236e <pmm_init+0xade>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0201aac:	4601                	li	a2,0
ffffffffc0201aae:	6585                	lui	a1,0x1
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0201ab0:	9ae2                	add	s5,s5,s8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0201ab2:	df8ff0ef          	jal	ra,ffffffffc02010aa <get_pte>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0201ab6:	0aa1                	addi	s5,s5,8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0201ab8:	55551363          	bne	a0,s5,ffffffffc0201ffe <pmm_init+0x76e>
ffffffffc0201abc:	100027f3          	csrr	a5,sstatus
ffffffffc0201ac0:	8b89                	andi	a5,a5,2
ffffffffc0201ac2:	3a079163          	bnez	a5,ffffffffc0201e64 <pmm_init+0x5d4>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201ac6:	000b3783          	ld	a5,0(s6)
ffffffffc0201aca:	4505                	li	a0,1
ffffffffc0201acc:	6f9c                	ld	a5,24(a5)
ffffffffc0201ace:	9782                	jalr	a5
ffffffffc0201ad0:	8c2a                	mv	s8,a0

    p2 = alloc_page();
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc0201ad2:	00093503          	ld	a0,0(s2)
ffffffffc0201ad6:	46d1                	li	a3,20
ffffffffc0201ad8:	6605                	lui	a2,0x1
ffffffffc0201ada:	85e2                	mv	a1,s8
ffffffffc0201adc:	cbfff0ef          	jal	ra,ffffffffc020179a <page_insert>
ffffffffc0201ae0:	060517e3          	bnez	a0,ffffffffc020234e <pmm_init+0xabe>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0201ae4:	00093503          	ld	a0,0(s2)
ffffffffc0201ae8:	4601                	li	a2,0
ffffffffc0201aea:	6585                	lui	a1,0x1
ffffffffc0201aec:	dbeff0ef          	jal	ra,ffffffffc02010aa <get_pte>
ffffffffc0201af0:	02050fe3          	beqz	a0,ffffffffc020232e <pmm_init+0xa9e>
    assert(*ptep & PTE_U);
ffffffffc0201af4:	611c                	ld	a5,0(a0)
ffffffffc0201af6:	0107f713          	andi	a4,a5,16
ffffffffc0201afa:	7c070e63          	beqz	a4,ffffffffc02022d6 <pmm_init+0xa46>
    assert(*ptep & PTE_W);
ffffffffc0201afe:	8b91                	andi	a5,a5,4
ffffffffc0201b00:	7a078b63          	beqz	a5,ffffffffc02022b6 <pmm_init+0xa26>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc0201b04:	00093503          	ld	a0,0(s2)
ffffffffc0201b08:	611c                	ld	a5,0(a0)
ffffffffc0201b0a:	8bc1                	andi	a5,a5,16
ffffffffc0201b0c:	78078563          	beqz	a5,ffffffffc0202296 <pmm_init+0xa06>
    assert(page_ref(p2) == 1);
ffffffffc0201b10:	000c2703          	lw	a4,0(s8)
ffffffffc0201b14:	4785                	li	a5,1
ffffffffc0201b16:	76f71063          	bne	a4,a5,ffffffffc0202276 <pmm_init+0x9e6>

    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc0201b1a:	4681                	li	a3,0
ffffffffc0201b1c:	6605                	lui	a2,0x1
ffffffffc0201b1e:	85d2                	mv	a1,s4
ffffffffc0201b20:	c7bff0ef          	jal	ra,ffffffffc020179a <page_insert>
ffffffffc0201b24:	72051963          	bnez	a0,ffffffffc0202256 <pmm_init+0x9c6>
    assert(page_ref(p1) == 2);
ffffffffc0201b28:	000a2703          	lw	a4,0(s4)
ffffffffc0201b2c:	4789                	li	a5,2
ffffffffc0201b2e:	70f71463          	bne	a4,a5,ffffffffc0202236 <pmm_init+0x9a6>
    assert(page_ref(p2) == 0);
ffffffffc0201b32:	000c2783          	lw	a5,0(s8)
ffffffffc0201b36:	6e079063          	bnez	a5,ffffffffc0202216 <pmm_init+0x986>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0201b3a:	00093503          	ld	a0,0(s2)
ffffffffc0201b3e:	4601                	li	a2,0
ffffffffc0201b40:	6585                	lui	a1,0x1
ffffffffc0201b42:	d68ff0ef          	jal	ra,ffffffffc02010aa <get_pte>
ffffffffc0201b46:	6a050863          	beqz	a0,ffffffffc02021f6 <pmm_init+0x966>
    assert(pte2page(*ptep) == p1);
ffffffffc0201b4a:	6118                	ld	a4,0(a0)
    if (!(pte & PTE_V))
ffffffffc0201b4c:	00177793          	andi	a5,a4,1
ffffffffc0201b50:	4a078563          	beqz	a5,ffffffffc0201ffa <pmm_init+0x76a>
    if (PPN(pa) >= npage)
ffffffffc0201b54:	6094                	ld	a3,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc0201b56:	00271793          	slli	a5,a4,0x2
ffffffffc0201b5a:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0201b5c:	48d7fd63          	bgeu	a5,a3,ffffffffc0201ff6 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0201b60:	000bb683          	ld	a3,0(s7)
ffffffffc0201b64:	fff80ab7          	lui	s5,0xfff80
ffffffffc0201b68:	97d6                	add	a5,a5,s5
ffffffffc0201b6a:	079a                	slli	a5,a5,0x6
ffffffffc0201b6c:	97b6                	add	a5,a5,a3
ffffffffc0201b6e:	66fa1463          	bne	s4,a5,ffffffffc02021d6 <pmm_init+0x946>
    assert((*ptep & PTE_U) == 0);
ffffffffc0201b72:	8b41                	andi	a4,a4,16
ffffffffc0201b74:	64071163          	bnez	a4,ffffffffc02021b6 <pmm_init+0x926>

    page_remove(boot_pgdir_va, 0x0);
ffffffffc0201b78:	00093503          	ld	a0,0(s2)
ffffffffc0201b7c:	4581                	li	a1,0
ffffffffc0201b7e:	b81ff0ef          	jal	ra,ffffffffc02016fe <page_remove>
    assert(page_ref(p1) == 1);
ffffffffc0201b82:	000a2c83          	lw	s9,0(s4)
ffffffffc0201b86:	4785                	li	a5,1
ffffffffc0201b88:	60fc9763          	bne	s9,a5,ffffffffc0202196 <pmm_init+0x906>
    assert(page_ref(p2) == 0);
ffffffffc0201b8c:	000c2783          	lw	a5,0(s8)
ffffffffc0201b90:	5e079363          	bnez	a5,ffffffffc0202176 <pmm_init+0x8e6>

    page_remove(boot_pgdir_va, PGSIZE);
ffffffffc0201b94:	00093503          	ld	a0,0(s2)
ffffffffc0201b98:	6585                	lui	a1,0x1
ffffffffc0201b9a:	b65ff0ef          	jal	ra,ffffffffc02016fe <page_remove>
    assert(page_ref(p1) == 0);
ffffffffc0201b9e:	000a2783          	lw	a5,0(s4)
ffffffffc0201ba2:	52079a63          	bnez	a5,ffffffffc02020d6 <pmm_init+0x846>
    assert(page_ref(p2) == 0);
ffffffffc0201ba6:	000c2783          	lw	a5,0(s8)
ffffffffc0201baa:	50079663          	bnez	a5,ffffffffc02020b6 <pmm_init+0x826>

    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0201bae:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0201bb2:	608c                	ld	a1,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0201bb4:	000a3683          	ld	a3,0(s4)
ffffffffc0201bb8:	068a                	slli	a3,a3,0x2
ffffffffc0201bba:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage)
ffffffffc0201bbc:	42b6fd63          	bgeu	a3,a1,ffffffffc0201ff6 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0201bc0:	000bb503          	ld	a0,0(s7)
ffffffffc0201bc4:	96d6                	add	a3,a3,s5
ffffffffc0201bc6:	069a                	slli	a3,a3,0x6
    return page->ref;
ffffffffc0201bc8:	00d507b3          	add	a5,a0,a3
ffffffffc0201bcc:	439c                	lw	a5,0(a5)
ffffffffc0201bce:	4d979463          	bne	a5,s9,ffffffffc0202096 <pmm_init+0x806>
    return page - pages + nbase;
ffffffffc0201bd2:	8699                	srai	a3,a3,0x6
ffffffffc0201bd4:	00080637          	lui	a2,0x80
ffffffffc0201bd8:	96b2                	add	a3,a3,a2
    return KADDR(page2pa(page));
ffffffffc0201bda:	00c69713          	slli	a4,a3,0xc
ffffffffc0201bde:	8331                	srli	a4,a4,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0201be0:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0201be2:	48b77e63          	bgeu	a4,a1,ffffffffc020207e <pmm_init+0x7ee>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
    free_page(pde2page(pd0[0]));
ffffffffc0201be6:	0009b703          	ld	a4,0(s3)
ffffffffc0201bea:	96ba                	add	a3,a3,a4
    return pa2page(PDE_ADDR(pde));
ffffffffc0201bec:	629c                	ld	a5,0(a3)
ffffffffc0201bee:	078a                	slli	a5,a5,0x2
ffffffffc0201bf0:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0201bf2:	40b7f263          	bgeu	a5,a1,ffffffffc0201ff6 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0201bf6:	8f91                	sub	a5,a5,a2
ffffffffc0201bf8:	079a                	slli	a5,a5,0x6
ffffffffc0201bfa:	953e                	add	a0,a0,a5
ffffffffc0201bfc:	100027f3          	csrr	a5,sstatus
ffffffffc0201c00:	8b89                	andi	a5,a5,2
ffffffffc0201c02:	30079963          	bnez	a5,ffffffffc0201f14 <pmm_init+0x684>
        pmm_manager->free_pages(base, n);
ffffffffc0201c06:	000b3783          	ld	a5,0(s6)
ffffffffc0201c0a:	4585                	li	a1,1
ffffffffc0201c0c:	739c                	ld	a5,32(a5)
ffffffffc0201c0e:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0201c10:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage)
ffffffffc0201c14:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0201c16:	078a                	slli	a5,a5,0x2
ffffffffc0201c18:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0201c1a:	3ce7fe63          	bgeu	a5,a4,ffffffffc0201ff6 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0201c1e:	000bb503          	ld	a0,0(s7)
ffffffffc0201c22:	fff80737          	lui	a4,0xfff80
ffffffffc0201c26:	97ba                	add	a5,a5,a4
ffffffffc0201c28:	079a                	slli	a5,a5,0x6
ffffffffc0201c2a:	953e                	add	a0,a0,a5
ffffffffc0201c2c:	100027f3          	csrr	a5,sstatus
ffffffffc0201c30:	8b89                	andi	a5,a5,2
ffffffffc0201c32:	2c079563          	bnez	a5,ffffffffc0201efc <pmm_init+0x66c>
ffffffffc0201c36:	000b3783          	ld	a5,0(s6)
ffffffffc0201c3a:	4585                	li	a1,1
ffffffffc0201c3c:	739c                	ld	a5,32(a5)
ffffffffc0201c3e:	9782                	jalr	a5
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc0201c40:	00093783          	ld	a5,0(s2)
ffffffffc0201c44:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fd548a4>
    asm volatile("sfence.vma");
ffffffffc0201c48:	12000073          	sfence.vma
ffffffffc0201c4c:	100027f3          	csrr	a5,sstatus
ffffffffc0201c50:	8b89                	andi	a5,a5,2
ffffffffc0201c52:	28079b63          	bnez	a5,ffffffffc0201ee8 <pmm_init+0x658>
        ret = pmm_manager->nr_free_pages();
ffffffffc0201c56:	000b3783          	ld	a5,0(s6)
ffffffffc0201c5a:	779c                	ld	a5,40(a5)
ffffffffc0201c5c:	9782                	jalr	a5
ffffffffc0201c5e:	8a2a                	mv	s4,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0201c60:	4b441b63          	bne	s0,s4,ffffffffc0202116 <pmm_init+0x886>

    cprintf("check_pgdir() succeeded!\n");
ffffffffc0201c64:	00005517          	auipc	a0,0x5
ffffffffc0201c68:	96c50513          	addi	a0,a0,-1684 # ffffffffc02065d0 <commands+0xc98>
ffffffffc0201c6c:	c74fe0ef          	jal	ra,ffffffffc02000e0 <cprintf>
ffffffffc0201c70:	100027f3          	csrr	a5,sstatus
ffffffffc0201c74:	8b89                	andi	a5,a5,2
ffffffffc0201c76:	24079f63          	bnez	a5,ffffffffc0201ed4 <pmm_init+0x644>
        ret = pmm_manager->nr_free_pages();
ffffffffc0201c7a:	000b3783          	ld	a5,0(s6)
ffffffffc0201c7e:	779c                	ld	a5,40(a5)
ffffffffc0201c80:	9782                	jalr	a5
ffffffffc0201c82:	8c2a                	mv	s8,a0
    pte_t *ptep;
    int i;

    nr_free_store = nr_free_pages();

    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0201c84:	6098                	ld	a4,0(s1)
ffffffffc0201c86:	c0200437          	lui	s0,0xc0200
    {
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0201c8a:	7afd                	lui	s5,0xfffff
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0201c8c:	00c71793          	slli	a5,a4,0xc
ffffffffc0201c90:	6a05                	lui	s4,0x1
ffffffffc0201c92:	02f47c63          	bgeu	s0,a5,ffffffffc0201cca <pmm_init+0x43a>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0201c96:	00c45793          	srli	a5,s0,0xc
ffffffffc0201c9a:	00093503          	ld	a0,0(s2)
ffffffffc0201c9e:	2ee7ff63          	bgeu	a5,a4,ffffffffc0201f9c <pmm_init+0x70c>
ffffffffc0201ca2:	0009b583          	ld	a1,0(s3)
ffffffffc0201ca6:	4601                	li	a2,0
ffffffffc0201ca8:	95a2                	add	a1,a1,s0
ffffffffc0201caa:	c00ff0ef          	jal	ra,ffffffffc02010aa <get_pte>
ffffffffc0201cae:	32050463          	beqz	a0,ffffffffc0201fd6 <pmm_init+0x746>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0201cb2:	611c                	ld	a5,0(a0)
ffffffffc0201cb4:	078a                	slli	a5,a5,0x2
ffffffffc0201cb6:	0157f7b3          	and	a5,a5,s5
ffffffffc0201cba:	2e879e63          	bne	a5,s0,ffffffffc0201fb6 <pmm_init+0x726>
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0201cbe:	6098                	ld	a4,0(s1)
ffffffffc0201cc0:	9452                	add	s0,s0,s4
ffffffffc0201cc2:	00c71793          	slli	a5,a4,0xc
ffffffffc0201cc6:	fcf468e3          	bltu	s0,a5,ffffffffc0201c96 <pmm_init+0x406>
    }

    assert(boot_pgdir_va[0] == 0);
ffffffffc0201cca:	00093783          	ld	a5,0(s2)
ffffffffc0201cce:	639c                	ld	a5,0(a5)
ffffffffc0201cd0:	42079363          	bnez	a5,ffffffffc02020f6 <pmm_init+0x866>
ffffffffc0201cd4:	100027f3          	csrr	a5,sstatus
ffffffffc0201cd8:	8b89                	andi	a5,a5,2
ffffffffc0201cda:	24079963          	bnez	a5,ffffffffc0201f2c <pmm_init+0x69c>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201cde:	000b3783          	ld	a5,0(s6)
ffffffffc0201ce2:	4505                	li	a0,1
ffffffffc0201ce4:	6f9c                	ld	a5,24(a5)
ffffffffc0201ce6:	9782                	jalr	a5
ffffffffc0201ce8:	8a2a                	mv	s4,a0

    struct Page *p;
    p = alloc_page();
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0201cea:	00093503          	ld	a0,0(s2)
ffffffffc0201cee:	4699                	li	a3,6
ffffffffc0201cf0:	10000613          	li	a2,256
ffffffffc0201cf4:	85d2                	mv	a1,s4
ffffffffc0201cf6:	aa5ff0ef          	jal	ra,ffffffffc020179a <page_insert>
ffffffffc0201cfa:	44051e63          	bnez	a0,ffffffffc0202156 <pmm_init+0x8c6>
    assert(page_ref(p) == 1);
ffffffffc0201cfe:	000a2703          	lw	a4,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8bb0>
ffffffffc0201d02:	4785                	li	a5,1
ffffffffc0201d04:	42f71963          	bne	a4,a5,ffffffffc0202136 <pmm_init+0x8a6>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0201d08:	00093503          	ld	a0,0(s2)
ffffffffc0201d0c:	6405                	lui	s0,0x1
ffffffffc0201d0e:	4699                	li	a3,6
ffffffffc0201d10:	10040613          	addi	a2,s0,256 # 1100 <_binary_obj___user_faultread_out_size-0x8ab0>
ffffffffc0201d14:	85d2                	mv	a1,s4
ffffffffc0201d16:	a85ff0ef          	jal	ra,ffffffffc020179a <page_insert>
ffffffffc0201d1a:	72051363          	bnez	a0,ffffffffc0202440 <pmm_init+0xbb0>
    assert(page_ref(p) == 2);
ffffffffc0201d1e:	000a2703          	lw	a4,0(s4)
ffffffffc0201d22:	4789                	li	a5,2
ffffffffc0201d24:	6ef71e63          	bne	a4,a5,ffffffffc0202420 <pmm_init+0xb90>

    const char *str = "ucore: Hello world!!";
    strcpy((void *)0x100, str);
ffffffffc0201d28:	00005597          	auipc	a1,0x5
ffffffffc0201d2c:	9f058593          	addi	a1,a1,-1552 # ffffffffc0206718 <commands+0xde0>
ffffffffc0201d30:	10000513          	li	a0,256
ffffffffc0201d34:	4bc030ef          	jal	ra,ffffffffc02051f0 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0201d38:	10040593          	addi	a1,s0,256
ffffffffc0201d3c:	10000513          	li	a0,256
ffffffffc0201d40:	4c2030ef          	jal	ra,ffffffffc0205202 <strcmp>
ffffffffc0201d44:	6a051e63          	bnez	a0,ffffffffc0202400 <pmm_init+0xb70>
    return page - pages + nbase;
ffffffffc0201d48:	000bb683          	ld	a3,0(s7)
ffffffffc0201d4c:	00080737          	lui	a4,0x80
    return KADDR(page2pa(page));
ffffffffc0201d50:	547d                	li	s0,-1
    return page - pages + nbase;
ffffffffc0201d52:	40da06b3          	sub	a3,s4,a3
ffffffffc0201d56:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0201d58:	609c                	ld	a5,0(s1)
    return page - pages + nbase;
ffffffffc0201d5a:	96ba                	add	a3,a3,a4
    return KADDR(page2pa(page));
ffffffffc0201d5c:	8031                	srli	s0,s0,0xc
ffffffffc0201d5e:	0086f733          	and	a4,a3,s0
    return page2ppn(page) << PGSHIFT;
ffffffffc0201d62:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0201d64:	30f77d63          	bgeu	a4,a5,ffffffffc020207e <pmm_init+0x7ee>

    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0201d68:	0009b783          	ld	a5,0(s3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0201d6c:	10000513          	li	a0,256
    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc0201d70:	96be                	add	a3,a3,a5
ffffffffc0201d72:	10068023          	sb	zero,256(a3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc0201d76:	444030ef          	jal	ra,ffffffffc02051ba <strlen>
ffffffffc0201d7a:	66051363          	bnez	a0,ffffffffc02023e0 <pmm_init+0xb50>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
ffffffffc0201d7e:	00093a83          	ld	s5,0(s2)
    if (PPN(pa) >= npage)
ffffffffc0201d82:	609c                	ld	a5,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0201d84:	000ab683          	ld	a3,0(s5) # fffffffffffff000 <end+0x3fd548a4>
ffffffffc0201d88:	068a                	slli	a3,a3,0x2
ffffffffc0201d8a:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage)
ffffffffc0201d8c:	26f6f563          	bgeu	a3,a5,ffffffffc0201ff6 <pmm_init+0x766>
    return KADDR(page2pa(page));
ffffffffc0201d90:	8c75                	and	s0,s0,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0201d92:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0201d94:	2ef47563          	bgeu	s0,a5,ffffffffc020207e <pmm_init+0x7ee>
ffffffffc0201d98:	0009b403          	ld	s0,0(s3)
ffffffffc0201d9c:	9436                	add	s0,s0,a3
ffffffffc0201d9e:	100027f3          	csrr	a5,sstatus
ffffffffc0201da2:	8b89                	andi	a5,a5,2
ffffffffc0201da4:	1e079163          	bnez	a5,ffffffffc0201f86 <pmm_init+0x6f6>
        pmm_manager->free_pages(base, n);
ffffffffc0201da8:	000b3783          	ld	a5,0(s6)
ffffffffc0201dac:	4585                	li	a1,1
ffffffffc0201dae:	8552                	mv	a0,s4
ffffffffc0201db0:	739c                	ld	a5,32(a5)
ffffffffc0201db2:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0201db4:	601c                	ld	a5,0(s0)
    if (PPN(pa) >= npage)
ffffffffc0201db6:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0201db8:	078a                	slli	a5,a5,0x2
ffffffffc0201dba:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0201dbc:	22e7fd63          	bgeu	a5,a4,ffffffffc0201ff6 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0201dc0:	000bb503          	ld	a0,0(s7)
ffffffffc0201dc4:	fff80737          	lui	a4,0xfff80
ffffffffc0201dc8:	97ba                	add	a5,a5,a4
ffffffffc0201dca:	079a                	slli	a5,a5,0x6
ffffffffc0201dcc:	953e                	add	a0,a0,a5
ffffffffc0201dce:	100027f3          	csrr	a5,sstatus
ffffffffc0201dd2:	8b89                	andi	a5,a5,2
ffffffffc0201dd4:	18079d63          	bnez	a5,ffffffffc0201f6e <pmm_init+0x6de>
ffffffffc0201dd8:	000b3783          	ld	a5,0(s6)
ffffffffc0201ddc:	4585                	li	a1,1
ffffffffc0201dde:	739c                	ld	a5,32(a5)
ffffffffc0201de0:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc0201de2:	000ab783          	ld	a5,0(s5)
    if (PPN(pa) >= npage)
ffffffffc0201de6:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0201de8:	078a                	slli	a5,a5,0x2
ffffffffc0201dea:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0201dec:	20e7f563          	bgeu	a5,a4,ffffffffc0201ff6 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0201df0:	000bb503          	ld	a0,0(s7)
ffffffffc0201df4:	fff80737          	lui	a4,0xfff80
ffffffffc0201df8:	97ba                	add	a5,a5,a4
ffffffffc0201dfa:	079a                	slli	a5,a5,0x6
ffffffffc0201dfc:	953e                	add	a0,a0,a5
ffffffffc0201dfe:	100027f3          	csrr	a5,sstatus
ffffffffc0201e02:	8b89                	andi	a5,a5,2
ffffffffc0201e04:	14079963          	bnez	a5,ffffffffc0201f56 <pmm_init+0x6c6>
ffffffffc0201e08:	000b3783          	ld	a5,0(s6)
ffffffffc0201e0c:	4585                	li	a1,1
ffffffffc0201e0e:	739c                	ld	a5,32(a5)
ffffffffc0201e10:	9782                	jalr	a5
    free_page(p);
    free_page(pde2page(pd0[0]));
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc0201e12:	00093783          	ld	a5,0(s2)
ffffffffc0201e16:	0007b023          	sd	zero,0(a5)
    asm volatile("sfence.vma");
ffffffffc0201e1a:	12000073          	sfence.vma
ffffffffc0201e1e:	100027f3          	csrr	a5,sstatus
ffffffffc0201e22:	8b89                	andi	a5,a5,2
ffffffffc0201e24:	10079f63          	bnez	a5,ffffffffc0201f42 <pmm_init+0x6b2>
        ret = pmm_manager->nr_free_pages();
ffffffffc0201e28:	000b3783          	ld	a5,0(s6)
ffffffffc0201e2c:	779c                	ld	a5,40(a5)
ffffffffc0201e2e:	9782                	jalr	a5
ffffffffc0201e30:	842a                	mv	s0,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc0201e32:	4c8c1e63          	bne	s8,s0,ffffffffc020230e <pmm_init+0xa7e>

    cprintf("check_boot_pgdir() succeeded!\n");
ffffffffc0201e36:	00005517          	auipc	a0,0x5
ffffffffc0201e3a:	95a50513          	addi	a0,a0,-1702 # ffffffffc0206790 <commands+0xe58>
ffffffffc0201e3e:	aa2fe0ef          	jal	ra,ffffffffc02000e0 <cprintf>
}
ffffffffc0201e42:	7406                	ld	s0,96(sp)
ffffffffc0201e44:	70a6                	ld	ra,104(sp)
ffffffffc0201e46:	64e6                	ld	s1,88(sp)
ffffffffc0201e48:	6946                	ld	s2,80(sp)
ffffffffc0201e4a:	69a6                	ld	s3,72(sp)
ffffffffc0201e4c:	6a06                	ld	s4,64(sp)
ffffffffc0201e4e:	7ae2                	ld	s5,56(sp)
ffffffffc0201e50:	7b42                	ld	s6,48(sp)
ffffffffc0201e52:	7ba2                	ld	s7,40(sp)
ffffffffc0201e54:	7c02                	ld	s8,32(sp)
ffffffffc0201e56:	6ce2                	ld	s9,24(sp)
ffffffffc0201e58:	6165                	addi	sp,sp,112
    kmalloc_init();
ffffffffc0201e5a:	2d40106f          	j	ffffffffc020312e <kmalloc_init>
    npage = maxpa / PGSIZE;
ffffffffc0201e5e:	c80007b7          	lui	a5,0xc8000
ffffffffc0201e62:	bc7d                	j	ffffffffc0201920 <pmm_init+0x90>
        intr_disable();
ffffffffc0201e64:	b57fe0ef          	jal	ra,ffffffffc02009ba <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201e68:	000b3783          	ld	a5,0(s6)
ffffffffc0201e6c:	4505                	li	a0,1
ffffffffc0201e6e:	6f9c                	ld	a5,24(a5)
ffffffffc0201e70:	9782                	jalr	a5
ffffffffc0201e72:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0201e74:	b41fe0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
ffffffffc0201e78:	b9a9                	j	ffffffffc0201ad2 <pmm_init+0x242>
        intr_disable();
ffffffffc0201e7a:	b41fe0ef          	jal	ra,ffffffffc02009ba <intr_disable>
ffffffffc0201e7e:	000b3783          	ld	a5,0(s6)
ffffffffc0201e82:	4505                	li	a0,1
ffffffffc0201e84:	6f9c                	ld	a5,24(a5)
ffffffffc0201e86:	9782                	jalr	a5
ffffffffc0201e88:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0201e8a:	b2bfe0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
ffffffffc0201e8e:	b645                	j	ffffffffc0201a2e <pmm_init+0x19e>
        intr_disable();
ffffffffc0201e90:	b2bfe0ef          	jal	ra,ffffffffc02009ba <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0201e94:	000b3783          	ld	a5,0(s6)
ffffffffc0201e98:	779c                	ld	a5,40(a5)
ffffffffc0201e9a:	9782                	jalr	a5
ffffffffc0201e9c:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0201e9e:	b17fe0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
ffffffffc0201ea2:	b6b9                	j	ffffffffc02019f0 <pmm_init+0x160>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc0201ea4:	6705                	lui	a4,0x1
ffffffffc0201ea6:	177d                	addi	a4,a4,-1
ffffffffc0201ea8:	96ba                	add	a3,a3,a4
ffffffffc0201eaa:	8ff5                	and	a5,a5,a3
    if (PPN(pa) >= npage)
ffffffffc0201eac:	00c7d713          	srli	a4,a5,0xc
ffffffffc0201eb0:	14a77363          	bgeu	a4,a0,ffffffffc0201ff6 <pmm_init+0x766>
    pmm_manager->init_memmap(base, n);
ffffffffc0201eb4:	000b3683          	ld	a3,0(s6)
    return &pages[PPN(pa) - nbase];
ffffffffc0201eb8:	fff80537          	lui	a0,0xfff80
ffffffffc0201ebc:	972a                	add	a4,a4,a0
ffffffffc0201ebe:	6a94                	ld	a3,16(a3)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc0201ec0:	8c1d                	sub	s0,s0,a5
ffffffffc0201ec2:	00671513          	slli	a0,a4,0x6
    pmm_manager->init_memmap(base, n);
ffffffffc0201ec6:	00c45593          	srli	a1,s0,0xc
ffffffffc0201eca:	9532                	add	a0,a0,a2
ffffffffc0201ecc:	9682                	jalr	a3
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc0201ece:	0009b583          	ld	a1,0(s3)
}
ffffffffc0201ed2:	b4c1                	j	ffffffffc0201992 <pmm_init+0x102>
        intr_disable();
ffffffffc0201ed4:	ae7fe0ef          	jal	ra,ffffffffc02009ba <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0201ed8:	000b3783          	ld	a5,0(s6)
ffffffffc0201edc:	779c                	ld	a5,40(a5)
ffffffffc0201ede:	9782                	jalr	a5
ffffffffc0201ee0:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc0201ee2:	ad3fe0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
ffffffffc0201ee6:	bb79                	j	ffffffffc0201c84 <pmm_init+0x3f4>
        intr_disable();
ffffffffc0201ee8:	ad3fe0ef          	jal	ra,ffffffffc02009ba <intr_disable>
ffffffffc0201eec:	000b3783          	ld	a5,0(s6)
ffffffffc0201ef0:	779c                	ld	a5,40(a5)
ffffffffc0201ef2:	9782                	jalr	a5
ffffffffc0201ef4:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0201ef6:	abffe0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
ffffffffc0201efa:	b39d                	j	ffffffffc0201c60 <pmm_init+0x3d0>
ffffffffc0201efc:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0201efe:	abdfe0ef          	jal	ra,ffffffffc02009ba <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0201f02:	000b3783          	ld	a5,0(s6)
ffffffffc0201f06:	6522                	ld	a0,8(sp)
ffffffffc0201f08:	4585                	li	a1,1
ffffffffc0201f0a:	739c                	ld	a5,32(a5)
ffffffffc0201f0c:	9782                	jalr	a5
        intr_enable();
ffffffffc0201f0e:	aa7fe0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
ffffffffc0201f12:	b33d                	j	ffffffffc0201c40 <pmm_init+0x3b0>
ffffffffc0201f14:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0201f16:	aa5fe0ef          	jal	ra,ffffffffc02009ba <intr_disable>
ffffffffc0201f1a:	000b3783          	ld	a5,0(s6)
ffffffffc0201f1e:	6522                	ld	a0,8(sp)
ffffffffc0201f20:	4585                	li	a1,1
ffffffffc0201f22:	739c                	ld	a5,32(a5)
ffffffffc0201f24:	9782                	jalr	a5
        intr_enable();
ffffffffc0201f26:	a8ffe0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
ffffffffc0201f2a:	b1dd                	j	ffffffffc0201c10 <pmm_init+0x380>
        intr_disable();
ffffffffc0201f2c:	a8ffe0ef          	jal	ra,ffffffffc02009ba <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201f30:	000b3783          	ld	a5,0(s6)
ffffffffc0201f34:	4505                	li	a0,1
ffffffffc0201f36:	6f9c                	ld	a5,24(a5)
ffffffffc0201f38:	9782                	jalr	a5
ffffffffc0201f3a:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0201f3c:	a79fe0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
ffffffffc0201f40:	b36d                	j	ffffffffc0201cea <pmm_init+0x45a>
        intr_disable();
ffffffffc0201f42:	a79fe0ef          	jal	ra,ffffffffc02009ba <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0201f46:	000b3783          	ld	a5,0(s6)
ffffffffc0201f4a:	779c                	ld	a5,40(a5)
ffffffffc0201f4c:	9782                	jalr	a5
ffffffffc0201f4e:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0201f50:	a65fe0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
ffffffffc0201f54:	bdf9                	j	ffffffffc0201e32 <pmm_init+0x5a2>
ffffffffc0201f56:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0201f58:	a63fe0ef          	jal	ra,ffffffffc02009ba <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0201f5c:	000b3783          	ld	a5,0(s6)
ffffffffc0201f60:	6522                	ld	a0,8(sp)
ffffffffc0201f62:	4585                	li	a1,1
ffffffffc0201f64:	739c                	ld	a5,32(a5)
ffffffffc0201f66:	9782                	jalr	a5
        intr_enable();
ffffffffc0201f68:	a4dfe0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
ffffffffc0201f6c:	b55d                	j	ffffffffc0201e12 <pmm_init+0x582>
ffffffffc0201f6e:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0201f70:	a4bfe0ef          	jal	ra,ffffffffc02009ba <intr_disable>
ffffffffc0201f74:	000b3783          	ld	a5,0(s6)
ffffffffc0201f78:	6522                	ld	a0,8(sp)
ffffffffc0201f7a:	4585                	li	a1,1
ffffffffc0201f7c:	739c                	ld	a5,32(a5)
ffffffffc0201f7e:	9782                	jalr	a5
        intr_enable();
ffffffffc0201f80:	a35fe0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
ffffffffc0201f84:	bdb9                	j	ffffffffc0201de2 <pmm_init+0x552>
        intr_disable();
ffffffffc0201f86:	a35fe0ef          	jal	ra,ffffffffc02009ba <intr_disable>
ffffffffc0201f8a:	000b3783          	ld	a5,0(s6)
ffffffffc0201f8e:	4585                	li	a1,1
ffffffffc0201f90:	8552                	mv	a0,s4
ffffffffc0201f92:	739c                	ld	a5,32(a5)
ffffffffc0201f94:	9782                	jalr	a5
        intr_enable();
ffffffffc0201f96:	a1ffe0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
ffffffffc0201f9a:	bd29                	j	ffffffffc0201db4 <pmm_init+0x524>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0201f9c:	86a2                	mv	a3,s0
ffffffffc0201f9e:	00004617          	auipc	a2,0x4
ffffffffc0201fa2:	1ba60613          	addi	a2,a2,442 # ffffffffc0206158 <commands+0x820>
ffffffffc0201fa6:	24e00593          	li	a1,590
ffffffffc0201faa:	00004517          	auipc	a0,0x4
ffffffffc0201fae:	1d650513          	addi	a0,a0,470 # ffffffffc0206180 <commands+0x848>
ffffffffc0201fb2:	a6cfe0ef          	jal	ra,ffffffffc020021e <__panic>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0201fb6:	00004697          	auipc	a3,0x4
ffffffffc0201fba:	67a68693          	addi	a3,a3,1658 # ffffffffc0206630 <commands+0xcf8>
ffffffffc0201fbe:	00004617          	auipc	a2,0x4
ffffffffc0201fc2:	20260613          	addi	a2,a2,514 # ffffffffc02061c0 <commands+0x888>
ffffffffc0201fc6:	24f00593          	li	a1,591
ffffffffc0201fca:	00004517          	auipc	a0,0x4
ffffffffc0201fce:	1b650513          	addi	a0,a0,438 # ffffffffc0206180 <commands+0x848>
ffffffffc0201fd2:	a4cfe0ef          	jal	ra,ffffffffc020021e <__panic>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0201fd6:	00004697          	auipc	a3,0x4
ffffffffc0201fda:	61a68693          	addi	a3,a3,1562 # ffffffffc02065f0 <commands+0xcb8>
ffffffffc0201fde:	00004617          	auipc	a2,0x4
ffffffffc0201fe2:	1e260613          	addi	a2,a2,482 # ffffffffc02061c0 <commands+0x888>
ffffffffc0201fe6:	24e00593          	li	a1,590
ffffffffc0201fea:	00004517          	auipc	a0,0x4
ffffffffc0201fee:	19650513          	addi	a0,a0,406 # ffffffffc0206180 <commands+0x848>
ffffffffc0201ff2:	a2cfe0ef          	jal	ra,ffffffffc020021e <__panic>
ffffffffc0201ff6:	fc5fe0ef          	jal	ra,ffffffffc0200fba <pa2page.part.0>
ffffffffc0201ffa:	fddfe0ef          	jal	ra,ffffffffc0200fd6 <pte2page.part.0>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0201ffe:	00004697          	auipc	a3,0x4
ffffffffc0202002:	3ea68693          	addi	a3,a3,1002 # ffffffffc02063e8 <commands+0xab0>
ffffffffc0202006:	00004617          	auipc	a2,0x4
ffffffffc020200a:	1ba60613          	addi	a2,a2,442 # ffffffffc02061c0 <commands+0x888>
ffffffffc020200e:	21e00593          	li	a1,542
ffffffffc0202012:	00004517          	auipc	a0,0x4
ffffffffc0202016:	16e50513          	addi	a0,a0,366 # ffffffffc0206180 <commands+0x848>
ffffffffc020201a:	a04fe0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc020201e:	00004697          	auipc	a3,0x4
ffffffffc0202022:	30a68693          	addi	a3,a3,778 # ffffffffc0206328 <commands+0x9f0>
ffffffffc0202026:	00004617          	auipc	a2,0x4
ffffffffc020202a:	19a60613          	addi	a2,a2,410 # ffffffffc02061c0 <commands+0x888>
ffffffffc020202e:	21100593          	li	a1,529
ffffffffc0202032:	00004517          	auipc	a0,0x4
ffffffffc0202036:	14e50513          	addi	a0,a0,334 # ffffffffc0206180 <commands+0x848>
ffffffffc020203a:	9e4fe0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc020203e:	00004697          	auipc	a3,0x4
ffffffffc0202042:	2aa68693          	addi	a3,a3,682 # ffffffffc02062e8 <commands+0x9b0>
ffffffffc0202046:	00004617          	auipc	a2,0x4
ffffffffc020204a:	17a60613          	addi	a2,a2,378 # ffffffffc02061c0 <commands+0x888>
ffffffffc020204e:	21000593          	li	a1,528
ffffffffc0202052:	00004517          	auipc	a0,0x4
ffffffffc0202056:	12e50513          	addi	a0,a0,302 # ffffffffc0206180 <commands+0x848>
ffffffffc020205a:	9c4fe0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(npage <= KERNTOP / PGSIZE);
ffffffffc020205e:	00004697          	auipc	a3,0x4
ffffffffc0202062:	26a68693          	addi	a3,a3,618 # ffffffffc02062c8 <commands+0x990>
ffffffffc0202066:	00004617          	auipc	a2,0x4
ffffffffc020206a:	15a60613          	addi	a2,a2,346 # ffffffffc02061c0 <commands+0x888>
ffffffffc020206e:	20f00593          	li	a1,527
ffffffffc0202072:	00004517          	auipc	a0,0x4
ffffffffc0202076:	10e50513          	addi	a0,a0,270 # ffffffffc0206180 <commands+0x848>
ffffffffc020207a:	9a4fe0ef          	jal	ra,ffffffffc020021e <__panic>
    return KADDR(page2pa(page));
ffffffffc020207e:	00004617          	auipc	a2,0x4
ffffffffc0202082:	0da60613          	addi	a2,a2,218 # ffffffffc0206158 <commands+0x820>
ffffffffc0202086:	07100593          	li	a1,113
ffffffffc020208a:	00004517          	auipc	a0,0x4
ffffffffc020208e:	09650513          	addi	a0,a0,150 # ffffffffc0206120 <commands+0x7e8>
ffffffffc0202092:	98cfe0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0202096:	00004697          	auipc	a3,0x4
ffffffffc020209a:	4e268693          	addi	a3,a3,1250 # ffffffffc0206578 <commands+0xc40>
ffffffffc020209e:	00004617          	auipc	a2,0x4
ffffffffc02020a2:	12260613          	addi	a2,a2,290 # ffffffffc02061c0 <commands+0x888>
ffffffffc02020a6:	23700593          	li	a1,567
ffffffffc02020aa:	00004517          	auipc	a0,0x4
ffffffffc02020ae:	0d650513          	addi	a0,a0,214 # ffffffffc0206180 <commands+0x848>
ffffffffc02020b2:	96cfe0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(page_ref(p2) == 0);
ffffffffc02020b6:	00004697          	auipc	a3,0x4
ffffffffc02020ba:	47a68693          	addi	a3,a3,1146 # ffffffffc0206530 <commands+0xbf8>
ffffffffc02020be:	00004617          	auipc	a2,0x4
ffffffffc02020c2:	10260613          	addi	a2,a2,258 # ffffffffc02061c0 <commands+0x888>
ffffffffc02020c6:	23500593          	li	a1,565
ffffffffc02020ca:	00004517          	auipc	a0,0x4
ffffffffc02020ce:	0b650513          	addi	a0,a0,182 # ffffffffc0206180 <commands+0x848>
ffffffffc02020d2:	94cfe0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(page_ref(p1) == 0);
ffffffffc02020d6:	00004697          	auipc	a3,0x4
ffffffffc02020da:	48a68693          	addi	a3,a3,1162 # ffffffffc0206560 <commands+0xc28>
ffffffffc02020de:	00004617          	auipc	a2,0x4
ffffffffc02020e2:	0e260613          	addi	a2,a2,226 # ffffffffc02061c0 <commands+0x888>
ffffffffc02020e6:	23400593          	li	a1,564
ffffffffc02020ea:	00004517          	auipc	a0,0x4
ffffffffc02020ee:	09650513          	addi	a0,a0,150 # ffffffffc0206180 <commands+0x848>
ffffffffc02020f2:	92cfe0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(boot_pgdir_va[0] == 0);
ffffffffc02020f6:	00004697          	auipc	a3,0x4
ffffffffc02020fa:	55268693          	addi	a3,a3,1362 # ffffffffc0206648 <commands+0xd10>
ffffffffc02020fe:	00004617          	auipc	a2,0x4
ffffffffc0202102:	0c260613          	addi	a2,a2,194 # ffffffffc02061c0 <commands+0x888>
ffffffffc0202106:	25200593          	li	a1,594
ffffffffc020210a:	00004517          	auipc	a0,0x4
ffffffffc020210e:	07650513          	addi	a0,a0,118 # ffffffffc0206180 <commands+0x848>
ffffffffc0202112:	90cfe0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc0202116:	00004697          	auipc	a3,0x4
ffffffffc020211a:	49268693          	addi	a3,a3,1170 # ffffffffc02065a8 <commands+0xc70>
ffffffffc020211e:	00004617          	auipc	a2,0x4
ffffffffc0202122:	0a260613          	addi	a2,a2,162 # ffffffffc02061c0 <commands+0x888>
ffffffffc0202126:	23f00593          	li	a1,575
ffffffffc020212a:	00004517          	auipc	a0,0x4
ffffffffc020212e:	05650513          	addi	a0,a0,86 # ffffffffc0206180 <commands+0x848>
ffffffffc0202132:	8ecfe0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(page_ref(p) == 1);
ffffffffc0202136:	00004697          	auipc	a3,0x4
ffffffffc020213a:	56a68693          	addi	a3,a3,1386 # ffffffffc02066a0 <commands+0xd68>
ffffffffc020213e:	00004617          	auipc	a2,0x4
ffffffffc0202142:	08260613          	addi	a2,a2,130 # ffffffffc02061c0 <commands+0x888>
ffffffffc0202146:	25700593          	li	a1,599
ffffffffc020214a:	00004517          	auipc	a0,0x4
ffffffffc020214e:	03650513          	addi	a0,a0,54 # ffffffffc0206180 <commands+0x848>
ffffffffc0202152:	8ccfe0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0202156:	00004697          	auipc	a3,0x4
ffffffffc020215a:	50a68693          	addi	a3,a3,1290 # ffffffffc0206660 <commands+0xd28>
ffffffffc020215e:	00004617          	auipc	a2,0x4
ffffffffc0202162:	06260613          	addi	a2,a2,98 # ffffffffc02061c0 <commands+0x888>
ffffffffc0202166:	25600593          	li	a1,598
ffffffffc020216a:	00004517          	auipc	a0,0x4
ffffffffc020216e:	01650513          	addi	a0,a0,22 # ffffffffc0206180 <commands+0x848>
ffffffffc0202172:	8acfe0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202176:	00004697          	auipc	a3,0x4
ffffffffc020217a:	3ba68693          	addi	a3,a3,954 # ffffffffc0206530 <commands+0xbf8>
ffffffffc020217e:	00004617          	auipc	a2,0x4
ffffffffc0202182:	04260613          	addi	a2,a2,66 # ffffffffc02061c0 <commands+0x888>
ffffffffc0202186:	23100593          	li	a1,561
ffffffffc020218a:	00004517          	auipc	a0,0x4
ffffffffc020218e:	ff650513          	addi	a0,a0,-10 # ffffffffc0206180 <commands+0x848>
ffffffffc0202192:	88cfe0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(page_ref(p1) == 1);
ffffffffc0202196:	00004697          	auipc	a3,0x4
ffffffffc020219a:	23a68693          	addi	a3,a3,570 # ffffffffc02063d0 <commands+0xa98>
ffffffffc020219e:	00004617          	auipc	a2,0x4
ffffffffc02021a2:	02260613          	addi	a2,a2,34 # ffffffffc02061c0 <commands+0x888>
ffffffffc02021a6:	23000593          	li	a1,560
ffffffffc02021aa:	00004517          	auipc	a0,0x4
ffffffffc02021ae:	fd650513          	addi	a0,a0,-42 # ffffffffc0206180 <commands+0x848>
ffffffffc02021b2:	86cfe0ef          	jal	ra,ffffffffc020021e <__panic>
    assert((*ptep & PTE_U) == 0);
ffffffffc02021b6:	00004697          	auipc	a3,0x4
ffffffffc02021ba:	39268693          	addi	a3,a3,914 # ffffffffc0206548 <commands+0xc10>
ffffffffc02021be:	00004617          	auipc	a2,0x4
ffffffffc02021c2:	00260613          	addi	a2,a2,2 # ffffffffc02061c0 <commands+0x888>
ffffffffc02021c6:	22d00593          	li	a1,557
ffffffffc02021ca:	00004517          	auipc	a0,0x4
ffffffffc02021ce:	fb650513          	addi	a0,a0,-74 # ffffffffc0206180 <commands+0x848>
ffffffffc02021d2:	84cfe0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc02021d6:	00004697          	auipc	a3,0x4
ffffffffc02021da:	1e268693          	addi	a3,a3,482 # ffffffffc02063b8 <commands+0xa80>
ffffffffc02021de:	00004617          	auipc	a2,0x4
ffffffffc02021e2:	fe260613          	addi	a2,a2,-30 # ffffffffc02061c0 <commands+0x888>
ffffffffc02021e6:	22c00593          	li	a1,556
ffffffffc02021ea:	00004517          	auipc	a0,0x4
ffffffffc02021ee:	f9650513          	addi	a0,a0,-106 # ffffffffc0206180 <commands+0x848>
ffffffffc02021f2:	82cfe0ef          	jal	ra,ffffffffc020021e <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc02021f6:	00004697          	auipc	a3,0x4
ffffffffc02021fa:	26268693          	addi	a3,a3,610 # ffffffffc0206458 <commands+0xb20>
ffffffffc02021fe:	00004617          	auipc	a2,0x4
ffffffffc0202202:	fc260613          	addi	a2,a2,-62 # ffffffffc02061c0 <commands+0x888>
ffffffffc0202206:	22b00593          	li	a1,555
ffffffffc020220a:	00004517          	auipc	a0,0x4
ffffffffc020220e:	f7650513          	addi	a0,a0,-138 # ffffffffc0206180 <commands+0x848>
ffffffffc0202212:	80cfe0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0202216:	00004697          	auipc	a3,0x4
ffffffffc020221a:	31a68693          	addi	a3,a3,794 # ffffffffc0206530 <commands+0xbf8>
ffffffffc020221e:	00004617          	auipc	a2,0x4
ffffffffc0202222:	fa260613          	addi	a2,a2,-94 # ffffffffc02061c0 <commands+0x888>
ffffffffc0202226:	22a00593          	li	a1,554
ffffffffc020222a:	00004517          	auipc	a0,0x4
ffffffffc020222e:	f5650513          	addi	a0,a0,-170 # ffffffffc0206180 <commands+0x848>
ffffffffc0202232:	fedfd0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(page_ref(p1) == 2);
ffffffffc0202236:	00004697          	auipc	a3,0x4
ffffffffc020223a:	2e268693          	addi	a3,a3,738 # ffffffffc0206518 <commands+0xbe0>
ffffffffc020223e:	00004617          	auipc	a2,0x4
ffffffffc0202242:	f8260613          	addi	a2,a2,-126 # ffffffffc02061c0 <commands+0x888>
ffffffffc0202246:	22900593          	li	a1,553
ffffffffc020224a:	00004517          	auipc	a0,0x4
ffffffffc020224e:	f3650513          	addi	a0,a0,-202 # ffffffffc0206180 <commands+0x848>
ffffffffc0202252:	fcdfd0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc0202256:	00004697          	auipc	a3,0x4
ffffffffc020225a:	29268693          	addi	a3,a3,658 # ffffffffc02064e8 <commands+0xbb0>
ffffffffc020225e:	00004617          	auipc	a2,0x4
ffffffffc0202262:	f6260613          	addi	a2,a2,-158 # ffffffffc02061c0 <commands+0x888>
ffffffffc0202266:	22800593          	li	a1,552
ffffffffc020226a:	00004517          	auipc	a0,0x4
ffffffffc020226e:	f1650513          	addi	a0,a0,-234 # ffffffffc0206180 <commands+0x848>
ffffffffc0202272:	fadfd0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(page_ref(p2) == 1);
ffffffffc0202276:	00004697          	auipc	a3,0x4
ffffffffc020227a:	25a68693          	addi	a3,a3,602 # ffffffffc02064d0 <commands+0xb98>
ffffffffc020227e:	00004617          	auipc	a2,0x4
ffffffffc0202282:	f4260613          	addi	a2,a2,-190 # ffffffffc02061c0 <commands+0x888>
ffffffffc0202286:	22600593          	li	a1,550
ffffffffc020228a:	00004517          	auipc	a0,0x4
ffffffffc020228e:	ef650513          	addi	a0,a0,-266 # ffffffffc0206180 <commands+0x848>
ffffffffc0202292:	f8dfd0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc0202296:	00004697          	auipc	a3,0x4
ffffffffc020229a:	21a68693          	addi	a3,a3,538 # ffffffffc02064b0 <commands+0xb78>
ffffffffc020229e:	00004617          	auipc	a2,0x4
ffffffffc02022a2:	f2260613          	addi	a2,a2,-222 # ffffffffc02061c0 <commands+0x888>
ffffffffc02022a6:	22500593          	li	a1,549
ffffffffc02022aa:	00004517          	auipc	a0,0x4
ffffffffc02022ae:	ed650513          	addi	a0,a0,-298 # ffffffffc0206180 <commands+0x848>
ffffffffc02022b2:	f6dfd0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(*ptep & PTE_W);
ffffffffc02022b6:	00004697          	auipc	a3,0x4
ffffffffc02022ba:	1ea68693          	addi	a3,a3,490 # ffffffffc02064a0 <commands+0xb68>
ffffffffc02022be:	00004617          	auipc	a2,0x4
ffffffffc02022c2:	f0260613          	addi	a2,a2,-254 # ffffffffc02061c0 <commands+0x888>
ffffffffc02022c6:	22400593          	li	a1,548
ffffffffc02022ca:	00004517          	auipc	a0,0x4
ffffffffc02022ce:	eb650513          	addi	a0,a0,-330 # ffffffffc0206180 <commands+0x848>
ffffffffc02022d2:	f4dfd0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(*ptep & PTE_U);
ffffffffc02022d6:	00004697          	auipc	a3,0x4
ffffffffc02022da:	1ba68693          	addi	a3,a3,442 # ffffffffc0206490 <commands+0xb58>
ffffffffc02022de:	00004617          	auipc	a2,0x4
ffffffffc02022e2:	ee260613          	addi	a2,a2,-286 # ffffffffc02061c0 <commands+0x888>
ffffffffc02022e6:	22300593          	li	a1,547
ffffffffc02022ea:	00004517          	auipc	a0,0x4
ffffffffc02022ee:	e9650513          	addi	a0,a0,-362 # ffffffffc0206180 <commands+0x848>
ffffffffc02022f2:	f2dfd0ef          	jal	ra,ffffffffc020021e <__panic>
        panic("DTB memory info not available");
ffffffffc02022f6:	00004617          	auipc	a2,0x4
ffffffffc02022fa:	f1260613          	addi	a2,a2,-238 # ffffffffc0206208 <commands+0x8d0>
ffffffffc02022fe:	06500593          	li	a1,101
ffffffffc0202302:	00004517          	auipc	a0,0x4
ffffffffc0202306:	e7e50513          	addi	a0,a0,-386 # ffffffffc0206180 <commands+0x848>
ffffffffc020230a:	f15fd0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc020230e:	00004697          	auipc	a3,0x4
ffffffffc0202312:	29a68693          	addi	a3,a3,666 # ffffffffc02065a8 <commands+0xc70>
ffffffffc0202316:	00004617          	auipc	a2,0x4
ffffffffc020231a:	eaa60613          	addi	a2,a2,-342 # ffffffffc02061c0 <commands+0x888>
ffffffffc020231e:	26900593          	li	a1,617
ffffffffc0202322:	00004517          	auipc	a0,0x4
ffffffffc0202326:	e5e50513          	addi	a0,a0,-418 # ffffffffc0206180 <commands+0x848>
ffffffffc020232a:	ef5fd0ef          	jal	ra,ffffffffc020021e <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc020232e:	00004697          	auipc	a3,0x4
ffffffffc0202332:	12a68693          	addi	a3,a3,298 # ffffffffc0206458 <commands+0xb20>
ffffffffc0202336:	00004617          	auipc	a2,0x4
ffffffffc020233a:	e8a60613          	addi	a2,a2,-374 # ffffffffc02061c0 <commands+0x888>
ffffffffc020233e:	22200593          	li	a1,546
ffffffffc0202342:	00004517          	auipc	a0,0x4
ffffffffc0202346:	e3e50513          	addi	a0,a0,-450 # ffffffffc0206180 <commands+0x848>
ffffffffc020234a:	ed5fd0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc020234e:	00004697          	auipc	a3,0x4
ffffffffc0202352:	0ca68693          	addi	a3,a3,202 # ffffffffc0206418 <commands+0xae0>
ffffffffc0202356:	00004617          	auipc	a2,0x4
ffffffffc020235a:	e6a60613          	addi	a2,a2,-406 # ffffffffc02061c0 <commands+0x888>
ffffffffc020235e:	22100593          	li	a1,545
ffffffffc0202362:	00004517          	auipc	a0,0x4
ffffffffc0202366:	e1e50513          	addi	a0,a0,-482 # ffffffffc0206180 <commands+0x848>
ffffffffc020236a:	eb5fd0ef          	jal	ra,ffffffffc020021e <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc020236e:	86d6                	mv	a3,s5
ffffffffc0202370:	00004617          	auipc	a2,0x4
ffffffffc0202374:	de860613          	addi	a2,a2,-536 # ffffffffc0206158 <commands+0x820>
ffffffffc0202378:	21d00593          	li	a1,541
ffffffffc020237c:	00004517          	auipc	a0,0x4
ffffffffc0202380:	e0450513          	addi	a0,a0,-508 # ffffffffc0206180 <commands+0x848>
ffffffffc0202384:	e9bfd0ef          	jal	ra,ffffffffc020021e <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc0202388:	00004617          	auipc	a2,0x4
ffffffffc020238c:	dd060613          	addi	a2,a2,-560 # ffffffffc0206158 <commands+0x820>
ffffffffc0202390:	21c00593          	li	a1,540
ffffffffc0202394:	00004517          	auipc	a0,0x4
ffffffffc0202398:	dec50513          	addi	a0,a0,-532 # ffffffffc0206180 <commands+0x848>
ffffffffc020239c:	e83fd0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(page_ref(p1) == 1);
ffffffffc02023a0:	00004697          	auipc	a3,0x4
ffffffffc02023a4:	03068693          	addi	a3,a3,48 # ffffffffc02063d0 <commands+0xa98>
ffffffffc02023a8:	00004617          	auipc	a2,0x4
ffffffffc02023ac:	e1860613          	addi	a2,a2,-488 # ffffffffc02061c0 <commands+0x888>
ffffffffc02023b0:	21a00593          	li	a1,538
ffffffffc02023b4:	00004517          	auipc	a0,0x4
ffffffffc02023b8:	dcc50513          	addi	a0,a0,-564 # ffffffffc0206180 <commands+0x848>
ffffffffc02023bc:	e63fd0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc02023c0:	00004697          	auipc	a3,0x4
ffffffffc02023c4:	ff868693          	addi	a3,a3,-8 # ffffffffc02063b8 <commands+0xa80>
ffffffffc02023c8:	00004617          	auipc	a2,0x4
ffffffffc02023cc:	df860613          	addi	a2,a2,-520 # ffffffffc02061c0 <commands+0x888>
ffffffffc02023d0:	21900593          	li	a1,537
ffffffffc02023d4:	00004517          	auipc	a0,0x4
ffffffffc02023d8:	dac50513          	addi	a0,a0,-596 # ffffffffc0206180 <commands+0x848>
ffffffffc02023dc:	e43fd0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(strlen((const char *)0x100) == 0);
ffffffffc02023e0:	00004697          	auipc	a3,0x4
ffffffffc02023e4:	38868693          	addi	a3,a3,904 # ffffffffc0206768 <commands+0xe30>
ffffffffc02023e8:	00004617          	auipc	a2,0x4
ffffffffc02023ec:	dd860613          	addi	a2,a2,-552 # ffffffffc02061c0 <commands+0x888>
ffffffffc02023f0:	26000593          	li	a1,608
ffffffffc02023f4:	00004517          	auipc	a0,0x4
ffffffffc02023f8:	d8c50513          	addi	a0,a0,-628 # ffffffffc0206180 <commands+0x848>
ffffffffc02023fc:	e23fd0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0202400:	00004697          	auipc	a3,0x4
ffffffffc0202404:	33068693          	addi	a3,a3,816 # ffffffffc0206730 <commands+0xdf8>
ffffffffc0202408:	00004617          	auipc	a2,0x4
ffffffffc020240c:	db860613          	addi	a2,a2,-584 # ffffffffc02061c0 <commands+0x888>
ffffffffc0202410:	25d00593          	li	a1,605
ffffffffc0202414:	00004517          	auipc	a0,0x4
ffffffffc0202418:	d6c50513          	addi	a0,a0,-660 # ffffffffc0206180 <commands+0x848>
ffffffffc020241c:	e03fd0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(page_ref(p) == 2);
ffffffffc0202420:	00004697          	auipc	a3,0x4
ffffffffc0202424:	2e068693          	addi	a3,a3,736 # ffffffffc0206700 <commands+0xdc8>
ffffffffc0202428:	00004617          	auipc	a2,0x4
ffffffffc020242c:	d9860613          	addi	a2,a2,-616 # ffffffffc02061c0 <commands+0x888>
ffffffffc0202430:	25900593          	li	a1,601
ffffffffc0202434:	00004517          	auipc	a0,0x4
ffffffffc0202438:	d4c50513          	addi	a0,a0,-692 # ffffffffc0206180 <commands+0x848>
ffffffffc020243c:	de3fd0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0202440:	00004697          	auipc	a3,0x4
ffffffffc0202444:	27868693          	addi	a3,a3,632 # ffffffffc02066b8 <commands+0xd80>
ffffffffc0202448:	00004617          	auipc	a2,0x4
ffffffffc020244c:	d7860613          	addi	a2,a2,-648 # ffffffffc02061c0 <commands+0x888>
ffffffffc0202450:	25800593          	li	a1,600
ffffffffc0202454:	00004517          	auipc	a0,0x4
ffffffffc0202458:	d2c50513          	addi	a0,a0,-724 # ffffffffc0206180 <commands+0x848>
ffffffffc020245c:	dc3fd0ef          	jal	ra,ffffffffc020021e <__panic>
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc0202460:	00004617          	auipc	a2,0x4
ffffffffc0202464:	e0860613          	addi	a2,a2,-504 # ffffffffc0206268 <commands+0x930>
ffffffffc0202468:	0c900593          	li	a1,201
ffffffffc020246c:	00004517          	auipc	a0,0x4
ffffffffc0202470:	d1450513          	addi	a0,a0,-748 # ffffffffc0206180 <commands+0x848>
ffffffffc0202474:	dabfd0ef          	jal	ra,ffffffffc020021e <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0202478:	00004617          	auipc	a2,0x4
ffffffffc020247c:	df060613          	addi	a2,a2,-528 # ffffffffc0206268 <commands+0x930>
ffffffffc0202480:	08100593          	li	a1,129
ffffffffc0202484:	00004517          	auipc	a0,0x4
ffffffffc0202488:	cfc50513          	addi	a0,a0,-772 # ffffffffc0206180 <commands+0x848>
ffffffffc020248c:	d93fd0ef          	jal	ra,ffffffffc020021e <__panic>
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc0202490:	00004697          	auipc	a3,0x4
ffffffffc0202494:	ef868693          	addi	a3,a3,-264 # ffffffffc0206388 <commands+0xa50>
ffffffffc0202498:	00004617          	auipc	a2,0x4
ffffffffc020249c:	d2860613          	addi	a2,a2,-728 # ffffffffc02061c0 <commands+0x888>
ffffffffc02024a0:	21800593          	li	a1,536
ffffffffc02024a4:	00004517          	auipc	a0,0x4
ffffffffc02024a8:	cdc50513          	addi	a0,a0,-804 # ffffffffc0206180 <commands+0x848>
ffffffffc02024ac:	d73fd0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc02024b0:	00004697          	auipc	a3,0x4
ffffffffc02024b4:	ea868693          	addi	a3,a3,-344 # ffffffffc0206358 <commands+0xa20>
ffffffffc02024b8:	00004617          	auipc	a2,0x4
ffffffffc02024bc:	d0860613          	addi	a2,a2,-760 # ffffffffc02061c0 <commands+0x888>
ffffffffc02024c0:	21500593          	li	a1,533
ffffffffc02024c4:	00004517          	auipc	a0,0x4
ffffffffc02024c8:	cbc50513          	addi	a0,a0,-836 # ffffffffc0206180 <commands+0x848>
ffffffffc02024cc:	d53fd0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc02024d0 <copy_range>:
{
ffffffffc02024d0:	7159                	addi	sp,sp,-112
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02024d2:	00d667b3          	or	a5,a2,a3
{
ffffffffc02024d6:	f486                	sd	ra,104(sp)
ffffffffc02024d8:	f0a2                	sd	s0,96(sp)
ffffffffc02024da:	eca6                	sd	s1,88(sp)
ffffffffc02024dc:	e8ca                	sd	s2,80(sp)
ffffffffc02024de:	e4ce                	sd	s3,72(sp)
ffffffffc02024e0:	e0d2                	sd	s4,64(sp)
ffffffffc02024e2:	fc56                	sd	s5,56(sp)
ffffffffc02024e4:	f85a                	sd	s6,48(sp)
ffffffffc02024e6:	f45e                	sd	s7,40(sp)
ffffffffc02024e8:	f062                	sd	s8,32(sp)
ffffffffc02024ea:	ec66                	sd	s9,24(sp)
ffffffffc02024ec:	e86a                	sd	s10,16(sp)
ffffffffc02024ee:	e46e                	sd	s11,8(sp)
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc02024f0:	17d2                	slli	a5,a5,0x34
ffffffffc02024f2:	20079f63          	bnez	a5,ffffffffc0202710 <copy_range+0x240>
    assert(USER_ACCESS(start, end));
ffffffffc02024f6:	002007b7          	lui	a5,0x200
ffffffffc02024fa:	8432                	mv	s0,a2
ffffffffc02024fc:	1af66263          	bltu	a2,a5,ffffffffc02026a0 <copy_range+0x1d0>
ffffffffc0202500:	8936                	mv	s2,a3
ffffffffc0202502:	18d67f63          	bgeu	a2,a3,ffffffffc02026a0 <copy_range+0x1d0>
ffffffffc0202506:	4785                	li	a5,1
ffffffffc0202508:	07fe                	slli	a5,a5,0x1f
ffffffffc020250a:	18d7eb63          	bltu	a5,a3,ffffffffc02026a0 <copy_range+0x1d0>
ffffffffc020250e:	5b7d                	li	s6,-1
ffffffffc0202510:	8aaa                	mv	s5,a0
ffffffffc0202512:	89ae                	mv	s3,a1
        start += PGSIZE;
ffffffffc0202514:	6a05                	lui	s4,0x1
    if (PPN(pa) >= npage)
ffffffffc0202516:	000a8c17          	auipc	s8,0xa8
ffffffffc020251a:	202c0c13          	addi	s8,s8,514 # ffffffffc02aa718 <npage>
    return &pages[PPN(pa) - nbase];
ffffffffc020251e:	000a8b97          	auipc	s7,0xa8
ffffffffc0202522:	202b8b93          	addi	s7,s7,514 # ffffffffc02aa720 <pages>
    return KADDR(page2pa(page));
ffffffffc0202526:	00cb5b13          	srli	s6,s6,0xc
        page = pmm_manager->alloc_pages(n);
ffffffffc020252a:	000a8c97          	auipc	s9,0xa8
ffffffffc020252e:	1fec8c93          	addi	s9,s9,510 # ffffffffc02aa728 <pmm_manager>
        pte_t *ptep = get_pte(from, start, 0), *nptep;
ffffffffc0202532:	4601                	li	a2,0
ffffffffc0202534:	85a2                	mv	a1,s0
ffffffffc0202536:	854e                	mv	a0,s3
ffffffffc0202538:	b73fe0ef          	jal	ra,ffffffffc02010aa <get_pte>
ffffffffc020253c:	84aa                	mv	s1,a0
        if (ptep == NULL)
ffffffffc020253e:	0e050c63          	beqz	a0,ffffffffc0202636 <copy_range+0x166>
        if (*ptep & PTE_V)
ffffffffc0202542:	611c                	ld	a5,0(a0)
ffffffffc0202544:	8b85                	andi	a5,a5,1
ffffffffc0202546:	e785                	bnez	a5,ffffffffc020256e <copy_range+0x9e>
        start += PGSIZE;
ffffffffc0202548:	9452                	add	s0,s0,s4
    } while (start != 0 && start < end);
ffffffffc020254a:	ff2464e3          	bltu	s0,s2,ffffffffc0202532 <copy_range+0x62>
    return 0;
ffffffffc020254e:	4501                	li	a0,0
}
ffffffffc0202550:	70a6                	ld	ra,104(sp)
ffffffffc0202552:	7406                	ld	s0,96(sp)
ffffffffc0202554:	64e6                	ld	s1,88(sp)
ffffffffc0202556:	6946                	ld	s2,80(sp)
ffffffffc0202558:	69a6                	ld	s3,72(sp)
ffffffffc020255a:	6a06                	ld	s4,64(sp)
ffffffffc020255c:	7ae2                	ld	s5,56(sp)
ffffffffc020255e:	7b42                	ld	s6,48(sp)
ffffffffc0202560:	7ba2                	ld	s7,40(sp)
ffffffffc0202562:	7c02                	ld	s8,32(sp)
ffffffffc0202564:	6ce2                	ld	s9,24(sp)
ffffffffc0202566:	6d42                	ld	s10,16(sp)
ffffffffc0202568:	6da2                	ld	s11,8(sp)
ffffffffc020256a:	6165                	addi	sp,sp,112
ffffffffc020256c:	8082                	ret
            if ((nptep = get_pte(to, start, 1)) == NULL)
ffffffffc020256e:	4605                	li	a2,1
ffffffffc0202570:	85a2                	mv	a1,s0
ffffffffc0202572:	8556                	mv	a0,s5
ffffffffc0202574:	b37fe0ef          	jal	ra,ffffffffc02010aa <get_pte>
ffffffffc0202578:	c56d                	beqz	a0,ffffffffc0202662 <copy_range+0x192>
            uint32_t perm = (*ptep & PTE_USER);
ffffffffc020257a:	609c                	ld	a5,0(s1)
    if (!(pte & PTE_V))
ffffffffc020257c:	0017f713          	andi	a4,a5,1
ffffffffc0202580:	01f7f493          	andi	s1,a5,31
ffffffffc0202584:	16070a63          	beqz	a4,ffffffffc02026f8 <copy_range+0x228>
    if (PPN(pa) >= npage)
ffffffffc0202588:	000c3683          	ld	a3,0(s8)
    return pa2page(PTE_ADDR(pte));
ffffffffc020258c:	078a                	slli	a5,a5,0x2
ffffffffc020258e:	00c7d713          	srli	a4,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0202592:	14d77763          	bgeu	a4,a3,ffffffffc02026e0 <copy_range+0x210>
    return &pages[PPN(pa) - nbase];
ffffffffc0202596:	000bb783          	ld	a5,0(s7)
ffffffffc020259a:	fff806b7          	lui	a3,0xfff80
ffffffffc020259e:	9736                	add	a4,a4,a3
ffffffffc02025a0:	071a                	slli	a4,a4,0x6
ffffffffc02025a2:	00e78db3          	add	s11,a5,a4
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02025a6:	10002773          	csrr	a4,sstatus
ffffffffc02025aa:	8b09                	andi	a4,a4,2
ffffffffc02025ac:	e345                	bnez	a4,ffffffffc020264c <copy_range+0x17c>
        page = pmm_manager->alloc_pages(n);
ffffffffc02025ae:	000cb703          	ld	a4,0(s9)
ffffffffc02025b2:	4505                	li	a0,1
ffffffffc02025b4:	6f18                	ld	a4,24(a4)
ffffffffc02025b6:	9702                	jalr	a4
ffffffffc02025b8:	8d2a                	mv	s10,a0
            assert(page != NULL);
ffffffffc02025ba:	0c0d8363          	beqz	s11,ffffffffc0202680 <copy_range+0x1b0>
            assert(npage != NULL);
ffffffffc02025be:	100d0163          	beqz	s10,ffffffffc02026c0 <copy_range+0x1f0>
    return page - pages + nbase;
ffffffffc02025c2:	000bb703          	ld	a4,0(s7)
ffffffffc02025c6:	000805b7          	lui	a1,0x80
    return KADDR(page2pa(page));
ffffffffc02025ca:	000c3603          	ld	a2,0(s8)
    return page - pages + nbase;
ffffffffc02025ce:	40ed86b3          	sub	a3,s11,a4
ffffffffc02025d2:	8699                	srai	a3,a3,0x6
ffffffffc02025d4:	96ae                	add	a3,a3,a1
    return KADDR(page2pa(page));
ffffffffc02025d6:	0166f7b3          	and	a5,a3,s6
    return page2ppn(page) << PGSHIFT;
ffffffffc02025da:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02025dc:	08c7f663          	bgeu	a5,a2,ffffffffc0202668 <copy_range+0x198>
    return page - pages + nbase;
ffffffffc02025e0:	40ed07b3          	sub	a5,s10,a4
    return KADDR(page2pa(page));
ffffffffc02025e4:	000a8717          	auipc	a4,0xa8
ffffffffc02025e8:	14c70713          	addi	a4,a4,332 # ffffffffc02aa730 <va_pa_offset>
ffffffffc02025ec:	6308                	ld	a0,0(a4)
    return page - pages + nbase;
ffffffffc02025ee:	8799                	srai	a5,a5,0x6
ffffffffc02025f0:	97ae                	add	a5,a5,a1
    return KADDR(page2pa(page));
ffffffffc02025f2:	0167f733          	and	a4,a5,s6
ffffffffc02025f6:	00a685b3          	add	a1,a3,a0
    return page2ppn(page) << PGSHIFT;
ffffffffc02025fa:	07b2                	slli	a5,a5,0xc
    return KADDR(page2pa(page));
ffffffffc02025fc:	06c77563          	bgeu	a4,a2,ffffffffc0202666 <copy_range+0x196>
            memcpy(dst, src, PGSIZE);
ffffffffc0202600:	6605                	lui	a2,0x1
ffffffffc0202602:	953e                	add	a0,a0,a5
ffffffffc0202604:	46b020ef          	jal	ra,ffffffffc020526e <memcpy>
            ret = page_insert(to, npage, start, perm);
ffffffffc0202608:	86a6                	mv	a3,s1
ffffffffc020260a:	8622                	mv	a2,s0
ffffffffc020260c:	85ea                	mv	a1,s10
ffffffffc020260e:	8556                	mv	a0,s5
ffffffffc0202610:	98aff0ef          	jal	ra,ffffffffc020179a <page_insert>
            assert(ret == 0);
ffffffffc0202614:	d915                	beqz	a0,ffffffffc0202548 <copy_range+0x78>
ffffffffc0202616:	00004697          	auipc	a3,0x4
ffffffffc020261a:	1ba68693          	addi	a3,a3,442 # ffffffffc02067d0 <commands+0xe98>
ffffffffc020261e:	00004617          	auipc	a2,0x4
ffffffffc0202622:	ba260613          	addi	a2,a2,-1118 # ffffffffc02061c0 <commands+0x888>
ffffffffc0202626:	1ad00593          	li	a1,429
ffffffffc020262a:	00004517          	auipc	a0,0x4
ffffffffc020262e:	b5650513          	addi	a0,a0,-1194 # ffffffffc0206180 <commands+0x848>
ffffffffc0202632:	bedfd0ef          	jal	ra,ffffffffc020021e <__panic>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
ffffffffc0202636:	00200637          	lui	a2,0x200
ffffffffc020263a:	9432                	add	s0,s0,a2
ffffffffc020263c:	ffe00637          	lui	a2,0xffe00
ffffffffc0202640:	8c71                	and	s0,s0,a2
    } while (start != 0 && start < end);
ffffffffc0202642:	f00406e3          	beqz	s0,ffffffffc020254e <copy_range+0x7e>
ffffffffc0202646:	ef2466e3          	bltu	s0,s2,ffffffffc0202532 <copy_range+0x62>
ffffffffc020264a:	b711                	j	ffffffffc020254e <copy_range+0x7e>
        intr_disable();
ffffffffc020264c:	b6efe0ef          	jal	ra,ffffffffc02009ba <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202650:	000cb703          	ld	a4,0(s9)
ffffffffc0202654:	4505                	li	a0,1
ffffffffc0202656:	6f18                	ld	a4,24(a4)
ffffffffc0202658:	9702                	jalr	a4
ffffffffc020265a:	8d2a                	mv	s10,a0
        intr_enable();
ffffffffc020265c:	b58fe0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
ffffffffc0202660:	bfa9                	j	ffffffffc02025ba <copy_range+0xea>
                return -E_NO_MEM;
ffffffffc0202662:	5571                	li	a0,-4
ffffffffc0202664:	b5f5                	j	ffffffffc0202550 <copy_range+0x80>
ffffffffc0202666:	86be                	mv	a3,a5
ffffffffc0202668:	00004617          	auipc	a2,0x4
ffffffffc020266c:	af060613          	addi	a2,a2,-1296 # ffffffffc0206158 <commands+0x820>
ffffffffc0202670:	07100593          	li	a1,113
ffffffffc0202674:	00004517          	auipc	a0,0x4
ffffffffc0202678:	aac50513          	addi	a0,a0,-1364 # ffffffffc0206120 <commands+0x7e8>
ffffffffc020267c:	ba3fd0ef          	jal	ra,ffffffffc020021e <__panic>
            assert(page != NULL);
ffffffffc0202680:	00004697          	auipc	a3,0x4
ffffffffc0202684:	13068693          	addi	a3,a3,304 # ffffffffc02067b0 <commands+0xe78>
ffffffffc0202688:	00004617          	auipc	a2,0x4
ffffffffc020268c:	b3860613          	addi	a2,a2,-1224 # ffffffffc02061c0 <commands+0x888>
ffffffffc0202690:	19400593          	li	a1,404
ffffffffc0202694:	00004517          	auipc	a0,0x4
ffffffffc0202698:	aec50513          	addi	a0,a0,-1300 # ffffffffc0206180 <commands+0x848>
ffffffffc020269c:	b83fd0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(USER_ACCESS(start, end));
ffffffffc02026a0:	00004697          	auipc	a3,0x4
ffffffffc02026a4:	b3868693          	addi	a3,a3,-1224 # ffffffffc02061d8 <commands+0x8a0>
ffffffffc02026a8:	00004617          	auipc	a2,0x4
ffffffffc02026ac:	b1860613          	addi	a2,a2,-1256 # ffffffffc02061c0 <commands+0x888>
ffffffffc02026b0:	17c00593          	li	a1,380
ffffffffc02026b4:	00004517          	auipc	a0,0x4
ffffffffc02026b8:	acc50513          	addi	a0,a0,-1332 # ffffffffc0206180 <commands+0x848>
ffffffffc02026bc:	b63fd0ef          	jal	ra,ffffffffc020021e <__panic>
            assert(npage != NULL);
ffffffffc02026c0:	00004697          	auipc	a3,0x4
ffffffffc02026c4:	10068693          	addi	a3,a3,256 # ffffffffc02067c0 <commands+0xe88>
ffffffffc02026c8:	00004617          	auipc	a2,0x4
ffffffffc02026cc:	af860613          	addi	a2,a2,-1288 # ffffffffc02061c0 <commands+0x888>
ffffffffc02026d0:	19500593          	li	a1,405
ffffffffc02026d4:	00004517          	auipc	a0,0x4
ffffffffc02026d8:	aac50513          	addi	a0,a0,-1364 # ffffffffc0206180 <commands+0x848>
ffffffffc02026dc:	b43fd0ef          	jal	ra,ffffffffc020021e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc02026e0:	00004617          	auipc	a2,0x4
ffffffffc02026e4:	a2060613          	addi	a2,a2,-1504 # ffffffffc0206100 <commands+0x7c8>
ffffffffc02026e8:	06900593          	li	a1,105
ffffffffc02026ec:	00004517          	auipc	a0,0x4
ffffffffc02026f0:	a3450513          	addi	a0,a0,-1484 # ffffffffc0206120 <commands+0x7e8>
ffffffffc02026f4:	b2bfd0ef          	jal	ra,ffffffffc020021e <__panic>
        panic("pte2page called with invalid pte");
ffffffffc02026f8:	00004617          	auipc	a2,0x4
ffffffffc02026fc:	a3860613          	addi	a2,a2,-1480 # ffffffffc0206130 <commands+0x7f8>
ffffffffc0202700:	07f00593          	li	a1,127
ffffffffc0202704:	00004517          	auipc	a0,0x4
ffffffffc0202708:	a1c50513          	addi	a0,a0,-1508 # ffffffffc0206120 <commands+0x7e8>
ffffffffc020270c:	b13fd0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
ffffffffc0202710:	00004697          	auipc	a3,0x4
ffffffffc0202714:	a8068693          	addi	a3,a3,-1408 # ffffffffc0206190 <commands+0x858>
ffffffffc0202718:	00004617          	auipc	a2,0x4
ffffffffc020271c:	aa860613          	addi	a2,a2,-1368 # ffffffffc02061c0 <commands+0x888>
ffffffffc0202720:	17b00593          	li	a1,379
ffffffffc0202724:	00004517          	auipc	a0,0x4
ffffffffc0202728:	a5c50513          	addi	a0,a0,-1444 # ffffffffc0206180 <commands+0x848>
ffffffffc020272c:	af3fd0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc0202730 <pgdir_alloc_page>:
{
ffffffffc0202730:	7179                	addi	sp,sp,-48
ffffffffc0202732:	ec26                	sd	s1,24(sp)
ffffffffc0202734:	e84a                	sd	s2,16(sp)
ffffffffc0202736:	e052                	sd	s4,0(sp)
ffffffffc0202738:	f406                	sd	ra,40(sp)
ffffffffc020273a:	f022                	sd	s0,32(sp)
ffffffffc020273c:	e44e                	sd	s3,8(sp)
ffffffffc020273e:	8a2a                	mv	s4,a0
ffffffffc0202740:	84ae                	mv	s1,a1
ffffffffc0202742:	8932                	mv	s2,a2
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202744:	100027f3          	csrr	a5,sstatus
ffffffffc0202748:	8b89                	andi	a5,a5,2
        page = pmm_manager->alloc_pages(n);
ffffffffc020274a:	000a8997          	auipc	s3,0xa8
ffffffffc020274e:	fde98993          	addi	s3,s3,-34 # ffffffffc02aa728 <pmm_manager>
ffffffffc0202752:	ef8d                	bnez	a5,ffffffffc020278c <pgdir_alloc_page+0x5c>
ffffffffc0202754:	0009b783          	ld	a5,0(s3)
ffffffffc0202758:	4505                	li	a0,1
ffffffffc020275a:	6f9c                	ld	a5,24(a5)
ffffffffc020275c:	9782                	jalr	a5
ffffffffc020275e:	842a                	mv	s0,a0
    if (page != NULL)
ffffffffc0202760:	cc09                	beqz	s0,ffffffffc020277a <pgdir_alloc_page+0x4a>
        if (page_insert(pgdir, page, la, perm) != 0)
ffffffffc0202762:	86ca                	mv	a3,s2
ffffffffc0202764:	8626                	mv	a2,s1
ffffffffc0202766:	85a2                	mv	a1,s0
ffffffffc0202768:	8552                	mv	a0,s4
ffffffffc020276a:	830ff0ef          	jal	ra,ffffffffc020179a <page_insert>
ffffffffc020276e:	e915                	bnez	a0,ffffffffc02027a2 <pgdir_alloc_page+0x72>
        assert(page_ref(page) == 1);
ffffffffc0202770:	4018                	lw	a4,0(s0)
        page->pra_vaddr = la;
ffffffffc0202772:	fc04                	sd	s1,56(s0)
        assert(page_ref(page) == 1);
ffffffffc0202774:	4785                	li	a5,1
ffffffffc0202776:	04f71e63          	bne	a4,a5,ffffffffc02027d2 <pgdir_alloc_page+0xa2>
}
ffffffffc020277a:	70a2                	ld	ra,40(sp)
ffffffffc020277c:	8522                	mv	a0,s0
ffffffffc020277e:	7402                	ld	s0,32(sp)
ffffffffc0202780:	64e2                	ld	s1,24(sp)
ffffffffc0202782:	6942                	ld	s2,16(sp)
ffffffffc0202784:	69a2                	ld	s3,8(sp)
ffffffffc0202786:	6a02                	ld	s4,0(sp)
ffffffffc0202788:	6145                	addi	sp,sp,48
ffffffffc020278a:	8082                	ret
        intr_disable();
ffffffffc020278c:	a2efe0ef          	jal	ra,ffffffffc02009ba <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0202790:	0009b783          	ld	a5,0(s3)
ffffffffc0202794:	4505                	li	a0,1
ffffffffc0202796:	6f9c                	ld	a5,24(a5)
ffffffffc0202798:	9782                	jalr	a5
ffffffffc020279a:	842a                	mv	s0,a0
        intr_enable();
ffffffffc020279c:	a18fe0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
ffffffffc02027a0:	b7c1                	j	ffffffffc0202760 <pgdir_alloc_page+0x30>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc02027a2:	100027f3          	csrr	a5,sstatus
ffffffffc02027a6:	8b89                	andi	a5,a5,2
ffffffffc02027a8:	eb89                	bnez	a5,ffffffffc02027ba <pgdir_alloc_page+0x8a>
        pmm_manager->free_pages(base, n);
ffffffffc02027aa:	0009b783          	ld	a5,0(s3)
ffffffffc02027ae:	8522                	mv	a0,s0
ffffffffc02027b0:	4585                	li	a1,1
ffffffffc02027b2:	739c                	ld	a5,32(a5)
            return NULL;
ffffffffc02027b4:	4401                	li	s0,0
        pmm_manager->free_pages(base, n);
ffffffffc02027b6:	9782                	jalr	a5
    if (flag)
ffffffffc02027b8:	b7c9                	j	ffffffffc020277a <pgdir_alloc_page+0x4a>
        intr_disable();
ffffffffc02027ba:	a00fe0ef          	jal	ra,ffffffffc02009ba <intr_disable>
ffffffffc02027be:	0009b783          	ld	a5,0(s3)
ffffffffc02027c2:	8522                	mv	a0,s0
ffffffffc02027c4:	4585                	li	a1,1
ffffffffc02027c6:	739c                	ld	a5,32(a5)
            return NULL;
ffffffffc02027c8:	4401                	li	s0,0
        pmm_manager->free_pages(base, n);
ffffffffc02027ca:	9782                	jalr	a5
        intr_enable();
ffffffffc02027cc:	9e8fe0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
ffffffffc02027d0:	b76d                	j	ffffffffc020277a <pgdir_alloc_page+0x4a>
        assert(page_ref(page) == 1);
ffffffffc02027d2:	00004697          	auipc	a3,0x4
ffffffffc02027d6:	00e68693          	addi	a3,a3,14 # ffffffffc02067e0 <commands+0xea8>
ffffffffc02027da:	00004617          	auipc	a2,0x4
ffffffffc02027de:	9e660613          	addi	a2,a2,-1562 # ffffffffc02061c0 <commands+0x888>
ffffffffc02027e2:	1f600593          	li	a1,502
ffffffffc02027e6:	00004517          	auipc	a0,0x4
ffffffffc02027ea:	99a50513          	addi	a0,a0,-1638 # ffffffffc0206180 <commands+0x848>
ffffffffc02027ee:	a31fd0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc02027f2 <check_vma_overlap.part.0>:
    return vma;
}

// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc02027f2:	1141                	addi	sp,sp,-16
{
    assert(prev->vm_start < prev->vm_end);
    assert(prev->vm_end <= next->vm_start);
    assert(next->vm_start < next->vm_end);
ffffffffc02027f4:	00004697          	auipc	a3,0x4
ffffffffc02027f8:	00468693          	addi	a3,a3,4 # ffffffffc02067f8 <commands+0xec0>
ffffffffc02027fc:	00004617          	auipc	a2,0x4
ffffffffc0202800:	9c460613          	addi	a2,a2,-1596 # ffffffffc02061c0 <commands+0x888>
ffffffffc0202804:	07400593          	li	a1,116
ffffffffc0202808:	00004517          	auipc	a0,0x4
ffffffffc020280c:	01050513          	addi	a0,a0,16 # ffffffffc0206818 <commands+0xee0>
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc0202810:	e406                	sd	ra,8(sp)
    assert(next->vm_start < next->vm_end);
ffffffffc0202812:	a0dfd0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc0202816 <mm_create>:
{
ffffffffc0202816:	1141                	addi	sp,sp,-16
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0202818:	04000513          	li	a0,64
{
ffffffffc020281c:	e406                	sd	ra,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc020281e:	135000ef          	jal	ra,ffffffffc0203152 <kmalloc>
    if (mm != NULL)
ffffffffc0202822:	cd19                	beqz	a0,ffffffffc0202840 <mm_create+0x2a>
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0202824:	e508                	sd	a0,8(a0)
ffffffffc0202826:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc0202828:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc020282c:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0202830:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc0202834:	02053423          	sd	zero,40(a0)
}

static inline void
set_mm_count(struct mm_struct *mm, int val)
{
    mm->mm_count = val;
ffffffffc0202838:	02052823          	sw	zero,48(a0)
typedef volatile bool lock_t;

static inline void
lock_init(lock_t *lock)
{
    *lock = 0;
ffffffffc020283c:	02053c23          	sd	zero,56(a0)
}
ffffffffc0202840:	60a2                	ld	ra,8(sp)
ffffffffc0202842:	0141                	addi	sp,sp,16
ffffffffc0202844:	8082                	ret

ffffffffc0202846 <find_vma>:
{
ffffffffc0202846:	86aa                	mv	a3,a0
    if (mm != NULL)
ffffffffc0202848:	c505                	beqz	a0,ffffffffc0202870 <find_vma+0x2a>
        vma = mm->mmap_cache;
ffffffffc020284a:	6908                	ld	a0,16(a0)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc020284c:	c501                	beqz	a0,ffffffffc0202854 <find_vma+0xe>
ffffffffc020284e:	651c                	ld	a5,8(a0)
ffffffffc0202850:	02f5f263          	bgeu	a1,a5,ffffffffc0202874 <find_vma+0x2e>
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0202854:	669c                	ld	a5,8(a3)
            while ((le = list_next(le)) != list)
ffffffffc0202856:	00f68d63          	beq	a3,a5,ffffffffc0202870 <find_vma+0x2a>
                if (vma->vm_start <= addr && addr < vma->vm_end)
ffffffffc020285a:	fe87b703          	ld	a4,-24(a5) # 1fffe8 <_binary_obj___user_exit_out_size+0x1f4ec8>
ffffffffc020285e:	00e5e663          	bltu	a1,a4,ffffffffc020286a <find_vma+0x24>
ffffffffc0202862:	ff07b703          	ld	a4,-16(a5)
ffffffffc0202866:	00e5ec63          	bltu	a1,a4,ffffffffc020287e <find_vma+0x38>
ffffffffc020286a:	679c                	ld	a5,8(a5)
            while ((le = list_next(le)) != list)
ffffffffc020286c:	fef697e3          	bne	a3,a5,ffffffffc020285a <find_vma+0x14>
    struct vma_struct *vma = NULL;
ffffffffc0202870:	4501                	li	a0,0
}
ffffffffc0202872:	8082                	ret
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc0202874:	691c                	ld	a5,16(a0)
ffffffffc0202876:	fcf5ffe3          	bgeu	a1,a5,ffffffffc0202854 <find_vma+0xe>
            mm->mmap_cache = vma;
ffffffffc020287a:	ea88                	sd	a0,16(a3)
ffffffffc020287c:	8082                	ret
                vma = le2vma(le, list_link);
ffffffffc020287e:	fe078513          	addi	a0,a5,-32
            mm->mmap_cache = vma;
ffffffffc0202882:	ea88                	sd	a0,16(a3)
ffffffffc0202884:	8082                	ret

ffffffffc0202886 <insert_vma_struct>:
}

// insert_vma_struct -insert vma in mm's list link
void insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma)
{
    assert(vma->vm_start < vma->vm_end);
ffffffffc0202886:	6590                	ld	a2,8(a1)
ffffffffc0202888:	0105b803          	ld	a6,16(a1) # 80010 <_binary_obj___user_exit_out_size+0x74ef0>
{
ffffffffc020288c:	1141                	addi	sp,sp,-16
ffffffffc020288e:	e406                	sd	ra,8(sp)
ffffffffc0202890:	87aa                	mv	a5,a0
    assert(vma->vm_start < vma->vm_end);
ffffffffc0202892:	01066763          	bltu	a2,a6,ffffffffc02028a0 <insert_vma_struct+0x1a>
ffffffffc0202896:	a085                	j	ffffffffc02028f6 <insert_vma_struct+0x70>

    list_entry_t *le = list;
    while ((le = list_next(le)) != list)
    {
        struct vma_struct *mmap_prev = le2vma(le, list_link);
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc0202898:	fe87b703          	ld	a4,-24(a5)
ffffffffc020289c:	04e66863          	bltu	a2,a4,ffffffffc02028ec <insert_vma_struct+0x66>
ffffffffc02028a0:	86be                	mv	a3,a5
ffffffffc02028a2:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != list)
ffffffffc02028a4:	fef51ae3          	bne	a0,a5,ffffffffc0202898 <insert_vma_struct+0x12>
    }

    le_next = list_next(le_prev);

    /* check overlap */
    if (le_prev != list)
ffffffffc02028a8:	02a68463          	beq	a3,a0,ffffffffc02028d0 <insert_vma_struct+0x4a>
    {
        check_vma_overlap(le2vma(le_prev, list_link), vma);
ffffffffc02028ac:	ff06b703          	ld	a4,-16(a3)
    assert(prev->vm_start < prev->vm_end);
ffffffffc02028b0:	fe86b883          	ld	a7,-24(a3)
ffffffffc02028b4:	08e8f163          	bgeu	a7,a4,ffffffffc0202936 <insert_vma_struct+0xb0>
    assert(prev->vm_end <= next->vm_start);
ffffffffc02028b8:	04e66f63          	bltu	a2,a4,ffffffffc0202916 <insert_vma_struct+0x90>
    }
    if (le_next != list)
ffffffffc02028bc:	00f50a63          	beq	a0,a5,ffffffffc02028d0 <insert_vma_struct+0x4a>
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc02028c0:	fe87b703          	ld	a4,-24(a5)
    assert(prev->vm_end <= next->vm_start);
ffffffffc02028c4:	05076963          	bltu	a4,a6,ffffffffc0202916 <insert_vma_struct+0x90>
    assert(next->vm_start < next->vm_end);
ffffffffc02028c8:	ff07b603          	ld	a2,-16(a5)
ffffffffc02028cc:	02c77363          	bgeu	a4,a2,ffffffffc02028f2 <insert_vma_struct+0x6c>
    }

    vma->vm_mm = mm;
    list_add_after(le_prev, &(vma->list_link));

    mm->map_count++;
ffffffffc02028d0:	5118                	lw	a4,32(a0)
    vma->vm_mm = mm;
ffffffffc02028d2:	e188                	sd	a0,0(a1)
    list_add_after(le_prev, &(vma->list_link));
ffffffffc02028d4:	02058613          	addi	a2,a1,32
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc02028d8:	e390                	sd	a2,0(a5)
ffffffffc02028da:	e690                	sd	a2,8(a3)
}
ffffffffc02028dc:	60a2                	ld	ra,8(sp)
    elm->next = next;
ffffffffc02028de:	f59c                	sd	a5,40(a1)
    elm->prev = prev;
ffffffffc02028e0:	f194                	sd	a3,32(a1)
    mm->map_count++;
ffffffffc02028e2:	0017079b          	addiw	a5,a4,1
ffffffffc02028e6:	d11c                	sw	a5,32(a0)
}
ffffffffc02028e8:	0141                	addi	sp,sp,16
ffffffffc02028ea:	8082                	ret
    if (le_prev != list)
ffffffffc02028ec:	fca690e3          	bne	a3,a0,ffffffffc02028ac <insert_vma_struct+0x26>
ffffffffc02028f0:	bfd1                	j	ffffffffc02028c4 <insert_vma_struct+0x3e>
ffffffffc02028f2:	f01ff0ef          	jal	ra,ffffffffc02027f2 <check_vma_overlap.part.0>
    assert(vma->vm_start < vma->vm_end);
ffffffffc02028f6:	00004697          	auipc	a3,0x4
ffffffffc02028fa:	f3268693          	addi	a3,a3,-206 # ffffffffc0206828 <commands+0xef0>
ffffffffc02028fe:	00004617          	auipc	a2,0x4
ffffffffc0202902:	8c260613          	addi	a2,a2,-1854 # ffffffffc02061c0 <commands+0x888>
ffffffffc0202906:	07a00593          	li	a1,122
ffffffffc020290a:	00004517          	auipc	a0,0x4
ffffffffc020290e:	f0e50513          	addi	a0,a0,-242 # ffffffffc0206818 <commands+0xee0>
ffffffffc0202912:	90dfd0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0202916:	00004697          	auipc	a3,0x4
ffffffffc020291a:	f5268693          	addi	a3,a3,-174 # ffffffffc0206868 <commands+0xf30>
ffffffffc020291e:	00004617          	auipc	a2,0x4
ffffffffc0202922:	8a260613          	addi	a2,a2,-1886 # ffffffffc02061c0 <commands+0x888>
ffffffffc0202926:	07300593          	li	a1,115
ffffffffc020292a:	00004517          	auipc	a0,0x4
ffffffffc020292e:	eee50513          	addi	a0,a0,-274 # ffffffffc0206818 <commands+0xee0>
ffffffffc0202932:	8edfd0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(prev->vm_start < prev->vm_end);
ffffffffc0202936:	00004697          	auipc	a3,0x4
ffffffffc020293a:	f1268693          	addi	a3,a3,-238 # ffffffffc0206848 <commands+0xf10>
ffffffffc020293e:	00004617          	auipc	a2,0x4
ffffffffc0202942:	88260613          	addi	a2,a2,-1918 # ffffffffc02061c0 <commands+0x888>
ffffffffc0202946:	07200593          	li	a1,114
ffffffffc020294a:	00004517          	auipc	a0,0x4
ffffffffc020294e:	ece50513          	addi	a0,a0,-306 # ffffffffc0206818 <commands+0xee0>
ffffffffc0202952:	8cdfd0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc0202956 <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void mm_destroy(struct mm_struct *mm)
{
    assert(mm_count(mm) == 0);
ffffffffc0202956:	591c                	lw	a5,48(a0)
{
ffffffffc0202958:	1141                	addi	sp,sp,-16
ffffffffc020295a:	e406                	sd	ra,8(sp)
ffffffffc020295c:	e022                	sd	s0,0(sp)
    assert(mm_count(mm) == 0);
ffffffffc020295e:	e78d                	bnez	a5,ffffffffc0202988 <mm_destroy+0x32>
ffffffffc0202960:	842a                	mv	s0,a0
    return listelm->next;
ffffffffc0202962:	6508                	ld	a0,8(a0)

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list)
ffffffffc0202964:	00a40c63          	beq	s0,a0,ffffffffc020297c <mm_destroy+0x26>
    __list_del(listelm->prev, listelm->next);
ffffffffc0202968:	6118                	ld	a4,0(a0)
ffffffffc020296a:	651c                	ld	a5,8(a0)
    {
        list_del(le);
        kfree(le2vma(le, list_link)); // kfree vma
ffffffffc020296c:	1501                	addi	a0,a0,-32
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc020296e:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0202970:	e398                	sd	a4,0(a5)
ffffffffc0202972:	091000ef          	jal	ra,ffffffffc0203202 <kfree>
    return listelm->next;
ffffffffc0202976:	6408                	ld	a0,8(s0)
    while ((le = list_next(list)) != list)
ffffffffc0202978:	fea418e3          	bne	s0,a0,ffffffffc0202968 <mm_destroy+0x12>
    }
    kfree(mm); // kfree mm
ffffffffc020297c:	8522                	mv	a0,s0
    mm = NULL;
}
ffffffffc020297e:	6402                	ld	s0,0(sp)
ffffffffc0202980:	60a2                	ld	ra,8(sp)
ffffffffc0202982:	0141                	addi	sp,sp,16
    kfree(mm); // kfree mm
ffffffffc0202984:	07f0006f          	j	ffffffffc0203202 <kfree>
    assert(mm_count(mm) == 0);
ffffffffc0202988:	00004697          	auipc	a3,0x4
ffffffffc020298c:	f0068693          	addi	a3,a3,-256 # ffffffffc0206888 <commands+0xf50>
ffffffffc0202990:	00004617          	auipc	a2,0x4
ffffffffc0202994:	83060613          	addi	a2,a2,-2000 # ffffffffc02061c0 <commands+0x888>
ffffffffc0202998:	09e00593          	li	a1,158
ffffffffc020299c:	00004517          	auipc	a0,0x4
ffffffffc02029a0:	e7c50513          	addi	a0,a0,-388 # ffffffffc0206818 <commands+0xee0>
ffffffffc02029a4:	87bfd0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc02029a8 <mm_map>:

int mm_map(struct mm_struct *mm, uintptr_t addr, size_t len, uint32_t vm_flags,
           struct vma_struct **vma_store)
{
ffffffffc02029a8:	7139                	addi	sp,sp,-64
ffffffffc02029aa:	f822                	sd	s0,48(sp)
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc02029ac:	6405                	lui	s0,0x1
ffffffffc02029ae:	147d                	addi	s0,s0,-1
ffffffffc02029b0:	77fd                	lui	a5,0xfffff
ffffffffc02029b2:	9622                	add	a2,a2,s0
ffffffffc02029b4:	962e                	add	a2,a2,a1
{
ffffffffc02029b6:	f426                	sd	s1,40(sp)
ffffffffc02029b8:	fc06                	sd	ra,56(sp)
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
ffffffffc02029ba:	00f5f4b3          	and	s1,a1,a5
{
ffffffffc02029be:	f04a                	sd	s2,32(sp)
ffffffffc02029c0:	ec4e                	sd	s3,24(sp)
ffffffffc02029c2:	e852                	sd	s4,16(sp)
ffffffffc02029c4:	e456                	sd	s5,8(sp)
    if (!USER_ACCESS(start, end))
ffffffffc02029c6:	002005b7          	lui	a1,0x200
ffffffffc02029ca:	00f67433          	and	s0,a2,a5
ffffffffc02029ce:	06b4e363          	bltu	s1,a1,ffffffffc0202a34 <mm_map+0x8c>
ffffffffc02029d2:	0684f163          	bgeu	s1,s0,ffffffffc0202a34 <mm_map+0x8c>
ffffffffc02029d6:	4785                	li	a5,1
ffffffffc02029d8:	07fe                	slli	a5,a5,0x1f
ffffffffc02029da:	0487ed63          	bltu	a5,s0,ffffffffc0202a34 <mm_map+0x8c>
ffffffffc02029de:	89aa                	mv	s3,a0
    {
        return -E_INVAL;
    }

    assert(mm != NULL);
ffffffffc02029e0:	cd21                	beqz	a0,ffffffffc0202a38 <mm_map+0x90>

    int ret = -E_INVAL;

    struct vma_struct *vma;
    if ((vma = find_vma(mm, start)) != NULL && end > vma->vm_start)
ffffffffc02029e2:	85a6                	mv	a1,s1
ffffffffc02029e4:	8ab6                	mv	s5,a3
ffffffffc02029e6:	8a3a                	mv	s4,a4
ffffffffc02029e8:	e5fff0ef          	jal	ra,ffffffffc0202846 <find_vma>
ffffffffc02029ec:	c501                	beqz	a0,ffffffffc02029f4 <mm_map+0x4c>
ffffffffc02029ee:	651c                	ld	a5,8(a0)
ffffffffc02029f0:	0487e263          	bltu	a5,s0,ffffffffc0202a34 <mm_map+0x8c>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc02029f4:	03000513          	li	a0,48
ffffffffc02029f8:	75a000ef          	jal	ra,ffffffffc0203152 <kmalloc>
ffffffffc02029fc:	892a                	mv	s2,a0
    {
        goto out;
    }
    ret = -E_NO_MEM;
ffffffffc02029fe:	5571                	li	a0,-4
    if (vma != NULL)
ffffffffc0202a00:	02090163          	beqz	s2,ffffffffc0202a22 <mm_map+0x7a>

    if ((vma = vma_create(start, end, vm_flags)) == NULL)
    {
        goto out;
    }
    insert_vma_struct(mm, vma);
ffffffffc0202a04:	854e                	mv	a0,s3
        vma->vm_start = vm_start;
ffffffffc0202a06:	00993423          	sd	s1,8(s2)
        vma->vm_end = vm_end;
ffffffffc0202a0a:	00893823          	sd	s0,16(s2)
        vma->vm_flags = vm_flags;
ffffffffc0202a0e:	01592c23          	sw	s5,24(s2)
    insert_vma_struct(mm, vma);
ffffffffc0202a12:	85ca                	mv	a1,s2
ffffffffc0202a14:	e73ff0ef          	jal	ra,ffffffffc0202886 <insert_vma_struct>
    if (vma_store != NULL)
    {
        *vma_store = vma;
    }
    ret = 0;
ffffffffc0202a18:	4501                	li	a0,0
    if (vma_store != NULL)
ffffffffc0202a1a:	000a0463          	beqz	s4,ffffffffc0202a22 <mm_map+0x7a>
        *vma_store = vma;
ffffffffc0202a1e:	012a3023          	sd	s2,0(s4) # 1000 <_binary_obj___user_faultread_out_size-0x8bb0>

out:
    return ret;
}
ffffffffc0202a22:	70e2                	ld	ra,56(sp)
ffffffffc0202a24:	7442                	ld	s0,48(sp)
ffffffffc0202a26:	74a2                	ld	s1,40(sp)
ffffffffc0202a28:	7902                	ld	s2,32(sp)
ffffffffc0202a2a:	69e2                	ld	s3,24(sp)
ffffffffc0202a2c:	6a42                	ld	s4,16(sp)
ffffffffc0202a2e:	6aa2                	ld	s5,8(sp)
ffffffffc0202a30:	6121                	addi	sp,sp,64
ffffffffc0202a32:	8082                	ret
        return -E_INVAL;
ffffffffc0202a34:	5575                	li	a0,-3
ffffffffc0202a36:	b7f5                	j	ffffffffc0202a22 <mm_map+0x7a>
    assert(mm != NULL);
ffffffffc0202a38:	00004697          	auipc	a3,0x4
ffffffffc0202a3c:	e6868693          	addi	a3,a3,-408 # ffffffffc02068a0 <commands+0xf68>
ffffffffc0202a40:	00003617          	auipc	a2,0x3
ffffffffc0202a44:	78060613          	addi	a2,a2,1920 # ffffffffc02061c0 <commands+0x888>
ffffffffc0202a48:	0b300593          	li	a1,179
ffffffffc0202a4c:	00004517          	auipc	a0,0x4
ffffffffc0202a50:	dcc50513          	addi	a0,a0,-564 # ffffffffc0206818 <commands+0xee0>
ffffffffc0202a54:	fcafd0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc0202a58 <dup_mmap>:

int dup_mmap(struct mm_struct *to, struct mm_struct *from)
{
ffffffffc0202a58:	7139                	addi	sp,sp,-64
ffffffffc0202a5a:	fc06                	sd	ra,56(sp)
ffffffffc0202a5c:	f822                	sd	s0,48(sp)
ffffffffc0202a5e:	f426                	sd	s1,40(sp)
ffffffffc0202a60:	f04a                	sd	s2,32(sp)
ffffffffc0202a62:	ec4e                	sd	s3,24(sp)
ffffffffc0202a64:	e852                	sd	s4,16(sp)
ffffffffc0202a66:	e456                	sd	s5,8(sp)
    assert(to != NULL && from != NULL);
ffffffffc0202a68:	c52d                	beqz	a0,ffffffffc0202ad2 <dup_mmap+0x7a>
ffffffffc0202a6a:	892a                	mv	s2,a0
ffffffffc0202a6c:	84ae                	mv	s1,a1
    list_entry_t *list = &(from->mmap_list), *le = list;
ffffffffc0202a6e:	842e                	mv	s0,a1
    assert(to != NULL && from != NULL);
ffffffffc0202a70:	e595                	bnez	a1,ffffffffc0202a9c <dup_mmap+0x44>
ffffffffc0202a72:	a085                	j	ffffffffc0202ad2 <dup_mmap+0x7a>
        if (nvma == NULL)
        {
            return -E_NO_MEM;
        }

        insert_vma_struct(to, nvma);
ffffffffc0202a74:	854a                	mv	a0,s2
        vma->vm_start = vm_start;
ffffffffc0202a76:	0155b423          	sd	s5,8(a1) # 200008 <_binary_obj___user_exit_out_size+0x1f4ee8>
        vma->vm_end = vm_end;
ffffffffc0202a7a:	0145b823          	sd	s4,16(a1)
        vma->vm_flags = vm_flags;
ffffffffc0202a7e:	0135ac23          	sw	s3,24(a1)
        insert_vma_struct(to, nvma);
ffffffffc0202a82:	e05ff0ef          	jal	ra,ffffffffc0202886 <insert_vma_struct>

        bool share = 0;
        if (copy_range(to->pgdir, from->pgdir, vma->vm_start, vma->vm_end, share) != 0)
ffffffffc0202a86:	ff043683          	ld	a3,-16(s0) # ff0 <_binary_obj___user_faultread_out_size-0x8bc0>
ffffffffc0202a8a:	fe843603          	ld	a2,-24(s0)
ffffffffc0202a8e:	6c8c                	ld	a1,24(s1)
ffffffffc0202a90:	01893503          	ld	a0,24(s2)
ffffffffc0202a94:	4701                	li	a4,0
ffffffffc0202a96:	a3bff0ef          	jal	ra,ffffffffc02024d0 <copy_range>
ffffffffc0202a9a:	e105                	bnez	a0,ffffffffc0202aba <dup_mmap+0x62>
    return listelm->prev;
ffffffffc0202a9c:	6000                	ld	s0,0(s0)
    while ((le = list_prev(le)) != list)
ffffffffc0202a9e:	02848863          	beq	s1,s0,ffffffffc0202ace <dup_mmap+0x76>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0202aa2:	03000513          	li	a0,48
        nvma = vma_create(vma->vm_start, vma->vm_end, vma->vm_flags);
ffffffffc0202aa6:	fe843a83          	ld	s5,-24(s0)
ffffffffc0202aaa:	ff043a03          	ld	s4,-16(s0)
ffffffffc0202aae:	ff842983          	lw	s3,-8(s0)
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0202ab2:	6a0000ef          	jal	ra,ffffffffc0203152 <kmalloc>
ffffffffc0202ab6:	85aa                	mv	a1,a0
    if (vma != NULL)
ffffffffc0202ab8:	fd55                	bnez	a0,ffffffffc0202a74 <dup_mmap+0x1c>
            return -E_NO_MEM;
ffffffffc0202aba:	5571                	li	a0,-4
        {
            return -E_NO_MEM;
        }
    }
    return 0;
}
ffffffffc0202abc:	70e2                	ld	ra,56(sp)
ffffffffc0202abe:	7442                	ld	s0,48(sp)
ffffffffc0202ac0:	74a2                	ld	s1,40(sp)
ffffffffc0202ac2:	7902                	ld	s2,32(sp)
ffffffffc0202ac4:	69e2                	ld	s3,24(sp)
ffffffffc0202ac6:	6a42                	ld	s4,16(sp)
ffffffffc0202ac8:	6aa2                	ld	s5,8(sp)
ffffffffc0202aca:	6121                	addi	sp,sp,64
ffffffffc0202acc:	8082                	ret
    return 0;
ffffffffc0202ace:	4501                	li	a0,0
ffffffffc0202ad0:	b7f5                	j	ffffffffc0202abc <dup_mmap+0x64>
    assert(to != NULL && from != NULL);
ffffffffc0202ad2:	00004697          	auipc	a3,0x4
ffffffffc0202ad6:	dde68693          	addi	a3,a3,-546 # ffffffffc02068b0 <commands+0xf78>
ffffffffc0202ada:	00003617          	auipc	a2,0x3
ffffffffc0202ade:	6e660613          	addi	a2,a2,1766 # ffffffffc02061c0 <commands+0x888>
ffffffffc0202ae2:	0cf00593          	li	a1,207
ffffffffc0202ae6:	00004517          	auipc	a0,0x4
ffffffffc0202aea:	d3250513          	addi	a0,a0,-718 # ffffffffc0206818 <commands+0xee0>
ffffffffc0202aee:	f30fd0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc0202af2 <exit_mmap>:

void exit_mmap(struct mm_struct *mm)
{
ffffffffc0202af2:	1101                	addi	sp,sp,-32
ffffffffc0202af4:	ec06                	sd	ra,24(sp)
ffffffffc0202af6:	e822                	sd	s0,16(sp)
ffffffffc0202af8:	e426                	sd	s1,8(sp)
ffffffffc0202afa:	e04a                	sd	s2,0(sp)
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc0202afc:	c531                	beqz	a0,ffffffffc0202b48 <exit_mmap+0x56>
ffffffffc0202afe:	591c                	lw	a5,48(a0)
ffffffffc0202b00:	84aa                	mv	s1,a0
ffffffffc0202b02:	e3b9                	bnez	a5,ffffffffc0202b48 <exit_mmap+0x56>
    return listelm->next;
ffffffffc0202b04:	6500                	ld	s0,8(a0)
    pde_t *pgdir = mm->pgdir;
ffffffffc0202b06:	01853903          	ld	s2,24(a0)
    list_entry_t *list = &(mm->mmap_list), *le = list;
    while ((le = list_next(le)) != list)
ffffffffc0202b0a:	02850663          	beq	a0,s0,ffffffffc0202b36 <exit_mmap+0x44>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc0202b0e:	ff043603          	ld	a2,-16(s0)
ffffffffc0202b12:	fe843583          	ld	a1,-24(s0)
ffffffffc0202b16:	854a                	mv	a0,s2
ffffffffc0202b18:	80ffe0ef          	jal	ra,ffffffffc0201326 <unmap_range>
ffffffffc0202b1c:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc0202b1e:	fe8498e3          	bne	s1,s0,ffffffffc0202b0e <exit_mmap+0x1c>
ffffffffc0202b22:	6400                	ld	s0,8(s0)
    }
    while ((le = list_next(le)) != list)
ffffffffc0202b24:	00848c63          	beq	s1,s0,ffffffffc0202b3c <exit_mmap+0x4a>
    {
        struct vma_struct *vma = le2vma(le, list_link);
        exit_range(pgdir, vma->vm_start, vma->vm_end);
ffffffffc0202b28:	ff043603          	ld	a2,-16(s0)
ffffffffc0202b2c:	fe843583          	ld	a1,-24(s0)
ffffffffc0202b30:	854a                	mv	a0,s2
ffffffffc0202b32:	93bfe0ef          	jal	ra,ffffffffc020146c <exit_range>
ffffffffc0202b36:	6400                	ld	s0,8(s0)
    while ((le = list_next(le)) != list)
ffffffffc0202b38:	fe8498e3          	bne	s1,s0,ffffffffc0202b28 <exit_mmap+0x36>
    }
}
ffffffffc0202b3c:	60e2                	ld	ra,24(sp)
ffffffffc0202b3e:	6442                	ld	s0,16(sp)
ffffffffc0202b40:	64a2                	ld	s1,8(sp)
ffffffffc0202b42:	6902                	ld	s2,0(sp)
ffffffffc0202b44:	6105                	addi	sp,sp,32
ffffffffc0202b46:	8082                	ret
    assert(mm != NULL && mm_count(mm) == 0);
ffffffffc0202b48:	00004697          	auipc	a3,0x4
ffffffffc0202b4c:	d8868693          	addi	a3,a3,-632 # ffffffffc02068d0 <commands+0xf98>
ffffffffc0202b50:	00003617          	auipc	a2,0x3
ffffffffc0202b54:	67060613          	addi	a2,a2,1648 # ffffffffc02061c0 <commands+0x888>
ffffffffc0202b58:	0e800593          	li	a1,232
ffffffffc0202b5c:	00004517          	auipc	a0,0x4
ffffffffc0202b60:	cbc50513          	addi	a0,a0,-836 # ffffffffc0206818 <commands+0xee0>
ffffffffc0202b64:	ebafd0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc0202b68 <vmm_init>:
}

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void vmm_init(void)
{
ffffffffc0202b68:	7139                	addi	sp,sp,-64
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0202b6a:	04000513          	li	a0,64
{
ffffffffc0202b6e:	fc06                	sd	ra,56(sp)
ffffffffc0202b70:	f822                	sd	s0,48(sp)
ffffffffc0202b72:	f426                	sd	s1,40(sp)
ffffffffc0202b74:	f04a                	sd	s2,32(sp)
ffffffffc0202b76:	ec4e                	sd	s3,24(sp)
ffffffffc0202b78:	e852                	sd	s4,16(sp)
ffffffffc0202b7a:	e456                	sd	s5,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0202b7c:	5d6000ef          	jal	ra,ffffffffc0203152 <kmalloc>
    if (mm != NULL)
ffffffffc0202b80:	2e050663          	beqz	a0,ffffffffc0202e6c <vmm_init+0x304>
ffffffffc0202b84:	84aa                	mv	s1,a0
    elm->prev = elm->next = elm;
ffffffffc0202b86:	e508                	sd	a0,8(a0)
ffffffffc0202b88:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc0202b8a:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0202b8e:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0202b92:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc0202b96:	02053423          	sd	zero,40(a0)
ffffffffc0202b9a:	02052823          	sw	zero,48(a0)
ffffffffc0202b9e:	02053c23          	sd	zero,56(a0)
ffffffffc0202ba2:	03200413          	li	s0,50
ffffffffc0202ba6:	a811                	j	ffffffffc0202bba <vmm_init+0x52>
        vma->vm_start = vm_start;
ffffffffc0202ba8:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc0202baa:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0202bac:	00052c23          	sw	zero,24(a0)
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i--)
ffffffffc0202bb0:	146d                	addi	s0,s0,-5
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0202bb2:	8526                	mv	a0,s1
ffffffffc0202bb4:	cd3ff0ef          	jal	ra,ffffffffc0202886 <insert_vma_struct>
    for (i = step1; i >= 1; i--)
ffffffffc0202bb8:	c80d                	beqz	s0,ffffffffc0202bea <vmm_init+0x82>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0202bba:	03000513          	li	a0,48
ffffffffc0202bbe:	594000ef          	jal	ra,ffffffffc0203152 <kmalloc>
ffffffffc0202bc2:	85aa                	mv	a1,a0
ffffffffc0202bc4:	00240793          	addi	a5,s0,2
    if (vma != NULL)
ffffffffc0202bc8:	f165                	bnez	a0,ffffffffc0202ba8 <vmm_init+0x40>
        assert(vma != NULL);
ffffffffc0202bca:	00004697          	auipc	a3,0x4
ffffffffc0202bce:	e9e68693          	addi	a3,a3,-354 # ffffffffc0206a68 <commands+0x1130>
ffffffffc0202bd2:	00003617          	auipc	a2,0x3
ffffffffc0202bd6:	5ee60613          	addi	a2,a2,1518 # ffffffffc02061c0 <commands+0x888>
ffffffffc0202bda:	12c00593          	li	a1,300
ffffffffc0202bde:	00004517          	auipc	a0,0x4
ffffffffc0202be2:	c3a50513          	addi	a0,a0,-966 # ffffffffc0206818 <commands+0xee0>
ffffffffc0202be6:	e38fd0ef          	jal	ra,ffffffffc020021e <__panic>
ffffffffc0202bea:	03700413          	li	s0,55
    }

    for (i = step1 + 1; i <= step2; i++)
ffffffffc0202bee:	1f900913          	li	s2,505
ffffffffc0202bf2:	a819                	j	ffffffffc0202c08 <vmm_init+0xa0>
        vma->vm_start = vm_start;
ffffffffc0202bf4:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc0202bf6:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc0202bf8:	00052c23          	sw	zero,24(a0)
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0202bfc:	0415                	addi	s0,s0,5
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0202bfe:	8526                	mv	a0,s1
ffffffffc0202c00:	c87ff0ef          	jal	ra,ffffffffc0202886 <insert_vma_struct>
    for (i = step1 + 1; i <= step2; i++)
ffffffffc0202c04:	03240a63          	beq	s0,s2,ffffffffc0202c38 <vmm_init+0xd0>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0202c08:	03000513          	li	a0,48
ffffffffc0202c0c:	546000ef          	jal	ra,ffffffffc0203152 <kmalloc>
ffffffffc0202c10:	85aa                	mv	a1,a0
ffffffffc0202c12:	00240793          	addi	a5,s0,2
    if (vma != NULL)
ffffffffc0202c16:	fd79                	bnez	a0,ffffffffc0202bf4 <vmm_init+0x8c>
        assert(vma != NULL);
ffffffffc0202c18:	00004697          	auipc	a3,0x4
ffffffffc0202c1c:	e5068693          	addi	a3,a3,-432 # ffffffffc0206a68 <commands+0x1130>
ffffffffc0202c20:	00003617          	auipc	a2,0x3
ffffffffc0202c24:	5a060613          	addi	a2,a2,1440 # ffffffffc02061c0 <commands+0x888>
ffffffffc0202c28:	13300593          	li	a1,307
ffffffffc0202c2c:	00004517          	auipc	a0,0x4
ffffffffc0202c30:	bec50513          	addi	a0,a0,-1044 # ffffffffc0206818 <commands+0xee0>
ffffffffc0202c34:	deafd0ef          	jal	ra,ffffffffc020021e <__panic>
    return listelm->next;
ffffffffc0202c38:	649c                	ld	a5,8(s1)
ffffffffc0202c3a:	471d                	li	a4,7
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i++)
ffffffffc0202c3c:	1fb00593          	li	a1,507
    {
        assert(le != &(mm->mmap_list));
ffffffffc0202c40:	16f48663          	beq	s1,a5,ffffffffc0202dac <vmm_init+0x244>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0202c44:	fe87b603          	ld	a2,-24(a5) # ffffffffffffefe8 <end+0x3fd5488c>
ffffffffc0202c48:	ffe70693          	addi	a3,a4,-2
ffffffffc0202c4c:	10d61063          	bne	a2,a3,ffffffffc0202d4c <vmm_init+0x1e4>
ffffffffc0202c50:	ff07b683          	ld	a3,-16(a5)
ffffffffc0202c54:	0ed71c63          	bne	a4,a3,ffffffffc0202d4c <vmm_init+0x1e4>
    for (i = 1; i <= step2; i++)
ffffffffc0202c58:	0715                	addi	a4,a4,5
ffffffffc0202c5a:	679c                	ld	a5,8(a5)
ffffffffc0202c5c:	feb712e3          	bne	a4,a1,ffffffffc0202c40 <vmm_init+0xd8>
ffffffffc0202c60:	4a1d                	li	s4,7
ffffffffc0202c62:	4415                	li	s0,5
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc0202c64:	1f900a93          	li	s5,505
    {
        struct vma_struct *vma1 = find_vma(mm, i);
ffffffffc0202c68:	85a2                	mv	a1,s0
ffffffffc0202c6a:	8526                	mv	a0,s1
ffffffffc0202c6c:	bdbff0ef          	jal	ra,ffffffffc0202846 <find_vma>
ffffffffc0202c70:	892a                	mv	s2,a0
        assert(vma1 != NULL);
ffffffffc0202c72:	16050d63          	beqz	a0,ffffffffc0202dec <vmm_init+0x284>
        struct vma_struct *vma2 = find_vma(mm, i + 1);
ffffffffc0202c76:	00140593          	addi	a1,s0,1
ffffffffc0202c7a:	8526                	mv	a0,s1
ffffffffc0202c7c:	bcbff0ef          	jal	ra,ffffffffc0202846 <find_vma>
ffffffffc0202c80:	89aa                	mv	s3,a0
        assert(vma2 != NULL);
ffffffffc0202c82:	14050563          	beqz	a0,ffffffffc0202dcc <vmm_init+0x264>
        struct vma_struct *vma3 = find_vma(mm, i + 2);
ffffffffc0202c86:	85d2                	mv	a1,s4
ffffffffc0202c88:	8526                	mv	a0,s1
ffffffffc0202c8a:	bbdff0ef          	jal	ra,ffffffffc0202846 <find_vma>
        assert(vma3 == NULL);
ffffffffc0202c8e:	16051f63          	bnez	a0,ffffffffc0202e0c <vmm_init+0x2a4>
        struct vma_struct *vma4 = find_vma(mm, i + 3);
ffffffffc0202c92:	00340593          	addi	a1,s0,3
ffffffffc0202c96:	8526                	mv	a0,s1
ffffffffc0202c98:	bafff0ef          	jal	ra,ffffffffc0202846 <find_vma>
        assert(vma4 == NULL);
ffffffffc0202c9c:	1a051863          	bnez	a0,ffffffffc0202e4c <vmm_init+0x2e4>
        struct vma_struct *vma5 = find_vma(mm, i + 4);
ffffffffc0202ca0:	00440593          	addi	a1,s0,4
ffffffffc0202ca4:	8526                	mv	a0,s1
ffffffffc0202ca6:	ba1ff0ef          	jal	ra,ffffffffc0202846 <find_vma>
        assert(vma5 == NULL);
ffffffffc0202caa:	18051163          	bnez	a0,ffffffffc0202e2c <vmm_init+0x2c4>

        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0202cae:	00893783          	ld	a5,8(s2)
ffffffffc0202cb2:	0a879d63          	bne	a5,s0,ffffffffc0202d6c <vmm_init+0x204>
ffffffffc0202cb6:	01093783          	ld	a5,16(s2)
ffffffffc0202cba:	0b479963          	bne	a5,s4,ffffffffc0202d6c <vmm_init+0x204>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0202cbe:	0089b783          	ld	a5,8(s3)
ffffffffc0202cc2:	0c879563          	bne	a5,s0,ffffffffc0202d8c <vmm_init+0x224>
ffffffffc0202cc6:	0109b783          	ld	a5,16(s3)
ffffffffc0202cca:	0d479163          	bne	a5,s4,ffffffffc0202d8c <vmm_init+0x224>
    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc0202cce:	0415                	addi	s0,s0,5
ffffffffc0202cd0:	0a15                	addi	s4,s4,5
ffffffffc0202cd2:	f9541be3          	bne	s0,s5,ffffffffc0202c68 <vmm_init+0x100>
ffffffffc0202cd6:	4411                	li	s0,4
    }

    for (i = 4; i >= 0; i--)
ffffffffc0202cd8:	597d                	li	s2,-1
    {
        struct vma_struct *vma_below_5 = find_vma(mm, i);
ffffffffc0202cda:	85a2                	mv	a1,s0
ffffffffc0202cdc:	8526                	mv	a0,s1
ffffffffc0202cde:	b69ff0ef          	jal	ra,ffffffffc0202846 <find_vma>
ffffffffc0202ce2:	0004059b          	sext.w	a1,s0
        if (vma_below_5 != NULL)
ffffffffc0202ce6:	c90d                	beqz	a0,ffffffffc0202d18 <vmm_init+0x1b0>
        {
            cprintf("vma_below_5: i %x, start %x, end %x\n", i, vma_below_5->vm_start, vma_below_5->vm_end);
ffffffffc0202ce8:	6914                	ld	a3,16(a0)
ffffffffc0202cea:	6510                	ld	a2,8(a0)
ffffffffc0202cec:	00004517          	auipc	a0,0x4
ffffffffc0202cf0:	d0450513          	addi	a0,a0,-764 # ffffffffc02069f0 <commands+0x10b8>
ffffffffc0202cf4:	becfd0ef          	jal	ra,ffffffffc02000e0 <cprintf>
        }
        assert(vma_below_5 == NULL);
ffffffffc0202cf8:	00004697          	auipc	a3,0x4
ffffffffc0202cfc:	d2068693          	addi	a3,a3,-736 # ffffffffc0206a18 <commands+0x10e0>
ffffffffc0202d00:	00003617          	auipc	a2,0x3
ffffffffc0202d04:	4c060613          	addi	a2,a2,1216 # ffffffffc02061c0 <commands+0x888>
ffffffffc0202d08:	15900593          	li	a1,345
ffffffffc0202d0c:	00004517          	auipc	a0,0x4
ffffffffc0202d10:	b0c50513          	addi	a0,a0,-1268 # ffffffffc0206818 <commands+0xee0>
ffffffffc0202d14:	d0afd0ef          	jal	ra,ffffffffc020021e <__panic>
    for (i = 4; i >= 0; i--)
ffffffffc0202d18:	147d                	addi	s0,s0,-1
ffffffffc0202d1a:	fd2410e3          	bne	s0,s2,ffffffffc0202cda <vmm_init+0x172>
    }

    mm_destroy(mm);
ffffffffc0202d1e:	8526                	mv	a0,s1
ffffffffc0202d20:	c37ff0ef          	jal	ra,ffffffffc0202956 <mm_destroy>

    cprintf("check_vma_struct() succeeded!\n");
ffffffffc0202d24:	00004517          	auipc	a0,0x4
ffffffffc0202d28:	d0c50513          	addi	a0,a0,-756 # ffffffffc0206a30 <commands+0x10f8>
ffffffffc0202d2c:	bb4fd0ef          	jal	ra,ffffffffc02000e0 <cprintf>
}
ffffffffc0202d30:	7442                	ld	s0,48(sp)
ffffffffc0202d32:	70e2                	ld	ra,56(sp)
ffffffffc0202d34:	74a2                	ld	s1,40(sp)
ffffffffc0202d36:	7902                	ld	s2,32(sp)
ffffffffc0202d38:	69e2                	ld	s3,24(sp)
ffffffffc0202d3a:	6a42                	ld	s4,16(sp)
ffffffffc0202d3c:	6aa2                	ld	s5,8(sp)
    cprintf("check_vmm() succeeded.\n");
ffffffffc0202d3e:	00004517          	auipc	a0,0x4
ffffffffc0202d42:	d1250513          	addi	a0,a0,-750 # ffffffffc0206a50 <commands+0x1118>
}
ffffffffc0202d46:	6121                	addi	sp,sp,64
    cprintf("check_vmm() succeeded.\n");
ffffffffc0202d48:	b98fd06f          	j	ffffffffc02000e0 <cprintf>
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0202d4c:	00004697          	auipc	a3,0x4
ffffffffc0202d50:	bbc68693          	addi	a3,a3,-1092 # ffffffffc0206908 <commands+0xfd0>
ffffffffc0202d54:	00003617          	auipc	a2,0x3
ffffffffc0202d58:	46c60613          	addi	a2,a2,1132 # ffffffffc02061c0 <commands+0x888>
ffffffffc0202d5c:	13d00593          	li	a1,317
ffffffffc0202d60:	00004517          	auipc	a0,0x4
ffffffffc0202d64:	ab850513          	addi	a0,a0,-1352 # ffffffffc0206818 <commands+0xee0>
ffffffffc0202d68:	cb6fd0ef          	jal	ra,ffffffffc020021e <__panic>
        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0202d6c:	00004697          	auipc	a3,0x4
ffffffffc0202d70:	c2468693          	addi	a3,a3,-988 # ffffffffc0206990 <commands+0x1058>
ffffffffc0202d74:	00003617          	auipc	a2,0x3
ffffffffc0202d78:	44c60613          	addi	a2,a2,1100 # ffffffffc02061c0 <commands+0x888>
ffffffffc0202d7c:	14e00593          	li	a1,334
ffffffffc0202d80:	00004517          	auipc	a0,0x4
ffffffffc0202d84:	a9850513          	addi	a0,a0,-1384 # ffffffffc0206818 <commands+0xee0>
ffffffffc0202d88:	c96fd0ef          	jal	ra,ffffffffc020021e <__panic>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0202d8c:	00004697          	auipc	a3,0x4
ffffffffc0202d90:	c3468693          	addi	a3,a3,-972 # ffffffffc02069c0 <commands+0x1088>
ffffffffc0202d94:	00003617          	auipc	a2,0x3
ffffffffc0202d98:	42c60613          	addi	a2,a2,1068 # ffffffffc02061c0 <commands+0x888>
ffffffffc0202d9c:	14f00593          	li	a1,335
ffffffffc0202da0:	00004517          	auipc	a0,0x4
ffffffffc0202da4:	a7850513          	addi	a0,a0,-1416 # ffffffffc0206818 <commands+0xee0>
ffffffffc0202da8:	c76fd0ef          	jal	ra,ffffffffc020021e <__panic>
        assert(le != &(mm->mmap_list));
ffffffffc0202dac:	00004697          	auipc	a3,0x4
ffffffffc0202db0:	b4468693          	addi	a3,a3,-1212 # ffffffffc02068f0 <commands+0xfb8>
ffffffffc0202db4:	00003617          	auipc	a2,0x3
ffffffffc0202db8:	40c60613          	addi	a2,a2,1036 # ffffffffc02061c0 <commands+0x888>
ffffffffc0202dbc:	13b00593          	li	a1,315
ffffffffc0202dc0:	00004517          	auipc	a0,0x4
ffffffffc0202dc4:	a5850513          	addi	a0,a0,-1448 # ffffffffc0206818 <commands+0xee0>
ffffffffc0202dc8:	c56fd0ef          	jal	ra,ffffffffc020021e <__panic>
        assert(vma2 != NULL);
ffffffffc0202dcc:	00004697          	auipc	a3,0x4
ffffffffc0202dd0:	b8468693          	addi	a3,a3,-1148 # ffffffffc0206950 <commands+0x1018>
ffffffffc0202dd4:	00003617          	auipc	a2,0x3
ffffffffc0202dd8:	3ec60613          	addi	a2,a2,1004 # ffffffffc02061c0 <commands+0x888>
ffffffffc0202ddc:	14600593          	li	a1,326
ffffffffc0202de0:	00004517          	auipc	a0,0x4
ffffffffc0202de4:	a3850513          	addi	a0,a0,-1480 # ffffffffc0206818 <commands+0xee0>
ffffffffc0202de8:	c36fd0ef          	jal	ra,ffffffffc020021e <__panic>
        assert(vma1 != NULL);
ffffffffc0202dec:	00004697          	auipc	a3,0x4
ffffffffc0202df0:	b5468693          	addi	a3,a3,-1196 # ffffffffc0206940 <commands+0x1008>
ffffffffc0202df4:	00003617          	auipc	a2,0x3
ffffffffc0202df8:	3cc60613          	addi	a2,a2,972 # ffffffffc02061c0 <commands+0x888>
ffffffffc0202dfc:	14400593          	li	a1,324
ffffffffc0202e00:	00004517          	auipc	a0,0x4
ffffffffc0202e04:	a1850513          	addi	a0,a0,-1512 # ffffffffc0206818 <commands+0xee0>
ffffffffc0202e08:	c16fd0ef          	jal	ra,ffffffffc020021e <__panic>
        assert(vma3 == NULL);
ffffffffc0202e0c:	00004697          	auipc	a3,0x4
ffffffffc0202e10:	b5468693          	addi	a3,a3,-1196 # ffffffffc0206960 <commands+0x1028>
ffffffffc0202e14:	00003617          	auipc	a2,0x3
ffffffffc0202e18:	3ac60613          	addi	a2,a2,940 # ffffffffc02061c0 <commands+0x888>
ffffffffc0202e1c:	14800593          	li	a1,328
ffffffffc0202e20:	00004517          	auipc	a0,0x4
ffffffffc0202e24:	9f850513          	addi	a0,a0,-1544 # ffffffffc0206818 <commands+0xee0>
ffffffffc0202e28:	bf6fd0ef          	jal	ra,ffffffffc020021e <__panic>
        assert(vma5 == NULL);
ffffffffc0202e2c:	00004697          	auipc	a3,0x4
ffffffffc0202e30:	b5468693          	addi	a3,a3,-1196 # ffffffffc0206980 <commands+0x1048>
ffffffffc0202e34:	00003617          	auipc	a2,0x3
ffffffffc0202e38:	38c60613          	addi	a2,a2,908 # ffffffffc02061c0 <commands+0x888>
ffffffffc0202e3c:	14c00593          	li	a1,332
ffffffffc0202e40:	00004517          	auipc	a0,0x4
ffffffffc0202e44:	9d850513          	addi	a0,a0,-1576 # ffffffffc0206818 <commands+0xee0>
ffffffffc0202e48:	bd6fd0ef          	jal	ra,ffffffffc020021e <__panic>
        assert(vma4 == NULL);
ffffffffc0202e4c:	00004697          	auipc	a3,0x4
ffffffffc0202e50:	b2468693          	addi	a3,a3,-1244 # ffffffffc0206970 <commands+0x1038>
ffffffffc0202e54:	00003617          	auipc	a2,0x3
ffffffffc0202e58:	36c60613          	addi	a2,a2,876 # ffffffffc02061c0 <commands+0x888>
ffffffffc0202e5c:	14a00593          	li	a1,330
ffffffffc0202e60:	00004517          	auipc	a0,0x4
ffffffffc0202e64:	9b850513          	addi	a0,a0,-1608 # ffffffffc0206818 <commands+0xee0>
ffffffffc0202e68:	bb6fd0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(mm != NULL);
ffffffffc0202e6c:	00004697          	auipc	a3,0x4
ffffffffc0202e70:	a3468693          	addi	a3,a3,-1484 # ffffffffc02068a0 <commands+0xf68>
ffffffffc0202e74:	00003617          	auipc	a2,0x3
ffffffffc0202e78:	34c60613          	addi	a2,a2,844 # ffffffffc02061c0 <commands+0x888>
ffffffffc0202e7c:	12400593          	li	a1,292
ffffffffc0202e80:	00004517          	auipc	a0,0x4
ffffffffc0202e84:	99850513          	addi	a0,a0,-1640 # ffffffffc0206818 <commands+0xee0>
ffffffffc0202e88:	b96fd0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc0202e8c <user_mem_check>:
}
bool user_mem_check(struct mm_struct *mm, uintptr_t addr, size_t len, bool write)
{
ffffffffc0202e8c:	7179                	addi	sp,sp,-48
ffffffffc0202e8e:	f022                	sd	s0,32(sp)
ffffffffc0202e90:	f406                	sd	ra,40(sp)
ffffffffc0202e92:	ec26                	sd	s1,24(sp)
ffffffffc0202e94:	e84a                	sd	s2,16(sp)
ffffffffc0202e96:	e44e                	sd	s3,8(sp)
ffffffffc0202e98:	e052                	sd	s4,0(sp)
ffffffffc0202e9a:	842e                	mv	s0,a1
    if (mm != NULL)
ffffffffc0202e9c:	c135                	beqz	a0,ffffffffc0202f00 <user_mem_check+0x74>
    {
        if (!USER_ACCESS(addr, addr + len))
ffffffffc0202e9e:	002007b7          	lui	a5,0x200
ffffffffc0202ea2:	04f5e663          	bltu	a1,a5,ffffffffc0202eee <user_mem_check+0x62>
ffffffffc0202ea6:	00c584b3          	add	s1,a1,a2
ffffffffc0202eaa:	0495f263          	bgeu	a1,s1,ffffffffc0202eee <user_mem_check+0x62>
ffffffffc0202eae:	4785                	li	a5,1
ffffffffc0202eb0:	07fe                	slli	a5,a5,0x1f
ffffffffc0202eb2:	0297ee63          	bltu	a5,s1,ffffffffc0202eee <user_mem_check+0x62>
ffffffffc0202eb6:	892a                	mv	s2,a0
ffffffffc0202eb8:	89b6                	mv	s3,a3
            {
                return 0;
            }
            if (write && (vma->vm_flags & VM_STACK))
            {
                if (start < vma->vm_start + PGSIZE)
ffffffffc0202eba:	6a05                	lui	s4,0x1
ffffffffc0202ebc:	a821                	j	ffffffffc0202ed4 <user_mem_check+0x48>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0202ebe:	0027f693          	andi	a3,a5,2
                if (start < vma->vm_start + PGSIZE)
ffffffffc0202ec2:	9752                	add	a4,a4,s4
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc0202ec4:	8ba1                	andi	a5,a5,8
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0202ec6:	c685                	beqz	a3,ffffffffc0202eee <user_mem_check+0x62>
            if (write && (vma->vm_flags & VM_STACK))
ffffffffc0202ec8:	c399                	beqz	a5,ffffffffc0202ece <user_mem_check+0x42>
                if (start < vma->vm_start + PGSIZE)
ffffffffc0202eca:	02e46263          	bltu	s0,a4,ffffffffc0202eee <user_mem_check+0x62>
                { // check stack start & size
                    return 0;
                }
            }
            start = vma->vm_end;
ffffffffc0202ece:	6900                	ld	s0,16(a0)
        while (start < end)
ffffffffc0202ed0:	04947663          	bgeu	s0,s1,ffffffffc0202f1c <user_mem_check+0x90>
            if ((vma = find_vma(mm, start)) == NULL || start < vma->vm_start)
ffffffffc0202ed4:	85a2                	mv	a1,s0
ffffffffc0202ed6:	854a                	mv	a0,s2
ffffffffc0202ed8:	96fff0ef          	jal	ra,ffffffffc0202846 <find_vma>
ffffffffc0202edc:	c909                	beqz	a0,ffffffffc0202eee <user_mem_check+0x62>
ffffffffc0202ede:	6518                	ld	a4,8(a0)
ffffffffc0202ee0:	00e46763          	bltu	s0,a4,ffffffffc0202eee <user_mem_check+0x62>
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ)))
ffffffffc0202ee4:	4d1c                	lw	a5,24(a0)
ffffffffc0202ee6:	fc099ce3          	bnez	s3,ffffffffc0202ebe <user_mem_check+0x32>
ffffffffc0202eea:	8b85                	andi	a5,a5,1
ffffffffc0202eec:	f3ed                	bnez	a5,ffffffffc0202ece <user_mem_check+0x42>
            return 0;
ffffffffc0202eee:	4501                	li	a0,0
        }
        return 1;
    }
    return KERN_ACCESS(addr, addr + len);
ffffffffc0202ef0:	70a2                	ld	ra,40(sp)
ffffffffc0202ef2:	7402                	ld	s0,32(sp)
ffffffffc0202ef4:	64e2                	ld	s1,24(sp)
ffffffffc0202ef6:	6942                	ld	s2,16(sp)
ffffffffc0202ef8:	69a2                	ld	s3,8(sp)
ffffffffc0202efa:	6a02                	ld	s4,0(sp)
ffffffffc0202efc:	6145                	addi	sp,sp,48
ffffffffc0202efe:	8082                	ret
    return KERN_ACCESS(addr, addr + len);
ffffffffc0202f00:	c02007b7          	lui	a5,0xc0200
ffffffffc0202f04:	4501                	li	a0,0
ffffffffc0202f06:	fef5e5e3          	bltu	a1,a5,ffffffffc0202ef0 <user_mem_check+0x64>
ffffffffc0202f0a:	962e                	add	a2,a2,a1
ffffffffc0202f0c:	fec5f2e3          	bgeu	a1,a2,ffffffffc0202ef0 <user_mem_check+0x64>
ffffffffc0202f10:	c8000537          	lui	a0,0xc8000
ffffffffc0202f14:	0505                	addi	a0,a0,1
ffffffffc0202f16:	00a63533          	sltu	a0,a2,a0
ffffffffc0202f1a:	bfd9                	j	ffffffffc0202ef0 <user_mem_check+0x64>
        return 1;
ffffffffc0202f1c:	4505                	li	a0,1
ffffffffc0202f1e:	bfc9                	j	ffffffffc0202ef0 <user_mem_check+0x64>

ffffffffc0202f20 <slob_free>:
static void slob_free(void *block, int size)
{
	slob_t *cur, *b = (slob_t *)block;
	unsigned long flags;

	if (!block)
ffffffffc0202f20:	c94d                	beqz	a0,ffffffffc0202fd2 <slob_free+0xb2>
{
ffffffffc0202f22:	1141                	addi	sp,sp,-16
ffffffffc0202f24:	e022                	sd	s0,0(sp)
ffffffffc0202f26:	e406                	sd	ra,8(sp)
ffffffffc0202f28:	842a                	mv	s0,a0
		return;

	if (size)
ffffffffc0202f2a:	e9c1                	bnez	a1,ffffffffc0202fba <slob_free+0x9a>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202f2c:	100027f3          	csrr	a5,sstatus
ffffffffc0202f30:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0202f32:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202f34:	ebd9                	bnez	a5,ffffffffc0202fca <slob_free+0xaa>
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0202f36:	000a3617          	auipc	a2,0xa3
ffffffffc0202f3a:	37260613          	addi	a2,a2,882 # ffffffffc02a62a8 <slobfree>
ffffffffc0202f3e:	621c                	ld	a5,0(a2)
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0202f40:	873e                	mv	a4,a5
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc0202f42:	679c                	ld	a5,8(a5)
ffffffffc0202f44:	02877a63          	bgeu	a4,s0,ffffffffc0202f78 <slob_free+0x58>
ffffffffc0202f48:	00f46463          	bltu	s0,a5,ffffffffc0202f50 <slob_free+0x30>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0202f4c:	fef76ae3          	bltu	a4,a5,ffffffffc0202f40 <slob_free+0x20>
			break;

	if (b + b->units == cur->next)
ffffffffc0202f50:	400c                	lw	a1,0(s0)
ffffffffc0202f52:	00459693          	slli	a3,a1,0x4
ffffffffc0202f56:	96a2                	add	a3,a3,s0
ffffffffc0202f58:	02d78a63          	beq	a5,a3,ffffffffc0202f8c <slob_free+0x6c>
		b->next = cur->next->next;
	}
	else
		b->next = cur->next;

	if (cur + cur->units == b)
ffffffffc0202f5c:	4314                	lw	a3,0(a4)
		b->next = cur->next;
ffffffffc0202f5e:	e41c                	sd	a5,8(s0)
	if (cur + cur->units == b)
ffffffffc0202f60:	00469793          	slli	a5,a3,0x4
ffffffffc0202f64:	97ba                	add	a5,a5,a4
ffffffffc0202f66:	02f40e63          	beq	s0,a5,ffffffffc0202fa2 <slob_free+0x82>
	{
		cur->units += b->units;
		cur->next = b->next;
	}
	else
		cur->next = b;
ffffffffc0202f6a:	e700                	sd	s0,8(a4)

	slobfree = cur;
ffffffffc0202f6c:	e218                	sd	a4,0(a2)
    if (flag)
ffffffffc0202f6e:	e129                	bnez	a0,ffffffffc0202fb0 <slob_free+0x90>

	spin_unlock_irqrestore(&slob_lock, flags);
}
ffffffffc0202f70:	60a2                	ld	ra,8(sp)
ffffffffc0202f72:	6402                	ld	s0,0(sp)
ffffffffc0202f74:	0141                	addi	sp,sp,16
ffffffffc0202f76:	8082                	ret
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc0202f78:	fcf764e3          	bltu	a4,a5,ffffffffc0202f40 <slob_free+0x20>
ffffffffc0202f7c:	fcf472e3          	bgeu	s0,a5,ffffffffc0202f40 <slob_free+0x20>
	if (b + b->units == cur->next)
ffffffffc0202f80:	400c                	lw	a1,0(s0)
ffffffffc0202f82:	00459693          	slli	a3,a1,0x4
ffffffffc0202f86:	96a2                	add	a3,a3,s0
ffffffffc0202f88:	fcd79ae3          	bne	a5,a3,ffffffffc0202f5c <slob_free+0x3c>
		b->units += cur->next->units;
ffffffffc0202f8c:	4394                	lw	a3,0(a5)
		b->next = cur->next->next;
ffffffffc0202f8e:	679c                	ld	a5,8(a5)
		b->units += cur->next->units;
ffffffffc0202f90:	9db5                	addw	a1,a1,a3
ffffffffc0202f92:	c00c                	sw	a1,0(s0)
	if (cur + cur->units == b)
ffffffffc0202f94:	4314                	lw	a3,0(a4)
		b->next = cur->next->next;
ffffffffc0202f96:	e41c                	sd	a5,8(s0)
	if (cur + cur->units == b)
ffffffffc0202f98:	00469793          	slli	a5,a3,0x4
ffffffffc0202f9c:	97ba                	add	a5,a5,a4
ffffffffc0202f9e:	fcf416e3          	bne	s0,a5,ffffffffc0202f6a <slob_free+0x4a>
		cur->units += b->units;
ffffffffc0202fa2:	401c                	lw	a5,0(s0)
		cur->next = b->next;
ffffffffc0202fa4:	640c                	ld	a1,8(s0)
	slobfree = cur;
ffffffffc0202fa6:	e218                	sd	a4,0(a2)
		cur->units += b->units;
ffffffffc0202fa8:	9ebd                	addw	a3,a3,a5
ffffffffc0202faa:	c314                	sw	a3,0(a4)
		cur->next = b->next;
ffffffffc0202fac:	e70c                	sd	a1,8(a4)
ffffffffc0202fae:	d169                	beqz	a0,ffffffffc0202f70 <slob_free+0x50>
}
ffffffffc0202fb0:	6402                	ld	s0,0(sp)
ffffffffc0202fb2:	60a2                	ld	ra,8(sp)
ffffffffc0202fb4:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc0202fb6:	9fffd06f          	j	ffffffffc02009b4 <intr_enable>
		b->units = SLOB_UNITS(size);
ffffffffc0202fba:	25bd                	addiw	a1,a1,15
ffffffffc0202fbc:	8191                	srli	a1,a1,0x4
ffffffffc0202fbe:	c10c                	sw	a1,0(a0)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202fc0:	100027f3          	csrr	a5,sstatus
ffffffffc0202fc4:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0202fc6:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0202fc8:	d7bd                	beqz	a5,ffffffffc0202f36 <slob_free+0x16>
        intr_disable();
ffffffffc0202fca:	9f1fd0ef          	jal	ra,ffffffffc02009ba <intr_disable>
        return 1;
ffffffffc0202fce:	4505                	li	a0,1
ffffffffc0202fd0:	b79d                	j	ffffffffc0202f36 <slob_free+0x16>
ffffffffc0202fd2:	8082                	ret

ffffffffc0202fd4 <__slob_get_free_pages.constprop.0>:
	struct Page *page = alloc_pages(1 << order);
ffffffffc0202fd4:	4785                	li	a5,1
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0202fd6:	1141                	addi	sp,sp,-16
	struct Page *page = alloc_pages(1 << order);
ffffffffc0202fd8:	00a7953b          	sllw	a0,a5,a0
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0202fdc:	e406                	sd	ra,8(sp)
	struct Page *page = alloc_pages(1 << order);
ffffffffc0202fde:	814fe0ef          	jal	ra,ffffffffc0200ff2 <alloc_pages>
	if (!page)
ffffffffc0202fe2:	c91d                	beqz	a0,ffffffffc0203018 <__slob_get_free_pages.constprop.0+0x44>
    return page - pages + nbase;
ffffffffc0202fe4:	000a7697          	auipc	a3,0xa7
ffffffffc0202fe8:	73c6b683          	ld	a3,1852(a3) # ffffffffc02aa720 <pages>
ffffffffc0202fec:	8d15                	sub	a0,a0,a3
ffffffffc0202fee:	8519                	srai	a0,a0,0x6
ffffffffc0202ff0:	00004697          	auipc	a3,0x4
ffffffffc0202ff4:	7d06b683          	ld	a3,2000(a3) # ffffffffc02077c0 <nbase>
ffffffffc0202ff8:	9536                	add	a0,a0,a3
    return KADDR(page2pa(page));
ffffffffc0202ffa:	00c51793          	slli	a5,a0,0xc
ffffffffc0202ffe:	83b1                	srli	a5,a5,0xc
ffffffffc0203000:	000a7717          	auipc	a4,0xa7
ffffffffc0203004:	71873703          	ld	a4,1816(a4) # ffffffffc02aa718 <npage>
    return page2ppn(page) << PGSHIFT;
ffffffffc0203008:	0532                	slli	a0,a0,0xc
    return KADDR(page2pa(page));
ffffffffc020300a:	00e7fa63          	bgeu	a5,a4,ffffffffc020301e <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc020300e:	000a7697          	auipc	a3,0xa7
ffffffffc0203012:	7226b683          	ld	a3,1826(a3) # ffffffffc02aa730 <va_pa_offset>
ffffffffc0203016:	9536                	add	a0,a0,a3
}
ffffffffc0203018:	60a2                	ld	ra,8(sp)
ffffffffc020301a:	0141                	addi	sp,sp,16
ffffffffc020301c:	8082                	ret
ffffffffc020301e:	86aa                	mv	a3,a0
ffffffffc0203020:	00003617          	auipc	a2,0x3
ffffffffc0203024:	13860613          	addi	a2,a2,312 # ffffffffc0206158 <commands+0x820>
ffffffffc0203028:	07100593          	li	a1,113
ffffffffc020302c:	00003517          	auipc	a0,0x3
ffffffffc0203030:	0f450513          	addi	a0,a0,244 # ffffffffc0206120 <commands+0x7e8>
ffffffffc0203034:	9eafd0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc0203038 <slob_alloc.constprop.0>:
static void *slob_alloc(size_t size, gfp_t gfp, int align)
ffffffffc0203038:	1101                	addi	sp,sp,-32
ffffffffc020303a:	ec06                	sd	ra,24(sp)
ffffffffc020303c:	e822                	sd	s0,16(sp)
ffffffffc020303e:	e426                	sd	s1,8(sp)
ffffffffc0203040:	e04a                	sd	s2,0(sp)
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0203042:	01050713          	addi	a4,a0,16
ffffffffc0203046:	6785                	lui	a5,0x1
ffffffffc0203048:	0cf77363          	bgeu	a4,a5,ffffffffc020310e <slob_alloc.constprop.0+0xd6>
	int delta = 0, units = SLOB_UNITS(size);
ffffffffc020304c:	00f50493          	addi	s1,a0,15
ffffffffc0203050:	8091                	srli	s1,s1,0x4
ffffffffc0203052:	2481                	sext.w	s1,s1
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203054:	10002673          	csrr	a2,sstatus
ffffffffc0203058:	8a09                	andi	a2,a2,2
ffffffffc020305a:	e25d                	bnez	a2,ffffffffc0203100 <slob_alloc.constprop.0+0xc8>
	prev = slobfree;
ffffffffc020305c:	000a3917          	auipc	s2,0xa3
ffffffffc0203060:	24c90913          	addi	s2,s2,588 # ffffffffc02a62a8 <slobfree>
ffffffffc0203064:	00093683          	ld	a3,0(s2)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0203068:	669c                	ld	a5,8(a3)
		if (cur->units >= units + delta)
ffffffffc020306a:	4398                	lw	a4,0(a5)
ffffffffc020306c:	08975e63          	bge	a4,s1,ffffffffc0203108 <slob_alloc.constprop.0+0xd0>
		if (cur == slobfree)
ffffffffc0203070:	00f68b63          	beq	a3,a5,ffffffffc0203086 <slob_alloc.constprop.0+0x4e>
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0203074:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta)
ffffffffc0203076:	4018                	lw	a4,0(s0)
ffffffffc0203078:	02975a63          	bge	a4,s1,ffffffffc02030ac <slob_alloc.constprop.0+0x74>
		if (cur == slobfree)
ffffffffc020307c:	00093683          	ld	a3,0(s2)
ffffffffc0203080:	87a2                	mv	a5,s0
ffffffffc0203082:	fef699e3          	bne	a3,a5,ffffffffc0203074 <slob_alloc.constprop.0+0x3c>
    if (flag)
ffffffffc0203086:	ee31                	bnez	a2,ffffffffc02030e2 <slob_alloc.constprop.0+0xaa>
			cur = (slob_t *)__slob_get_free_page(gfp);
ffffffffc0203088:	4501                	li	a0,0
ffffffffc020308a:	f4bff0ef          	jal	ra,ffffffffc0202fd4 <__slob_get_free_pages.constprop.0>
ffffffffc020308e:	842a                	mv	s0,a0
			if (!cur)
ffffffffc0203090:	cd05                	beqz	a0,ffffffffc02030c8 <slob_alloc.constprop.0+0x90>
			slob_free(cur, PAGE_SIZE);
ffffffffc0203092:	6585                	lui	a1,0x1
ffffffffc0203094:	e8dff0ef          	jal	ra,ffffffffc0202f20 <slob_free>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203098:	10002673          	csrr	a2,sstatus
ffffffffc020309c:	8a09                	andi	a2,a2,2
ffffffffc020309e:	ee05                	bnez	a2,ffffffffc02030d6 <slob_alloc.constprop.0+0x9e>
			cur = slobfree;
ffffffffc02030a0:	00093783          	ld	a5,0(s2)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc02030a4:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta)
ffffffffc02030a6:	4018                	lw	a4,0(s0)
ffffffffc02030a8:	fc974ae3          	blt	a4,s1,ffffffffc020307c <slob_alloc.constprop.0+0x44>
			if (cur->units == units)	/* exact fit? */
ffffffffc02030ac:	04e48763          	beq	s1,a4,ffffffffc02030fa <slob_alloc.constprop.0+0xc2>
				prev->next = cur + units;
ffffffffc02030b0:	00449693          	slli	a3,s1,0x4
ffffffffc02030b4:	96a2                	add	a3,a3,s0
ffffffffc02030b6:	e794                	sd	a3,8(a5)
				prev->next->next = cur->next;
ffffffffc02030b8:	640c                	ld	a1,8(s0)
				prev->next->units = cur->units - units;
ffffffffc02030ba:	9f05                	subw	a4,a4,s1
ffffffffc02030bc:	c298                	sw	a4,0(a3)
				prev->next->next = cur->next;
ffffffffc02030be:	e68c                	sd	a1,8(a3)
				cur->units = units;
ffffffffc02030c0:	c004                	sw	s1,0(s0)
			slobfree = prev;
ffffffffc02030c2:	00f93023          	sd	a5,0(s2)
    if (flag)
ffffffffc02030c6:	e20d                	bnez	a2,ffffffffc02030e8 <slob_alloc.constprop.0+0xb0>
}
ffffffffc02030c8:	60e2                	ld	ra,24(sp)
ffffffffc02030ca:	8522                	mv	a0,s0
ffffffffc02030cc:	6442                	ld	s0,16(sp)
ffffffffc02030ce:	64a2                	ld	s1,8(sp)
ffffffffc02030d0:	6902                	ld	s2,0(sp)
ffffffffc02030d2:	6105                	addi	sp,sp,32
ffffffffc02030d4:	8082                	ret
        intr_disable();
ffffffffc02030d6:	8e5fd0ef          	jal	ra,ffffffffc02009ba <intr_disable>
			cur = slobfree;
ffffffffc02030da:	00093783          	ld	a5,0(s2)
        return 1;
ffffffffc02030de:	4605                	li	a2,1
ffffffffc02030e0:	b7d1                	j	ffffffffc02030a4 <slob_alloc.constprop.0+0x6c>
        intr_enable();
ffffffffc02030e2:	8d3fd0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
ffffffffc02030e6:	b74d                	j	ffffffffc0203088 <slob_alloc.constprop.0+0x50>
ffffffffc02030e8:	8cdfd0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
}
ffffffffc02030ec:	60e2                	ld	ra,24(sp)
ffffffffc02030ee:	8522                	mv	a0,s0
ffffffffc02030f0:	6442                	ld	s0,16(sp)
ffffffffc02030f2:	64a2                	ld	s1,8(sp)
ffffffffc02030f4:	6902                	ld	s2,0(sp)
ffffffffc02030f6:	6105                	addi	sp,sp,32
ffffffffc02030f8:	8082                	ret
				prev->next = cur->next; /* unlink */
ffffffffc02030fa:	6418                	ld	a4,8(s0)
ffffffffc02030fc:	e798                	sd	a4,8(a5)
ffffffffc02030fe:	b7d1                	j	ffffffffc02030c2 <slob_alloc.constprop.0+0x8a>
        intr_disable();
ffffffffc0203100:	8bbfd0ef          	jal	ra,ffffffffc02009ba <intr_disable>
        return 1;
ffffffffc0203104:	4605                	li	a2,1
ffffffffc0203106:	bf99                	j	ffffffffc020305c <slob_alloc.constprop.0+0x24>
		if (cur->units >= units + delta)
ffffffffc0203108:	843e                	mv	s0,a5
ffffffffc020310a:	87b6                	mv	a5,a3
ffffffffc020310c:	b745                	j	ffffffffc02030ac <slob_alloc.constprop.0+0x74>
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc020310e:	00004697          	auipc	a3,0x4
ffffffffc0203112:	96a68693          	addi	a3,a3,-1686 # ffffffffc0206a78 <commands+0x1140>
ffffffffc0203116:	00003617          	auipc	a2,0x3
ffffffffc020311a:	0aa60613          	addi	a2,a2,170 # ffffffffc02061c0 <commands+0x888>
ffffffffc020311e:	06300593          	li	a1,99
ffffffffc0203122:	00004517          	auipc	a0,0x4
ffffffffc0203126:	97650513          	addi	a0,a0,-1674 # ffffffffc0206a98 <commands+0x1160>
ffffffffc020312a:	8f4fd0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc020312e <kmalloc_init>:
	cprintf("use SLOB allocator\n");
}

inline void
kmalloc_init(void)
{
ffffffffc020312e:	1141                	addi	sp,sp,-16
	cprintf("use SLOB allocator\n");
ffffffffc0203130:	00004517          	auipc	a0,0x4
ffffffffc0203134:	98050513          	addi	a0,a0,-1664 # ffffffffc0206ab0 <commands+0x1178>
{
ffffffffc0203138:	e406                	sd	ra,8(sp)
	cprintf("use SLOB allocator\n");
ffffffffc020313a:	fa7fc0ef          	jal	ra,ffffffffc02000e0 <cprintf>
	slob_init();
	cprintf("kmalloc_init() succeeded!\n");
}
ffffffffc020313e:	60a2                	ld	ra,8(sp)
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc0203140:	00004517          	auipc	a0,0x4
ffffffffc0203144:	98850513          	addi	a0,a0,-1656 # ffffffffc0206ac8 <commands+0x1190>
}
ffffffffc0203148:	0141                	addi	sp,sp,16
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc020314a:	f97fc06f          	j	ffffffffc02000e0 <cprintf>

ffffffffc020314e <kallocated>:

size_t
kallocated(void)
{
	return slob_allocated();
}
ffffffffc020314e:	4501                	li	a0,0
ffffffffc0203150:	8082                	ret

ffffffffc0203152 <kmalloc>:
	return 0;
}

void *
kmalloc(size_t size)
{
ffffffffc0203152:	1101                	addi	sp,sp,-32
ffffffffc0203154:	e04a                	sd	s2,0(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0203156:	6905                	lui	s2,0x1
{
ffffffffc0203158:	e822                	sd	s0,16(sp)
ffffffffc020315a:	ec06                	sd	ra,24(sp)
ffffffffc020315c:	e426                	sd	s1,8(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc020315e:	fef90793          	addi	a5,s2,-17 # fef <_binary_obj___user_faultread_out_size-0x8bc1>
{
ffffffffc0203162:	842a                	mv	s0,a0
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc0203164:	04a7f963          	bgeu	a5,a0,ffffffffc02031b6 <kmalloc+0x64>
	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
ffffffffc0203168:	4561                	li	a0,24
ffffffffc020316a:	ecfff0ef          	jal	ra,ffffffffc0203038 <slob_alloc.constprop.0>
ffffffffc020316e:	84aa                	mv	s1,a0
	if (!bb)
ffffffffc0203170:	c929                	beqz	a0,ffffffffc02031c2 <kmalloc+0x70>
	bb->order = find_order(size);
ffffffffc0203172:	0004079b          	sext.w	a5,s0
	int order = 0;
ffffffffc0203176:	4501                	li	a0,0
	for (; size > 4096; size >>= 1)
ffffffffc0203178:	00f95763          	bge	s2,a5,ffffffffc0203186 <kmalloc+0x34>
ffffffffc020317c:	6705                	lui	a4,0x1
ffffffffc020317e:	8785                	srai	a5,a5,0x1
		order++;
ffffffffc0203180:	2505                	addiw	a0,a0,1
	for (; size > 4096; size >>= 1)
ffffffffc0203182:	fef74ee3          	blt	a4,a5,ffffffffc020317e <kmalloc+0x2c>
	bb->order = find_order(size);
ffffffffc0203186:	c088                	sw	a0,0(s1)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
ffffffffc0203188:	e4dff0ef          	jal	ra,ffffffffc0202fd4 <__slob_get_free_pages.constprop.0>
ffffffffc020318c:	e488                	sd	a0,8(s1)
ffffffffc020318e:	842a                	mv	s0,a0
	if (bb->pages)
ffffffffc0203190:	c525                	beqz	a0,ffffffffc02031f8 <kmalloc+0xa6>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203192:	100027f3          	csrr	a5,sstatus
ffffffffc0203196:	8b89                	andi	a5,a5,2
ffffffffc0203198:	ef8d                	bnez	a5,ffffffffc02031d2 <kmalloc+0x80>
		bb->next = bigblocks;
ffffffffc020319a:	000a7797          	auipc	a5,0xa7
ffffffffc020319e:	59e78793          	addi	a5,a5,1438 # ffffffffc02aa738 <bigblocks>
ffffffffc02031a2:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc02031a4:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc02031a6:	e898                	sd	a4,16(s1)
	return __kmalloc(size, 0);
}
ffffffffc02031a8:	60e2                	ld	ra,24(sp)
ffffffffc02031aa:	8522                	mv	a0,s0
ffffffffc02031ac:	6442                	ld	s0,16(sp)
ffffffffc02031ae:	64a2                	ld	s1,8(sp)
ffffffffc02031b0:	6902                	ld	s2,0(sp)
ffffffffc02031b2:	6105                	addi	sp,sp,32
ffffffffc02031b4:	8082                	ret
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
ffffffffc02031b6:	0541                	addi	a0,a0,16
ffffffffc02031b8:	e81ff0ef          	jal	ra,ffffffffc0203038 <slob_alloc.constprop.0>
		return m ? (void *)(m + 1) : 0;
ffffffffc02031bc:	01050413          	addi	s0,a0,16
ffffffffc02031c0:	f565                	bnez	a0,ffffffffc02031a8 <kmalloc+0x56>
ffffffffc02031c2:	4401                	li	s0,0
}
ffffffffc02031c4:	60e2                	ld	ra,24(sp)
ffffffffc02031c6:	8522                	mv	a0,s0
ffffffffc02031c8:	6442                	ld	s0,16(sp)
ffffffffc02031ca:	64a2                	ld	s1,8(sp)
ffffffffc02031cc:	6902                	ld	s2,0(sp)
ffffffffc02031ce:	6105                	addi	sp,sp,32
ffffffffc02031d0:	8082                	ret
        intr_disable();
ffffffffc02031d2:	fe8fd0ef          	jal	ra,ffffffffc02009ba <intr_disable>
		bb->next = bigblocks;
ffffffffc02031d6:	000a7797          	auipc	a5,0xa7
ffffffffc02031da:	56278793          	addi	a5,a5,1378 # ffffffffc02aa738 <bigblocks>
ffffffffc02031de:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc02031e0:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc02031e2:	e898                	sd	a4,16(s1)
        intr_enable();
ffffffffc02031e4:	fd0fd0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
		return bb->pages;
ffffffffc02031e8:	6480                	ld	s0,8(s1)
}
ffffffffc02031ea:	60e2                	ld	ra,24(sp)
ffffffffc02031ec:	64a2                	ld	s1,8(sp)
ffffffffc02031ee:	8522                	mv	a0,s0
ffffffffc02031f0:	6442                	ld	s0,16(sp)
ffffffffc02031f2:	6902                	ld	s2,0(sp)
ffffffffc02031f4:	6105                	addi	sp,sp,32
ffffffffc02031f6:	8082                	ret
	slob_free(bb, sizeof(bigblock_t));
ffffffffc02031f8:	45e1                	li	a1,24
ffffffffc02031fa:	8526                	mv	a0,s1
ffffffffc02031fc:	d25ff0ef          	jal	ra,ffffffffc0202f20 <slob_free>
	return __kmalloc(size, 0);
ffffffffc0203200:	b765                	j	ffffffffc02031a8 <kmalloc+0x56>

ffffffffc0203202 <kfree>:
void kfree(void *block)
{
	bigblock_t *bb, **last = &bigblocks;
	unsigned long flags;

	if (!block)
ffffffffc0203202:	c179                	beqz	a0,ffffffffc02032c8 <kfree+0xc6>
{
ffffffffc0203204:	1101                	addi	sp,sp,-32
ffffffffc0203206:	e822                	sd	s0,16(sp)
ffffffffc0203208:	ec06                	sd	ra,24(sp)
ffffffffc020320a:	e426                	sd	s1,8(sp)
		return;

	if (!((unsigned long)block & (PAGE_SIZE - 1)))
ffffffffc020320c:	03451793          	slli	a5,a0,0x34
ffffffffc0203210:	842a                	mv	s0,a0
ffffffffc0203212:	e7c1                	bnez	a5,ffffffffc020329a <kfree+0x98>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203214:	100027f3          	csrr	a5,sstatus
ffffffffc0203218:	8b89                	andi	a5,a5,2
ffffffffc020321a:	ebc9                	bnez	a5,ffffffffc02032ac <kfree+0xaa>
	{
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc020321c:	000a7797          	auipc	a5,0xa7
ffffffffc0203220:	51c7b783          	ld	a5,1308(a5) # ffffffffc02aa738 <bigblocks>
    return 0;
ffffffffc0203224:	4601                	li	a2,0
ffffffffc0203226:	cbb5                	beqz	a5,ffffffffc020329a <kfree+0x98>
	bigblock_t *bb, **last = &bigblocks;
ffffffffc0203228:	000a7697          	auipc	a3,0xa7
ffffffffc020322c:	51068693          	addi	a3,a3,1296 # ffffffffc02aa738 <bigblocks>
ffffffffc0203230:	a021                	j	ffffffffc0203238 <kfree+0x36>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0203232:	01048693          	addi	a3,s1,16
ffffffffc0203236:	c3ad                	beqz	a5,ffffffffc0203298 <kfree+0x96>
		{
			if (bb->pages == block)
ffffffffc0203238:	6798                	ld	a4,8(a5)
ffffffffc020323a:	84be                	mv	s1,a5
			{
				*last = bb->next;
ffffffffc020323c:	6b9c                	ld	a5,16(a5)
			if (bb->pages == block)
ffffffffc020323e:	fe871ae3          	bne	a4,s0,ffffffffc0203232 <kfree+0x30>
				*last = bb->next;
ffffffffc0203242:	e29c                	sd	a5,0(a3)
    if (flag)
ffffffffc0203244:	ee3d                	bnez	a2,ffffffffc02032c2 <kfree+0xc0>
    return pa2page(PADDR(kva));
ffffffffc0203246:	c02007b7          	lui	a5,0xc0200
				spin_unlock_irqrestore(&block_lock, flags);
				__slob_free_pages((unsigned long)block, bb->order);
ffffffffc020324a:	4098                	lw	a4,0(s1)
ffffffffc020324c:	08f46b63          	bltu	s0,a5,ffffffffc02032e2 <kfree+0xe0>
ffffffffc0203250:	000a7697          	auipc	a3,0xa7
ffffffffc0203254:	4e06b683          	ld	a3,1248(a3) # ffffffffc02aa730 <va_pa_offset>
ffffffffc0203258:	8c15                	sub	s0,s0,a3
    if (PPN(pa) >= npage)
ffffffffc020325a:	8031                	srli	s0,s0,0xc
ffffffffc020325c:	000a7797          	auipc	a5,0xa7
ffffffffc0203260:	4bc7b783          	ld	a5,1212(a5) # ffffffffc02aa718 <npage>
ffffffffc0203264:	06f47363          	bgeu	s0,a5,ffffffffc02032ca <kfree+0xc8>
    return &pages[PPN(pa) - nbase];
ffffffffc0203268:	00004517          	auipc	a0,0x4
ffffffffc020326c:	55853503          	ld	a0,1368(a0) # ffffffffc02077c0 <nbase>
ffffffffc0203270:	8c09                	sub	s0,s0,a0
ffffffffc0203272:	041a                	slli	s0,s0,0x6
	free_pages(kva2page(kva), 1 << order);
ffffffffc0203274:	000a7517          	auipc	a0,0xa7
ffffffffc0203278:	4ac53503          	ld	a0,1196(a0) # ffffffffc02aa720 <pages>
ffffffffc020327c:	4585                	li	a1,1
ffffffffc020327e:	9522                	add	a0,a0,s0
ffffffffc0203280:	00e595bb          	sllw	a1,a1,a4
ffffffffc0203284:	dadfd0ef          	jal	ra,ffffffffc0201030 <free_pages>
		spin_unlock_irqrestore(&block_lock, flags);
	}

	slob_free((slob_t *)block - 1, 0);
	return;
}
ffffffffc0203288:	6442                	ld	s0,16(sp)
ffffffffc020328a:	60e2                	ld	ra,24(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc020328c:	8526                	mv	a0,s1
}
ffffffffc020328e:	64a2                	ld	s1,8(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc0203290:	45e1                	li	a1,24
}
ffffffffc0203292:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0203294:	c8dff06f          	j	ffffffffc0202f20 <slob_free>
ffffffffc0203298:	e215                	bnez	a2,ffffffffc02032bc <kfree+0xba>
ffffffffc020329a:	ff040513          	addi	a0,s0,-16
}
ffffffffc020329e:	6442                	ld	s0,16(sp)
ffffffffc02032a0:	60e2                	ld	ra,24(sp)
ffffffffc02032a2:	64a2                	ld	s1,8(sp)
	slob_free((slob_t *)block - 1, 0);
ffffffffc02032a4:	4581                	li	a1,0
}
ffffffffc02032a6:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc02032a8:	c79ff06f          	j	ffffffffc0202f20 <slob_free>
        intr_disable();
ffffffffc02032ac:	f0efd0ef          	jal	ra,ffffffffc02009ba <intr_disable>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc02032b0:	000a7797          	auipc	a5,0xa7
ffffffffc02032b4:	4887b783          	ld	a5,1160(a5) # ffffffffc02aa738 <bigblocks>
        return 1;
ffffffffc02032b8:	4605                	li	a2,1
ffffffffc02032ba:	f7bd                	bnez	a5,ffffffffc0203228 <kfree+0x26>
        intr_enable();
ffffffffc02032bc:	ef8fd0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
ffffffffc02032c0:	bfe9                	j	ffffffffc020329a <kfree+0x98>
ffffffffc02032c2:	ef2fd0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
ffffffffc02032c6:	b741                	j	ffffffffc0203246 <kfree+0x44>
ffffffffc02032c8:	8082                	ret
        panic("pa2page called with invalid pa");
ffffffffc02032ca:	00003617          	auipc	a2,0x3
ffffffffc02032ce:	e3660613          	addi	a2,a2,-458 # ffffffffc0206100 <commands+0x7c8>
ffffffffc02032d2:	06900593          	li	a1,105
ffffffffc02032d6:	00003517          	auipc	a0,0x3
ffffffffc02032da:	e4a50513          	addi	a0,a0,-438 # ffffffffc0206120 <commands+0x7e8>
ffffffffc02032de:	f41fc0ef          	jal	ra,ffffffffc020021e <__panic>
    return pa2page(PADDR(kva));
ffffffffc02032e2:	86a2                	mv	a3,s0
ffffffffc02032e4:	00003617          	auipc	a2,0x3
ffffffffc02032e8:	f8460613          	addi	a2,a2,-124 # ffffffffc0206268 <commands+0x930>
ffffffffc02032ec:	07700593          	li	a1,119
ffffffffc02032f0:	00003517          	auipc	a0,0x3
ffffffffc02032f4:	e3050513          	addi	a0,a0,-464 # ffffffffc0206120 <commands+0x7e8>
ffffffffc02032f8:	f27fc0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc02032fc <default_init>:
    elm->prev = elm->next = elm;
ffffffffc02032fc:	000a3797          	auipc	a5,0xa3
ffffffffc0203300:	3bc78793          	addi	a5,a5,956 # ffffffffc02a66b8 <free_area>
ffffffffc0203304:	e79c                	sd	a5,8(a5)
ffffffffc0203306:	e39c                	sd	a5,0(a5)

static void
default_init(void)
{
    list_init(&free_list);
    nr_free = 0;
ffffffffc0203308:	0007a823          	sw	zero,16(a5)
}
ffffffffc020330c:	8082                	ret

ffffffffc020330e <default_nr_free_pages>:

static size_t
default_nr_free_pages(void)
{
    return nr_free;
}
ffffffffc020330e:	000a3517          	auipc	a0,0xa3
ffffffffc0203312:	3ba56503          	lwu	a0,954(a0) # ffffffffc02a66c8 <free_area+0x10>
ffffffffc0203316:	8082                	ret

ffffffffc0203318 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1)
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void)
{
ffffffffc0203318:	715d                	addi	sp,sp,-80
ffffffffc020331a:	e0a2                	sd	s0,64(sp)
    return listelm->next;
ffffffffc020331c:	000a3417          	auipc	s0,0xa3
ffffffffc0203320:	39c40413          	addi	s0,s0,924 # ffffffffc02a66b8 <free_area>
ffffffffc0203324:	641c                	ld	a5,8(s0)
ffffffffc0203326:	e486                	sd	ra,72(sp)
ffffffffc0203328:	fc26                	sd	s1,56(sp)
ffffffffc020332a:	f84a                	sd	s2,48(sp)
ffffffffc020332c:	f44e                	sd	s3,40(sp)
ffffffffc020332e:	f052                	sd	s4,32(sp)
ffffffffc0203330:	ec56                	sd	s5,24(sp)
ffffffffc0203332:	e85a                	sd	s6,16(sp)
ffffffffc0203334:	e45e                	sd	s7,8(sp)
ffffffffc0203336:	e062                	sd	s8,0(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list)
ffffffffc0203338:	2a878d63          	beq	a5,s0,ffffffffc02035f2 <default_check+0x2da>
    int count = 0, total = 0;
ffffffffc020333c:	4481                	li	s1,0
ffffffffc020333e:	4901                	li	s2,0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0203340:	ff07b703          	ld	a4,-16(a5)
    {
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0203344:	8b09                	andi	a4,a4,2
ffffffffc0203346:	2a070a63          	beqz	a4,ffffffffc02035fa <default_check+0x2e2>
        count++, total += p->property;
ffffffffc020334a:	ff87a703          	lw	a4,-8(a5)
ffffffffc020334e:	679c                	ld	a5,8(a5)
ffffffffc0203350:	2905                	addiw	s2,s2,1
ffffffffc0203352:	9cb9                	addw	s1,s1,a4
    while ((le = list_next(le)) != &free_list)
ffffffffc0203354:	fe8796e3          	bne	a5,s0,ffffffffc0203340 <default_check+0x28>
    }
    assert(total == nr_free_pages());
ffffffffc0203358:	89a6                	mv	s3,s1
ffffffffc020335a:	d17fd0ef          	jal	ra,ffffffffc0201070 <nr_free_pages>
ffffffffc020335e:	6f351e63          	bne	a0,s3,ffffffffc0203a5a <default_check+0x742>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0203362:	4505                	li	a0,1
ffffffffc0203364:	c8ffd0ef          	jal	ra,ffffffffc0200ff2 <alloc_pages>
ffffffffc0203368:	8aaa                	mv	s5,a0
ffffffffc020336a:	42050863          	beqz	a0,ffffffffc020379a <default_check+0x482>
    assert((p1 = alloc_page()) != NULL);
ffffffffc020336e:	4505                	li	a0,1
ffffffffc0203370:	c83fd0ef          	jal	ra,ffffffffc0200ff2 <alloc_pages>
ffffffffc0203374:	89aa                	mv	s3,a0
ffffffffc0203376:	70050263          	beqz	a0,ffffffffc0203a7a <default_check+0x762>
    assert((p2 = alloc_page()) != NULL);
ffffffffc020337a:	4505                	li	a0,1
ffffffffc020337c:	c77fd0ef          	jal	ra,ffffffffc0200ff2 <alloc_pages>
ffffffffc0203380:	8a2a                	mv	s4,a0
ffffffffc0203382:	48050c63          	beqz	a0,ffffffffc020381a <default_check+0x502>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0203386:	293a8a63          	beq	s5,s3,ffffffffc020361a <default_check+0x302>
ffffffffc020338a:	28aa8863          	beq	s5,a0,ffffffffc020361a <default_check+0x302>
ffffffffc020338e:	28a98663          	beq	s3,a0,ffffffffc020361a <default_check+0x302>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0203392:	000aa783          	lw	a5,0(s5)
ffffffffc0203396:	2a079263          	bnez	a5,ffffffffc020363a <default_check+0x322>
ffffffffc020339a:	0009a783          	lw	a5,0(s3)
ffffffffc020339e:	28079e63          	bnez	a5,ffffffffc020363a <default_check+0x322>
ffffffffc02033a2:	411c                	lw	a5,0(a0)
ffffffffc02033a4:	28079b63          	bnez	a5,ffffffffc020363a <default_check+0x322>
    return page - pages + nbase;
ffffffffc02033a8:	000a7797          	auipc	a5,0xa7
ffffffffc02033ac:	3787b783          	ld	a5,888(a5) # ffffffffc02aa720 <pages>
ffffffffc02033b0:	40fa8733          	sub	a4,s5,a5
ffffffffc02033b4:	00004617          	auipc	a2,0x4
ffffffffc02033b8:	40c63603          	ld	a2,1036(a2) # ffffffffc02077c0 <nbase>
ffffffffc02033bc:	8719                	srai	a4,a4,0x6
ffffffffc02033be:	9732                	add	a4,a4,a2
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc02033c0:	000a7697          	auipc	a3,0xa7
ffffffffc02033c4:	3586b683          	ld	a3,856(a3) # ffffffffc02aa718 <npage>
ffffffffc02033c8:	06b2                	slli	a3,a3,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc02033ca:	0732                	slli	a4,a4,0xc
ffffffffc02033cc:	28d77763          	bgeu	a4,a3,ffffffffc020365a <default_check+0x342>
    return page - pages + nbase;
ffffffffc02033d0:	40f98733          	sub	a4,s3,a5
ffffffffc02033d4:	8719                	srai	a4,a4,0x6
ffffffffc02033d6:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc02033d8:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc02033da:	4cd77063          	bgeu	a4,a3,ffffffffc020389a <default_check+0x582>
    return page - pages + nbase;
ffffffffc02033de:	40f507b3          	sub	a5,a0,a5
ffffffffc02033e2:	8799                	srai	a5,a5,0x6
ffffffffc02033e4:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc02033e6:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc02033e8:	30d7f963          	bgeu	a5,a3,ffffffffc02036fa <default_check+0x3e2>
    assert(alloc_page() == NULL);
ffffffffc02033ec:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc02033ee:	00043c03          	ld	s8,0(s0)
ffffffffc02033f2:	00843b83          	ld	s7,8(s0)
    unsigned int nr_free_store = nr_free;
ffffffffc02033f6:	01042b03          	lw	s6,16(s0)
    elm->prev = elm->next = elm;
ffffffffc02033fa:	e400                	sd	s0,8(s0)
ffffffffc02033fc:	e000                	sd	s0,0(s0)
    nr_free = 0;
ffffffffc02033fe:	000a3797          	auipc	a5,0xa3
ffffffffc0203402:	2c07a523          	sw	zero,714(a5) # ffffffffc02a66c8 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc0203406:	bedfd0ef          	jal	ra,ffffffffc0200ff2 <alloc_pages>
ffffffffc020340a:	2c051863          	bnez	a0,ffffffffc02036da <default_check+0x3c2>
    free_page(p0);
ffffffffc020340e:	4585                	li	a1,1
ffffffffc0203410:	8556                	mv	a0,s5
ffffffffc0203412:	c1ffd0ef          	jal	ra,ffffffffc0201030 <free_pages>
    free_page(p1);
ffffffffc0203416:	4585                	li	a1,1
ffffffffc0203418:	854e                	mv	a0,s3
ffffffffc020341a:	c17fd0ef          	jal	ra,ffffffffc0201030 <free_pages>
    free_page(p2);
ffffffffc020341e:	4585                	li	a1,1
ffffffffc0203420:	8552                	mv	a0,s4
ffffffffc0203422:	c0ffd0ef          	jal	ra,ffffffffc0201030 <free_pages>
    assert(nr_free == 3);
ffffffffc0203426:	4818                	lw	a4,16(s0)
ffffffffc0203428:	478d                	li	a5,3
ffffffffc020342a:	28f71863          	bne	a4,a5,ffffffffc02036ba <default_check+0x3a2>
    assert((p0 = alloc_page()) != NULL);
ffffffffc020342e:	4505                	li	a0,1
ffffffffc0203430:	bc3fd0ef          	jal	ra,ffffffffc0200ff2 <alloc_pages>
ffffffffc0203434:	89aa                	mv	s3,a0
ffffffffc0203436:	26050263          	beqz	a0,ffffffffc020369a <default_check+0x382>
    assert((p1 = alloc_page()) != NULL);
ffffffffc020343a:	4505                	li	a0,1
ffffffffc020343c:	bb7fd0ef          	jal	ra,ffffffffc0200ff2 <alloc_pages>
ffffffffc0203440:	8aaa                	mv	s5,a0
ffffffffc0203442:	3a050c63          	beqz	a0,ffffffffc02037fa <default_check+0x4e2>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0203446:	4505                	li	a0,1
ffffffffc0203448:	babfd0ef          	jal	ra,ffffffffc0200ff2 <alloc_pages>
ffffffffc020344c:	8a2a                	mv	s4,a0
ffffffffc020344e:	38050663          	beqz	a0,ffffffffc02037da <default_check+0x4c2>
    assert(alloc_page() == NULL);
ffffffffc0203452:	4505                	li	a0,1
ffffffffc0203454:	b9ffd0ef          	jal	ra,ffffffffc0200ff2 <alloc_pages>
ffffffffc0203458:	36051163          	bnez	a0,ffffffffc02037ba <default_check+0x4a2>
    free_page(p0);
ffffffffc020345c:	4585                	li	a1,1
ffffffffc020345e:	854e                	mv	a0,s3
ffffffffc0203460:	bd1fd0ef          	jal	ra,ffffffffc0201030 <free_pages>
    assert(!list_empty(&free_list));
ffffffffc0203464:	641c                	ld	a5,8(s0)
ffffffffc0203466:	20878a63          	beq	a5,s0,ffffffffc020367a <default_check+0x362>
    assert((p = alloc_page()) == p0);
ffffffffc020346a:	4505                	li	a0,1
ffffffffc020346c:	b87fd0ef          	jal	ra,ffffffffc0200ff2 <alloc_pages>
ffffffffc0203470:	30a99563          	bne	s3,a0,ffffffffc020377a <default_check+0x462>
    assert(alloc_page() == NULL);
ffffffffc0203474:	4505                	li	a0,1
ffffffffc0203476:	b7dfd0ef          	jal	ra,ffffffffc0200ff2 <alloc_pages>
ffffffffc020347a:	2e051063          	bnez	a0,ffffffffc020375a <default_check+0x442>
    assert(nr_free == 0);
ffffffffc020347e:	481c                	lw	a5,16(s0)
ffffffffc0203480:	2a079d63          	bnez	a5,ffffffffc020373a <default_check+0x422>
    free_page(p);
ffffffffc0203484:	854e                	mv	a0,s3
ffffffffc0203486:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc0203488:	01843023          	sd	s8,0(s0)
ffffffffc020348c:	01743423          	sd	s7,8(s0)
    nr_free = nr_free_store;
ffffffffc0203490:	01642823          	sw	s6,16(s0)
    free_page(p);
ffffffffc0203494:	b9dfd0ef          	jal	ra,ffffffffc0201030 <free_pages>
    free_page(p1);
ffffffffc0203498:	4585                	li	a1,1
ffffffffc020349a:	8556                	mv	a0,s5
ffffffffc020349c:	b95fd0ef          	jal	ra,ffffffffc0201030 <free_pages>
    free_page(p2);
ffffffffc02034a0:	4585                	li	a1,1
ffffffffc02034a2:	8552                	mv	a0,s4
ffffffffc02034a4:	b8dfd0ef          	jal	ra,ffffffffc0201030 <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc02034a8:	4515                	li	a0,5
ffffffffc02034aa:	b49fd0ef          	jal	ra,ffffffffc0200ff2 <alloc_pages>
ffffffffc02034ae:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc02034b0:	26050563          	beqz	a0,ffffffffc020371a <default_check+0x402>
ffffffffc02034b4:	651c                	ld	a5,8(a0)
ffffffffc02034b6:	8385                	srli	a5,a5,0x1
ffffffffc02034b8:	8b85                	andi	a5,a5,1
    assert(!PageProperty(p0));
ffffffffc02034ba:	54079063          	bnez	a5,ffffffffc02039fa <default_check+0x6e2>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc02034be:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc02034c0:	00043b03          	ld	s6,0(s0)
ffffffffc02034c4:	00843a83          	ld	s5,8(s0)
ffffffffc02034c8:	e000                	sd	s0,0(s0)
ffffffffc02034ca:	e400                	sd	s0,8(s0)
    assert(alloc_page() == NULL);
ffffffffc02034cc:	b27fd0ef          	jal	ra,ffffffffc0200ff2 <alloc_pages>
ffffffffc02034d0:	50051563          	bnez	a0,ffffffffc02039da <default_check+0x6c2>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc02034d4:	08098a13          	addi	s4,s3,128
ffffffffc02034d8:	8552                	mv	a0,s4
ffffffffc02034da:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc02034dc:	01042b83          	lw	s7,16(s0)
    nr_free = 0;
ffffffffc02034e0:	000a3797          	auipc	a5,0xa3
ffffffffc02034e4:	1e07a423          	sw	zero,488(a5) # ffffffffc02a66c8 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc02034e8:	b49fd0ef          	jal	ra,ffffffffc0201030 <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc02034ec:	4511                	li	a0,4
ffffffffc02034ee:	b05fd0ef          	jal	ra,ffffffffc0200ff2 <alloc_pages>
ffffffffc02034f2:	4c051463          	bnez	a0,ffffffffc02039ba <default_check+0x6a2>
ffffffffc02034f6:	0889b783          	ld	a5,136(s3)
ffffffffc02034fa:	8385                	srli	a5,a5,0x1
ffffffffc02034fc:	8b85                	andi	a5,a5,1
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc02034fe:	48078e63          	beqz	a5,ffffffffc020399a <default_check+0x682>
ffffffffc0203502:	0909a703          	lw	a4,144(s3)
ffffffffc0203506:	478d                	li	a5,3
ffffffffc0203508:	48f71963          	bne	a4,a5,ffffffffc020399a <default_check+0x682>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc020350c:	450d                	li	a0,3
ffffffffc020350e:	ae5fd0ef          	jal	ra,ffffffffc0200ff2 <alloc_pages>
ffffffffc0203512:	8c2a                	mv	s8,a0
ffffffffc0203514:	46050363          	beqz	a0,ffffffffc020397a <default_check+0x662>
    assert(alloc_page() == NULL);
ffffffffc0203518:	4505                	li	a0,1
ffffffffc020351a:	ad9fd0ef          	jal	ra,ffffffffc0200ff2 <alloc_pages>
ffffffffc020351e:	42051e63          	bnez	a0,ffffffffc020395a <default_check+0x642>
    assert(p0 + 2 == p1);
ffffffffc0203522:	418a1c63          	bne	s4,s8,ffffffffc020393a <default_check+0x622>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc0203526:	4585                	li	a1,1
ffffffffc0203528:	854e                	mv	a0,s3
ffffffffc020352a:	b07fd0ef          	jal	ra,ffffffffc0201030 <free_pages>
    free_pages(p1, 3);
ffffffffc020352e:	458d                	li	a1,3
ffffffffc0203530:	8552                	mv	a0,s4
ffffffffc0203532:	afffd0ef          	jal	ra,ffffffffc0201030 <free_pages>
ffffffffc0203536:	0089b783          	ld	a5,8(s3)
    p2 = p0 + 1;
ffffffffc020353a:	04098c13          	addi	s8,s3,64
ffffffffc020353e:	8385                	srli	a5,a5,0x1
ffffffffc0203540:	8b85                	andi	a5,a5,1
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0203542:	3c078c63          	beqz	a5,ffffffffc020391a <default_check+0x602>
ffffffffc0203546:	0109a703          	lw	a4,16(s3)
ffffffffc020354a:	4785                	li	a5,1
ffffffffc020354c:	3cf71763          	bne	a4,a5,ffffffffc020391a <default_check+0x602>
ffffffffc0203550:	008a3783          	ld	a5,8(s4) # 1008 <_binary_obj___user_faultread_out_size-0x8ba8>
ffffffffc0203554:	8385                	srli	a5,a5,0x1
ffffffffc0203556:	8b85                	andi	a5,a5,1
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0203558:	3a078163          	beqz	a5,ffffffffc02038fa <default_check+0x5e2>
ffffffffc020355c:	010a2703          	lw	a4,16(s4)
ffffffffc0203560:	478d                	li	a5,3
ffffffffc0203562:	38f71c63          	bne	a4,a5,ffffffffc02038fa <default_check+0x5e2>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0203566:	4505                	li	a0,1
ffffffffc0203568:	a8bfd0ef          	jal	ra,ffffffffc0200ff2 <alloc_pages>
ffffffffc020356c:	36a99763          	bne	s3,a0,ffffffffc02038da <default_check+0x5c2>
    free_page(p0);
ffffffffc0203570:	4585                	li	a1,1
ffffffffc0203572:	abffd0ef          	jal	ra,ffffffffc0201030 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0203576:	4509                	li	a0,2
ffffffffc0203578:	a7bfd0ef          	jal	ra,ffffffffc0200ff2 <alloc_pages>
ffffffffc020357c:	32aa1f63          	bne	s4,a0,ffffffffc02038ba <default_check+0x5a2>

    free_pages(p0, 2);
ffffffffc0203580:	4589                	li	a1,2
ffffffffc0203582:	aaffd0ef          	jal	ra,ffffffffc0201030 <free_pages>
    free_page(p2);
ffffffffc0203586:	4585                	li	a1,1
ffffffffc0203588:	8562                	mv	a0,s8
ffffffffc020358a:	aa7fd0ef          	jal	ra,ffffffffc0201030 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc020358e:	4515                	li	a0,5
ffffffffc0203590:	a63fd0ef          	jal	ra,ffffffffc0200ff2 <alloc_pages>
ffffffffc0203594:	89aa                	mv	s3,a0
ffffffffc0203596:	48050263          	beqz	a0,ffffffffc0203a1a <default_check+0x702>
    assert(alloc_page() == NULL);
ffffffffc020359a:	4505                	li	a0,1
ffffffffc020359c:	a57fd0ef          	jal	ra,ffffffffc0200ff2 <alloc_pages>
ffffffffc02035a0:	2c051d63          	bnez	a0,ffffffffc020387a <default_check+0x562>

    assert(nr_free == 0);
ffffffffc02035a4:	481c                	lw	a5,16(s0)
ffffffffc02035a6:	2a079a63          	bnez	a5,ffffffffc020385a <default_check+0x542>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc02035aa:	4595                	li	a1,5
ffffffffc02035ac:	854e                	mv	a0,s3
    nr_free = nr_free_store;
ffffffffc02035ae:	01742823          	sw	s7,16(s0)
    free_list = free_list_store;
ffffffffc02035b2:	01643023          	sd	s6,0(s0)
ffffffffc02035b6:	01543423          	sd	s5,8(s0)
    free_pages(p0, 5);
ffffffffc02035ba:	a77fd0ef          	jal	ra,ffffffffc0201030 <free_pages>
    return listelm->next;
ffffffffc02035be:	641c                	ld	a5,8(s0)

    le = &free_list;
    while ((le = list_next(le)) != &free_list)
ffffffffc02035c0:	00878963          	beq	a5,s0,ffffffffc02035d2 <default_check+0x2ba>
    {
        struct Page *p = le2page(le, page_link);
        count--, total -= p->property;
ffffffffc02035c4:	ff87a703          	lw	a4,-8(a5)
ffffffffc02035c8:	679c                	ld	a5,8(a5)
ffffffffc02035ca:	397d                	addiw	s2,s2,-1
ffffffffc02035cc:	9c99                	subw	s1,s1,a4
    while ((le = list_next(le)) != &free_list)
ffffffffc02035ce:	fe879be3          	bne	a5,s0,ffffffffc02035c4 <default_check+0x2ac>
    }
    assert(count == 0);
ffffffffc02035d2:	26091463          	bnez	s2,ffffffffc020383a <default_check+0x522>
    assert(total == 0);
ffffffffc02035d6:	46049263          	bnez	s1,ffffffffc0203a3a <default_check+0x722>
}
ffffffffc02035da:	60a6                	ld	ra,72(sp)
ffffffffc02035dc:	6406                	ld	s0,64(sp)
ffffffffc02035de:	74e2                	ld	s1,56(sp)
ffffffffc02035e0:	7942                	ld	s2,48(sp)
ffffffffc02035e2:	79a2                	ld	s3,40(sp)
ffffffffc02035e4:	7a02                	ld	s4,32(sp)
ffffffffc02035e6:	6ae2                	ld	s5,24(sp)
ffffffffc02035e8:	6b42                	ld	s6,16(sp)
ffffffffc02035ea:	6ba2                	ld	s7,8(sp)
ffffffffc02035ec:	6c02                	ld	s8,0(sp)
ffffffffc02035ee:	6161                	addi	sp,sp,80
ffffffffc02035f0:	8082                	ret
    while ((le = list_next(le)) != &free_list)
ffffffffc02035f2:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc02035f4:	4481                	li	s1,0
ffffffffc02035f6:	4901                	li	s2,0
ffffffffc02035f8:	b38d                	j	ffffffffc020335a <default_check+0x42>
        assert(PageProperty(p));
ffffffffc02035fa:	00003697          	auipc	a3,0x3
ffffffffc02035fe:	4ee68693          	addi	a3,a3,1262 # ffffffffc0206ae8 <commands+0x11b0>
ffffffffc0203602:	00003617          	auipc	a2,0x3
ffffffffc0203606:	bbe60613          	addi	a2,a2,-1090 # ffffffffc02061c0 <commands+0x888>
ffffffffc020360a:	11000593          	li	a1,272
ffffffffc020360e:	00003517          	auipc	a0,0x3
ffffffffc0203612:	4ea50513          	addi	a0,a0,1258 # ffffffffc0206af8 <commands+0x11c0>
ffffffffc0203616:	c09fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc020361a:	00003697          	auipc	a3,0x3
ffffffffc020361e:	57668693          	addi	a3,a3,1398 # ffffffffc0206b90 <commands+0x1258>
ffffffffc0203622:	00003617          	auipc	a2,0x3
ffffffffc0203626:	b9e60613          	addi	a2,a2,-1122 # ffffffffc02061c0 <commands+0x888>
ffffffffc020362a:	0db00593          	li	a1,219
ffffffffc020362e:	00003517          	auipc	a0,0x3
ffffffffc0203632:	4ca50513          	addi	a0,a0,1226 # ffffffffc0206af8 <commands+0x11c0>
ffffffffc0203636:	be9fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc020363a:	00003697          	auipc	a3,0x3
ffffffffc020363e:	57e68693          	addi	a3,a3,1406 # ffffffffc0206bb8 <commands+0x1280>
ffffffffc0203642:	00003617          	auipc	a2,0x3
ffffffffc0203646:	b7e60613          	addi	a2,a2,-1154 # ffffffffc02061c0 <commands+0x888>
ffffffffc020364a:	0dc00593          	li	a1,220
ffffffffc020364e:	00003517          	auipc	a0,0x3
ffffffffc0203652:	4aa50513          	addi	a0,a0,1194 # ffffffffc0206af8 <commands+0x11c0>
ffffffffc0203656:	bc9fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc020365a:	00003697          	auipc	a3,0x3
ffffffffc020365e:	59e68693          	addi	a3,a3,1438 # ffffffffc0206bf8 <commands+0x12c0>
ffffffffc0203662:	00003617          	auipc	a2,0x3
ffffffffc0203666:	b5e60613          	addi	a2,a2,-1186 # ffffffffc02061c0 <commands+0x888>
ffffffffc020366a:	0de00593          	li	a1,222
ffffffffc020366e:	00003517          	auipc	a0,0x3
ffffffffc0203672:	48a50513          	addi	a0,a0,1162 # ffffffffc0206af8 <commands+0x11c0>
ffffffffc0203676:	ba9fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(!list_empty(&free_list));
ffffffffc020367a:	00003697          	auipc	a3,0x3
ffffffffc020367e:	60668693          	addi	a3,a3,1542 # ffffffffc0206c80 <commands+0x1348>
ffffffffc0203682:	00003617          	auipc	a2,0x3
ffffffffc0203686:	b3e60613          	addi	a2,a2,-1218 # ffffffffc02061c0 <commands+0x888>
ffffffffc020368a:	0f700593          	li	a1,247
ffffffffc020368e:	00003517          	auipc	a0,0x3
ffffffffc0203692:	46a50513          	addi	a0,a0,1130 # ffffffffc0206af8 <commands+0x11c0>
ffffffffc0203696:	b89fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc020369a:	00003697          	auipc	a3,0x3
ffffffffc020369e:	49668693          	addi	a3,a3,1174 # ffffffffc0206b30 <commands+0x11f8>
ffffffffc02036a2:	00003617          	auipc	a2,0x3
ffffffffc02036a6:	b1e60613          	addi	a2,a2,-1250 # ffffffffc02061c0 <commands+0x888>
ffffffffc02036aa:	0f000593          	li	a1,240
ffffffffc02036ae:	00003517          	auipc	a0,0x3
ffffffffc02036b2:	44a50513          	addi	a0,a0,1098 # ffffffffc0206af8 <commands+0x11c0>
ffffffffc02036b6:	b69fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(nr_free == 3);
ffffffffc02036ba:	00003697          	auipc	a3,0x3
ffffffffc02036be:	5b668693          	addi	a3,a3,1462 # ffffffffc0206c70 <commands+0x1338>
ffffffffc02036c2:	00003617          	auipc	a2,0x3
ffffffffc02036c6:	afe60613          	addi	a2,a2,-1282 # ffffffffc02061c0 <commands+0x888>
ffffffffc02036ca:	0ee00593          	li	a1,238
ffffffffc02036ce:	00003517          	auipc	a0,0x3
ffffffffc02036d2:	42a50513          	addi	a0,a0,1066 # ffffffffc0206af8 <commands+0x11c0>
ffffffffc02036d6:	b49fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(alloc_page() == NULL);
ffffffffc02036da:	00003697          	auipc	a3,0x3
ffffffffc02036de:	57e68693          	addi	a3,a3,1406 # ffffffffc0206c58 <commands+0x1320>
ffffffffc02036e2:	00003617          	auipc	a2,0x3
ffffffffc02036e6:	ade60613          	addi	a2,a2,-1314 # ffffffffc02061c0 <commands+0x888>
ffffffffc02036ea:	0e900593          	li	a1,233
ffffffffc02036ee:	00003517          	auipc	a0,0x3
ffffffffc02036f2:	40a50513          	addi	a0,a0,1034 # ffffffffc0206af8 <commands+0x11c0>
ffffffffc02036f6:	b29fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc02036fa:	00003697          	auipc	a3,0x3
ffffffffc02036fe:	53e68693          	addi	a3,a3,1342 # ffffffffc0206c38 <commands+0x1300>
ffffffffc0203702:	00003617          	auipc	a2,0x3
ffffffffc0203706:	abe60613          	addi	a2,a2,-1346 # ffffffffc02061c0 <commands+0x888>
ffffffffc020370a:	0e000593          	li	a1,224
ffffffffc020370e:	00003517          	auipc	a0,0x3
ffffffffc0203712:	3ea50513          	addi	a0,a0,1002 # ffffffffc0206af8 <commands+0x11c0>
ffffffffc0203716:	b09fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(p0 != NULL);
ffffffffc020371a:	00003697          	auipc	a3,0x3
ffffffffc020371e:	5ae68693          	addi	a3,a3,1454 # ffffffffc0206cc8 <commands+0x1390>
ffffffffc0203722:	00003617          	auipc	a2,0x3
ffffffffc0203726:	a9e60613          	addi	a2,a2,-1378 # ffffffffc02061c0 <commands+0x888>
ffffffffc020372a:	11800593          	li	a1,280
ffffffffc020372e:	00003517          	auipc	a0,0x3
ffffffffc0203732:	3ca50513          	addi	a0,a0,970 # ffffffffc0206af8 <commands+0x11c0>
ffffffffc0203736:	ae9fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(nr_free == 0);
ffffffffc020373a:	00003697          	auipc	a3,0x3
ffffffffc020373e:	57e68693          	addi	a3,a3,1406 # ffffffffc0206cb8 <commands+0x1380>
ffffffffc0203742:	00003617          	auipc	a2,0x3
ffffffffc0203746:	a7e60613          	addi	a2,a2,-1410 # ffffffffc02061c0 <commands+0x888>
ffffffffc020374a:	0fd00593          	li	a1,253
ffffffffc020374e:	00003517          	auipc	a0,0x3
ffffffffc0203752:	3aa50513          	addi	a0,a0,938 # ffffffffc0206af8 <commands+0x11c0>
ffffffffc0203756:	ac9fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(alloc_page() == NULL);
ffffffffc020375a:	00003697          	auipc	a3,0x3
ffffffffc020375e:	4fe68693          	addi	a3,a3,1278 # ffffffffc0206c58 <commands+0x1320>
ffffffffc0203762:	00003617          	auipc	a2,0x3
ffffffffc0203766:	a5e60613          	addi	a2,a2,-1442 # ffffffffc02061c0 <commands+0x888>
ffffffffc020376a:	0fb00593          	li	a1,251
ffffffffc020376e:	00003517          	auipc	a0,0x3
ffffffffc0203772:	38a50513          	addi	a0,a0,906 # ffffffffc0206af8 <commands+0x11c0>
ffffffffc0203776:	aa9fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc020377a:	00003697          	auipc	a3,0x3
ffffffffc020377e:	51e68693          	addi	a3,a3,1310 # ffffffffc0206c98 <commands+0x1360>
ffffffffc0203782:	00003617          	auipc	a2,0x3
ffffffffc0203786:	a3e60613          	addi	a2,a2,-1474 # ffffffffc02061c0 <commands+0x888>
ffffffffc020378a:	0fa00593          	li	a1,250
ffffffffc020378e:	00003517          	auipc	a0,0x3
ffffffffc0203792:	36a50513          	addi	a0,a0,874 # ffffffffc0206af8 <commands+0x11c0>
ffffffffc0203796:	a89fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc020379a:	00003697          	auipc	a3,0x3
ffffffffc020379e:	39668693          	addi	a3,a3,918 # ffffffffc0206b30 <commands+0x11f8>
ffffffffc02037a2:	00003617          	auipc	a2,0x3
ffffffffc02037a6:	a1e60613          	addi	a2,a2,-1506 # ffffffffc02061c0 <commands+0x888>
ffffffffc02037aa:	0d700593          	li	a1,215
ffffffffc02037ae:	00003517          	auipc	a0,0x3
ffffffffc02037b2:	34a50513          	addi	a0,a0,842 # ffffffffc0206af8 <commands+0x11c0>
ffffffffc02037b6:	a69fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(alloc_page() == NULL);
ffffffffc02037ba:	00003697          	auipc	a3,0x3
ffffffffc02037be:	49e68693          	addi	a3,a3,1182 # ffffffffc0206c58 <commands+0x1320>
ffffffffc02037c2:	00003617          	auipc	a2,0x3
ffffffffc02037c6:	9fe60613          	addi	a2,a2,-1538 # ffffffffc02061c0 <commands+0x888>
ffffffffc02037ca:	0f400593          	li	a1,244
ffffffffc02037ce:	00003517          	auipc	a0,0x3
ffffffffc02037d2:	32a50513          	addi	a0,a0,810 # ffffffffc0206af8 <commands+0x11c0>
ffffffffc02037d6:	a49fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02037da:	00003697          	auipc	a3,0x3
ffffffffc02037de:	39668693          	addi	a3,a3,918 # ffffffffc0206b70 <commands+0x1238>
ffffffffc02037e2:	00003617          	auipc	a2,0x3
ffffffffc02037e6:	9de60613          	addi	a2,a2,-1570 # ffffffffc02061c0 <commands+0x888>
ffffffffc02037ea:	0f200593          	li	a1,242
ffffffffc02037ee:	00003517          	auipc	a0,0x3
ffffffffc02037f2:	30a50513          	addi	a0,a0,778 # ffffffffc0206af8 <commands+0x11c0>
ffffffffc02037f6:	a29fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02037fa:	00003697          	auipc	a3,0x3
ffffffffc02037fe:	35668693          	addi	a3,a3,854 # ffffffffc0206b50 <commands+0x1218>
ffffffffc0203802:	00003617          	auipc	a2,0x3
ffffffffc0203806:	9be60613          	addi	a2,a2,-1602 # ffffffffc02061c0 <commands+0x888>
ffffffffc020380a:	0f100593          	li	a1,241
ffffffffc020380e:	00003517          	auipc	a0,0x3
ffffffffc0203812:	2ea50513          	addi	a0,a0,746 # ffffffffc0206af8 <commands+0x11c0>
ffffffffc0203816:	a09fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc020381a:	00003697          	auipc	a3,0x3
ffffffffc020381e:	35668693          	addi	a3,a3,854 # ffffffffc0206b70 <commands+0x1238>
ffffffffc0203822:	00003617          	auipc	a2,0x3
ffffffffc0203826:	99e60613          	addi	a2,a2,-1634 # ffffffffc02061c0 <commands+0x888>
ffffffffc020382a:	0d900593          	li	a1,217
ffffffffc020382e:	00003517          	auipc	a0,0x3
ffffffffc0203832:	2ca50513          	addi	a0,a0,714 # ffffffffc0206af8 <commands+0x11c0>
ffffffffc0203836:	9e9fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(count == 0);
ffffffffc020383a:	00003697          	auipc	a3,0x3
ffffffffc020383e:	5de68693          	addi	a3,a3,1502 # ffffffffc0206e18 <commands+0x14e0>
ffffffffc0203842:	00003617          	auipc	a2,0x3
ffffffffc0203846:	97e60613          	addi	a2,a2,-1666 # ffffffffc02061c0 <commands+0x888>
ffffffffc020384a:	14600593          	li	a1,326
ffffffffc020384e:	00003517          	auipc	a0,0x3
ffffffffc0203852:	2aa50513          	addi	a0,a0,682 # ffffffffc0206af8 <commands+0x11c0>
ffffffffc0203856:	9c9fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(nr_free == 0);
ffffffffc020385a:	00003697          	auipc	a3,0x3
ffffffffc020385e:	45e68693          	addi	a3,a3,1118 # ffffffffc0206cb8 <commands+0x1380>
ffffffffc0203862:	00003617          	auipc	a2,0x3
ffffffffc0203866:	95e60613          	addi	a2,a2,-1698 # ffffffffc02061c0 <commands+0x888>
ffffffffc020386a:	13a00593          	li	a1,314
ffffffffc020386e:	00003517          	auipc	a0,0x3
ffffffffc0203872:	28a50513          	addi	a0,a0,650 # ffffffffc0206af8 <commands+0x11c0>
ffffffffc0203876:	9a9fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(alloc_page() == NULL);
ffffffffc020387a:	00003697          	auipc	a3,0x3
ffffffffc020387e:	3de68693          	addi	a3,a3,990 # ffffffffc0206c58 <commands+0x1320>
ffffffffc0203882:	00003617          	auipc	a2,0x3
ffffffffc0203886:	93e60613          	addi	a2,a2,-1730 # ffffffffc02061c0 <commands+0x888>
ffffffffc020388a:	13800593          	li	a1,312
ffffffffc020388e:	00003517          	auipc	a0,0x3
ffffffffc0203892:	26a50513          	addi	a0,a0,618 # ffffffffc0206af8 <commands+0x11c0>
ffffffffc0203896:	989fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc020389a:	00003697          	auipc	a3,0x3
ffffffffc020389e:	37e68693          	addi	a3,a3,894 # ffffffffc0206c18 <commands+0x12e0>
ffffffffc02038a2:	00003617          	auipc	a2,0x3
ffffffffc02038a6:	91e60613          	addi	a2,a2,-1762 # ffffffffc02061c0 <commands+0x888>
ffffffffc02038aa:	0df00593          	li	a1,223
ffffffffc02038ae:	00003517          	auipc	a0,0x3
ffffffffc02038b2:	24a50513          	addi	a0,a0,586 # ffffffffc0206af8 <commands+0x11c0>
ffffffffc02038b6:	969fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc02038ba:	00003697          	auipc	a3,0x3
ffffffffc02038be:	51e68693          	addi	a3,a3,1310 # ffffffffc0206dd8 <commands+0x14a0>
ffffffffc02038c2:	00003617          	auipc	a2,0x3
ffffffffc02038c6:	8fe60613          	addi	a2,a2,-1794 # ffffffffc02061c0 <commands+0x888>
ffffffffc02038ca:	13200593          	li	a1,306
ffffffffc02038ce:	00003517          	auipc	a0,0x3
ffffffffc02038d2:	22a50513          	addi	a0,a0,554 # ffffffffc0206af8 <commands+0x11c0>
ffffffffc02038d6:	949fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc02038da:	00003697          	auipc	a3,0x3
ffffffffc02038de:	4de68693          	addi	a3,a3,1246 # ffffffffc0206db8 <commands+0x1480>
ffffffffc02038e2:	00003617          	auipc	a2,0x3
ffffffffc02038e6:	8de60613          	addi	a2,a2,-1826 # ffffffffc02061c0 <commands+0x888>
ffffffffc02038ea:	13000593          	li	a1,304
ffffffffc02038ee:	00003517          	auipc	a0,0x3
ffffffffc02038f2:	20a50513          	addi	a0,a0,522 # ffffffffc0206af8 <commands+0x11c0>
ffffffffc02038f6:	929fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc02038fa:	00003697          	auipc	a3,0x3
ffffffffc02038fe:	49668693          	addi	a3,a3,1174 # ffffffffc0206d90 <commands+0x1458>
ffffffffc0203902:	00003617          	auipc	a2,0x3
ffffffffc0203906:	8be60613          	addi	a2,a2,-1858 # ffffffffc02061c0 <commands+0x888>
ffffffffc020390a:	12e00593          	li	a1,302
ffffffffc020390e:	00003517          	auipc	a0,0x3
ffffffffc0203912:	1ea50513          	addi	a0,a0,490 # ffffffffc0206af8 <commands+0x11c0>
ffffffffc0203916:	909fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc020391a:	00003697          	auipc	a3,0x3
ffffffffc020391e:	44e68693          	addi	a3,a3,1102 # ffffffffc0206d68 <commands+0x1430>
ffffffffc0203922:	00003617          	auipc	a2,0x3
ffffffffc0203926:	89e60613          	addi	a2,a2,-1890 # ffffffffc02061c0 <commands+0x888>
ffffffffc020392a:	12d00593          	li	a1,301
ffffffffc020392e:	00003517          	auipc	a0,0x3
ffffffffc0203932:	1ca50513          	addi	a0,a0,458 # ffffffffc0206af8 <commands+0x11c0>
ffffffffc0203936:	8e9fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(p0 + 2 == p1);
ffffffffc020393a:	00003697          	auipc	a3,0x3
ffffffffc020393e:	41e68693          	addi	a3,a3,1054 # ffffffffc0206d58 <commands+0x1420>
ffffffffc0203942:	00003617          	auipc	a2,0x3
ffffffffc0203946:	87e60613          	addi	a2,a2,-1922 # ffffffffc02061c0 <commands+0x888>
ffffffffc020394a:	12800593          	li	a1,296
ffffffffc020394e:	00003517          	auipc	a0,0x3
ffffffffc0203952:	1aa50513          	addi	a0,a0,426 # ffffffffc0206af8 <commands+0x11c0>
ffffffffc0203956:	8c9fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(alloc_page() == NULL);
ffffffffc020395a:	00003697          	auipc	a3,0x3
ffffffffc020395e:	2fe68693          	addi	a3,a3,766 # ffffffffc0206c58 <commands+0x1320>
ffffffffc0203962:	00003617          	auipc	a2,0x3
ffffffffc0203966:	85e60613          	addi	a2,a2,-1954 # ffffffffc02061c0 <commands+0x888>
ffffffffc020396a:	12700593          	li	a1,295
ffffffffc020396e:	00003517          	auipc	a0,0x3
ffffffffc0203972:	18a50513          	addi	a0,a0,394 # ffffffffc0206af8 <commands+0x11c0>
ffffffffc0203976:	8a9fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc020397a:	00003697          	auipc	a3,0x3
ffffffffc020397e:	3be68693          	addi	a3,a3,958 # ffffffffc0206d38 <commands+0x1400>
ffffffffc0203982:	00003617          	auipc	a2,0x3
ffffffffc0203986:	83e60613          	addi	a2,a2,-1986 # ffffffffc02061c0 <commands+0x888>
ffffffffc020398a:	12600593          	li	a1,294
ffffffffc020398e:	00003517          	auipc	a0,0x3
ffffffffc0203992:	16a50513          	addi	a0,a0,362 # ffffffffc0206af8 <commands+0x11c0>
ffffffffc0203996:	889fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc020399a:	00003697          	auipc	a3,0x3
ffffffffc020399e:	36e68693          	addi	a3,a3,878 # ffffffffc0206d08 <commands+0x13d0>
ffffffffc02039a2:	00003617          	auipc	a2,0x3
ffffffffc02039a6:	81e60613          	addi	a2,a2,-2018 # ffffffffc02061c0 <commands+0x888>
ffffffffc02039aa:	12500593          	li	a1,293
ffffffffc02039ae:	00003517          	auipc	a0,0x3
ffffffffc02039b2:	14a50513          	addi	a0,a0,330 # ffffffffc0206af8 <commands+0x11c0>
ffffffffc02039b6:	869fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc02039ba:	00003697          	auipc	a3,0x3
ffffffffc02039be:	33668693          	addi	a3,a3,822 # ffffffffc0206cf0 <commands+0x13b8>
ffffffffc02039c2:	00002617          	auipc	a2,0x2
ffffffffc02039c6:	7fe60613          	addi	a2,a2,2046 # ffffffffc02061c0 <commands+0x888>
ffffffffc02039ca:	12400593          	li	a1,292
ffffffffc02039ce:	00003517          	auipc	a0,0x3
ffffffffc02039d2:	12a50513          	addi	a0,a0,298 # ffffffffc0206af8 <commands+0x11c0>
ffffffffc02039d6:	849fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(alloc_page() == NULL);
ffffffffc02039da:	00003697          	auipc	a3,0x3
ffffffffc02039de:	27e68693          	addi	a3,a3,638 # ffffffffc0206c58 <commands+0x1320>
ffffffffc02039e2:	00002617          	auipc	a2,0x2
ffffffffc02039e6:	7de60613          	addi	a2,a2,2014 # ffffffffc02061c0 <commands+0x888>
ffffffffc02039ea:	11e00593          	li	a1,286
ffffffffc02039ee:	00003517          	auipc	a0,0x3
ffffffffc02039f2:	10a50513          	addi	a0,a0,266 # ffffffffc0206af8 <commands+0x11c0>
ffffffffc02039f6:	829fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(!PageProperty(p0));
ffffffffc02039fa:	00003697          	auipc	a3,0x3
ffffffffc02039fe:	2de68693          	addi	a3,a3,734 # ffffffffc0206cd8 <commands+0x13a0>
ffffffffc0203a02:	00002617          	auipc	a2,0x2
ffffffffc0203a06:	7be60613          	addi	a2,a2,1982 # ffffffffc02061c0 <commands+0x888>
ffffffffc0203a0a:	11900593          	li	a1,281
ffffffffc0203a0e:	00003517          	auipc	a0,0x3
ffffffffc0203a12:	0ea50513          	addi	a0,a0,234 # ffffffffc0206af8 <commands+0x11c0>
ffffffffc0203a16:	809fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0203a1a:	00003697          	auipc	a3,0x3
ffffffffc0203a1e:	3de68693          	addi	a3,a3,990 # ffffffffc0206df8 <commands+0x14c0>
ffffffffc0203a22:	00002617          	auipc	a2,0x2
ffffffffc0203a26:	79e60613          	addi	a2,a2,1950 # ffffffffc02061c0 <commands+0x888>
ffffffffc0203a2a:	13700593          	li	a1,311
ffffffffc0203a2e:	00003517          	auipc	a0,0x3
ffffffffc0203a32:	0ca50513          	addi	a0,a0,202 # ffffffffc0206af8 <commands+0x11c0>
ffffffffc0203a36:	fe8fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(total == 0);
ffffffffc0203a3a:	00003697          	auipc	a3,0x3
ffffffffc0203a3e:	3ee68693          	addi	a3,a3,1006 # ffffffffc0206e28 <commands+0x14f0>
ffffffffc0203a42:	00002617          	auipc	a2,0x2
ffffffffc0203a46:	77e60613          	addi	a2,a2,1918 # ffffffffc02061c0 <commands+0x888>
ffffffffc0203a4a:	14700593          	li	a1,327
ffffffffc0203a4e:	00003517          	auipc	a0,0x3
ffffffffc0203a52:	0aa50513          	addi	a0,a0,170 # ffffffffc0206af8 <commands+0x11c0>
ffffffffc0203a56:	fc8fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(total == nr_free_pages());
ffffffffc0203a5a:	00003697          	auipc	a3,0x3
ffffffffc0203a5e:	0b668693          	addi	a3,a3,182 # ffffffffc0206b10 <commands+0x11d8>
ffffffffc0203a62:	00002617          	auipc	a2,0x2
ffffffffc0203a66:	75e60613          	addi	a2,a2,1886 # ffffffffc02061c0 <commands+0x888>
ffffffffc0203a6a:	11300593          	li	a1,275
ffffffffc0203a6e:	00003517          	auipc	a0,0x3
ffffffffc0203a72:	08a50513          	addi	a0,a0,138 # ffffffffc0206af8 <commands+0x11c0>
ffffffffc0203a76:	fa8fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0203a7a:	00003697          	auipc	a3,0x3
ffffffffc0203a7e:	0d668693          	addi	a3,a3,214 # ffffffffc0206b50 <commands+0x1218>
ffffffffc0203a82:	00002617          	auipc	a2,0x2
ffffffffc0203a86:	73e60613          	addi	a2,a2,1854 # ffffffffc02061c0 <commands+0x888>
ffffffffc0203a8a:	0d800593          	li	a1,216
ffffffffc0203a8e:	00003517          	auipc	a0,0x3
ffffffffc0203a92:	06a50513          	addi	a0,a0,106 # ffffffffc0206af8 <commands+0x11c0>
ffffffffc0203a96:	f88fc0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc0203a9a <default_free_pages>:
{
ffffffffc0203a9a:	1141                	addi	sp,sp,-16
ffffffffc0203a9c:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0203a9e:	14058463          	beqz	a1,ffffffffc0203be6 <default_free_pages+0x14c>
    for (; p != base + n; p++)
ffffffffc0203aa2:	00659693          	slli	a3,a1,0x6
ffffffffc0203aa6:	96aa                	add	a3,a3,a0
ffffffffc0203aa8:	87aa                	mv	a5,a0
ffffffffc0203aaa:	02d50263          	beq	a0,a3,ffffffffc0203ace <default_free_pages+0x34>
ffffffffc0203aae:	6798                	ld	a4,8(a5)
ffffffffc0203ab0:	8b05                	andi	a4,a4,1
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0203ab2:	10071a63          	bnez	a4,ffffffffc0203bc6 <default_free_pages+0x12c>
ffffffffc0203ab6:	6798                	ld	a4,8(a5)
ffffffffc0203ab8:	8b09                	andi	a4,a4,2
ffffffffc0203aba:	10071663          	bnez	a4,ffffffffc0203bc6 <default_free_pages+0x12c>
        p->flags = 0;
ffffffffc0203abe:	0007b423          	sd	zero,8(a5)
    page->ref = val;
ffffffffc0203ac2:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc0203ac6:	04078793          	addi	a5,a5,64
ffffffffc0203aca:	fed792e3          	bne	a5,a3,ffffffffc0203aae <default_free_pages+0x14>
    base->property = n;
ffffffffc0203ace:	2581                	sext.w	a1,a1
ffffffffc0203ad0:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc0203ad2:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0203ad6:	4789                	li	a5,2
ffffffffc0203ad8:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc0203adc:	000a3697          	auipc	a3,0xa3
ffffffffc0203ae0:	bdc68693          	addi	a3,a3,-1060 # ffffffffc02a66b8 <free_area>
ffffffffc0203ae4:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc0203ae6:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc0203ae8:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc0203aec:	9db9                	addw	a1,a1,a4
ffffffffc0203aee:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list))
ffffffffc0203af0:	0ad78463          	beq	a5,a3,ffffffffc0203b98 <default_free_pages+0xfe>
            struct Page *page = le2page(le, page_link);
ffffffffc0203af4:	fe878713          	addi	a4,a5,-24
ffffffffc0203af8:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list))
ffffffffc0203afc:	4581                	li	a1,0
            if (base < page)
ffffffffc0203afe:	00e56a63          	bltu	a0,a4,ffffffffc0203b12 <default_free_pages+0x78>
    return listelm->next;
ffffffffc0203b02:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc0203b04:	04d70c63          	beq	a4,a3,ffffffffc0203b5c <default_free_pages+0xc2>
    for (; p != base + n; p++)
ffffffffc0203b08:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc0203b0a:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc0203b0e:	fee57ae3          	bgeu	a0,a4,ffffffffc0203b02 <default_free_pages+0x68>
ffffffffc0203b12:	c199                	beqz	a1,ffffffffc0203b18 <default_free_pages+0x7e>
ffffffffc0203b14:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0203b18:	6398                	ld	a4,0(a5)
    prev->next = next->prev = elm;
ffffffffc0203b1a:	e390                	sd	a2,0(a5)
ffffffffc0203b1c:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0203b1e:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0203b20:	ed18                	sd	a4,24(a0)
    if (le != &free_list)
ffffffffc0203b22:	00d70d63          	beq	a4,a3,ffffffffc0203b3c <default_free_pages+0xa2>
        if (p + p->property == base)
ffffffffc0203b26:	ff872583          	lw	a1,-8(a4) # ff8 <_binary_obj___user_faultread_out_size-0x8bb8>
        p = le2page(le, page_link);
ffffffffc0203b2a:	fe870613          	addi	a2,a4,-24
        if (p + p->property == base)
ffffffffc0203b2e:	02059813          	slli	a6,a1,0x20
ffffffffc0203b32:	01a85793          	srli	a5,a6,0x1a
ffffffffc0203b36:	97b2                	add	a5,a5,a2
ffffffffc0203b38:	02f50c63          	beq	a0,a5,ffffffffc0203b70 <default_free_pages+0xd6>
    return listelm->next;
ffffffffc0203b3c:	711c                	ld	a5,32(a0)
    if (le != &free_list)
ffffffffc0203b3e:	00d78c63          	beq	a5,a3,ffffffffc0203b56 <default_free_pages+0xbc>
        if (base + base->property == p)
ffffffffc0203b42:	4910                	lw	a2,16(a0)
        p = le2page(le, page_link);
ffffffffc0203b44:	fe878693          	addi	a3,a5,-24
        if (base + base->property == p)
ffffffffc0203b48:	02061593          	slli	a1,a2,0x20
ffffffffc0203b4c:	01a5d713          	srli	a4,a1,0x1a
ffffffffc0203b50:	972a                	add	a4,a4,a0
ffffffffc0203b52:	04e68a63          	beq	a3,a4,ffffffffc0203ba6 <default_free_pages+0x10c>
}
ffffffffc0203b56:	60a2                	ld	ra,8(sp)
ffffffffc0203b58:	0141                	addi	sp,sp,16
ffffffffc0203b5a:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0203b5c:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0203b5e:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0203b60:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0203b62:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list)
ffffffffc0203b64:	02d70763          	beq	a4,a3,ffffffffc0203b92 <default_free_pages+0xf8>
    prev->next = next->prev = elm;
ffffffffc0203b68:	8832                	mv	a6,a2
ffffffffc0203b6a:	4585                	li	a1,1
    for (; p != base + n; p++)
ffffffffc0203b6c:	87ba                	mv	a5,a4
ffffffffc0203b6e:	bf71                	j	ffffffffc0203b0a <default_free_pages+0x70>
            p->property += base->property;
ffffffffc0203b70:	491c                	lw	a5,16(a0)
ffffffffc0203b72:	9dbd                	addw	a1,a1,a5
ffffffffc0203b74:	feb72c23          	sw	a1,-8(a4)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0203b78:	57f5                	li	a5,-3
ffffffffc0203b7a:	60f8b02f          	amoand.d	zero,a5,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc0203b7e:	01853803          	ld	a6,24(a0)
ffffffffc0203b82:	710c                	ld	a1,32(a0)
            base = p;
ffffffffc0203b84:	8532                	mv	a0,a2
    prev->next = next;
ffffffffc0203b86:	00b83423          	sd	a1,8(a6)
    return listelm->next;
ffffffffc0203b8a:	671c                	ld	a5,8(a4)
    next->prev = prev;
ffffffffc0203b8c:	0105b023          	sd	a6,0(a1) # 1000 <_binary_obj___user_faultread_out_size-0x8bb0>
ffffffffc0203b90:	b77d                	j	ffffffffc0203b3e <default_free_pages+0xa4>
ffffffffc0203b92:	e290                	sd	a2,0(a3)
        while ((le = list_next(le)) != &free_list)
ffffffffc0203b94:	873e                	mv	a4,a5
ffffffffc0203b96:	bf41                	j	ffffffffc0203b26 <default_free_pages+0x8c>
}
ffffffffc0203b98:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0203b9a:	e390                	sd	a2,0(a5)
ffffffffc0203b9c:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0203b9e:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0203ba0:	ed1c                	sd	a5,24(a0)
ffffffffc0203ba2:	0141                	addi	sp,sp,16
ffffffffc0203ba4:	8082                	ret
            base->property += p->property;
ffffffffc0203ba6:	ff87a703          	lw	a4,-8(a5)
ffffffffc0203baa:	ff078693          	addi	a3,a5,-16
ffffffffc0203bae:	9e39                	addw	a2,a2,a4
ffffffffc0203bb0:	c910                	sw	a2,16(a0)
ffffffffc0203bb2:	5775                	li	a4,-3
ffffffffc0203bb4:	60e6b02f          	amoand.d	zero,a4,(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc0203bb8:	6398                	ld	a4,0(a5)
ffffffffc0203bba:	679c                	ld	a5,8(a5)
}
ffffffffc0203bbc:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc0203bbe:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0203bc0:	e398                	sd	a4,0(a5)
ffffffffc0203bc2:	0141                	addi	sp,sp,16
ffffffffc0203bc4:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0203bc6:	00003697          	auipc	a3,0x3
ffffffffc0203bca:	27a68693          	addi	a3,a3,634 # ffffffffc0206e40 <commands+0x1508>
ffffffffc0203bce:	00002617          	auipc	a2,0x2
ffffffffc0203bd2:	5f260613          	addi	a2,a2,1522 # ffffffffc02061c0 <commands+0x888>
ffffffffc0203bd6:	09400593          	li	a1,148
ffffffffc0203bda:	00003517          	auipc	a0,0x3
ffffffffc0203bde:	f1e50513          	addi	a0,a0,-226 # ffffffffc0206af8 <commands+0x11c0>
ffffffffc0203be2:	e3cfc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(n > 0);
ffffffffc0203be6:	00003697          	auipc	a3,0x3
ffffffffc0203bea:	25268693          	addi	a3,a3,594 # ffffffffc0206e38 <commands+0x1500>
ffffffffc0203bee:	00002617          	auipc	a2,0x2
ffffffffc0203bf2:	5d260613          	addi	a2,a2,1490 # ffffffffc02061c0 <commands+0x888>
ffffffffc0203bf6:	09000593          	li	a1,144
ffffffffc0203bfa:	00003517          	auipc	a0,0x3
ffffffffc0203bfe:	efe50513          	addi	a0,a0,-258 # ffffffffc0206af8 <commands+0x11c0>
ffffffffc0203c02:	e1cfc0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc0203c06 <default_alloc_pages>:
    assert(n > 0);
ffffffffc0203c06:	c941                	beqz	a0,ffffffffc0203c96 <default_alloc_pages+0x90>
    if (n > nr_free)
ffffffffc0203c08:	000a3597          	auipc	a1,0xa3
ffffffffc0203c0c:	ab058593          	addi	a1,a1,-1360 # ffffffffc02a66b8 <free_area>
ffffffffc0203c10:	0105a803          	lw	a6,16(a1)
ffffffffc0203c14:	872a                	mv	a4,a0
ffffffffc0203c16:	02081793          	slli	a5,a6,0x20
ffffffffc0203c1a:	9381                	srli	a5,a5,0x20
ffffffffc0203c1c:	00a7ee63          	bltu	a5,a0,ffffffffc0203c38 <default_alloc_pages+0x32>
    list_entry_t *le = &free_list;
ffffffffc0203c20:	87ae                	mv	a5,a1
ffffffffc0203c22:	a801                	j	ffffffffc0203c32 <default_alloc_pages+0x2c>
        if (p->property >= n)
ffffffffc0203c24:	ff87a683          	lw	a3,-8(a5)
ffffffffc0203c28:	02069613          	slli	a2,a3,0x20
ffffffffc0203c2c:	9201                	srli	a2,a2,0x20
ffffffffc0203c2e:	00e67763          	bgeu	a2,a4,ffffffffc0203c3c <default_alloc_pages+0x36>
    return listelm->next;
ffffffffc0203c32:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list)
ffffffffc0203c34:	feb798e3          	bne	a5,a1,ffffffffc0203c24 <default_alloc_pages+0x1e>
        return NULL;
ffffffffc0203c38:	4501                	li	a0,0
}
ffffffffc0203c3a:	8082                	ret
    return listelm->prev;
ffffffffc0203c3c:	0007b883          	ld	a7,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc0203c40:	0087b303          	ld	t1,8(a5)
        struct Page *p = le2page(le, page_link);
ffffffffc0203c44:	fe878513          	addi	a0,a5,-24
            p->property = page->property - n;
ffffffffc0203c48:	00070e1b          	sext.w	t3,a4
    prev->next = next;
ffffffffc0203c4c:	0068b423          	sd	t1,8(a7) # 1008 <_binary_obj___user_faultread_out_size-0x8ba8>
    next->prev = prev;
ffffffffc0203c50:	01133023          	sd	a7,0(t1) # 80000 <_binary_obj___user_exit_out_size+0x74ee0>
        if (page->property > n)
ffffffffc0203c54:	02c77863          	bgeu	a4,a2,ffffffffc0203c84 <default_alloc_pages+0x7e>
            struct Page *p = page + n;
ffffffffc0203c58:	071a                	slli	a4,a4,0x6
ffffffffc0203c5a:	972a                	add	a4,a4,a0
            p->property = page->property - n;
ffffffffc0203c5c:	41c686bb          	subw	a3,a3,t3
ffffffffc0203c60:	cb14                	sw	a3,16(a4)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0203c62:	00870613          	addi	a2,a4,8
ffffffffc0203c66:	4689                	li	a3,2
ffffffffc0203c68:	40d6302f          	amoor.d	zero,a3,(a2)
    __list_add(elm, listelm, listelm->next);
ffffffffc0203c6c:	0088b683          	ld	a3,8(a7)
            list_add(prev, &(p->page_link));
ffffffffc0203c70:	01870613          	addi	a2,a4,24
        nr_free -= n;
ffffffffc0203c74:	0105a803          	lw	a6,16(a1)
    prev->next = next->prev = elm;
ffffffffc0203c78:	e290                	sd	a2,0(a3)
ffffffffc0203c7a:	00c8b423          	sd	a2,8(a7)
    elm->next = next;
ffffffffc0203c7e:	f314                	sd	a3,32(a4)
    elm->prev = prev;
ffffffffc0203c80:	01173c23          	sd	a7,24(a4)
ffffffffc0203c84:	41c8083b          	subw	a6,a6,t3
ffffffffc0203c88:	0105a823          	sw	a6,16(a1)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0203c8c:	5775                	li	a4,-3
ffffffffc0203c8e:	17c1                	addi	a5,a5,-16
ffffffffc0203c90:	60e7b02f          	amoand.d	zero,a4,(a5)
}
ffffffffc0203c94:	8082                	ret
{
ffffffffc0203c96:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc0203c98:	00003697          	auipc	a3,0x3
ffffffffc0203c9c:	1a068693          	addi	a3,a3,416 # ffffffffc0206e38 <commands+0x1500>
ffffffffc0203ca0:	00002617          	auipc	a2,0x2
ffffffffc0203ca4:	52060613          	addi	a2,a2,1312 # ffffffffc02061c0 <commands+0x888>
ffffffffc0203ca8:	06c00593          	li	a1,108
ffffffffc0203cac:	00003517          	auipc	a0,0x3
ffffffffc0203cb0:	e4c50513          	addi	a0,a0,-436 # ffffffffc0206af8 <commands+0x11c0>
{
ffffffffc0203cb4:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0203cb6:	d68fc0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc0203cba <default_init_memmap>:
{
ffffffffc0203cba:	1141                	addi	sp,sp,-16
ffffffffc0203cbc:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0203cbe:	c5f1                	beqz	a1,ffffffffc0203d8a <default_init_memmap+0xd0>
    for (; p != base + n; p++)
ffffffffc0203cc0:	00659693          	slli	a3,a1,0x6
ffffffffc0203cc4:	96aa                	add	a3,a3,a0
ffffffffc0203cc6:	87aa                	mv	a5,a0
ffffffffc0203cc8:	00d50f63          	beq	a0,a3,ffffffffc0203ce6 <default_init_memmap+0x2c>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0203ccc:	6798                	ld	a4,8(a5)
ffffffffc0203cce:	8b05                	andi	a4,a4,1
        assert(PageReserved(p));
ffffffffc0203cd0:	cf49                	beqz	a4,ffffffffc0203d6a <default_init_memmap+0xb0>
        p->flags = p->property = 0;
ffffffffc0203cd2:	0007a823          	sw	zero,16(a5)
ffffffffc0203cd6:	0007b423          	sd	zero,8(a5)
ffffffffc0203cda:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p++)
ffffffffc0203cde:	04078793          	addi	a5,a5,64
ffffffffc0203ce2:	fed795e3          	bne	a5,a3,ffffffffc0203ccc <default_init_memmap+0x12>
    base->property = n;
ffffffffc0203ce6:	2581                	sext.w	a1,a1
ffffffffc0203ce8:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0203cea:	4789                	li	a5,2
ffffffffc0203cec:	00850713          	addi	a4,a0,8
ffffffffc0203cf0:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc0203cf4:	000a3697          	auipc	a3,0xa3
ffffffffc0203cf8:	9c468693          	addi	a3,a3,-1596 # ffffffffc02a66b8 <free_area>
ffffffffc0203cfc:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc0203cfe:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc0203d00:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc0203d04:	9db9                	addw	a1,a1,a4
ffffffffc0203d06:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list))
ffffffffc0203d08:	04d78a63          	beq	a5,a3,ffffffffc0203d5c <default_init_memmap+0xa2>
            struct Page *page = le2page(le, page_link);
ffffffffc0203d0c:	fe878713          	addi	a4,a5,-24
ffffffffc0203d10:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list))
ffffffffc0203d14:	4581                	li	a1,0
            if (base < page)
ffffffffc0203d16:	00e56a63          	bltu	a0,a4,ffffffffc0203d2a <default_init_memmap+0x70>
    return listelm->next;
ffffffffc0203d1a:	6798                	ld	a4,8(a5)
            else if (list_next(le) == &free_list)
ffffffffc0203d1c:	02d70263          	beq	a4,a3,ffffffffc0203d40 <default_init_memmap+0x86>
    for (; p != base + n; p++)
ffffffffc0203d20:	87ba                	mv	a5,a4
            struct Page *page = le2page(le, page_link);
ffffffffc0203d22:	fe878713          	addi	a4,a5,-24
            if (base < page)
ffffffffc0203d26:	fee57ae3          	bgeu	a0,a4,ffffffffc0203d1a <default_init_memmap+0x60>
ffffffffc0203d2a:	c199                	beqz	a1,ffffffffc0203d30 <default_init_memmap+0x76>
ffffffffc0203d2c:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0203d30:	6398                	ld	a4,0(a5)
}
ffffffffc0203d32:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0203d34:	e390                	sd	a2,0(a5)
ffffffffc0203d36:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0203d38:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0203d3a:	ed18                	sd	a4,24(a0)
ffffffffc0203d3c:	0141                	addi	sp,sp,16
ffffffffc0203d3e:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0203d40:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0203d42:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0203d44:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0203d46:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list)
ffffffffc0203d48:	00d70663          	beq	a4,a3,ffffffffc0203d54 <default_init_memmap+0x9a>
    prev->next = next->prev = elm;
ffffffffc0203d4c:	8832                	mv	a6,a2
ffffffffc0203d4e:	4585                	li	a1,1
    for (; p != base + n; p++)
ffffffffc0203d50:	87ba                	mv	a5,a4
ffffffffc0203d52:	bfc1                	j	ffffffffc0203d22 <default_init_memmap+0x68>
}
ffffffffc0203d54:	60a2                	ld	ra,8(sp)
ffffffffc0203d56:	e290                	sd	a2,0(a3)
ffffffffc0203d58:	0141                	addi	sp,sp,16
ffffffffc0203d5a:	8082                	ret
ffffffffc0203d5c:	60a2                	ld	ra,8(sp)
ffffffffc0203d5e:	e390                	sd	a2,0(a5)
ffffffffc0203d60:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0203d62:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0203d64:	ed1c                	sd	a5,24(a0)
ffffffffc0203d66:	0141                	addi	sp,sp,16
ffffffffc0203d68:	8082                	ret
        assert(PageReserved(p));
ffffffffc0203d6a:	00003697          	auipc	a3,0x3
ffffffffc0203d6e:	0fe68693          	addi	a3,a3,254 # ffffffffc0206e68 <commands+0x1530>
ffffffffc0203d72:	00002617          	auipc	a2,0x2
ffffffffc0203d76:	44e60613          	addi	a2,a2,1102 # ffffffffc02061c0 <commands+0x888>
ffffffffc0203d7a:	04b00593          	li	a1,75
ffffffffc0203d7e:	00003517          	auipc	a0,0x3
ffffffffc0203d82:	d7a50513          	addi	a0,a0,-646 # ffffffffc0206af8 <commands+0x11c0>
ffffffffc0203d86:	c98fc0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(n > 0);
ffffffffc0203d8a:	00003697          	auipc	a3,0x3
ffffffffc0203d8e:	0ae68693          	addi	a3,a3,174 # ffffffffc0206e38 <commands+0x1500>
ffffffffc0203d92:	00002617          	auipc	a2,0x2
ffffffffc0203d96:	42e60613          	addi	a2,a2,1070 # ffffffffc02061c0 <commands+0x888>
ffffffffc0203d9a:	04700593          	li	a1,71
ffffffffc0203d9e:	00003517          	auipc	a0,0x3
ffffffffc0203da2:	d5a50513          	addi	a0,a0,-678 # ffffffffc0206af8 <commands+0x11c0>
ffffffffc0203da6:	c78fc0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc0203daa <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)
	move a0, s1
ffffffffc0203daa:	8526                	mv	a0,s1
	jalr s0
ffffffffc0203dac:	9402                	jalr	s0

	jal do_exit
ffffffffc0203dae:	654000ef          	jal	ra,ffffffffc0204402 <do_exit>

ffffffffc0203db2 <switch_to>:
.text
# void switch_to(struct proc_struct* from, struct proc_struct* to)
.globl switch_to
switch_to:
    # save from's registers
    STORE ra, 0*REGBYTES(a0)
ffffffffc0203db2:	00153023          	sd	ra,0(a0)
    STORE sp, 1*REGBYTES(a0)
ffffffffc0203db6:	00253423          	sd	sp,8(a0)
    STORE s0, 2*REGBYTES(a0)
ffffffffc0203dba:	e900                	sd	s0,16(a0)
    STORE s1, 3*REGBYTES(a0)
ffffffffc0203dbc:	ed04                	sd	s1,24(a0)
    STORE s2, 4*REGBYTES(a0)
ffffffffc0203dbe:	03253023          	sd	s2,32(a0)
    STORE s3, 5*REGBYTES(a0)
ffffffffc0203dc2:	03353423          	sd	s3,40(a0)
    STORE s4, 6*REGBYTES(a0)
ffffffffc0203dc6:	03453823          	sd	s4,48(a0)
    STORE s5, 7*REGBYTES(a0)
ffffffffc0203dca:	03553c23          	sd	s5,56(a0)
    STORE s6, 8*REGBYTES(a0)
ffffffffc0203dce:	05653023          	sd	s6,64(a0)
    STORE s7, 9*REGBYTES(a0)
ffffffffc0203dd2:	05753423          	sd	s7,72(a0)
    STORE s8, 10*REGBYTES(a0)
ffffffffc0203dd6:	05853823          	sd	s8,80(a0)
    STORE s9, 11*REGBYTES(a0)
ffffffffc0203dda:	05953c23          	sd	s9,88(a0)
    STORE s10, 12*REGBYTES(a0)
ffffffffc0203dde:	07a53023          	sd	s10,96(a0)
    STORE s11, 13*REGBYTES(a0)
ffffffffc0203de2:	07b53423          	sd	s11,104(a0)

    # restore to's registers
    LOAD ra, 0*REGBYTES(a1)
ffffffffc0203de6:	0005b083          	ld	ra,0(a1)
    LOAD sp, 1*REGBYTES(a1)
ffffffffc0203dea:	0085b103          	ld	sp,8(a1)
    LOAD s0, 2*REGBYTES(a1)
ffffffffc0203dee:	6980                	ld	s0,16(a1)
    LOAD s1, 3*REGBYTES(a1)
ffffffffc0203df0:	6d84                	ld	s1,24(a1)
    LOAD s2, 4*REGBYTES(a1)
ffffffffc0203df2:	0205b903          	ld	s2,32(a1)
    LOAD s3, 5*REGBYTES(a1)
ffffffffc0203df6:	0285b983          	ld	s3,40(a1)
    LOAD s4, 6*REGBYTES(a1)
ffffffffc0203dfa:	0305ba03          	ld	s4,48(a1)
    LOAD s5, 7*REGBYTES(a1)
ffffffffc0203dfe:	0385ba83          	ld	s5,56(a1)
    LOAD s6, 8*REGBYTES(a1)
ffffffffc0203e02:	0405bb03          	ld	s6,64(a1)
    LOAD s7, 9*REGBYTES(a1)
ffffffffc0203e06:	0485bb83          	ld	s7,72(a1)
    LOAD s8, 10*REGBYTES(a1)
ffffffffc0203e0a:	0505bc03          	ld	s8,80(a1)
    LOAD s9, 11*REGBYTES(a1)
ffffffffc0203e0e:	0585bc83          	ld	s9,88(a1)
    LOAD s10, 12*REGBYTES(a1)
ffffffffc0203e12:	0605bd03          	ld	s10,96(a1)
    LOAD s11, 13*REGBYTES(a1)
ffffffffc0203e16:	0685bd83          	ld	s11,104(a1)

    ret
ffffffffc0203e1a:	8082                	ret

ffffffffc0203e1c <alloc_proc>:
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void)
{
ffffffffc0203e1c:	1141                	addi	sp,sp,-16
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0203e1e:	10800513          	li	a0,264
{
ffffffffc0203e22:	e022                	sd	s0,0(sp)
ffffffffc0203e24:	e406                	sd	ra,8(sp)
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0203e26:	b2cff0ef          	jal	ra,ffffffffc0203152 <kmalloc>
ffffffffc0203e2a:	842a                	mv	s0,a0
    if (proc != NULL)
ffffffffc0203e2c:	c525                	beqz	a0,ffffffffc0203e94 <alloc_proc+0x78>
        /*
         * below fields(add in LAB5) in proc_struct need to be initialized
         *       uint32_t wait_state;                        // waiting state
         *       struct proc_struct *cptr, *yptr, *optr;     // relations between processes
         */
	proc->state = PROC_UNINIT;
ffffffffc0203e2e:	57fd                	li	a5,-1
ffffffffc0203e30:	1782                	slli	a5,a5,0x20
ffffffffc0203e32:	e11c                	sd	a5,0(a0)
        proc->need_resched = 0;
        proc->parent = NULL;
        proc->mm = NULL;


        memset(&(proc->context), 0, sizeof(struct context));
ffffffffc0203e34:	07000613          	li	a2,112
ffffffffc0203e38:	4581                	li	a1,0
        proc->runs = 0;
ffffffffc0203e3a:	00052423          	sw	zero,8(a0)
        proc->kstack = 0;
ffffffffc0203e3e:	00053823          	sd	zero,16(a0)
        proc->need_resched = 0;
ffffffffc0203e42:	00053c23          	sd	zero,24(a0)
        proc->parent = NULL;
ffffffffc0203e46:	02053023          	sd	zero,32(a0)
        proc->mm = NULL;
ffffffffc0203e4a:	02053423          	sd	zero,40(a0)
        memset(&(proc->context), 0, sizeof(struct context));
ffffffffc0203e4e:	03050513          	addi	a0,a0,48
ffffffffc0203e52:	40a010ef          	jal	ra,ffffffffc020525c <memset>

        proc->tf = NULL;
        proc->pgdir = boot_pgdir_pa;
ffffffffc0203e56:	000a7797          	auipc	a5,0xa7
ffffffffc0203e5a:	8b27b783          	ld	a5,-1870(a5) # ffffffffc02aa708 <boot_pgdir_pa>
ffffffffc0203e5e:	f45c                	sd	a5,168(s0)
        proc->tf = NULL;
ffffffffc0203e60:	0a043023          	sd	zero,160(s0)

        proc->flags = 0;
ffffffffc0203e64:	0a042823          	sw	zero,176(s0)
        memset(proc->name, 0, sizeof(proc->name));
ffffffffc0203e68:	4641                	li	a2,16
ffffffffc0203e6a:	4581                	li	a1,0
ffffffffc0203e6c:	0b440513          	addi	a0,s0,180
ffffffffc0203e70:	3ec010ef          	jal	ra,ffffffffc020525c <memset>

        // 链表初始化
        list_init(&(proc->list_link));
ffffffffc0203e74:	0c840713          	addi	a4,s0,200
        list_init(&(proc->hash_link));
ffffffffc0203e78:	0d840793          	addi	a5,s0,216
    elm->prev = elm->next = elm;
ffffffffc0203e7c:	e878                	sd	a4,208(s0)
ffffffffc0203e7e:	e478                	sd	a4,200(s0)
ffffffffc0203e80:	f07c                	sd	a5,224(s0)
ffffffffc0203e82:	ec7c                	sd	a5,216(s0)
 	
	proc->wait_state = 0;
ffffffffc0203e84:	0e042623          	sw	zero,236(s0)
	proc->cptr = NULL;
ffffffffc0203e88:	0e043823          	sd	zero,240(s0)
        proc->optr = NULL;
ffffffffc0203e8c:	10043023          	sd	zero,256(s0)
        proc->yptr = NULL;
ffffffffc0203e90:	0e043c23          	sd	zero,248(s0)

    }
    return proc;
}
ffffffffc0203e94:	60a2                	ld	ra,8(sp)
ffffffffc0203e96:	8522                	mv	a0,s0
ffffffffc0203e98:	6402                	ld	s0,0(sp)
ffffffffc0203e9a:	0141                	addi	sp,sp,16
ffffffffc0203e9c:	8082                	ret

ffffffffc0203e9e <forkret>:
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void)
{
    forkrets(current->tf);
ffffffffc0203e9e:	000a7797          	auipc	a5,0xa7
ffffffffc0203ea2:	8a27b783          	ld	a5,-1886(a5) # ffffffffc02aa740 <current>
ffffffffc0203ea6:	73c8                	ld	a0,160(a5)
ffffffffc0203ea8:	866fd06f          	j	ffffffffc0200f0e <forkrets>

ffffffffc0203eac <user_main>:
user_main(void *arg)
{
#ifdef TEST
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
#else
    KERNEL_EXECVE(exit);
ffffffffc0203eac:	000a7797          	auipc	a5,0xa7
ffffffffc0203eb0:	8947b783          	ld	a5,-1900(a5) # ffffffffc02aa740 <current>
ffffffffc0203eb4:	43cc                	lw	a1,4(a5)
{
ffffffffc0203eb6:	7139                	addi	sp,sp,-64
    KERNEL_EXECVE(exit);
ffffffffc0203eb8:	00003617          	auipc	a2,0x3
ffffffffc0203ebc:	01060613          	addi	a2,a2,16 # ffffffffc0206ec8 <default_pmm_manager+0x38>
ffffffffc0203ec0:	00003517          	auipc	a0,0x3
ffffffffc0203ec4:	01050513          	addi	a0,a0,16 # ffffffffc0206ed0 <default_pmm_manager+0x40>
{
ffffffffc0203ec8:	fc06                	sd	ra,56(sp)
    KERNEL_EXECVE(exit);
ffffffffc0203eca:	a16fc0ef          	jal	ra,ffffffffc02000e0 <cprintf>
ffffffffc0203ece:	3fe07797          	auipc	a5,0x3fe07
ffffffffc0203ed2:	25278793          	addi	a5,a5,594 # b120 <_binary_obj___user_exit_out_size>
ffffffffc0203ed6:	e43e                	sd	a5,8(sp)
ffffffffc0203ed8:	00003517          	auipc	a0,0x3
ffffffffc0203edc:	ff050513          	addi	a0,a0,-16 # ffffffffc0206ec8 <default_pmm_manager+0x38>
ffffffffc0203ee0:	00044797          	auipc	a5,0x44
ffffffffc0203ee4:	5f878793          	addi	a5,a5,1528 # ffffffffc02484d8 <_binary_obj___user_exit_out_start>
ffffffffc0203ee8:	f03e                	sd	a5,32(sp)
ffffffffc0203eea:	f42a                	sd	a0,40(sp)
    int64_t ret = 0, len = strlen(name);
ffffffffc0203eec:	e802                	sd	zero,16(sp)
ffffffffc0203eee:	2cc010ef          	jal	ra,ffffffffc02051ba <strlen>
ffffffffc0203ef2:	ec2a                	sd	a0,24(sp)
    asm volatile(
ffffffffc0203ef4:	4511                	li	a0,4
ffffffffc0203ef6:	55a2                	lw	a1,40(sp)
ffffffffc0203ef8:	4662                	lw	a2,24(sp)
ffffffffc0203efa:	5682                	lw	a3,32(sp)
ffffffffc0203efc:	4722                	lw	a4,8(sp)
ffffffffc0203efe:	48a9                	li	a7,10
ffffffffc0203f00:	9002                	ebreak
ffffffffc0203f02:	c82a                	sw	a0,16(sp)
    cprintf("ret = %d\n", ret);
ffffffffc0203f04:	65c2                	ld	a1,16(sp)
ffffffffc0203f06:	00003517          	auipc	a0,0x3
ffffffffc0203f0a:	ff250513          	addi	a0,a0,-14 # ffffffffc0206ef8 <default_pmm_manager+0x68>
ffffffffc0203f0e:	9d2fc0ef          	jal	ra,ffffffffc02000e0 <cprintf>
#endif
    panic("user_main execve failed.\n");
ffffffffc0203f12:	00003617          	auipc	a2,0x3
ffffffffc0203f16:	ff660613          	addi	a2,a2,-10 # ffffffffc0206f08 <default_pmm_manager+0x78>
ffffffffc0203f1a:	3c400593          	li	a1,964
ffffffffc0203f1e:	00003517          	auipc	a0,0x3
ffffffffc0203f22:	00a50513          	addi	a0,a0,10 # ffffffffc0206f28 <default_pmm_manager+0x98>
ffffffffc0203f26:	af8fc0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc0203f2a <put_pgdir>:
    return pa2page(PADDR(kva));
ffffffffc0203f2a:	6d14                	ld	a3,24(a0)
{
ffffffffc0203f2c:	1141                	addi	sp,sp,-16
ffffffffc0203f2e:	e406                	sd	ra,8(sp)
ffffffffc0203f30:	c02007b7          	lui	a5,0xc0200
ffffffffc0203f34:	02f6ee63          	bltu	a3,a5,ffffffffc0203f70 <put_pgdir+0x46>
ffffffffc0203f38:	000a6517          	auipc	a0,0xa6
ffffffffc0203f3c:	7f853503          	ld	a0,2040(a0) # ffffffffc02aa730 <va_pa_offset>
ffffffffc0203f40:	8e89                	sub	a3,a3,a0
    if (PPN(pa) >= npage)
ffffffffc0203f42:	82b1                	srli	a3,a3,0xc
ffffffffc0203f44:	000a6797          	auipc	a5,0xa6
ffffffffc0203f48:	7d47b783          	ld	a5,2004(a5) # ffffffffc02aa718 <npage>
ffffffffc0203f4c:	02f6fe63          	bgeu	a3,a5,ffffffffc0203f88 <put_pgdir+0x5e>
    return &pages[PPN(pa) - nbase];
ffffffffc0203f50:	00004517          	auipc	a0,0x4
ffffffffc0203f54:	87053503          	ld	a0,-1936(a0) # ffffffffc02077c0 <nbase>
}
ffffffffc0203f58:	60a2                	ld	ra,8(sp)
ffffffffc0203f5a:	8e89                	sub	a3,a3,a0
ffffffffc0203f5c:	069a                	slli	a3,a3,0x6
    free_page(kva2page(mm->pgdir));
ffffffffc0203f5e:	000a6517          	auipc	a0,0xa6
ffffffffc0203f62:	7c253503          	ld	a0,1986(a0) # ffffffffc02aa720 <pages>
ffffffffc0203f66:	4585                	li	a1,1
ffffffffc0203f68:	9536                	add	a0,a0,a3
}
ffffffffc0203f6a:	0141                	addi	sp,sp,16
    free_page(kva2page(mm->pgdir));
ffffffffc0203f6c:	8c4fd06f          	j	ffffffffc0201030 <free_pages>
    return pa2page(PADDR(kva));
ffffffffc0203f70:	00002617          	auipc	a2,0x2
ffffffffc0203f74:	2f860613          	addi	a2,a2,760 # ffffffffc0206268 <commands+0x930>
ffffffffc0203f78:	07700593          	li	a1,119
ffffffffc0203f7c:	00002517          	auipc	a0,0x2
ffffffffc0203f80:	1a450513          	addi	a0,a0,420 # ffffffffc0206120 <commands+0x7e8>
ffffffffc0203f84:	a9afc0ef          	jal	ra,ffffffffc020021e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0203f88:	00002617          	auipc	a2,0x2
ffffffffc0203f8c:	17860613          	addi	a2,a2,376 # ffffffffc0206100 <commands+0x7c8>
ffffffffc0203f90:	06900593          	li	a1,105
ffffffffc0203f94:	00002517          	auipc	a0,0x2
ffffffffc0203f98:	18c50513          	addi	a0,a0,396 # ffffffffc0206120 <commands+0x7e8>
ffffffffc0203f9c:	a82fc0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc0203fa0 <proc_run>:
{
ffffffffc0203fa0:	7179                	addi	sp,sp,-48
ffffffffc0203fa2:	ec4a                	sd	s2,24(sp)
    if (proc != current)
ffffffffc0203fa4:	000a6917          	auipc	s2,0xa6
ffffffffc0203fa8:	79c90913          	addi	s2,s2,1948 # ffffffffc02aa740 <current>
{
ffffffffc0203fac:	f026                	sd	s1,32(sp)
    if (proc != current)
ffffffffc0203fae:	00093483          	ld	s1,0(s2)
{
ffffffffc0203fb2:	f406                	sd	ra,40(sp)
ffffffffc0203fb4:	e84e                	sd	s3,16(sp)
    if (proc != current)
ffffffffc0203fb6:	02a48863          	beq	s1,a0,ffffffffc0203fe6 <proc_run+0x46>
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203fba:	100027f3          	csrr	a5,sstatus
ffffffffc0203fbe:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0203fc0:	4981                	li	s3,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0203fc2:	ef9d                	bnez	a5,ffffffffc0204000 <proc_run+0x60>
#define barrier() __asm__ __volatile__("fence" ::: "memory")

static inline void
lsatp(unsigned long pgdir)
{
  write_csr(satp, 0x8000000000000000 | (pgdir >> RISCV_PGSHIFT));
ffffffffc0203fc4:	755c                	ld	a5,168(a0)
ffffffffc0203fc6:	577d                	li	a4,-1
ffffffffc0203fc8:	177e                	slli	a4,a4,0x3f
ffffffffc0203fca:	83b1                	srli	a5,a5,0xc
            current = proc;
ffffffffc0203fcc:	00a93023          	sd	a0,0(s2)
ffffffffc0203fd0:	8fd9                	or	a5,a5,a4
ffffffffc0203fd2:	18079073          	csrw	satp,a5
            switch_to(&(prev->context), &(proc->context));
ffffffffc0203fd6:	03050593          	addi	a1,a0,48
ffffffffc0203fda:	03048513          	addi	a0,s1,48
ffffffffc0203fde:	dd5ff0ef          	jal	ra,ffffffffc0203db2 <switch_to>
    if (flag)
ffffffffc0203fe2:	00099863          	bnez	s3,ffffffffc0203ff2 <proc_run+0x52>
}
ffffffffc0203fe6:	70a2                	ld	ra,40(sp)
ffffffffc0203fe8:	7482                	ld	s1,32(sp)
ffffffffc0203fea:	6962                	ld	s2,24(sp)
ffffffffc0203fec:	69c2                	ld	s3,16(sp)
ffffffffc0203fee:	6145                	addi	sp,sp,48
ffffffffc0203ff0:	8082                	ret
ffffffffc0203ff2:	70a2                	ld	ra,40(sp)
ffffffffc0203ff4:	7482                	ld	s1,32(sp)
ffffffffc0203ff6:	6962                	ld	s2,24(sp)
ffffffffc0203ff8:	69c2                	ld	s3,16(sp)
ffffffffc0203ffa:	6145                	addi	sp,sp,48
        intr_enable();
ffffffffc0203ffc:	9b9fc06f          	j	ffffffffc02009b4 <intr_enable>
ffffffffc0204000:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0204002:	9b9fc0ef          	jal	ra,ffffffffc02009ba <intr_disable>
        return 1;
ffffffffc0204006:	6522                	ld	a0,8(sp)
ffffffffc0204008:	4985                	li	s3,1
ffffffffc020400a:	bf6d                	j	ffffffffc0203fc4 <proc_run+0x24>

ffffffffc020400c <do_fork>:
{
ffffffffc020400c:	7119                	addi	sp,sp,-128
ffffffffc020400e:	f0ca                	sd	s2,96(sp)
    if (nr_process >= MAX_PROCESS)
ffffffffc0204010:	000a6917          	auipc	s2,0xa6
ffffffffc0204014:	74890913          	addi	s2,s2,1864 # ffffffffc02aa758 <nr_process>
ffffffffc0204018:	00092703          	lw	a4,0(s2)
{
ffffffffc020401c:	fc86                	sd	ra,120(sp)
ffffffffc020401e:	f8a2                	sd	s0,112(sp)
ffffffffc0204020:	f4a6                	sd	s1,104(sp)
ffffffffc0204022:	ecce                	sd	s3,88(sp)
ffffffffc0204024:	e8d2                	sd	s4,80(sp)
ffffffffc0204026:	e4d6                	sd	s5,72(sp)
ffffffffc0204028:	e0da                	sd	s6,64(sp)
ffffffffc020402a:	fc5e                	sd	s7,56(sp)
ffffffffc020402c:	f862                	sd	s8,48(sp)
ffffffffc020402e:	f466                	sd	s9,40(sp)
ffffffffc0204030:	f06a                	sd	s10,32(sp)
ffffffffc0204032:	ec6e                	sd	s11,24(sp)
    if (nr_process >= MAX_PROCESS)
ffffffffc0204034:	6785                	lui	a5,0x1
ffffffffc0204036:	2ef75c63          	bge	a4,a5,ffffffffc020432e <do_fork+0x322>
ffffffffc020403a:	8a2a                	mv	s4,a0
ffffffffc020403c:	89ae                	mv	s3,a1
ffffffffc020403e:	84b2                	mv	s1,a2
	if ((proc = alloc_proc()) == NULL) {
ffffffffc0204040:	dddff0ef          	jal	ra,ffffffffc0203e1c <alloc_proc>
ffffffffc0204044:	842a                	mv	s0,a0
ffffffffc0204046:	2c050863          	beqz	a0,ffffffffc0204316 <do_fork+0x30a>
    proc->parent = current;
ffffffffc020404a:	000a6c17          	auipc	s8,0xa6
ffffffffc020404e:	6f6c0c13          	addi	s8,s8,1782 # ffffffffc02aa740 <current>
ffffffffc0204052:	000c3783          	ld	a5,0(s8)
    proc->wait_state = 0;
ffffffffc0204056:	0e052623          	sw	zero,236(a0)
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc020405a:	4509                	li	a0,2
    proc->parent = current;
ffffffffc020405c:	f01c                	sd	a5,32(s0)
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc020405e:	f95fc0ef          	jal	ra,ffffffffc0200ff2 <alloc_pages>
    if (page != NULL)
ffffffffc0204062:	2a050763          	beqz	a0,ffffffffc0204310 <do_fork+0x304>
    return page - pages + nbase;
ffffffffc0204066:	000a6a97          	auipc	s5,0xa6
ffffffffc020406a:	6baa8a93          	addi	s5,s5,1722 # ffffffffc02aa720 <pages>
ffffffffc020406e:	000ab683          	ld	a3,0(s5)
ffffffffc0204072:	00003b17          	auipc	s6,0x3
ffffffffc0204076:	74eb0b13          	addi	s6,s6,1870 # ffffffffc02077c0 <nbase>
ffffffffc020407a:	000b3783          	ld	a5,0(s6)
ffffffffc020407e:	40d506b3          	sub	a3,a0,a3
    return KADDR(page2pa(page));
ffffffffc0204082:	000a6b97          	auipc	s7,0xa6
ffffffffc0204086:	696b8b93          	addi	s7,s7,1686 # ffffffffc02aa718 <npage>
    return page - pages + nbase;
ffffffffc020408a:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc020408c:	5dfd                	li	s11,-1
ffffffffc020408e:	000bb703          	ld	a4,0(s7)
    return page - pages + nbase;
ffffffffc0204092:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204094:	00cddd93          	srli	s11,s11,0xc
ffffffffc0204098:	01b6f633          	and	a2,a3,s11
    return page2ppn(page) << PGSHIFT;
ffffffffc020409c:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc020409e:	2ce67563          	bgeu	a2,a4,ffffffffc0204368 <do_fork+0x35c>
    struct mm_struct *mm, *oldmm = current->mm;
ffffffffc02040a2:	000c3603          	ld	a2,0(s8)
ffffffffc02040a6:	000a6c17          	auipc	s8,0xa6
ffffffffc02040aa:	68ac0c13          	addi	s8,s8,1674 # ffffffffc02aa730 <va_pa_offset>
ffffffffc02040ae:	000c3703          	ld	a4,0(s8)
ffffffffc02040b2:	02863d03          	ld	s10,40(a2)
ffffffffc02040b6:	e43e                	sd	a5,8(sp)
ffffffffc02040b8:	96ba                	add	a3,a3,a4
        proc->kstack = (uintptr_t)page2kva(page);
ffffffffc02040ba:	e814                	sd	a3,16(s0)
    if (oldmm == NULL)
ffffffffc02040bc:	020d0863          	beqz	s10,ffffffffc02040ec <do_fork+0xe0>
    if (clone_flags & CLONE_VM)
ffffffffc02040c0:	100a7a13          	andi	s4,s4,256
ffffffffc02040c4:	180a0863          	beqz	s4,ffffffffc0204254 <do_fork+0x248>
}

static inline int
mm_count_inc(struct mm_struct *mm)
{
    mm->mm_count += 1;
ffffffffc02040c8:	030d2703          	lw	a4,48(s10)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc02040cc:	018d3783          	ld	a5,24(s10)
ffffffffc02040d0:	c02006b7          	lui	a3,0xc0200
ffffffffc02040d4:	2705                	addiw	a4,a4,1
ffffffffc02040d6:	02ed2823          	sw	a4,48(s10)
    proc->mm = mm;
ffffffffc02040da:	03a43423          	sd	s10,40(s0)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc02040de:	2ad7e163          	bltu	a5,a3,ffffffffc0204380 <do_fork+0x374>
ffffffffc02040e2:	000c3703          	ld	a4,0(s8)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc02040e6:	6814                	ld	a3,16(s0)
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc02040e8:	8f99                	sub	a5,a5,a4
ffffffffc02040ea:	f45c                	sd	a5,168(s0)
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc02040ec:	6789                	lui	a5,0x2
ffffffffc02040ee:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_obj___user_faultread_out_size-0x7cd0>
ffffffffc02040f2:	96be                	add	a3,a3,a5
    *(proc->tf) = *tf;
ffffffffc02040f4:	8626                	mv	a2,s1
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
ffffffffc02040f6:	f054                	sd	a3,160(s0)
    *(proc->tf) = *tf;
ffffffffc02040f8:	87b6                	mv	a5,a3
ffffffffc02040fa:	12048893          	addi	a7,s1,288
ffffffffc02040fe:	00063803          	ld	a6,0(a2)
ffffffffc0204102:	6608                	ld	a0,8(a2)
ffffffffc0204104:	6a0c                	ld	a1,16(a2)
ffffffffc0204106:	6e18                	ld	a4,24(a2)
ffffffffc0204108:	0107b023          	sd	a6,0(a5)
ffffffffc020410c:	e788                	sd	a0,8(a5)
ffffffffc020410e:	eb8c                	sd	a1,16(a5)
ffffffffc0204110:	ef98                	sd	a4,24(a5)
ffffffffc0204112:	02060613          	addi	a2,a2,32
ffffffffc0204116:	02078793          	addi	a5,a5,32
ffffffffc020411a:	ff1612e3          	bne	a2,a7,ffffffffc02040fe <do_fork+0xf2>
    proc->tf->gpr.a0 = 0;
ffffffffc020411e:	0406b823          	sd	zero,80(a3) # ffffffffc0200050 <kern_init+0x6>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc0204122:	12098763          	beqz	s3,ffffffffc0204250 <do_fork+0x244>
    if (++last_pid >= MAX_PID)
ffffffffc0204126:	000a2817          	auipc	a6,0xa2
ffffffffc020412a:	18a80813          	addi	a6,a6,394 # ffffffffc02a62b0 <last_pid.1>
ffffffffc020412e:	00082783          	lw	a5,0(a6)
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc0204132:	0136b823          	sd	s3,16(a3)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc0204136:	00000717          	auipc	a4,0x0
ffffffffc020413a:	d6870713          	addi	a4,a4,-664 # ffffffffc0203e9e <forkret>
    if (++last_pid >= MAX_PID)
ffffffffc020413e:	0017851b          	addiw	a0,a5,1
    proc->context.ra = (uintptr_t)forkret;
ffffffffc0204142:	f818                	sd	a4,48(s0)
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc0204144:	fc14                	sd	a3,56(s0)
    if (++last_pid >= MAX_PID)
ffffffffc0204146:	00a82023          	sw	a0,0(a6)
ffffffffc020414a:	6789                	lui	a5,0x2
ffffffffc020414c:	08f55b63          	bge	a0,a5,ffffffffc02041e2 <do_fork+0x1d6>
    if (last_pid >= next_safe)
ffffffffc0204150:	000a2317          	auipc	t1,0xa2
ffffffffc0204154:	16430313          	addi	t1,t1,356 # ffffffffc02a62b4 <next_safe.0>
ffffffffc0204158:	00032783          	lw	a5,0(t1)
ffffffffc020415c:	000a6497          	auipc	s1,0xa6
ffffffffc0204160:	57448493          	addi	s1,s1,1396 # ffffffffc02aa6d0 <proc_list>
ffffffffc0204164:	08f55763          	bge	a0,a5,ffffffffc02041f2 <do_fork+0x1e6>
    proc->pid = get_pid();
ffffffffc0204168:	c048                	sw	a0,4(s0)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc020416a:	45a9                	li	a1,10
ffffffffc020416c:	2501                	sext.w	a0,a0
ffffffffc020416e:	506010ef          	jal	ra,ffffffffc0205674 <hash32>
ffffffffc0204172:	02051793          	slli	a5,a0,0x20
ffffffffc0204176:	01c7d513          	srli	a0,a5,0x1c
ffffffffc020417a:	000a2797          	auipc	a5,0xa2
ffffffffc020417e:	55678793          	addi	a5,a5,1366 # ffffffffc02a66d0 <hash_list>
ffffffffc0204182:	953e                	add	a0,a0,a5
    __list_add(elm, listelm, listelm->next);
ffffffffc0204184:	650c                	ld	a1,8(a0)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc0204186:	7014                	ld	a3,32(s0)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc0204188:	0d840793          	addi	a5,s0,216
    prev->next = next->prev = elm;
ffffffffc020418c:	e19c                	sd	a5,0(a1)
    __list_add(elm, listelm, listelm->next);
ffffffffc020418e:	6490                	ld	a2,8(s1)
    prev->next = next->prev = elm;
ffffffffc0204190:	e51c                	sd	a5,8(a0)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc0204192:	7af8                	ld	a4,240(a3)
    list_add(&proc_list, &(proc->list_link));
ffffffffc0204194:	0c840793          	addi	a5,s0,200
    elm->next = next;
ffffffffc0204198:	f06c                	sd	a1,224(s0)
    elm->prev = prev;
ffffffffc020419a:	ec68                	sd	a0,216(s0)
    prev->next = next->prev = elm;
ffffffffc020419c:	e21c                	sd	a5,0(a2)
ffffffffc020419e:	e49c                	sd	a5,8(s1)
    elm->next = next;
ffffffffc02041a0:	e870                	sd	a2,208(s0)
    elm->prev = prev;
ffffffffc02041a2:	e464                	sd	s1,200(s0)
    proc->yptr = NULL;
ffffffffc02041a4:	0e043c23          	sd	zero,248(s0)
    if ((proc->optr = proc->parent->cptr) != NULL)
ffffffffc02041a8:	10e43023          	sd	a4,256(s0)
ffffffffc02041ac:	c311                	beqz	a4,ffffffffc02041b0 <do_fork+0x1a4>
        proc->optr->yptr = proc;
ffffffffc02041ae:	ff60                	sd	s0,248(a4)
    nr_process++;
ffffffffc02041b0:	00092783          	lw	a5,0(s2)
    wakeup_proc(proc);
ffffffffc02041b4:	8522                	mv	a0,s0
    proc->parent->cptr = proc;
ffffffffc02041b6:	fae0                	sd	s0,240(a3)
    nr_process++;
ffffffffc02041b8:	2785                	addiw	a5,a5,1
ffffffffc02041ba:	00f92023          	sw	a5,0(s2)
    wakeup_proc(proc);
ffffffffc02041be:	611000ef          	jal	ra,ffffffffc0204fce <wakeup_proc>
    ret = proc->pid;
ffffffffc02041c2:	4048                	lw	a0,4(s0)
}
ffffffffc02041c4:	70e6                	ld	ra,120(sp)
ffffffffc02041c6:	7446                	ld	s0,112(sp)
ffffffffc02041c8:	74a6                	ld	s1,104(sp)
ffffffffc02041ca:	7906                	ld	s2,96(sp)
ffffffffc02041cc:	69e6                	ld	s3,88(sp)
ffffffffc02041ce:	6a46                	ld	s4,80(sp)
ffffffffc02041d0:	6aa6                	ld	s5,72(sp)
ffffffffc02041d2:	6b06                	ld	s6,64(sp)
ffffffffc02041d4:	7be2                	ld	s7,56(sp)
ffffffffc02041d6:	7c42                	ld	s8,48(sp)
ffffffffc02041d8:	7ca2                	ld	s9,40(sp)
ffffffffc02041da:	7d02                	ld	s10,32(sp)
ffffffffc02041dc:	6de2                	ld	s11,24(sp)
ffffffffc02041de:	6109                	addi	sp,sp,128
ffffffffc02041e0:	8082                	ret
        last_pid = 1;
ffffffffc02041e2:	4785                	li	a5,1
ffffffffc02041e4:	00f82023          	sw	a5,0(a6)
        goto inside;
ffffffffc02041e8:	4505                	li	a0,1
ffffffffc02041ea:	000a2317          	auipc	t1,0xa2
ffffffffc02041ee:	0ca30313          	addi	t1,t1,202 # ffffffffc02a62b4 <next_safe.0>
    return listelm->next;
ffffffffc02041f2:	000a6497          	auipc	s1,0xa6
ffffffffc02041f6:	4de48493          	addi	s1,s1,1246 # ffffffffc02aa6d0 <proc_list>
ffffffffc02041fa:	0084be03          	ld	t3,8(s1)
        next_safe = MAX_PID;
ffffffffc02041fe:	6789                	lui	a5,0x2
ffffffffc0204200:	00f32023          	sw	a5,0(t1)
ffffffffc0204204:	86aa                	mv	a3,a0
ffffffffc0204206:	4581                	li	a1,0
        while ((le = list_next(le)) != list)
ffffffffc0204208:	6e89                	lui	t4,0x2
ffffffffc020420a:	109e0d63          	beq	t3,s1,ffffffffc0204324 <do_fork+0x318>
ffffffffc020420e:	88ae                	mv	a7,a1
ffffffffc0204210:	87f2                	mv	a5,t3
ffffffffc0204212:	6609                	lui	a2,0x2
ffffffffc0204214:	a811                	j	ffffffffc0204228 <do_fork+0x21c>
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc0204216:	00e6d663          	bge	a3,a4,ffffffffc0204222 <do_fork+0x216>
ffffffffc020421a:	00c75463          	bge	a4,a2,ffffffffc0204222 <do_fork+0x216>
ffffffffc020421e:	863a                	mv	a2,a4
ffffffffc0204220:	4885                	li	a7,1
ffffffffc0204222:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0204224:	00978d63          	beq	a5,s1,ffffffffc020423e <do_fork+0x232>
            if (proc->pid == last_pid)
ffffffffc0204228:	f3c7a703          	lw	a4,-196(a5) # 1f3c <_binary_obj___user_faultread_out_size-0x7c74>
ffffffffc020422c:	fed715e3          	bne	a4,a3,ffffffffc0204216 <do_fork+0x20a>
                if (++last_pid >= next_safe)
ffffffffc0204230:	2685                	addiw	a3,a3,1
ffffffffc0204232:	0ec6d463          	bge	a3,a2,ffffffffc020431a <do_fork+0x30e>
ffffffffc0204236:	679c                	ld	a5,8(a5)
ffffffffc0204238:	4585                	li	a1,1
        while ((le = list_next(le)) != list)
ffffffffc020423a:	fe9797e3          	bne	a5,s1,ffffffffc0204228 <do_fork+0x21c>
ffffffffc020423e:	c581                	beqz	a1,ffffffffc0204246 <do_fork+0x23a>
ffffffffc0204240:	00d82023          	sw	a3,0(a6)
ffffffffc0204244:	8536                	mv	a0,a3
ffffffffc0204246:	f20881e3          	beqz	a7,ffffffffc0204168 <do_fork+0x15c>
ffffffffc020424a:	00c32023          	sw	a2,0(t1)
ffffffffc020424e:	bf29                	j	ffffffffc0204168 <do_fork+0x15c>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc0204250:	89b6                	mv	s3,a3
ffffffffc0204252:	bdd1                	j	ffffffffc0204126 <do_fork+0x11a>
    if ((mm = mm_create()) == NULL)
ffffffffc0204254:	dc2fe0ef          	jal	ra,ffffffffc0202816 <mm_create>
ffffffffc0204258:	8caa                	mv	s9,a0
ffffffffc020425a:	c159                	beqz	a0,ffffffffc02042e0 <do_fork+0x2d4>
    if ((page = alloc_page()) == NULL)
ffffffffc020425c:	4505                	li	a0,1
ffffffffc020425e:	d95fc0ef          	jal	ra,ffffffffc0200ff2 <alloc_pages>
ffffffffc0204262:	cd25                	beqz	a0,ffffffffc02042da <do_fork+0x2ce>
    return page - pages + nbase;
ffffffffc0204264:	000ab683          	ld	a3,0(s5)
ffffffffc0204268:	67a2                	ld	a5,8(sp)
    return KADDR(page2pa(page));
ffffffffc020426a:	000bb703          	ld	a4,0(s7)
    return page - pages + nbase;
ffffffffc020426e:	40d506b3          	sub	a3,a0,a3
ffffffffc0204272:	8699                	srai	a3,a3,0x6
ffffffffc0204274:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204276:	01b6fdb3          	and	s11,a3,s11
    return page2ppn(page) << PGSHIFT;
ffffffffc020427a:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc020427c:	0eedf663          	bgeu	s11,a4,ffffffffc0204368 <do_fork+0x35c>
ffffffffc0204280:	000c3a03          	ld	s4,0(s8)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc0204284:	6605                	lui	a2,0x1
ffffffffc0204286:	000a6597          	auipc	a1,0xa6
ffffffffc020428a:	48a5b583          	ld	a1,1162(a1) # ffffffffc02aa710 <boot_pgdir_va>
ffffffffc020428e:	9a36                	add	s4,s4,a3
ffffffffc0204290:	8552                	mv	a0,s4
ffffffffc0204292:	7dd000ef          	jal	ra,ffffffffc020526e <memcpy>
static inline void
lock_mm(struct mm_struct *mm)
{
    if (mm != NULL)
    {
        lock(&(mm->mm_lock));
ffffffffc0204296:	038d0d93          	addi	s11,s10,56
    mm->pgdir = pgdir;
ffffffffc020429a:	014cbc23          	sd	s4,24(s9)
 * test_and_set_bit - Atomically set a bit and return its old value
 * @nr:     the bit to set
 * @addr:   the address to count from
 * */
static inline bool test_and_set_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc020429e:	4785                	li	a5,1
ffffffffc02042a0:	40fdb7af          	amoor.d	a5,a5,(s11)
}

static inline void
lock(lock_t *lock)
{
    while (!try_lock(lock))
ffffffffc02042a4:	8b85                	andi	a5,a5,1
ffffffffc02042a6:	4a05                	li	s4,1
ffffffffc02042a8:	c799                	beqz	a5,ffffffffc02042b6 <do_fork+0x2aa>
    {
        schedule();
ffffffffc02042aa:	5a5000ef          	jal	ra,ffffffffc020504e <schedule>
ffffffffc02042ae:	414db7af          	amoor.d	a5,s4,(s11)
    while (!try_lock(lock))
ffffffffc02042b2:	8b85                	andi	a5,a5,1
ffffffffc02042b4:	fbfd                	bnez	a5,ffffffffc02042aa <do_fork+0x29e>
        ret = dup_mmap(mm, oldmm);
ffffffffc02042b6:	85ea                	mv	a1,s10
ffffffffc02042b8:	8566                	mv	a0,s9
ffffffffc02042ba:	f9efe0ef          	jal	ra,ffffffffc0202a58 <dup_mmap>
 * test_and_clear_bit - Atomically clear a bit and return its old value
 * @nr:     the bit to clear
 * @addr:   the address to count from
 * */
static inline bool test_and_clear_bit(int nr, volatile void *addr) {
    return __test_and_op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc02042be:	57f9                	li	a5,-2
ffffffffc02042c0:	60fdb7af          	amoand.d	a5,a5,(s11)
ffffffffc02042c4:	8b85                	andi	a5,a5,1
}

static inline void
unlock(lock_t *lock)
{
    if (!test_and_clear_bit(0, lock))
ffffffffc02042c6:	cbad                	beqz	a5,ffffffffc0204338 <do_fork+0x32c>
good_mm:
ffffffffc02042c8:	8d66                	mv	s10,s9
    if (ret != 0)
ffffffffc02042ca:	de050fe3          	beqz	a0,ffffffffc02040c8 <do_fork+0xbc>
    exit_mmap(mm);
ffffffffc02042ce:	8566                	mv	a0,s9
ffffffffc02042d0:	823fe0ef          	jal	ra,ffffffffc0202af2 <exit_mmap>
    put_pgdir(mm);
ffffffffc02042d4:	8566                	mv	a0,s9
ffffffffc02042d6:	c55ff0ef          	jal	ra,ffffffffc0203f2a <put_pgdir>
    mm_destroy(mm);
ffffffffc02042da:	8566                	mv	a0,s9
ffffffffc02042dc:	e7afe0ef          	jal	ra,ffffffffc0202956 <mm_destroy>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc02042e0:	6814                	ld	a3,16(s0)
    return pa2page(PADDR(kva));
ffffffffc02042e2:	c02007b7          	lui	a5,0xc0200
ffffffffc02042e6:	0af6ea63          	bltu	a3,a5,ffffffffc020439a <do_fork+0x38e>
ffffffffc02042ea:	000c3783          	ld	a5,0(s8)
    if (PPN(pa) >= npage)
ffffffffc02042ee:	000bb703          	ld	a4,0(s7)
    return pa2page(PADDR(kva));
ffffffffc02042f2:	40f687b3          	sub	a5,a3,a5
    if (PPN(pa) >= npage)
ffffffffc02042f6:	83b1                	srli	a5,a5,0xc
ffffffffc02042f8:	04e7fc63          	bgeu	a5,a4,ffffffffc0204350 <do_fork+0x344>
    return &pages[PPN(pa) - nbase];
ffffffffc02042fc:	000b3703          	ld	a4,0(s6)
ffffffffc0204300:	000ab503          	ld	a0,0(s5)
ffffffffc0204304:	4589                	li	a1,2
ffffffffc0204306:	8f99                	sub	a5,a5,a4
ffffffffc0204308:	079a                	slli	a5,a5,0x6
ffffffffc020430a:	953e                	add	a0,a0,a5
ffffffffc020430c:	d25fc0ef          	jal	ra,ffffffffc0201030 <free_pages>
    kfree(proc);
ffffffffc0204310:	8522                	mv	a0,s0
ffffffffc0204312:	ef1fe0ef          	jal	ra,ffffffffc0203202 <kfree>
    ret = -E_NO_MEM;
ffffffffc0204316:	5571                	li	a0,-4
    return ret;
ffffffffc0204318:	b575                	j	ffffffffc02041c4 <do_fork+0x1b8>
                    if (last_pid >= MAX_PID)
ffffffffc020431a:	01d6c363          	blt	a3,t4,ffffffffc0204320 <do_fork+0x314>
                        last_pid = 1;
ffffffffc020431e:	4685                	li	a3,1
                    goto repeat;
ffffffffc0204320:	4585                	li	a1,1
ffffffffc0204322:	b5e5                	j	ffffffffc020420a <do_fork+0x1fe>
ffffffffc0204324:	c599                	beqz	a1,ffffffffc0204332 <do_fork+0x326>
ffffffffc0204326:	00d82023          	sw	a3,0(a6)
    return last_pid;
ffffffffc020432a:	8536                	mv	a0,a3
ffffffffc020432c:	bd35                	j	ffffffffc0204168 <do_fork+0x15c>
    int ret = -E_NO_FREE_PROC;
ffffffffc020432e:	556d                	li	a0,-5
ffffffffc0204330:	bd51                	j	ffffffffc02041c4 <do_fork+0x1b8>
    return last_pid;
ffffffffc0204332:	00082503          	lw	a0,0(a6)
ffffffffc0204336:	bd0d                	j	ffffffffc0204168 <do_fork+0x15c>
    {
        panic("Unlock failed.\n");
ffffffffc0204338:	00003617          	auipc	a2,0x3
ffffffffc020433c:	c0860613          	addi	a2,a2,-1016 # ffffffffc0206f40 <default_pmm_manager+0xb0>
ffffffffc0204340:	03f00593          	li	a1,63
ffffffffc0204344:	00003517          	auipc	a0,0x3
ffffffffc0204348:	c0c50513          	addi	a0,a0,-1012 # ffffffffc0206f50 <default_pmm_manager+0xc0>
ffffffffc020434c:	ed3fb0ef          	jal	ra,ffffffffc020021e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0204350:	00002617          	auipc	a2,0x2
ffffffffc0204354:	db060613          	addi	a2,a2,-592 # ffffffffc0206100 <commands+0x7c8>
ffffffffc0204358:	06900593          	li	a1,105
ffffffffc020435c:	00002517          	auipc	a0,0x2
ffffffffc0204360:	dc450513          	addi	a0,a0,-572 # ffffffffc0206120 <commands+0x7e8>
ffffffffc0204364:	ebbfb0ef          	jal	ra,ffffffffc020021e <__panic>
    return KADDR(page2pa(page));
ffffffffc0204368:	00002617          	auipc	a2,0x2
ffffffffc020436c:	df060613          	addi	a2,a2,-528 # ffffffffc0206158 <commands+0x820>
ffffffffc0204370:	07100593          	li	a1,113
ffffffffc0204374:	00002517          	auipc	a0,0x2
ffffffffc0204378:	dac50513          	addi	a0,a0,-596 # ffffffffc0206120 <commands+0x7e8>
ffffffffc020437c:	ea3fb0ef          	jal	ra,ffffffffc020021e <__panic>
    proc->pgdir = PADDR(mm->pgdir);
ffffffffc0204380:	86be                	mv	a3,a5
ffffffffc0204382:	00002617          	auipc	a2,0x2
ffffffffc0204386:	ee660613          	addi	a2,a2,-282 # ffffffffc0206268 <commands+0x930>
ffffffffc020438a:	19600593          	li	a1,406
ffffffffc020438e:	00003517          	auipc	a0,0x3
ffffffffc0204392:	b9a50513          	addi	a0,a0,-1126 # ffffffffc0206f28 <default_pmm_manager+0x98>
ffffffffc0204396:	e89fb0ef          	jal	ra,ffffffffc020021e <__panic>
    return pa2page(PADDR(kva));
ffffffffc020439a:	00002617          	auipc	a2,0x2
ffffffffc020439e:	ece60613          	addi	a2,a2,-306 # ffffffffc0206268 <commands+0x930>
ffffffffc02043a2:	07700593          	li	a1,119
ffffffffc02043a6:	00002517          	auipc	a0,0x2
ffffffffc02043aa:	d7a50513          	addi	a0,a0,-646 # ffffffffc0206120 <commands+0x7e8>
ffffffffc02043ae:	e71fb0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc02043b2 <kernel_thread>:
{
ffffffffc02043b2:	7129                	addi	sp,sp,-320
ffffffffc02043b4:	fa22                	sd	s0,304(sp)
ffffffffc02043b6:	f626                	sd	s1,296(sp)
ffffffffc02043b8:	f24a                	sd	s2,288(sp)
ffffffffc02043ba:	84ae                	mv	s1,a1
ffffffffc02043bc:	892a                	mv	s2,a0
ffffffffc02043be:	8432                	mv	s0,a2
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc02043c0:	4581                	li	a1,0
ffffffffc02043c2:	12000613          	li	a2,288
ffffffffc02043c6:	850a                	mv	a0,sp
{
ffffffffc02043c8:	fe06                	sd	ra,312(sp)
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc02043ca:	693000ef          	jal	ra,ffffffffc020525c <memset>
    tf.gpr.s0 = (uintptr_t)fn;
ffffffffc02043ce:	e0ca                	sd	s2,64(sp)
    tf.gpr.s1 = (uintptr_t)arg;
ffffffffc02043d0:	e4a6                	sd	s1,72(sp)
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc02043d2:	100027f3          	csrr	a5,sstatus
ffffffffc02043d6:	edd7f793          	andi	a5,a5,-291
ffffffffc02043da:	1207e793          	ori	a5,a5,288
ffffffffc02043de:	e23e                	sd	a5,256(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02043e0:	860a                	mv	a2,sp
ffffffffc02043e2:	10046513          	ori	a0,s0,256
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc02043e6:	00000797          	auipc	a5,0x0
ffffffffc02043ea:	9c478793          	addi	a5,a5,-1596 # ffffffffc0203daa <kernel_thread_entry>
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02043ee:	4581                	li	a1,0
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc02043f0:	e63e                	sd	a5,264(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc02043f2:	c1bff0ef          	jal	ra,ffffffffc020400c <do_fork>
}
ffffffffc02043f6:	70f2                	ld	ra,312(sp)
ffffffffc02043f8:	7452                	ld	s0,304(sp)
ffffffffc02043fa:	74b2                	ld	s1,296(sp)
ffffffffc02043fc:	7912                	ld	s2,288(sp)
ffffffffc02043fe:	6131                	addi	sp,sp,320
ffffffffc0204400:	8082                	ret

ffffffffc0204402 <do_exit>:
{
ffffffffc0204402:	7179                	addi	sp,sp,-48
ffffffffc0204404:	f022                	sd	s0,32(sp)
    if (current == idleproc)
ffffffffc0204406:	000a6417          	auipc	s0,0xa6
ffffffffc020440a:	33a40413          	addi	s0,s0,826 # ffffffffc02aa740 <current>
ffffffffc020440e:	601c                	ld	a5,0(s0)
{
ffffffffc0204410:	f406                	sd	ra,40(sp)
ffffffffc0204412:	ec26                	sd	s1,24(sp)
ffffffffc0204414:	e84a                	sd	s2,16(sp)
ffffffffc0204416:	e44e                	sd	s3,8(sp)
ffffffffc0204418:	e052                	sd	s4,0(sp)
    if (current == idleproc)
ffffffffc020441a:	000a6717          	auipc	a4,0xa6
ffffffffc020441e:	32e73703          	ld	a4,814(a4) # ffffffffc02aa748 <idleproc>
ffffffffc0204422:	0ce78c63          	beq	a5,a4,ffffffffc02044fa <do_exit+0xf8>
    if (current == initproc)
ffffffffc0204426:	000a6497          	auipc	s1,0xa6
ffffffffc020442a:	32a48493          	addi	s1,s1,810 # ffffffffc02aa750 <initproc>
ffffffffc020442e:	6098                	ld	a4,0(s1)
ffffffffc0204430:	0ee78b63          	beq	a5,a4,ffffffffc0204526 <do_exit+0x124>
    struct mm_struct *mm = current->mm;
ffffffffc0204434:	0287b983          	ld	s3,40(a5)
ffffffffc0204438:	892a                	mv	s2,a0
    if (mm != NULL)
ffffffffc020443a:	02098663          	beqz	s3,ffffffffc0204466 <do_exit+0x64>
ffffffffc020443e:	000a6797          	auipc	a5,0xa6
ffffffffc0204442:	2ca7b783          	ld	a5,714(a5) # ffffffffc02aa708 <boot_pgdir_pa>
ffffffffc0204446:	577d                	li	a4,-1
ffffffffc0204448:	177e                	slli	a4,a4,0x3f
ffffffffc020444a:	83b1                	srli	a5,a5,0xc
ffffffffc020444c:	8fd9                	or	a5,a5,a4
ffffffffc020444e:	18079073          	csrw	satp,a5
    mm->mm_count -= 1;
ffffffffc0204452:	0309a783          	lw	a5,48(s3)
ffffffffc0204456:	fff7871b          	addiw	a4,a5,-1
ffffffffc020445a:	02e9a823          	sw	a4,48(s3)
        if (mm_count_dec(mm) == 0)
ffffffffc020445e:	cb55                	beqz	a4,ffffffffc0204512 <do_exit+0x110>
        current->mm = NULL;
ffffffffc0204460:	601c                	ld	a5,0(s0)
ffffffffc0204462:	0207b423          	sd	zero,40(a5)
    current->state = PROC_ZOMBIE;
ffffffffc0204466:	601c                	ld	a5,0(s0)
ffffffffc0204468:	470d                	li	a4,3
ffffffffc020446a:	c398                	sw	a4,0(a5)
    current->exit_code = error_code;
ffffffffc020446c:	0f27a423          	sw	s2,232(a5)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204470:	100027f3          	csrr	a5,sstatus
ffffffffc0204474:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0204476:	4a01                	li	s4,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204478:	e3f9                	bnez	a5,ffffffffc020453e <do_exit+0x13c>
        proc = current->parent;
ffffffffc020447a:	6018                	ld	a4,0(s0)
        if (proc->wait_state == WT_CHILD)
ffffffffc020447c:	800007b7          	lui	a5,0x80000
ffffffffc0204480:	0785                	addi	a5,a5,1
        proc = current->parent;
ffffffffc0204482:	7308                	ld	a0,32(a4)
        if (proc->wait_state == WT_CHILD)
ffffffffc0204484:	0ec52703          	lw	a4,236(a0)
ffffffffc0204488:	0af70f63          	beq	a4,a5,ffffffffc0204546 <do_exit+0x144>
        while (current->cptr != NULL)
ffffffffc020448c:	6018                	ld	a4,0(s0)
ffffffffc020448e:	7b7c                	ld	a5,240(a4)
ffffffffc0204490:	c3a1                	beqz	a5,ffffffffc02044d0 <do_exit+0xce>
                if (initproc->wait_state == WT_CHILD)
ffffffffc0204492:	800009b7          	lui	s3,0x80000
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204496:	490d                	li	s2,3
                if (initproc->wait_state == WT_CHILD)
ffffffffc0204498:	0985                	addi	s3,s3,1
ffffffffc020449a:	a021                	j	ffffffffc02044a2 <do_exit+0xa0>
        while (current->cptr != NULL)
ffffffffc020449c:	6018                	ld	a4,0(s0)
ffffffffc020449e:	7b7c                	ld	a5,240(a4)
ffffffffc02044a0:	cb85                	beqz	a5,ffffffffc02044d0 <do_exit+0xce>
            current->cptr = proc->optr;
ffffffffc02044a2:	1007b683          	ld	a3,256(a5) # ffffffff80000100 <_binary_obj___user_exit_out_size+0xffffffff7fff4fe0>
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc02044a6:	6088                	ld	a0,0(s1)
            current->cptr = proc->optr;
ffffffffc02044a8:	fb74                	sd	a3,240(a4)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc02044aa:	7978                	ld	a4,240(a0)
            proc->yptr = NULL;
ffffffffc02044ac:	0e07bc23          	sd	zero,248(a5)
            if ((proc->optr = initproc->cptr) != NULL)
ffffffffc02044b0:	10e7b023          	sd	a4,256(a5)
ffffffffc02044b4:	c311                	beqz	a4,ffffffffc02044b8 <do_exit+0xb6>
                initproc->cptr->yptr = proc;
ffffffffc02044b6:	ff7c                	sd	a5,248(a4)
            if (proc->state == PROC_ZOMBIE)
ffffffffc02044b8:	4398                	lw	a4,0(a5)
            proc->parent = initproc;
ffffffffc02044ba:	f388                	sd	a0,32(a5)
            initproc->cptr = proc;
ffffffffc02044bc:	f97c                	sd	a5,240(a0)
            if (proc->state == PROC_ZOMBIE)
ffffffffc02044be:	fd271fe3          	bne	a4,s2,ffffffffc020449c <do_exit+0x9a>
                if (initproc->wait_state == WT_CHILD)
ffffffffc02044c2:	0ec52783          	lw	a5,236(a0)
ffffffffc02044c6:	fd379be3          	bne	a5,s3,ffffffffc020449c <do_exit+0x9a>
                    wakeup_proc(initproc);
ffffffffc02044ca:	305000ef          	jal	ra,ffffffffc0204fce <wakeup_proc>
ffffffffc02044ce:	b7f9                	j	ffffffffc020449c <do_exit+0x9a>
    if (flag)
ffffffffc02044d0:	020a1263          	bnez	s4,ffffffffc02044f4 <do_exit+0xf2>
    schedule();
ffffffffc02044d4:	37b000ef          	jal	ra,ffffffffc020504e <schedule>
    panic("do_exit will not return!! %d.\n", current->pid);
ffffffffc02044d8:	601c                	ld	a5,0(s0)
ffffffffc02044da:	00003617          	auipc	a2,0x3
ffffffffc02044de:	aae60613          	addi	a2,a2,-1362 # ffffffffc0206f88 <default_pmm_manager+0xf8>
ffffffffc02044e2:	24b00593          	li	a1,587
ffffffffc02044e6:	43d4                	lw	a3,4(a5)
ffffffffc02044e8:	00003517          	auipc	a0,0x3
ffffffffc02044ec:	a4050513          	addi	a0,a0,-1472 # ffffffffc0206f28 <default_pmm_manager+0x98>
ffffffffc02044f0:	d2ffb0ef          	jal	ra,ffffffffc020021e <__panic>
        intr_enable();
ffffffffc02044f4:	cc0fc0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
ffffffffc02044f8:	bff1                	j	ffffffffc02044d4 <do_exit+0xd2>
        panic("idleproc exit.\n");
ffffffffc02044fa:	00003617          	auipc	a2,0x3
ffffffffc02044fe:	a6e60613          	addi	a2,a2,-1426 # ffffffffc0206f68 <default_pmm_manager+0xd8>
ffffffffc0204502:	21700593          	li	a1,535
ffffffffc0204506:	00003517          	auipc	a0,0x3
ffffffffc020450a:	a2250513          	addi	a0,a0,-1502 # ffffffffc0206f28 <default_pmm_manager+0x98>
ffffffffc020450e:	d11fb0ef          	jal	ra,ffffffffc020021e <__panic>
            exit_mmap(mm);
ffffffffc0204512:	854e                	mv	a0,s3
ffffffffc0204514:	ddefe0ef          	jal	ra,ffffffffc0202af2 <exit_mmap>
            put_pgdir(mm);
ffffffffc0204518:	854e                	mv	a0,s3
ffffffffc020451a:	a11ff0ef          	jal	ra,ffffffffc0203f2a <put_pgdir>
            mm_destroy(mm);
ffffffffc020451e:	854e                	mv	a0,s3
ffffffffc0204520:	c36fe0ef          	jal	ra,ffffffffc0202956 <mm_destroy>
ffffffffc0204524:	bf35                	j	ffffffffc0204460 <do_exit+0x5e>
        panic("initproc exit.\n");
ffffffffc0204526:	00003617          	auipc	a2,0x3
ffffffffc020452a:	a5260613          	addi	a2,a2,-1454 # ffffffffc0206f78 <default_pmm_manager+0xe8>
ffffffffc020452e:	21b00593          	li	a1,539
ffffffffc0204532:	00003517          	auipc	a0,0x3
ffffffffc0204536:	9f650513          	addi	a0,a0,-1546 # ffffffffc0206f28 <default_pmm_manager+0x98>
ffffffffc020453a:	ce5fb0ef          	jal	ra,ffffffffc020021e <__panic>
        intr_disable();
ffffffffc020453e:	c7cfc0ef          	jal	ra,ffffffffc02009ba <intr_disable>
        return 1;
ffffffffc0204542:	4a05                	li	s4,1
ffffffffc0204544:	bf1d                	j	ffffffffc020447a <do_exit+0x78>
            wakeup_proc(proc);
ffffffffc0204546:	289000ef          	jal	ra,ffffffffc0204fce <wakeup_proc>
ffffffffc020454a:	b789                	j	ffffffffc020448c <do_exit+0x8a>

ffffffffc020454c <do_wait.part.0>:
int do_wait(int pid, int *code_store)
ffffffffc020454c:	715d                	addi	sp,sp,-80
ffffffffc020454e:	f84a                	sd	s2,48(sp)
ffffffffc0204550:	f44e                	sd	s3,40(sp)
        current->wait_state = WT_CHILD;
ffffffffc0204552:	80000937          	lui	s2,0x80000
    if (0 < pid && pid < MAX_PID)
ffffffffc0204556:	6989                	lui	s3,0x2
int do_wait(int pid, int *code_store)
ffffffffc0204558:	fc26                	sd	s1,56(sp)
ffffffffc020455a:	f052                	sd	s4,32(sp)
ffffffffc020455c:	ec56                	sd	s5,24(sp)
ffffffffc020455e:	e85a                	sd	s6,16(sp)
ffffffffc0204560:	e45e                	sd	s7,8(sp)
ffffffffc0204562:	e486                	sd	ra,72(sp)
ffffffffc0204564:	e0a2                	sd	s0,64(sp)
ffffffffc0204566:	84aa                	mv	s1,a0
ffffffffc0204568:	8a2e                	mv	s4,a1
        proc = current->cptr;
ffffffffc020456a:	000a6b97          	auipc	s7,0xa6
ffffffffc020456e:	1d6b8b93          	addi	s7,s7,470 # ffffffffc02aa740 <current>
    if (0 < pid && pid < MAX_PID)
ffffffffc0204572:	00050b1b          	sext.w	s6,a0
ffffffffc0204576:	fff50a9b          	addiw	s5,a0,-1
ffffffffc020457a:	19f9                	addi	s3,s3,-2
        current->wait_state = WT_CHILD;
ffffffffc020457c:	0905                	addi	s2,s2,1
    if (pid != 0)
ffffffffc020457e:	ccbd                	beqz	s1,ffffffffc02045fc <do_wait.part.0+0xb0>
    if (0 < pid && pid < MAX_PID)
ffffffffc0204580:	0359e863          	bltu	s3,s5,ffffffffc02045b0 <do_wait.part.0+0x64>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204584:	45a9                	li	a1,10
ffffffffc0204586:	855a                	mv	a0,s6
ffffffffc0204588:	0ec010ef          	jal	ra,ffffffffc0205674 <hash32>
ffffffffc020458c:	02051793          	slli	a5,a0,0x20
ffffffffc0204590:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0204594:	000a2797          	auipc	a5,0xa2
ffffffffc0204598:	13c78793          	addi	a5,a5,316 # ffffffffc02a66d0 <hash_list>
ffffffffc020459c:	953e                	add	a0,a0,a5
ffffffffc020459e:	842a                	mv	s0,a0
        while ((le = list_next(le)) != list)
ffffffffc02045a0:	a029                	j	ffffffffc02045aa <do_wait.part.0+0x5e>
            if (proc->pid == pid)
ffffffffc02045a2:	f2c42783          	lw	a5,-212(s0)
ffffffffc02045a6:	02978163          	beq	a5,s1,ffffffffc02045c8 <do_wait.part.0+0x7c>
ffffffffc02045aa:	6400                	ld	s0,8(s0)
        while ((le = list_next(le)) != list)
ffffffffc02045ac:	fe851be3          	bne	a0,s0,ffffffffc02045a2 <do_wait.part.0+0x56>
    return -E_BAD_PROC;
ffffffffc02045b0:	5579                	li	a0,-2
}
ffffffffc02045b2:	60a6                	ld	ra,72(sp)
ffffffffc02045b4:	6406                	ld	s0,64(sp)
ffffffffc02045b6:	74e2                	ld	s1,56(sp)
ffffffffc02045b8:	7942                	ld	s2,48(sp)
ffffffffc02045ba:	79a2                	ld	s3,40(sp)
ffffffffc02045bc:	7a02                	ld	s4,32(sp)
ffffffffc02045be:	6ae2                	ld	s5,24(sp)
ffffffffc02045c0:	6b42                	ld	s6,16(sp)
ffffffffc02045c2:	6ba2                	ld	s7,8(sp)
ffffffffc02045c4:	6161                	addi	sp,sp,80
ffffffffc02045c6:	8082                	ret
        if (proc != NULL && proc->parent == current)
ffffffffc02045c8:	000bb683          	ld	a3,0(s7)
ffffffffc02045cc:	f4843783          	ld	a5,-184(s0)
ffffffffc02045d0:	fed790e3          	bne	a5,a3,ffffffffc02045b0 <do_wait.part.0+0x64>
            if (proc->state == PROC_ZOMBIE)
ffffffffc02045d4:	f2842703          	lw	a4,-216(s0)
ffffffffc02045d8:	478d                	li	a5,3
ffffffffc02045da:	0ef70b63          	beq	a4,a5,ffffffffc02046d0 <do_wait.part.0+0x184>
        current->state = PROC_SLEEPING;
ffffffffc02045de:	4785                	li	a5,1
ffffffffc02045e0:	c29c                	sw	a5,0(a3)
        current->wait_state = WT_CHILD;
ffffffffc02045e2:	0f26a623          	sw	s2,236(a3)
        schedule();
ffffffffc02045e6:	269000ef          	jal	ra,ffffffffc020504e <schedule>
        if (current->flags & PF_EXITING)
ffffffffc02045ea:	000bb783          	ld	a5,0(s7)
ffffffffc02045ee:	0b07a783          	lw	a5,176(a5)
ffffffffc02045f2:	8b85                	andi	a5,a5,1
ffffffffc02045f4:	d7c9                	beqz	a5,ffffffffc020457e <do_wait.part.0+0x32>
            do_exit(-E_KILLED);
ffffffffc02045f6:	555d                	li	a0,-9
ffffffffc02045f8:	e0bff0ef          	jal	ra,ffffffffc0204402 <do_exit>
        proc = current->cptr;
ffffffffc02045fc:	000bb683          	ld	a3,0(s7)
ffffffffc0204600:	7ae0                	ld	s0,240(a3)
        for (; proc != NULL; proc = proc->optr)
ffffffffc0204602:	d45d                	beqz	s0,ffffffffc02045b0 <do_wait.part.0+0x64>
            if (proc->state == PROC_ZOMBIE)
ffffffffc0204604:	470d                	li	a4,3
ffffffffc0204606:	a021                	j	ffffffffc020460e <do_wait.part.0+0xc2>
        for (; proc != NULL; proc = proc->optr)
ffffffffc0204608:	10043403          	ld	s0,256(s0)
ffffffffc020460c:	d869                	beqz	s0,ffffffffc02045de <do_wait.part.0+0x92>
            if (proc->state == PROC_ZOMBIE)
ffffffffc020460e:	401c                	lw	a5,0(s0)
ffffffffc0204610:	fee79ce3          	bne	a5,a4,ffffffffc0204608 <do_wait.part.0+0xbc>
    if (proc == idleproc || proc == initproc)
ffffffffc0204614:	000a6797          	auipc	a5,0xa6
ffffffffc0204618:	1347b783          	ld	a5,308(a5) # ffffffffc02aa748 <idleproc>
ffffffffc020461c:	0c878963          	beq	a5,s0,ffffffffc02046ee <do_wait.part.0+0x1a2>
ffffffffc0204620:	000a6797          	auipc	a5,0xa6
ffffffffc0204624:	1307b783          	ld	a5,304(a5) # ffffffffc02aa750 <initproc>
ffffffffc0204628:	0cf40363          	beq	s0,a5,ffffffffc02046ee <do_wait.part.0+0x1a2>
    if (code_store != NULL)
ffffffffc020462c:	000a0663          	beqz	s4,ffffffffc0204638 <do_wait.part.0+0xec>
        *code_store = proc->exit_code;
ffffffffc0204630:	0e842783          	lw	a5,232(s0)
ffffffffc0204634:	00fa2023          	sw	a5,0(s4)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204638:	100027f3          	csrr	a5,sstatus
ffffffffc020463c:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc020463e:	4581                	li	a1,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204640:	e7c1                	bnez	a5,ffffffffc02046c8 <do_wait.part.0+0x17c>
    __list_del(listelm->prev, listelm->next);
ffffffffc0204642:	6c70                	ld	a2,216(s0)
ffffffffc0204644:	7074                	ld	a3,224(s0)
    if (proc->optr != NULL)
ffffffffc0204646:	10043703          	ld	a4,256(s0)
        proc->optr->yptr = proc->yptr;
ffffffffc020464a:	7c7c                	ld	a5,248(s0)
    prev->next = next;
ffffffffc020464c:	e614                	sd	a3,8(a2)
    next->prev = prev;
ffffffffc020464e:	e290                	sd	a2,0(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc0204650:	6470                	ld	a2,200(s0)
ffffffffc0204652:	6874                	ld	a3,208(s0)
    prev->next = next;
ffffffffc0204654:	e614                	sd	a3,8(a2)
    next->prev = prev;
ffffffffc0204656:	e290                	sd	a2,0(a3)
    if (proc->optr != NULL)
ffffffffc0204658:	c319                	beqz	a4,ffffffffc020465e <do_wait.part.0+0x112>
        proc->optr->yptr = proc->yptr;
ffffffffc020465a:	ff7c                	sd	a5,248(a4)
    if (proc->yptr != NULL)
ffffffffc020465c:	7c7c                	ld	a5,248(s0)
ffffffffc020465e:	c3b5                	beqz	a5,ffffffffc02046c2 <do_wait.part.0+0x176>
        proc->yptr->optr = proc->optr;
ffffffffc0204660:	10e7b023          	sd	a4,256(a5)
    nr_process--;
ffffffffc0204664:	000a6717          	auipc	a4,0xa6
ffffffffc0204668:	0f470713          	addi	a4,a4,244 # ffffffffc02aa758 <nr_process>
ffffffffc020466c:	431c                	lw	a5,0(a4)
ffffffffc020466e:	37fd                	addiw	a5,a5,-1
ffffffffc0204670:	c31c                	sw	a5,0(a4)
    if (flag)
ffffffffc0204672:	e5a9                	bnez	a1,ffffffffc02046bc <do_wait.part.0+0x170>
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
ffffffffc0204674:	6814                	ld	a3,16(s0)
ffffffffc0204676:	c02007b7          	lui	a5,0xc0200
ffffffffc020467a:	04f6ee63          	bltu	a3,a5,ffffffffc02046d6 <do_wait.part.0+0x18a>
ffffffffc020467e:	000a6797          	auipc	a5,0xa6
ffffffffc0204682:	0b27b783          	ld	a5,178(a5) # ffffffffc02aa730 <va_pa_offset>
ffffffffc0204686:	8e9d                	sub	a3,a3,a5
    if (PPN(pa) >= npage)
ffffffffc0204688:	82b1                	srli	a3,a3,0xc
ffffffffc020468a:	000a6797          	auipc	a5,0xa6
ffffffffc020468e:	08e7b783          	ld	a5,142(a5) # ffffffffc02aa718 <npage>
ffffffffc0204692:	06f6fa63          	bgeu	a3,a5,ffffffffc0204706 <do_wait.part.0+0x1ba>
    return &pages[PPN(pa) - nbase];
ffffffffc0204696:	00003517          	auipc	a0,0x3
ffffffffc020469a:	12a53503          	ld	a0,298(a0) # ffffffffc02077c0 <nbase>
ffffffffc020469e:	8e89                	sub	a3,a3,a0
ffffffffc02046a0:	069a                	slli	a3,a3,0x6
ffffffffc02046a2:	000a6517          	auipc	a0,0xa6
ffffffffc02046a6:	07e53503          	ld	a0,126(a0) # ffffffffc02aa720 <pages>
ffffffffc02046aa:	9536                	add	a0,a0,a3
ffffffffc02046ac:	4589                	li	a1,2
ffffffffc02046ae:	983fc0ef          	jal	ra,ffffffffc0201030 <free_pages>
    kfree(proc);
ffffffffc02046b2:	8522                	mv	a0,s0
ffffffffc02046b4:	b4ffe0ef          	jal	ra,ffffffffc0203202 <kfree>
    return 0;
ffffffffc02046b8:	4501                	li	a0,0
ffffffffc02046ba:	bde5                	j	ffffffffc02045b2 <do_wait.part.0+0x66>
        intr_enable();
ffffffffc02046bc:	af8fc0ef          	jal	ra,ffffffffc02009b4 <intr_enable>
ffffffffc02046c0:	bf55                	j	ffffffffc0204674 <do_wait.part.0+0x128>
        proc->parent->cptr = proc->optr;
ffffffffc02046c2:	701c                	ld	a5,32(s0)
ffffffffc02046c4:	fbf8                	sd	a4,240(a5)
ffffffffc02046c6:	bf79                	j	ffffffffc0204664 <do_wait.part.0+0x118>
        intr_disable();
ffffffffc02046c8:	af2fc0ef          	jal	ra,ffffffffc02009ba <intr_disable>
        return 1;
ffffffffc02046cc:	4585                	li	a1,1
ffffffffc02046ce:	bf95                	j	ffffffffc0204642 <do_wait.part.0+0xf6>
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc02046d0:	f2840413          	addi	s0,s0,-216
ffffffffc02046d4:	b781                	j	ffffffffc0204614 <do_wait.part.0+0xc8>
    return pa2page(PADDR(kva));
ffffffffc02046d6:	00002617          	auipc	a2,0x2
ffffffffc02046da:	b9260613          	addi	a2,a2,-1134 # ffffffffc0206268 <commands+0x930>
ffffffffc02046de:	07700593          	li	a1,119
ffffffffc02046e2:	00002517          	auipc	a0,0x2
ffffffffc02046e6:	a3e50513          	addi	a0,a0,-1474 # ffffffffc0206120 <commands+0x7e8>
ffffffffc02046ea:	b35fb0ef          	jal	ra,ffffffffc020021e <__panic>
        panic("wait idleproc or initproc.\n");
ffffffffc02046ee:	00003617          	auipc	a2,0x3
ffffffffc02046f2:	8ba60613          	addi	a2,a2,-1862 # ffffffffc0206fa8 <default_pmm_manager+0x118>
ffffffffc02046f6:	36c00593          	li	a1,876
ffffffffc02046fa:	00003517          	auipc	a0,0x3
ffffffffc02046fe:	82e50513          	addi	a0,a0,-2002 # ffffffffc0206f28 <default_pmm_manager+0x98>
ffffffffc0204702:	b1dfb0ef          	jal	ra,ffffffffc020021e <__panic>
        panic("pa2page called with invalid pa");
ffffffffc0204706:	00002617          	auipc	a2,0x2
ffffffffc020470a:	9fa60613          	addi	a2,a2,-1542 # ffffffffc0206100 <commands+0x7c8>
ffffffffc020470e:	06900593          	li	a1,105
ffffffffc0204712:	00002517          	auipc	a0,0x2
ffffffffc0204716:	a0e50513          	addi	a0,a0,-1522 # ffffffffc0206120 <commands+0x7e8>
ffffffffc020471a:	b05fb0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc020471e <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg)
{
ffffffffc020471e:	1141                	addi	sp,sp,-16
ffffffffc0204720:	e406                	sd	ra,8(sp)
    size_t nr_free_pages_store = nr_free_pages();
ffffffffc0204722:	94ffc0ef          	jal	ra,ffffffffc0201070 <nr_free_pages>
    size_t kernel_allocated_store = kallocated();
ffffffffc0204726:	a29fe0ef          	jal	ra,ffffffffc020314e <kallocated>

    int pid = kernel_thread(user_main, NULL, 0);
ffffffffc020472a:	4601                	li	a2,0
ffffffffc020472c:	4581                	li	a1,0
ffffffffc020472e:	fffff517          	auipc	a0,0xfffff
ffffffffc0204732:	77e50513          	addi	a0,a0,1918 # ffffffffc0203eac <user_main>
ffffffffc0204736:	c7dff0ef          	jal	ra,ffffffffc02043b2 <kernel_thread>
    if (pid <= 0)
ffffffffc020473a:	00a04563          	bgtz	a0,ffffffffc0204744 <init_main+0x26>
ffffffffc020473e:	a071                	j	ffffffffc02047ca <init_main+0xac>
        panic("create user_main failed.\n");
    }

    while (do_wait(0, NULL) == 0)
    {
        schedule();
ffffffffc0204740:	10f000ef          	jal	ra,ffffffffc020504e <schedule>
    if (code_store != NULL)
ffffffffc0204744:	4581                	li	a1,0
ffffffffc0204746:	4501                	li	a0,0
ffffffffc0204748:	e05ff0ef          	jal	ra,ffffffffc020454c <do_wait.part.0>
    while (do_wait(0, NULL) == 0)
ffffffffc020474c:	d975                	beqz	a0,ffffffffc0204740 <init_main+0x22>
    }

    cprintf("all user-mode processes have quit.\n");
ffffffffc020474e:	00003517          	auipc	a0,0x3
ffffffffc0204752:	89a50513          	addi	a0,a0,-1894 # ffffffffc0206fe8 <default_pmm_manager+0x158>
ffffffffc0204756:	98bfb0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc020475a:	000a6797          	auipc	a5,0xa6
ffffffffc020475e:	ff67b783          	ld	a5,-10(a5) # ffffffffc02aa750 <initproc>
ffffffffc0204762:	7bf8                	ld	a4,240(a5)
ffffffffc0204764:	e339                	bnez	a4,ffffffffc02047aa <init_main+0x8c>
ffffffffc0204766:	7ff8                	ld	a4,248(a5)
ffffffffc0204768:	e329                	bnez	a4,ffffffffc02047aa <init_main+0x8c>
ffffffffc020476a:	1007b703          	ld	a4,256(a5)
ffffffffc020476e:	ef15                	bnez	a4,ffffffffc02047aa <init_main+0x8c>
    assert(nr_process == 2);
ffffffffc0204770:	000a6697          	auipc	a3,0xa6
ffffffffc0204774:	fe86a683          	lw	a3,-24(a3) # ffffffffc02aa758 <nr_process>
ffffffffc0204778:	4709                	li	a4,2
ffffffffc020477a:	0ae69463          	bne	a3,a4,ffffffffc0204822 <init_main+0x104>
    return listelm->next;
ffffffffc020477e:	000a6697          	auipc	a3,0xa6
ffffffffc0204782:	f5268693          	addi	a3,a3,-174 # ffffffffc02aa6d0 <proc_list>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc0204786:	6698                	ld	a4,8(a3)
ffffffffc0204788:	0c878793          	addi	a5,a5,200
ffffffffc020478c:	06f71b63          	bne	a4,a5,ffffffffc0204802 <init_main+0xe4>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc0204790:	629c                	ld	a5,0(a3)
ffffffffc0204792:	04f71863          	bne	a4,a5,ffffffffc02047e2 <init_main+0xc4>

    cprintf("init check memory pass.\n");
ffffffffc0204796:	00003517          	auipc	a0,0x3
ffffffffc020479a:	93a50513          	addi	a0,a0,-1734 # ffffffffc02070d0 <default_pmm_manager+0x240>
ffffffffc020479e:	943fb0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    return 0;
}
ffffffffc02047a2:	60a2                	ld	ra,8(sp)
ffffffffc02047a4:	4501                	li	a0,0
ffffffffc02047a6:	0141                	addi	sp,sp,16
ffffffffc02047a8:	8082                	ret
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
ffffffffc02047aa:	00003697          	auipc	a3,0x3
ffffffffc02047ae:	86668693          	addi	a3,a3,-1946 # ffffffffc0207010 <default_pmm_manager+0x180>
ffffffffc02047b2:	00002617          	auipc	a2,0x2
ffffffffc02047b6:	a0e60613          	addi	a2,a2,-1522 # ffffffffc02061c0 <commands+0x888>
ffffffffc02047ba:	3da00593          	li	a1,986
ffffffffc02047be:	00002517          	auipc	a0,0x2
ffffffffc02047c2:	76a50513          	addi	a0,a0,1898 # ffffffffc0206f28 <default_pmm_manager+0x98>
ffffffffc02047c6:	a59fb0ef          	jal	ra,ffffffffc020021e <__panic>
        panic("create user_main failed.\n");
ffffffffc02047ca:	00002617          	auipc	a2,0x2
ffffffffc02047ce:	7fe60613          	addi	a2,a2,2046 # ffffffffc0206fc8 <default_pmm_manager+0x138>
ffffffffc02047d2:	3d100593          	li	a1,977
ffffffffc02047d6:	00002517          	auipc	a0,0x2
ffffffffc02047da:	75250513          	addi	a0,a0,1874 # ffffffffc0206f28 <default_pmm_manager+0x98>
ffffffffc02047de:	a41fb0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(list_prev(&proc_list) == &(initproc->list_link));
ffffffffc02047e2:	00003697          	auipc	a3,0x3
ffffffffc02047e6:	8be68693          	addi	a3,a3,-1858 # ffffffffc02070a0 <default_pmm_manager+0x210>
ffffffffc02047ea:	00002617          	auipc	a2,0x2
ffffffffc02047ee:	9d660613          	addi	a2,a2,-1578 # ffffffffc02061c0 <commands+0x888>
ffffffffc02047f2:	3dd00593          	li	a1,989
ffffffffc02047f6:	00002517          	auipc	a0,0x2
ffffffffc02047fa:	73250513          	addi	a0,a0,1842 # ffffffffc0206f28 <default_pmm_manager+0x98>
ffffffffc02047fe:	a21fb0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(list_next(&proc_list) == &(initproc->list_link));
ffffffffc0204802:	00003697          	auipc	a3,0x3
ffffffffc0204806:	86e68693          	addi	a3,a3,-1938 # ffffffffc0207070 <default_pmm_manager+0x1e0>
ffffffffc020480a:	00002617          	auipc	a2,0x2
ffffffffc020480e:	9b660613          	addi	a2,a2,-1610 # ffffffffc02061c0 <commands+0x888>
ffffffffc0204812:	3dc00593          	li	a1,988
ffffffffc0204816:	00002517          	auipc	a0,0x2
ffffffffc020481a:	71250513          	addi	a0,a0,1810 # ffffffffc0206f28 <default_pmm_manager+0x98>
ffffffffc020481e:	a01fb0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(nr_process == 2);
ffffffffc0204822:	00003697          	auipc	a3,0x3
ffffffffc0204826:	83e68693          	addi	a3,a3,-1986 # ffffffffc0207060 <default_pmm_manager+0x1d0>
ffffffffc020482a:	00002617          	auipc	a2,0x2
ffffffffc020482e:	99660613          	addi	a2,a2,-1642 # ffffffffc02061c0 <commands+0x888>
ffffffffc0204832:	3db00593          	li	a1,987
ffffffffc0204836:	00002517          	auipc	a0,0x2
ffffffffc020483a:	6f250513          	addi	a0,a0,1778 # ffffffffc0206f28 <default_pmm_manager+0x98>
ffffffffc020483e:	9e1fb0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc0204842 <do_execve>:
{
ffffffffc0204842:	7171                	addi	sp,sp,-176
ffffffffc0204844:	e4ee                	sd	s11,72(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0204846:	000a6d97          	auipc	s11,0xa6
ffffffffc020484a:	efad8d93          	addi	s11,s11,-262 # ffffffffc02aa740 <current>
ffffffffc020484e:	000db783          	ld	a5,0(s11)
{
ffffffffc0204852:	e54e                	sd	s3,136(sp)
ffffffffc0204854:	ed26                	sd	s1,152(sp)
    struct mm_struct *mm = current->mm;
ffffffffc0204856:	0287b983          	ld	s3,40(a5)
{
ffffffffc020485a:	e94a                	sd	s2,144(sp)
ffffffffc020485c:	f4de                	sd	s7,104(sp)
ffffffffc020485e:	892a                	mv	s2,a0
ffffffffc0204860:	8bb2                	mv	s7,a2
ffffffffc0204862:	84ae                	mv	s1,a1
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc0204864:	862e                	mv	a2,a1
ffffffffc0204866:	4681                	li	a3,0
ffffffffc0204868:	85aa                	mv	a1,a0
ffffffffc020486a:	854e                	mv	a0,s3
{
ffffffffc020486c:	f506                	sd	ra,168(sp)
ffffffffc020486e:	f122                	sd	s0,160(sp)
ffffffffc0204870:	e152                	sd	s4,128(sp)
ffffffffc0204872:	fcd6                	sd	s5,120(sp)
ffffffffc0204874:	f8da                	sd	s6,112(sp)
ffffffffc0204876:	f0e2                	sd	s8,96(sp)
ffffffffc0204878:	ece6                	sd	s9,88(sp)
ffffffffc020487a:	e8ea                	sd	s10,80(sp)
ffffffffc020487c:	f05e                	sd	s7,32(sp)
    if (!user_mem_check(mm, (uintptr_t)name, len, 0))
ffffffffc020487e:	e0efe0ef          	jal	ra,ffffffffc0202e8c <user_mem_check>
ffffffffc0204882:	40050863          	beqz	a0,ffffffffc0204c92 <do_execve+0x450>
    memset(local_name, 0, sizeof(local_name));
ffffffffc0204886:	4641                	li	a2,16
ffffffffc0204888:	4581                	li	a1,0
ffffffffc020488a:	1808                	addi	a0,sp,48
ffffffffc020488c:	1d1000ef          	jal	ra,ffffffffc020525c <memset>
    memcpy(local_name, name, len);
ffffffffc0204890:	47bd                	li	a5,15
ffffffffc0204892:	8626                	mv	a2,s1
ffffffffc0204894:	1e97e063          	bltu	a5,s1,ffffffffc0204a74 <do_execve+0x232>
ffffffffc0204898:	85ca                	mv	a1,s2
ffffffffc020489a:	1808                	addi	a0,sp,48
ffffffffc020489c:	1d3000ef          	jal	ra,ffffffffc020526e <memcpy>
    if (mm != NULL)
ffffffffc02048a0:	1e098163          	beqz	s3,ffffffffc0204a82 <do_execve+0x240>
        cputs("mm != NULL");
ffffffffc02048a4:	00002517          	auipc	a0,0x2
ffffffffc02048a8:	ffc50513          	addi	a0,a0,-4 # ffffffffc02068a0 <commands+0xf68>
ffffffffc02048ac:	86ffb0ef          	jal	ra,ffffffffc020011a <cputs>
ffffffffc02048b0:	000a6797          	auipc	a5,0xa6
ffffffffc02048b4:	e587b783          	ld	a5,-424(a5) # ffffffffc02aa708 <boot_pgdir_pa>
ffffffffc02048b8:	577d                	li	a4,-1
ffffffffc02048ba:	177e                	slli	a4,a4,0x3f
ffffffffc02048bc:	83b1                	srli	a5,a5,0xc
ffffffffc02048be:	8fd9                	or	a5,a5,a4
ffffffffc02048c0:	18079073          	csrw	satp,a5
ffffffffc02048c4:	0309a783          	lw	a5,48(s3) # 2030 <_binary_obj___user_faultread_out_size-0x7b80>
ffffffffc02048c8:	fff7871b          	addiw	a4,a5,-1
ffffffffc02048cc:	02e9a823          	sw	a4,48(s3)
        if (mm_count_dec(mm) == 0)
ffffffffc02048d0:	2c070263          	beqz	a4,ffffffffc0204b94 <do_execve+0x352>
        current->mm = NULL;
ffffffffc02048d4:	000db783          	ld	a5,0(s11)
ffffffffc02048d8:	0207b423          	sd	zero,40(a5)
    if ((mm = mm_create()) == NULL)
ffffffffc02048dc:	f3bfd0ef          	jal	ra,ffffffffc0202816 <mm_create>
ffffffffc02048e0:	84aa                	mv	s1,a0
ffffffffc02048e2:	1c050b63          	beqz	a0,ffffffffc0204ab8 <do_execve+0x276>
    if ((page = alloc_page()) == NULL)
ffffffffc02048e6:	4505                	li	a0,1
ffffffffc02048e8:	f0afc0ef          	jal	ra,ffffffffc0200ff2 <alloc_pages>
ffffffffc02048ec:	3a050763          	beqz	a0,ffffffffc0204c9a <do_execve+0x458>
    return page - pages + nbase;
ffffffffc02048f0:	000a6c97          	auipc	s9,0xa6
ffffffffc02048f4:	e30c8c93          	addi	s9,s9,-464 # ffffffffc02aa720 <pages>
ffffffffc02048f8:	000cb683          	ld	a3,0(s9)
    return KADDR(page2pa(page));
ffffffffc02048fc:	000a6c17          	auipc	s8,0xa6
ffffffffc0204900:	e1cc0c13          	addi	s8,s8,-484 # ffffffffc02aa718 <npage>
    return page - pages + nbase;
ffffffffc0204904:	00003717          	auipc	a4,0x3
ffffffffc0204908:	ebc73703          	ld	a4,-324(a4) # ffffffffc02077c0 <nbase>
ffffffffc020490c:	40d506b3          	sub	a3,a0,a3
ffffffffc0204910:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc0204912:	5afd                	li	s5,-1
ffffffffc0204914:	000c3783          	ld	a5,0(s8)
    return page - pages + nbase;
ffffffffc0204918:	96ba                	add	a3,a3,a4
ffffffffc020491a:	e83a                	sd	a4,16(sp)
    return KADDR(page2pa(page));
ffffffffc020491c:	00cad713          	srli	a4,s5,0xc
ffffffffc0204920:	ec3a                	sd	a4,24(sp)
ffffffffc0204922:	8f75                	and	a4,a4,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc0204924:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204926:	36f77e63          	bgeu	a4,a5,ffffffffc0204ca2 <do_execve+0x460>
ffffffffc020492a:	000a6b17          	auipc	s6,0xa6
ffffffffc020492e:	e06b0b13          	addi	s6,s6,-506 # ffffffffc02aa730 <va_pa_offset>
ffffffffc0204932:	000b3903          	ld	s2,0(s6)
    memcpy(pgdir, boot_pgdir_va, PGSIZE);
ffffffffc0204936:	6605                	lui	a2,0x1
ffffffffc0204938:	000a6597          	auipc	a1,0xa6
ffffffffc020493c:	dd85b583          	ld	a1,-552(a1) # ffffffffc02aa710 <boot_pgdir_va>
ffffffffc0204940:	9936                	add	s2,s2,a3
ffffffffc0204942:	854a                	mv	a0,s2
ffffffffc0204944:	12b000ef          	jal	ra,ffffffffc020526e <memcpy>
    if (elf->e_magic != ELF_MAGIC)
ffffffffc0204948:	7782                	ld	a5,32(sp)
ffffffffc020494a:	4398                	lw	a4,0(a5)
ffffffffc020494c:	464c47b7          	lui	a5,0x464c4
    mm->pgdir = pgdir;
ffffffffc0204950:	0124bc23          	sd	s2,24(s1)
    if (elf->e_magic != ELF_MAGIC)
ffffffffc0204954:	57f78793          	addi	a5,a5,1407 # 464c457f <_binary_obj___user_exit_out_size+0x464b945f>
ffffffffc0204958:	14f71663          	bne	a4,a5,ffffffffc0204aa4 <do_execve+0x262>
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc020495c:	7682                	ld	a3,32(sp)
ffffffffc020495e:	0386d703          	lhu	a4,56(a3)
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc0204962:	0206b983          	ld	s3,32(a3)
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc0204966:	00371793          	slli	a5,a4,0x3
ffffffffc020496a:	8f99                	sub	a5,a5,a4
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
ffffffffc020496c:	99b6                	add	s3,s3,a3
    struct proghdr *ph_end = ph + elf->e_phnum;
ffffffffc020496e:	078e                	slli	a5,a5,0x3
ffffffffc0204970:	97ce                	add	a5,a5,s3
ffffffffc0204972:	f43e                	sd	a5,40(sp)
    for (; ph < ph_end; ph++)
ffffffffc0204974:	00f9fc63          	bgeu	s3,a5,ffffffffc020498c <do_execve+0x14a>
        if (ph->p_type != ELF_PT_LOAD)
ffffffffc0204978:	0009a783          	lw	a5,0(s3)
ffffffffc020497c:	4705                	li	a4,1
ffffffffc020497e:	12e78f63          	beq	a5,a4,ffffffffc0204abc <do_execve+0x27a>
    for (; ph < ph_end; ph++)
ffffffffc0204982:	77a2                	ld	a5,40(sp)
ffffffffc0204984:	03898993          	addi	s3,s3,56
ffffffffc0204988:	fef9e8e3          	bltu	s3,a5,ffffffffc0204978 <do_execve+0x136>
    if ((ret = mm_map(mm, USTACKTOP - USTACKSIZE, USTACKSIZE, vm_flags, NULL)) != 0)
ffffffffc020498c:	4701                	li	a4,0
ffffffffc020498e:	46ad                	li	a3,11
ffffffffc0204990:	00100637          	lui	a2,0x100
ffffffffc0204994:	7ff005b7          	lui	a1,0x7ff00
ffffffffc0204998:	8526                	mv	a0,s1
ffffffffc020499a:	80efe0ef          	jal	ra,ffffffffc02029a8 <mm_map>
ffffffffc020499e:	8a2a                	mv	s4,a0
ffffffffc02049a0:	1e051063          	bnez	a0,ffffffffc0204b80 <do_execve+0x33e>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc02049a4:	6c88                	ld	a0,24(s1)
ffffffffc02049a6:	467d                	li	a2,31
ffffffffc02049a8:	7ffff5b7          	lui	a1,0x7ffff
ffffffffc02049ac:	d85fd0ef          	jal	ra,ffffffffc0202730 <pgdir_alloc_page>
ffffffffc02049b0:	38050163          	beqz	a0,ffffffffc0204d32 <do_execve+0x4f0>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc02049b4:	6c88                	ld	a0,24(s1)
ffffffffc02049b6:	467d                	li	a2,31
ffffffffc02049b8:	7fffe5b7          	lui	a1,0x7fffe
ffffffffc02049bc:	d75fd0ef          	jal	ra,ffffffffc0202730 <pgdir_alloc_page>
ffffffffc02049c0:	34050963          	beqz	a0,ffffffffc0204d12 <do_execve+0x4d0>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc02049c4:	6c88                	ld	a0,24(s1)
ffffffffc02049c6:	467d                	li	a2,31
ffffffffc02049c8:	7fffd5b7          	lui	a1,0x7fffd
ffffffffc02049cc:	d65fd0ef          	jal	ra,ffffffffc0202730 <pgdir_alloc_page>
ffffffffc02049d0:	32050163          	beqz	a0,ffffffffc0204cf2 <do_execve+0x4b0>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc02049d4:	6c88                	ld	a0,24(s1)
ffffffffc02049d6:	467d                	li	a2,31
ffffffffc02049d8:	7fffc5b7          	lui	a1,0x7fffc
ffffffffc02049dc:	d55fd0ef          	jal	ra,ffffffffc0202730 <pgdir_alloc_page>
ffffffffc02049e0:	2e050963          	beqz	a0,ffffffffc0204cd2 <do_execve+0x490>
    mm->mm_count += 1;
ffffffffc02049e4:	589c                	lw	a5,48(s1)
    current->mm = mm;
ffffffffc02049e6:	000db603          	ld	a2,0(s11)
    current->pgdir = PADDR(mm->pgdir);
ffffffffc02049ea:	6c94                	ld	a3,24(s1)
ffffffffc02049ec:	2785                	addiw	a5,a5,1
ffffffffc02049ee:	d89c                	sw	a5,48(s1)
    current->mm = mm;
ffffffffc02049f0:	f604                	sd	s1,40(a2)
    current->pgdir = PADDR(mm->pgdir);
ffffffffc02049f2:	c02007b7          	lui	a5,0xc0200
ffffffffc02049f6:	2cf6e263          	bltu	a3,a5,ffffffffc0204cba <do_execve+0x478>
ffffffffc02049fa:	000b3783          	ld	a5,0(s6)
ffffffffc02049fe:	577d                	li	a4,-1
ffffffffc0204a00:	177e                	slli	a4,a4,0x3f
ffffffffc0204a02:	8e9d                	sub	a3,a3,a5
ffffffffc0204a04:	00c6d793          	srli	a5,a3,0xc
ffffffffc0204a08:	f654                	sd	a3,168(a2)
ffffffffc0204a0a:	8fd9                	or	a5,a5,a4
ffffffffc0204a0c:	18079073          	csrw	satp,a5
    struct trapframe *tf = current->tf;
ffffffffc0204a10:	7240                	ld	s0,160(a2)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc0204a12:	4581                	li	a1,0
ffffffffc0204a14:	12000613          	li	a2,288
ffffffffc0204a18:	8522                	mv	a0,s0
    uintptr_t sstatus = tf->status;
ffffffffc0204a1a:	10043903          	ld	s2,256(s0)
    memset(tf, 0, sizeof(struct trapframe));
ffffffffc0204a1e:	03f000ef          	jal	ra,ffffffffc020525c <memset>
    tf->epc = elf->e_entry;
ffffffffc0204a22:	7782                	ld	a5,32(sp)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204a24:	000db483          	ld	s1,0(s11)
    tf->status = sstatus & ~(SSTATUS_SPP | SSTATUS_SPIE);
ffffffffc0204a28:	edf97913          	andi	s2,s2,-289
    tf->epc = elf->e_entry;
ffffffffc0204a2c:	6f98                	ld	a4,24(a5)
    tf->gpr.sp = USTACKTOP;
ffffffffc0204a2e:	4785                	li	a5,1
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204a30:	0b448493          	addi	s1,s1,180
    tf->gpr.sp = USTACKTOP;
ffffffffc0204a34:	07fe                	slli	a5,a5,0x1f
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204a36:	4641                	li	a2,16
ffffffffc0204a38:	4581                	li	a1,0
    tf->gpr.sp = USTACKTOP;
ffffffffc0204a3a:	e81c                	sd	a5,16(s0)
    tf->epc = elf->e_entry;
ffffffffc0204a3c:	10e43423          	sd	a4,264(s0)
    tf->status = sstatus & ~(SSTATUS_SPP | SSTATUS_SPIE);
ffffffffc0204a40:	11243023          	sd	s2,256(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204a44:	8526                	mv	a0,s1
ffffffffc0204a46:	017000ef          	jal	ra,ffffffffc020525c <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204a4a:	463d                	li	a2,15
ffffffffc0204a4c:	180c                	addi	a1,sp,48
ffffffffc0204a4e:	8526                	mv	a0,s1
ffffffffc0204a50:	01f000ef          	jal	ra,ffffffffc020526e <memcpy>
}
ffffffffc0204a54:	70aa                	ld	ra,168(sp)
ffffffffc0204a56:	740a                	ld	s0,160(sp)
ffffffffc0204a58:	64ea                	ld	s1,152(sp)
ffffffffc0204a5a:	694a                	ld	s2,144(sp)
ffffffffc0204a5c:	69aa                	ld	s3,136(sp)
ffffffffc0204a5e:	7ae6                	ld	s5,120(sp)
ffffffffc0204a60:	7b46                	ld	s6,112(sp)
ffffffffc0204a62:	7ba6                	ld	s7,104(sp)
ffffffffc0204a64:	7c06                	ld	s8,96(sp)
ffffffffc0204a66:	6ce6                	ld	s9,88(sp)
ffffffffc0204a68:	6d46                	ld	s10,80(sp)
ffffffffc0204a6a:	6da6                	ld	s11,72(sp)
ffffffffc0204a6c:	8552                	mv	a0,s4
ffffffffc0204a6e:	6a0a                	ld	s4,128(sp)
ffffffffc0204a70:	614d                	addi	sp,sp,176
ffffffffc0204a72:	8082                	ret
    memcpy(local_name, name, len);
ffffffffc0204a74:	463d                	li	a2,15
ffffffffc0204a76:	85ca                	mv	a1,s2
ffffffffc0204a78:	1808                	addi	a0,sp,48
ffffffffc0204a7a:	7f4000ef          	jal	ra,ffffffffc020526e <memcpy>
    if (mm != NULL)
ffffffffc0204a7e:	e20993e3          	bnez	s3,ffffffffc02048a4 <do_execve+0x62>
    if (current->mm != NULL)
ffffffffc0204a82:	000db783          	ld	a5,0(s11)
ffffffffc0204a86:	779c                	ld	a5,40(a5)
ffffffffc0204a88:	e4078ae3          	beqz	a5,ffffffffc02048dc <do_execve+0x9a>
        panic("load_icode: current->mm must be empty.\n");
ffffffffc0204a8c:	00002617          	auipc	a2,0x2
ffffffffc0204a90:	66460613          	addi	a2,a2,1636 # ffffffffc02070f0 <default_pmm_manager+0x260>
ffffffffc0204a94:	25700593          	li	a1,599
ffffffffc0204a98:	00002517          	auipc	a0,0x2
ffffffffc0204a9c:	49050513          	addi	a0,a0,1168 # ffffffffc0206f28 <default_pmm_manager+0x98>
ffffffffc0204aa0:	f7efb0ef          	jal	ra,ffffffffc020021e <__panic>
    put_pgdir(mm);
ffffffffc0204aa4:	8526                	mv	a0,s1
ffffffffc0204aa6:	c84ff0ef          	jal	ra,ffffffffc0203f2a <put_pgdir>
    mm_destroy(mm);
ffffffffc0204aaa:	8526                	mv	a0,s1
ffffffffc0204aac:	eabfd0ef          	jal	ra,ffffffffc0202956 <mm_destroy>
        ret = -E_INVAL_ELF;
ffffffffc0204ab0:	5a61                	li	s4,-8
    do_exit(ret);
ffffffffc0204ab2:	8552                	mv	a0,s4
ffffffffc0204ab4:	94fff0ef          	jal	ra,ffffffffc0204402 <do_exit>
    int ret = -E_NO_MEM;
ffffffffc0204ab8:	5a71                	li	s4,-4
ffffffffc0204aba:	bfe5                	j	ffffffffc0204ab2 <do_execve+0x270>
        if (ph->p_filesz > ph->p_memsz)
ffffffffc0204abc:	0289b603          	ld	a2,40(s3)
ffffffffc0204ac0:	0209b783          	ld	a5,32(s3)
ffffffffc0204ac4:	1cf66d63          	bltu	a2,a5,ffffffffc0204c9e <do_execve+0x45c>
        if (ph->p_flags & ELF_PF_X)
ffffffffc0204ac8:	0049a783          	lw	a5,4(s3)
ffffffffc0204acc:	0017f693          	andi	a3,a5,1
ffffffffc0204ad0:	c291                	beqz	a3,ffffffffc0204ad4 <do_execve+0x292>
            vm_flags |= VM_EXEC;
ffffffffc0204ad2:	4691                	li	a3,4
        if (ph->p_flags & ELF_PF_W)
ffffffffc0204ad4:	0027f713          	andi	a4,a5,2
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204ad8:	8b91                	andi	a5,a5,4
        if (ph->p_flags & ELF_PF_W)
ffffffffc0204ada:	e779                	bnez	a4,ffffffffc0204ba8 <do_execve+0x366>
        vm_flags = 0, perm = PTE_U | PTE_V;
ffffffffc0204adc:	4d45                	li	s10,17
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204ade:	c781                	beqz	a5,ffffffffc0204ae6 <do_execve+0x2a4>
            vm_flags |= VM_READ;
ffffffffc0204ae0:	0016e693          	ori	a3,a3,1
            perm |= PTE_R;
ffffffffc0204ae4:	4d4d                	li	s10,19
        if (vm_flags & VM_WRITE)
ffffffffc0204ae6:	0026f793          	andi	a5,a3,2
ffffffffc0204aea:	e3f1                	bnez	a5,ffffffffc0204bae <do_execve+0x36c>
        if (vm_flags & VM_EXEC)
ffffffffc0204aec:	0046f793          	andi	a5,a3,4
ffffffffc0204af0:	c399                	beqz	a5,ffffffffc0204af6 <do_execve+0x2b4>
            perm |= PTE_X;
ffffffffc0204af2:	008d6d13          	ori	s10,s10,8
        if ((ret = mm_map(mm, ph->p_va, ph->p_memsz, vm_flags, NULL)) != 0)
ffffffffc0204af6:	0109b583          	ld	a1,16(s3)
ffffffffc0204afa:	4701                	li	a4,0
ffffffffc0204afc:	8526                	mv	a0,s1
ffffffffc0204afe:	eabfd0ef          	jal	ra,ffffffffc02029a8 <mm_map>
ffffffffc0204b02:	8a2a                	mv	s4,a0
ffffffffc0204b04:	ed35                	bnez	a0,ffffffffc0204b80 <do_execve+0x33e>
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204b06:	0109bb83          	ld	s7,16(s3)
ffffffffc0204b0a:	77fd                	lui	a5,0xfffff
        end = ph->p_va + ph->p_filesz;
ffffffffc0204b0c:	0209ba03          	ld	s4,32(s3)
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204b10:	0089b903          	ld	s2,8(s3)
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
ffffffffc0204b14:	00fbfab3          	and	s5,s7,a5
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204b18:	7782                	ld	a5,32(sp)
        end = ph->p_va + ph->p_filesz;
ffffffffc0204b1a:	9a5e                	add	s4,s4,s7
        unsigned char *from = binary + ph->p_offset;
ffffffffc0204b1c:	993e                	add	s2,s2,a5
        while (start < end)
ffffffffc0204b1e:	054be963          	bltu	s7,s4,ffffffffc0204b70 <do_execve+0x32e>
ffffffffc0204b22:	aa95                	j	ffffffffc0204c96 <do_execve+0x454>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204b24:	6785                	lui	a5,0x1
ffffffffc0204b26:	415b8533          	sub	a0,s7,s5
ffffffffc0204b2a:	9abe                	add	s5,s5,a5
ffffffffc0204b2c:	417a8633          	sub	a2,s5,s7
            if (end < la)
ffffffffc0204b30:	015a7463          	bgeu	s4,s5,ffffffffc0204b38 <do_execve+0x2f6>
                size -= la - end;
ffffffffc0204b34:	417a0633          	sub	a2,s4,s7
    return page - pages + nbase;
ffffffffc0204b38:	000cb683          	ld	a3,0(s9)
ffffffffc0204b3c:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204b3e:	000c3583          	ld	a1,0(s8)
    return page - pages + nbase;
ffffffffc0204b42:	40d406b3          	sub	a3,s0,a3
ffffffffc0204b46:	8699                	srai	a3,a3,0x6
ffffffffc0204b48:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204b4a:	67e2                	ld	a5,24(sp)
ffffffffc0204b4c:	00f6f833          	and	a6,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204b50:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204b52:	14b87863          	bgeu	a6,a1,ffffffffc0204ca2 <do_execve+0x460>
ffffffffc0204b56:	000b3803          	ld	a6,0(s6)
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204b5a:	85ca                	mv	a1,s2
            start += size, from += size;
ffffffffc0204b5c:	9bb2                	add	s7,s7,a2
ffffffffc0204b5e:	96c2                	add	a3,a3,a6
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204b60:	9536                	add	a0,a0,a3
            start += size, from += size;
ffffffffc0204b62:	e432                	sd	a2,8(sp)
            memcpy(page2kva(page) + off, from, size);
ffffffffc0204b64:	70a000ef          	jal	ra,ffffffffc020526e <memcpy>
            start += size, from += size;
ffffffffc0204b68:	6622                	ld	a2,8(sp)
ffffffffc0204b6a:	9932                	add	s2,s2,a2
        while (start < end)
ffffffffc0204b6c:	054bf363          	bgeu	s7,s4,ffffffffc0204bb2 <do_execve+0x370>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc0204b70:	6c88                	ld	a0,24(s1)
ffffffffc0204b72:	866a                	mv	a2,s10
ffffffffc0204b74:	85d6                	mv	a1,s5
ffffffffc0204b76:	bbbfd0ef          	jal	ra,ffffffffc0202730 <pgdir_alloc_page>
ffffffffc0204b7a:	842a                	mv	s0,a0
ffffffffc0204b7c:	f545                	bnez	a0,ffffffffc0204b24 <do_execve+0x2e2>
        ret = -E_NO_MEM;
ffffffffc0204b7e:	5a71                	li	s4,-4
    exit_mmap(mm);
ffffffffc0204b80:	8526                	mv	a0,s1
ffffffffc0204b82:	f71fd0ef          	jal	ra,ffffffffc0202af2 <exit_mmap>
    put_pgdir(mm);
ffffffffc0204b86:	8526                	mv	a0,s1
ffffffffc0204b88:	ba2ff0ef          	jal	ra,ffffffffc0203f2a <put_pgdir>
    mm_destroy(mm);
ffffffffc0204b8c:	8526                	mv	a0,s1
ffffffffc0204b8e:	dc9fd0ef          	jal	ra,ffffffffc0202956 <mm_destroy>
    return ret;
ffffffffc0204b92:	b705                	j	ffffffffc0204ab2 <do_execve+0x270>
            exit_mmap(mm);
ffffffffc0204b94:	854e                	mv	a0,s3
ffffffffc0204b96:	f5dfd0ef          	jal	ra,ffffffffc0202af2 <exit_mmap>
            put_pgdir(mm);
ffffffffc0204b9a:	854e                	mv	a0,s3
ffffffffc0204b9c:	b8eff0ef          	jal	ra,ffffffffc0203f2a <put_pgdir>
            mm_destroy(mm);
ffffffffc0204ba0:	854e                	mv	a0,s3
ffffffffc0204ba2:	db5fd0ef          	jal	ra,ffffffffc0202956 <mm_destroy>
ffffffffc0204ba6:	b33d                	j	ffffffffc02048d4 <do_execve+0x92>
            vm_flags |= VM_WRITE;
ffffffffc0204ba8:	0026e693          	ori	a3,a3,2
        if (ph->p_flags & ELF_PF_R)
ffffffffc0204bac:	fb95                	bnez	a5,ffffffffc0204ae0 <do_execve+0x29e>
            perm |= (PTE_W | PTE_R);
ffffffffc0204bae:	4d5d                	li	s10,23
ffffffffc0204bb0:	bf35                	j	ffffffffc0204aec <do_execve+0x2aa>
        end = ph->p_va + ph->p_memsz;
ffffffffc0204bb2:	0109b683          	ld	a3,16(s3)
ffffffffc0204bb6:	0289b903          	ld	s2,40(s3)
ffffffffc0204bba:	9936                	add	s2,s2,a3
        if (start < la)
ffffffffc0204bbc:	075bfd63          	bgeu	s7,s5,ffffffffc0204c36 <do_execve+0x3f4>
            if (start == end)
ffffffffc0204bc0:	dd7901e3          	beq	s2,s7,ffffffffc0204982 <do_execve+0x140>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0204bc4:	6785                	lui	a5,0x1
ffffffffc0204bc6:	00fb8533          	add	a0,s7,a5
ffffffffc0204bca:	41550533          	sub	a0,a0,s5
                size -= la - end;
ffffffffc0204bce:	41790a33          	sub	s4,s2,s7
            if (end < la)
ffffffffc0204bd2:	0b597d63          	bgeu	s2,s5,ffffffffc0204c8c <do_execve+0x44a>
    return page - pages + nbase;
ffffffffc0204bd6:	000cb683          	ld	a3,0(s9)
ffffffffc0204bda:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204bdc:	000c3603          	ld	a2,0(s8)
    return page - pages + nbase;
ffffffffc0204be0:	40d406b3          	sub	a3,s0,a3
ffffffffc0204be4:	8699                	srai	a3,a3,0x6
ffffffffc0204be6:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204be8:	67e2                	ld	a5,24(sp)
ffffffffc0204bea:	00f6f5b3          	and	a1,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204bee:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204bf0:	0ac5f963          	bgeu	a1,a2,ffffffffc0204ca2 <do_execve+0x460>
ffffffffc0204bf4:	000b3803          	ld	a6,0(s6)
            memset(page2kva(page) + off, 0, size);
ffffffffc0204bf8:	8652                	mv	a2,s4
ffffffffc0204bfa:	4581                	li	a1,0
ffffffffc0204bfc:	96c2                	add	a3,a3,a6
ffffffffc0204bfe:	9536                	add	a0,a0,a3
ffffffffc0204c00:	65c000ef          	jal	ra,ffffffffc020525c <memset>
            start += size;
ffffffffc0204c04:	017a0733          	add	a4,s4,s7
            assert((end < la && start == end) || (end >= la && start == la));
ffffffffc0204c08:	03597463          	bgeu	s2,s5,ffffffffc0204c30 <do_execve+0x3ee>
ffffffffc0204c0c:	d6e90be3          	beq	s2,a4,ffffffffc0204982 <do_execve+0x140>
ffffffffc0204c10:	00002697          	auipc	a3,0x2
ffffffffc0204c14:	50868693          	addi	a3,a3,1288 # ffffffffc0207118 <default_pmm_manager+0x288>
ffffffffc0204c18:	00001617          	auipc	a2,0x1
ffffffffc0204c1c:	5a860613          	addi	a2,a2,1448 # ffffffffc02061c0 <commands+0x888>
ffffffffc0204c20:	2c000593          	li	a1,704
ffffffffc0204c24:	00002517          	auipc	a0,0x2
ffffffffc0204c28:	30450513          	addi	a0,a0,772 # ffffffffc0206f28 <default_pmm_manager+0x98>
ffffffffc0204c2c:	df2fb0ef          	jal	ra,ffffffffc020021e <__panic>
ffffffffc0204c30:	ff5710e3          	bne	a4,s5,ffffffffc0204c10 <do_execve+0x3ce>
ffffffffc0204c34:	8bd6                	mv	s7,s5
        while (start < end)
ffffffffc0204c36:	d52bf6e3          	bgeu	s7,s2,ffffffffc0204982 <do_execve+0x140>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL)
ffffffffc0204c3a:	6c88                	ld	a0,24(s1)
ffffffffc0204c3c:	866a                	mv	a2,s10
ffffffffc0204c3e:	85d6                	mv	a1,s5
ffffffffc0204c40:	af1fd0ef          	jal	ra,ffffffffc0202730 <pgdir_alloc_page>
ffffffffc0204c44:	842a                	mv	s0,a0
ffffffffc0204c46:	dd05                	beqz	a0,ffffffffc0204b7e <do_execve+0x33c>
            off = start - la, size = PGSIZE - off, la += PGSIZE;
ffffffffc0204c48:	6785                	lui	a5,0x1
ffffffffc0204c4a:	415b8533          	sub	a0,s7,s5
ffffffffc0204c4e:	9abe                	add	s5,s5,a5
ffffffffc0204c50:	417a8633          	sub	a2,s5,s7
            if (end < la)
ffffffffc0204c54:	01597463          	bgeu	s2,s5,ffffffffc0204c5c <do_execve+0x41a>
                size -= la - end;
ffffffffc0204c58:	41790633          	sub	a2,s2,s7
    return page - pages + nbase;
ffffffffc0204c5c:	000cb683          	ld	a3,0(s9)
ffffffffc0204c60:	67c2                	ld	a5,16(sp)
    return KADDR(page2pa(page));
ffffffffc0204c62:	000c3583          	ld	a1,0(s8)
    return page - pages + nbase;
ffffffffc0204c66:	40d406b3          	sub	a3,s0,a3
ffffffffc0204c6a:	8699                	srai	a3,a3,0x6
ffffffffc0204c6c:	96be                	add	a3,a3,a5
    return KADDR(page2pa(page));
ffffffffc0204c6e:	67e2                	ld	a5,24(sp)
ffffffffc0204c70:	00f6f833          	and	a6,a3,a5
    return page2ppn(page) << PGSHIFT;
ffffffffc0204c74:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0204c76:	02b87663          	bgeu	a6,a1,ffffffffc0204ca2 <do_execve+0x460>
ffffffffc0204c7a:	000b3803          	ld	a6,0(s6)
            memset(page2kva(page) + off, 0, size);
ffffffffc0204c7e:	4581                	li	a1,0
            start += size;
ffffffffc0204c80:	9bb2                	add	s7,s7,a2
ffffffffc0204c82:	96c2                	add	a3,a3,a6
            memset(page2kva(page) + off, 0, size);
ffffffffc0204c84:	9536                	add	a0,a0,a3
ffffffffc0204c86:	5d6000ef          	jal	ra,ffffffffc020525c <memset>
ffffffffc0204c8a:	b775                	j	ffffffffc0204c36 <do_execve+0x3f4>
            off = start + PGSIZE - la, size = PGSIZE - off;
ffffffffc0204c8c:	417a8a33          	sub	s4,s5,s7
ffffffffc0204c90:	b799                	j	ffffffffc0204bd6 <do_execve+0x394>
        return -E_INVAL;
ffffffffc0204c92:	5a75                	li	s4,-3
ffffffffc0204c94:	b3c1                	j	ffffffffc0204a54 <do_execve+0x212>
        while (start < end)
ffffffffc0204c96:	86de                	mv	a3,s7
ffffffffc0204c98:	bf39                	j	ffffffffc0204bb6 <do_execve+0x374>
    int ret = -E_NO_MEM;
ffffffffc0204c9a:	5a71                	li	s4,-4
ffffffffc0204c9c:	bdc5                	j	ffffffffc0204b8c <do_execve+0x34a>
            ret = -E_INVAL_ELF;
ffffffffc0204c9e:	5a61                	li	s4,-8
ffffffffc0204ca0:	b5c5                	j	ffffffffc0204b80 <do_execve+0x33e>
ffffffffc0204ca2:	00001617          	auipc	a2,0x1
ffffffffc0204ca6:	4b660613          	addi	a2,a2,1206 # ffffffffc0206158 <commands+0x820>
ffffffffc0204caa:	07100593          	li	a1,113
ffffffffc0204cae:	00001517          	auipc	a0,0x1
ffffffffc0204cb2:	47250513          	addi	a0,a0,1138 # ffffffffc0206120 <commands+0x7e8>
ffffffffc0204cb6:	d68fb0ef          	jal	ra,ffffffffc020021e <__panic>
    current->pgdir = PADDR(mm->pgdir);
ffffffffc0204cba:	00001617          	auipc	a2,0x1
ffffffffc0204cbe:	5ae60613          	addi	a2,a2,1454 # ffffffffc0206268 <commands+0x930>
ffffffffc0204cc2:	2df00593          	li	a1,735
ffffffffc0204cc6:	00002517          	auipc	a0,0x2
ffffffffc0204cca:	26250513          	addi	a0,a0,610 # ffffffffc0206f28 <default_pmm_manager+0x98>
ffffffffc0204cce:	d50fb0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204cd2:	00002697          	auipc	a3,0x2
ffffffffc0204cd6:	55e68693          	addi	a3,a3,1374 # ffffffffc0207230 <default_pmm_manager+0x3a0>
ffffffffc0204cda:	00001617          	auipc	a2,0x1
ffffffffc0204cde:	4e660613          	addi	a2,a2,1254 # ffffffffc02061c0 <commands+0x888>
ffffffffc0204ce2:	2da00593          	li	a1,730
ffffffffc0204ce6:	00002517          	auipc	a0,0x2
ffffffffc0204cea:	24250513          	addi	a0,a0,578 # ffffffffc0206f28 <default_pmm_manager+0x98>
ffffffffc0204cee:	d30fb0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204cf2:	00002697          	auipc	a3,0x2
ffffffffc0204cf6:	4f668693          	addi	a3,a3,1270 # ffffffffc02071e8 <default_pmm_manager+0x358>
ffffffffc0204cfa:	00001617          	auipc	a2,0x1
ffffffffc0204cfe:	4c660613          	addi	a2,a2,1222 # ffffffffc02061c0 <commands+0x888>
ffffffffc0204d02:	2d900593          	li	a1,729
ffffffffc0204d06:	00002517          	auipc	a0,0x2
ffffffffc0204d0a:	22250513          	addi	a0,a0,546 # ffffffffc0206f28 <default_pmm_manager+0x98>
ffffffffc0204d0e:	d10fb0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
ffffffffc0204d12:	00002697          	auipc	a3,0x2
ffffffffc0204d16:	48e68693          	addi	a3,a3,1166 # ffffffffc02071a0 <default_pmm_manager+0x310>
ffffffffc0204d1a:	00001617          	auipc	a2,0x1
ffffffffc0204d1e:	4a660613          	addi	a2,a2,1190 # ffffffffc02061c0 <commands+0x888>
ffffffffc0204d22:	2d800593          	li	a1,728
ffffffffc0204d26:	00002517          	auipc	a0,0x2
ffffffffc0204d2a:	20250513          	addi	a0,a0,514 # ffffffffc0206f28 <default_pmm_manager+0x98>
ffffffffc0204d2e:	cf0fb0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
ffffffffc0204d32:	00002697          	auipc	a3,0x2
ffffffffc0204d36:	42668693          	addi	a3,a3,1062 # ffffffffc0207158 <default_pmm_manager+0x2c8>
ffffffffc0204d3a:	00001617          	auipc	a2,0x1
ffffffffc0204d3e:	48660613          	addi	a2,a2,1158 # ffffffffc02061c0 <commands+0x888>
ffffffffc0204d42:	2d700593          	li	a1,727
ffffffffc0204d46:	00002517          	auipc	a0,0x2
ffffffffc0204d4a:	1e250513          	addi	a0,a0,482 # ffffffffc0206f28 <default_pmm_manager+0x98>
ffffffffc0204d4e:	cd0fb0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc0204d52 <do_yield>:
    current->need_resched = 1;
ffffffffc0204d52:	000a6797          	auipc	a5,0xa6
ffffffffc0204d56:	9ee7b783          	ld	a5,-1554(a5) # ffffffffc02aa740 <current>
ffffffffc0204d5a:	4705                	li	a4,1
ffffffffc0204d5c:	ef98                	sd	a4,24(a5)
}
ffffffffc0204d5e:	4501                	li	a0,0
ffffffffc0204d60:	8082                	ret

ffffffffc0204d62 <do_wait>:
{
ffffffffc0204d62:	1101                	addi	sp,sp,-32
ffffffffc0204d64:	e822                	sd	s0,16(sp)
ffffffffc0204d66:	e426                	sd	s1,8(sp)
ffffffffc0204d68:	ec06                	sd	ra,24(sp)
ffffffffc0204d6a:	842e                	mv	s0,a1
ffffffffc0204d6c:	84aa                	mv	s1,a0
    if (code_store != NULL)
ffffffffc0204d6e:	c999                	beqz	a1,ffffffffc0204d84 <do_wait+0x22>
    struct mm_struct *mm = current->mm;
ffffffffc0204d70:	000a6797          	auipc	a5,0xa6
ffffffffc0204d74:	9d07b783          	ld	a5,-1584(a5) # ffffffffc02aa740 <current>
        if (!user_mem_check(mm, (uintptr_t)code_store, sizeof(int), 1))
ffffffffc0204d78:	7788                	ld	a0,40(a5)
ffffffffc0204d7a:	4685                	li	a3,1
ffffffffc0204d7c:	4611                	li	a2,4
ffffffffc0204d7e:	90efe0ef          	jal	ra,ffffffffc0202e8c <user_mem_check>
ffffffffc0204d82:	c909                	beqz	a0,ffffffffc0204d94 <do_wait+0x32>
ffffffffc0204d84:	85a2                	mv	a1,s0
}
ffffffffc0204d86:	6442                	ld	s0,16(sp)
ffffffffc0204d88:	60e2                	ld	ra,24(sp)
ffffffffc0204d8a:	8526                	mv	a0,s1
ffffffffc0204d8c:	64a2                	ld	s1,8(sp)
ffffffffc0204d8e:	6105                	addi	sp,sp,32
ffffffffc0204d90:	fbcff06f          	j	ffffffffc020454c <do_wait.part.0>
ffffffffc0204d94:	60e2                	ld	ra,24(sp)
ffffffffc0204d96:	6442                	ld	s0,16(sp)
ffffffffc0204d98:	64a2                	ld	s1,8(sp)
ffffffffc0204d9a:	5575                	li	a0,-3
ffffffffc0204d9c:	6105                	addi	sp,sp,32
ffffffffc0204d9e:	8082                	ret

ffffffffc0204da0 <do_kill>:
{
ffffffffc0204da0:	1141                	addi	sp,sp,-16
    if (0 < pid && pid < MAX_PID)
ffffffffc0204da2:	6789                	lui	a5,0x2
{
ffffffffc0204da4:	e406                	sd	ra,8(sp)
ffffffffc0204da6:	e022                	sd	s0,0(sp)
    if (0 < pid && pid < MAX_PID)
ffffffffc0204da8:	fff5071b          	addiw	a4,a0,-1
ffffffffc0204dac:	17f9                	addi	a5,a5,-2
ffffffffc0204dae:	02e7e963          	bltu	a5,a4,ffffffffc0204de0 <do_kill+0x40>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204db2:	842a                	mv	s0,a0
ffffffffc0204db4:	45a9                	li	a1,10
ffffffffc0204db6:	2501                	sext.w	a0,a0
ffffffffc0204db8:	0bd000ef          	jal	ra,ffffffffc0205674 <hash32>
ffffffffc0204dbc:	02051793          	slli	a5,a0,0x20
ffffffffc0204dc0:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0204dc4:	000a2797          	auipc	a5,0xa2
ffffffffc0204dc8:	90c78793          	addi	a5,a5,-1780 # ffffffffc02a66d0 <hash_list>
ffffffffc0204dcc:	953e                	add	a0,a0,a5
ffffffffc0204dce:	87aa                	mv	a5,a0
        while ((le = list_next(le)) != list)
ffffffffc0204dd0:	a029                	j	ffffffffc0204dda <do_kill+0x3a>
            if (proc->pid == pid)
ffffffffc0204dd2:	f2c7a703          	lw	a4,-212(a5)
ffffffffc0204dd6:	00870b63          	beq	a4,s0,ffffffffc0204dec <do_kill+0x4c>
ffffffffc0204dda:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0204ddc:	fef51be3          	bne	a0,a5,ffffffffc0204dd2 <do_kill+0x32>
    return -E_INVAL;
ffffffffc0204de0:	5475                	li	s0,-3
}
ffffffffc0204de2:	60a2                	ld	ra,8(sp)
ffffffffc0204de4:	8522                	mv	a0,s0
ffffffffc0204de6:	6402                	ld	s0,0(sp)
ffffffffc0204de8:	0141                	addi	sp,sp,16
ffffffffc0204dea:	8082                	ret
        if (!(proc->flags & PF_EXITING))
ffffffffc0204dec:	fd87a703          	lw	a4,-40(a5)
ffffffffc0204df0:	00177693          	andi	a3,a4,1
ffffffffc0204df4:	e295                	bnez	a3,ffffffffc0204e18 <do_kill+0x78>
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc0204df6:	4bd4                	lw	a3,20(a5)
            proc->flags |= PF_EXITING;
ffffffffc0204df8:	00176713          	ori	a4,a4,1
ffffffffc0204dfc:	fce7ac23          	sw	a4,-40(a5)
            return 0;
ffffffffc0204e00:	4401                	li	s0,0
            if (proc->wait_state & WT_INTERRUPTED)
ffffffffc0204e02:	fe06d0e3          	bgez	a3,ffffffffc0204de2 <do_kill+0x42>
                wakeup_proc(proc);
ffffffffc0204e06:	f2878513          	addi	a0,a5,-216
ffffffffc0204e0a:	1c4000ef          	jal	ra,ffffffffc0204fce <wakeup_proc>
}
ffffffffc0204e0e:	60a2                	ld	ra,8(sp)
ffffffffc0204e10:	8522                	mv	a0,s0
ffffffffc0204e12:	6402                	ld	s0,0(sp)
ffffffffc0204e14:	0141                	addi	sp,sp,16
ffffffffc0204e16:	8082                	ret
        return -E_KILLED;
ffffffffc0204e18:	545d                	li	s0,-9
ffffffffc0204e1a:	b7e1                	j	ffffffffc0204de2 <do_kill+0x42>

ffffffffc0204e1c <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and
//           - create the second kernel thread init_main
void proc_init(void)
{
ffffffffc0204e1c:	1101                	addi	sp,sp,-32
ffffffffc0204e1e:	e426                	sd	s1,8(sp)
    elm->prev = elm->next = elm;
ffffffffc0204e20:	000a6797          	auipc	a5,0xa6
ffffffffc0204e24:	8b078793          	addi	a5,a5,-1872 # ffffffffc02aa6d0 <proc_list>
ffffffffc0204e28:	ec06                	sd	ra,24(sp)
ffffffffc0204e2a:	e822                	sd	s0,16(sp)
ffffffffc0204e2c:	e04a                	sd	s2,0(sp)
ffffffffc0204e2e:	000a2497          	auipc	s1,0xa2
ffffffffc0204e32:	8a248493          	addi	s1,s1,-1886 # ffffffffc02a66d0 <hash_list>
ffffffffc0204e36:	e79c                	sd	a5,8(a5)
ffffffffc0204e38:	e39c                	sd	a5,0(a5)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i++)
ffffffffc0204e3a:	000a6717          	auipc	a4,0xa6
ffffffffc0204e3e:	89670713          	addi	a4,a4,-1898 # ffffffffc02aa6d0 <proc_list>
ffffffffc0204e42:	87a6                	mv	a5,s1
ffffffffc0204e44:	e79c                	sd	a5,8(a5)
ffffffffc0204e46:	e39c                	sd	a5,0(a5)
ffffffffc0204e48:	07c1                	addi	a5,a5,16
ffffffffc0204e4a:	fef71de3          	bne	a4,a5,ffffffffc0204e44 <proc_init+0x28>
    {
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL)
ffffffffc0204e4e:	fcffe0ef          	jal	ra,ffffffffc0203e1c <alloc_proc>
ffffffffc0204e52:	000a6917          	auipc	s2,0xa6
ffffffffc0204e56:	8f690913          	addi	s2,s2,-1802 # ffffffffc02aa748 <idleproc>
ffffffffc0204e5a:	00a93023          	sd	a0,0(s2)
ffffffffc0204e5e:	0e050f63          	beqz	a0,ffffffffc0204f5c <proc_init+0x140>
    {
        panic("cannot alloc idleproc.\n");
    }

    idleproc->pid = 0;
    idleproc->state = PROC_RUNNABLE;
ffffffffc0204e62:	4789                	li	a5,2
ffffffffc0204e64:	e11c                	sd	a5,0(a0)
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0204e66:	00003797          	auipc	a5,0x3
ffffffffc0204e6a:	19a78793          	addi	a5,a5,410 # ffffffffc0208000 <bootstack>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204e6e:	0b450413          	addi	s0,a0,180
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0204e72:	e91c                	sd	a5,16(a0)
    idleproc->need_resched = 1;
ffffffffc0204e74:	4785                	li	a5,1
ffffffffc0204e76:	ed1c                	sd	a5,24(a0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204e78:	4641                	li	a2,16
ffffffffc0204e7a:	4581                	li	a1,0
ffffffffc0204e7c:	8522                	mv	a0,s0
ffffffffc0204e7e:	3de000ef          	jal	ra,ffffffffc020525c <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204e82:	463d                	li	a2,15
ffffffffc0204e84:	00002597          	auipc	a1,0x2
ffffffffc0204e88:	40c58593          	addi	a1,a1,1036 # ffffffffc0207290 <default_pmm_manager+0x400>
ffffffffc0204e8c:	8522                	mv	a0,s0
ffffffffc0204e8e:	3e0000ef          	jal	ra,ffffffffc020526e <memcpy>
    set_proc_name(idleproc, "idle");
    nr_process++;
ffffffffc0204e92:	000a6717          	auipc	a4,0xa6
ffffffffc0204e96:	8c670713          	addi	a4,a4,-1850 # ffffffffc02aa758 <nr_process>
ffffffffc0204e9a:	431c                	lw	a5,0(a4)

    current = idleproc;
ffffffffc0204e9c:	00093683          	ld	a3,0(s2)

    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0204ea0:	4601                	li	a2,0
    nr_process++;
ffffffffc0204ea2:	2785                	addiw	a5,a5,1
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0204ea4:	4581                	li	a1,0
ffffffffc0204ea6:	00000517          	auipc	a0,0x0
ffffffffc0204eaa:	87850513          	addi	a0,a0,-1928 # ffffffffc020471e <init_main>
    nr_process++;
ffffffffc0204eae:	c31c                	sw	a5,0(a4)
    current = idleproc;
ffffffffc0204eb0:	000a6797          	auipc	a5,0xa6
ffffffffc0204eb4:	88d7b823          	sd	a3,-1904(a5) # ffffffffc02aa740 <current>
    int pid = kernel_thread(init_main, NULL, 0);
ffffffffc0204eb8:	cfaff0ef          	jal	ra,ffffffffc02043b2 <kernel_thread>
ffffffffc0204ebc:	842a                	mv	s0,a0
    if (pid <= 0)
ffffffffc0204ebe:	08a05363          	blez	a0,ffffffffc0204f44 <proc_init+0x128>
    if (0 < pid && pid < MAX_PID)
ffffffffc0204ec2:	6789                	lui	a5,0x2
ffffffffc0204ec4:	fff5071b          	addiw	a4,a0,-1
ffffffffc0204ec8:	17f9                	addi	a5,a5,-2
ffffffffc0204eca:	2501                	sext.w	a0,a0
ffffffffc0204ecc:	02e7e363          	bltu	a5,a4,ffffffffc0204ef2 <proc_init+0xd6>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0204ed0:	45a9                	li	a1,10
ffffffffc0204ed2:	7a2000ef          	jal	ra,ffffffffc0205674 <hash32>
ffffffffc0204ed6:	02051793          	slli	a5,a0,0x20
ffffffffc0204eda:	01c7d693          	srli	a3,a5,0x1c
ffffffffc0204ede:	96a6                	add	a3,a3,s1
ffffffffc0204ee0:	87b6                	mv	a5,a3
        while ((le = list_next(le)) != list)
ffffffffc0204ee2:	a029                	j	ffffffffc0204eec <proc_init+0xd0>
            if (proc->pid == pid)
ffffffffc0204ee4:	f2c7a703          	lw	a4,-212(a5) # 1f2c <_binary_obj___user_faultread_out_size-0x7c84>
ffffffffc0204ee8:	04870b63          	beq	a4,s0,ffffffffc0204f3e <proc_init+0x122>
    return listelm->next;
ffffffffc0204eec:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc0204eee:	fef69be3          	bne	a3,a5,ffffffffc0204ee4 <proc_init+0xc8>
    return NULL;
ffffffffc0204ef2:	4781                	li	a5,0
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204ef4:	0b478493          	addi	s1,a5,180
ffffffffc0204ef8:	4641                	li	a2,16
ffffffffc0204efa:	4581                	li	a1,0
    {
        panic("create init_main failed.\n");
    }

    initproc = find_proc(pid);
ffffffffc0204efc:	000a6417          	auipc	s0,0xa6
ffffffffc0204f00:	85440413          	addi	s0,s0,-1964 # ffffffffc02aa750 <initproc>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204f04:	8526                	mv	a0,s1
    initproc = find_proc(pid);
ffffffffc0204f06:	e01c                	sd	a5,0(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0204f08:	354000ef          	jal	ra,ffffffffc020525c <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc0204f0c:	463d                	li	a2,15
ffffffffc0204f0e:	00002597          	auipc	a1,0x2
ffffffffc0204f12:	3aa58593          	addi	a1,a1,938 # ffffffffc02072b8 <default_pmm_manager+0x428>
ffffffffc0204f16:	8526                	mv	a0,s1
ffffffffc0204f18:	356000ef          	jal	ra,ffffffffc020526e <memcpy>
    set_proc_name(initproc, "init");

    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc0204f1c:	00093783          	ld	a5,0(s2)
ffffffffc0204f20:	cbb5                	beqz	a5,ffffffffc0204f94 <proc_init+0x178>
ffffffffc0204f22:	43dc                	lw	a5,4(a5)
ffffffffc0204f24:	eba5                	bnez	a5,ffffffffc0204f94 <proc_init+0x178>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0204f26:	601c                	ld	a5,0(s0)
ffffffffc0204f28:	c7b1                	beqz	a5,ffffffffc0204f74 <proc_init+0x158>
ffffffffc0204f2a:	43d8                	lw	a4,4(a5)
ffffffffc0204f2c:	4785                	li	a5,1
ffffffffc0204f2e:	04f71363          	bne	a4,a5,ffffffffc0204f74 <proc_init+0x158>
}
ffffffffc0204f32:	60e2                	ld	ra,24(sp)
ffffffffc0204f34:	6442                	ld	s0,16(sp)
ffffffffc0204f36:	64a2                	ld	s1,8(sp)
ffffffffc0204f38:	6902                	ld	s2,0(sp)
ffffffffc0204f3a:	6105                	addi	sp,sp,32
ffffffffc0204f3c:	8082                	ret
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc0204f3e:	f2878793          	addi	a5,a5,-216
ffffffffc0204f42:	bf4d                	j	ffffffffc0204ef4 <proc_init+0xd8>
        panic("create init_main failed.\n");
ffffffffc0204f44:	00002617          	auipc	a2,0x2
ffffffffc0204f48:	35460613          	addi	a2,a2,852 # ffffffffc0207298 <default_pmm_manager+0x408>
ffffffffc0204f4c:	40000593          	li	a1,1024
ffffffffc0204f50:	00002517          	auipc	a0,0x2
ffffffffc0204f54:	fd850513          	addi	a0,a0,-40 # ffffffffc0206f28 <default_pmm_manager+0x98>
ffffffffc0204f58:	ac6fb0ef          	jal	ra,ffffffffc020021e <__panic>
        panic("cannot alloc idleproc.\n");
ffffffffc0204f5c:	00002617          	auipc	a2,0x2
ffffffffc0204f60:	31c60613          	addi	a2,a2,796 # ffffffffc0207278 <default_pmm_manager+0x3e8>
ffffffffc0204f64:	3f100593          	li	a1,1009
ffffffffc0204f68:	00002517          	auipc	a0,0x2
ffffffffc0204f6c:	fc050513          	addi	a0,a0,-64 # ffffffffc0206f28 <default_pmm_manager+0x98>
ffffffffc0204f70:	aaefb0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc0204f74:	00002697          	auipc	a3,0x2
ffffffffc0204f78:	37468693          	addi	a3,a3,884 # ffffffffc02072e8 <default_pmm_manager+0x458>
ffffffffc0204f7c:	00001617          	auipc	a2,0x1
ffffffffc0204f80:	24460613          	addi	a2,a2,580 # ffffffffc02061c0 <commands+0x888>
ffffffffc0204f84:	40700593          	li	a1,1031
ffffffffc0204f88:	00002517          	auipc	a0,0x2
ffffffffc0204f8c:	fa050513          	addi	a0,a0,-96 # ffffffffc0206f28 <default_pmm_manager+0x98>
ffffffffc0204f90:	a8efb0ef          	jal	ra,ffffffffc020021e <__panic>
    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc0204f94:	00002697          	auipc	a3,0x2
ffffffffc0204f98:	32c68693          	addi	a3,a3,812 # ffffffffc02072c0 <default_pmm_manager+0x430>
ffffffffc0204f9c:	00001617          	auipc	a2,0x1
ffffffffc0204fa0:	22460613          	addi	a2,a2,548 # ffffffffc02061c0 <commands+0x888>
ffffffffc0204fa4:	40600593          	li	a1,1030
ffffffffc0204fa8:	00002517          	auipc	a0,0x2
ffffffffc0204fac:	f8050513          	addi	a0,a0,-128 # ffffffffc0206f28 <default_pmm_manager+0x98>
ffffffffc0204fb0:	a6efb0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc0204fb4 <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void cpu_idle(void)
{
ffffffffc0204fb4:	1141                	addi	sp,sp,-16
ffffffffc0204fb6:	e022                	sd	s0,0(sp)
ffffffffc0204fb8:	e406                	sd	ra,8(sp)
ffffffffc0204fba:	000a5417          	auipc	s0,0xa5
ffffffffc0204fbe:	78640413          	addi	s0,s0,1926 # ffffffffc02aa740 <current>
    while (1)
    {
        if (current->need_resched)
ffffffffc0204fc2:	6018                	ld	a4,0(s0)
ffffffffc0204fc4:	6f1c                	ld	a5,24(a4)
ffffffffc0204fc6:	dffd                	beqz	a5,ffffffffc0204fc4 <cpu_idle+0x10>
        {
            schedule();
ffffffffc0204fc8:	086000ef          	jal	ra,ffffffffc020504e <schedule>
ffffffffc0204fcc:	bfdd                	j	ffffffffc0204fc2 <cpu_idle+0xe>

ffffffffc0204fce <wakeup_proc>:
#include <sched.h>
#include <assert.h>

void wakeup_proc(struct proc_struct *proc)
{
    assert(proc->state != PROC_ZOMBIE);
ffffffffc0204fce:	4118                	lw	a4,0(a0)
{
ffffffffc0204fd0:	1101                	addi	sp,sp,-32
ffffffffc0204fd2:	ec06                	sd	ra,24(sp)
ffffffffc0204fd4:	e822                	sd	s0,16(sp)
ffffffffc0204fd6:	e426                	sd	s1,8(sp)
    assert(proc->state != PROC_ZOMBIE);
ffffffffc0204fd8:	478d                	li	a5,3
ffffffffc0204fda:	04f70b63          	beq	a4,a5,ffffffffc0205030 <wakeup_proc+0x62>
ffffffffc0204fde:	842a                	mv	s0,a0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204fe0:	100027f3          	csrr	a5,sstatus
ffffffffc0204fe4:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0204fe6:	4481                	li	s1,0
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0204fe8:	ef9d                	bnez	a5,ffffffffc0205026 <wakeup_proc+0x58>
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        if (proc->state != PROC_RUNNABLE)
ffffffffc0204fea:	4789                	li	a5,2
ffffffffc0204fec:	02f70163          	beq	a4,a5,ffffffffc020500e <wakeup_proc+0x40>
        {
            proc->state = PROC_RUNNABLE;
ffffffffc0204ff0:	c01c                	sw	a5,0(s0)
            proc->wait_state = 0;
ffffffffc0204ff2:	0e042623          	sw	zero,236(s0)
    if (flag)
ffffffffc0204ff6:	e491                	bnez	s1,ffffffffc0205002 <wakeup_proc+0x34>
        {
            warn("wakeup runnable process.\n");
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc0204ff8:	60e2                	ld	ra,24(sp)
ffffffffc0204ffa:	6442                	ld	s0,16(sp)
ffffffffc0204ffc:	64a2                	ld	s1,8(sp)
ffffffffc0204ffe:	6105                	addi	sp,sp,32
ffffffffc0205000:	8082                	ret
ffffffffc0205002:	6442                	ld	s0,16(sp)
ffffffffc0205004:	60e2                	ld	ra,24(sp)
ffffffffc0205006:	64a2                	ld	s1,8(sp)
ffffffffc0205008:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc020500a:	9abfb06f          	j	ffffffffc02009b4 <intr_enable>
            warn("wakeup runnable process.\n");
ffffffffc020500e:	00002617          	auipc	a2,0x2
ffffffffc0205012:	33a60613          	addi	a2,a2,826 # ffffffffc0207348 <default_pmm_manager+0x4b8>
ffffffffc0205016:	45d1                	li	a1,20
ffffffffc0205018:	00002517          	auipc	a0,0x2
ffffffffc020501c:	31850513          	addi	a0,a0,792 # ffffffffc0207330 <default_pmm_manager+0x4a0>
ffffffffc0205020:	a66fb0ef          	jal	ra,ffffffffc0200286 <__warn>
ffffffffc0205024:	bfc9                	j	ffffffffc0204ff6 <wakeup_proc+0x28>
        intr_disable();
ffffffffc0205026:	995fb0ef          	jal	ra,ffffffffc02009ba <intr_disable>
        if (proc->state != PROC_RUNNABLE)
ffffffffc020502a:	4018                	lw	a4,0(s0)
        return 1;
ffffffffc020502c:	4485                	li	s1,1
ffffffffc020502e:	bf75                	j	ffffffffc0204fea <wakeup_proc+0x1c>
    assert(proc->state != PROC_ZOMBIE);
ffffffffc0205030:	00002697          	auipc	a3,0x2
ffffffffc0205034:	2e068693          	addi	a3,a3,736 # ffffffffc0207310 <default_pmm_manager+0x480>
ffffffffc0205038:	00001617          	auipc	a2,0x1
ffffffffc020503c:	18860613          	addi	a2,a2,392 # ffffffffc02061c0 <commands+0x888>
ffffffffc0205040:	45a5                	li	a1,9
ffffffffc0205042:	00002517          	auipc	a0,0x2
ffffffffc0205046:	2ee50513          	addi	a0,a0,750 # ffffffffc0207330 <default_pmm_manager+0x4a0>
ffffffffc020504a:	9d4fb0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc020504e <schedule>:

void schedule(void)
{
ffffffffc020504e:	1141                	addi	sp,sp,-16
ffffffffc0205050:	e406                	sd	ra,8(sp)
ffffffffc0205052:	e022                	sd	s0,0(sp)
    if (read_csr(sstatus) & SSTATUS_SIE)
ffffffffc0205054:	100027f3          	csrr	a5,sstatus
ffffffffc0205058:	8b89                	andi	a5,a5,2
ffffffffc020505a:	4401                	li	s0,0
ffffffffc020505c:	efbd                	bnez	a5,ffffffffc02050da <schedule+0x8c>
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
    local_intr_save(intr_flag);
    {
        current->need_resched = 0;
ffffffffc020505e:	000a5897          	auipc	a7,0xa5
ffffffffc0205062:	6e28b883          	ld	a7,1762(a7) # ffffffffc02aa740 <current>
ffffffffc0205066:	0008bc23          	sd	zero,24(a7)
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc020506a:	000a5517          	auipc	a0,0xa5
ffffffffc020506e:	6de53503          	ld	a0,1758(a0) # ffffffffc02aa748 <idleproc>
ffffffffc0205072:	04a88e63          	beq	a7,a0,ffffffffc02050ce <schedule+0x80>
ffffffffc0205076:	0c888693          	addi	a3,a7,200
ffffffffc020507a:	000a5617          	auipc	a2,0xa5
ffffffffc020507e:	65660613          	addi	a2,a2,1622 # ffffffffc02aa6d0 <proc_list>
        le = last;
ffffffffc0205082:	87b6                	mv	a5,a3
    struct proc_struct *next = NULL;
ffffffffc0205084:	4581                	li	a1,0
        do
        {
            if ((le = list_next(le)) != &proc_list)
            {
                next = le2proc(le, list_link);
                if (next->state == PROC_RUNNABLE)
ffffffffc0205086:	4809                	li	a6,2
ffffffffc0205088:	679c                	ld	a5,8(a5)
            if ((le = list_next(le)) != &proc_list)
ffffffffc020508a:	00c78863          	beq	a5,a2,ffffffffc020509a <schedule+0x4c>
                if (next->state == PROC_RUNNABLE)
ffffffffc020508e:	f387a703          	lw	a4,-200(a5)
                next = le2proc(le, list_link);
ffffffffc0205092:	f3878593          	addi	a1,a5,-200
                if (next->state == PROC_RUNNABLE)
ffffffffc0205096:	03070163          	beq	a4,a6,ffffffffc02050b8 <schedule+0x6a>
                {
                    break;
                }
            }
        } while (le != last);
ffffffffc020509a:	fef697e3          	bne	a3,a5,ffffffffc0205088 <schedule+0x3a>
        if (next == NULL || next->state != PROC_RUNNABLE)
ffffffffc020509e:	ed89                	bnez	a1,ffffffffc02050b8 <schedule+0x6a>
        {
            next = idleproc;
        }
        next->runs++;
ffffffffc02050a0:	451c                	lw	a5,8(a0)
ffffffffc02050a2:	2785                	addiw	a5,a5,1
ffffffffc02050a4:	c51c                	sw	a5,8(a0)
        if (next != current)
ffffffffc02050a6:	00a88463          	beq	a7,a0,ffffffffc02050ae <schedule+0x60>
        {
            proc_run(next);
ffffffffc02050aa:	ef7fe0ef          	jal	ra,ffffffffc0203fa0 <proc_run>
    if (flag)
ffffffffc02050ae:	e819                	bnez	s0,ffffffffc02050c4 <schedule+0x76>
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc02050b0:	60a2                	ld	ra,8(sp)
ffffffffc02050b2:	6402                	ld	s0,0(sp)
ffffffffc02050b4:	0141                	addi	sp,sp,16
ffffffffc02050b6:	8082                	ret
        if (next == NULL || next->state != PROC_RUNNABLE)
ffffffffc02050b8:	4198                	lw	a4,0(a1)
ffffffffc02050ba:	4789                	li	a5,2
ffffffffc02050bc:	fef712e3          	bne	a4,a5,ffffffffc02050a0 <schedule+0x52>
ffffffffc02050c0:	852e                	mv	a0,a1
ffffffffc02050c2:	bff9                	j	ffffffffc02050a0 <schedule+0x52>
}
ffffffffc02050c4:	6402                	ld	s0,0(sp)
ffffffffc02050c6:	60a2                	ld	ra,8(sp)
ffffffffc02050c8:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc02050ca:	8ebfb06f          	j	ffffffffc02009b4 <intr_enable>
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc02050ce:	000a5617          	auipc	a2,0xa5
ffffffffc02050d2:	60260613          	addi	a2,a2,1538 # ffffffffc02aa6d0 <proc_list>
ffffffffc02050d6:	86b2                	mv	a3,a2
ffffffffc02050d8:	b76d                	j	ffffffffc0205082 <schedule+0x34>
        intr_disable();
ffffffffc02050da:	8e1fb0ef          	jal	ra,ffffffffc02009ba <intr_disable>
        return 1;
ffffffffc02050de:	4405                	li	s0,1
ffffffffc02050e0:	bfbd                	j	ffffffffc020505e <schedule+0x10>

ffffffffc02050e2 <sys_getpid>:
    return do_kill(pid);
}

static int
sys_getpid(uint64_t arg[]) {
    return current->pid;
ffffffffc02050e2:	000a5797          	auipc	a5,0xa5
ffffffffc02050e6:	65e7b783          	ld	a5,1630(a5) # ffffffffc02aa740 <current>
}
ffffffffc02050ea:	43c8                	lw	a0,4(a5)
ffffffffc02050ec:	8082                	ret

ffffffffc02050ee <sys_pgdir>:

static int
sys_pgdir(uint64_t arg[]) {
    //print_pgdir();
    return 0;
}
ffffffffc02050ee:	4501                	li	a0,0
ffffffffc02050f0:	8082                	ret

ffffffffc02050f2 <sys_putc>:
    cputchar(c);
ffffffffc02050f2:	4108                	lw	a0,0(a0)
sys_putc(uint64_t arg[]) {
ffffffffc02050f4:	1141                	addi	sp,sp,-16
ffffffffc02050f6:	e406                	sd	ra,8(sp)
    cputchar(c);
ffffffffc02050f8:	81efb0ef          	jal	ra,ffffffffc0200116 <cputchar>
}
ffffffffc02050fc:	60a2                	ld	ra,8(sp)
ffffffffc02050fe:	4501                	li	a0,0
ffffffffc0205100:	0141                	addi	sp,sp,16
ffffffffc0205102:	8082                	ret

ffffffffc0205104 <sys_kill>:
    return do_kill(pid);
ffffffffc0205104:	4108                	lw	a0,0(a0)
ffffffffc0205106:	c9bff06f          	j	ffffffffc0204da0 <do_kill>

ffffffffc020510a <sys_yield>:
    return do_yield();
ffffffffc020510a:	c49ff06f          	j	ffffffffc0204d52 <do_yield>

ffffffffc020510e <sys_exec>:
    return do_execve(name, len, binary, size);
ffffffffc020510e:	6d14                	ld	a3,24(a0)
ffffffffc0205110:	6910                	ld	a2,16(a0)
ffffffffc0205112:	650c                	ld	a1,8(a0)
ffffffffc0205114:	6108                	ld	a0,0(a0)
ffffffffc0205116:	f2cff06f          	j	ffffffffc0204842 <do_execve>

ffffffffc020511a <sys_wait>:
    return do_wait(pid, store);
ffffffffc020511a:	650c                	ld	a1,8(a0)
ffffffffc020511c:	4108                	lw	a0,0(a0)
ffffffffc020511e:	c45ff06f          	j	ffffffffc0204d62 <do_wait>

ffffffffc0205122 <sys_fork>:
    struct trapframe *tf = current->tf;
ffffffffc0205122:	000a5797          	auipc	a5,0xa5
ffffffffc0205126:	61e7b783          	ld	a5,1566(a5) # ffffffffc02aa740 <current>
ffffffffc020512a:	73d0                	ld	a2,160(a5)
    return do_fork(0, stack, tf);
ffffffffc020512c:	4501                	li	a0,0
ffffffffc020512e:	6a0c                	ld	a1,16(a2)
ffffffffc0205130:	eddfe06f          	j	ffffffffc020400c <do_fork>

ffffffffc0205134 <sys_exit>:
    return do_exit(error_code);
ffffffffc0205134:	4108                	lw	a0,0(a0)
ffffffffc0205136:	accff06f          	j	ffffffffc0204402 <do_exit>

ffffffffc020513a <syscall>:
};

#define NUM_SYSCALLS        ((sizeof(syscalls)) / (sizeof(syscalls[0])))

void
syscall(void) {
ffffffffc020513a:	715d                	addi	sp,sp,-80
ffffffffc020513c:	fc26                	sd	s1,56(sp)
    struct trapframe *tf = current->tf;
ffffffffc020513e:	000a5497          	auipc	s1,0xa5
ffffffffc0205142:	60248493          	addi	s1,s1,1538 # ffffffffc02aa740 <current>
ffffffffc0205146:	6098                	ld	a4,0(s1)
syscall(void) {
ffffffffc0205148:	e0a2                	sd	s0,64(sp)
ffffffffc020514a:	f84a                	sd	s2,48(sp)
    struct trapframe *tf = current->tf;
ffffffffc020514c:	7340                	ld	s0,160(a4)
syscall(void) {
ffffffffc020514e:	e486                	sd	ra,72(sp)
    uint64_t arg[5];
    int num = tf->gpr.a0;
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc0205150:	47fd                	li	a5,31
    int num = tf->gpr.a0;
ffffffffc0205152:	05042903          	lw	s2,80(s0)
    if (num >= 0 && num < NUM_SYSCALLS) {
ffffffffc0205156:	0327ee63          	bltu	a5,s2,ffffffffc0205192 <syscall+0x58>
        if (syscalls[num] != NULL) {
ffffffffc020515a:	00391713          	slli	a4,s2,0x3
ffffffffc020515e:	00002797          	auipc	a5,0x2
ffffffffc0205162:	25278793          	addi	a5,a5,594 # ffffffffc02073b0 <syscalls>
ffffffffc0205166:	97ba                	add	a5,a5,a4
ffffffffc0205168:	639c                	ld	a5,0(a5)
ffffffffc020516a:	c785                	beqz	a5,ffffffffc0205192 <syscall+0x58>
            arg[0] = tf->gpr.a1;
ffffffffc020516c:	6c28                	ld	a0,88(s0)
            arg[1] = tf->gpr.a2;
ffffffffc020516e:	702c                	ld	a1,96(s0)
            arg[2] = tf->gpr.a3;
ffffffffc0205170:	7430                	ld	a2,104(s0)
            arg[3] = tf->gpr.a4;
ffffffffc0205172:	7834                	ld	a3,112(s0)
            arg[4] = tf->gpr.a5;
ffffffffc0205174:	7c38                	ld	a4,120(s0)
            arg[0] = tf->gpr.a1;
ffffffffc0205176:	e42a                	sd	a0,8(sp)
            arg[1] = tf->gpr.a2;
ffffffffc0205178:	e82e                	sd	a1,16(sp)
            arg[2] = tf->gpr.a3;
ffffffffc020517a:	ec32                	sd	a2,24(sp)
            arg[3] = tf->gpr.a4;
ffffffffc020517c:	f036                	sd	a3,32(sp)
            arg[4] = tf->gpr.a5;
ffffffffc020517e:	f43a                	sd	a4,40(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc0205180:	0028                	addi	a0,sp,8
ffffffffc0205182:	9782                	jalr	a5
        }
    }
    print_trapframe(tf);
    panic("undefined syscall %d, pid = %d, name = %s.\n",
            num, current->pid, current->name);
}
ffffffffc0205184:	60a6                	ld	ra,72(sp)
            tf->gpr.a0 = syscalls[num](arg);
ffffffffc0205186:	e828                	sd	a0,80(s0)
}
ffffffffc0205188:	6406                	ld	s0,64(sp)
ffffffffc020518a:	74e2                	ld	s1,56(sp)
ffffffffc020518c:	7942                	ld	s2,48(sp)
ffffffffc020518e:	6161                	addi	sp,sp,80
ffffffffc0205190:	8082                	ret
    print_trapframe(tf);
ffffffffc0205192:	8522                	mv	a0,s0
ffffffffc0205194:	a15fb0ef          	jal	ra,ffffffffc0200ba8 <print_trapframe>
    panic("undefined syscall %d, pid = %d, name = %s.\n",
ffffffffc0205198:	609c                	ld	a5,0(s1)
ffffffffc020519a:	86ca                	mv	a3,s2
ffffffffc020519c:	00002617          	auipc	a2,0x2
ffffffffc02051a0:	1cc60613          	addi	a2,a2,460 # ffffffffc0207368 <default_pmm_manager+0x4d8>
ffffffffc02051a4:	43d8                	lw	a4,4(a5)
ffffffffc02051a6:	06200593          	li	a1,98
ffffffffc02051aa:	0b478793          	addi	a5,a5,180
ffffffffc02051ae:	00002517          	auipc	a0,0x2
ffffffffc02051b2:	1ea50513          	addi	a0,a0,490 # ffffffffc0207398 <default_pmm_manager+0x508>
ffffffffc02051b6:	868fb0ef          	jal	ra,ffffffffc020021e <__panic>

ffffffffc02051ba <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc02051ba:	00054783          	lbu	a5,0(a0)
strlen(const char *s) {
ffffffffc02051be:	872a                	mv	a4,a0
    size_t cnt = 0;
ffffffffc02051c0:	4501                	li	a0,0
    while (*s ++ != '\0') {
ffffffffc02051c2:	cb81                	beqz	a5,ffffffffc02051d2 <strlen+0x18>
        cnt ++;
ffffffffc02051c4:	0505                	addi	a0,a0,1
    while (*s ++ != '\0') {
ffffffffc02051c6:	00a707b3          	add	a5,a4,a0
ffffffffc02051ca:	0007c783          	lbu	a5,0(a5)
ffffffffc02051ce:	fbfd                	bnez	a5,ffffffffc02051c4 <strlen+0xa>
ffffffffc02051d0:	8082                	ret
    }
    return cnt;
}
ffffffffc02051d2:	8082                	ret

ffffffffc02051d4 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc02051d4:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc02051d6:	e589                	bnez	a1,ffffffffc02051e0 <strnlen+0xc>
ffffffffc02051d8:	a811                	j	ffffffffc02051ec <strnlen+0x18>
        cnt ++;
ffffffffc02051da:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc02051dc:	00f58863          	beq	a1,a5,ffffffffc02051ec <strnlen+0x18>
ffffffffc02051e0:	00f50733          	add	a4,a0,a5
ffffffffc02051e4:	00074703          	lbu	a4,0(a4)
ffffffffc02051e8:	fb6d                	bnez	a4,ffffffffc02051da <strnlen+0x6>
ffffffffc02051ea:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc02051ec:	852e                	mv	a0,a1
ffffffffc02051ee:	8082                	ret

ffffffffc02051f0 <strcpy>:
char *
strcpy(char *dst, const char *src) {
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
#else
    char *p = dst;
ffffffffc02051f0:	87aa                	mv	a5,a0
    while ((*p ++ = *src ++) != '\0')
ffffffffc02051f2:	0005c703          	lbu	a4,0(a1)
ffffffffc02051f6:	0785                	addi	a5,a5,1
ffffffffc02051f8:	0585                	addi	a1,a1,1
ffffffffc02051fa:	fee78fa3          	sb	a4,-1(a5)
ffffffffc02051fe:	fb75                	bnez	a4,ffffffffc02051f2 <strcpy+0x2>
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
ffffffffc0205200:	8082                	ret

ffffffffc0205202 <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0205202:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0205206:	0005c703          	lbu	a4,0(a1)
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc020520a:	cb89                	beqz	a5,ffffffffc020521c <strcmp+0x1a>
        s1 ++, s2 ++;
ffffffffc020520c:	0505                	addi	a0,a0,1
ffffffffc020520e:	0585                	addi	a1,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0205210:	fee789e3          	beq	a5,a4,ffffffffc0205202 <strcmp>
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0205214:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc0205218:	9d19                	subw	a0,a0,a4
ffffffffc020521a:	8082                	ret
ffffffffc020521c:	4501                	li	a0,0
ffffffffc020521e:	bfed                	j	ffffffffc0205218 <strcmp+0x16>

ffffffffc0205220 <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0205220:	c20d                	beqz	a2,ffffffffc0205242 <strncmp+0x22>
ffffffffc0205222:	962e                	add	a2,a2,a1
ffffffffc0205224:	a031                	j	ffffffffc0205230 <strncmp+0x10>
        n --, s1 ++, s2 ++;
ffffffffc0205226:	0505                	addi	a0,a0,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0205228:	00e79a63          	bne	a5,a4,ffffffffc020523c <strncmp+0x1c>
ffffffffc020522c:	00b60b63          	beq	a2,a1,ffffffffc0205242 <strncmp+0x22>
ffffffffc0205230:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc0205234:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0205236:	fff5c703          	lbu	a4,-1(a1)
ffffffffc020523a:	f7f5                	bnez	a5,ffffffffc0205226 <strncmp+0x6>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc020523c:	40e7853b          	subw	a0,a5,a4
}
ffffffffc0205240:	8082                	ret
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0205242:	4501                	li	a0,0
ffffffffc0205244:	8082                	ret

ffffffffc0205246 <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc0205246:	00054783          	lbu	a5,0(a0)
ffffffffc020524a:	c799                	beqz	a5,ffffffffc0205258 <strchr+0x12>
        if (*s == c) {
ffffffffc020524c:	00f58763          	beq	a1,a5,ffffffffc020525a <strchr+0x14>
    while (*s != '\0') {
ffffffffc0205250:	00154783          	lbu	a5,1(a0)
            return (char *)s;
        }
        s ++;
ffffffffc0205254:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc0205256:	fbfd                	bnez	a5,ffffffffc020524c <strchr+0x6>
    }
    return NULL;
ffffffffc0205258:	4501                	li	a0,0
}
ffffffffc020525a:	8082                	ret

ffffffffc020525c <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc020525c:	ca01                	beqz	a2,ffffffffc020526c <memset+0x10>
ffffffffc020525e:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc0205260:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc0205262:	0785                	addi	a5,a5,1
ffffffffc0205264:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc0205268:	fec79de3          	bne	a5,a2,ffffffffc0205262 <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc020526c:	8082                	ret

ffffffffc020526e <memcpy>:
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
ffffffffc020526e:	ca19                	beqz	a2,ffffffffc0205284 <memcpy+0x16>
ffffffffc0205270:	962e                	add	a2,a2,a1
    char *d = dst;
ffffffffc0205272:	87aa                	mv	a5,a0
        *d ++ = *s ++;
ffffffffc0205274:	0005c703          	lbu	a4,0(a1)
ffffffffc0205278:	0585                	addi	a1,a1,1
ffffffffc020527a:	0785                	addi	a5,a5,1
ffffffffc020527c:	fee78fa3          	sb	a4,-1(a5)
    while (n -- > 0) {
ffffffffc0205280:	fec59ae3          	bne	a1,a2,ffffffffc0205274 <memcpy+0x6>
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
ffffffffc0205284:	8082                	ret

ffffffffc0205286 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc0205286:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc020528a:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc020528c:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0205290:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc0205292:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0205296:	f022                	sd	s0,32(sp)
ffffffffc0205298:	ec26                	sd	s1,24(sp)
ffffffffc020529a:	e84a                	sd	s2,16(sp)
ffffffffc020529c:	f406                	sd	ra,40(sp)
ffffffffc020529e:	e44e                	sd	s3,8(sp)
ffffffffc02052a0:	84aa                	mv	s1,a0
ffffffffc02052a2:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc02052a4:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc02052a8:	2a01                	sext.w	s4,s4
    if (num >= base) {
ffffffffc02052aa:	03067e63          	bgeu	a2,a6,ffffffffc02052e6 <printnum+0x60>
ffffffffc02052ae:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc02052b0:	00805763          	blez	s0,ffffffffc02052be <printnum+0x38>
ffffffffc02052b4:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc02052b6:	85ca                	mv	a1,s2
ffffffffc02052b8:	854e                	mv	a0,s3
ffffffffc02052ba:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc02052bc:	fc65                	bnez	s0,ffffffffc02052b4 <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02052be:	1a02                	slli	s4,s4,0x20
ffffffffc02052c0:	00002797          	auipc	a5,0x2
ffffffffc02052c4:	1f078793          	addi	a5,a5,496 # ffffffffc02074b0 <syscalls+0x100>
ffffffffc02052c8:	020a5a13          	srli	s4,s4,0x20
ffffffffc02052cc:	9a3e                	add	s4,s4,a5
    // Crashes if num >= base. No idea what going on here
    // Here is a quick fix
    // update: Stack grows downward and destory the SBI
    // sbi_console_putchar("0123456789abcdef"[mod]);
    // (*(int *)putdat)++;
}
ffffffffc02052ce:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02052d0:	000a4503          	lbu	a0,0(s4)
}
ffffffffc02052d4:	70a2                	ld	ra,40(sp)
ffffffffc02052d6:	69a2                	ld	s3,8(sp)
ffffffffc02052d8:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02052da:	85ca                	mv	a1,s2
ffffffffc02052dc:	87a6                	mv	a5,s1
}
ffffffffc02052de:	6942                	ld	s2,16(sp)
ffffffffc02052e0:	64e2                	ld	s1,24(sp)
ffffffffc02052e2:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc02052e4:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc02052e6:	03065633          	divu	a2,a2,a6
ffffffffc02052ea:	8722                	mv	a4,s0
ffffffffc02052ec:	f9bff0ef          	jal	ra,ffffffffc0205286 <printnum>
ffffffffc02052f0:	b7f9                	j	ffffffffc02052be <printnum+0x38>

ffffffffc02052f2 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc02052f2:	7119                	addi	sp,sp,-128
ffffffffc02052f4:	f4a6                	sd	s1,104(sp)
ffffffffc02052f6:	f0ca                	sd	s2,96(sp)
ffffffffc02052f8:	ecce                	sd	s3,88(sp)
ffffffffc02052fa:	e8d2                	sd	s4,80(sp)
ffffffffc02052fc:	e4d6                	sd	s5,72(sp)
ffffffffc02052fe:	e0da                	sd	s6,64(sp)
ffffffffc0205300:	fc5e                	sd	s7,56(sp)
ffffffffc0205302:	f06a                	sd	s10,32(sp)
ffffffffc0205304:	fc86                	sd	ra,120(sp)
ffffffffc0205306:	f8a2                	sd	s0,112(sp)
ffffffffc0205308:	f862                	sd	s8,48(sp)
ffffffffc020530a:	f466                	sd	s9,40(sp)
ffffffffc020530c:	ec6e                	sd	s11,24(sp)
ffffffffc020530e:	892a                	mv	s2,a0
ffffffffc0205310:	84ae                	mv	s1,a1
ffffffffc0205312:	8d32                	mv	s10,a2
ffffffffc0205314:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0205316:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
ffffffffc020531a:	5b7d                	li	s6,-1
ffffffffc020531c:	00002a97          	auipc	s5,0x2
ffffffffc0205320:	1c0a8a93          	addi	s5,s5,448 # ffffffffc02074dc <syscalls+0x12c>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0205324:	00002b97          	auipc	s7,0x2
ffffffffc0205328:	3d4b8b93          	addi	s7,s7,980 # ffffffffc02076f8 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc020532c:	000d4503          	lbu	a0,0(s10)
ffffffffc0205330:	001d0413          	addi	s0,s10,1
ffffffffc0205334:	01350a63          	beq	a0,s3,ffffffffc0205348 <vprintfmt+0x56>
            if (ch == '\0') {
ffffffffc0205338:	c121                	beqz	a0,ffffffffc0205378 <vprintfmt+0x86>
            putch(ch, putdat);
ffffffffc020533a:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc020533c:	0405                	addi	s0,s0,1
            putch(ch, putdat);
ffffffffc020533e:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0205340:	fff44503          	lbu	a0,-1(s0)
ffffffffc0205344:	ff351ae3          	bne	a0,s3,ffffffffc0205338 <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205348:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
ffffffffc020534c:	02000793          	li	a5,32
        lflag = altflag = 0;
ffffffffc0205350:	4c81                	li	s9,0
ffffffffc0205352:	4881                	li	a7,0
        width = precision = -1;
ffffffffc0205354:	5c7d                	li	s8,-1
ffffffffc0205356:	5dfd                	li	s11,-1
ffffffffc0205358:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
ffffffffc020535c:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020535e:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0205362:	0ff5f593          	zext.b	a1,a1
ffffffffc0205366:	00140d13          	addi	s10,s0,1
ffffffffc020536a:	04b56263          	bltu	a0,a1,ffffffffc02053ae <vprintfmt+0xbc>
ffffffffc020536e:	058a                	slli	a1,a1,0x2
ffffffffc0205370:	95d6                	add	a1,a1,s5
ffffffffc0205372:	4194                	lw	a3,0(a1)
ffffffffc0205374:	96d6                	add	a3,a3,s5
ffffffffc0205376:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc0205378:	70e6                	ld	ra,120(sp)
ffffffffc020537a:	7446                	ld	s0,112(sp)
ffffffffc020537c:	74a6                	ld	s1,104(sp)
ffffffffc020537e:	7906                	ld	s2,96(sp)
ffffffffc0205380:	69e6                	ld	s3,88(sp)
ffffffffc0205382:	6a46                	ld	s4,80(sp)
ffffffffc0205384:	6aa6                	ld	s5,72(sp)
ffffffffc0205386:	6b06                	ld	s6,64(sp)
ffffffffc0205388:	7be2                	ld	s7,56(sp)
ffffffffc020538a:	7c42                	ld	s8,48(sp)
ffffffffc020538c:	7ca2                	ld	s9,40(sp)
ffffffffc020538e:	7d02                	ld	s10,32(sp)
ffffffffc0205390:	6de2                	ld	s11,24(sp)
ffffffffc0205392:	6109                	addi	sp,sp,128
ffffffffc0205394:	8082                	ret
            padc = '0';
ffffffffc0205396:	87b2                	mv	a5,a2
            goto reswitch;
ffffffffc0205398:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020539c:	846a                	mv	s0,s10
ffffffffc020539e:	00140d13          	addi	s10,s0,1
ffffffffc02053a2:	fdd6059b          	addiw	a1,a2,-35
ffffffffc02053a6:	0ff5f593          	zext.b	a1,a1
ffffffffc02053aa:	fcb572e3          	bgeu	a0,a1,ffffffffc020536e <vprintfmt+0x7c>
            putch('%', putdat);
ffffffffc02053ae:	85a6                	mv	a1,s1
ffffffffc02053b0:	02500513          	li	a0,37
ffffffffc02053b4:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc02053b6:	fff44783          	lbu	a5,-1(s0)
ffffffffc02053ba:	8d22                	mv	s10,s0
ffffffffc02053bc:	f73788e3          	beq	a5,s3,ffffffffc020532c <vprintfmt+0x3a>
ffffffffc02053c0:	ffed4783          	lbu	a5,-2(s10)
ffffffffc02053c4:	1d7d                	addi	s10,s10,-1
ffffffffc02053c6:	ff379de3          	bne	a5,s3,ffffffffc02053c0 <vprintfmt+0xce>
ffffffffc02053ca:	b78d                	j	ffffffffc020532c <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
ffffffffc02053cc:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
ffffffffc02053d0:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc02053d4:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
ffffffffc02053d6:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
ffffffffc02053da:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc02053de:	02d86463          	bltu	a6,a3,ffffffffc0205406 <vprintfmt+0x114>
                ch = *fmt;
ffffffffc02053e2:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc02053e6:	002c169b          	slliw	a3,s8,0x2
ffffffffc02053ea:	0186873b          	addw	a4,a3,s8
ffffffffc02053ee:	0017171b          	slliw	a4,a4,0x1
ffffffffc02053f2:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
ffffffffc02053f4:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc02053f8:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc02053fa:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
ffffffffc02053fe:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc0205402:	fed870e3          	bgeu	a6,a3,ffffffffc02053e2 <vprintfmt+0xf0>
            if (width < 0)
ffffffffc0205406:	f40ddce3          	bgez	s11,ffffffffc020535e <vprintfmt+0x6c>
                width = precision, precision = -1;
ffffffffc020540a:	8de2                	mv	s11,s8
ffffffffc020540c:	5c7d                	li	s8,-1
ffffffffc020540e:	bf81                	j	ffffffffc020535e <vprintfmt+0x6c>
            if (width < 0)
ffffffffc0205410:	fffdc693          	not	a3,s11
ffffffffc0205414:	96fd                	srai	a3,a3,0x3f
ffffffffc0205416:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020541a:	00144603          	lbu	a2,1(s0)
ffffffffc020541e:	2d81                	sext.w	s11,s11
ffffffffc0205420:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0205422:	bf35                	j	ffffffffc020535e <vprintfmt+0x6c>
            precision = va_arg(ap, int);
ffffffffc0205424:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205428:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
ffffffffc020542c:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020542e:	846a                	mv	s0,s10
            goto process_precision;
ffffffffc0205430:	bfd9                	j	ffffffffc0205406 <vprintfmt+0x114>
    if (lflag >= 2) {
ffffffffc0205432:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0205434:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0205438:	01174463          	blt	a4,a7,ffffffffc0205440 <vprintfmt+0x14e>
    else if (lflag) {
ffffffffc020543c:	1a088e63          	beqz	a7,ffffffffc02055f8 <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
ffffffffc0205440:	000a3603          	ld	a2,0(s4)
ffffffffc0205444:	46c1                	li	a3,16
ffffffffc0205446:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0205448:	2781                	sext.w	a5,a5
ffffffffc020544a:	876e                	mv	a4,s11
ffffffffc020544c:	85a6                	mv	a1,s1
ffffffffc020544e:	854a                	mv	a0,s2
ffffffffc0205450:	e37ff0ef          	jal	ra,ffffffffc0205286 <printnum>
            break;
ffffffffc0205454:	bde1                	j	ffffffffc020532c <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
ffffffffc0205456:	000a2503          	lw	a0,0(s4)
ffffffffc020545a:	85a6                	mv	a1,s1
ffffffffc020545c:	0a21                	addi	s4,s4,8
ffffffffc020545e:	9902                	jalr	s2
            break;
ffffffffc0205460:	b5f1                	j	ffffffffc020532c <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0205462:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0205464:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0205468:	01174463          	blt	a4,a7,ffffffffc0205470 <vprintfmt+0x17e>
    else if (lflag) {
ffffffffc020546c:	18088163          	beqz	a7,ffffffffc02055ee <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
ffffffffc0205470:	000a3603          	ld	a2,0(s4)
ffffffffc0205474:	46a9                	li	a3,10
ffffffffc0205476:	8a2e                	mv	s4,a1
ffffffffc0205478:	bfc1                	j	ffffffffc0205448 <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020547a:	00144603          	lbu	a2,1(s0)
            altflag = 1;
ffffffffc020547e:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205480:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0205482:	bdf1                	j	ffffffffc020535e <vprintfmt+0x6c>
            putch(ch, putdat);
ffffffffc0205484:	85a6                	mv	a1,s1
ffffffffc0205486:	02500513          	li	a0,37
ffffffffc020548a:	9902                	jalr	s2
            break;
ffffffffc020548c:	b545                	j	ffffffffc020532c <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc020548e:	00144603          	lbu	a2,1(s0)
            lflag ++;
ffffffffc0205492:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0205494:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0205496:	b5e1                	j	ffffffffc020535e <vprintfmt+0x6c>
    if (lflag >= 2) {
ffffffffc0205498:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc020549a:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc020549e:	01174463          	blt	a4,a7,ffffffffc02054a6 <vprintfmt+0x1b4>
    else if (lflag) {
ffffffffc02054a2:	14088163          	beqz	a7,ffffffffc02055e4 <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
ffffffffc02054a6:	000a3603          	ld	a2,0(s4)
ffffffffc02054aa:	46a1                	li	a3,8
ffffffffc02054ac:	8a2e                	mv	s4,a1
ffffffffc02054ae:	bf69                	j	ffffffffc0205448 <vprintfmt+0x156>
            putch('0', putdat);
ffffffffc02054b0:	03000513          	li	a0,48
ffffffffc02054b4:	85a6                	mv	a1,s1
ffffffffc02054b6:	e03e                	sd	a5,0(sp)
ffffffffc02054b8:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc02054ba:	85a6                	mv	a1,s1
ffffffffc02054bc:	07800513          	li	a0,120
ffffffffc02054c0:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc02054c2:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc02054c4:	6782                	ld	a5,0(sp)
ffffffffc02054c6:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc02054c8:	ff8a3603          	ld	a2,-8(s4)
            goto number;
ffffffffc02054cc:	bfb5                	j	ffffffffc0205448 <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc02054ce:	000a3403          	ld	s0,0(s4)
ffffffffc02054d2:	008a0713          	addi	a4,s4,8
ffffffffc02054d6:	e03a                	sd	a4,0(sp)
ffffffffc02054d8:	14040263          	beqz	s0,ffffffffc020561c <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
ffffffffc02054dc:	0fb05763          	blez	s11,ffffffffc02055ca <vprintfmt+0x2d8>
ffffffffc02054e0:	02d00693          	li	a3,45
ffffffffc02054e4:	0cd79163          	bne	a5,a3,ffffffffc02055a6 <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02054e8:	00044783          	lbu	a5,0(s0)
ffffffffc02054ec:	0007851b          	sext.w	a0,a5
ffffffffc02054f0:	cf85                	beqz	a5,ffffffffc0205528 <vprintfmt+0x236>
ffffffffc02054f2:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02054f6:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02054fa:	000c4563          	bltz	s8,ffffffffc0205504 <vprintfmt+0x212>
ffffffffc02054fe:	3c7d                	addiw	s8,s8,-1
ffffffffc0205500:	036c0263          	beq	s8,s6,ffffffffc0205524 <vprintfmt+0x232>
                    putch('?', putdat);
ffffffffc0205504:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0205506:	0e0c8e63          	beqz	s9,ffffffffc0205602 <vprintfmt+0x310>
ffffffffc020550a:	3781                	addiw	a5,a5,-32
ffffffffc020550c:	0ef47b63          	bgeu	s0,a5,ffffffffc0205602 <vprintfmt+0x310>
                    putch('?', putdat);
ffffffffc0205510:	03f00513          	li	a0,63
ffffffffc0205514:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205516:	000a4783          	lbu	a5,0(s4)
ffffffffc020551a:	3dfd                	addiw	s11,s11,-1
ffffffffc020551c:	0a05                	addi	s4,s4,1
ffffffffc020551e:	0007851b          	sext.w	a0,a5
ffffffffc0205522:	ffe1                	bnez	a5,ffffffffc02054fa <vprintfmt+0x208>
            for (; width > 0; width --) {
ffffffffc0205524:	01b05963          	blez	s11,ffffffffc0205536 <vprintfmt+0x244>
ffffffffc0205528:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc020552a:	85a6                	mv	a1,s1
ffffffffc020552c:	02000513          	li	a0,32
ffffffffc0205530:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc0205532:	fe0d9be3          	bnez	s11,ffffffffc0205528 <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0205536:	6a02                	ld	s4,0(sp)
ffffffffc0205538:	bbd5                	j	ffffffffc020532c <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc020553a:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc020553c:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
ffffffffc0205540:	01174463          	blt	a4,a7,ffffffffc0205548 <vprintfmt+0x256>
    else if (lflag) {
ffffffffc0205544:	08088d63          	beqz	a7,ffffffffc02055de <vprintfmt+0x2ec>
        return va_arg(*ap, long);
ffffffffc0205548:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc020554c:	0a044d63          	bltz	s0,ffffffffc0205606 <vprintfmt+0x314>
            num = getint(&ap, lflag);
ffffffffc0205550:	8622                	mv	a2,s0
ffffffffc0205552:	8a66                	mv	s4,s9
ffffffffc0205554:	46a9                	li	a3,10
ffffffffc0205556:	bdcd                	j	ffffffffc0205448 <vprintfmt+0x156>
            err = va_arg(ap, int);
ffffffffc0205558:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc020555c:	4761                	li	a4,24
            err = va_arg(ap, int);
ffffffffc020555e:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc0205560:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc0205564:	8fb5                	xor	a5,a5,a3
ffffffffc0205566:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc020556a:	02d74163          	blt	a4,a3,ffffffffc020558c <vprintfmt+0x29a>
ffffffffc020556e:	00369793          	slli	a5,a3,0x3
ffffffffc0205572:	97de                	add	a5,a5,s7
ffffffffc0205574:	639c                	ld	a5,0(a5)
ffffffffc0205576:	cb99                	beqz	a5,ffffffffc020558c <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
ffffffffc0205578:	86be                	mv	a3,a5
ffffffffc020557a:	00000617          	auipc	a2,0x0
ffffffffc020557e:	13e60613          	addi	a2,a2,318 # ffffffffc02056b8 <etext+0x2e>
ffffffffc0205582:	85a6                	mv	a1,s1
ffffffffc0205584:	854a                	mv	a0,s2
ffffffffc0205586:	0ce000ef          	jal	ra,ffffffffc0205654 <printfmt>
ffffffffc020558a:	b34d                	j	ffffffffc020532c <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
ffffffffc020558c:	00002617          	auipc	a2,0x2
ffffffffc0205590:	f4460613          	addi	a2,a2,-188 # ffffffffc02074d0 <syscalls+0x120>
ffffffffc0205594:	85a6                	mv	a1,s1
ffffffffc0205596:	854a                	mv	a0,s2
ffffffffc0205598:	0bc000ef          	jal	ra,ffffffffc0205654 <printfmt>
ffffffffc020559c:	bb41                	j	ffffffffc020532c <vprintfmt+0x3a>
                p = "(null)";
ffffffffc020559e:	00002417          	auipc	s0,0x2
ffffffffc02055a2:	f2a40413          	addi	s0,s0,-214 # ffffffffc02074c8 <syscalls+0x118>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02055a6:	85e2                	mv	a1,s8
ffffffffc02055a8:	8522                	mv	a0,s0
ffffffffc02055aa:	e43e                	sd	a5,8(sp)
ffffffffc02055ac:	c29ff0ef          	jal	ra,ffffffffc02051d4 <strnlen>
ffffffffc02055b0:	40ad8dbb          	subw	s11,s11,a0
ffffffffc02055b4:	01b05b63          	blez	s11,ffffffffc02055ca <vprintfmt+0x2d8>
                    putch(padc, putdat);
ffffffffc02055b8:	67a2                	ld	a5,8(sp)
ffffffffc02055ba:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02055be:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
ffffffffc02055c0:	85a6                	mv	a1,s1
ffffffffc02055c2:	8552                	mv	a0,s4
ffffffffc02055c4:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc02055c6:	fe0d9ce3          	bnez	s11,ffffffffc02055be <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc02055ca:	00044783          	lbu	a5,0(s0)
ffffffffc02055ce:	00140a13          	addi	s4,s0,1
ffffffffc02055d2:	0007851b          	sext.w	a0,a5
ffffffffc02055d6:	d3a5                	beqz	a5,ffffffffc0205536 <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc02055d8:	05e00413          	li	s0,94
ffffffffc02055dc:	bf39                	j	ffffffffc02054fa <vprintfmt+0x208>
        return va_arg(*ap, int);
ffffffffc02055de:	000a2403          	lw	s0,0(s4)
ffffffffc02055e2:	b7ad                	j	ffffffffc020554c <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
ffffffffc02055e4:	000a6603          	lwu	a2,0(s4)
ffffffffc02055e8:	46a1                	li	a3,8
ffffffffc02055ea:	8a2e                	mv	s4,a1
ffffffffc02055ec:	bdb1                	j	ffffffffc0205448 <vprintfmt+0x156>
ffffffffc02055ee:	000a6603          	lwu	a2,0(s4)
ffffffffc02055f2:	46a9                	li	a3,10
ffffffffc02055f4:	8a2e                	mv	s4,a1
ffffffffc02055f6:	bd89                	j	ffffffffc0205448 <vprintfmt+0x156>
ffffffffc02055f8:	000a6603          	lwu	a2,0(s4)
ffffffffc02055fc:	46c1                	li	a3,16
ffffffffc02055fe:	8a2e                	mv	s4,a1
ffffffffc0205600:	b5a1                	j	ffffffffc0205448 <vprintfmt+0x156>
                    putch(ch, putdat);
ffffffffc0205602:	9902                	jalr	s2
ffffffffc0205604:	bf09                	j	ffffffffc0205516 <vprintfmt+0x224>
                putch('-', putdat);
ffffffffc0205606:	85a6                	mv	a1,s1
ffffffffc0205608:	02d00513          	li	a0,45
ffffffffc020560c:	e03e                	sd	a5,0(sp)
ffffffffc020560e:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc0205610:	6782                	ld	a5,0(sp)
ffffffffc0205612:	8a66                	mv	s4,s9
ffffffffc0205614:	40800633          	neg	a2,s0
ffffffffc0205618:	46a9                	li	a3,10
ffffffffc020561a:	b53d                	j	ffffffffc0205448 <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
ffffffffc020561c:	03b05163          	blez	s11,ffffffffc020563e <vprintfmt+0x34c>
ffffffffc0205620:	02d00693          	li	a3,45
ffffffffc0205624:	f6d79de3          	bne	a5,a3,ffffffffc020559e <vprintfmt+0x2ac>
                p = "(null)";
ffffffffc0205628:	00002417          	auipc	s0,0x2
ffffffffc020562c:	ea040413          	addi	s0,s0,-352 # ffffffffc02074c8 <syscalls+0x118>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0205630:	02800793          	li	a5,40
ffffffffc0205634:	02800513          	li	a0,40
ffffffffc0205638:	00140a13          	addi	s4,s0,1
ffffffffc020563c:	bd6d                	j	ffffffffc02054f6 <vprintfmt+0x204>
ffffffffc020563e:	00002a17          	auipc	s4,0x2
ffffffffc0205642:	e8ba0a13          	addi	s4,s4,-373 # ffffffffc02074c9 <syscalls+0x119>
ffffffffc0205646:	02800513          	li	a0,40
ffffffffc020564a:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc020564e:	05e00413          	li	s0,94
ffffffffc0205652:	b565                	j	ffffffffc02054fa <vprintfmt+0x208>

ffffffffc0205654 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0205654:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc0205656:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc020565a:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc020565c:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc020565e:	ec06                	sd	ra,24(sp)
ffffffffc0205660:	f83a                	sd	a4,48(sp)
ffffffffc0205662:	fc3e                	sd	a5,56(sp)
ffffffffc0205664:	e0c2                	sd	a6,64(sp)
ffffffffc0205666:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0205668:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc020566a:	c89ff0ef          	jal	ra,ffffffffc02052f2 <vprintfmt>
}
ffffffffc020566e:	60e2                	ld	ra,24(sp)
ffffffffc0205670:	6161                	addi	sp,sp,80
ffffffffc0205672:	8082                	ret

ffffffffc0205674 <hash32>:
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
ffffffffc0205674:	9e3707b7          	lui	a5,0x9e370
ffffffffc0205678:	2785                	addiw	a5,a5,1
ffffffffc020567a:	02a7853b          	mulw	a0,a5,a0
    return (hash >> (32 - bits));
ffffffffc020567e:	02000793          	li	a5,32
ffffffffc0205682:	9f8d                	subw	a5,a5,a1
}
ffffffffc0205684:	00f5553b          	srlw	a0,a0,a5
ffffffffc0205688:	8082                	ret
