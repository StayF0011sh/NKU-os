
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
    .globl kern_entry
kern_entry:
    # a0: hartid
    # a1: dtb physical address
    # save hartid and dtb address
    la t0, boot_hartid
ffffffffc0200000:	00007297          	auipc	t0,0x7
ffffffffc0200004:	00028293          	mv	t0,t0
    sd a0, 0(t0)
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc0207000 <boot_hartid>
    la t0, boot_dtb
ffffffffc020000c:	00007297          	auipc	t0,0x7
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc0207008 <boot_dtb>
    sd a1, 0(t0)
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)

    # t0 := 三级页表的虚拟地址
    lui     t0, %hi(boot_page_table_sv39)
ffffffffc0200018:	c02062b7          	lui	t0,0xc0206
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
ffffffffc020003c:	c0206137          	lui	sp,0xc0206

    # 我们在虚拟内存空间中：随意跳转到虚拟地址！
    # 1. 使用临时寄存器 t1 计算栈顶的精确地址
    lui t1, %hi(bootstacktop)
ffffffffc0200040:	c0206337          	lui	t1,0xc0206
    addi t1, t1, %lo(bootstacktop)
ffffffffc0200044:	00030313          	mv	t1,t1
    # 2. 将精确地址一次性地、安全地传给 sp
    mv sp, t1
ffffffffc0200048:	811a                	mv	sp,t1
    # 现在栈指针已经完美设置，可以安全地调用任何C函数了
    # 然后跳转到 kern_init (不再返回)
    lui t0, %hi(kern_init)
ffffffffc020004a:	c02002b7          	lui	t0,0xc0200
    addi t0, t0, %lo(kern_init)
ffffffffc020004e:	05428293          	addi	t0,t0,84 # ffffffffc0200054 <kern_init>
    jr t0
ffffffffc0200052:	8282                	jr	t0

ffffffffc0200054 <kern_init>:
void grade_backtrace(void);

