
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
    .globl kern_entry
kern_entry:
    # a0: hartid
    # a1: dtb physical address
    # save hartid and dtb address
    la t0, boot_hartid
ffffffffc0200000:	00009297          	auipc	t0,0x9
ffffffffc0200004:	00028293          	mv	t0,t0
    sd a0, 0(t0)
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc0209000 <boot_hartid>
    la t0, boot_dtb
ffffffffc020000c:	00009297          	auipc	t0,0x9
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc0209008 <boot_dtb>
    sd a1, 0(t0)
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)
    
    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200018:	c02082b7          	lui	t0,0xc0208
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
ffffffffc020003c:	c0208137          	lui	sp,0xc0208

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
ffffffffc020004a:	00009517          	auipc	a0,0x9
ffffffffc020004e:	fe650513          	addi	a0,a0,-26 # ffffffffc0209030 <buf>
ffffffffc0200052:	0000d617          	auipc	a2,0xd
ffffffffc0200056:	49a60613          	addi	a2,a2,1178 # ffffffffc020d4ec <end>
{
ffffffffc020005a:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc020005c:	8e09                	sub	a2,a2,a0
ffffffffc020005e:	4581                	li	a1,0
{
ffffffffc0200060:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc0200062:	1ed030ef          	jal	ra,ffffffffc0203a4e <memset>
    dtb_init();
ffffffffc0200066:	452000ef          	jal	ra,ffffffffc02004b8 <dtb_init>
    cons_init(); // init the console
ffffffffc020006a:	053000ef          	jal	ra,ffffffffc02008bc <cons_init>

    const char *message = "(THU.CST) os is loading ...";
    cprintf("%s\n\n", message);
ffffffffc020006e:	00004597          	auipc	a1,0x4
ffffffffc0200072:	e3258593          	addi	a1,a1,-462 # ffffffffc0203ea0 <etext>
ffffffffc0200076:	00004517          	auipc	a0,0x4
ffffffffc020007a:	e4a50513          	addi	a0,a0,-438 # ffffffffc0203ec0 <etext+0x20>
ffffffffc020007e:	062000ef          	jal	ra,ffffffffc02000e0 <cprintf>

    print_kerninfo();
ffffffffc0200082:	1b8000ef          	jal	ra,ffffffffc020023a <print_kerninfo>

    // grade_backtrace();

    pmm_init(); // init physical memory management
ffffffffc0200086:	254010ef          	jal	ra,ffffffffc02012da <pmm_init>

    pic_init(); // init interrupt controller
ffffffffc020008a:	0a5000ef          	jal	ra,ffffffffc020092e <pic_init>
    idt_init(); // init interrupt descriptor table
ffffffffc020008e:	0af000ef          	jal	ra,ffffffffc020093c <idt_init>

    vmm_init();  // init virtual memory management
ffffffffc0200092:	7bd010ef          	jal	ra,ffffffffc020204e <vmm_init>
    proc_init(); // init process table
ffffffffc0200096:	5e6030ef          	jal	ra,ffffffffc020367c <proc_init>

    clock_init();  // init clock interrupt
ffffffffc020009a:	7ce000ef          	jal	ra,ffffffffc0200868 <clock_init>
    intr_enable(); // enable irq interrupt
ffffffffc020009e:	093000ef          	jal	ra,ffffffffc0200930 <intr_enable>

    cpu_idle(); // run idle process
ffffffffc02000a2:	029030ef          	jal	ra,ffffffffc02038ca <cpu_idle>

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
ffffffffc02000ae:	011000ef          	jal	ra,ffffffffc02008be <cons_putc>
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
ffffffffc02000d4:	235030ef          	jal	ra,ffffffffc0203b08 <vprintfmt>
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
ffffffffc02000e2:	02810313          	addi	t1,sp,40 # ffffffffc0208028 <boot_page_table_sv39+0x28>
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
ffffffffc020010a:	1ff030ef          	jal	ra,ffffffffc0203b08 <vprintfmt>
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
ffffffffc0200116:	7a80006f          	j	ffffffffc02008be <cons_putc>

ffffffffc020011a <getchar>:
}

/* getchar - reads a single non-zero character from stdin */
int getchar(void)
{
ffffffffc020011a:	1141                	addi	sp,sp,-16
ffffffffc020011c:	e406                	sd	ra,8(sp)
    int c;
    while ((c = cons_getc()) == 0)
ffffffffc020011e:	7d4000ef          	jal	ra,ffffffffc02008f2 <cons_getc>
ffffffffc0200122:	dd75                	beqz	a0,ffffffffc020011e <getchar+0x4>
        /* do nothing */;
    return c;
}
ffffffffc0200124:	60a2                	ld	ra,8(sp)
ffffffffc0200126:	0141                	addi	sp,sp,16
ffffffffc0200128:	8082                	ret

ffffffffc020012a <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
ffffffffc020012a:	715d                	addi	sp,sp,-80
ffffffffc020012c:	e486                	sd	ra,72(sp)
ffffffffc020012e:	e0a6                	sd	s1,64(sp)
ffffffffc0200130:	fc4a                	sd	s2,56(sp)
ffffffffc0200132:	f84e                	sd	s3,48(sp)
ffffffffc0200134:	f452                	sd	s4,40(sp)
ffffffffc0200136:	f056                	sd	s5,32(sp)
ffffffffc0200138:	ec5a                	sd	s6,24(sp)
ffffffffc020013a:	e85e                	sd	s7,16(sp)
    if (prompt != NULL) {
ffffffffc020013c:	c901                	beqz	a0,ffffffffc020014c <readline+0x22>
ffffffffc020013e:	85aa                	mv	a1,a0
        cprintf("%s", prompt);
ffffffffc0200140:	00004517          	auipc	a0,0x4
ffffffffc0200144:	d8850513          	addi	a0,a0,-632 # ffffffffc0203ec8 <etext+0x28>
ffffffffc0200148:	f99ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
readline(const char *prompt) {
ffffffffc020014c:	4481                	li	s1,0
    while (1) {
        c = getchar();
        if (c < 0) {
            return NULL;
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc020014e:	497d                	li	s2,31
            cputchar(c);
            buf[i ++] = c;
        }
        else if (c == '\b' && i > 0) {
ffffffffc0200150:	49a1                	li	s3,8
            cputchar(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
ffffffffc0200152:	4aa9                	li	s5,10
ffffffffc0200154:	4b35                	li	s6,13
            buf[i ++] = c;
ffffffffc0200156:	00009b97          	auipc	s7,0x9
ffffffffc020015a:	edab8b93          	addi	s7,s7,-294 # ffffffffc0209030 <buf>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc020015e:	3fe00a13          	li	s4,1022
        c = getchar();
ffffffffc0200162:	fb9ff0ef          	jal	ra,ffffffffc020011a <getchar>
        if (c < 0) {
ffffffffc0200166:	00054a63          	bltz	a0,ffffffffc020017a <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc020016a:	00a95a63          	bge	s2,a0,ffffffffc020017e <readline+0x54>
ffffffffc020016e:	029a5263          	bge	s4,s1,ffffffffc0200192 <readline+0x68>
        c = getchar();
ffffffffc0200172:	fa9ff0ef          	jal	ra,ffffffffc020011a <getchar>
        if (c < 0) {
ffffffffc0200176:	fe055ae3          	bgez	a0,ffffffffc020016a <readline+0x40>
            return NULL;
ffffffffc020017a:	4501                	li	a0,0
ffffffffc020017c:	a091                	j	ffffffffc02001c0 <readline+0x96>
        else if (c == '\b' && i > 0) {
ffffffffc020017e:	03351463          	bne	a0,s3,ffffffffc02001a6 <readline+0x7c>
ffffffffc0200182:	e8a9                	bnez	s1,ffffffffc02001d4 <readline+0xaa>
        c = getchar();
ffffffffc0200184:	f97ff0ef          	jal	ra,ffffffffc020011a <getchar>
        if (c < 0) {
ffffffffc0200188:	fe0549e3          	bltz	a0,ffffffffc020017a <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc020018c:	fea959e3          	bge	s2,a0,ffffffffc020017e <readline+0x54>
ffffffffc0200190:	4481                	li	s1,0
            cputchar(c);
ffffffffc0200192:	e42a                	sd	a0,8(sp)
ffffffffc0200194:	f83ff0ef          	jal	ra,ffffffffc0200116 <cputchar>
            buf[i ++] = c;
ffffffffc0200198:	6522                	ld	a0,8(sp)
ffffffffc020019a:	009b87b3          	add	a5,s7,s1
ffffffffc020019e:	2485                	addiw	s1,s1,1
ffffffffc02001a0:	00a78023          	sb	a0,0(a5)
ffffffffc02001a4:	bf7d                	j	ffffffffc0200162 <readline+0x38>
        else if (c == '\n' || c == '\r') {
ffffffffc02001a6:	01550463          	beq	a0,s5,ffffffffc02001ae <readline+0x84>
ffffffffc02001aa:	fb651ce3          	bne	a0,s6,ffffffffc0200162 <readline+0x38>
            cputchar(c);
ffffffffc02001ae:	f69ff0ef          	jal	ra,ffffffffc0200116 <cputchar>
            buf[i] = '\0';
ffffffffc02001b2:	00009517          	auipc	a0,0x9
ffffffffc02001b6:	e7e50513          	addi	a0,a0,-386 # ffffffffc0209030 <buf>
ffffffffc02001ba:	94aa                	add	s1,s1,a0
ffffffffc02001bc:	00048023          	sb	zero,0(s1)
            return buf;
        }
    }
}
ffffffffc02001c0:	60a6                	ld	ra,72(sp)
ffffffffc02001c2:	6486                	ld	s1,64(sp)
ffffffffc02001c4:	7962                	ld	s2,56(sp)
ffffffffc02001c6:	79c2                	ld	s3,48(sp)
ffffffffc02001c8:	7a22                	ld	s4,40(sp)
ffffffffc02001ca:	7a82                	ld	s5,32(sp)
ffffffffc02001cc:	6b62                	ld	s6,24(sp)
ffffffffc02001ce:	6bc2                	ld	s7,16(sp)
ffffffffc02001d0:	6161                	addi	sp,sp,80
ffffffffc02001d2:	8082                	ret
            cputchar(c);
ffffffffc02001d4:	4521                	li	a0,8
ffffffffc02001d6:	f41ff0ef          	jal	ra,ffffffffc0200116 <cputchar>
            i --;
ffffffffc02001da:	34fd                	addiw	s1,s1,-1
ffffffffc02001dc:	b759                	j	ffffffffc0200162 <readline+0x38>

ffffffffc02001de <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
ffffffffc02001de:	0000d317          	auipc	t1,0xd
ffffffffc02001e2:	28a30313          	addi	t1,t1,650 # ffffffffc020d468 <is_panic>
ffffffffc02001e6:	00032e03          	lw	t3,0(t1)
__panic(const char *file, int line, const char *fmt, ...) {
ffffffffc02001ea:	715d                	addi	sp,sp,-80
ffffffffc02001ec:	ec06                	sd	ra,24(sp)
ffffffffc02001ee:	e822                	sd	s0,16(sp)
ffffffffc02001f0:	f436                	sd	a3,40(sp)
ffffffffc02001f2:	f83a                	sd	a4,48(sp)
ffffffffc02001f4:	fc3e                	sd	a5,56(sp)
ffffffffc02001f6:	e0c2                	sd	a6,64(sp)
ffffffffc02001f8:	e4c6                	sd	a7,72(sp)
    if (is_panic) {
ffffffffc02001fa:	020e1a63          	bnez	t3,ffffffffc020022e <__panic+0x50>
        goto panic_dead;
    }
    is_panic = 1;
ffffffffc02001fe:	4785                	li	a5,1
ffffffffc0200200:	00f32023          	sw	a5,0(t1)

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
ffffffffc0200204:	8432                	mv	s0,a2
ffffffffc0200206:	103c                	addi	a5,sp,40
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc0200208:	862e                	mv	a2,a1
ffffffffc020020a:	85aa                	mv	a1,a0
ffffffffc020020c:	00004517          	auipc	a0,0x4
ffffffffc0200210:	cc450513          	addi	a0,a0,-828 # ffffffffc0203ed0 <etext+0x30>
    va_start(ap, fmt);
ffffffffc0200214:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc0200216:	ecbff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    vcprintf(fmt, ap);
ffffffffc020021a:	65a2                	ld	a1,8(sp)
ffffffffc020021c:	8522                	mv	a0,s0
ffffffffc020021e:	ea3ff0ef          	jal	ra,ffffffffc02000c0 <vcprintf>
    cprintf("\n");
ffffffffc0200222:	00005517          	auipc	a0,0x5
ffffffffc0200226:	b8e50513          	addi	a0,a0,-1138 # ffffffffc0204db0 <commands+0xc88>
ffffffffc020022a:	eb7ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
ffffffffc020022e:	708000ef          	jal	ra,ffffffffc0200936 <intr_disable>
    while (1) {
        kmonitor(NULL);
ffffffffc0200232:	4501                	li	a0,0
ffffffffc0200234:	130000ef          	jal	ra,ffffffffc0200364 <kmonitor>
    while (1) {
ffffffffc0200238:	bfed                	j	ffffffffc0200232 <__panic+0x54>

ffffffffc020023a <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void)
{
ffffffffc020023a:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
ffffffffc020023c:	00004517          	auipc	a0,0x4
ffffffffc0200240:	cb450513          	addi	a0,a0,-844 # ffffffffc0203ef0 <etext+0x50>
{
ffffffffc0200244:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc0200246:	e9bff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  entry  0x%08x (virtual)\n", kern_init);
ffffffffc020024a:	00000597          	auipc	a1,0x0
ffffffffc020024e:	e0058593          	addi	a1,a1,-512 # ffffffffc020004a <kern_init>
ffffffffc0200252:	00004517          	auipc	a0,0x4
ffffffffc0200256:	cbe50513          	addi	a0,a0,-834 # ffffffffc0203f10 <etext+0x70>
ffffffffc020025a:	e87ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  etext  0x%08x (virtual)\n", etext);
ffffffffc020025e:	00004597          	auipc	a1,0x4
ffffffffc0200262:	c4258593          	addi	a1,a1,-958 # ffffffffc0203ea0 <etext>
ffffffffc0200266:	00004517          	auipc	a0,0x4
ffffffffc020026a:	cca50513          	addi	a0,a0,-822 # ffffffffc0203f30 <etext+0x90>
ffffffffc020026e:	e73ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  edata  0x%08x (virtual)\n", edata);
ffffffffc0200272:	00009597          	auipc	a1,0x9
ffffffffc0200276:	dbe58593          	addi	a1,a1,-578 # ffffffffc0209030 <buf>
ffffffffc020027a:	00004517          	auipc	a0,0x4
ffffffffc020027e:	cd650513          	addi	a0,a0,-810 # ffffffffc0203f50 <etext+0xb0>
ffffffffc0200282:	e5fff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  end    0x%08x (virtual)\n", end);
ffffffffc0200286:	0000d597          	auipc	a1,0xd
ffffffffc020028a:	26658593          	addi	a1,a1,614 # ffffffffc020d4ec <end>
ffffffffc020028e:	00004517          	auipc	a0,0x4
ffffffffc0200292:	ce250513          	addi	a0,a0,-798 # ffffffffc0203f70 <etext+0xd0>
ffffffffc0200296:	e4bff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc020029a:	0000d597          	auipc	a1,0xd
ffffffffc020029e:	65158593          	addi	a1,a1,1617 # ffffffffc020d8eb <end+0x3ff>
ffffffffc02002a2:	00000797          	auipc	a5,0x0
ffffffffc02002a6:	da878793          	addi	a5,a5,-600 # ffffffffc020004a <kern_init>
ffffffffc02002aa:	40f587b3          	sub	a5,a1,a5
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02002ae:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc02002b2:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02002b4:	3ff5f593          	andi	a1,a1,1023
ffffffffc02002b8:	95be                	add	a1,a1,a5
ffffffffc02002ba:	85a9                	srai	a1,a1,0xa
ffffffffc02002bc:	00004517          	auipc	a0,0x4
ffffffffc02002c0:	cd450513          	addi	a0,a0,-812 # ffffffffc0203f90 <etext+0xf0>
}
ffffffffc02002c4:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc02002c6:	bd29                	j	ffffffffc02000e0 <cprintf>

ffffffffc02002c8 <print_stackframe>:
 * jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the
 * boundary.
 * */
void print_stackframe(void)
{
ffffffffc02002c8:	1141                	addi	sp,sp,-16
    panic("Not Implemented!");
ffffffffc02002ca:	00004617          	auipc	a2,0x4
ffffffffc02002ce:	cf660613          	addi	a2,a2,-778 # ffffffffc0203fc0 <etext+0x120>
ffffffffc02002d2:	04900593          	li	a1,73
ffffffffc02002d6:	00004517          	auipc	a0,0x4
ffffffffc02002da:	d0250513          	addi	a0,a0,-766 # ffffffffc0203fd8 <etext+0x138>
{
ffffffffc02002de:	e406                	sd	ra,8(sp)
    panic("Not Implemented!");
ffffffffc02002e0:	effff0ef          	jal	ra,ffffffffc02001de <__panic>

ffffffffc02002e4 <mon_help>:
    }
}

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc02002e4:	1141                	addi	sp,sp,-16
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc02002e6:	00004617          	auipc	a2,0x4
ffffffffc02002ea:	d0a60613          	addi	a2,a2,-758 # ffffffffc0203ff0 <etext+0x150>
ffffffffc02002ee:	00004597          	auipc	a1,0x4
ffffffffc02002f2:	d2258593          	addi	a1,a1,-734 # ffffffffc0204010 <etext+0x170>
ffffffffc02002f6:	00004517          	auipc	a0,0x4
ffffffffc02002fa:	d2250513          	addi	a0,a0,-734 # ffffffffc0204018 <etext+0x178>
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc02002fe:	e406                	sd	ra,8(sp)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc0200300:	de1ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
ffffffffc0200304:	00004617          	auipc	a2,0x4
ffffffffc0200308:	d2460613          	addi	a2,a2,-732 # ffffffffc0204028 <etext+0x188>
ffffffffc020030c:	00004597          	auipc	a1,0x4
ffffffffc0200310:	d4458593          	addi	a1,a1,-700 # ffffffffc0204050 <etext+0x1b0>
ffffffffc0200314:	00004517          	auipc	a0,0x4
ffffffffc0200318:	d0450513          	addi	a0,a0,-764 # ffffffffc0204018 <etext+0x178>
ffffffffc020031c:	dc5ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
ffffffffc0200320:	00004617          	auipc	a2,0x4
ffffffffc0200324:	d4060613          	addi	a2,a2,-704 # ffffffffc0204060 <etext+0x1c0>
ffffffffc0200328:	00004597          	auipc	a1,0x4
ffffffffc020032c:	d5858593          	addi	a1,a1,-680 # ffffffffc0204080 <etext+0x1e0>
ffffffffc0200330:	00004517          	auipc	a0,0x4
ffffffffc0200334:	ce850513          	addi	a0,a0,-792 # ffffffffc0204018 <etext+0x178>
ffffffffc0200338:	da9ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    }
    return 0;
}
ffffffffc020033c:	60a2                	ld	ra,8(sp)
ffffffffc020033e:	4501                	li	a0,0
ffffffffc0200340:	0141                	addi	sp,sp,16
ffffffffc0200342:	8082                	ret

ffffffffc0200344 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200344:	1141                	addi	sp,sp,-16
ffffffffc0200346:	e406                	sd	ra,8(sp)
    print_kerninfo();
ffffffffc0200348:	ef3ff0ef          	jal	ra,ffffffffc020023a <print_kerninfo>
    return 0;
}
ffffffffc020034c:	60a2                	ld	ra,8(sp)
ffffffffc020034e:	4501                	li	a0,0
ffffffffc0200350:	0141                	addi	sp,sp,16
ffffffffc0200352:	8082                	ret

ffffffffc0200354 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200354:	1141                	addi	sp,sp,-16
ffffffffc0200356:	e406                	sd	ra,8(sp)
    print_stackframe();
ffffffffc0200358:	f71ff0ef          	jal	ra,ffffffffc02002c8 <print_stackframe>
    return 0;
}
ffffffffc020035c:	60a2                	ld	ra,8(sp)
ffffffffc020035e:	4501                	li	a0,0
ffffffffc0200360:	0141                	addi	sp,sp,16
ffffffffc0200362:	8082                	ret

ffffffffc0200364 <kmonitor>:
kmonitor(struct trapframe *tf) {
ffffffffc0200364:	7115                	addi	sp,sp,-224
ffffffffc0200366:	ed5e                	sd	s7,152(sp)
ffffffffc0200368:	8baa                	mv	s7,a0
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc020036a:	00004517          	auipc	a0,0x4
ffffffffc020036e:	d2650513          	addi	a0,a0,-730 # ffffffffc0204090 <etext+0x1f0>
kmonitor(struct trapframe *tf) {
ffffffffc0200372:	ed86                	sd	ra,216(sp)
ffffffffc0200374:	e9a2                	sd	s0,208(sp)
ffffffffc0200376:	e5a6                	sd	s1,200(sp)
ffffffffc0200378:	e1ca                	sd	s2,192(sp)
ffffffffc020037a:	fd4e                	sd	s3,184(sp)
ffffffffc020037c:	f952                	sd	s4,176(sp)
ffffffffc020037e:	f556                	sd	s5,168(sp)
ffffffffc0200380:	f15a                	sd	s6,160(sp)
ffffffffc0200382:	e962                	sd	s8,144(sp)
ffffffffc0200384:	e566                	sd	s9,136(sp)
ffffffffc0200386:	e16a                	sd	s10,128(sp)
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc0200388:	d59ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
ffffffffc020038c:	00004517          	auipc	a0,0x4
ffffffffc0200390:	d2c50513          	addi	a0,a0,-724 # ffffffffc02040b8 <etext+0x218>
ffffffffc0200394:	d4dff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    if (tf != NULL) {
ffffffffc0200398:	000b8563          	beqz	s7,ffffffffc02003a2 <kmonitor+0x3e>
        print_trapframe(tf);
ffffffffc020039c:	855e                	mv	a0,s7
ffffffffc020039e:	786000ef          	jal	ra,ffffffffc0200b24 <print_trapframe>
#endif
}

static inline void sbi_shutdown(void)
{
	SBI_CALL_0(SBI_SHUTDOWN);
ffffffffc02003a2:	4501                	li	a0,0
ffffffffc02003a4:	4581                	li	a1,0
ffffffffc02003a6:	4601                	li	a2,0
ffffffffc02003a8:	48a1                	li	a7,8
ffffffffc02003aa:	00000073          	ecall
ffffffffc02003ae:	00004c17          	auipc	s8,0x4
ffffffffc02003b2:	d7ac0c13          	addi	s8,s8,-646 # ffffffffc0204128 <commands>
        if ((buf = readline("K> ")) != NULL) {
ffffffffc02003b6:	00004917          	auipc	s2,0x4
ffffffffc02003ba:	d2a90913          	addi	s2,s2,-726 # ffffffffc02040e0 <etext+0x240>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003be:	00004497          	auipc	s1,0x4
ffffffffc02003c2:	d2a48493          	addi	s1,s1,-726 # ffffffffc02040e8 <etext+0x248>
        if (argc == MAXARGS - 1) {
ffffffffc02003c6:	49bd                	li	s3,15
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc02003c8:	00004b17          	auipc	s6,0x4
ffffffffc02003cc:	d28b0b13          	addi	s6,s6,-728 # ffffffffc02040f0 <etext+0x250>
        argv[argc ++] = buf;
ffffffffc02003d0:	00004a17          	auipc	s4,0x4
ffffffffc02003d4:	c40a0a13          	addi	s4,s4,-960 # ffffffffc0204010 <etext+0x170>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02003d8:	4a8d                	li	s5,3
        if ((buf = readline("K> ")) != NULL) {
ffffffffc02003da:	854a                	mv	a0,s2
ffffffffc02003dc:	d4fff0ef          	jal	ra,ffffffffc020012a <readline>
ffffffffc02003e0:	842a                	mv	s0,a0
ffffffffc02003e2:	dd65                	beqz	a0,ffffffffc02003da <kmonitor+0x76>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003e4:	00054583          	lbu	a1,0(a0)
    int argc = 0;
ffffffffc02003e8:	4c81                	li	s9,0
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003ea:	e1bd                	bnez	a1,ffffffffc0200450 <kmonitor+0xec>
    if (argc == 0) {
ffffffffc02003ec:	fe0c87e3          	beqz	s9,ffffffffc02003da <kmonitor+0x76>
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc02003f0:	6582                	ld	a1,0(sp)
ffffffffc02003f2:	00004d17          	auipc	s10,0x4
ffffffffc02003f6:	d36d0d13          	addi	s10,s10,-714 # ffffffffc0204128 <commands>
        argv[argc ++] = buf;
ffffffffc02003fa:	8552                	mv	a0,s4
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc02003fc:	4401                	li	s0,0
ffffffffc02003fe:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200400:	5f4030ef          	jal	ra,ffffffffc02039f4 <strcmp>
ffffffffc0200404:	c919                	beqz	a0,ffffffffc020041a <kmonitor+0xb6>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200406:	2405                	addiw	s0,s0,1
ffffffffc0200408:	0b540063          	beq	s0,s5,ffffffffc02004a8 <kmonitor+0x144>
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc020040c:	000d3503          	ld	a0,0(s10)
ffffffffc0200410:	6582                	ld	a1,0(sp)
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200412:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200414:	5e0030ef          	jal	ra,ffffffffc02039f4 <strcmp>
ffffffffc0200418:	f57d                	bnez	a0,ffffffffc0200406 <kmonitor+0xa2>
            return commands[i].func(argc - 1, argv + 1, tf);
ffffffffc020041a:	00141793          	slli	a5,s0,0x1
ffffffffc020041e:	97a2                	add	a5,a5,s0
ffffffffc0200420:	078e                	slli	a5,a5,0x3
ffffffffc0200422:	97e2                	add	a5,a5,s8
ffffffffc0200424:	6b9c                	ld	a5,16(a5)
ffffffffc0200426:	865e                	mv	a2,s7
ffffffffc0200428:	002c                	addi	a1,sp,8
ffffffffc020042a:	fffc851b          	addiw	a0,s9,-1
ffffffffc020042e:	9782                	jalr	a5
            if (runcmd(buf, tf) < 0) {
ffffffffc0200430:	fa0555e3          	bgez	a0,ffffffffc02003da <kmonitor+0x76>
}
ffffffffc0200434:	60ee                	ld	ra,216(sp)
ffffffffc0200436:	644e                	ld	s0,208(sp)
ffffffffc0200438:	64ae                	ld	s1,200(sp)
ffffffffc020043a:	690e                	ld	s2,192(sp)
ffffffffc020043c:	79ea                	ld	s3,184(sp)
ffffffffc020043e:	7a4a                	ld	s4,176(sp)
ffffffffc0200440:	7aaa                	ld	s5,168(sp)
ffffffffc0200442:	7b0a                	ld	s6,160(sp)
ffffffffc0200444:	6bea                	ld	s7,152(sp)
ffffffffc0200446:	6c4a                	ld	s8,144(sp)
ffffffffc0200448:	6caa                	ld	s9,136(sp)
ffffffffc020044a:	6d0a                	ld	s10,128(sp)
ffffffffc020044c:	612d                	addi	sp,sp,224
ffffffffc020044e:	8082                	ret
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200450:	8526                	mv	a0,s1
ffffffffc0200452:	5e6030ef          	jal	ra,ffffffffc0203a38 <strchr>
ffffffffc0200456:	c901                	beqz	a0,ffffffffc0200466 <kmonitor+0x102>
ffffffffc0200458:	00144583          	lbu	a1,1(s0)
            *buf ++ = '\0';
ffffffffc020045c:	00040023          	sb	zero,0(s0)
ffffffffc0200460:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200462:	d5c9                	beqz	a1,ffffffffc02003ec <kmonitor+0x88>
ffffffffc0200464:	b7f5                	j	ffffffffc0200450 <kmonitor+0xec>
        if (*buf == '\0') {
ffffffffc0200466:	00044783          	lbu	a5,0(s0)
ffffffffc020046a:	d3c9                	beqz	a5,ffffffffc02003ec <kmonitor+0x88>
        if (argc == MAXARGS - 1) {
ffffffffc020046c:	033c8963          	beq	s9,s3,ffffffffc020049e <kmonitor+0x13a>
        argv[argc ++] = buf;
ffffffffc0200470:	003c9793          	slli	a5,s9,0x3
ffffffffc0200474:	0118                	addi	a4,sp,128
ffffffffc0200476:	97ba                	add	a5,a5,a4
ffffffffc0200478:	f887b023          	sd	s0,-128(a5)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc020047c:	00044583          	lbu	a1,0(s0)
        argv[argc ++] = buf;
ffffffffc0200480:	2c85                	addiw	s9,s9,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc0200482:	e591                	bnez	a1,ffffffffc020048e <kmonitor+0x12a>
ffffffffc0200484:	b7b5                	j	ffffffffc02003f0 <kmonitor+0x8c>
ffffffffc0200486:	00144583          	lbu	a1,1(s0)
            buf ++;
ffffffffc020048a:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc020048c:	d1a5                	beqz	a1,ffffffffc02003ec <kmonitor+0x88>
ffffffffc020048e:	8526                	mv	a0,s1
ffffffffc0200490:	5a8030ef          	jal	ra,ffffffffc0203a38 <strchr>
ffffffffc0200494:	d96d                	beqz	a0,ffffffffc0200486 <kmonitor+0x122>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200496:	00044583          	lbu	a1,0(s0)
ffffffffc020049a:	d9a9                	beqz	a1,ffffffffc02003ec <kmonitor+0x88>
ffffffffc020049c:	bf55                	j	ffffffffc0200450 <kmonitor+0xec>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc020049e:	45c1                	li	a1,16
ffffffffc02004a0:	855a                	mv	a0,s6
ffffffffc02004a2:	c3fff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
ffffffffc02004a6:	b7e9                	j	ffffffffc0200470 <kmonitor+0x10c>
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc02004a8:	6582                	ld	a1,0(sp)
ffffffffc02004aa:	00004517          	auipc	a0,0x4
ffffffffc02004ae:	c6650513          	addi	a0,a0,-922 # ffffffffc0204110 <etext+0x270>
ffffffffc02004b2:	c2fff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    return 0;
ffffffffc02004b6:	b715                	j	ffffffffc02003da <kmonitor+0x76>

ffffffffc02004b8 <dtb_init>:

// 保存解析出的系统物理内存信息
static uint64_t memory_base = 0;
static uint64_t memory_size = 0;

void dtb_init(void) {
ffffffffc02004b8:	7119                	addi	sp,sp,-128
    cprintf("DTB Init\n");
ffffffffc02004ba:	00004517          	auipc	a0,0x4
ffffffffc02004be:	cb650513          	addi	a0,a0,-842 # ffffffffc0204170 <commands+0x48>
void dtb_init(void) {
ffffffffc02004c2:	fc86                	sd	ra,120(sp)
ffffffffc02004c4:	f8a2                	sd	s0,112(sp)
ffffffffc02004c6:	e8d2                	sd	s4,80(sp)
ffffffffc02004c8:	f4a6                	sd	s1,104(sp)
ffffffffc02004ca:	f0ca                	sd	s2,96(sp)
ffffffffc02004cc:	ecce                	sd	s3,88(sp)
ffffffffc02004ce:	e4d6                	sd	s5,72(sp)
ffffffffc02004d0:	e0da                	sd	s6,64(sp)
ffffffffc02004d2:	fc5e                	sd	s7,56(sp)
ffffffffc02004d4:	f862                	sd	s8,48(sp)
ffffffffc02004d6:	f466                	sd	s9,40(sp)
ffffffffc02004d8:	f06a                	sd	s10,32(sp)
ffffffffc02004da:	ec6e                	sd	s11,24(sp)
    cprintf("DTB Init\n");
ffffffffc02004dc:	c05ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc02004e0:	00009597          	auipc	a1,0x9
ffffffffc02004e4:	b205b583          	ld	a1,-1248(a1) # ffffffffc0209000 <boot_hartid>
ffffffffc02004e8:	00004517          	auipc	a0,0x4
ffffffffc02004ec:	c9850513          	addi	a0,a0,-872 # ffffffffc0204180 <commands+0x58>
ffffffffc02004f0:	bf1ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc02004f4:	00009417          	auipc	s0,0x9
ffffffffc02004f8:	b1440413          	addi	s0,s0,-1260 # ffffffffc0209008 <boot_dtb>
ffffffffc02004fc:	600c                	ld	a1,0(s0)
ffffffffc02004fe:	00004517          	auipc	a0,0x4
ffffffffc0200502:	c9250513          	addi	a0,a0,-878 # ffffffffc0204190 <commands+0x68>
ffffffffc0200506:	bdbff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc020050a:	00043a03          	ld	s4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc020050e:	00004517          	auipc	a0,0x4
ffffffffc0200512:	c9a50513          	addi	a0,a0,-870 # ffffffffc02041a8 <commands+0x80>
    if (boot_dtb == 0) {
ffffffffc0200516:	120a0463          	beqz	s4,ffffffffc020063e <dtb_init+0x186>
        return;
    }
    
    // 转换为虚拟地址
    uintptr_t dtb_vaddr = boot_dtb + PHYSICAL_MEMORY_OFFSET;
ffffffffc020051a:	57f5                	li	a5,-3
ffffffffc020051c:	07fa                	slli	a5,a5,0x1e
ffffffffc020051e:	00fa0733          	add	a4,s4,a5
    const struct fdt_header *header = (const struct fdt_header *)dtb_vaddr;
    
    // 验证DTB
    uint32_t magic = fdt32_to_cpu(header->magic);
ffffffffc0200522:	431c                	lw	a5,0(a4)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200524:	00ff0637          	lui	a2,0xff0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200528:	6b41                	lui	s6,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020052a:	0087d59b          	srliw	a1,a5,0x8
ffffffffc020052e:	0187969b          	slliw	a3,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200532:	0187d51b          	srliw	a0,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200536:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020053a:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020053e:	8df1                	and	a1,a1,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200540:	8ec9                	or	a3,a3,a0
ffffffffc0200542:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200546:	1b7d                	addi	s6,s6,-1
ffffffffc0200548:	0167f7b3          	and	a5,a5,s6
ffffffffc020054c:	8dd5                	or	a1,a1,a3
ffffffffc020054e:	8ddd                	or	a1,a1,a5
    if (magic != 0xd00dfeed) {
ffffffffc0200550:	d00e07b7          	lui	a5,0xd00e0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200554:	2581                	sext.w	a1,a1
    if (magic != 0xd00dfeed) {
ffffffffc0200556:	eed78793          	addi	a5,a5,-275 # ffffffffd00dfeed <end+0xfed2a01>
ffffffffc020055a:	10f59163          	bne	a1,a5,ffffffffc020065c <dtb_init+0x1a4>
        return;
    }
    
    // 提取内存信息
    uint64_t mem_base, mem_size;
    if (extract_memory_info(dtb_vaddr, header, &mem_base, &mem_size) == 0) {
ffffffffc020055e:	471c                	lw	a5,8(a4)
ffffffffc0200560:	4754                	lw	a3,12(a4)
    int in_memory_node = 0;
ffffffffc0200562:	4c81                	li	s9,0
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200564:	0087d59b          	srliw	a1,a5,0x8
ffffffffc0200568:	0086d51b          	srliw	a0,a3,0x8
ffffffffc020056c:	0186941b          	slliw	s0,a3,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200570:	0186d89b          	srliw	a7,a3,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200574:	01879a1b          	slliw	s4,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200578:	0187d81b          	srliw	a6,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020057c:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200580:	0106d69b          	srliw	a3,a3,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200584:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200588:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020058c:	8d71                	and	a0,a0,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020058e:	01146433          	or	s0,s0,a7
ffffffffc0200592:	0086969b          	slliw	a3,a3,0x8
ffffffffc0200596:	010a6a33          	or	s4,s4,a6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020059a:	8e6d                	and	a2,a2,a1
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020059c:	0087979b          	slliw	a5,a5,0x8
ffffffffc02005a0:	8c49                	or	s0,s0,a0
ffffffffc02005a2:	0166f6b3          	and	a3,a3,s6
ffffffffc02005a6:	00ca6a33          	or	s4,s4,a2
ffffffffc02005aa:	0167f7b3          	and	a5,a5,s6
ffffffffc02005ae:	8c55                	or	s0,s0,a3
ffffffffc02005b0:	00fa6a33          	or	s4,s4,a5
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc02005b4:	1402                	slli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc02005b6:	1a02                	slli	s4,s4,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc02005b8:	9001                	srli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc02005ba:	020a5a13          	srli	s4,s4,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc02005be:	943a                	add	s0,s0,a4
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc02005c0:	9a3a                	add	s4,s4,a4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005c2:	00ff0c37          	lui	s8,0xff0
        switch (token) {
ffffffffc02005c6:	4b8d                	li	s7,3
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc02005c8:	00004917          	auipc	s2,0x4
ffffffffc02005cc:	c3090913          	addi	s2,s2,-976 # ffffffffc02041f8 <commands+0xd0>
ffffffffc02005d0:	49bd                	li	s3,15
        switch (token) {
ffffffffc02005d2:	4d91                	li	s11,4
ffffffffc02005d4:	4d05                	li	s10,1
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc02005d6:	00004497          	auipc	s1,0x4
ffffffffc02005da:	c1a48493          	addi	s1,s1,-998 # ffffffffc02041f0 <commands+0xc8>
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc02005de:	000a2703          	lw	a4,0(s4)
ffffffffc02005e2:	004a0a93          	addi	s5,s4,4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005e6:	0087569b          	srliw	a3,a4,0x8
ffffffffc02005ea:	0187179b          	slliw	a5,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005ee:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005f2:	0106969b          	slliw	a3,a3,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02005f6:	0107571b          	srliw	a4,a4,0x10
ffffffffc02005fa:	8fd1                	or	a5,a5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02005fc:	0186f6b3          	and	a3,a3,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200600:	0087171b          	slliw	a4,a4,0x8
ffffffffc0200604:	8fd5                	or	a5,a5,a3
ffffffffc0200606:	00eb7733          	and	a4,s6,a4
ffffffffc020060a:	8fd9                	or	a5,a5,a4
ffffffffc020060c:	2781                	sext.w	a5,a5
        switch (token) {
ffffffffc020060e:	09778c63          	beq	a5,s7,ffffffffc02006a6 <dtb_init+0x1ee>
ffffffffc0200612:	00fbea63          	bltu	s7,a5,ffffffffc0200626 <dtb_init+0x16e>
ffffffffc0200616:	07a78663          	beq	a5,s10,ffffffffc0200682 <dtb_init+0x1ca>
ffffffffc020061a:	4709                	li	a4,2
ffffffffc020061c:	00e79763          	bne	a5,a4,ffffffffc020062a <dtb_init+0x172>
ffffffffc0200620:	4c81                	li	s9,0
ffffffffc0200622:	8a56                	mv	s4,s5
ffffffffc0200624:	bf6d                	j	ffffffffc02005de <dtb_init+0x126>
ffffffffc0200626:	ffb78ee3          	beq	a5,s11,ffffffffc0200622 <dtb_init+0x16a>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
        // 保存到全局变量，供 PMM 查询
        memory_base = mem_base;
        memory_size = mem_size;
    } else {
        cprintf("Warning: Could not extract memory info from DTB\n");
ffffffffc020062a:	00004517          	auipc	a0,0x4
ffffffffc020062e:	c4650513          	addi	a0,a0,-954 # ffffffffc0204270 <commands+0x148>
ffffffffc0200632:	aafff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc0200636:	00004517          	auipc	a0,0x4
ffffffffc020063a:	c7250513          	addi	a0,a0,-910 # ffffffffc02042a8 <commands+0x180>
}
ffffffffc020063e:	7446                	ld	s0,112(sp)
ffffffffc0200640:	70e6                	ld	ra,120(sp)
ffffffffc0200642:	74a6                	ld	s1,104(sp)
ffffffffc0200644:	7906                	ld	s2,96(sp)
ffffffffc0200646:	69e6                	ld	s3,88(sp)
ffffffffc0200648:	6a46                	ld	s4,80(sp)
ffffffffc020064a:	6aa6                	ld	s5,72(sp)
ffffffffc020064c:	6b06                	ld	s6,64(sp)
ffffffffc020064e:	7be2                	ld	s7,56(sp)
ffffffffc0200650:	7c42                	ld	s8,48(sp)
ffffffffc0200652:	7ca2                	ld	s9,40(sp)
ffffffffc0200654:	7d02                	ld	s10,32(sp)
ffffffffc0200656:	6de2                	ld	s11,24(sp)
ffffffffc0200658:	6109                	addi	sp,sp,128
    cprintf("DTB init completed\n");
ffffffffc020065a:	b459                	j	ffffffffc02000e0 <cprintf>
}
ffffffffc020065c:	7446                	ld	s0,112(sp)
ffffffffc020065e:	70e6                	ld	ra,120(sp)
ffffffffc0200660:	74a6                	ld	s1,104(sp)
ffffffffc0200662:	7906                	ld	s2,96(sp)
ffffffffc0200664:	69e6                	ld	s3,88(sp)
ffffffffc0200666:	6a46                	ld	s4,80(sp)
ffffffffc0200668:	6aa6                	ld	s5,72(sp)
ffffffffc020066a:	6b06                	ld	s6,64(sp)
ffffffffc020066c:	7be2                	ld	s7,56(sp)
ffffffffc020066e:	7c42                	ld	s8,48(sp)
ffffffffc0200670:	7ca2                	ld	s9,40(sp)
ffffffffc0200672:	7d02                	ld	s10,32(sp)
ffffffffc0200674:	6de2                	ld	s11,24(sp)
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc0200676:	00004517          	auipc	a0,0x4
ffffffffc020067a:	b5250513          	addi	a0,a0,-1198 # ffffffffc02041c8 <commands+0xa0>
}
ffffffffc020067e:	6109                	addi	sp,sp,128
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc0200680:	b485                	j	ffffffffc02000e0 <cprintf>
                int name_len = strlen(name);
ffffffffc0200682:	8556                	mv	a0,s5
ffffffffc0200684:	328030ef          	jal	ra,ffffffffc02039ac <strlen>
ffffffffc0200688:	8a2a                	mv	s4,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc020068a:	4619                	li	a2,6
ffffffffc020068c:	85a6                	mv	a1,s1
ffffffffc020068e:	8556                	mv	a0,s5
                int name_len = strlen(name);
ffffffffc0200690:	2a01                	sext.w	s4,s4
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc0200692:	380030ef          	jal	ra,ffffffffc0203a12 <strncmp>
ffffffffc0200696:	e111                	bnez	a0,ffffffffc020069a <dtb_init+0x1e2>
                    in_memory_node = 1;
ffffffffc0200698:	4c85                	li	s9,1
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc020069a:	0a91                	addi	s5,s5,4
ffffffffc020069c:	9ad2                	add	s5,s5,s4
ffffffffc020069e:	ffcafa93          	andi	s5,s5,-4
        switch (token) {
ffffffffc02006a2:	8a56                	mv	s4,s5
ffffffffc02006a4:	bf2d                	j	ffffffffc02005de <dtb_init+0x126>
                uint32_t prop_len = fdt32_to_cpu(*struct_ptr++);
ffffffffc02006a6:	004a2783          	lw	a5,4(s4)
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc02006aa:	00ca0693          	addi	a3,s4,12
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006ae:	0087d71b          	srliw	a4,a5,0x8
ffffffffc02006b2:	01879a9b          	slliw	s5,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006b6:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006ba:	0107171b          	slliw	a4,a4,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006be:	0107d79b          	srliw	a5,a5,0x10
ffffffffc02006c2:	00caeab3          	or	s5,s5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006c6:	01877733          	and	a4,a4,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006ca:	0087979b          	slliw	a5,a5,0x8
ffffffffc02006ce:	00eaeab3          	or	s5,s5,a4
ffffffffc02006d2:	00fb77b3          	and	a5,s6,a5
ffffffffc02006d6:	00faeab3          	or	s5,s5,a5
ffffffffc02006da:	2a81                	sext.w	s5,s5
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc02006dc:	000c9c63          	bnez	s9,ffffffffc02006f4 <dtb_init+0x23c>
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + prop_len + 3) & ~3);
ffffffffc02006e0:	1a82                	slli	s5,s5,0x20
ffffffffc02006e2:	00368793          	addi	a5,a3,3
ffffffffc02006e6:	020ada93          	srli	s5,s5,0x20
ffffffffc02006ea:	9abe                	add	s5,s5,a5
ffffffffc02006ec:	ffcafa93          	andi	s5,s5,-4
        switch (token) {
ffffffffc02006f0:	8a56                	mv	s4,s5
ffffffffc02006f2:	b5f5                	j	ffffffffc02005de <dtb_init+0x126>
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc02006f4:	008a2783          	lw	a5,8(s4)
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc02006f8:	85ca                	mv	a1,s2
ffffffffc02006fa:	e436                	sd	a3,8(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006fc:	0087d51b          	srliw	a0,a5,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200700:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200704:	0187971b          	slliw	a4,a5,0x18
ffffffffc0200708:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020070c:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200710:	8f51                	or	a4,a4,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200712:	01857533          	and	a0,a0,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200716:	0087979b          	slliw	a5,a5,0x8
ffffffffc020071a:	8d59                	or	a0,a0,a4
ffffffffc020071c:	00fb77b3          	and	a5,s6,a5
ffffffffc0200720:	8d5d                	or	a0,a0,a5
                const char *prop_name = strings_base + prop_nameoff;
ffffffffc0200722:	1502                	slli	a0,a0,0x20
ffffffffc0200724:	9101                	srli	a0,a0,0x20
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200726:	9522                	add	a0,a0,s0
ffffffffc0200728:	2cc030ef          	jal	ra,ffffffffc02039f4 <strcmp>
ffffffffc020072c:	66a2                	ld	a3,8(sp)
ffffffffc020072e:	f94d                	bnez	a0,ffffffffc02006e0 <dtb_init+0x228>
ffffffffc0200730:	fb59f8e3          	bgeu	s3,s5,ffffffffc02006e0 <dtb_init+0x228>
                    *mem_base = fdt64_to_cpu(reg_data[0]);
ffffffffc0200734:	00ca3783          	ld	a5,12(s4)
                    *mem_size = fdt64_to_cpu(reg_data[1]);
ffffffffc0200738:	014a3703          	ld	a4,20(s4)
        cprintf("Physical Memory from DTB:\n");
ffffffffc020073c:	00004517          	auipc	a0,0x4
ffffffffc0200740:	ac450513          	addi	a0,a0,-1340 # ffffffffc0204200 <commands+0xd8>
           fdt32_to_cpu(x >> 32);
ffffffffc0200744:	4207d613          	srai	a2,a5,0x20
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200748:	0087d31b          	srliw	t1,a5,0x8
           fdt32_to_cpu(x >> 32);
ffffffffc020074c:	42075593          	srai	a1,a4,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200750:	0187de1b          	srliw	t3,a5,0x18
ffffffffc0200754:	0186581b          	srliw	a6,a2,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200758:	0187941b          	slliw	s0,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020075c:	0107d89b          	srliw	a7,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200760:	0187d693          	srli	a3,a5,0x18
ffffffffc0200764:	01861f1b          	slliw	t5,a2,0x18
ffffffffc0200768:	0087579b          	srliw	a5,a4,0x8
ffffffffc020076c:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200770:	0106561b          	srliw	a2,a2,0x10
ffffffffc0200774:	010f6f33          	or	t5,t5,a6
ffffffffc0200778:	0187529b          	srliw	t0,a4,0x18
ffffffffc020077c:	0185df9b          	srliw	t6,a1,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200780:	01837333          	and	t1,t1,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200784:	01c46433          	or	s0,s0,t3
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200788:	0186f6b3          	and	a3,a3,s8
ffffffffc020078c:	01859e1b          	slliw	t3,a1,0x18
ffffffffc0200790:	01871e9b          	slliw	t4,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200794:	0107581b          	srliw	a6,a4,0x10
ffffffffc0200798:	0086161b          	slliw	a2,a2,0x8
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020079c:	8361                	srli	a4,a4,0x18
ffffffffc020079e:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007a2:	0105d59b          	srliw	a1,a1,0x10
ffffffffc02007a6:	01e6e6b3          	or	a3,a3,t5
ffffffffc02007aa:	00cb7633          	and	a2,s6,a2
ffffffffc02007ae:	0088181b          	slliw	a6,a6,0x8
ffffffffc02007b2:	0085959b          	slliw	a1,a1,0x8
ffffffffc02007b6:	00646433          	or	s0,s0,t1
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007ba:	0187f7b3          	and	a5,a5,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007be:	01fe6333          	or	t1,t3,t6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02007c2:	01877c33          	and	s8,a4,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02007c6:	0088989b          	slliw	a7,a7,0x8
ffffffffc02007ca:	011b78b3          	and	a7,s6,a7
ffffffffc02007ce:	005eeeb3          	or	t4,t4,t0
ffffffffc02007d2:	00c6e733          	or	a4,a3,a2
ffffffffc02007d6:	006c6c33          	or	s8,s8,t1
ffffffffc02007da:	010b76b3          	and	a3,s6,a6
ffffffffc02007de:	00bb7b33          	and	s6,s6,a1
ffffffffc02007e2:	01d7e7b3          	or	a5,a5,t4
ffffffffc02007e6:	016c6b33          	or	s6,s8,s6
ffffffffc02007ea:	01146433          	or	s0,s0,a7
ffffffffc02007ee:	8fd5                	or	a5,a5,a3
           fdt32_to_cpu(x >> 32);
ffffffffc02007f0:	1702                	slli	a4,a4,0x20
ffffffffc02007f2:	1b02                	slli	s6,s6,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc02007f4:	1782                	slli	a5,a5,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc02007f6:	9301                	srli	a4,a4,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc02007f8:	1402                	slli	s0,s0,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc02007fa:	020b5b13          	srli	s6,s6,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc02007fe:	0167eb33          	or	s6,a5,s6
ffffffffc0200802:	8c59                	or	s0,s0,a4
        cprintf("Physical Memory from DTB:\n");
ffffffffc0200804:	8ddff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
        cprintf("  Base: 0x%016lx\n", mem_base);
ffffffffc0200808:	85a2                	mv	a1,s0
ffffffffc020080a:	00004517          	auipc	a0,0x4
ffffffffc020080e:	a1650513          	addi	a0,a0,-1514 # ffffffffc0204220 <commands+0xf8>
ffffffffc0200812:	8cfff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc0200816:	014b5613          	srli	a2,s6,0x14
ffffffffc020081a:	85da                	mv	a1,s6
ffffffffc020081c:	00004517          	auipc	a0,0x4
ffffffffc0200820:	a1c50513          	addi	a0,a0,-1508 # ffffffffc0204238 <commands+0x110>
ffffffffc0200824:	8bdff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc0200828:	008b05b3          	add	a1,s6,s0
ffffffffc020082c:	15fd                	addi	a1,a1,-1
ffffffffc020082e:	00004517          	auipc	a0,0x4
ffffffffc0200832:	a2a50513          	addi	a0,a0,-1494 # ffffffffc0204258 <commands+0x130>
ffffffffc0200836:	8abff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("DTB init completed\n");
ffffffffc020083a:	00004517          	auipc	a0,0x4
ffffffffc020083e:	a6e50513          	addi	a0,a0,-1426 # ffffffffc02042a8 <commands+0x180>
        memory_base = mem_base;
ffffffffc0200842:	0000d797          	auipc	a5,0xd
ffffffffc0200846:	c287b723          	sd	s0,-978(a5) # ffffffffc020d470 <memory_base>
        memory_size = mem_size;
ffffffffc020084a:	0000d797          	auipc	a5,0xd
ffffffffc020084e:	c367b723          	sd	s6,-978(a5) # ffffffffc020d478 <memory_size>
    cprintf("DTB init completed\n");
ffffffffc0200852:	b3f5                	j	ffffffffc020063e <dtb_init+0x186>

ffffffffc0200854 <get_memory_base>:

uint64_t get_memory_base(void) {
    return memory_base;
}
ffffffffc0200854:	0000d517          	auipc	a0,0xd
ffffffffc0200858:	c1c53503          	ld	a0,-996(a0) # ffffffffc020d470 <memory_base>
ffffffffc020085c:	8082                	ret

ffffffffc020085e <get_memory_size>:

uint64_t get_memory_size(void) {
    return memory_size;
ffffffffc020085e:	0000d517          	auipc	a0,0xd
ffffffffc0200862:	c1a53503          	ld	a0,-998(a0) # ffffffffc020d478 <memory_size>
ffffffffc0200866:	8082                	ret

ffffffffc0200868 <clock_init>:
 * and then enable IRQ_TIMER.
 * */
void clock_init(void) {
    // divided by 500 when using Spike(2MHz)
    // divided by 100 when using QEMU(10MHz)
    timebase = 1e7 / 100;
ffffffffc0200868:	67e1                	lui	a5,0x18
ffffffffc020086a:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc020086e:	0000d717          	auipc	a4,0xd
ffffffffc0200872:	c0f73d23          	sd	a5,-998(a4) # ffffffffc020d488 <timebase>
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200876:	c0102573          	rdtime	a0
	SBI_CALL_1(SBI_SET_TIMER, stime_value);
ffffffffc020087a:	4581                	li	a1,0
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc020087c:	953e                	add	a0,a0,a5
ffffffffc020087e:	4601                	li	a2,0
ffffffffc0200880:	4881                	li	a7,0
ffffffffc0200882:	00000073          	ecall
    set_csr(sie, MIP_STIP);
ffffffffc0200886:	02000793          	li	a5,32
ffffffffc020088a:	1047a7f3          	csrrs	a5,sie,a5
    cprintf("++ setup timer interrupts\n");
ffffffffc020088e:	00004517          	auipc	a0,0x4
ffffffffc0200892:	a3250513          	addi	a0,a0,-1486 # ffffffffc02042c0 <commands+0x198>
    ticks = 0;
ffffffffc0200896:	0000d797          	auipc	a5,0xd
ffffffffc020089a:	be07b523          	sd	zero,-1046(a5) # ffffffffc020d480 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc020089e:	843ff06f          	j	ffffffffc02000e0 <cprintf>

ffffffffc02008a2 <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc02008a2:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc02008a6:	0000d797          	auipc	a5,0xd
ffffffffc02008aa:	be27b783          	ld	a5,-1054(a5) # ffffffffc020d488 <timebase>
ffffffffc02008ae:	953e                	add	a0,a0,a5
ffffffffc02008b0:	4581                	li	a1,0
ffffffffc02008b2:	4601                	li	a2,0
ffffffffc02008b4:	4881                	li	a7,0
ffffffffc02008b6:	00000073          	ecall
ffffffffc02008ba:	8082                	ret

ffffffffc02008bc <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc02008bc:	8082                	ret

ffffffffc02008be <cons_putc>:
#include <defs.h>
#include <intr.h>
#include <riscv.h>

static inline bool __intr_save(void) {
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02008be:	100027f3          	csrr	a5,sstatus
ffffffffc02008c2:	8b89                	andi	a5,a5,2
	SBI_CALL_1(SBI_CONSOLE_PUTCHAR, ch);
ffffffffc02008c4:	0ff57513          	zext.b	a0,a0
ffffffffc02008c8:	e799                	bnez	a5,ffffffffc02008d6 <cons_putc+0x18>
ffffffffc02008ca:	4581                	li	a1,0
ffffffffc02008cc:	4601                	li	a2,0
ffffffffc02008ce:	4885                	li	a7,1
ffffffffc02008d0:	00000073          	ecall
    }
    return 0;
}

static inline void __intr_restore(bool flag) {
    if (flag) {
ffffffffc02008d4:	8082                	ret

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) {
ffffffffc02008d6:	1101                	addi	sp,sp,-32
ffffffffc02008d8:	ec06                	sd	ra,24(sp)
ffffffffc02008da:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02008dc:	05a000ef          	jal	ra,ffffffffc0200936 <intr_disable>
ffffffffc02008e0:	6522                	ld	a0,8(sp)
ffffffffc02008e2:	4581                	li	a1,0
ffffffffc02008e4:	4601                	li	a2,0
ffffffffc02008e6:	4885                	li	a7,1
ffffffffc02008e8:	00000073          	ecall
    local_intr_save(intr_flag);
    {
        sbi_console_putchar((unsigned char)c);
    }
    local_intr_restore(intr_flag);
}
ffffffffc02008ec:	60e2                	ld	ra,24(sp)
ffffffffc02008ee:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc02008f0:	a081                	j	ffffffffc0200930 <intr_enable>

ffffffffc02008f2 <cons_getc>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02008f2:	100027f3          	csrr	a5,sstatus
ffffffffc02008f6:	8b89                	andi	a5,a5,2
ffffffffc02008f8:	eb89                	bnez	a5,ffffffffc020090a <cons_getc+0x18>
	return SBI_CALL_0(SBI_CONSOLE_GETCHAR);
ffffffffc02008fa:	4501                	li	a0,0
ffffffffc02008fc:	4581                	li	a1,0
ffffffffc02008fe:	4601                	li	a2,0
ffffffffc0200900:	4889                	li	a7,2
ffffffffc0200902:	00000073          	ecall
ffffffffc0200906:	2501                	sext.w	a0,a0
    {
        c = sbi_console_getchar();
    }
    local_intr_restore(intr_flag);
    return c;
}
ffffffffc0200908:	8082                	ret
int cons_getc(void) {
ffffffffc020090a:	1101                	addi	sp,sp,-32
ffffffffc020090c:	ec06                	sd	ra,24(sp)
        intr_disable();
ffffffffc020090e:	028000ef          	jal	ra,ffffffffc0200936 <intr_disable>
ffffffffc0200912:	4501                	li	a0,0
ffffffffc0200914:	4581                	li	a1,0
ffffffffc0200916:	4601                	li	a2,0
ffffffffc0200918:	4889                	li	a7,2
ffffffffc020091a:	00000073          	ecall
ffffffffc020091e:	2501                	sext.w	a0,a0
ffffffffc0200920:	e42a                	sd	a0,8(sp)
        intr_enable();
ffffffffc0200922:	00e000ef          	jal	ra,ffffffffc0200930 <intr_enable>
}
ffffffffc0200926:	60e2                	ld	ra,24(sp)
ffffffffc0200928:	6522                	ld	a0,8(sp)
ffffffffc020092a:	6105                	addi	sp,sp,32
ffffffffc020092c:	8082                	ret

ffffffffc020092e <pic_init>:
#include <picirq.h>

void pic_enable(unsigned int irq) {}

/* pic_init - initialize the 8259A interrupt controllers */
void pic_init(void) {}
ffffffffc020092e:	8082                	ret

ffffffffc0200930 <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
ffffffffc0200930:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc0200934:	8082                	ret

ffffffffc0200936 <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void) { clear_csr(sstatus, SSTATUS_SIE); }
ffffffffc0200936:	100177f3          	csrrci	a5,sstatus,2
ffffffffc020093a:	8082                	ret

ffffffffc020093c <idt_init>:
void idt_init(void)
{
    extern void __alltraps(void);
    /* Set sscratch register to 0, indicating to exception vector that we are
     * presently executing in the kernel */
    write_csr(sscratch, 0);
ffffffffc020093c:	14005073          	csrwi	sscratch,0
    /* Set the exception vector address */
    write_csr(stvec, &__alltraps);
ffffffffc0200940:	00000797          	auipc	a5,0x0
ffffffffc0200944:	3e478793          	addi	a5,a5,996 # ffffffffc0200d24 <__alltraps>
ffffffffc0200948:	10579073          	csrw	stvec,a5
    /* Allow kernel to access user memory */
    set_csr(sstatus, SSTATUS_SUM);
ffffffffc020094c:	000407b7          	lui	a5,0x40
ffffffffc0200950:	1007a7f3          	csrrs	a5,sstatus,a5
}
ffffffffc0200954:	8082                	ret

ffffffffc0200956 <print_regs>:
    cprintf("  cause    0x%08x\n", tf->cause);
}

void print_regs(struct pushregs *gpr)
{
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200956:	610c                	ld	a1,0(a0)
{
ffffffffc0200958:	1141                	addi	sp,sp,-16
ffffffffc020095a:	e022                	sd	s0,0(sp)
ffffffffc020095c:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc020095e:	00004517          	auipc	a0,0x4
ffffffffc0200962:	98250513          	addi	a0,a0,-1662 # ffffffffc02042e0 <commands+0x1b8>
{
ffffffffc0200966:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200968:	f78ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc020096c:	640c                	ld	a1,8(s0)
ffffffffc020096e:	00004517          	auipc	a0,0x4
ffffffffc0200972:	98a50513          	addi	a0,a0,-1654 # ffffffffc02042f8 <commands+0x1d0>
ffffffffc0200976:	f6aff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc020097a:	680c                	ld	a1,16(s0)
ffffffffc020097c:	00004517          	auipc	a0,0x4
ffffffffc0200980:	99450513          	addi	a0,a0,-1644 # ffffffffc0204310 <commands+0x1e8>
ffffffffc0200984:	f5cff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc0200988:	6c0c                	ld	a1,24(s0)
ffffffffc020098a:	00004517          	auipc	a0,0x4
ffffffffc020098e:	99e50513          	addi	a0,a0,-1634 # ffffffffc0204328 <commands+0x200>
ffffffffc0200992:	f4eff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc0200996:	700c                	ld	a1,32(s0)
ffffffffc0200998:	00004517          	auipc	a0,0x4
ffffffffc020099c:	9a850513          	addi	a0,a0,-1624 # ffffffffc0204340 <commands+0x218>
ffffffffc02009a0:	f40ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc02009a4:	740c                	ld	a1,40(s0)
ffffffffc02009a6:	00004517          	auipc	a0,0x4
ffffffffc02009aa:	9b250513          	addi	a0,a0,-1614 # ffffffffc0204358 <commands+0x230>
ffffffffc02009ae:	f32ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc02009b2:	780c                	ld	a1,48(s0)
ffffffffc02009b4:	00004517          	auipc	a0,0x4
ffffffffc02009b8:	9bc50513          	addi	a0,a0,-1604 # ffffffffc0204370 <commands+0x248>
ffffffffc02009bc:	f24ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc02009c0:	7c0c                	ld	a1,56(s0)
ffffffffc02009c2:	00004517          	auipc	a0,0x4
ffffffffc02009c6:	9c650513          	addi	a0,a0,-1594 # ffffffffc0204388 <commands+0x260>
ffffffffc02009ca:	f16ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc02009ce:	602c                	ld	a1,64(s0)
ffffffffc02009d0:	00004517          	auipc	a0,0x4
ffffffffc02009d4:	9d050513          	addi	a0,a0,-1584 # ffffffffc02043a0 <commands+0x278>
ffffffffc02009d8:	f08ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc02009dc:	642c                	ld	a1,72(s0)
ffffffffc02009de:	00004517          	auipc	a0,0x4
ffffffffc02009e2:	9da50513          	addi	a0,a0,-1574 # ffffffffc02043b8 <commands+0x290>
ffffffffc02009e6:	efaff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc02009ea:	682c                	ld	a1,80(s0)
ffffffffc02009ec:	00004517          	auipc	a0,0x4
ffffffffc02009f0:	9e450513          	addi	a0,a0,-1564 # ffffffffc02043d0 <commands+0x2a8>
ffffffffc02009f4:	eecff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc02009f8:	6c2c                	ld	a1,88(s0)
ffffffffc02009fa:	00004517          	auipc	a0,0x4
ffffffffc02009fe:	9ee50513          	addi	a0,a0,-1554 # ffffffffc02043e8 <commands+0x2c0>
ffffffffc0200a02:	edeff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc0200a06:	702c                	ld	a1,96(s0)
ffffffffc0200a08:	00004517          	auipc	a0,0x4
ffffffffc0200a0c:	9f850513          	addi	a0,a0,-1544 # ffffffffc0204400 <commands+0x2d8>
ffffffffc0200a10:	ed0ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc0200a14:	742c                	ld	a1,104(s0)
ffffffffc0200a16:	00004517          	auipc	a0,0x4
ffffffffc0200a1a:	a0250513          	addi	a0,a0,-1534 # ffffffffc0204418 <commands+0x2f0>
ffffffffc0200a1e:	ec2ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc0200a22:	782c                	ld	a1,112(s0)
ffffffffc0200a24:	00004517          	auipc	a0,0x4
ffffffffc0200a28:	a0c50513          	addi	a0,a0,-1524 # ffffffffc0204430 <commands+0x308>
ffffffffc0200a2c:	eb4ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc0200a30:	7c2c                	ld	a1,120(s0)
ffffffffc0200a32:	00004517          	auipc	a0,0x4
ffffffffc0200a36:	a1650513          	addi	a0,a0,-1514 # ffffffffc0204448 <commands+0x320>
ffffffffc0200a3a:	ea6ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc0200a3e:	604c                	ld	a1,128(s0)
ffffffffc0200a40:	00004517          	auipc	a0,0x4
ffffffffc0200a44:	a2050513          	addi	a0,a0,-1504 # ffffffffc0204460 <commands+0x338>
ffffffffc0200a48:	e98ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc0200a4c:	644c                	ld	a1,136(s0)
ffffffffc0200a4e:	00004517          	auipc	a0,0x4
ffffffffc0200a52:	a2a50513          	addi	a0,a0,-1494 # ffffffffc0204478 <commands+0x350>
ffffffffc0200a56:	e8aff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc0200a5a:	684c                	ld	a1,144(s0)
ffffffffc0200a5c:	00004517          	auipc	a0,0x4
ffffffffc0200a60:	a3450513          	addi	a0,a0,-1484 # ffffffffc0204490 <commands+0x368>
ffffffffc0200a64:	e7cff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc0200a68:	6c4c                	ld	a1,152(s0)
ffffffffc0200a6a:	00004517          	auipc	a0,0x4
ffffffffc0200a6e:	a3e50513          	addi	a0,a0,-1474 # ffffffffc02044a8 <commands+0x380>
ffffffffc0200a72:	e6eff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc0200a76:	704c                	ld	a1,160(s0)
ffffffffc0200a78:	00004517          	auipc	a0,0x4
ffffffffc0200a7c:	a4850513          	addi	a0,a0,-1464 # ffffffffc02044c0 <commands+0x398>
ffffffffc0200a80:	e60ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc0200a84:	744c                	ld	a1,168(s0)
ffffffffc0200a86:	00004517          	auipc	a0,0x4
ffffffffc0200a8a:	a5250513          	addi	a0,a0,-1454 # ffffffffc02044d8 <commands+0x3b0>
ffffffffc0200a8e:	e52ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc0200a92:	784c                	ld	a1,176(s0)
ffffffffc0200a94:	00004517          	auipc	a0,0x4
ffffffffc0200a98:	a5c50513          	addi	a0,a0,-1444 # ffffffffc02044f0 <commands+0x3c8>
ffffffffc0200a9c:	e44ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc0200aa0:	7c4c                	ld	a1,184(s0)
ffffffffc0200aa2:	00004517          	auipc	a0,0x4
ffffffffc0200aa6:	a6650513          	addi	a0,a0,-1434 # ffffffffc0204508 <commands+0x3e0>
ffffffffc0200aaa:	e36ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc0200aae:	606c                	ld	a1,192(s0)
ffffffffc0200ab0:	00004517          	auipc	a0,0x4
ffffffffc0200ab4:	a7050513          	addi	a0,a0,-1424 # ffffffffc0204520 <commands+0x3f8>
ffffffffc0200ab8:	e28ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc0200abc:	646c                	ld	a1,200(s0)
ffffffffc0200abe:	00004517          	auipc	a0,0x4
ffffffffc0200ac2:	a7a50513          	addi	a0,a0,-1414 # ffffffffc0204538 <commands+0x410>
ffffffffc0200ac6:	e1aff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc0200aca:	686c                	ld	a1,208(s0)
ffffffffc0200acc:	00004517          	auipc	a0,0x4
ffffffffc0200ad0:	a8450513          	addi	a0,a0,-1404 # ffffffffc0204550 <commands+0x428>
ffffffffc0200ad4:	e0cff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc0200ad8:	6c6c                	ld	a1,216(s0)
ffffffffc0200ada:	00004517          	auipc	a0,0x4
ffffffffc0200ade:	a8e50513          	addi	a0,a0,-1394 # ffffffffc0204568 <commands+0x440>
ffffffffc0200ae2:	dfeff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc0200ae6:	706c                	ld	a1,224(s0)
ffffffffc0200ae8:	00004517          	auipc	a0,0x4
ffffffffc0200aec:	a9850513          	addi	a0,a0,-1384 # ffffffffc0204580 <commands+0x458>
ffffffffc0200af0:	df0ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc0200af4:	746c                	ld	a1,232(s0)
ffffffffc0200af6:	00004517          	auipc	a0,0x4
ffffffffc0200afa:	aa250513          	addi	a0,a0,-1374 # ffffffffc0204598 <commands+0x470>
ffffffffc0200afe:	de2ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc0200b02:	786c                	ld	a1,240(s0)
ffffffffc0200b04:	00004517          	auipc	a0,0x4
ffffffffc0200b08:	aac50513          	addi	a0,a0,-1364 # ffffffffc02045b0 <commands+0x488>
ffffffffc0200b0c:	dd4ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b10:	7c6c                	ld	a1,248(s0)
}
ffffffffc0200b12:	6402                	ld	s0,0(sp)
ffffffffc0200b14:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b16:	00004517          	auipc	a0,0x4
ffffffffc0200b1a:	ab250513          	addi	a0,a0,-1358 # ffffffffc02045c8 <commands+0x4a0>
}
ffffffffc0200b1e:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200b20:	dc0ff06f          	j	ffffffffc02000e0 <cprintf>

ffffffffc0200b24 <print_trapframe>:
{
ffffffffc0200b24:	1141                	addi	sp,sp,-16
ffffffffc0200b26:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200b28:	85aa                	mv	a1,a0
{
ffffffffc0200b2a:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
ffffffffc0200b2c:	00004517          	auipc	a0,0x4
ffffffffc0200b30:	ab450513          	addi	a0,a0,-1356 # ffffffffc02045e0 <commands+0x4b8>
{
ffffffffc0200b34:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200b36:	daaff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    print_regs(&tf->gpr);
ffffffffc0200b3a:	8522                	mv	a0,s0
ffffffffc0200b3c:	e1bff0ef          	jal	ra,ffffffffc0200956 <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc0200b40:	10043583          	ld	a1,256(s0)
ffffffffc0200b44:	00004517          	auipc	a0,0x4
ffffffffc0200b48:	ab450513          	addi	a0,a0,-1356 # ffffffffc02045f8 <commands+0x4d0>
ffffffffc0200b4c:	d94ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc0200b50:	10843583          	ld	a1,264(s0)
ffffffffc0200b54:	00004517          	auipc	a0,0x4
ffffffffc0200b58:	abc50513          	addi	a0,a0,-1348 # ffffffffc0204610 <commands+0x4e8>
ffffffffc0200b5c:	d84ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
ffffffffc0200b60:	11043583          	ld	a1,272(s0)
ffffffffc0200b64:	00004517          	auipc	a0,0x4
ffffffffc0200b68:	ac450513          	addi	a0,a0,-1340 # ffffffffc0204628 <commands+0x500>
ffffffffc0200b6c:	d74ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200b70:	11843583          	ld	a1,280(s0)
}
ffffffffc0200b74:	6402                	ld	s0,0(sp)
ffffffffc0200b76:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200b78:	00004517          	auipc	a0,0x4
ffffffffc0200b7c:	ac850513          	addi	a0,a0,-1336 # ffffffffc0204640 <commands+0x518>
}
ffffffffc0200b80:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200b82:	d5eff06f          	j	ffffffffc02000e0 <cprintf>

ffffffffc0200b86 <interrupt_handler>:

extern struct mm_struct *check_mm_struct;

void interrupt_handler(struct trapframe *tf)
{
    intptr_t cause = (tf->cause << 1) >> 1;
ffffffffc0200b86:	11853783          	ld	a5,280(a0)
ffffffffc0200b8a:	472d                	li	a4,11
ffffffffc0200b8c:	0786                	slli	a5,a5,0x1
ffffffffc0200b8e:	8385                	srli	a5,a5,0x1
ffffffffc0200b90:	08f76963          	bltu	a4,a5,ffffffffc0200c22 <interrupt_handler+0x9c>
ffffffffc0200b94:	00004717          	auipc	a4,0x4
ffffffffc0200b98:	b7470713          	addi	a4,a4,-1164 # ffffffffc0204708 <commands+0x5e0>
ffffffffc0200b9c:	078a                	slli	a5,a5,0x2
ffffffffc0200b9e:	97ba                	add	a5,a5,a4
ffffffffc0200ba0:	439c                	lw	a5,0(a5)
ffffffffc0200ba2:	97ba                	add	a5,a5,a4
ffffffffc0200ba4:	8782                	jr	a5
        break;
    case IRQ_H_SOFT:
        cprintf("Hypervisor software interrupt\n");
        break;
    case IRQ_M_SOFT:
        cprintf("Machine software interrupt\n");
ffffffffc0200ba6:	00004517          	auipc	a0,0x4
ffffffffc0200baa:	b1250513          	addi	a0,a0,-1262 # ffffffffc02046b8 <commands+0x590>
ffffffffc0200bae:	d32ff06f          	j	ffffffffc02000e0 <cprintf>
        cprintf("Hypervisor software interrupt\n");
ffffffffc0200bb2:	00004517          	auipc	a0,0x4
ffffffffc0200bb6:	ae650513          	addi	a0,a0,-1306 # ffffffffc0204698 <commands+0x570>
ffffffffc0200bba:	d26ff06f          	j	ffffffffc02000e0 <cprintf>
        cprintf("User software interrupt\n");
ffffffffc0200bbe:	00004517          	auipc	a0,0x4
ffffffffc0200bc2:	a9a50513          	addi	a0,a0,-1382 # ffffffffc0204658 <commands+0x530>
ffffffffc0200bc6:	d1aff06f          	j	ffffffffc02000e0 <cprintf>
        cprintf("Supervisor software interrupt\n");
ffffffffc0200bca:	00004517          	auipc	a0,0x4
ffffffffc0200bce:	aae50513          	addi	a0,a0,-1362 # ffffffffc0204678 <commands+0x550>
ffffffffc0200bd2:	d0eff06f          	j	ffffffffc02000e0 <cprintf>
{
ffffffffc0200bd6:	1141                	addi	sp,sp,-16
ffffffffc0200bd8:	e406                	sd	ra,8(sp)
        // In fact, Call sbi_set_timer will clear STIP, or you can clear it
        // directly.
        // clear_csr(sip, SIP_STIP);

        /*LAB3 请补充你在lab3中的代码 */ 
	clock_set_next_event();
ffffffffc0200bda:	cc9ff0ef          	jal	ra,ffffffffc02008a2 <clock_set_next_event>

        static int ticks = 0;
        static int num = 0;

        ticks++;
ffffffffc0200bde:	0000d697          	auipc	a3,0xd
ffffffffc0200be2:	8b668693          	addi	a3,a3,-1866 # ffffffffc020d494 <ticks.1>
ffffffffc0200be6:	429c                	lw	a5,0(a3)

        if (ticks % TICK_NUM == 0) {
ffffffffc0200be8:	06400713          	li	a4,100
        ticks++;
ffffffffc0200bec:	2785                	addiw	a5,a5,1
        if (ticks % TICK_NUM == 0) {
ffffffffc0200bee:	02e7e73b          	remw	a4,a5,a4
        ticks++;
ffffffffc0200bf2:	c29c                	sw	a5,0(a3)
        if (ticks % TICK_NUM == 0) {
ffffffffc0200bf4:	cb05                	beqz	a4,ffffffffc0200c24 <interrupt_handler+0x9e>
                print_ticks();
                num++;
        }

        if (num >= 10) {
ffffffffc0200bf6:	0000d717          	auipc	a4,0xd
ffffffffc0200bfa:	89a72703          	lw	a4,-1894(a4) # ffffffffc020d490 <num.0>
ffffffffc0200bfe:	47a5                	li	a5,9
ffffffffc0200c00:	00e7d863          	bge	a5,a4,ffffffffc0200c10 <interrupt_handler+0x8a>
	SBI_CALL_0(SBI_SHUTDOWN);
ffffffffc0200c04:	4501                	li	a0,0
ffffffffc0200c06:	4581                	li	a1,0
ffffffffc0200c08:	4601                	li	a2,0
ffffffffc0200c0a:	48a1                	li	a7,8
ffffffffc0200c0c:	00000073          	ecall
        break;
    default:
        print_trapframe(tf);
        break;
    }
}
ffffffffc0200c10:	60a2                	ld	ra,8(sp)
ffffffffc0200c12:	0141                	addi	sp,sp,16
ffffffffc0200c14:	8082                	ret
        cprintf("Supervisor external interrupt\n");
ffffffffc0200c16:	00004517          	auipc	a0,0x4
ffffffffc0200c1a:	ad250513          	addi	a0,a0,-1326 # ffffffffc02046e8 <commands+0x5c0>
ffffffffc0200c1e:	cc2ff06f          	j	ffffffffc02000e0 <cprintf>
        print_trapframe(tf);
ffffffffc0200c22:	b709                	j	ffffffffc0200b24 <print_trapframe>
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc0200c24:	06400593          	li	a1,100
ffffffffc0200c28:	00004517          	auipc	a0,0x4
ffffffffc0200c2c:	ab050513          	addi	a0,a0,-1360 # ffffffffc02046d8 <commands+0x5b0>
ffffffffc0200c30:	cb0ff0ef          	jal	ra,ffffffffc02000e0 <cprintf>
                num++;
ffffffffc0200c34:	0000d697          	auipc	a3,0xd
ffffffffc0200c38:	85c68693          	addi	a3,a3,-1956 # ffffffffc020d490 <num.0>
ffffffffc0200c3c:	429c                	lw	a5,0(a3)
ffffffffc0200c3e:	0017871b          	addiw	a4,a5,1
ffffffffc0200c42:	c298                	sw	a4,0(a3)
ffffffffc0200c44:	bf6d                	j	ffffffffc0200bfe <interrupt_handler+0x78>

ffffffffc0200c46 <exception_handler>:

void exception_handler(struct trapframe *tf)
{
    int ret;
    switch (tf->cause)
ffffffffc0200c46:	11853783          	ld	a5,280(a0)
ffffffffc0200c4a:	473d                	li	a4,15
ffffffffc0200c4c:	0cf76563          	bltu	a4,a5,ffffffffc0200d16 <exception_handler+0xd0>
ffffffffc0200c50:	00004717          	auipc	a4,0x4
ffffffffc0200c54:	c8070713          	addi	a4,a4,-896 # ffffffffc02048d0 <commands+0x7a8>
ffffffffc0200c58:	078a                	slli	a5,a5,0x2
ffffffffc0200c5a:	97ba                	add	a5,a5,a4
ffffffffc0200c5c:	439c                	lw	a5,0(a5)
ffffffffc0200c5e:	97ba                	add	a5,a5,a4
ffffffffc0200c60:	8782                	jr	a5
        break;
    case CAUSE_LOAD_PAGE_FAULT:
        cprintf("Load page fault\n");
        break;
    case CAUSE_STORE_PAGE_FAULT:
        cprintf("Store/AMO page fault\n");
ffffffffc0200c62:	00004517          	auipc	a0,0x4
ffffffffc0200c66:	c5650513          	addi	a0,a0,-938 # ffffffffc02048b8 <commands+0x790>
ffffffffc0200c6a:	c76ff06f          	j	ffffffffc02000e0 <cprintf>
        cprintf("Instruction address misaligned\n");
ffffffffc0200c6e:	00004517          	auipc	a0,0x4
ffffffffc0200c72:	aca50513          	addi	a0,a0,-1334 # ffffffffc0204738 <commands+0x610>
ffffffffc0200c76:	c6aff06f          	j	ffffffffc02000e0 <cprintf>
        cprintf("Instruction access fault\n");
ffffffffc0200c7a:	00004517          	auipc	a0,0x4
ffffffffc0200c7e:	ade50513          	addi	a0,a0,-1314 # ffffffffc0204758 <commands+0x630>
ffffffffc0200c82:	c5eff06f          	j	ffffffffc02000e0 <cprintf>
        cprintf("Illegal instruction\n");
ffffffffc0200c86:	00004517          	auipc	a0,0x4
ffffffffc0200c8a:	af250513          	addi	a0,a0,-1294 # ffffffffc0204778 <commands+0x650>
ffffffffc0200c8e:	c52ff06f          	j	ffffffffc02000e0 <cprintf>
        cprintf("Breakpoint\n");
ffffffffc0200c92:	00004517          	auipc	a0,0x4
ffffffffc0200c96:	afe50513          	addi	a0,a0,-1282 # ffffffffc0204790 <commands+0x668>
ffffffffc0200c9a:	c46ff06f          	j	ffffffffc02000e0 <cprintf>
        cprintf("Load address misaligned\n");
ffffffffc0200c9e:	00004517          	auipc	a0,0x4
ffffffffc0200ca2:	b0250513          	addi	a0,a0,-1278 # ffffffffc02047a0 <commands+0x678>
ffffffffc0200ca6:	c3aff06f          	j	ffffffffc02000e0 <cprintf>
        cprintf("Load access fault\n");
ffffffffc0200caa:	00004517          	auipc	a0,0x4
ffffffffc0200cae:	b1650513          	addi	a0,a0,-1258 # ffffffffc02047c0 <commands+0x698>
ffffffffc0200cb2:	c2eff06f          	j	ffffffffc02000e0 <cprintf>
        cprintf("AMO address misaligned\n");
ffffffffc0200cb6:	00004517          	auipc	a0,0x4
ffffffffc0200cba:	b2250513          	addi	a0,a0,-1246 # ffffffffc02047d8 <commands+0x6b0>
ffffffffc0200cbe:	c22ff06f          	j	ffffffffc02000e0 <cprintf>
        cprintf("Store/AMO access fault\n");
ffffffffc0200cc2:	00004517          	auipc	a0,0x4
ffffffffc0200cc6:	b2e50513          	addi	a0,a0,-1234 # ffffffffc02047f0 <commands+0x6c8>
ffffffffc0200cca:	c16ff06f          	j	ffffffffc02000e0 <cprintf>
        cprintf("Environment call from U-mode\n");
ffffffffc0200cce:	00004517          	auipc	a0,0x4
ffffffffc0200cd2:	b3a50513          	addi	a0,a0,-1222 # ffffffffc0204808 <commands+0x6e0>
ffffffffc0200cd6:	c0aff06f          	j	ffffffffc02000e0 <cprintf>
        cprintf("Environment call from S-mode\n");
ffffffffc0200cda:	00004517          	auipc	a0,0x4
ffffffffc0200cde:	b4e50513          	addi	a0,a0,-1202 # ffffffffc0204828 <commands+0x700>
ffffffffc0200ce2:	bfeff06f          	j	ffffffffc02000e0 <cprintf>
        cprintf("Environment call from H-mode\n");
ffffffffc0200ce6:	00004517          	auipc	a0,0x4
ffffffffc0200cea:	b6250513          	addi	a0,a0,-1182 # ffffffffc0204848 <commands+0x720>
ffffffffc0200cee:	bf2ff06f          	j	ffffffffc02000e0 <cprintf>
        cprintf("Environment call from M-mode\n");
ffffffffc0200cf2:	00004517          	auipc	a0,0x4
ffffffffc0200cf6:	b7650513          	addi	a0,a0,-1162 # ffffffffc0204868 <commands+0x740>
ffffffffc0200cfa:	be6ff06f          	j	ffffffffc02000e0 <cprintf>
        cprintf("Instruction page fault\n");
ffffffffc0200cfe:	00004517          	auipc	a0,0x4
ffffffffc0200d02:	b8a50513          	addi	a0,a0,-1142 # ffffffffc0204888 <commands+0x760>
ffffffffc0200d06:	bdaff06f          	j	ffffffffc02000e0 <cprintf>
        cprintf("Load page fault\n");
ffffffffc0200d0a:	00004517          	auipc	a0,0x4
ffffffffc0200d0e:	b9650513          	addi	a0,a0,-1130 # ffffffffc02048a0 <commands+0x778>
ffffffffc0200d12:	bceff06f          	j	ffffffffc02000e0 <cprintf>
        break;
    default:
        print_trapframe(tf);
ffffffffc0200d16:	b539                	j	ffffffffc0200b24 <print_trapframe>

ffffffffc0200d18 <trap>:
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void trap(struct trapframe *tf)
{
    // dispatch based on what type of trap occurred
    if ((intptr_t)tf->cause < 0)
ffffffffc0200d18:	11853783          	ld	a5,280(a0)
ffffffffc0200d1c:	0007c363          	bltz	a5,ffffffffc0200d22 <trap+0xa>
        interrupt_handler(tf);
    }
    else
    {
        // exceptions
        exception_handler(tf);
ffffffffc0200d20:	b71d                	j	ffffffffc0200c46 <exception_handler>
        interrupt_handler(tf);
ffffffffc0200d22:	b595                	j	ffffffffc0200b86 <interrupt_handler>

ffffffffc0200d24 <__alltraps>:
    LOAD  x2,2*REGBYTES(sp)
    .endm

    .globl __alltraps
__alltraps:
    SAVE_ALL
ffffffffc0200d24:	14011073          	csrw	sscratch,sp
ffffffffc0200d28:	712d                	addi	sp,sp,-288
ffffffffc0200d2a:	e406                	sd	ra,8(sp)
ffffffffc0200d2c:	ec0e                	sd	gp,24(sp)
ffffffffc0200d2e:	f012                	sd	tp,32(sp)
ffffffffc0200d30:	f416                	sd	t0,40(sp)
ffffffffc0200d32:	f81a                	sd	t1,48(sp)
ffffffffc0200d34:	fc1e                	sd	t2,56(sp)
ffffffffc0200d36:	e0a2                	sd	s0,64(sp)
ffffffffc0200d38:	e4a6                	sd	s1,72(sp)
ffffffffc0200d3a:	e8aa                	sd	a0,80(sp)
ffffffffc0200d3c:	ecae                	sd	a1,88(sp)
ffffffffc0200d3e:	f0b2                	sd	a2,96(sp)
ffffffffc0200d40:	f4b6                	sd	a3,104(sp)
ffffffffc0200d42:	f8ba                	sd	a4,112(sp)
ffffffffc0200d44:	fcbe                	sd	a5,120(sp)
ffffffffc0200d46:	e142                	sd	a6,128(sp)
ffffffffc0200d48:	e546                	sd	a7,136(sp)
ffffffffc0200d4a:	e94a                	sd	s2,144(sp)
ffffffffc0200d4c:	ed4e                	sd	s3,152(sp)
ffffffffc0200d4e:	f152                	sd	s4,160(sp)
ffffffffc0200d50:	f556                	sd	s5,168(sp)
ffffffffc0200d52:	f95a                	sd	s6,176(sp)
ffffffffc0200d54:	fd5e                	sd	s7,184(sp)
ffffffffc0200d56:	e1e2                	sd	s8,192(sp)
ffffffffc0200d58:	e5e6                	sd	s9,200(sp)
ffffffffc0200d5a:	e9ea                	sd	s10,208(sp)
ffffffffc0200d5c:	edee                	sd	s11,216(sp)
ffffffffc0200d5e:	f1f2                	sd	t3,224(sp)
ffffffffc0200d60:	f5f6                	sd	t4,232(sp)
ffffffffc0200d62:	f9fa                	sd	t5,240(sp)
ffffffffc0200d64:	fdfe                	sd	t6,248(sp)
ffffffffc0200d66:	14002473          	csrr	s0,sscratch
ffffffffc0200d6a:	100024f3          	csrr	s1,sstatus
ffffffffc0200d6e:	14102973          	csrr	s2,sepc
ffffffffc0200d72:	143029f3          	csrr	s3,stval
ffffffffc0200d76:	14202a73          	csrr	s4,scause
ffffffffc0200d7a:	e822                	sd	s0,16(sp)
ffffffffc0200d7c:	e226                	sd	s1,256(sp)
ffffffffc0200d7e:	e64a                	sd	s2,264(sp)
ffffffffc0200d80:	ea4e                	sd	s3,272(sp)
ffffffffc0200d82:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc0200d84:	850a                	mv	a0,sp
    jal trap
ffffffffc0200d86:	f93ff0ef          	jal	ra,ffffffffc0200d18 <trap>

ffffffffc0200d8a <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0200d8a:	6492                	ld	s1,256(sp)
ffffffffc0200d8c:	6932                	ld	s2,264(sp)
ffffffffc0200d8e:	10049073          	csrw	sstatus,s1
ffffffffc0200d92:	14191073          	csrw	sepc,s2
ffffffffc0200d96:	60a2                	ld	ra,8(sp)
ffffffffc0200d98:	61e2                	ld	gp,24(sp)
ffffffffc0200d9a:	7202                	ld	tp,32(sp)
ffffffffc0200d9c:	72a2                	ld	t0,40(sp)
ffffffffc0200d9e:	7342                	ld	t1,48(sp)
ffffffffc0200da0:	73e2                	ld	t2,56(sp)
ffffffffc0200da2:	6406                	ld	s0,64(sp)
ffffffffc0200da4:	64a6                	ld	s1,72(sp)
ffffffffc0200da6:	6546                	ld	a0,80(sp)
ffffffffc0200da8:	65e6                	ld	a1,88(sp)
ffffffffc0200daa:	7606                	ld	a2,96(sp)
ffffffffc0200dac:	76a6                	ld	a3,104(sp)
ffffffffc0200dae:	7746                	ld	a4,112(sp)
ffffffffc0200db0:	77e6                	ld	a5,120(sp)
ffffffffc0200db2:	680a                	ld	a6,128(sp)
ffffffffc0200db4:	68aa                	ld	a7,136(sp)
ffffffffc0200db6:	694a                	ld	s2,144(sp)
ffffffffc0200db8:	69ea                	ld	s3,152(sp)
ffffffffc0200dba:	7a0a                	ld	s4,160(sp)
ffffffffc0200dbc:	7aaa                	ld	s5,168(sp)
ffffffffc0200dbe:	7b4a                	ld	s6,176(sp)
ffffffffc0200dc0:	7bea                	ld	s7,184(sp)
ffffffffc0200dc2:	6c0e                	ld	s8,192(sp)
ffffffffc0200dc4:	6cae                	ld	s9,200(sp)
ffffffffc0200dc6:	6d4e                	ld	s10,208(sp)
ffffffffc0200dc8:	6dee                	ld	s11,216(sp)
ffffffffc0200dca:	7e0e                	ld	t3,224(sp)
ffffffffc0200dcc:	7eae                	ld	t4,232(sp)
ffffffffc0200dce:	7f4e                	ld	t5,240(sp)
ffffffffc0200dd0:	7fee                	ld	t6,248(sp)
ffffffffc0200dd2:	6142                	ld	sp,16(sp)
    # go back from supervisor call
    sret
ffffffffc0200dd4:	10200073          	sret

ffffffffc0200dd8 <forkrets>:
 
    .globl forkrets
forkrets:
    # set stack to this new process's trapframe
    move sp, a0
ffffffffc0200dd8:	812a                	mv	sp,a0
    j __trapret
ffffffffc0200dda:	bf45                	j	ffffffffc0200d8a <__trapret>
	...

ffffffffc0200dde <pa2page.part.0>:
{
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa)
ffffffffc0200dde:	1141                	addi	sp,sp,-16
{
    if (PPN(pa) >= npage)
    {
        panic("pa2page called with invalid pa");
ffffffffc0200de0:	00004617          	auipc	a2,0x4
ffffffffc0200de4:	b3060613          	addi	a2,a2,-1232 # ffffffffc0204910 <commands+0x7e8>
ffffffffc0200de8:	06900593          	li	a1,105
ffffffffc0200dec:	00004517          	auipc	a0,0x4
ffffffffc0200df0:	b4450513          	addi	a0,a0,-1212 # ffffffffc0204930 <commands+0x808>
pa2page(uintptr_t pa)
ffffffffc0200df4:	e406                	sd	ra,8(sp)
        panic("pa2page called with invalid pa");
ffffffffc0200df6:	be8ff0ef          	jal	ra,ffffffffc02001de <__panic>

ffffffffc0200dfa <pte2page.part.0>:
{
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte)
ffffffffc0200dfa:	1141                	addi	sp,sp,-16
{
    if (!(pte & PTE_V))
    {
        panic("pte2page called with invalid pte");
ffffffffc0200dfc:	00004617          	auipc	a2,0x4
ffffffffc0200e00:	b4460613          	addi	a2,a2,-1212 # ffffffffc0204940 <commands+0x818>
ffffffffc0200e04:	07f00593          	li	a1,127
ffffffffc0200e08:	00004517          	auipc	a0,0x4
ffffffffc0200e0c:	b2850513          	addi	a0,a0,-1240 # ffffffffc0204930 <commands+0x808>
pte2page(pte_t pte)
ffffffffc0200e10:	e406                	sd	ra,8(sp)
        panic("pte2page called with invalid pte");
ffffffffc0200e12:	bccff0ef          	jal	ra,ffffffffc02001de <__panic>

ffffffffc0200e16 <alloc_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0200e16:	100027f3          	csrr	a5,sstatus
ffffffffc0200e1a:	8b89                	andi	a5,a5,2
ffffffffc0200e1c:	e799                	bnez	a5,ffffffffc0200e2a <alloc_pages+0x14>
{
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
ffffffffc0200e1e:	0000c797          	auipc	a5,0xc
ffffffffc0200e22:	69a7b783          	ld	a5,1690(a5) # ffffffffc020d4b8 <pmm_manager>
ffffffffc0200e26:	6f9c                	ld	a5,24(a5)
ffffffffc0200e28:	8782                	jr	a5
{
ffffffffc0200e2a:	1141                	addi	sp,sp,-16
ffffffffc0200e2c:	e406                	sd	ra,8(sp)
ffffffffc0200e2e:	e022                	sd	s0,0(sp)
ffffffffc0200e30:	842a                	mv	s0,a0
        intr_disable();
ffffffffc0200e32:	b05ff0ef          	jal	ra,ffffffffc0200936 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0200e36:	0000c797          	auipc	a5,0xc
ffffffffc0200e3a:	6827b783          	ld	a5,1666(a5) # ffffffffc020d4b8 <pmm_manager>
ffffffffc0200e3e:	6f9c                	ld	a5,24(a5)
ffffffffc0200e40:	8522                	mv	a0,s0
ffffffffc0200e42:	9782                	jalr	a5
ffffffffc0200e44:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0200e46:	aebff0ef          	jal	ra,ffffffffc0200930 <intr_enable>
    }
    local_intr_restore(intr_flag);
    return page;
}
ffffffffc0200e4a:	60a2                	ld	ra,8(sp)
ffffffffc0200e4c:	8522                	mv	a0,s0
ffffffffc0200e4e:	6402                	ld	s0,0(sp)
ffffffffc0200e50:	0141                	addi	sp,sp,16
ffffffffc0200e52:	8082                	ret

ffffffffc0200e54 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0200e54:	100027f3          	csrr	a5,sstatus
ffffffffc0200e58:	8b89                	andi	a5,a5,2
ffffffffc0200e5a:	e799                	bnez	a5,ffffffffc0200e68 <free_pages+0x14>
void free_pages(struct Page *base, size_t n)
{
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc0200e5c:	0000c797          	auipc	a5,0xc
ffffffffc0200e60:	65c7b783          	ld	a5,1628(a5) # ffffffffc020d4b8 <pmm_manager>
ffffffffc0200e64:	739c                	ld	a5,32(a5)
ffffffffc0200e66:	8782                	jr	a5
{
ffffffffc0200e68:	1101                	addi	sp,sp,-32
ffffffffc0200e6a:	ec06                	sd	ra,24(sp)
ffffffffc0200e6c:	e822                	sd	s0,16(sp)
ffffffffc0200e6e:	e426                	sd	s1,8(sp)
ffffffffc0200e70:	842a                	mv	s0,a0
ffffffffc0200e72:	84ae                	mv	s1,a1
        intr_disable();
ffffffffc0200e74:	ac3ff0ef          	jal	ra,ffffffffc0200936 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0200e78:	0000c797          	auipc	a5,0xc
ffffffffc0200e7c:	6407b783          	ld	a5,1600(a5) # ffffffffc020d4b8 <pmm_manager>
ffffffffc0200e80:	739c                	ld	a5,32(a5)
ffffffffc0200e82:	85a6                	mv	a1,s1
ffffffffc0200e84:	8522                	mv	a0,s0
ffffffffc0200e86:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc0200e88:	6442                	ld	s0,16(sp)
ffffffffc0200e8a:	60e2                	ld	ra,24(sp)
ffffffffc0200e8c:	64a2                	ld	s1,8(sp)
ffffffffc0200e8e:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0200e90:	b445                	j	ffffffffc0200930 <intr_enable>

ffffffffc0200e92 <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0200e92:	100027f3          	csrr	a5,sstatus
ffffffffc0200e96:	8b89                	andi	a5,a5,2
ffffffffc0200e98:	e799                	bnez	a5,ffffffffc0200ea6 <nr_free_pages+0x14>
{
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc0200e9a:	0000c797          	auipc	a5,0xc
ffffffffc0200e9e:	61e7b783          	ld	a5,1566(a5) # ffffffffc020d4b8 <pmm_manager>
ffffffffc0200ea2:	779c                	ld	a5,40(a5)
ffffffffc0200ea4:	8782                	jr	a5
{
ffffffffc0200ea6:	1141                	addi	sp,sp,-16
ffffffffc0200ea8:	e406                	sd	ra,8(sp)
ffffffffc0200eaa:	e022                	sd	s0,0(sp)
        intr_disable();
ffffffffc0200eac:	a8bff0ef          	jal	ra,ffffffffc0200936 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0200eb0:	0000c797          	auipc	a5,0xc
ffffffffc0200eb4:	6087b783          	ld	a5,1544(a5) # ffffffffc020d4b8 <pmm_manager>
ffffffffc0200eb8:	779c                	ld	a5,40(a5)
ffffffffc0200eba:	9782                	jalr	a5
ffffffffc0200ebc:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0200ebe:	a73ff0ef          	jal	ra,ffffffffc0200930 <intr_enable>
    }
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc0200ec2:	60a2                	ld	ra,8(sp)
ffffffffc0200ec4:	8522                	mv	a0,s0
ffffffffc0200ec6:	6402                	ld	s0,0(sp)
ffffffffc0200ec8:	0141                	addi	sp,sp,16
ffffffffc0200eca:	8082                	ret

ffffffffc0200ecc <get_pte>:
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *get_pte(pde_t *pgdir, uintptr_t la, bool create)
{
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0200ecc:	01e5d793          	srli	a5,a1,0x1e
ffffffffc0200ed0:	1ff7f793          	andi	a5,a5,511
{
ffffffffc0200ed4:	7139                	addi	sp,sp,-64
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0200ed6:	078e                	slli	a5,a5,0x3
{
ffffffffc0200ed8:	f426                	sd	s1,40(sp)
    pde_t *pdep1 = &pgdir[PDX1(la)];
ffffffffc0200eda:	00f504b3          	add	s1,a0,a5
    if (!(*pdep1 & PTE_V))
ffffffffc0200ede:	6094                	ld	a3,0(s1)
{
ffffffffc0200ee0:	f04a                	sd	s2,32(sp)
ffffffffc0200ee2:	ec4e                	sd	s3,24(sp)
ffffffffc0200ee4:	e852                	sd	s4,16(sp)
ffffffffc0200ee6:	fc06                	sd	ra,56(sp)
ffffffffc0200ee8:	f822                	sd	s0,48(sp)
ffffffffc0200eea:	e456                	sd	s5,8(sp)
ffffffffc0200eec:	e05a                	sd	s6,0(sp)
    if (!(*pdep1 & PTE_V))
ffffffffc0200eee:	0016f793          	andi	a5,a3,1
{
ffffffffc0200ef2:	892e                	mv	s2,a1
ffffffffc0200ef4:	8a32                	mv	s4,a2
ffffffffc0200ef6:	0000c997          	auipc	s3,0xc
ffffffffc0200efa:	5b298993          	addi	s3,s3,1458 # ffffffffc020d4a8 <npage>
    if (!(*pdep1 & PTE_V))
ffffffffc0200efe:	efbd                	bnez	a5,ffffffffc0200f7c <get_pte+0xb0>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0200f00:	14060c63          	beqz	a2,ffffffffc0201058 <get_pte+0x18c>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0200f04:	100027f3          	csrr	a5,sstatus
ffffffffc0200f08:	8b89                	andi	a5,a5,2
ffffffffc0200f0a:	14079963          	bnez	a5,ffffffffc020105c <get_pte+0x190>
        page = pmm_manager->alloc_pages(n);
ffffffffc0200f0e:	0000c797          	auipc	a5,0xc
ffffffffc0200f12:	5aa7b783          	ld	a5,1450(a5) # ffffffffc020d4b8 <pmm_manager>
ffffffffc0200f16:	6f9c                	ld	a5,24(a5)
ffffffffc0200f18:	4505                	li	a0,1
ffffffffc0200f1a:	9782                	jalr	a5
ffffffffc0200f1c:	842a                	mv	s0,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0200f1e:	12040d63          	beqz	s0,ffffffffc0201058 <get_pte+0x18c>
    return page - pages + nbase;
ffffffffc0200f22:	0000cb17          	auipc	s6,0xc
ffffffffc0200f26:	58eb0b13          	addi	s6,s6,1422 # ffffffffc020d4b0 <pages>
ffffffffc0200f2a:	000b3503          	ld	a0,0(s6)
ffffffffc0200f2e:	00080ab7          	lui	s5,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0200f32:	0000c997          	auipc	s3,0xc
ffffffffc0200f36:	57698993          	addi	s3,s3,1398 # ffffffffc020d4a8 <npage>
ffffffffc0200f3a:	40a40533          	sub	a0,s0,a0
ffffffffc0200f3e:	8519                	srai	a0,a0,0x6
ffffffffc0200f40:	9556                	add	a0,a0,s5
ffffffffc0200f42:	0009b703          	ld	a4,0(s3)
ffffffffc0200f46:	00c51793          	slli	a5,a0,0xc
}

static inline void
set_page_ref(struct Page *page, int val)
{
    page->ref = val;
ffffffffc0200f4a:	4685                	li	a3,1
ffffffffc0200f4c:	c014                	sw	a3,0(s0)
ffffffffc0200f4e:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0200f50:	0532                	slli	a0,a0,0xc
ffffffffc0200f52:	16e7f763          	bgeu	a5,a4,ffffffffc02010c0 <get_pte+0x1f4>
ffffffffc0200f56:	0000c797          	auipc	a5,0xc
ffffffffc0200f5a:	56a7b783          	ld	a5,1386(a5) # ffffffffc020d4c0 <va_pa_offset>
ffffffffc0200f5e:	6605                	lui	a2,0x1
ffffffffc0200f60:	4581                	li	a1,0
ffffffffc0200f62:	953e                	add	a0,a0,a5
ffffffffc0200f64:	2eb020ef          	jal	ra,ffffffffc0203a4e <memset>
    return page - pages + nbase;
ffffffffc0200f68:	000b3683          	ld	a3,0(s6)
ffffffffc0200f6c:	40d406b3          	sub	a3,s0,a3
ffffffffc0200f70:	8699                	srai	a3,a3,0x6
ffffffffc0200f72:	96d6                	add	a3,a3,s5
}

// construct PTE from a page and permission bits
static inline pte_t pte_create(uintptr_t ppn, int type)
{
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0200f74:	06aa                	slli	a3,a3,0xa
ffffffffc0200f76:	0116e693          	ori	a3,a3,17
        *pdep1 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc0200f7a:	e094                	sd	a3,0(s1)
    }
    pde_t *pdep0 = &((pte_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc0200f7c:	77fd                	lui	a5,0xfffff
ffffffffc0200f7e:	068a                	slli	a3,a3,0x2
ffffffffc0200f80:	0009b703          	ld	a4,0(s3)
ffffffffc0200f84:	8efd                	and	a3,a3,a5
ffffffffc0200f86:	00c6d793          	srli	a5,a3,0xc
ffffffffc0200f8a:	10e7ff63          	bgeu	a5,a4,ffffffffc02010a8 <get_pte+0x1dc>
ffffffffc0200f8e:	0000ca97          	auipc	s5,0xc
ffffffffc0200f92:	532a8a93          	addi	s5,s5,1330 # ffffffffc020d4c0 <va_pa_offset>
ffffffffc0200f96:	000ab403          	ld	s0,0(s5)
ffffffffc0200f9a:	01595793          	srli	a5,s2,0x15
ffffffffc0200f9e:	1ff7f793          	andi	a5,a5,511
ffffffffc0200fa2:	96a2                	add	a3,a3,s0
ffffffffc0200fa4:	00379413          	slli	s0,a5,0x3
ffffffffc0200fa8:	9436                	add	s0,s0,a3
    if (!(*pdep0 & PTE_V))
ffffffffc0200faa:	6014                	ld	a3,0(s0)
ffffffffc0200fac:	0016f793          	andi	a5,a3,1
ffffffffc0200fb0:	ebad                	bnez	a5,ffffffffc0201022 <get_pte+0x156>
    {
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0200fb2:	0a0a0363          	beqz	s4,ffffffffc0201058 <get_pte+0x18c>
ffffffffc0200fb6:	100027f3          	csrr	a5,sstatus
ffffffffc0200fba:	8b89                	andi	a5,a5,2
ffffffffc0200fbc:	efcd                	bnez	a5,ffffffffc0201076 <get_pte+0x1aa>
        page = pmm_manager->alloc_pages(n);
ffffffffc0200fbe:	0000c797          	auipc	a5,0xc
ffffffffc0200fc2:	4fa7b783          	ld	a5,1274(a5) # ffffffffc020d4b8 <pmm_manager>
ffffffffc0200fc6:	6f9c                	ld	a5,24(a5)
ffffffffc0200fc8:	4505                	li	a0,1
ffffffffc0200fca:	9782                	jalr	a5
ffffffffc0200fcc:	84aa                	mv	s1,a0
        if (!create || (page = alloc_page()) == NULL)
ffffffffc0200fce:	c4c9                	beqz	s1,ffffffffc0201058 <get_pte+0x18c>
    return page - pages + nbase;
ffffffffc0200fd0:	0000cb17          	auipc	s6,0xc
ffffffffc0200fd4:	4e0b0b13          	addi	s6,s6,1248 # ffffffffc020d4b0 <pages>
ffffffffc0200fd8:	000b3503          	ld	a0,0(s6)
ffffffffc0200fdc:	00080a37          	lui	s4,0x80
        {
            return NULL;
        }
        set_page_ref(page, 1);
        uintptr_t pa = page2pa(page);
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc0200fe0:	0009b703          	ld	a4,0(s3)
ffffffffc0200fe4:	40a48533          	sub	a0,s1,a0
ffffffffc0200fe8:	8519                	srai	a0,a0,0x6
ffffffffc0200fea:	9552                	add	a0,a0,s4
ffffffffc0200fec:	00c51793          	slli	a5,a0,0xc
    page->ref = val;
ffffffffc0200ff0:	4685                	li	a3,1
ffffffffc0200ff2:	c094                	sw	a3,0(s1)
ffffffffc0200ff4:	83b1                	srli	a5,a5,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc0200ff6:	0532                	slli	a0,a0,0xc
ffffffffc0200ff8:	0ee7f163          	bgeu	a5,a4,ffffffffc02010da <get_pte+0x20e>
ffffffffc0200ffc:	000ab783          	ld	a5,0(s5)
ffffffffc0201000:	6605                	lui	a2,0x1
ffffffffc0201002:	4581                	li	a1,0
ffffffffc0201004:	953e                	add	a0,a0,a5
ffffffffc0201006:	249020ef          	jal	ra,ffffffffc0203a4e <memset>
    return page - pages + nbase;
ffffffffc020100a:	000b3683          	ld	a3,0(s6)
ffffffffc020100e:	40d486b3          	sub	a3,s1,a3
ffffffffc0201012:	8699                	srai	a3,a3,0x6
ffffffffc0201014:	96d2                	add	a3,a3,s4
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0201016:	06aa                	slli	a3,a3,0xa
ffffffffc0201018:	0116e693          	ori	a3,a3,17
        *pdep0 = pte_create(page2ppn(page), PTE_U | PTE_V);
ffffffffc020101c:	e014                	sd	a3,0(s0)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc020101e:	0009b703          	ld	a4,0(s3)
ffffffffc0201022:	068a                	slli	a3,a3,0x2
ffffffffc0201024:	757d                	lui	a0,0xfffff
ffffffffc0201026:	8ee9                	and	a3,a3,a0
ffffffffc0201028:	00c6d793          	srli	a5,a3,0xc
ffffffffc020102c:	06e7f263          	bgeu	a5,a4,ffffffffc0201090 <get_pte+0x1c4>
ffffffffc0201030:	000ab503          	ld	a0,0(s5)
ffffffffc0201034:	00c95913          	srli	s2,s2,0xc
ffffffffc0201038:	1ff97913          	andi	s2,s2,511
ffffffffc020103c:	96aa                	add	a3,a3,a0
ffffffffc020103e:	00391513          	slli	a0,s2,0x3
ffffffffc0201042:	9536                	add	a0,a0,a3
}
ffffffffc0201044:	70e2                	ld	ra,56(sp)
ffffffffc0201046:	7442                	ld	s0,48(sp)
ffffffffc0201048:	74a2                	ld	s1,40(sp)
ffffffffc020104a:	7902                	ld	s2,32(sp)
ffffffffc020104c:	69e2                	ld	s3,24(sp)
ffffffffc020104e:	6a42                	ld	s4,16(sp)
ffffffffc0201050:	6aa2                	ld	s5,8(sp)
ffffffffc0201052:	6b02                	ld	s6,0(sp)
ffffffffc0201054:	6121                	addi	sp,sp,64
ffffffffc0201056:	8082                	ret
            return NULL;
ffffffffc0201058:	4501                	li	a0,0
ffffffffc020105a:	b7ed                	j	ffffffffc0201044 <get_pte+0x178>
        intr_disable();
ffffffffc020105c:	8dbff0ef          	jal	ra,ffffffffc0200936 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201060:	0000c797          	auipc	a5,0xc
ffffffffc0201064:	4587b783          	ld	a5,1112(a5) # ffffffffc020d4b8 <pmm_manager>
ffffffffc0201068:	6f9c                	ld	a5,24(a5)
ffffffffc020106a:	4505                	li	a0,1
ffffffffc020106c:	9782                	jalr	a5
ffffffffc020106e:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0201070:	8c1ff0ef          	jal	ra,ffffffffc0200930 <intr_enable>
ffffffffc0201074:	b56d                	j	ffffffffc0200f1e <get_pte+0x52>
        intr_disable();
ffffffffc0201076:	8c1ff0ef          	jal	ra,ffffffffc0200936 <intr_disable>
ffffffffc020107a:	0000c797          	auipc	a5,0xc
ffffffffc020107e:	43e7b783          	ld	a5,1086(a5) # ffffffffc020d4b8 <pmm_manager>
ffffffffc0201082:	6f9c                	ld	a5,24(a5)
ffffffffc0201084:	4505                	li	a0,1
ffffffffc0201086:	9782                	jalr	a5
ffffffffc0201088:	84aa                	mv	s1,a0
        intr_enable();
ffffffffc020108a:	8a7ff0ef          	jal	ra,ffffffffc0200930 <intr_enable>
ffffffffc020108e:	b781                	j	ffffffffc0200fce <get_pte+0x102>
    return &((pte_t *)KADDR(PDE_ADDR(*pdep0)))[PTX(la)];
ffffffffc0201090:	00004617          	auipc	a2,0x4
ffffffffc0201094:	8d860613          	addi	a2,a2,-1832 # ffffffffc0204968 <commands+0x840>
ffffffffc0201098:	0fb00593          	li	a1,251
ffffffffc020109c:	00004517          	auipc	a0,0x4
ffffffffc02010a0:	8f450513          	addi	a0,a0,-1804 # ffffffffc0204990 <commands+0x868>
ffffffffc02010a4:	93aff0ef          	jal	ra,ffffffffc02001de <__panic>
    pde_t *pdep0 = &((pte_t *)KADDR(PDE_ADDR(*pdep1)))[PDX0(la)];
ffffffffc02010a8:	00004617          	auipc	a2,0x4
ffffffffc02010ac:	8c060613          	addi	a2,a2,-1856 # ffffffffc0204968 <commands+0x840>
ffffffffc02010b0:	0ee00593          	li	a1,238
ffffffffc02010b4:	00004517          	auipc	a0,0x4
ffffffffc02010b8:	8dc50513          	addi	a0,a0,-1828 # ffffffffc0204990 <commands+0x868>
ffffffffc02010bc:	922ff0ef          	jal	ra,ffffffffc02001de <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc02010c0:	86aa                	mv	a3,a0
ffffffffc02010c2:	00004617          	auipc	a2,0x4
ffffffffc02010c6:	8a660613          	addi	a2,a2,-1882 # ffffffffc0204968 <commands+0x840>
ffffffffc02010ca:	0eb00593          	li	a1,235
ffffffffc02010ce:	00004517          	auipc	a0,0x4
ffffffffc02010d2:	8c250513          	addi	a0,a0,-1854 # ffffffffc0204990 <commands+0x868>
ffffffffc02010d6:	908ff0ef          	jal	ra,ffffffffc02001de <__panic>
        memset(KADDR(pa), 0, PGSIZE);
ffffffffc02010da:	86aa                	mv	a3,a0
ffffffffc02010dc:	00004617          	auipc	a2,0x4
ffffffffc02010e0:	88c60613          	addi	a2,a2,-1908 # ffffffffc0204968 <commands+0x840>
ffffffffc02010e4:	0f800593          	li	a1,248
ffffffffc02010e8:	00004517          	auipc	a0,0x4
ffffffffc02010ec:	8a850513          	addi	a0,a0,-1880 # ffffffffc0204990 <commands+0x868>
ffffffffc02010f0:	8eeff0ef          	jal	ra,ffffffffc02001de <__panic>

ffffffffc02010f4 <get_page>:

// get_page - get related Page struct for linear address la using PDT pgdir
struct Page *get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store)
{
ffffffffc02010f4:	1141                	addi	sp,sp,-16
ffffffffc02010f6:	e022                	sd	s0,0(sp)
ffffffffc02010f8:	8432                	mv	s0,a2
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc02010fa:	4601                	li	a2,0
{
ffffffffc02010fc:	e406                	sd	ra,8(sp)
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc02010fe:	dcfff0ef          	jal	ra,ffffffffc0200ecc <get_pte>
    if (ptep_store != NULL)
ffffffffc0201102:	c011                	beqz	s0,ffffffffc0201106 <get_page+0x12>
    {
        *ptep_store = ptep;
ffffffffc0201104:	e008                	sd	a0,0(s0)
    }
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc0201106:	c511                	beqz	a0,ffffffffc0201112 <get_page+0x1e>
ffffffffc0201108:	611c                	ld	a5,0(a0)
    {
        return pte2page(*ptep);
    }
    return NULL;
ffffffffc020110a:	4501                	li	a0,0
    if (ptep != NULL && *ptep & PTE_V)
ffffffffc020110c:	0017f713          	andi	a4,a5,1
ffffffffc0201110:	e709                	bnez	a4,ffffffffc020111a <get_page+0x26>
}
ffffffffc0201112:	60a2                	ld	ra,8(sp)
ffffffffc0201114:	6402                	ld	s0,0(sp)
ffffffffc0201116:	0141                	addi	sp,sp,16
ffffffffc0201118:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc020111a:	078a                	slli	a5,a5,0x2
ffffffffc020111c:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020111e:	0000c717          	auipc	a4,0xc
ffffffffc0201122:	38a73703          	ld	a4,906(a4) # ffffffffc020d4a8 <npage>
ffffffffc0201126:	00e7ff63          	bgeu	a5,a4,ffffffffc0201144 <get_page+0x50>
ffffffffc020112a:	60a2                	ld	ra,8(sp)
ffffffffc020112c:	6402                	ld	s0,0(sp)
    return &pages[PPN(pa) - nbase];
ffffffffc020112e:	fff80537          	lui	a0,0xfff80
ffffffffc0201132:	97aa                	add	a5,a5,a0
ffffffffc0201134:	079a                	slli	a5,a5,0x6
ffffffffc0201136:	0000c517          	auipc	a0,0xc
ffffffffc020113a:	37a53503          	ld	a0,890(a0) # ffffffffc020d4b0 <pages>
ffffffffc020113e:	953e                	add	a0,a0,a5
ffffffffc0201140:	0141                	addi	sp,sp,16
ffffffffc0201142:	8082                	ret
ffffffffc0201144:	c9bff0ef          	jal	ra,ffffffffc0200dde <pa2page.part.0>

ffffffffc0201148 <page_remove>:
}

// page_remove - free an Page which is related linear address la and has an
// validated pte
void page_remove(pde_t *pgdir, uintptr_t la)
{
ffffffffc0201148:	7179                	addi	sp,sp,-48
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc020114a:	4601                	li	a2,0
{
ffffffffc020114c:	ec26                	sd	s1,24(sp)
ffffffffc020114e:	f406                	sd	ra,40(sp)
ffffffffc0201150:	f022                	sd	s0,32(sp)
ffffffffc0201152:	84ae                	mv	s1,a1
    pte_t *ptep = get_pte(pgdir, la, 0);
ffffffffc0201154:	d79ff0ef          	jal	ra,ffffffffc0200ecc <get_pte>
    if (ptep != NULL)
ffffffffc0201158:	c511                	beqz	a0,ffffffffc0201164 <page_remove+0x1c>
    if (*ptep & PTE_V)
ffffffffc020115a:	611c                	ld	a5,0(a0)
ffffffffc020115c:	842a                	mv	s0,a0
ffffffffc020115e:	0017f713          	andi	a4,a5,1
ffffffffc0201162:	e711                	bnez	a4,ffffffffc020116e <page_remove+0x26>
    {
        page_remove_pte(pgdir, la, ptep);
    }
}
ffffffffc0201164:	70a2                	ld	ra,40(sp)
ffffffffc0201166:	7402                	ld	s0,32(sp)
ffffffffc0201168:	64e2                	ld	s1,24(sp)
ffffffffc020116a:	6145                	addi	sp,sp,48
ffffffffc020116c:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc020116e:	078a                	slli	a5,a5,0x2
ffffffffc0201170:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0201172:	0000c717          	auipc	a4,0xc
ffffffffc0201176:	33673703          	ld	a4,822(a4) # ffffffffc020d4a8 <npage>
ffffffffc020117a:	06e7f363          	bgeu	a5,a4,ffffffffc02011e0 <page_remove+0x98>
    return &pages[PPN(pa) - nbase];
ffffffffc020117e:	fff80537          	lui	a0,0xfff80
ffffffffc0201182:	97aa                	add	a5,a5,a0
ffffffffc0201184:	079a                	slli	a5,a5,0x6
ffffffffc0201186:	0000c517          	auipc	a0,0xc
ffffffffc020118a:	32a53503          	ld	a0,810(a0) # ffffffffc020d4b0 <pages>
ffffffffc020118e:	953e                	add	a0,a0,a5
    page->ref -= 1;
ffffffffc0201190:	411c                	lw	a5,0(a0)
ffffffffc0201192:	fff7871b          	addiw	a4,a5,-1
ffffffffc0201196:	c118                	sw	a4,0(a0)
        if (page_ref(page) ==
ffffffffc0201198:	cb11                	beqz	a4,ffffffffc02011ac <page_remove+0x64>
        *ptep = 0;                 //(5) clear second page table entry
ffffffffc020119a:	00043023          	sd	zero,0(s0)
// edited are the ones currently in use by the processor.
void tlb_invalidate(pde_t *pgdir, uintptr_t la)
{
    // flush_tlb();
    // The flush_tlb flush the entire TLB, is there any better way?
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc020119e:	12048073          	sfence.vma	s1
}
ffffffffc02011a2:	70a2                	ld	ra,40(sp)
ffffffffc02011a4:	7402                	ld	s0,32(sp)
ffffffffc02011a6:	64e2                	ld	s1,24(sp)
ffffffffc02011a8:	6145                	addi	sp,sp,48
ffffffffc02011aa:	8082                	ret
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02011ac:	100027f3          	csrr	a5,sstatus
ffffffffc02011b0:	8b89                	andi	a5,a5,2
ffffffffc02011b2:	eb89                	bnez	a5,ffffffffc02011c4 <page_remove+0x7c>
        pmm_manager->free_pages(base, n);
ffffffffc02011b4:	0000c797          	auipc	a5,0xc
ffffffffc02011b8:	3047b783          	ld	a5,772(a5) # ffffffffc020d4b8 <pmm_manager>
ffffffffc02011bc:	739c                	ld	a5,32(a5)
ffffffffc02011be:	4585                	li	a1,1
ffffffffc02011c0:	9782                	jalr	a5
    if (flag) {
ffffffffc02011c2:	bfe1                	j	ffffffffc020119a <page_remove+0x52>
        intr_disable();
ffffffffc02011c4:	e42a                	sd	a0,8(sp)
ffffffffc02011c6:	f70ff0ef          	jal	ra,ffffffffc0200936 <intr_disable>
ffffffffc02011ca:	0000c797          	auipc	a5,0xc
ffffffffc02011ce:	2ee7b783          	ld	a5,750(a5) # ffffffffc020d4b8 <pmm_manager>
ffffffffc02011d2:	739c                	ld	a5,32(a5)
ffffffffc02011d4:	6522                	ld	a0,8(sp)
ffffffffc02011d6:	4585                	li	a1,1
ffffffffc02011d8:	9782                	jalr	a5
        intr_enable();
ffffffffc02011da:	f56ff0ef          	jal	ra,ffffffffc0200930 <intr_enable>
ffffffffc02011de:	bf75                	j	ffffffffc020119a <page_remove+0x52>
ffffffffc02011e0:	bffff0ef          	jal	ra,ffffffffc0200dde <pa2page.part.0>

ffffffffc02011e4 <page_insert>:
{
ffffffffc02011e4:	7139                	addi	sp,sp,-64
ffffffffc02011e6:	e852                	sd	s4,16(sp)
ffffffffc02011e8:	8a32                	mv	s4,a2
ffffffffc02011ea:	f822                	sd	s0,48(sp)
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc02011ec:	4605                	li	a2,1
{
ffffffffc02011ee:	842e                	mv	s0,a1
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc02011f0:	85d2                	mv	a1,s4
{
ffffffffc02011f2:	f426                	sd	s1,40(sp)
ffffffffc02011f4:	fc06                	sd	ra,56(sp)
ffffffffc02011f6:	f04a                	sd	s2,32(sp)
ffffffffc02011f8:	ec4e                	sd	s3,24(sp)
ffffffffc02011fa:	e456                	sd	s5,8(sp)
ffffffffc02011fc:	84b6                	mv	s1,a3
    pte_t *ptep = get_pte(pgdir, la, 1);
ffffffffc02011fe:	ccfff0ef          	jal	ra,ffffffffc0200ecc <get_pte>
    if (ptep == NULL)
ffffffffc0201202:	c961                	beqz	a0,ffffffffc02012d2 <page_insert+0xee>
    page->ref += 1;
ffffffffc0201204:	4014                	lw	a3,0(s0)
    if (*ptep & PTE_V)
ffffffffc0201206:	611c                	ld	a5,0(a0)
ffffffffc0201208:	89aa                	mv	s3,a0
ffffffffc020120a:	0016871b          	addiw	a4,a3,1
ffffffffc020120e:	c018                	sw	a4,0(s0)
ffffffffc0201210:	0017f713          	andi	a4,a5,1
ffffffffc0201214:	ef05                	bnez	a4,ffffffffc020124c <page_insert+0x68>
    return page - pages + nbase;
ffffffffc0201216:	0000c717          	auipc	a4,0xc
ffffffffc020121a:	29a73703          	ld	a4,666(a4) # ffffffffc020d4b0 <pages>
ffffffffc020121e:	8c19                	sub	s0,s0,a4
ffffffffc0201220:	000807b7          	lui	a5,0x80
ffffffffc0201224:	8419                	srai	s0,s0,0x6
ffffffffc0201226:	943e                	add	s0,s0,a5
    return (ppn << PTE_PPN_SHIFT) | PTE_V | type;
ffffffffc0201228:	042a                	slli	s0,s0,0xa
ffffffffc020122a:	8cc1                	or	s1,s1,s0
ffffffffc020122c:	0014e493          	ori	s1,s1,1
    *ptep = pte_create(page2ppn(page), PTE_V | perm);
ffffffffc0201230:	0099b023          	sd	s1,0(s3)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0201234:	120a0073          	sfence.vma	s4
    return 0;
ffffffffc0201238:	4501                	li	a0,0
}
ffffffffc020123a:	70e2                	ld	ra,56(sp)
ffffffffc020123c:	7442                	ld	s0,48(sp)
ffffffffc020123e:	74a2                	ld	s1,40(sp)
ffffffffc0201240:	7902                	ld	s2,32(sp)
ffffffffc0201242:	69e2                	ld	s3,24(sp)
ffffffffc0201244:	6a42                	ld	s4,16(sp)
ffffffffc0201246:	6aa2                	ld	s5,8(sp)
ffffffffc0201248:	6121                	addi	sp,sp,64
ffffffffc020124a:	8082                	ret
    return pa2page(PTE_ADDR(pte));
ffffffffc020124c:	078a                	slli	a5,a5,0x2
ffffffffc020124e:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0201250:	0000c717          	auipc	a4,0xc
ffffffffc0201254:	25873703          	ld	a4,600(a4) # ffffffffc020d4a8 <npage>
ffffffffc0201258:	06e7ff63          	bgeu	a5,a4,ffffffffc02012d6 <page_insert+0xf2>
    return &pages[PPN(pa) - nbase];
ffffffffc020125c:	0000ca97          	auipc	s5,0xc
ffffffffc0201260:	254a8a93          	addi	s5,s5,596 # ffffffffc020d4b0 <pages>
ffffffffc0201264:	000ab703          	ld	a4,0(s5)
ffffffffc0201268:	fff80937          	lui	s2,0xfff80
ffffffffc020126c:	993e                	add	s2,s2,a5
ffffffffc020126e:	091a                	slli	s2,s2,0x6
ffffffffc0201270:	993a                	add	s2,s2,a4
        if (p == page)
ffffffffc0201272:	01240c63          	beq	s0,s2,ffffffffc020128a <page_insert+0xa6>
    page->ref -= 1;
ffffffffc0201276:	00092783          	lw	a5,0(s2) # fffffffffff80000 <end+0x3fd72b14>
ffffffffc020127a:	fff7869b          	addiw	a3,a5,-1
ffffffffc020127e:	00d92023          	sw	a3,0(s2)
        if (page_ref(page) ==
ffffffffc0201282:	c691                	beqz	a3,ffffffffc020128e <page_insert+0xaa>
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc0201284:	120a0073          	sfence.vma	s4
}
ffffffffc0201288:	bf59                	j	ffffffffc020121e <page_insert+0x3a>
ffffffffc020128a:	c014                	sw	a3,0(s0)
    return page->ref;
ffffffffc020128c:	bf49                	j	ffffffffc020121e <page_insert+0x3a>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020128e:	100027f3          	csrr	a5,sstatus
ffffffffc0201292:	8b89                	andi	a5,a5,2
ffffffffc0201294:	ef91                	bnez	a5,ffffffffc02012b0 <page_insert+0xcc>
        pmm_manager->free_pages(base, n);
ffffffffc0201296:	0000c797          	auipc	a5,0xc
ffffffffc020129a:	2227b783          	ld	a5,546(a5) # ffffffffc020d4b8 <pmm_manager>
ffffffffc020129e:	739c                	ld	a5,32(a5)
ffffffffc02012a0:	4585                	li	a1,1
ffffffffc02012a2:	854a                	mv	a0,s2
ffffffffc02012a4:	9782                	jalr	a5
    return page - pages + nbase;
ffffffffc02012a6:	000ab703          	ld	a4,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02012aa:	120a0073          	sfence.vma	s4
ffffffffc02012ae:	bf85                	j	ffffffffc020121e <page_insert+0x3a>
        intr_disable();
ffffffffc02012b0:	e86ff0ef          	jal	ra,ffffffffc0200936 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02012b4:	0000c797          	auipc	a5,0xc
ffffffffc02012b8:	2047b783          	ld	a5,516(a5) # ffffffffc020d4b8 <pmm_manager>
ffffffffc02012bc:	739c                	ld	a5,32(a5)
ffffffffc02012be:	4585                	li	a1,1
ffffffffc02012c0:	854a                	mv	a0,s2
ffffffffc02012c2:	9782                	jalr	a5
        intr_enable();
ffffffffc02012c4:	e6cff0ef          	jal	ra,ffffffffc0200930 <intr_enable>
ffffffffc02012c8:	000ab703          	ld	a4,0(s5)
    asm volatile("sfence.vma %0" : : "r"(la));
ffffffffc02012cc:	120a0073          	sfence.vma	s4
ffffffffc02012d0:	b7b9                	j	ffffffffc020121e <page_insert+0x3a>
        return -E_NO_MEM;
ffffffffc02012d2:	5571                	li	a0,-4
ffffffffc02012d4:	b79d                	j	ffffffffc020123a <page_insert+0x56>
ffffffffc02012d6:	b09ff0ef          	jal	ra,ffffffffc0200dde <pa2page.part.0>

ffffffffc02012da <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc02012da:	00004797          	auipc	a5,0x4
ffffffffc02012de:	2de78793          	addi	a5,a5,734 # ffffffffc02055b8 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02012e2:	638c                	ld	a1,0(a5)
{
ffffffffc02012e4:	7159                	addi	sp,sp,-112
ffffffffc02012e6:	f85a                	sd	s6,48(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc02012e8:	00003517          	auipc	a0,0x3
ffffffffc02012ec:	6b850513          	addi	a0,a0,1720 # ffffffffc02049a0 <commands+0x878>
    pmm_manager = &default_pmm_manager;
ffffffffc02012f0:	0000cb17          	auipc	s6,0xc
ffffffffc02012f4:	1c8b0b13          	addi	s6,s6,456 # ffffffffc020d4b8 <pmm_manager>
{
ffffffffc02012f8:	f486                	sd	ra,104(sp)
ffffffffc02012fa:	e8ca                	sd	s2,80(sp)
ffffffffc02012fc:	e4ce                	sd	s3,72(sp)
ffffffffc02012fe:	f0a2                	sd	s0,96(sp)
ffffffffc0201300:	eca6                	sd	s1,88(sp)
ffffffffc0201302:	e0d2                	sd	s4,64(sp)
ffffffffc0201304:	fc56                	sd	s5,56(sp)
ffffffffc0201306:	f45e                	sd	s7,40(sp)
ffffffffc0201308:	f062                	sd	s8,32(sp)
ffffffffc020130a:	ec66                	sd	s9,24(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc020130c:	00fb3023          	sd	a5,0(s6)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0201310:	dd1fe0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    pmm_manager->init();
ffffffffc0201314:	000b3783          	ld	a5,0(s6)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0201318:	0000c997          	auipc	s3,0xc
ffffffffc020131c:	1a898993          	addi	s3,s3,424 # ffffffffc020d4c0 <va_pa_offset>
    pmm_manager->init();
ffffffffc0201320:	679c                	ld	a5,8(a5)
ffffffffc0201322:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0201324:	57f5                	li	a5,-3
ffffffffc0201326:	07fa                	slli	a5,a5,0x1e
ffffffffc0201328:	00f9b023          	sd	a5,0(s3)
    uint64_t mem_begin = get_memory_base();
ffffffffc020132c:	d28ff0ef          	jal	ra,ffffffffc0200854 <get_memory_base>
ffffffffc0201330:	892a                	mv	s2,a0
    uint64_t mem_size  = get_memory_size();
ffffffffc0201332:	d2cff0ef          	jal	ra,ffffffffc020085e <get_memory_size>
    if (mem_size == 0) {
ffffffffc0201336:	200505e3          	beqz	a0,ffffffffc0201d40 <pmm_init+0xa66>
    uint64_t mem_end   = mem_begin + mem_size;
ffffffffc020133a:	84aa                	mv	s1,a0
    cprintf("physcial memory map:\n");
ffffffffc020133c:	00003517          	auipc	a0,0x3
ffffffffc0201340:	69c50513          	addi	a0,a0,1692 # ffffffffc02049d8 <commands+0x8b0>
ffffffffc0201344:	d9dfe0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    uint64_t mem_end   = mem_begin + mem_size;
ffffffffc0201348:	00990433          	add	s0,s2,s1
    cprintf("  memory: 0x%08lx, [0x%08lx, 0x%08lx].\n", mem_size, mem_begin,
ffffffffc020134c:	fff40693          	addi	a3,s0,-1
ffffffffc0201350:	864a                	mv	a2,s2
ffffffffc0201352:	85a6                	mv	a1,s1
ffffffffc0201354:	00003517          	auipc	a0,0x3
ffffffffc0201358:	69c50513          	addi	a0,a0,1692 # ffffffffc02049f0 <commands+0x8c8>
ffffffffc020135c:	d85fe0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    npage = maxpa / PGSIZE;
ffffffffc0201360:	c8000737          	lui	a4,0xc8000
ffffffffc0201364:	87a2                	mv	a5,s0
ffffffffc0201366:	54876163          	bltu	a4,s0,ffffffffc02018a8 <pmm_init+0x5ce>
ffffffffc020136a:	757d                	lui	a0,0xfffff
ffffffffc020136c:	0000d617          	auipc	a2,0xd
ffffffffc0201370:	17f60613          	addi	a2,a2,383 # ffffffffc020e4eb <end+0xfff>
ffffffffc0201374:	8e69                	and	a2,a2,a0
ffffffffc0201376:	0000c497          	auipc	s1,0xc
ffffffffc020137a:	13248493          	addi	s1,s1,306 # ffffffffc020d4a8 <npage>
ffffffffc020137e:	00c7d513          	srli	a0,a5,0xc
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0201382:	0000cb97          	auipc	s7,0xc
ffffffffc0201386:	12eb8b93          	addi	s7,s7,302 # ffffffffc020d4b0 <pages>
    npage = maxpa / PGSIZE;
ffffffffc020138a:	e088                	sd	a0,0(s1)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc020138c:	00cbb023          	sd	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0201390:	000807b7          	lui	a5,0x80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0201394:	86b2                	mv	a3,a2
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc0201396:	02f50863          	beq	a0,a5,ffffffffc02013c6 <pmm_init+0xec>
ffffffffc020139a:	4781                	li	a5,0
 *
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void set_bit(int nr, volatile void *addr) {
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc020139c:	4585                	li	a1,1
ffffffffc020139e:	fff806b7          	lui	a3,0xfff80
        SetPageReserved(pages + i);
ffffffffc02013a2:	00679513          	slli	a0,a5,0x6
ffffffffc02013a6:	9532                	add	a0,a0,a2
ffffffffc02013a8:	00850713          	addi	a4,a0,8 # fffffffffffff008 <end+0x3fdf1b1c>
ffffffffc02013ac:	40b7302f          	amoor.d	zero,a1,(a4)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc02013b0:	6088                	ld	a0,0(s1)
ffffffffc02013b2:	0785                	addi	a5,a5,1
        SetPageReserved(pages + i);
ffffffffc02013b4:	000bb603          	ld	a2,0(s7)
    for (size_t i = 0; i < npage - nbase; i++)
ffffffffc02013b8:	00d50733          	add	a4,a0,a3
ffffffffc02013bc:	fee7e3e3          	bltu	a5,a4,ffffffffc02013a2 <pmm_init+0xc8>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02013c0:	071a                	slli	a4,a4,0x6
ffffffffc02013c2:	00e606b3          	add	a3,a2,a4
ffffffffc02013c6:	c02007b7          	lui	a5,0xc0200
ffffffffc02013ca:	2ef6ece3          	bltu	a3,a5,ffffffffc0201ec2 <pmm_init+0xbe8>
ffffffffc02013ce:	0009b583          	ld	a1,0(s3)
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc02013d2:	77fd                	lui	a5,0xfffff
ffffffffc02013d4:	8c7d                	and	s0,s0,a5
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc02013d6:	8e8d                	sub	a3,a3,a1
    if (freemem < mem_end)
ffffffffc02013d8:	5086eb63          	bltu	a3,s0,ffffffffc02018ee <pmm_init+0x614>
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc02013dc:	00003517          	auipc	a0,0x3
ffffffffc02013e0:	66450513          	addi	a0,a0,1636 # ffffffffc0204a40 <commands+0x918>
ffffffffc02013e4:	cfdfe0ef          	jal	ra,ffffffffc02000e0 <cprintf>
}

static void check_alloc_page(void)
{
    pmm_manager->check();
ffffffffc02013e8:	000b3783          	ld	a5,0(s6)
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc02013ec:	0000c917          	auipc	s2,0xc
ffffffffc02013f0:	0b490913          	addi	s2,s2,180 # ffffffffc020d4a0 <boot_pgdir_va>
    pmm_manager->check();
ffffffffc02013f4:	7b9c                	ld	a5,48(a5)
ffffffffc02013f6:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc02013f8:	00003517          	auipc	a0,0x3
ffffffffc02013fc:	66050513          	addi	a0,a0,1632 # ffffffffc0204a58 <commands+0x930>
ffffffffc0201400:	ce1fe0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    boot_pgdir_va = (pte_t *)boot_page_table_sv39;
ffffffffc0201404:	00007697          	auipc	a3,0x7
ffffffffc0201408:	bfc68693          	addi	a3,a3,-1028 # ffffffffc0208000 <boot_page_table_sv39>
ffffffffc020140c:	00d93023          	sd	a3,0(s2)
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc0201410:	c02007b7          	lui	a5,0xc0200
ffffffffc0201414:	28f6ebe3          	bltu	a3,a5,ffffffffc0201eaa <pmm_init+0xbd0>
ffffffffc0201418:	0009b783          	ld	a5,0(s3)
ffffffffc020141c:	8e9d                	sub	a3,a3,a5
ffffffffc020141e:	0000c797          	auipc	a5,0xc
ffffffffc0201422:	06d7bd23          	sd	a3,122(a5) # ffffffffc020d498 <boot_pgdir_pa>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0201426:	100027f3          	csrr	a5,sstatus
ffffffffc020142a:	8b89                	andi	a5,a5,2
ffffffffc020142c:	4a079763          	bnez	a5,ffffffffc02018da <pmm_init+0x600>
        ret = pmm_manager->nr_free_pages();
ffffffffc0201430:	000b3783          	ld	a5,0(s6)
ffffffffc0201434:	779c                	ld	a5,40(a5)
ffffffffc0201436:	9782                	jalr	a5
ffffffffc0201438:	842a                	mv	s0,a0
    // so npage is always larger than KMEMSIZE / PGSIZE
    size_t nr_free_store;

    nr_free_store = nr_free_pages();

    assert(npage <= KERNTOP / PGSIZE);
ffffffffc020143a:	6098                	ld	a4,0(s1)
ffffffffc020143c:	c80007b7          	lui	a5,0xc8000
ffffffffc0201440:	83b1                	srli	a5,a5,0xc
ffffffffc0201442:	66e7e363          	bltu	a5,a4,ffffffffc0201aa8 <pmm_init+0x7ce>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc0201446:	00093503          	ld	a0,0(s2)
ffffffffc020144a:	62050f63          	beqz	a0,ffffffffc0201a88 <pmm_init+0x7ae>
ffffffffc020144e:	03451793          	slli	a5,a0,0x34
ffffffffc0201452:	62079b63          	bnez	a5,ffffffffc0201a88 <pmm_init+0x7ae>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc0201456:	4601                	li	a2,0
ffffffffc0201458:	4581                	li	a1,0
ffffffffc020145a:	c9bff0ef          	jal	ra,ffffffffc02010f4 <get_page>
ffffffffc020145e:	60051563          	bnez	a0,ffffffffc0201a68 <pmm_init+0x78e>
ffffffffc0201462:	100027f3          	csrr	a5,sstatus
ffffffffc0201466:	8b89                	andi	a5,a5,2
ffffffffc0201468:	44079e63          	bnez	a5,ffffffffc02018c4 <pmm_init+0x5ea>
        page = pmm_manager->alloc_pages(n);
ffffffffc020146c:	000b3783          	ld	a5,0(s6)
ffffffffc0201470:	4505                	li	a0,1
ffffffffc0201472:	6f9c                	ld	a5,24(a5)
ffffffffc0201474:	9782                	jalr	a5
ffffffffc0201476:	8a2a                	mv	s4,a0

    struct Page *p1, *p2;
    p1 = alloc_page();
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc0201478:	00093503          	ld	a0,0(s2)
ffffffffc020147c:	4681                	li	a3,0
ffffffffc020147e:	4601                	li	a2,0
ffffffffc0201480:	85d2                	mv	a1,s4
ffffffffc0201482:	d63ff0ef          	jal	ra,ffffffffc02011e4 <page_insert>
ffffffffc0201486:	26051ae3          	bnez	a0,ffffffffc0201efa <pmm_init+0xc20>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc020148a:	00093503          	ld	a0,0(s2)
ffffffffc020148e:	4601                	li	a2,0
ffffffffc0201490:	4581                	li	a1,0
ffffffffc0201492:	a3bff0ef          	jal	ra,ffffffffc0200ecc <get_pte>
ffffffffc0201496:	240502e3          	beqz	a0,ffffffffc0201eda <pmm_init+0xc00>
    assert(pte2page(*ptep) == p1);
ffffffffc020149a:	611c                	ld	a5,0(a0)
    if (!(pte & PTE_V))
ffffffffc020149c:	0017f713          	andi	a4,a5,1
ffffffffc02014a0:	5a070263          	beqz	a4,ffffffffc0201a44 <pmm_init+0x76a>
    if (PPN(pa) >= npage)
ffffffffc02014a4:	6098                	ld	a4,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc02014a6:	078a                	slli	a5,a5,0x2
ffffffffc02014a8:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02014aa:	58e7fb63          	bgeu	a5,a4,ffffffffc0201a40 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc02014ae:	000bb683          	ld	a3,0(s7)
ffffffffc02014b2:	fff80637          	lui	a2,0xfff80
ffffffffc02014b6:	97b2                	add	a5,a5,a2
ffffffffc02014b8:	079a                	slli	a5,a5,0x6
ffffffffc02014ba:	97b6                	add	a5,a5,a3
ffffffffc02014bc:	14fa17e3          	bne	s4,a5,ffffffffc0201e0a <pmm_init+0xb30>
    assert(page_ref(p1) == 1);
ffffffffc02014c0:	000a2683          	lw	a3,0(s4) # 80000 <kern_entry-0xffffffffc0180000>
ffffffffc02014c4:	4785                	li	a5,1
ffffffffc02014c6:	12f692e3          	bne	a3,a5,ffffffffc0201dea <pmm_init+0xb10>

    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc02014ca:	00093503          	ld	a0,0(s2)
ffffffffc02014ce:	77fd                	lui	a5,0xfffff
ffffffffc02014d0:	6114                	ld	a3,0(a0)
ffffffffc02014d2:	068a                	slli	a3,a3,0x2
ffffffffc02014d4:	8efd                	and	a3,a3,a5
ffffffffc02014d6:	00c6d613          	srli	a2,a3,0xc
ffffffffc02014da:	0ee67ce3          	bgeu	a2,a4,ffffffffc0201dd2 <pmm_init+0xaf8>
ffffffffc02014de:	0009bc03          	ld	s8,0(s3)
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc02014e2:	96e2                	add	a3,a3,s8
ffffffffc02014e4:	0006ba83          	ld	s5,0(a3)
ffffffffc02014e8:	0a8a                	slli	s5,s5,0x2
ffffffffc02014ea:	00fafab3          	and	s5,s5,a5
ffffffffc02014ee:	00cad793          	srli	a5,s5,0xc
ffffffffc02014f2:	0ce7f3e3          	bgeu	a5,a4,ffffffffc0201db8 <pmm_init+0xade>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc02014f6:	4601                	li	a2,0
ffffffffc02014f8:	6585                	lui	a1,0x1
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc02014fa:	9ae2                	add	s5,s5,s8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc02014fc:	9d1ff0ef          	jal	ra,ffffffffc0200ecc <get_pte>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0201500:	0aa1                	addi	s5,s5,8
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0201502:	55551363          	bne	a0,s5,ffffffffc0201a48 <pmm_init+0x76e>
ffffffffc0201506:	100027f3          	csrr	a5,sstatus
ffffffffc020150a:	8b89                	andi	a5,a5,2
ffffffffc020150c:	3a079163          	bnez	a5,ffffffffc02018ae <pmm_init+0x5d4>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201510:	000b3783          	ld	a5,0(s6)
ffffffffc0201514:	4505                	li	a0,1
ffffffffc0201516:	6f9c                	ld	a5,24(a5)
ffffffffc0201518:	9782                	jalr	a5
ffffffffc020151a:	8c2a                	mv	s8,a0

    p2 = alloc_page();
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc020151c:	00093503          	ld	a0,0(s2)
ffffffffc0201520:	46d1                	li	a3,20
ffffffffc0201522:	6605                	lui	a2,0x1
ffffffffc0201524:	85e2                	mv	a1,s8
ffffffffc0201526:	cbfff0ef          	jal	ra,ffffffffc02011e4 <page_insert>
ffffffffc020152a:	060517e3          	bnez	a0,ffffffffc0201d98 <pmm_init+0xabe>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc020152e:	00093503          	ld	a0,0(s2)
ffffffffc0201532:	4601                	li	a2,0
ffffffffc0201534:	6585                	lui	a1,0x1
ffffffffc0201536:	997ff0ef          	jal	ra,ffffffffc0200ecc <get_pte>
ffffffffc020153a:	02050fe3          	beqz	a0,ffffffffc0201d78 <pmm_init+0xa9e>
    assert(*ptep & PTE_U);
ffffffffc020153e:	611c                	ld	a5,0(a0)
ffffffffc0201540:	0107f713          	andi	a4,a5,16
ffffffffc0201544:	7c070e63          	beqz	a4,ffffffffc0201d20 <pmm_init+0xa46>
    assert(*ptep & PTE_W);
ffffffffc0201548:	8b91                	andi	a5,a5,4
ffffffffc020154a:	7a078b63          	beqz	a5,ffffffffc0201d00 <pmm_init+0xa26>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc020154e:	00093503          	ld	a0,0(s2)
ffffffffc0201552:	611c                	ld	a5,0(a0)
ffffffffc0201554:	8bc1                	andi	a5,a5,16
ffffffffc0201556:	78078563          	beqz	a5,ffffffffc0201ce0 <pmm_init+0xa06>
    assert(page_ref(p2) == 1);
ffffffffc020155a:	000c2703          	lw	a4,0(s8) # ff0000 <kern_entry-0xffffffffbf210000>
ffffffffc020155e:	4785                	li	a5,1
ffffffffc0201560:	76f71063          	bne	a4,a5,ffffffffc0201cc0 <pmm_init+0x9e6>

    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc0201564:	4681                	li	a3,0
ffffffffc0201566:	6605                	lui	a2,0x1
ffffffffc0201568:	85d2                	mv	a1,s4
ffffffffc020156a:	c7bff0ef          	jal	ra,ffffffffc02011e4 <page_insert>
ffffffffc020156e:	72051963          	bnez	a0,ffffffffc0201ca0 <pmm_init+0x9c6>
    assert(page_ref(p1) == 2);
ffffffffc0201572:	000a2703          	lw	a4,0(s4)
ffffffffc0201576:	4789                	li	a5,2
ffffffffc0201578:	70f71463          	bne	a4,a5,ffffffffc0201c80 <pmm_init+0x9a6>
    assert(page_ref(p2) == 0);
ffffffffc020157c:	000c2783          	lw	a5,0(s8)
ffffffffc0201580:	6e079063          	bnez	a5,ffffffffc0201c60 <pmm_init+0x986>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0201584:	00093503          	ld	a0,0(s2)
ffffffffc0201588:	4601                	li	a2,0
ffffffffc020158a:	6585                	lui	a1,0x1
ffffffffc020158c:	941ff0ef          	jal	ra,ffffffffc0200ecc <get_pte>
ffffffffc0201590:	6a050863          	beqz	a0,ffffffffc0201c40 <pmm_init+0x966>
    assert(pte2page(*ptep) == p1);
ffffffffc0201594:	6118                	ld	a4,0(a0)
    if (!(pte & PTE_V))
ffffffffc0201596:	00177793          	andi	a5,a4,1
ffffffffc020159a:	4a078563          	beqz	a5,ffffffffc0201a44 <pmm_init+0x76a>
    if (PPN(pa) >= npage)
ffffffffc020159e:	6094                	ld	a3,0(s1)
    return pa2page(PTE_ADDR(pte));
ffffffffc02015a0:	00271793          	slli	a5,a4,0x2
ffffffffc02015a4:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc02015a6:	48d7fd63          	bgeu	a5,a3,ffffffffc0201a40 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc02015aa:	000bb683          	ld	a3,0(s7)
ffffffffc02015ae:	fff80ab7          	lui	s5,0xfff80
ffffffffc02015b2:	97d6                	add	a5,a5,s5
ffffffffc02015b4:	079a                	slli	a5,a5,0x6
ffffffffc02015b6:	97b6                	add	a5,a5,a3
ffffffffc02015b8:	66fa1463          	bne	s4,a5,ffffffffc0201c20 <pmm_init+0x946>
    assert((*ptep & PTE_U) == 0);
ffffffffc02015bc:	8b41                	andi	a4,a4,16
ffffffffc02015be:	64071163          	bnez	a4,ffffffffc0201c00 <pmm_init+0x926>

    page_remove(boot_pgdir_va, 0x0);
ffffffffc02015c2:	00093503          	ld	a0,0(s2)
ffffffffc02015c6:	4581                	li	a1,0
ffffffffc02015c8:	b81ff0ef          	jal	ra,ffffffffc0201148 <page_remove>
    assert(page_ref(p1) == 1);
ffffffffc02015cc:	000a2c83          	lw	s9,0(s4)
ffffffffc02015d0:	4785                	li	a5,1
ffffffffc02015d2:	60fc9763          	bne	s9,a5,ffffffffc0201be0 <pmm_init+0x906>
    assert(page_ref(p2) == 0);
ffffffffc02015d6:	000c2783          	lw	a5,0(s8)
ffffffffc02015da:	5e079363          	bnez	a5,ffffffffc0201bc0 <pmm_init+0x8e6>

    page_remove(boot_pgdir_va, PGSIZE);
ffffffffc02015de:	00093503          	ld	a0,0(s2)
ffffffffc02015e2:	6585                	lui	a1,0x1
ffffffffc02015e4:	b65ff0ef          	jal	ra,ffffffffc0201148 <page_remove>
    assert(page_ref(p1) == 0);
ffffffffc02015e8:	000a2783          	lw	a5,0(s4)
ffffffffc02015ec:	52079a63          	bnez	a5,ffffffffc0201b20 <pmm_init+0x846>
    assert(page_ref(p2) == 0);
ffffffffc02015f0:	000c2783          	lw	a5,0(s8)
ffffffffc02015f4:	50079663          	bnez	a5,ffffffffc0201b00 <pmm_init+0x826>

    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc02015f8:	00093a03          	ld	s4,0(s2)
    if (PPN(pa) >= npage)
ffffffffc02015fc:	608c                	ld	a1,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc02015fe:	000a3683          	ld	a3,0(s4)
ffffffffc0201602:	068a                	slli	a3,a3,0x2
ffffffffc0201604:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage)
ffffffffc0201606:	42b6fd63          	bgeu	a3,a1,ffffffffc0201a40 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc020160a:	000bb503          	ld	a0,0(s7)
ffffffffc020160e:	96d6                	add	a3,a3,s5
ffffffffc0201610:	069a                	slli	a3,a3,0x6
    return page->ref;
ffffffffc0201612:	00d507b3          	add	a5,a0,a3
ffffffffc0201616:	439c                	lw	a5,0(a5)
ffffffffc0201618:	4d979463          	bne	a5,s9,ffffffffc0201ae0 <pmm_init+0x806>
    return page - pages + nbase;
ffffffffc020161c:	8699                	srai	a3,a3,0x6
ffffffffc020161e:	00080637          	lui	a2,0x80
ffffffffc0201622:	96b2                	add	a3,a3,a2
    return KADDR(page2pa(page));
ffffffffc0201624:	00c69713          	slli	a4,a3,0xc
ffffffffc0201628:	8331                	srli	a4,a4,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc020162a:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc020162c:	48b77e63          	bgeu	a4,a1,ffffffffc0201ac8 <pmm_init+0x7ee>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
    free_page(pde2page(pd0[0]));
ffffffffc0201630:	0009b703          	ld	a4,0(s3)
ffffffffc0201634:	96ba                	add	a3,a3,a4
    return pa2page(PDE_ADDR(pde));
ffffffffc0201636:	629c                	ld	a5,0(a3)
ffffffffc0201638:	078a                	slli	a5,a5,0x2
ffffffffc020163a:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc020163c:	40b7f263          	bgeu	a5,a1,ffffffffc0201a40 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0201640:	8f91                	sub	a5,a5,a2
ffffffffc0201642:	079a                	slli	a5,a5,0x6
ffffffffc0201644:	953e                	add	a0,a0,a5
ffffffffc0201646:	100027f3          	csrr	a5,sstatus
ffffffffc020164a:	8b89                	andi	a5,a5,2
ffffffffc020164c:	30079963          	bnez	a5,ffffffffc020195e <pmm_init+0x684>
        pmm_manager->free_pages(base, n);
ffffffffc0201650:	000b3783          	ld	a5,0(s6)
ffffffffc0201654:	4585                	li	a1,1
ffffffffc0201656:	739c                	ld	a5,32(a5)
ffffffffc0201658:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc020165a:	000a3783          	ld	a5,0(s4)
    if (PPN(pa) >= npage)
ffffffffc020165e:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0201660:	078a                	slli	a5,a5,0x2
ffffffffc0201662:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0201664:	3ce7fe63          	bgeu	a5,a4,ffffffffc0201a40 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc0201668:	000bb503          	ld	a0,0(s7)
ffffffffc020166c:	fff80737          	lui	a4,0xfff80
ffffffffc0201670:	97ba                	add	a5,a5,a4
ffffffffc0201672:	079a                	slli	a5,a5,0x6
ffffffffc0201674:	953e                	add	a0,a0,a5
ffffffffc0201676:	100027f3          	csrr	a5,sstatus
ffffffffc020167a:	8b89                	andi	a5,a5,2
ffffffffc020167c:	2c079563          	bnez	a5,ffffffffc0201946 <pmm_init+0x66c>
ffffffffc0201680:	000b3783          	ld	a5,0(s6)
ffffffffc0201684:	4585                	li	a1,1
ffffffffc0201686:	739c                	ld	a5,32(a5)
ffffffffc0201688:	9782                	jalr	a5
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc020168a:	00093783          	ld	a5,0(s2)
ffffffffc020168e:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fdf1b14>
    asm volatile("sfence.vma");
ffffffffc0201692:	12000073          	sfence.vma
ffffffffc0201696:	100027f3          	csrr	a5,sstatus
ffffffffc020169a:	8b89                	andi	a5,a5,2
ffffffffc020169c:	28079b63          	bnez	a5,ffffffffc0201932 <pmm_init+0x658>
        ret = pmm_manager->nr_free_pages();
ffffffffc02016a0:	000b3783          	ld	a5,0(s6)
ffffffffc02016a4:	779c                	ld	a5,40(a5)
ffffffffc02016a6:	9782                	jalr	a5
ffffffffc02016a8:	8a2a                	mv	s4,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc02016aa:	4b441b63          	bne	s0,s4,ffffffffc0201b60 <pmm_init+0x886>

    cprintf("check_pgdir() succeeded!\n");
ffffffffc02016ae:	00003517          	auipc	a0,0x3
ffffffffc02016b2:	6ea50513          	addi	a0,a0,1770 # ffffffffc0204d98 <commands+0xc70>
ffffffffc02016b6:	a2bfe0ef          	jal	ra,ffffffffc02000e0 <cprintf>
ffffffffc02016ba:	100027f3          	csrr	a5,sstatus
ffffffffc02016be:	8b89                	andi	a5,a5,2
ffffffffc02016c0:	24079f63          	bnez	a5,ffffffffc020191e <pmm_init+0x644>
        ret = pmm_manager->nr_free_pages();
ffffffffc02016c4:	000b3783          	ld	a5,0(s6)
ffffffffc02016c8:	779c                	ld	a5,40(a5)
ffffffffc02016ca:	9782                	jalr	a5
ffffffffc02016cc:	8c2a                	mv	s8,a0
    pte_t *ptep;
    int i;

    nr_free_store = nr_free_pages();

    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc02016ce:	6098                	ld	a4,0(s1)
ffffffffc02016d0:	c0200437          	lui	s0,0xc0200
    {
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
ffffffffc02016d4:	7afd                	lui	s5,0xfffff
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc02016d6:	00c71793          	slli	a5,a4,0xc
ffffffffc02016da:	6a05                	lui	s4,0x1
ffffffffc02016dc:	02f47c63          	bgeu	s0,a5,ffffffffc0201714 <pmm_init+0x43a>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc02016e0:	00c45793          	srli	a5,s0,0xc
ffffffffc02016e4:	00093503          	ld	a0,0(s2)
ffffffffc02016e8:	2ee7ff63          	bgeu	a5,a4,ffffffffc02019e6 <pmm_init+0x70c>
ffffffffc02016ec:	0009b583          	ld	a1,0(s3)
ffffffffc02016f0:	4601                	li	a2,0
ffffffffc02016f2:	95a2                	add	a1,a1,s0
ffffffffc02016f4:	fd8ff0ef          	jal	ra,ffffffffc0200ecc <get_pte>
ffffffffc02016f8:	32050463          	beqz	a0,ffffffffc0201a20 <pmm_init+0x746>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc02016fc:	611c                	ld	a5,0(a0)
ffffffffc02016fe:	078a                	slli	a5,a5,0x2
ffffffffc0201700:	0157f7b3          	and	a5,a5,s5
ffffffffc0201704:	2e879e63          	bne	a5,s0,ffffffffc0201a00 <pmm_init+0x726>
    for (i = ROUNDDOWN(KERNBASE, PGSIZE); i < npage * PGSIZE; i += PGSIZE)
ffffffffc0201708:	6098                	ld	a4,0(s1)
ffffffffc020170a:	9452                	add	s0,s0,s4
ffffffffc020170c:	00c71793          	slli	a5,a4,0xc
ffffffffc0201710:	fcf468e3          	bltu	s0,a5,ffffffffc02016e0 <pmm_init+0x406>
    }

    assert(boot_pgdir_va[0] == 0);
ffffffffc0201714:	00093783          	ld	a5,0(s2)
ffffffffc0201718:	639c                	ld	a5,0(a5)
ffffffffc020171a:	42079363          	bnez	a5,ffffffffc0201b40 <pmm_init+0x866>
ffffffffc020171e:	100027f3          	csrr	a5,sstatus
ffffffffc0201722:	8b89                	andi	a5,a5,2
ffffffffc0201724:	24079963          	bnez	a5,ffffffffc0201976 <pmm_init+0x69c>
        page = pmm_manager->alloc_pages(n);
ffffffffc0201728:	000b3783          	ld	a5,0(s6)
ffffffffc020172c:	4505                	li	a0,1
ffffffffc020172e:	6f9c                	ld	a5,24(a5)
ffffffffc0201730:	9782                	jalr	a5
ffffffffc0201732:	8a2a                	mv	s4,a0

    struct Page *p;
    p = alloc_page();
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0201734:	00093503          	ld	a0,0(s2)
ffffffffc0201738:	4699                	li	a3,6
ffffffffc020173a:	10000613          	li	a2,256
ffffffffc020173e:	85d2                	mv	a1,s4
ffffffffc0201740:	aa5ff0ef          	jal	ra,ffffffffc02011e4 <page_insert>
ffffffffc0201744:	44051e63          	bnez	a0,ffffffffc0201ba0 <pmm_init+0x8c6>
    assert(page_ref(p) == 1);
ffffffffc0201748:	000a2703          	lw	a4,0(s4) # 1000 <kern_entry-0xffffffffc01ff000>
ffffffffc020174c:	4785                	li	a5,1
ffffffffc020174e:	42f71963          	bne	a4,a5,ffffffffc0201b80 <pmm_init+0x8a6>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0201752:	00093503          	ld	a0,0(s2)
ffffffffc0201756:	6405                	lui	s0,0x1
ffffffffc0201758:	4699                	li	a3,6
ffffffffc020175a:	10040613          	addi	a2,s0,256 # 1100 <kern_entry-0xffffffffc01fef00>
ffffffffc020175e:	85d2                	mv	a1,s4
ffffffffc0201760:	a85ff0ef          	jal	ra,ffffffffc02011e4 <page_insert>
ffffffffc0201764:	72051363          	bnez	a0,ffffffffc0201e8a <pmm_init+0xbb0>
    assert(page_ref(p) == 2);
ffffffffc0201768:	000a2703          	lw	a4,0(s4)
ffffffffc020176c:	4789                	li	a5,2
ffffffffc020176e:	6ef71e63          	bne	a4,a5,ffffffffc0201e6a <pmm_init+0xb90>

    const char *str = "ucore: Hello world!!";
    strcpy((void *)0x100, str);
ffffffffc0201772:	00003597          	auipc	a1,0x3
ffffffffc0201776:	76e58593          	addi	a1,a1,1902 # ffffffffc0204ee0 <commands+0xdb8>
ffffffffc020177a:	10000513          	li	a0,256
ffffffffc020177e:	264020ef          	jal	ra,ffffffffc02039e2 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0201782:	10040593          	addi	a1,s0,256
ffffffffc0201786:	10000513          	li	a0,256
ffffffffc020178a:	26a020ef          	jal	ra,ffffffffc02039f4 <strcmp>
ffffffffc020178e:	6a051e63          	bnez	a0,ffffffffc0201e4a <pmm_init+0xb70>
    return page - pages + nbase;
ffffffffc0201792:	000bb683          	ld	a3,0(s7)
ffffffffc0201796:	00080737          	lui	a4,0x80
    return KADDR(page2pa(page));
ffffffffc020179a:	547d                	li	s0,-1
    return page - pages + nbase;
ffffffffc020179c:	40da06b3          	sub	a3,s4,a3
ffffffffc02017a0:	8699                	srai	a3,a3,0x6
    return KADDR(page2pa(page));
ffffffffc02017a2:	609c                	ld	a5,0(s1)
    return page - pages + nbase;
ffffffffc02017a4:	96ba                	add	a3,a3,a4
    return KADDR(page2pa(page));
ffffffffc02017a6:	8031                	srli	s0,s0,0xc
ffffffffc02017a8:	0086f733          	and	a4,a3,s0
    return page2ppn(page) << PGSHIFT;
ffffffffc02017ac:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02017ae:	30f77d63          	bgeu	a4,a5,ffffffffc0201ac8 <pmm_init+0x7ee>

    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc02017b2:	0009b783          	ld	a5,0(s3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc02017b6:	10000513          	li	a0,256
    *(char *)(page2kva(p) + 0x100) = '\0';
ffffffffc02017ba:	96be                	add	a3,a3,a5
ffffffffc02017bc:	10068023          	sb	zero,256(a3)
    assert(strlen((const char *)0x100) == 0);
ffffffffc02017c0:	1ec020ef          	jal	ra,ffffffffc02039ac <strlen>
ffffffffc02017c4:	66051363          	bnez	a0,ffffffffc0201e2a <pmm_init+0xb50>

    pde_t *pd1 = boot_pgdir_va, *pd0 = page2kva(pde2page(boot_pgdir_va[0]));
ffffffffc02017c8:	00093a83          	ld	s5,0(s2)
    if (PPN(pa) >= npage)
ffffffffc02017cc:	609c                	ld	a5,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc02017ce:	000ab683          	ld	a3,0(s5) # fffffffffffff000 <end+0x3fdf1b14>
ffffffffc02017d2:	068a                	slli	a3,a3,0x2
ffffffffc02017d4:	82b1                	srli	a3,a3,0xc
    if (PPN(pa) >= npage)
ffffffffc02017d6:	26f6f563          	bgeu	a3,a5,ffffffffc0201a40 <pmm_init+0x766>
    return KADDR(page2pa(page));
ffffffffc02017da:	8c75                	and	s0,s0,a3
    return page2ppn(page) << PGSHIFT;
ffffffffc02017dc:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc02017de:	2ef47563          	bgeu	s0,a5,ffffffffc0201ac8 <pmm_init+0x7ee>
ffffffffc02017e2:	0009b403          	ld	s0,0(s3)
ffffffffc02017e6:	9436                	add	s0,s0,a3
ffffffffc02017e8:	100027f3          	csrr	a5,sstatus
ffffffffc02017ec:	8b89                	andi	a5,a5,2
ffffffffc02017ee:	1e079163          	bnez	a5,ffffffffc02019d0 <pmm_init+0x6f6>
        pmm_manager->free_pages(base, n);
ffffffffc02017f2:	000b3783          	ld	a5,0(s6)
ffffffffc02017f6:	4585                	li	a1,1
ffffffffc02017f8:	8552                	mv	a0,s4
ffffffffc02017fa:	739c                	ld	a5,32(a5)
ffffffffc02017fc:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc02017fe:	601c                	ld	a5,0(s0)
    if (PPN(pa) >= npage)
ffffffffc0201800:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0201802:	078a                	slli	a5,a5,0x2
ffffffffc0201804:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0201806:	22e7fd63          	bgeu	a5,a4,ffffffffc0201a40 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc020180a:	000bb503          	ld	a0,0(s7)
ffffffffc020180e:	fff80737          	lui	a4,0xfff80
ffffffffc0201812:	97ba                	add	a5,a5,a4
ffffffffc0201814:	079a                	slli	a5,a5,0x6
ffffffffc0201816:	953e                	add	a0,a0,a5
ffffffffc0201818:	100027f3          	csrr	a5,sstatus
ffffffffc020181c:	8b89                	andi	a5,a5,2
ffffffffc020181e:	18079d63          	bnez	a5,ffffffffc02019b8 <pmm_init+0x6de>
ffffffffc0201822:	000b3783          	ld	a5,0(s6)
ffffffffc0201826:	4585                	li	a1,1
ffffffffc0201828:	739c                	ld	a5,32(a5)
ffffffffc020182a:	9782                	jalr	a5
    return pa2page(PDE_ADDR(pde));
ffffffffc020182c:	000ab783          	ld	a5,0(s5)
    if (PPN(pa) >= npage)
ffffffffc0201830:	6098                	ld	a4,0(s1)
    return pa2page(PDE_ADDR(pde));
ffffffffc0201832:	078a                	slli	a5,a5,0x2
ffffffffc0201834:	83b1                	srli	a5,a5,0xc
    if (PPN(pa) >= npage)
ffffffffc0201836:	20e7f563          	bgeu	a5,a4,ffffffffc0201a40 <pmm_init+0x766>
    return &pages[PPN(pa) - nbase];
ffffffffc020183a:	000bb503          	ld	a0,0(s7)
ffffffffc020183e:	fff80737          	lui	a4,0xfff80
ffffffffc0201842:	97ba                	add	a5,a5,a4
ffffffffc0201844:	079a                	slli	a5,a5,0x6
ffffffffc0201846:	953e                	add	a0,a0,a5
ffffffffc0201848:	100027f3          	csrr	a5,sstatus
ffffffffc020184c:	8b89                	andi	a5,a5,2
ffffffffc020184e:	14079963          	bnez	a5,ffffffffc02019a0 <pmm_init+0x6c6>
ffffffffc0201852:	000b3783          	ld	a5,0(s6)
ffffffffc0201856:	4585                	li	a1,1
ffffffffc0201858:	739c                	ld	a5,32(a5)
ffffffffc020185a:	9782                	jalr	a5
    free_page(p);
    free_page(pde2page(pd0[0]));
    free_page(pde2page(pd1[0]));
    boot_pgdir_va[0] = 0;
ffffffffc020185c:	00093783          	ld	a5,0(s2)
ffffffffc0201860:	0007b023          	sd	zero,0(a5)
    asm volatile("sfence.vma");
ffffffffc0201864:	12000073          	sfence.vma
ffffffffc0201868:	100027f3          	csrr	a5,sstatus
ffffffffc020186c:	8b89                	andi	a5,a5,2
ffffffffc020186e:	10079f63          	bnez	a5,ffffffffc020198c <pmm_init+0x6b2>
        ret = pmm_manager->nr_free_pages();
ffffffffc0201872:	000b3783          	ld	a5,0(s6)
ffffffffc0201876:	779c                	ld	a5,40(a5)
ffffffffc0201878:	9782                	jalr	a5
ffffffffc020187a:	842a                	mv	s0,a0
    flush_tlb();

    assert(nr_free_store == nr_free_pages());
ffffffffc020187c:	4c8c1e63          	bne	s8,s0,ffffffffc0201d58 <pmm_init+0xa7e>

    cprintf("check_boot_pgdir() succeeded!\n");
ffffffffc0201880:	00003517          	auipc	a0,0x3
ffffffffc0201884:	6d850513          	addi	a0,a0,1752 # ffffffffc0204f58 <commands+0xe30>
ffffffffc0201888:	859fe0ef          	jal	ra,ffffffffc02000e0 <cprintf>
}
ffffffffc020188c:	7406                	ld	s0,96(sp)
ffffffffc020188e:	70a6                	ld	ra,104(sp)
ffffffffc0201890:	64e6                	ld	s1,88(sp)
ffffffffc0201892:	6946                	ld	s2,80(sp)
ffffffffc0201894:	69a6                	ld	s3,72(sp)
ffffffffc0201896:	6a06                	ld	s4,64(sp)
ffffffffc0201898:	7ae2                	ld	s5,56(sp)
ffffffffc020189a:	7b42                	ld	s6,48(sp)
ffffffffc020189c:	7ba2                	ld	s7,40(sp)
ffffffffc020189e:	7c02                	ld	s8,32(sp)
ffffffffc02018a0:	6ce2                	ld	s9,24(sp)
ffffffffc02018a2:	6165                	addi	sp,sp,112
    kmalloc_init();
ffffffffc02018a4:	4ef0006f          	j	ffffffffc0202592 <kmalloc_init>
    npage = maxpa / PGSIZE;
ffffffffc02018a8:	c80007b7          	lui	a5,0xc8000
ffffffffc02018ac:	bc7d                	j	ffffffffc020136a <pmm_init+0x90>
        intr_disable();
ffffffffc02018ae:	888ff0ef          	jal	ra,ffffffffc0200936 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc02018b2:	000b3783          	ld	a5,0(s6)
ffffffffc02018b6:	4505                	li	a0,1
ffffffffc02018b8:	6f9c                	ld	a5,24(a5)
ffffffffc02018ba:	9782                	jalr	a5
ffffffffc02018bc:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc02018be:	872ff0ef          	jal	ra,ffffffffc0200930 <intr_enable>
ffffffffc02018c2:	b9a9                	j	ffffffffc020151c <pmm_init+0x242>
        intr_disable();
ffffffffc02018c4:	872ff0ef          	jal	ra,ffffffffc0200936 <intr_disable>
ffffffffc02018c8:	000b3783          	ld	a5,0(s6)
ffffffffc02018cc:	4505                	li	a0,1
ffffffffc02018ce:	6f9c                	ld	a5,24(a5)
ffffffffc02018d0:	9782                	jalr	a5
ffffffffc02018d2:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc02018d4:	85cff0ef          	jal	ra,ffffffffc0200930 <intr_enable>
ffffffffc02018d8:	b645                	j	ffffffffc0201478 <pmm_init+0x19e>
        intr_disable();
ffffffffc02018da:	85cff0ef          	jal	ra,ffffffffc0200936 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc02018de:	000b3783          	ld	a5,0(s6)
ffffffffc02018e2:	779c                	ld	a5,40(a5)
ffffffffc02018e4:	9782                	jalr	a5
ffffffffc02018e6:	842a                	mv	s0,a0
        intr_enable();
ffffffffc02018e8:	848ff0ef          	jal	ra,ffffffffc0200930 <intr_enable>
ffffffffc02018ec:	b6b9                	j	ffffffffc020143a <pmm_init+0x160>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc02018ee:	6705                	lui	a4,0x1
ffffffffc02018f0:	177d                	addi	a4,a4,-1
ffffffffc02018f2:	96ba                	add	a3,a3,a4
ffffffffc02018f4:	8ff5                	and	a5,a5,a3
    if (PPN(pa) >= npage)
ffffffffc02018f6:	00c7d713          	srli	a4,a5,0xc
ffffffffc02018fa:	14a77363          	bgeu	a4,a0,ffffffffc0201a40 <pmm_init+0x766>
    pmm_manager->init_memmap(base, n);
ffffffffc02018fe:	000b3683          	ld	a3,0(s6)
    return &pages[PPN(pa) - nbase];
ffffffffc0201902:	fff80537          	lui	a0,0xfff80
ffffffffc0201906:	972a                	add	a4,a4,a0
ffffffffc0201908:	6a94                	ld	a3,16(a3)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc020190a:	8c1d                	sub	s0,s0,a5
ffffffffc020190c:	00671513          	slli	a0,a4,0x6
    pmm_manager->init_memmap(base, n);
ffffffffc0201910:	00c45593          	srli	a1,s0,0xc
ffffffffc0201914:	9532                	add	a0,a0,a2
ffffffffc0201916:	9682                	jalr	a3
    cprintf("vapaofset is %llu\n", va_pa_offset);
ffffffffc0201918:	0009b583          	ld	a1,0(s3)
}
ffffffffc020191c:	b4c1                	j	ffffffffc02013dc <pmm_init+0x102>
        intr_disable();
ffffffffc020191e:	818ff0ef          	jal	ra,ffffffffc0200936 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0201922:	000b3783          	ld	a5,0(s6)
ffffffffc0201926:	779c                	ld	a5,40(a5)
ffffffffc0201928:	9782                	jalr	a5
ffffffffc020192a:	8c2a                	mv	s8,a0
        intr_enable();
ffffffffc020192c:	804ff0ef          	jal	ra,ffffffffc0200930 <intr_enable>
ffffffffc0201930:	bb79                	j	ffffffffc02016ce <pmm_init+0x3f4>
        intr_disable();
ffffffffc0201932:	804ff0ef          	jal	ra,ffffffffc0200936 <intr_disable>
ffffffffc0201936:	000b3783          	ld	a5,0(s6)
ffffffffc020193a:	779c                	ld	a5,40(a5)
ffffffffc020193c:	9782                	jalr	a5
ffffffffc020193e:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0201940:	ff1fe0ef          	jal	ra,ffffffffc0200930 <intr_enable>
ffffffffc0201944:	b39d                	j	ffffffffc02016aa <pmm_init+0x3d0>
ffffffffc0201946:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0201948:	feffe0ef          	jal	ra,ffffffffc0200936 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc020194c:	000b3783          	ld	a5,0(s6)
ffffffffc0201950:	6522                	ld	a0,8(sp)
ffffffffc0201952:	4585                	li	a1,1
ffffffffc0201954:	739c                	ld	a5,32(a5)
ffffffffc0201956:	9782                	jalr	a5
        intr_enable();
ffffffffc0201958:	fd9fe0ef          	jal	ra,ffffffffc0200930 <intr_enable>
ffffffffc020195c:	b33d                	j	ffffffffc020168a <pmm_init+0x3b0>
ffffffffc020195e:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc0201960:	fd7fe0ef          	jal	ra,ffffffffc0200936 <intr_disable>
ffffffffc0201964:	000b3783          	ld	a5,0(s6)
ffffffffc0201968:	6522                	ld	a0,8(sp)
ffffffffc020196a:	4585                	li	a1,1
ffffffffc020196c:	739c                	ld	a5,32(a5)
ffffffffc020196e:	9782                	jalr	a5
        intr_enable();
ffffffffc0201970:	fc1fe0ef          	jal	ra,ffffffffc0200930 <intr_enable>
ffffffffc0201974:	b1dd                	j	ffffffffc020165a <pmm_init+0x380>
        intr_disable();
ffffffffc0201976:	fc1fe0ef          	jal	ra,ffffffffc0200936 <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc020197a:	000b3783          	ld	a5,0(s6)
ffffffffc020197e:	4505                	li	a0,1
ffffffffc0201980:	6f9c                	ld	a5,24(a5)
ffffffffc0201982:	9782                	jalr	a5
ffffffffc0201984:	8a2a                	mv	s4,a0
        intr_enable();
ffffffffc0201986:	fabfe0ef          	jal	ra,ffffffffc0200930 <intr_enable>
ffffffffc020198a:	b36d                	j	ffffffffc0201734 <pmm_init+0x45a>
        intr_disable();
ffffffffc020198c:	fabfe0ef          	jal	ra,ffffffffc0200936 <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0201990:	000b3783          	ld	a5,0(s6)
ffffffffc0201994:	779c                	ld	a5,40(a5)
ffffffffc0201996:	9782                	jalr	a5
ffffffffc0201998:	842a                	mv	s0,a0
        intr_enable();
ffffffffc020199a:	f97fe0ef          	jal	ra,ffffffffc0200930 <intr_enable>
ffffffffc020199e:	bdf9                	j	ffffffffc020187c <pmm_init+0x5a2>
ffffffffc02019a0:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02019a2:	f95fe0ef          	jal	ra,ffffffffc0200936 <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc02019a6:	000b3783          	ld	a5,0(s6)
ffffffffc02019aa:	6522                	ld	a0,8(sp)
ffffffffc02019ac:	4585                	li	a1,1
ffffffffc02019ae:	739c                	ld	a5,32(a5)
ffffffffc02019b0:	9782                	jalr	a5
        intr_enable();
ffffffffc02019b2:	f7ffe0ef          	jal	ra,ffffffffc0200930 <intr_enable>
ffffffffc02019b6:	b55d                	j	ffffffffc020185c <pmm_init+0x582>
ffffffffc02019b8:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02019ba:	f7dfe0ef          	jal	ra,ffffffffc0200936 <intr_disable>
ffffffffc02019be:	000b3783          	ld	a5,0(s6)
ffffffffc02019c2:	6522                	ld	a0,8(sp)
ffffffffc02019c4:	4585                	li	a1,1
ffffffffc02019c6:	739c                	ld	a5,32(a5)
ffffffffc02019c8:	9782                	jalr	a5
        intr_enable();
ffffffffc02019ca:	f67fe0ef          	jal	ra,ffffffffc0200930 <intr_enable>
ffffffffc02019ce:	bdb9                	j	ffffffffc020182c <pmm_init+0x552>
        intr_disable();
ffffffffc02019d0:	f67fe0ef          	jal	ra,ffffffffc0200936 <intr_disable>
ffffffffc02019d4:	000b3783          	ld	a5,0(s6)
ffffffffc02019d8:	4585                	li	a1,1
ffffffffc02019da:	8552                	mv	a0,s4
ffffffffc02019dc:	739c                	ld	a5,32(a5)
ffffffffc02019de:	9782                	jalr	a5
        intr_enable();
ffffffffc02019e0:	f51fe0ef          	jal	ra,ffffffffc0200930 <intr_enable>
ffffffffc02019e4:	bd29                	j	ffffffffc02017fe <pmm_init+0x524>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc02019e6:	86a2                	mv	a3,s0
ffffffffc02019e8:	00003617          	auipc	a2,0x3
ffffffffc02019ec:	f8060613          	addi	a2,a2,-128 # ffffffffc0204968 <commands+0x840>
ffffffffc02019f0:	1a400593          	li	a1,420
ffffffffc02019f4:	00003517          	auipc	a0,0x3
ffffffffc02019f8:	f9c50513          	addi	a0,a0,-100 # ffffffffc0204990 <commands+0x868>
ffffffffc02019fc:	fe2fe0ef          	jal	ra,ffffffffc02001de <__panic>
        assert(PTE_ADDR(*ptep) == i);
ffffffffc0201a00:	00003697          	auipc	a3,0x3
ffffffffc0201a04:	3f868693          	addi	a3,a3,1016 # ffffffffc0204df8 <commands+0xcd0>
ffffffffc0201a08:	00003617          	auipc	a2,0x3
ffffffffc0201a0c:	09060613          	addi	a2,a2,144 # ffffffffc0204a98 <commands+0x970>
ffffffffc0201a10:	1a500593          	li	a1,421
ffffffffc0201a14:	00003517          	auipc	a0,0x3
ffffffffc0201a18:	f7c50513          	addi	a0,a0,-132 # ffffffffc0204990 <commands+0x868>
ffffffffc0201a1c:	fc2fe0ef          	jal	ra,ffffffffc02001de <__panic>
        assert((ptep = get_pte(boot_pgdir_va, (uintptr_t)KADDR(i), 0)) != NULL);
ffffffffc0201a20:	00003697          	auipc	a3,0x3
ffffffffc0201a24:	39868693          	addi	a3,a3,920 # ffffffffc0204db8 <commands+0xc90>
ffffffffc0201a28:	00003617          	auipc	a2,0x3
ffffffffc0201a2c:	07060613          	addi	a2,a2,112 # ffffffffc0204a98 <commands+0x970>
ffffffffc0201a30:	1a400593          	li	a1,420
ffffffffc0201a34:	00003517          	auipc	a0,0x3
ffffffffc0201a38:	f5c50513          	addi	a0,a0,-164 # ffffffffc0204990 <commands+0x868>
ffffffffc0201a3c:	fa2fe0ef          	jal	ra,ffffffffc02001de <__panic>
ffffffffc0201a40:	b9eff0ef          	jal	ra,ffffffffc0200dde <pa2page.part.0>
ffffffffc0201a44:	bb6ff0ef          	jal	ra,ffffffffc0200dfa <pte2page.part.0>
    assert(get_pte(boot_pgdir_va, PGSIZE, 0) == ptep);
ffffffffc0201a48:	00003697          	auipc	a3,0x3
ffffffffc0201a4c:	16868693          	addi	a3,a3,360 # ffffffffc0204bb0 <commands+0xa88>
ffffffffc0201a50:	00003617          	auipc	a2,0x3
ffffffffc0201a54:	04860613          	addi	a2,a2,72 # ffffffffc0204a98 <commands+0x970>
ffffffffc0201a58:	17400593          	li	a1,372
ffffffffc0201a5c:	00003517          	auipc	a0,0x3
ffffffffc0201a60:	f3450513          	addi	a0,a0,-204 # ffffffffc0204990 <commands+0x868>
ffffffffc0201a64:	f7afe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(get_page(boot_pgdir_va, 0x0, NULL) == NULL);
ffffffffc0201a68:	00003697          	auipc	a3,0x3
ffffffffc0201a6c:	08868693          	addi	a3,a3,136 # ffffffffc0204af0 <commands+0x9c8>
ffffffffc0201a70:	00003617          	auipc	a2,0x3
ffffffffc0201a74:	02860613          	addi	a2,a2,40 # ffffffffc0204a98 <commands+0x970>
ffffffffc0201a78:	16700593          	li	a1,359
ffffffffc0201a7c:	00003517          	auipc	a0,0x3
ffffffffc0201a80:	f1450513          	addi	a0,a0,-236 # ffffffffc0204990 <commands+0x868>
ffffffffc0201a84:	f5afe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(boot_pgdir_va != NULL && (uint32_t)PGOFF(boot_pgdir_va) == 0);
ffffffffc0201a88:	00003697          	auipc	a3,0x3
ffffffffc0201a8c:	02868693          	addi	a3,a3,40 # ffffffffc0204ab0 <commands+0x988>
ffffffffc0201a90:	00003617          	auipc	a2,0x3
ffffffffc0201a94:	00860613          	addi	a2,a2,8 # ffffffffc0204a98 <commands+0x970>
ffffffffc0201a98:	16600593          	li	a1,358
ffffffffc0201a9c:	00003517          	auipc	a0,0x3
ffffffffc0201aa0:	ef450513          	addi	a0,a0,-268 # ffffffffc0204990 <commands+0x868>
ffffffffc0201aa4:	f3afe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(npage <= KERNTOP / PGSIZE);
ffffffffc0201aa8:	00003697          	auipc	a3,0x3
ffffffffc0201aac:	fd068693          	addi	a3,a3,-48 # ffffffffc0204a78 <commands+0x950>
ffffffffc0201ab0:	00003617          	auipc	a2,0x3
ffffffffc0201ab4:	fe860613          	addi	a2,a2,-24 # ffffffffc0204a98 <commands+0x970>
ffffffffc0201ab8:	16500593          	li	a1,357
ffffffffc0201abc:	00003517          	auipc	a0,0x3
ffffffffc0201ac0:	ed450513          	addi	a0,a0,-300 # ffffffffc0204990 <commands+0x868>
ffffffffc0201ac4:	f1afe0ef          	jal	ra,ffffffffc02001de <__panic>
    return KADDR(page2pa(page));
ffffffffc0201ac8:	00003617          	auipc	a2,0x3
ffffffffc0201acc:	ea060613          	addi	a2,a2,-352 # ffffffffc0204968 <commands+0x840>
ffffffffc0201ad0:	07100593          	li	a1,113
ffffffffc0201ad4:	00003517          	auipc	a0,0x3
ffffffffc0201ad8:	e5c50513          	addi	a0,a0,-420 # ffffffffc0204930 <commands+0x808>
ffffffffc0201adc:	f02fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(page_ref(pde2page(boot_pgdir_va[0])) == 1);
ffffffffc0201ae0:	00003697          	auipc	a3,0x3
ffffffffc0201ae4:	26068693          	addi	a3,a3,608 # ffffffffc0204d40 <commands+0xc18>
ffffffffc0201ae8:	00003617          	auipc	a2,0x3
ffffffffc0201aec:	fb060613          	addi	a2,a2,-80 # ffffffffc0204a98 <commands+0x970>
ffffffffc0201af0:	18d00593          	li	a1,397
ffffffffc0201af4:	00003517          	auipc	a0,0x3
ffffffffc0201af8:	e9c50513          	addi	a0,a0,-356 # ffffffffc0204990 <commands+0x868>
ffffffffc0201afc:	ee2fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0201b00:	00003697          	auipc	a3,0x3
ffffffffc0201b04:	1f868693          	addi	a3,a3,504 # ffffffffc0204cf8 <commands+0xbd0>
ffffffffc0201b08:	00003617          	auipc	a2,0x3
ffffffffc0201b0c:	f9060613          	addi	a2,a2,-112 # ffffffffc0204a98 <commands+0x970>
ffffffffc0201b10:	18b00593          	li	a1,395
ffffffffc0201b14:	00003517          	auipc	a0,0x3
ffffffffc0201b18:	e7c50513          	addi	a0,a0,-388 # ffffffffc0204990 <commands+0x868>
ffffffffc0201b1c:	ec2fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(page_ref(p1) == 0);
ffffffffc0201b20:	00003697          	auipc	a3,0x3
ffffffffc0201b24:	20868693          	addi	a3,a3,520 # ffffffffc0204d28 <commands+0xc00>
ffffffffc0201b28:	00003617          	auipc	a2,0x3
ffffffffc0201b2c:	f7060613          	addi	a2,a2,-144 # ffffffffc0204a98 <commands+0x970>
ffffffffc0201b30:	18a00593          	li	a1,394
ffffffffc0201b34:	00003517          	auipc	a0,0x3
ffffffffc0201b38:	e5c50513          	addi	a0,a0,-420 # ffffffffc0204990 <commands+0x868>
ffffffffc0201b3c:	ea2fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(boot_pgdir_va[0] == 0);
ffffffffc0201b40:	00003697          	auipc	a3,0x3
ffffffffc0201b44:	2d068693          	addi	a3,a3,720 # ffffffffc0204e10 <commands+0xce8>
ffffffffc0201b48:	00003617          	auipc	a2,0x3
ffffffffc0201b4c:	f5060613          	addi	a2,a2,-176 # ffffffffc0204a98 <commands+0x970>
ffffffffc0201b50:	1a800593          	li	a1,424
ffffffffc0201b54:	00003517          	auipc	a0,0x3
ffffffffc0201b58:	e3c50513          	addi	a0,a0,-452 # ffffffffc0204990 <commands+0x868>
ffffffffc0201b5c:	e82fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc0201b60:	00003697          	auipc	a3,0x3
ffffffffc0201b64:	21068693          	addi	a3,a3,528 # ffffffffc0204d70 <commands+0xc48>
ffffffffc0201b68:	00003617          	auipc	a2,0x3
ffffffffc0201b6c:	f3060613          	addi	a2,a2,-208 # ffffffffc0204a98 <commands+0x970>
ffffffffc0201b70:	19500593          	li	a1,405
ffffffffc0201b74:	00003517          	auipc	a0,0x3
ffffffffc0201b78:	e1c50513          	addi	a0,a0,-484 # ffffffffc0204990 <commands+0x868>
ffffffffc0201b7c:	e62fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(page_ref(p) == 1);
ffffffffc0201b80:	00003697          	auipc	a3,0x3
ffffffffc0201b84:	2e868693          	addi	a3,a3,744 # ffffffffc0204e68 <commands+0xd40>
ffffffffc0201b88:	00003617          	auipc	a2,0x3
ffffffffc0201b8c:	f1060613          	addi	a2,a2,-240 # ffffffffc0204a98 <commands+0x970>
ffffffffc0201b90:	1ad00593          	li	a1,429
ffffffffc0201b94:	00003517          	auipc	a0,0x3
ffffffffc0201b98:	dfc50513          	addi	a0,a0,-516 # ffffffffc0204990 <commands+0x868>
ffffffffc0201b9c:	e42fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100, PTE_W | PTE_R) == 0);
ffffffffc0201ba0:	00003697          	auipc	a3,0x3
ffffffffc0201ba4:	28868693          	addi	a3,a3,648 # ffffffffc0204e28 <commands+0xd00>
ffffffffc0201ba8:	00003617          	auipc	a2,0x3
ffffffffc0201bac:	ef060613          	addi	a2,a2,-272 # ffffffffc0204a98 <commands+0x970>
ffffffffc0201bb0:	1ac00593          	li	a1,428
ffffffffc0201bb4:	00003517          	auipc	a0,0x3
ffffffffc0201bb8:	ddc50513          	addi	a0,a0,-548 # ffffffffc0204990 <commands+0x868>
ffffffffc0201bbc:	e22fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0201bc0:	00003697          	auipc	a3,0x3
ffffffffc0201bc4:	13868693          	addi	a3,a3,312 # ffffffffc0204cf8 <commands+0xbd0>
ffffffffc0201bc8:	00003617          	auipc	a2,0x3
ffffffffc0201bcc:	ed060613          	addi	a2,a2,-304 # ffffffffc0204a98 <commands+0x970>
ffffffffc0201bd0:	18700593          	li	a1,391
ffffffffc0201bd4:	00003517          	auipc	a0,0x3
ffffffffc0201bd8:	dbc50513          	addi	a0,a0,-580 # ffffffffc0204990 <commands+0x868>
ffffffffc0201bdc:	e02fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(page_ref(p1) == 1);
ffffffffc0201be0:	00003697          	auipc	a3,0x3
ffffffffc0201be4:	fb868693          	addi	a3,a3,-72 # ffffffffc0204b98 <commands+0xa70>
ffffffffc0201be8:	00003617          	auipc	a2,0x3
ffffffffc0201bec:	eb060613          	addi	a2,a2,-336 # ffffffffc0204a98 <commands+0x970>
ffffffffc0201bf0:	18600593          	li	a1,390
ffffffffc0201bf4:	00003517          	auipc	a0,0x3
ffffffffc0201bf8:	d9c50513          	addi	a0,a0,-612 # ffffffffc0204990 <commands+0x868>
ffffffffc0201bfc:	de2fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert((*ptep & PTE_U) == 0);
ffffffffc0201c00:	00003697          	auipc	a3,0x3
ffffffffc0201c04:	11068693          	addi	a3,a3,272 # ffffffffc0204d10 <commands+0xbe8>
ffffffffc0201c08:	00003617          	auipc	a2,0x3
ffffffffc0201c0c:	e9060613          	addi	a2,a2,-368 # ffffffffc0204a98 <commands+0x970>
ffffffffc0201c10:	18300593          	li	a1,387
ffffffffc0201c14:	00003517          	auipc	a0,0x3
ffffffffc0201c18:	d7c50513          	addi	a0,a0,-644 # ffffffffc0204990 <commands+0x868>
ffffffffc0201c1c:	dc2fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0201c20:	00003697          	auipc	a3,0x3
ffffffffc0201c24:	f6068693          	addi	a3,a3,-160 # ffffffffc0204b80 <commands+0xa58>
ffffffffc0201c28:	00003617          	auipc	a2,0x3
ffffffffc0201c2c:	e7060613          	addi	a2,a2,-400 # ffffffffc0204a98 <commands+0x970>
ffffffffc0201c30:	18200593          	li	a1,386
ffffffffc0201c34:	00003517          	auipc	a0,0x3
ffffffffc0201c38:	d5c50513          	addi	a0,a0,-676 # ffffffffc0204990 <commands+0x868>
ffffffffc0201c3c:	da2fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0201c40:	00003697          	auipc	a3,0x3
ffffffffc0201c44:	fe068693          	addi	a3,a3,-32 # ffffffffc0204c20 <commands+0xaf8>
ffffffffc0201c48:	00003617          	auipc	a2,0x3
ffffffffc0201c4c:	e5060613          	addi	a2,a2,-432 # ffffffffc0204a98 <commands+0x970>
ffffffffc0201c50:	18100593          	li	a1,385
ffffffffc0201c54:	00003517          	auipc	a0,0x3
ffffffffc0201c58:	d3c50513          	addi	a0,a0,-708 # ffffffffc0204990 <commands+0x868>
ffffffffc0201c5c:	d82fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(page_ref(p2) == 0);
ffffffffc0201c60:	00003697          	auipc	a3,0x3
ffffffffc0201c64:	09868693          	addi	a3,a3,152 # ffffffffc0204cf8 <commands+0xbd0>
ffffffffc0201c68:	00003617          	auipc	a2,0x3
ffffffffc0201c6c:	e3060613          	addi	a2,a2,-464 # ffffffffc0204a98 <commands+0x970>
ffffffffc0201c70:	18000593          	li	a1,384
ffffffffc0201c74:	00003517          	auipc	a0,0x3
ffffffffc0201c78:	d1c50513          	addi	a0,a0,-740 # ffffffffc0204990 <commands+0x868>
ffffffffc0201c7c:	d62fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(page_ref(p1) == 2);
ffffffffc0201c80:	00003697          	auipc	a3,0x3
ffffffffc0201c84:	06068693          	addi	a3,a3,96 # ffffffffc0204ce0 <commands+0xbb8>
ffffffffc0201c88:	00003617          	auipc	a2,0x3
ffffffffc0201c8c:	e1060613          	addi	a2,a2,-496 # ffffffffc0204a98 <commands+0x970>
ffffffffc0201c90:	17f00593          	li	a1,383
ffffffffc0201c94:	00003517          	auipc	a0,0x3
ffffffffc0201c98:	cfc50513          	addi	a0,a0,-772 # ffffffffc0204990 <commands+0x868>
ffffffffc0201c9c:	d42fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(page_insert(boot_pgdir_va, p1, PGSIZE, 0) == 0);
ffffffffc0201ca0:	00003697          	auipc	a3,0x3
ffffffffc0201ca4:	01068693          	addi	a3,a3,16 # ffffffffc0204cb0 <commands+0xb88>
ffffffffc0201ca8:	00003617          	auipc	a2,0x3
ffffffffc0201cac:	df060613          	addi	a2,a2,-528 # ffffffffc0204a98 <commands+0x970>
ffffffffc0201cb0:	17e00593          	li	a1,382
ffffffffc0201cb4:	00003517          	auipc	a0,0x3
ffffffffc0201cb8:	cdc50513          	addi	a0,a0,-804 # ffffffffc0204990 <commands+0x868>
ffffffffc0201cbc:	d22fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(page_ref(p2) == 1);
ffffffffc0201cc0:	00003697          	auipc	a3,0x3
ffffffffc0201cc4:	fd868693          	addi	a3,a3,-40 # ffffffffc0204c98 <commands+0xb70>
ffffffffc0201cc8:	00003617          	auipc	a2,0x3
ffffffffc0201ccc:	dd060613          	addi	a2,a2,-560 # ffffffffc0204a98 <commands+0x970>
ffffffffc0201cd0:	17c00593          	li	a1,380
ffffffffc0201cd4:	00003517          	auipc	a0,0x3
ffffffffc0201cd8:	cbc50513          	addi	a0,a0,-836 # ffffffffc0204990 <commands+0x868>
ffffffffc0201cdc:	d02fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(boot_pgdir_va[0] & PTE_U);
ffffffffc0201ce0:	00003697          	auipc	a3,0x3
ffffffffc0201ce4:	f9868693          	addi	a3,a3,-104 # ffffffffc0204c78 <commands+0xb50>
ffffffffc0201ce8:	00003617          	auipc	a2,0x3
ffffffffc0201cec:	db060613          	addi	a2,a2,-592 # ffffffffc0204a98 <commands+0x970>
ffffffffc0201cf0:	17b00593          	li	a1,379
ffffffffc0201cf4:	00003517          	auipc	a0,0x3
ffffffffc0201cf8:	c9c50513          	addi	a0,a0,-868 # ffffffffc0204990 <commands+0x868>
ffffffffc0201cfc:	ce2fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(*ptep & PTE_W);
ffffffffc0201d00:	00003697          	auipc	a3,0x3
ffffffffc0201d04:	f6868693          	addi	a3,a3,-152 # ffffffffc0204c68 <commands+0xb40>
ffffffffc0201d08:	00003617          	auipc	a2,0x3
ffffffffc0201d0c:	d9060613          	addi	a2,a2,-624 # ffffffffc0204a98 <commands+0x970>
ffffffffc0201d10:	17a00593          	li	a1,378
ffffffffc0201d14:	00003517          	auipc	a0,0x3
ffffffffc0201d18:	c7c50513          	addi	a0,a0,-900 # ffffffffc0204990 <commands+0x868>
ffffffffc0201d1c:	cc2fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(*ptep & PTE_U);
ffffffffc0201d20:	00003697          	auipc	a3,0x3
ffffffffc0201d24:	f3868693          	addi	a3,a3,-200 # ffffffffc0204c58 <commands+0xb30>
ffffffffc0201d28:	00003617          	auipc	a2,0x3
ffffffffc0201d2c:	d7060613          	addi	a2,a2,-656 # ffffffffc0204a98 <commands+0x970>
ffffffffc0201d30:	17900593          	li	a1,377
ffffffffc0201d34:	00003517          	auipc	a0,0x3
ffffffffc0201d38:	c5c50513          	addi	a0,a0,-932 # ffffffffc0204990 <commands+0x868>
ffffffffc0201d3c:	ca2fe0ef          	jal	ra,ffffffffc02001de <__panic>
        panic("DTB memory info not available");
ffffffffc0201d40:	00003617          	auipc	a2,0x3
ffffffffc0201d44:	c7860613          	addi	a2,a2,-904 # ffffffffc02049b8 <commands+0x890>
ffffffffc0201d48:	06400593          	li	a1,100
ffffffffc0201d4c:	00003517          	auipc	a0,0x3
ffffffffc0201d50:	c4450513          	addi	a0,a0,-956 # ffffffffc0204990 <commands+0x868>
ffffffffc0201d54:	c8afe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(nr_free_store == nr_free_pages());
ffffffffc0201d58:	00003697          	auipc	a3,0x3
ffffffffc0201d5c:	01868693          	addi	a3,a3,24 # ffffffffc0204d70 <commands+0xc48>
ffffffffc0201d60:	00003617          	auipc	a2,0x3
ffffffffc0201d64:	d3860613          	addi	a2,a2,-712 # ffffffffc0204a98 <commands+0x970>
ffffffffc0201d68:	1bf00593          	li	a1,447
ffffffffc0201d6c:	00003517          	auipc	a0,0x3
ffffffffc0201d70:	c2450513          	addi	a0,a0,-988 # ffffffffc0204990 <commands+0x868>
ffffffffc0201d74:	c6afe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert((ptep = get_pte(boot_pgdir_va, PGSIZE, 0)) != NULL);
ffffffffc0201d78:	00003697          	auipc	a3,0x3
ffffffffc0201d7c:	ea868693          	addi	a3,a3,-344 # ffffffffc0204c20 <commands+0xaf8>
ffffffffc0201d80:	00003617          	auipc	a2,0x3
ffffffffc0201d84:	d1860613          	addi	a2,a2,-744 # ffffffffc0204a98 <commands+0x970>
ffffffffc0201d88:	17800593          	li	a1,376
ffffffffc0201d8c:	00003517          	auipc	a0,0x3
ffffffffc0201d90:	c0450513          	addi	a0,a0,-1020 # ffffffffc0204990 <commands+0x868>
ffffffffc0201d94:	c4afe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(page_insert(boot_pgdir_va, p2, PGSIZE, PTE_U | PTE_W) == 0);
ffffffffc0201d98:	00003697          	auipc	a3,0x3
ffffffffc0201d9c:	e4868693          	addi	a3,a3,-440 # ffffffffc0204be0 <commands+0xab8>
ffffffffc0201da0:	00003617          	auipc	a2,0x3
ffffffffc0201da4:	cf860613          	addi	a2,a2,-776 # ffffffffc0204a98 <commands+0x970>
ffffffffc0201da8:	17700593          	li	a1,375
ffffffffc0201dac:	00003517          	auipc	a0,0x3
ffffffffc0201db0:	be450513          	addi	a0,a0,-1052 # ffffffffc0204990 <commands+0x868>
ffffffffc0201db4:	c2afe0ef          	jal	ra,ffffffffc02001de <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(ptep[0])) + 1;
ffffffffc0201db8:	86d6                	mv	a3,s5
ffffffffc0201dba:	00003617          	auipc	a2,0x3
ffffffffc0201dbe:	bae60613          	addi	a2,a2,-1106 # ffffffffc0204968 <commands+0x840>
ffffffffc0201dc2:	17300593          	li	a1,371
ffffffffc0201dc6:	00003517          	auipc	a0,0x3
ffffffffc0201dca:	bca50513          	addi	a0,a0,-1078 # ffffffffc0204990 <commands+0x868>
ffffffffc0201dce:	c10fe0ef          	jal	ra,ffffffffc02001de <__panic>
    ptep = (pte_t *)KADDR(PDE_ADDR(boot_pgdir_va[0]));
ffffffffc0201dd2:	00003617          	auipc	a2,0x3
ffffffffc0201dd6:	b9660613          	addi	a2,a2,-1130 # ffffffffc0204968 <commands+0x840>
ffffffffc0201dda:	17200593          	li	a1,370
ffffffffc0201dde:	00003517          	auipc	a0,0x3
ffffffffc0201de2:	bb250513          	addi	a0,a0,-1102 # ffffffffc0204990 <commands+0x868>
ffffffffc0201de6:	bf8fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(page_ref(p1) == 1);
ffffffffc0201dea:	00003697          	auipc	a3,0x3
ffffffffc0201dee:	dae68693          	addi	a3,a3,-594 # ffffffffc0204b98 <commands+0xa70>
ffffffffc0201df2:	00003617          	auipc	a2,0x3
ffffffffc0201df6:	ca660613          	addi	a2,a2,-858 # ffffffffc0204a98 <commands+0x970>
ffffffffc0201dfa:	17000593          	li	a1,368
ffffffffc0201dfe:	00003517          	auipc	a0,0x3
ffffffffc0201e02:	b9250513          	addi	a0,a0,-1134 # ffffffffc0204990 <commands+0x868>
ffffffffc0201e06:	bd8fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(pte2page(*ptep) == p1);
ffffffffc0201e0a:	00003697          	auipc	a3,0x3
ffffffffc0201e0e:	d7668693          	addi	a3,a3,-650 # ffffffffc0204b80 <commands+0xa58>
ffffffffc0201e12:	00003617          	auipc	a2,0x3
ffffffffc0201e16:	c8660613          	addi	a2,a2,-890 # ffffffffc0204a98 <commands+0x970>
ffffffffc0201e1a:	16f00593          	li	a1,367
ffffffffc0201e1e:	00003517          	auipc	a0,0x3
ffffffffc0201e22:	b7250513          	addi	a0,a0,-1166 # ffffffffc0204990 <commands+0x868>
ffffffffc0201e26:	bb8fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(strlen((const char *)0x100) == 0);
ffffffffc0201e2a:	00003697          	auipc	a3,0x3
ffffffffc0201e2e:	10668693          	addi	a3,a3,262 # ffffffffc0204f30 <commands+0xe08>
ffffffffc0201e32:	00003617          	auipc	a2,0x3
ffffffffc0201e36:	c6660613          	addi	a2,a2,-922 # ffffffffc0204a98 <commands+0x970>
ffffffffc0201e3a:	1b600593          	li	a1,438
ffffffffc0201e3e:	00003517          	auipc	a0,0x3
ffffffffc0201e42:	b5250513          	addi	a0,a0,-1198 # ffffffffc0204990 <commands+0x868>
ffffffffc0201e46:	b98fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
ffffffffc0201e4a:	00003697          	auipc	a3,0x3
ffffffffc0201e4e:	0ae68693          	addi	a3,a3,174 # ffffffffc0204ef8 <commands+0xdd0>
ffffffffc0201e52:	00003617          	auipc	a2,0x3
ffffffffc0201e56:	c4660613          	addi	a2,a2,-954 # ffffffffc0204a98 <commands+0x970>
ffffffffc0201e5a:	1b300593          	li	a1,435
ffffffffc0201e5e:	00003517          	auipc	a0,0x3
ffffffffc0201e62:	b3250513          	addi	a0,a0,-1230 # ffffffffc0204990 <commands+0x868>
ffffffffc0201e66:	b78fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(page_ref(p) == 2);
ffffffffc0201e6a:	00003697          	auipc	a3,0x3
ffffffffc0201e6e:	05e68693          	addi	a3,a3,94 # ffffffffc0204ec8 <commands+0xda0>
ffffffffc0201e72:	00003617          	auipc	a2,0x3
ffffffffc0201e76:	c2660613          	addi	a2,a2,-986 # ffffffffc0204a98 <commands+0x970>
ffffffffc0201e7a:	1af00593          	li	a1,431
ffffffffc0201e7e:	00003517          	auipc	a0,0x3
ffffffffc0201e82:	b1250513          	addi	a0,a0,-1262 # ffffffffc0204990 <commands+0x868>
ffffffffc0201e86:	b58fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(page_insert(boot_pgdir_va, p, 0x100 + PGSIZE, PTE_W | PTE_R) == 0);
ffffffffc0201e8a:	00003697          	auipc	a3,0x3
ffffffffc0201e8e:	ff668693          	addi	a3,a3,-10 # ffffffffc0204e80 <commands+0xd58>
ffffffffc0201e92:	00003617          	auipc	a2,0x3
ffffffffc0201e96:	c0660613          	addi	a2,a2,-1018 # ffffffffc0204a98 <commands+0x970>
ffffffffc0201e9a:	1ae00593          	li	a1,430
ffffffffc0201e9e:	00003517          	auipc	a0,0x3
ffffffffc0201ea2:	af250513          	addi	a0,a0,-1294 # ffffffffc0204990 <commands+0x868>
ffffffffc0201ea6:	b38fe0ef          	jal	ra,ffffffffc02001de <__panic>
    boot_pgdir_pa = PADDR(boot_pgdir_va);
ffffffffc0201eaa:	00003617          	auipc	a2,0x3
ffffffffc0201eae:	b6e60613          	addi	a2,a2,-1170 # ffffffffc0204a18 <commands+0x8f0>
ffffffffc0201eb2:	0cb00593          	li	a1,203
ffffffffc0201eb6:	00003517          	auipc	a0,0x3
ffffffffc0201eba:	ada50513          	addi	a0,a0,-1318 # ffffffffc0204990 <commands+0x868>
ffffffffc0201ebe:	b20fe0ef          	jal	ra,ffffffffc02001de <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0201ec2:	00003617          	auipc	a2,0x3
ffffffffc0201ec6:	b5660613          	addi	a2,a2,-1194 # ffffffffc0204a18 <commands+0x8f0>
ffffffffc0201eca:	08000593          	li	a1,128
ffffffffc0201ece:	00003517          	auipc	a0,0x3
ffffffffc0201ed2:	ac250513          	addi	a0,a0,-1342 # ffffffffc0204990 <commands+0x868>
ffffffffc0201ed6:	b08fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert((ptep = get_pte(boot_pgdir_va, 0x0, 0)) != NULL);
ffffffffc0201eda:	00003697          	auipc	a3,0x3
ffffffffc0201ede:	c7668693          	addi	a3,a3,-906 # ffffffffc0204b50 <commands+0xa28>
ffffffffc0201ee2:	00003617          	auipc	a2,0x3
ffffffffc0201ee6:	bb660613          	addi	a2,a2,-1098 # ffffffffc0204a98 <commands+0x970>
ffffffffc0201eea:	16e00593          	li	a1,366
ffffffffc0201eee:	00003517          	auipc	a0,0x3
ffffffffc0201ef2:	aa250513          	addi	a0,a0,-1374 # ffffffffc0204990 <commands+0x868>
ffffffffc0201ef6:	ae8fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(page_insert(boot_pgdir_va, p1, 0x0, 0) == 0);
ffffffffc0201efa:	00003697          	auipc	a3,0x3
ffffffffc0201efe:	c2668693          	addi	a3,a3,-986 # ffffffffc0204b20 <commands+0x9f8>
ffffffffc0201f02:	00003617          	auipc	a2,0x3
ffffffffc0201f06:	b9660613          	addi	a2,a2,-1130 # ffffffffc0204a98 <commands+0x970>
ffffffffc0201f0a:	16b00593          	li	a1,363
ffffffffc0201f0e:	00003517          	auipc	a0,0x3
ffffffffc0201f12:	a8250513          	addi	a0,a0,-1406 # ffffffffc0204990 <commands+0x868>
ffffffffc0201f16:	ac8fe0ef          	jal	ra,ffffffffc02001de <__panic>

ffffffffc0201f1a <check_vma_overlap.part.0>:
    return vma;
}

// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc0201f1a:	1141                	addi	sp,sp,-16
{
    assert(prev->vm_start < prev->vm_end);
    assert(prev->vm_end <= next->vm_start);
    assert(next->vm_start < next->vm_end);
ffffffffc0201f1c:	00003697          	auipc	a3,0x3
ffffffffc0201f20:	05c68693          	addi	a3,a3,92 # ffffffffc0204f78 <commands+0xe50>
ffffffffc0201f24:	00003617          	auipc	a2,0x3
ffffffffc0201f28:	b7460613          	addi	a2,a2,-1164 # ffffffffc0204a98 <commands+0x970>
ffffffffc0201f2c:	08800593          	li	a1,136
ffffffffc0201f30:	00003517          	auipc	a0,0x3
ffffffffc0201f34:	06850513          	addi	a0,a0,104 # ffffffffc0204f98 <commands+0xe70>
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next)
ffffffffc0201f38:	e406                	sd	ra,8(sp)
    assert(next->vm_start < next->vm_end);
ffffffffc0201f3a:	aa4fe0ef          	jal	ra,ffffffffc02001de <__panic>

ffffffffc0201f3e <find_vma>:
{
ffffffffc0201f3e:	86aa                	mv	a3,a0
    if (mm != NULL)
ffffffffc0201f40:	c505                	beqz	a0,ffffffffc0201f68 <find_vma+0x2a>
        vma = mm->mmap_cache;
ffffffffc0201f42:	6908                	ld	a0,16(a0)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc0201f44:	c501                	beqz	a0,ffffffffc0201f4c <find_vma+0xe>
ffffffffc0201f46:	651c                	ld	a5,8(a0)
ffffffffc0201f48:	02f5f263          	bgeu	a1,a5,ffffffffc0201f6c <find_vma+0x2e>
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0201f4c:	669c                	ld	a5,8(a3)
            while ((le = list_next(le)) != list)
ffffffffc0201f4e:	00f68d63          	beq	a3,a5,ffffffffc0201f68 <find_vma+0x2a>
                if (vma->vm_start <= addr && addr < vma->vm_end)
ffffffffc0201f52:	fe87b703          	ld	a4,-24(a5) # ffffffffc7ffffe8 <end+0x7df2afc>
ffffffffc0201f56:	00e5e663          	bltu	a1,a4,ffffffffc0201f62 <find_vma+0x24>
ffffffffc0201f5a:	ff07b703          	ld	a4,-16(a5)
ffffffffc0201f5e:	00e5ec63          	bltu	a1,a4,ffffffffc0201f76 <find_vma+0x38>
ffffffffc0201f62:	679c                	ld	a5,8(a5)
            while ((le = list_next(le)) != list)
ffffffffc0201f64:	fef697e3          	bne	a3,a5,ffffffffc0201f52 <find_vma+0x14>
    struct vma_struct *vma = NULL;
ffffffffc0201f68:	4501                	li	a0,0
}
ffffffffc0201f6a:	8082                	ret
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr))
ffffffffc0201f6c:	691c                	ld	a5,16(a0)
ffffffffc0201f6e:	fcf5ffe3          	bgeu	a1,a5,ffffffffc0201f4c <find_vma+0xe>
            mm->mmap_cache = vma;
ffffffffc0201f72:	ea88                	sd	a0,16(a3)
ffffffffc0201f74:	8082                	ret
                vma = le2vma(le, list_link);
ffffffffc0201f76:	fe078513          	addi	a0,a5,-32
            mm->mmap_cache = vma;
ffffffffc0201f7a:	ea88                	sd	a0,16(a3)
ffffffffc0201f7c:	8082                	ret

ffffffffc0201f7e <insert_vma_struct>:
}

// insert_vma_struct -insert vma in mm's list link
void insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma)
{
    assert(vma->vm_start < vma->vm_end);
ffffffffc0201f7e:	6590                	ld	a2,8(a1)
ffffffffc0201f80:	0105b803          	ld	a6,16(a1)
{
ffffffffc0201f84:	1141                	addi	sp,sp,-16
ffffffffc0201f86:	e406                	sd	ra,8(sp)
ffffffffc0201f88:	87aa                	mv	a5,a0
    assert(vma->vm_start < vma->vm_end);
ffffffffc0201f8a:	01066763          	bltu	a2,a6,ffffffffc0201f98 <insert_vma_struct+0x1a>
ffffffffc0201f8e:	a085                	j	ffffffffc0201fee <insert_vma_struct+0x70>

    list_entry_t *le = list;
    while ((le = list_next(le)) != list)
    {
        struct vma_struct *mmap_prev = le2vma(le, list_link);
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc0201f90:	fe87b703          	ld	a4,-24(a5)
ffffffffc0201f94:	04e66863          	bltu	a2,a4,ffffffffc0201fe4 <insert_vma_struct+0x66>
ffffffffc0201f98:	86be                	mv	a3,a5
ffffffffc0201f9a:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != list)
ffffffffc0201f9c:	fef51ae3          	bne	a0,a5,ffffffffc0201f90 <insert_vma_struct+0x12>
    }

    le_next = list_next(le_prev);

    /* check overlap */
    if (le_prev != list)
ffffffffc0201fa0:	02a68463          	beq	a3,a0,ffffffffc0201fc8 <insert_vma_struct+0x4a>
    {
        check_vma_overlap(le2vma(le_prev, list_link), vma);
ffffffffc0201fa4:	ff06b703          	ld	a4,-16(a3)
    assert(prev->vm_start < prev->vm_end);
ffffffffc0201fa8:	fe86b883          	ld	a7,-24(a3)
ffffffffc0201fac:	08e8f163          	bgeu	a7,a4,ffffffffc020202e <insert_vma_struct+0xb0>
    assert(prev->vm_end <= next->vm_start);
ffffffffc0201fb0:	04e66f63          	bltu	a2,a4,ffffffffc020200e <insert_vma_struct+0x90>
    }
    if (le_next != list)
ffffffffc0201fb4:	00f50a63          	beq	a0,a5,ffffffffc0201fc8 <insert_vma_struct+0x4a>
        if (mmap_prev->vm_start > vma->vm_start)
ffffffffc0201fb8:	fe87b703          	ld	a4,-24(a5)
    assert(prev->vm_end <= next->vm_start);
ffffffffc0201fbc:	05076963          	bltu	a4,a6,ffffffffc020200e <insert_vma_struct+0x90>
    assert(next->vm_start < next->vm_end);
ffffffffc0201fc0:	ff07b603          	ld	a2,-16(a5)
ffffffffc0201fc4:	02c77363          	bgeu	a4,a2,ffffffffc0201fea <insert_vma_struct+0x6c>
    }

    vma->vm_mm = mm;
    list_add_after(le_prev, &(vma->list_link));

    mm->map_count++;
ffffffffc0201fc8:	5118                	lw	a4,32(a0)
    vma->vm_mm = mm;
ffffffffc0201fca:	e188                	sd	a0,0(a1)
    list_add_after(le_prev, &(vma->list_link));
ffffffffc0201fcc:	02058613          	addi	a2,a1,32
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc0201fd0:	e390                	sd	a2,0(a5)
ffffffffc0201fd2:	e690                	sd	a2,8(a3)
}
ffffffffc0201fd4:	60a2                	ld	ra,8(sp)
    elm->next = next;
ffffffffc0201fd6:	f59c                	sd	a5,40(a1)
    elm->prev = prev;
ffffffffc0201fd8:	f194                	sd	a3,32(a1)
    mm->map_count++;
ffffffffc0201fda:	0017079b          	addiw	a5,a4,1
ffffffffc0201fde:	d11c                	sw	a5,32(a0)
}
ffffffffc0201fe0:	0141                	addi	sp,sp,16
ffffffffc0201fe2:	8082                	ret
    if (le_prev != list)
ffffffffc0201fe4:	fca690e3          	bne	a3,a0,ffffffffc0201fa4 <insert_vma_struct+0x26>
ffffffffc0201fe8:	bfd1                	j	ffffffffc0201fbc <insert_vma_struct+0x3e>
ffffffffc0201fea:	f31ff0ef          	jal	ra,ffffffffc0201f1a <check_vma_overlap.part.0>
    assert(vma->vm_start < vma->vm_end);
ffffffffc0201fee:	00003697          	auipc	a3,0x3
ffffffffc0201ff2:	fba68693          	addi	a3,a3,-70 # ffffffffc0204fa8 <commands+0xe80>
ffffffffc0201ff6:	00003617          	auipc	a2,0x3
ffffffffc0201ffa:	aa260613          	addi	a2,a2,-1374 # ffffffffc0204a98 <commands+0x970>
ffffffffc0201ffe:	08e00593          	li	a1,142
ffffffffc0202002:	00003517          	auipc	a0,0x3
ffffffffc0202006:	f9650513          	addi	a0,a0,-106 # ffffffffc0204f98 <commands+0xe70>
ffffffffc020200a:	9d4fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(prev->vm_end <= next->vm_start);
ffffffffc020200e:	00003697          	auipc	a3,0x3
ffffffffc0202012:	fda68693          	addi	a3,a3,-38 # ffffffffc0204fe8 <commands+0xec0>
ffffffffc0202016:	00003617          	auipc	a2,0x3
ffffffffc020201a:	a8260613          	addi	a2,a2,-1406 # ffffffffc0204a98 <commands+0x970>
ffffffffc020201e:	08700593          	li	a1,135
ffffffffc0202022:	00003517          	auipc	a0,0x3
ffffffffc0202026:	f7650513          	addi	a0,a0,-138 # ffffffffc0204f98 <commands+0xe70>
ffffffffc020202a:	9b4fe0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(prev->vm_start < prev->vm_end);
ffffffffc020202e:	00003697          	auipc	a3,0x3
ffffffffc0202032:	f9a68693          	addi	a3,a3,-102 # ffffffffc0204fc8 <commands+0xea0>
ffffffffc0202036:	00003617          	auipc	a2,0x3
ffffffffc020203a:	a6260613          	addi	a2,a2,-1438 # ffffffffc0204a98 <commands+0x970>
ffffffffc020203e:	08600593          	li	a1,134
ffffffffc0202042:	00003517          	auipc	a0,0x3
ffffffffc0202046:	f5650513          	addi	a0,a0,-170 # ffffffffc0204f98 <commands+0xe70>
ffffffffc020204a:	994fe0ef          	jal	ra,ffffffffc02001de <__panic>

ffffffffc020204e <vmm_init>:
}

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void vmm_init(void)
{
ffffffffc020204e:	7139                	addi	sp,sp,-64
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0202050:	03000513          	li	a0,48
{
ffffffffc0202054:	fc06                	sd	ra,56(sp)
ffffffffc0202056:	f822                	sd	s0,48(sp)
ffffffffc0202058:	f426                	sd	s1,40(sp)
ffffffffc020205a:	f04a                	sd	s2,32(sp)
ffffffffc020205c:	ec4e                	sd	s3,24(sp)
ffffffffc020205e:	e852                	sd	s4,16(sp)
ffffffffc0202060:	e456                	sd	s5,8(sp)
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
ffffffffc0202062:	550000ef          	jal	ra,ffffffffc02025b2 <kmalloc>
    if (mm != NULL)
ffffffffc0202066:	2e050f63          	beqz	a0,ffffffffc0202364 <vmm_init+0x316>
ffffffffc020206a:	84aa                	mv	s1,a0
    elm->prev = elm->next = elm;
ffffffffc020206c:	e508                	sd	a0,8(a0)
ffffffffc020206e:	e108                	sd	a0,0(a0)
        mm->mmap_cache = NULL;
ffffffffc0202070:	00053823          	sd	zero,16(a0)
        mm->pgdir = NULL;
ffffffffc0202074:	00053c23          	sd	zero,24(a0)
        mm->map_count = 0;
ffffffffc0202078:	02052023          	sw	zero,32(a0)
        mm->sm_priv = NULL;
ffffffffc020207c:	02053423          	sd	zero,40(a0)
ffffffffc0202080:	03200413          	li	s0,50
ffffffffc0202084:	a811                	j	ffffffffc0202098 <vmm_init+0x4a>
        vma->vm_start = vm_start;
ffffffffc0202086:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc0202088:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc020208a:	00052c23          	sw	zero,24(a0)
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i--)
ffffffffc020208e:	146d                	addi	s0,s0,-5
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc0202090:	8526                	mv	a0,s1
ffffffffc0202092:	eedff0ef          	jal	ra,ffffffffc0201f7e <insert_vma_struct>
    for (i = step1; i >= 1; i--)
ffffffffc0202096:	c80d                	beqz	s0,ffffffffc02020c8 <vmm_init+0x7a>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc0202098:	03000513          	li	a0,48
ffffffffc020209c:	516000ef          	jal	ra,ffffffffc02025b2 <kmalloc>
ffffffffc02020a0:	85aa                	mv	a1,a0
ffffffffc02020a2:	00240793          	addi	a5,s0,2
    if (vma != NULL)
ffffffffc02020a6:	f165                	bnez	a0,ffffffffc0202086 <vmm_init+0x38>
        assert(vma != NULL);
ffffffffc02020a8:	00003697          	auipc	a3,0x3
ffffffffc02020ac:	0d868693          	addi	a3,a3,216 # ffffffffc0205180 <commands+0x1058>
ffffffffc02020b0:	00003617          	auipc	a2,0x3
ffffffffc02020b4:	9e860613          	addi	a2,a2,-1560 # ffffffffc0204a98 <commands+0x970>
ffffffffc02020b8:	0da00593          	li	a1,218
ffffffffc02020bc:	00003517          	auipc	a0,0x3
ffffffffc02020c0:	edc50513          	addi	a0,a0,-292 # ffffffffc0204f98 <commands+0xe70>
ffffffffc02020c4:	91afe0ef          	jal	ra,ffffffffc02001de <__panic>
ffffffffc02020c8:	03700413          	li	s0,55
    }

    for (i = step1 + 1; i <= step2; i++)
ffffffffc02020cc:	1f900913          	li	s2,505
ffffffffc02020d0:	a819                	j	ffffffffc02020e6 <vmm_init+0x98>
        vma->vm_start = vm_start;
ffffffffc02020d2:	e500                	sd	s0,8(a0)
        vma->vm_end = vm_end;
ffffffffc02020d4:	e91c                	sd	a5,16(a0)
        vma->vm_flags = vm_flags;
ffffffffc02020d6:	00052c23          	sw	zero,24(a0)
    for (i = step1 + 1; i <= step2; i++)
ffffffffc02020da:	0415                	addi	s0,s0,5
    {
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
ffffffffc02020dc:	8526                	mv	a0,s1
ffffffffc02020de:	ea1ff0ef          	jal	ra,ffffffffc0201f7e <insert_vma_struct>
    for (i = step1 + 1; i <= step2; i++)
ffffffffc02020e2:	03240a63          	beq	s0,s2,ffffffffc0202116 <vmm_init+0xc8>
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
ffffffffc02020e6:	03000513          	li	a0,48
ffffffffc02020ea:	4c8000ef          	jal	ra,ffffffffc02025b2 <kmalloc>
ffffffffc02020ee:	85aa                	mv	a1,a0
ffffffffc02020f0:	00240793          	addi	a5,s0,2
    if (vma != NULL)
ffffffffc02020f4:	fd79                	bnez	a0,ffffffffc02020d2 <vmm_init+0x84>
        assert(vma != NULL);
ffffffffc02020f6:	00003697          	auipc	a3,0x3
ffffffffc02020fa:	08a68693          	addi	a3,a3,138 # ffffffffc0205180 <commands+0x1058>
ffffffffc02020fe:	00003617          	auipc	a2,0x3
ffffffffc0202102:	99a60613          	addi	a2,a2,-1638 # ffffffffc0204a98 <commands+0x970>
ffffffffc0202106:	0e100593          	li	a1,225
ffffffffc020210a:	00003517          	auipc	a0,0x3
ffffffffc020210e:	e8e50513          	addi	a0,a0,-370 # ffffffffc0204f98 <commands+0xe70>
ffffffffc0202112:	8ccfe0ef          	jal	ra,ffffffffc02001de <__panic>
    return listelm->next;
ffffffffc0202116:	649c                	ld	a5,8(s1)
ffffffffc0202118:	471d                	li	a4,7
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i++)
ffffffffc020211a:	1fb00593          	li	a1,507
    {
        assert(le != &(mm->mmap_list));
ffffffffc020211e:	18f48363          	beq	s1,a5,ffffffffc02022a4 <vmm_init+0x256>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0202122:	fe87b603          	ld	a2,-24(a5)
ffffffffc0202126:	ffe70693          	addi	a3,a4,-2 # ffe <kern_entry-0xffffffffc01ff002>
ffffffffc020212a:	10d61d63          	bne	a2,a3,ffffffffc0202244 <vmm_init+0x1f6>
ffffffffc020212e:	ff07b683          	ld	a3,-16(a5)
ffffffffc0202132:	10e69963          	bne	a3,a4,ffffffffc0202244 <vmm_init+0x1f6>
    for (i = 1; i <= step2; i++)
ffffffffc0202136:	0715                	addi	a4,a4,5
ffffffffc0202138:	679c                	ld	a5,8(a5)
ffffffffc020213a:	feb712e3          	bne	a4,a1,ffffffffc020211e <vmm_init+0xd0>
ffffffffc020213e:	4a1d                	li	s4,7
ffffffffc0202140:	4415                	li	s0,5
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc0202142:	1f900a93          	li	s5,505
    {
        struct vma_struct *vma1 = find_vma(mm, i);
ffffffffc0202146:	85a2                	mv	a1,s0
ffffffffc0202148:	8526                	mv	a0,s1
ffffffffc020214a:	df5ff0ef          	jal	ra,ffffffffc0201f3e <find_vma>
ffffffffc020214e:	892a                	mv	s2,a0
        assert(vma1 != NULL);
ffffffffc0202150:	18050a63          	beqz	a0,ffffffffc02022e4 <vmm_init+0x296>
        struct vma_struct *vma2 = find_vma(mm, i + 1);
ffffffffc0202154:	00140593          	addi	a1,s0,1
ffffffffc0202158:	8526                	mv	a0,s1
ffffffffc020215a:	de5ff0ef          	jal	ra,ffffffffc0201f3e <find_vma>
ffffffffc020215e:	89aa                	mv	s3,a0
        assert(vma2 != NULL);
ffffffffc0202160:	16050263          	beqz	a0,ffffffffc02022c4 <vmm_init+0x276>
        struct vma_struct *vma3 = find_vma(mm, i + 2);
ffffffffc0202164:	85d2                	mv	a1,s4
ffffffffc0202166:	8526                	mv	a0,s1
ffffffffc0202168:	dd7ff0ef          	jal	ra,ffffffffc0201f3e <find_vma>
        assert(vma3 == NULL);
ffffffffc020216c:	18051c63          	bnez	a0,ffffffffc0202304 <vmm_init+0x2b6>
        struct vma_struct *vma4 = find_vma(mm, i + 3);
ffffffffc0202170:	00340593          	addi	a1,s0,3
ffffffffc0202174:	8526                	mv	a0,s1
ffffffffc0202176:	dc9ff0ef          	jal	ra,ffffffffc0201f3e <find_vma>
        assert(vma4 == NULL);
ffffffffc020217a:	1c051563          	bnez	a0,ffffffffc0202344 <vmm_init+0x2f6>
        struct vma_struct *vma5 = find_vma(mm, i + 4);
ffffffffc020217e:	00440593          	addi	a1,s0,4
ffffffffc0202182:	8526                	mv	a0,s1
ffffffffc0202184:	dbbff0ef          	jal	ra,ffffffffc0201f3e <find_vma>
        assert(vma5 == NULL);
ffffffffc0202188:	18051e63          	bnez	a0,ffffffffc0202324 <vmm_init+0x2d6>

        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc020218c:	00893783          	ld	a5,8(s2)
ffffffffc0202190:	0c879a63          	bne	a5,s0,ffffffffc0202264 <vmm_init+0x216>
ffffffffc0202194:	01093783          	ld	a5,16(s2)
ffffffffc0202198:	0d479663          	bne	a5,s4,ffffffffc0202264 <vmm_init+0x216>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc020219c:	0089b783          	ld	a5,8(s3)
ffffffffc02021a0:	0e879263          	bne	a5,s0,ffffffffc0202284 <vmm_init+0x236>
ffffffffc02021a4:	0109b783          	ld	a5,16(s3)
ffffffffc02021a8:	0d479e63          	bne	a5,s4,ffffffffc0202284 <vmm_init+0x236>
    for (i = 5; i <= 5 * step2; i += 5)
ffffffffc02021ac:	0415                	addi	s0,s0,5
ffffffffc02021ae:	0a15                	addi	s4,s4,5
ffffffffc02021b0:	f9541be3          	bne	s0,s5,ffffffffc0202146 <vmm_init+0xf8>
ffffffffc02021b4:	4411                	li	s0,4
    }

    for (i = 4; i >= 0; i--)
ffffffffc02021b6:	597d                	li	s2,-1
    {
        struct vma_struct *vma_below_5 = find_vma(mm, i);
ffffffffc02021b8:	85a2                	mv	a1,s0
ffffffffc02021ba:	8526                	mv	a0,s1
ffffffffc02021bc:	d83ff0ef          	jal	ra,ffffffffc0201f3e <find_vma>
ffffffffc02021c0:	0004059b          	sext.w	a1,s0
        if (vma_below_5 != NULL)
ffffffffc02021c4:	c90d                	beqz	a0,ffffffffc02021f6 <vmm_init+0x1a8>
        {
            cprintf("vma_below_5: i %x, start %x, end %x\n", i, vma_below_5->vm_start, vma_below_5->vm_end);
ffffffffc02021c6:	6914                	ld	a3,16(a0)
ffffffffc02021c8:	6510                	ld	a2,8(a0)
ffffffffc02021ca:	00003517          	auipc	a0,0x3
ffffffffc02021ce:	f3e50513          	addi	a0,a0,-194 # ffffffffc0205108 <commands+0xfe0>
ffffffffc02021d2:	f0ffd0ef          	jal	ra,ffffffffc02000e0 <cprintf>
        }
        assert(vma_below_5 == NULL);
ffffffffc02021d6:	00003697          	auipc	a3,0x3
ffffffffc02021da:	f5a68693          	addi	a3,a3,-166 # ffffffffc0205130 <commands+0x1008>
ffffffffc02021de:	00003617          	auipc	a2,0x3
ffffffffc02021e2:	8ba60613          	addi	a2,a2,-1862 # ffffffffc0204a98 <commands+0x970>
ffffffffc02021e6:	10700593          	li	a1,263
ffffffffc02021ea:	00003517          	auipc	a0,0x3
ffffffffc02021ee:	dae50513          	addi	a0,a0,-594 # ffffffffc0204f98 <commands+0xe70>
ffffffffc02021f2:	fedfd0ef          	jal	ra,ffffffffc02001de <__panic>
    for (i = 4; i >= 0; i--)
ffffffffc02021f6:	147d                	addi	s0,s0,-1
ffffffffc02021f8:	fd2410e3          	bne	s0,s2,ffffffffc02021b8 <vmm_init+0x16a>
ffffffffc02021fc:	6488                	ld	a0,8(s1)
    while ((le = list_next(list)) != list)
ffffffffc02021fe:	00a48c63          	beq	s1,a0,ffffffffc0202216 <vmm_init+0x1c8>
    __list_del(listelm->prev, listelm->next);
ffffffffc0202202:	6118                	ld	a4,0(a0)
ffffffffc0202204:	651c                	ld	a5,8(a0)
        kfree(le2vma(le, list_link)); // kfree vma
ffffffffc0202206:	1501                	addi	a0,a0,-32
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc0202208:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc020220a:	e398                	sd	a4,0(a5)
ffffffffc020220c:	456000ef          	jal	ra,ffffffffc0202662 <kfree>
    return listelm->next;
ffffffffc0202210:	6488                	ld	a0,8(s1)
    while ((le = list_next(list)) != list)
ffffffffc0202212:	fea498e3          	bne	s1,a0,ffffffffc0202202 <vmm_init+0x1b4>
    kfree(mm); // kfree mm
ffffffffc0202216:	8526                	mv	a0,s1
ffffffffc0202218:	44a000ef          	jal	ra,ffffffffc0202662 <kfree>
    }

    mm_destroy(mm);

    cprintf("check_vma_struct() succeeded!\n");
ffffffffc020221c:	00003517          	auipc	a0,0x3
ffffffffc0202220:	f2c50513          	addi	a0,a0,-212 # ffffffffc0205148 <commands+0x1020>
ffffffffc0202224:	ebdfd0ef          	jal	ra,ffffffffc02000e0 <cprintf>
}
ffffffffc0202228:	7442                	ld	s0,48(sp)
ffffffffc020222a:	70e2                	ld	ra,56(sp)
ffffffffc020222c:	74a2                	ld	s1,40(sp)
ffffffffc020222e:	7902                	ld	s2,32(sp)
ffffffffc0202230:	69e2                	ld	s3,24(sp)
ffffffffc0202232:	6a42                	ld	s4,16(sp)
ffffffffc0202234:	6aa2                	ld	s5,8(sp)
    cprintf("check_vmm() succeeded.\n");
ffffffffc0202236:	00003517          	auipc	a0,0x3
ffffffffc020223a:	f3250513          	addi	a0,a0,-206 # ffffffffc0205168 <commands+0x1040>
}
ffffffffc020223e:	6121                	addi	sp,sp,64
    cprintf("check_vmm() succeeded.\n");
ffffffffc0202240:	ea1fd06f          	j	ffffffffc02000e0 <cprintf>
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
ffffffffc0202244:	00003697          	auipc	a3,0x3
ffffffffc0202248:	ddc68693          	addi	a3,a3,-548 # ffffffffc0205020 <commands+0xef8>
ffffffffc020224c:	00003617          	auipc	a2,0x3
ffffffffc0202250:	84c60613          	addi	a2,a2,-1972 # ffffffffc0204a98 <commands+0x970>
ffffffffc0202254:	0eb00593          	li	a1,235
ffffffffc0202258:	00003517          	auipc	a0,0x3
ffffffffc020225c:	d4050513          	addi	a0,a0,-704 # ffffffffc0204f98 <commands+0xe70>
ffffffffc0202260:	f7ffd0ef          	jal	ra,ffffffffc02001de <__panic>
        assert(vma1->vm_start == i && vma1->vm_end == i + 2);
ffffffffc0202264:	00003697          	auipc	a3,0x3
ffffffffc0202268:	e4468693          	addi	a3,a3,-444 # ffffffffc02050a8 <commands+0xf80>
ffffffffc020226c:	00003617          	auipc	a2,0x3
ffffffffc0202270:	82c60613          	addi	a2,a2,-2004 # ffffffffc0204a98 <commands+0x970>
ffffffffc0202274:	0fc00593          	li	a1,252
ffffffffc0202278:	00003517          	auipc	a0,0x3
ffffffffc020227c:	d2050513          	addi	a0,a0,-736 # ffffffffc0204f98 <commands+0xe70>
ffffffffc0202280:	f5ffd0ef          	jal	ra,ffffffffc02001de <__panic>
        assert(vma2->vm_start == i && vma2->vm_end == i + 2);
ffffffffc0202284:	00003697          	auipc	a3,0x3
ffffffffc0202288:	e5468693          	addi	a3,a3,-428 # ffffffffc02050d8 <commands+0xfb0>
ffffffffc020228c:	00003617          	auipc	a2,0x3
ffffffffc0202290:	80c60613          	addi	a2,a2,-2036 # ffffffffc0204a98 <commands+0x970>
ffffffffc0202294:	0fd00593          	li	a1,253
ffffffffc0202298:	00003517          	auipc	a0,0x3
ffffffffc020229c:	d0050513          	addi	a0,a0,-768 # ffffffffc0204f98 <commands+0xe70>
ffffffffc02022a0:	f3ffd0ef          	jal	ra,ffffffffc02001de <__panic>
        assert(le != &(mm->mmap_list));
ffffffffc02022a4:	00003697          	auipc	a3,0x3
ffffffffc02022a8:	d6468693          	addi	a3,a3,-668 # ffffffffc0205008 <commands+0xee0>
ffffffffc02022ac:	00002617          	auipc	a2,0x2
ffffffffc02022b0:	7ec60613          	addi	a2,a2,2028 # ffffffffc0204a98 <commands+0x970>
ffffffffc02022b4:	0e900593          	li	a1,233
ffffffffc02022b8:	00003517          	auipc	a0,0x3
ffffffffc02022bc:	ce050513          	addi	a0,a0,-800 # ffffffffc0204f98 <commands+0xe70>
ffffffffc02022c0:	f1ffd0ef          	jal	ra,ffffffffc02001de <__panic>
        assert(vma2 != NULL);
ffffffffc02022c4:	00003697          	auipc	a3,0x3
ffffffffc02022c8:	da468693          	addi	a3,a3,-604 # ffffffffc0205068 <commands+0xf40>
ffffffffc02022cc:	00002617          	auipc	a2,0x2
ffffffffc02022d0:	7cc60613          	addi	a2,a2,1996 # ffffffffc0204a98 <commands+0x970>
ffffffffc02022d4:	0f400593          	li	a1,244
ffffffffc02022d8:	00003517          	auipc	a0,0x3
ffffffffc02022dc:	cc050513          	addi	a0,a0,-832 # ffffffffc0204f98 <commands+0xe70>
ffffffffc02022e0:	efffd0ef          	jal	ra,ffffffffc02001de <__panic>
        assert(vma1 != NULL);
ffffffffc02022e4:	00003697          	auipc	a3,0x3
ffffffffc02022e8:	d7468693          	addi	a3,a3,-652 # ffffffffc0205058 <commands+0xf30>
ffffffffc02022ec:	00002617          	auipc	a2,0x2
ffffffffc02022f0:	7ac60613          	addi	a2,a2,1964 # ffffffffc0204a98 <commands+0x970>
ffffffffc02022f4:	0f200593          	li	a1,242
ffffffffc02022f8:	00003517          	auipc	a0,0x3
ffffffffc02022fc:	ca050513          	addi	a0,a0,-864 # ffffffffc0204f98 <commands+0xe70>
ffffffffc0202300:	edffd0ef          	jal	ra,ffffffffc02001de <__panic>
        assert(vma3 == NULL);
ffffffffc0202304:	00003697          	auipc	a3,0x3
ffffffffc0202308:	d7468693          	addi	a3,a3,-652 # ffffffffc0205078 <commands+0xf50>
ffffffffc020230c:	00002617          	auipc	a2,0x2
ffffffffc0202310:	78c60613          	addi	a2,a2,1932 # ffffffffc0204a98 <commands+0x970>
ffffffffc0202314:	0f600593          	li	a1,246
ffffffffc0202318:	00003517          	auipc	a0,0x3
ffffffffc020231c:	c8050513          	addi	a0,a0,-896 # ffffffffc0204f98 <commands+0xe70>
ffffffffc0202320:	ebffd0ef          	jal	ra,ffffffffc02001de <__panic>
        assert(vma5 == NULL);
ffffffffc0202324:	00003697          	auipc	a3,0x3
ffffffffc0202328:	d7468693          	addi	a3,a3,-652 # ffffffffc0205098 <commands+0xf70>
ffffffffc020232c:	00002617          	auipc	a2,0x2
ffffffffc0202330:	76c60613          	addi	a2,a2,1900 # ffffffffc0204a98 <commands+0x970>
ffffffffc0202334:	0fa00593          	li	a1,250
ffffffffc0202338:	00003517          	auipc	a0,0x3
ffffffffc020233c:	c6050513          	addi	a0,a0,-928 # ffffffffc0204f98 <commands+0xe70>
ffffffffc0202340:	e9ffd0ef          	jal	ra,ffffffffc02001de <__panic>
        assert(vma4 == NULL);
ffffffffc0202344:	00003697          	auipc	a3,0x3
ffffffffc0202348:	d4468693          	addi	a3,a3,-700 # ffffffffc0205088 <commands+0xf60>
ffffffffc020234c:	00002617          	auipc	a2,0x2
ffffffffc0202350:	74c60613          	addi	a2,a2,1868 # ffffffffc0204a98 <commands+0x970>
ffffffffc0202354:	0f800593          	li	a1,248
ffffffffc0202358:	00003517          	auipc	a0,0x3
ffffffffc020235c:	c4050513          	addi	a0,a0,-960 # ffffffffc0204f98 <commands+0xe70>
ffffffffc0202360:	e7ffd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(mm != NULL);
ffffffffc0202364:	00003697          	auipc	a3,0x3
ffffffffc0202368:	e2c68693          	addi	a3,a3,-468 # ffffffffc0205190 <commands+0x1068>
ffffffffc020236c:	00002617          	auipc	a2,0x2
ffffffffc0202370:	72c60613          	addi	a2,a2,1836 # ffffffffc0204a98 <commands+0x970>
ffffffffc0202374:	0d200593          	li	a1,210
ffffffffc0202378:	00003517          	auipc	a0,0x3
ffffffffc020237c:	c2050513          	addi	a0,a0,-992 # ffffffffc0204f98 <commands+0xe70>
ffffffffc0202380:	e5ffd0ef          	jal	ra,ffffffffc02001de <__panic>

ffffffffc0202384 <slob_free>:
static void slob_free(void *block, int size)
{
	slob_t *cur, *b = (slob_t *)block;
	unsigned long flags;

	if (!block)
ffffffffc0202384:	c94d                	beqz	a0,ffffffffc0202436 <slob_free+0xb2>
{
ffffffffc0202386:	1141                	addi	sp,sp,-16
ffffffffc0202388:	e022                	sd	s0,0(sp)
ffffffffc020238a:	e406                	sd	ra,8(sp)
ffffffffc020238c:	842a                	mv	s0,a0
		return;

	if (size)
ffffffffc020238e:	e9c1                	bnez	a1,ffffffffc020241e <slob_free+0x9a>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0202390:	100027f3          	csrr	a5,sstatus
ffffffffc0202394:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0202396:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0202398:	ebd9                	bnez	a5,ffffffffc020242e <slob_free+0xaa>
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc020239a:	00007617          	auipc	a2,0x7
ffffffffc020239e:	c8660613          	addi	a2,a2,-890 # ffffffffc0209020 <slobfree>
ffffffffc02023a2:	621c                	ld	a5,0(a2)
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc02023a4:	873e                	mv	a4,a5
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
ffffffffc02023a6:	679c                	ld	a5,8(a5)
ffffffffc02023a8:	02877a63          	bgeu	a4,s0,ffffffffc02023dc <slob_free+0x58>
ffffffffc02023ac:	00f46463          	bltu	s0,a5,ffffffffc02023b4 <slob_free+0x30>
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc02023b0:	fef76ae3          	bltu	a4,a5,ffffffffc02023a4 <slob_free+0x20>
			break;

	if (b + b->units == cur->next)
ffffffffc02023b4:	400c                	lw	a1,0(s0)
ffffffffc02023b6:	00459693          	slli	a3,a1,0x4
ffffffffc02023ba:	96a2                	add	a3,a3,s0
ffffffffc02023bc:	02d78a63          	beq	a5,a3,ffffffffc02023f0 <slob_free+0x6c>
		b->next = cur->next->next;
	}
	else
		b->next = cur->next;

	if (cur + cur->units == b)
ffffffffc02023c0:	4314                	lw	a3,0(a4)
		b->next = cur->next;
ffffffffc02023c2:	e41c                	sd	a5,8(s0)
	if (cur + cur->units == b)
ffffffffc02023c4:	00469793          	slli	a5,a3,0x4
ffffffffc02023c8:	97ba                	add	a5,a5,a4
ffffffffc02023ca:	02f40e63          	beq	s0,a5,ffffffffc0202406 <slob_free+0x82>
	{
		cur->units += b->units;
		cur->next = b->next;
	}
	else
		cur->next = b;
ffffffffc02023ce:	e700                	sd	s0,8(a4)

	slobfree = cur;
ffffffffc02023d0:	e218                	sd	a4,0(a2)
    if (flag) {
ffffffffc02023d2:	e129                	bnez	a0,ffffffffc0202414 <slob_free+0x90>

	spin_unlock_irqrestore(&slob_lock, flags);
}
ffffffffc02023d4:	60a2                	ld	ra,8(sp)
ffffffffc02023d6:	6402                	ld	s0,0(sp)
ffffffffc02023d8:	0141                	addi	sp,sp,16
ffffffffc02023da:	8082                	ret
		if (cur >= cur->next && (b > cur || b < cur->next))
ffffffffc02023dc:	fcf764e3          	bltu	a4,a5,ffffffffc02023a4 <slob_free+0x20>
ffffffffc02023e0:	fcf472e3          	bgeu	s0,a5,ffffffffc02023a4 <slob_free+0x20>
	if (b + b->units == cur->next)
ffffffffc02023e4:	400c                	lw	a1,0(s0)
ffffffffc02023e6:	00459693          	slli	a3,a1,0x4
ffffffffc02023ea:	96a2                	add	a3,a3,s0
ffffffffc02023ec:	fcd79ae3          	bne	a5,a3,ffffffffc02023c0 <slob_free+0x3c>
		b->units += cur->next->units;
ffffffffc02023f0:	4394                	lw	a3,0(a5)
		b->next = cur->next->next;
ffffffffc02023f2:	679c                	ld	a5,8(a5)
		b->units += cur->next->units;
ffffffffc02023f4:	9db5                	addw	a1,a1,a3
ffffffffc02023f6:	c00c                	sw	a1,0(s0)
	if (cur + cur->units == b)
ffffffffc02023f8:	4314                	lw	a3,0(a4)
		b->next = cur->next->next;
ffffffffc02023fa:	e41c                	sd	a5,8(s0)
	if (cur + cur->units == b)
ffffffffc02023fc:	00469793          	slli	a5,a3,0x4
ffffffffc0202400:	97ba                	add	a5,a5,a4
ffffffffc0202402:	fcf416e3          	bne	s0,a5,ffffffffc02023ce <slob_free+0x4a>
		cur->units += b->units;
ffffffffc0202406:	401c                	lw	a5,0(s0)
		cur->next = b->next;
ffffffffc0202408:	640c                	ld	a1,8(s0)
	slobfree = cur;
ffffffffc020240a:	e218                	sd	a4,0(a2)
		cur->units += b->units;
ffffffffc020240c:	9ebd                	addw	a3,a3,a5
ffffffffc020240e:	c314                	sw	a3,0(a4)
		cur->next = b->next;
ffffffffc0202410:	e70c                	sd	a1,8(a4)
ffffffffc0202412:	d169                	beqz	a0,ffffffffc02023d4 <slob_free+0x50>
}
ffffffffc0202414:	6402                	ld	s0,0(sp)
ffffffffc0202416:	60a2                	ld	ra,8(sp)
ffffffffc0202418:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc020241a:	d16fe06f          	j	ffffffffc0200930 <intr_enable>
		b->units = SLOB_UNITS(size);
ffffffffc020241e:	25bd                	addiw	a1,a1,15
ffffffffc0202420:	8191                	srli	a1,a1,0x4
ffffffffc0202422:	c10c                	sw	a1,0(a0)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0202424:	100027f3          	csrr	a5,sstatus
ffffffffc0202428:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc020242a:	4501                	li	a0,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020242c:	d7bd                	beqz	a5,ffffffffc020239a <slob_free+0x16>
        intr_disable();
ffffffffc020242e:	d08fe0ef          	jal	ra,ffffffffc0200936 <intr_disable>
        return 1;
ffffffffc0202432:	4505                	li	a0,1
ffffffffc0202434:	b79d                	j	ffffffffc020239a <slob_free+0x16>
ffffffffc0202436:	8082                	ret

ffffffffc0202438 <__slob_get_free_pages.constprop.0>:
	struct Page *page = alloc_pages(1 << order);
ffffffffc0202438:	4785                	li	a5,1
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc020243a:	1141                	addi	sp,sp,-16
	struct Page *page = alloc_pages(1 << order);
ffffffffc020243c:	00a7953b          	sllw	a0,a5,a0
static void *__slob_get_free_pages(gfp_t gfp, int order)
ffffffffc0202440:	e406                	sd	ra,8(sp)
	struct Page *page = alloc_pages(1 << order);
ffffffffc0202442:	9d5fe0ef          	jal	ra,ffffffffc0200e16 <alloc_pages>
	if (!page)
ffffffffc0202446:	c91d                	beqz	a0,ffffffffc020247c <__slob_get_free_pages.constprop.0+0x44>
    return page - pages + nbase;
ffffffffc0202448:	0000b697          	auipc	a3,0xb
ffffffffc020244c:	0686b683          	ld	a3,104(a3) # ffffffffc020d4b0 <pages>
ffffffffc0202450:	8d15                	sub	a0,a0,a3
ffffffffc0202452:	8519                	srai	a0,a0,0x6
ffffffffc0202454:	00003697          	auipc	a3,0x3
ffffffffc0202458:	5946b683          	ld	a3,1428(a3) # ffffffffc02059e8 <nbase>
ffffffffc020245c:	9536                	add	a0,a0,a3
    return KADDR(page2pa(page));
ffffffffc020245e:	00c51793          	slli	a5,a0,0xc
ffffffffc0202462:	83b1                	srli	a5,a5,0xc
ffffffffc0202464:	0000b717          	auipc	a4,0xb
ffffffffc0202468:	04473703          	ld	a4,68(a4) # ffffffffc020d4a8 <npage>
    return page2ppn(page) << PGSHIFT;
ffffffffc020246c:	0532                	slli	a0,a0,0xc
    return KADDR(page2pa(page));
ffffffffc020246e:	00e7fa63          	bgeu	a5,a4,ffffffffc0202482 <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc0202472:	0000b697          	auipc	a3,0xb
ffffffffc0202476:	04e6b683          	ld	a3,78(a3) # ffffffffc020d4c0 <va_pa_offset>
ffffffffc020247a:	9536                	add	a0,a0,a3
}
ffffffffc020247c:	60a2                	ld	ra,8(sp)
ffffffffc020247e:	0141                	addi	sp,sp,16
ffffffffc0202480:	8082                	ret
ffffffffc0202482:	86aa                	mv	a3,a0
ffffffffc0202484:	00002617          	auipc	a2,0x2
ffffffffc0202488:	4e460613          	addi	a2,a2,1252 # ffffffffc0204968 <commands+0x840>
ffffffffc020248c:	07100593          	li	a1,113
ffffffffc0202490:	00002517          	auipc	a0,0x2
ffffffffc0202494:	4a050513          	addi	a0,a0,1184 # ffffffffc0204930 <commands+0x808>
ffffffffc0202498:	d47fd0ef          	jal	ra,ffffffffc02001de <__panic>

ffffffffc020249c <slob_alloc.constprop.0>:
static void *slob_alloc(size_t size, gfp_t gfp, int align)
ffffffffc020249c:	1101                	addi	sp,sp,-32
ffffffffc020249e:	ec06                	sd	ra,24(sp)
ffffffffc02024a0:	e822                	sd	s0,16(sp)
ffffffffc02024a2:	e426                	sd	s1,8(sp)
ffffffffc02024a4:	e04a                	sd	s2,0(sp)
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc02024a6:	01050713          	addi	a4,a0,16
ffffffffc02024aa:	6785                	lui	a5,0x1
ffffffffc02024ac:	0cf77363          	bgeu	a4,a5,ffffffffc0202572 <slob_alloc.constprop.0+0xd6>
	int delta = 0, units = SLOB_UNITS(size);
ffffffffc02024b0:	00f50493          	addi	s1,a0,15
ffffffffc02024b4:	8091                	srli	s1,s1,0x4
ffffffffc02024b6:	2481                	sext.w	s1,s1
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02024b8:	10002673          	csrr	a2,sstatus
ffffffffc02024bc:	8a09                	andi	a2,a2,2
ffffffffc02024be:	e25d                	bnez	a2,ffffffffc0202564 <slob_alloc.constprop.0+0xc8>
	prev = slobfree;
ffffffffc02024c0:	00007917          	auipc	s2,0x7
ffffffffc02024c4:	b6090913          	addi	s2,s2,-1184 # ffffffffc0209020 <slobfree>
ffffffffc02024c8:	00093683          	ld	a3,0(s2)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc02024cc:	669c                	ld	a5,8(a3)
		if (cur->units >= units + delta)
ffffffffc02024ce:	4398                	lw	a4,0(a5)
ffffffffc02024d0:	08975e63          	bge	a4,s1,ffffffffc020256c <slob_alloc.constprop.0+0xd0>
		if (cur == slobfree)
ffffffffc02024d4:	00d78b63          	beq	a5,a3,ffffffffc02024ea <slob_alloc.constprop.0+0x4e>
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc02024d8:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta)
ffffffffc02024da:	4018                	lw	a4,0(s0)
ffffffffc02024dc:	02975a63          	bge	a4,s1,ffffffffc0202510 <slob_alloc.constprop.0+0x74>
		if (cur == slobfree)
ffffffffc02024e0:	00093683          	ld	a3,0(s2)
ffffffffc02024e4:	87a2                	mv	a5,s0
ffffffffc02024e6:	fed799e3          	bne	a5,a3,ffffffffc02024d8 <slob_alloc.constprop.0+0x3c>
    if (flag) {
ffffffffc02024ea:	ee31                	bnez	a2,ffffffffc0202546 <slob_alloc.constprop.0+0xaa>
			cur = (slob_t *)__slob_get_free_page(gfp);
ffffffffc02024ec:	4501                	li	a0,0
ffffffffc02024ee:	f4bff0ef          	jal	ra,ffffffffc0202438 <__slob_get_free_pages.constprop.0>
ffffffffc02024f2:	842a                	mv	s0,a0
			if (!cur)
ffffffffc02024f4:	cd05                	beqz	a0,ffffffffc020252c <slob_alloc.constprop.0+0x90>
			slob_free(cur, PAGE_SIZE);
ffffffffc02024f6:	6585                	lui	a1,0x1
ffffffffc02024f8:	e8dff0ef          	jal	ra,ffffffffc0202384 <slob_free>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02024fc:	10002673          	csrr	a2,sstatus
ffffffffc0202500:	8a09                	andi	a2,a2,2
ffffffffc0202502:	ee05                	bnez	a2,ffffffffc020253a <slob_alloc.constprop.0+0x9e>
			cur = slobfree;
ffffffffc0202504:	00093783          	ld	a5,0(s2)
	for (cur = prev->next;; prev = cur, cur = cur->next)
ffffffffc0202508:	6780                	ld	s0,8(a5)
		if (cur->units >= units + delta)
ffffffffc020250a:	4018                	lw	a4,0(s0)
ffffffffc020250c:	fc974ae3          	blt	a4,s1,ffffffffc02024e0 <slob_alloc.constprop.0+0x44>
			if (cur->units == units)	/* exact fit? */
ffffffffc0202510:	04e48763          	beq	s1,a4,ffffffffc020255e <slob_alloc.constprop.0+0xc2>
				prev->next = cur + units;
ffffffffc0202514:	00449693          	slli	a3,s1,0x4
ffffffffc0202518:	96a2                	add	a3,a3,s0
ffffffffc020251a:	e794                	sd	a3,8(a5)
				prev->next->next = cur->next;
ffffffffc020251c:	640c                	ld	a1,8(s0)
				prev->next->units = cur->units - units;
ffffffffc020251e:	9f05                	subw	a4,a4,s1
ffffffffc0202520:	c298                	sw	a4,0(a3)
				prev->next->next = cur->next;
ffffffffc0202522:	e68c                	sd	a1,8(a3)
				cur->units = units;
ffffffffc0202524:	c004                	sw	s1,0(s0)
			slobfree = prev;
ffffffffc0202526:	00f93023          	sd	a5,0(s2)
    if (flag) {
ffffffffc020252a:	e20d                	bnez	a2,ffffffffc020254c <slob_alloc.constprop.0+0xb0>
}
ffffffffc020252c:	60e2                	ld	ra,24(sp)
ffffffffc020252e:	8522                	mv	a0,s0
ffffffffc0202530:	6442                	ld	s0,16(sp)
ffffffffc0202532:	64a2                	ld	s1,8(sp)
ffffffffc0202534:	6902                	ld	s2,0(sp)
ffffffffc0202536:	6105                	addi	sp,sp,32
ffffffffc0202538:	8082                	ret
        intr_disable();
ffffffffc020253a:	bfcfe0ef          	jal	ra,ffffffffc0200936 <intr_disable>
			cur = slobfree;
ffffffffc020253e:	00093783          	ld	a5,0(s2)
        return 1;
ffffffffc0202542:	4605                	li	a2,1
ffffffffc0202544:	b7d1                	j	ffffffffc0202508 <slob_alloc.constprop.0+0x6c>
        intr_enable();
ffffffffc0202546:	beafe0ef          	jal	ra,ffffffffc0200930 <intr_enable>
ffffffffc020254a:	b74d                	j	ffffffffc02024ec <slob_alloc.constprop.0+0x50>
ffffffffc020254c:	be4fe0ef          	jal	ra,ffffffffc0200930 <intr_enable>
}
ffffffffc0202550:	60e2                	ld	ra,24(sp)
ffffffffc0202552:	8522                	mv	a0,s0
ffffffffc0202554:	6442                	ld	s0,16(sp)
ffffffffc0202556:	64a2                	ld	s1,8(sp)
ffffffffc0202558:	6902                	ld	s2,0(sp)
ffffffffc020255a:	6105                	addi	sp,sp,32
ffffffffc020255c:	8082                	ret
				prev->next = cur->next; /* unlink */
ffffffffc020255e:	6418                	ld	a4,8(s0)
ffffffffc0202560:	e798                	sd	a4,8(a5)
ffffffffc0202562:	b7d1                	j	ffffffffc0202526 <slob_alloc.constprop.0+0x8a>
        intr_disable();
ffffffffc0202564:	bd2fe0ef          	jal	ra,ffffffffc0200936 <intr_disable>
        return 1;
ffffffffc0202568:	4605                	li	a2,1
ffffffffc020256a:	bf99                	j	ffffffffc02024c0 <slob_alloc.constprop.0+0x24>
		if (cur->units >= units + delta)
ffffffffc020256c:	843e                	mv	s0,a5
ffffffffc020256e:	87b6                	mv	a5,a3
ffffffffc0202570:	b745                	j	ffffffffc0202510 <slob_alloc.constprop.0+0x74>
	assert((size + SLOB_UNIT) < PAGE_SIZE);
ffffffffc0202572:	00003697          	auipc	a3,0x3
ffffffffc0202576:	c2e68693          	addi	a3,a3,-978 # ffffffffc02051a0 <commands+0x1078>
ffffffffc020257a:	00002617          	auipc	a2,0x2
ffffffffc020257e:	51e60613          	addi	a2,a2,1310 # ffffffffc0204a98 <commands+0x970>
ffffffffc0202582:	06300593          	li	a1,99
ffffffffc0202586:	00003517          	auipc	a0,0x3
ffffffffc020258a:	c3a50513          	addi	a0,a0,-966 # ffffffffc02051c0 <commands+0x1098>
ffffffffc020258e:	c51fd0ef          	jal	ra,ffffffffc02001de <__panic>

ffffffffc0202592 <kmalloc_init>:
	cprintf("use SLOB allocator\n");
}

inline void
kmalloc_init(void)
{
ffffffffc0202592:	1141                	addi	sp,sp,-16
	cprintf("use SLOB allocator\n");
ffffffffc0202594:	00003517          	auipc	a0,0x3
ffffffffc0202598:	c4450513          	addi	a0,a0,-956 # ffffffffc02051d8 <commands+0x10b0>
{
ffffffffc020259c:	e406                	sd	ra,8(sp)
	cprintf("use SLOB allocator\n");
ffffffffc020259e:	b43fd0ef          	jal	ra,ffffffffc02000e0 <cprintf>
	slob_init();
	cprintf("kmalloc_init() succeeded!\n");
}
ffffffffc02025a2:	60a2                	ld	ra,8(sp)
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc02025a4:	00003517          	auipc	a0,0x3
ffffffffc02025a8:	c4c50513          	addi	a0,a0,-948 # ffffffffc02051f0 <commands+0x10c8>
}
ffffffffc02025ac:	0141                	addi	sp,sp,16
	cprintf("kmalloc_init() succeeded!\n");
ffffffffc02025ae:	b33fd06f          	j	ffffffffc02000e0 <cprintf>

ffffffffc02025b2 <kmalloc>:
	return 0;
}

void *
kmalloc(size_t size)
{
ffffffffc02025b2:	1101                	addi	sp,sp,-32
ffffffffc02025b4:	e04a                	sd	s2,0(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc02025b6:	6905                	lui	s2,0x1
{
ffffffffc02025b8:	e822                	sd	s0,16(sp)
ffffffffc02025ba:	ec06                	sd	ra,24(sp)
ffffffffc02025bc:	e426                	sd	s1,8(sp)
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc02025be:	fef90793          	addi	a5,s2,-17 # fef <kern_entry-0xffffffffc01ff011>
{
ffffffffc02025c2:	842a                	mv	s0,a0
	if (size < PAGE_SIZE - SLOB_UNIT)
ffffffffc02025c4:	04a7f963          	bgeu	a5,a0,ffffffffc0202616 <kmalloc+0x64>
	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
ffffffffc02025c8:	4561                	li	a0,24
ffffffffc02025ca:	ed3ff0ef          	jal	ra,ffffffffc020249c <slob_alloc.constprop.0>
ffffffffc02025ce:	84aa                	mv	s1,a0
	if (!bb)
ffffffffc02025d0:	c929                	beqz	a0,ffffffffc0202622 <kmalloc+0x70>
	bb->order = find_order(size);
ffffffffc02025d2:	0004079b          	sext.w	a5,s0
	int order = 0;
ffffffffc02025d6:	4501                	li	a0,0
	for (; size > 4096; size >>= 1)
ffffffffc02025d8:	00f95763          	bge	s2,a5,ffffffffc02025e6 <kmalloc+0x34>
ffffffffc02025dc:	6705                	lui	a4,0x1
ffffffffc02025de:	8785                	srai	a5,a5,0x1
		order++;
ffffffffc02025e0:	2505                	addiw	a0,a0,1
	for (; size > 4096; size >>= 1)
ffffffffc02025e2:	fef74ee3          	blt	a4,a5,ffffffffc02025de <kmalloc+0x2c>
	bb->order = find_order(size);
ffffffffc02025e6:	c088                	sw	a0,0(s1)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
ffffffffc02025e8:	e51ff0ef          	jal	ra,ffffffffc0202438 <__slob_get_free_pages.constprop.0>
ffffffffc02025ec:	e488                	sd	a0,8(s1)
ffffffffc02025ee:	842a                	mv	s0,a0
	if (bb->pages)
ffffffffc02025f0:	c525                	beqz	a0,ffffffffc0202658 <kmalloc+0xa6>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc02025f2:	100027f3          	csrr	a5,sstatus
ffffffffc02025f6:	8b89                	andi	a5,a5,2
ffffffffc02025f8:	ef8d                	bnez	a5,ffffffffc0202632 <kmalloc+0x80>
		bb->next = bigblocks;
ffffffffc02025fa:	0000b797          	auipc	a5,0xb
ffffffffc02025fe:	ece78793          	addi	a5,a5,-306 # ffffffffc020d4c8 <bigblocks>
ffffffffc0202602:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc0202604:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc0202606:	e898                	sd	a4,16(s1)
	return __kmalloc(size, 0);
}
ffffffffc0202608:	60e2                	ld	ra,24(sp)
ffffffffc020260a:	8522                	mv	a0,s0
ffffffffc020260c:	6442                	ld	s0,16(sp)
ffffffffc020260e:	64a2                	ld	s1,8(sp)
ffffffffc0202610:	6902                	ld	s2,0(sp)
ffffffffc0202612:	6105                	addi	sp,sp,32
ffffffffc0202614:	8082                	ret
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
ffffffffc0202616:	0541                	addi	a0,a0,16
ffffffffc0202618:	e85ff0ef          	jal	ra,ffffffffc020249c <slob_alloc.constprop.0>
		return m ? (void *)(m + 1) : 0;
ffffffffc020261c:	01050413          	addi	s0,a0,16
ffffffffc0202620:	f565                	bnez	a0,ffffffffc0202608 <kmalloc+0x56>
ffffffffc0202622:	4401                	li	s0,0
}
ffffffffc0202624:	60e2                	ld	ra,24(sp)
ffffffffc0202626:	8522                	mv	a0,s0
ffffffffc0202628:	6442                	ld	s0,16(sp)
ffffffffc020262a:	64a2                	ld	s1,8(sp)
ffffffffc020262c:	6902                	ld	s2,0(sp)
ffffffffc020262e:	6105                	addi	sp,sp,32
ffffffffc0202630:	8082                	ret
        intr_disable();
ffffffffc0202632:	b04fe0ef          	jal	ra,ffffffffc0200936 <intr_disable>
		bb->next = bigblocks;
ffffffffc0202636:	0000b797          	auipc	a5,0xb
ffffffffc020263a:	e9278793          	addi	a5,a5,-366 # ffffffffc020d4c8 <bigblocks>
ffffffffc020263e:	6398                	ld	a4,0(a5)
		bigblocks = bb;
ffffffffc0202640:	e384                	sd	s1,0(a5)
		bb->next = bigblocks;
ffffffffc0202642:	e898                	sd	a4,16(s1)
        intr_enable();
ffffffffc0202644:	aecfe0ef          	jal	ra,ffffffffc0200930 <intr_enable>
		return bb->pages;
ffffffffc0202648:	6480                	ld	s0,8(s1)
}
ffffffffc020264a:	60e2                	ld	ra,24(sp)
ffffffffc020264c:	64a2                	ld	s1,8(sp)
ffffffffc020264e:	8522                	mv	a0,s0
ffffffffc0202650:	6442                	ld	s0,16(sp)
ffffffffc0202652:	6902                	ld	s2,0(sp)
ffffffffc0202654:	6105                	addi	sp,sp,32
ffffffffc0202656:	8082                	ret
	slob_free(bb, sizeof(bigblock_t));
ffffffffc0202658:	45e1                	li	a1,24
ffffffffc020265a:	8526                	mv	a0,s1
ffffffffc020265c:	d29ff0ef          	jal	ra,ffffffffc0202384 <slob_free>
	return __kmalloc(size, 0);
ffffffffc0202660:	b765                	j	ffffffffc0202608 <kmalloc+0x56>

ffffffffc0202662 <kfree>:
void kfree(void *block)
{
	bigblock_t *bb, **last = &bigblocks;
	unsigned long flags;

	if (!block)
ffffffffc0202662:	c179                	beqz	a0,ffffffffc0202728 <kfree+0xc6>
{
ffffffffc0202664:	1101                	addi	sp,sp,-32
ffffffffc0202666:	e822                	sd	s0,16(sp)
ffffffffc0202668:	ec06                	sd	ra,24(sp)
ffffffffc020266a:	e426                	sd	s1,8(sp)
		return;

	if (!((unsigned long)block & (PAGE_SIZE - 1)))
ffffffffc020266c:	03451793          	slli	a5,a0,0x34
ffffffffc0202670:	842a                	mv	s0,a0
ffffffffc0202672:	e7c1                	bnez	a5,ffffffffc02026fa <kfree+0x98>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0202674:	100027f3          	csrr	a5,sstatus
ffffffffc0202678:	8b89                	andi	a5,a5,2
ffffffffc020267a:	ebc9                	bnez	a5,ffffffffc020270c <kfree+0xaa>
	{
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc020267c:	0000b797          	auipc	a5,0xb
ffffffffc0202680:	e4c7b783          	ld	a5,-436(a5) # ffffffffc020d4c8 <bigblocks>
    return 0;
ffffffffc0202684:	4601                	li	a2,0
ffffffffc0202686:	cbb5                	beqz	a5,ffffffffc02026fa <kfree+0x98>
	bigblock_t *bb, **last = &bigblocks;
ffffffffc0202688:	0000b697          	auipc	a3,0xb
ffffffffc020268c:	e4068693          	addi	a3,a3,-448 # ffffffffc020d4c8 <bigblocks>
ffffffffc0202690:	a021                	j	ffffffffc0202698 <kfree+0x36>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0202692:	01048693          	addi	a3,s1,16
ffffffffc0202696:	c3ad                	beqz	a5,ffffffffc02026f8 <kfree+0x96>
		{
			if (bb->pages == block)
ffffffffc0202698:	6798                	ld	a4,8(a5)
ffffffffc020269a:	84be                	mv	s1,a5
			{
				*last = bb->next;
ffffffffc020269c:	6b9c                	ld	a5,16(a5)
			if (bb->pages == block)
ffffffffc020269e:	fe871ae3          	bne	a4,s0,ffffffffc0202692 <kfree+0x30>
				*last = bb->next;
ffffffffc02026a2:	e29c                	sd	a5,0(a3)
    if (flag) {
ffffffffc02026a4:	ee3d                	bnez	a2,ffffffffc0202722 <kfree+0xc0>
    return pa2page(PADDR(kva));
ffffffffc02026a6:	c02007b7          	lui	a5,0xc0200
				spin_unlock_irqrestore(&block_lock, flags);
				__slob_free_pages((unsigned long)block, bb->order);
ffffffffc02026aa:	4098                	lw	a4,0(s1)
ffffffffc02026ac:	08f46b63          	bltu	s0,a5,ffffffffc0202742 <kfree+0xe0>
ffffffffc02026b0:	0000b697          	auipc	a3,0xb
ffffffffc02026b4:	e106b683          	ld	a3,-496(a3) # ffffffffc020d4c0 <va_pa_offset>
ffffffffc02026b8:	8c15                	sub	s0,s0,a3
    if (PPN(pa) >= npage)
ffffffffc02026ba:	8031                	srli	s0,s0,0xc
ffffffffc02026bc:	0000b797          	auipc	a5,0xb
ffffffffc02026c0:	dec7b783          	ld	a5,-532(a5) # ffffffffc020d4a8 <npage>
ffffffffc02026c4:	06f47363          	bgeu	s0,a5,ffffffffc020272a <kfree+0xc8>
    return &pages[PPN(pa) - nbase];
ffffffffc02026c8:	00003517          	auipc	a0,0x3
ffffffffc02026cc:	32053503          	ld	a0,800(a0) # ffffffffc02059e8 <nbase>
ffffffffc02026d0:	8c09                	sub	s0,s0,a0
ffffffffc02026d2:	041a                	slli	s0,s0,0x6
	free_pages(kva2page(kva), 1 << order);
ffffffffc02026d4:	0000b517          	auipc	a0,0xb
ffffffffc02026d8:	ddc53503          	ld	a0,-548(a0) # ffffffffc020d4b0 <pages>
ffffffffc02026dc:	4585                	li	a1,1
ffffffffc02026de:	9522                	add	a0,a0,s0
ffffffffc02026e0:	00e595bb          	sllw	a1,a1,a4
ffffffffc02026e4:	f70fe0ef          	jal	ra,ffffffffc0200e54 <free_pages>
		spin_unlock_irqrestore(&block_lock, flags);
	}

	slob_free((slob_t *)block - 1, 0);
	return;
}
ffffffffc02026e8:	6442                	ld	s0,16(sp)
ffffffffc02026ea:	60e2                	ld	ra,24(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc02026ec:	8526                	mv	a0,s1
}
ffffffffc02026ee:	64a2                	ld	s1,8(sp)
				slob_free(bb, sizeof(bigblock_t));
ffffffffc02026f0:	45e1                	li	a1,24
}
ffffffffc02026f2:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc02026f4:	c91ff06f          	j	ffffffffc0202384 <slob_free>
ffffffffc02026f8:	e215                	bnez	a2,ffffffffc020271c <kfree+0xba>
ffffffffc02026fa:	ff040513          	addi	a0,s0,-16
}
ffffffffc02026fe:	6442                	ld	s0,16(sp)
ffffffffc0202700:	60e2                	ld	ra,24(sp)
ffffffffc0202702:	64a2                	ld	s1,8(sp)
	slob_free((slob_t *)block - 1, 0);
ffffffffc0202704:	4581                	li	a1,0
}
ffffffffc0202706:	6105                	addi	sp,sp,32
	slob_free((slob_t *)block - 1, 0);
ffffffffc0202708:	c7dff06f          	j	ffffffffc0202384 <slob_free>
        intr_disable();
ffffffffc020270c:	a2afe0ef          	jal	ra,ffffffffc0200936 <intr_disable>
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next)
ffffffffc0202710:	0000b797          	auipc	a5,0xb
ffffffffc0202714:	db87b783          	ld	a5,-584(a5) # ffffffffc020d4c8 <bigblocks>
        return 1;
ffffffffc0202718:	4605                	li	a2,1
ffffffffc020271a:	f7bd                	bnez	a5,ffffffffc0202688 <kfree+0x26>
        intr_enable();
ffffffffc020271c:	a14fe0ef          	jal	ra,ffffffffc0200930 <intr_enable>
ffffffffc0202720:	bfe9                	j	ffffffffc02026fa <kfree+0x98>
ffffffffc0202722:	a0efe0ef          	jal	ra,ffffffffc0200930 <intr_enable>
ffffffffc0202726:	b741                	j	ffffffffc02026a6 <kfree+0x44>
ffffffffc0202728:	8082                	ret
        panic("pa2page called with invalid pa");
ffffffffc020272a:	00002617          	auipc	a2,0x2
ffffffffc020272e:	1e660613          	addi	a2,a2,486 # ffffffffc0204910 <commands+0x7e8>
ffffffffc0202732:	06900593          	li	a1,105
ffffffffc0202736:	00002517          	auipc	a0,0x2
ffffffffc020273a:	1fa50513          	addi	a0,a0,506 # ffffffffc0204930 <commands+0x808>
ffffffffc020273e:	aa1fd0ef          	jal	ra,ffffffffc02001de <__panic>
    return pa2page(PADDR(kva));
ffffffffc0202742:	86a2                	mv	a3,s0
ffffffffc0202744:	00002617          	auipc	a2,0x2
ffffffffc0202748:	2d460613          	addi	a2,a2,724 # ffffffffc0204a18 <commands+0x8f0>
ffffffffc020274c:	07700593          	li	a1,119
ffffffffc0202750:	00002517          	auipc	a0,0x2
ffffffffc0202754:	1e050513          	addi	a0,a0,480 # ffffffffc0204930 <commands+0x808>
ffffffffc0202758:	a87fd0ef          	jal	ra,ffffffffc02001de <__panic>

ffffffffc020275c <default_init>:
    elm->prev = elm->next = elm;
ffffffffc020275c:	00007797          	auipc	a5,0x7
ffffffffc0202760:	cd478793          	addi	a5,a5,-812 # ffffffffc0209430 <free_area>
ffffffffc0202764:	e79c                	sd	a5,8(a5)
ffffffffc0202766:	e39c                	sd	a5,0(a5)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
    list_init(&free_list);
    nr_free = 0;
ffffffffc0202768:	0007a823          	sw	zero,16(a5)
}
ffffffffc020276c:	8082                	ret

ffffffffc020276e <default_nr_free_pages>:
}

static size_t
default_nr_free_pages(void) {
    return nr_free;
}
ffffffffc020276e:	00007517          	auipc	a0,0x7
ffffffffc0202772:	cd256503          	lwu	a0,-814(a0) # ffffffffc0209440 <free_area+0x10>
ffffffffc0202776:	8082                	ret

ffffffffc0202778 <default_check>:
}

// LAB2: below code is used to check the first fit allocation algorithm 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
ffffffffc0202778:	715d                	addi	sp,sp,-80
ffffffffc020277a:	e0a2                	sd	s0,64(sp)
    return listelm->next;
ffffffffc020277c:	00007417          	auipc	s0,0x7
ffffffffc0202780:	cb440413          	addi	s0,s0,-844 # ffffffffc0209430 <free_area>
ffffffffc0202784:	641c                	ld	a5,8(s0)
ffffffffc0202786:	e486                	sd	ra,72(sp)
ffffffffc0202788:	fc26                	sd	s1,56(sp)
ffffffffc020278a:	f84a                	sd	s2,48(sp)
ffffffffc020278c:	f44e                	sd	s3,40(sp)
ffffffffc020278e:	f052                	sd	s4,32(sp)
ffffffffc0202790:	ec56                	sd	s5,24(sp)
ffffffffc0202792:	e85a                	sd	s6,16(sp)
ffffffffc0202794:	e45e                	sd	s7,8(sp)
ffffffffc0202796:	e062                	sd	s8,0(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0202798:	2a878d63          	beq	a5,s0,ffffffffc0202a52 <default_check+0x2da>
    int count = 0, total = 0;
ffffffffc020279c:	4481                	li	s1,0
ffffffffc020279e:	4901                	li	s2,0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc02027a0:	ff07b703          	ld	a4,-16(a5)
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc02027a4:	8b09                	andi	a4,a4,2
ffffffffc02027a6:	2a070a63          	beqz	a4,ffffffffc0202a5a <default_check+0x2e2>
        count ++, total += p->property;
ffffffffc02027aa:	ff87a703          	lw	a4,-8(a5)
ffffffffc02027ae:	679c                	ld	a5,8(a5)
ffffffffc02027b0:	2905                	addiw	s2,s2,1
ffffffffc02027b2:	9cb9                	addw	s1,s1,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc02027b4:	fe8796e3          	bne	a5,s0,ffffffffc02027a0 <default_check+0x28>
    }
    assert(total == nr_free_pages());
ffffffffc02027b8:	89a6                	mv	s3,s1
ffffffffc02027ba:	ed8fe0ef          	jal	ra,ffffffffc0200e92 <nr_free_pages>
ffffffffc02027be:	6f351e63          	bne	a0,s3,ffffffffc0202eba <default_check+0x742>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02027c2:	4505                	li	a0,1
ffffffffc02027c4:	e52fe0ef          	jal	ra,ffffffffc0200e16 <alloc_pages>
ffffffffc02027c8:	8aaa                	mv	s5,a0
ffffffffc02027ca:	42050863          	beqz	a0,ffffffffc0202bfa <default_check+0x482>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02027ce:	4505                	li	a0,1
ffffffffc02027d0:	e46fe0ef          	jal	ra,ffffffffc0200e16 <alloc_pages>
ffffffffc02027d4:	89aa                	mv	s3,a0
ffffffffc02027d6:	70050263          	beqz	a0,ffffffffc0202eda <default_check+0x762>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02027da:	4505                	li	a0,1
ffffffffc02027dc:	e3afe0ef          	jal	ra,ffffffffc0200e16 <alloc_pages>
ffffffffc02027e0:	8a2a                	mv	s4,a0
ffffffffc02027e2:	48050c63          	beqz	a0,ffffffffc0202c7a <default_check+0x502>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc02027e6:	293a8a63          	beq	s5,s3,ffffffffc0202a7a <default_check+0x302>
ffffffffc02027ea:	28aa8863          	beq	s5,a0,ffffffffc0202a7a <default_check+0x302>
ffffffffc02027ee:	28a98663          	beq	s3,a0,ffffffffc0202a7a <default_check+0x302>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc02027f2:	000aa783          	lw	a5,0(s5)
ffffffffc02027f6:	2a079263          	bnez	a5,ffffffffc0202a9a <default_check+0x322>
ffffffffc02027fa:	0009a783          	lw	a5,0(s3)
ffffffffc02027fe:	28079e63          	bnez	a5,ffffffffc0202a9a <default_check+0x322>
ffffffffc0202802:	411c                	lw	a5,0(a0)
ffffffffc0202804:	28079b63          	bnez	a5,ffffffffc0202a9a <default_check+0x322>
    return page - pages + nbase;
ffffffffc0202808:	0000b797          	auipc	a5,0xb
ffffffffc020280c:	ca87b783          	ld	a5,-856(a5) # ffffffffc020d4b0 <pages>
ffffffffc0202810:	40fa8733          	sub	a4,s5,a5
ffffffffc0202814:	00003617          	auipc	a2,0x3
ffffffffc0202818:	1d463603          	ld	a2,468(a2) # ffffffffc02059e8 <nbase>
ffffffffc020281c:	8719                	srai	a4,a4,0x6
ffffffffc020281e:	9732                	add	a4,a4,a2
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0202820:	0000b697          	auipc	a3,0xb
ffffffffc0202824:	c886b683          	ld	a3,-888(a3) # ffffffffc020d4a8 <npage>
ffffffffc0202828:	06b2                	slli	a3,a3,0xc
    return page2ppn(page) << PGSHIFT;
ffffffffc020282a:	0732                	slli	a4,a4,0xc
ffffffffc020282c:	28d77763          	bgeu	a4,a3,ffffffffc0202aba <default_check+0x342>
    return page - pages + nbase;
ffffffffc0202830:	40f98733          	sub	a4,s3,a5
ffffffffc0202834:	8719                	srai	a4,a4,0x6
ffffffffc0202836:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0202838:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc020283a:	4cd77063          	bgeu	a4,a3,ffffffffc0202cfa <default_check+0x582>
    return page - pages + nbase;
ffffffffc020283e:	40f507b3          	sub	a5,a0,a5
ffffffffc0202842:	8799                	srai	a5,a5,0x6
ffffffffc0202844:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0202846:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0202848:	30d7f963          	bgeu	a5,a3,ffffffffc0202b5a <default_check+0x3e2>
    assert(alloc_page() == NULL);
ffffffffc020284c:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc020284e:	00043c03          	ld	s8,0(s0)
ffffffffc0202852:	00843b83          	ld	s7,8(s0)
    unsigned int nr_free_store = nr_free;
ffffffffc0202856:	01042b03          	lw	s6,16(s0)
    elm->prev = elm->next = elm;
ffffffffc020285a:	e400                	sd	s0,8(s0)
ffffffffc020285c:	e000                	sd	s0,0(s0)
    nr_free = 0;
ffffffffc020285e:	00007797          	auipc	a5,0x7
ffffffffc0202862:	be07a123          	sw	zero,-1054(a5) # ffffffffc0209440 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc0202866:	db0fe0ef          	jal	ra,ffffffffc0200e16 <alloc_pages>
ffffffffc020286a:	2c051863          	bnez	a0,ffffffffc0202b3a <default_check+0x3c2>
    free_page(p0);
ffffffffc020286e:	4585                	li	a1,1
ffffffffc0202870:	8556                	mv	a0,s5
ffffffffc0202872:	de2fe0ef          	jal	ra,ffffffffc0200e54 <free_pages>
    free_page(p1);
ffffffffc0202876:	4585                	li	a1,1
ffffffffc0202878:	854e                	mv	a0,s3
ffffffffc020287a:	ddafe0ef          	jal	ra,ffffffffc0200e54 <free_pages>
    free_page(p2);
ffffffffc020287e:	4585                	li	a1,1
ffffffffc0202880:	8552                	mv	a0,s4
ffffffffc0202882:	dd2fe0ef          	jal	ra,ffffffffc0200e54 <free_pages>
    assert(nr_free == 3);
ffffffffc0202886:	4818                	lw	a4,16(s0)
ffffffffc0202888:	478d                	li	a5,3
ffffffffc020288a:	28f71863          	bne	a4,a5,ffffffffc0202b1a <default_check+0x3a2>
    assert((p0 = alloc_page()) != NULL);
ffffffffc020288e:	4505                	li	a0,1
ffffffffc0202890:	d86fe0ef          	jal	ra,ffffffffc0200e16 <alloc_pages>
ffffffffc0202894:	89aa                	mv	s3,a0
ffffffffc0202896:	26050263          	beqz	a0,ffffffffc0202afa <default_check+0x382>
    assert((p1 = alloc_page()) != NULL);
ffffffffc020289a:	4505                	li	a0,1
ffffffffc020289c:	d7afe0ef          	jal	ra,ffffffffc0200e16 <alloc_pages>
ffffffffc02028a0:	8aaa                	mv	s5,a0
ffffffffc02028a2:	3a050c63          	beqz	a0,ffffffffc0202c5a <default_check+0x4e2>
    assert((p2 = alloc_page()) != NULL);
ffffffffc02028a6:	4505                	li	a0,1
ffffffffc02028a8:	d6efe0ef          	jal	ra,ffffffffc0200e16 <alloc_pages>
ffffffffc02028ac:	8a2a                	mv	s4,a0
ffffffffc02028ae:	38050663          	beqz	a0,ffffffffc0202c3a <default_check+0x4c2>
    assert(alloc_page() == NULL);
ffffffffc02028b2:	4505                	li	a0,1
ffffffffc02028b4:	d62fe0ef          	jal	ra,ffffffffc0200e16 <alloc_pages>
ffffffffc02028b8:	36051163          	bnez	a0,ffffffffc0202c1a <default_check+0x4a2>
    free_page(p0);
ffffffffc02028bc:	4585                	li	a1,1
ffffffffc02028be:	854e                	mv	a0,s3
ffffffffc02028c0:	d94fe0ef          	jal	ra,ffffffffc0200e54 <free_pages>
    assert(!list_empty(&free_list));
ffffffffc02028c4:	641c                	ld	a5,8(s0)
ffffffffc02028c6:	20878a63          	beq	a5,s0,ffffffffc0202ada <default_check+0x362>
    assert((p = alloc_page()) == p0);
ffffffffc02028ca:	4505                	li	a0,1
ffffffffc02028cc:	d4afe0ef          	jal	ra,ffffffffc0200e16 <alloc_pages>
ffffffffc02028d0:	30a99563          	bne	s3,a0,ffffffffc0202bda <default_check+0x462>
    assert(alloc_page() == NULL);
ffffffffc02028d4:	4505                	li	a0,1
ffffffffc02028d6:	d40fe0ef          	jal	ra,ffffffffc0200e16 <alloc_pages>
ffffffffc02028da:	2e051063          	bnez	a0,ffffffffc0202bba <default_check+0x442>
    assert(nr_free == 0);
ffffffffc02028de:	481c                	lw	a5,16(s0)
ffffffffc02028e0:	2a079d63          	bnez	a5,ffffffffc0202b9a <default_check+0x422>
    free_page(p);
ffffffffc02028e4:	854e                	mv	a0,s3
ffffffffc02028e6:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc02028e8:	01843023          	sd	s8,0(s0)
ffffffffc02028ec:	01743423          	sd	s7,8(s0)
    nr_free = nr_free_store;
ffffffffc02028f0:	01642823          	sw	s6,16(s0)
    free_page(p);
ffffffffc02028f4:	d60fe0ef          	jal	ra,ffffffffc0200e54 <free_pages>
    free_page(p1);
ffffffffc02028f8:	4585                	li	a1,1
ffffffffc02028fa:	8556                	mv	a0,s5
ffffffffc02028fc:	d58fe0ef          	jal	ra,ffffffffc0200e54 <free_pages>
    free_page(p2);
ffffffffc0202900:	4585                	li	a1,1
ffffffffc0202902:	8552                	mv	a0,s4
ffffffffc0202904:	d50fe0ef          	jal	ra,ffffffffc0200e54 <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc0202908:	4515                	li	a0,5
ffffffffc020290a:	d0cfe0ef          	jal	ra,ffffffffc0200e16 <alloc_pages>
ffffffffc020290e:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc0202910:	26050563          	beqz	a0,ffffffffc0202b7a <default_check+0x402>
ffffffffc0202914:	651c                	ld	a5,8(a0)
ffffffffc0202916:	8385                	srli	a5,a5,0x1
    assert(!PageProperty(p0));
ffffffffc0202918:	8b85                	andi	a5,a5,1
ffffffffc020291a:	54079063          	bnez	a5,ffffffffc0202e5a <default_check+0x6e2>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc020291e:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0202920:	00043b03          	ld	s6,0(s0)
ffffffffc0202924:	00843a83          	ld	s5,8(s0)
ffffffffc0202928:	e000                	sd	s0,0(s0)
ffffffffc020292a:	e400                	sd	s0,8(s0)
    assert(alloc_page() == NULL);
ffffffffc020292c:	ceafe0ef          	jal	ra,ffffffffc0200e16 <alloc_pages>
ffffffffc0202930:	50051563          	bnez	a0,ffffffffc0202e3a <default_check+0x6c2>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc0202934:	08098a13          	addi	s4,s3,128
ffffffffc0202938:	8552                	mv	a0,s4
ffffffffc020293a:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc020293c:	01042b83          	lw	s7,16(s0)
    nr_free = 0;
ffffffffc0202940:	00007797          	auipc	a5,0x7
ffffffffc0202944:	b007a023          	sw	zero,-1280(a5) # ffffffffc0209440 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc0202948:	d0cfe0ef          	jal	ra,ffffffffc0200e54 <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc020294c:	4511                	li	a0,4
ffffffffc020294e:	cc8fe0ef          	jal	ra,ffffffffc0200e16 <alloc_pages>
ffffffffc0202952:	4c051463          	bnez	a0,ffffffffc0202e1a <default_check+0x6a2>
ffffffffc0202956:	0889b783          	ld	a5,136(s3)
ffffffffc020295a:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc020295c:	8b85                	andi	a5,a5,1
ffffffffc020295e:	48078e63          	beqz	a5,ffffffffc0202dfa <default_check+0x682>
ffffffffc0202962:	0909a703          	lw	a4,144(s3)
ffffffffc0202966:	478d                	li	a5,3
ffffffffc0202968:	48f71963          	bne	a4,a5,ffffffffc0202dfa <default_check+0x682>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc020296c:	450d                	li	a0,3
ffffffffc020296e:	ca8fe0ef          	jal	ra,ffffffffc0200e16 <alloc_pages>
ffffffffc0202972:	8c2a                	mv	s8,a0
ffffffffc0202974:	46050363          	beqz	a0,ffffffffc0202dda <default_check+0x662>
    assert(alloc_page() == NULL);
ffffffffc0202978:	4505                	li	a0,1
ffffffffc020297a:	c9cfe0ef          	jal	ra,ffffffffc0200e16 <alloc_pages>
ffffffffc020297e:	42051e63          	bnez	a0,ffffffffc0202dba <default_check+0x642>
    assert(p0 + 2 == p1);
ffffffffc0202982:	418a1c63          	bne	s4,s8,ffffffffc0202d9a <default_check+0x622>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc0202986:	4585                	li	a1,1
ffffffffc0202988:	854e                	mv	a0,s3
ffffffffc020298a:	ccafe0ef          	jal	ra,ffffffffc0200e54 <free_pages>
    free_pages(p1, 3);
ffffffffc020298e:	458d                	li	a1,3
ffffffffc0202990:	8552                	mv	a0,s4
ffffffffc0202992:	cc2fe0ef          	jal	ra,ffffffffc0200e54 <free_pages>
ffffffffc0202996:	0089b783          	ld	a5,8(s3)
    p2 = p0 + 1;
ffffffffc020299a:	04098c13          	addi	s8,s3,64
ffffffffc020299e:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc02029a0:	8b85                	andi	a5,a5,1
ffffffffc02029a2:	3c078c63          	beqz	a5,ffffffffc0202d7a <default_check+0x602>
ffffffffc02029a6:	0109a703          	lw	a4,16(s3)
ffffffffc02029aa:	4785                	li	a5,1
ffffffffc02029ac:	3cf71763          	bne	a4,a5,ffffffffc0202d7a <default_check+0x602>
ffffffffc02029b0:	008a3783          	ld	a5,8(s4)
ffffffffc02029b4:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc02029b6:	8b85                	andi	a5,a5,1
ffffffffc02029b8:	3a078163          	beqz	a5,ffffffffc0202d5a <default_check+0x5e2>
ffffffffc02029bc:	010a2703          	lw	a4,16(s4)
ffffffffc02029c0:	478d                	li	a5,3
ffffffffc02029c2:	38f71c63          	bne	a4,a5,ffffffffc0202d5a <default_check+0x5e2>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc02029c6:	4505                	li	a0,1
ffffffffc02029c8:	c4efe0ef          	jal	ra,ffffffffc0200e16 <alloc_pages>
ffffffffc02029cc:	36a99763          	bne	s3,a0,ffffffffc0202d3a <default_check+0x5c2>
    free_page(p0);
ffffffffc02029d0:	4585                	li	a1,1
ffffffffc02029d2:	c82fe0ef          	jal	ra,ffffffffc0200e54 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc02029d6:	4509                	li	a0,2
ffffffffc02029d8:	c3efe0ef          	jal	ra,ffffffffc0200e16 <alloc_pages>
ffffffffc02029dc:	32aa1f63          	bne	s4,a0,ffffffffc0202d1a <default_check+0x5a2>

    free_pages(p0, 2);
ffffffffc02029e0:	4589                	li	a1,2
ffffffffc02029e2:	c72fe0ef          	jal	ra,ffffffffc0200e54 <free_pages>
    free_page(p2);
ffffffffc02029e6:	4585                	li	a1,1
ffffffffc02029e8:	8562                	mv	a0,s8
ffffffffc02029ea:	c6afe0ef          	jal	ra,ffffffffc0200e54 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc02029ee:	4515                	li	a0,5
ffffffffc02029f0:	c26fe0ef          	jal	ra,ffffffffc0200e16 <alloc_pages>
ffffffffc02029f4:	89aa                	mv	s3,a0
ffffffffc02029f6:	48050263          	beqz	a0,ffffffffc0202e7a <default_check+0x702>
    assert(alloc_page() == NULL);
ffffffffc02029fa:	4505                	li	a0,1
ffffffffc02029fc:	c1afe0ef          	jal	ra,ffffffffc0200e16 <alloc_pages>
ffffffffc0202a00:	2c051d63          	bnez	a0,ffffffffc0202cda <default_check+0x562>

    assert(nr_free == 0);
ffffffffc0202a04:	481c                	lw	a5,16(s0)
ffffffffc0202a06:	2a079a63          	bnez	a5,ffffffffc0202cba <default_check+0x542>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc0202a0a:	4595                	li	a1,5
ffffffffc0202a0c:	854e                	mv	a0,s3
    nr_free = nr_free_store;
ffffffffc0202a0e:	01742823          	sw	s7,16(s0)
    free_list = free_list_store;
ffffffffc0202a12:	01643023          	sd	s6,0(s0)
ffffffffc0202a16:	01543423          	sd	s5,8(s0)
    free_pages(p0, 5);
ffffffffc0202a1a:	c3afe0ef          	jal	ra,ffffffffc0200e54 <free_pages>
    return listelm->next;
ffffffffc0202a1e:	641c                	ld	a5,8(s0)

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0202a20:	00878963          	beq	a5,s0,ffffffffc0202a32 <default_check+0x2ba>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
ffffffffc0202a24:	ff87a703          	lw	a4,-8(a5)
ffffffffc0202a28:	679c                	ld	a5,8(a5)
ffffffffc0202a2a:	397d                	addiw	s2,s2,-1
ffffffffc0202a2c:	9c99                	subw	s1,s1,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0202a2e:	fe879be3          	bne	a5,s0,ffffffffc0202a24 <default_check+0x2ac>
    }
    assert(count == 0);
ffffffffc0202a32:	26091463          	bnez	s2,ffffffffc0202c9a <default_check+0x522>
    assert(total == 0);
ffffffffc0202a36:	46049263          	bnez	s1,ffffffffc0202e9a <default_check+0x722>
}
ffffffffc0202a3a:	60a6                	ld	ra,72(sp)
ffffffffc0202a3c:	6406                	ld	s0,64(sp)
ffffffffc0202a3e:	74e2                	ld	s1,56(sp)
ffffffffc0202a40:	7942                	ld	s2,48(sp)
ffffffffc0202a42:	79a2                	ld	s3,40(sp)
ffffffffc0202a44:	7a02                	ld	s4,32(sp)
ffffffffc0202a46:	6ae2                	ld	s5,24(sp)
ffffffffc0202a48:	6b42                	ld	s6,16(sp)
ffffffffc0202a4a:	6ba2                	ld	s7,8(sp)
ffffffffc0202a4c:	6c02                	ld	s8,0(sp)
ffffffffc0202a4e:	6161                	addi	sp,sp,80
ffffffffc0202a50:	8082                	ret
    while ((le = list_next(le)) != &free_list) {
ffffffffc0202a52:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc0202a54:	4481                	li	s1,0
ffffffffc0202a56:	4901                	li	s2,0
ffffffffc0202a58:	b38d                	j	ffffffffc02027ba <default_check+0x42>
        assert(PageProperty(p));
ffffffffc0202a5a:	00002697          	auipc	a3,0x2
ffffffffc0202a5e:	7b668693          	addi	a3,a3,1974 # ffffffffc0205210 <commands+0x10e8>
ffffffffc0202a62:	00002617          	auipc	a2,0x2
ffffffffc0202a66:	03660613          	addi	a2,a2,54 # ffffffffc0204a98 <commands+0x970>
ffffffffc0202a6a:	0f000593          	li	a1,240
ffffffffc0202a6e:	00002517          	auipc	a0,0x2
ffffffffc0202a72:	7b250513          	addi	a0,a0,1970 # ffffffffc0205220 <commands+0x10f8>
ffffffffc0202a76:	f68fd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0202a7a:	00003697          	auipc	a3,0x3
ffffffffc0202a7e:	83e68693          	addi	a3,a3,-1986 # ffffffffc02052b8 <commands+0x1190>
ffffffffc0202a82:	00002617          	auipc	a2,0x2
ffffffffc0202a86:	01660613          	addi	a2,a2,22 # ffffffffc0204a98 <commands+0x970>
ffffffffc0202a8a:	0bd00593          	li	a1,189
ffffffffc0202a8e:	00002517          	auipc	a0,0x2
ffffffffc0202a92:	79250513          	addi	a0,a0,1938 # ffffffffc0205220 <commands+0x10f8>
ffffffffc0202a96:	f48fd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0202a9a:	00003697          	auipc	a3,0x3
ffffffffc0202a9e:	84668693          	addi	a3,a3,-1978 # ffffffffc02052e0 <commands+0x11b8>
ffffffffc0202aa2:	00002617          	auipc	a2,0x2
ffffffffc0202aa6:	ff660613          	addi	a2,a2,-10 # ffffffffc0204a98 <commands+0x970>
ffffffffc0202aaa:	0be00593          	li	a1,190
ffffffffc0202aae:	00002517          	auipc	a0,0x2
ffffffffc0202ab2:	77250513          	addi	a0,a0,1906 # ffffffffc0205220 <commands+0x10f8>
ffffffffc0202ab6:	f28fd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0202aba:	00003697          	auipc	a3,0x3
ffffffffc0202abe:	86668693          	addi	a3,a3,-1946 # ffffffffc0205320 <commands+0x11f8>
ffffffffc0202ac2:	00002617          	auipc	a2,0x2
ffffffffc0202ac6:	fd660613          	addi	a2,a2,-42 # ffffffffc0204a98 <commands+0x970>
ffffffffc0202aca:	0c000593          	li	a1,192
ffffffffc0202ace:	00002517          	auipc	a0,0x2
ffffffffc0202ad2:	75250513          	addi	a0,a0,1874 # ffffffffc0205220 <commands+0x10f8>
ffffffffc0202ad6:	f08fd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(!list_empty(&free_list));
ffffffffc0202ada:	00003697          	auipc	a3,0x3
ffffffffc0202ade:	8ce68693          	addi	a3,a3,-1842 # ffffffffc02053a8 <commands+0x1280>
ffffffffc0202ae2:	00002617          	auipc	a2,0x2
ffffffffc0202ae6:	fb660613          	addi	a2,a2,-74 # ffffffffc0204a98 <commands+0x970>
ffffffffc0202aea:	0d900593          	li	a1,217
ffffffffc0202aee:	00002517          	auipc	a0,0x2
ffffffffc0202af2:	73250513          	addi	a0,a0,1842 # ffffffffc0205220 <commands+0x10f8>
ffffffffc0202af6:	ee8fd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0202afa:	00002697          	auipc	a3,0x2
ffffffffc0202afe:	75e68693          	addi	a3,a3,1886 # ffffffffc0205258 <commands+0x1130>
ffffffffc0202b02:	00002617          	auipc	a2,0x2
ffffffffc0202b06:	f9660613          	addi	a2,a2,-106 # ffffffffc0204a98 <commands+0x970>
ffffffffc0202b0a:	0d200593          	li	a1,210
ffffffffc0202b0e:	00002517          	auipc	a0,0x2
ffffffffc0202b12:	71250513          	addi	a0,a0,1810 # ffffffffc0205220 <commands+0x10f8>
ffffffffc0202b16:	ec8fd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(nr_free == 3);
ffffffffc0202b1a:	00003697          	auipc	a3,0x3
ffffffffc0202b1e:	87e68693          	addi	a3,a3,-1922 # ffffffffc0205398 <commands+0x1270>
ffffffffc0202b22:	00002617          	auipc	a2,0x2
ffffffffc0202b26:	f7660613          	addi	a2,a2,-138 # ffffffffc0204a98 <commands+0x970>
ffffffffc0202b2a:	0d000593          	li	a1,208
ffffffffc0202b2e:	00002517          	auipc	a0,0x2
ffffffffc0202b32:	6f250513          	addi	a0,a0,1778 # ffffffffc0205220 <commands+0x10f8>
ffffffffc0202b36:	ea8fd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(alloc_page() == NULL);
ffffffffc0202b3a:	00003697          	auipc	a3,0x3
ffffffffc0202b3e:	84668693          	addi	a3,a3,-1978 # ffffffffc0205380 <commands+0x1258>
ffffffffc0202b42:	00002617          	auipc	a2,0x2
ffffffffc0202b46:	f5660613          	addi	a2,a2,-170 # ffffffffc0204a98 <commands+0x970>
ffffffffc0202b4a:	0cb00593          	li	a1,203
ffffffffc0202b4e:	00002517          	auipc	a0,0x2
ffffffffc0202b52:	6d250513          	addi	a0,a0,1746 # ffffffffc0205220 <commands+0x10f8>
ffffffffc0202b56:	e88fd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc0202b5a:	00003697          	auipc	a3,0x3
ffffffffc0202b5e:	80668693          	addi	a3,a3,-2042 # ffffffffc0205360 <commands+0x1238>
ffffffffc0202b62:	00002617          	auipc	a2,0x2
ffffffffc0202b66:	f3660613          	addi	a2,a2,-202 # ffffffffc0204a98 <commands+0x970>
ffffffffc0202b6a:	0c200593          	li	a1,194
ffffffffc0202b6e:	00002517          	auipc	a0,0x2
ffffffffc0202b72:	6b250513          	addi	a0,a0,1714 # ffffffffc0205220 <commands+0x10f8>
ffffffffc0202b76:	e68fd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(p0 != NULL);
ffffffffc0202b7a:	00003697          	auipc	a3,0x3
ffffffffc0202b7e:	87668693          	addi	a3,a3,-1930 # ffffffffc02053f0 <commands+0x12c8>
ffffffffc0202b82:	00002617          	auipc	a2,0x2
ffffffffc0202b86:	f1660613          	addi	a2,a2,-234 # ffffffffc0204a98 <commands+0x970>
ffffffffc0202b8a:	0f800593          	li	a1,248
ffffffffc0202b8e:	00002517          	auipc	a0,0x2
ffffffffc0202b92:	69250513          	addi	a0,a0,1682 # ffffffffc0205220 <commands+0x10f8>
ffffffffc0202b96:	e48fd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(nr_free == 0);
ffffffffc0202b9a:	00003697          	auipc	a3,0x3
ffffffffc0202b9e:	84668693          	addi	a3,a3,-1978 # ffffffffc02053e0 <commands+0x12b8>
ffffffffc0202ba2:	00002617          	auipc	a2,0x2
ffffffffc0202ba6:	ef660613          	addi	a2,a2,-266 # ffffffffc0204a98 <commands+0x970>
ffffffffc0202baa:	0df00593          	li	a1,223
ffffffffc0202bae:	00002517          	auipc	a0,0x2
ffffffffc0202bb2:	67250513          	addi	a0,a0,1650 # ffffffffc0205220 <commands+0x10f8>
ffffffffc0202bb6:	e28fd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(alloc_page() == NULL);
ffffffffc0202bba:	00002697          	auipc	a3,0x2
ffffffffc0202bbe:	7c668693          	addi	a3,a3,1990 # ffffffffc0205380 <commands+0x1258>
ffffffffc0202bc2:	00002617          	auipc	a2,0x2
ffffffffc0202bc6:	ed660613          	addi	a2,a2,-298 # ffffffffc0204a98 <commands+0x970>
ffffffffc0202bca:	0dd00593          	li	a1,221
ffffffffc0202bce:	00002517          	auipc	a0,0x2
ffffffffc0202bd2:	65250513          	addi	a0,a0,1618 # ffffffffc0205220 <commands+0x10f8>
ffffffffc0202bd6:	e08fd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc0202bda:	00002697          	auipc	a3,0x2
ffffffffc0202bde:	7e668693          	addi	a3,a3,2022 # ffffffffc02053c0 <commands+0x1298>
ffffffffc0202be2:	00002617          	auipc	a2,0x2
ffffffffc0202be6:	eb660613          	addi	a2,a2,-330 # ffffffffc0204a98 <commands+0x970>
ffffffffc0202bea:	0dc00593          	li	a1,220
ffffffffc0202bee:	00002517          	auipc	a0,0x2
ffffffffc0202bf2:	63250513          	addi	a0,a0,1586 # ffffffffc0205220 <commands+0x10f8>
ffffffffc0202bf6:	de8fd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0202bfa:	00002697          	auipc	a3,0x2
ffffffffc0202bfe:	65e68693          	addi	a3,a3,1630 # ffffffffc0205258 <commands+0x1130>
ffffffffc0202c02:	00002617          	auipc	a2,0x2
ffffffffc0202c06:	e9660613          	addi	a2,a2,-362 # ffffffffc0204a98 <commands+0x970>
ffffffffc0202c0a:	0b900593          	li	a1,185
ffffffffc0202c0e:	00002517          	auipc	a0,0x2
ffffffffc0202c12:	61250513          	addi	a0,a0,1554 # ffffffffc0205220 <commands+0x10f8>
ffffffffc0202c16:	dc8fd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(alloc_page() == NULL);
ffffffffc0202c1a:	00002697          	auipc	a3,0x2
ffffffffc0202c1e:	76668693          	addi	a3,a3,1894 # ffffffffc0205380 <commands+0x1258>
ffffffffc0202c22:	00002617          	auipc	a2,0x2
ffffffffc0202c26:	e7660613          	addi	a2,a2,-394 # ffffffffc0204a98 <commands+0x970>
ffffffffc0202c2a:	0d600593          	li	a1,214
ffffffffc0202c2e:	00002517          	auipc	a0,0x2
ffffffffc0202c32:	5f250513          	addi	a0,a0,1522 # ffffffffc0205220 <commands+0x10f8>
ffffffffc0202c36:	da8fd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0202c3a:	00002697          	auipc	a3,0x2
ffffffffc0202c3e:	65e68693          	addi	a3,a3,1630 # ffffffffc0205298 <commands+0x1170>
ffffffffc0202c42:	00002617          	auipc	a2,0x2
ffffffffc0202c46:	e5660613          	addi	a2,a2,-426 # ffffffffc0204a98 <commands+0x970>
ffffffffc0202c4a:	0d400593          	li	a1,212
ffffffffc0202c4e:	00002517          	auipc	a0,0x2
ffffffffc0202c52:	5d250513          	addi	a0,a0,1490 # ffffffffc0205220 <commands+0x10f8>
ffffffffc0202c56:	d88fd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0202c5a:	00002697          	auipc	a3,0x2
ffffffffc0202c5e:	61e68693          	addi	a3,a3,1566 # ffffffffc0205278 <commands+0x1150>
ffffffffc0202c62:	00002617          	auipc	a2,0x2
ffffffffc0202c66:	e3660613          	addi	a2,a2,-458 # ffffffffc0204a98 <commands+0x970>
ffffffffc0202c6a:	0d300593          	li	a1,211
ffffffffc0202c6e:	00002517          	auipc	a0,0x2
ffffffffc0202c72:	5b250513          	addi	a0,a0,1458 # ffffffffc0205220 <commands+0x10f8>
ffffffffc0202c76:	d68fd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0202c7a:	00002697          	auipc	a3,0x2
ffffffffc0202c7e:	61e68693          	addi	a3,a3,1566 # ffffffffc0205298 <commands+0x1170>
ffffffffc0202c82:	00002617          	auipc	a2,0x2
ffffffffc0202c86:	e1660613          	addi	a2,a2,-490 # ffffffffc0204a98 <commands+0x970>
ffffffffc0202c8a:	0bb00593          	li	a1,187
ffffffffc0202c8e:	00002517          	auipc	a0,0x2
ffffffffc0202c92:	59250513          	addi	a0,a0,1426 # ffffffffc0205220 <commands+0x10f8>
ffffffffc0202c96:	d48fd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(count == 0);
ffffffffc0202c9a:	00003697          	auipc	a3,0x3
ffffffffc0202c9e:	8a668693          	addi	a3,a3,-1882 # ffffffffc0205540 <commands+0x1418>
ffffffffc0202ca2:	00002617          	auipc	a2,0x2
ffffffffc0202ca6:	df660613          	addi	a2,a2,-522 # ffffffffc0204a98 <commands+0x970>
ffffffffc0202caa:	12500593          	li	a1,293
ffffffffc0202cae:	00002517          	auipc	a0,0x2
ffffffffc0202cb2:	57250513          	addi	a0,a0,1394 # ffffffffc0205220 <commands+0x10f8>
ffffffffc0202cb6:	d28fd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(nr_free == 0);
ffffffffc0202cba:	00002697          	auipc	a3,0x2
ffffffffc0202cbe:	72668693          	addi	a3,a3,1830 # ffffffffc02053e0 <commands+0x12b8>
ffffffffc0202cc2:	00002617          	auipc	a2,0x2
ffffffffc0202cc6:	dd660613          	addi	a2,a2,-554 # ffffffffc0204a98 <commands+0x970>
ffffffffc0202cca:	11a00593          	li	a1,282
ffffffffc0202cce:	00002517          	auipc	a0,0x2
ffffffffc0202cd2:	55250513          	addi	a0,a0,1362 # ffffffffc0205220 <commands+0x10f8>
ffffffffc0202cd6:	d08fd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(alloc_page() == NULL);
ffffffffc0202cda:	00002697          	auipc	a3,0x2
ffffffffc0202cde:	6a668693          	addi	a3,a3,1702 # ffffffffc0205380 <commands+0x1258>
ffffffffc0202ce2:	00002617          	auipc	a2,0x2
ffffffffc0202ce6:	db660613          	addi	a2,a2,-586 # ffffffffc0204a98 <commands+0x970>
ffffffffc0202cea:	11800593          	li	a1,280
ffffffffc0202cee:	00002517          	auipc	a0,0x2
ffffffffc0202cf2:	53250513          	addi	a0,a0,1330 # ffffffffc0205220 <commands+0x10f8>
ffffffffc0202cf6:	ce8fd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc0202cfa:	00002697          	auipc	a3,0x2
ffffffffc0202cfe:	64668693          	addi	a3,a3,1606 # ffffffffc0205340 <commands+0x1218>
ffffffffc0202d02:	00002617          	auipc	a2,0x2
ffffffffc0202d06:	d9660613          	addi	a2,a2,-618 # ffffffffc0204a98 <commands+0x970>
ffffffffc0202d0a:	0c100593          	li	a1,193
ffffffffc0202d0e:	00002517          	auipc	a0,0x2
ffffffffc0202d12:	51250513          	addi	a0,a0,1298 # ffffffffc0205220 <commands+0x10f8>
ffffffffc0202d16:	cc8fd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc0202d1a:	00002697          	auipc	a3,0x2
ffffffffc0202d1e:	7e668693          	addi	a3,a3,2022 # ffffffffc0205500 <commands+0x13d8>
ffffffffc0202d22:	00002617          	auipc	a2,0x2
ffffffffc0202d26:	d7660613          	addi	a2,a2,-650 # ffffffffc0204a98 <commands+0x970>
ffffffffc0202d2a:	11200593          	li	a1,274
ffffffffc0202d2e:	00002517          	auipc	a0,0x2
ffffffffc0202d32:	4f250513          	addi	a0,a0,1266 # ffffffffc0205220 <commands+0x10f8>
ffffffffc0202d36:	ca8fd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc0202d3a:	00002697          	auipc	a3,0x2
ffffffffc0202d3e:	7a668693          	addi	a3,a3,1958 # ffffffffc02054e0 <commands+0x13b8>
ffffffffc0202d42:	00002617          	auipc	a2,0x2
ffffffffc0202d46:	d5660613          	addi	a2,a2,-682 # ffffffffc0204a98 <commands+0x970>
ffffffffc0202d4a:	11000593          	li	a1,272
ffffffffc0202d4e:	00002517          	auipc	a0,0x2
ffffffffc0202d52:	4d250513          	addi	a0,a0,1234 # ffffffffc0205220 <commands+0x10f8>
ffffffffc0202d56:	c88fd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc0202d5a:	00002697          	auipc	a3,0x2
ffffffffc0202d5e:	75e68693          	addi	a3,a3,1886 # ffffffffc02054b8 <commands+0x1390>
ffffffffc0202d62:	00002617          	auipc	a2,0x2
ffffffffc0202d66:	d3660613          	addi	a2,a2,-714 # ffffffffc0204a98 <commands+0x970>
ffffffffc0202d6a:	10e00593          	li	a1,270
ffffffffc0202d6e:	00002517          	auipc	a0,0x2
ffffffffc0202d72:	4b250513          	addi	a0,a0,1202 # ffffffffc0205220 <commands+0x10f8>
ffffffffc0202d76:	c68fd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0202d7a:	00002697          	auipc	a3,0x2
ffffffffc0202d7e:	71668693          	addi	a3,a3,1814 # ffffffffc0205490 <commands+0x1368>
ffffffffc0202d82:	00002617          	auipc	a2,0x2
ffffffffc0202d86:	d1660613          	addi	a2,a2,-746 # ffffffffc0204a98 <commands+0x970>
ffffffffc0202d8a:	10d00593          	li	a1,269
ffffffffc0202d8e:	00002517          	auipc	a0,0x2
ffffffffc0202d92:	49250513          	addi	a0,a0,1170 # ffffffffc0205220 <commands+0x10f8>
ffffffffc0202d96:	c48fd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(p0 + 2 == p1);
ffffffffc0202d9a:	00002697          	auipc	a3,0x2
ffffffffc0202d9e:	6e668693          	addi	a3,a3,1766 # ffffffffc0205480 <commands+0x1358>
ffffffffc0202da2:	00002617          	auipc	a2,0x2
ffffffffc0202da6:	cf660613          	addi	a2,a2,-778 # ffffffffc0204a98 <commands+0x970>
ffffffffc0202daa:	10800593          	li	a1,264
ffffffffc0202dae:	00002517          	auipc	a0,0x2
ffffffffc0202db2:	47250513          	addi	a0,a0,1138 # ffffffffc0205220 <commands+0x10f8>
ffffffffc0202db6:	c28fd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(alloc_page() == NULL);
ffffffffc0202dba:	00002697          	auipc	a3,0x2
ffffffffc0202dbe:	5c668693          	addi	a3,a3,1478 # ffffffffc0205380 <commands+0x1258>
ffffffffc0202dc2:	00002617          	auipc	a2,0x2
ffffffffc0202dc6:	cd660613          	addi	a2,a2,-810 # ffffffffc0204a98 <commands+0x970>
ffffffffc0202dca:	10700593          	li	a1,263
ffffffffc0202dce:	00002517          	auipc	a0,0x2
ffffffffc0202dd2:	45250513          	addi	a0,a0,1106 # ffffffffc0205220 <commands+0x10f8>
ffffffffc0202dd6:	c08fd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0202dda:	00002697          	auipc	a3,0x2
ffffffffc0202dde:	68668693          	addi	a3,a3,1670 # ffffffffc0205460 <commands+0x1338>
ffffffffc0202de2:	00002617          	auipc	a2,0x2
ffffffffc0202de6:	cb660613          	addi	a2,a2,-842 # ffffffffc0204a98 <commands+0x970>
ffffffffc0202dea:	10600593          	li	a1,262
ffffffffc0202dee:	00002517          	auipc	a0,0x2
ffffffffc0202df2:	43250513          	addi	a0,a0,1074 # ffffffffc0205220 <commands+0x10f8>
ffffffffc0202df6:	be8fd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0202dfa:	00002697          	auipc	a3,0x2
ffffffffc0202dfe:	63668693          	addi	a3,a3,1590 # ffffffffc0205430 <commands+0x1308>
ffffffffc0202e02:	00002617          	auipc	a2,0x2
ffffffffc0202e06:	c9660613          	addi	a2,a2,-874 # ffffffffc0204a98 <commands+0x970>
ffffffffc0202e0a:	10500593          	li	a1,261
ffffffffc0202e0e:	00002517          	auipc	a0,0x2
ffffffffc0202e12:	41250513          	addi	a0,a0,1042 # ffffffffc0205220 <commands+0x10f8>
ffffffffc0202e16:	bc8fd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc0202e1a:	00002697          	auipc	a3,0x2
ffffffffc0202e1e:	5fe68693          	addi	a3,a3,1534 # ffffffffc0205418 <commands+0x12f0>
ffffffffc0202e22:	00002617          	auipc	a2,0x2
ffffffffc0202e26:	c7660613          	addi	a2,a2,-906 # ffffffffc0204a98 <commands+0x970>
ffffffffc0202e2a:	10400593          	li	a1,260
ffffffffc0202e2e:	00002517          	auipc	a0,0x2
ffffffffc0202e32:	3f250513          	addi	a0,a0,1010 # ffffffffc0205220 <commands+0x10f8>
ffffffffc0202e36:	ba8fd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(alloc_page() == NULL);
ffffffffc0202e3a:	00002697          	auipc	a3,0x2
ffffffffc0202e3e:	54668693          	addi	a3,a3,1350 # ffffffffc0205380 <commands+0x1258>
ffffffffc0202e42:	00002617          	auipc	a2,0x2
ffffffffc0202e46:	c5660613          	addi	a2,a2,-938 # ffffffffc0204a98 <commands+0x970>
ffffffffc0202e4a:	0fe00593          	li	a1,254
ffffffffc0202e4e:	00002517          	auipc	a0,0x2
ffffffffc0202e52:	3d250513          	addi	a0,a0,978 # ffffffffc0205220 <commands+0x10f8>
ffffffffc0202e56:	b88fd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(!PageProperty(p0));
ffffffffc0202e5a:	00002697          	auipc	a3,0x2
ffffffffc0202e5e:	5a668693          	addi	a3,a3,1446 # ffffffffc0205400 <commands+0x12d8>
ffffffffc0202e62:	00002617          	auipc	a2,0x2
ffffffffc0202e66:	c3660613          	addi	a2,a2,-970 # ffffffffc0204a98 <commands+0x970>
ffffffffc0202e6a:	0f900593          	li	a1,249
ffffffffc0202e6e:	00002517          	auipc	a0,0x2
ffffffffc0202e72:	3b250513          	addi	a0,a0,946 # ffffffffc0205220 <commands+0x10f8>
ffffffffc0202e76:	b68fd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc0202e7a:	00002697          	auipc	a3,0x2
ffffffffc0202e7e:	6a668693          	addi	a3,a3,1702 # ffffffffc0205520 <commands+0x13f8>
ffffffffc0202e82:	00002617          	auipc	a2,0x2
ffffffffc0202e86:	c1660613          	addi	a2,a2,-1002 # ffffffffc0204a98 <commands+0x970>
ffffffffc0202e8a:	11700593          	li	a1,279
ffffffffc0202e8e:	00002517          	auipc	a0,0x2
ffffffffc0202e92:	39250513          	addi	a0,a0,914 # ffffffffc0205220 <commands+0x10f8>
ffffffffc0202e96:	b48fd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(total == 0);
ffffffffc0202e9a:	00002697          	auipc	a3,0x2
ffffffffc0202e9e:	6b668693          	addi	a3,a3,1718 # ffffffffc0205550 <commands+0x1428>
ffffffffc0202ea2:	00002617          	auipc	a2,0x2
ffffffffc0202ea6:	bf660613          	addi	a2,a2,-1034 # ffffffffc0204a98 <commands+0x970>
ffffffffc0202eaa:	12600593          	li	a1,294
ffffffffc0202eae:	00002517          	auipc	a0,0x2
ffffffffc0202eb2:	37250513          	addi	a0,a0,882 # ffffffffc0205220 <commands+0x10f8>
ffffffffc0202eb6:	b28fd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(total == nr_free_pages());
ffffffffc0202eba:	00002697          	auipc	a3,0x2
ffffffffc0202ebe:	37e68693          	addi	a3,a3,894 # ffffffffc0205238 <commands+0x1110>
ffffffffc0202ec2:	00002617          	auipc	a2,0x2
ffffffffc0202ec6:	bd660613          	addi	a2,a2,-1066 # ffffffffc0204a98 <commands+0x970>
ffffffffc0202eca:	0f300593          	li	a1,243
ffffffffc0202ece:	00002517          	auipc	a0,0x2
ffffffffc0202ed2:	35250513          	addi	a0,a0,850 # ffffffffc0205220 <commands+0x10f8>
ffffffffc0202ed6:	b08fd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0202eda:	00002697          	auipc	a3,0x2
ffffffffc0202ede:	39e68693          	addi	a3,a3,926 # ffffffffc0205278 <commands+0x1150>
ffffffffc0202ee2:	00002617          	auipc	a2,0x2
ffffffffc0202ee6:	bb660613          	addi	a2,a2,-1098 # ffffffffc0204a98 <commands+0x970>
ffffffffc0202eea:	0ba00593          	li	a1,186
ffffffffc0202eee:	00002517          	auipc	a0,0x2
ffffffffc0202ef2:	33250513          	addi	a0,a0,818 # ffffffffc0205220 <commands+0x10f8>
ffffffffc0202ef6:	ae8fd0ef          	jal	ra,ffffffffc02001de <__panic>

ffffffffc0202efa <default_free_pages>:
default_free_pages(struct Page *base, size_t n) {
ffffffffc0202efa:	1141                	addi	sp,sp,-16
ffffffffc0202efc:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0202efe:	14058463          	beqz	a1,ffffffffc0203046 <default_free_pages+0x14c>
    for (; p != base + n; p ++) {
ffffffffc0202f02:	00659693          	slli	a3,a1,0x6
ffffffffc0202f06:	96aa                	add	a3,a3,a0
ffffffffc0202f08:	87aa                	mv	a5,a0
ffffffffc0202f0a:	02d50263          	beq	a0,a3,ffffffffc0202f2e <default_free_pages+0x34>
ffffffffc0202f0e:	6798                	ld	a4,8(a5)
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0202f10:	8b05                	andi	a4,a4,1
ffffffffc0202f12:	10071a63          	bnez	a4,ffffffffc0203026 <default_free_pages+0x12c>
ffffffffc0202f16:	6798                	ld	a4,8(a5)
ffffffffc0202f18:	8b09                	andi	a4,a4,2
ffffffffc0202f1a:	10071663          	bnez	a4,ffffffffc0203026 <default_free_pages+0x12c>
        p->flags = 0;
ffffffffc0202f1e:	0007b423          	sd	zero,8(a5)
    page->ref = val;
ffffffffc0202f22:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc0202f26:	04078793          	addi	a5,a5,64
ffffffffc0202f2a:	fed792e3          	bne	a5,a3,ffffffffc0202f0e <default_free_pages+0x14>
    base->property = n;
ffffffffc0202f2e:	2581                	sext.w	a1,a1
ffffffffc0202f30:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc0202f32:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0202f36:	4789                	li	a5,2
ffffffffc0202f38:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc0202f3c:	00006697          	auipc	a3,0x6
ffffffffc0202f40:	4f468693          	addi	a3,a3,1268 # ffffffffc0209430 <free_area>
ffffffffc0202f44:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc0202f46:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc0202f48:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc0202f4c:	9db9                	addw	a1,a1,a4
ffffffffc0202f4e:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list)) {
ffffffffc0202f50:	0ad78463          	beq	a5,a3,ffffffffc0202ff8 <default_free_pages+0xfe>
            struct Page* page = le2page(le, page_link);
ffffffffc0202f54:	fe878713          	addi	a4,a5,-24
ffffffffc0202f58:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list)) {
ffffffffc0202f5c:	4581                	li	a1,0
            if (base < page) {
ffffffffc0202f5e:	00e56a63          	bltu	a0,a4,ffffffffc0202f72 <default_free_pages+0x78>
    return listelm->next;
ffffffffc0202f62:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc0202f64:	04d70c63          	beq	a4,a3,ffffffffc0202fbc <default_free_pages+0xc2>
    for (; p != base + n; p ++) {
ffffffffc0202f68:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc0202f6a:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc0202f6e:	fee57ae3          	bgeu	a0,a4,ffffffffc0202f62 <default_free_pages+0x68>
ffffffffc0202f72:	c199                	beqz	a1,ffffffffc0202f78 <default_free_pages+0x7e>
ffffffffc0202f74:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0202f78:	6398                	ld	a4,0(a5)
    prev->next = next->prev = elm;
ffffffffc0202f7a:	e390                	sd	a2,0(a5)
ffffffffc0202f7c:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0202f7e:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0202f80:	ed18                	sd	a4,24(a0)
    if (le != &free_list) {
ffffffffc0202f82:	00d70d63          	beq	a4,a3,ffffffffc0202f9c <default_free_pages+0xa2>
        if (p + p->property == base) {
ffffffffc0202f86:	ff872583          	lw	a1,-8(a4) # ff8 <kern_entry-0xffffffffc01ff008>
        p = le2page(le, page_link);
ffffffffc0202f8a:	fe870613          	addi	a2,a4,-24
        if (p + p->property == base) {
ffffffffc0202f8e:	02059813          	slli	a6,a1,0x20
ffffffffc0202f92:	01a85793          	srli	a5,a6,0x1a
ffffffffc0202f96:	97b2                	add	a5,a5,a2
ffffffffc0202f98:	02f50c63          	beq	a0,a5,ffffffffc0202fd0 <default_free_pages+0xd6>
    return listelm->next;
ffffffffc0202f9c:	711c                	ld	a5,32(a0)
    if (le != &free_list) {
ffffffffc0202f9e:	00d78c63          	beq	a5,a3,ffffffffc0202fb6 <default_free_pages+0xbc>
        if (base + base->property == p) {
ffffffffc0202fa2:	4910                	lw	a2,16(a0)
        p = le2page(le, page_link);
ffffffffc0202fa4:	fe878693          	addi	a3,a5,-24
        if (base + base->property == p) {
ffffffffc0202fa8:	02061593          	slli	a1,a2,0x20
ffffffffc0202fac:	01a5d713          	srli	a4,a1,0x1a
ffffffffc0202fb0:	972a                	add	a4,a4,a0
ffffffffc0202fb2:	04e68a63          	beq	a3,a4,ffffffffc0203006 <default_free_pages+0x10c>
}
ffffffffc0202fb6:	60a2                	ld	ra,8(sp)
ffffffffc0202fb8:	0141                	addi	sp,sp,16
ffffffffc0202fba:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc0202fbc:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0202fbe:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc0202fc0:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc0202fc2:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list) {
ffffffffc0202fc4:	02d70763          	beq	a4,a3,ffffffffc0202ff2 <default_free_pages+0xf8>
    prev->next = next->prev = elm;
ffffffffc0202fc8:	8832                	mv	a6,a2
ffffffffc0202fca:	4585                	li	a1,1
    for (; p != base + n; p ++) {
ffffffffc0202fcc:	87ba                	mv	a5,a4
ffffffffc0202fce:	bf71                	j	ffffffffc0202f6a <default_free_pages+0x70>
            p->property += base->property;
ffffffffc0202fd0:	491c                	lw	a5,16(a0)
ffffffffc0202fd2:	9dbd                	addw	a1,a1,a5
ffffffffc0202fd4:	feb72c23          	sw	a1,-8(a4)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc0202fd8:	57f5                	li	a5,-3
ffffffffc0202fda:	60f8b02f          	amoand.d	zero,a5,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc0202fde:	01853803          	ld	a6,24(a0)
ffffffffc0202fe2:	710c                	ld	a1,32(a0)
            base = p;
ffffffffc0202fe4:	8532                	mv	a0,a2
    prev->next = next;
ffffffffc0202fe6:	00b83423          	sd	a1,8(a6)
    return listelm->next;
ffffffffc0202fea:	671c                	ld	a5,8(a4)
    next->prev = prev;
ffffffffc0202fec:	0105b023          	sd	a6,0(a1) # 1000 <kern_entry-0xffffffffc01ff000>
ffffffffc0202ff0:	b77d                	j	ffffffffc0202f9e <default_free_pages+0xa4>
ffffffffc0202ff2:	e290                	sd	a2,0(a3)
        while ((le = list_next(le)) != &free_list) {
ffffffffc0202ff4:	873e                	mv	a4,a5
ffffffffc0202ff6:	bf41                	j	ffffffffc0202f86 <default_free_pages+0x8c>
}
ffffffffc0202ff8:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0202ffa:	e390                	sd	a2,0(a5)
ffffffffc0202ffc:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc0202ffe:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0203000:	ed1c                	sd	a5,24(a0)
ffffffffc0203002:	0141                	addi	sp,sp,16
ffffffffc0203004:	8082                	ret
            base->property += p->property;
ffffffffc0203006:	ff87a703          	lw	a4,-8(a5)
ffffffffc020300a:	ff078693          	addi	a3,a5,-16
ffffffffc020300e:	9e39                	addw	a2,a2,a4
ffffffffc0203010:	c910                	sw	a2,16(a0)
ffffffffc0203012:	5775                	li	a4,-3
ffffffffc0203014:	60e6b02f          	amoand.d	zero,a4,(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc0203018:	6398                	ld	a4,0(a5)
ffffffffc020301a:	679c                	ld	a5,8(a5)
}
ffffffffc020301c:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc020301e:	e71c                	sd	a5,8(a4)
    next->prev = prev;
ffffffffc0203020:	e398                	sd	a4,0(a5)
ffffffffc0203022:	0141                	addi	sp,sp,16
ffffffffc0203024:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0203026:	00002697          	auipc	a3,0x2
ffffffffc020302a:	54268693          	addi	a3,a3,1346 # ffffffffc0205568 <commands+0x1440>
ffffffffc020302e:	00002617          	auipc	a2,0x2
ffffffffc0203032:	a6a60613          	addi	a2,a2,-1430 # ffffffffc0204a98 <commands+0x970>
ffffffffc0203036:	08300593          	li	a1,131
ffffffffc020303a:	00002517          	auipc	a0,0x2
ffffffffc020303e:	1e650513          	addi	a0,a0,486 # ffffffffc0205220 <commands+0x10f8>
ffffffffc0203042:	99cfd0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(n > 0);
ffffffffc0203046:	00002697          	auipc	a3,0x2
ffffffffc020304a:	51a68693          	addi	a3,a3,1306 # ffffffffc0205560 <commands+0x1438>
ffffffffc020304e:	00002617          	auipc	a2,0x2
ffffffffc0203052:	a4a60613          	addi	a2,a2,-1462 # ffffffffc0204a98 <commands+0x970>
ffffffffc0203056:	08000593          	li	a1,128
ffffffffc020305a:	00002517          	auipc	a0,0x2
ffffffffc020305e:	1c650513          	addi	a0,a0,454 # ffffffffc0205220 <commands+0x10f8>
ffffffffc0203062:	97cfd0ef          	jal	ra,ffffffffc02001de <__panic>

ffffffffc0203066 <default_alloc_pages>:
    assert(n > 0);
ffffffffc0203066:	c941                	beqz	a0,ffffffffc02030f6 <default_alloc_pages+0x90>
    if (n > nr_free) {
ffffffffc0203068:	00006597          	auipc	a1,0x6
ffffffffc020306c:	3c858593          	addi	a1,a1,968 # ffffffffc0209430 <free_area>
ffffffffc0203070:	0105a803          	lw	a6,16(a1)
ffffffffc0203074:	872a                	mv	a4,a0
ffffffffc0203076:	02081793          	slli	a5,a6,0x20
ffffffffc020307a:	9381                	srli	a5,a5,0x20
ffffffffc020307c:	00a7ee63          	bltu	a5,a0,ffffffffc0203098 <default_alloc_pages+0x32>
    list_entry_t *le = &free_list;
ffffffffc0203080:	87ae                	mv	a5,a1
ffffffffc0203082:	a801                	j	ffffffffc0203092 <default_alloc_pages+0x2c>
        if (p->property >= n) {
ffffffffc0203084:	ff87a683          	lw	a3,-8(a5)
ffffffffc0203088:	02069613          	slli	a2,a3,0x20
ffffffffc020308c:	9201                	srli	a2,a2,0x20
ffffffffc020308e:	00e67763          	bgeu	a2,a4,ffffffffc020309c <default_alloc_pages+0x36>
    return listelm->next;
ffffffffc0203092:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list) {
ffffffffc0203094:	feb798e3          	bne	a5,a1,ffffffffc0203084 <default_alloc_pages+0x1e>
        return NULL;
ffffffffc0203098:	4501                	li	a0,0
}
ffffffffc020309a:	8082                	ret
    return listelm->prev;
ffffffffc020309c:	0007b883          	ld	a7,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc02030a0:	0087b303          	ld	t1,8(a5)
        struct Page *p = le2page(le, page_link);
ffffffffc02030a4:	fe878513          	addi	a0,a5,-24
            p->property = page->property - n;
ffffffffc02030a8:	00070e1b          	sext.w	t3,a4
    prev->next = next;
ffffffffc02030ac:	0068b423          	sd	t1,8(a7)
    next->prev = prev;
ffffffffc02030b0:	01133023          	sd	a7,0(t1)
        if (page->property > n) {
ffffffffc02030b4:	02c77863          	bgeu	a4,a2,ffffffffc02030e4 <default_alloc_pages+0x7e>
            struct Page *p = page + n;
ffffffffc02030b8:	071a                	slli	a4,a4,0x6
ffffffffc02030ba:	972a                	add	a4,a4,a0
            p->property = page->property - n;
ffffffffc02030bc:	41c686bb          	subw	a3,a3,t3
ffffffffc02030c0:	cb14                	sw	a3,16(a4)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02030c2:	00870613          	addi	a2,a4,8
ffffffffc02030c6:	4689                	li	a3,2
ffffffffc02030c8:	40d6302f          	amoor.d	zero,a3,(a2)
    __list_add(elm, listelm, listelm->next);
ffffffffc02030cc:	0088b683          	ld	a3,8(a7)
            list_add(prev, &(p->page_link));
ffffffffc02030d0:	01870613          	addi	a2,a4,24
        nr_free -= n;
ffffffffc02030d4:	0105a803          	lw	a6,16(a1)
    prev->next = next->prev = elm;
ffffffffc02030d8:	e290                	sd	a2,0(a3)
ffffffffc02030da:	00c8b423          	sd	a2,8(a7)
    elm->next = next;
ffffffffc02030de:	f314                	sd	a3,32(a4)
    elm->prev = prev;
ffffffffc02030e0:	01173c23          	sd	a7,24(a4)
ffffffffc02030e4:	41c8083b          	subw	a6,a6,t3
ffffffffc02030e8:	0105a823          	sw	a6,16(a1)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc02030ec:	5775                	li	a4,-3
ffffffffc02030ee:	17c1                	addi	a5,a5,-16
ffffffffc02030f0:	60e7b02f          	amoand.d	zero,a4,(a5)
}
ffffffffc02030f4:	8082                	ret
default_alloc_pages(size_t n) {
ffffffffc02030f6:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc02030f8:	00002697          	auipc	a3,0x2
ffffffffc02030fc:	46868693          	addi	a3,a3,1128 # ffffffffc0205560 <commands+0x1438>
ffffffffc0203100:	00002617          	auipc	a2,0x2
ffffffffc0203104:	99860613          	addi	a2,a2,-1640 # ffffffffc0204a98 <commands+0x970>
ffffffffc0203108:	06200593          	li	a1,98
ffffffffc020310c:	00002517          	auipc	a0,0x2
ffffffffc0203110:	11450513          	addi	a0,a0,276 # ffffffffc0205220 <commands+0x10f8>
default_alloc_pages(size_t n) {
ffffffffc0203114:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0203116:	8c8fd0ef          	jal	ra,ffffffffc02001de <__panic>

ffffffffc020311a <default_init_memmap>:
default_init_memmap(struct Page *base, size_t n) {
ffffffffc020311a:	1141                	addi	sp,sp,-16
ffffffffc020311c:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc020311e:	c5f1                	beqz	a1,ffffffffc02031ea <default_init_memmap+0xd0>
    for (; p != base + n; p ++) {
ffffffffc0203120:	00659693          	slli	a3,a1,0x6
ffffffffc0203124:	96aa                	add	a3,a3,a0
ffffffffc0203126:	87aa                	mv	a5,a0
ffffffffc0203128:	00d50f63          	beq	a0,a3,ffffffffc0203146 <default_init_memmap+0x2c>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc020312c:	6798                	ld	a4,8(a5)
        assert(PageReserved(p));
ffffffffc020312e:	8b05                	andi	a4,a4,1
ffffffffc0203130:	cf49                	beqz	a4,ffffffffc02031ca <default_init_memmap+0xb0>
        p->flags = p->property = 0;
ffffffffc0203132:	0007a823          	sw	zero,16(a5)
ffffffffc0203136:	0007b423          	sd	zero,8(a5)
ffffffffc020313a:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc020313e:	04078793          	addi	a5,a5,64
ffffffffc0203142:	fed795e3          	bne	a5,a3,ffffffffc020312c <default_init_memmap+0x12>
    base->property = n;
ffffffffc0203146:	2581                	sext.w	a1,a1
ffffffffc0203148:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc020314a:	4789                	li	a5,2
ffffffffc020314c:	00850713          	addi	a4,a0,8
ffffffffc0203150:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc0203154:	00006697          	auipc	a3,0x6
ffffffffc0203158:	2dc68693          	addi	a3,a3,732 # ffffffffc0209430 <free_area>
ffffffffc020315c:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc020315e:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc0203160:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc0203164:	9db9                	addw	a1,a1,a4
ffffffffc0203166:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list)) {
ffffffffc0203168:	04d78a63          	beq	a5,a3,ffffffffc02031bc <default_init_memmap+0xa2>
            struct Page* page = le2page(le, page_link);
ffffffffc020316c:	fe878713          	addi	a4,a5,-24
ffffffffc0203170:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list)) {
ffffffffc0203174:	4581                	li	a1,0
            if (base < page) {
ffffffffc0203176:	00e56a63          	bltu	a0,a4,ffffffffc020318a <default_init_memmap+0x70>
    return listelm->next;
ffffffffc020317a:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc020317c:	02d70263          	beq	a4,a3,ffffffffc02031a0 <default_init_memmap+0x86>
    for (; p != base + n; p ++) {
ffffffffc0203180:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc0203182:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc0203186:	fee57ae3          	bgeu	a0,a4,ffffffffc020317a <default_init_memmap+0x60>
ffffffffc020318a:	c199                	beqz	a1,ffffffffc0203190 <default_init_memmap+0x76>
ffffffffc020318c:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0203190:	6398                	ld	a4,0(a5)
}
ffffffffc0203192:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc0203194:	e390                	sd	a2,0(a5)
ffffffffc0203196:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0203198:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc020319a:	ed18                	sd	a4,24(a0)
ffffffffc020319c:	0141                	addi	sp,sp,16
ffffffffc020319e:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc02031a0:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc02031a2:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc02031a4:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc02031a6:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list) {
ffffffffc02031a8:	00d70663          	beq	a4,a3,ffffffffc02031b4 <default_init_memmap+0x9a>
    prev->next = next->prev = elm;
ffffffffc02031ac:	8832                	mv	a6,a2
ffffffffc02031ae:	4585                	li	a1,1
    for (; p != base + n; p ++) {
ffffffffc02031b0:	87ba                	mv	a5,a4
ffffffffc02031b2:	bfc1                	j	ffffffffc0203182 <default_init_memmap+0x68>
}
ffffffffc02031b4:	60a2                	ld	ra,8(sp)
ffffffffc02031b6:	e290                	sd	a2,0(a3)
ffffffffc02031b8:	0141                	addi	sp,sp,16
ffffffffc02031ba:	8082                	ret
ffffffffc02031bc:	60a2                	ld	ra,8(sp)
ffffffffc02031be:	e390                	sd	a2,0(a5)
ffffffffc02031c0:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc02031c2:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc02031c4:	ed1c                	sd	a5,24(a0)
ffffffffc02031c6:	0141                	addi	sp,sp,16
ffffffffc02031c8:	8082                	ret
        assert(PageReserved(p));
ffffffffc02031ca:	00002697          	auipc	a3,0x2
ffffffffc02031ce:	3c668693          	addi	a3,a3,966 # ffffffffc0205590 <commands+0x1468>
ffffffffc02031d2:	00002617          	auipc	a2,0x2
ffffffffc02031d6:	8c660613          	addi	a2,a2,-1850 # ffffffffc0204a98 <commands+0x970>
ffffffffc02031da:	04900593          	li	a1,73
ffffffffc02031de:	00002517          	auipc	a0,0x2
ffffffffc02031e2:	04250513          	addi	a0,a0,66 # ffffffffc0205220 <commands+0x10f8>
ffffffffc02031e6:	ff9fc0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(n > 0);
ffffffffc02031ea:	00002697          	auipc	a3,0x2
ffffffffc02031ee:	37668693          	addi	a3,a3,886 # ffffffffc0205560 <commands+0x1438>
ffffffffc02031f2:	00002617          	auipc	a2,0x2
ffffffffc02031f6:	8a660613          	addi	a2,a2,-1882 # ffffffffc0204a98 <commands+0x970>
ffffffffc02031fa:	04600593          	li	a1,70
ffffffffc02031fe:	00002517          	auipc	a0,0x2
ffffffffc0203202:	02250513          	addi	a0,a0,34 # ffffffffc0205220 <commands+0x10f8>
ffffffffc0203206:	fd9fc0ef          	jal	ra,ffffffffc02001de <__panic>

ffffffffc020320a <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)
	move a0, s1
ffffffffc020320a:	8526                	mv	a0,s1
	jalr s0
ffffffffc020320c:	9402                	jalr	s0

	jal do_exit
ffffffffc020320e:	452000ef          	jal	ra,ffffffffc0203660 <do_exit>

ffffffffc0203212 <switch_to>:
.text
# void switch_to(struct proc_struct* from, struct proc_struct* to)
.globl switch_to
switch_to:
    # save from's registers
    STORE ra, 0*REGBYTES(a0)
ffffffffc0203212:	00153023          	sd	ra,0(a0)
    STORE sp, 1*REGBYTES(a0)
ffffffffc0203216:	00253423          	sd	sp,8(a0)
    STORE s0, 2*REGBYTES(a0)
ffffffffc020321a:	e900                	sd	s0,16(a0)
    STORE s1, 3*REGBYTES(a0)
ffffffffc020321c:	ed04                	sd	s1,24(a0)
    STORE s2, 4*REGBYTES(a0)
ffffffffc020321e:	03253023          	sd	s2,32(a0)
    STORE s3, 5*REGBYTES(a0)
ffffffffc0203222:	03353423          	sd	s3,40(a0)
    STORE s4, 6*REGBYTES(a0)
ffffffffc0203226:	03453823          	sd	s4,48(a0)
    STORE s5, 7*REGBYTES(a0)
ffffffffc020322a:	03553c23          	sd	s5,56(a0)
    STORE s6, 8*REGBYTES(a0)
ffffffffc020322e:	05653023          	sd	s6,64(a0)
    STORE s7, 9*REGBYTES(a0)
ffffffffc0203232:	05753423          	sd	s7,72(a0)
    STORE s8, 10*REGBYTES(a0)
ffffffffc0203236:	05853823          	sd	s8,80(a0)
    STORE s9, 11*REGBYTES(a0)
ffffffffc020323a:	05953c23          	sd	s9,88(a0)
    STORE s10, 12*REGBYTES(a0)
ffffffffc020323e:	07a53023          	sd	s10,96(a0)
    STORE s11, 13*REGBYTES(a0)
ffffffffc0203242:	07b53423          	sd	s11,104(a0)

    # restore to's registers
    LOAD ra, 0*REGBYTES(a1)
ffffffffc0203246:	0005b083          	ld	ra,0(a1)
    LOAD sp, 1*REGBYTES(a1)
ffffffffc020324a:	0085b103          	ld	sp,8(a1)
    LOAD s0, 2*REGBYTES(a1)
ffffffffc020324e:	6980                	ld	s0,16(a1)
    LOAD s1, 3*REGBYTES(a1)
ffffffffc0203250:	6d84                	ld	s1,24(a1)
    LOAD s2, 4*REGBYTES(a1)
ffffffffc0203252:	0205b903          	ld	s2,32(a1)
    LOAD s3, 5*REGBYTES(a1)
ffffffffc0203256:	0285b983          	ld	s3,40(a1)
    LOAD s4, 6*REGBYTES(a1)
ffffffffc020325a:	0305ba03          	ld	s4,48(a1)
    LOAD s5, 7*REGBYTES(a1)
ffffffffc020325e:	0385ba83          	ld	s5,56(a1)
    LOAD s6, 8*REGBYTES(a1)
ffffffffc0203262:	0405bb03          	ld	s6,64(a1)
    LOAD s7, 9*REGBYTES(a1)
ffffffffc0203266:	0485bb83          	ld	s7,72(a1)
    LOAD s8, 10*REGBYTES(a1)
ffffffffc020326a:	0505bc03          	ld	s8,80(a1)
    LOAD s9, 11*REGBYTES(a1)
ffffffffc020326e:	0585bc83          	ld	s9,88(a1)
    LOAD s10, 12*REGBYTES(a1)
ffffffffc0203272:	0605bd03          	ld	s10,96(a1)
    LOAD s11, 13*REGBYTES(a1)
ffffffffc0203276:	0685bd83          	ld	s11,104(a1)

    ret
ffffffffc020327a:	8082                	ret

ffffffffc020327c <alloc_proc>:
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void)
{
ffffffffc020327c:	1141                	addi	sp,sp,-16
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc020327e:	0e800513          	li	a0,232
{
ffffffffc0203282:	e022                	sd	s0,0(sp)
ffffffffc0203284:	e406                	sd	ra,8(sp)
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
ffffffffc0203286:	b2cff0ef          	jal	ra,ffffffffc02025b2 <kmalloc>
ffffffffc020328a:	842a                	mv	s0,a0
    if (proc != NULL)
ffffffffc020328c:	c929                	beqz	a0,ffffffffc02032de <alloc_proc+0x62>
         *       struct trapframe *tf;                       // Trap frame for current interrupt
         *       uintptr_t pgdir;                            // the base addr of Page Directroy Table(PDT)
         *       uint32_t flags;                             // Process flag
         *       char name[PROC_NAME_LEN + 1];               // Process name
         */
 	proc->state = PROC_UNINIT;
ffffffffc020328e:	57fd                	li	a5,-1
ffffffffc0203290:	1782                	slli	a5,a5,0x20
ffffffffc0203292:	e11c                	sd	a5,0(a0)
        proc->kstack = 0;
        proc->need_resched = 0;
        proc->parent = NULL;
        proc->mm = NULL;

        memset(&(proc->context), 0, sizeof(struct context));
ffffffffc0203294:	07000613          	li	a2,112
ffffffffc0203298:	4581                	li	a1,0
        proc->runs = 0;
ffffffffc020329a:	00052423          	sw	zero,8(a0)
        proc->kstack = 0;
ffffffffc020329e:	00053823          	sd	zero,16(a0)
        proc->need_resched = 0;
ffffffffc02032a2:	00052c23          	sw	zero,24(a0)
        proc->parent = NULL;
ffffffffc02032a6:	02053023          	sd	zero,32(a0)
        proc->mm = NULL;
ffffffffc02032aa:	02053423          	sd	zero,40(a0)
        memset(&(proc->context), 0, sizeof(struct context));
ffffffffc02032ae:	03050513          	addi	a0,a0,48
ffffffffc02032b2:	79c000ef          	jal	ra,ffffffffc0203a4e <memset>

        proc->tf = NULL;
        proc->pgdir = 0;

        proc->flags = 0;
        memset(proc->name, 0, sizeof(proc->name));
ffffffffc02032b6:	4641                	li	a2,16
        proc->tf = NULL;
ffffffffc02032b8:	0a043023          	sd	zero,160(s0)
        proc->pgdir = 0;
ffffffffc02032bc:	0a043423          	sd	zero,168(s0)
        proc->flags = 0;
ffffffffc02032c0:	0a042823          	sw	zero,176(s0)
        memset(proc->name, 0, sizeof(proc->name));
ffffffffc02032c4:	4581                	li	a1,0
ffffffffc02032c6:	0b440513          	addi	a0,s0,180
ffffffffc02032ca:	784000ef          	jal	ra,ffffffffc0203a4e <memset>

        // 链表初始化
        list_init(&(proc->list_link));
ffffffffc02032ce:	0c840713          	addi	a4,s0,200
        list_init(&(proc->hash_link));
ffffffffc02032d2:	0d840793          	addi	a5,s0,216
    elm->prev = elm->next = elm;
ffffffffc02032d6:	e878                	sd	a4,208(s0)
ffffffffc02032d8:	e478                	sd	a4,200(s0)
ffffffffc02032da:	f07c                	sd	a5,224(s0)
ffffffffc02032dc:	ec7c                	sd	a5,216(s0)
        
    }
    return proc;
}
ffffffffc02032de:	60a2                	ld	ra,8(sp)
ffffffffc02032e0:	8522                	mv	a0,s0
ffffffffc02032e2:	6402                	ld	s0,0(sp)
ffffffffc02032e4:	0141                	addi	sp,sp,16
ffffffffc02032e6:	8082                	ret

ffffffffc02032e8 <forkret>:
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void)
{
    forkrets(current->tf);
ffffffffc02032e8:	0000a797          	auipc	a5,0xa
ffffffffc02032ec:	1e87b783          	ld	a5,488(a5) # ffffffffc020d4d0 <current>
ffffffffc02032f0:	73c8                	ld	a0,160(a5)
ffffffffc02032f2:	ae7fd06f          	j	ffffffffc0200dd8 <forkrets>

ffffffffc02032f6 <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg)
{
ffffffffc02032f6:	7179                	addi	sp,sp,-48
ffffffffc02032f8:	ec26                	sd	s1,24(sp)
    memset(name, 0, sizeof(name));
ffffffffc02032fa:	0000a497          	auipc	s1,0xa
ffffffffc02032fe:	14e48493          	addi	s1,s1,334 # ffffffffc020d448 <name.2>
{
ffffffffc0203302:	f022                	sd	s0,32(sp)
ffffffffc0203304:	e84a                	sd	s2,16(sp)
ffffffffc0203306:	842a                	mv	s0,a0
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, get_proc_name(current));
ffffffffc0203308:	0000a917          	auipc	s2,0xa
ffffffffc020330c:	1c893903          	ld	s2,456(s2) # ffffffffc020d4d0 <current>
    memset(name, 0, sizeof(name));
ffffffffc0203310:	4641                	li	a2,16
ffffffffc0203312:	4581                	li	a1,0
ffffffffc0203314:	8526                	mv	a0,s1
{
ffffffffc0203316:	f406                	sd	ra,40(sp)
ffffffffc0203318:	e44e                	sd	s3,8(sp)
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, get_proc_name(current));
ffffffffc020331a:	00492983          	lw	s3,4(s2)
    memset(name, 0, sizeof(name));
ffffffffc020331e:	730000ef          	jal	ra,ffffffffc0203a4e <memset>
    return memcpy(name, proc->name, PROC_NAME_LEN);
ffffffffc0203322:	0b490593          	addi	a1,s2,180
ffffffffc0203326:	463d                	li	a2,15
ffffffffc0203328:	8526                	mv	a0,s1
ffffffffc020332a:	736000ef          	jal	ra,ffffffffc0203a60 <memcpy>
ffffffffc020332e:	862a                	mv	a2,a0
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, get_proc_name(current));
ffffffffc0203330:	85ce                	mv	a1,s3
ffffffffc0203332:	00002517          	auipc	a0,0x2
ffffffffc0203336:	2be50513          	addi	a0,a0,702 # ffffffffc02055f0 <default_pmm_manager+0x38>
ffffffffc020333a:	da7fc0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("To U: \"%s\".\n", (const char *)arg);
ffffffffc020333e:	85a2                	mv	a1,s0
ffffffffc0203340:	00002517          	auipc	a0,0x2
ffffffffc0203344:	2d850513          	addi	a0,a0,728 # ffffffffc0205618 <default_pmm_manager+0x60>
ffffffffc0203348:	d99fc0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    cprintf("To U: \"en.., Bye, Bye. :)\"\n");
ffffffffc020334c:	00002517          	auipc	a0,0x2
ffffffffc0203350:	2dc50513          	addi	a0,a0,732 # ffffffffc0205628 <default_pmm_manager+0x70>
ffffffffc0203354:	d8dfc0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    return 0;
}
ffffffffc0203358:	70a2                	ld	ra,40(sp)
ffffffffc020335a:	7402                	ld	s0,32(sp)
ffffffffc020335c:	64e2                	ld	s1,24(sp)
ffffffffc020335e:	6942                	ld	s2,16(sp)
ffffffffc0203360:	69a2                	ld	s3,8(sp)
ffffffffc0203362:	4501                	li	a0,0
ffffffffc0203364:	6145                	addi	sp,sp,48
ffffffffc0203366:	8082                	ret

ffffffffc0203368 <proc_run>:
{
ffffffffc0203368:	7179                	addi	sp,sp,-48
ffffffffc020336a:	ec4a                	sd	s2,24(sp)
    if (proc != current)
ffffffffc020336c:	0000a917          	auipc	s2,0xa
ffffffffc0203370:	16490913          	addi	s2,s2,356 # ffffffffc020d4d0 <current>
{
ffffffffc0203374:	f026                	sd	s1,32(sp)
    if (proc != current)
ffffffffc0203376:	00093483          	ld	s1,0(s2)
{
ffffffffc020337a:	f406                	sd	ra,40(sp)
ffffffffc020337c:	e84e                	sd	s3,16(sp)
    if (proc != current)
ffffffffc020337e:	02a48963          	beq	s1,a0,ffffffffc02033b0 <proc_run+0x48>
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0203382:	100027f3          	csrr	a5,sstatus
ffffffffc0203386:	8b89                	andi	a5,a5,2
    return 0;
ffffffffc0203388:	4981                	li	s3,0
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020338a:	e3a1                	bnez	a5,ffffffffc02033ca <proc_run+0x62>
            lsatp(proc->pgdir);
ffffffffc020338c:	755c                	ld	a5,168(a0)
#define barrier() __asm__ __volatile__("fence" ::: "memory")

static inline void
lsatp(unsigned int pgdir)
{
  write_csr(satp, SATP32_MODE | (pgdir >> RISCV_PGSHIFT));
ffffffffc020338e:	80000737          	lui	a4,0x80000
            current = proc;
ffffffffc0203392:	00a93023          	sd	a0,0(s2)
ffffffffc0203396:	00c7d79b          	srliw	a5,a5,0xc
ffffffffc020339a:	8fd9                	or	a5,a5,a4
ffffffffc020339c:	18079073          	csrw	satp,a5
            switch_to(&(prev->context), &(proc->context));
ffffffffc02033a0:	03050593          	addi	a1,a0,48
ffffffffc02033a4:	03048513          	addi	a0,s1,48
ffffffffc02033a8:	e6bff0ef          	jal	ra,ffffffffc0203212 <switch_to>
    if (flag) {
ffffffffc02033ac:	00099863          	bnez	s3,ffffffffc02033bc <proc_run+0x54>
}
ffffffffc02033b0:	70a2                	ld	ra,40(sp)
ffffffffc02033b2:	7482                	ld	s1,32(sp)
ffffffffc02033b4:	6962                	ld	s2,24(sp)
ffffffffc02033b6:	69c2                	ld	s3,16(sp)
ffffffffc02033b8:	6145                	addi	sp,sp,48
ffffffffc02033ba:	8082                	ret
ffffffffc02033bc:	70a2                	ld	ra,40(sp)
ffffffffc02033be:	7482                	ld	s1,32(sp)
ffffffffc02033c0:	6962                	ld	s2,24(sp)
ffffffffc02033c2:	69c2                	ld	s3,16(sp)
ffffffffc02033c4:	6145                	addi	sp,sp,48
        intr_enable();
ffffffffc02033c6:	d6afd06f          	j	ffffffffc0200930 <intr_enable>
ffffffffc02033ca:	e42a                	sd	a0,8(sp)
        intr_disable();
ffffffffc02033cc:	d6afd0ef          	jal	ra,ffffffffc0200936 <intr_disable>
        return 1;
ffffffffc02033d0:	6522                	ld	a0,8(sp)
ffffffffc02033d2:	4985                	li	s3,1
ffffffffc02033d4:	bf65                	j	ffffffffc020338c <proc_run+0x24>

ffffffffc02033d6 <do_fork>:
{
ffffffffc02033d6:	7179                	addi	sp,sp,-48
ffffffffc02033d8:	ec26                	sd	s1,24(sp)
    if (nr_process >= MAX_PROCESS)
ffffffffc02033da:	0000a497          	auipc	s1,0xa
ffffffffc02033de:	10e48493          	addi	s1,s1,270 # ffffffffc020d4e8 <nr_process>
ffffffffc02033e2:	4098                	lw	a4,0(s1)
{
ffffffffc02033e4:	f406                	sd	ra,40(sp)
ffffffffc02033e6:	f022                	sd	s0,32(sp)
ffffffffc02033e8:	e84a                	sd	s2,16(sp)
ffffffffc02033ea:	e44e                	sd	s3,8(sp)
    if (nr_process >= MAX_PROCESS)
ffffffffc02033ec:	6785                	lui	a5,0x1
ffffffffc02033ee:	1cf75e63          	bge	a4,a5,ffffffffc02035ca <do_fork+0x1f4>
ffffffffc02033f2:	892e                	mv	s2,a1
ffffffffc02033f4:	8432                	mv	s0,a2
    if ((proc = alloc_proc()) == NULL) {
ffffffffc02033f6:	e87ff0ef          	jal	ra,ffffffffc020327c <alloc_proc>
ffffffffc02033fa:	89aa                	mv	s3,a0
ffffffffc02033fc:	1c050c63          	beqz	a0,ffffffffc02035d4 <do_fork+0x1fe>
    struct Page *page = alloc_pages(KSTACKPAGE);
ffffffffc0203400:	4509                	li	a0,2
ffffffffc0203402:	a15fd0ef          	jal	ra,ffffffffc0200e16 <alloc_pages>
    if (page != NULL)
ffffffffc0203406:	1a050d63          	beqz	a0,ffffffffc02035c0 <do_fork+0x1ea>
    return page - pages + nbase;
ffffffffc020340a:	0000a697          	auipc	a3,0xa
ffffffffc020340e:	0a66b683          	ld	a3,166(a3) # ffffffffc020d4b0 <pages>
ffffffffc0203412:	40d506b3          	sub	a3,a0,a3
ffffffffc0203416:	8699                	srai	a3,a3,0x6
ffffffffc0203418:	00002517          	auipc	a0,0x2
ffffffffc020341c:	5d053503          	ld	a0,1488(a0) # ffffffffc02059e8 <nbase>
ffffffffc0203420:	96aa                	add	a3,a3,a0
    return KADDR(page2pa(page));
ffffffffc0203422:	00c69793          	slli	a5,a3,0xc
ffffffffc0203426:	83b1                	srli	a5,a5,0xc
ffffffffc0203428:	0000a717          	auipc	a4,0xa
ffffffffc020342c:	08073703          	ld	a4,128(a4) # ffffffffc020d4a8 <npage>
    return page2ppn(page) << PGSHIFT;
ffffffffc0203430:	06b2                	slli	a3,a3,0xc
    return KADDR(page2pa(page));
ffffffffc0203432:	1ce7f363          	bgeu	a5,a4,ffffffffc02035f8 <do_fork+0x222>
    assert(current->mm == NULL);
ffffffffc0203436:	0000a317          	auipc	t1,0xa
ffffffffc020343a:	09a33303          	ld	t1,154(t1) # ffffffffc020d4d0 <current>
ffffffffc020343e:	02833783          	ld	a5,40(t1)
ffffffffc0203442:	0000a717          	auipc	a4,0xa
ffffffffc0203446:	07e73703          	ld	a4,126(a4) # ffffffffc020d4c0 <va_pa_offset>
ffffffffc020344a:	96ba                	add	a3,a3,a4
        proc->kstack = (uintptr_t)page2kva(page);
ffffffffc020344c:	00d9b823          	sd	a3,16(s3)
    assert(current->mm == NULL);
ffffffffc0203450:	18079463          	bnez	a5,ffffffffc02035d8 <do_fork+0x202>
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE - sizeof(struct trapframe));
ffffffffc0203454:	6789                	lui	a5,0x2
ffffffffc0203456:	ee078793          	addi	a5,a5,-288 # 1ee0 <kern_entry-0xffffffffc01fe120>
ffffffffc020345a:	96be                	add	a3,a3,a5
    *(proc->tf) = *tf;
ffffffffc020345c:	8622                	mv	a2,s0
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE - sizeof(struct trapframe));
ffffffffc020345e:	0ad9b023          	sd	a3,160(s3)
    *(proc->tf) = *tf;
ffffffffc0203462:	87b6                	mv	a5,a3
ffffffffc0203464:	12040893          	addi	a7,s0,288
ffffffffc0203468:	00063803          	ld	a6,0(a2)
ffffffffc020346c:	6608                	ld	a0,8(a2)
ffffffffc020346e:	6a0c                	ld	a1,16(a2)
ffffffffc0203470:	6e18                	ld	a4,24(a2)
ffffffffc0203472:	0107b023          	sd	a6,0(a5)
ffffffffc0203476:	e788                	sd	a0,8(a5)
ffffffffc0203478:	eb8c                	sd	a1,16(a5)
ffffffffc020347a:	ef98                	sd	a4,24(a5)
ffffffffc020347c:	02060613          	addi	a2,a2,32
ffffffffc0203480:	02078793          	addi	a5,a5,32
ffffffffc0203484:	ff1612e3          	bne	a2,a7,ffffffffc0203468 <do_fork+0x92>
    proc->tf->gpr.a0 = 0;
ffffffffc0203488:	0406b823          	sd	zero,80(a3)
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc020348c:	10090e63          	beqz	s2,ffffffffc02035a8 <do_fork+0x1d2>
    if (++last_pid >= MAX_PID)
ffffffffc0203490:	00006817          	auipc	a6,0x6
ffffffffc0203494:	b9880813          	addi	a6,a6,-1128 # ffffffffc0209028 <last_pid.1>
ffffffffc0203498:	00082783          	lw	a5,0(a6)
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc020349c:	0126b823          	sd	s2,16(a3)
    proc->context.ra = (uintptr_t)forkret;
ffffffffc02034a0:	00000717          	auipc	a4,0x0
ffffffffc02034a4:	e4870713          	addi	a4,a4,-440 # ffffffffc02032e8 <forkret>
    if (++last_pid >= MAX_PID)
ffffffffc02034a8:	0017851b          	addiw	a0,a5,1
    proc->context.ra = (uintptr_t)forkret;
ffffffffc02034ac:	02e9b823          	sd	a4,48(s3)
    proc->context.sp = (uintptr_t)(proc->tf);
ffffffffc02034b0:	02d9bc23          	sd	a3,56(s3)
    if (++last_pid >= MAX_PID)
ffffffffc02034b4:	00a82023          	sw	a0,0(a6)
ffffffffc02034b8:	6789                	lui	a5,0x2
ffffffffc02034ba:	08f55063          	bge	a0,a5,ffffffffc020353a <do_fork+0x164>
    if (last_pid >= next_safe)
ffffffffc02034be:	00006e17          	auipc	t3,0x6
ffffffffc02034c2:	b6ee0e13          	addi	t3,t3,-1170 # ffffffffc020902c <next_safe.0>
ffffffffc02034c6:	000e2783          	lw	a5,0(t3)
ffffffffc02034ca:	0000a417          	auipc	s0,0xa
ffffffffc02034ce:	f8e40413          	addi	s0,s0,-114 # ffffffffc020d458 <proc_list>
ffffffffc02034d2:	06f55c63          	bge	a0,a5,ffffffffc020354a <do_fork+0x174>
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc02034d6:	45a9                	li	a1,10
    proc->pid = get_pid();
ffffffffc02034d8:	00a9a223          	sw	a0,4(s3)
    proc->parent = current;
ffffffffc02034dc:	0269b023          	sd	t1,32(s3)
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
ffffffffc02034e0:	2501                	sext.w	a0,a0
ffffffffc02034e2:	1a9000ef          	jal	ra,ffffffffc0203e8a <hash32>
ffffffffc02034e6:	02051793          	slli	a5,a0,0x20
ffffffffc02034ea:	01c7d513          	srli	a0,a5,0x1c
ffffffffc02034ee:	00006797          	auipc	a5,0x6
ffffffffc02034f2:	f5a78793          	addi	a5,a5,-166 # ffffffffc0209448 <hash_list>
ffffffffc02034f6:	953e                	add	a0,a0,a5
    __list_add(elm, listelm, listelm->next);
ffffffffc02034f8:	6518                	ld	a4,8(a0)
ffffffffc02034fa:	0d898793          	addi	a5,s3,216
ffffffffc02034fe:	6414                	ld	a3,8(s0)
    prev->next = next->prev = elm;
ffffffffc0203500:	e31c                	sd	a5,0(a4)
ffffffffc0203502:	e51c                	sd	a5,8(a0)
    nr_process++;
ffffffffc0203504:	409c                	lw	a5,0(s1)
    elm->next = next;
ffffffffc0203506:	0ee9b023          	sd	a4,224(s3)
    elm->prev = prev;
ffffffffc020350a:	0ca9bc23          	sd	a0,216(s3)
    list_add(&proc_list, &(proc->list_link));
ffffffffc020350e:	0c898713          	addi	a4,s3,200
    prev->next = next->prev = elm;
ffffffffc0203512:	e298                	sd	a4,0(a3)
    nr_process++;
ffffffffc0203514:	2785                	addiw	a5,a5,1
    wakeup_proc(proc);
ffffffffc0203516:	854e                	mv	a0,s3
    elm->next = next;
ffffffffc0203518:	0cd9b823          	sd	a3,208(s3)
    elm->prev = prev;
ffffffffc020351c:	0c89b423          	sd	s0,200(s3)
    prev->next = next->prev = elm;
ffffffffc0203520:	e418                	sd	a4,8(s0)
    nr_process++;
ffffffffc0203522:	c09c                	sw	a5,0(s1)
    wakeup_proc(proc);
ffffffffc0203524:	3c2000ef          	jal	ra,ffffffffc02038e6 <wakeup_proc>
    ret = proc->pid;
ffffffffc0203528:	0049a503          	lw	a0,4(s3)
}
ffffffffc020352c:	70a2                	ld	ra,40(sp)
ffffffffc020352e:	7402                	ld	s0,32(sp)
ffffffffc0203530:	64e2                	ld	s1,24(sp)
ffffffffc0203532:	6942                	ld	s2,16(sp)
ffffffffc0203534:	69a2                	ld	s3,8(sp)
ffffffffc0203536:	6145                	addi	sp,sp,48
ffffffffc0203538:	8082                	ret
        last_pid = 1;
ffffffffc020353a:	4785                	li	a5,1
ffffffffc020353c:	00f82023          	sw	a5,0(a6)
        goto inside;
ffffffffc0203540:	4505                	li	a0,1
ffffffffc0203542:	00006e17          	auipc	t3,0x6
ffffffffc0203546:	aeae0e13          	addi	t3,t3,-1302 # ffffffffc020902c <next_safe.0>
    return listelm->next;
ffffffffc020354a:	0000a417          	auipc	s0,0xa
ffffffffc020354e:	f0e40413          	addi	s0,s0,-242 # ffffffffc020d458 <proc_list>
ffffffffc0203552:	00843e83          	ld	t4,8(s0)
        next_safe = MAX_PID;
ffffffffc0203556:	6789                	lui	a5,0x2
ffffffffc0203558:	00fe2023          	sw	a5,0(t3)
ffffffffc020355c:	86aa                	mv	a3,a0
ffffffffc020355e:	4581                	li	a1,0
        while ((le = list_next(le)) != list)
ffffffffc0203560:	6f09                	lui	t5,0x2
ffffffffc0203562:	048e8a63          	beq	t4,s0,ffffffffc02035b6 <do_fork+0x1e0>
ffffffffc0203566:	88ae                	mv	a7,a1
ffffffffc0203568:	87f6                	mv	a5,t4
ffffffffc020356a:	6609                	lui	a2,0x2
ffffffffc020356c:	a811                	j	ffffffffc0203580 <do_fork+0x1aa>
            else if (proc->pid > last_pid && next_safe > proc->pid)
ffffffffc020356e:	00e6d663          	bge	a3,a4,ffffffffc020357a <do_fork+0x1a4>
ffffffffc0203572:	00c75463          	bge	a4,a2,ffffffffc020357a <do_fork+0x1a4>
ffffffffc0203576:	863a                	mv	a2,a4
ffffffffc0203578:	4885                	li	a7,1
ffffffffc020357a:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc020357c:	00878d63          	beq	a5,s0,ffffffffc0203596 <do_fork+0x1c0>
            if (proc->pid == last_pid)
ffffffffc0203580:	f3c7a703          	lw	a4,-196(a5) # 1f3c <kern_entry-0xffffffffc01fe0c4>
ffffffffc0203584:	fed715e3          	bne	a4,a3,ffffffffc020356e <do_fork+0x198>
                if (++last_pid >= next_safe)
ffffffffc0203588:	2685                	addiw	a3,a3,1
ffffffffc020358a:	02c6d163          	bge	a3,a2,ffffffffc02035ac <do_fork+0x1d6>
ffffffffc020358e:	679c                	ld	a5,8(a5)
ffffffffc0203590:	4585                	li	a1,1
        while ((le = list_next(le)) != list)
ffffffffc0203592:	fe8797e3          	bne	a5,s0,ffffffffc0203580 <do_fork+0x1aa>
ffffffffc0203596:	c581                	beqz	a1,ffffffffc020359e <do_fork+0x1c8>
ffffffffc0203598:	00d82023          	sw	a3,0(a6)
ffffffffc020359c:	8536                	mv	a0,a3
ffffffffc020359e:	f2088ce3          	beqz	a7,ffffffffc02034d6 <do_fork+0x100>
ffffffffc02035a2:	00ce2023          	sw	a2,0(t3)
ffffffffc02035a6:	bf05                	j	ffffffffc02034d6 <do_fork+0x100>
    proc->tf->gpr.sp = (esp == 0) ? (uintptr_t)proc->tf : esp;
ffffffffc02035a8:	8936                	mv	s2,a3
ffffffffc02035aa:	b5dd                	j	ffffffffc0203490 <do_fork+0xba>
                    if (last_pid >= MAX_PID)
ffffffffc02035ac:	01e6c363          	blt	a3,t5,ffffffffc02035b2 <do_fork+0x1dc>
                        last_pid = 1;
ffffffffc02035b0:	4685                	li	a3,1
                    goto repeat;
ffffffffc02035b2:	4585                	li	a1,1
ffffffffc02035b4:	b77d                	j	ffffffffc0203562 <do_fork+0x18c>
ffffffffc02035b6:	cd81                	beqz	a1,ffffffffc02035ce <do_fork+0x1f8>
ffffffffc02035b8:	00d82023          	sw	a3,0(a6)
    return last_pid;
ffffffffc02035bc:	8536                	mv	a0,a3
ffffffffc02035be:	bf21                	j	ffffffffc02034d6 <do_fork+0x100>
    kfree(proc);
ffffffffc02035c0:	854e                	mv	a0,s3
ffffffffc02035c2:	8a0ff0ef          	jal	ra,ffffffffc0202662 <kfree>
    ret = -E_NO_MEM;
ffffffffc02035c6:	5571                	li	a0,-4
    goto fork_out;
ffffffffc02035c8:	b795                	j	ffffffffc020352c <do_fork+0x156>
    int ret = -E_NO_FREE_PROC;
ffffffffc02035ca:	556d                	li	a0,-5
ffffffffc02035cc:	b785                	j	ffffffffc020352c <do_fork+0x156>
    return last_pid;
ffffffffc02035ce:	00082503          	lw	a0,0(a6)
ffffffffc02035d2:	b711                	j	ffffffffc02034d6 <do_fork+0x100>
    ret = -E_NO_MEM;
ffffffffc02035d4:	5571                	li	a0,-4
    return ret;
ffffffffc02035d6:	bf99                	j	ffffffffc020352c <do_fork+0x156>
    assert(current->mm == NULL);
ffffffffc02035d8:	00002697          	auipc	a3,0x2
ffffffffc02035dc:	07068693          	addi	a3,a3,112 # ffffffffc0205648 <default_pmm_manager+0x90>
ffffffffc02035e0:	00001617          	auipc	a2,0x1
ffffffffc02035e4:	4b860613          	addi	a2,a2,1208 # ffffffffc0204a98 <commands+0x970>
ffffffffc02035e8:	12a00593          	li	a1,298
ffffffffc02035ec:	00002517          	auipc	a0,0x2
ffffffffc02035f0:	07450513          	addi	a0,a0,116 # ffffffffc0205660 <default_pmm_manager+0xa8>
ffffffffc02035f4:	bebfc0ef          	jal	ra,ffffffffc02001de <__panic>
ffffffffc02035f8:	00001617          	auipc	a2,0x1
ffffffffc02035fc:	37060613          	addi	a2,a2,880 # ffffffffc0204968 <commands+0x840>
ffffffffc0203600:	07100593          	li	a1,113
ffffffffc0203604:	00001517          	auipc	a0,0x1
ffffffffc0203608:	32c50513          	addi	a0,a0,812 # ffffffffc0204930 <commands+0x808>
ffffffffc020360c:	bd3fc0ef          	jal	ra,ffffffffc02001de <__panic>

ffffffffc0203610 <kernel_thread>:
{
ffffffffc0203610:	7129                	addi	sp,sp,-320
ffffffffc0203612:	fa22                	sd	s0,304(sp)
ffffffffc0203614:	f626                	sd	s1,296(sp)
ffffffffc0203616:	f24a                	sd	s2,288(sp)
ffffffffc0203618:	84ae                	mv	s1,a1
ffffffffc020361a:	892a                	mv	s2,a0
ffffffffc020361c:	8432                	mv	s0,a2
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc020361e:	4581                	li	a1,0
ffffffffc0203620:	12000613          	li	a2,288
ffffffffc0203624:	850a                	mv	a0,sp
{
ffffffffc0203626:	fe06                	sd	ra,312(sp)
    memset(&tf, 0, sizeof(struct trapframe));
ffffffffc0203628:	426000ef          	jal	ra,ffffffffc0203a4e <memset>
    tf.gpr.s0 = (uintptr_t)fn;
ffffffffc020362c:	e0ca                	sd	s2,64(sp)
    tf.gpr.s1 = (uintptr_t)arg;
ffffffffc020362e:	e4a6                	sd	s1,72(sp)
    tf.status = (read_csr(sstatus) | SSTATUS_SPP | SSTATUS_SPIE) & ~SSTATUS_SIE;
ffffffffc0203630:	100027f3          	csrr	a5,sstatus
ffffffffc0203634:	edd7f793          	andi	a5,a5,-291
ffffffffc0203638:	1207e793          	ori	a5,a5,288
ffffffffc020363c:	e23e                	sd	a5,256(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc020363e:	860a                	mv	a2,sp
ffffffffc0203640:	10046513          	ori	a0,s0,256
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc0203644:	00000797          	auipc	a5,0x0
ffffffffc0203648:	bc678793          	addi	a5,a5,-1082 # ffffffffc020320a <kernel_thread_entry>
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc020364c:	4581                	li	a1,0
    tf.epc = (uintptr_t)kernel_thread_entry;
ffffffffc020364e:	e63e                	sd	a5,264(sp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
ffffffffc0203650:	d87ff0ef          	jal	ra,ffffffffc02033d6 <do_fork>
}
ffffffffc0203654:	70f2                	ld	ra,312(sp)
ffffffffc0203656:	7452                	ld	s0,304(sp)
ffffffffc0203658:	74b2                	ld	s1,296(sp)
ffffffffc020365a:	7912                	ld	s2,288(sp)
ffffffffc020365c:	6131                	addi	sp,sp,320
ffffffffc020365e:	8082                	ret

ffffffffc0203660 <do_exit>:
{
ffffffffc0203660:	1141                	addi	sp,sp,-16
    panic("process exit!!.\n");
ffffffffc0203662:	00002617          	auipc	a2,0x2
ffffffffc0203666:	01660613          	addi	a2,a2,22 # ffffffffc0205678 <default_pmm_manager+0xc0>
ffffffffc020366a:	19b00593          	li	a1,411
ffffffffc020366e:	00002517          	auipc	a0,0x2
ffffffffc0203672:	ff250513          	addi	a0,a0,-14 # ffffffffc0205660 <default_pmm_manager+0xa8>
{
ffffffffc0203676:	e406                	sd	ra,8(sp)
    panic("process exit!!.\n");
ffffffffc0203678:	b67fc0ef          	jal	ra,ffffffffc02001de <__panic>

ffffffffc020367c <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and
//           - create the second kernel thread init_main
void proc_init(void)
{
ffffffffc020367c:	7179                	addi	sp,sp,-48
ffffffffc020367e:	ec26                	sd	s1,24(sp)
    elm->prev = elm->next = elm;
ffffffffc0203680:	0000a797          	auipc	a5,0xa
ffffffffc0203684:	dd878793          	addi	a5,a5,-552 # ffffffffc020d458 <proc_list>
ffffffffc0203688:	f406                	sd	ra,40(sp)
ffffffffc020368a:	f022                	sd	s0,32(sp)
ffffffffc020368c:	e84a                	sd	s2,16(sp)
ffffffffc020368e:	e44e                	sd	s3,8(sp)
ffffffffc0203690:	00006497          	auipc	s1,0x6
ffffffffc0203694:	db848493          	addi	s1,s1,-584 # ffffffffc0209448 <hash_list>
ffffffffc0203698:	e79c                	sd	a5,8(a5)
ffffffffc020369a:	e39c                	sd	a5,0(a5)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i++)
ffffffffc020369c:	0000a717          	auipc	a4,0xa
ffffffffc02036a0:	dac70713          	addi	a4,a4,-596 # ffffffffc020d448 <name.2>
ffffffffc02036a4:	87a6                	mv	a5,s1
ffffffffc02036a6:	e79c                	sd	a5,8(a5)
ffffffffc02036a8:	e39c                	sd	a5,0(a5)
ffffffffc02036aa:	07c1                	addi	a5,a5,16
ffffffffc02036ac:	fef71de3          	bne	a4,a5,ffffffffc02036a6 <proc_init+0x2a>
    {
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL)
ffffffffc02036b0:	bcdff0ef          	jal	ra,ffffffffc020327c <alloc_proc>
ffffffffc02036b4:	0000a917          	auipc	s2,0xa
ffffffffc02036b8:	e2490913          	addi	s2,s2,-476 # ffffffffc020d4d8 <idleproc>
ffffffffc02036bc:	00a93023          	sd	a0,0(s2)
ffffffffc02036c0:	18050d63          	beqz	a0,ffffffffc020385a <proc_init+0x1de>
    {
        panic("cannot alloc idleproc.\n");
    }

    // check the proc structure
    int *context_mem = (int *)kmalloc(sizeof(struct context));
ffffffffc02036c4:	07000513          	li	a0,112
ffffffffc02036c8:	eebfe0ef          	jal	ra,ffffffffc02025b2 <kmalloc>
    memset(context_mem, 0, sizeof(struct context));
ffffffffc02036cc:	07000613          	li	a2,112
ffffffffc02036d0:	4581                	li	a1,0
    int *context_mem = (int *)kmalloc(sizeof(struct context));
ffffffffc02036d2:	842a                	mv	s0,a0
    memset(context_mem, 0, sizeof(struct context));
ffffffffc02036d4:	37a000ef          	jal	ra,ffffffffc0203a4e <memset>
    int context_init_flag = memcmp(&(idleproc->context), context_mem, sizeof(struct context));
ffffffffc02036d8:	00093503          	ld	a0,0(s2)
ffffffffc02036dc:	85a2                	mv	a1,s0
ffffffffc02036de:	07000613          	li	a2,112
ffffffffc02036e2:	03050513          	addi	a0,a0,48
ffffffffc02036e6:	392000ef          	jal	ra,ffffffffc0203a78 <memcmp>
ffffffffc02036ea:	89aa                	mv	s3,a0

    int *proc_name_mem = (int *)kmalloc(PROC_NAME_LEN);
ffffffffc02036ec:	453d                	li	a0,15
ffffffffc02036ee:	ec5fe0ef          	jal	ra,ffffffffc02025b2 <kmalloc>
    memset(proc_name_mem, 0, PROC_NAME_LEN);
ffffffffc02036f2:	463d                	li	a2,15
ffffffffc02036f4:	4581                	li	a1,0
    int *proc_name_mem = (int *)kmalloc(PROC_NAME_LEN);
ffffffffc02036f6:	842a                	mv	s0,a0
    memset(proc_name_mem, 0, PROC_NAME_LEN);
ffffffffc02036f8:	356000ef          	jal	ra,ffffffffc0203a4e <memset>
    int proc_name_flag = memcmp(&(idleproc->name), proc_name_mem, PROC_NAME_LEN);
ffffffffc02036fc:	00093503          	ld	a0,0(s2)
ffffffffc0203700:	463d                	li	a2,15
ffffffffc0203702:	85a2                	mv	a1,s0
ffffffffc0203704:	0b450513          	addi	a0,a0,180
ffffffffc0203708:	370000ef          	jal	ra,ffffffffc0203a78 <memcmp>

    if (idleproc->pgdir == boot_pgdir_pa && idleproc->tf == NULL && !context_init_flag && idleproc->state == PROC_UNINIT && idleproc->pid == -1 && idleproc->runs == 0 && idleproc->kstack == 0 && idleproc->need_resched == 0 && idleproc->parent == NULL && idleproc->mm == NULL && idleproc->flags == 0 && !proc_name_flag)
ffffffffc020370c:	00093783          	ld	a5,0(s2)
ffffffffc0203710:	0000a717          	auipc	a4,0xa
ffffffffc0203714:	d8873703          	ld	a4,-632(a4) # ffffffffc020d498 <boot_pgdir_pa>
ffffffffc0203718:	77d4                	ld	a3,168(a5)
ffffffffc020371a:	0ee68463          	beq	a3,a4,ffffffffc0203802 <proc_init+0x186>
    {
        cprintf("alloc_proc() correct!\n");
    }

    idleproc->pid = 0;
    idleproc->state = PROC_RUNNABLE;
ffffffffc020371e:	4709                	li	a4,2
ffffffffc0203720:	e398                	sd	a4,0(a5)
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc0203722:	00003717          	auipc	a4,0x3
ffffffffc0203726:	8de70713          	addi	a4,a4,-1826 # ffffffffc0206000 <bootstack>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc020372a:	0b478413          	addi	s0,a5,180
    idleproc->kstack = (uintptr_t)bootstack;
ffffffffc020372e:	eb98                	sd	a4,16(a5)
    idleproc->need_resched = 1;
ffffffffc0203730:	4705                	li	a4,1
ffffffffc0203732:	cf98                	sw	a4,24(a5)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc0203734:	4641                	li	a2,16
ffffffffc0203736:	4581                	li	a1,0
ffffffffc0203738:	8522                	mv	a0,s0
ffffffffc020373a:	314000ef          	jal	ra,ffffffffc0203a4e <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc020373e:	463d                	li	a2,15
ffffffffc0203740:	00002597          	auipc	a1,0x2
ffffffffc0203744:	f8058593          	addi	a1,a1,-128 # ffffffffc02056c0 <default_pmm_manager+0x108>
ffffffffc0203748:	8522                	mv	a0,s0
ffffffffc020374a:	316000ef          	jal	ra,ffffffffc0203a60 <memcpy>
    set_proc_name(idleproc, "idle");
    nr_process++;
ffffffffc020374e:	0000a717          	auipc	a4,0xa
ffffffffc0203752:	d9a70713          	addi	a4,a4,-614 # ffffffffc020d4e8 <nr_process>
ffffffffc0203756:	431c                	lw	a5,0(a4)

    current = idleproc;
ffffffffc0203758:	00093683          	ld	a3,0(s2)

    int pid = kernel_thread(init_main, "Hello world!!", 0);
ffffffffc020375c:	4601                	li	a2,0
    nr_process++;
ffffffffc020375e:	2785                	addiw	a5,a5,1
    int pid = kernel_thread(init_main, "Hello world!!", 0);
ffffffffc0203760:	00002597          	auipc	a1,0x2
ffffffffc0203764:	f6858593          	addi	a1,a1,-152 # ffffffffc02056c8 <default_pmm_manager+0x110>
ffffffffc0203768:	00000517          	auipc	a0,0x0
ffffffffc020376c:	b8e50513          	addi	a0,a0,-1138 # ffffffffc02032f6 <init_main>
    nr_process++;
ffffffffc0203770:	c31c                	sw	a5,0(a4)
    current = idleproc;
ffffffffc0203772:	0000a797          	auipc	a5,0xa
ffffffffc0203776:	d4d7bf23          	sd	a3,-674(a5) # ffffffffc020d4d0 <current>
    int pid = kernel_thread(init_main, "Hello world!!", 0);
ffffffffc020377a:	e97ff0ef          	jal	ra,ffffffffc0203610 <kernel_thread>
ffffffffc020377e:	842a                	mv	s0,a0
    if (pid <= 0)
ffffffffc0203780:	0ea05963          	blez	a0,ffffffffc0203872 <proc_init+0x1f6>
    if (0 < pid && pid < MAX_PID)
ffffffffc0203784:	6789                	lui	a5,0x2
ffffffffc0203786:	fff5071b          	addiw	a4,a0,-1
ffffffffc020378a:	17f9                	addi	a5,a5,-2
ffffffffc020378c:	2501                	sext.w	a0,a0
ffffffffc020378e:	02e7e363          	bltu	a5,a4,ffffffffc02037b4 <proc_init+0x138>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
ffffffffc0203792:	45a9                	li	a1,10
ffffffffc0203794:	6f6000ef          	jal	ra,ffffffffc0203e8a <hash32>
ffffffffc0203798:	02051793          	slli	a5,a0,0x20
ffffffffc020379c:	01c7d693          	srli	a3,a5,0x1c
ffffffffc02037a0:	96a6                	add	a3,a3,s1
ffffffffc02037a2:	87b6                	mv	a5,a3
        while ((le = list_next(le)) != list)
ffffffffc02037a4:	a029                	j	ffffffffc02037ae <proc_init+0x132>
            if (proc->pid == pid)
ffffffffc02037a6:	f2c7a703          	lw	a4,-212(a5) # 1f2c <kern_entry-0xffffffffc01fe0d4>
ffffffffc02037aa:	0a870563          	beq	a4,s0,ffffffffc0203854 <proc_init+0x1d8>
    return listelm->next;
ffffffffc02037ae:	679c                	ld	a5,8(a5)
        while ((le = list_next(le)) != list)
ffffffffc02037b0:	fef69be3          	bne	a3,a5,ffffffffc02037a6 <proc_init+0x12a>
    return NULL;
ffffffffc02037b4:	4781                	li	a5,0
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02037b6:	0b478493          	addi	s1,a5,180
ffffffffc02037ba:	4641                	li	a2,16
ffffffffc02037bc:	4581                	li	a1,0
    {
        panic("create init_main failed.\n");
    }

    initproc = find_proc(pid);
ffffffffc02037be:	0000a417          	auipc	s0,0xa
ffffffffc02037c2:	d2240413          	addi	s0,s0,-734 # ffffffffc020d4e0 <initproc>
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02037c6:	8526                	mv	a0,s1
    initproc = find_proc(pid);
ffffffffc02037c8:	e01c                	sd	a5,0(s0)
    memset(proc->name, 0, sizeof(proc->name));
ffffffffc02037ca:	284000ef          	jal	ra,ffffffffc0203a4e <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
ffffffffc02037ce:	463d                	li	a2,15
ffffffffc02037d0:	00002597          	auipc	a1,0x2
ffffffffc02037d4:	f2858593          	addi	a1,a1,-216 # ffffffffc02056f8 <default_pmm_manager+0x140>
ffffffffc02037d8:	8526                	mv	a0,s1
ffffffffc02037da:	286000ef          	jal	ra,ffffffffc0203a60 <memcpy>
    set_proc_name(initproc, "init");

    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc02037de:	00093783          	ld	a5,0(s2)
ffffffffc02037e2:	c7e1                	beqz	a5,ffffffffc02038aa <proc_init+0x22e>
ffffffffc02037e4:	43dc                	lw	a5,4(a5)
ffffffffc02037e6:	e3f1                	bnez	a5,ffffffffc02038aa <proc_init+0x22e>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc02037e8:	601c                	ld	a5,0(s0)
ffffffffc02037ea:	c3c5                	beqz	a5,ffffffffc020388a <proc_init+0x20e>
ffffffffc02037ec:	43d8                	lw	a4,4(a5)
ffffffffc02037ee:	4785                	li	a5,1
ffffffffc02037f0:	08f71d63          	bne	a4,a5,ffffffffc020388a <proc_init+0x20e>
}
ffffffffc02037f4:	70a2                	ld	ra,40(sp)
ffffffffc02037f6:	7402                	ld	s0,32(sp)
ffffffffc02037f8:	64e2                	ld	s1,24(sp)
ffffffffc02037fa:	6942                	ld	s2,16(sp)
ffffffffc02037fc:	69a2                	ld	s3,8(sp)
ffffffffc02037fe:	6145                	addi	sp,sp,48
ffffffffc0203800:	8082                	ret
    if (idleproc->pgdir == boot_pgdir_pa && idleproc->tf == NULL && !context_init_flag && idleproc->state == PROC_UNINIT && idleproc->pid == -1 && idleproc->runs == 0 && idleproc->kstack == 0 && idleproc->need_resched == 0 && idleproc->parent == NULL && idleproc->mm == NULL && idleproc->flags == 0 && !proc_name_flag)
ffffffffc0203802:	73d8                	ld	a4,160(a5)
ffffffffc0203804:	ff09                	bnez	a4,ffffffffc020371e <proc_init+0xa2>
ffffffffc0203806:	f0099ce3          	bnez	s3,ffffffffc020371e <proc_init+0xa2>
ffffffffc020380a:	6394                	ld	a3,0(a5)
ffffffffc020380c:	577d                	li	a4,-1
ffffffffc020380e:	1702                	slli	a4,a4,0x20
ffffffffc0203810:	f0e697e3          	bne	a3,a4,ffffffffc020371e <proc_init+0xa2>
ffffffffc0203814:	4798                	lw	a4,8(a5)
ffffffffc0203816:	f00714e3          	bnez	a4,ffffffffc020371e <proc_init+0xa2>
ffffffffc020381a:	6b98                	ld	a4,16(a5)
ffffffffc020381c:	f00711e3          	bnez	a4,ffffffffc020371e <proc_init+0xa2>
ffffffffc0203820:	4f98                	lw	a4,24(a5)
ffffffffc0203822:	2701                	sext.w	a4,a4
ffffffffc0203824:	ee071de3          	bnez	a4,ffffffffc020371e <proc_init+0xa2>
ffffffffc0203828:	7398                	ld	a4,32(a5)
ffffffffc020382a:	ee071ae3          	bnez	a4,ffffffffc020371e <proc_init+0xa2>
ffffffffc020382e:	7798                	ld	a4,40(a5)
ffffffffc0203830:	ee0717e3          	bnez	a4,ffffffffc020371e <proc_init+0xa2>
ffffffffc0203834:	0b07a703          	lw	a4,176(a5)
ffffffffc0203838:	8d59                	or	a0,a0,a4
ffffffffc020383a:	0005071b          	sext.w	a4,a0
ffffffffc020383e:	ee0710e3          	bnez	a4,ffffffffc020371e <proc_init+0xa2>
        cprintf("alloc_proc() correct!\n");
ffffffffc0203842:	00002517          	auipc	a0,0x2
ffffffffc0203846:	e6650513          	addi	a0,a0,-410 # ffffffffc02056a8 <default_pmm_manager+0xf0>
ffffffffc020384a:	897fc0ef          	jal	ra,ffffffffc02000e0 <cprintf>
    idleproc->pid = 0;
ffffffffc020384e:	00093783          	ld	a5,0(s2)
ffffffffc0203852:	b5f1                	j	ffffffffc020371e <proc_init+0xa2>
            struct proc_struct *proc = le2proc(le, hash_link);
ffffffffc0203854:	f2878793          	addi	a5,a5,-216
ffffffffc0203858:	bfb9                	j	ffffffffc02037b6 <proc_init+0x13a>
        panic("cannot alloc idleproc.\n");
ffffffffc020385a:	00002617          	auipc	a2,0x2
ffffffffc020385e:	e3660613          	addi	a2,a2,-458 # ffffffffc0205690 <default_pmm_manager+0xd8>
ffffffffc0203862:	1b600593          	li	a1,438
ffffffffc0203866:	00002517          	auipc	a0,0x2
ffffffffc020386a:	dfa50513          	addi	a0,a0,-518 # ffffffffc0205660 <default_pmm_manager+0xa8>
ffffffffc020386e:	971fc0ef          	jal	ra,ffffffffc02001de <__panic>
        panic("create init_main failed.\n");
ffffffffc0203872:	00002617          	auipc	a2,0x2
ffffffffc0203876:	e6660613          	addi	a2,a2,-410 # ffffffffc02056d8 <default_pmm_manager+0x120>
ffffffffc020387a:	1d300593          	li	a1,467
ffffffffc020387e:	00002517          	auipc	a0,0x2
ffffffffc0203882:	de250513          	addi	a0,a0,-542 # ffffffffc0205660 <default_pmm_manager+0xa8>
ffffffffc0203886:	959fc0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(initproc != NULL && initproc->pid == 1);
ffffffffc020388a:	00002697          	auipc	a3,0x2
ffffffffc020388e:	e9e68693          	addi	a3,a3,-354 # ffffffffc0205728 <default_pmm_manager+0x170>
ffffffffc0203892:	00001617          	auipc	a2,0x1
ffffffffc0203896:	20660613          	addi	a2,a2,518 # ffffffffc0204a98 <commands+0x970>
ffffffffc020389a:	1da00593          	li	a1,474
ffffffffc020389e:	00002517          	auipc	a0,0x2
ffffffffc02038a2:	dc250513          	addi	a0,a0,-574 # ffffffffc0205660 <default_pmm_manager+0xa8>
ffffffffc02038a6:	939fc0ef          	jal	ra,ffffffffc02001de <__panic>
    assert(idleproc != NULL && idleproc->pid == 0);
ffffffffc02038aa:	00002697          	auipc	a3,0x2
ffffffffc02038ae:	e5668693          	addi	a3,a3,-426 # ffffffffc0205700 <default_pmm_manager+0x148>
ffffffffc02038b2:	00001617          	auipc	a2,0x1
ffffffffc02038b6:	1e660613          	addi	a2,a2,486 # ffffffffc0204a98 <commands+0x970>
ffffffffc02038ba:	1d900593          	li	a1,473
ffffffffc02038be:	00002517          	auipc	a0,0x2
ffffffffc02038c2:	da250513          	addi	a0,a0,-606 # ffffffffc0205660 <default_pmm_manager+0xa8>
ffffffffc02038c6:	919fc0ef          	jal	ra,ffffffffc02001de <__panic>

ffffffffc02038ca <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void cpu_idle(void)
{
ffffffffc02038ca:	1141                	addi	sp,sp,-16
ffffffffc02038cc:	e022                	sd	s0,0(sp)
ffffffffc02038ce:	e406                	sd	ra,8(sp)
ffffffffc02038d0:	0000a417          	auipc	s0,0xa
ffffffffc02038d4:	c0040413          	addi	s0,s0,-1024 # ffffffffc020d4d0 <current>
    while (1)
    {
        if (current->need_resched)
ffffffffc02038d8:	6018                	ld	a4,0(s0)
ffffffffc02038da:	4f1c                	lw	a5,24(a4)
ffffffffc02038dc:	2781                	sext.w	a5,a5
ffffffffc02038de:	dff5                	beqz	a5,ffffffffc02038da <cpu_idle+0x10>
        {
            schedule();
ffffffffc02038e0:	038000ef          	jal	ra,ffffffffc0203918 <schedule>
ffffffffc02038e4:	bfd5                	j	ffffffffc02038d8 <cpu_idle+0xe>

ffffffffc02038e6 <wakeup_proc>:
#include <sched.h>
#include <assert.h>

void
wakeup_proc(struct proc_struct *proc) {
    assert(proc->state != PROC_ZOMBIE && proc->state != PROC_RUNNABLE);
ffffffffc02038e6:	411c                	lw	a5,0(a0)
ffffffffc02038e8:	4705                	li	a4,1
ffffffffc02038ea:	37f9                	addiw	a5,a5,-2
ffffffffc02038ec:	00f77563          	bgeu	a4,a5,ffffffffc02038f6 <wakeup_proc+0x10>
    proc->state = PROC_RUNNABLE;
ffffffffc02038f0:	4789                	li	a5,2
ffffffffc02038f2:	c11c                	sw	a5,0(a0)
ffffffffc02038f4:	8082                	ret
wakeup_proc(struct proc_struct *proc) {
ffffffffc02038f6:	1141                	addi	sp,sp,-16
    assert(proc->state != PROC_ZOMBIE && proc->state != PROC_RUNNABLE);
ffffffffc02038f8:	00002697          	auipc	a3,0x2
ffffffffc02038fc:	e5868693          	addi	a3,a3,-424 # ffffffffc0205750 <default_pmm_manager+0x198>
ffffffffc0203900:	00001617          	auipc	a2,0x1
ffffffffc0203904:	19860613          	addi	a2,a2,408 # ffffffffc0204a98 <commands+0x970>
ffffffffc0203908:	45a5                	li	a1,9
ffffffffc020390a:	00002517          	auipc	a0,0x2
ffffffffc020390e:	e8650513          	addi	a0,a0,-378 # ffffffffc0205790 <default_pmm_manager+0x1d8>
wakeup_proc(struct proc_struct *proc) {
ffffffffc0203912:	e406                	sd	ra,8(sp)
    assert(proc->state != PROC_ZOMBIE && proc->state != PROC_RUNNABLE);
ffffffffc0203914:	8cbfc0ef          	jal	ra,ffffffffc02001de <__panic>

ffffffffc0203918 <schedule>:
}

void
schedule(void) {
ffffffffc0203918:	1141                	addi	sp,sp,-16
ffffffffc020391a:	e406                	sd	ra,8(sp)
ffffffffc020391c:	e022                	sd	s0,0(sp)
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc020391e:	100027f3          	csrr	a5,sstatus
ffffffffc0203922:	8b89                	andi	a5,a5,2
ffffffffc0203924:	4401                	li	s0,0
ffffffffc0203926:	efbd                	bnez	a5,ffffffffc02039a4 <schedule+0x8c>
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
    local_intr_save(intr_flag);
    {
        current->need_resched = 0;
ffffffffc0203928:	0000a897          	auipc	a7,0xa
ffffffffc020392c:	ba88b883          	ld	a7,-1112(a7) # ffffffffc020d4d0 <current>
ffffffffc0203930:	0008ac23          	sw	zero,24(a7)
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc0203934:	0000a517          	auipc	a0,0xa
ffffffffc0203938:	ba453503          	ld	a0,-1116(a0) # ffffffffc020d4d8 <idleproc>
ffffffffc020393c:	04a88e63          	beq	a7,a0,ffffffffc0203998 <schedule+0x80>
ffffffffc0203940:	0c888693          	addi	a3,a7,200
ffffffffc0203944:	0000a617          	auipc	a2,0xa
ffffffffc0203948:	b1460613          	addi	a2,a2,-1260 # ffffffffc020d458 <proc_list>
        le = last;
ffffffffc020394c:	87b6                	mv	a5,a3
    struct proc_struct *next = NULL;
ffffffffc020394e:	4581                	li	a1,0
        do {
            if ((le = list_next(le)) != &proc_list) {
                next = le2proc(le, list_link);
                if (next->state == PROC_RUNNABLE) {
ffffffffc0203950:	4809                	li	a6,2
ffffffffc0203952:	679c                	ld	a5,8(a5)
            if ((le = list_next(le)) != &proc_list) {
ffffffffc0203954:	00c78863          	beq	a5,a2,ffffffffc0203964 <schedule+0x4c>
                if (next->state == PROC_RUNNABLE) {
ffffffffc0203958:	f387a703          	lw	a4,-200(a5)
                next = le2proc(le, list_link);
ffffffffc020395c:	f3878593          	addi	a1,a5,-200
                if (next->state == PROC_RUNNABLE) {
ffffffffc0203960:	03070163          	beq	a4,a6,ffffffffc0203982 <schedule+0x6a>
                    break;
                }
            }
        } while (le != last);
ffffffffc0203964:	fef697e3          	bne	a3,a5,ffffffffc0203952 <schedule+0x3a>
        if (next == NULL || next->state != PROC_RUNNABLE) {
ffffffffc0203968:	ed89                	bnez	a1,ffffffffc0203982 <schedule+0x6a>
            next = idleproc;
        }
        next->runs ++;
ffffffffc020396a:	451c                	lw	a5,8(a0)
ffffffffc020396c:	2785                	addiw	a5,a5,1
ffffffffc020396e:	c51c                	sw	a5,8(a0)
        if (next != current) {
ffffffffc0203970:	00a88463          	beq	a7,a0,ffffffffc0203978 <schedule+0x60>
            proc_run(next);
ffffffffc0203974:	9f5ff0ef          	jal	ra,ffffffffc0203368 <proc_run>
    if (flag) {
ffffffffc0203978:	e819                	bnez	s0,ffffffffc020398e <schedule+0x76>
        }
    }
    local_intr_restore(intr_flag);
}
ffffffffc020397a:	60a2                	ld	ra,8(sp)
ffffffffc020397c:	6402                	ld	s0,0(sp)
ffffffffc020397e:	0141                	addi	sp,sp,16
ffffffffc0203980:	8082                	ret
        if (next == NULL || next->state != PROC_RUNNABLE) {
ffffffffc0203982:	4198                	lw	a4,0(a1)
ffffffffc0203984:	4789                	li	a5,2
ffffffffc0203986:	fef712e3          	bne	a4,a5,ffffffffc020396a <schedule+0x52>
ffffffffc020398a:	852e                	mv	a0,a1
ffffffffc020398c:	bff9                	j	ffffffffc020396a <schedule+0x52>
}
ffffffffc020398e:	6402                	ld	s0,0(sp)
ffffffffc0203990:	60a2                	ld	ra,8(sp)
ffffffffc0203992:	0141                	addi	sp,sp,16
        intr_enable();
ffffffffc0203994:	f9dfc06f          	j	ffffffffc0200930 <intr_enable>
        last = (current == idleproc) ? &proc_list : &(current->list_link);
ffffffffc0203998:	0000a617          	auipc	a2,0xa
ffffffffc020399c:	ac060613          	addi	a2,a2,-1344 # ffffffffc020d458 <proc_list>
ffffffffc02039a0:	86b2                	mv	a3,a2
ffffffffc02039a2:	b76d                	j	ffffffffc020394c <schedule+0x34>
        intr_disable();
ffffffffc02039a4:	f93fc0ef          	jal	ra,ffffffffc0200936 <intr_disable>
        return 1;
ffffffffc02039a8:	4405                	li	s0,1
ffffffffc02039aa:	bfbd                	j	ffffffffc0203928 <schedule+0x10>

ffffffffc02039ac <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc02039ac:	00054783          	lbu	a5,0(a0)
strlen(const char *s) {
ffffffffc02039b0:	872a                	mv	a4,a0
    size_t cnt = 0;
ffffffffc02039b2:	4501                	li	a0,0
    while (*s ++ != '\0') {
ffffffffc02039b4:	cb81                	beqz	a5,ffffffffc02039c4 <strlen+0x18>
        cnt ++;
ffffffffc02039b6:	0505                	addi	a0,a0,1
    while (*s ++ != '\0') {
ffffffffc02039b8:	00a707b3          	add	a5,a4,a0
ffffffffc02039bc:	0007c783          	lbu	a5,0(a5)
ffffffffc02039c0:	fbfd                	bnez	a5,ffffffffc02039b6 <strlen+0xa>
ffffffffc02039c2:	8082                	ret
    }
    return cnt;
}
ffffffffc02039c4:	8082                	ret

ffffffffc02039c6 <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc02039c6:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc02039c8:	e589                	bnez	a1,ffffffffc02039d2 <strnlen+0xc>
ffffffffc02039ca:	a811                	j	ffffffffc02039de <strnlen+0x18>
        cnt ++;
ffffffffc02039cc:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc02039ce:	00f58863          	beq	a1,a5,ffffffffc02039de <strnlen+0x18>
ffffffffc02039d2:	00f50733          	add	a4,a0,a5
ffffffffc02039d6:	00074703          	lbu	a4,0(a4)
ffffffffc02039da:	fb6d                	bnez	a4,ffffffffc02039cc <strnlen+0x6>
ffffffffc02039dc:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc02039de:	852e                	mv	a0,a1
ffffffffc02039e0:	8082                	ret

ffffffffc02039e2 <strcpy>:
char *
strcpy(char *dst, const char *src) {
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
#else
    char *p = dst;
ffffffffc02039e2:	87aa                	mv	a5,a0
    while ((*p ++ = *src ++) != '\0')
ffffffffc02039e4:	0005c703          	lbu	a4,0(a1)
ffffffffc02039e8:	0785                	addi	a5,a5,1
ffffffffc02039ea:	0585                	addi	a1,a1,1
ffffffffc02039ec:	fee78fa3          	sb	a4,-1(a5)
ffffffffc02039f0:	fb75                	bnez	a4,ffffffffc02039e4 <strcpy+0x2>
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
ffffffffc02039f2:	8082                	ret

ffffffffc02039f4 <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc02039f4:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc02039f8:	0005c703          	lbu	a4,0(a1)
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc02039fc:	cb89                	beqz	a5,ffffffffc0203a0e <strcmp+0x1a>
        s1 ++, s2 ++;
ffffffffc02039fe:	0505                	addi	a0,a0,1
ffffffffc0203a00:	0585                	addi	a1,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0203a02:	fee789e3          	beq	a5,a4,ffffffffc02039f4 <strcmp>
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0203a06:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc0203a0a:	9d19                	subw	a0,a0,a4
ffffffffc0203a0c:	8082                	ret
ffffffffc0203a0e:	4501                	li	a0,0
ffffffffc0203a10:	bfed                	j	ffffffffc0203a0a <strcmp+0x16>

ffffffffc0203a12 <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0203a12:	c20d                	beqz	a2,ffffffffc0203a34 <strncmp+0x22>
ffffffffc0203a14:	962e                	add	a2,a2,a1
ffffffffc0203a16:	a031                	j	ffffffffc0203a22 <strncmp+0x10>
        n --, s1 ++, s2 ++;
ffffffffc0203a18:	0505                	addi	a0,a0,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0203a1a:	00e79a63          	bne	a5,a4,ffffffffc0203a2e <strncmp+0x1c>
ffffffffc0203a1e:	00b60b63          	beq	a2,a1,ffffffffc0203a34 <strncmp+0x22>
ffffffffc0203a22:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc0203a26:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0203a28:	fff5c703          	lbu	a4,-1(a1)
ffffffffc0203a2c:	f7f5                	bnez	a5,ffffffffc0203a18 <strncmp+0x6>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0203a2e:	40e7853b          	subw	a0,a5,a4
}
ffffffffc0203a32:	8082                	ret
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0203a34:	4501                	li	a0,0
ffffffffc0203a36:	8082                	ret

ffffffffc0203a38 <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc0203a38:	00054783          	lbu	a5,0(a0)
ffffffffc0203a3c:	c799                	beqz	a5,ffffffffc0203a4a <strchr+0x12>
        if (*s == c) {
ffffffffc0203a3e:	00f58763          	beq	a1,a5,ffffffffc0203a4c <strchr+0x14>
    while (*s != '\0') {
ffffffffc0203a42:	00154783          	lbu	a5,1(a0)
            return (char *)s;
        }
        s ++;
ffffffffc0203a46:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc0203a48:	fbfd                	bnez	a5,ffffffffc0203a3e <strchr+0x6>
    }
    return NULL;
ffffffffc0203a4a:	4501                	li	a0,0
}
ffffffffc0203a4c:	8082                	ret

ffffffffc0203a4e <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc0203a4e:	ca01                	beqz	a2,ffffffffc0203a5e <memset+0x10>
ffffffffc0203a50:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc0203a52:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc0203a54:	0785                	addi	a5,a5,1
ffffffffc0203a56:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc0203a5a:	fec79de3          	bne	a5,a2,ffffffffc0203a54 <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc0203a5e:	8082                	ret

ffffffffc0203a60 <memcpy>:
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
#else
    const char *s = src;
    char *d = dst;
    while (n -- > 0) {
ffffffffc0203a60:	ca19                	beqz	a2,ffffffffc0203a76 <memcpy+0x16>
ffffffffc0203a62:	962e                	add	a2,a2,a1
    char *d = dst;
ffffffffc0203a64:	87aa                	mv	a5,a0
        *d ++ = *s ++;
ffffffffc0203a66:	0005c703          	lbu	a4,0(a1)
ffffffffc0203a6a:	0585                	addi	a1,a1,1
ffffffffc0203a6c:	0785                	addi	a5,a5,1
ffffffffc0203a6e:	fee78fa3          	sb	a4,-1(a5)
    while (n -- > 0) {
ffffffffc0203a72:	fec59ae3          	bne	a1,a2,ffffffffc0203a66 <memcpy+0x6>
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
ffffffffc0203a76:	8082                	ret

ffffffffc0203a78 <memcmp>:
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
ffffffffc0203a78:	c205                	beqz	a2,ffffffffc0203a98 <memcmp+0x20>
ffffffffc0203a7a:	962e                	add	a2,a2,a1
ffffffffc0203a7c:	a019                	j	ffffffffc0203a82 <memcmp+0xa>
ffffffffc0203a7e:	00c58d63          	beq	a1,a2,ffffffffc0203a98 <memcmp+0x20>
        if (*s1 != *s2) {
ffffffffc0203a82:	00054783          	lbu	a5,0(a0)
ffffffffc0203a86:	0005c703          	lbu	a4,0(a1)
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
ffffffffc0203a8a:	0505                	addi	a0,a0,1
ffffffffc0203a8c:	0585                	addi	a1,a1,1
        if (*s1 != *s2) {
ffffffffc0203a8e:	fee788e3          	beq	a5,a4,ffffffffc0203a7e <memcmp+0x6>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0203a92:	40e7853b          	subw	a0,a5,a4
ffffffffc0203a96:	8082                	ret
    }
    return 0;
ffffffffc0203a98:	4501                	li	a0,0
}
ffffffffc0203a9a:	8082                	ret

ffffffffc0203a9c <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc0203a9c:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0203aa0:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc0203aa2:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0203aa6:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc0203aa8:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0203aac:	f022                	sd	s0,32(sp)
ffffffffc0203aae:	ec26                	sd	s1,24(sp)
ffffffffc0203ab0:	e84a                	sd	s2,16(sp)
ffffffffc0203ab2:	f406                	sd	ra,40(sp)
ffffffffc0203ab4:	e44e                	sd	s3,8(sp)
ffffffffc0203ab6:	84aa                	mv	s1,a0
ffffffffc0203ab8:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc0203aba:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc0203abe:	2a01                	sext.w	s4,s4
    if (num >= base) {
ffffffffc0203ac0:	03067e63          	bgeu	a2,a6,ffffffffc0203afc <printnum+0x60>
ffffffffc0203ac4:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc0203ac6:	00805763          	blez	s0,ffffffffc0203ad4 <printnum+0x38>
ffffffffc0203aca:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc0203acc:	85ca                	mv	a1,s2
ffffffffc0203ace:	854e                	mv	a0,s3
ffffffffc0203ad0:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc0203ad2:	fc65                	bnez	s0,ffffffffc0203aca <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0203ad4:	1a02                	slli	s4,s4,0x20
ffffffffc0203ad6:	00002797          	auipc	a5,0x2
ffffffffc0203ada:	cd278793          	addi	a5,a5,-814 # ffffffffc02057a8 <default_pmm_manager+0x1f0>
ffffffffc0203ade:	020a5a13          	srli	s4,s4,0x20
ffffffffc0203ae2:	9a3e                	add	s4,s4,a5
}
ffffffffc0203ae4:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0203ae6:	000a4503          	lbu	a0,0(s4)
}
ffffffffc0203aea:	70a2                	ld	ra,40(sp)
ffffffffc0203aec:	69a2                	ld	s3,8(sp)
ffffffffc0203aee:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0203af0:	85ca                	mv	a1,s2
ffffffffc0203af2:	87a6                	mv	a5,s1
}
ffffffffc0203af4:	6942                	ld	s2,16(sp)
ffffffffc0203af6:	64e2                	ld	s1,24(sp)
ffffffffc0203af8:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0203afa:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc0203afc:	03065633          	divu	a2,a2,a6
ffffffffc0203b00:	8722                	mv	a4,s0
ffffffffc0203b02:	f9bff0ef          	jal	ra,ffffffffc0203a9c <printnum>
ffffffffc0203b06:	b7f9                	j	ffffffffc0203ad4 <printnum+0x38>

ffffffffc0203b08 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc0203b08:	7119                	addi	sp,sp,-128
ffffffffc0203b0a:	f4a6                	sd	s1,104(sp)
ffffffffc0203b0c:	f0ca                	sd	s2,96(sp)
ffffffffc0203b0e:	ecce                	sd	s3,88(sp)
ffffffffc0203b10:	e8d2                	sd	s4,80(sp)
ffffffffc0203b12:	e4d6                	sd	s5,72(sp)
ffffffffc0203b14:	e0da                	sd	s6,64(sp)
ffffffffc0203b16:	fc5e                	sd	s7,56(sp)
ffffffffc0203b18:	f06a                	sd	s10,32(sp)
ffffffffc0203b1a:	fc86                	sd	ra,120(sp)
ffffffffc0203b1c:	f8a2                	sd	s0,112(sp)
ffffffffc0203b1e:	f862                	sd	s8,48(sp)
ffffffffc0203b20:	f466                	sd	s9,40(sp)
ffffffffc0203b22:	ec6e                	sd	s11,24(sp)
ffffffffc0203b24:	892a                	mv	s2,a0
ffffffffc0203b26:	84ae                	mv	s1,a1
ffffffffc0203b28:	8d32                	mv	s10,a2
ffffffffc0203b2a:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0203b2c:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
ffffffffc0203b30:	5b7d                	li	s6,-1
ffffffffc0203b32:	00002a97          	auipc	s5,0x2
ffffffffc0203b36:	ca2a8a93          	addi	s5,s5,-862 # ffffffffc02057d4 <default_pmm_manager+0x21c>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0203b3a:	00002b97          	auipc	s7,0x2
ffffffffc0203b3e:	e76b8b93          	addi	s7,s7,-394 # ffffffffc02059b0 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0203b42:	000d4503          	lbu	a0,0(s10)
ffffffffc0203b46:	001d0413          	addi	s0,s10,1
ffffffffc0203b4a:	01350a63          	beq	a0,s3,ffffffffc0203b5e <vprintfmt+0x56>
            if (ch == '\0') {
ffffffffc0203b4e:	c121                	beqz	a0,ffffffffc0203b8e <vprintfmt+0x86>
            putch(ch, putdat);
ffffffffc0203b50:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0203b52:	0405                	addi	s0,s0,1
            putch(ch, putdat);
ffffffffc0203b54:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0203b56:	fff44503          	lbu	a0,-1(s0)
ffffffffc0203b5a:	ff351ae3          	bne	a0,s3,ffffffffc0203b4e <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203b5e:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
ffffffffc0203b62:	02000793          	li	a5,32
        lflag = altflag = 0;
ffffffffc0203b66:	4c81                	li	s9,0
ffffffffc0203b68:	4881                	li	a7,0
        width = precision = -1;
ffffffffc0203b6a:	5c7d                	li	s8,-1
ffffffffc0203b6c:	5dfd                	li	s11,-1
ffffffffc0203b6e:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
ffffffffc0203b72:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203b74:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0203b78:	0ff5f593          	zext.b	a1,a1
ffffffffc0203b7c:	00140d13          	addi	s10,s0,1
ffffffffc0203b80:	04b56263          	bltu	a0,a1,ffffffffc0203bc4 <vprintfmt+0xbc>
ffffffffc0203b84:	058a                	slli	a1,a1,0x2
ffffffffc0203b86:	95d6                	add	a1,a1,s5
ffffffffc0203b88:	4194                	lw	a3,0(a1)
ffffffffc0203b8a:	96d6                	add	a3,a3,s5
ffffffffc0203b8c:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc0203b8e:	70e6                	ld	ra,120(sp)
ffffffffc0203b90:	7446                	ld	s0,112(sp)
ffffffffc0203b92:	74a6                	ld	s1,104(sp)
ffffffffc0203b94:	7906                	ld	s2,96(sp)
ffffffffc0203b96:	69e6                	ld	s3,88(sp)
ffffffffc0203b98:	6a46                	ld	s4,80(sp)
ffffffffc0203b9a:	6aa6                	ld	s5,72(sp)
ffffffffc0203b9c:	6b06                	ld	s6,64(sp)
ffffffffc0203b9e:	7be2                	ld	s7,56(sp)
ffffffffc0203ba0:	7c42                	ld	s8,48(sp)
ffffffffc0203ba2:	7ca2                	ld	s9,40(sp)
ffffffffc0203ba4:	7d02                	ld	s10,32(sp)
ffffffffc0203ba6:	6de2                	ld	s11,24(sp)
ffffffffc0203ba8:	6109                	addi	sp,sp,128
ffffffffc0203baa:	8082                	ret
            padc = '0';
ffffffffc0203bac:	87b2                	mv	a5,a2
            goto reswitch;
ffffffffc0203bae:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203bb2:	846a                	mv	s0,s10
ffffffffc0203bb4:	00140d13          	addi	s10,s0,1
ffffffffc0203bb8:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0203bbc:	0ff5f593          	zext.b	a1,a1
ffffffffc0203bc0:	fcb572e3          	bgeu	a0,a1,ffffffffc0203b84 <vprintfmt+0x7c>
            putch('%', putdat);
ffffffffc0203bc4:	85a6                	mv	a1,s1
ffffffffc0203bc6:	02500513          	li	a0,37
ffffffffc0203bca:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc0203bcc:	fff44783          	lbu	a5,-1(s0)
ffffffffc0203bd0:	8d22                	mv	s10,s0
ffffffffc0203bd2:	f73788e3          	beq	a5,s3,ffffffffc0203b42 <vprintfmt+0x3a>
ffffffffc0203bd6:	ffed4783          	lbu	a5,-2(s10)
ffffffffc0203bda:	1d7d                	addi	s10,s10,-1
ffffffffc0203bdc:	ff379de3          	bne	a5,s3,ffffffffc0203bd6 <vprintfmt+0xce>
ffffffffc0203be0:	b78d                	j	ffffffffc0203b42 <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
ffffffffc0203be2:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
ffffffffc0203be6:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203bea:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
ffffffffc0203bec:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
ffffffffc0203bf0:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc0203bf4:	02d86463          	bltu	a6,a3,ffffffffc0203c1c <vprintfmt+0x114>
                ch = *fmt;
ffffffffc0203bf8:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc0203bfc:	002c169b          	slliw	a3,s8,0x2
ffffffffc0203c00:	0186873b          	addw	a4,a3,s8
ffffffffc0203c04:	0017171b          	slliw	a4,a4,0x1
ffffffffc0203c08:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
ffffffffc0203c0a:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc0203c0e:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc0203c10:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
ffffffffc0203c14:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc0203c18:	fed870e3          	bgeu	a6,a3,ffffffffc0203bf8 <vprintfmt+0xf0>
            if (width < 0)
ffffffffc0203c1c:	f40ddce3          	bgez	s11,ffffffffc0203b74 <vprintfmt+0x6c>
                width = precision, precision = -1;
ffffffffc0203c20:	8de2                	mv	s11,s8
ffffffffc0203c22:	5c7d                	li	s8,-1
ffffffffc0203c24:	bf81                	j	ffffffffc0203b74 <vprintfmt+0x6c>
            if (width < 0)
ffffffffc0203c26:	fffdc693          	not	a3,s11
ffffffffc0203c2a:	96fd                	srai	a3,a3,0x3f
ffffffffc0203c2c:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203c30:	00144603          	lbu	a2,1(s0)
ffffffffc0203c34:	2d81                	sext.w	s11,s11
ffffffffc0203c36:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0203c38:	bf35                	j	ffffffffc0203b74 <vprintfmt+0x6c>
            precision = va_arg(ap, int);
ffffffffc0203c3a:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203c3e:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
ffffffffc0203c42:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203c44:	846a                	mv	s0,s10
            goto process_precision;
ffffffffc0203c46:	bfd9                	j	ffffffffc0203c1c <vprintfmt+0x114>
    if (lflag >= 2) {
ffffffffc0203c48:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0203c4a:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0203c4e:	01174463          	blt	a4,a7,ffffffffc0203c56 <vprintfmt+0x14e>
    else if (lflag) {
ffffffffc0203c52:	1a088e63          	beqz	a7,ffffffffc0203e0e <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
ffffffffc0203c56:	000a3603          	ld	a2,0(s4)
ffffffffc0203c5a:	46c1                	li	a3,16
ffffffffc0203c5c:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0203c5e:	2781                	sext.w	a5,a5
ffffffffc0203c60:	876e                	mv	a4,s11
ffffffffc0203c62:	85a6                	mv	a1,s1
ffffffffc0203c64:	854a                	mv	a0,s2
ffffffffc0203c66:	e37ff0ef          	jal	ra,ffffffffc0203a9c <printnum>
            break;
ffffffffc0203c6a:	bde1                	j	ffffffffc0203b42 <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
ffffffffc0203c6c:	000a2503          	lw	a0,0(s4)
ffffffffc0203c70:	85a6                	mv	a1,s1
ffffffffc0203c72:	0a21                	addi	s4,s4,8
ffffffffc0203c74:	9902                	jalr	s2
            break;
ffffffffc0203c76:	b5f1                	j	ffffffffc0203b42 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0203c78:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0203c7a:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0203c7e:	01174463          	blt	a4,a7,ffffffffc0203c86 <vprintfmt+0x17e>
    else if (lflag) {
ffffffffc0203c82:	18088163          	beqz	a7,ffffffffc0203e04 <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
ffffffffc0203c86:	000a3603          	ld	a2,0(s4)
ffffffffc0203c8a:	46a9                	li	a3,10
ffffffffc0203c8c:	8a2e                	mv	s4,a1
ffffffffc0203c8e:	bfc1                	j	ffffffffc0203c5e <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203c90:	00144603          	lbu	a2,1(s0)
            altflag = 1;
ffffffffc0203c94:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203c96:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0203c98:	bdf1                	j	ffffffffc0203b74 <vprintfmt+0x6c>
            putch(ch, putdat);
ffffffffc0203c9a:	85a6                	mv	a1,s1
ffffffffc0203c9c:	02500513          	li	a0,37
ffffffffc0203ca0:	9902                	jalr	s2
            break;
ffffffffc0203ca2:	b545                	j	ffffffffc0203b42 <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203ca4:	00144603          	lbu	a2,1(s0)
            lflag ++;
ffffffffc0203ca8:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0203caa:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0203cac:	b5e1                	j	ffffffffc0203b74 <vprintfmt+0x6c>
    if (lflag >= 2) {
ffffffffc0203cae:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0203cb0:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0203cb4:	01174463          	blt	a4,a7,ffffffffc0203cbc <vprintfmt+0x1b4>
    else if (lflag) {
ffffffffc0203cb8:	14088163          	beqz	a7,ffffffffc0203dfa <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
ffffffffc0203cbc:	000a3603          	ld	a2,0(s4)
ffffffffc0203cc0:	46a1                	li	a3,8
ffffffffc0203cc2:	8a2e                	mv	s4,a1
ffffffffc0203cc4:	bf69                	j	ffffffffc0203c5e <vprintfmt+0x156>
            putch('0', putdat);
ffffffffc0203cc6:	03000513          	li	a0,48
ffffffffc0203cca:	85a6                	mv	a1,s1
ffffffffc0203ccc:	e03e                	sd	a5,0(sp)
ffffffffc0203cce:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc0203cd0:	85a6                	mv	a1,s1
ffffffffc0203cd2:	07800513          	li	a0,120
ffffffffc0203cd6:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0203cd8:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc0203cda:	6782                	ld	a5,0(sp)
ffffffffc0203cdc:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0203cde:	ff8a3603          	ld	a2,-8(s4)
            goto number;
ffffffffc0203ce2:	bfb5                	j	ffffffffc0203c5e <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0203ce4:	000a3403          	ld	s0,0(s4)
ffffffffc0203ce8:	008a0713          	addi	a4,s4,8
ffffffffc0203cec:	e03a                	sd	a4,0(sp)
ffffffffc0203cee:	14040263          	beqz	s0,ffffffffc0203e32 <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
ffffffffc0203cf2:	0fb05763          	blez	s11,ffffffffc0203de0 <vprintfmt+0x2d8>
ffffffffc0203cf6:	02d00693          	li	a3,45
ffffffffc0203cfa:	0cd79163          	bne	a5,a3,ffffffffc0203dbc <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0203cfe:	00044783          	lbu	a5,0(s0)
ffffffffc0203d02:	0007851b          	sext.w	a0,a5
ffffffffc0203d06:	cf85                	beqz	a5,ffffffffc0203d3e <vprintfmt+0x236>
ffffffffc0203d08:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0203d0c:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0203d10:	000c4563          	bltz	s8,ffffffffc0203d1a <vprintfmt+0x212>
ffffffffc0203d14:	3c7d                	addiw	s8,s8,-1
ffffffffc0203d16:	036c0263          	beq	s8,s6,ffffffffc0203d3a <vprintfmt+0x232>
                    putch('?', putdat);
ffffffffc0203d1a:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0203d1c:	0e0c8e63          	beqz	s9,ffffffffc0203e18 <vprintfmt+0x310>
ffffffffc0203d20:	3781                	addiw	a5,a5,-32
ffffffffc0203d22:	0ef47b63          	bgeu	s0,a5,ffffffffc0203e18 <vprintfmt+0x310>
                    putch('?', putdat);
ffffffffc0203d26:	03f00513          	li	a0,63
ffffffffc0203d2a:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0203d2c:	000a4783          	lbu	a5,0(s4)
ffffffffc0203d30:	3dfd                	addiw	s11,s11,-1
ffffffffc0203d32:	0a05                	addi	s4,s4,1
ffffffffc0203d34:	0007851b          	sext.w	a0,a5
ffffffffc0203d38:	ffe1                	bnez	a5,ffffffffc0203d10 <vprintfmt+0x208>
            for (; width > 0; width --) {
ffffffffc0203d3a:	01b05963          	blez	s11,ffffffffc0203d4c <vprintfmt+0x244>
ffffffffc0203d3e:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc0203d40:	85a6                	mv	a1,s1
ffffffffc0203d42:	02000513          	li	a0,32
ffffffffc0203d46:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc0203d48:	fe0d9be3          	bnez	s11,ffffffffc0203d3e <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0203d4c:	6a02                	ld	s4,0(sp)
ffffffffc0203d4e:	bbd5                	j	ffffffffc0203b42 <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0203d50:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0203d52:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
ffffffffc0203d56:	01174463          	blt	a4,a7,ffffffffc0203d5e <vprintfmt+0x256>
    else if (lflag) {
ffffffffc0203d5a:	08088d63          	beqz	a7,ffffffffc0203df4 <vprintfmt+0x2ec>
        return va_arg(*ap, long);
ffffffffc0203d5e:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc0203d62:	0a044d63          	bltz	s0,ffffffffc0203e1c <vprintfmt+0x314>
            num = getint(&ap, lflag);
ffffffffc0203d66:	8622                	mv	a2,s0
ffffffffc0203d68:	8a66                	mv	s4,s9
ffffffffc0203d6a:	46a9                	li	a3,10
ffffffffc0203d6c:	bdcd                	j	ffffffffc0203c5e <vprintfmt+0x156>
            err = va_arg(ap, int);
ffffffffc0203d6e:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0203d72:	4719                	li	a4,6
            err = va_arg(ap, int);
ffffffffc0203d74:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc0203d76:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc0203d7a:	8fb5                	xor	a5,a5,a3
ffffffffc0203d7c:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0203d80:	02d74163          	blt	a4,a3,ffffffffc0203da2 <vprintfmt+0x29a>
ffffffffc0203d84:	00369793          	slli	a5,a3,0x3
ffffffffc0203d88:	97de                	add	a5,a5,s7
ffffffffc0203d8a:	639c                	ld	a5,0(a5)
ffffffffc0203d8c:	cb99                	beqz	a5,ffffffffc0203da2 <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
ffffffffc0203d8e:	86be                	mv	a3,a5
ffffffffc0203d90:	00000617          	auipc	a2,0x0
ffffffffc0203d94:	13860613          	addi	a2,a2,312 # ffffffffc0203ec8 <etext+0x28>
ffffffffc0203d98:	85a6                	mv	a1,s1
ffffffffc0203d9a:	854a                	mv	a0,s2
ffffffffc0203d9c:	0ce000ef          	jal	ra,ffffffffc0203e6a <printfmt>
ffffffffc0203da0:	b34d                	j	ffffffffc0203b42 <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
ffffffffc0203da2:	00002617          	auipc	a2,0x2
ffffffffc0203da6:	a2660613          	addi	a2,a2,-1498 # ffffffffc02057c8 <default_pmm_manager+0x210>
ffffffffc0203daa:	85a6                	mv	a1,s1
ffffffffc0203dac:	854a                	mv	a0,s2
ffffffffc0203dae:	0bc000ef          	jal	ra,ffffffffc0203e6a <printfmt>
ffffffffc0203db2:	bb41                	j	ffffffffc0203b42 <vprintfmt+0x3a>
                p = "(null)";
ffffffffc0203db4:	00002417          	auipc	s0,0x2
ffffffffc0203db8:	a0c40413          	addi	s0,s0,-1524 # ffffffffc02057c0 <default_pmm_manager+0x208>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0203dbc:	85e2                	mv	a1,s8
ffffffffc0203dbe:	8522                	mv	a0,s0
ffffffffc0203dc0:	e43e                	sd	a5,8(sp)
ffffffffc0203dc2:	c05ff0ef          	jal	ra,ffffffffc02039c6 <strnlen>
ffffffffc0203dc6:	40ad8dbb          	subw	s11,s11,a0
ffffffffc0203dca:	01b05b63          	blez	s11,ffffffffc0203de0 <vprintfmt+0x2d8>
                    putch(padc, putdat);
ffffffffc0203dce:	67a2                	ld	a5,8(sp)
ffffffffc0203dd0:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0203dd4:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
ffffffffc0203dd6:	85a6                	mv	a1,s1
ffffffffc0203dd8:	8552                	mv	a0,s4
ffffffffc0203dda:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0203ddc:	fe0d9ce3          	bnez	s11,ffffffffc0203dd4 <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0203de0:	00044783          	lbu	a5,0(s0)
ffffffffc0203de4:	00140a13          	addi	s4,s0,1
ffffffffc0203de8:	0007851b          	sext.w	a0,a5
ffffffffc0203dec:	d3a5                	beqz	a5,ffffffffc0203d4c <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0203dee:	05e00413          	li	s0,94
ffffffffc0203df2:	bf39                	j	ffffffffc0203d10 <vprintfmt+0x208>
        return va_arg(*ap, int);
ffffffffc0203df4:	000a2403          	lw	s0,0(s4)
ffffffffc0203df8:	b7ad                	j	ffffffffc0203d62 <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
ffffffffc0203dfa:	000a6603          	lwu	a2,0(s4)
ffffffffc0203dfe:	46a1                	li	a3,8
ffffffffc0203e00:	8a2e                	mv	s4,a1
ffffffffc0203e02:	bdb1                	j	ffffffffc0203c5e <vprintfmt+0x156>
ffffffffc0203e04:	000a6603          	lwu	a2,0(s4)
ffffffffc0203e08:	46a9                	li	a3,10
ffffffffc0203e0a:	8a2e                	mv	s4,a1
ffffffffc0203e0c:	bd89                	j	ffffffffc0203c5e <vprintfmt+0x156>
ffffffffc0203e0e:	000a6603          	lwu	a2,0(s4)
ffffffffc0203e12:	46c1                	li	a3,16
ffffffffc0203e14:	8a2e                	mv	s4,a1
ffffffffc0203e16:	b5a1                	j	ffffffffc0203c5e <vprintfmt+0x156>
                    putch(ch, putdat);
ffffffffc0203e18:	9902                	jalr	s2
ffffffffc0203e1a:	bf09                	j	ffffffffc0203d2c <vprintfmt+0x224>
                putch('-', putdat);
ffffffffc0203e1c:	85a6                	mv	a1,s1
ffffffffc0203e1e:	02d00513          	li	a0,45
ffffffffc0203e22:	e03e                	sd	a5,0(sp)
ffffffffc0203e24:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc0203e26:	6782                	ld	a5,0(sp)
ffffffffc0203e28:	8a66                	mv	s4,s9
ffffffffc0203e2a:	40800633          	neg	a2,s0
ffffffffc0203e2e:	46a9                	li	a3,10
ffffffffc0203e30:	b53d                	j	ffffffffc0203c5e <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
ffffffffc0203e32:	03b05163          	blez	s11,ffffffffc0203e54 <vprintfmt+0x34c>
ffffffffc0203e36:	02d00693          	li	a3,45
ffffffffc0203e3a:	f6d79de3          	bne	a5,a3,ffffffffc0203db4 <vprintfmt+0x2ac>
                p = "(null)";
ffffffffc0203e3e:	00002417          	auipc	s0,0x2
ffffffffc0203e42:	98240413          	addi	s0,s0,-1662 # ffffffffc02057c0 <default_pmm_manager+0x208>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0203e46:	02800793          	li	a5,40
ffffffffc0203e4a:	02800513          	li	a0,40
ffffffffc0203e4e:	00140a13          	addi	s4,s0,1
ffffffffc0203e52:	bd6d                	j	ffffffffc0203d0c <vprintfmt+0x204>
ffffffffc0203e54:	00002a17          	auipc	s4,0x2
ffffffffc0203e58:	96da0a13          	addi	s4,s4,-1683 # ffffffffc02057c1 <default_pmm_manager+0x209>
ffffffffc0203e5c:	02800513          	li	a0,40
ffffffffc0203e60:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0203e64:	05e00413          	li	s0,94
ffffffffc0203e68:	b565                	j	ffffffffc0203d10 <vprintfmt+0x208>

ffffffffc0203e6a <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0203e6a:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc0203e6c:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0203e70:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0203e72:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0203e74:	ec06                	sd	ra,24(sp)
ffffffffc0203e76:	f83a                	sd	a4,48(sp)
ffffffffc0203e78:	fc3e                	sd	a5,56(sp)
ffffffffc0203e7a:	e0c2                	sd	a6,64(sp)
ffffffffc0203e7c:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0203e7e:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0203e80:	c89ff0ef          	jal	ra,ffffffffc0203b08 <vprintfmt>
}
ffffffffc0203e84:	60e2                	ld	ra,24(sp)
ffffffffc0203e86:	6161                	addi	sp,sp,80
ffffffffc0203e88:	8082                	ret

ffffffffc0203e8a <hash32>:
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
ffffffffc0203e8a:	9e3707b7          	lui	a5,0x9e370
ffffffffc0203e8e:	2785                	addiw	a5,a5,1
ffffffffc0203e90:	02a7853b          	mulw	a0,a5,a0
    return (hash >> (32 - bits));
ffffffffc0203e94:	02000793          	li	a5,32
ffffffffc0203e98:	9f8d                	subw	a5,a5,a1
}
ffffffffc0203e9a:	00f5553b          	srlw	a0,a0,a5
ffffffffc0203e9e:	8082                	ret