int kern_init(void) {
    extern char edata[], end[];
    // 先清零 BSS，再读取并保存 DTB 的内存信息，避免被清零覆盖（为了解释变化 正式上传时我觉得应该删去这句话）
    memset(edata, 0, end - edata);
ffffffffc0200054:	00007517          	auipc	a0,0x7
ffffffffc0200058:	fd450513          	addi	a0,a0,-44 # ffffffffc0207028 <free_area>
ffffffffc020005c:	00007617          	auipc	a2,0x7
ffffffffc0200060:	44460613          	addi	a2,a2,1092 # ffffffffc02074a0 <end>
int kern_init(void) {
ffffffffc0200064:	1141                	addi	sp,sp,-16
    memset(edata, 0, end - edata);
ffffffffc0200066:	8e09                	sub	a2,a2,a0
ffffffffc0200068:	4581                	li	a1,0
int kern_init(void) {
ffffffffc020006a:	e406                	sd	ra,8(sp)
    memset(edata, 0, end - edata);
ffffffffc020006c:	229010ef          	jal	ra,ffffffffc0201a94 <memset>
    dtb_init();
ffffffffc0200070:	3c4000ef          	jal	ra,ffffffffc0200434 <dtb_init>
    cons_init();  // init the console
ffffffffc0200074:	7b4000ef          	jal	ra,ffffffffc0200828 <cons_init>
    const char *message = "(THU.CST) os is loading ...\0";
    //cprintf("%s\n\n", message);
    cputs(message);
ffffffffc0200078:	00002517          	auipc	a0,0x2
ffffffffc020007c:	f4050513          	addi	a0,a0,-192 # ffffffffc0201fb8 <etext+0x6>
ffffffffc0200080:	096000ef          	jal	ra,ffffffffc0200116 <cputs>

    print_kerninfo();
ffffffffc0200084:	13e000ef          	jal	ra,ffffffffc02001c2 <print_kerninfo>
    // grade_backtrace();
    idt_init();  // init interrupt descriptor table
ffffffffc0200088:	7ba000ef          	jal	ra,ffffffffc0200842 <idt_init>

    pmm_init();  // init physical memory management
ffffffffc020008c:	4c1000ef          	jal	ra,ffffffffc0200d4c <pmm_init>

    idt_init();  // init interrupt descriptor table
ffffffffc0200090:	7b2000ef          	jal	ra,ffffffffc0200842 <idt_init>

    clock_init();   // init clock interrupt
ffffffffc0200094:	750000ef          	jal	ra,ffffffffc02007e4 <clock_init>
    intr_enable();  // enable irq interrupt
ffffffffc0200098:	79e000ef          	jal	ra,ffffffffc0200836 <intr_enable>
    
    asm("mret");
ffffffffc020009c:	30200073          	mret
    asm("ebreak");
ffffffffc02000a0:	9002                	ebreak

    /* do nothing */
    while (1)
ffffffffc02000a2:	a001                	j	ffffffffc02000a2 <kern_init+0x4e>

ffffffffc02000a4 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
ffffffffc02000a4:	1141                	addi	sp,sp,-16
ffffffffc02000a6:	e022                	sd	s0,0(sp)
ffffffffc02000a8:	e406                	sd	ra,8(sp)
ffffffffc02000aa:	842e                	mv	s0,a1
    cons_putc(c);
ffffffffc02000ac:	77e000ef          	jal	ra,ffffffffc020082a <cons_putc>
    (*cnt) ++;
ffffffffc02000b0:	401c                	lw	a5,0(s0)
}
ffffffffc02000b2:	60a2                	ld	ra,8(sp)
    (*cnt) ++;
ffffffffc02000b4:	2785                	addiw	a5,a5,1
ffffffffc02000b6:	c01c                	sw	a5,0(s0)
}
ffffffffc02000b8:	6402                	ld	s0,0(sp)
ffffffffc02000ba:	0141                	addi	sp,sp,16
ffffffffc02000bc:	8082                	ret

ffffffffc02000be <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
ffffffffc02000be:	1101                	addi	sp,sp,-32
ffffffffc02000c0:	862a                	mv	a2,a0
ffffffffc02000c2:	86ae                	mv	a3,a1
    int cnt = 0;
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02000c4:	00000517          	auipc	a0,0x0
ffffffffc02000c8:	fe050513          	addi	a0,a0,-32 # ffffffffc02000a4 <cputch>
ffffffffc02000cc:	006c                	addi	a1,sp,12
vcprintf(const char *fmt, va_list ap) {
ffffffffc02000ce:	ec06                	sd	ra,24(sp)
    int cnt = 0;
ffffffffc02000d0:	c602                	sw	zero,12(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02000d2:	241010ef          	jal	ra,ffffffffc0201b12 <vprintfmt>
    return cnt;
}
ffffffffc02000d6:	60e2                	ld	ra,24(sp)
ffffffffc02000d8:	4532                	lw	a0,12(sp)
ffffffffc02000da:	6105                	addi	sp,sp,32
ffffffffc02000dc:	8082                	ret

ffffffffc02000de <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
ffffffffc02000de:	711d                	addi	sp,sp,-96
    va_list ap;
    int cnt;
    va_start(ap, fmt);
ffffffffc02000e0:	02810313          	addi	t1,sp,40 # ffffffffc0206028 <boot_page_table_sv39+0x28>
cprintf(const char *fmt, ...) {
ffffffffc02000e4:	8e2a                	mv	t3,a0
ffffffffc02000e6:	f42e                	sd	a1,40(sp)
ffffffffc02000e8:	f832                	sd	a2,48(sp)
ffffffffc02000ea:	fc36                	sd	a3,56(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc02000ec:	00000517          	auipc	a0,0x0
ffffffffc02000f0:	fb850513          	addi	a0,a0,-72 # ffffffffc02000a4 <cputch>
ffffffffc02000f4:	004c                	addi	a1,sp,4
ffffffffc02000f6:	869a                	mv	a3,t1
ffffffffc02000f8:	8672                	mv	a2,t3
cprintf(const char *fmt, ...) {
ffffffffc02000fa:	ec06                	sd	ra,24(sp)
ffffffffc02000fc:	e0ba                	sd	a4,64(sp)
ffffffffc02000fe:	e4be                	sd	a5,72(sp)
ffffffffc0200100:	e8c2                	sd	a6,80(sp)
ffffffffc0200102:	ecc6                	sd	a7,88(sp)
    va_start(ap, fmt);
ffffffffc0200104:	e41a                	sd	t1,8(sp)
    int cnt = 0;
ffffffffc0200106:	c202                	sw	zero,4(sp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
ffffffffc0200108:	20b010ef          	jal	ra,ffffffffc0201b12 <vprintfmt>
    cnt = vcprintf(fmt, ap);
    va_end(ap);
    return cnt;
}
ffffffffc020010c:	60e2                	ld	ra,24(sp)
ffffffffc020010e:	4512                	lw	a0,4(sp)
ffffffffc0200110:	6125                	addi	sp,sp,96
ffffffffc0200112:	8082                	ret

ffffffffc0200114 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
    cons_putc(c);
ffffffffc0200114:	af19                	j	ffffffffc020082a <cons_putc>

ffffffffc0200116 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
ffffffffc0200116:	1101                	addi	sp,sp,-32
ffffffffc0200118:	e822                	sd	s0,16(sp)
ffffffffc020011a:	ec06                	sd	ra,24(sp)
ffffffffc020011c:	e426                	sd	s1,8(sp)
ffffffffc020011e:	842a                	mv	s0,a0
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
ffffffffc0200120:	00054503          	lbu	a0,0(a0)
ffffffffc0200124:	c51d                	beqz	a0,ffffffffc0200152 <cputs+0x3c>
ffffffffc0200126:	0405                	addi	s0,s0,1
ffffffffc0200128:	4485                	li	s1,1
ffffffffc020012a:	9c81                	subw	s1,s1,s0
    cons_putc(c);
ffffffffc020012c:	6fe000ef          	jal	ra,ffffffffc020082a <cons_putc>
    while ((c = *str ++) != '\0') {
ffffffffc0200130:	00044503          	lbu	a0,0(s0)
ffffffffc0200134:	008487bb          	addw	a5,s1,s0
ffffffffc0200138:	0405                	addi	s0,s0,1
ffffffffc020013a:	f96d                	bnez	a0,ffffffffc020012c <cputs+0x16>
    (*cnt) ++;
ffffffffc020013c:	0017841b          	addiw	s0,a5,1
    cons_putc(c);
ffffffffc0200140:	4529                	li	a0,10
ffffffffc0200142:	6e8000ef          	jal	ra,ffffffffc020082a <cons_putc>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
    return cnt;
}
ffffffffc0200146:	60e2                	ld	ra,24(sp)
ffffffffc0200148:	8522                	mv	a0,s0
ffffffffc020014a:	6442                	ld	s0,16(sp)
ffffffffc020014c:	64a2                	ld	s1,8(sp)
ffffffffc020014e:	6105                	addi	sp,sp,32
ffffffffc0200150:	8082                	ret
    while ((c = *str ++) != '\0') {
ffffffffc0200152:	4405                	li	s0,1
ffffffffc0200154:	b7f5                	j	ffffffffc0200140 <cputs+0x2a>

ffffffffc0200156 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
ffffffffc0200156:	1141                	addi	sp,sp,-16
ffffffffc0200158:	e406                	sd	ra,8(sp)
    int c;
    while ((c = cons_getc()) == 0)
ffffffffc020015a:	6d8000ef          	jal	ra,ffffffffc0200832 <cons_getc>
ffffffffc020015e:	dd75                	beqz	a0,ffffffffc020015a <getchar+0x4>
        /* do nothing */;
    return c;
}
ffffffffc0200160:	60a2                	ld	ra,8(sp)
ffffffffc0200162:	0141                	addi	sp,sp,16
ffffffffc0200164:	8082                	ret

ffffffffc0200166 <__panic>:
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
ffffffffc0200166:	00007317          	auipc	t1,0x7
ffffffffc020016a:	2da30313          	addi	t1,t1,730 # ffffffffc0207440 <is_panic>
ffffffffc020016e:	00032e03          	lw	t3,0(t1)
__panic(const char *file, int line, const char *fmt, ...) {
ffffffffc0200172:	715d                	addi	sp,sp,-80
ffffffffc0200174:	ec06                	sd	ra,24(sp)
ffffffffc0200176:	e822                	sd	s0,16(sp)
ffffffffc0200178:	f436                	sd	a3,40(sp)
ffffffffc020017a:	f83a                	sd	a4,48(sp)
ffffffffc020017c:	fc3e                	sd	a5,56(sp)
ffffffffc020017e:	e0c2                	sd	a6,64(sp)
ffffffffc0200180:	e4c6                	sd	a7,72(sp)
    if (is_panic) {
ffffffffc0200182:	020e1a63          	bnez	t3,ffffffffc02001b6 <__panic+0x50>
        goto panic_dead;
    }
    is_panic = 1;
ffffffffc0200186:	4785                	li	a5,1
ffffffffc0200188:	00f32023          	sw	a5,0(t1)

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
ffffffffc020018c:	8432                	mv	s0,a2
ffffffffc020018e:	103c                	addi	a5,sp,40
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc0200190:	862e                	mv	a2,a1
ffffffffc0200192:	85aa                	mv	a1,a0
ffffffffc0200194:	00002517          	auipc	a0,0x2
ffffffffc0200198:	e4450513          	addi	a0,a0,-444 # ffffffffc0201fd8 <etext+0x26>
    va_start(ap, fmt);
ffffffffc020019c:	e43e                	sd	a5,8(sp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
ffffffffc020019e:	f41ff0ef          	jal	ra,ffffffffc02000de <cprintf>
    vcprintf(fmt, ap);
ffffffffc02001a2:	65a2                	ld	a1,8(sp)
ffffffffc02001a4:	8522                	mv	a0,s0
ffffffffc02001a6:	f19ff0ef          	jal	ra,ffffffffc02000be <vcprintf>
    cprintf("\n");
ffffffffc02001aa:	00002517          	auipc	a0,0x2
ffffffffc02001ae:	f1650513          	addi	a0,a0,-234 # ffffffffc02020c0 <etext+0x10e>
ffffffffc02001b2:	f2dff0ef          	jal	ra,ffffffffc02000de <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
ffffffffc02001b6:	686000ef          	jal	ra,ffffffffc020083c <intr_disable>
    while (1) {
        kmonitor(NULL);
ffffffffc02001ba:	4501                	li	a0,0
ffffffffc02001bc:	130000ef          	jal	ra,ffffffffc02002ec <kmonitor>
    while (1) {
ffffffffc02001c0:	bfed                	j	ffffffffc02001ba <__panic+0x54>

ffffffffc02001c2 <print_kerninfo>:
/* *
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void print_kerninfo(void) {
ffffffffc02001c2:	1141                	addi	sp,sp,-16
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
ffffffffc02001c4:	00002517          	auipc	a0,0x2
ffffffffc02001c8:	e3450513          	addi	a0,a0,-460 # ffffffffc0201ff8 <etext+0x46>
void print_kerninfo(void) {
ffffffffc02001cc:	e406                	sd	ra,8(sp)
    cprintf("Special kernel symbols:\n");
ffffffffc02001ce:	f11ff0ef          	jal	ra,ffffffffc02000de <cprintf>
    cprintf("  entry  0x%016lx (virtual)\n", kern_init);
ffffffffc02001d2:	00000597          	auipc	a1,0x0
ffffffffc02001d6:	e8258593          	addi	a1,a1,-382 # ffffffffc0200054 <kern_init>
ffffffffc02001da:	00002517          	auipc	a0,0x2
ffffffffc02001de:	e3e50513          	addi	a0,a0,-450 # ffffffffc0202018 <etext+0x66>
ffffffffc02001e2:	efdff0ef          	jal	ra,ffffffffc02000de <cprintf>
    cprintf("  etext  0x%016lx (virtual)\n", etext);
ffffffffc02001e6:	00002597          	auipc	a1,0x2
ffffffffc02001ea:	dcc58593          	addi	a1,a1,-564 # ffffffffc0201fb2 <etext>
ffffffffc02001ee:	00002517          	auipc	a0,0x2
ffffffffc02001f2:	e4a50513          	addi	a0,a0,-438 # ffffffffc0202038 <etext+0x86>
ffffffffc02001f6:	ee9ff0ef          	jal	ra,ffffffffc02000de <cprintf>
    cprintf("  edata  0x%016lx (virtual)\n", edata);
ffffffffc02001fa:	00007597          	auipc	a1,0x7
ffffffffc02001fe:	e2e58593          	addi	a1,a1,-466 # ffffffffc0207028 <free_area>
ffffffffc0200202:	00002517          	auipc	a0,0x2
ffffffffc0200206:	e5650513          	addi	a0,a0,-426 # ffffffffc0202058 <etext+0xa6>
ffffffffc020020a:	ed5ff0ef          	jal	ra,ffffffffc02000de <cprintf>
    cprintf("  end    0x%016lx (virtual)\n", end);
ffffffffc020020e:	00007597          	auipc	a1,0x7
ffffffffc0200212:	29258593          	addi	a1,a1,658 # ffffffffc02074a0 <end>
ffffffffc0200216:	00002517          	auipc	a0,0x2
ffffffffc020021a:	e6250513          	addi	a0,a0,-414 # ffffffffc0202078 <etext+0xc6>
ffffffffc020021e:	ec1ff0ef          	jal	ra,ffffffffc02000de <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n",
            (end - kern_init + 1023) / 1024);
ffffffffc0200222:	00007597          	auipc	a1,0x7
ffffffffc0200226:	67d58593          	addi	a1,a1,1661 # ffffffffc020789f <end+0x3ff>
ffffffffc020022a:	00000797          	auipc	a5,0x0
ffffffffc020022e:	e2a78793          	addi	a5,a5,-470 # ffffffffc0200054 <kern_init>
ffffffffc0200232:	40f587b3          	sub	a5,a1,a5
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc0200236:	43f7d593          	srai	a1,a5,0x3f
}
ffffffffc020023a:	60a2                	ld	ra,8(sp)
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc020023c:	3ff5f593          	andi	a1,a1,1023
ffffffffc0200240:	95be                	add	a1,a1,a5
ffffffffc0200242:	85a9                	srai	a1,a1,0xa
ffffffffc0200244:	00002517          	auipc	a0,0x2
ffffffffc0200248:	e5450513          	addi	a0,a0,-428 # ffffffffc0202098 <etext+0xe6>
}
ffffffffc020024c:	0141                	addi	sp,sp,16
    cprintf("Kernel executable memory footprint: %dKB\n",
ffffffffc020024e:	bd41                	j	ffffffffc02000de <cprintf>

ffffffffc0200250 <print_stackframe>:
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before
 * jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the
 * boundary.
 * */
void print_stackframe(void) {
ffffffffc0200250:	1141                	addi	sp,sp,-16
    panic("Not Implemented!");
ffffffffc0200252:	00002617          	auipc	a2,0x2
ffffffffc0200256:	e7660613          	addi	a2,a2,-394 # ffffffffc02020c8 <etext+0x116>
ffffffffc020025a:	04d00593          	li	a1,77
ffffffffc020025e:	00002517          	auipc	a0,0x2
ffffffffc0200262:	e8250513          	addi	a0,a0,-382 # ffffffffc02020e0 <etext+0x12e>
void print_stackframe(void) {
ffffffffc0200266:	e406                	sd	ra,8(sp)
    panic("Not Implemented!");
ffffffffc0200268:	effff0ef          	jal	ra,ffffffffc0200166 <__panic>

ffffffffc020026c <mon_help>:
    }
}

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc020026c:	1141                	addi	sp,sp,-16
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc020026e:	00002617          	auipc	a2,0x2
ffffffffc0200272:	e8a60613          	addi	a2,a2,-374 # ffffffffc02020f8 <etext+0x146>
ffffffffc0200276:	00002597          	auipc	a1,0x2
ffffffffc020027a:	ea258593          	addi	a1,a1,-350 # ffffffffc0202118 <etext+0x166>
ffffffffc020027e:	00002517          	auipc	a0,0x2
ffffffffc0200282:	ea250513          	addi	a0,a0,-350 # ffffffffc0202120 <etext+0x16e>
mon_help(int argc, char **argv, struct trapframe *tf) {
ffffffffc0200286:	e406                	sd	ra,8(sp)
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
ffffffffc0200288:	e57ff0ef          	jal	ra,ffffffffc02000de <cprintf>
ffffffffc020028c:	00002617          	auipc	a2,0x2
ffffffffc0200290:	ea460613          	addi	a2,a2,-348 # ffffffffc0202130 <etext+0x17e>
ffffffffc0200294:	00002597          	auipc	a1,0x2
ffffffffc0200298:	ec458593          	addi	a1,a1,-316 # ffffffffc0202158 <etext+0x1a6>
ffffffffc020029c:	00002517          	auipc	a0,0x2
ffffffffc02002a0:	e8450513          	addi	a0,a0,-380 # ffffffffc0202120 <etext+0x16e>
ffffffffc02002a4:	e3bff0ef          	jal	ra,ffffffffc02000de <cprintf>
ffffffffc02002a8:	00002617          	auipc	a2,0x2
ffffffffc02002ac:	ec060613          	addi	a2,a2,-320 # ffffffffc0202168 <etext+0x1b6>
ffffffffc02002b0:	00002597          	auipc	a1,0x2
ffffffffc02002b4:	ed858593          	addi	a1,a1,-296 # ffffffffc0202188 <etext+0x1d6>
ffffffffc02002b8:	00002517          	auipc	a0,0x2
ffffffffc02002bc:	e6850513          	addi	a0,a0,-408 # ffffffffc0202120 <etext+0x16e>
ffffffffc02002c0:	e1fff0ef          	jal	ra,ffffffffc02000de <cprintf>
    }
    return 0;
}
ffffffffc02002c4:	60a2                	ld	ra,8(sp)
ffffffffc02002c6:	4501                	li	a0,0
ffffffffc02002c8:	0141                	addi	sp,sp,16
ffffffffc02002ca:	8082                	ret

ffffffffc02002cc <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
ffffffffc02002cc:	1141                	addi	sp,sp,-16
ffffffffc02002ce:	e406                	sd	ra,8(sp)
    print_kerninfo();
ffffffffc02002d0:	ef3ff0ef          	jal	ra,ffffffffc02001c2 <print_kerninfo>
    return 0;
}
ffffffffc02002d4:	60a2                	ld	ra,8(sp)
ffffffffc02002d6:	4501                	li	a0,0
ffffffffc02002d8:	0141                	addi	sp,sp,16
ffffffffc02002da:	8082                	ret

ffffffffc02002dc <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
ffffffffc02002dc:	1141                	addi	sp,sp,-16
ffffffffc02002de:	e406                	sd	ra,8(sp)
    print_stackframe();
ffffffffc02002e0:	f71ff0ef          	jal	ra,ffffffffc0200250 <print_stackframe>
    return 0;
}
ffffffffc02002e4:	60a2                	ld	ra,8(sp)
ffffffffc02002e6:	4501                	li	a0,0
ffffffffc02002e8:	0141                	addi	sp,sp,16
ffffffffc02002ea:	8082                	ret

ffffffffc02002ec <kmonitor>:
kmonitor(struct trapframe *tf) {
ffffffffc02002ec:	7115                	addi	sp,sp,-224
ffffffffc02002ee:	ed5e                	sd	s7,152(sp)
ffffffffc02002f0:	8baa                	mv	s7,a0
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc02002f2:	00002517          	auipc	a0,0x2
ffffffffc02002f6:	ea650513          	addi	a0,a0,-346 # ffffffffc0202198 <etext+0x1e6>
kmonitor(struct trapframe *tf) {
ffffffffc02002fa:	ed86                	sd	ra,216(sp)
ffffffffc02002fc:	e9a2                	sd	s0,208(sp)
ffffffffc02002fe:	e5a6                	sd	s1,200(sp)
ffffffffc0200300:	e1ca                	sd	s2,192(sp)
ffffffffc0200302:	fd4e                	sd	s3,184(sp)
ffffffffc0200304:	f952                	sd	s4,176(sp)
ffffffffc0200306:	f556                	sd	s5,168(sp)
ffffffffc0200308:	f15a                	sd	s6,160(sp)
ffffffffc020030a:	e962                	sd	s8,144(sp)
ffffffffc020030c:	e566                	sd	s9,136(sp)
ffffffffc020030e:	e16a                	sd	s10,128(sp)
    cprintf("Welcome to the kernel debug monitor!!\n");
ffffffffc0200310:	dcfff0ef          	jal	ra,ffffffffc02000de <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
ffffffffc0200314:	00002517          	auipc	a0,0x2
ffffffffc0200318:	eac50513          	addi	a0,a0,-340 # ffffffffc02021c0 <etext+0x20e>
ffffffffc020031c:	dc3ff0ef          	jal	ra,ffffffffc02000de <cprintf>
    if (tf != NULL) {
ffffffffc0200320:	000b8563          	beqz	s7,ffffffffc020032a <kmonitor+0x3e>
        print_trapframe(tf);
ffffffffc0200324:	855e                	mv	a0,s7
ffffffffc0200326:	6fc000ef          	jal	ra,ffffffffc0200a22 <print_trapframe>
ffffffffc020032a:	00002c17          	auipc	s8,0x2
ffffffffc020032e:	f06c0c13          	addi	s8,s8,-250 # ffffffffc0202230 <commands>
        if ((buf = readline("K> ")) != NULL) {
ffffffffc0200332:	00002917          	auipc	s2,0x2
ffffffffc0200336:	eb690913          	addi	s2,s2,-330 # ffffffffc02021e8 <etext+0x236>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc020033a:	00002497          	auipc	s1,0x2
ffffffffc020033e:	eb648493          	addi	s1,s1,-330 # ffffffffc02021f0 <etext+0x23e>
        if (argc == MAXARGS - 1) {
ffffffffc0200342:	49bd                	li	s3,15
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc0200344:	00002b17          	auipc	s6,0x2
ffffffffc0200348:	eb4b0b13          	addi	s6,s6,-332 # ffffffffc02021f8 <etext+0x246>
        argv[argc ++] = buf;
ffffffffc020034c:	00002a17          	auipc	s4,0x2
ffffffffc0200350:	dcca0a13          	addi	s4,s4,-564 # ffffffffc0202118 <etext+0x166>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200354:	4a8d                	li	s5,3
        if ((buf = readline("K> ")) != NULL) {
ffffffffc0200356:	854a                	mv	a0,s2
ffffffffc0200358:	33d010ef          	jal	ra,ffffffffc0201e94 <readline>
ffffffffc020035c:	842a                	mv	s0,a0
ffffffffc020035e:	dd65                	beqz	a0,ffffffffc0200356 <kmonitor+0x6a>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200360:	00054583          	lbu	a1,0(a0)
    int argc = 0;
ffffffffc0200364:	4c81                	li	s9,0
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200366:	e1bd                	bnez	a1,ffffffffc02003cc <kmonitor+0xe0>
    if (argc == 0) {
ffffffffc0200368:	fe0c87e3          	beqz	s9,ffffffffc0200356 <kmonitor+0x6a>
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc020036c:	6582                	ld	a1,0(sp)
ffffffffc020036e:	00002d17          	auipc	s10,0x2
ffffffffc0200372:	ec2d0d13          	addi	s10,s10,-318 # ffffffffc0202230 <commands>
        argv[argc ++] = buf;
ffffffffc0200376:	8552                	mv	a0,s4
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200378:	4401                	li	s0,0
ffffffffc020037a:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc020037c:	6be010ef          	jal	ra,ffffffffc0201a3a <strcmp>
ffffffffc0200380:	c919                	beqz	a0,ffffffffc0200396 <kmonitor+0xaa>
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc0200382:	2405                	addiw	s0,s0,1
ffffffffc0200384:	0b540063          	beq	s0,s5,ffffffffc0200424 <kmonitor+0x138>
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200388:	000d3503          	ld	a0,0(s10)
ffffffffc020038c:	6582                	ld	a1,0(sp)
    for (i = 0; i < NCOMMANDS; i ++) {
ffffffffc020038e:	0d61                	addi	s10,s10,24
        if (strcmp(commands[i].name, argv[0]) == 0) {
ffffffffc0200390:	6aa010ef          	jal	ra,ffffffffc0201a3a <strcmp>
ffffffffc0200394:	f57d                	bnez	a0,ffffffffc0200382 <kmonitor+0x96>
            return commands[i].func(argc - 1, argv + 1, tf);
ffffffffc0200396:	00141793          	slli	a5,s0,0x1
ffffffffc020039a:	97a2                	add	a5,a5,s0
ffffffffc020039c:	078e                	slli	a5,a5,0x3
ffffffffc020039e:	97e2                	add	a5,a5,s8
ffffffffc02003a0:	6b9c                	ld	a5,16(a5)
ffffffffc02003a2:	865e                	mv	a2,s7
ffffffffc02003a4:	002c                	addi	a1,sp,8
ffffffffc02003a6:	fffc851b          	addiw	a0,s9,-1
ffffffffc02003aa:	9782                	jalr	a5
            if (runcmd(buf, tf) < 0) {
ffffffffc02003ac:	fa0555e3          	bgez	a0,ffffffffc0200356 <kmonitor+0x6a>
}
ffffffffc02003b0:	60ee                	ld	ra,216(sp)
ffffffffc02003b2:	644e                	ld	s0,208(sp)
ffffffffc02003b4:	64ae                	ld	s1,200(sp)
ffffffffc02003b6:	690e                	ld	s2,192(sp)
ffffffffc02003b8:	79ea                	ld	s3,184(sp)
ffffffffc02003ba:	7a4a                	ld	s4,176(sp)
ffffffffc02003bc:	7aaa                	ld	s5,168(sp)
ffffffffc02003be:	7b0a                	ld	s6,160(sp)
ffffffffc02003c0:	6bea                	ld	s7,152(sp)
ffffffffc02003c2:	6c4a                	ld	s8,144(sp)
ffffffffc02003c4:	6caa                	ld	s9,136(sp)
ffffffffc02003c6:	6d0a                	ld	s10,128(sp)
ffffffffc02003c8:	612d                	addi	sp,sp,224
ffffffffc02003ca:	8082                	ret
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003cc:	8526                	mv	a0,s1
ffffffffc02003ce:	6b0010ef          	jal	ra,ffffffffc0201a7e <strchr>
ffffffffc02003d2:	c901                	beqz	a0,ffffffffc02003e2 <kmonitor+0xf6>
ffffffffc02003d4:	00144583          	lbu	a1,1(s0)
            *buf ++ = '\0';
ffffffffc02003d8:	00040023          	sb	zero,0(s0)
ffffffffc02003dc:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc02003de:	d5c9                	beqz	a1,ffffffffc0200368 <kmonitor+0x7c>
ffffffffc02003e0:	b7f5                	j	ffffffffc02003cc <kmonitor+0xe0>
        if (*buf == '\0') {
ffffffffc02003e2:	00044783          	lbu	a5,0(s0)
ffffffffc02003e6:	d3c9                	beqz	a5,ffffffffc0200368 <kmonitor+0x7c>
        if (argc == MAXARGS - 1) {
ffffffffc02003e8:	033c8963          	beq	s9,s3,ffffffffc020041a <kmonitor+0x12e>
        argv[argc ++] = buf;
ffffffffc02003ec:	003c9793          	slli	a5,s9,0x3
ffffffffc02003f0:	0118                	addi	a4,sp,128
ffffffffc02003f2:	97ba                	add	a5,a5,a4
ffffffffc02003f4:	f887b023          	sd	s0,-128(a5)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc02003f8:	00044583          	lbu	a1,0(s0)
        argv[argc ++] = buf;
ffffffffc02003fc:	2c85                	addiw	s9,s9,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc02003fe:	e591                	bnez	a1,ffffffffc020040a <kmonitor+0x11e>
ffffffffc0200400:	b7b5                	j	ffffffffc020036c <kmonitor+0x80>
ffffffffc0200402:	00144583          	lbu	a1,1(s0)
            buf ++;
ffffffffc0200406:	0405                	addi	s0,s0,1
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
ffffffffc0200408:	d1a5                	beqz	a1,ffffffffc0200368 <kmonitor+0x7c>
ffffffffc020040a:	8526                	mv	a0,s1
ffffffffc020040c:	672010ef          	jal	ra,ffffffffc0201a7e <strchr>
ffffffffc0200410:	d96d                	beqz	a0,ffffffffc0200402 <kmonitor+0x116>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
ffffffffc0200412:	00044583          	lbu	a1,0(s0)
ffffffffc0200416:	d9a9                	beqz	a1,ffffffffc0200368 <kmonitor+0x7c>
ffffffffc0200418:	bf55                	j	ffffffffc02003cc <kmonitor+0xe0>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
ffffffffc020041a:	45c1                	li	a1,16
ffffffffc020041c:	855a                	mv	a0,s6
ffffffffc020041e:	cc1ff0ef          	jal	ra,ffffffffc02000de <cprintf>
ffffffffc0200422:	b7e9                	j	ffffffffc02003ec <kmonitor+0x100>
    cprintf("Unknown command '%s'\n", argv[0]);
ffffffffc0200424:	6582                	ld	a1,0(sp)
ffffffffc0200426:	00002517          	auipc	a0,0x2
ffffffffc020042a:	df250513          	addi	a0,a0,-526 # ffffffffc0202218 <etext+0x266>
ffffffffc020042e:	cb1ff0ef          	jal	ra,ffffffffc02000de <cprintf>
    return 0;
ffffffffc0200432:	b715                	j	ffffffffc0200356 <kmonitor+0x6a>

ffffffffc0200434 <dtb_init>:

// 保存解析出的系统物理内存信息
static uint64_t memory_base = 0;
static uint64_t memory_size = 0;

void dtb_init(void) {
ffffffffc0200434:	7119                	addi	sp,sp,-128
    cprintf("DTB Init\n");
ffffffffc0200436:	00002517          	auipc	a0,0x2
ffffffffc020043a:	e4250513          	addi	a0,a0,-446 # ffffffffc0202278 <commands+0x48>
void dtb_init(void) {
ffffffffc020043e:	fc86                	sd	ra,120(sp)
ffffffffc0200440:	f8a2                	sd	s0,112(sp)
ffffffffc0200442:	e8d2                	sd	s4,80(sp)
ffffffffc0200444:	f4a6                	sd	s1,104(sp)
ffffffffc0200446:	f0ca                	sd	s2,96(sp)
ffffffffc0200448:	ecce                	sd	s3,88(sp)
ffffffffc020044a:	e4d6                	sd	s5,72(sp)
ffffffffc020044c:	e0da                	sd	s6,64(sp)
ffffffffc020044e:	fc5e                	sd	s7,56(sp)
ffffffffc0200450:	f862                	sd	s8,48(sp)
ffffffffc0200452:	f466                	sd	s9,40(sp)
ffffffffc0200454:	f06a                	sd	s10,32(sp)
ffffffffc0200456:	ec6e                	sd	s11,24(sp)
    cprintf("DTB Init\n");
ffffffffc0200458:	c87ff0ef          	jal	ra,ffffffffc02000de <cprintf>
    cprintf("HartID: %ld\n", boot_hartid);
ffffffffc020045c:	00007597          	auipc	a1,0x7
ffffffffc0200460:	ba45b583          	ld	a1,-1116(a1) # ffffffffc0207000 <boot_hartid>
ffffffffc0200464:	00002517          	auipc	a0,0x2
ffffffffc0200468:	e2450513          	addi	a0,a0,-476 # ffffffffc0202288 <commands+0x58>
ffffffffc020046c:	c73ff0ef          	jal	ra,ffffffffc02000de <cprintf>
    cprintf("DTB Address: 0x%lx\n", boot_dtb);
ffffffffc0200470:	00007417          	auipc	s0,0x7
ffffffffc0200474:	b9840413          	addi	s0,s0,-1128 # ffffffffc0207008 <boot_dtb>
ffffffffc0200478:	600c                	ld	a1,0(s0)
ffffffffc020047a:	00002517          	auipc	a0,0x2
ffffffffc020047e:	e1e50513          	addi	a0,a0,-482 # ffffffffc0202298 <commands+0x68>
ffffffffc0200482:	c5dff0ef          	jal	ra,ffffffffc02000de <cprintf>
    
    if (boot_dtb == 0) {
ffffffffc0200486:	00043a03          	ld	s4,0(s0)
        cprintf("Error: DTB address is null\n");
ffffffffc020048a:	00002517          	auipc	a0,0x2
ffffffffc020048e:	e2650513          	addi	a0,a0,-474 # ffffffffc02022b0 <commands+0x80>
    if (boot_dtb == 0) {
ffffffffc0200492:	120a0463          	beqz	s4,ffffffffc02005ba <dtb_init+0x186>
        return;
    }
    
    // 转换为虚拟地址
    uintptr_t dtb_vaddr = boot_dtb + PHYSICAL_MEMORY_OFFSET;
ffffffffc0200496:	57f5                	li	a5,-3
ffffffffc0200498:	07fa                	slli	a5,a5,0x1e
ffffffffc020049a:	00fa0733          	add	a4,s4,a5
    const struct fdt_header *header = (const struct fdt_header *)dtb_vaddr;
    
    // 验证DTB
    uint32_t magic = fdt32_to_cpu(header->magic);
ffffffffc020049e:	431c                	lw	a5,0(a4)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004a0:	00ff0637          	lui	a2,0xff0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004a4:	6b41                	lui	s6,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004a6:	0087d59b          	srliw	a1,a5,0x8
ffffffffc02004aa:	0187969b          	slliw	a3,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004ae:	0187d51b          	srliw	a0,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004b2:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004b6:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004ba:	8df1                	and	a1,a1,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004bc:	8ec9                	or	a3,a3,a0
ffffffffc02004be:	0087979b          	slliw	a5,a5,0x8
ffffffffc02004c2:	1b7d                	addi	s6,s6,-1
ffffffffc02004c4:	0167f7b3          	and	a5,a5,s6
ffffffffc02004c8:	8dd5                	or	a1,a1,a3
ffffffffc02004ca:	8ddd                	or	a1,a1,a5
    if (magic != 0xd00dfeed) {
ffffffffc02004cc:	d00e07b7          	lui	a5,0xd00e0
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004d0:	2581                	sext.w	a1,a1
    if (magic != 0xd00dfeed) {
ffffffffc02004d2:	eed78793          	addi	a5,a5,-275 # ffffffffd00dfeed <end+0xfed8a4d>
ffffffffc02004d6:	10f59163          	bne	a1,a5,ffffffffc02005d8 <dtb_init+0x1a4>
        return;
    }
    
    // 提取内存信息
    uint64_t mem_base, mem_size;
    if (extract_memory_info(dtb_vaddr, header, &mem_base, &mem_size) == 0) {
ffffffffc02004da:	471c                	lw	a5,8(a4)
ffffffffc02004dc:	4754                	lw	a3,12(a4)
    int in_memory_node = 0;
ffffffffc02004de:	4c81                	li	s9,0
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004e0:	0087d59b          	srliw	a1,a5,0x8
ffffffffc02004e4:	0086d51b          	srliw	a0,a3,0x8
ffffffffc02004e8:	0186941b          	slliw	s0,a3,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004ec:	0186d89b          	srliw	a7,a3,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004f0:	01879a1b          	slliw	s4,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004f4:	0187d81b          	srliw	a6,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02004f8:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02004fc:	0106d69b          	srliw	a3,a3,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200500:	0105959b          	slliw	a1,a1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200504:	0107d79b          	srliw	a5,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200508:	8d71                	and	a0,a0,a2
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020050a:	01146433          	or	s0,s0,a7
ffffffffc020050e:	0086969b          	slliw	a3,a3,0x8
ffffffffc0200512:	010a6a33          	or	s4,s4,a6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200516:	8e6d                	and	a2,a2,a1
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200518:	0087979b          	slliw	a5,a5,0x8
ffffffffc020051c:	8c49                	or	s0,s0,a0
ffffffffc020051e:	0166f6b3          	and	a3,a3,s6
ffffffffc0200522:	00ca6a33          	or	s4,s4,a2
ffffffffc0200526:	0167f7b3          	and	a5,a5,s6
ffffffffc020052a:	8c55                	or	s0,s0,a3
ffffffffc020052c:	00fa6a33          	or	s4,s4,a5
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200530:	1402                	slli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200532:	1a02                	slli	s4,s4,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc0200534:	9001                	srli	s0,s0,0x20
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc0200536:	020a5a13          	srli	s4,s4,0x20
    const char *strings_base = (const char *)(dtb_vaddr + strings_offset);
ffffffffc020053a:	943a                	add	s0,s0,a4
    const uint32_t *struct_ptr = (const uint32_t *)(dtb_vaddr + struct_offset);
ffffffffc020053c:	9a3a                	add	s4,s4,a4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020053e:	00ff0c37          	lui	s8,0xff0
        switch (token) {
ffffffffc0200542:	4b8d                	li	s7,3
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200544:	00002917          	auipc	s2,0x2
ffffffffc0200548:	dbc90913          	addi	s2,s2,-580 # ffffffffc0202300 <commands+0xd0>
ffffffffc020054c:	49bd                	li	s3,15
        switch (token) {
ffffffffc020054e:	4d91                	li	s11,4
ffffffffc0200550:	4d05                	li	s10,1
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc0200552:	00002497          	auipc	s1,0x2
ffffffffc0200556:	da648493          	addi	s1,s1,-602 # ffffffffc02022f8 <commands+0xc8>
        uint32_t token = fdt32_to_cpu(*struct_ptr++);
ffffffffc020055a:	000a2703          	lw	a4,0(s4)
ffffffffc020055e:	004a0a93          	addi	s5,s4,4
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200562:	0087569b          	srliw	a3,a4,0x8
ffffffffc0200566:	0187179b          	slliw	a5,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020056a:	0187561b          	srliw	a2,a4,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020056e:	0106969b          	slliw	a3,a3,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200572:	0107571b          	srliw	a4,a4,0x10
ffffffffc0200576:	8fd1                	or	a5,a5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200578:	0186f6b3          	and	a3,a3,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020057c:	0087171b          	slliw	a4,a4,0x8
ffffffffc0200580:	8fd5                	or	a5,a5,a3
ffffffffc0200582:	00eb7733          	and	a4,s6,a4
ffffffffc0200586:	8fd9                	or	a5,a5,a4
ffffffffc0200588:	2781                	sext.w	a5,a5
        switch (token) {
ffffffffc020058a:	09778c63          	beq	a5,s7,ffffffffc0200622 <dtb_init+0x1ee>
ffffffffc020058e:	00fbea63          	bltu	s7,a5,ffffffffc02005a2 <dtb_init+0x16e>
ffffffffc0200592:	07a78663          	beq	a5,s10,ffffffffc02005fe <dtb_init+0x1ca>
ffffffffc0200596:	4709                	li	a4,2
ffffffffc0200598:	00e79763          	bne	a5,a4,ffffffffc02005a6 <dtb_init+0x172>
ffffffffc020059c:	4c81                	li	s9,0
ffffffffc020059e:	8a56                	mv	s4,s5
ffffffffc02005a0:	bf6d                	j	ffffffffc020055a <dtb_init+0x126>
ffffffffc02005a2:	ffb78ee3          	beq	a5,s11,ffffffffc020059e <dtb_init+0x16a>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
        // 保存到全局变量，供 PMM 查询
        memory_base = mem_base;
        memory_size = mem_size;
    } else {
        cprintf("Warning: Could not extract memory info from DTB\n");
ffffffffc02005a6:	00002517          	auipc	a0,0x2
ffffffffc02005aa:	dd250513          	addi	a0,a0,-558 # ffffffffc0202378 <commands+0x148>
ffffffffc02005ae:	b31ff0ef          	jal	ra,ffffffffc02000de <cprintf>
    }
    cprintf("DTB init completed\n");
ffffffffc02005b2:	00002517          	auipc	a0,0x2
ffffffffc02005b6:	dfe50513          	addi	a0,a0,-514 # ffffffffc02023b0 <commands+0x180>
}
ffffffffc02005ba:	7446                	ld	s0,112(sp)
ffffffffc02005bc:	70e6                	ld	ra,120(sp)
ffffffffc02005be:	74a6                	ld	s1,104(sp)
ffffffffc02005c0:	7906                	ld	s2,96(sp)
ffffffffc02005c2:	69e6                	ld	s3,88(sp)
ffffffffc02005c4:	6a46                	ld	s4,80(sp)
ffffffffc02005c6:	6aa6                	ld	s5,72(sp)
ffffffffc02005c8:	6b06                	ld	s6,64(sp)
ffffffffc02005ca:	7be2                	ld	s7,56(sp)
ffffffffc02005cc:	7c42                	ld	s8,48(sp)
ffffffffc02005ce:	7ca2                	ld	s9,40(sp)
ffffffffc02005d0:	7d02                	ld	s10,32(sp)
ffffffffc02005d2:	6de2                	ld	s11,24(sp)
ffffffffc02005d4:	6109                	addi	sp,sp,128
    cprintf("DTB init completed\n");
ffffffffc02005d6:	b621                	j	ffffffffc02000de <cprintf>
}
ffffffffc02005d8:	7446                	ld	s0,112(sp)
ffffffffc02005da:	70e6                	ld	ra,120(sp)
ffffffffc02005dc:	74a6                	ld	s1,104(sp)
ffffffffc02005de:	7906                	ld	s2,96(sp)
ffffffffc02005e0:	69e6                	ld	s3,88(sp)
ffffffffc02005e2:	6a46                	ld	s4,80(sp)
ffffffffc02005e4:	6aa6                	ld	s5,72(sp)
ffffffffc02005e6:	6b06                	ld	s6,64(sp)
ffffffffc02005e8:	7be2                	ld	s7,56(sp)
ffffffffc02005ea:	7c42                	ld	s8,48(sp)
ffffffffc02005ec:	7ca2                	ld	s9,40(sp)
ffffffffc02005ee:	7d02                	ld	s10,32(sp)
ffffffffc02005f0:	6de2                	ld	s11,24(sp)
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc02005f2:	00002517          	auipc	a0,0x2
ffffffffc02005f6:	cde50513          	addi	a0,a0,-802 # ffffffffc02022d0 <commands+0xa0>
}
ffffffffc02005fa:	6109                	addi	sp,sp,128
        cprintf("Error: Invalid DTB magic number: 0x%x\n", magic);
ffffffffc02005fc:	b4cd                	j	ffffffffc02000de <cprintf>
                int name_len = strlen(name);
ffffffffc02005fe:	8556                	mv	a0,s5
ffffffffc0200600:	404010ef          	jal	ra,ffffffffc0201a04 <strlen>
ffffffffc0200604:	8a2a                	mv	s4,a0
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc0200606:	4619                	li	a2,6
ffffffffc0200608:	85a6                	mv	a1,s1
ffffffffc020060a:	8556                	mv	a0,s5
                int name_len = strlen(name);
ffffffffc020060c:	2a01                	sext.w	s4,s4
                if (strncmp(name, "memory", 6) == 0) {
ffffffffc020060e:	44a010ef          	jal	ra,ffffffffc0201a58 <strncmp>
ffffffffc0200612:	e111                	bnez	a0,ffffffffc0200616 <dtb_init+0x1e2>
                    in_memory_node = 1;
ffffffffc0200614:	4c85                	li	s9,1
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + name_len + 4) & ~3);
ffffffffc0200616:	0a91                	addi	s5,s5,4
ffffffffc0200618:	9ad2                	add	s5,s5,s4
ffffffffc020061a:	ffcafa93          	andi	s5,s5,-4
        switch (token) {
ffffffffc020061e:	8a56                	mv	s4,s5
ffffffffc0200620:	bf2d                	j	ffffffffc020055a <dtb_init+0x126>
                uint32_t prop_len = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200622:	004a2783          	lw	a5,4(s4)
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200626:	00ca0693          	addi	a3,s4,12
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020062a:	0087d71b          	srliw	a4,a5,0x8
ffffffffc020062e:	01879a9b          	slliw	s5,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200632:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200636:	0107171b          	slliw	a4,a4,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020063a:	0107d79b          	srliw	a5,a5,0x10
ffffffffc020063e:	00caeab3          	or	s5,s5,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200642:	01877733          	and	a4,a4,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200646:	0087979b          	slliw	a5,a5,0x8
ffffffffc020064a:	00eaeab3          	or	s5,s5,a4
ffffffffc020064e:	00fb77b3          	and	a5,s6,a5
ffffffffc0200652:	00faeab3          	or	s5,s5,a5
ffffffffc0200656:	2a81                	sext.w	s5,s5
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200658:	000c9c63          	bnez	s9,ffffffffc0200670 <dtb_init+0x23c>
                struct_ptr = (const uint32_t *)(((uintptr_t)struct_ptr + prop_len + 3) & ~3);
ffffffffc020065c:	1a82                	slli	s5,s5,0x20
ffffffffc020065e:	00368793          	addi	a5,a3,3
ffffffffc0200662:	020ada93          	srli	s5,s5,0x20
ffffffffc0200666:	9abe                	add	s5,s5,a5
ffffffffc0200668:	ffcafa93          	andi	s5,s5,-4
        switch (token) {
ffffffffc020066c:	8a56                	mv	s4,s5
ffffffffc020066e:	b5f5                	j	ffffffffc020055a <dtb_init+0x126>
                uint32_t prop_nameoff = fdt32_to_cpu(*struct_ptr++);
ffffffffc0200670:	008a2783          	lw	a5,8(s4)
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc0200674:	85ca                	mv	a1,s2
ffffffffc0200676:	e436                	sd	a3,8(sp)
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200678:	0087d51b          	srliw	a0,a5,0x8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020067c:	0187d61b          	srliw	a2,a5,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200680:	0187971b          	slliw	a4,a5,0x18
ffffffffc0200684:	0105151b          	slliw	a0,a0,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200688:	0107d79b          	srliw	a5,a5,0x10
ffffffffc020068c:	8f51                	or	a4,a4,a2
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020068e:	01857533          	and	a0,a0,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200692:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200696:	8d59                	or	a0,a0,a4
ffffffffc0200698:	00fb77b3          	and	a5,s6,a5
ffffffffc020069c:	8d5d                	or	a0,a0,a5
                const char *prop_name = strings_base + prop_nameoff;
ffffffffc020069e:	1502                	slli	a0,a0,0x20
ffffffffc02006a0:	9101                	srli	a0,a0,0x20
                if (in_memory_node && strcmp(prop_name, "reg") == 0 && prop_len >= 16) {
ffffffffc02006a2:	9522                	add	a0,a0,s0
ffffffffc02006a4:	396010ef          	jal	ra,ffffffffc0201a3a <strcmp>
ffffffffc02006a8:	66a2                	ld	a3,8(sp)
ffffffffc02006aa:	f94d                	bnez	a0,ffffffffc020065c <dtb_init+0x228>
ffffffffc02006ac:	fb59f8e3          	bgeu	s3,s5,ffffffffc020065c <dtb_init+0x228>
                    *mem_base = fdt64_to_cpu(reg_data[0]);
ffffffffc02006b0:	00ca3783          	ld	a5,12(s4)
                    *mem_size = fdt64_to_cpu(reg_data[1]);
ffffffffc02006b4:	014a3703          	ld	a4,20(s4)
        cprintf("Physical Memory from DTB:\n");
ffffffffc02006b8:	00002517          	auipc	a0,0x2
ffffffffc02006bc:	c5050513          	addi	a0,a0,-944 # ffffffffc0202308 <commands+0xd8>
           fdt32_to_cpu(x >> 32);
ffffffffc02006c0:	4207d613          	srai	a2,a5,0x20
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006c4:	0087d31b          	srliw	t1,a5,0x8
           fdt32_to_cpu(x >> 32);
ffffffffc02006c8:	42075593          	srai	a1,a4,0x20
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006cc:	0187de1b          	srliw	t3,a5,0x18
ffffffffc02006d0:	0186581b          	srliw	a6,a2,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006d4:	0187941b          	slliw	s0,a5,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006d8:	0107d89b          	srliw	a7,a5,0x10
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006dc:	0187d693          	srli	a3,a5,0x18
ffffffffc02006e0:	01861f1b          	slliw	t5,a2,0x18
ffffffffc02006e4:	0087579b          	srliw	a5,a4,0x8
ffffffffc02006e8:	0103131b          	slliw	t1,t1,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc02006ec:	0106561b          	srliw	a2,a2,0x10
ffffffffc02006f0:	010f6f33          	or	t5,t5,a6
ffffffffc02006f4:	0187529b          	srliw	t0,a4,0x18
ffffffffc02006f8:	0185df9b          	srliw	t6,a1,0x18
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc02006fc:	01837333          	and	t1,t1,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200700:	01c46433          	or	s0,s0,t3
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200704:	0186f6b3          	and	a3,a3,s8
ffffffffc0200708:	01859e1b          	slliw	t3,a1,0x18
ffffffffc020070c:	01871e9b          	slliw	t4,a4,0x18
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200710:	0107581b          	srliw	a6,a4,0x10
ffffffffc0200714:	0086161b          	slliw	a2,a2,0x8
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200718:	8361                	srli	a4,a4,0x18
ffffffffc020071a:	0107979b          	slliw	a5,a5,0x10
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020071e:	0105d59b          	srliw	a1,a1,0x10
ffffffffc0200722:	01e6e6b3          	or	a3,a3,t5
ffffffffc0200726:	00cb7633          	and	a2,s6,a2
ffffffffc020072a:	0088181b          	slliw	a6,a6,0x8
ffffffffc020072e:	0085959b          	slliw	a1,a1,0x8
ffffffffc0200732:	00646433          	or	s0,s0,t1
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc0200736:	0187f7b3          	and	a5,a5,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc020073a:	01fe6333          	or	t1,t3,t6
    return ((x & 0xff) << 24) | (((x >> 8) & 0xff) << 16) | 
ffffffffc020073e:	01877c33          	and	s8,a4,s8
           (((x >> 16) & 0xff) << 8) | ((x >> 24) & 0xff);
ffffffffc0200742:	0088989b          	slliw	a7,a7,0x8
ffffffffc0200746:	011b78b3          	and	a7,s6,a7
ffffffffc020074a:	005eeeb3          	or	t4,t4,t0
ffffffffc020074e:	00c6e733          	or	a4,a3,a2
ffffffffc0200752:	006c6c33          	or	s8,s8,t1
ffffffffc0200756:	010b76b3          	and	a3,s6,a6
ffffffffc020075a:	00bb7b33          	and	s6,s6,a1
ffffffffc020075e:	01d7e7b3          	or	a5,a5,t4
ffffffffc0200762:	016c6b33          	or	s6,s8,s6
ffffffffc0200766:	01146433          	or	s0,s0,a7
ffffffffc020076a:	8fd5                	or	a5,a5,a3
           fdt32_to_cpu(x >> 32);
ffffffffc020076c:	1702                	slli	a4,a4,0x20
ffffffffc020076e:	1b02                	slli	s6,s6,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc0200770:	1782                	slli	a5,a5,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc0200772:	9301                	srli	a4,a4,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc0200774:	1402                	slli	s0,s0,0x20
           fdt32_to_cpu(x >> 32);
ffffffffc0200776:	020b5b13          	srli	s6,s6,0x20
    return ((uint64_t)fdt32_to_cpu(x & 0xffffffff) << 32) | 
ffffffffc020077a:	0167eb33          	or	s6,a5,s6
ffffffffc020077e:	8c59                	or	s0,s0,a4
        cprintf("Physical Memory from DTB:\n");
ffffffffc0200780:	95fff0ef          	jal	ra,ffffffffc02000de <cprintf>
        cprintf("  Base: 0x%016lx\n", mem_base);
ffffffffc0200784:	85a2                	mv	a1,s0
ffffffffc0200786:	00002517          	auipc	a0,0x2
ffffffffc020078a:	ba250513          	addi	a0,a0,-1118 # ffffffffc0202328 <commands+0xf8>
ffffffffc020078e:	951ff0ef          	jal	ra,ffffffffc02000de <cprintf>
        cprintf("  Size: 0x%016lx (%ld MB)\n", mem_size, mem_size / (1024 * 1024));
ffffffffc0200792:	014b5613          	srli	a2,s6,0x14
ffffffffc0200796:	85da                	mv	a1,s6
ffffffffc0200798:	00002517          	auipc	a0,0x2
ffffffffc020079c:	ba850513          	addi	a0,a0,-1112 # ffffffffc0202340 <commands+0x110>
ffffffffc02007a0:	93fff0ef          	jal	ra,ffffffffc02000de <cprintf>
        cprintf("  End:  0x%016lx\n", mem_base + mem_size - 1);
ffffffffc02007a4:	008b05b3          	add	a1,s6,s0
ffffffffc02007a8:	15fd                	addi	a1,a1,-1
ffffffffc02007aa:	00002517          	auipc	a0,0x2
ffffffffc02007ae:	bb650513          	addi	a0,a0,-1098 # ffffffffc0202360 <commands+0x130>
ffffffffc02007b2:	92dff0ef          	jal	ra,ffffffffc02000de <cprintf>
    cprintf("DTB init completed\n");
ffffffffc02007b6:	00002517          	auipc	a0,0x2
ffffffffc02007ba:	bfa50513          	addi	a0,a0,-1030 # ffffffffc02023b0 <commands+0x180>
        memory_base = mem_base;
ffffffffc02007be:	00007797          	auipc	a5,0x7
ffffffffc02007c2:	c887b523          	sd	s0,-886(a5) # ffffffffc0207448 <memory_base>
        memory_size = mem_size;
ffffffffc02007c6:	00007797          	auipc	a5,0x7
ffffffffc02007ca:	c967b523          	sd	s6,-886(a5) # ffffffffc0207450 <memory_size>
    cprintf("DTB init completed\n");
ffffffffc02007ce:	b3f5                	j	ffffffffc02005ba <dtb_init+0x186>

ffffffffc02007d0 <get_memory_base>:

uint64_t get_memory_base(void) {
    return memory_base;
}
ffffffffc02007d0:	00007517          	auipc	a0,0x7
ffffffffc02007d4:	c7853503          	ld	a0,-904(a0) # ffffffffc0207448 <memory_base>
ffffffffc02007d8:	8082                	ret

ffffffffc02007da <get_memory_size>:

uint64_t get_memory_size(void) {
    return memory_size;
}
ffffffffc02007da:	00007517          	auipc	a0,0x7
ffffffffc02007de:	c7653503          	ld	a0,-906(a0) # ffffffffc0207450 <memory_size>
ffffffffc02007e2:	8082                	ret

ffffffffc02007e4 <clock_init>:

/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void clock_init(void) {
ffffffffc02007e4:	1141                	addi	sp,sp,-16
ffffffffc02007e6:	e406                	sd	ra,8(sp)
    // enable timer interrupt in sie
    set_csr(sie, MIP_STIP);
ffffffffc02007e8:	02000793          	li	a5,32
ffffffffc02007ec:	1047a7f3          	csrrs	a5,sie,a5
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc02007f0:	c0102573          	rdtime	a0
    ticks = 0;

    cprintf("++ setup timer interrupts\n");
}

void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc02007f4:	67e1                	lui	a5,0x18
ffffffffc02007f6:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc02007fa:	953e                	add	a0,a0,a5
ffffffffc02007fc:	766010ef          	jal	ra,ffffffffc0201f62 <sbi_set_timer>
}
ffffffffc0200800:	60a2                	ld	ra,8(sp)
    ticks = 0;
ffffffffc0200802:	00007797          	auipc	a5,0x7
ffffffffc0200806:	c407bb23          	sd	zero,-938(a5) # ffffffffc0207458 <ticks>
    cprintf("++ setup timer interrupts\n");
ffffffffc020080a:	00002517          	auipc	a0,0x2
ffffffffc020080e:	bbe50513          	addi	a0,a0,-1090 # ffffffffc02023c8 <commands+0x198>
}
ffffffffc0200812:	0141                	addi	sp,sp,16
    cprintf("++ setup timer interrupts\n");
ffffffffc0200814:	8cbff06f          	j	ffffffffc02000de <cprintf>

ffffffffc0200818 <clock_set_next_event>:
    __asm__ __volatile__("rdtime %0" : "=r"(n));
ffffffffc0200818:	c0102573          	rdtime	a0
void clock_set_next_event(void) { sbi_set_timer(get_cycles() + timebase); }
ffffffffc020081c:	67e1                	lui	a5,0x18
ffffffffc020081e:	6a078793          	addi	a5,a5,1696 # 186a0 <kern_entry-0xffffffffc01e7960>
ffffffffc0200822:	953e                	add	a0,a0,a5
ffffffffc0200824:	73e0106f          	j	ffffffffc0201f62 <sbi_set_timer>

ffffffffc0200828 <cons_init>:

/* serial_intr - try to feed input characters from serial port */
void serial_intr(void) {}

/* cons_init - initializes the console devices */
void cons_init(void) {}
ffffffffc0200828:	8082                	ret

ffffffffc020082a <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void cons_putc(int c) { sbi_console_putchar((unsigned char)c); }
ffffffffc020082a:	0ff57513          	zext.b	a0,a0
ffffffffc020082e:	71a0106f          	j	ffffffffc0201f48 <sbi_console_putchar>

ffffffffc0200832 <cons_getc>:
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int cons_getc(void) {
    int c = 0;
    c = sbi_console_getchar();
ffffffffc0200832:	74a0106f          	j	ffffffffc0201f7c <sbi_console_getchar>

ffffffffc0200836 <intr_enable>:
#include <intr.h>
#include <riscv.h>

/* intr_enable - enable irq interrupt */
void intr_enable(void) { set_csr(sstatus, SSTATUS_SIE); }
ffffffffc0200836:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc020083a:	8082                	ret

ffffffffc020083c <intr_disable>:

/* intr_disable - disable irq interrupt */
void intr_disable(void) { clear_csr(sstatus, SSTATUS_SIE); }
ffffffffc020083c:	100177f3          	csrrci	a5,sstatus,2
ffffffffc0200840:	8082                	ret

ffffffffc0200842 <idt_init>:
     */

    extern void __alltraps(void);
    /* Set sup0 scratch register to 0, indicating to exception vector
       that we are presently executing in the kernel */
    write_csr(sscratch, 0);
ffffffffc0200842:	14005073          	csrwi	sscratch,0
    /* Set the exception vector address */
    write_csr(stvec, &__alltraps);
ffffffffc0200846:	00000797          	auipc	a5,0x0
ffffffffc020084a:	39a78793          	addi	a5,a5,922 # ffffffffc0200be0 <__alltraps>
ffffffffc020084e:	10579073          	csrw	stvec,a5
}
ffffffffc0200852:	8082                	ret

ffffffffc0200854 <print_regs>:
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
    cprintf("  cause    0x%08x\n", tf->cause);
}

void print_regs(struct pushregs *gpr) {
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200854:	610c                	ld	a1,0(a0)
void print_regs(struct pushregs *gpr) {
ffffffffc0200856:	1141                	addi	sp,sp,-16
ffffffffc0200858:	e022                	sd	s0,0(sp)
ffffffffc020085a:	842a                	mv	s0,a0
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc020085c:	00002517          	auipc	a0,0x2
ffffffffc0200860:	b8c50513          	addi	a0,a0,-1140 # ffffffffc02023e8 <commands+0x1b8>
void print_regs(struct pushregs *gpr) {
ffffffffc0200864:	e406                	sd	ra,8(sp)
    cprintf("  zero     0x%08x\n", gpr->zero);
ffffffffc0200866:	879ff0ef          	jal	ra,ffffffffc02000de <cprintf>
    cprintf("  ra       0x%08x\n", gpr->ra);
ffffffffc020086a:	640c                	ld	a1,8(s0)
ffffffffc020086c:	00002517          	auipc	a0,0x2
ffffffffc0200870:	b9450513          	addi	a0,a0,-1132 # ffffffffc0202400 <commands+0x1d0>
ffffffffc0200874:	86bff0ef          	jal	ra,ffffffffc02000de <cprintf>
    cprintf("  sp       0x%08x\n", gpr->sp);
ffffffffc0200878:	680c                	ld	a1,16(s0)
ffffffffc020087a:	00002517          	auipc	a0,0x2
ffffffffc020087e:	b9e50513          	addi	a0,a0,-1122 # ffffffffc0202418 <commands+0x1e8>
ffffffffc0200882:	85dff0ef          	jal	ra,ffffffffc02000de <cprintf>
    cprintf("  gp       0x%08x\n", gpr->gp);
ffffffffc0200886:	6c0c                	ld	a1,24(s0)
ffffffffc0200888:	00002517          	auipc	a0,0x2
ffffffffc020088c:	ba850513          	addi	a0,a0,-1112 # ffffffffc0202430 <commands+0x200>
ffffffffc0200890:	84fff0ef          	jal	ra,ffffffffc02000de <cprintf>
    cprintf("  tp       0x%08x\n", gpr->tp);
ffffffffc0200894:	700c                	ld	a1,32(s0)
ffffffffc0200896:	00002517          	auipc	a0,0x2
ffffffffc020089a:	bb250513          	addi	a0,a0,-1102 # ffffffffc0202448 <commands+0x218>
ffffffffc020089e:	841ff0ef          	jal	ra,ffffffffc02000de <cprintf>
    cprintf("  t0       0x%08x\n", gpr->t0);
ffffffffc02008a2:	740c                	ld	a1,40(s0)
ffffffffc02008a4:	00002517          	auipc	a0,0x2
ffffffffc02008a8:	bbc50513          	addi	a0,a0,-1092 # ffffffffc0202460 <commands+0x230>
ffffffffc02008ac:	833ff0ef          	jal	ra,ffffffffc02000de <cprintf>
    cprintf("  t1       0x%08x\n", gpr->t1);
ffffffffc02008b0:	780c                	ld	a1,48(s0)
ffffffffc02008b2:	00002517          	auipc	a0,0x2
ffffffffc02008b6:	bc650513          	addi	a0,a0,-1082 # ffffffffc0202478 <commands+0x248>
ffffffffc02008ba:	825ff0ef          	jal	ra,ffffffffc02000de <cprintf>
    cprintf("  t2       0x%08x\n", gpr->t2);
ffffffffc02008be:	7c0c                	ld	a1,56(s0)
ffffffffc02008c0:	00002517          	auipc	a0,0x2
ffffffffc02008c4:	bd050513          	addi	a0,a0,-1072 # ffffffffc0202490 <commands+0x260>
ffffffffc02008c8:	817ff0ef          	jal	ra,ffffffffc02000de <cprintf>
    cprintf("  s0       0x%08x\n", gpr->s0);
ffffffffc02008cc:	602c                	ld	a1,64(s0)
ffffffffc02008ce:	00002517          	auipc	a0,0x2
ffffffffc02008d2:	bda50513          	addi	a0,a0,-1062 # ffffffffc02024a8 <commands+0x278>
ffffffffc02008d6:	809ff0ef          	jal	ra,ffffffffc02000de <cprintf>
    cprintf("  s1       0x%08x\n", gpr->s1);
ffffffffc02008da:	642c                	ld	a1,72(s0)
ffffffffc02008dc:	00002517          	auipc	a0,0x2
ffffffffc02008e0:	be450513          	addi	a0,a0,-1052 # ffffffffc02024c0 <commands+0x290>
ffffffffc02008e4:	ffaff0ef          	jal	ra,ffffffffc02000de <cprintf>
    cprintf("  a0       0x%08x\n", gpr->a0);
ffffffffc02008e8:	682c                	ld	a1,80(s0)
ffffffffc02008ea:	00002517          	auipc	a0,0x2
ffffffffc02008ee:	bee50513          	addi	a0,a0,-1042 # ffffffffc02024d8 <commands+0x2a8>
ffffffffc02008f2:	fecff0ef          	jal	ra,ffffffffc02000de <cprintf>
    cprintf("  a1       0x%08x\n", gpr->a1);
ffffffffc02008f6:	6c2c                	ld	a1,88(s0)
ffffffffc02008f8:	00002517          	auipc	a0,0x2
ffffffffc02008fc:	bf850513          	addi	a0,a0,-1032 # ffffffffc02024f0 <commands+0x2c0>
ffffffffc0200900:	fdeff0ef          	jal	ra,ffffffffc02000de <cprintf>
    cprintf("  a2       0x%08x\n", gpr->a2);
ffffffffc0200904:	702c                	ld	a1,96(s0)
ffffffffc0200906:	00002517          	auipc	a0,0x2
ffffffffc020090a:	c0250513          	addi	a0,a0,-1022 # ffffffffc0202508 <commands+0x2d8>
ffffffffc020090e:	fd0ff0ef          	jal	ra,ffffffffc02000de <cprintf>
    cprintf("  a3       0x%08x\n", gpr->a3);
ffffffffc0200912:	742c                	ld	a1,104(s0)
ffffffffc0200914:	00002517          	auipc	a0,0x2
ffffffffc0200918:	c0c50513          	addi	a0,a0,-1012 # ffffffffc0202520 <commands+0x2f0>
ffffffffc020091c:	fc2ff0ef          	jal	ra,ffffffffc02000de <cprintf>
    cprintf("  a4       0x%08x\n", gpr->a4);
ffffffffc0200920:	782c                	ld	a1,112(s0)
ffffffffc0200922:	00002517          	auipc	a0,0x2
ffffffffc0200926:	c1650513          	addi	a0,a0,-1002 # ffffffffc0202538 <commands+0x308>
ffffffffc020092a:	fb4ff0ef          	jal	ra,ffffffffc02000de <cprintf>
    cprintf("  a5       0x%08x\n", gpr->a5);
ffffffffc020092e:	7c2c                	ld	a1,120(s0)
ffffffffc0200930:	00002517          	auipc	a0,0x2
ffffffffc0200934:	c2050513          	addi	a0,a0,-992 # ffffffffc0202550 <commands+0x320>
ffffffffc0200938:	fa6ff0ef          	jal	ra,ffffffffc02000de <cprintf>
    cprintf("  a6       0x%08x\n", gpr->a6);
ffffffffc020093c:	604c                	ld	a1,128(s0)
ffffffffc020093e:	00002517          	auipc	a0,0x2
ffffffffc0200942:	c2a50513          	addi	a0,a0,-982 # ffffffffc0202568 <commands+0x338>
ffffffffc0200946:	f98ff0ef          	jal	ra,ffffffffc02000de <cprintf>
    cprintf("  a7       0x%08x\n", gpr->a7);
ffffffffc020094a:	644c                	ld	a1,136(s0)
ffffffffc020094c:	00002517          	auipc	a0,0x2
ffffffffc0200950:	c3450513          	addi	a0,a0,-972 # ffffffffc0202580 <commands+0x350>
ffffffffc0200954:	f8aff0ef          	jal	ra,ffffffffc02000de <cprintf>
    cprintf("  s2       0x%08x\n", gpr->s2);
ffffffffc0200958:	684c                	ld	a1,144(s0)
ffffffffc020095a:	00002517          	auipc	a0,0x2
ffffffffc020095e:	c3e50513          	addi	a0,a0,-962 # ffffffffc0202598 <commands+0x368>
ffffffffc0200962:	f7cff0ef          	jal	ra,ffffffffc02000de <cprintf>
    cprintf("  s3       0x%08x\n", gpr->s3);
ffffffffc0200966:	6c4c                	ld	a1,152(s0)
ffffffffc0200968:	00002517          	auipc	a0,0x2
ffffffffc020096c:	c4850513          	addi	a0,a0,-952 # ffffffffc02025b0 <commands+0x380>
ffffffffc0200970:	f6eff0ef          	jal	ra,ffffffffc02000de <cprintf>
    cprintf("  s4       0x%08x\n", gpr->s4);
ffffffffc0200974:	704c                	ld	a1,160(s0)
ffffffffc0200976:	00002517          	auipc	a0,0x2
ffffffffc020097a:	c5250513          	addi	a0,a0,-942 # ffffffffc02025c8 <commands+0x398>
ffffffffc020097e:	f60ff0ef          	jal	ra,ffffffffc02000de <cprintf>
    cprintf("  s5       0x%08x\n", gpr->s5);
ffffffffc0200982:	744c                	ld	a1,168(s0)
ffffffffc0200984:	00002517          	auipc	a0,0x2
ffffffffc0200988:	c5c50513          	addi	a0,a0,-932 # ffffffffc02025e0 <commands+0x3b0>
ffffffffc020098c:	f52ff0ef          	jal	ra,ffffffffc02000de <cprintf>
    cprintf("  s6       0x%08x\n", gpr->s6);
ffffffffc0200990:	784c                	ld	a1,176(s0)
ffffffffc0200992:	00002517          	auipc	a0,0x2
ffffffffc0200996:	c6650513          	addi	a0,a0,-922 # ffffffffc02025f8 <commands+0x3c8>
ffffffffc020099a:	f44ff0ef          	jal	ra,ffffffffc02000de <cprintf>
    cprintf("  s7       0x%08x\n", gpr->s7);
ffffffffc020099e:	7c4c                	ld	a1,184(s0)
ffffffffc02009a0:	00002517          	auipc	a0,0x2
ffffffffc02009a4:	c7050513          	addi	a0,a0,-912 # ffffffffc0202610 <commands+0x3e0>
ffffffffc02009a8:	f36ff0ef          	jal	ra,ffffffffc02000de <cprintf>
    cprintf("  s8       0x%08x\n", gpr->s8);
ffffffffc02009ac:	606c                	ld	a1,192(s0)
ffffffffc02009ae:	00002517          	auipc	a0,0x2
ffffffffc02009b2:	c7a50513          	addi	a0,a0,-902 # ffffffffc0202628 <commands+0x3f8>
ffffffffc02009b6:	f28ff0ef          	jal	ra,ffffffffc02000de <cprintf>
    cprintf("  s9       0x%08x\n", gpr->s9);
ffffffffc02009ba:	646c                	ld	a1,200(s0)
ffffffffc02009bc:	00002517          	auipc	a0,0x2
ffffffffc02009c0:	c8450513          	addi	a0,a0,-892 # ffffffffc0202640 <commands+0x410>
ffffffffc02009c4:	f1aff0ef          	jal	ra,ffffffffc02000de <cprintf>
    cprintf("  s10      0x%08x\n", gpr->s10);
ffffffffc02009c8:	686c                	ld	a1,208(s0)
ffffffffc02009ca:	00002517          	auipc	a0,0x2
ffffffffc02009ce:	c8e50513          	addi	a0,a0,-882 # ffffffffc0202658 <commands+0x428>
ffffffffc02009d2:	f0cff0ef          	jal	ra,ffffffffc02000de <cprintf>
    cprintf("  s11      0x%08x\n", gpr->s11);
ffffffffc02009d6:	6c6c                	ld	a1,216(s0)
ffffffffc02009d8:	00002517          	auipc	a0,0x2
ffffffffc02009dc:	c9850513          	addi	a0,a0,-872 # ffffffffc0202670 <commands+0x440>
ffffffffc02009e0:	efeff0ef          	jal	ra,ffffffffc02000de <cprintf>
    cprintf("  t3       0x%08x\n", gpr->t3);
ffffffffc02009e4:	706c                	ld	a1,224(s0)
ffffffffc02009e6:	00002517          	auipc	a0,0x2
ffffffffc02009ea:	ca250513          	addi	a0,a0,-862 # ffffffffc0202688 <commands+0x458>
ffffffffc02009ee:	ef0ff0ef          	jal	ra,ffffffffc02000de <cprintf>
    cprintf("  t4       0x%08x\n", gpr->t4);
ffffffffc02009f2:	746c                	ld	a1,232(s0)
ffffffffc02009f4:	00002517          	auipc	a0,0x2
ffffffffc02009f8:	cac50513          	addi	a0,a0,-852 # ffffffffc02026a0 <commands+0x470>
ffffffffc02009fc:	ee2ff0ef          	jal	ra,ffffffffc02000de <cprintf>
    cprintf("  t5       0x%08x\n", gpr->t5);
ffffffffc0200a00:	786c                	ld	a1,240(s0)
ffffffffc0200a02:	00002517          	auipc	a0,0x2
ffffffffc0200a06:	cb650513          	addi	a0,a0,-842 # ffffffffc02026b8 <commands+0x488>
ffffffffc0200a0a:	ed4ff0ef          	jal	ra,ffffffffc02000de <cprintf>
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200a0e:	7c6c                	ld	a1,248(s0)
}
ffffffffc0200a10:	6402                	ld	s0,0(sp)
ffffffffc0200a12:	60a2                	ld	ra,8(sp)
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200a14:	00002517          	auipc	a0,0x2
ffffffffc0200a18:	cbc50513          	addi	a0,a0,-836 # ffffffffc02026d0 <commands+0x4a0>
}
ffffffffc0200a1c:	0141                	addi	sp,sp,16
    cprintf("  t6       0x%08x\n", gpr->t6);
ffffffffc0200a1e:	ec0ff06f          	j	ffffffffc02000de <cprintf>

ffffffffc0200a22 <print_trapframe>:
void print_trapframe(struct trapframe *tf) {
ffffffffc0200a22:	1141                	addi	sp,sp,-16
ffffffffc0200a24:	e022                	sd	s0,0(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200a26:	85aa                	mv	a1,a0
void print_trapframe(struct trapframe *tf) {
ffffffffc0200a28:	842a                	mv	s0,a0
    cprintf("trapframe at %p\n", tf);
ffffffffc0200a2a:	00002517          	auipc	a0,0x2
ffffffffc0200a2e:	cbe50513          	addi	a0,a0,-834 # ffffffffc02026e8 <commands+0x4b8>
void print_trapframe(struct trapframe *tf) {
ffffffffc0200a32:	e406                	sd	ra,8(sp)
    cprintf("trapframe at %p\n", tf);
ffffffffc0200a34:	eaaff0ef          	jal	ra,ffffffffc02000de <cprintf>
    print_regs(&tf->gpr);
ffffffffc0200a38:	8522                	mv	a0,s0
ffffffffc0200a3a:	e1bff0ef          	jal	ra,ffffffffc0200854 <print_regs>
    cprintf("  status   0x%08x\n", tf->status);
ffffffffc0200a3e:	10043583          	ld	a1,256(s0)
ffffffffc0200a42:	00002517          	auipc	a0,0x2
ffffffffc0200a46:	cbe50513          	addi	a0,a0,-834 # ffffffffc0202700 <commands+0x4d0>
ffffffffc0200a4a:	e94ff0ef          	jal	ra,ffffffffc02000de <cprintf>
    cprintf("  epc      0x%08x\n", tf->epc);
ffffffffc0200a4e:	10843583          	ld	a1,264(s0)
ffffffffc0200a52:	00002517          	auipc	a0,0x2
ffffffffc0200a56:	cc650513          	addi	a0,a0,-826 # ffffffffc0202718 <commands+0x4e8>
ffffffffc0200a5a:	e84ff0ef          	jal	ra,ffffffffc02000de <cprintf>
    cprintf("  badvaddr 0x%08x\n", tf->badvaddr);
ffffffffc0200a5e:	11043583          	ld	a1,272(s0)
ffffffffc0200a62:	00002517          	auipc	a0,0x2
ffffffffc0200a66:	cce50513          	addi	a0,a0,-818 # ffffffffc0202730 <commands+0x500>
ffffffffc0200a6a:	e74ff0ef          	jal	ra,ffffffffc02000de <cprintf>
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200a6e:	11843583          	ld	a1,280(s0)
}
ffffffffc0200a72:	6402                	ld	s0,0(sp)
ffffffffc0200a74:	60a2                	ld	ra,8(sp)
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200a76:	00002517          	auipc	a0,0x2
ffffffffc0200a7a:	cd250513          	addi	a0,a0,-814 # ffffffffc0202748 <commands+0x518>
}
ffffffffc0200a7e:	0141                	addi	sp,sp,16
    cprintf("  cause    0x%08x\n", tf->cause);
ffffffffc0200a80:	e5eff06f          	j	ffffffffc02000de <cprintf>

ffffffffc0200a84 <interrupt_handler>:

void interrupt_handler(struct trapframe *tf) {
    intptr_t cause = (tf->cause << 1) >> 1;
ffffffffc0200a84:	11853783          	ld	a5,280(a0)
ffffffffc0200a88:	472d                	li	a4,11
ffffffffc0200a8a:	0786                	slli	a5,a5,0x1
ffffffffc0200a8c:	8385                	srli	a5,a5,0x1
ffffffffc0200a8e:	08f76963          	bltu	a4,a5,ffffffffc0200b20 <interrupt_handler+0x9c>
ffffffffc0200a92:	00002717          	auipc	a4,0x2
ffffffffc0200a96:	d9670713          	addi	a4,a4,-618 # ffffffffc0202828 <commands+0x5f8>
ffffffffc0200a9a:	078a                	slli	a5,a5,0x2
ffffffffc0200a9c:	97ba                	add	a5,a5,a4
ffffffffc0200a9e:	439c                	lw	a5,0(a5)
ffffffffc0200aa0:	97ba                	add	a5,a5,a4
ffffffffc0200aa2:	8782                	jr	a5
            break;
        case IRQ_H_SOFT:
            cprintf("Hypervisor software interrupt\n");
            break;
        case IRQ_M_SOFT:
            cprintf("Machine software interrupt\n");
ffffffffc0200aa4:	00002517          	auipc	a0,0x2
ffffffffc0200aa8:	d1c50513          	addi	a0,a0,-740 # ffffffffc02027c0 <commands+0x590>
ffffffffc0200aac:	e32ff06f          	j	ffffffffc02000de <cprintf>
            cprintf("Hypervisor software interrupt\n");
ffffffffc0200ab0:	00002517          	auipc	a0,0x2
ffffffffc0200ab4:	cf050513          	addi	a0,a0,-784 # ffffffffc02027a0 <commands+0x570>
ffffffffc0200ab8:	e26ff06f          	j	ffffffffc02000de <cprintf>
            cprintf("User software interrupt\n");
ffffffffc0200abc:	00002517          	auipc	a0,0x2
ffffffffc0200ac0:	ca450513          	addi	a0,a0,-860 # ffffffffc0202760 <commands+0x530>
ffffffffc0200ac4:	e1aff06f          	j	ffffffffc02000de <cprintf>
            break;
        case IRQ_U_TIMER:
            cprintf("User Timer interrupt\n");
ffffffffc0200ac8:	00002517          	auipc	a0,0x2
ffffffffc0200acc:	d1850513          	addi	a0,a0,-744 # ffffffffc02027e0 <commands+0x5b0>
ffffffffc0200ad0:	e0eff06f          	j	ffffffffc02000de <cprintf>
void interrupt_handler(struct trapframe *tf) {
ffffffffc0200ad4:	1141                	addi	sp,sp,-16
ffffffffc0200ad6:	e406                	sd	ra,8(sp)
            /*(1)设置下次时钟中断- clock_set_next_event()
             *(2)计数器（ticks）加一
             *(3)当计数器加到100的时候，我们会输出一个`100ticks`表示我们触发了100次时钟中断，同时打印次数（num）加一
            * (4)判断打印次数，当打印次数为10时，调用<sbi.h>中的关机函数关机
            */
	    clock_set_next_event();
ffffffffc0200ad8:	d41ff0ef          	jal	ra,ffffffffc0200818 <clock_set_next_event>

            static int ticks = 0;
            static int num = 0;

            ticks++;
ffffffffc0200adc:	00007697          	auipc	a3,0x7
ffffffffc0200ae0:	98868693          	addi	a3,a3,-1656 # ffffffffc0207464 <ticks.1>
ffffffffc0200ae4:	429c                	lw	a5,0(a3)

            if (ticks % TICK_NUM == 0) {
ffffffffc0200ae6:	06400713          	li	a4,100
            ticks++;
ffffffffc0200aea:	2785                	addiw	a5,a5,1
            if (ticks % TICK_NUM == 0) {
ffffffffc0200aec:	02e7e73b          	remw	a4,a5,a4
            ticks++;
ffffffffc0200af0:	c29c                	sw	a5,0(a3)
            if (ticks % TICK_NUM == 0) {
ffffffffc0200af2:	cb05                	beqz	a4,ffffffffc0200b22 <interrupt_handler+0x9e>
                print_ticks();
                num++;
            }

            if (num >= 10) {
ffffffffc0200af4:	00007717          	auipc	a4,0x7
ffffffffc0200af8:	96c72703          	lw	a4,-1684(a4) # ffffffffc0207460 <num.0>
ffffffffc0200afc:	47a5                	li	a5,9
ffffffffc0200afe:	04e7c363          	blt	a5,a4,ffffffffc0200b44 <interrupt_handler+0xc0>
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
ffffffffc0200b02:	60a2                	ld	ra,8(sp)
ffffffffc0200b04:	0141                	addi	sp,sp,16
ffffffffc0200b06:	8082                	ret
            cprintf("Supervisor external interrupt\n");
ffffffffc0200b08:	00002517          	auipc	a0,0x2
ffffffffc0200b0c:	d0050513          	addi	a0,a0,-768 # ffffffffc0202808 <commands+0x5d8>
ffffffffc0200b10:	dceff06f          	j	ffffffffc02000de <cprintf>
            cprintf("Supervisor software interrupt\n");
ffffffffc0200b14:	00002517          	auipc	a0,0x2
ffffffffc0200b18:	c6c50513          	addi	a0,a0,-916 # ffffffffc0202780 <commands+0x550>
ffffffffc0200b1c:	dc2ff06f          	j	ffffffffc02000de <cprintf>
            print_trapframe(tf);
ffffffffc0200b20:	b709                	j	ffffffffc0200a22 <print_trapframe>
    cprintf("%d ticks\n", TICK_NUM);
ffffffffc0200b22:	06400593          	li	a1,100
ffffffffc0200b26:	00002517          	auipc	a0,0x2
ffffffffc0200b2a:	cd250513          	addi	a0,a0,-814 # ffffffffc02027f8 <commands+0x5c8>
ffffffffc0200b2e:	db0ff0ef          	jal	ra,ffffffffc02000de <cprintf>
                num++;
ffffffffc0200b32:	00007697          	auipc	a3,0x7
ffffffffc0200b36:	92e68693          	addi	a3,a3,-1746 # ffffffffc0207460 <num.0>
ffffffffc0200b3a:	429c                	lw	a5,0(a3)
ffffffffc0200b3c:	0017871b          	addiw	a4,a5,1
ffffffffc0200b40:	c298                	sw	a4,0(a3)
ffffffffc0200b42:	bf6d                	j	ffffffffc0200afc <interrupt_handler+0x78>
}
ffffffffc0200b44:	60a2                	ld	ra,8(sp)
ffffffffc0200b46:	0141                	addi	sp,sp,16
                sbi_shutdown();
ffffffffc0200b48:	4500106f          	j	ffffffffc0201f98 <sbi_shutdown>

ffffffffc0200b4c <exception_handler>:

void exception_handler(struct trapframe *tf) {
    switch (tf->cause) {
ffffffffc0200b4c:	11853783          	ld	a5,280(a0)
void exception_handler(struct trapframe *tf) {
ffffffffc0200b50:	1141                	addi	sp,sp,-16
ffffffffc0200b52:	e022                	sd	s0,0(sp)
ffffffffc0200b54:	e406                	sd	ra,8(sp)
    switch (tf->cause) {
ffffffffc0200b56:	470d                	li	a4,3
void exception_handler(struct trapframe *tf) {
ffffffffc0200b58:	842a                	mv	s0,a0
    switch (tf->cause) {
ffffffffc0200b5a:	04e78663          	beq	a5,a4,ffffffffc0200ba6 <exception_handler+0x5a>
ffffffffc0200b5e:	02f76c63          	bltu	a4,a5,ffffffffc0200b96 <exception_handler+0x4a>
ffffffffc0200b62:	4709                	li	a4,2
ffffffffc0200b64:	02e79563          	bne	a5,a4,ffffffffc0200b8e <exception_handler+0x42>
             /* LAB3 CHALLENGE3   YOUR CODE :  */
            /*(1)输出指令异常类型（ Illegal instruction）
             *(2)输出异常指令地址
             *(3)更新 tf->epc寄存器
            */
            cprintf("Exception type: Illegal instruction\n");
ffffffffc0200b68:	00002517          	auipc	a0,0x2
ffffffffc0200b6c:	cf050513          	addi	a0,a0,-784 # ffffffffc0202858 <commands+0x628>
ffffffffc0200b70:	d6eff0ef          	jal	ra,ffffffffc02000de <cprintf>
    	    cprintf("Illegal instruction caught at 0x%08x\n", tf->epc);
ffffffffc0200b74:	10843583          	ld	a1,264(s0)
ffffffffc0200b78:	00002517          	auipc	a0,0x2
ffffffffc0200b7c:	d0850513          	addi	a0,a0,-760 # ffffffffc0202880 <commands+0x650>
ffffffffc0200b80:	d5eff0ef          	jal	ra,ffffffffc02000de <cprintf>
            tf->epc += 4;
ffffffffc0200b84:	10843783          	ld	a5,264(s0)
ffffffffc0200b88:	0791                	addi	a5,a5,4
ffffffffc0200b8a:	10f43423          	sd	a5,264(s0)
            break;
        default:
            print_trapframe(tf);
            break;
    }
}
ffffffffc0200b8e:	60a2                	ld	ra,8(sp)
ffffffffc0200b90:	6402                	ld	s0,0(sp)
ffffffffc0200b92:	0141                	addi	sp,sp,16
ffffffffc0200b94:	8082                	ret
    switch (tf->cause) {
ffffffffc0200b96:	17f1                	addi	a5,a5,-4
ffffffffc0200b98:	471d                	li	a4,7
ffffffffc0200b9a:	fef77ae3          	bgeu	a4,a5,ffffffffc0200b8e <exception_handler+0x42>
}
ffffffffc0200b9e:	6402                	ld	s0,0(sp)
ffffffffc0200ba0:	60a2                	ld	ra,8(sp)
ffffffffc0200ba2:	0141                	addi	sp,sp,16
            print_trapframe(tf);
ffffffffc0200ba4:	bdbd                	j	ffffffffc0200a22 <print_trapframe>
	    cprintf("Exception type: breakpoint\n");
ffffffffc0200ba6:	00002517          	auipc	a0,0x2
ffffffffc0200baa:	d0250513          	addi	a0,a0,-766 # ffffffffc02028a8 <commands+0x678>
ffffffffc0200bae:	d30ff0ef          	jal	ra,ffffffffc02000de <cprintf>
            cprintf("ebreak caught at 0x%08x\n", tf->epc);
ffffffffc0200bb2:	10843583          	ld	a1,264(s0)
ffffffffc0200bb6:	00002517          	auipc	a0,0x2
ffffffffc0200bba:	d1250513          	addi	a0,a0,-750 # ffffffffc02028c8 <commands+0x698>
ffffffffc0200bbe:	d20ff0ef          	jal	ra,ffffffffc02000de <cprintf>
            tf->epc += 2;
ffffffffc0200bc2:	10843783          	ld	a5,264(s0)
}
ffffffffc0200bc6:	60a2                	ld	ra,8(sp)
            tf->epc += 2;
ffffffffc0200bc8:	0789                	addi	a5,a5,2
ffffffffc0200bca:	10f43423          	sd	a5,264(s0)
}
ffffffffc0200bce:	6402                	ld	s0,0(sp)
ffffffffc0200bd0:	0141                	addi	sp,sp,16
ffffffffc0200bd2:	8082                	ret

ffffffffc0200bd4 <trap>:

static inline void trap_dispatch(struct trapframe *tf) {
    if ((intptr_t)tf->cause < 0) {
ffffffffc0200bd4:	11853783          	ld	a5,280(a0)
ffffffffc0200bd8:	0007c363          	bltz	a5,ffffffffc0200bde <trap+0xa>
        // interrupts
        interrupt_handler(tf);
    } else {
        // exceptions
        exception_handler(tf);
ffffffffc0200bdc:	bf85                	j	ffffffffc0200b4c <exception_handler>
        interrupt_handler(tf);
ffffffffc0200bde:	b55d                	j	ffffffffc0200a84 <interrupt_handler>

ffffffffc0200be0 <__alltraps>:
    .endm

    .globl __alltraps
    .align(2)
__alltraps:
    SAVE_ALL
ffffffffc0200be0:	14011073          	csrw	sscratch,sp
ffffffffc0200be4:	712d                	addi	sp,sp,-288
ffffffffc0200be6:	e002                	sd	zero,0(sp)
ffffffffc0200be8:	e406                	sd	ra,8(sp)
ffffffffc0200bea:	ec0e                	sd	gp,24(sp)
ffffffffc0200bec:	f012                	sd	tp,32(sp)
ffffffffc0200bee:	f416                	sd	t0,40(sp)
ffffffffc0200bf0:	f81a                	sd	t1,48(sp)
ffffffffc0200bf2:	fc1e                	sd	t2,56(sp)
ffffffffc0200bf4:	e0a2                	sd	s0,64(sp)
ffffffffc0200bf6:	e4a6                	sd	s1,72(sp)
ffffffffc0200bf8:	e8aa                	sd	a0,80(sp)
ffffffffc0200bfa:	ecae                	sd	a1,88(sp)
ffffffffc0200bfc:	f0b2                	sd	a2,96(sp)
ffffffffc0200bfe:	f4b6                	sd	a3,104(sp)
ffffffffc0200c00:	f8ba                	sd	a4,112(sp)
ffffffffc0200c02:	fcbe                	sd	a5,120(sp)
ffffffffc0200c04:	e142                	sd	a6,128(sp)
ffffffffc0200c06:	e546                	sd	a7,136(sp)
ffffffffc0200c08:	e94a                	sd	s2,144(sp)
ffffffffc0200c0a:	ed4e                	sd	s3,152(sp)
ffffffffc0200c0c:	f152                	sd	s4,160(sp)
ffffffffc0200c0e:	f556                	sd	s5,168(sp)
ffffffffc0200c10:	f95a                	sd	s6,176(sp)
ffffffffc0200c12:	fd5e                	sd	s7,184(sp)
ffffffffc0200c14:	e1e2                	sd	s8,192(sp)
ffffffffc0200c16:	e5e6                	sd	s9,200(sp)
ffffffffc0200c18:	e9ea                	sd	s10,208(sp)
ffffffffc0200c1a:	edee                	sd	s11,216(sp)
ffffffffc0200c1c:	f1f2                	sd	t3,224(sp)
ffffffffc0200c1e:	f5f6                	sd	t4,232(sp)
ffffffffc0200c20:	f9fa                	sd	t5,240(sp)
ffffffffc0200c22:	fdfe                	sd	t6,248(sp)
ffffffffc0200c24:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0200c28:	100024f3          	csrr	s1,sstatus
ffffffffc0200c2c:	14102973          	csrr	s2,sepc
ffffffffc0200c30:	143029f3          	csrr	s3,stval
ffffffffc0200c34:	14202a73          	csrr	s4,scause
ffffffffc0200c38:	e822                	sd	s0,16(sp)
ffffffffc0200c3a:	e226                	sd	s1,256(sp)
ffffffffc0200c3c:	e64a                	sd	s2,264(sp)
ffffffffc0200c3e:	ea4e                	sd	s3,272(sp)
ffffffffc0200c40:	ee52                	sd	s4,280(sp)

    move  a0, sp
ffffffffc0200c42:	850a                	mv	a0,sp
    jal trap
ffffffffc0200c44:	f91ff0ef          	jal	ra,ffffffffc0200bd4 <trap>

ffffffffc0200c48 <__trapret>:
    # sp should be the same as before "jal trap"

    .globl __trapret
__trapret:
    RESTORE_ALL
ffffffffc0200c48:	6492                	ld	s1,256(sp)
ffffffffc0200c4a:	6932                	ld	s2,264(sp)
ffffffffc0200c4c:	10049073          	csrw	sstatus,s1
ffffffffc0200c50:	14191073          	csrw	sepc,s2
ffffffffc0200c54:	60a2                	ld	ra,8(sp)
ffffffffc0200c56:	61e2                	ld	gp,24(sp)
ffffffffc0200c58:	7202                	ld	tp,32(sp)
ffffffffc0200c5a:	72a2                	ld	t0,40(sp)
ffffffffc0200c5c:	7342                	ld	t1,48(sp)
ffffffffc0200c5e:	73e2                	ld	t2,56(sp)
ffffffffc0200c60:	6406                	ld	s0,64(sp)
ffffffffc0200c62:	64a6                	ld	s1,72(sp)
ffffffffc0200c64:	6546                	ld	a0,80(sp)
ffffffffc0200c66:	65e6                	ld	a1,88(sp)
ffffffffc0200c68:	7606                	ld	a2,96(sp)
ffffffffc0200c6a:	76a6                	ld	a3,104(sp)
ffffffffc0200c6c:	7746                	ld	a4,112(sp)
ffffffffc0200c6e:	77e6                	ld	a5,120(sp)
ffffffffc0200c70:	680a                	ld	a6,128(sp)
ffffffffc0200c72:	68aa                	ld	a7,136(sp)
ffffffffc0200c74:	694a                	ld	s2,144(sp)
ffffffffc0200c76:	69ea                	ld	s3,152(sp)
ffffffffc0200c78:	7a0a                	ld	s4,160(sp)
ffffffffc0200c7a:	7aaa                	ld	s5,168(sp)
ffffffffc0200c7c:	7b4a                	ld	s6,176(sp)
ffffffffc0200c7e:	7bea                	ld	s7,184(sp)
ffffffffc0200c80:	6c0e                	ld	s8,192(sp)
ffffffffc0200c82:	6cae                	ld	s9,200(sp)
ffffffffc0200c84:	6d4e                	ld	s10,208(sp)
ffffffffc0200c86:	6dee                	ld	s11,216(sp)
ffffffffc0200c88:	7e0e                	ld	t3,224(sp)
ffffffffc0200c8a:	7eae                	ld	t4,232(sp)
ffffffffc0200c8c:	7f4e                	ld	t5,240(sp)
ffffffffc0200c8e:	7fee                	ld	t6,248(sp)
ffffffffc0200c90:	6142                	ld	sp,16(sp)
    # return from supervisor call
    sret
ffffffffc0200c92:	10200073          	sret

ffffffffc0200c96 <alloc_pages>:
#include <defs.h>
#include <intr.h>
#include <riscv.h>

static inline bool __intr_save(void) {
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0200c96:	100027f3          	csrr	a5,sstatus
ffffffffc0200c9a:	8b89                	andi	a5,a5,2
ffffffffc0200c9c:	e799                	bnez	a5,ffffffffc0200caa <alloc_pages+0x14>
struct Page *alloc_pages(size_t n) {
    struct Page *page = NULL;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        page = pmm_manager->alloc_pages(n);
ffffffffc0200c9e:	00006797          	auipc	a5,0x6
ffffffffc0200ca2:	7da7b783          	ld	a5,2010(a5) # ffffffffc0207478 <pmm_manager>
ffffffffc0200ca6:	6f9c                	ld	a5,24(a5)
ffffffffc0200ca8:	8782                	jr	a5
struct Page *alloc_pages(size_t n) {
ffffffffc0200caa:	1141                	addi	sp,sp,-16
ffffffffc0200cac:	e406                	sd	ra,8(sp)
ffffffffc0200cae:	e022                	sd	s0,0(sp)
ffffffffc0200cb0:	842a                	mv	s0,a0
        intr_disable();
ffffffffc0200cb2:	b8bff0ef          	jal	ra,ffffffffc020083c <intr_disable>
        page = pmm_manager->alloc_pages(n);
ffffffffc0200cb6:	00006797          	auipc	a5,0x6
ffffffffc0200cba:	7c27b783          	ld	a5,1986(a5) # ffffffffc0207478 <pmm_manager>
ffffffffc0200cbe:	6f9c                	ld	a5,24(a5)
ffffffffc0200cc0:	8522                	mv	a0,s0
ffffffffc0200cc2:	9782                	jalr	a5
ffffffffc0200cc4:	842a                	mv	s0,a0
    return 0;
}

static inline void __intr_restore(bool flag) {
    if (flag) {
        intr_enable();
ffffffffc0200cc6:	b71ff0ef          	jal	ra,ffffffffc0200836 <intr_enable>
    }
    local_intr_restore(intr_flag);
    return page;
}
ffffffffc0200cca:	60a2                	ld	ra,8(sp)
ffffffffc0200ccc:	8522                	mv	a0,s0
ffffffffc0200cce:	6402                	ld	s0,0(sp)
ffffffffc0200cd0:	0141                	addi	sp,sp,16
ffffffffc0200cd2:	8082                	ret

ffffffffc0200cd4 <free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0200cd4:	100027f3          	csrr	a5,sstatus
ffffffffc0200cd8:	8b89                	andi	a5,a5,2
ffffffffc0200cda:	e799                	bnez	a5,ffffffffc0200ce8 <free_pages+0x14>
// free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory
void free_pages(struct Page *base, size_t n) {
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        pmm_manager->free_pages(base, n);
ffffffffc0200cdc:	00006797          	auipc	a5,0x6
ffffffffc0200ce0:	79c7b783          	ld	a5,1948(a5) # ffffffffc0207478 <pmm_manager>
ffffffffc0200ce4:	739c                	ld	a5,32(a5)
ffffffffc0200ce6:	8782                	jr	a5
void free_pages(struct Page *base, size_t n) {
ffffffffc0200ce8:	1101                	addi	sp,sp,-32
ffffffffc0200cea:	ec06                	sd	ra,24(sp)
ffffffffc0200cec:	e822                	sd	s0,16(sp)
ffffffffc0200cee:	e426                	sd	s1,8(sp)
ffffffffc0200cf0:	842a                	mv	s0,a0
ffffffffc0200cf2:	84ae                	mv	s1,a1
        intr_disable();
ffffffffc0200cf4:	b49ff0ef          	jal	ra,ffffffffc020083c <intr_disable>
        pmm_manager->free_pages(base, n);
ffffffffc0200cf8:	00006797          	auipc	a5,0x6
ffffffffc0200cfc:	7807b783          	ld	a5,1920(a5) # ffffffffc0207478 <pmm_manager>
ffffffffc0200d00:	739c                	ld	a5,32(a5)
ffffffffc0200d02:	85a6                	mv	a1,s1
ffffffffc0200d04:	8522                	mv	a0,s0
ffffffffc0200d06:	9782                	jalr	a5
    }
    local_intr_restore(intr_flag);
}
ffffffffc0200d08:	6442                	ld	s0,16(sp)
ffffffffc0200d0a:	60e2                	ld	ra,24(sp)
ffffffffc0200d0c:	64a2                	ld	s1,8(sp)
ffffffffc0200d0e:	6105                	addi	sp,sp,32
        intr_enable();
ffffffffc0200d10:	b61d                	j	ffffffffc0200836 <intr_enable>

ffffffffc0200d12 <nr_free_pages>:
    if (read_csr(sstatus) & SSTATUS_SIE) {
ffffffffc0200d12:	100027f3          	csrr	a5,sstatus
ffffffffc0200d16:	8b89                	andi	a5,a5,2
ffffffffc0200d18:	e799                	bnez	a5,ffffffffc0200d26 <nr_free_pages+0x14>
size_t nr_free_pages(void) {
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
    {
        ret = pmm_manager->nr_free_pages();
ffffffffc0200d1a:	00006797          	auipc	a5,0x6
ffffffffc0200d1e:	75e7b783          	ld	a5,1886(a5) # ffffffffc0207478 <pmm_manager>
ffffffffc0200d22:	779c                	ld	a5,40(a5)
ffffffffc0200d24:	8782                	jr	a5
size_t nr_free_pages(void) {
ffffffffc0200d26:	1141                	addi	sp,sp,-16
ffffffffc0200d28:	e406                	sd	ra,8(sp)
ffffffffc0200d2a:	e022                	sd	s0,0(sp)
        intr_disable();
ffffffffc0200d2c:	b11ff0ef          	jal	ra,ffffffffc020083c <intr_disable>
        ret = pmm_manager->nr_free_pages();
ffffffffc0200d30:	00006797          	auipc	a5,0x6
ffffffffc0200d34:	7487b783          	ld	a5,1864(a5) # ffffffffc0207478 <pmm_manager>
ffffffffc0200d38:	779c                	ld	a5,40(a5)
ffffffffc0200d3a:	9782                	jalr	a5
ffffffffc0200d3c:	842a                	mv	s0,a0
        intr_enable();
ffffffffc0200d3e:	af9ff0ef          	jal	ra,ffffffffc0200836 <intr_enable>
    }
    local_intr_restore(intr_flag);
    return ret;
}
ffffffffc0200d42:	60a2                	ld	ra,8(sp)
ffffffffc0200d44:	8522                	mv	a0,s0
ffffffffc0200d46:	6402                	ld	s0,0(sp)
ffffffffc0200d48:	0141                	addi	sp,sp,16
ffffffffc0200d4a:	8082                	ret

ffffffffc0200d4c <pmm_init>:
    pmm_manager = &default_pmm_manager;
ffffffffc0200d4c:	00002797          	auipc	a5,0x2
ffffffffc0200d50:	0a478793          	addi	a5,a5,164 # ffffffffc0202df0 <default_pmm_manager>
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0200d54:	638c                	ld	a1,0(a5)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
    }
}

/* pmm_init - initialize the physical memory management */
void pmm_init(void) {
ffffffffc0200d56:	7179                	addi	sp,sp,-48
ffffffffc0200d58:	f022                	sd	s0,32(sp)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0200d5a:	00002517          	auipc	a0,0x2
ffffffffc0200d5e:	b8e50513          	addi	a0,a0,-1138 # ffffffffc02028e8 <commands+0x6b8>
    pmm_manager = &default_pmm_manager;
ffffffffc0200d62:	00006417          	auipc	s0,0x6
ffffffffc0200d66:	71640413          	addi	s0,s0,1814 # ffffffffc0207478 <pmm_manager>
void pmm_init(void) {
ffffffffc0200d6a:	f406                	sd	ra,40(sp)
ffffffffc0200d6c:	ec26                	sd	s1,24(sp)
ffffffffc0200d6e:	e44e                	sd	s3,8(sp)
ffffffffc0200d70:	e84a                	sd	s2,16(sp)
ffffffffc0200d72:	e052                	sd	s4,0(sp)
    pmm_manager = &default_pmm_manager;
ffffffffc0200d74:	e01c                	sd	a5,0(s0)
    cprintf("memory management: %s\n", pmm_manager->name);
ffffffffc0200d76:	b68ff0ef          	jal	ra,ffffffffc02000de <cprintf>
    pmm_manager->init();
ffffffffc0200d7a:	601c                	ld	a5,0(s0)
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0200d7c:	00006497          	auipc	s1,0x6
ffffffffc0200d80:	71448493          	addi	s1,s1,1812 # ffffffffc0207490 <va_pa_offset>
    pmm_manager->init();
ffffffffc0200d84:	679c                	ld	a5,8(a5)
ffffffffc0200d86:	9782                	jalr	a5
    va_pa_offset = PHYSICAL_MEMORY_OFFSET;
ffffffffc0200d88:	57f5                	li	a5,-3
ffffffffc0200d8a:	07fa                	slli	a5,a5,0x1e
ffffffffc0200d8c:	e09c                	sd	a5,0(s1)
    uint64_t mem_begin = get_memory_base();
ffffffffc0200d8e:	a43ff0ef          	jal	ra,ffffffffc02007d0 <get_memory_base>
ffffffffc0200d92:	89aa                	mv	s3,a0
    uint64_t mem_size  = get_memory_size();
ffffffffc0200d94:	a47ff0ef          	jal	ra,ffffffffc02007da <get_memory_size>
    if (mem_size == 0) {
ffffffffc0200d98:	16050163          	beqz	a0,ffffffffc0200efa <pmm_init+0x1ae>
    uint64_t mem_end   = mem_begin + mem_size;
ffffffffc0200d9c:	892a                	mv	s2,a0
    cprintf("physcial memory map:\n");
ffffffffc0200d9e:	00002517          	auipc	a0,0x2
ffffffffc0200da2:	b9250513          	addi	a0,a0,-1134 # ffffffffc0202930 <commands+0x700>
ffffffffc0200da6:	b38ff0ef          	jal	ra,ffffffffc02000de <cprintf>
    uint64_t mem_end   = mem_begin + mem_size;
ffffffffc0200daa:	01298a33          	add	s4,s3,s2
    cprintf("  memory: 0x%016lx, [0x%016lx, 0x%016lx].\n", mem_size, mem_begin,
ffffffffc0200dae:	864e                	mv	a2,s3
ffffffffc0200db0:	fffa0693          	addi	a3,s4,-1
ffffffffc0200db4:	85ca                	mv	a1,s2
ffffffffc0200db6:	00002517          	auipc	a0,0x2
ffffffffc0200dba:	b9250513          	addi	a0,a0,-1134 # ffffffffc0202948 <commands+0x718>
ffffffffc0200dbe:	b20ff0ef          	jal	ra,ffffffffc02000de <cprintf>
    npage = maxpa / PGSIZE;
ffffffffc0200dc2:	c80007b7          	lui	a5,0xc8000
ffffffffc0200dc6:	8652                	mv	a2,s4
ffffffffc0200dc8:	0d47e863          	bltu	a5,s4,ffffffffc0200e98 <pmm_init+0x14c>
ffffffffc0200dcc:	00007797          	auipc	a5,0x7
ffffffffc0200dd0:	6d378793          	addi	a5,a5,1747 # ffffffffc020849f <end+0xfff>
ffffffffc0200dd4:	757d                	lui	a0,0xfffff
ffffffffc0200dd6:	8d7d                	and	a0,a0,a5
ffffffffc0200dd8:	8231                	srli	a2,a2,0xc
ffffffffc0200dda:	00006597          	auipc	a1,0x6
ffffffffc0200dde:	68e58593          	addi	a1,a1,1678 # ffffffffc0207468 <npage>
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0200de2:	00006817          	auipc	a6,0x6
ffffffffc0200de6:	68e80813          	addi	a6,a6,1678 # ffffffffc0207470 <pages>
    npage = maxpa / PGSIZE;
ffffffffc0200dea:	e190                	sd	a2,0(a1)
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
ffffffffc0200dec:	00a83023          	sd	a0,0(a6)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0200df0:	000807b7          	lui	a5,0x80
ffffffffc0200df4:	02f60663          	beq	a2,a5,ffffffffc0200e20 <pmm_init+0xd4>
ffffffffc0200df8:	4701                	li	a4,0
ffffffffc0200dfa:	4781                	li	a5,0
 *
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void set_bit(int nr, volatile void *addr) {
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0200dfc:	4305                	li	t1,1
ffffffffc0200dfe:	fff808b7          	lui	a7,0xfff80
        SetPageReserved(pages + i);
ffffffffc0200e02:	953a                	add	a0,a0,a4
ffffffffc0200e04:	00850693          	addi	a3,a0,8 # fffffffffffff008 <end+0x3fdf7b68>
ffffffffc0200e08:	4066b02f          	amoor.d	zero,t1,(a3)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0200e0c:	6190                	ld	a2,0(a1)
ffffffffc0200e0e:	0785                	addi	a5,a5,1
        SetPageReserved(pages + i);
ffffffffc0200e10:	00083503          	ld	a0,0(a6)
    for (size_t i = 0; i < npage - nbase; i++) {
ffffffffc0200e14:	011606b3          	add	a3,a2,a7
ffffffffc0200e18:	02870713          	addi	a4,a4,40
ffffffffc0200e1c:	fed7e3e3          	bltu	a5,a3,ffffffffc0200e02 <pmm_init+0xb6>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0200e20:	00261693          	slli	a3,a2,0x2
ffffffffc0200e24:	96b2                	add	a3,a3,a2
ffffffffc0200e26:	fec007b7          	lui	a5,0xfec00
ffffffffc0200e2a:	97aa                	add	a5,a5,a0
ffffffffc0200e2c:	068e                	slli	a3,a3,0x3
ffffffffc0200e2e:	96be                	add	a3,a3,a5
ffffffffc0200e30:	c02007b7          	lui	a5,0xc0200
ffffffffc0200e34:	0af6e763          	bltu	a3,a5,ffffffffc0200ee2 <pmm_init+0x196>
ffffffffc0200e38:	6098                	ld	a4,0(s1)
    mem_end = ROUNDDOWN(mem_end, PGSIZE);
ffffffffc0200e3a:	77fd                	lui	a5,0xfffff
ffffffffc0200e3c:	00fa75b3          	and	a1,s4,a5
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0200e40:	8e99                	sub	a3,a3,a4
    if (freemem < mem_end) {
ffffffffc0200e42:	04b6ee63          	bltu	a3,a1,ffffffffc0200e9e <pmm_init+0x152>
    satp_physical = PADDR(satp_virtual);
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
}

static void check_alloc_page(void) {
    pmm_manager->check();
ffffffffc0200e46:	601c                	ld	a5,0(s0)
ffffffffc0200e48:	7b9c                	ld	a5,48(a5)
ffffffffc0200e4a:	9782                	jalr	a5
    cprintf("check_alloc_page() succeeded!\n");
ffffffffc0200e4c:	00002517          	auipc	a0,0x2
ffffffffc0200e50:	b8450513          	addi	a0,a0,-1148 # ffffffffc02029d0 <commands+0x7a0>
ffffffffc0200e54:	a8aff0ef          	jal	ra,ffffffffc02000de <cprintf>
    satp_virtual = (pte_t*)boot_page_table_sv39;
ffffffffc0200e58:	00005597          	auipc	a1,0x5
ffffffffc0200e5c:	1a858593          	addi	a1,a1,424 # ffffffffc0206000 <boot_page_table_sv39>
ffffffffc0200e60:	00006797          	auipc	a5,0x6
ffffffffc0200e64:	62b7b423          	sd	a1,1576(a5) # ffffffffc0207488 <satp_virtual>
    satp_physical = PADDR(satp_virtual);
ffffffffc0200e68:	c02007b7          	lui	a5,0xc0200
ffffffffc0200e6c:	0af5e363          	bltu	a1,a5,ffffffffc0200f12 <pmm_init+0x1c6>
ffffffffc0200e70:	6090                	ld	a2,0(s1)
}
ffffffffc0200e72:	7402                	ld	s0,32(sp)
ffffffffc0200e74:	70a2                	ld	ra,40(sp)
ffffffffc0200e76:	64e2                	ld	s1,24(sp)
ffffffffc0200e78:	6942                	ld	s2,16(sp)
ffffffffc0200e7a:	69a2                	ld	s3,8(sp)
ffffffffc0200e7c:	6a02                	ld	s4,0(sp)
    satp_physical = PADDR(satp_virtual);
ffffffffc0200e7e:	40c58633          	sub	a2,a1,a2
ffffffffc0200e82:	00006797          	auipc	a5,0x6
ffffffffc0200e86:	5ec7bf23          	sd	a2,1534(a5) # ffffffffc0207480 <satp_physical>
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc0200e8a:	00002517          	auipc	a0,0x2
ffffffffc0200e8e:	b6650513          	addi	a0,a0,-1178 # ffffffffc02029f0 <commands+0x7c0>
}
ffffffffc0200e92:	6145                	addi	sp,sp,48
    cprintf("satp virtual address: 0x%016lx\nsatp physical address: 0x%016lx\n", satp_virtual, satp_physical);
ffffffffc0200e94:	a4aff06f          	j	ffffffffc02000de <cprintf>
    npage = maxpa / PGSIZE;
ffffffffc0200e98:	c8000637          	lui	a2,0xc8000
ffffffffc0200e9c:	bf05                	j	ffffffffc0200dcc <pmm_init+0x80>
    mem_begin = ROUNDUP(freemem, PGSIZE);
ffffffffc0200e9e:	6705                	lui	a4,0x1
ffffffffc0200ea0:	177d                	addi	a4,a4,-1
ffffffffc0200ea2:	96ba                	add	a3,a3,a4
ffffffffc0200ea4:	8efd                	and	a3,a3,a5
static inline int page_ref_dec(struct Page *page) {
    page->ref -= 1;
    return page->ref;
}
static inline struct Page *pa2page(uintptr_t pa) {
    if (PPN(pa) >= npage) {
ffffffffc0200ea6:	00c6d793          	srli	a5,a3,0xc
ffffffffc0200eaa:	02c7f063          	bgeu	a5,a2,ffffffffc0200eca <pmm_init+0x17e>
    pmm_manager->init_memmap(base, n);
ffffffffc0200eae:	6010                	ld	a2,0(s0)
        panic("pa2page called with invalid pa");
    }
    return &pages[PPN(pa) - nbase];
ffffffffc0200eb0:	fff80737          	lui	a4,0xfff80
ffffffffc0200eb4:	973e                	add	a4,a4,a5
ffffffffc0200eb6:	00271793          	slli	a5,a4,0x2
ffffffffc0200eba:	97ba                	add	a5,a5,a4
ffffffffc0200ebc:	6a18                	ld	a4,16(a2)
        init_memmap(pa2page(mem_begin), (mem_end - mem_begin) / PGSIZE);
ffffffffc0200ebe:	8d95                	sub	a1,a1,a3
ffffffffc0200ec0:	078e                	slli	a5,a5,0x3
    pmm_manager->init_memmap(base, n);
ffffffffc0200ec2:	81b1                	srli	a1,a1,0xc
ffffffffc0200ec4:	953e                	add	a0,a0,a5
ffffffffc0200ec6:	9702                	jalr	a4
}
ffffffffc0200ec8:	bfbd                	j	ffffffffc0200e46 <pmm_init+0xfa>
        panic("pa2page called with invalid pa");
ffffffffc0200eca:	00002617          	auipc	a2,0x2
ffffffffc0200ece:	ad660613          	addi	a2,a2,-1322 # ffffffffc02029a0 <commands+0x770>
ffffffffc0200ed2:	06b00593          	li	a1,107
ffffffffc0200ed6:	00002517          	auipc	a0,0x2
ffffffffc0200eda:	aea50513          	addi	a0,a0,-1302 # ffffffffc02029c0 <commands+0x790>
ffffffffc0200ede:	a88ff0ef          	jal	ra,ffffffffc0200166 <__panic>
    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * (npage - nbase));
ffffffffc0200ee2:	00002617          	auipc	a2,0x2
ffffffffc0200ee6:	a9660613          	addi	a2,a2,-1386 # ffffffffc0202978 <commands+0x748>
ffffffffc0200eea:	07100593          	li	a1,113
ffffffffc0200eee:	00002517          	auipc	a0,0x2
ffffffffc0200ef2:	a3250513          	addi	a0,a0,-1486 # ffffffffc0202920 <commands+0x6f0>
ffffffffc0200ef6:	a70ff0ef          	jal	ra,ffffffffc0200166 <__panic>
        panic("DTB memory info not available");
ffffffffc0200efa:	00002617          	auipc	a2,0x2
ffffffffc0200efe:	a0660613          	addi	a2,a2,-1530 # ffffffffc0202900 <commands+0x6d0>
ffffffffc0200f02:	05a00593          	li	a1,90
ffffffffc0200f06:	00002517          	auipc	a0,0x2
ffffffffc0200f0a:	a1a50513          	addi	a0,a0,-1510 # ffffffffc0202920 <commands+0x6f0>
ffffffffc0200f0e:	a58ff0ef          	jal	ra,ffffffffc0200166 <__panic>
    satp_physical = PADDR(satp_virtual);
ffffffffc0200f12:	86ae                	mv	a3,a1
ffffffffc0200f14:	00002617          	auipc	a2,0x2
ffffffffc0200f18:	a6460613          	addi	a2,a2,-1436 # ffffffffc0202978 <commands+0x748>
ffffffffc0200f1c:	08c00593          	li	a1,140
ffffffffc0200f20:	00002517          	auipc	a0,0x2
ffffffffc0200f24:	a0050513          	addi	a0,a0,-1536 # ffffffffc0202920 <commands+0x6f0>
ffffffffc0200f28:	a3eff0ef          	jal	ra,ffffffffc0200166 <__panic>

ffffffffc0200f2c <default_init>:
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
ffffffffc0200f2c:	00006797          	auipc	a5,0x6
ffffffffc0200f30:	0fc78793          	addi	a5,a5,252 # ffffffffc0207028 <free_area>
ffffffffc0200f34:	e79c                	sd	a5,8(a5)
ffffffffc0200f36:	e39c                	sd	a5,0(a5)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
    list_init(&free_list);
    nr_free = 0;
ffffffffc0200f38:	0007a823          	sw	zero,16(a5)
}
ffffffffc0200f3c:	8082                	ret

ffffffffc0200f3e <default_nr_free_pages>:
}

static size_t
default_nr_free_pages(void) {
    return nr_free;
}
ffffffffc0200f3e:	00006517          	auipc	a0,0x6
ffffffffc0200f42:	0fa56503          	lwu	a0,250(a0) # ffffffffc0207038 <free_area+0x10>
ffffffffc0200f46:	8082                	ret

ffffffffc0200f48 <default_check>:
}

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
ffffffffc0200f48:	715d                	addi	sp,sp,-80
ffffffffc0200f4a:	e0a2                	sd	s0,64(sp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
ffffffffc0200f4c:	00006417          	auipc	s0,0x6
ffffffffc0200f50:	0dc40413          	addi	s0,s0,220 # ffffffffc0207028 <free_area>
ffffffffc0200f54:	641c                	ld	a5,8(s0)
ffffffffc0200f56:	e486                	sd	ra,72(sp)
ffffffffc0200f58:	fc26                	sd	s1,56(sp)
ffffffffc0200f5a:	f84a                	sd	s2,48(sp)
ffffffffc0200f5c:	f44e                	sd	s3,40(sp)
ffffffffc0200f5e:	f052                	sd	s4,32(sp)
ffffffffc0200f60:	ec56                	sd	s5,24(sp)
ffffffffc0200f62:	e85a                	sd	s6,16(sp)
ffffffffc0200f64:	e45e                	sd	s7,8(sp)
ffffffffc0200f66:	e062                	sd	s8,0(sp)
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200f68:	2c878763          	beq	a5,s0,ffffffffc0201236 <default_check+0x2ee>
    int count = 0, total = 0;
ffffffffc0200f6c:	4481                	li	s1,0
ffffffffc0200f6e:	4901                	li	s2,0
 * test_bit - Determine whether a bit is set
 * @nr:     the bit to test
 * @addr:   the address to count from
 * */
static inline bool test_bit(int nr, volatile void *addr) {
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0200f70:	ff07b703          	ld	a4,-16(a5)
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
ffffffffc0200f74:	8b09                	andi	a4,a4,2
ffffffffc0200f76:	2c070463          	beqz	a4,ffffffffc020123e <default_check+0x2f6>
        count ++, total += p->property;
ffffffffc0200f7a:	ff87a703          	lw	a4,-8(a5)
ffffffffc0200f7e:	679c                	ld	a5,8(a5)
ffffffffc0200f80:	2905                	addiw	s2,s2,1
ffffffffc0200f82:	9cb9                	addw	s1,s1,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0200f84:	fe8796e3          	bne	a5,s0,ffffffffc0200f70 <default_check+0x28>
    }
    assert(total == nr_free_pages());
ffffffffc0200f88:	89a6                	mv	s3,s1
ffffffffc0200f8a:	d89ff0ef          	jal	ra,ffffffffc0200d12 <nr_free_pages>
ffffffffc0200f8e:	71351863          	bne	a0,s3,ffffffffc020169e <default_check+0x756>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0200f92:	4505                	li	a0,1
ffffffffc0200f94:	d03ff0ef          	jal	ra,ffffffffc0200c96 <alloc_pages>
ffffffffc0200f98:	8a2a                	mv	s4,a0
ffffffffc0200f9a:	44050263          	beqz	a0,ffffffffc02013de <default_check+0x496>
    assert((p1 = alloc_page()) != NULL);
ffffffffc0200f9e:	4505                	li	a0,1
ffffffffc0200fa0:	cf7ff0ef          	jal	ra,ffffffffc0200c96 <alloc_pages>
ffffffffc0200fa4:	89aa                	mv	s3,a0
ffffffffc0200fa6:	70050c63          	beqz	a0,ffffffffc02016be <default_check+0x776>
    assert((p2 = alloc_page()) != NULL);
ffffffffc0200faa:	4505                	li	a0,1
ffffffffc0200fac:	cebff0ef          	jal	ra,ffffffffc0200c96 <alloc_pages>
ffffffffc0200fb0:	8aaa                	mv	s5,a0
ffffffffc0200fb2:	4a050663          	beqz	a0,ffffffffc020145e <default_check+0x516>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc0200fb6:	2b3a0463          	beq	s4,s3,ffffffffc020125e <default_check+0x316>
ffffffffc0200fba:	2aaa0263          	beq	s4,a0,ffffffffc020125e <default_check+0x316>
ffffffffc0200fbe:	2aa98063          	beq	s3,a0,ffffffffc020125e <default_check+0x316>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc0200fc2:	000a2783          	lw	a5,0(s4)
ffffffffc0200fc6:	2a079c63          	bnez	a5,ffffffffc020127e <default_check+0x336>
ffffffffc0200fca:	0009a783          	lw	a5,0(s3)
ffffffffc0200fce:	2a079863          	bnez	a5,ffffffffc020127e <default_check+0x336>
ffffffffc0200fd2:	411c                	lw	a5,0(a0)
ffffffffc0200fd4:	2a079563          	bnez	a5,ffffffffc020127e <default_check+0x336>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc0200fd8:	00006797          	auipc	a5,0x6
ffffffffc0200fdc:	4987b783          	ld	a5,1176(a5) # ffffffffc0207470 <pages>
ffffffffc0200fe0:	40fa0733          	sub	a4,s4,a5
ffffffffc0200fe4:	870d                	srai	a4,a4,0x3
ffffffffc0200fe6:	00002597          	auipc	a1,0x2
ffffffffc0200fea:	0925b583          	ld	a1,146(a1) # ffffffffc0203078 <nbase+0x8>
ffffffffc0200fee:	02b70733          	mul	a4,a4,a1
ffffffffc0200ff2:	00002617          	auipc	a2,0x2
ffffffffc0200ff6:	07e63603          	ld	a2,126(a2) # ffffffffc0203070 <nbase>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc0200ffa:	00006697          	auipc	a3,0x6
ffffffffc0200ffe:	46e6b683          	ld	a3,1134(a3) # ffffffffc0207468 <npage>
ffffffffc0201002:	06b2                	slli	a3,a3,0xc
ffffffffc0201004:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0201006:	0732                	slli	a4,a4,0xc
ffffffffc0201008:	28d77b63          	bgeu	a4,a3,ffffffffc020129e <default_check+0x356>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc020100c:	40f98733          	sub	a4,s3,a5
ffffffffc0201010:	870d                	srai	a4,a4,0x3
ffffffffc0201012:	02b70733          	mul	a4,a4,a1
ffffffffc0201016:	9732                	add	a4,a4,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc0201018:	0732                	slli	a4,a4,0xc
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc020101a:	4cd77263          	bgeu	a4,a3,ffffffffc02014de <default_check+0x596>
static inline ppn_t page2ppn(struct Page *page) { return page - pages + nbase; }
ffffffffc020101e:	40f507b3          	sub	a5,a0,a5
ffffffffc0201022:	878d                	srai	a5,a5,0x3
ffffffffc0201024:	02b787b3          	mul	a5,a5,a1
ffffffffc0201028:	97b2                	add	a5,a5,a2
    return page2ppn(page) << PGSHIFT;
ffffffffc020102a:	07b2                	slli	a5,a5,0xc
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc020102c:	30d7f963          	bgeu	a5,a3,ffffffffc020133e <default_check+0x3f6>
    assert(alloc_page() == NULL);
ffffffffc0201030:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0201032:	00043c03          	ld	s8,0(s0)
ffffffffc0201036:	00843b83          	ld	s7,8(s0)
    unsigned int nr_free_store = nr_free;
ffffffffc020103a:	01042b03          	lw	s6,16(s0)
    elm->prev = elm->next = elm;
ffffffffc020103e:	e400                	sd	s0,8(s0)
ffffffffc0201040:	e000                	sd	s0,0(s0)
    nr_free = 0;
ffffffffc0201042:	00006797          	auipc	a5,0x6
ffffffffc0201046:	fe07ab23          	sw	zero,-10(a5) # ffffffffc0207038 <free_area+0x10>
    assert(alloc_page() == NULL);
ffffffffc020104a:	c4dff0ef          	jal	ra,ffffffffc0200c96 <alloc_pages>
ffffffffc020104e:	2c051863          	bnez	a0,ffffffffc020131e <default_check+0x3d6>
    free_page(p0);
ffffffffc0201052:	4585                	li	a1,1
ffffffffc0201054:	8552                	mv	a0,s4
ffffffffc0201056:	c7fff0ef          	jal	ra,ffffffffc0200cd4 <free_pages>
    free_page(p1);
ffffffffc020105a:	4585                	li	a1,1
ffffffffc020105c:	854e                	mv	a0,s3
ffffffffc020105e:	c77ff0ef          	jal	ra,ffffffffc0200cd4 <free_pages>
    free_page(p2);
ffffffffc0201062:	4585                	li	a1,1
ffffffffc0201064:	8556                	mv	a0,s5
ffffffffc0201066:	c6fff0ef          	jal	ra,ffffffffc0200cd4 <free_pages>
    assert(nr_free == 3);
ffffffffc020106a:	4818                	lw	a4,16(s0)
ffffffffc020106c:	478d                	li	a5,3
ffffffffc020106e:	28f71863          	bne	a4,a5,ffffffffc02012fe <default_check+0x3b6>
    assert((p0 = alloc_page()) != NULL);
ffffffffc0201072:	4505                	li	a0,1
ffffffffc0201074:	c23ff0ef          	jal	ra,ffffffffc0200c96 <alloc_pages>
ffffffffc0201078:	89aa                	mv	s3,a0
ffffffffc020107a:	26050263          	beqz	a0,ffffffffc02012de <default_check+0x396>
    assert((p1 = alloc_page()) != NULL);
ffffffffc020107e:	4505                	li	a0,1
ffffffffc0201080:	c17ff0ef          	jal	ra,ffffffffc0200c96 <alloc_pages>
ffffffffc0201084:	8aaa                	mv	s5,a0
ffffffffc0201086:	3a050c63          	beqz	a0,ffffffffc020143e <default_check+0x4f6>
    assert((p2 = alloc_page()) != NULL);
ffffffffc020108a:	4505                	li	a0,1
ffffffffc020108c:	c0bff0ef          	jal	ra,ffffffffc0200c96 <alloc_pages>
ffffffffc0201090:	8a2a                	mv	s4,a0
ffffffffc0201092:	38050663          	beqz	a0,ffffffffc020141e <default_check+0x4d6>
    assert(alloc_page() == NULL);
ffffffffc0201096:	4505                	li	a0,1
ffffffffc0201098:	bffff0ef          	jal	ra,ffffffffc0200c96 <alloc_pages>
ffffffffc020109c:	36051163          	bnez	a0,ffffffffc02013fe <default_check+0x4b6>
    free_page(p0);
ffffffffc02010a0:	4585                	li	a1,1
ffffffffc02010a2:	854e                	mv	a0,s3
ffffffffc02010a4:	c31ff0ef          	jal	ra,ffffffffc0200cd4 <free_pages>
    assert(!list_empty(&free_list));
ffffffffc02010a8:	641c                	ld	a5,8(s0)
ffffffffc02010aa:	20878a63          	beq	a5,s0,ffffffffc02012be <default_check+0x376>
    assert((p = alloc_page()) == p0);
ffffffffc02010ae:	4505                	li	a0,1
ffffffffc02010b0:	be7ff0ef          	jal	ra,ffffffffc0200c96 <alloc_pages>
ffffffffc02010b4:	30a99563          	bne	s3,a0,ffffffffc02013be <default_check+0x476>
    assert(alloc_page() == NULL);
ffffffffc02010b8:	4505                	li	a0,1
ffffffffc02010ba:	bddff0ef          	jal	ra,ffffffffc0200c96 <alloc_pages>
ffffffffc02010be:	2e051063          	bnez	a0,ffffffffc020139e <default_check+0x456>
    assert(nr_free == 0);
ffffffffc02010c2:	481c                	lw	a5,16(s0)
ffffffffc02010c4:	2a079d63          	bnez	a5,ffffffffc020137e <default_check+0x436>
    free_page(p);
ffffffffc02010c8:	854e                	mv	a0,s3
ffffffffc02010ca:	4585                	li	a1,1
    free_list = free_list_store;
ffffffffc02010cc:	01843023          	sd	s8,0(s0)
ffffffffc02010d0:	01743423          	sd	s7,8(s0)
    nr_free = nr_free_store;
ffffffffc02010d4:	01642823          	sw	s6,16(s0)
    free_page(p);
ffffffffc02010d8:	bfdff0ef          	jal	ra,ffffffffc0200cd4 <free_pages>
    free_page(p1);
ffffffffc02010dc:	4585                	li	a1,1
ffffffffc02010de:	8556                	mv	a0,s5
ffffffffc02010e0:	bf5ff0ef          	jal	ra,ffffffffc0200cd4 <free_pages>
    free_page(p2);
ffffffffc02010e4:	4585                	li	a1,1
ffffffffc02010e6:	8552                	mv	a0,s4
ffffffffc02010e8:	bedff0ef          	jal	ra,ffffffffc0200cd4 <free_pages>

    basic_check();

    struct Page *p0 = alloc_pages(5), *p1, *p2;
ffffffffc02010ec:	4515                	li	a0,5
ffffffffc02010ee:	ba9ff0ef          	jal	ra,ffffffffc0200c96 <alloc_pages>
ffffffffc02010f2:	89aa                	mv	s3,a0
    assert(p0 != NULL);
ffffffffc02010f4:	26050563          	beqz	a0,ffffffffc020135e <default_check+0x416>
ffffffffc02010f8:	651c                	ld	a5,8(a0)
ffffffffc02010fa:	8385                	srli	a5,a5,0x1
    assert(!PageProperty(p0));
ffffffffc02010fc:	8b85                	andi	a5,a5,1
ffffffffc02010fe:	54079063          	bnez	a5,ffffffffc020163e <default_check+0x6f6>

    list_entry_t free_list_store = free_list;
    list_init(&free_list);
    assert(list_empty(&free_list));
    assert(alloc_page() == NULL);
ffffffffc0201102:	4505                	li	a0,1
    list_entry_t free_list_store = free_list;
ffffffffc0201104:	00043b03          	ld	s6,0(s0)
ffffffffc0201108:	00843a83          	ld	s5,8(s0)
ffffffffc020110c:	e000                	sd	s0,0(s0)
ffffffffc020110e:	e400                	sd	s0,8(s0)
    assert(alloc_page() == NULL);
ffffffffc0201110:	b87ff0ef          	jal	ra,ffffffffc0200c96 <alloc_pages>
ffffffffc0201114:	50051563          	bnez	a0,ffffffffc020161e <default_check+0x6d6>

    unsigned int nr_free_store = nr_free;
    nr_free = 0;

    free_pages(p0 + 2, 3);
ffffffffc0201118:	05098a13          	addi	s4,s3,80
ffffffffc020111c:	8552                	mv	a0,s4
ffffffffc020111e:	458d                	li	a1,3
    unsigned int nr_free_store = nr_free;
ffffffffc0201120:	01042b83          	lw	s7,16(s0)
    nr_free = 0;
ffffffffc0201124:	00006797          	auipc	a5,0x6
ffffffffc0201128:	f007aa23          	sw	zero,-236(a5) # ffffffffc0207038 <free_area+0x10>
    free_pages(p0 + 2, 3);
ffffffffc020112c:	ba9ff0ef          	jal	ra,ffffffffc0200cd4 <free_pages>
    assert(alloc_pages(4) == NULL);
ffffffffc0201130:	4511                	li	a0,4
ffffffffc0201132:	b65ff0ef          	jal	ra,ffffffffc0200c96 <alloc_pages>
ffffffffc0201136:	4c051463          	bnez	a0,ffffffffc02015fe <default_check+0x6b6>
ffffffffc020113a:	0589b783          	ld	a5,88(s3)
ffffffffc020113e:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc0201140:	8b85                	andi	a5,a5,1
ffffffffc0201142:	48078e63          	beqz	a5,ffffffffc02015de <default_check+0x696>
ffffffffc0201146:	0609a703          	lw	a4,96(s3)
ffffffffc020114a:	478d                	li	a5,3
ffffffffc020114c:	48f71963          	bne	a4,a5,ffffffffc02015de <default_check+0x696>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc0201150:	450d                	li	a0,3
ffffffffc0201152:	b45ff0ef          	jal	ra,ffffffffc0200c96 <alloc_pages>
ffffffffc0201156:	8c2a                	mv	s8,a0
ffffffffc0201158:	46050363          	beqz	a0,ffffffffc02015be <default_check+0x676>
    assert(alloc_page() == NULL);
ffffffffc020115c:	4505                	li	a0,1
ffffffffc020115e:	b39ff0ef          	jal	ra,ffffffffc0200c96 <alloc_pages>
ffffffffc0201162:	42051e63          	bnez	a0,ffffffffc020159e <default_check+0x656>
    assert(p0 + 2 == p1);
ffffffffc0201166:	418a1c63          	bne	s4,s8,ffffffffc020157e <default_check+0x636>

    p2 = p0 + 1;
    free_page(p0);
ffffffffc020116a:	4585                	li	a1,1
ffffffffc020116c:	854e                	mv	a0,s3
ffffffffc020116e:	b67ff0ef          	jal	ra,ffffffffc0200cd4 <free_pages>
    free_pages(p1, 3);
ffffffffc0201172:	458d                	li	a1,3
ffffffffc0201174:	8552                	mv	a0,s4
ffffffffc0201176:	b5fff0ef          	jal	ra,ffffffffc0200cd4 <free_pages>
ffffffffc020117a:	0089b783          	ld	a5,8(s3)
    p2 = p0 + 1;
ffffffffc020117e:	02898c13          	addi	s8,s3,40
ffffffffc0201182:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc0201184:	8b85                	andi	a5,a5,1
ffffffffc0201186:	3c078c63          	beqz	a5,ffffffffc020155e <default_check+0x616>
ffffffffc020118a:	0109a703          	lw	a4,16(s3)
ffffffffc020118e:	4785                	li	a5,1
ffffffffc0201190:	3cf71763          	bne	a4,a5,ffffffffc020155e <default_check+0x616>
ffffffffc0201194:	008a3783          	ld	a5,8(s4)
ffffffffc0201198:	8385                	srli	a5,a5,0x1
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc020119a:	8b85                	andi	a5,a5,1
ffffffffc020119c:	3a078163          	beqz	a5,ffffffffc020153e <default_check+0x5f6>
ffffffffc02011a0:	010a2703          	lw	a4,16(s4)
ffffffffc02011a4:	478d                	li	a5,3
ffffffffc02011a6:	38f71c63          	bne	a4,a5,ffffffffc020153e <default_check+0x5f6>

    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc02011aa:	4505                	li	a0,1
ffffffffc02011ac:	aebff0ef          	jal	ra,ffffffffc0200c96 <alloc_pages>
ffffffffc02011b0:	36a99763          	bne	s3,a0,ffffffffc020151e <default_check+0x5d6>
    free_page(p0);
ffffffffc02011b4:	4585                	li	a1,1
ffffffffc02011b6:	b1fff0ef          	jal	ra,ffffffffc0200cd4 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc02011ba:	4509                	li	a0,2
ffffffffc02011bc:	adbff0ef          	jal	ra,ffffffffc0200c96 <alloc_pages>
ffffffffc02011c0:	32aa1f63          	bne	s4,a0,ffffffffc02014fe <default_check+0x5b6>

    free_pages(p0, 2);
ffffffffc02011c4:	4589                	li	a1,2
ffffffffc02011c6:	b0fff0ef          	jal	ra,ffffffffc0200cd4 <free_pages>
    free_page(p2);
ffffffffc02011ca:	4585                	li	a1,1
ffffffffc02011cc:	8562                	mv	a0,s8
ffffffffc02011ce:	b07ff0ef          	jal	ra,ffffffffc0200cd4 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc02011d2:	4515                	li	a0,5
ffffffffc02011d4:	ac3ff0ef          	jal	ra,ffffffffc0200c96 <alloc_pages>
ffffffffc02011d8:	89aa                	mv	s3,a0
ffffffffc02011da:	48050263          	beqz	a0,ffffffffc020165e <default_check+0x716>
    assert(alloc_page() == NULL);
ffffffffc02011de:	4505                	li	a0,1
ffffffffc02011e0:	ab7ff0ef          	jal	ra,ffffffffc0200c96 <alloc_pages>
ffffffffc02011e4:	2c051d63          	bnez	a0,ffffffffc02014be <default_check+0x576>

    assert(nr_free == 0);
ffffffffc02011e8:	481c                	lw	a5,16(s0)
ffffffffc02011ea:	2a079a63          	bnez	a5,ffffffffc020149e <default_check+0x556>
    nr_free = nr_free_store;

    free_list = free_list_store;
    free_pages(p0, 5);
ffffffffc02011ee:	4595                	li	a1,5
ffffffffc02011f0:	854e                	mv	a0,s3
    nr_free = nr_free_store;
ffffffffc02011f2:	01742823          	sw	s7,16(s0)
    free_list = free_list_store;
ffffffffc02011f6:	01643023          	sd	s6,0(s0)
ffffffffc02011fa:	01543423          	sd	s5,8(s0)
    free_pages(p0, 5);
ffffffffc02011fe:	ad7ff0ef          	jal	ra,ffffffffc0200cd4 <free_pages>
    return listelm->next;
ffffffffc0201202:	641c                	ld	a5,8(s0)

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
ffffffffc0201204:	00878963          	beq	a5,s0,ffffffffc0201216 <default_check+0x2ce>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
ffffffffc0201208:	ff87a703          	lw	a4,-8(a5)
ffffffffc020120c:	679c                	ld	a5,8(a5)
ffffffffc020120e:	397d                	addiw	s2,s2,-1
ffffffffc0201210:	9c99                	subw	s1,s1,a4
    while ((le = list_next(le)) != &free_list) {
ffffffffc0201212:	fe879be3          	bne	a5,s0,ffffffffc0201208 <default_check+0x2c0>
    }
    assert(count == 0);
ffffffffc0201216:	26091463          	bnez	s2,ffffffffc020147e <default_check+0x536>
    assert(total == 0);
ffffffffc020121a:	46049263          	bnez	s1,ffffffffc020167e <default_check+0x736>
}
ffffffffc020121e:	60a6                	ld	ra,72(sp)
ffffffffc0201220:	6406                	ld	s0,64(sp)
ffffffffc0201222:	74e2                	ld	s1,56(sp)
ffffffffc0201224:	7942                	ld	s2,48(sp)
ffffffffc0201226:	79a2                	ld	s3,40(sp)
ffffffffc0201228:	7a02                	ld	s4,32(sp)
ffffffffc020122a:	6ae2                	ld	s5,24(sp)
ffffffffc020122c:	6b42                	ld	s6,16(sp)
ffffffffc020122e:	6ba2                	ld	s7,8(sp)
ffffffffc0201230:	6c02                	ld	s8,0(sp)
ffffffffc0201232:	6161                	addi	sp,sp,80
ffffffffc0201234:	8082                	ret
    while ((le = list_next(le)) != &free_list) {
ffffffffc0201236:	4981                	li	s3,0
    int count = 0, total = 0;
ffffffffc0201238:	4481                	li	s1,0
ffffffffc020123a:	4901                	li	s2,0
ffffffffc020123c:	b3b9                	j	ffffffffc0200f8a <default_check+0x42>
        assert(PageProperty(p));
ffffffffc020123e:	00001697          	auipc	a3,0x1
ffffffffc0201242:	7f268693          	addi	a3,a3,2034 # ffffffffc0202a30 <commands+0x800>
ffffffffc0201246:	00001617          	auipc	a2,0x1
ffffffffc020124a:	7fa60613          	addi	a2,a2,2042 # ffffffffc0202a40 <commands+0x810>
ffffffffc020124e:	0f000593          	li	a1,240
ffffffffc0201252:	00002517          	auipc	a0,0x2
ffffffffc0201256:	80650513          	addi	a0,a0,-2042 # ffffffffc0202a58 <commands+0x828>
ffffffffc020125a:	f0dfe0ef          	jal	ra,ffffffffc0200166 <__panic>
    assert(p0 != p1 && p0 != p2 && p1 != p2);
ffffffffc020125e:	00002697          	auipc	a3,0x2
ffffffffc0201262:	89268693          	addi	a3,a3,-1902 # ffffffffc0202af0 <commands+0x8c0>
ffffffffc0201266:	00001617          	auipc	a2,0x1
ffffffffc020126a:	7da60613          	addi	a2,a2,2010 # ffffffffc0202a40 <commands+0x810>
ffffffffc020126e:	0bd00593          	li	a1,189
ffffffffc0201272:	00001517          	auipc	a0,0x1
ffffffffc0201276:	7e650513          	addi	a0,a0,2022 # ffffffffc0202a58 <commands+0x828>
ffffffffc020127a:	eedfe0ef          	jal	ra,ffffffffc0200166 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
ffffffffc020127e:	00002697          	auipc	a3,0x2
ffffffffc0201282:	89a68693          	addi	a3,a3,-1894 # ffffffffc0202b18 <commands+0x8e8>
ffffffffc0201286:	00001617          	auipc	a2,0x1
ffffffffc020128a:	7ba60613          	addi	a2,a2,1978 # ffffffffc0202a40 <commands+0x810>
ffffffffc020128e:	0be00593          	li	a1,190
ffffffffc0201292:	00001517          	auipc	a0,0x1
ffffffffc0201296:	7c650513          	addi	a0,a0,1990 # ffffffffc0202a58 <commands+0x828>
ffffffffc020129a:	ecdfe0ef          	jal	ra,ffffffffc0200166 <__panic>
    assert(page2pa(p0) < npage * PGSIZE);
ffffffffc020129e:	00002697          	auipc	a3,0x2
ffffffffc02012a2:	8ba68693          	addi	a3,a3,-1862 # ffffffffc0202b58 <commands+0x928>
ffffffffc02012a6:	00001617          	auipc	a2,0x1
ffffffffc02012aa:	79a60613          	addi	a2,a2,1946 # ffffffffc0202a40 <commands+0x810>
ffffffffc02012ae:	0c000593          	li	a1,192
ffffffffc02012b2:	00001517          	auipc	a0,0x1
ffffffffc02012b6:	7a650513          	addi	a0,a0,1958 # ffffffffc0202a58 <commands+0x828>
ffffffffc02012ba:	eadfe0ef          	jal	ra,ffffffffc0200166 <__panic>
    assert(!list_empty(&free_list));
ffffffffc02012be:	00002697          	auipc	a3,0x2
ffffffffc02012c2:	92268693          	addi	a3,a3,-1758 # ffffffffc0202be0 <commands+0x9b0>
ffffffffc02012c6:	00001617          	auipc	a2,0x1
ffffffffc02012ca:	77a60613          	addi	a2,a2,1914 # ffffffffc0202a40 <commands+0x810>
ffffffffc02012ce:	0d900593          	li	a1,217
ffffffffc02012d2:	00001517          	auipc	a0,0x1
ffffffffc02012d6:	78650513          	addi	a0,a0,1926 # ffffffffc0202a58 <commands+0x828>
ffffffffc02012da:	e8dfe0ef          	jal	ra,ffffffffc0200166 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02012de:	00001697          	auipc	a3,0x1
ffffffffc02012e2:	7b268693          	addi	a3,a3,1970 # ffffffffc0202a90 <commands+0x860>
ffffffffc02012e6:	00001617          	auipc	a2,0x1
ffffffffc02012ea:	75a60613          	addi	a2,a2,1882 # ffffffffc0202a40 <commands+0x810>
ffffffffc02012ee:	0d200593          	li	a1,210
ffffffffc02012f2:	00001517          	auipc	a0,0x1
ffffffffc02012f6:	76650513          	addi	a0,a0,1894 # ffffffffc0202a58 <commands+0x828>
ffffffffc02012fa:	e6dfe0ef          	jal	ra,ffffffffc0200166 <__panic>
    assert(nr_free == 3);
ffffffffc02012fe:	00002697          	auipc	a3,0x2
ffffffffc0201302:	8d268693          	addi	a3,a3,-1838 # ffffffffc0202bd0 <commands+0x9a0>
ffffffffc0201306:	00001617          	auipc	a2,0x1
ffffffffc020130a:	73a60613          	addi	a2,a2,1850 # ffffffffc0202a40 <commands+0x810>
ffffffffc020130e:	0d000593          	li	a1,208
ffffffffc0201312:	00001517          	auipc	a0,0x1
ffffffffc0201316:	74650513          	addi	a0,a0,1862 # ffffffffc0202a58 <commands+0x828>
ffffffffc020131a:	e4dfe0ef          	jal	ra,ffffffffc0200166 <__panic>
    assert(alloc_page() == NULL);
ffffffffc020131e:	00002697          	auipc	a3,0x2
ffffffffc0201322:	89a68693          	addi	a3,a3,-1894 # ffffffffc0202bb8 <commands+0x988>
ffffffffc0201326:	00001617          	auipc	a2,0x1
ffffffffc020132a:	71a60613          	addi	a2,a2,1818 # ffffffffc0202a40 <commands+0x810>
ffffffffc020132e:	0cb00593          	li	a1,203
ffffffffc0201332:	00001517          	auipc	a0,0x1
ffffffffc0201336:	72650513          	addi	a0,a0,1830 # ffffffffc0202a58 <commands+0x828>
ffffffffc020133a:	e2dfe0ef          	jal	ra,ffffffffc0200166 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
ffffffffc020133e:	00002697          	auipc	a3,0x2
ffffffffc0201342:	85a68693          	addi	a3,a3,-1958 # ffffffffc0202b98 <commands+0x968>
ffffffffc0201346:	00001617          	auipc	a2,0x1
ffffffffc020134a:	6fa60613          	addi	a2,a2,1786 # ffffffffc0202a40 <commands+0x810>
ffffffffc020134e:	0c200593          	li	a1,194
ffffffffc0201352:	00001517          	auipc	a0,0x1
ffffffffc0201356:	70650513          	addi	a0,a0,1798 # ffffffffc0202a58 <commands+0x828>
ffffffffc020135a:	e0dfe0ef          	jal	ra,ffffffffc0200166 <__panic>
    assert(p0 != NULL);
ffffffffc020135e:	00002697          	auipc	a3,0x2
ffffffffc0201362:	8ca68693          	addi	a3,a3,-1846 # ffffffffc0202c28 <commands+0x9f8>
ffffffffc0201366:	00001617          	auipc	a2,0x1
ffffffffc020136a:	6da60613          	addi	a2,a2,1754 # ffffffffc0202a40 <commands+0x810>
ffffffffc020136e:	0f800593          	li	a1,248
ffffffffc0201372:	00001517          	auipc	a0,0x1
ffffffffc0201376:	6e650513          	addi	a0,a0,1766 # ffffffffc0202a58 <commands+0x828>
ffffffffc020137a:	dedfe0ef          	jal	ra,ffffffffc0200166 <__panic>
    assert(nr_free == 0);
ffffffffc020137e:	00002697          	auipc	a3,0x2
ffffffffc0201382:	89a68693          	addi	a3,a3,-1894 # ffffffffc0202c18 <commands+0x9e8>
ffffffffc0201386:	00001617          	auipc	a2,0x1
ffffffffc020138a:	6ba60613          	addi	a2,a2,1722 # ffffffffc0202a40 <commands+0x810>
ffffffffc020138e:	0df00593          	li	a1,223
ffffffffc0201392:	00001517          	auipc	a0,0x1
ffffffffc0201396:	6c650513          	addi	a0,a0,1734 # ffffffffc0202a58 <commands+0x828>
ffffffffc020139a:	dcdfe0ef          	jal	ra,ffffffffc0200166 <__panic>
    assert(alloc_page() == NULL);
ffffffffc020139e:	00002697          	auipc	a3,0x2
ffffffffc02013a2:	81a68693          	addi	a3,a3,-2022 # ffffffffc0202bb8 <commands+0x988>
ffffffffc02013a6:	00001617          	auipc	a2,0x1
ffffffffc02013aa:	69a60613          	addi	a2,a2,1690 # ffffffffc0202a40 <commands+0x810>
ffffffffc02013ae:	0dd00593          	li	a1,221
ffffffffc02013b2:	00001517          	auipc	a0,0x1
ffffffffc02013b6:	6a650513          	addi	a0,a0,1702 # ffffffffc0202a58 <commands+0x828>
ffffffffc02013ba:	dadfe0ef          	jal	ra,ffffffffc0200166 <__panic>
    assert((p = alloc_page()) == p0);
ffffffffc02013be:	00002697          	auipc	a3,0x2
ffffffffc02013c2:	83a68693          	addi	a3,a3,-1990 # ffffffffc0202bf8 <commands+0x9c8>
ffffffffc02013c6:	00001617          	auipc	a2,0x1
ffffffffc02013ca:	67a60613          	addi	a2,a2,1658 # ffffffffc0202a40 <commands+0x810>
ffffffffc02013ce:	0dc00593          	li	a1,220
ffffffffc02013d2:	00001517          	auipc	a0,0x1
ffffffffc02013d6:	68650513          	addi	a0,a0,1670 # ffffffffc0202a58 <commands+0x828>
ffffffffc02013da:	d8dfe0ef          	jal	ra,ffffffffc0200166 <__panic>
    assert((p0 = alloc_page()) != NULL);
ffffffffc02013de:	00001697          	auipc	a3,0x1
ffffffffc02013e2:	6b268693          	addi	a3,a3,1714 # ffffffffc0202a90 <commands+0x860>
ffffffffc02013e6:	00001617          	auipc	a2,0x1
ffffffffc02013ea:	65a60613          	addi	a2,a2,1626 # ffffffffc0202a40 <commands+0x810>
ffffffffc02013ee:	0b900593          	li	a1,185
ffffffffc02013f2:	00001517          	auipc	a0,0x1
ffffffffc02013f6:	66650513          	addi	a0,a0,1638 # ffffffffc0202a58 <commands+0x828>
ffffffffc02013fa:	d6dfe0ef          	jal	ra,ffffffffc0200166 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02013fe:	00001697          	auipc	a3,0x1
ffffffffc0201402:	7ba68693          	addi	a3,a3,1978 # ffffffffc0202bb8 <commands+0x988>
ffffffffc0201406:	00001617          	auipc	a2,0x1
ffffffffc020140a:	63a60613          	addi	a2,a2,1594 # ffffffffc0202a40 <commands+0x810>
ffffffffc020140e:	0d600593          	li	a1,214
ffffffffc0201412:	00001517          	auipc	a0,0x1
ffffffffc0201416:	64650513          	addi	a0,a0,1606 # ffffffffc0202a58 <commands+0x828>
ffffffffc020141a:	d4dfe0ef          	jal	ra,ffffffffc0200166 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc020141e:	00001697          	auipc	a3,0x1
ffffffffc0201422:	6b268693          	addi	a3,a3,1714 # ffffffffc0202ad0 <commands+0x8a0>
ffffffffc0201426:	00001617          	auipc	a2,0x1
ffffffffc020142a:	61a60613          	addi	a2,a2,1562 # ffffffffc0202a40 <commands+0x810>
ffffffffc020142e:	0d400593          	li	a1,212
ffffffffc0201432:	00001517          	auipc	a0,0x1
ffffffffc0201436:	62650513          	addi	a0,a0,1574 # ffffffffc0202a58 <commands+0x828>
ffffffffc020143a:	d2dfe0ef          	jal	ra,ffffffffc0200166 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc020143e:	00001697          	auipc	a3,0x1
ffffffffc0201442:	67268693          	addi	a3,a3,1650 # ffffffffc0202ab0 <commands+0x880>
ffffffffc0201446:	00001617          	auipc	a2,0x1
ffffffffc020144a:	5fa60613          	addi	a2,a2,1530 # ffffffffc0202a40 <commands+0x810>
ffffffffc020144e:	0d300593          	li	a1,211
ffffffffc0201452:	00001517          	auipc	a0,0x1
ffffffffc0201456:	60650513          	addi	a0,a0,1542 # ffffffffc0202a58 <commands+0x828>
ffffffffc020145a:	d0dfe0ef          	jal	ra,ffffffffc0200166 <__panic>
    assert((p2 = alloc_page()) != NULL);
ffffffffc020145e:	00001697          	auipc	a3,0x1
ffffffffc0201462:	67268693          	addi	a3,a3,1650 # ffffffffc0202ad0 <commands+0x8a0>
ffffffffc0201466:	00001617          	auipc	a2,0x1
ffffffffc020146a:	5da60613          	addi	a2,a2,1498 # ffffffffc0202a40 <commands+0x810>
ffffffffc020146e:	0bb00593          	li	a1,187
ffffffffc0201472:	00001517          	auipc	a0,0x1
ffffffffc0201476:	5e650513          	addi	a0,a0,1510 # ffffffffc0202a58 <commands+0x828>
ffffffffc020147a:	cedfe0ef          	jal	ra,ffffffffc0200166 <__panic>
    assert(count == 0);
ffffffffc020147e:	00002697          	auipc	a3,0x2
ffffffffc0201482:	8fa68693          	addi	a3,a3,-1798 # ffffffffc0202d78 <commands+0xb48>
ffffffffc0201486:	00001617          	auipc	a2,0x1
ffffffffc020148a:	5ba60613          	addi	a2,a2,1466 # ffffffffc0202a40 <commands+0x810>
ffffffffc020148e:	12500593          	li	a1,293
ffffffffc0201492:	00001517          	auipc	a0,0x1
ffffffffc0201496:	5c650513          	addi	a0,a0,1478 # ffffffffc0202a58 <commands+0x828>
ffffffffc020149a:	ccdfe0ef          	jal	ra,ffffffffc0200166 <__panic>
    assert(nr_free == 0);
ffffffffc020149e:	00001697          	auipc	a3,0x1
ffffffffc02014a2:	77a68693          	addi	a3,a3,1914 # ffffffffc0202c18 <commands+0x9e8>
ffffffffc02014a6:	00001617          	auipc	a2,0x1
ffffffffc02014aa:	59a60613          	addi	a2,a2,1434 # ffffffffc0202a40 <commands+0x810>
ffffffffc02014ae:	11a00593          	li	a1,282
ffffffffc02014b2:	00001517          	auipc	a0,0x1
ffffffffc02014b6:	5a650513          	addi	a0,a0,1446 # ffffffffc0202a58 <commands+0x828>
ffffffffc02014ba:	cadfe0ef          	jal	ra,ffffffffc0200166 <__panic>
    assert(alloc_page() == NULL);
ffffffffc02014be:	00001697          	auipc	a3,0x1
ffffffffc02014c2:	6fa68693          	addi	a3,a3,1786 # ffffffffc0202bb8 <commands+0x988>
ffffffffc02014c6:	00001617          	auipc	a2,0x1
ffffffffc02014ca:	57a60613          	addi	a2,a2,1402 # ffffffffc0202a40 <commands+0x810>
ffffffffc02014ce:	11800593          	li	a1,280
ffffffffc02014d2:	00001517          	auipc	a0,0x1
ffffffffc02014d6:	58650513          	addi	a0,a0,1414 # ffffffffc0202a58 <commands+0x828>
ffffffffc02014da:	c8dfe0ef          	jal	ra,ffffffffc0200166 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
ffffffffc02014de:	00001697          	auipc	a3,0x1
ffffffffc02014e2:	69a68693          	addi	a3,a3,1690 # ffffffffc0202b78 <commands+0x948>
ffffffffc02014e6:	00001617          	auipc	a2,0x1
ffffffffc02014ea:	55a60613          	addi	a2,a2,1370 # ffffffffc0202a40 <commands+0x810>
ffffffffc02014ee:	0c100593          	li	a1,193
ffffffffc02014f2:	00001517          	auipc	a0,0x1
ffffffffc02014f6:	56650513          	addi	a0,a0,1382 # ffffffffc0202a58 <commands+0x828>
ffffffffc02014fa:	c6dfe0ef          	jal	ra,ffffffffc0200166 <__panic>
    assert((p0 = alloc_pages(2)) == p2 + 1);
ffffffffc02014fe:	00002697          	auipc	a3,0x2
ffffffffc0201502:	83a68693          	addi	a3,a3,-1990 # ffffffffc0202d38 <commands+0xb08>
ffffffffc0201506:	00001617          	auipc	a2,0x1
ffffffffc020150a:	53a60613          	addi	a2,a2,1338 # ffffffffc0202a40 <commands+0x810>
ffffffffc020150e:	11200593          	li	a1,274
ffffffffc0201512:	00001517          	auipc	a0,0x1
ffffffffc0201516:	54650513          	addi	a0,a0,1350 # ffffffffc0202a58 <commands+0x828>
ffffffffc020151a:	c4dfe0ef          	jal	ra,ffffffffc0200166 <__panic>
    assert((p0 = alloc_page()) == p2 - 1);
ffffffffc020151e:	00001697          	auipc	a3,0x1
ffffffffc0201522:	7fa68693          	addi	a3,a3,2042 # ffffffffc0202d18 <commands+0xae8>
ffffffffc0201526:	00001617          	auipc	a2,0x1
ffffffffc020152a:	51a60613          	addi	a2,a2,1306 # ffffffffc0202a40 <commands+0x810>
ffffffffc020152e:	11000593          	li	a1,272
ffffffffc0201532:	00001517          	auipc	a0,0x1
ffffffffc0201536:	52650513          	addi	a0,a0,1318 # ffffffffc0202a58 <commands+0x828>
ffffffffc020153a:	c2dfe0ef          	jal	ra,ffffffffc0200166 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
ffffffffc020153e:	00001697          	auipc	a3,0x1
ffffffffc0201542:	7b268693          	addi	a3,a3,1970 # ffffffffc0202cf0 <commands+0xac0>
ffffffffc0201546:	00001617          	auipc	a2,0x1
ffffffffc020154a:	4fa60613          	addi	a2,a2,1274 # ffffffffc0202a40 <commands+0x810>
ffffffffc020154e:	10e00593          	li	a1,270
ffffffffc0201552:	00001517          	auipc	a0,0x1
ffffffffc0201556:	50650513          	addi	a0,a0,1286 # ffffffffc0202a58 <commands+0x828>
ffffffffc020155a:	c0dfe0ef          	jal	ra,ffffffffc0200166 <__panic>
    assert(PageProperty(p0) && p0->property == 1);
ffffffffc020155e:	00001697          	auipc	a3,0x1
ffffffffc0201562:	76a68693          	addi	a3,a3,1898 # ffffffffc0202cc8 <commands+0xa98>
ffffffffc0201566:	00001617          	auipc	a2,0x1
ffffffffc020156a:	4da60613          	addi	a2,a2,1242 # ffffffffc0202a40 <commands+0x810>
ffffffffc020156e:	10d00593          	li	a1,269
ffffffffc0201572:	00001517          	auipc	a0,0x1
ffffffffc0201576:	4e650513          	addi	a0,a0,1254 # ffffffffc0202a58 <commands+0x828>
ffffffffc020157a:	bedfe0ef          	jal	ra,ffffffffc0200166 <__panic>
    assert(p0 + 2 == p1);
ffffffffc020157e:	00001697          	auipc	a3,0x1
ffffffffc0201582:	73a68693          	addi	a3,a3,1850 # ffffffffc0202cb8 <commands+0xa88>
ffffffffc0201586:	00001617          	auipc	a2,0x1
ffffffffc020158a:	4ba60613          	addi	a2,a2,1210 # ffffffffc0202a40 <commands+0x810>
ffffffffc020158e:	10800593          	li	a1,264
ffffffffc0201592:	00001517          	auipc	a0,0x1
ffffffffc0201596:	4c650513          	addi	a0,a0,1222 # ffffffffc0202a58 <commands+0x828>
ffffffffc020159a:	bcdfe0ef          	jal	ra,ffffffffc0200166 <__panic>
    assert(alloc_page() == NULL);
ffffffffc020159e:	00001697          	auipc	a3,0x1
ffffffffc02015a2:	61a68693          	addi	a3,a3,1562 # ffffffffc0202bb8 <commands+0x988>
ffffffffc02015a6:	00001617          	auipc	a2,0x1
ffffffffc02015aa:	49a60613          	addi	a2,a2,1178 # ffffffffc0202a40 <commands+0x810>
ffffffffc02015ae:	10700593          	li	a1,263
ffffffffc02015b2:	00001517          	auipc	a0,0x1
ffffffffc02015b6:	4a650513          	addi	a0,a0,1190 # ffffffffc0202a58 <commands+0x828>
ffffffffc02015ba:	badfe0ef          	jal	ra,ffffffffc0200166 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
ffffffffc02015be:	00001697          	auipc	a3,0x1
ffffffffc02015c2:	6da68693          	addi	a3,a3,1754 # ffffffffc0202c98 <commands+0xa68>
ffffffffc02015c6:	00001617          	auipc	a2,0x1
ffffffffc02015ca:	47a60613          	addi	a2,a2,1146 # ffffffffc0202a40 <commands+0x810>
ffffffffc02015ce:	10600593          	li	a1,262
ffffffffc02015d2:	00001517          	auipc	a0,0x1
ffffffffc02015d6:	48650513          	addi	a0,a0,1158 # ffffffffc0202a58 <commands+0x828>
ffffffffc02015da:	b8dfe0ef          	jal	ra,ffffffffc0200166 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
ffffffffc02015de:	00001697          	auipc	a3,0x1
ffffffffc02015e2:	68a68693          	addi	a3,a3,1674 # ffffffffc0202c68 <commands+0xa38>
ffffffffc02015e6:	00001617          	auipc	a2,0x1
ffffffffc02015ea:	45a60613          	addi	a2,a2,1114 # ffffffffc0202a40 <commands+0x810>
ffffffffc02015ee:	10500593          	li	a1,261
ffffffffc02015f2:	00001517          	auipc	a0,0x1
ffffffffc02015f6:	46650513          	addi	a0,a0,1126 # ffffffffc0202a58 <commands+0x828>
ffffffffc02015fa:	b6dfe0ef          	jal	ra,ffffffffc0200166 <__panic>
    assert(alloc_pages(4) == NULL);
ffffffffc02015fe:	00001697          	auipc	a3,0x1
ffffffffc0201602:	65268693          	addi	a3,a3,1618 # ffffffffc0202c50 <commands+0xa20>
ffffffffc0201606:	00001617          	auipc	a2,0x1
ffffffffc020160a:	43a60613          	addi	a2,a2,1082 # ffffffffc0202a40 <commands+0x810>
ffffffffc020160e:	10400593          	li	a1,260
ffffffffc0201612:	00001517          	auipc	a0,0x1
ffffffffc0201616:	44650513          	addi	a0,a0,1094 # ffffffffc0202a58 <commands+0x828>
ffffffffc020161a:	b4dfe0ef          	jal	ra,ffffffffc0200166 <__panic>
    assert(alloc_page() == NULL);
ffffffffc020161e:	00001697          	auipc	a3,0x1
ffffffffc0201622:	59a68693          	addi	a3,a3,1434 # ffffffffc0202bb8 <commands+0x988>
ffffffffc0201626:	00001617          	auipc	a2,0x1
ffffffffc020162a:	41a60613          	addi	a2,a2,1050 # ffffffffc0202a40 <commands+0x810>
ffffffffc020162e:	0fe00593          	li	a1,254
ffffffffc0201632:	00001517          	auipc	a0,0x1
ffffffffc0201636:	42650513          	addi	a0,a0,1062 # ffffffffc0202a58 <commands+0x828>
ffffffffc020163a:	b2dfe0ef          	jal	ra,ffffffffc0200166 <__panic>
    assert(!PageProperty(p0));
ffffffffc020163e:	00001697          	auipc	a3,0x1
ffffffffc0201642:	5fa68693          	addi	a3,a3,1530 # ffffffffc0202c38 <commands+0xa08>
ffffffffc0201646:	00001617          	auipc	a2,0x1
ffffffffc020164a:	3fa60613          	addi	a2,a2,1018 # ffffffffc0202a40 <commands+0x810>
ffffffffc020164e:	0f900593          	li	a1,249
ffffffffc0201652:	00001517          	auipc	a0,0x1
ffffffffc0201656:	40650513          	addi	a0,a0,1030 # ffffffffc0202a58 <commands+0x828>
ffffffffc020165a:	b0dfe0ef          	jal	ra,ffffffffc0200166 <__panic>
    assert((p0 = alloc_pages(5)) != NULL);
ffffffffc020165e:	00001697          	auipc	a3,0x1
ffffffffc0201662:	6fa68693          	addi	a3,a3,1786 # ffffffffc0202d58 <commands+0xb28>
ffffffffc0201666:	00001617          	auipc	a2,0x1
ffffffffc020166a:	3da60613          	addi	a2,a2,986 # ffffffffc0202a40 <commands+0x810>
ffffffffc020166e:	11700593          	li	a1,279
ffffffffc0201672:	00001517          	auipc	a0,0x1
ffffffffc0201676:	3e650513          	addi	a0,a0,998 # ffffffffc0202a58 <commands+0x828>
ffffffffc020167a:	aedfe0ef          	jal	ra,ffffffffc0200166 <__panic>
    assert(total == 0);
ffffffffc020167e:	00001697          	auipc	a3,0x1
ffffffffc0201682:	70a68693          	addi	a3,a3,1802 # ffffffffc0202d88 <commands+0xb58>
ffffffffc0201686:	00001617          	auipc	a2,0x1
ffffffffc020168a:	3ba60613          	addi	a2,a2,954 # ffffffffc0202a40 <commands+0x810>
ffffffffc020168e:	12600593          	li	a1,294
ffffffffc0201692:	00001517          	auipc	a0,0x1
ffffffffc0201696:	3c650513          	addi	a0,a0,966 # ffffffffc0202a58 <commands+0x828>
ffffffffc020169a:	acdfe0ef          	jal	ra,ffffffffc0200166 <__panic>
    assert(total == nr_free_pages());
ffffffffc020169e:	00001697          	auipc	a3,0x1
ffffffffc02016a2:	3d268693          	addi	a3,a3,978 # ffffffffc0202a70 <commands+0x840>
ffffffffc02016a6:	00001617          	auipc	a2,0x1
ffffffffc02016aa:	39a60613          	addi	a2,a2,922 # ffffffffc0202a40 <commands+0x810>
ffffffffc02016ae:	0f300593          	li	a1,243
ffffffffc02016b2:	00001517          	auipc	a0,0x1
ffffffffc02016b6:	3a650513          	addi	a0,a0,934 # ffffffffc0202a58 <commands+0x828>
ffffffffc02016ba:	aadfe0ef          	jal	ra,ffffffffc0200166 <__panic>
    assert((p1 = alloc_page()) != NULL);
ffffffffc02016be:	00001697          	auipc	a3,0x1
ffffffffc02016c2:	3f268693          	addi	a3,a3,1010 # ffffffffc0202ab0 <commands+0x880>
ffffffffc02016c6:	00001617          	auipc	a2,0x1
ffffffffc02016ca:	37a60613          	addi	a2,a2,890 # ffffffffc0202a40 <commands+0x810>
ffffffffc02016ce:	0ba00593          	li	a1,186
ffffffffc02016d2:	00001517          	auipc	a0,0x1
ffffffffc02016d6:	38650513          	addi	a0,a0,902 # ffffffffc0202a58 <commands+0x828>
ffffffffc02016da:	a8dfe0ef          	jal	ra,ffffffffc0200166 <__panic>

ffffffffc02016de <default_free_pages>:
default_free_pages(struct Page *base, size_t n) {
ffffffffc02016de:	1141                	addi	sp,sp,-16
ffffffffc02016e0:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc02016e2:	14058a63          	beqz	a1,ffffffffc0201836 <default_free_pages+0x158>
    for (; p != base + n; p ++) {
ffffffffc02016e6:	00259693          	slli	a3,a1,0x2
ffffffffc02016ea:	96ae                	add	a3,a3,a1
ffffffffc02016ec:	068e                	slli	a3,a3,0x3
ffffffffc02016ee:	96aa                	add	a3,a3,a0
ffffffffc02016f0:	87aa                	mv	a5,a0
ffffffffc02016f2:	02d50263          	beq	a0,a3,ffffffffc0201716 <default_free_pages+0x38>
ffffffffc02016f6:	6798                	ld	a4,8(a5)
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc02016f8:	8b05                	andi	a4,a4,1
ffffffffc02016fa:	10071e63          	bnez	a4,ffffffffc0201816 <default_free_pages+0x138>
ffffffffc02016fe:	6798                	ld	a4,8(a5)
ffffffffc0201700:	8b09                	andi	a4,a4,2
ffffffffc0201702:	10071a63          	bnez	a4,ffffffffc0201816 <default_free_pages+0x138>
        p->flags = 0;
ffffffffc0201706:	0007b423          	sd	zero,8(a5)
static inline void set_page_ref(struct Page *page, int val) { page->ref = val; }
ffffffffc020170a:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc020170e:	02878793          	addi	a5,a5,40
ffffffffc0201712:	fed792e3          	bne	a5,a3,ffffffffc02016f6 <default_free_pages+0x18>
    base->property = n;
ffffffffc0201716:	2581                	sext.w	a1,a1
ffffffffc0201718:	c90c                	sw	a1,16(a0)
    SetPageProperty(base);
ffffffffc020171a:	00850893          	addi	a7,a0,8
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc020171e:	4789                	li	a5,2
ffffffffc0201720:	40f8b02f          	amoor.d	zero,a5,(a7)
    nr_free += n;
ffffffffc0201724:	00006697          	auipc	a3,0x6
ffffffffc0201728:	90468693          	addi	a3,a3,-1788 # ffffffffc0207028 <free_area>
ffffffffc020172c:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc020172e:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc0201730:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc0201734:	9db9                	addw	a1,a1,a4
ffffffffc0201736:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list)) {
ffffffffc0201738:	0ad78863          	beq	a5,a3,ffffffffc02017e8 <default_free_pages+0x10a>
            struct Page* page = le2page(le, page_link);
ffffffffc020173c:	fe878713          	addi	a4,a5,-24
ffffffffc0201740:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list)) {
ffffffffc0201744:	4581                	li	a1,0
            if (base < page) {
ffffffffc0201746:	00e56a63          	bltu	a0,a4,ffffffffc020175a <default_free_pages+0x7c>
    return listelm->next;
ffffffffc020174a:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc020174c:	06d70263          	beq	a4,a3,ffffffffc02017b0 <default_free_pages+0xd2>
    for (; p != base + n; p ++) {
ffffffffc0201750:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc0201752:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc0201756:	fee57ae3          	bgeu	a0,a4,ffffffffc020174a <default_free_pages+0x6c>
ffffffffc020175a:	c199                	beqz	a1,ffffffffc0201760 <default_free_pages+0x82>
ffffffffc020175c:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc0201760:	6398                	ld	a4,0(a5)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
ffffffffc0201762:	e390                	sd	a2,0(a5)
ffffffffc0201764:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0201766:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201768:	ed18                	sd	a4,24(a0)
    if (le != &free_list) {
ffffffffc020176a:	02d70063          	beq	a4,a3,ffffffffc020178a <default_free_pages+0xac>
        if (p + p->property == base) {
ffffffffc020176e:	ff872803          	lw	a6,-8(a4) # fffffffffff7fff8 <end+0x3fd78b58>
        p = le2page(le, page_link);
ffffffffc0201772:	fe870593          	addi	a1,a4,-24
        if (p + p->property == base) {
ffffffffc0201776:	02081613          	slli	a2,a6,0x20
ffffffffc020177a:	9201                	srli	a2,a2,0x20
ffffffffc020177c:	00261793          	slli	a5,a2,0x2
ffffffffc0201780:	97b2                	add	a5,a5,a2
ffffffffc0201782:	078e                	slli	a5,a5,0x3
ffffffffc0201784:	97ae                	add	a5,a5,a1
ffffffffc0201786:	02f50f63          	beq	a0,a5,ffffffffc02017c4 <default_free_pages+0xe6>
    return listelm->next;
ffffffffc020178a:	7118                	ld	a4,32(a0)
    if (le != &free_list) {
ffffffffc020178c:	00d70f63          	beq	a4,a3,ffffffffc02017aa <default_free_pages+0xcc>
        if (base + base->property == p) {
ffffffffc0201790:	490c                	lw	a1,16(a0)
        p = le2page(le, page_link);
ffffffffc0201792:	fe870693          	addi	a3,a4,-24
        if (base + base->property == p) {
ffffffffc0201796:	02059613          	slli	a2,a1,0x20
ffffffffc020179a:	9201                	srli	a2,a2,0x20
ffffffffc020179c:	00261793          	slli	a5,a2,0x2
ffffffffc02017a0:	97b2                	add	a5,a5,a2
ffffffffc02017a2:	078e                	slli	a5,a5,0x3
ffffffffc02017a4:	97aa                	add	a5,a5,a0
ffffffffc02017a6:	04f68863          	beq	a3,a5,ffffffffc02017f6 <default_free_pages+0x118>
}
ffffffffc02017aa:	60a2                	ld	ra,8(sp)
ffffffffc02017ac:	0141                	addi	sp,sp,16
ffffffffc02017ae:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc02017b0:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc02017b2:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc02017b4:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc02017b6:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list) {
ffffffffc02017b8:	02d70563          	beq	a4,a3,ffffffffc02017e2 <default_free_pages+0x104>
    prev->next = next->prev = elm;
ffffffffc02017bc:	8832                	mv	a6,a2
ffffffffc02017be:	4585                	li	a1,1
    for (; p != base + n; p ++) {
ffffffffc02017c0:	87ba                	mv	a5,a4
ffffffffc02017c2:	bf41                	j	ffffffffc0201752 <default_free_pages+0x74>
            p->property += base->property;
ffffffffc02017c4:	491c                	lw	a5,16(a0)
ffffffffc02017c6:	0107883b          	addw	a6,a5,a6
ffffffffc02017ca:	ff072c23          	sw	a6,-8(a4)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc02017ce:	57f5                	li	a5,-3
ffffffffc02017d0:	60f8b02f          	amoand.d	zero,a5,(a7)
    __list_del(listelm->prev, listelm->next);
ffffffffc02017d4:	6d10                	ld	a2,24(a0)
ffffffffc02017d6:	711c                	ld	a5,32(a0)
            base = p;
ffffffffc02017d8:	852e                	mv	a0,a1
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
ffffffffc02017da:	e61c                	sd	a5,8(a2)
    return listelm->next;
ffffffffc02017dc:	6718                	ld	a4,8(a4)
    next->prev = prev;
ffffffffc02017de:	e390                	sd	a2,0(a5)
ffffffffc02017e0:	b775                	j	ffffffffc020178c <default_free_pages+0xae>
ffffffffc02017e2:	e290                	sd	a2,0(a3)
        while ((le = list_next(le)) != &free_list) {
ffffffffc02017e4:	873e                	mv	a4,a5
ffffffffc02017e6:	b761                	j	ffffffffc020176e <default_free_pages+0x90>
}
ffffffffc02017e8:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc02017ea:	e390                	sd	a2,0(a5)
ffffffffc02017ec:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc02017ee:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc02017f0:	ed1c                	sd	a5,24(a0)
ffffffffc02017f2:	0141                	addi	sp,sp,16
ffffffffc02017f4:	8082                	ret
            base->property += p->property;
ffffffffc02017f6:	ff872783          	lw	a5,-8(a4)
ffffffffc02017fa:	ff070693          	addi	a3,a4,-16
ffffffffc02017fe:	9dbd                	addw	a1,a1,a5
ffffffffc0201800:	c90c                	sw	a1,16(a0)
ffffffffc0201802:	57f5                	li	a5,-3
ffffffffc0201804:	60f6b02f          	amoand.d	zero,a5,(a3)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201808:	6314                	ld	a3,0(a4)
ffffffffc020180a:	671c                	ld	a5,8(a4)
}
ffffffffc020180c:	60a2                	ld	ra,8(sp)
    prev->next = next;
ffffffffc020180e:	e69c                	sd	a5,8(a3)
    next->prev = prev;
ffffffffc0201810:	e394                	sd	a3,0(a5)
ffffffffc0201812:	0141                	addi	sp,sp,16
ffffffffc0201814:	8082                	ret
        assert(!PageReserved(p) && !PageProperty(p));
ffffffffc0201816:	00001697          	auipc	a3,0x1
ffffffffc020181a:	58a68693          	addi	a3,a3,1418 # ffffffffc0202da0 <commands+0xb70>
ffffffffc020181e:	00001617          	auipc	a2,0x1
ffffffffc0201822:	22260613          	addi	a2,a2,546 # ffffffffc0202a40 <commands+0x810>
ffffffffc0201826:	08300593          	li	a1,131
ffffffffc020182a:	00001517          	auipc	a0,0x1
ffffffffc020182e:	22e50513          	addi	a0,a0,558 # ffffffffc0202a58 <commands+0x828>
ffffffffc0201832:	935fe0ef          	jal	ra,ffffffffc0200166 <__panic>
    assert(n > 0);
ffffffffc0201836:	00001697          	auipc	a3,0x1
ffffffffc020183a:	56268693          	addi	a3,a3,1378 # ffffffffc0202d98 <commands+0xb68>
ffffffffc020183e:	00001617          	auipc	a2,0x1
ffffffffc0201842:	20260613          	addi	a2,a2,514 # ffffffffc0202a40 <commands+0x810>
ffffffffc0201846:	08000593          	li	a1,128
ffffffffc020184a:	00001517          	auipc	a0,0x1
ffffffffc020184e:	20e50513          	addi	a0,a0,526 # ffffffffc0202a58 <commands+0x828>
ffffffffc0201852:	915fe0ef          	jal	ra,ffffffffc0200166 <__panic>

ffffffffc0201856 <default_alloc_pages>:
    assert(n > 0);
ffffffffc0201856:	c959                	beqz	a0,ffffffffc02018ec <default_alloc_pages+0x96>
    if (n > nr_free) {
ffffffffc0201858:	00005597          	auipc	a1,0x5
ffffffffc020185c:	7d058593          	addi	a1,a1,2000 # ffffffffc0207028 <free_area>
ffffffffc0201860:	0105a803          	lw	a6,16(a1)
ffffffffc0201864:	862a                	mv	a2,a0
ffffffffc0201866:	02081793          	slli	a5,a6,0x20
ffffffffc020186a:	9381                	srli	a5,a5,0x20
ffffffffc020186c:	00a7ee63          	bltu	a5,a0,ffffffffc0201888 <default_alloc_pages+0x32>
    list_entry_t *le = &free_list;
ffffffffc0201870:	87ae                	mv	a5,a1
ffffffffc0201872:	a801                	j	ffffffffc0201882 <default_alloc_pages+0x2c>
        if (p->property >= n) {
ffffffffc0201874:	ff87a703          	lw	a4,-8(a5)
ffffffffc0201878:	02071693          	slli	a3,a4,0x20
ffffffffc020187c:	9281                	srli	a3,a3,0x20
ffffffffc020187e:	00c6f763          	bgeu	a3,a2,ffffffffc020188c <default_alloc_pages+0x36>
    return listelm->next;
ffffffffc0201882:	679c                	ld	a5,8(a5)
    while ((le = list_next(le)) != &free_list) {
ffffffffc0201884:	feb798e3          	bne	a5,a1,ffffffffc0201874 <default_alloc_pages+0x1e>
        return NULL;
ffffffffc0201888:	4501                	li	a0,0
}
ffffffffc020188a:	8082                	ret
    return listelm->prev;
ffffffffc020188c:	0007b883          	ld	a7,0(a5)
    __list_del(listelm->prev, listelm->next);
ffffffffc0201890:	0087b303          	ld	t1,8(a5)
        struct Page *p = le2page(le, page_link);
ffffffffc0201894:	fe878513          	addi	a0,a5,-24
            p->property = page->property - n;
ffffffffc0201898:	00060e1b          	sext.w	t3,a2
    prev->next = next;
ffffffffc020189c:	0068b423          	sd	t1,8(a7) # fffffffffff80008 <end+0x3fd78b68>
    next->prev = prev;
ffffffffc02018a0:	01133023          	sd	a7,0(t1)
        if (page->property > n) {
ffffffffc02018a4:	02d67b63          	bgeu	a2,a3,ffffffffc02018da <default_alloc_pages+0x84>
            struct Page *p = page + n;
ffffffffc02018a8:	00261693          	slli	a3,a2,0x2
ffffffffc02018ac:	96b2                	add	a3,a3,a2
ffffffffc02018ae:	068e                	slli	a3,a3,0x3
ffffffffc02018b0:	96aa                	add	a3,a3,a0
            p->property = page->property - n;
ffffffffc02018b2:	41c7073b          	subw	a4,a4,t3
ffffffffc02018b6:	ca98                	sw	a4,16(a3)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc02018b8:	00868613          	addi	a2,a3,8
ffffffffc02018bc:	4709                	li	a4,2
ffffffffc02018be:	40e6302f          	amoor.d	zero,a4,(a2)
    __list_add(elm, listelm, listelm->next);
ffffffffc02018c2:	0088b703          	ld	a4,8(a7)
            list_add(prev, &(p->page_link));
ffffffffc02018c6:	01868613          	addi	a2,a3,24
        nr_free -= n;
ffffffffc02018ca:	0105a803          	lw	a6,16(a1)
    prev->next = next->prev = elm;
ffffffffc02018ce:	e310                	sd	a2,0(a4)
ffffffffc02018d0:	00c8b423          	sd	a2,8(a7)
    elm->next = next;
ffffffffc02018d4:	f298                	sd	a4,32(a3)
    elm->prev = prev;
ffffffffc02018d6:	0116bc23          	sd	a7,24(a3)
ffffffffc02018da:	41c8083b          	subw	a6,a6,t3
ffffffffc02018de:	0105a823          	sw	a6,16(a1)
    __op_bit(and, __NOT, nr, ((volatile unsigned long *)addr));
ffffffffc02018e2:	5775                	li	a4,-3
ffffffffc02018e4:	17c1                	addi	a5,a5,-16
ffffffffc02018e6:	60e7b02f          	amoand.d	zero,a4,(a5)
}
ffffffffc02018ea:	8082                	ret
default_alloc_pages(size_t n) {
ffffffffc02018ec:	1141                	addi	sp,sp,-16
    assert(n > 0);
ffffffffc02018ee:	00001697          	auipc	a3,0x1
ffffffffc02018f2:	4aa68693          	addi	a3,a3,1194 # ffffffffc0202d98 <commands+0xb68>
ffffffffc02018f6:	00001617          	auipc	a2,0x1
ffffffffc02018fa:	14a60613          	addi	a2,a2,330 # ffffffffc0202a40 <commands+0x810>
ffffffffc02018fe:	06200593          	li	a1,98
ffffffffc0201902:	00001517          	auipc	a0,0x1
ffffffffc0201906:	15650513          	addi	a0,a0,342 # ffffffffc0202a58 <commands+0x828>
default_alloc_pages(size_t n) {
ffffffffc020190a:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc020190c:	85bfe0ef          	jal	ra,ffffffffc0200166 <__panic>

ffffffffc0201910 <default_init_memmap>:
default_init_memmap(struct Page *base, size_t n) {
ffffffffc0201910:	1141                	addi	sp,sp,-16
ffffffffc0201912:	e406                	sd	ra,8(sp)
    assert(n > 0);
ffffffffc0201914:	c9e1                	beqz	a1,ffffffffc02019e4 <default_init_memmap+0xd4>
    for (; p != base + n; p ++) {
ffffffffc0201916:	00259693          	slli	a3,a1,0x2
ffffffffc020191a:	96ae                	add	a3,a3,a1
ffffffffc020191c:	068e                	slli	a3,a3,0x3
ffffffffc020191e:	96aa                	add	a3,a3,a0
ffffffffc0201920:	87aa                	mv	a5,a0
ffffffffc0201922:	00d50f63          	beq	a0,a3,ffffffffc0201940 <default_init_memmap+0x30>
    return (((*(volatile unsigned long *)addr) >> nr) & 1);
ffffffffc0201926:	6798                	ld	a4,8(a5)
        assert(PageReserved(p));
ffffffffc0201928:	8b05                	andi	a4,a4,1
ffffffffc020192a:	cf49                	beqz	a4,ffffffffc02019c4 <default_init_memmap+0xb4>
        p->flags = p->property = 0;
ffffffffc020192c:	0007a823          	sw	zero,16(a5)
ffffffffc0201930:	0007b423          	sd	zero,8(a5)
ffffffffc0201934:	0007a023          	sw	zero,0(a5)
    for (; p != base + n; p ++) {
ffffffffc0201938:	02878793          	addi	a5,a5,40
ffffffffc020193c:	fed795e3          	bne	a5,a3,ffffffffc0201926 <default_init_memmap+0x16>
    base->property = n;
ffffffffc0201940:	2581                	sext.w	a1,a1
ffffffffc0201942:	c90c                	sw	a1,16(a0)
    __op_bit(or, __NOP, nr, ((volatile unsigned long *)addr));
ffffffffc0201944:	4789                	li	a5,2
ffffffffc0201946:	00850713          	addi	a4,a0,8
ffffffffc020194a:	40f7302f          	amoor.d	zero,a5,(a4)
    nr_free += n;
ffffffffc020194e:	00005697          	auipc	a3,0x5
ffffffffc0201952:	6da68693          	addi	a3,a3,1754 # ffffffffc0207028 <free_area>
ffffffffc0201956:	4a98                	lw	a4,16(a3)
    return list->next == list;
ffffffffc0201958:	669c                	ld	a5,8(a3)
        list_add(&free_list, &(base->page_link));
ffffffffc020195a:	01850613          	addi	a2,a0,24
    nr_free += n;
ffffffffc020195e:	9db9                	addw	a1,a1,a4
ffffffffc0201960:	ca8c                	sw	a1,16(a3)
    if (list_empty(&free_list)) {
ffffffffc0201962:	04d78a63          	beq	a5,a3,ffffffffc02019b6 <default_init_memmap+0xa6>
            struct Page* page = le2page(le, page_link);
ffffffffc0201966:	fe878713          	addi	a4,a5,-24
ffffffffc020196a:	0006b803          	ld	a6,0(a3)
    if (list_empty(&free_list)) {
ffffffffc020196e:	4581                	li	a1,0
            if (base < page) {
ffffffffc0201970:	00e56a63          	bltu	a0,a4,ffffffffc0201984 <default_init_memmap+0x74>
    return listelm->next;
ffffffffc0201974:	6798                	ld	a4,8(a5)
            } else if (list_next(le) == &free_list) {
ffffffffc0201976:	02d70263          	beq	a4,a3,ffffffffc020199a <default_init_memmap+0x8a>
    for (; p != base + n; p ++) {
ffffffffc020197a:	87ba                	mv	a5,a4
            struct Page* page = le2page(le, page_link);
ffffffffc020197c:	fe878713          	addi	a4,a5,-24
            if (base < page) {
ffffffffc0201980:	fee57ae3          	bgeu	a0,a4,ffffffffc0201974 <default_init_memmap+0x64>
ffffffffc0201984:	c199                	beqz	a1,ffffffffc020198a <default_init_memmap+0x7a>
ffffffffc0201986:	0106b023          	sd	a6,0(a3)
    __list_add(elm, listelm->prev, listelm);
ffffffffc020198a:	6398                	ld	a4,0(a5)
}
ffffffffc020198c:	60a2                	ld	ra,8(sp)
    prev->next = next->prev = elm;
ffffffffc020198e:	e390                	sd	a2,0(a5)
ffffffffc0201990:	e710                	sd	a2,8(a4)
    elm->next = next;
ffffffffc0201992:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc0201994:	ed18                	sd	a4,24(a0)
ffffffffc0201996:	0141                	addi	sp,sp,16
ffffffffc0201998:	8082                	ret
    prev->next = next->prev = elm;
ffffffffc020199a:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc020199c:	f114                	sd	a3,32(a0)
    return listelm->next;
ffffffffc020199e:	6798                	ld	a4,8(a5)
    elm->prev = prev;
ffffffffc02019a0:	ed1c                	sd	a5,24(a0)
        while ((le = list_next(le)) != &free_list) {
ffffffffc02019a2:	00d70663          	beq	a4,a3,ffffffffc02019ae <default_init_memmap+0x9e>
    prev->next = next->prev = elm;
ffffffffc02019a6:	8832                	mv	a6,a2
ffffffffc02019a8:	4585                	li	a1,1
    for (; p != base + n; p ++) {
ffffffffc02019aa:	87ba                	mv	a5,a4
ffffffffc02019ac:	bfc1                	j	ffffffffc020197c <default_init_memmap+0x6c>
}
ffffffffc02019ae:	60a2                	ld	ra,8(sp)
ffffffffc02019b0:	e290                	sd	a2,0(a3)
ffffffffc02019b2:	0141                	addi	sp,sp,16
ffffffffc02019b4:	8082                	ret
ffffffffc02019b6:	60a2                	ld	ra,8(sp)
ffffffffc02019b8:	e390                	sd	a2,0(a5)
ffffffffc02019ba:	e790                	sd	a2,8(a5)
    elm->next = next;
ffffffffc02019bc:	f11c                	sd	a5,32(a0)
    elm->prev = prev;
ffffffffc02019be:	ed1c                	sd	a5,24(a0)
ffffffffc02019c0:	0141                	addi	sp,sp,16
ffffffffc02019c2:	8082                	ret
        assert(PageReserved(p));
ffffffffc02019c4:	00001697          	auipc	a3,0x1
ffffffffc02019c8:	40468693          	addi	a3,a3,1028 # ffffffffc0202dc8 <commands+0xb98>
ffffffffc02019cc:	00001617          	auipc	a2,0x1
ffffffffc02019d0:	07460613          	addi	a2,a2,116 # ffffffffc0202a40 <commands+0x810>
ffffffffc02019d4:	04900593          	li	a1,73
ffffffffc02019d8:	00001517          	auipc	a0,0x1
ffffffffc02019dc:	08050513          	addi	a0,a0,128 # ffffffffc0202a58 <commands+0x828>
ffffffffc02019e0:	f86fe0ef          	jal	ra,ffffffffc0200166 <__panic>
    assert(n > 0);
ffffffffc02019e4:	00001697          	auipc	a3,0x1
ffffffffc02019e8:	3b468693          	addi	a3,a3,948 # ffffffffc0202d98 <commands+0xb68>
ffffffffc02019ec:	00001617          	auipc	a2,0x1
ffffffffc02019f0:	05460613          	addi	a2,a2,84 # ffffffffc0202a40 <commands+0x810>
ffffffffc02019f4:	04600593          	li	a1,70
ffffffffc02019f8:	00001517          	auipc	a0,0x1
ffffffffc02019fc:	06050513          	addi	a0,a0,96 # ffffffffc0202a58 <commands+0x828>
ffffffffc0201a00:	f66fe0ef          	jal	ra,ffffffffc0200166 <__panic>

ffffffffc0201a04 <strlen>:
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
ffffffffc0201a04:	00054783          	lbu	a5,0(a0)
strlen(const char *s) {
ffffffffc0201a08:	872a                	mv	a4,a0
    size_t cnt = 0;
ffffffffc0201a0a:	4501                	li	a0,0
    while (*s ++ != '\0') {
ffffffffc0201a0c:	cb81                	beqz	a5,ffffffffc0201a1c <strlen+0x18>
        cnt ++;
ffffffffc0201a0e:	0505                	addi	a0,a0,1
    while (*s ++ != '\0') {
ffffffffc0201a10:	00a707b3          	add	a5,a4,a0
ffffffffc0201a14:	0007c783          	lbu	a5,0(a5)
ffffffffc0201a18:	fbfd                	bnez	a5,ffffffffc0201a0e <strlen+0xa>
ffffffffc0201a1a:	8082                	ret
    }
    return cnt;
}
ffffffffc0201a1c:	8082                	ret

ffffffffc0201a1e <strnlen>:
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
ffffffffc0201a1e:	4781                	li	a5,0
    while (cnt < len && *s ++ != '\0') {
ffffffffc0201a20:	e589                	bnez	a1,ffffffffc0201a2a <strnlen+0xc>
ffffffffc0201a22:	a811                	j	ffffffffc0201a36 <strnlen+0x18>
        cnt ++;
ffffffffc0201a24:	0785                	addi	a5,a5,1
    while (cnt < len && *s ++ != '\0') {
ffffffffc0201a26:	00f58863          	beq	a1,a5,ffffffffc0201a36 <strnlen+0x18>
ffffffffc0201a2a:	00f50733          	add	a4,a0,a5
ffffffffc0201a2e:	00074703          	lbu	a4,0(a4)
ffffffffc0201a32:	fb6d                	bnez	a4,ffffffffc0201a24 <strnlen+0x6>
ffffffffc0201a34:	85be                	mv	a1,a5
    }
    return cnt;
}
ffffffffc0201a36:	852e                	mv	a0,a1
ffffffffc0201a38:	8082                	ret

ffffffffc0201a3a <strcmp>:
int
strcmp(const char *s1, const char *s2) {
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
#else
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0201a3a:	00054783          	lbu	a5,0(a0)
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201a3e:	0005c703          	lbu	a4,0(a1)
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0201a42:	cb89                	beqz	a5,ffffffffc0201a54 <strcmp+0x1a>
        s1 ++, s2 ++;
ffffffffc0201a44:	0505                	addi	a0,a0,1
ffffffffc0201a46:	0585                	addi	a1,a1,1
    while (*s1 != '\0' && *s1 == *s2) {
ffffffffc0201a48:	fee789e3          	beq	a5,a4,ffffffffc0201a3a <strcmp>
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201a4c:	0007851b          	sext.w	a0,a5
#endif /* __HAVE_ARCH_STRCMP */
}
ffffffffc0201a50:	9d19                	subw	a0,a0,a4
ffffffffc0201a52:	8082                	ret
ffffffffc0201a54:	4501                	li	a0,0
ffffffffc0201a56:	bfed                	j	ffffffffc0201a50 <strcmp+0x16>

ffffffffc0201a58 <strncmp>:
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0201a58:	c20d                	beqz	a2,ffffffffc0201a7a <strncmp+0x22>
ffffffffc0201a5a:	962e                	add	a2,a2,a1
ffffffffc0201a5c:	a031                	j	ffffffffc0201a68 <strncmp+0x10>
        n --, s1 ++, s2 ++;
ffffffffc0201a5e:	0505                	addi	a0,a0,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0201a60:	00e79a63          	bne	a5,a4,ffffffffc0201a74 <strncmp+0x1c>
ffffffffc0201a64:	00b60b63          	beq	a2,a1,ffffffffc0201a7a <strncmp+0x22>
ffffffffc0201a68:	00054783          	lbu	a5,0(a0)
        n --, s1 ++, s2 ++;
ffffffffc0201a6c:	0585                	addi	a1,a1,1
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
ffffffffc0201a6e:	fff5c703          	lbu	a4,-1(a1)
ffffffffc0201a72:	f7f5                	bnez	a5,ffffffffc0201a5e <strncmp+0x6>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201a74:	40e7853b          	subw	a0,a5,a4
}
ffffffffc0201a78:	8082                	ret
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
ffffffffc0201a7a:	4501                	li	a0,0
ffffffffc0201a7c:	8082                	ret

ffffffffc0201a7e <strchr>:
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
ffffffffc0201a7e:	00054783          	lbu	a5,0(a0)
ffffffffc0201a82:	c799                	beqz	a5,ffffffffc0201a90 <strchr+0x12>
        if (*s == c) {
ffffffffc0201a84:	00f58763          	beq	a1,a5,ffffffffc0201a92 <strchr+0x14>
    while (*s != '\0') {
ffffffffc0201a88:	00154783          	lbu	a5,1(a0)
            return (char *)s;
        }
        s ++;
ffffffffc0201a8c:	0505                	addi	a0,a0,1
    while (*s != '\0') {
ffffffffc0201a8e:	fbfd                	bnez	a5,ffffffffc0201a84 <strchr+0x6>
    }
    return NULL;
ffffffffc0201a90:	4501                	li	a0,0
}
ffffffffc0201a92:	8082                	ret

ffffffffc0201a94 <memset>:
memset(void *s, char c, size_t n) {
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
#else
    char *p = s;
    while (n -- > 0) {
ffffffffc0201a94:	ca01                	beqz	a2,ffffffffc0201aa4 <memset+0x10>
ffffffffc0201a96:	962a                	add	a2,a2,a0
    char *p = s;
ffffffffc0201a98:	87aa                	mv	a5,a0
        *p ++ = c;
ffffffffc0201a9a:	0785                	addi	a5,a5,1
ffffffffc0201a9c:	feb78fa3          	sb	a1,-1(a5)
    while (n -- > 0) {
ffffffffc0201aa0:	fec79de3          	bne	a5,a2,ffffffffc0201a9a <memset+0x6>
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
ffffffffc0201aa4:	8082                	ret

ffffffffc0201aa6 <printnum>:
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
    unsigned long long result = num;
    unsigned mod = do_div(result, base);
ffffffffc0201aa6:	02069813          	slli	a6,a3,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0201aaa:	7179                	addi	sp,sp,-48
    unsigned mod = do_div(result, base);
ffffffffc0201aac:	02085813          	srli	a6,a6,0x20
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0201ab0:	e052                	sd	s4,0(sp)
    unsigned mod = do_div(result, base);
ffffffffc0201ab2:	03067a33          	remu	s4,a2,a6
        unsigned long long num, unsigned base, int width, int padc) {
ffffffffc0201ab6:	f022                	sd	s0,32(sp)
ffffffffc0201ab8:	ec26                	sd	s1,24(sp)
ffffffffc0201aba:	e84a                	sd	s2,16(sp)
ffffffffc0201abc:	f406                	sd	ra,40(sp)
ffffffffc0201abe:	e44e                	sd	s3,8(sp)
ffffffffc0201ac0:	84aa                	mv	s1,a0
ffffffffc0201ac2:	892e                	mv	s2,a1
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
ffffffffc0201ac4:	fff7041b          	addiw	s0,a4,-1
    unsigned mod = do_div(result, base);
ffffffffc0201ac8:	2a01                	sext.w	s4,s4
    if (num >= base) {
ffffffffc0201aca:	03067e63          	bgeu	a2,a6,ffffffffc0201b06 <printnum+0x60>
ffffffffc0201ace:	89be                	mv	s3,a5
        while (-- width > 0)
ffffffffc0201ad0:	00805763          	blez	s0,ffffffffc0201ade <printnum+0x38>
ffffffffc0201ad4:	347d                	addiw	s0,s0,-1
            putch(padc, putdat);
ffffffffc0201ad6:	85ca                	mv	a1,s2
ffffffffc0201ad8:	854e                	mv	a0,s3
ffffffffc0201ada:	9482                	jalr	s1
        while (-- width > 0)
ffffffffc0201adc:	fc65                	bnez	s0,ffffffffc0201ad4 <printnum+0x2e>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201ade:	1a02                	slli	s4,s4,0x20
ffffffffc0201ae0:	00001797          	auipc	a5,0x1
ffffffffc0201ae4:	34878793          	addi	a5,a5,840 # ffffffffc0202e28 <default_pmm_manager+0x38>
ffffffffc0201ae8:	020a5a13          	srli	s4,s4,0x20
ffffffffc0201aec:	9a3e                	add	s4,s4,a5
}
ffffffffc0201aee:	7402                	ld	s0,32(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201af0:	000a4503          	lbu	a0,0(s4)
}
ffffffffc0201af4:	70a2                	ld	ra,40(sp)
ffffffffc0201af6:	69a2                	ld	s3,8(sp)
ffffffffc0201af8:	6a02                	ld	s4,0(sp)
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201afa:	85ca                	mv	a1,s2
ffffffffc0201afc:	87a6                	mv	a5,s1
}
ffffffffc0201afe:	6942                	ld	s2,16(sp)
ffffffffc0201b00:	64e2                	ld	s1,24(sp)
ffffffffc0201b02:	6145                	addi	sp,sp,48
    putch("0123456789abcdef"[mod], putdat);
ffffffffc0201b04:	8782                	jr	a5
        printnum(putch, putdat, result, base, width - 1, padc);
ffffffffc0201b06:	03065633          	divu	a2,a2,a6
ffffffffc0201b0a:	8722                	mv	a4,s0
ffffffffc0201b0c:	f9bff0ef          	jal	ra,ffffffffc0201aa6 <printnum>
ffffffffc0201b10:	b7f9                	j	ffffffffc0201ade <printnum+0x38>

ffffffffc0201b12 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
ffffffffc0201b12:	7119                	addi	sp,sp,-128
ffffffffc0201b14:	f4a6                	sd	s1,104(sp)
ffffffffc0201b16:	f0ca                	sd	s2,96(sp)
ffffffffc0201b18:	ecce                	sd	s3,88(sp)
ffffffffc0201b1a:	e8d2                	sd	s4,80(sp)
ffffffffc0201b1c:	e4d6                	sd	s5,72(sp)
ffffffffc0201b1e:	e0da                	sd	s6,64(sp)
ffffffffc0201b20:	fc5e                	sd	s7,56(sp)
ffffffffc0201b22:	f06a                	sd	s10,32(sp)
ffffffffc0201b24:	fc86                	sd	ra,120(sp)
ffffffffc0201b26:	f8a2                	sd	s0,112(sp)
ffffffffc0201b28:	f862                	sd	s8,48(sp)
ffffffffc0201b2a:	f466                	sd	s9,40(sp)
ffffffffc0201b2c:	ec6e                	sd	s11,24(sp)
ffffffffc0201b2e:	892a                	mv	s2,a0
ffffffffc0201b30:	84ae                	mv	s1,a1
ffffffffc0201b32:	8d32                	mv	s10,a2
ffffffffc0201b34:	8a36                	mv	s4,a3
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0201b36:	02500993          	li	s3,37
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
        width = precision = -1;
ffffffffc0201b3a:	5b7d                	li	s6,-1
ffffffffc0201b3c:	00001a97          	auipc	s5,0x1
ffffffffc0201b40:	320a8a93          	addi	s5,s5,800 # ffffffffc0202e5c <default_pmm_manager+0x6c>
        case 'e':
            err = va_arg(ap, int);
            if (err < 0) {
                err = -err;
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0201b44:	00001b97          	auipc	s7,0x1
ffffffffc0201b48:	4f4b8b93          	addi	s7,s7,1268 # ffffffffc0203038 <error_string>
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0201b4c:	000d4503          	lbu	a0,0(s10)
ffffffffc0201b50:	001d0413          	addi	s0,s10,1
ffffffffc0201b54:	01350a63          	beq	a0,s3,ffffffffc0201b68 <vprintfmt+0x56>
            if (ch == '\0') {
ffffffffc0201b58:	c121                	beqz	a0,ffffffffc0201b98 <vprintfmt+0x86>
            putch(ch, putdat);
ffffffffc0201b5a:	85a6                	mv	a1,s1
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0201b5c:	0405                	addi	s0,s0,1
            putch(ch, putdat);
ffffffffc0201b5e:	9902                	jalr	s2
        while ((ch = *(unsigned char *)fmt ++) != '%') {
ffffffffc0201b60:	fff44503          	lbu	a0,-1(s0)
ffffffffc0201b64:	ff351ae3          	bne	a0,s3,ffffffffc0201b58 <vprintfmt+0x46>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201b68:	00044603          	lbu	a2,0(s0)
        char padc = ' ';
ffffffffc0201b6c:	02000793          	li	a5,32
        lflag = altflag = 0;
ffffffffc0201b70:	4c81                	li	s9,0
ffffffffc0201b72:	4881                	li	a7,0
        width = precision = -1;
ffffffffc0201b74:	5c7d                	li	s8,-1
ffffffffc0201b76:	5dfd                	li	s11,-1
ffffffffc0201b78:	05500513          	li	a0,85
                if (ch < '0' || ch > '9') {
ffffffffc0201b7c:	4825                	li	a6,9
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201b7e:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0201b82:	0ff5f593          	zext.b	a1,a1
ffffffffc0201b86:	00140d13          	addi	s10,s0,1
ffffffffc0201b8a:	04b56263          	bltu	a0,a1,ffffffffc0201bce <vprintfmt+0xbc>
ffffffffc0201b8e:	058a                	slli	a1,a1,0x2
ffffffffc0201b90:	95d6                	add	a1,a1,s5
ffffffffc0201b92:	4194                	lw	a3,0(a1)
ffffffffc0201b94:	96d6                	add	a3,a3,s5
ffffffffc0201b96:	8682                	jr	a3
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
ffffffffc0201b98:	70e6                	ld	ra,120(sp)
ffffffffc0201b9a:	7446                	ld	s0,112(sp)
ffffffffc0201b9c:	74a6                	ld	s1,104(sp)
ffffffffc0201b9e:	7906                	ld	s2,96(sp)
ffffffffc0201ba0:	69e6                	ld	s3,88(sp)
ffffffffc0201ba2:	6a46                	ld	s4,80(sp)
ffffffffc0201ba4:	6aa6                	ld	s5,72(sp)
ffffffffc0201ba6:	6b06                	ld	s6,64(sp)
ffffffffc0201ba8:	7be2                	ld	s7,56(sp)
ffffffffc0201baa:	7c42                	ld	s8,48(sp)
ffffffffc0201bac:	7ca2                	ld	s9,40(sp)
ffffffffc0201bae:	7d02                	ld	s10,32(sp)
ffffffffc0201bb0:	6de2                	ld	s11,24(sp)
ffffffffc0201bb2:	6109                	addi	sp,sp,128
ffffffffc0201bb4:	8082                	ret
            padc = '0';
ffffffffc0201bb6:	87b2                	mv	a5,a2
            goto reswitch;
ffffffffc0201bb8:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201bbc:	846a                	mv	s0,s10
ffffffffc0201bbe:	00140d13          	addi	s10,s0,1
ffffffffc0201bc2:	fdd6059b          	addiw	a1,a2,-35
ffffffffc0201bc6:	0ff5f593          	zext.b	a1,a1
ffffffffc0201bca:	fcb572e3          	bgeu	a0,a1,ffffffffc0201b8e <vprintfmt+0x7c>
            putch('%', putdat);
ffffffffc0201bce:	85a6                	mv	a1,s1
ffffffffc0201bd0:	02500513          	li	a0,37
ffffffffc0201bd4:	9902                	jalr	s2
            for (fmt --; fmt[-1] != '%'; fmt --)
ffffffffc0201bd6:	fff44783          	lbu	a5,-1(s0)
ffffffffc0201bda:	8d22                	mv	s10,s0
ffffffffc0201bdc:	f73788e3          	beq	a5,s3,ffffffffc0201b4c <vprintfmt+0x3a>
ffffffffc0201be0:	ffed4783          	lbu	a5,-2(s10)
ffffffffc0201be4:	1d7d                	addi	s10,s10,-1
ffffffffc0201be6:	ff379de3          	bne	a5,s3,ffffffffc0201be0 <vprintfmt+0xce>
ffffffffc0201bea:	b78d                	j	ffffffffc0201b4c <vprintfmt+0x3a>
                precision = precision * 10 + ch - '0';
ffffffffc0201bec:	fd060c1b          	addiw	s8,a2,-48
                ch = *fmt;
ffffffffc0201bf0:	00144603          	lbu	a2,1(s0)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201bf4:	846a                	mv	s0,s10
                if (ch < '0' || ch > '9') {
ffffffffc0201bf6:	fd06069b          	addiw	a3,a2,-48
                ch = *fmt;
ffffffffc0201bfa:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc0201bfe:	02d86463          	bltu	a6,a3,ffffffffc0201c26 <vprintfmt+0x114>
                ch = *fmt;
ffffffffc0201c02:	00144603          	lbu	a2,1(s0)
                precision = precision * 10 + ch - '0';
ffffffffc0201c06:	002c169b          	slliw	a3,s8,0x2
ffffffffc0201c0a:	0186873b          	addw	a4,a3,s8
ffffffffc0201c0e:	0017171b          	slliw	a4,a4,0x1
ffffffffc0201c12:	9f2d                	addw	a4,a4,a1
                if (ch < '0' || ch > '9') {
ffffffffc0201c14:	fd06069b          	addiw	a3,a2,-48
            for (precision = 0; ; ++ fmt) {
ffffffffc0201c18:	0405                	addi	s0,s0,1
                precision = precision * 10 + ch - '0';
ffffffffc0201c1a:	fd070c1b          	addiw	s8,a4,-48
                ch = *fmt;
ffffffffc0201c1e:	0006059b          	sext.w	a1,a2
                if (ch < '0' || ch > '9') {
ffffffffc0201c22:	fed870e3          	bgeu	a6,a3,ffffffffc0201c02 <vprintfmt+0xf0>
            if (width < 0)
ffffffffc0201c26:	f40ddce3          	bgez	s11,ffffffffc0201b7e <vprintfmt+0x6c>
                width = precision, precision = -1;
ffffffffc0201c2a:	8de2                	mv	s11,s8
ffffffffc0201c2c:	5c7d                	li	s8,-1
ffffffffc0201c2e:	bf81                	j	ffffffffc0201b7e <vprintfmt+0x6c>
            if (width < 0)
ffffffffc0201c30:	fffdc693          	not	a3,s11
ffffffffc0201c34:	96fd                	srai	a3,a3,0x3f
ffffffffc0201c36:	00ddfdb3          	and	s11,s11,a3
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201c3a:	00144603          	lbu	a2,1(s0)
ffffffffc0201c3e:	2d81                	sext.w	s11,s11
ffffffffc0201c40:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0201c42:	bf35                	j	ffffffffc0201b7e <vprintfmt+0x6c>
            precision = va_arg(ap, int);
ffffffffc0201c44:	000a2c03          	lw	s8,0(s4)
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201c48:	00144603          	lbu	a2,1(s0)
            precision = va_arg(ap, int);
ffffffffc0201c4c:	0a21                	addi	s4,s4,8
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201c4e:	846a                	mv	s0,s10
            goto process_precision;
ffffffffc0201c50:	bfd9                	j	ffffffffc0201c26 <vprintfmt+0x114>
    if (lflag >= 2) {
ffffffffc0201c52:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201c54:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0201c58:	01174463          	blt	a4,a7,ffffffffc0201c60 <vprintfmt+0x14e>
    else if (lflag) {
ffffffffc0201c5c:	1a088e63          	beqz	a7,ffffffffc0201e18 <vprintfmt+0x306>
        return va_arg(*ap, unsigned long);
ffffffffc0201c60:	000a3603          	ld	a2,0(s4)
ffffffffc0201c64:	46c1                	li	a3,16
ffffffffc0201c66:	8a2e                	mv	s4,a1
            printnum(putch, putdat, num, base, width, padc);
ffffffffc0201c68:	2781                	sext.w	a5,a5
ffffffffc0201c6a:	876e                	mv	a4,s11
ffffffffc0201c6c:	85a6                	mv	a1,s1
ffffffffc0201c6e:	854a                	mv	a0,s2
ffffffffc0201c70:	e37ff0ef          	jal	ra,ffffffffc0201aa6 <printnum>
            break;
ffffffffc0201c74:	bde1                	j	ffffffffc0201b4c <vprintfmt+0x3a>
            putch(va_arg(ap, int), putdat);
ffffffffc0201c76:	000a2503          	lw	a0,0(s4)
ffffffffc0201c7a:	85a6                	mv	a1,s1
ffffffffc0201c7c:	0a21                	addi	s4,s4,8
ffffffffc0201c7e:	9902                	jalr	s2
            break;
ffffffffc0201c80:	b5f1                	j	ffffffffc0201b4c <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0201c82:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201c84:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0201c88:	01174463          	blt	a4,a7,ffffffffc0201c90 <vprintfmt+0x17e>
    else if (lflag) {
ffffffffc0201c8c:	18088163          	beqz	a7,ffffffffc0201e0e <vprintfmt+0x2fc>
        return va_arg(*ap, unsigned long);
ffffffffc0201c90:	000a3603          	ld	a2,0(s4)
ffffffffc0201c94:	46a9                	li	a3,10
ffffffffc0201c96:	8a2e                	mv	s4,a1
ffffffffc0201c98:	bfc1                	j	ffffffffc0201c68 <vprintfmt+0x156>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201c9a:	00144603          	lbu	a2,1(s0)
            altflag = 1;
ffffffffc0201c9e:	4c85                	li	s9,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201ca0:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0201ca2:	bdf1                	j	ffffffffc0201b7e <vprintfmt+0x6c>
            putch(ch, putdat);
ffffffffc0201ca4:	85a6                	mv	a1,s1
ffffffffc0201ca6:	02500513          	li	a0,37
ffffffffc0201caa:	9902                	jalr	s2
            break;
ffffffffc0201cac:	b545                	j	ffffffffc0201b4c <vprintfmt+0x3a>
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201cae:	00144603          	lbu	a2,1(s0)
            lflag ++;
ffffffffc0201cb2:	2885                	addiw	a7,a7,1
        switch (ch = *(unsigned char *)fmt ++) {
ffffffffc0201cb4:	846a                	mv	s0,s10
            goto reswitch;
ffffffffc0201cb6:	b5e1                	j	ffffffffc0201b7e <vprintfmt+0x6c>
    if (lflag >= 2) {
ffffffffc0201cb8:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201cba:	008a0593          	addi	a1,s4,8
    if (lflag >= 2) {
ffffffffc0201cbe:	01174463          	blt	a4,a7,ffffffffc0201cc6 <vprintfmt+0x1b4>
    else if (lflag) {
ffffffffc0201cc2:	14088163          	beqz	a7,ffffffffc0201e04 <vprintfmt+0x2f2>
        return va_arg(*ap, unsigned long);
ffffffffc0201cc6:	000a3603          	ld	a2,0(s4)
ffffffffc0201cca:	46a1                	li	a3,8
ffffffffc0201ccc:	8a2e                	mv	s4,a1
ffffffffc0201cce:	bf69                	j	ffffffffc0201c68 <vprintfmt+0x156>
            putch('0', putdat);
ffffffffc0201cd0:	03000513          	li	a0,48
ffffffffc0201cd4:	85a6                	mv	a1,s1
ffffffffc0201cd6:	e03e                	sd	a5,0(sp)
ffffffffc0201cd8:	9902                	jalr	s2
            putch('x', putdat);
ffffffffc0201cda:	85a6                	mv	a1,s1
ffffffffc0201cdc:	07800513          	li	a0,120
ffffffffc0201ce0:	9902                	jalr	s2
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0201ce2:	0a21                	addi	s4,s4,8
            goto number;
ffffffffc0201ce4:	6782                	ld	a5,0(sp)
ffffffffc0201ce6:	46c1                	li	a3,16
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
ffffffffc0201ce8:	ff8a3603          	ld	a2,-8(s4)
            goto number;
ffffffffc0201cec:	bfb5                	j	ffffffffc0201c68 <vprintfmt+0x156>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0201cee:	000a3403          	ld	s0,0(s4)
ffffffffc0201cf2:	008a0713          	addi	a4,s4,8
ffffffffc0201cf6:	e03a                	sd	a4,0(sp)
ffffffffc0201cf8:	14040263          	beqz	s0,ffffffffc0201e3c <vprintfmt+0x32a>
            if (width > 0 && padc != '-') {
ffffffffc0201cfc:	0fb05763          	blez	s11,ffffffffc0201dea <vprintfmt+0x2d8>
ffffffffc0201d00:	02d00693          	li	a3,45
ffffffffc0201d04:	0cd79163          	bne	a5,a3,ffffffffc0201dc6 <vprintfmt+0x2b4>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201d08:	00044783          	lbu	a5,0(s0)
ffffffffc0201d0c:	0007851b          	sext.w	a0,a5
ffffffffc0201d10:	cf85                	beqz	a5,ffffffffc0201d48 <vprintfmt+0x236>
ffffffffc0201d12:	00140a13          	addi	s4,s0,1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201d16:	05e00413          	li	s0,94
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201d1a:	000c4563          	bltz	s8,ffffffffc0201d24 <vprintfmt+0x212>
ffffffffc0201d1e:	3c7d                	addiw	s8,s8,-1
ffffffffc0201d20:	036c0263          	beq	s8,s6,ffffffffc0201d44 <vprintfmt+0x232>
                    putch('?', putdat);
ffffffffc0201d24:	85a6                	mv	a1,s1
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201d26:	0e0c8e63          	beqz	s9,ffffffffc0201e22 <vprintfmt+0x310>
ffffffffc0201d2a:	3781                	addiw	a5,a5,-32
ffffffffc0201d2c:	0ef47b63          	bgeu	s0,a5,ffffffffc0201e22 <vprintfmt+0x310>
                    putch('?', putdat);
ffffffffc0201d30:	03f00513          	li	a0,63
ffffffffc0201d34:	9902                	jalr	s2
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201d36:	000a4783          	lbu	a5,0(s4)
ffffffffc0201d3a:	3dfd                	addiw	s11,s11,-1
ffffffffc0201d3c:	0a05                	addi	s4,s4,1
ffffffffc0201d3e:	0007851b          	sext.w	a0,a5
ffffffffc0201d42:	ffe1                	bnez	a5,ffffffffc0201d1a <vprintfmt+0x208>
            for (; width > 0; width --) {
ffffffffc0201d44:	01b05963          	blez	s11,ffffffffc0201d56 <vprintfmt+0x244>
ffffffffc0201d48:	3dfd                	addiw	s11,s11,-1
                putch(' ', putdat);
ffffffffc0201d4a:	85a6                	mv	a1,s1
ffffffffc0201d4c:	02000513          	li	a0,32
ffffffffc0201d50:	9902                	jalr	s2
            for (; width > 0; width --) {
ffffffffc0201d52:	fe0d9be3          	bnez	s11,ffffffffc0201d48 <vprintfmt+0x236>
            if ((p = va_arg(ap, char *)) == NULL) {
ffffffffc0201d56:	6a02                	ld	s4,0(sp)
ffffffffc0201d58:	bbd5                	j	ffffffffc0201b4c <vprintfmt+0x3a>
    if (lflag >= 2) {
ffffffffc0201d5a:	4705                	li	a4,1
            precision = va_arg(ap, int);
ffffffffc0201d5c:	008a0c93          	addi	s9,s4,8
    if (lflag >= 2) {
ffffffffc0201d60:	01174463          	blt	a4,a7,ffffffffc0201d68 <vprintfmt+0x256>
    else if (lflag) {
ffffffffc0201d64:	08088d63          	beqz	a7,ffffffffc0201dfe <vprintfmt+0x2ec>
        return va_arg(*ap, long);
ffffffffc0201d68:	000a3403          	ld	s0,0(s4)
            if ((long long)num < 0) {
ffffffffc0201d6c:	0a044d63          	bltz	s0,ffffffffc0201e26 <vprintfmt+0x314>
            num = getint(&ap, lflag);
ffffffffc0201d70:	8622                	mv	a2,s0
ffffffffc0201d72:	8a66                	mv	s4,s9
ffffffffc0201d74:	46a9                	li	a3,10
ffffffffc0201d76:	bdcd                	j	ffffffffc0201c68 <vprintfmt+0x156>
            err = va_arg(ap, int);
ffffffffc0201d78:	000a2783          	lw	a5,0(s4)
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0201d7c:	4719                	li	a4,6
            err = va_arg(ap, int);
ffffffffc0201d7e:	0a21                	addi	s4,s4,8
            if (err < 0) {
ffffffffc0201d80:	41f7d69b          	sraiw	a3,a5,0x1f
ffffffffc0201d84:	8fb5                	xor	a5,a5,a3
ffffffffc0201d86:	40d786bb          	subw	a3,a5,a3
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
ffffffffc0201d8a:	02d74163          	blt	a4,a3,ffffffffc0201dac <vprintfmt+0x29a>
ffffffffc0201d8e:	00369793          	slli	a5,a3,0x3
ffffffffc0201d92:	97de                	add	a5,a5,s7
ffffffffc0201d94:	639c                	ld	a5,0(a5)
ffffffffc0201d96:	cb99                	beqz	a5,ffffffffc0201dac <vprintfmt+0x29a>
                printfmt(putch, putdat, "%s", p);
ffffffffc0201d98:	86be                	mv	a3,a5
ffffffffc0201d9a:	00001617          	auipc	a2,0x1
ffffffffc0201d9e:	0be60613          	addi	a2,a2,190 # ffffffffc0202e58 <default_pmm_manager+0x68>
ffffffffc0201da2:	85a6                	mv	a1,s1
ffffffffc0201da4:	854a                	mv	a0,s2
ffffffffc0201da6:	0ce000ef          	jal	ra,ffffffffc0201e74 <printfmt>
ffffffffc0201daa:	b34d                	j	ffffffffc0201b4c <vprintfmt+0x3a>
                printfmt(putch, putdat, "error %d", err);
ffffffffc0201dac:	00001617          	auipc	a2,0x1
ffffffffc0201db0:	09c60613          	addi	a2,a2,156 # ffffffffc0202e48 <default_pmm_manager+0x58>
ffffffffc0201db4:	85a6                	mv	a1,s1
ffffffffc0201db6:	854a                	mv	a0,s2
ffffffffc0201db8:	0bc000ef          	jal	ra,ffffffffc0201e74 <printfmt>
ffffffffc0201dbc:	bb41                	j	ffffffffc0201b4c <vprintfmt+0x3a>
                p = "(null)";
ffffffffc0201dbe:	00001417          	auipc	s0,0x1
ffffffffc0201dc2:	08240413          	addi	s0,s0,130 # ffffffffc0202e40 <default_pmm_manager+0x50>
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201dc6:	85e2                	mv	a1,s8
ffffffffc0201dc8:	8522                	mv	a0,s0
ffffffffc0201dca:	e43e                	sd	a5,8(sp)
ffffffffc0201dcc:	c53ff0ef          	jal	ra,ffffffffc0201a1e <strnlen>
ffffffffc0201dd0:	40ad8dbb          	subw	s11,s11,a0
ffffffffc0201dd4:	01b05b63          	blez	s11,ffffffffc0201dea <vprintfmt+0x2d8>
                    putch(padc, putdat);
ffffffffc0201dd8:	67a2                	ld	a5,8(sp)
ffffffffc0201dda:	00078a1b          	sext.w	s4,a5
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201dde:	3dfd                	addiw	s11,s11,-1
                    putch(padc, putdat);
ffffffffc0201de0:	85a6                	mv	a1,s1
ffffffffc0201de2:	8552                	mv	a0,s4
ffffffffc0201de4:	9902                	jalr	s2
                for (width -= strnlen(p, precision); width > 0; width --) {
ffffffffc0201de6:	fe0d9ce3          	bnez	s11,ffffffffc0201dde <vprintfmt+0x2cc>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201dea:	00044783          	lbu	a5,0(s0)
ffffffffc0201dee:	00140a13          	addi	s4,s0,1
ffffffffc0201df2:	0007851b          	sext.w	a0,a5
ffffffffc0201df6:	d3a5                	beqz	a5,ffffffffc0201d56 <vprintfmt+0x244>
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201df8:	05e00413          	li	s0,94
ffffffffc0201dfc:	bf39                	j	ffffffffc0201d1a <vprintfmt+0x208>
        return va_arg(*ap, int);
ffffffffc0201dfe:	000a2403          	lw	s0,0(s4)
ffffffffc0201e02:	b7ad                	j	ffffffffc0201d6c <vprintfmt+0x25a>
        return va_arg(*ap, unsigned int);
ffffffffc0201e04:	000a6603          	lwu	a2,0(s4)
ffffffffc0201e08:	46a1                	li	a3,8
ffffffffc0201e0a:	8a2e                	mv	s4,a1
ffffffffc0201e0c:	bdb1                	j	ffffffffc0201c68 <vprintfmt+0x156>
ffffffffc0201e0e:	000a6603          	lwu	a2,0(s4)
ffffffffc0201e12:	46a9                	li	a3,10
ffffffffc0201e14:	8a2e                	mv	s4,a1
ffffffffc0201e16:	bd89                	j	ffffffffc0201c68 <vprintfmt+0x156>
ffffffffc0201e18:	000a6603          	lwu	a2,0(s4)
ffffffffc0201e1c:	46c1                	li	a3,16
ffffffffc0201e1e:	8a2e                	mv	s4,a1
ffffffffc0201e20:	b5a1                	j	ffffffffc0201c68 <vprintfmt+0x156>
                    putch(ch, putdat);
ffffffffc0201e22:	9902                	jalr	s2
ffffffffc0201e24:	bf09                	j	ffffffffc0201d36 <vprintfmt+0x224>
                putch('-', putdat);
ffffffffc0201e26:	85a6                	mv	a1,s1
ffffffffc0201e28:	02d00513          	li	a0,45
ffffffffc0201e2c:	e03e                	sd	a5,0(sp)
ffffffffc0201e2e:	9902                	jalr	s2
                num = -(long long)num;
ffffffffc0201e30:	6782                	ld	a5,0(sp)
ffffffffc0201e32:	8a66                	mv	s4,s9
ffffffffc0201e34:	40800633          	neg	a2,s0
ffffffffc0201e38:	46a9                	li	a3,10
ffffffffc0201e3a:	b53d                	j	ffffffffc0201c68 <vprintfmt+0x156>
            if (width > 0 && padc != '-') {
ffffffffc0201e3c:	03b05163          	blez	s11,ffffffffc0201e5e <vprintfmt+0x34c>
ffffffffc0201e40:	02d00693          	li	a3,45
ffffffffc0201e44:	f6d79de3          	bne	a5,a3,ffffffffc0201dbe <vprintfmt+0x2ac>
                p = "(null)";
ffffffffc0201e48:	00001417          	auipc	s0,0x1
ffffffffc0201e4c:	ff840413          	addi	s0,s0,-8 # ffffffffc0202e40 <default_pmm_manager+0x50>
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
ffffffffc0201e50:	02800793          	li	a5,40
ffffffffc0201e54:	02800513          	li	a0,40
ffffffffc0201e58:	00140a13          	addi	s4,s0,1
ffffffffc0201e5c:	bd6d                	j	ffffffffc0201d16 <vprintfmt+0x204>
ffffffffc0201e5e:	00001a17          	auipc	s4,0x1
ffffffffc0201e62:	fe3a0a13          	addi	s4,s4,-29 # ffffffffc0202e41 <default_pmm_manager+0x51>
ffffffffc0201e66:	02800513          	li	a0,40
ffffffffc0201e6a:	02800793          	li	a5,40
                if (altflag && (ch < ' ' || ch > '~')) {
ffffffffc0201e6e:	05e00413          	li	s0,94
ffffffffc0201e72:	b565                	j	ffffffffc0201d1a <vprintfmt+0x208>

ffffffffc0201e74 <printfmt>:
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0201e74:	715d                	addi	sp,sp,-80
    va_start(ap, fmt);
ffffffffc0201e76:	02810313          	addi	t1,sp,40
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0201e7a:	f436                	sd	a3,40(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0201e7c:	869a                	mv	a3,t1
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
ffffffffc0201e7e:	ec06                	sd	ra,24(sp)
ffffffffc0201e80:	f83a                	sd	a4,48(sp)
ffffffffc0201e82:	fc3e                	sd	a5,56(sp)
ffffffffc0201e84:	e0c2                	sd	a6,64(sp)
ffffffffc0201e86:	e4c6                	sd	a7,72(sp)
    va_start(ap, fmt);
ffffffffc0201e88:	e41a                	sd	t1,8(sp)
    vprintfmt(putch, putdat, fmt, ap);
ffffffffc0201e8a:	c89ff0ef          	jal	ra,ffffffffc0201b12 <vprintfmt>
}
ffffffffc0201e8e:	60e2                	ld	ra,24(sp)
ffffffffc0201e90:	6161                	addi	sp,sp,80
ffffffffc0201e92:	8082                	ret

ffffffffc0201e94 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
ffffffffc0201e94:	715d                	addi	sp,sp,-80
ffffffffc0201e96:	e486                	sd	ra,72(sp)
ffffffffc0201e98:	e0a6                	sd	s1,64(sp)
ffffffffc0201e9a:	fc4a                	sd	s2,56(sp)
ffffffffc0201e9c:	f84e                	sd	s3,48(sp)
ffffffffc0201e9e:	f452                	sd	s4,40(sp)
ffffffffc0201ea0:	f056                	sd	s5,32(sp)
ffffffffc0201ea2:	ec5a                	sd	s6,24(sp)
ffffffffc0201ea4:	e85e                	sd	s7,16(sp)
    if (prompt != NULL) {
ffffffffc0201ea6:	c901                	beqz	a0,ffffffffc0201eb6 <readline+0x22>
ffffffffc0201ea8:	85aa                	mv	a1,a0
        cprintf("%s", prompt);
ffffffffc0201eaa:	00001517          	auipc	a0,0x1
ffffffffc0201eae:	fae50513          	addi	a0,a0,-82 # ffffffffc0202e58 <default_pmm_manager+0x68>
ffffffffc0201eb2:	a2cfe0ef          	jal	ra,ffffffffc02000de <cprintf>
readline(const char *prompt) {
ffffffffc0201eb6:	4481                	li	s1,0
    while (1) {
        c = getchar();
        if (c < 0) {
            return NULL;
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0201eb8:	497d                	li	s2,31
            cputchar(c);
            buf[i ++] = c;
        }
        else if (c == '\b' && i > 0) {
ffffffffc0201eba:	49a1                	li	s3,8
            cputchar(c);
            i --;
        }
        else if (c == '\n' || c == '\r') {
ffffffffc0201ebc:	4aa9                	li	s5,10
ffffffffc0201ebe:	4b35                	li	s6,13
            buf[i ++] = c;
ffffffffc0201ec0:	00005b97          	auipc	s7,0x5
ffffffffc0201ec4:	180b8b93          	addi	s7,s7,384 # ffffffffc0207040 <buf>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0201ec8:	3fe00a13          	li	s4,1022
        c = getchar();
ffffffffc0201ecc:	a8afe0ef          	jal	ra,ffffffffc0200156 <getchar>
        if (c < 0) {
ffffffffc0201ed0:	00054a63          	bltz	a0,ffffffffc0201ee4 <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0201ed4:	00a95a63          	bge	s2,a0,ffffffffc0201ee8 <readline+0x54>
ffffffffc0201ed8:	029a5263          	bge	s4,s1,ffffffffc0201efc <readline+0x68>
        c = getchar();
ffffffffc0201edc:	a7afe0ef          	jal	ra,ffffffffc0200156 <getchar>
        if (c < 0) {
ffffffffc0201ee0:	fe055ae3          	bgez	a0,ffffffffc0201ed4 <readline+0x40>
            return NULL;
ffffffffc0201ee4:	4501                	li	a0,0
ffffffffc0201ee6:	a091                	j	ffffffffc0201f2a <readline+0x96>
        else if (c == '\b' && i > 0) {
ffffffffc0201ee8:	03351463          	bne	a0,s3,ffffffffc0201f10 <readline+0x7c>
ffffffffc0201eec:	e8a9                	bnez	s1,ffffffffc0201f3e <readline+0xaa>
        c = getchar();
ffffffffc0201eee:	a68fe0ef          	jal	ra,ffffffffc0200156 <getchar>
        if (c < 0) {
ffffffffc0201ef2:	fe0549e3          	bltz	a0,ffffffffc0201ee4 <readline+0x50>
        else if (c >= ' ' && i < BUFSIZE - 1) {
ffffffffc0201ef6:	fea959e3          	bge	s2,a0,ffffffffc0201ee8 <readline+0x54>
ffffffffc0201efa:	4481                	li	s1,0
            cputchar(c);
ffffffffc0201efc:	e42a                	sd	a0,8(sp)
ffffffffc0201efe:	a16fe0ef          	jal	ra,ffffffffc0200114 <cputchar>
            buf[i ++] = c;
ffffffffc0201f02:	6522                	ld	a0,8(sp)
ffffffffc0201f04:	009b87b3          	add	a5,s7,s1
ffffffffc0201f08:	2485                	addiw	s1,s1,1
ffffffffc0201f0a:	00a78023          	sb	a0,0(a5)
ffffffffc0201f0e:	bf7d                	j	ffffffffc0201ecc <readline+0x38>
        else if (c == '\n' || c == '\r') {
ffffffffc0201f10:	01550463          	beq	a0,s5,ffffffffc0201f18 <readline+0x84>
ffffffffc0201f14:	fb651ce3          	bne	a0,s6,ffffffffc0201ecc <readline+0x38>
            cputchar(c);
ffffffffc0201f18:	9fcfe0ef          	jal	ra,ffffffffc0200114 <cputchar>
            buf[i] = '\0';
ffffffffc0201f1c:	00005517          	auipc	a0,0x5
ffffffffc0201f20:	12450513          	addi	a0,a0,292 # ffffffffc0207040 <buf>
ffffffffc0201f24:	94aa                	add	s1,s1,a0
ffffffffc0201f26:	00048023          	sb	zero,0(s1)
            return buf;
        }
    }
}
ffffffffc0201f2a:	60a6                	ld	ra,72(sp)
ffffffffc0201f2c:	6486                	ld	s1,64(sp)
ffffffffc0201f2e:	7962                	ld	s2,56(sp)
ffffffffc0201f30:	79c2                	ld	s3,48(sp)
ffffffffc0201f32:	7a22                	ld	s4,40(sp)
ffffffffc0201f34:	7a82                	ld	s5,32(sp)
ffffffffc0201f36:	6b62                	ld	s6,24(sp)
ffffffffc0201f38:	6bc2                	ld	s7,16(sp)
ffffffffc0201f3a:	6161                	addi	sp,sp,80
ffffffffc0201f3c:	8082                	ret
            cputchar(c);
ffffffffc0201f3e:	4521                	li	a0,8
ffffffffc0201f40:	9d4fe0ef          	jal	ra,ffffffffc0200114 <cputchar>
            i --;
ffffffffc0201f44:	34fd                	addiw	s1,s1,-1
ffffffffc0201f46:	b759                	j	ffffffffc0201ecc <readline+0x38>

ffffffffc0201f48 <sbi_console_putchar>:
uint64_t SBI_REMOTE_SFENCE_VMA_ASID = 7;
uint64_t SBI_SHUTDOWN = 8;

uint64_t sbi_call(uint64_t sbi_type, uint64_t arg0, uint64_t arg1, uint64_t arg2) {
    uint64_t ret_val;
    __asm__ volatile (
ffffffffc0201f48:	4781                	li	a5,0
ffffffffc0201f4a:	00005717          	auipc	a4,0x5
ffffffffc0201f4e:	0ce73703          	ld	a4,206(a4) # ffffffffc0207018 <SBI_CONSOLE_PUTCHAR>
ffffffffc0201f52:	88ba                	mv	a7,a4
ffffffffc0201f54:	852a                	mv	a0,a0
ffffffffc0201f56:	85be                	mv	a1,a5
ffffffffc0201f58:	863e                	mv	a2,a5
ffffffffc0201f5a:	00000073          	ecall
ffffffffc0201f5e:	87aa                	mv	a5,a0
    return ret_val;
}

void sbi_console_putchar(unsigned char ch) {
    sbi_call(SBI_CONSOLE_PUTCHAR, ch, 0, 0);
}
ffffffffc0201f60:	8082                	ret

ffffffffc0201f62 <sbi_set_timer>:
    __asm__ volatile (
ffffffffc0201f62:	4781                	li	a5,0
ffffffffc0201f64:	00005717          	auipc	a4,0x5
ffffffffc0201f68:	53473703          	ld	a4,1332(a4) # ffffffffc0207498 <SBI_SET_TIMER>
ffffffffc0201f6c:	88ba                	mv	a7,a4
ffffffffc0201f6e:	852a                	mv	a0,a0
ffffffffc0201f70:	85be                	mv	a1,a5
ffffffffc0201f72:	863e                	mv	a2,a5
ffffffffc0201f74:	00000073          	ecall
ffffffffc0201f78:	87aa                	mv	a5,a0

void sbi_set_timer(unsigned long long stime_value) {
    sbi_call(SBI_SET_TIMER, stime_value, 0, 0);
}
ffffffffc0201f7a:	8082                	ret

ffffffffc0201f7c <sbi_console_getchar>:
    __asm__ volatile (
ffffffffc0201f7c:	4501                	li	a0,0
ffffffffc0201f7e:	00005797          	auipc	a5,0x5
ffffffffc0201f82:	0927b783          	ld	a5,146(a5) # ffffffffc0207010 <SBI_CONSOLE_GETCHAR>
ffffffffc0201f86:	88be                	mv	a7,a5
ffffffffc0201f88:	852a                	mv	a0,a0
ffffffffc0201f8a:	85aa                	mv	a1,a0
ffffffffc0201f8c:	862a                	mv	a2,a0
ffffffffc0201f8e:	00000073          	ecall
ffffffffc0201f92:	852a                	mv	a0,a0

int sbi_console_getchar(void) {
    return sbi_call(SBI_CONSOLE_GETCHAR, 0, 0, 0);
}
ffffffffc0201f94:	2501                	sext.w	a0,a0
ffffffffc0201f96:	8082                	ret

ffffffffc0201f98 <sbi_shutdown>:
    __asm__ volatile (
ffffffffc0201f98:	4781                	li	a5,0
ffffffffc0201f9a:	00005717          	auipc	a4,0x5
ffffffffc0201f9e:	08673703          	ld	a4,134(a4) # ffffffffc0207020 <SBI_SHUTDOWN>
ffffffffc0201fa2:	88ba                	mv	a7,a4
ffffffffc0201fa4:	853e                	mv	a0,a5
ffffffffc0201fa6:	85be                	mv	a1,a5
ffffffffc0201fa8:	863e                	mv	a2,a5
ffffffffc0201faa:	00000073          	ecall
ffffffffc0201fae:	87aa                	mv	a5,a0

void sbi_shutdown(void)
{
	sbi_call(SBI_SHUTDOWN, 0, 0, 0);
ffffffffc0201fb0:	8082                	ret
