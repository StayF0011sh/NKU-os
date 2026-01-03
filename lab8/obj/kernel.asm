
bin/kernel:     file format elf64-littleriscv


Disassembly of section .text:

ffffffffc0200000 <kern_entry>:
ffffffffc0200000:	00014297          	auipc	t0,0x14
ffffffffc0200004:	00028293          	mv	t0,t0
ffffffffc0200008:	00a2b023          	sd	a0,0(t0) # ffffffffc0214000 <boot_hartid>
ffffffffc020000c:	00014297          	auipc	t0,0x14
ffffffffc0200010:	ffc28293          	addi	t0,t0,-4 # ffffffffc0214008 <boot_dtb>
ffffffffc0200014:	00b2b023          	sd	a1,0(t0)
ffffffffc0200018:	c02132b7          	lui	t0,0xc0213
ffffffffc020001c:	ffd0031b          	addiw	t1,zero,-3
ffffffffc0200020:	037a                	slli	t1,t1,0x1e
ffffffffc0200022:	406282b3          	sub	t0,t0,t1
ffffffffc0200026:	00c2d293          	srli	t0,t0,0xc
ffffffffc020002a:	fff0031b          	addiw	t1,zero,-1
ffffffffc020002e:	137e                	slli	t1,t1,0x3f
ffffffffc0200030:	0062e2b3          	or	t0,t0,t1
ffffffffc0200034:	18029073          	csrw	satp,t0
ffffffffc0200038:	12000073          	sfence.vma
ffffffffc020003c:	c0213137          	lui	sp,0xc0213
ffffffffc0200040:	c02002b7          	lui	t0,0xc0200
ffffffffc0200044:	04a28293          	addi	t0,t0,74 # ffffffffc020004a <kern_init>
ffffffffc0200048:	8282                	jr	t0

ffffffffc020004a <kern_init>:
ffffffffc020004a:	00091517          	auipc	a0,0x91
ffffffffc020004e:	01650513          	addi	a0,a0,22 # ffffffffc0291060 <buf>
ffffffffc0200052:	00097617          	auipc	a2,0x97
ffffffffc0200056:	8be60613          	addi	a2,a2,-1858 # ffffffffc0296910 <end>
ffffffffc020005a:	1141                	addi	sp,sp,-16
ffffffffc020005c:	8e09                	sub	a2,a2,a0
ffffffffc020005e:	4581                	li	a1,0
ffffffffc0200060:	e406                	sd	ra,8(sp)
ffffffffc0200062:	79d0a0ef          	jal	ra,ffffffffc020affe <memset>
ffffffffc0200066:	41d000ef          	jal	ra,ffffffffc0200c82 <cons_init>
ffffffffc020006a:	0000b597          	auipc	a1,0xb
ffffffffc020006e:	49658593          	addi	a1,a1,1174 # ffffffffc020b500 <etext+0x6>
ffffffffc0200072:	0000b517          	auipc	a0,0xb
ffffffffc0200076:	4ae50513          	addi	a0,a0,1198 # ffffffffc020b520 <etext+0x26>
ffffffffc020007a:	0b0000ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc020007e:	25c000ef          	jal	ra,ffffffffc02002da <print_kerninfo>
ffffffffc0200082:	04d000ef          	jal	ra,ffffffffc02008ce <dtb_init>
ffffffffc0200086:	3cd010ef          	jal	ra,ffffffffc0201c52 <pmm_init>
ffffffffc020008a:	513000ef          	jal	ra,ffffffffc0200d9c <pic_init>
ffffffffc020008e:	51d000ef          	jal	ra,ffffffffc0200daa <idt_init>
ffffffffc0200092:	058030ef          	jal	ra,ffffffffc02030ea <vmm_init>
ffffffffc0200096:	088070ef          	jal	ra,ffffffffc020711e <sched_init>
ffffffffc020009a:	5e1060ef          	jal	ra,ffffffffc0206e7a <proc_init>
ffffffffc020009e:	4ae000ef          	jal	ra,ffffffffc020054c <ide_init>
ffffffffc02000a2:	724050ef          	jal	ra,ffffffffc02057c6 <fs_init>
ffffffffc02000a6:	7de000ef          	jal	ra,ffffffffc0200884 <clock_init>
ffffffffc02000aa:	4f5000ef          	jal	ra,ffffffffc0200d9e <intr_enable>
ffffffffc02000ae:	799060ef          	jal	ra,ffffffffc0207046 <cpu_idle>

ffffffffc02000b2 <strdup>:
ffffffffc02000b2:	1101                	addi	sp,sp,-32
ffffffffc02000b4:	ec06                	sd	ra,24(sp)
ffffffffc02000b6:	e822                	sd	s0,16(sp)
ffffffffc02000b8:	e426                	sd	s1,8(sp)
ffffffffc02000ba:	e04a                	sd	s2,0(sp)
ffffffffc02000bc:	892a                	mv	s2,a0
ffffffffc02000be:	69f0a0ef          	jal	ra,ffffffffc020af5c <strlen>
ffffffffc02000c2:	842a                	mv	s0,a0
ffffffffc02000c4:	0505                	addi	a0,a0,1
ffffffffc02000c6:	700030ef          	jal	ra,ffffffffc02037c6 <kmalloc>
ffffffffc02000ca:	84aa                	mv	s1,a0
ffffffffc02000cc:	c901                	beqz	a0,ffffffffc02000dc <strdup+0x2a>
ffffffffc02000ce:	8622                	mv	a2,s0
ffffffffc02000d0:	85ca                	mv	a1,s2
ffffffffc02000d2:	9426                	add	s0,s0,s1
ffffffffc02000d4:	77d0a0ef          	jal	ra,ffffffffc020b050 <memcpy>
ffffffffc02000d8:	00040023          	sb	zero,0(s0)
ffffffffc02000dc:	60e2                	ld	ra,24(sp)
ffffffffc02000de:	6442                	ld	s0,16(sp)
ffffffffc02000e0:	6902                	ld	s2,0(sp)
ffffffffc02000e2:	8526                	mv	a0,s1
ffffffffc02000e4:	64a2                	ld	s1,8(sp)
ffffffffc02000e6:	6105                	addi	sp,sp,32
ffffffffc02000e8:	8082                	ret

ffffffffc02000ea <cputch>:
ffffffffc02000ea:	1141                	addi	sp,sp,-16
ffffffffc02000ec:	e022                	sd	s0,0(sp)
ffffffffc02000ee:	e406                	sd	ra,8(sp)
ffffffffc02000f0:	842e                	mv	s0,a1
ffffffffc02000f2:	39f000ef          	jal	ra,ffffffffc0200c90 <cons_putc>
ffffffffc02000f6:	401c                	lw	a5,0(s0)
ffffffffc02000f8:	60a2                	ld	ra,8(sp)
ffffffffc02000fa:	2785                	addiw	a5,a5,1
ffffffffc02000fc:	c01c                	sw	a5,0(s0)
ffffffffc02000fe:	6402                	ld	s0,0(sp)
ffffffffc0200100:	0141                	addi	sp,sp,16
ffffffffc0200102:	8082                	ret

ffffffffc0200104 <vcprintf>:
ffffffffc0200104:	1101                	addi	sp,sp,-32
ffffffffc0200106:	872e                	mv	a4,a1
ffffffffc0200108:	75dd                	lui	a1,0xffff7
ffffffffc020010a:	86aa                	mv	a3,a0
ffffffffc020010c:	0070                	addi	a2,sp,12
ffffffffc020010e:	00000517          	auipc	a0,0x0
ffffffffc0200112:	fdc50513          	addi	a0,a0,-36 # ffffffffc02000ea <cputch>
ffffffffc0200116:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <end+0x3fd601c9>
ffffffffc020011a:	ec06                	sd	ra,24(sp)
ffffffffc020011c:	c602                	sw	zero,12(sp)
ffffffffc020011e:	7db0a0ef          	jal	ra,ffffffffc020b0f8 <vprintfmt>
ffffffffc0200122:	60e2                	ld	ra,24(sp)
ffffffffc0200124:	4532                	lw	a0,12(sp)
ffffffffc0200126:	6105                	addi	sp,sp,32
ffffffffc0200128:	8082                	ret

ffffffffc020012a <cprintf>:
ffffffffc020012a:	711d                	addi	sp,sp,-96
ffffffffc020012c:	02810313          	addi	t1,sp,40 # ffffffffc0213028 <boot_page_table_sv39+0x28>
ffffffffc0200130:	8e2a                	mv	t3,a0
ffffffffc0200132:	f42e                	sd	a1,40(sp)
ffffffffc0200134:	75dd                	lui	a1,0xffff7
ffffffffc0200136:	f832                	sd	a2,48(sp)
ffffffffc0200138:	fc36                	sd	a3,56(sp)
ffffffffc020013a:	e0ba                	sd	a4,64(sp)
ffffffffc020013c:	00000517          	auipc	a0,0x0
ffffffffc0200140:	fae50513          	addi	a0,a0,-82 # ffffffffc02000ea <cputch>
ffffffffc0200144:	0050                	addi	a2,sp,4
ffffffffc0200146:	871a                	mv	a4,t1
ffffffffc0200148:	86f2                	mv	a3,t3
ffffffffc020014a:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <end+0x3fd601c9>
ffffffffc020014e:	ec06                	sd	ra,24(sp)
ffffffffc0200150:	e4be                	sd	a5,72(sp)
ffffffffc0200152:	e8c2                	sd	a6,80(sp)
ffffffffc0200154:	ecc6                	sd	a7,88(sp)
ffffffffc0200156:	e41a                	sd	t1,8(sp)
ffffffffc0200158:	c202                	sw	zero,4(sp)
ffffffffc020015a:	79f0a0ef          	jal	ra,ffffffffc020b0f8 <vprintfmt>
ffffffffc020015e:	60e2                	ld	ra,24(sp)
ffffffffc0200160:	4512                	lw	a0,4(sp)
ffffffffc0200162:	6125                	addi	sp,sp,96
ffffffffc0200164:	8082                	ret

ffffffffc0200166 <cputchar>:
ffffffffc0200166:	32b0006f          	j	ffffffffc0200c90 <cons_putc>

ffffffffc020016a <getchar>:
ffffffffc020016a:	1141                	addi	sp,sp,-16
ffffffffc020016c:	e406                	sd	ra,8(sp)
ffffffffc020016e:	377000ef          	jal	ra,ffffffffc0200ce4 <cons_getc>
ffffffffc0200172:	dd75                	beqz	a0,ffffffffc020016e <getchar+0x4>
ffffffffc0200174:	60a2                	ld	ra,8(sp)
ffffffffc0200176:	0141                	addi	sp,sp,16
ffffffffc0200178:	8082                	ret

ffffffffc020017a <readline>:
ffffffffc020017a:	715d                	addi	sp,sp,-80
ffffffffc020017c:	e486                	sd	ra,72(sp)
ffffffffc020017e:	e0a6                	sd	s1,64(sp)
ffffffffc0200180:	fc4a                	sd	s2,56(sp)
ffffffffc0200182:	f84e                	sd	s3,48(sp)
ffffffffc0200184:	f452                	sd	s4,40(sp)
ffffffffc0200186:	f056                	sd	s5,32(sp)
ffffffffc0200188:	ec5a                	sd	s6,24(sp)
ffffffffc020018a:	e85e                	sd	s7,16(sp)
ffffffffc020018c:	c901                	beqz	a0,ffffffffc020019c <readline+0x22>
ffffffffc020018e:	85aa                	mv	a1,a0
ffffffffc0200190:	0000b517          	auipc	a0,0xb
ffffffffc0200194:	39850513          	addi	a0,a0,920 # ffffffffc020b528 <etext+0x2e>
ffffffffc0200198:	f93ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc020019c:	4481                	li	s1,0
ffffffffc020019e:	497d                	li	s2,31
ffffffffc02001a0:	49a1                	li	s3,8
ffffffffc02001a2:	4aa9                	li	s5,10
ffffffffc02001a4:	4b35                	li	s6,13
ffffffffc02001a6:	00091b97          	auipc	s7,0x91
ffffffffc02001aa:	ebab8b93          	addi	s7,s7,-326 # ffffffffc0291060 <buf>
ffffffffc02001ae:	3fe00a13          	li	s4,1022
ffffffffc02001b2:	fb9ff0ef          	jal	ra,ffffffffc020016a <getchar>
ffffffffc02001b6:	00054a63          	bltz	a0,ffffffffc02001ca <readline+0x50>
ffffffffc02001ba:	00a95a63          	bge	s2,a0,ffffffffc02001ce <readline+0x54>
ffffffffc02001be:	029a5263          	bge	s4,s1,ffffffffc02001e2 <readline+0x68>
ffffffffc02001c2:	fa9ff0ef          	jal	ra,ffffffffc020016a <getchar>
ffffffffc02001c6:	fe055ae3          	bgez	a0,ffffffffc02001ba <readline+0x40>
ffffffffc02001ca:	4501                	li	a0,0
ffffffffc02001cc:	a091                	j	ffffffffc0200210 <readline+0x96>
ffffffffc02001ce:	03351463          	bne	a0,s3,ffffffffc02001f6 <readline+0x7c>
ffffffffc02001d2:	e8a9                	bnez	s1,ffffffffc0200224 <readline+0xaa>
ffffffffc02001d4:	f97ff0ef          	jal	ra,ffffffffc020016a <getchar>
ffffffffc02001d8:	fe0549e3          	bltz	a0,ffffffffc02001ca <readline+0x50>
ffffffffc02001dc:	fea959e3          	bge	s2,a0,ffffffffc02001ce <readline+0x54>
ffffffffc02001e0:	4481                	li	s1,0
ffffffffc02001e2:	e42a                	sd	a0,8(sp)
ffffffffc02001e4:	f83ff0ef          	jal	ra,ffffffffc0200166 <cputchar>
ffffffffc02001e8:	6522                	ld	a0,8(sp)
ffffffffc02001ea:	009b87b3          	add	a5,s7,s1
ffffffffc02001ee:	2485                	addiw	s1,s1,1
ffffffffc02001f0:	00a78023          	sb	a0,0(a5)
ffffffffc02001f4:	bf7d                	j	ffffffffc02001b2 <readline+0x38>
ffffffffc02001f6:	01550463          	beq	a0,s5,ffffffffc02001fe <readline+0x84>
ffffffffc02001fa:	fb651ce3          	bne	a0,s6,ffffffffc02001b2 <readline+0x38>
ffffffffc02001fe:	f69ff0ef          	jal	ra,ffffffffc0200166 <cputchar>
ffffffffc0200202:	00091517          	auipc	a0,0x91
ffffffffc0200206:	e5e50513          	addi	a0,a0,-418 # ffffffffc0291060 <buf>
ffffffffc020020a:	94aa                	add	s1,s1,a0
ffffffffc020020c:	00048023          	sb	zero,0(s1)
ffffffffc0200210:	60a6                	ld	ra,72(sp)
ffffffffc0200212:	6486                	ld	s1,64(sp)
ffffffffc0200214:	7962                	ld	s2,56(sp)
ffffffffc0200216:	79c2                	ld	s3,48(sp)
ffffffffc0200218:	7a22                	ld	s4,40(sp)
ffffffffc020021a:	7a82                	ld	s5,32(sp)
ffffffffc020021c:	6b62                	ld	s6,24(sp)
ffffffffc020021e:	6bc2                	ld	s7,16(sp)
ffffffffc0200220:	6161                	addi	sp,sp,80
ffffffffc0200222:	8082                	ret
ffffffffc0200224:	4521                	li	a0,8
ffffffffc0200226:	f41ff0ef          	jal	ra,ffffffffc0200166 <cputchar>
ffffffffc020022a:	34fd                	addiw	s1,s1,-1
ffffffffc020022c:	b759                	j	ffffffffc02001b2 <readline+0x38>

ffffffffc020022e <__panic>:
ffffffffc020022e:	00096317          	auipc	t1,0x96
ffffffffc0200232:	63a30313          	addi	t1,t1,1594 # ffffffffc0296868 <is_panic>
ffffffffc0200236:	00033e03          	ld	t3,0(t1)
ffffffffc020023a:	715d                	addi	sp,sp,-80
ffffffffc020023c:	ec06                	sd	ra,24(sp)
ffffffffc020023e:	e822                	sd	s0,16(sp)
ffffffffc0200240:	f436                	sd	a3,40(sp)
ffffffffc0200242:	f83a                	sd	a4,48(sp)
ffffffffc0200244:	fc3e                	sd	a5,56(sp)
ffffffffc0200246:	e0c2                	sd	a6,64(sp)
ffffffffc0200248:	e4c6                	sd	a7,72(sp)
ffffffffc020024a:	020e1a63          	bnez	t3,ffffffffc020027e <__panic+0x50>
ffffffffc020024e:	4785                	li	a5,1
ffffffffc0200250:	00f33023          	sd	a5,0(t1)
ffffffffc0200254:	8432                	mv	s0,a2
ffffffffc0200256:	103c                	addi	a5,sp,40
ffffffffc0200258:	862e                	mv	a2,a1
ffffffffc020025a:	85aa                	mv	a1,a0
ffffffffc020025c:	0000b517          	auipc	a0,0xb
ffffffffc0200260:	2d450513          	addi	a0,a0,724 # ffffffffc020b530 <etext+0x36>
ffffffffc0200264:	e43e                	sd	a5,8(sp)
ffffffffc0200266:	ec5ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc020026a:	65a2                	ld	a1,8(sp)
ffffffffc020026c:	8522                	mv	a0,s0
ffffffffc020026e:	e97ff0ef          	jal	ra,ffffffffc0200104 <vcprintf>
ffffffffc0200272:	0000c517          	auipc	a0,0xc
ffffffffc0200276:	3ae50513          	addi	a0,a0,942 # ffffffffc020c620 <commands+0xe78>
ffffffffc020027a:	eb1ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc020027e:	4501                	li	a0,0
ffffffffc0200280:	4581                	li	a1,0
ffffffffc0200282:	4601                	li	a2,0
ffffffffc0200284:	48a1                	li	a7,8
ffffffffc0200286:	00000073          	ecall
ffffffffc020028a:	31b000ef          	jal	ra,ffffffffc0200da4 <intr_disable>
ffffffffc020028e:	4501                	li	a0,0
ffffffffc0200290:	174000ef          	jal	ra,ffffffffc0200404 <kmonitor>
ffffffffc0200294:	bfed                	j	ffffffffc020028e <__panic+0x60>

ffffffffc0200296 <__warn>:
ffffffffc0200296:	715d                	addi	sp,sp,-80
ffffffffc0200298:	832e                	mv	t1,a1
ffffffffc020029a:	e822                	sd	s0,16(sp)
ffffffffc020029c:	85aa                	mv	a1,a0
ffffffffc020029e:	8432                	mv	s0,a2
ffffffffc02002a0:	fc3e                	sd	a5,56(sp)
ffffffffc02002a2:	861a                	mv	a2,t1
ffffffffc02002a4:	103c                	addi	a5,sp,40
ffffffffc02002a6:	0000b517          	auipc	a0,0xb
ffffffffc02002aa:	2aa50513          	addi	a0,a0,682 # ffffffffc020b550 <etext+0x56>
ffffffffc02002ae:	ec06                	sd	ra,24(sp)
ffffffffc02002b0:	f436                	sd	a3,40(sp)
ffffffffc02002b2:	f83a                	sd	a4,48(sp)
ffffffffc02002b4:	e0c2                	sd	a6,64(sp)
ffffffffc02002b6:	e4c6                	sd	a7,72(sp)
ffffffffc02002b8:	e43e                	sd	a5,8(sp)
ffffffffc02002ba:	e71ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02002be:	65a2                	ld	a1,8(sp)
ffffffffc02002c0:	8522                	mv	a0,s0
ffffffffc02002c2:	e43ff0ef          	jal	ra,ffffffffc0200104 <vcprintf>
ffffffffc02002c6:	0000c517          	auipc	a0,0xc
ffffffffc02002ca:	35a50513          	addi	a0,a0,858 # ffffffffc020c620 <commands+0xe78>
ffffffffc02002ce:	e5dff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02002d2:	60e2                	ld	ra,24(sp)
ffffffffc02002d4:	6442                	ld	s0,16(sp)
ffffffffc02002d6:	6161                	addi	sp,sp,80
ffffffffc02002d8:	8082                	ret

ffffffffc02002da <print_kerninfo>:
ffffffffc02002da:	1141                	addi	sp,sp,-16
ffffffffc02002dc:	0000b517          	auipc	a0,0xb
ffffffffc02002e0:	29450513          	addi	a0,a0,660 # ffffffffc020b570 <etext+0x76>
ffffffffc02002e4:	e406                	sd	ra,8(sp)
ffffffffc02002e6:	e45ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02002ea:	00000597          	auipc	a1,0x0
ffffffffc02002ee:	d6058593          	addi	a1,a1,-672 # ffffffffc020004a <kern_init>
ffffffffc02002f2:	0000b517          	auipc	a0,0xb
ffffffffc02002f6:	29e50513          	addi	a0,a0,670 # ffffffffc020b590 <etext+0x96>
ffffffffc02002fa:	e31ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02002fe:	0000b597          	auipc	a1,0xb
ffffffffc0200302:	1fc58593          	addi	a1,a1,508 # ffffffffc020b4fa <etext>
ffffffffc0200306:	0000b517          	auipc	a0,0xb
ffffffffc020030a:	2aa50513          	addi	a0,a0,682 # ffffffffc020b5b0 <etext+0xb6>
ffffffffc020030e:	e1dff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200312:	00091597          	auipc	a1,0x91
ffffffffc0200316:	d4e58593          	addi	a1,a1,-690 # ffffffffc0291060 <buf>
ffffffffc020031a:	0000b517          	auipc	a0,0xb
ffffffffc020031e:	2b650513          	addi	a0,a0,694 # ffffffffc020b5d0 <etext+0xd6>
ffffffffc0200322:	e09ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200326:	00096597          	auipc	a1,0x96
ffffffffc020032a:	5ea58593          	addi	a1,a1,1514 # ffffffffc0296910 <end>
ffffffffc020032e:	0000b517          	auipc	a0,0xb
ffffffffc0200332:	2c250513          	addi	a0,a0,706 # ffffffffc020b5f0 <etext+0xf6>
ffffffffc0200336:	df5ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc020033a:	00097597          	auipc	a1,0x97
ffffffffc020033e:	9d558593          	addi	a1,a1,-1579 # ffffffffc0296d0f <end+0x3ff>
ffffffffc0200342:	00000797          	auipc	a5,0x0
ffffffffc0200346:	d0878793          	addi	a5,a5,-760 # ffffffffc020004a <kern_init>
ffffffffc020034a:	40f587b3          	sub	a5,a1,a5
ffffffffc020034e:	43f7d593          	srai	a1,a5,0x3f
ffffffffc0200352:	60a2                	ld	ra,8(sp)
ffffffffc0200354:	3ff5f593          	andi	a1,a1,1023
ffffffffc0200358:	95be                	add	a1,a1,a5
ffffffffc020035a:	85a9                	srai	a1,a1,0xa
ffffffffc020035c:	0000b517          	auipc	a0,0xb
ffffffffc0200360:	2b450513          	addi	a0,a0,692 # ffffffffc020b610 <etext+0x116>
ffffffffc0200364:	0141                	addi	sp,sp,16
ffffffffc0200366:	b3d1                	j	ffffffffc020012a <cprintf>

ffffffffc0200368 <print_stackframe>:
ffffffffc0200368:	1141                	addi	sp,sp,-16
ffffffffc020036a:	0000b617          	auipc	a2,0xb
ffffffffc020036e:	2d660613          	addi	a2,a2,726 # ffffffffc020b640 <etext+0x146>
ffffffffc0200372:	04e00593          	li	a1,78
ffffffffc0200376:	0000b517          	auipc	a0,0xb
ffffffffc020037a:	2e250513          	addi	a0,a0,738 # ffffffffc020b658 <etext+0x15e>
ffffffffc020037e:	e406                	sd	ra,8(sp)
ffffffffc0200380:	eafff0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0200384 <mon_help>:
ffffffffc0200384:	1141                	addi	sp,sp,-16
ffffffffc0200386:	0000b617          	auipc	a2,0xb
ffffffffc020038a:	2ea60613          	addi	a2,a2,746 # ffffffffc020b670 <etext+0x176>
ffffffffc020038e:	0000b597          	auipc	a1,0xb
ffffffffc0200392:	30258593          	addi	a1,a1,770 # ffffffffc020b690 <etext+0x196>
ffffffffc0200396:	0000b517          	auipc	a0,0xb
ffffffffc020039a:	30250513          	addi	a0,a0,770 # ffffffffc020b698 <etext+0x19e>
ffffffffc020039e:	e406                	sd	ra,8(sp)
ffffffffc02003a0:	d8bff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02003a4:	0000b617          	auipc	a2,0xb
ffffffffc02003a8:	30460613          	addi	a2,a2,772 # ffffffffc020b6a8 <etext+0x1ae>
ffffffffc02003ac:	0000b597          	auipc	a1,0xb
ffffffffc02003b0:	32458593          	addi	a1,a1,804 # ffffffffc020b6d0 <etext+0x1d6>
ffffffffc02003b4:	0000b517          	auipc	a0,0xb
ffffffffc02003b8:	2e450513          	addi	a0,a0,740 # ffffffffc020b698 <etext+0x19e>
ffffffffc02003bc:	d6fff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02003c0:	0000b617          	auipc	a2,0xb
ffffffffc02003c4:	32060613          	addi	a2,a2,800 # ffffffffc020b6e0 <etext+0x1e6>
ffffffffc02003c8:	0000b597          	auipc	a1,0xb
ffffffffc02003cc:	33858593          	addi	a1,a1,824 # ffffffffc020b700 <etext+0x206>
ffffffffc02003d0:	0000b517          	auipc	a0,0xb
ffffffffc02003d4:	2c850513          	addi	a0,a0,712 # ffffffffc020b698 <etext+0x19e>
ffffffffc02003d8:	d53ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02003dc:	60a2                	ld	ra,8(sp)
ffffffffc02003de:	4501                	li	a0,0
ffffffffc02003e0:	0141                	addi	sp,sp,16
ffffffffc02003e2:	8082                	ret

ffffffffc02003e4 <mon_kerninfo>:
ffffffffc02003e4:	1141                	addi	sp,sp,-16
ffffffffc02003e6:	e406                	sd	ra,8(sp)
ffffffffc02003e8:	ef3ff0ef          	jal	ra,ffffffffc02002da <print_kerninfo>
ffffffffc02003ec:	60a2                	ld	ra,8(sp)
ffffffffc02003ee:	4501                	li	a0,0
ffffffffc02003f0:	0141                	addi	sp,sp,16
ffffffffc02003f2:	8082                	ret

ffffffffc02003f4 <mon_backtrace>:
ffffffffc02003f4:	1141                	addi	sp,sp,-16
ffffffffc02003f6:	e406                	sd	ra,8(sp)
ffffffffc02003f8:	f71ff0ef          	jal	ra,ffffffffc0200368 <print_stackframe>
ffffffffc02003fc:	60a2                	ld	ra,8(sp)
ffffffffc02003fe:	4501                	li	a0,0
ffffffffc0200400:	0141                	addi	sp,sp,16
ffffffffc0200402:	8082                	ret

ffffffffc0200404 <kmonitor>:
ffffffffc0200404:	7115                	addi	sp,sp,-224
ffffffffc0200406:	ed5e                	sd	s7,152(sp)
ffffffffc0200408:	8baa                	mv	s7,a0
ffffffffc020040a:	0000b517          	auipc	a0,0xb
ffffffffc020040e:	30650513          	addi	a0,a0,774 # ffffffffc020b710 <etext+0x216>
ffffffffc0200412:	ed86                	sd	ra,216(sp)
ffffffffc0200414:	e9a2                	sd	s0,208(sp)
ffffffffc0200416:	e5a6                	sd	s1,200(sp)
ffffffffc0200418:	e1ca                	sd	s2,192(sp)
ffffffffc020041a:	fd4e                	sd	s3,184(sp)
ffffffffc020041c:	f952                	sd	s4,176(sp)
ffffffffc020041e:	f556                	sd	s5,168(sp)
ffffffffc0200420:	f15a                	sd	s6,160(sp)
ffffffffc0200422:	e962                	sd	s8,144(sp)
ffffffffc0200424:	e566                	sd	s9,136(sp)
ffffffffc0200426:	e16a                	sd	s10,128(sp)
ffffffffc0200428:	d03ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc020042c:	0000b517          	auipc	a0,0xb
ffffffffc0200430:	30c50513          	addi	a0,a0,780 # ffffffffc020b738 <etext+0x23e>
ffffffffc0200434:	cf7ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200438:	000b8563          	beqz	s7,ffffffffc0200442 <kmonitor+0x3e>
ffffffffc020043c:	855e                	mv	a0,s7
ffffffffc020043e:	355000ef          	jal	ra,ffffffffc0200f92 <print_trapframe>
ffffffffc0200442:	0000bc17          	auipc	s8,0xb
ffffffffc0200446:	366c0c13          	addi	s8,s8,870 # ffffffffc020b7a8 <commands>
ffffffffc020044a:	0000b917          	auipc	s2,0xb
ffffffffc020044e:	31690913          	addi	s2,s2,790 # ffffffffc020b760 <etext+0x266>
ffffffffc0200452:	0000b497          	auipc	s1,0xb
ffffffffc0200456:	31648493          	addi	s1,s1,790 # ffffffffc020b768 <etext+0x26e>
ffffffffc020045a:	49bd                	li	s3,15
ffffffffc020045c:	0000bb17          	auipc	s6,0xb
ffffffffc0200460:	314b0b13          	addi	s6,s6,788 # ffffffffc020b770 <etext+0x276>
ffffffffc0200464:	0000ba17          	auipc	s4,0xb
ffffffffc0200468:	22ca0a13          	addi	s4,s4,556 # ffffffffc020b690 <etext+0x196>
ffffffffc020046c:	4a8d                	li	s5,3
ffffffffc020046e:	854a                	mv	a0,s2
ffffffffc0200470:	d0bff0ef          	jal	ra,ffffffffc020017a <readline>
ffffffffc0200474:	842a                	mv	s0,a0
ffffffffc0200476:	dd65                	beqz	a0,ffffffffc020046e <kmonitor+0x6a>
ffffffffc0200478:	00054583          	lbu	a1,0(a0)
ffffffffc020047c:	4c81                	li	s9,0
ffffffffc020047e:	e1bd                	bnez	a1,ffffffffc02004e4 <kmonitor+0xe0>
ffffffffc0200480:	fe0c87e3          	beqz	s9,ffffffffc020046e <kmonitor+0x6a>
ffffffffc0200484:	6582                	ld	a1,0(sp)
ffffffffc0200486:	0000bd17          	auipc	s10,0xb
ffffffffc020048a:	322d0d13          	addi	s10,s10,802 # ffffffffc020b7a8 <commands>
ffffffffc020048e:	8552                	mv	a0,s4
ffffffffc0200490:	4401                	li	s0,0
ffffffffc0200492:	0d61                	addi	s10,s10,24
ffffffffc0200494:	3110a0ef          	jal	ra,ffffffffc020afa4 <strcmp>
ffffffffc0200498:	c919                	beqz	a0,ffffffffc02004ae <kmonitor+0xaa>
ffffffffc020049a:	2405                	addiw	s0,s0,1
ffffffffc020049c:	0b540063          	beq	s0,s5,ffffffffc020053c <kmonitor+0x138>
ffffffffc02004a0:	000d3503          	ld	a0,0(s10)
ffffffffc02004a4:	6582                	ld	a1,0(sp)
ffffffffc02004a6:	0d61                	addi	s10,s10,24
ffffffffc02004a8:	2fd0a0ef          	jal	ra,ffffffffc020afa4 <strcmp>
ffffffffc02004ac:	f57d                	bnez	a0,ffffffffc020049a <kmonitor+0x96>
ffffffffc02004ae:	00141793          	slli	a5,s0,0x1
ffffffffc02004b2:	97a2                	add	a5,a5,s0
ffffffffc02004b4:	078e                	slli	a5,a5,0x3
ffffffffc02004b6:	97e2                	add	a5,a5,s8
ffffffffc02004b8:	6b9c                	ld	a5,16(a5)
ffffffffc02004ba:	865e                	mv	a2,s7
ffffffffc02004bc:	002c                	addi	a1,sp,8
ffffffffc02004be:	fffc851b          	addiw	a0,s9,-1
ffffffffc02004c2:	9782                	jalr	a5
ffffffffc02004c4:	fa0555e3          	bgez	a0,ffffffffc020046e <kmonitor+0x6a>
ffffffffc02004c8:	60ee                	ld	ra,216(sp)
ffffffffc02004ca:	644e                	ld	s0,208(sp)
ffffffffc02004cc:	64ae                	ld	s1,200(sp)
ffffffffc02004ce:	690e                	ld	s2,192(sp)
ffffffffc02004d0:	79ea                	ld	s3,184(sp)
ffffffffc02004d2:	7a4a                	ld	s4,176(sp)
ffffffffc02004d4:	7aaa                	ld	s5,168(sp)
ffffffffc02004d6:	7b0a                	ld	s6,160(sp)
ffffffffc02004d8:	6bea                	ld	s7,152(sp)
ffffffffc02004da:	6c4a                	ld	s8,144(sp)
ffffffffc02004dc:	6caa                	ld	s9,136(sp)
ffffffffc02004de:	6d0a                	ld	s10,128(sp)
ffffffffc02004e0:	612d                	addi	sp,sp,224
ffffffffc02004e2:	8082                	ret
ffffffffc02004e4:	8526                	mv	a0,s1
ffffffffc02004e6:	3030a0ef          	jal	ra,ffffffffc020afe8 <strchr>
ffffffffc02004ea:	c901                	beqz	a0,ffffffffc02004fa <kmonitor+0xf6>
ffffffffc02004ec:	00144583          	lbu	a1,1(s0)
ffffffffc02004f0:	00040023          	sb	zero,0(s0)
ffffffffc02004f4:	0405                	addi	s0,s0,1
ffffffffc02004f6:	d5c9                	beqz	a1,ffffffffc0200480 <kmonitor+0x7c>
ffffffffc02004f8:	b7f5                	j	ffffffffc02004e4 <kmonitor+0xe0>
ffffffffc02004fa:	00044783          	lbu	a5,0(s0)
ffffffffc02004fe:	d3c9                	beqz	a5,ffffffffc0200480 <kmonitor+0x7c>
ffffffffc0200500:	033c8963          	beq	s9,s3,ffffffffc0200532 <kmonitor+0x12e>
ffffffffc0200504:	003c9793          	slli	a5,s9,0x3
ffffffffc0200508:	0118                	addi	a4,sp,128
ffffffffc020050a:	97ba                	add	a5,a5,a4
ffffffffc020050c:	f887b023          	sd	s0,-128(a5)
ffffffffc0200510:	00044583          	lbu	a1,0(s0)
ffffffffc0200514:	2c85                	addiw	s9,s9,1
ffffffffc0200516:	e591                	bnez	a1,ffffffffc0200522 <kmonitor+0x11e>
ffffffffc0200518:	b7b5                	j	ffffffffc0200484 <kmonitor+0x80>
ffffffffc020051a:	00144583          	lbu	a1,1(s0)
ffffffffc020051e:	0405                	addi	s0,s0,1
ffffffffc0200520:	d1a5                	beqz	a1,ffffffffc0200480 <kmonitor+0x7c>
ffffffffc0200522:	8526                	mv	a0,s1
ffffffffc0200524:	2c50a0ef          	jal	ra,ffffffffc020afe8 <strchr>
ffffffffc0200528:	d96d                	beqz	a0,ffffffffc020051a <kmonitor+0x116>
ffffffffc020052a:	00044583          	lbu	a1,0(s0)
ffffffffc020052e:	d9a9                	beqz	a1,ffffffffc0200480 <kmonitor+0x7c>
ffffffffc0200530:	bf55                	j	ffffffffc02004e4 <kmonitor+0xe0>
ffffffffc0200532:	45c1                	li	a1,16
ffffffffc0200534:	855a                	mv	a0,s6
ffffffffc0200536:	bf5ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc020053a:	b7e9                	j	ffffffffc0200504 <kmonitor+0x100>
ffffffffc020053c:	6582                	ld	a1,0(sp)
ffffffffc020053e:	0000b517          	auipc	a0,0xb
ffffffffc0200542:	25250513          	addi	a0,a0,594 # ffffffffc020b790 <etext+0x296>
ffffffffc0200546:	be5ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc020054a:	b715                	j	ffffffffc020046e <kmonitor+0x6a>

ffffffffc020054c <ide_init>:
ffffffffc020054c:	1141                	addi	sp,sp,-16
ffffffffc020054e:	00091597          	auipc	a1,0x91
ffffffffc0200552:	f6258593          	addi	a1,a1,-158 # ffffffffc02914b0 <ide_devices+0x50>
ffffffffc0200556:	4505                	li	a0,1
ffffffffc0200558:	e022                	sd	s0,0(sp)
ffffffffc020055a:	00091797          	auipc	a5,0x91
ffffffffc020055e:	f007a323          	sw	zero,-250(a5) # ffffffffc0291460 <ide_devices>
ffffffffc0200562:	00091797          	auipc	a5,0x91
ffffffffc0200566:	f407a723          	sw	zero,-178(a5) # ffffffffc02914b0 <ide_devices+0x50>
ffffffffc020056a:	00091797          	auipc	a5,0x91
ffffffffc020056e:	f807ab23          	sw	zero,-106(a5) # ffffffffc0291500 <ide_devices+0xa0>
ffffffffc0200572:	00091797          	auipc	a5,0x91
ffffffffc0200576:	fc07af23          	sw	zero,-34(a5) # ffffffffc0291550 <ide_devices+0xf0>
ffffffffc020057a:	e406                	sd	ra,8(sp)
ffffffffc020057c:	00091417          	auipc	s0,0x91
ffffffffc0200580:	ee440413          	addi	s0,s0,-284 # ffffffffc0291460 <ide_devices>
ffffffffc0200584:	22c000ef          	jal	ra,ffffffffc02007b0 <ramdisk_init>
ffffffffc0200588:	483c                	lw	a5,80(s0)
ffffffffc020058a:	cf99                	beqz	a5,ffffffffc02005a8 <ide_init+0x5c>
ffffffffc020058c:	00091597          	auipc	a1,0x91
ffffffffc0200590:	f7458593          	addi	a1,a1,-140 # ffffffffc0291500 <ide_devices+0xa0>
ffffffffc0200594:	4509                	li	a0,2
ffffffffc0200596:	21a000ef          	jal	ra,ffffffffc02007b0 <ramdisk_init>
ffffffffc020059a:	0a042783          	lw	a5,160(s0)
ffffffffc020059e:	c785                	beqz	a5,ffffffffc02005c6 <ide_init+0x7a>
ffffffffc02005a0:	60a2                	ld	ra,8(sp)
ffffffffc02005a2:	6402                	ld	s0,0(sp)
ffffffffc02005a4:	0141                	addi	sp,sp,16
ffffffffc02005a6:	8082                	ret
ffffffffc02005a8:	0000b697          	auipc	a3,0xb
ffffffffc02005ac:	24868693          	addi	a3,a3,584 # ffffffffc020b7f0 <commands+0x48>
ffffffffc02005b0:	0000b617          	auipc	a2,0xb
ffffffffc02005b4:	25860613          	addi	a2,a2,600 # ffffffffc020b808 <commands+0x60>
ffffffffc02005b8:	45c5                	li	a1,17
ffffffffc02005ba:	0000b517          	auipc	a0,0xb
ffffffffc02005be:	26650513          	addi	a0,a0,614 # ffffffffc020b820 <commands+0x78>
ffffffffc02005c2:	c6dff0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02005c6:	0000b697          	auipc	a3,0xb
ffffffffc02005ca:	27268693          	addi	a3,a3,626 # ffffffffc020b838 <commands+0x90>
ffffffffc02005ce:	0000b617          	auipc	a2,0xb
ffffffffc02005d2:	23a60613          	addi	a2,a2,570 # ffffffffc020b808 <commands+0x60>
ffffffffc02005d6:	45d1                	li	a1,20
ffffffffc02005d8:	0000b517          	auipc	a0,0xb
ffffffffc02005dc:	24850513          	addi	a0,a0,584 # ffffffffc020b820 <commands+0x78>
ffffffffc02005e0:	c4fff0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02005e4 <ide_device_valid>:
ffffffffc02005e4:	478d                	li	a5,3
ffffffffc02005e6:	00a7ef63          	bltu	a5,a0,ffffffffc0200604 <ide_device_valid+0x20>
ffffffffc02005ea:	00251793          	slli	a5,a0,0x2
ffffffffc02005ee:	953e                	add	a0,a0,a5
ffffffffc02005f0:	0512                	slli	a0,a0,0x4
ffffffffc02005f2:	00091797          	auipc	a5,0x91
ffffffffc02005f6:	e6e78793          	addi	a5,a5,-402 # ffffffffc0291460 <ide_devices>
ffffffffc02005fa:	953e                	add	a0,a0,a5
ffffffffc02005fc:	4108                	lw	a0,0(a0)
ffffffffc02005fe:	00a03533          	snez	a0,a0
ffffffffc0200602:	8082                	ret
ffffffffc0200604:	4501                	li	a0,0
ffffffffc0200606:	8082                	ret

ffffffffc0200608 <ide_device_size>:
ffffffffc0200608:	478d                	li	a5,3
ffffffffc020060a:	02a7e163          	bltu	a5,a0,ffffffffc020062c <ide_device_size+0x24>
ffffffffc020060e:	00251793          	slli	a5,a0,0x2
ffffffffc0200612:	953e                	add	a0,a0,a5
ffffffffc0200614:	0512                	slli	a0,a0,0x4
ffffffffc0200616:	00091797          	auipc	a5,0x91
ffffffffc020061a:	e4a78793          	addi	a5,a5,-438 # ffffffffc0291460 <ide_devices>
ffffffffc020061e:	97aa                	add	a5,a5,a0
ffffffffc0200620:	4398                	lw	a4,0(a5)
ffffffffc0200622:	4501                	li	a0,0
ffffffffc0200624:	c709                	beqz	a4,ffffffffc020062e <ide_device_size+0x26>
ffffffffc0200626:	0087e503          	lwu	a0,8(a5)
ffffffffc020062a:	8082                	ret
ffffffffc020062c:	4501                	li	a0,0
ffffffffc020062e:	8082                	ret

ffffffffc0200630 <ide_read_secs>:
ffffffffc0200630:	1141                	addi	sp,sp,-16
ffffffffc0200632:	e406                	sd	ra,8(sp)
ffffffffc0200634:	08000793          	li	a5,128
ffffffffc0200638:	04d7e763          	bltu	a5,a3,ffffffffc0200686 <ide_read_secs+0x56>
ffffffffc020063c:	478d                	li	a5,3
ffffffffc020063e:	0005081b          	sext.w	a6,a0
ffffffffc0200642:	04a7e263          	bltu	a5,a0,ffffffffc0200686 <ide_read_secs+0x56>
ffffffffc0200646:	00281793          	slli	a5,a6,0x2
ffffffffc020064a:	97c2                	add	a5,a5,a6
ffffffffc020064c:	0792                	slli	a5,a5,0x4
ffffffffc020064e:	00091817          	auipc	a6,0x91
ffffffffc0200652:	e1280813          	addi	a6,a6,-494 # ffffffffc0291460 <ide_devices>
ffffffffc0200656:	97c2                	add	a5,a5,a6
ffffffffc0200658:	0007a883          	lw	a7,0(a5)
ffffffffc020065c:	02088563          	beqz	a7,ffffffffc0200686 <ide_read_secs+0x56>
ffffffffc0200660:	100008b7          	lui	a7,0x10000
ffffffffc0200664:	0515f163          	bgeu	a1,a7,ffffffffc02006a6 <ide_read_secs+0x76>
ffffffffc0200668:	1582                	slli	a1,a1,0x20
ffffffffc020066a:	9181                	srli	a1,a1,0x20
ffffffffc020066c:	00d58733          	add	a4,a1,a3
ffffffffc0200670:	02e8eb63          	bltu	a7,a4,ffffffffc02006a6 <ide_read_secs+0x76>
ffffffffc0200674:	00251713          	slli	a4,a0,0x2
ffffffffc0200678:	60a2                	ld	ra,8(sp)
ffffffffc020067a:	63bc                	ld	a5,64(a5)
ffffffffc020067c:	953a                	add	a0,a0,a4
ffffffffc020067e:	0512                	slli	a0,a0,0x4
ffffffffc0200680:	9542                	add	a0,a0,a6
ffffffffc0200682:	0141                	addi	sp,sp,16
ffffffffc0200684:	8782                	jr	a5
ffffffffc0200686:	0000b697          	auipc	a3,0xb
ffffffffc020068a:	1ca68693          	addi	a3,a3,458 # ffffffffc020b850 <commands+0xa8>
ffffffffc020068e:	0000b617          	auipc	a2,0xb
ffffffffc0200692:	17a60613          	addi	a2,a2,378 # ffffffffc020b808 <commands+0x60>
ffffffffc0200696:	02200593          	li	a1,34
ffffffffc020069a:	0000b517          	auipc	a0,0xb
ffffffffc020069e:	18650513          	addi	a0,a0,390 # ffffffffc020b820 <commands+0x78>
ffffffffc02006a2:	b8dff0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02006a6:	0000b697          	auipc	a3,0xb
ffffffffc02006aa:	1d268693          	addi	a3,a3,466 # ffffffffc020b878 <commands+0xd0>
ffffffffc02006ae:	0000b617          	auipc	a2,0xb
ffffffffc02006b2:	15a60613          	addi	a2,a2,346 # ffffffffc020b808 <commands+0x60>
ffffffffc02006b6:	02300593          	li	a1,35
ffffffffc02006ba:	0000b517          	auipc	a0,0xb
ffffffffc02006be:	16650513          	addi	a0,a0,358 # ffffffffc020b820 <commands+0x78>
ffffffffc02006c2:	b6dff0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02006c6 <ide_write_secs>:
ffffffffc02006c6:	1141                	addi	sp,sp,-16
ffffffffc02006c8:	e406                	sd	ra,8(sp)
ffffffffc02006ca:	08000793          	li	a5,128
ffffffffc02006ce:	04d7e763          	bltu	a5,a3,ffffffffc020071c <ide_write_secs+0x56>
ffffffffc02006d2:	478d                	li	a5,3
ffffffffc02006d4:	0005081b          	sext.w	a6,a0
ffffffffc02006d8:	04a7e263          	bltu	a5,a0,ffffffffc020071c <ide_write_secs+0x56>
ffffffffc02006dc:	00281793          	slli	a5,a6,0x2
ffffffffc02006e0:	97c2                	add	a5,a5,a6
ffffffffc02006e2:	0792                	slli	a5,a5,0x4
ffffffffc02006e4:	00091817          	auipc	a6,0x91
ffffffffc02006e8:	d7c80813          	addi	a6,a6,-644 # ffffffffc0291460 <ide_devices>
ffffffffc02006ec:	97c2                	add	a5,a5,a6
ffffffffc02006ee:	0007a883          	lw	a7,0(a5)
ffffffffc02006f2:	02088563          	beqz	a7,ffffffffc020071c <ide_write_secs+0x56>
ffffffffc02006f6:	100008b7          	lui	a7,0x10000
ffffffffc02006fa:	0515f163          	bgeu	a1,a7,ffffffffc020073c <ide_write_secs+0x76>
ffffffffc02006fe:	1582                	slli	a1,a1,0x20
ffffffffc0200700:	9181                	srli	a1,a1,0x20
ffffffffc0200702:	00d58733          	add	a4,a1,a3
ffffffffc0200706:	02e8eb63          	bltu	a7,a4,ffffffffc020073c <ide_write_secs+0x76>
ffffffffc020070a:	00251713          	slli	a4,a0,0x2
ffffffffc020070e:	60a2                	ld	ra,8(sp)
ffffffffc0200710:	67bc                	ld	a5,72(a5)
ffffffffc0200712:	953a                	add	a0,a0,a4
ffffffffc0200714:	0512                	slli	a0,a0,0x4
ffffffffc0200716:	9542                	add	a0,a0,a6
ffffffffc0200718:	0141                	addi	sp,sp,16
ffffffffc020071a:	8782                	jr	a5
ffffffffc020071c:	0000b697          	auipc	a3,0xb
ffffffffc0200720:	13468693          	addi	a3,a3,308 # ffffffffc020b850 <commands+0xa8>
ffffffffc0200724:	0000b617          	auipc	a2,0xb
ffffffffc0200728:	0e460613          	addi	a2,a2,228 # ffffffffc020b808 <commands+0x60>
ffffffffc020072c:	02900593          	li	a1,41
ffffffffc0200730:	0000b517          	auipc	a0,0xb
ffffffffc0200734:	0f050513          	addi	a0,a0,240 # ffffffffc020b820 <commands+0x78>
ffffffffc0200738:	af7ff0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020073c:	0000b697          	auipc	a3,0xb
ffffffffc0200740:	13c68693          	addi	a3,a3,316 # ffffffffc020b878 <commands+0xd0>
ffffffffc0200744:	0000b617          	auipc	a2,0xb
ffffffffc0200748:	0c460613          	addi	a2,a2,196 # ffffffffc020b808 <commands+0x60>
ffffffffc020074c:	02a00593          	li	a1,42
ffffffffc0200750:	0000b517          	auipc	a0,0xb
ffffffffc0200754:	0d050513          	addi	a0,a0,208 # ffffffffc020b820 <commands+0x78>
ffffffffc0200758:	ad7ff0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020075c <ramdisk_write>:
ffffffffc020075c:	00856703          	lwu	a4,8(a0)
ffffffffc0200760:	1141                	addi	sp,sp,-16
ffffffffc0200762:	e406                	sd	ra,8(sp)
ffffffffc0200764:	8f0d                	sub	a4,a4,a1
ffffffffc0200766:	87ae                	mv	a5,a1
ffffffffc0200768:	85b2                	mv	a1,a2
ffffffffc020076a:	00e6f363          	bgeu	a3,a4,ffffffffc0200770 <ramdisk_write+0x14>
ffffffffc020076e:	8736                	mv	a4,a3
ffffffffc0200770:	6908                	ld	a0,16(a0)
ffffffffc0200772:	07a6                	slli	a5,a5,0x9
ffffffffc0200774:	00971613          	slli	a2,a4,0x9
ffffffffc0200778:	953e                	add	a0,a0,a5
ffffffffc020077a:	0d70a0ef          	jal	ra,ffffffffc020b050 <memcpy>
ffffffffc020077e:	60a2                	ld	ra,8(sp)
ffffffffc0200780:	4501                	li	a0,0
ffffffffc0200782:	0141                	addi	sp,sp,16
ffffffffc0200784:	8082                	ret

ffffffffc0200786 <ramdisk_read>:
ffffffffc0200786:	00856783          	lwu	a5,8(a0)
ffffffffc020078a:	1141                	addi	sp,sp,-16
ffffffffc020078c:	e406                	sd	ra,8(sp)
ffffffffc020078e:	8f8d                	sub	a5,a5,a1
ffffffffc0200790:	872a                	mv	a4,a0
ffffffffc0200792:	8532                	mv	a0,a2
ffffffffc0200794:	00f6f363          	bgeu	a3,a5,ffffffffc020079a <ramdisk_read+0x14>
ffffffffc0200798:	87b6                	mv	a5,a3
ffffffffc020079a:	6b18                	ld	a4,16(a4)
ffffffffc020079c:	05a6                	slli	a1,a1,0x9
ffffffffc020079e:	00979613          	slli	a2,a5,0x9
ffffffffc02007a2:	95ba                	add	a1,a1,a4
ffffffffc02007a4:	0ad0a0ef          	jal	ra,ffffffffc020b050 <memcpy>
ffffffffc02007a8:	60a2                	ld	ra,8(sp)
ffffffffc02007aa:	4501                	li	a0,0
ffffffffc02007ac:	0141                	addi	sp,sp,16
ffffffffc02007ae:	8082                	ret

ffffffffc02007b0 <ramdisk_init>:
ffffffffc02007b0:	1101                	addi	sp,sp,-32
ffffffffc02007b2:	e822                	sd	s0,16(sp)
ffffffffc02007b4:	842e                	mv	s0,a1
ffffffffc02007b6:	e426                	sd	s1,8(sp)
ffffffffc02007b8:	05000613          	li	a2,80
ffffffffc02007bc:	84aa                	mv	s1,a0
ffffffffc02007be:	4581                	li	a1,0
ffffffffc02007c0:	8522                	mv	a0,s0
ffffffffc02007c2:	ec06                	sd	ra,24(sp)
ffffffffc02007c4:	e04a                	sd	s2,0(sp)
ffffffffc02007c6:	0390a0ef          	jal	ra,ffffffffc020affe <memset>
ffffffffc02007ca:	4785                	li	a5,1
ffffffffc02007cc:	06f48b63          	beq	s1,a5,ffffffffc0200842 <ramdisk_init+0x92>
ffffffffc02007d0:	4789                	li	a5,2
ffffffffc02007d2:	00091617          	auipc	a2,0x91
ffffffffc02007d6:	83e60613          	addi	a2,a2,-1986 # ffffffffc0291010 <arena>
ffffffffc02007da:	0001b917          	auipc	s2,0x1b
ffffffffc02007de:	53690913          	addi	s2,s2,1334 # ffffffffc021bd10 <_binary_bin_sfs_img_start>
ffffffffc02007e2:	08f49563          	bne	s1,a5,ffffffffc020086c <ramdisk_init+0xbc>
ffffffffc02007e6:	06c90863          	beq	s2,a2,ffffffffc0200856 <ramdisk_init+0xa6>
ffffffffc02007ea:	412604b3          	sub	s1,a2,s2
ffffffffc02007ee:	86a6                	mv	a3,s1
ffffffffc02007f0:	85ca                	mv	a1,s2
ffffffffc02007f2:	167d                	addi	a2,a2,-1
ffffffffc02007f4:	0000b517          	auipc	a0,0xb
ffffffffc02007f8:	0dc50513          	addi	a0,a0,220 # ffffffffc020b8d0 <commands+0x128>
ffffffffc02007fc:	92fff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200800:	57fd                	li	a5,-1
ffffffffc0200802:	1782                	slli	a5,a5,0x20
ffffffffc0200804:	0785                	addi	a5,a5,1
ffffffffc0200806:	0094d49b          	srliw	s1,s1,0x9
ffffffffc020080a:	e01c                	sd	a5,0(s0)
ffffffffc020080c:	c404                	sw	s1,8(s0)
ffffffffc020080e:	01243823          	sd	s2,16(s0)
ffffffffc0200812:	02040513          	addi	a0,s0,32
ffffffffc0200816:	0000b597          	auipc	a1,0xb
ffffffffc020081a:	11258593          	addi	a1,a1,274 # ffffffffc020b928 <commands+0x180>
ffffffffc020081e:	7740a0ef          	jal	ra,ffffffffc020af92 <strcpy>
ffffffffc0200822:	00000797          	auipc	a5,0x0
ffffffffc0200826:	f6478793          	addi	a5,a5,-156 # ffffffffc0200786 <ramdisk_read>
ffffffffc020082a:	e03c                	sd	a5,64(s0)
ffffffffc020082c:	00000797          	auipc	a5,0x0
ffffffffc0200830:	f3078793          	addi	a5,a5,-208 # ffffffffc020075c <ramdisk_write>
ffffffffc0200834:	60e2                	ld	ra,24(sp)
ffffffffc0200836:	e43c                	sd	a5,72(s0)
ffffffffc0200838:	6442                	ld	s0,16(sp)
ffffffffc020083a:	64a2                	ld	s1,8(sp)
ffffffffc020083c:	6902                	ld	s2,0(sp)
ffffffffc020083e:	6105                	addi	sp,sp,32
ffffffffc0200840:	8082                	ret
ffffffffc0200842:	0001b617          	auipc	a2,0x1b
ffffffffc0200846:	4ce60613          	addi	a2,a2,1230 # ffffffffc021bd10 <_binary_bin_sfs_img_start>
ffffffffc020084a:	00013917          	auipc	s2,0x13
ffffffffc020084e:	7c690913          	addi	s2,s2,1990 # ffffffffc0214010 <_binary_bin_swap_img_start>
ffffffffc0200852:	f8c91ce3          	bne	s2,a2,ffffffffc02007ea <ramdisk_init+0x3a>
ffffffffc0200856:	6442                	ld	s0,16(sp)
ffffffffc0200858:	60e2                	ld	ra,24(sp)
ffffffffc020085a:	64a2                	ld	s1,8(sp)
ffffffffc020085c:	6902                	ld	s2,0(sp)
ffffffffc020085e:	0000b517          	auipc	a0,0xb
ffffffffc0200862:	05a50513          	addi	a0,a0,90 # ffffffffc020b8b8 <commands+0x110>
ffffffffc0200866:	6105                	addi	sp,sp,32
ffffffffc0200868:	8c3ff06f          	j	ffffffffc020012a <cprintf>
ffffffffc020086c:	0000b617          	auipc	a2,0xb
ffffffffc0200870:	08c60613          	addi	a2,a2,140 # ffffffffc020b8f8 <commands+0x150>
ffffffffc0200874:	03200593          	li	a1,50
ffffffffc0200878:	0000b517          	auipc	a0,0xb
ffffffffc020087c:	09850513          	addi	a0,a0,152 # ffffffffc020b910 <commands+0x168>
ffffffffc0200880:	9afff0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0200884 <clock_init>:
ffffffffc0200884:	02000793          	li	a5,32
ffffffffc0200888:	1047a7f3          	csrrs	a5,sie,a5
ffffffffc020088c:	c0102573          	rdtime	a0
ffffffffc0200890:	67e1                	lui	a5,0x18
ffffffffc0200892:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_bin_swap_img_size+0x109a0>
ffffffffc0200896:	953e                	add	a0,a0,a5
ffffffffc0200898:	4581                	li	a1,0
ffffffffc020089a:	4601                	li	a2,0
ffffffffc020089c:	4881                	li	a7,0
ffffffffc020089e:	00000073          	ecall
ffffffffc02008a2:	0000b517          	auipc	a0,0xb
ffffffffc02008a6:	09650513          	addi	a0,a0,150 # ffffffffc020b938 <commands+0x190>
ffffffffc02008aa:	00096797          	auipc	a5,0x96
ffffffffc02008ae:	fc07b323          	sd	zero,-58(a5) # ffffffffc0296870 <ticks>
ffffffffc02008b2:	879ff06f          	j	ffffffffc020012a <cprintf>

ffffffffc02008b6 <clock_set_next_event>:
ffffffffc02008b6:	c0102573          	rdtime	a0
ffffffffc02008ba:	67e1                	lui	a5,0x18
ffffffffc02008bc:	6a078793          	addi	a5,a5,1696 # 186a0 <_binary_bin_swap_img_size+0x109a0>
ffffffffc02008c0:	953e                	add	a0,a0,a5
ffffffffc02008c2:	4581                	li	a1,0
ffffffffc02008c4:	4601                	li	a2,0
ffffffffc02008c6:	4881                	li	a7,0
ffffffffc02008c8:	00000073          	ecall
ffffffffc02008cc:	8082                	ret

ffffffffc02008ce <dtb_init>:
ffffffffc02008ce:	7119                	addi	sp,sp,-128
ffffffffc02008d0:	0000b517          	auipc	a0,0xb
ffffffffc02008d4:	08850513          	addi	a0,a0,136 # ffffffffc020b958 <commands+0x1b0>
ffffffffc02008d8:	fc86                	sd	ra,120(sp)
ffffffffc02008da:	f8a2                	sd	s0,112(sp)
ffffffffc02008dc:	e8d2                	sd	s4,80(sp)
ffffffffc02008de:	f4a6                	sd	s1,104(sp)
ffffffffc02008e0:	f0ca                	sd	s2,96(sp)
ffffffffc02008e2:	ecce                	sd	s3,88(sp)
ffffffffc02008e4:	e4d6                	sd	s5,72(sp)
ffffffffc02008e6:	e0da                	sd	s6,64(sp)
ffffffffc02008e8:	fc5e                	sd	s7,56(sp)
ffffffffc02008ea:	f862                	sd	s8,48(sp)
ffffffffc02008ec:	f466                	sd	s9,40(sp)
ffffffffc02008ee:	f06a                	sd	s10,32(sp)
ffffffffc02008f0:	ec6e                	sd	s11,24(sp)
ffffffffc02008f2:	839ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02008f6:	00013597          	auipc	a1,0x13
ffffffffc02008fa:	70a5b583          	ld	a1,1802(a1) # ffffffffc0214000 <boot_hartid>
ffffffffc02008fe:	0000b517          	auipc	a0,0xb
ffffffffc0200902:	06a50513          	addi	a0,a0,106 # ffffffffc020b968 <commands+0x1c0>
ffffffffc0200906:	825ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc020090a:	00013417          	auipc	s0,0x13
ffffffffc020090e:	6fe40413          	addi	s0,s0,1790 # ffffffffc0214008 <boot_dtb>
ffffffffc0200912:	600c                	ld	a1,0(s0)
ffffffffc0200914:	0000b517          	auipc	a0,0xb
ffffffffc0200918:	06450513          	addi	a0,a0,100 # ffffffffc020b978 <commands+0x1d0>
ffffffffc020091c:	80fff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200920:	00043a03          	ld	s4,0(s0)
ffffffffc0200924:	0000b517          	auipc	a0,0xb
ffffffffc0200928:	06c50513          	addi	a0,a0,108 # ffffffffc020b990 <commands+0x1e8>
ffffffffc020092c:	120a0463          	beqz	s4,ffffffffc0200a54 <dtb_init+0x186>
ffffffffc0200930:	57f5                	li	a5,-3
ffffffffc0200932:	07fa                	slli	a5,a5,0x1e
ffffffffc0200934:	00fa0733          	add	a4,s4,a5
ffffffffc0200938:	431c                	lw	a5,0(a4)
ffffffffc020093a:	00ff0637          	lui	a2,0xff0
ffffffffc020093e:	6b41                	lui	s6,0x10
ffffffffc0200940:	0087d59b          	srliw	a1,a5,0x8
ffffffffc0200944:	0187969b          	slliw	a3,a5,0x18
ffffffffc0200948:	0187d51b          	srliw	a0,a5,0x18
ffffffffc020094c:	0105959b          	slliw	a1,a1,0x10
ffffffffc0200950:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200954:	8df1                	and	a1,a1,a2
ffffffffc0200956:	8ec9                	or	a3,a3,a0
ffffffffc0200958:	0087979b          	slliw	a5,a5,0x8
ffffffffc020095c:	1b7d                	addi	s6,s6,-1
ffffffffc020095e:	0167f7b3          	and	a5,a5,s6
ffffffffc0200962:	8dd5                	or	a1,a1,a3
ffffffffc0200964:	8ddd                	or	a1,a1,a5
ffffffffc0200966:	d00e07b7          	lui	a5,0xd00e0
ffffffffc020096a:	2581                	sext.w	a1,a1
ffffffffc020096c:	eed78793          	addi	a5,a5,-275 # ffffffffd00dfeed <end+0xfe495dd>
ffffffffc0200970:	10f59263          	bne	a1,a5,ffffffffc0200a74 <dtb_init+0x1a6>
ffffffffc0200974:	471c                	lw	a5,8(a4)
ffffffffc0200976:	4754                	lw	a3,12(a4)
ffffffffc0200978:	4c81                	li	s9,0
ffffffffc020097a:	0087d59b          	srliw	a1,a5,0x8
ffffffffc020097e:	0086d51b          	srliw	a0,a3,0x8
ffffffffc0200982:	0186941b          	slliw	s0,a3,0x18
ffffffffc0200986:	0186d89b          	srliw	a7,a3,0x18
ffffffffc020098a:	01879a1b          	slliw	s4,a5,0x18
ffffffffc020098e:	0187d81b          	srliw	a6,a5,0x18
ffffffffc0200992:	0105151b          	slliw	a0,a0,0x10
ffffffffc0200996:	0106d69b          	srliw	a3,a3,0x10
ffffffffc020099a:	0105959b          	slliw	a1,a1,0x10
ffffffffc020099e:	0107d79b          	srliw	a5,a5,0x10
ffffffffc02009a2:	8d71                	and	a0,a0,a2
ffffffffc02009a4:	01146433          	or	s0,s0,a7
ffffffffc02009a8:	0086969b          	slliw	a3,a3,0x8
ffffffffc02009ac:	010a6a33          	or	s4,s4,a6
ffffffffc02009b0:	8e6d                	and	a2,a2,a1
ffffffffc02009b2:	0087979b          	slliw	a5,a5,0x8
ffffffffc02009b6:	8c49                	or	s0,s0,a0
ffffffffc02009b8:	0166f6b3          	and	a3,a3,s6
ffffffffc02009bc:	00ca6a33          	or	s4,s4,a2
ffffffffc02009c0:	0167f7b3          	and	a5,a5,s6
ffffffffc02009c4:	8c55                	or	s0,s0,a3
ffffffffc02009c6:	00fa6a33          	or	s4,s4,a5
ffffffffc02009ca:	1402                	slli	s0,s0,0x20
ffffffffc02009cc:	1a02                	slli	s4,s4,0x20
ffffffffc02009ce:	9001                	srli	s0,s0,0x20
ffffffffc02009d0:	020a5a13          	srli	s4,s4,0x20
ffffffffc02009d4:	943a                	add	s0,s0,a4
ffffffffc02009d6:	9a3a                	add	s4,s4,a4
ffffffffc02009d8:	00ff0c37          	lui	s8,0xff0
ffffffffc02009dc:	4b8d                	li	s7,3
ffffffffc02009de:	0000b917          	auipc	s2,0xb
ffffffffc02009e2:	00290913          	addi	s2,s2,2 # ffffffffc020b9e0 <commands+0x238>
ffffffffc02009e6:	49bd                	li	s3,15
ffffffffc02009e8:	4d91                	li	s11,4
ffffffffc02009ea:	4d05                	li	s10,1
ffffffffc02009ec:	0000b497          	auipc	s1,0xb
ffffffffc02009f0:	fec48493          	addi	s1,s1,-20 # ffffffffc020b9d8 <commands+0x230>
ffffffffc02009f4:	000a2703          	lw	a4,0(s4)
ffffffffc02009f8:	004a0a93          	addi	s5,s4,4
ffffffffc02009fc:	0087569b          	srliw	a3,a4,0x8
ffffffffc0200a00:	0187179b          	slliw	a5,a4,0x18
ffffffffc0200a04:	0187561b          	srliw	a2,a4,0x18
ffffffffc0200a08:	0106969b          	slliw	a3,a3,0x10
ffffffffc0200a0c:	0107571b          	srliw	a4,a4,0x10
ffffffffc0200a10:	8fd1                	or	a5,a5,a2
ffffffffc0200a12:	0186f6b3          	and	a3,a3,s8
ffffffffc0200a16:	0087171b          	slliw	a4,a4,0x8
ffffffffc0200a1a:	8fd5                	or	a5,a5,a3
ffffffffc0200a1c:	00eb7733          	and	a4,s6,a4
ffffffffc0200a20:	8fd9                	or	a5,a5,a4
ffffffffc0200a22:	2781                	sext.w	a5,a5
ffffffffc0200a24:	09778e63          	beq	a5,s7,ffffffffc0200ac0 <dtb_init+0x1f2>
ffffffffc0200a28:	00fbea63          	bltu	s7,a5,ffffffffc0200a3c <dtb_init+0x16e>
ffffffffc0200a2c:	07a78863          	beq	a5,s10,ffffffffc0200a9c <dtb_init+0x1ce>
ffffffffc0200a30:	4709                	li	a4,2
ffffffffc0200a32:	00e79763          	bne	a5,a4,ffffffffc0200a40 <dtb_init+0x172>
ffffffffc0200a36:	4c81                	li	s9,0
ffffffffc0200a38:	8a56                	mv	s4,s5
ffffffffc0200a3a:	bf6d                	j	ffffffffc02009f4 <dtb_init+0x126>
ffffffffc0200a3c:	ffb78ee3          	beq	a5,s11,ffffffffc0200a38 <dtb_init+0x16a>
ffffffffc0200a40:	0000b517          	auipc	a0,0xb
ffffffffc0200a44:	01850513          	addi	a0,a0,24 # ffffffffc020ba58 <commands+0x2b0>
ffffffffc0200a48:	ee2ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200a4c:	0000b517          	auipc	a0,0xb
ffffffffc0200a50:	04450513          	addi	a0,a0,68 # ffffffffc020ba90 <commands+0x2e8>
ffffffffc0200a54:	7446                	ld	s0,112(sp)
ffffffffc0200a56:	70e6                	ld	ra,120(sp)
ffffffffc0200a58:	74a6                	ld	s1,104(sp)
ffffffffc0200a5a:	7906                	ld	s2,96(sp)
ffffffffc0200a5c:	69e6                	ld	s3,88(sp)
ffffffffc0200a5e:	6a46                	ld	s4,80(sp)
ffffffffc0200a60:	6aa6                	ld	s5,72(sp)
ffffffffc0200a62:	6b06                	ld	s6,64(sp)
ffffffffc0200a64:	7be2                	ld	s7,56(sp)
ffffffffc0200a66:	7c42                	ld	s8,48(sp)
ffffffffc0200a68:	7ca2                	ld	s9,40(sp)
ffffffffc0200a6a:	7d02                	ld	s10,32(sp)
ffffffffc0200a6c:	6de2                	ld	s11,24(sp)
ffffffffc0200a6e:	6109                	addi	sp,sp,128
ffffffffc0200a70:	ebaff06f          	j	ffffffffc020012a <cprintf>
ffffffffc0200a74:	7446                	ld	s0,112(sp)
ffffffffc0200a76:	70e6                	ld	ra,120(sp)
ffffffffc0200a78:	74a6                	ld	s1,104(sp)
ffffffffc0200a7a:	7906                	ld	s2,96(sp)
ffffffffc0200a7c:	69e6                	ld	s3,88(sp)
ffffffffc0200a7e:	6a46                	ld	s4,80(sp)
ffffffffc0200a80:	6aa6                	ld	s5,72(sp)
ffffffffc0200a82:	6b06                	ld	s6,64(sp)
ffffffffc0200a84:	7be2                	ld	s7,56(sp)
ffffffffc0200a86:	7c42                	ld	s8,48(sp)
ffffffffc0200a88:	7ca2                	ld	s9,40(sp)
ffffffffc0200a8a:	7d02                	ld	s10,32(sp)
ffffffffc0200a8c:	6de2                	ld	s11,24(sp)
ffffffffc0200a8e:	0000b517          	auipc	a0,0xb
ffffffffc0200a92:	f2250513          	addi	a0,a0,-222 # ffffffffc020b9b0 <commands+0x208>
ffffffffc0200a96:	6109                	addi	sp,sp,128
ffffffffc0200a98:	e92ff06f          	j	ffffffffc020012a <cprintf>
ffffffffc0200a9c:	8556                	mv	a0,s5
ffffffffc0200a9e:	4be0a0ef          	jal	ra,ffffffffc020af5c <strlen>
ffffffffc0200aa2:	8a2a                	mv	s4,a0
ffffffffc0200aa4:	4619                	li	a2,6
ffffffffc0200aa6:	85a6                	mv	a1,s1
ffffffffc0200aa8:	8556                	mv	a0,s5
ffffffffc0200aaa:	2a01                	sext.w	s4,s4
ffffffffc0200aac:	5160a0ef          	jal	ra,ffffffffc020afc2 <strncmp>
ffffffffc0200ab0:	e111                	bnez	a0,ffffffffc0200ab4 <dtb_init+0x1e6>
ffffffffc0200ab2:	4c85                	li	s9,1
ffffffffc0200ab4:	0a91                	addi	s5,s5,4
ffffffffc0200ab6:	9ad2                	add	s5,s5,s4
ffffffffc0200ab8:	ffcafa93          	andi	s5,s5,-4
ffffffffc0200abc:	8a56                	mv	s4,s5
ffffffffc0200abe:	bf1d                	j	ffffffffc02009f4 <dtb_init+0x126>
ffffffffc0200ac0:	004a2783          	lw	a5,4(s4)
ffffffffc0200ac4:	00ca0693          	addi	a3,s4,12
ffffffffc0200ac8:	0087d71b          	srliw	a4,a5,0x8
ffffffffc0200acc:	01879a9b          	slliw	s5,a5,0x18
ffffffffc0200ad0:	0187d61b          	srliw	a2,a5,0x18
ffffffffc0200ad4:	0107171b          	slliw	a4,a4,0x10
ffffffffc0200ad8:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200adc:	00caeab3          	or	s5,s5,a2
ffffffffc0200ae0:	01877733          	and	a4,a4,s8
ffffffffc0200ae4:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200ae8:	00eaeab3          	or	s5,s5,a4
ffffffffc0200aec:	00fb77b3          	and	a5,s6,a5
ffffffffc0200af0:	00faeab3          	or	s5,s5,a5
ffffffffc0200af4:	2a81                	sext.w	s5,s5
ffffffffc0200af6:	000c9c63          	bnez	s9,ffffffffc0200b0e <dtb_init+0x240>
ffffffffc0200afa:	1a82                	slli	s5,s5,0x20
ffffffffc0200afc:	00368793          	addi	a5,a3,3
ffffffffc0200b00:	020ada93          	srli	s5,s5,0x20
ffffffffc0200b04:	9abe                	add	s5,s5,a5
ffffffffc0200b06:	ffcafa93          	andi	s5,s5,-4
ffffffffc0200b0a:	8a56                	mv	s4,s5
ffffffffc0200b0c:	b5e5                	j	ffffffffc02009f4 <dtb_init+0x126>
ffffffffc0200b0e:	008a2783          	lw	a5,8(s4)
ffffffffc0200b12:	85ca                	mv	a1,s2
ffffffffc0200b14:	e436                	sd	a3,8(sp)
ffffffffc0200b16:	0087d51b          	srliw	a0,a5,0x8
ffffffffc0200b1a:	0187d61b          	srliw	a2,a5,0x18
ffffffffc0200b1e:	0187971b          	slliw	a4,a5,0x18
ffffffffc0200b22:	0105151b          	slliw	a0,a0,0x10
ffffffffc0200b26:	0107d79b          	srliw	a5,a5,0x10
ffffffffc0200b2a:	8f51                	or	a4,a4,a2
ffffffffc0200b2c:	01857533          	and	a0,a0,s8
ffffffffc0200b30:	0087979b          	slliw	a5,a5,0x8
ffffffffc0200b34:	8d59                	or	a0,a0,a4
ffffffffc0200b36:	00fb77b3          	and	a5,s6,a5
ffffffffc0200b3a:	8d5d                	or	a0,a0,a5
ffffffffc0200b3c:	1502                	slli	a0,a0,0x20
ffffffffc0200b3e:	9101                	srli	a0,a0,0x20
ffffffffc0200b40:	9522                	add	a0,a0,s0
ffffffffc0200b42:	4620a0ef          	jal	ra,ffffffffc020afa4 <strcmp>
ffffffffc0200b46:	66a2                	ld	a3,8(sp)
ffffffffc0200b48:	f94d                	bnez	a0,ffffffffc0200afa <dtb_init+0x22c>
ffffffffc0200b4a:	fb59f8e3          	bgeu	s3,s5,ffffffffc0200afa <dtb_init+0x22c>
ffffffffc0200b4e:	00ca3783          	ld	a5,12(s4)
ffffffffc0200b52:	014a3703          	ld	a4,20(s4)
ffffffffc0200b56:	0000b517          	auipc	a0,0xb
ffffffffc0200b5a:	e9250513          	addi	a0,a0,-366 # ffffffffc020b9e8 <commands+0x240>
ffffffffc0200b5e:	4207d613          	srai	a2,a5,0x20
ffffffffc0200b62:	0087d31b          	srliw	t1,a5,0x8
ffffffffc0200b66:	42075593          	srai	a1,a4,0x20
ffffffffc0200b6a:	0187de1b          	srliw	t3,a5,0x18
ffffffffc0200b6e:	0186581b          	srliw	a6,a2,0x18
ffffffffc0200b72:	0187941b          	slliw	s0,a5,0x18
ffffffffc0200b76:	0107d89b          	srliw	a7,a5,0x10
ffffffffc0200b7a:	0187d693          	srli	a3,a5,0x18
ffffffffc0200b7e:	01861f1b          	slliw	t5,a2,0x18
ffffffffc0200b82:	0087579b          	srliw	a5,a4,0x8
ffffffffc0200b86:	0103131b          	slliw	t1,t1,0x10
ffffffffc0200b8a:	0106561b          	srliw	a2,a2,0x10
ffffffffc0200b8e:	010f6f33          	or	t5,t5,a6
ffffffffc0200b92:	0187529b          	srliw	t0,a4,0x18
ffffffffc0200b96:	0185df9b          	srliw	t6,a1,0x18
ffffffffc0200b9a:	01837333          	and	t1,t1,s8
ffffffffc0200b9e:	01c46433          	or	s0,s0,t3
ffffffffc0200ba2:	0186f6b3          	and	a3,a3,s8
ffffffffc0200ba6:	01859e1b          	slliw	t3,a1,0x18
ffffffffc0200baa:	01871e9b          	slliw	t4,a4,0x18
ffffffffc0200bae:	0107581b          	srliw	a6,a4,0x10
ffffffffc0200bb2:	0086161b          	slliw	a2,a2,0x8
ffffffffc0200bb6:	8361                	srli	a4,a4,0x18
ffffffffc0200bb8:	0107979b          	slliw	a5,a5,0x10
ffffffffc0200bbc:	0105d59b          	srliw	a1,a1,0x10
ffffffffc0200bc0:	01e6e6b3          	or	a3,a3,t5
ffffffffc0200bc4:	00cb7633          	and	a2,s6,a2
ffffffffc0200bc8:	0088181b          	slliw	a6,a6,0x8
ffffffffc0200bcc:	0085959b          	slliw	a1,a1,0x8
ffffffffc0200bd0:	00646433          	or	s0,s0,t1
ffffffffc0200bd4:	0187f7b3          	and	a5,a5,s8
ffffffffc0200bd8:	01fe6333          	or	t1,t3,t6
ffffffffc0200bdc:	01877c33          	and	s8,a4,s8
ffffffffc0200be0:	0088989b          	slliw	a7,a7,0x8
ffffffffc0200be4:	011b78b3          	and	a7,s6,a7
ffffffffc0200be8:	005eeeb3          	or	t4,t4,t0
ffffffffc0200bec:	00c6e733          	or	a4,a3,a2
ffffffffc0200bf0:	006c6c33          	or	s8,s8,t1
ffffffffc0200bf4:	010b76b3          	and	a3,s6,a6
ffffffffc0200bf8:	00bb7b33          	and	s6,s6,a1
ffffffffc0200bfc:	01d7e7b3          	or	a5,a5,t4
ffffffffc0200c00:	016c6b33          	or	s6,s8,s6
ffffffffc0200c04:	01146433          	or	s0,s0,a7
ffffffffc0200c08:	8fd5                	or	a5,a5,a3
ffffffffc0200c0a:	1702                	slli	a4,a4,0x20
ffffffffc0200c0c:	1b02                	slli	s6,s6,0x20
ffffffffc0200c0e:	1782                	slli	a5,a5,0x20
ffffffffc0200c10:	9301                	srli	a4,a4,0x20
ffffffffc0200c12:	1402                	slli	s0,s0,0x20
ffffffffc0200c14:	020b5b13          	srli	s6,s6,0x20
ffffffffc0200c18:	0167eb33          	or	s6,a5,s6
ffffffffc0200c1c:	8c59                	or	s0,s0,a4
ffffffffc0200c1e:	d0cff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200c22:	85a2                	mv	a1,s0
ffffffffc0200c24:	0000b517          	auipc	a0,0xb
ffffffffc0200c28:	de450513          	addi	a0,a0,-540 # ffffffffc020ba08 <commands+0x260>
ffffffffc0200c2c:	cfeff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200c30:	014b5613          	srli	a2,s6,0x14
ffffffffc0200c34:	85da                	mv	a1,s6
ffffffffc0200c36:	0000b517          	auipc	a0,0xb
ffffffffc0200c3a:	dea50513          	addi	a0,a0,-534 # ffffffffc020ba20 <commands+0x278>
ffffffffc0200c3e:	cecff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200c42:	008b05b3          	add	a1,s6,s0
ffffffffc0200c46:	15fd                	addi	a1,a1,-1
ffffffffc0200c48:	0000b517          	auipc	a0,0xb
ffffffffc0200c4c:	df850513          	addi	a0,a0,-520 # ffffffffc020ba40 <commands+0x298>
ffffffffc0200c50:	cdaff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200c54:	0000b517          	auipc	a0,0xb
ffffffffc0200c58:	e3c50513          	addi	a0,a0,-452 # ffffffffc020ba90 <commands+0x2e8>
ffffffffc0200c5c:	00096797          	auipc	a5,0x96
ffffffffc0200c60:	c087be23          	sd	s0,-996(a5) # ffffffffc0296878 <memory_base>
ffffffffc0200c64:	00096797          	auipc	a5,0x96
ffffffffc0200c68:	c167be23          	sd	s6,-996(a5) # ffffffffc0296880 <memory_size>
ffffffffc0200c6c:	b3e5                	j	ffffffffc0200a54 <dtb_init+0x186>

ffffffffc0200c6e <get_memory_base>:
ffffffffc0200c6e:	00096517          	auipc	a0,0x96
ffffffffc0200c72:	c0a53503          	ld	a0,-1014(a0) # ffffffffc0296878 <memory_base>
ffffffffc0200c76:	8082                	ret

ffffffffc0200c78 <get_memory_size>:
ffffffffc0200c78:	00096517          	auipc	a0,0x96
ffffffffc0200c7c:	c0853503          	ld	a0,-1016(a0) # ffffffffc0296880 <memory_size>
ffffffffc0200c80:	8082                	ret

ffffffffc0200c82 <cons_init>:
ffffffffc0200c82:	4501                	li	a0,0
ffffffffc0200c84:	4581                	li	a1,0
ffffffffc0200c86:	4601                	li	a2,0
ffffffffc0200c88:	4889                	li	a7,2
ffffffffc0200c8a:	00000073          	ecall
ffffffffc0200c8e:	8082                	ret

ffffffffc0200c90 <cons_putc>:
ffffffffc0200c90:	1101                	addi	sp,sp,-32
ffffffffc0200c92:	ec06                	sd	ra,24(sp)
ffffffffc0200c94:	100027f3          	csrr	a5,sstatus
ffffffffc0200c98:	8b89                	andi	a5,a5,2
ffffffffc0200c9a:	4701                	li	a4,0
ffffffffc0200c9c:	ef95                	bnez	a5,ffffffffc0200cd8 <cons_putc+0x48>
ffffffffc0200c9e:	47a1                	li	a5,8
ffffffffc0200ca0:	00f50b63          	beq	a0,a5,ffffffffc0200cb6 <cons_putc+0x26>
ffffffffc0200ca4:	4581                	li	a1,0
ffffffffc0200ca6:	4601                	li	a2,0
ffffffffc0200ca8:	4885                	li	a7,1
ffffffffc0200caa:	00000073          	ecall
ffffffffc0200cae:	e315                	bnez	a4,ffffffffc0200cd2 <cons_putc+0x42>
ffffffffc0200cb0:	60e2                	ld	ra,24(sp)
ffffffffc0200cb2:	6105                	addi	sp,sp,32
ffffffffc0200cb4:	8082                	ret
ffffffffc0200cb6:	4521                	li	a0,8
ffffffffc0200cb8:	4581                	li	a1,0
ffffffffc0200cba:	4601                	li	a2,0
ffffffffc0200cbc:	4885                	li	a7,1
ffffffffc0200cbe:	00000073          	ecall
ffffffffc0200cc2:	02000513          	li	a0,32
ffffffffc0200cc6:	00000073          	ecall
ffffffffc0200cca:	4521                	li	a0,8
ffffffffc0200ccc:	00000073          	ecall
ffffffffc0200cd0:	d365                	beqz	a4,ffffffffc0200cb0 <cons_putc+0x20>
ffffffffc0200cd2:	60e2                	ld	ra,24(sp)
ffffffffc0200cd4:	6105                	addi	sp,sp,32
ffffffffc0200cd6:	a0e1                	j	ffffffffc0200d9e <intr_enable>
ffffffffc0200cd8:	e42a                	sd	a0,8(sp)
ffffffffc0200cda:	0ca000ef          	jal	ra,ffffffffc0200da4 <intr_disable>
ffffffffc0200cde:	6522                	ld	a0,8(sp)
ffffffffc0200ce0:	4705                	li	a4,1
ffffffffc0200ce2:	bf75                	j	ffffffffc0200c9e <cons_putc+0xe>

ffffffffc0200ce4 <cons_getc>:
ffffffffc0200ce4:	1101                	addi	sp,sp,-32
ffffffffc0200ce6:	ec06                	sd	ra,24(sp)
ffffffffc0200ce8:	100027f3          	csrr	a5,sstatus
ffffffffc0200cec:	8b89                	andi	a5,a5,2
ffffffffc0200cee:	4801                	li	a6,0
ffffffffc0200cf0:	e3d5                	bnez	a5,ffffffffc0200d94 <cons_getc+0xb0>
ffffffffc0200cf2:	00091697          	auipc	a3,0x91
ffffffffc0200cf6:	8ae68693          	addi	a3,a3,-1874 # ffffffffc02915a0 <cons>
ffffffffc0200cfa:	07f00713          	li	a4,127
ffffffffc0200cfe:	20000313          	li	t1,512
ffffffffc0200d02:	a021                	j	ffffffffc0200d0a <cons_getc+0x26>
ffffffffc0200d04:	0ff57513          	zext.b	a0,a0
ffffffffc0200d08:	ef91                	bnez	a5,ffffffffc0200d24 <cons_getc+0x40>
ffffffffc0200d0a:	4501                	li	a0,0
ffffffffc0200d0c:	4581                	li	a1,0
ffffffffc0200d0e:	4601                	li	a2,0
ffffffffc0200d10:	4889                	li	a7,2
ffffffffc0200d12:	00000073          	ecall
ffffffffc0200d16:	0005079b          	sext.w	a5,a0
ffffffffc0200d1a:	0207c763          	bltz	a5,ffffffffc0200d48 <cons_getc+0x64>
ffffffffc0200d1e:	fee793e3          	bne	a5,a4,ffffffffc0200d04 <cons_getc+0x20>
ffffffffc0200d22:	4521                	li	a0,8
ffffffffc0200d24:	2046a783          	lw	a5,516(a3)
ffffffffc0200d28:	02079613          	slli	a2,a5,0x20
ffffffffc0200d2c:	9201                	srli	a2,a2,0x20
ffffffffc0200d2e:	2785                	addiw	a5,a5,1
ffffffffc0200d30:	9636                	add	a2,a2,a3
ffffffffc0200d32:	20f6a223          	sw	a5,516(a3)
ffffffffc0200d36:	00a60023          	sb	a0,0(a2) # ff0000 <_binary_bin_sfs_img_size+0xf7ad00>
ffffffffc0200d3a:	fc6798e3          	bne	a5,t1,ffffffffc0200d0a <cons_getc+0x26>
ffffffffc0200d3e:	00091797          	auipc	a5,0x91
ffffffffc0200d42:	a607a323          	sw	zero,-1434(a5) # ffffffffc02917a4 <cons+0x204>
ffffffffc0200d46:	b7d1                	j	ffffffffc0200d0a <cons_getc+0x26>
ffffffffc0200d48:	2006a783          	lw	a5,512(a3)
ffffffffc0200d4c:	2046a703          	lw	a4,516(a3)
ffffffffc0200d50:	4501                	li	a0,0
ffffffffc0200d52:	00f70f63          	beq	a4,a5,ffffffffc0200d70 <cons_getc+0x8c>
ffffffffc0200d56:	0017861b          	addiw	a2,a5,1
ffffffffc0200d5a:	1782                	slli	a5,a5,0x20
ffffffffc0200d5c:	9381                	srli	a5,a5,0x20
ffffffffc0200d5e:	97b6                	add	a5,a5,a3
ffffffffc0200d60:	20c6a023          	sw	a2,512(a3)
ffffffffc0200d64:	20000713          	li	a4,512
ffffffffc0200d68:	0007c503          	lbu	a0,0(a5)
ffffffffc0200d6c:	00e60763          	beq	a2,a4,ffffffffc0200d7a <cons_getc+0x96>
ffffffffc0200d70:	00081b63          	bnez	a6,ffffffffc0200d86 <cons_getc+0xa2>
ffffffffc0200d74:	60e2                	ld	ra,24(sp)
ffffffffc0200d76:	6105                	addi	sp,sp,32
ffffffffc0200d78:	8082                	ret
ffffffffc0200d7a:	00091797          	auipc	a5,0x91
ffffffffc0200d7e:	a207a323          	sw	zero,-1498(a5) # ffffffffc02917a0 <cons+0x200>
ffffffffc0200d82:	fe0809e3          	beqz	a6,ffffffffc0200d74 <cons_getc+0x90>
ffffffffc0200d86:	e42a                	sd	a0,8(sp)
ffffffffc0200d88:	016000ef          	jal	ra,ffffffffc0200d9e <intr_enable>
ffffffffc0200d8c:	60e2                	ld	ra,24(sp)
ffffffffc0200d8e:	6522                	ld	a0,8(sp)
ffffffffc0200d90:	6105                	addi	sp,sp,32
ffffffffc0200d92:	8082                	ret
ffffffffc0200d94:	010000ef          	jal	ra,ffffffffc0200da4 <intr_disable>
ffffffffc0200d98:	4805                	li	a6,1
ffffffffc0200d9a:	bfa1                	j	ffffffffc0200cf2 <cons_getc+0xe>

ffffffffc0200d9c <pic_init>:
ffffffffc0200d9c:	8082                	ret

ffffffffc0200d9e <intr_enable>:
ffffffffc0200d9e:	100167f3          	csrrsi	a5,sstatus,2
ffffffffc0200da2:	8082                	ret

ffffffffc0200da4 <intr_disable>:
ffffffffc0200da4:	100177f3          	csrrci	a5,sstatus,2
ffffffffc0200da8:	8082                	ret

ffffffffc0200daa <idt_init>:
ffffffffc0200daa:	14005073          	csrwi	sscratch,0
ffffffffc0200dae:	00000797          	auipc	a5,0x0
ffffffffc0200db2:	43a78793          	addi	a5,a5,1082 # ffffffffc02011e8 <__alltraps>
ffffffffc0200db6:	10579073          	csrw	stvec,a5
ffffffffc0200dba:	000407b7          	lui	a5,0x40
ffffffffc0200dbe:	1007a7f3          	csrrs	a5,sstatus,a5
ffffffffc0200dc2:	8082                	ret

ffffffffc0200dc4 <print_regs>:
ffffffffc0200dc4:	610c                	ld	a1,0(a0)
ffffffffc0200dc6:	1141                	addi	sp,sp,-16
ffffffffc0200dc8:	e022                	sd	s0,0(sp)
ffffffffc0200dca:	842a                	mv	s0,a0
ffffffffc0200dcc:	0000b517          	auipc	a0,0xb
ffffffffc0200dd0:	cdc50513          	addi	a0,a0,-804 # ffffffffc020baa8 <commands+0x300>
ffffffffc0200dd4:	e406                	sd	ra,8(sp)
ffffffffc0200dd6:	b54ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200dda:	640c                	ld	a1,8(s0)
ffffffffc0200ddc:	0000b517          	auipc	a0,0xb
ffffffffc0200de0:	ce450513          	addi	a0,a0,-796 # ffffffffc020bac0 <commands+0x318>
ffffffffc0200de4:	b46ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200de8:	680c                	ld	a1,16(s0)
ffffffffc0200dea:	0000b517          	auipc	a0,0xb
ffffffffc0200dee:	cee50513          	addi	a0,a0,-786 # ffffffffc020bad8 <commands+0x330>
ffffffffc0200df2:	b38ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200df6:	6c0c                	ld	a1,24(s0)
ffffffffc0200df8:	0000b517          	auipc	a0,0xb
ffffffffc0200dfc:	cf850513          	addi	a0,a0,-776 # ffffffffc020baf0 <commands+0x348>
ffffffffc0200e00:	b2aff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200e04:	700c                	ld	a1,32(s0)
ffffffffc0200e06:	0000b517          	auipc	a0,0xb
ffffffffc0200e0a:	d0250513          	addi	a0,a0,-766 # ffffffffc020bb08 <commands+0x360>
ffffffffc0200e0e:	b1cff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200e12:	740c                	ld	a1,40(s0)
ffffffffc0200e14:	0000b517          	auipc	a0,0xb
ffffffffc0200e18:	d0c50513          	addi	a0,a0,-756 # ffffffffc020bb20 <commands+0x378>
ffffffffc0200e1c:	b0eff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200e20:	780c                	ld	a1,48(s0)
ffffffffc0200e22:	0000b517          	auipc	a0,0xb
ffffffffc0200e26:	d1650513          	addi	a0,a0,-746 # ffffffffc020bb38 <commands+0x390>
ffffffffc0200e2a:	b00ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200e2e:	7c0c                	ld	a1,56(s0)
ffffffffc0200e30:	0000b517          	auipc	a0,0xb
ffffffffc0200e34:	d2050513          	addi	a0,a0,-736 # ffffffffc020bb50 <commands+0x3a8>
ffffffffc0200e38:	af2ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200e3c:	602c                	ld	a1,64(s0)
ffffffffc0200e3e:	0000b517          	auipc	a0,0xb
ffffffffc0200e42:	d2a50513          	addi	a0,a0,-726 # ffffffffc020bb68 <commands+0x3c0>
ffffffffc0200e46:	ae4ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200e4a:	642c                	ld	a1,72(s0)
ffffffffc0200e4c:	0000b517          	auipc	a0,0xb
ffffffffc0200e50:	d3450513          	addi	a0,a0,-716 # ffffffffc020bb80 <commands+0x3d8>
ffffffffc0200e54:	ad6ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200e58:	682c                	ld	a1,80(s0)
ffffffffc0200e5a:	0000b517          	auipc	a0,0xb
ffffffffc0200e5e:	d3e50513          	addi	a0,a0,-706 # ffffffffc020bb98 <commands+0x3f0>
ffffffffc0200e62:	ac8ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200e66:	6c2c                	ld	a1,88(s0)
ffffffffc0200e68:	0000b517          	auipc	a0,0xb
ffffffffc0200e6c:	d4850513          	addi	a0,a0,-696 # ffffffffc020bbb0 <commands+0x408>
ffffffffc0200e70:	abaff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200e74:	702c                	ld	a1,96(s0)
ffffffffc0200e76:	0000b517          	auipc	a0,0xb
ffffffffc0200e7a:	d5250513          	addi	a0,a0,-686 # ffffffffc020bbc8 <commands+0x420>
ffffffffc0200e7e:	aacff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200e82:	742c                	ld	a1,104(s0)
ffffffffc0200e84:	0000b517          	auipc	a0,0xb
ffffffffc0200e88:	d5c50513          	addi	a0,a0,-676 # ffffffffc020bbe0 <commands+0x438>
ffffffffc0200e8c:	a9eff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200e90:	782c                	ld	a1,112(s0)
ffffffffc0200e92:	0000b517          	auipc	a0,0xb
ffffffffc0200e96:	d6650513          	addi	a0,a0,-666 # ffffffffc020bbf8 <commands+0x450>
ffffffffc0200e9a:	a90ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200e9e:	7c2c                	ld	a1,120(s0)
ffffffffc0200ea0:	0000b517          	auipc	a0,0xb
ffffffffc0200ea4:	d7050513          	addi	a0,a0,-656 # ffffffffc020bc10 <commands+0x468>
ffffffffc0200ea8:	a82ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200eac:	604c                	ld	a1,128(s0)
ffffffffc0200eae:	0000b517          	auipc	a0,0xb
ffffffffc0200eb2:	d7a50513          	addi	a0,a0,-646 # ffffffffc020bc28 <commands+0x480>
ffffffffc0200eb6:	a74ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200eba:	644c                	ld	a1,136(s0)
ffffffffc0200ebc:	0000b517          	auipc	a0,0xb
ffffffffc0200ec0:	d8450513          	addi	a0,a0,-636 # ffffffffc020bc40 <commands+0x498>
ffffffffc0200ec4:	a66ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200ec8:	684c                	ld	a1,144(s0)
ffffffffc0200eca:	0000b517          	auipc	a0,0xb
ffffffffc0200ece:	d8e50513          	addi	a0,a0,-626 # ffffffffc020bc58 <commands+0x4b0>
ffffffffc0200ed2:	a58ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200ed6:	6c4c                	ld	a1,152(s0)
ffffffffc0200ed8:	0000b517          	auipc	a0,0xb
ffffffffc0200edc:	d9850513          	addi	a0,a0,-616 # ffffffffc020bc70 <commands+0x4c8>
ffffffffc0200ee0:	a4aff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200ee4:	704c                	ld	a1,160(s0)
ffffffffc0200ee6:	0000b517          	auipc	a0,0xb
ffffffffc0200eea:	da250513          	addi	a0,a0,-606 # ffffffffc020bc88 <commands+0x4e0>
ffffffffc0200eee:	a3cff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200ef2:	744c                	ld	a1,168(s0)
ffffffffc0200ef4:	0000b517          	auipc	a0,0xb
ffffffffc0200ef8:	dac50513          	addi	a0,a0,-596 # ffffffffc020bca0 <commands+0x4f8>
ffffffffc0200efc:	a2eff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200f00:	784c                	ld	a1,176(s0)
ffffffffc0200f02:	0000b517          	auipc	a0,0xb
ffffffffc0200f06:	db650513          	addi	a0,a0,-586 # ffffffffc020bcb8 <commands+0x510>
ffffffffc0200f0a:	a20ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200f0e:	7c4c                	ld	a1,184(s0)
ffffffffc0200f10:	0000b517          	auipc	a0,0xb
ffffffffc0200f14:	dc050513          	addi	a0,a0,-576 # ffffffffc020bcd0 <commands+0x528>
ffffffffc0200f18:	a12ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200f1c:	606c                	ld	a1,192(s0)
ffffffffc0200f1e:	0000b517          	auipc	a0,0xb
ffffffffc0200f22:	dca50513          	addi	a0,a0,-566 # ffffffffc020bce8 <commands+0x540>
ffffffffc0200f26:	a04ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200f2a:	646c                	ld	a1,200(s0)
ffffffffc0200f2c:	0000b517          	auipc	a0,0xb
ffffffffc0200f30:	dd450513          	addi	a0,a0,-556 # ffffffffc020bd00 <commands+0x558>
ffffffffc0200f34:	9f6ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200f38:	686c                	ld	a1,208(s0)
ffffffffc0200f3a:	0000b517          	auipc	a0,0xb
ffffffffc0200f3e:	dde50513          	addi	a0,a0,-546 # ffffffffc020bd18 <commands+0x570>
ffffffffc0200f42:	9e8ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200f46:	6c6c                	ld	a1,216(s0)
ffffffffc0200f48:	0000b517          	auipc	a0,0xb
ffffffffc0200f4c:	de850513          	addi	a0,a0,-536 # ffffffffc020bd30 <commands+0x588>
ffffffffc0200f50:	9daff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200f54:	706c                	ld	a1,224(s0)
ffffffffc0200f56:	0000b517          	auipc	a0,0xb
ffffffffc0200f5a:	df250513          	addi	a0,a0,-526 # ffffffffc020bd48 <commands+0x5a0>
ffffffffc0200f5e:	9ccff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200f62:	746c                	ld	a1,232(s0)
ffffffffc0200f64:	0000b517          	auipc	a0,0xb
ffffffffc0200f68:	dfc50513          	addi	a0,a0,-516 # ffffffffc020bd60 <commands+0x5b8>
ffffffffc0200f6c:	9beff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200f70:	786c                	ld	a1,240(s0)
ffffffffc0200f72:	0000b517          	auipc	a0,0xb
ffffffffc0200f76:	e0650513          	addi	a0,a0,-506 # ffffffffc020bd78 <commands+0x5d0>
ffffffffc0200f7a:	9b0ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200f7e:	7c6c                	ld	a1,248(s0)
ffffffffc0200f80:	6402                	ld	s0,0(sp)
ffffffffc0200f82:	60a2                	ld	ra,8(sp)
ffffffffc0200f84:	0000b517          	auipc	a0,0xb
ffffffffc0200f88:	e0c50513          	addi	a0,a0,-500 # ffffffffc020bd90 <commands+0x5e8>
ffffffffc0200f8c:	0141                	addi	sp,sp,16
ffffffffc0200f8e:	99cff06f          	j	ffffffffc020012a <cprintf>

ffffffffc0200f92 <print_trapframe>:
ffffffffc0200f92:	1141                	addi	sp,sp,-16
ffffffffc0200f94:	e022                	sd	s0,0(sp)
ffffffffc0200f96:	85aa                	mv	a1,a0
ffffffffc0200f98:	842a                	mv	s0,a0
ffffffffc0200f9a:	0000b517          	auipc	a0,0xb
ffffffffc0200f9e:	e0e50513          	addi	a0,a0,-498 # ffffffffc020bda8 <commands+0x600>
ffffffffc0200fa2:	e406                	sd	ra,8(sp)
ffffffffc0200fa4:	986ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200fa8:	8522                	mv	a0,s0
ffffffffc0200faa:	e1bff0ef          	jal	ra,ffffffffc0200dc4 <print_regs>
ffffffffc0200fae:	10043583          	ld	a1,256(s0)
ffffffffc0200fb2:	0000b517          	auipc	a0,0xb
ffffffffc0200fb6:	e0e50513          	addi	a0,a0,-498 # ffffffffc020bdc0 <commands+0x618>
ffffffffc0200fba:	970ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200fbe:	10843583          	ld	a1,264(s0)
ffffffffc0200fc2:	0000b517          	auipc	a0,0xb
ffffffffc0200fc6:	e1650513          	addi	a0,a0,-490 # ffffffffc020bdd8 <commands+0x630>
ffffffffc0200fca:	960ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200fce:	11043583          	ld	a1,272(s0)
ffffffffc0200fd2:	0000b517          	auipc	a0,0xb
ffffffffc0200fd6:	e1e50513          	addi	a0,a0,-482 # ffffffffc020bdf0 <commands+0x648>
ffffffffc0200fda:	950ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0200fde:	11843583          	ld	a1,280(s0)
ffffffffc0200fe2:	6402                	ld	s0,0(sp)
ffffffffc0200fe4:	60a2                	ld	ra,8(sp)
ffffffffc0200fe6:	0000b517          	auipc	a0,0xb
ffffffffc0200fea:	e1a50513          	addi	a0,a0,-486 # ffffffffc020be00 <commands+0x658>
ffffffffc0200fee:	0141                	addi	sp,sp,16
ffffffffc0200ff0:	93aff06f          	j	ffffffffc020012a <cprintf>

ffffffffc0200ff4 <interrupt_handler>:
ffffffffc0200ff4:	11853783          	ld	a5,280(a0)
ffffffffc0200ff8:	472d                	li	a4,11
ffffffffc0200ffa:	0786                	slli	a5,a5,0x1
ffffffffc0200ffc:	8385                	srli	a5,a5,0x1
ffffffffc0200ffe:	06f76c63          	bltu	a4,a5,ffffffffc0201076 <interrupt_handler+0x82>
ffffffffc0201002:	0000b717          	auipc	a4,0xb
ffffffffc0201006:	eb670713          	addi	a4,a4,-330 # ffffffffc020beb8 <commands+0x710>
ffffffffc020100a:	078a                	slli	a5,a5,0x2
ffffffffc020100c:	97ba                	add	a5,a5,a4
ffffffffc020100e:	439c                	lw	a5,0(a5)
ffffffffc0201010:	97ba                	add	a5,a5,a4
ffffffffc0201012:	8782                	jr	a5
ffffffffc0201014:	0000b517          	auipc	a0,0xb
ffffffffc0201018:	e6450513          	addi	a0,a0,-412 # ffffffffc020be78 <commands+0x6d0>
ffffffffc020101c:	90eff06f          	j	ffffffffc020012a <cprintf>
ffffffffc0201020:	0000b517          	auipc	a0,0xb
ffffffffc0201024:	e3850513          	addi	a0,a0,-456 # ffffffffc020be58 <commands+0x6b0>
ffffffffc0201028:	902ff06f          	j	ffffffffc020012a <cprintf>
ffffffffc020102c:	0000b517          	auipc	a0,0xb
ffffffffc0201030:	dec50513          	addi	a0,a0,-532 # ffffffffc020be18 <commands+0x670>
ffffffffc0201034:	8f6ff06f          	j	ffffffffc020012a <cprintf>
ffffffffc0201038:	0000b517          	auipc	a0,0xb
ffffffffc020103c:	e0050513          	addi	a0,a0,-512 # ffffffffc020be38 <commands+0x690>
ffffffffc0201040:	8eaff06f          	j	ffffffffc020012a <cprintf>
ffffffffc0201044:	1141                	addi	sp,sp,-16
ffffffffc0201046:	e406                	sd	ra,8(sp)
ffffffffc0201048:	86fff0ef          	jal	ra,ffffffffc02008b6 <clock_set_next_event>
ffffffffc020104c:	00096717          	auipc	a4,0x96
ffffffffc0201050:	82470713          	addi	a4,a4,-2012 # ffffffffc0296870 <ticks>
ffffffffc0201054:	631c                	ld	a5,0(a4)
ffffffffc0201056:	0785                	addi	a5,a5,1
ffffffffc0201058:	e31c                	sd	a5,0(a4)
ffffffffc020105a:	3d4060ef          	jal	ra,ffffffffc020742e <run_timer_list>
ffffffffc020105e:	c87ff0ef          	jal	ra,ffffffffc0200ce4 <cons_getc>
ffffffffc0201062:	60a2                	ld	ra,8(sp)
ffffffffc0201064:	0141                	addi	sp,sp,16
ffffffffc0201066:	5d60706f          	j	ffffffffc020863c <dev_stdin_write>
ffffffffc020106a:	0000b517          	auipc	a0,0xb
ffffffffc020106e:	e2e50513          	addi	a0,a0,-466 # ffffffffc020be98 <commands+0x6f0>
ffffffffc0201072:	8b8ff06f          	j	ffffffffc020012a <cprintf>
ffffffffc0201076:	bf31                	j	ffffffffc0200f92 <print_trapframe>

ffffffffc0201078 <exception_handler>:
ffffffffc0201078:	11853783          	ld	a5,280(a0)
ffffffffc020107c:	1141                	addi	sp,sp,-16
ffffffffc020107e:	e022                	sd	s0,0(sp)
ffffffffc0201080:	e406                	sd	ra,8(sp)
ffffffffc0201082:	473d                	li	a4,15
ffffffffc0201084:	842a                	mv	s0,a0
ffffffffc0201086:	0af76b63          	bltu	a4,a5,ffffffffc020113c <exception_handler+0xc4>
ffffffffc020108a:	0000b717          	auipc	a4,0xb
ffffffffc020108e:	fee70713          	addi	a4,a4,-18 # ffffffffc020c078 <commands+0x8d0>
ffffffffc0201092:	078a                	slli	a5,a5,0x2
ffffffffc0201094:	97ba                	add	a5,a5,a4
ffffffffc0201096:	439c                	lw	a5,0(a5)
ffffffffc0201098:	97ba                	add	a5,a5,a4
ffffffffc020109a:	8782                	jr	a5
ffffffffc020109c:	0000b517          	auipc	a0,0xb
ffffffffc02010a0:	f3450513          	addi	a0,a0,-204 # ffffffffc020bfd0 <commands+0x828>
ffffffffc02010a4:	886ff0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02010a8:	10843783          	ld	a5,264(s0)
ffffffffc02010ac:	60a2                	ld	ra,8(sp)
ffffffffc02010ae:	0791                	addi	a5,a5,4
ffffffffc02010b0:	10f43423          	sd	a5,264(s0)
ffffffffc02010b4:	6402                	ld	s0,0(sp)
ffffffffc02010b6:	0141                	addi	sp,sp,16
ffffffffc02010b8:	6740606f          	j	ffffffffc020772c <syscall>
ffffffffc02010bc:	0000b517          	auipc	a0,0xb
ffffffffc02010c0:	f3450513          	addi	a0,a0,-204 # ffffffffc020bff0 <commands+0x848>
ffffffffc02010c4:	6402                	ld	s0,0(sp)
ffffffffc02010c6:	60a2                	ld	ra,8(sp)
ffffffffc02010c8:	0141                	addi	sp,sp,16
ffffffffc02010ca:	860ff06f          	j	ffffffffc020012a <cprintf>
ffffffffc02010ce:	0000b517          	auipc	a0,0xb
ffffffffc02010d2:	f4250513          	addi	a0,a0,-190 # ffffffffc020c010 <commands+0x868>
ffffffffc02010d6:	b7fd                	j	ffffffffc02010c4 <exception_handler+0x4c>
ffffffffc02010d8:	0000b517          	auipc	a0,0xb
ffffffffc02010dc:	f5850513          	addi	a0,a0,-168 # ffffffffc020c030 <commands+0x888>
ffffffffc02010e0:	b7d5                	j	ffffffffc02010c4 <exception_handler+0x4c>
ffffffffc02010e2:	0000b517          	auipc	a0,0xb
ffffffffc02010e6:	f6650513          	addi	a0,a0,-154 # ffffffffc020c048 <commands+0x8a0>
ffffffffc02010ea:	bfe9                	j	ffffffffc02010c4 <exception_handler+0x4c>
ffffffffc02010ec:	0000b517          	auipc	a0,0xb
ffffffffc02010f0:	f7450513          	addi	a0,a0,-140 # ffffffffc020c060 <commands+0x8b8>
ffffffffc02010f4:	bfc1                	j	ffffffffc02010c4 <exception_handler+0x4c>
ffffffffc02010f6:	0000b517          	auipc	a0,0xb
ffffffffc02010fa:	df250513          	addi	a0,a0,-526 # ffffffffc020bee8 <commands+0x740>
ffffffffc02010fe:	b7d9                	j	ffffffffc02010c4 <exception_handler+0x4c>
ffffffffc0201100:	0000b517          	auipc	a0,0xb
ffffffffc0201104:	e0850513          	addi	a0,a0,-504 # ffffffffc020bf08 <commands+0x760>
ffffffffc0201108:	bf75                	j	ffffffffc02010c4 <exception_handler+0x4c>
ffffffffc020110a:	0000b517          	auipc	a0,0xb
ffffffffc020110e:	e1e50513          	addi	a0,a0,-482 # ffffffffc020bf28 <commands+0x780>
ffffffffc0201112:	bf4d                	j	ffffffffc02010c4 <exception_handler+0x4c>
ffffffffc0201114:	0000b517          	auipc	a0,0xb
ffffffffc0201118:	e2c50513          	addi	a0,a0,-468 # ffffffffc020bf40 <commands+0x798>
ffffffffc020111c:	b765                	j	ffffffffc02010c4 <exception_handler+0x4c>
ffffffffc020111e:	0000b517          	auipc	a0,0xb
ffffffffc0201122:	e3250513          	addi	a0,a0,-462 # ffffffffc020bf50 <commands+0x7a8>
ffffffffc0201126:	bf79                	j	ffffffffc02010c4 <exception_handler+0x4c>
ffffffffc0201128:	0000b517          	auipc	a0,0xb
ffffffffc020112c:	e4850513          	addi	a0,a0,-440 # ffffffffc020bf70 <commands+0x7c8>
ffffffffc0201130:	bf51                	j	ffffffffc02010c4 <exception_handler+0x4c>
ffffffffc0201132:	0000b517          	auipc	a0,0xb
ffffffffc0201136:	e8650513          	addi	a0,a0,-378 # ffffffffc020bfb8 <commands+0x810>
ffffffffc020113a:	b769                	j	ffffffffc02010c4 <exception_handler+0x4c>
ffffffffc020113c:	8522                	mv	a0,s0
ffffffffc020113e:	6402                	ld	s0,0(sp)
ffffffffc0201140:	60a2                	ld	ra,8(sp)
ffffffffc0201142:	0141                	addi	sp,sp,16
ffffffffc0201144:	b5b9                	j	ffffffffc0200f92 <print_trapframe>
ffffffffc0201146:	0000b617          	auipc	a2,0xb
ffffffffc020114a:	e4260613          	addi	a2,a2,-446 # ffffffffc020bf88 <commands+0x7e0>
ffffffffc020114e:	0b100593          	li	a1,177
ffffffffc0201152:	0000b517          	auipc	a0,0xb
ffffffffc0201156:	e4e50513          	addi	a0,a0,-434 # ffffffffc020bfa0 <commands+0x7f8>
ffffffffc020115a:	8d4ff0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020115e <trap>:
ffffffffc020115e:	1101                	addi	sp,sp,-32
ffffffffc0201160:	e822                	sd	s0,16(sp)
ffffffffc0201162:	00095417          	auipc	s0,0x95
ffffffffc0201166:	75e40413          	addi	s0,s0,1886 # ffffffffc02968c0 <current>
ffffffffc020116a:	6018                	ld	a4,0(s0)
ffffffffc020116c:	ec06                	sd	ra,24(sp)
ffffffffc020116e:	e426                	sd	s1,8(sp)
ffffffffc0201170:	e04a                	sd	s2,0(sp)
ffffffffc0201172:	11853683          	ld	a3,280(a0)
ffffffffc0201176:	cf1d                	beqz	a4,ffffffffc02011b4 <trap+0x56>
ffffffffc0201178:	10053483          	ld	s1,256(a0)
ffffffffc020117c:	0a073903          	ld	s2,160(a4)
ffffffffc0201180:	f348                	sd	a0,160(a4)
ffffffffc0201182:	1004f493          	andi	s1,s1,256
ffffffffc0201186:	0206c463          	bltz	a3,ffffffffc02011ae <trap+0x50>
ffffffffc020118a:	eefff0ef          	jal	ra,ffffffffc0201078 <exception_handler>
ffffffffc020118e:	601c                	ld	a5,0(s0)
ffffffffc0201190:	0b27b023          	sd	s2,160(a5) # 400a0 <_binary_bin_swap_img_size+0x383a0>
ffffffffc0201194:	e499                	bnez	s1,ffffffffc02011a2 <trap+0x44>
ffffffffc0201196:	0b07a703          	lw	a4,176(a5)
ffffffffc020119a:	8b05                	andi	a4,a4,1
ffffffffc020119c:	e329                	bnez	a4,ffffffffc02011de <trap+0x80>
ffffffffc020119e:	6f9c                	ld	a5,24(a5)
ffffffffc02011a0:	eb85                	bnez	a5,ffffffffc02011d0 <trap+0x72>
ffffffffc02011a2:	60e2                	ld	ra,24(sp)
ffffffffc02011a4:	6442                	ld	s0,16(sp)
ffffffffc02011a6:	64a2                	ld	s1,8(sp)
ffffffffc02011a8:	6902                	ld	s2,0(sp)
ffffffffc02011aa:	6105                	addi	sp,sp,32
ffffffffc02011ac:	8082                	ret
ffffffffc02011ae:	e47ff0ef          	jal	ra,ffffffffc0200ff4 <interrupt_handler>
ffffffffc02011b2:	bff1                	j	ffffffffc020118e <trap+0x30>
ffffffffc02011b4:	0006c863          	bltz	a3,ffffffffc02011c4 <trap+0x66>
ffffffffc02011b8:	6442                	ld	s0,16(sp)
ffffffffc02011ba:	60e2                	ld	ra,24(sp)
ffffffffc02011bc:	64a2                	ld	s1,8(sp)
ffffffffc02011be:	6902                	ld	s2,0(sp)
ffffffffc02011c0:	6105                	addi	sp,sp,32
ffffffffc02011c2:	bd5d                	j	ffffffffc0201078 <exception_handler>
ffffffffc02011c4:	6442                	ld	s0,16(sp)
ffffffffc02011c6:	60e2                	ld	ra,24(sp)
ffffffffc02011c8:	64a2                	ld	s1,8(sp)
ffffffffc02011ca:	6902                	ld	s2,0(sp)
ffffffffc02011cc:	6105                	addi	sp,sp,32
ffffffffc02011ce:	b51d                	j	ffffffffc0200ff4 <interrupt_handler>
ffffffffc02011d0:	6442                	ld	s0,16(sp)
ffffffffc02011d2:	60e2                	ld	ra,24(sp)
ffffffffc02011d4:	64a2                	ld	s1,8(sp)
ffffffffc02011d6:	6902                	ld	s2,0(sp)
ffffffffc02011d8:	6105                	addi	sp,sp,32
ffffffffc02011da:	0480606f          	j	ffffffffc0207222 <schedule>
ffffffffc02011de:	555d                	li	a0,-9
ffffffffc02011e0:	68f040ef          	jal	ra,ffffffffc020606e <do_exit>
ffffffffc02011e4:	601c                	ld	a5,0(s0)
ffffffffc02011e6:	bf65                	j	ffffffffc020119e <trap+0x40>

ffffffffc02011e8 <__alltraps>:
ffffffffc02011e8:	14011173          	csrrw	sp,sscratch,sp
ffffffffc02011ec:	00011463          	bnez	sp,ffffffffc02011f4 <__alltraps+0xc>
ffffffffc02011f0:	14002173          	csrr	sp,sscratch
ffffffffc02011f4:	712d                	addi	sp,sp,-288
ffffffffc02011f6:	e002                	sd	zero,0(sp)
ffffffffc02011f8:	e406                	sd	ra,8(sp)
ffffffffc02011fa:	ec0e                	sd	gp,24(sp)
ffffffffc02011fc:	f012                	sd	tp,32(sp)
ffffffffc02011fe:	f416                	sd	t0,40(sp)
ffffffffc0201200:	f81a                	sd	t1,48(sp)
ffffffffc0201202:	fc1e                	sd	t2,56(sp)
ffffffffc0201204:	e0a2                	sd	s0,64(sp)
ffffffffc0201206:	e4a6                	sd	s1,72(sp)
ffffffffc0201208:	e8aa                	sd	a0,80(sp)
ffffffffc020120a:	ecae                	sd	a1,88(sp)
ffffffffc020120c:	f0b2                	sd	a2,96(sp)
ffffffffc020120e:	f4b6                	sd	a3,104(sp)
ffffffffc0201210:	f8ba                	sd	a4,112(sp)
ffffffffc0201212:	fcbe                	sd	a5,120(sp)
ffffffffc0201214:	e142                	sd	a6,128(sp)
ffffffffc0201216:	e546                	sd	a7,136(sp)
ffffffffc0201218:	e94a                	sd	s2,144(sp)
ffffffffc020121a:	ed4e                	sd	s3,152(sp)
ffffffffc020121c:	f152                	sd	s4,160(sp)
ffffffffc020121e:	f556                	sd	s5,168(sp)
ffffffffc0201220:	f95a                	sd	s6,176(sp)
ffffffffc0201222:	fd5e                	sd	s7,184(sp)
ffffffffc0201224:	e1e2                	sd	s8,192(sp)
ffffffffc0201226:	e5e6                	sd	s9,200(sp)
ffffffffc0201228:	e9ea                	sd	s10,208(sp)
ffffffffc020122a:	edee                	sd	s11,216(sp)
ffffffffc020122c:	f1f2                	sd	t3,224(sp)
ffffffffc020122e:	f5f6                	sd	t4,232(sp)
ffffffffc0201230:	f9fa                	sd	t5,240(sp)
ffffffffc0201232:	fdfe                	sd	t6,248(sp)
ffffffffc0201234:	14001473          	csrrw	s0,sscratch,zero
ffffffffc0201238:	100024f3          	csrr	s1,sstatus
ffffffffc020123c:	14102973          	csrr	s2,sepc
ffffffffc0201240:	143029f3          	csrr	s3,stval
ffffffffc0201244:	14202a73          	csrr	s4,scause
ffffffffc0201248:	e822                	sd	s0,16(sp)
ffffffffc020124a:	e226                	sd	s1,256(sp)
ffffffffc020124c:	e64a                	sd	s2,264(sp)
ffffffffc020124e:	ea4e                	sd	s3,272(sp)
ffffffffc0201250:	ee52                	sd	s4,280(sp)
ffffffffc0201252:	850a                	mv	a0,sp
ffffffffc0201254:	f0bff0ef          	jal	ra,ffffffffc020115e <trap>

ffffffffc0201258 <__trapret>:
ffffffffc0201258:	6492                	ld	s1,256(sp)
ffffffffc020125a:	6932                	ld	s2,264(sp)
ffffffffc020125c:	1004f413          	andi	s0,s1,256
ffffffffc0201260:	e401                	bnez	s0,ffffffffc0201268 <__trapret+0x10>
ffffffffc0201262:	1200                	addi	s0,sp,288
ffffffffc0201264:	14041073          	csrw	sscratch,s0
ffffffffc0201268:	10049073          	csrw	sstatus,s1
ffffffffc020126c:	14191073          	csrw	sepc,s2
ffffffffc0201270:	60a2                	ld	ra,8(sp)
ffffffffc0201272:	61e2                	ld	gp,24(sp)
ffffffffc0201274:	7202                	ld	tp,32(sp)
ffffffffc0201276:	72a2                	ld	t0,40(sp)
ffffffffc0201278:	7342                	ld	t1,48(sp)
ffffffffc020127a:	73e2                	ld	t2,56(sp)
ffffffffc020127c:	6406                	ld	s0,64(sp)
ffffffffc020127e:	64a6                	ld	s1,72(sp)
ffffffffc0201280:	6546                	ld	a0,80(sp)
ffffffffc0201282:	65e6                	ld	a1,88(sp)
ffffffffc0201284:	7606                	ld	a2,96(sp)
ffffffffc0201286:	76a6                	ld	a3,104(sp)
ffffffffc0201288:	7746                	ld	a4,112(sp)
ffffffffc020128a:	77e6                	ld	a5,120(sp)
ffffffffc020128c:	680a                	ld	a6,128(sp)
ffffffffc020128e:	68aa                	ld	a7,136(sp)
ffffffffc0201290:	694a                	ld	s2,144(sp)
ffffffffc0201292:	69ea                	ld	s3,152(sp)
ffffffffc0201294:	7a0a                	ld	s4,160(sp)
ffffffffc0201296:	7aaa                	ld	s5,168(sp)
ffffffffc0201298:	7b4a                	ld	s6,176(sp)
ffffffffc020129a:	7bea                	ld	s7,184(sp)
ffffffffc020129c:	6c0e                	ld	s8,192(sp)
ffffffffc020129e:	6cae                	ld	s9,200(sp)
ffffffffc02012a0:	6d4e                	ld	s10,208(sp)
ffffffffc02012a2:	6dee                	ld	s11,216(sp)
ffffffffc02012a4:	7e0e                	ld	t3,224(sp)
ffffffffc02012a6:	7eae                	ld	t4,232(sp)
ffffffffc02012a8:	7f4e                	ld	t5,240(sp)
ffffffffc02012aa:	7fee                	ld	t6,248(sp)
ffffffffc02012ac:	6142                	ld	sp,16(sp)
ffffffffc02012ae:	10200073          	sret

ffffffffc02012b2 <forkrets>:
ffffffffc02012b2:	812a                	mv	sp,a0
ffffffffc02012b4:	b755                	j	ffffffffc0201258 <__trapret>

ffffffffc02012b6 <pa2page.part.0>:
ffffffffc02012b6:	1141                	addi	sp,sp,-16
ffffffffc02012b8:	0000b617          	auipc	a2,0xb
ffffffffc02012bc:	e0060613          	addi	a2,a2,-512 # ffffffffc020c0b8 <commands+0x910>
ffffffffc02012c0:	06900593          	li	a1,105
ffffffffc02012c4:	0000b517          	auipc	a0,0xb
ffffffffc02012c8:	e1450513          	addi	a0,a0,-492 # ffffffffc020c0d8 <commands+0x930>
ffffffffc02012cc:	e406                	sd	ra,8(sp)
ffffffffc02012ce:	f61fe0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02012d2 <pte2page.part.0>:
ffffffffc02012d2:	1141                	addi	sp,sp,-16
ffffffffc02012d4:	0000b617          	auipc	a2,0xb
ffffffffc02012d8:	e1460613          	addi	a2,a2,-492 # ffffffffc020c0e8 <commands+0x940>
ffffffffc02012dc:	07f00593          	li	a1,127
ffffffffc02012e0:	0000b517          	auipc	a0,0xb
ffffffffc02012e4:	df850513          	addi	a0,a0,-520 # ffffffffc020c0d8 <commands+0x930>
ffffffffc02012e8:	e406                	sd	ra,8(sp)
ffffffffc02012ea:	f45fe0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02012ee <alloc_pages>:
ffffffffc02012ee:	100027f3          	csrr	a5,sstatus
ffffffffc02012f2:	8b89                	andi	a5,a5,2
ffffffffc02012f4:	e799                	bnez	a5,ffffffffc0201302 <alloc_pages+0x14>
ffffffffc02012f6:	00095797          	auipc	a5,0x95
ffffffffc02012fa:	5b27b783          	ld	a5,1458(a5) # ffffffffc02968a8 <pmm_manager>
ffffffffc02012fe:	6f9c                	ld	a5,24(a5)
ffffffffc0201300:	8782                	jr	a5
ffffffffc0201302:	1141                	addi	sp,sp,-16
ffffffffc0201304:	e406                	sd	ra,8(sp)
ffffffffc0201306:	e022                	sd	s0,0(sp)
ffffffffc0201308:	842a                	mv	s0,a0
ffffffffc020130a:	a9bff0ef          	jal	ra,ffffffffc0200da4 <intr_disable>
ffffffffc020130e:	00095797          	auipc	a5,0x95
ffffffffc0201312:	59a7b783          	ld	a5,1434(a5) # ffffffffc02968a8 <pmm_manager>
ffffffffc0201316:	6f9c                	ld	a5,24(a5)
ffffffffc0201318:	8522                	mv	a0,s0
ffffffffc020131a:	9782                	jalr	a5
ffffffffc020131c:	842a                	mv	s0,a0
ffffffffc020131e:	a81ff0ef          	jal	ra,ffffffffc0200d9e <intr_enable>
ffffffffc0201322:	60a2                	ld	ra,8(sp)
ffffffffc0201324:	8522                	mv	a0,s0
ffffffffc0201326:	6402                	ld	s0,0(sp)
ffffffffc0201328:	0141                	addi	sp,sp,16
ffffffffc020132a:	8082                	ret

ffffffffc020132c <free_pages>:
ffffffffc020132c:	100027f3          	csrr	a5,sstatus
ffffffffc0201330:	8b89                	andi	a5,a5,2
ffffffffc0201332:	e799                	bnez	a5,ffffffffc0201340 <free_pages+0x14>
ffffffffc0201334:	00095797          	auipc	a5,0x95
ffffffffc0201338:	5747b783          	ld	a5,1396(a5) # ffffffffc02968a8 <pmm_manager>
ffffffffc020133c:	739c                	ld	a5,32(a5)
ffffffffc020133e:	8782                	jr	a5
ffffffffc0201340:	1101                	addi	sp,sp,-32
ffffffffc0201342:	ec06                	sd	ra,24(sp)
ffffffffc0201344:	e822                	sd	s0,16(sp)
ffffffffc0201346:	e426                	sd	s1,8(sp)
ffffffffc0201348:	842a                	mv	s0,a0
ffffffffc020134a:	84ae                	mv	s1,a1
ffffffffc020134c:	a59ff0ef          	jal	ra,ffffffffc0200da4 <intr_disable>
ffffffffc0201350:	00095797          	auipc	a5,0x95
ffffffffc0201354:	5587b783          	ld	a5,1368(a5) # ffffffffc02968a8 <pmm_manager>
ffffffffc0201358:	739c                	ld	a5,32(a5)
ffffffffc020135a:	85a6                	mv	a1,s1
ffffffffc020135c:	8522                	mv	a0,s0
ffffffffc020135e:	9782                	jalr	a5
ffffffffc0201360:	6442                	ld	s0,16(sp)
ffffffffc0201362:	60e2                	ld	ra,24(sp)
ffffffffc0201364:	64a2                	ld	s1,8(sp)
ffffffffc0201366:	6105                	addi	sp,sp,32
ffffffffc0201368:	a37ff06f          	j	ffffffffc0200d9e <intr_enable>

ffffffffc020136c <nr_free_pages>:
ffffffffc020136c:	100027f3          	csrr	a5,sstatus
ffffffffc0201370:	8b89                	andi	a5,a5,2
ffffffffc0201372:	e799                	bnez	a5,ffffffffc0201380 <nr_free_pages+0x14>
ffffffffc0201374:	00095797          	auipc	a5,0x95
ffffffffc0201378:	5347b783          	ld	a5,1332(a5) # ffffffffc02968a8 <pmm_manager>
ffffffffc020137c:	779c                	ld	a5,40(a5)
ffffffffc020137e:	8782                	jr	a5
ffffffffc0201380:	1141                	addi	sp,sp,-16
ffffffffc0201382:	e406                	sd	ra,8(sp)
ffffffffc0201384:	e022                	sd	s0,0(sp)
ffffffffc0201386:	a1fff0ef          	jal	ra,ffffffffc0200da4 <intr_disable>
ffffffffc020138a:	00095797          	auipc	a5,0x95
ffffffffc020138e:	51e7b783          	ld	a5,1310(a5) # ffffffffc02968a8 <pmm_manager>
ffffffffc0201392:	779c                	ld	a5,40(a5)
ffffffffc0201394:	9782                	jalr	a5
ffffffffc0201396:	842a                	mv	s0,a0
ffffffffc0201398:	a07ff0ef          	jal	ra,ffffffffc0200d9e <intr_enable>
ffffffffc020139c:	60a2                	ld	ra,8(sp)
ffffffffc020139e:	8522                	mv	a0,s0
ffffffffc02013a0:	6402                	ld	s0,0(sp)
ffffffffc02013a2:	0141                	addi	sp,sp,16
ffffffffc02013a4:	8082                	ret

ffffffffc02013a6 <get_pte>:
ffffffffc02013a6:	01e5d793          	srli	a5,a1,0x1e
ffffffffc02013aa:	1ff7f793          	andi	a5,a5,511
ffffffffc02013ae:	7139                	addi	sp,sp,-64
ffffffffc02013b0:	078e                	slli	a5,a5,0x3
ffffffffc02013b2:	f426                	sd	s1,40(sp)
ffffffffc02013b4:	00f504b3          	add	s1,a0,a5
ffffffffc02013b8:	6094                	ld	a3,0(s1)
ffffffffc02013ba:	f04a                	sd	s2,32(sp)
ffffffffc02013bc:	ec4e                	sd	s3,24(sp)
ffffffffc02013be:	e852                	sd	s4,16(sp)
ffffffffc02013c0:	fc06                	sd	ra,56(sp)
ffffffffc02013c2:	f822                	sd	s0,48(sp)
ffffffffc02013c4:	e456                	sd	s5,8(sp)
ffffffffc02013c6:	e05a                	sd	s6,0(sp)
ffffffffc02013c8:	0016f793          	andi	a5,a3,1
ffffffffc02013cc:	892e                	mv	s2,a1
ffffffffc02013ce:	8a32                	mv	s4,a2
ffffffffc02013d0:	00095997          	auipc	s3,0x95
ffffffffc02013d4:	4c898993          	addi	s3,s3,1224 # ffffffffc0296898 <npage>
ffffffffc02013d8:	efbd                	bnez	a5,ffffffffc0201456 <get_pte+0xb0>
ffffffffc02013da:	14060c63          	beqz	a2,ffffffffc0201532 <get_pte+0x18c>
ffffffffc02013de:	100027f3          	csrr	a5,sstatus
ffffffffc02013e2:	8b89                	andi	a5,a5,2
ffffffffc02013e4:	14079963          	bnez	a5,ffffffffc0201536 <get_pte+0x190>
ffffffffc02013e8:	00095797          	auipc	a5,0x95
ffffffffc02013ec:	4c07b783          	ld	a5,1216(a5) # ffffffffc02968a8 <pmm_manager>
ffffffffc02013f0:	6f9c                	ld	a5,24(a5)
ffffffffc02013f2:	4505                	li	a0,1
ffffffffc02013f4:	9782                	jalr	a5
ffffffffc02013f6:	842a                	mv	s0,a0
ffffffffc02013f8:	12040d63          	beqz	s0,ffffffffc0201532 <get_pte+0x18c>
ffffffffc02013fc:	00095b17          	auipc	s6,0x95
ffffffffc0201400:	4a4b0b13          	addi	s6,s6,1188 # ffffffffc02968a0 <pages>
ffffffffc0201404:	000b3503          	ld	a0,0(s6)
ffffffffc0201408:	00080ab7          	lui	s5,0x80
ffffffffc020140c:	00095997          	auipc	s3,0x95
ffffffffc0201410:	48c98993          	addi	s3,s3,1164 # ffffffffc0296898 <npage>
ffffffffc0201414:	40a40533          	sub	a0,s0,a0
ffffffffc0201418:	8519                	srai	a0,a0,0x6
ffffffffc020141a:	9556                	add	a0,a0,s5
ffffffffc020141c:	0009b703          	ld	a4,0(s3)
ffffffffc0201420:	00c51793          	slli	a5,a0,0xc
ffffffffc0201424:	4685                	li	a3,1
ffffffffc0201426:	c014                	sw	a3,0(s0)
ffffffffc0201428:	83b1                	srli	a5,a5,0xc
ffffffffc020142a:	0532                	slli	a0,a0,0xc
ffffffffc020142c:	16e7f763          	bgeu	a5,a4,ffffffffc020159a <get_pte+0x1f4>
ffffffffc0201430:	00095797          	auipc	a5,0x95
ffffffffc0201434:	4807b783          	ld	a5,1152(a5) # ffffffffc02968b0 <va_pa_offset>
ffffffffc0201438:	6605                	lui	a2,0x1
ffffffffc020143a:	4581                	li	a1,0
ffffffffc020143c:	953e                	add	a0,a0,a5
ffffffffc020143e:	3c1090ef          	jal	ra,ffffffffc020affe <memset>
ffffffffc0201442:	000b3683          	ld	a3,0(s6)
ffffffffc0201446:	40d406b3          	sub	a3,s0,a3
ffffffffc020144a:	8699                	srai	a3,a3,0x6
ffffffffc020144c:	96d6                	add	a3,a3,s5
ffffffffc020144e:	06aa                	slli	a3,a3,0xa
ffffffffc0201450:	0116e693          	ori	a3,a3,17
ffffffffc0201454:	e094                	sd	a3,0(s1)
ffffffffc0201456:	77fd                	lui	a5,0xfffff
ffffffffc0201458:	068a                	slli	a3,a3,0x2
ffffffffc020145a:	0009b703          	ld	a4,0(s3)
ffffffffc020145e:	8efd                	and	a3,a3,a5
ffffffffc0201460:	00c6d793          	srli	a5,a3,0xc
ffffffffc0201464:	10e7ff63          	bgeu	a5,a4,ffffffffc0201582 <get_pte+0x1dc>
ffffffffc0201468:	00095a97          	auipc	s5,0x95
ffffffffc020146c:	448a8a93          	addi	s5,s5,1096 # ffffffffc02968b0 <va_pa_offset>
ffffffffc0201470:	000ab403          	ld	s0,0(s5)
ffffffffc0201474:	01595793          	srli	a5,s2,0x15
ffffffffc0201478:	1ff7f793          	andi	a5,a5,511
ffffffffc020147c:	96a2                	add	a3,a3,s0
ffffffffc020147e:	00379413          	slli	s0,a5,0x3
ffffffffc0201482:	9436                	add	s0,s0,a3
ffffffffc0201484:	6014                	ld	a3,0(s0)
ffffffffc0201486:	0016f793          	andi	a5,a3,1
ffffffffc020148a:	ebad                	bnez	a5,ffffffffc02014fc <get_pte+0x156>
ffffffffc020148c:	0a0a0363          	beqz	s4,ffffffffc0201532 <get_pte+0x18c>
ffffffffc0201490:	100027f3          	csrr	a5,sstatus
ffffffffc0201494:	8b89                	andi	a5,a5,2
ffffffffc0201496:	efcd                	bnez	a5,ffffffffc0201550 <get_pte+0x1aa>
ffffffffc0201498:	00095797          	auipc	a5,0x95
ffffffffc020149c:	4107b783          	ld	a5,1040(a5) # ffffffffc02968a8 <pmm_manager>
ffffffffc02014a0:	6f9c                	ld	a5,24(a5)
ffffffffc02014a2:	4505                	li	a0,1
ffffffffc02014a4:	9782                	jalr	a5
ffffffffc02014a6:	84aa                	mv	s1,a0
ffffffffc02014a8:	c4c9                	beqz	s1,ffffffffc0201532 <get_pte+0x18c>
ffffffffc02014aa:	00095b17          	auipc	s6,0x95
ffffffffc02014ae:	3f6b0b13          	addi	s6,s6,1014 # ffffffffc02968a0 <pages>
ffffffffc02014b2:	000b3503          	ld	a0,0(s6)
ffffffffc02014b6:	00080a37          	lui	s4,0x80
ffffffffc02014ba:	0009b703          	ld	a4,0(s3)
ffffffffc02014be:	40a48533          	sub	a0,s1,a0
ffffffffc02014c2:	8519                	srai	a0,a0,0x6
ffffffffc02014c4:	9552                	add	a0,a0,s4
ffffffffc02014c6:	00c51793          	slli	a5,a0,0xc
ffffffffc02014ca:	4685                	li	a3,1
ffffffffc02014cc:	c094                	sw	a3,0(s1)
ffffffffc02014ce:	83b1                	srli	a5,a5,0xc
ffffffffc02014d0:	0532                	slli	a0,a0,0xc
ffffffffc02014d2:	0ee7f163          	bgeu	a5,a4,ffffffffc02015b4 <get_pte+0x20e>
ffffffffc02014d6:	000ab783          	ld	a5,0(s5)
ffffffffc02014da:	6605                	lui	a2,0x1
ffffffffc02014dc:	4581                	li	a1,0
ffffffffc02014de:	953e                	add	a0,a0,a5
ffffffffc02014e0:	31f090ef          	jal	ra,ffffffffc020affe <memset>
ffffffffc02014e4:	000b3683          	ld	a3,0(s6)
ffffffffc02014e8:	40d486b3          	sub	a3,s1,a3
ffffffffc02014ec:	8699                	srai	a3,a3,0x6
ffffffffc02014ee:	96d2                	add	a3,a3,s4
ffffffffc02014f0:	06aa                	slli	a3,a3,0xa
ffffffffc02014f2:	0116e693          	ori	a3,a3,17
ffffffffc02014f6:	e014                	sd	a3,0(s0)
ffffffffc02014f8:	0009b703          	ld	a4,0(s3)
ffffffffc02014fc:	068a                	slli	a3,a3,0x2
ffffffffc02014fe:	757d                	lui	a0,0xfffff
ffffffffc0201500:	8ee9                	and	a3,a3,a0
ffffffffc0201502:	00c6d793          	srli	a5,a3,0xc
ffffffffc0201506:	06e7f263          	bgeu	a5,a4,ffffffffc020156a <get_pte+0x1c4>
ffffffffc020150a:	000ab503          	ld	a0,0(s5)
ffffffffc020150e:	00c95913          	srli	s2,s2,0xc
ffffffffc0201512:	1ff97913          	andi	s2,s2,511
ffffffffc0201516:	96aa                	add	a3,a3,a0
ffffffffc0201518:	00391513          	slli	a0,s2,0x3
ffffffffc020151c:	9536                	add	a0,a0,a3
ffffffffc020151e:	70e2                	ld	ra,56(sp)
ffffffffc0201520:	7442                	ld	s0,48(sp)
ffffffffc0201522:	74a2                	ld	s1,40(sp)
ffffffffc0201524:	7902                	ld	s2,32(sp)
ffffffffc0201526:	69e2                	ld	s3,24(sp)
ffffffffc0201528:	6a42                	ld	s4,16(sp)
ffffffffc020152a:	6aa2                	ld	s5,8(sp)
ffffffffc020152c:	6b02                	ld	s6,0(sp)
ffffffffc020152e:	6121                	addi	sp,sp,64
ffffffffc0201530:	8082                	ret
ffffffffc0201532:	4501                	li	a0,0
ffffffffc0201534:	b7ed                	j	ffffffffc020151e <get_pte+0x178>
ffffffffc0201536:	86fff0ef          	jal	ra,ffffffffc0200da4 <intr_disable>
ffffffffc020153a:	00095797          	auipc	a5,0x95
ffffffffc020153e:	36e7b783          	ld	a5,878(a5) # ffffffffc02968a8 <pmm_manager>
ffffffffc0201542:	6f9c                	ld	a5,24(a5)
ffffffffc0201544:	4505                	li	a0,1
ffffffffc0201546:	9782                	jalr	a5
ffffffffc0201548:	842a                	mv	s0,a0
ffffffffc020154a:	855ff0ef          	jal	ra,ffffffffc0200d9e <intr_enable>
ffffffffc020154e:	b56d                	j	ffffffffc02013f8 <get_pte+0x52>
ffffffffc0201550:	855ff0ef          	jal	ra,ffffffffc0200da4 <intr_disable>
ffffffffc0201554:	00095797          	auipc	a5,0x95
ffffffffc0201558:	3547b783          	ld	a5,852(a5) # ffffffffc02968a8 <pmm_manager>
ffffffffc020155c:	6f9c                	ld	a5,24(a5)
ffffffffc020155e:	4505                	li	a0,1
ffffffffc0201560:	9782                	jalr	a5
ffffffffc0201562:	84aa                	mv	s1,a0
ffffffffc0201564:	83bff0ef          	jal	ra,ffffffffc0200d9e <intr_enable>
ffffffffc0201568:	b781                	j	ffffffffc02014a8 <get_pte+0x102>
ffffffffc020156a:	0000b617          	auipc	a2,0xb
ffffffffc020156e:	ba660613          	addi	a2,a2,-1114 # ffffffffc020c110 <commands+0x968>
ffffffffc0201572:	13200593          	li	a1,306
ffffffffc0201576:	0000b517          	auipc	a0,0xb
ffffffffc020157a:	bc250513          	addi	a0,a0,-1086 # ffffffffc020c138 <commands+0x990>
ffffffffc020157e:	cb1fe0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0201582:	0000b617          	auipc	a2,0xb
ffffffffc0201586:	b8e60613          	addi	a2,a2,-1138 # ffffffffc020c110 <commands+0x968>
ffffffffc020158a:	12500593          	li	a1,293
ffffffffc020158e:	0000b517          	auipc	a0,0xb
ffffffffc0201592:	baa50513          	addi	a0,a0,-1110 # ffffffffc020c138 <commands+0x990>
ffffffffc0201596:	c99fe0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020159a:	86aa                	mv	a3,a0
ffffffffc020159c:	0000b617          	auipc	a2,0xb
ffffffffc02015a0:	b7460613          	addi	a2,a2,-1164 # ffffffffc020c110 <commands+0x968>
ffffffffc02015a4:	12100593          	li	a1,289
ffffffffc02015a8:	0000b517          	auipc	a0,0xb
ffffffffc02015ac:	b9050513          	addi	a0,a0,-1136 # ffffffffc020c138 <commands+0x990>
ffffffffc02015b0:	c7ffe0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02015b4:	86aa                	mv	a3,a0
ffffffffc02015b6:	0000b617          	auipc	a2,0xb
ffffffffc02015ba:	b5a60613          	addi	a2,a2,-1190 # ffffffffc020c110 <commands+0x968>
ffffffffc02015be:	12f00593          	li	a1,303
ffffffffc02015c2:	0000b517          	auipc	a0,0xb
ffffffffc02015c6:	b7650513          	addi	a0,a0,-1162 # ffffffffc020c138 <commands+0x990>
ffffffffc02015ca:	c65fe0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02015ce <boot_map_segment>:
ffffffffc02015ce:	6785                	lui	a5,0x1
ffffffffc02015d0:	7139                	addi	sp,sp,-64
ffffffffc02015d2:	00d5c833          	xor	a6,a1,a3
ffffffffc02015d6:	17fd                	addi	a5,a5,-1
ffffffffc02015d8:	fc06                	sd	ra,56(sp)
ffffffffc02015da:	f822                	sd	s0,48(sp)
ffffffffc02015dc:	f426                	sd	s1,40(sp)
ffffffffc02015de:	f04a                	sd	s2,32(sp)
ffffffffc02015e0:	ec4e                	sd	s3,24(sp)
ffffffffc02015e2:	e852                	sd	s4,16(sp)
ffffffffc02015e4:	e456                	sd	s5,8(sp)
ffffffffc02015e6:	00f87833          	and	a6,a6,a5
ffffffffc02015ea:	08081563          	bnez	a6,ffffffffc0201674 <boot_map_segment+0xa6>
ffffffffc02015ee:	00f5f4b3          	and	s1,a1,a5
ffffffffc02015f2:	963e                	add	a2,a2,a5
ffffffffc02015f4:	94b2                	add	s1,s1,a2
ffffffffc02015f6:	797d                	lui	s2,0xfffff
ffffffffc02015f8:	80b1                	srli	s1,s1,0xc
ffffffffc02015fa:	0125f5b3          	and	a1,a1,s2
ffffffffc02015fe:	0126f6b3          	and	a3,a3,s2
ffffffffc0201602:	c0a1                	beqz	s1,ffffffffc0201642 <boot_map_segment+0x74>
ffffffffc0201604:	00176713          	ori	a4,a4,1
ffffffffc0201608:	04b2                	slli	s1,s1,0xc
ffffffffc020160a:	02071993          	slli	s3,a4,0x20
ffffffffc020160e:	8a2a                	mv	s4,a0
ffffffffc0201610:	842e                	mv	s0,a1
ffffffffc0201612:	94ae                	add	s1,s1,a1
ffffffffc0201614:	40b68933          	sub	s2,a3,a1
ffffffffc0201618:	0209d993          	srli	s3,s3,0x20
ffffffffc020161c:	6a85                	lui	s5,0x1
ffffffffc020161e:	4605                	li	a2,1
ffffffffc0201620:	85a2                	mv	a1,s0
ffffffffc0201622:	8552                	mv	a0,s4
ffffffffc0201624:	d83ff0ef          	jal	ra,ffffffffc02013a6 <get_pte>
ffffffffc0201628:	008907b3          	add	a5,s2,s0
ffffffffc020162c:	c505                	beqz	a0,ffffffffc0201654 <boot_map_segment+0x86>
ffffffffc020162e:	83b1                	srli	a5,a5,0xc
ffffffffc0201630:	07aa                	slli	a5,a5,0xa
ffffffffc0201632:	0137e7b3          	or	a5,a5,s3
ffffffffc0201636:	0017e793          	ori	a5,a5,1
ffffffffc020163a:	e11c                	sd	a5,0(a0)
ffffffffc020163c:	9456                	add	s0,s0,s5
ffffffffc020163e:	fe8490e3          	bne	s1,s0,ffffffffc020161e <boot_map_segment+0x50>
ffffffffc0201642:	70e2                	ld	ra,56(sp)
ffffffffc0201644:	7442                	ld	s0,48(sp)
ffffffffc0201646:	74a2                	ld	s1,40(sp)
ffffffffc0201648:	7902                	ld	s2,32(sp)
ffffffffc020164a:	69e2                	ld	s3,24(sp)
ffffffffc020164c:	6a42                	ld	s4,16(sp)
ffffffffc020164e:	6aa2                	ld	s5,8(sp)
ffffffffc0201650:	6121                	addi	sp,sp,64
ffffffffc0201652:	8082                	ret
ffffffffc0201654:	0000b697          	auipc	a3,0xb
ffffffffc0201658:	b0c68693          	addi	a3,a3,-1268 # ffffffffc020c160 <commands+0x9b8>
ffffffffc020165c:	0000a617          	auipc	a2,0xa
ffffffffc0201660:	1ac60613          	addi	a2,a2,428 # ffffffffc020b808 <commands+0x60>
ffffffffc0201664:	09c00593          	li	a1,156
ffffffffc0201668:	0000b517          	auipc	a0,0xb
ffffffffc020166c:	ad050513          	addi	a0,a0,-1328 # ffffffffc020c138 <commands+0x990>
ffffffffc0201670:	bbffe0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0201674:	0000b697          	auipc	a3,0xb
ffffffffc0201678:	ad468693          	addi	a3,a3,-1324 # ffffffffc020c148 <commands+0x9a0>
ffffffffc020167c:	0000a617          	auipc	a2,0xa
ffffffffc0201680:	18c60613          	addi	a2,a2,396 # ffffffffc020b808 <commands+0x60>
ffffffffc0201684:	09500593          	li	a1,149
ffffffffc0201688:	0000b517          	auipc	a0,0xb
ffffffffc020168c:	ab050513          	addi	a0,a0,-1360 # ffffffffc020c138 <commands+0x990>
ffffffffc0201690:	b9ffe0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0201694 <get_page>:
ffffffffc0201694:	1141                	addi	sp,sp,-16
ffffffffc0201696:	e022                	sd	s0,0(sp)
ffffffffc0201698:	8432                	mv	s0,a2
ffffffffc020169a:	4601                	li	a2,0
ffffffffc020169c:	e406                	sd	ra,8(sp)
ffffffffc020169e:	d09ff0ef          	jal	ra,ffffffffc02013a6 <get_pte>
ffffffffc02016a2:	c011                	beqz	s0,ffffffffc02016a6 <get_page+0x12>
ffffffffc02016a4:	e008                	sd	a0,0(s0)
ffffffffc02016a6:	c511                	beqz	a0,ffffffffc02016b2 <get_page+0x1e>
ffffffffc02016a8:	611c                	ld	a5,0(a0)
ffffffffc02016aa:	4501                	li	a0,0
ffffffffc02016ac:	0017f713          	andi	a4,a5,1
ffffffffc02016b0:	e709                	bnez	a4,ffffffffc02016ba <get_page+0x26>
ffffffffc02016b2:	60a2                	ld	ra,8(sp)
ffffffffc02016b4:	6402                	ld	s0,0(sp)
ffffffffc02016b6:	0141                	addi	sp,sp,16
ffffffffc02016b8:	8082                	ret
ffffffffc02016ba:	078a                	slli	a5,a5,0x2
ffffffffc02016bc:	83b1                	srli	a5,a5,0xc
ffffffffc02016be:	00095717          	auipc	a4,0x95
ffffffffc02016c2:	1da73703          	ld	a4,474(a4) # ffffffffc0296898 <npage>
ffffffffc02016c6:	00e7ff63          	bgeu	a5,a4,ffffffffc02016e4 <get_page+0x50>
ffffffffc02016ca:	60a2                	ld	ra,8(sp)
ffffffffc02016cc:	6402                	ld	s0,0(sp)
ffffffffc02016ce:	fff80537          	lui	a0,0xfff80
ffffffffc02016d2:	97aa                	add	a5,a5,a0
ffffffffc02016d4:	079a                	slli	a5,a5,0x6
ffffffffc02016d6:	00095517          	auipc	a0,0x95
ffffffffc02016da:	1ca53503          	ld	a0,458(a0) # ffffffffc02968a0 <pages>
ffffffffc02016de:	953e                	add	a0,a0,a5
ffffffffc02016e0:	0141                	addi	sp,sp,16
ffffffffc02016e2:	8082                	ret
ffffffffc02016e4:	bd3ff0ef          	jal	ra,ffffffffc02012b6 <pa2page.part.0>

ffffffffc02016e8 <unmap_range>:
ffffffffc02016e8:	7159                	addi	sp,sp,-112
ffffffffc02016ea:	00c5e7b3          	or	a5,a1,a2
ffffffffc02016ee:	f486                	sd	ra,104(sp)
ffffffffc02016f0:	f0a2                	sd	s0,96(sp)
ffffffffc02016f2:	eca6                	sd	s1,88(sp)
ffffffffc02016f4:	e8ca                	sd	s2,80(sp)
ffffffffc02016f6:	e4ce                	sd	s3,72(sp)
ffffffffc02016f8:	e0d2                	sd	s4,64(sp)
ffffffffc02016fa:	fc56                	sd	s5,56(sp)
ffffffffc02016fc:	f85a                	sd	s6,48(sp)
ffffffffc02016fe:	f45e                	sd	s7,40(sp)
ffffffffc0201700:	f062                	sd	s8,32(sp)
ffffffffc0201702:	ec66                	sd	s9,24(sp)
ffffffffc0201704:	e86a                	sd	s10,16(sp)
ffffffffc0201706:	17d2                	slli	a5,a5,0x34
ffffffffc0201708:	e3ed                	bnez	a5,ffffffffc02017ea <unmap_range+0x102>
ffffffffc020170a:	002007b7          	lui	a5,0x200
ffffffffc020170e:	842e                	mv	s0,a1
ffffffffc0201710:	0ef5ed63          	bltu	a1,a5,ffffffffc020180a <unmap_range+0x122>
ffffffffc0201714:	8932                	mv	s2,a2
ffffffffc0201716:	0ec5fa63          	bgeu	a1,a2,ffffffffc020180a <unmap_range+0x122>
ffffffffc020171a:	4785                	li	a5,1
ffffffffc020171c:	07fe                	slli	a5,a5,0x1f
ffffffffc020171e:	0ec7e663          	bltu	a5,a2,ffffffffc020180a <unmap_range+0x122>
ffffffffc0201722:	89aa                	mv	s3,a0
ffffffffc0201724:	6a05                	lui	s4,0x1
ffffffffc0201726:	00095c97          	auipc	s9,0x95
ffffffffc020172a:	172c8c93          	addi	s9,s9,370 # ffffffffc0296898 <npage>
ffffffffc020172e:	00095c17          	auipc	s8,0x95
ffffffffc0201732:	172c0c13          	addi	s8,s8,370 # ffffffffc02968a0 <pages>
ffffffffc0201736:	fff80bb7          	lui	s7,0xfff80
ffffffffc020173a:	00095d17          	auipc	s10,0x95
ffffffffc020173e:	16ed0d13          	addi	s10,s10,366 # ffffffffc02968a8 <pmm_manager>
ffffffffc0201742:	00200b37          	lui	s6,0x200
ffffffffc0201746:	ffe00ab7          	lui	s5,0xffe00
ffffffffc020174a:	4601                	li	a2,0
ffffffffc020174c:	85a2                	mv	a1,s0
ffffffffc020174e:	854e                	mv	a0,s3
ffffffffc0201750:	c57ff0ef          	jal	ra,ffffffffc02013a6 <get_pte>
ffffffffc0201754:	84aa                	mv	s1,a0
ffffffffc0201756:	cd29                	beqz	a0,ffffffffc02017b0 <unmap_range+0xc8>
ffffffffc0201758:	611c                	ld	a5,0(a0)
ffffffffc020175a:	e395                	bnez	a5,ffffffffc020177e <unmap_range+0x96>
ffffffffc020175c:	9452                	add	s0,s0,s4
ffffffffc020175e:	ff2466e3          	bltu	s0,s2,ffffffffc020174a <unmap_range+0x62>
ffffffffc0201762:	70a6                	ld	ra,104(sp)
ffffffffc0201764:	7406                	ld	s0,96(sp)
ffffffffc0201766:	64e6                	ld	s1,88(sp)
ffffffffc0201768:	6946                	ld	s2,80(sp)
ffffffffc020176a:	69a6                	ld	s3,72(sp)
ffffffffc020176c:	6a06                	ld	s4,64(sp)
ffffffffc020176e:	7ae2                	ld	s5,56(sp)
ffffffffc0201770:	7b42                	ld	s6,48(sp)
ffffffffc0201772:	7ba2                	ld	s7,40(sp)
ffffffffc0201774:	7c02                	ld	s8,32(sp)
ffffffffc0201776:	6ce2                	ld	s9,24(sp)
ffffffffc0201778:	6d42                	ld	s10,16(sp)
ffffffffc020177a:	6165                	addi	sp,sp,112
ffffffffc020177c:	8082                	ret
ffffffffc020177e:	0017f713          	andi	a4,a5,1
ffffffffc0201782:	df69                	beqz	a4,ffffffffc020175c <unmap_range+0x74>
ffffffffc0201784:	000cb703          	ld	a4,0(s9)
ffffffffc0201788:	078a                	slli	a5,a5,0x2
ffffffffc020178a:	83b1                	srli	a5,a5,0xc
ffffffffc020178c:	08e7ff63          	bgeu	a5,a4,ffffffffc020182a <unmap_range+0x142>
ffffffffc0201790:	000c3503          	ld	a0,0(s8)
ffffffffc0201794:	97de                	add	a5,a5,s7
ffffffffc0201796:	079a                	slli	a5,a5,0x6
ffffffffc0201798:	953e                	add	a0,a0,a5
ffffffffc020179a:	411c                	lw	a5,0(a0)
ffffffffc020179c:	fff7871b          	addiw	a4,a5,-1
ffffffffc02017a0:	c118                	sw	a4,0(a0)
ffffffffc02017a2:	cf11                	beqz	a4,ffffffffc02017be <unmap_range+0xd6>
ffffffffc02017a4:	0004b023          	sd	zero,0(s1)
ffffffffc02017a8:	12040073          	sfence.vma	s0
ffffffffc02017ac:	9452                	add	s0,s0,s4
ffffffffc02017ae:	bf45                	j	ffffffffc020175e <unmap_range+0x76>
ffffffffc02017b0:	945a                	add	s0,s0,s6
ffffffffc02017b2:	01547433          	and	s0,s0,s5
ffffffffc02017b6:	d455                	beqz	s0,ffffffffc0201762 <unmap_range+0x7a>
ffffffffc02017b8:	f92469e3          	bltu	s0,s2,ffffffffc020174a <unmap_range+0x62>
ffffffffc02017bc:	b75d                	j	ffffffffc0201762 <unmap_range+0x7a>
ffffffffc02017be:	100027f3          	csrr	a5,sstatus
ffffffffc02017c2:	8b89                	andi	a5,a5,2
ffffffffc02017c4:	e799                	bnez	a5,ffffffffc02017d2 <unmap_range+0xea>
ffffffffc02017c6:	000d3783          	ld	a5,0(s10)
ffffffffc02017ca:	4585                	li	a1,1
ffffffffc02017cc:	739c                	ld	a5,32(a5)
ffffffffc02017ce:	9782                	jalr	a5
ffffffffc02017d0:	bfd1                	j	ffffffffc02017a4 <unmap_range+0xbc>
ffffffffc02017d2:	e42a                	sd	a0,8(sp)
ffffffffc02017d4:	dd0ff0ef          	jal	ra,ffffffffc0200da4 <intr_disable>
ffffffffc02017d8:	000d3783          	ld	a5,0(s10)
ffffffffc02017dc:	6522                	ld	a0,8(sp)
ffffffffc02017de:	4585                	li	a1,1
ffffffffc02017e0:	739c                	ld	a5,32(a5)
ffffffffc02017e2:	9782                	jalr	a5
ffffffffc02017e4:	dbaff0ef          	jal	ra,ffffffffc0200d9e <intr_enable>
ffffffffc02017e8:	bf75                	j	ffffffffc02017a4 <unmap_range+0xbc>
ffffffffc02017ea:	0000b697          	auipc	a3,0xb
ffffffffc02017ee:	98668693          	addi	a3,a3,-1658 # ffffffffc020c170 <commands+0x9c8>
ffffffffc02017f2:	0000a617          	auipc	a2,0xa
ffffffffc02017f6:	01660613          	addi	a2,a2,22 # ffffffffc020b808 <commands+0x60>
ffffffffc02017fa:	15a00593          	li	a1,346
ffffffffc02017fe:	0000b517          	auipc	a0,0xb
ffffffffc0201802:	93a50513          	addi	a0,a0,-1734 # ffffffffc020c138 <commands+0x990>
ffffffffc0201806:	a29fe0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020180a:	0000b697          	auipc	a3,0xb
ffffffffc020180e:	99668693          	addi	a3,a3,-1642 # ffffffffc020c1a0 <commands+0x9f8>
ffffffffc0201812:	0000a617          	auipc	a2,0xa
ffffffffc0201816:	ff660613          	addi	a2,a2,-10 # ffffffffc020b808 <commands+0x60>
ffffffffc020181a:	15b00593          	li	a1,347
ffffffffc020181e:	0000b517          	auipc	a0,0xb
ffffffffc0201822:	91a50513          	addi	a0,a0,-1766 # ffffffffc020c138 <commands+0x990>
ffffffffc0201826:	a09fe0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020182a:	a8dff0ef          	jal	ra,ffffffffc02012b6 <pa2page.part.0>

ffffffffc020182e <exit_range>:
ffffffffc020182e:	7119                	addi	sp,sp,-128
ffffffffc0201830:	00c5e7b3          	or	a5,a1,a2
ffffffffc0201834:	fc86                	sd	ra,120(sp)
ffffffffc0201836:	f8a2                	sd	s0,112(sp)
ffffffffc0201838:	f4a6                	sd	s1,104(sp)
ffffffffc020183a:	f0ca                	sd	s2,96(sp)
ffffffffc020183c:	ecce                	sd	s3,88(sp)
ffffffffc020183e:	e8d2                	sd	s4,80(sp)
ffffffffc0201840:	e4d6                	sd	s5,72(sp)
ffffffffc0201842:	e0da                	sd	s6,64(sp)
ffffffffc0201844:	fc5e                	sd	s7,56(sp)
ffffffffc0201846:	f862                	sd	s8,48(sp)
ffffffffc0201848:	f466                	sd	s9,40(sp)
ffffffffc020184a:	f06a                	sd	s10,32(sp)
ffffffffc020184c:	ec6e                	sd	s11,24(sp)
ffffffffc020184e:	17d2                	slli	a5,a5,0x34
ffffffffc0201850:	20079a63          	bnez	a5,ffffffffc0201a64 <exit_range+0x236>
ffffffffc0201854:	002007b7          	lui	a5,0x200
ffffffffc0201858:	24f5e463          	bltu	a1,a5,ffffffffc0201aa0 <exit_range+0x272>
ffffffffc020185c:	8ab2                	mv	s5,a2
ffffffffc020185e:	24c5f163          	bgeu	a1,a2,ffffffffc0201aa0 <exit_range+0x272>
ffffffffc0201862:	4785                	li	a5,1
ffffffffc0201864:	07fe                	slli	a5,a5,0x1f
ffffffffc0201866:	22c7ed63          	bltu	a5,a2,ffffffffc0201aa0 <exit_range+0x272>
ffffffffc020186a:	c00009b7          	lui	s3,0xc0000
ffffffffc020186e:	0135f9b3          	and	s3,a1,s3
ffffffffc0201872:	ffe00937          	lui	s2,0xffe00
ffffffffc0201876:	400007b7          	lui	a5,0x40000
ffffffffc020187a:	5cfd                	li	s9,-1
ffffffffc020187c:	8c2a                	mv	s8,a0
ffffffffc020187e:	0125f933          	and	s2,a1,s2
ffffffffc0201882:	99be                	add	s3,s3,a5
ffffffffc0201884:	00095d17          	auipc	s10,0x95
ffffffffc0201888:	014d0d13          	addi	s10,s10,20 # ffffffffc0296898 <npage>
ffffffffc020188c:	00ccdc93          	srli	s9,s9,0xc
ffffffffc0201890:	00095717          	auipc	a4,0x95
ffffffffc0201894:	01070713          	addi	a4,a4,16 # ffffffffc02968a0 <pages>
ffffffffc0201898:	00095d97          	auipc	s11,0x95
ffffffffc020189c:	010d8d93          	addi	s11,s11,16 # ffffffffc02968a8 <pmm_manager>
ffffffffc02018a0:	c0000437          	lui	s0,0xc0000
ffffffffc02018a4:	944e                	add	s0,s0,s3
ffffffffc02018a6:	8079                	srli	s0,s0,0x1e
ffffffffc02018a8:	1ff47413          	andi	s0,s0,511
ffffffffc02018ac:	040e                	slli	s0,s0,0x3
ffffffffc02018ae:	9462                	add	s0,s0,s8
ffffffffc02018b0:	00043a03          	ld	s4,0(s0) # ffffffffc0000000 <_binary_bin_sfs_img_size+0xffffffffbff8ad00>
ffffffffc02018b4:	001a7793          	andi	a5,s4,1
ffffffffc02018b8:	eb99                	bnez	a5,ffffffffc02018ce <exit_range+0xa0>
ffffffffc02018ba:	12098463          	beqz	s3,ffffffffc02019e2 <exit_range+0x1b4>
ffffffffc02018be:	400007b7          	lui	a5,0x40000
ffffffffc02018c2:	97ce                	add	a5,a5,s3
ffffffffc02018c4:	894e                	mv	s2,s3
ffffffffc02018c6:	1159fe63          	bgeu	s3,s5,ffffffffc02019e2 <exit_range+0x1b4>
ffffffffc02018ca:	89be                	mv	s3,a5
ffffffffc02018cc:	bfd1                	j	ffffffffc02018a0 <exit_range+0x72>
ffffffffc02018ce:	000d3783          	ld	a5,0(s10)
ffffffffc02018d2:	0a0a                	slli	s4,s4,0x2
ffffffffc02018d4:	00ca5a13          	srli	s4,s4,0xc
ffffffffc02018d8:	1cfa7263          	bgeu	s4,a5,ffffffffc0201a9c <exit_range+0x26e>
ffffffffc02018dc:	fff80637          	lui	a2,0xfff80
ffffffffc02018e0:	9652                	add	a2,a2,s4
ffffffffc02018e2:	000806b7          	lui	a3,0x80
ffffffffc02018e6:	96b2                	add	a3,a3,a2
ffffffffc02018e8:	0196f5b3          	and	a1,a3,s9
ffffffffc02018ec:	061a                	slli	a2,a2,0x6
ffffffffc02018ee:	06b2                	slli	a3,a3,0xc
ffffffffc02018f0:	18f5fa63          	bgeu	a1,a5,ffffffffc0201a84 <exit_range+0x256>
ffffffffc02018f4:	00095817          	auipc	a6,0x95
ffffffffc02018f8:	fbc80813          	addi	a6,a6,-68 # ffffffffc02968b0 <va_pa_offset>
ffffffffc02018fc:	00083b03          	ld	s6,0(a6)
ffffffffc0201900:	4b85                	li	s7,1
ffffffffc0201902:	fff80e37          	lui	t3,0xfff80
ffffffffc0201906:	9b36                	add	s6,s6,a3
ffffffffc0201908:	00080337          	lui	t1,0x80
ffffffffc020190c:	6885                	lui	a7,0x1
ffffffffc020190e:	a819                	j	ffffffffc0201924 <exit_range+0xf6>
ffffffffc0201910:	4b81                	li	s7,0
ffffffffc0201912:	002007b7          	lui	a5,0x200
ffffffffc0201916:	993e                	add	s2,s2,a5
ffffffffc0201918:	08090c63          	beqz	s2,ffffffffc02019b0 <exit_range+0x182>
ffffffffc020191c:	09397a63          	bgeu	s2,s3,ffffffffc02019b0 <exit_range+0x182>
ffffffffc0201920:	0f597063          	bgeu	s2,s5,ffffffffc0201a00 <exit_range+0x1d2>
ffffffffc0201924:	01595493          	srli	s1,s2,0x15
ffffffffc0201928:	1ff4f493          	andi	s1,s1,511
ffffffffc020192c:	048e                	slli	s1,s1,0x3
ffffffffc020192e:	94da                	add	s1,s1,s6
ffffffffc0201930:	609c                	ld	a5,0(s1)
ffffffffc0201932:	0017f693          	andi	a3,a5,1
ffffffffc0201936:	dee9                	beqz	a3,ffffffffc0201910 <exit_range+0xe2>
ffffffffc0201938:	000d3583          	ld	a1,0(s10)
ffffffffc020193c:	078a                	slli	a5,a5,0x2
ffffffffc020193e:	83b1                	srli	a5,a5,0xc
ffffffffc0201940:	14b7fe63          	bgeu	a5,a1,ffffffffc0201a9c <exit_range+0x26e>
ffffffffc0201944:	97f2                	add	a5,a5,t3
ffffffffc0201946:	006786b3          	add	a3,a5,t1
ffffffffc020194a:	0196feb3          	and	t4,a3,s9
ffffffffc020194e:	00679513          	slli	a0,a5,0x6
ffffffffc0201952:	06b2                	slli	a3,a3,0xc
ffffffffc0201954:	12bef863          	bgeu	t4,a1,ffffffffc0201a84 <exit_range+0x256>
ffffffffc0201958:	00083783          	ld	a5,0(a6)
ffffffffc020195c:	96be                	add	a3,a3,a5
ffffffffc020195e:	011685b3          	add	a1,a3,a7
ffffffffc0201962:	629c                	ld	a5,0(a3)
ffffffffc0201964:	8b85                	andi	a5,a5,1
ffffffffc0201966:	f7d5                	bnez	a5,ffffffffc0201912 <exit_range+0xe4>
ffffffffc0201968:	06a1                	addi	a3,a3,8
ffffffffc020196a:	fed59ce3          	bne	a1,a3,ffffffffc0201962 <exit_range+0x134>
ffffffffc020196e:	631c                	ld	a5,0(a4)
ffffffffc0201970:	953e                	add	a0,a0,a5
ffffffffc0201972:	100027f3          	csrr	a5,sstatus
ffffffffc0201976:	8b89                	andi	a5,a5,2
ffffffffc0201978:	e7d9                	bnez	a5,ffffffffc0201a06 <exit_range+0x1d8>
ffffffffc020197a:	000db783          	ld	a5,0(s11)
ffffffffc020197e:	4585                	li	a1,1
ffffffffc0201980:	e032                	sd	a2,0(sp)
ffffffffc0201982:	739c                	ld	a5,32(a5)
ffffffffc0201984:	9782                	jalr	a5
ffffffffc0201986:	6602                	ld	a2,0(sp)
ffffffffc0201988:	00095817          	auipc	a6,0x95
ffffffffc020198c:	f2880813          	addi	a6,a6,-216 # ffffffffc02968b0 <va_pa_offset>
ffffffffc0201990:	fff80e37          	lui	t3,0xfff80
ffffffffc0201994:	00080337          	lui	t1,0x80
ffffffffc0201998:	6885                	lui	a7,0x1
ffffffffc020199a:	00095717          	auipc	a4,0x95
ffffffffc020199e:	f0670713          	addi	a4,a4,-250 # ffffffffc02968a0 <pages>
ffffffffc02019a2:	0004b023          	sd	zero,0(s1)
ffffffffc02019a6:	002007b7          	lui	a5,0x200
ffffffffc02019aa:	993e                	add	s2,s2,a5
ffffffffc02019ac:	f60918e3          	bnez	s2,ffffffffc020191c <exit_range+0xee>
ffffffffc02019b0:	f00b85e3          	beqz	s7,ffffffffc02018ba <exit_range+0x8c>
ffffffffc02019b4:	000d3783          	ld	a5,0(s10)
ffffffffc02019b8:	0efa7263          	bgeu	s4,a5,ffffffffc0201a9c <exit_range+0x26e>
ffffffffc02019bc:	6308                	ld	a0,0(a4)
ffffffffc02019be:	9532                	add	a0,a0,a2
ffffffffc02019c0:	100027f3          	csrr	a5,sstatus
ffffffffc02019c4:	8b89                	andi	a5,a5,2
ffffffffc02019c6:	efad                	bnez	a5,ffffffffc0201a40 <exit_range+0x212>
ffffffffc02019c8:	000db783          	ld	a5,0(s11)
ffffffffc02019cc:	4585                	li	a1,1
ffffffffc02019ce:	739c                	ld	a5,32(a5)
ffffffffc02019d0:	9782                	jalr	a5
ffffffffc02019d2:	00095717          	auipc	a4,0x95
ffffffffc02019d6:	ece70713          	addi	a4,a4,-306 # ffffffffc02968a0 <pages>
ffffffffc02019da:	00043023          	sd	zero,0(s0)
ffffffffc02019de:	ee0990e3          	bnez	s3,ffffffffc02018be <exit_range+0x90>
ffffffffc02019e2:	70e6                	ld	ra,120(sp)
ffffffffc02019e4:	7446                	ld	s0,112(sp)
ffffffffc02019e6:	74a6                	ld	s1,104(sp)
ffffffffc02019e8:	7906                	ld	s2,96(sp)
ffffffffc02019ea:	69e6                	ld	s3,88(sp)
ffffffffc02019ec:	6a46                	ld	s4,80(sp)
ffffffffc02019ee:	6aa6                	ld	s5,72(sp)
ffffffffc02019f0:	6b06                	ld	s6,64(sp)
ffffffffc02019f2:	7be2                	ld	s7,56(sp)
ffffffffc02019f4:	7c42                	ld	s8,48(sp)
ffffffffc02019f6:	7ca2                	ld	s9,40(sp)
ffffffffc02019f8:	7d02                	ld	s10,32(sp)
ffffffffc02019fa:	6de2                	ld	s11,24(sp)
ffffffffc02019fc:	6109                	addi	sp,sp,128
ffffffffc02019fe:	8082                	ret
ffffffffc0201a00:	ea0b8fe3          	beqz	s7,ffffffffc02018be <exit_range+0x90>
ffffffffc0201a04:	bf45                	j	ffffffffc02019b4 <exit_range+0x186>
ffffffffc0201a06:	e032                	sd	a2,0(sp)
ffffffffc0201a08:	e42a                	sd	a0,8(sp)
ffffffffc0201a0a:	b9aff0ef          	jal	ra,ffffffffc0200da4 <intr_disable>
ffffffffc0201a0e:	000db783          	ld	a5,0(s11)
ffffffffc0201a12:	6522                	ld	a0,8(sp)
ffffffffc0201a14:	4585                	li	a1,1
ffffffffc0201a16:	739c                	ld	a5,32(a5)
ffffffffc0201a18:	9782                	jalr	a5
ffffffffc0201a1a:	b84ff0ef          	jal	ra,ffffffffc0200d9e <intr_enable>
ffffffffc0201a1e:	6602                	ld	a2,0(sp)
ffffffffc0201a20:	00095717          	auipc	a4,0x95
ffffffffc0201a24:	e8070713          	addi	a4,a4,-384 # ffffffffc02968a0 <pages>
ffffffffc0201a28:	6885                	lui	a7,0x1
ffffffffc0201a2a:	00080337          	lui	t1,0x80
ffffffffc0201a2e:	fff80e37          	lui	t3,0xfff80
ffffffffc0201a32:	00095817          	auipc	a6,0x95
ffffffffc0201a36:	e7e80813          	addi	a6,a6,-386 # ffffffffc02968b0 <va_pa_offset>
ffffffffc0201a3a:	0004b023          	sd	zero,0(s1)
ffffffffc0201a3e:	b7a5                	j	ffffffffc02019a6 <exit_range+0x178>
ffffffffc0201a40:	e02a                	sd	a0,0(sp)
ffffffffc0201a42:	b62ff0ef          	jal	ra,ffffffffc0200da4 <intr_disable>
ffffffffc0201a46:	000db783          	ld	a5,0(s11)
ffffffffc0201a4a:	6502                	ld	a0,0(sp)
ffffffffc0201a4c:	4585                	li	a1,1
ffffffffc0201a4e:	739c                	ld	a5,32(a5)
ffffffffc0201a50:	9782                	jalr	a5
ffffffffc0201a52:	b4cff0ef          	jal	ra,ffffffffc0200d9e <intr_enable>
ffffffffc0201a56:	00095717          	auipc	a4,0x95
ffffffffc0201a5a:	e4a70713          	addi	a4,a4,-438 # ffffffffc02968a0 <pages>
ffffffffc0201a5e:	00043023          	sd	zero,0(s0)
ffffffffc0201a62:	bfb5                	j	ffffffffc02019de <exit_range+0x1b0>
ffffffffc0201a64:	0000a697          	auipc	a3,0xa
ffffffffc0201a68:	70c68693          	addi	a3,a3,1804 # ffffffffc020c170 <commands+0x9c8>
ffffffffc0201a6c:	0000a617          	auipc	a2,0xa
ffffffffc0201a70:	d9c60613          	addi	a2,a2,-612 # ffffffffc020b808 <commands+0x60>
ffffffffc0201a74:	16f00593          	li	a1,367
ffffffffc0201a78:	0000a517          	auipc	a0,0xa
ffffffffc0201a7c:	6c050513          	addi	a0,a0,1728 # ffffffffc020c138 <commands+0x990>
ffffffffc0201a80:	faefe0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0201a84:	0000a617          	auipc	a2,0xa
ffffffffc0201a88:	68c60613          	addi	a2,a2,1676 # ffffffffc020c110 <commands+0x968>
ffffffffc0201a8c:	07100593          	li	a1,113
ffffffffc0201a90:	0000a517          	auipc	a0,0xa
ffffffffc0201a94:	64850513          	addi	a0,a0,1608 # ffffffffc020c0d8 <commands+0x930>
ffffffffc0201a98:	f96fe0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0201a9c:	81bff0ef          	jal	ra,ffffffffc02012b6 <pa2page.part.0>
ffffffffc0201aa0:	0000a697          	auipc	a3,0xa
ffffffffc0201aa4:	70068693          	addi	a3,a3,1792 # ffffffffc020c1a0 <commands+0x9f8>
ffffffffc0201aa8:	0000a617          	auipc	a2,0xa
ffffffffc0201aac:	d6060613          	addi	a2,a2,-672 # ffffffffc020b808 <commands+0x60>
ffffffffc0201ab0:	17000593          	li	a1,368
ffffffffc0201ab4:	0000a517          	auipc	a0,0xa
ffffffffc0201ab8:	68450513          	addi	a0,a0,1668 # ffffffffc020c138 <commands+0x990>
ffffffffc0201abc:	f72fe0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0201ac0 <page_remove>:
ffffffffc0201ac0:	7179                	addi	sp,sp,-48
ffffffffc0201ac2:	4601                	li	a2,0
ffffffffc0201ac4:	ec26                	sd	s1,24(sp)
ffffffffc0201ac6:	f406                	sd	ra,40(sp)
ffffffffc0201ac8:	f022                	sd	s0,32(sp)
ffffffffc0201aca:	84ae                	mv	s1,a1
ffffffffc0201acc:	8dbff0ef          	jal	ra,ffffffffc02013a6 <get_pte>
ffffffffc0201ad0:	c511                	beqz	a0,ffffffffc0201adc <page_remove+0x1c>
ffffffffc0201ad2:	611c                	ld	a5,0(a0)
ffffffffc0201ad4:	842a                	mv	s0,a0
ffffffffc0201ad6:	0017f713          	andi	a4,a5,1
ffffffffc0201ada:	e711                	bnez	a4,ffffffffc0201ae6 <page_remove+0x26>
ffffffffc0201adc:	70a2                	ld	ra,40(sp)
ffffffffc0201ade:	7402                	ld	s0,32(sp)
ffffffffc0201ae0:	64e2                	ld	s1,24(sp)
ffffffffc0201ae2:	6145                	addi	sp,sp,48
ffffffffc0201ae4:	8082                	ret
ffffffffc0201ae6:	078a                	slli	a5,a5,0x2
ffffffffc0201ae8:	83b1                	srli	a5,a5,0xc
ffffffffc0201aea:	00095717          	auipc	a4,0x95
ffffffffc0201aee:	dae73703          	ld	a4,-594(a4) # ffffffffc0296898 <npage>
ffffffffc0201af2:	06e7f363          	bgeu	a5,a4,ffffffffc0201b58 <page_remove+0x98>
ffffffffc0201af6:	fff80537          	lui	a0,0xfff80
ffffffffc0201afa:	97aa                	add	a5,a5,a0
ffffffffc0201afc:	079a                	slli	a5,a5,0x6
ffffffffc0201afe:	00095517          	auipc	a0,0x95
ffffffffc0201b02:	da253503          	ld	a0,-606(a0) # ffffffffc02968a0 <pages>
ffffffffc0201b06:	953e                	add	a0,a0,a5
ffffffffc0201b08:	411c                	lw	a5,0(a0)
ffffffffc0201b0a:	fff7871b          	addiw	a4,a5,-1
ffffffffc0201b0e:	c118                	sw	a4,0(a0)
ffffffffc0201b10:	cb11                	beqz	a4,ffffffffc0201b24 <page_remove+0x64>
ffffffffc0201b12:	00043023          	sd	zero,0(s0)
ffffffffc0201b16:	12048073          	sfence.vma	s1
ffffffffc0201b1a:	70a2                	ld	ra,40(sp)
ffffffffc0201b1c:	7402                	ld	s0,32(sp)
ffffffffc0201b1e:	64e2                	ld	s1,24(sp)
ffffffffc0201b20:	6145                	addi	sp,sp,48
ffffffffc0201b22:	8082                	ret
ffffffffc0201b24:	100027f3          	csrr	a5,sstatus
ffffffffc0201b28:	8b89                	andi	a5,a5,2
ffffffffc0201b2a:	eb89                	bnez	a5,ffffffffc0201b3c <page_remove+0x7c>
ffffffffc0201b2c:	00095797          	auipc	a5,0x95
ffffffffc0201b30:	d7c7b783          	ld	a5,-644(a5) # ffffffffc02968a8 <pmm_manager>
ffffffffc0201b34:	739c                	ld	a5,32(a5)
ffffffffc0201b36:	4585                	li	a1,1
ffffffffc0201b38:	9782                	jalr	a5
ffffffffc0201b3a:	bfe1                	j	ffffffffc0201b12 <page_remove+0x52>
ffffffffc0201b3c:	e42a                	sd	a0,8(sp)
ffffffffc0201b3e:	a66ff0ef          	jal	ra,ffffffffc0200da4 <intr_disable>
ffffffffc0201b42:	00095797          	auipc	a5,0x95
ffffffffc0201b46:	d667b783          	ld	a5,-666(a5) # ffffffffc02968a8 <pmm_manager>
ffffffffc0201b4a:	739c                	ld	a5,32(a5)
ffffffffc0201b4c:	6522                	ld	a0,8(sp)
ffffffffc0201b4e:	4585                	li	a1,1
ffffffffc0201b50:	9782                	jalr	a5
ffffffffc0201b52:	a4cff0ef          	jal	ra,ffffffffc0200d9e <intr_enable>
ffffffffc0201b56:	bf75                	j	ffffffffc0201b12 <page_remove+0x52>
ffffffffc0201b58:	f5eff0ef          	jal	ra,ffffffffc02012b6 <pa2page.part.0>

ffffffffc0201b5c <page_insert>:
ffffffffc0201b5c:	7139                	addi	sp,sp,-64
ffffffffc0201b5e:	e852                	sd	s4,16(sp)
ffffffffc0201b60:	8a32                	mv	s4,a2
ffffffffc0201b62:	f822                	sd	s0,48(sp)
ffffffffc0201b64:	4605                	li	a2,1
ffffffffc0201b66:	842e                	mv	s0,a1
ffffffffc0201b68:	85d2                	mv	a1,s4
ffffffffc0201b6a:	f426                	sd	s1,40(sp)
ffffffffc0201b6c:	fc06                	sd	ra,56(sp)
ffffffffc0201b6e:	f04a                	sd	s2,32(sp)
ffffffffc0201b70:	ec4e                	sd	s3,24(sp)
ffffffffc0201b72:	e456                	sd	s5,8(sp)
ffffffffc0201b74:	84b6                	mv	s1,a3
ffffffffc0201b76:	831ff0ef          	jal	ra,ffffffffc02013a6 <get_pte>
ffffffffc0201b7a:	c961                	beqz	a0,ffffffffc0201c4a <page_insert+0xee>
ffffffffc0201b7c:	4014                	lw	a3,0(s0)
ffffffffc0201b7e:	611c                	ld	a5,0(a0)
ffffffffc0201b80:	89aa                	mv	s3,a0
ffffffffc0201b82:	0016871b          	addiw	a4,a3,1
ffffffffc0201b86:	c018                	sw	a4,0(s0)
ffffffffc0201b88:	0017f713          	andi	a4,a5,1
ffffffffc0201b8c:	ef05                	bnez	a4,ffffffffc0201bc4 <page_insert+0x68>
ffffffffc0201b8e:	00095717          	auipc	a4,0x95
ffffffffc0201b92:	d1273703          	ld	a4,-750(a4) # ffffffffc02968a0 <pages>
ffffffffc0201b96:	8c19                	sub	s0,s0,a4
ffffffffc0201b98:	000807b7          	lui	a5,0x80
ffffffffc0201b9c:	8419                	srai	s0,s0,0x6
ffffffffc0201b9e:	943e                	add	s0,s0,a5
ffffffffc0201ba0:	042a                	slli	s0,s0,0xa
ffffffffc0201ba2:	8cc1                	or	s1,s1,s0
ffffffffc0201ba4:	0014e493          	ori	s1,s1,1
ffffffffc0201ba8:	0099b023          	sd	s1,0(s3) # ffffffffc0000000 <_binary_bin_sfs_img_size+0xffffffffbff8ad00>
ffffffffc0201bac:	120a0073          	sfence.vma	s4
ffffffffc0201bb0:	4501                	li	a0,0
ffffffffc0201bb2:	70e2                	ld	ra,56(sp)
ffffffffc0201bb4:	7442                	ld	s0,48(sp)
ffffffffc0201bb6:	74a2                	ld	s1,40(sp)
ffffffffc0201bb8:	7902                	ld	s2,32(sp)
ffffffffc0201bba:	69e2                	ld	s3,24(sp)
ffffffffc0201bbc:	6a42                	ld	s4,16(sp)
ffffffffc0201bbe:	6aa2                	ld	s5,8(sp)
ffffffffc0201bc0:	6121                	addi	sp,sp,64
ffffffffc0201bc2:	8082                	ret
ffffffffc0201bc4:	078a                	slli	a5,a5,0x2
ffffffffc0201bc6:	83b1                	srli	a5,a5,0xc
ffffffffc0201bc8:	00095717          	auipc	a4,0x95
ffffffffc0201bcc:	cd073703          	ld	a4,-816(a4) # ffffffffc0296898 <npage>
ffffffffc0201bd0:	06e7ff63          	bgeu	a5,a4,ffffffffc0201c4e <page_insert+0xf2>
ffffffffc0201bd4:	00095a97          	auipc	s5,0x95
ffffffffc0201bd8:	ccca8a93          	addi	s5,s5,-820 # ffffffffc02968a0 <pages>
ffffffffc0201bdc:	000ab703          	ld	a4,0(s5)
ffffffffc0201be0:	fff80937          	lui	s2,0xfff80
ffffffffc0201be4:	993e                	add	s2,s2,a5
ffffffffc0201be6:	091a                	slli	s2,s2,0x6
ffffffffc0201be8:	993a                	add	s2,s2,a4
ffffffffc0201bea:	01240c63          	beq	s0,s2,ffffffffc0201c02 <page_insert+0xa6>
ffffffffc0201bee:	00092783          	lw	a5,0(s2) # fffffffffff80000 <end+0x3fce96f0>
ffffffffc0201bf2:	fff7869b          	addiw	a3,a5,-1
ffffffffc0201bf6:	00d92023          	sw	a3,0(s2)
ffffffffc0201bfa:	c691                	beqz	a3,ffffffffc0201c06 <page_insert+0xaa>
ffffffffc0201bfc:	120a0073          	sfence.vma	s4
ffffffffc0201c00:	bf59                	j	ffffffffc0201b96 <page_insert+0x3a>
ffffffffc0201c02:	c014                	sw	a3,0(s0)
ffffffffc0201c04:	bf49                	j	ffffffffc0201b96 <page_insert+0x3a>
ffffffffc0201c06:	100027f3          	csrr	a5,sstatus
ffffffffc0201c0a:	8b89                	andi	a5,a5,2
ffffffffc0201c0c:	ef91                	bnez	a5,ffffffffc0201c28 <page_insert+0xcc>
ffffffffc0201c0e:	00095797          	auipc	a5,0x95
ffffffffc0201c12:	c9a7b783          	ld	a5,-870(a5) # ffffffffc02968a8 <pmm_manager>
ffffffffc0201c16:	739c                	ld	a5,32(a5)
ffffffffc0201c18:	4585                	li	a1,1
ffffffffc0201c1a:	854a                	mv	a0,s2
ffffffffc0201c1c:	9782                	jalr	a5
ffffffffc0201c1e:	000ab703          	ld	a4,0(s5)
ffffffffc0201c22:	120a0073          	sfence.vma	s4
ffffffffc0201c26:	bf85                	j	ffffffffc0201b96 <page_insert+0x3a>
ffffffffc0201c28:	97cff0ef          	jal	ra,ffffffffc0200da4 <intr_disable>
ffffffffc0201c2c:	00095797          	auipc	a5,0x95
ffffffffc0201c30:	c7c7b783          	ld	a5,-900(a5) # ffffffffc02968a8 <pmm_manager>
ffffffffc0201c34:	739c                	ld	a5,32(a5)
ffffffffc0201c36:	4585                	li	a1,1
ffffffffc0201c38:	854a                	mv	a0,s2
ffffffffc0201c3a:	9782                	jalr	a5
ffffffffc0201c3c:	962ff0ef          	jal	ra,ffffffffc0200d9e <intr_enable>
ffffffffc0201c40:	000ab703          	ld	a4,0(s5)
ffffffffc0201c44:	120a0073          	sfence.vma	s4
ffffffffc0201c48:	b7b9                	j	ffffffffc0201b96 <page_insert+0x3a>
ffffffffc0201c4a:	5571                	li	a0,-4
ffffffffc0201c4c:	b79d                	j	ffffffffc0201bb2 <page_insert+0x56>
ffffffffc0201c4e:	e68ff0ef          	jal	ra,ffffffffc02012b6 <pa2page.part.0>

ffffffffc0201c52 <pmm_init>:
ffffffffc0201c52:	0000b797          	auipc	a5,0xb
ffffffffc0201c56:	27678793          	addi	a5,a5,630 # ffffffffc020cec8 <default_pmm_manager>
ffffffffc0201c5a:	638c                	ld	a1,0(a5)
ffffffffc0201c5c:	7159                	addi	sp,sp,-112
ffffffffc0201c5e:	f85a                	sd	s6,48(sp)
ffffffffc0201c60:	0000a517          	auipc	a0,0xa
ffffffffc0201c64:	55850513          	addi	a0,a0,1368 # ffffffffc020c1b8 <commands+0xa10>
ffffffffc0201c68:	00095b17          	auipc	s6,0x95
ffffffffc0201c6c:	c40b0b13          	addi	s6,s6,-960 # ffffffffc02968a8 <pmm_manager>
ffffffffc0201c70:	f486                	sd	ra,104(sp)
ffffffffc0201c72:	e8ca                	sd	s2,80(sp)
ffffffffc0201c74:	e4ce                	sd	s3,72(sp)
ffffffffc0201c76:	f0a2                	sd	s0,96(sp)
ffffffffc0201c78:	eca6                	sd	s1,88(sp)
ffffffffc0201c7a:	e0d2                	sd	s4,64(sp)
ffffffffc0201c7c:	fc56                	sd	s5,56(sp)
ffffffffc0201c7e:	f45e                	sd	s7,40(sp)
ffffffffc0201c80:	f062                	sd	s8,32(sp)
ffffffffc0201c82:	ec66                	sd	s9,24(sp)
ffffffffc0201c84:	00fb3023          	sd	a5,0(s6)
ffffffffc0201c88:	ca2fe0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0201c8c:	000b3783          	ld	a5,0(s6)
ffffffffc0201c90:	00095997          	auipc	s3,0x95
ffffffffc0201c94:	c2098993          	addi	s3,s3,-992 # ffffffffc02968b0 <va_pa_offset>
ffffffffc0201c98:	679c                	ld	a5,8(a5)
ffffffffc0201c9a:	9782                	jalr	a5
ffffffffc0201c9c:	57f5                	li	a5,-3
ffffffffc0201c9e:	07fa                	slli	a5,a5,0x1e
ffffffffc0201ca0:	00f9b023          	sd	a5,0(s3)
ffffffffc0201ca4:	fcbfe0ef          	jal	ra,ffffffffc0200c6e <get_memory_base>
ffffffffc0201ca8:	892a                	mv	s2,a0
ffffffffc0201caa:	fcffe0ef          	jal	ra,ffffffffc0200c78 <get_memory_size>
ffffffffc0201cae:	280502e3          	beqz	a0,ffffffffc0202732 <pmm_init+0xae0>
ffffffffc0201cb2:	84aa                	mv	s1,a0
ffffffffc0201cb4:	0000a517          	auipc	a0,0xa
ffffffffc0201cb8:	53c50513          	addi	a0,a0,1340 # ffffffffc020c1f0 <commands+0xa48>
ffffffffc0201cbc:	c6efe0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0201cc0:	00990433          	add	s0,s2,s1
ffffffffc0201cc4:	fff40693          	addi	a3,s0,-1
ffffffffc0201cc8:	864a                	mv	a2,s2
ffffffffc0201cca:	85a6                	mv	a1,s1
ffffffffc0201ccc:	0000a517          	auipc	a0,0xa
ffffffffc0201cd0:	53c50513          	addi	a0,a0,1340 # ffffffffc020c208 <commands+0xa60>
ffffffffc0201cd4:	c56fe0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0201cd8:	c8000737          	lui	a4,0xc8000
ffffffffc0201cdc:	87a2                	mv	a5,s0
ffffffffc0201cde:	5e876e63          	bltu	a4,s0,ffffffffc02022da <pmm_init+0x688>
ffffffffc0201ce2:	757d                	lui	a0,0xfffff
ffffffffc0201ce4:	00096617          	auipc	a2,0x96
ffffffffc0201ce8:	c2b60613          	addi	a2,a2,-981 # ffffffffc029790f <end+0xfff>
ffffffffc0201cec:	8e69                	and	a2,a2,a0
ffffffffc0201cee:	00095497          	auipc	s1,0x95
ffffffffc0201cf2:	baa48493          	addi	s1,s1,-1110 # ffffffffc0296898 <npage>
ffffffffc0201cf6:	00c7d513          	srli	a0,a5,0xc
ffffffffc0201cfa:	00095b97          	auipc	s7,0x95
ffffffffc0201cfe:	ba6b8b93          	addi	s7,s7,-1114 # ffffffffc02968a0 <pages>
ffffffffc0201d02:	e088                	sd	a0,0(s1)
ffffffffc0201d04:	00cbb023          	sd	a2,0(s7)
ffffffffc0201d08:	000807b7          	lui	a5,0x80
ffffffffc0201d0c:	86b2                	mv	a3,a2
ffffffffc0201d0e:	02f50863          	beq	a0,a5,ffffffffc0201d3e <pmm_init+0xec>
ffffffffc0201d12:	4781                	li	a5,0
ffffffffc0201d14:	4585                	li	a1,1
ffffffffc0201d16:	fff806b7          	lui	a3,0xfff80
ffffffffc0201d1a:	00679513          	slli	a0,a5,0x6
ffffffffc0201d1e:	9532                	add	a0,a0,a2
ffffffffc0201d20:	00850713          	addi	a4,a0,8 # fffffffffffff008 <end+0x3fd686f8>
ffffffffc0201d24:	40b7302f          	amoor.d	zero,a1,(a4)
ffffffffc0201d28:	6088                	ld	a0,0(s1)
ffffffffc0201d2a:	0785                	addi	a5,a5,1
ffffffffc0201d2c:	000bb603          	ld	a2,0(s7)
ffffffffc0201d30:	00d50733          	add	a4,a0,a3
ffffffffc0201d34:	fee7e3e3          	bltu	a5,a4,ffffffffc0201d1a <pmm_init+0xc8>
ffffffffc0201d38:	071a                	slli	a4,a4,0x6
ffffffffc0201d3a:	00e606b3          	add	a3,a2,a4
ffffffffc0201d3e:	c02007b7          	lui	a5,0xc0200
ffffffffc0201d42:	3af6eae3          	bltu	a3,a5,ffffffffc02028f6 <pmm_init+0xca4>
ffffffffc0201d46:	0009b583          	ld	a1,0(s3)
ffffffffc0201d4a:	77fd                	lui	a5,0xfffff
ffffffffc0201d4c:	8c7d                	and	s0,s0,a5
ffffffffc0201d4e:	8e8d                	sub	a3,a3,a1
ffffffffc0201d50:	5e86e363          	bltu	a3,s0,ffffffffc0202336 <pmm_init+0x6e4>
ffffffffc0201d54:	0000a517          	auipc	a0,0xa
ffffffffc0201d58:	50450513          	addi	a0,a0,1284 # ffffffffc020c258 <commands+0xab0>
ffffffffc0201d5c:	bcefe0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0201d60:	000b3783          	ld	a5,0(s6)
ffffffffc0201d64:	7b9c                	ld	a5,48(a5)
ffffffffc0201d66:	9782                	jalr	a5
ffffffffc0201d68:	0000a517          	auipc	a0,0xa
ffffffffc0201d6c:	50850513          	addi	a0,a0,1288 # ffffffffc020c270 <commands+0xac8>
ffffffffc0201d70:	bbafe0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0201d74:	100027f3          	csrr	a5,sstatus
ffffffffc0201d78:	8b89                	andi	a5,a5,2
ffffffffc0201d7a:	5a079363          	bnez	a5,ffffffffc0202320 <pmm_init+0x6ce>
ffffffffc0201d7e:	000b3783          	ld	a5,0(s6)
ffffffffc0201d82:	4505                	li	a0,1
ffffffffc0201d84:	6f9c                	ld	a5,24(a5)
ffffffffc0201d86:	9782                	jalr	a5
ffffffffc0201d88:	842a                	mv	s0,a0
ffffffffc0201d8a:	180408e3          	beqz	s0,ffffffffc020271a <pmm_init+0xac8>
ffffffffc0201d8e:	000bb683          	ld	a3,0(s7)
ffffffffc0201d92:	5a7d                	li	s4,-1
ffffffffc0201d94:	6098                	ld	a4,0(s1)
ffffffffc0201d96:	40d406b3          	sub	a3,s0,a3
ffffffffc0201d9a:	8699                	srai	a3,a3,0x6
ffffffffc0201d9c:	00080437          	lui	s0,0x80
ffffffffc0201da0:	96a2                	add	a3,a3,s0
ffffffffc0201da2:	00ca5793          	srli	a5,s4,0xc
ffffffffc0201da6:	8ff5                	and	a5,a5,a3
ffffffffc0201da8:	06b2                	slli	a3,a3,0xc
ffffffffc0201daa:	30e7fde3          	bgeu	a5,a4,ffffffffc02028c4 <pmm_init+0xc72>
ffffffffc0201dae:	0009b403          	ld	s0,0(s3)
ffffffffc0201db2:	6605                	lui	a2,0x1
ffffffffc0201db4:	4581                	li	a1,0
ffffffffc0201db6:	9436                	add	s0,s0,a3
ffffffffc0201db8:	8522                	mv	a0,s0
ffffffffc0201dba:	244090ef          	jal	ra,ffffffffc020affe <memset>
ffffffffc0201dbe:	0009b683          	ld	a3,0(s3)
ffffffffc0201dc2:	77fd                	lui	a5,0xfffff
ffffffffc0201dc4:	0000a917          	auipc	s2,0xa
ffffffffc0201dc8:	73590913          	addi	s2,s2,1845 # ffffffffc020c4f9 <commands+0xd51>
ffffffffc0201dcc:	00f97933          	and	s2,s2,a5
ffffffffc0201dd0:	c0200ab7          	lui	s5,0xc0200
ffffffffc0201dd4:	3fe00637          	lui	a2,0x3fe00
ffffffffc0201dd8:	964a                	add	a2,a2,s2
ffffffffc0201dda:	4729                	li	a4,10
ffffffffc0201ddc:	40da86b3          	sub	a3,s5,a3
ffffffffc0201de0:	c02005b7          	lui	a1,0xc0200
ffffffffc0201de4:	8522                	mv	a0,s0
ffffffffc0201de6:	fe8ff0ef          	jal	ra,ffffffffc02015ce <boot_map_segment>
ffffffffc0201dea:	c8000637          	lui	a2,0xc8000
ffffffffc0201dee:	41260633          	sub	a2,a2,s2
ffffffffc0201df2:	3f596ce3          	bltu	s2,s5,ffffffffc02029ea <pmm_init+0xd98>
ffffffffc0201df6:	0009b683          	ld	a3,0(s3)
ffffffffc0201dfa:	85ca                	mv	a1,s2
ffffffffc0201dfc:	4719                	li	a4,6
ffffffffc0201dfe:	40d906b3          	sub	a3,s2,a3
ffffffffc0201e02:	8522                	mv	a0,s0
ffffffffc0201e04:	00095917          	auipc	s2,0x95
ffffffffc0201e08:	a8c90913          	addi	s2,s2,-1396 # ffffffffc0296890 <boot_pgdir_va>
ffffffffc0201e0c:	fc2ff0ef          	jal	ra,ffffffffc02015ce <boot_map_segment>
ffffffffc0201e10:	00893023          	sd	s0,0(s2)
ffffffffc0201e14:	2d5464e3          	bltu	s0,s5,ffffffffc02028dc <pmm_init+0xc8a>
ffffffffc0201e18:	0009b783          	ld	a5,0(s3)
ffffffffc0201e1c:	1a7e                	slli	s4,s4,0x3f
ffffffffc0201e1e:	8c1d                	sub	s0,s0,a5
ffffffffc0201e20:	00c45793          	srli	a5,s0,0xc
ffffffffc0201e24:	00095717          	auipc	a4,0x95
ffffffffc0201e28:	a6873223          	sd	s0,-1436(a4) # ffffffffc0296888 <boot_pgdir_pa>
ffffffffc0201e2c:	0147ea33          	or	s4,a5,s4
ffffffffc0201e30:	180a1073          	csrw	satp,s4
ffffffffc0201e34:	12000073          	sfence.vma
ffffffffc0201e38:	0000a517          	auipc	a0,0xa
ffffffffc0201e3c:	47850513          	addi	a0,a0,1144 # ffffffffc020c2b0 <commands+0xb08>
ffffffffc0201e40:	aeafe0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0201e44:	0000f717          	auipc	a4,0xf
ffffffffc0201e48:	1bc70713          	addi	a4,a4,444 # ffffffffc0211000 <bootstack>
ffffffffc0201e4c:	0000f797          	auipc	a5,0xf
ffffffffc0201e50:	1b478793          	addi	a5,a5,436 # ffffffffc0211000 <bootstack>
ffffffffc0201e54:	5cf70d63          	beq	a4,a5,ffffffffc020242e <pmm_init+0x7dc>
ffffffffc0201e58:	100027f3          	csrr	a5,sstatus
ffffffffc0201e5c:	8b89                	andi	a5,a5,2
ffffffffc0201e5e:	4a079763          	bnez	a5,ffffffffc020230c <pmm_init+0x6ba>
ffffffffc0201e62:	000b3783          	ld	a5,0(s6)
ffffffffc0201e66:	779c                	ld	a5,40(a5)
ffffffffc0201e68:	9782                	jalr	a5
ffffffffc0201e6a:	842a                	mv	s0,a0
ffffffffc0201e6c:	6098                	ld	a4,0(s1)
ffffffffc0201e6e:	c80007b7          	lui	a5,0xc8000
ffffffffc0201e72:	83b1                	srli	a5,a5,0xc
ffffffffc0201e74:	08e7e3e3          	bltu	a5,a4,ffffffffc02026fa <pmm_init+0xaa8>
ffffffffc0201e78:	00093503          	ld	a0,0(s2)
ffffffffc0201e7c:	04050fe3          	beqz	a0,ffffffffc02026da <pmm_init+0xa88>
ffffffffc0201e80:	03451793          	slli	a5,a0,0x34
ffffffffc0201e84:	04079be3          	bnez	a5,ffffffffc02026da <pmm_init+0xa88>
ffffffffc0201e88:	4601                	li	a2,0
ffffffffc0201e8a:	4581                	li	a1,0
ffffffffc0201e8c:	809ff0ef          	jal	ra,ffffffffc0201694 <get_page>
ffffffffc0201e90:	2e0511e3          	bnez	a0,ffffffffc0202972 <pmm_init+0xd20>
ffffffffc0201e94:	100027f3          	csrr	a5,sstatus
ffffffffc0201e98:	8b89                	andi	a5,a5,2
ffffffffc0201e9a:	44079e63          	bnez	a5,ffffffffc02022f6 <pmm_init+0x6a4>
ffffffffc0201e9e:	000b3783          	ld	a5,0(s6)
ffffffffc0201ea2:	4505                	li	a0,1
ffffffffc0201ea4:	6f9c                	ld	a5,24(a5)
ffffffffc0201ea6:	9782                	jalr	a5
ffffffffc0201ea8:	8a2a                	mv	s4,a0
ffffffffc0201eaa:	00093503          	ld	a0,0(s2)
ffffffffc0201eae:	4681                	li	a3,0
ffffffffc0201eb0:	4601                	li	a2,0
ffffffffc0201eb2:	85d2                	mv	a1,s4
ffffffffc0201eb4:	ca9ff0ef          	jal	ra,ffffffffc0201b5c <page_insert>
ffffffffc0201eb8:	26051be3          	bnez	a0,ffffffffc020292e <pmm_init+0xcdc>
ffffffffc0201ebc:	00093503          	ld	a0,0(s2)
ffffffffc0201ec0:	4601                	li	a2,0
ffffffffc0201ec2:	4581                	li	a1,0
ffffffffc0201ec4:	ce2ff0ef          	jal	ra,ffffffffc02013a6 <get_pte>
ffffffffc0201ec8:	280505e3          	beqz	a0,ffffffffc0202952 <pmm_init+0xd00>
ffffffffc0201ecc:	611c                	ld	a5,0(a0)
ffffffffc0201ece:	0017f713          	andi	a4,a5,1
ffffffffc0201ed2:	26070ee3          	beqz	a4,ffffffffc020294e <pmm_init+0xcfc>
ffffffffc0201ed6:	6098                	ld	a4,0(s1)
ffffffffc0201ed8:	078a                	slli	a5,a5,0x2
ffffffffc0201eda:	83b1                	srli	a5,a5,0xc
ffffffffc0201edc:	62e7f363          	bgeu	a5,a4,ffffffffc0202502 <pmm_init+0x8b0>
ffffffffc0201ee0:	000bb683          	ld	a3,0(s7)
ffffffffc0201ee4:	fff80637          	lui	a2,0xfff80
ffffffffc0201ee8:	97b2                	add	a5,a5,a2
ffffffffc0201eea:	079a                	slli	a5,a5,0x6
ffffffffc0201eec:	97b6                	add	a5,a5,a3
ffffffffc0201eee:	2afa12e3          	bne	s4,a5,ffffffffc0202992 <pmm_init+0xd40>
ffffffffc0201ef2:	000a2683          	lw	a3,0(s4) # 1000 <_binary_bin_swap_img_size-0x6d00>
ffffffffc0201ef6:	4785                	li	a5,1
ffffffffc0201ef8:	2cf699e3          	bne	a3,a5,ffffffffc02029ca <pmm_init+0xd78>
ffffffffc0201efc:	00093503          	ld	a0,0(s2)
ffffffffc0201f00:	77fd                	lui	a5,0xfffff
ffffffffc0201f02:	6114                	ld	a3,0(a0)
ffffffffc0201f04:	068a                	slli	a3,a3,0x2
ffffffffc0201f06:	8efd                	and	a3,a3,a5
ffffffffc0201f08:	00c6d613          	srli	a2,a3,0xc
ffffffffc0201f0c:	2ae673e3          	bgeu	a2,a4,ffffffffc02029b2 <pmm_init+0xd60>
ffffffffc0201f10:	0009bc03          	ld	s8,0(s3)
ffffffffc0201f14:	96e2                	add	a3,a3,s8
ffffffffc0201f16:	0006ba83          	ld	s5,0(a3) # fffffffffff80000 <end+0x3fce96f0>
ffffffffc0201f1a:	0a8a                	slli	s5,s5,0x2
ffffffffc0201f1c:	00fafab3          	and	s5,s5,a5
ffffffffc0201f20:	00cad793          	srli	a5,s5,0xc
ffffffffc0201f24:	06e7f3e3          	bgeu	a5,a4,ffffffffc020278a <pmm_init+0xb38>
ffffffffc0201f28:	4601                	li	a2,0
ffffffffc0201f2a:	6585                	lui	a1,0x1
ffffffffc0201f2c:	9ae2                	add	s5,s5,s8
ffffffffc0201f2e:	c78ff0ef          	jal	ra,ffffffffc02013a6 <get_pte>
ffffffffc0201f32:	0aa1                	addi	s5,s5,8
ffffffffc0201f34:	03551be3          	bne	a0,s5,ffffffffc020276a <pmm_init+0xb18>
ffffffffc0201f38:	100027f3          	csrr	a5,sstatus
ffffffffc0201f3c:	8b89                	andi	a5,a5,2
ffffffffc0201f3e:	3a079163          	bnez	a5,ffffffffc02022e0 <pmm_init+0x68e>
ffffffffc0201f42:	000b3783          	ld	a5,0(s6)
ffffffffc0201f46:	4505                	li	a0,1
ffffffffc0201f48:	6f9c                	ld	a5,24(a5)
ffffffffc0201f4a:	9782                	jalr	a5
ffffffffc0201f4c:	8c2a                	mv	s8,a0
ffffffffc0201f4e:	00093503          	ld	a0,0(s2)
ffffffffc0201f52:	46d1                	li	a3,20
ffffffffc0201f54:	6605                	lui	a2,0x1
ffffffffc0201f56:	85e2                	mv	a1,s8
ffffffffc0201f58:	c05ff0ef          	jal	ra,ffffffffc0201b5c <page_insert>
ffffffffc0201f5c:	1a0519e3          	bnez	a0,ffffffffc020290e <pmm_init+0xcbc>
ffffffffc0201f60:	00093503          	ld	a0,0(s2)
ffffffffc0201f64:	4601                	li	a2,0
ffffffffc0201f66:	6585                	lui	a1,0x1
ffffffffc0201f68:	c3eff0ef          	jal	ra,ffffffffc02013a6 <get_pte>
ffffffffc0201f6c:	10050ce3          	beqz	a0,ffffffffc0202884 <pmm_init+0xc32>
ffffffffc0201f70:	611c                	ld	a5,0(a0)
ffffffffc0201f72:	0107f713          	andi	a4,a5,16
ffffffffc0201f76:	0e0707e3          	beqz	a4,ffffffffc0202864 <pmm_init+0xc12>
ffffffffc0201f7a:	8b91                	andi	a5,a5,4
ffffffffc0201f7c:	0c0784e3          	beqz	a5,ffffffffc0202844 <pmm_init+0xbf2>
ffffffffc0201f80:	00093503          	ld	a0,0(s2)
ffffffffc0201f84:	611c                	ld	a5,0(a0)
ffffffffc0201f86:	8bc1                	andi	a5,a5,16
ffffffffc0201f88:	08078ee3          	beqz	a5,ffffffffc0202824 <pmm_init+0xbd2>
ffffffffc0201f8c:	000c2703          	lw	a4,0(s8)
ffffffffc0201f90:	4785                	li	a5,1
ffffffffc0201f92:	06f719e3          	bne	a4,a5,ffffffffc0202804 <pmm_init+0xbb2>
ffffffffc0201f96:	4681                	li	a3,0
ffffffffc0201f98:	6605                	lui	a2,0x1
ffffffffc0201f9a:	85d2                	mv	a1,s4
ffffffffc0201f9c:	bc1ff0ef          	jal	ra,ffffffffc0201b5c <page_insert>
ffffffffc0201fa0:	040512e3          	bnez	a0,ffffffffc02027e4 <pmm_init+0xb92>
ffffffffc0201fa4:	000a2703          	lw	a4,0(s4)
ffffffffc0201fa8:	4789                	li	a5,2
ffffffffc0201faa:	00f71de3          	bne	a4,a5,ffffffffc02027c4 <pmm_init+0xb72>
ffffffffc0201fae:	000c2783          	lw	a5,0(s8)
ffffffffc0201fb2:	7e079963          	bnez	a5,ffffffffc02027a4 <pmm_init+0xb52>
ffffffffc0201fb6:	00093503          	ld	a0,0(s2)
ffffffffc0201fba:	4601                	li	a2,0
ffffffffc0201fbc:	6585                	lui	a1,0x1
ffffffffc0201fbe:	be8ff0ef          	jal	ra,ffffffffc02013a6 <get_pte>
ffffffffc0201fc2:	54050263          	beqz	a0,ffffffffc0202506 <pmm_init+0x8b4>
ffffffffc0201fc6:	6118                	ld	a4,0(a0)
ffffffffc0201fc8:	00177793          	andi	a5,a4,1
ffffffffc0201fcc:	180781e3          	beqz	a5,ffffffffc020294e <pmm_init+0xcfc>
ffffffffc0201fd0:	6094                	ld	a3,0(s1)
ffffffffc0201fd2:	00271793          	slli	a5,a4,0x2
ffffffffc0201fd6:	83b1                	srli	a5,a5,0xc
ffffffffc0201fd8:	52d7f563          	bgeu	a5,a3,ffffffffc0202502 <pmm_init+0x8b0>
ffffffffc0201fdc:	000bb683          	ld	a3,0(s7)
ffffffffc0201fe0:	fff80ab7          	lui	s5,0xfff80
ffffffffc0201fe4:	97d6                	add	a5,a5,s5
ffffffffc0201fe6:	079a                	slli	a5,a5,0x6
ffffffffc0201fe8:	97b6                	add	a5,a5,a3
ffffffffc0201fea:	58fa1e63          	bne	s4,a5,ffffffffc0202586 <pmm_init+0x934>
ffffffffc0201fee:	8b41                	andi	a4,a4,16
ffffffffc0201ff0:	56071b63          	bnez	a4,ffffffffc0202566 <pmm_init+0x914>
ffffffffc0201ff4:	00093503          	ld	a0,0(s2)
ffffffffc0201ff8:	4581                	li	a1,0
ffffffffc0201ffa:	ac7ff0ef          	jal	ra,ffffffffc0201ac0 <page_remove>
ffffffffc0201ffe:	000a2c83          	lw	s9,0(s4)
ffffffffc0202002:	4785                	li	a5,1
ffffffffc0202004:	5cfc9163          	bne	s9,a5,ffffffffc02025c6 <pmm_init+0x974>
ffffffffc0202008:	000c2783          	lw	a5,0(s8)
ffffffffc020200c:	58079d63          	bnez	a5,ffffffffc02025a6 <pmm_init+0x954>
ffffffffc0202010:	00093503          	ld	a0,0(s2)
ffffffffc0202014:	6585                	lui	a1,0x1
ffffffffc0202016:	aabff0ef          	jal	ra,ffffffffc0201ac0 <page_remove>
ffffffffc020201a:	000a2783          	lw	a5,0(s4)
ffffffffc020201e:	200793e3          	bnez	a5,ffffffffc0202a24 <pmm_init+0xdd2>
ffffffffc0202022:	000c2783          	lw	a5,0(s8)
ffffffffc0202026:	1c079fe3          	bnez	a5,ffffffffc0202a04 <pmm_init+0xdb2>
ffffffffc020202a:	00093a03          	ld	s4,0(s2)
ffffffffc020202e:	608c                	ld	a1,0(s1)
ffffffffc0202030:	000a3683          	ld	a3,0(s4)
ffffffffc0202034:	068a                	slli	a3,a3,0x2
ffffffffc0202036:	82b1                	srli	a3,a3,0xc
ffffffffc0202038:	4cb6f563          	bgeu	a3,a1,ffffffffc0202502 <pmm_init+0x8b0>
ffffffffc020203c:	000bb503          	ld	a0,0(s7)
ffffffffc0202040:	96d6                	add	a3,a3,s5
ffffffffc0202042:	069a                	slli	a3,a3,0x6
ffffffffc0202044:	00d507b3          	add	a5,a0,a3
ffffffffc0202048:	439c                	lw	a5,0(a5)
ffffffffc020204a:	4f979e63          	bne	a5,s9,ffffffffc0202546 <pmm_init+0x8f4>
ffffffffc020204e:	8699                	srai	a3,a3,0x6
ffffffffc0202050:	00080637          	lui	a2,0x80
ffffffffc0202054:	96b2                	add	a3,a3,a2
ffffffffc0202056:	00c69713          	slli	a4,a3,0xc
ffffffffc020205a:	8331                	srli	a4,a4,0xc
ffffffffc020205c:	06b2                	slli	a3,a3,0xc
ffffffffc020205e:	06b773e3          	bgeu	a4,a1,ffffffffc02028c4 <pmm_init+0xc72>
ffffffffc0202062:	0009b703          	ld	a4,0(s3)
ffffffffc0202066:	96ba                	add	a3,a3,a4
ffffffffc0202068:	629c                	ld	a5,0(a3)
ffffffffc020206a:	078a                	slli	a5,a5,0x2
ffffffffc020206c:	83b1                	srli	a5,a5,0xc
ffffffffc020206e:	48b7fa63          	bgeu	a5,a1,ffffffffc0202502 <pmm_init+0x8b0>
ffffffffc0202072:	8f91                	sub	a5,a5,a2
ffffffffc0202074:	079a                	slli	a5,a5,0x6
ffffffffc0202076:	953e                	add	a0,a0,a5
ffffffffc0202078:	100027f3          	csrr	a5,sstatus
ffffffffc020207c:	8b89                	andi	a5,a5,2
ffffffffc020207e:	32079463          	bnez	a5,ffffffffc02023a6 <pmm_init+0x754>
ffffffffc0202082:	000b3783          	ld	a5,0(s6)
ffffffffc0202086:	4585                	li	a1,1
ffffffffc0202088:	739c                	ld	a5,32(a5)
ffffffffc020208a:	9782                	jalr	a5
ffffffffc020208c:	000a3783          	ld	a5,0(s4)
ffffffffc0202090:	6098                	ld	a4,0(s1)
ffffffffc0202092:	078a                	slli	a5,a5,0x2
ffffffffc0202094:	83b1                	srli	a5,a5,0xc
ffffffffc0202096:	46e7f663          	bgeu	a5,a4,ffffffffc0202502 <pmm_init+0x8b0>
ffffffffc020209a:	000bb503          	ld	a0,0(s7)
ffffffffc020209e:	fff80737          	lui	a4,0xfff80
ffffffffc02020a2:	97ba                	add	a5,a5,a4
ffffffffc02020a4:	079a                	slli	a5,a5,0x6
ffffffffc02020a6:	953e                	add	a0,a0,a5
ffffffffc02020a8:	100027f3          	csrr	a5,sstatus
ffffffffc02020ac:	8b89                	andi	a5,a5,2
ffffffffc02020ae:	2e079063          	bnez	a5,ffffffffc020238e <pmm_init+0x73c>
ffffffffc02020b2:	000b3783          	ld	a5,0(s6)
ffffffffc02020b6:	4585                	li	a1,1
ffffffffc02020b8:	739c                	ld	a5,32(a5)
ffffffffc02020ba:	9782                	jalr	a5
ffffffffc02020bc:	00093783          	ld	a5,0(s2)
ffffffffc02020c0:	0007b023          	sd	zero,0(a5) # fffffffffffff000 <end+0x3fd686f0>
ffffffffc02020c4:	12000073          	sfence.vma
ffffffffc02020c8:	100027f3          	csrr	a5,sstatus
ffffffffc02020cc:	8b89                	andi	a5,a5,2
ffffffffc02020ce:	2a079663          	bnez	a5,ffffffffc020237a <pmm_init+0x728>
ffffffffc02020d2:	000b3783          	ld	a5,0(s6)
ffffffffc02020d6:	779c                	ld	a5,40(a5)
ffffffffc02020d8:	9782                	jalr	a5
ffffffffc02020da:	8a2a                	mv	s4,a0
ffffffffc02020dc:	7d441463          	bne	s0,s4,ffffffffc02028a4 <pmm_init+0xc52>
ffffffffc02020e0:	0000a517          	auipc	a0,0xa
ffffffffc02020e4:	52850513          	addi	a0,a0,1320 # ffffffffc020c608 <commands+0xe60>
ffffffffc02020e8:	842fe0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02020ec:	100027f3          	csrr	a5,sstatus
ffffffffc02020f0:	8b89                	andi	a5,a5,2
ffffffffc02020f2:	26079a63          	bnez	a5,ffffffffc0202366 <pmm_init+0x714>
ffffffffc02020f6:	000b3783          	ld	a5,0(s6)
ffffffffc02020fa:	779c                	ld	a5,40(a5)
ffffffffc02020fc:	9782                	jalr	a5
ffffffffc02020fe:	8c2a                	mv	s8,a0
ffffffffc0202100:	6098                	ld	a4,0(s1)
ffffffffc0202102:	c0200437          	lui	s0,0xc0200
ffffffffc0202106:	7afd                	lui	s5,0xfffff
ffffffffc0202108:	00c71793          	slli	a5,a4,0xc
ffffffffc020210c:	6a05                	lui	s4,0x1
ffffffffc020210e:	02f47c63          	bgeu	s0,a5,ffffffffc0202146 <pmm_init+0x4f4>
ffffffffc0202112:	00c45793          	srli	a5,s0,0xc
ffffffffc0202116:	00093503          	ld	a0,0(s2)
ffffffffc020211a:	3ae7f763          	bgeu	a5,a4,ffffffffc02024c8 <pmm_init+0x876>
ffffffffc020211e:	0009b583          	ld	a1,0(s3)
ffffffffc0202122:	4601                	li	a2,0
ffffffffc0202124:	95a2                	add	a1,a1,s0
ffffffffc0202126:	a80ff0ef          	jal	ra,ffffffffc02013a6 <get_pte>
ffffffffc020212a:	36050f63          	beqz	a0,ffffffffc02024a8 <pmm_init+0x856>
ffffffffc020212e:	611c                	ld	a5,0(a0)
ffffffffc0202130:	078a                	slli	a5,a5,0x2
ffffffffc0202132:	0157f7b3          	and	a5,a5,s5
ffffffffc0202136:	3a879663          	bne	a5,s0,ffffffffc02024e2 <pmm_init+0x890>
ffffffffc020213a:	6098                	ld	a4,0(s1)
ffffffffc020213c:	9452                	add	s0,s0,s4
ffffffffc020213e:	00c71793          	slli	a5,a4,0xc
ffffffffc0202142:	fcf468e3          	bltu	s0,a5,ffffffffc0202112 <pmm_init+0x4c0>
ffffffffc0202146:	00093783          	ld	a5,0(s2)
ffffffffc020214a:	639c                	ld	a5,0(a5)
ffffffffc020214c:	48079d63          	bnez	a5,ffffffffc02025e6 <pmm_init+0x994>
ffffffffc0202150:	100027f3          	csrr	a5,sstatus
ffffffffc0202154:	8b89                	andi	a5,a5,2
ffffffffc0202156:	26079463          	bnez	a5,ffffffffc02023be <pmm_init+0x76c>
ffffffffc020215a:	000b3783          	ld	a5,0(s6)
ffffffffc020215e:	4505                	li	a0,1
ffffffffc0202160:	6f9c                	ld	a5,24(a5)
ffffffffc0202162:	9782                	jalr	a5
ffffffffc0202164:	8a2a                	mv	s4,a0
ffffffffc0202166:	00093503          	ld	a0,0(s2)
ffffffffc020216a:	4699                	li	a3,6
ffffffffc020216c:	10000613          	li	a2,256
ffffffffc0202170:	85d2                	mv	a1,s4
ffffffffc0202172:	9ebff0ef          	jal	ra,ffffffffc0201b5c <page_insert>
ffffffffc0202176:	4a051863          	bnez	a0,ffffffffc0202626 <pmm_init+0x9d4>
ffffffffc020217a:	000a2703          	lw	a4,0(s4) # 1000 <_binary_bin_swap_img_size-0x6d00>
ffffffffc020217e:	4785                	li	a5,1
ffffffffc0202180:	48f71363          	bne	a4,a5,ffffffffc0202606 <pmm_init+0x9b4>
ffffffffc0202184:	00093503          	ld	a0,0(s2)
ffffffffc0202188:	6405                	lui	s0,0x1
ffffffffc020218a:	4699                	li	a3,6
ffffffffc020218c:	10040613          	addi	a2,s0,256 # 1100 <_binary_bin_swap_img_size-0x6c00>
ffffffffc0202190:	85d2                	mv	a1,s4
ffffffffc0202192:	9cbff0ef          	jal	ra,ffffffffc0201b5c <page_insert>
ffffffffc0202196:	38051863          	bnez	a0,ffffffffc0202526 <pmm_init+0x8d4>
ffffffffc020219a:	000a2703          	lw	a4,0(s4)
ffffffffc020219e:	4789                	li	a5,2
ffffffffc02021a0:	4ef71363          	bne	a4,a5,ffffffffc0202686 <pmm_init+0xa34>
ffffffffc02021a4:	0000a597          	auipc	a1,0xa
ffffffffc02021a8:	5ac58593          	addi	a1,a1,1452 # ffffffffc020c750 <commands+0xfa8>
ffffffffc02021ac:	10000513          	li	a0,256
ffffffffc02021b0:	5e3080ef          	jal	ra,ffffffffc020af92 <strcpy>
ffffffffc02021b4:	10040593          	addi	a1,s0,256
ffffffffc02021b8:	10000513          	li	a0,256
ffffffffc02021bc:	5e9080ef          	jal	ra,ffffffffc020afa4 <strcmp>
ffffffffc02021c0:	4a051363          	bnez	a0,ffffffffc0202666 <pmm_init+0xa14>
ffffffffc02021c4:	000bb683          	ld	a3,0(s7)
ffffffffc02021c8:	00080737          	lui	a4,0x80
ffffffffc02021cc:	547d                	li	s0,-1
ffffffffc02021ce:	40da06b3          	sub	a3,s4,a3
ffffffffc02021d2:	8699                	srai	a3,a3,0x6
ffffffffc02021d4:	609c                	ld	a5,0(s1)
ffffffffc02021d6:	96ba                	add	a3,a3,a4
ffffffffc02021d8:	8031                	srli	s0,s0,0xc
ffffffffc02021da:	0086f733          	and	a4,a3,s0
ffffffffc02021de:	06b2                	slli	a3,a3,0xc
ffffffffc02021e0:	6ef77263          	bgeu	a4,a5,ffffffffc02028c4 <pmm_init+0xc72>
ffffffffc02021e4:	0009b783          	ld	a5,0(s3)
ffffffffc02021e8:	10000513          	li	a0,256
ffffffffc02021ec:	96be                	add	a3,a3,a5
ffffffffc02021ee:	10068023          	sb	zero,256(a3)
ffffffffc02021f2:	56b080ef          	jal	ra,ffffffffc020af5c <strlen>
ffffffffc02021f6:	44051863          	bnez	a0,ffffffffc0202646 <pmm_init+0x9f4>
ffffffffc02021fa:	00093a83          	ld	s5,0(s2)
ffffffffc02021fe:	609c                	ld	a5,0(s1)
ffffffffc0202200:	000ab683          	ld	a3,0(s5) # fffffffffffff000 <end+0x3fd686f0>
ffffffffc0202204:	068a                	slli	a3,a3,0x2
ffffffffc0202206:	82b1                	srli	a3,a3,0xc
ffffffffc0202208:	2ef6fd63          	bgeu	a3,a5,ffffffffc0202502 <pmm_init+0x8b0>
ffffffffc020220c:	8c75                	and	s0,s0,a3
ffffffffc020220e:	06b2                	slli	a3,a3,0xc
ffffffffc0202210:	6af47a63          	bgeu	s0,a5,ffffffffc02028c4 <pmm_init+0xc72>
ffffffffc0202214:	0009b403          	ld	s0,0(s3)
ffffffffc0202218:	9436                	add	s0,s0,a3
ffffffffc020221a:	100027f3          	csrr	a5,sstatus
ffffffffc020221e:	8b89                	andi	a5,a5,2
ffffffffc0202220:	1e079c63          	bnez	a5,ffffffffc0202418 <pmm_init+0x7c6>
ffffffffc0202224:	000b3783          	ld	a5,0(s6)
ffffffffc0202228:	4585                	li	a1,1
ffffffffc020222a:	8552                	mv	a0,s4
ffffffffc020222c:	739c                	ld	a5,32(a5)
ffffffffc020222e:	9782                	jalr	a5
ffffffffc0202230:	601c                	ld	a5,0(s0)
ffffffffc0202232:	6098                	ld	a4,0(s1)
ffffffffc0202234:	078a                	slli	a5,a5,0x2
ffffffffc0202236:	83b1                	srli	a5,a5,0xc
ffffffffc0202238:	2ce7f563          	bgeu	a5,a4,ffffffffc0202502 <pmm_init+0x8b0>
ffffffffc020223c:	000bb503          	ld	a0,0(s7)
ffffffffc0202240:	fff80737          	lui	a4,0xfff80
ffffffffc0202244:	97ba                	add	a5,a5,a4
ffffffffc0202246:	079a                	slli	a5,a5,0x6
ffffffffc0202248:	953e                	add	a0,a0,a5
ffffffffc020224a:	100027f3          	csrr	a5,sstatus
ffffffffc020224e:	8b89                	andi	a5,a5,2
ffffffffc0202250:	1a079863          	bnez	a5,ffffffffc0202400 <pmm_init+0x7ae>
ffffffffc0202254:	000b3783          	ld	a5,0(s6)
ffffffffc0202258:	4585                	li	a1,1
ffffffffc020225a:	739c                	ld	a5,32(a5)
ffffffffc020225c:	9782                	jalr	a5
ffffffffc020225e:	000ab783          	ld	a5,0(s5)
ffffffffc0202262:	6098                	ld	a4,0(s1)
ffffffffc0202264:	078a                	slli	a5,a5,0x2
ffffffffc0202266:	83b1                	srli	a5,a5,0xc
ffffffffc0202268:	28e7fd63          	bgeu	a5,a4,ffffffffc0202502 <pmm_init+0x8b0>
ffffffffc020226c:	000bb503          	ld	a0,0(s7)
ffffffffc0202270:	fff80737          	lui	a4,0xfff80
ffffffffc0202274:	97ba                	add	a5,a5,a4
ffffffffc0202276:	079a                	slli	a5,a5,0x6
ffffffffc0202278:	953e                	add	a0,a0,a5
ffffffffc020227a:	100027f3          	csrr	a5,sstatus
ffffffffc020227e:	8b89                	andi	a5,a5,2
ffffffffc0202280:	16079463          	bnez	a5,ffffffffc02023e8 <pmm_init+0x796>
ffffffffc0202284:	000b3783          	ld	a5,0(s6)
ffffffffc0202288:	4585                	li	a1,1
ffffffffc020228a:	739c                	ld	a5,32(a5)
ffffffffc020228c:	9782                	jalr	a5
ffffffffc020228e:	00093783          	ld	a5,0(s2)
ffffffffc0202292:	0007b023          	sd	zero,0(a5)
ffffffffc0202296:	12000073          	sfence.vma
ffffffffc020229a:	100027f3          	csrr	a5,sstatus
ffffffffc020229e:	8b89                	andi	a5,a5,2
ffffffffc02022a0:	12079a63          	bnez	a5,ffffffffc02023d4 <pmm_init+0x782>
ffffffffc02022a4:	000b3783          	ld	a5,0(s6)
ffffffffc02022a8:	779c                	ld	a5,40(a5)
ffffffffc02022aa:	9782                	jalr	a5
ffffffffc02022ac:	842a                	mv	s0,a0
ffffffffc02022ae:	488c1e63          	bne	s8,s0,ffffffffc020274a <pmm_init+0xaf8>
ffffffffc02022b2:	0000a517          	auipc	a0,0xa
ffffffffc02022b6:	51650513          	addi	a0,a0,1302 # ffffffffc020c7c8 <commands+0x1020>
ffffffffc02022ba:	e71fd0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02022be:	7406                	ld	s0,96(sp)
ffffffffc02022c0:	70a6                	ld	ra,104(sp)
ffffffffc02022c2:	64e6                	ld	s1,88(sp)
ffffffffc02022c4:	6946                	ld	s2,80(sp)
ffffffffc02022c6:	69a6                	ld	s3,72(sp)
ffffffffc02022c8:	6a06                	ld	s4,64(sp)
ffffffffc02022ca:	7ae2                	ld	s5,56(sp)
ffffffffc02022cc:	7b42                	ld	s6,48(sp)
ffffffffc02022ce:	7ba2                	ld	s7,40(sp)
ffffffffc02022d0:	7c02                	ld	s8,32(sp)
ffffffffc02022d2:	6ce2                	ld	s9,24(sp)
ffffffffc02022d4:	6165                	addi	sp,sp,112
ffffffffc02022d6:	4cc0106f          	j	ffffffffc02037a2 <kmalloc_init>
ffffffffc02022da:	c80007b7          	lui	a5,0xc8000
ffffffffc02022de:	b411                	j	ffffffffc0201ce2 <pmm_init+0x90>
ffffffffc02022e0:	ac5fe0ef          	jal	ra,ffffffffc0200da4 <intr_disable>
ffffffffc02022e4:	000b3783          	ld	a5,0(s6)
ffffffffc02022e8:	4505                	li	a0,1
ffffffffc02022ea:	6f9c                	ld	a5,24(a5)
ffffffffc02022ec:	9782                	jalr	a5
ffffffffc02022ee:	8c2a                	mv	s8,a0
ffffffffc02022f0:	aaffe0ef          	jal	ra,ffffffffc0200d9e <intr_enable>
ffffffffc02022f4:	b9a9                	j	ffffffffc0201f4e <pmm_init+0x2fc>
ffffffffc02022f6:	aaffe0ef          	jal	ra,ffffffffc0200da4 <intr_disable>
ffffffffc02022fa:	000b3783          	ld	a5,0(s6)
ffffffffc02022fe:	4505                	li	a0,1
ffffffffc0202300:	6f9c                	ld	a5,24(a5)
ffffffffc0202302:	9782                	jalr	a5
ffffffffc0202304:	8a2a                	mv	s4,a0
ffffffffc0202306:	a99fe0ef          	jal	ra,ffffffffc0200d9e <intr_enable>
ffffffffc020230a:	b645                	j	ffffffffc0201eaa <pmm_init+0x258>
ffffffffc020230c:	a99fe0ef          	jal	ra,ffffffffc0200da4 <intr_disable>
ffffffffc0202310:	000b3783          	ld	a5,0(s6)
ffffffffc0202314:	779c                	ld	a5,40(a5)
ffffffffc0202316:	9782                	jalr	a5
ffffffffc0202318:	842a                	mv	s0,a0
ffffffffc020231a:	a85fe0ef          	jal	ra,ffffffffc0200d9e <intr_enable>
ffffffffc020231e:	b6b9                	j	ffffffffc0201e6c <pmm_init+0x21a>
ffffffffc0202320:	a85fe0ef          	jal	ra,ffffffffc0200da4 <intr_disable>
ffffffffc0202324:	000b3783          	ld	a5,0(s6)
ffffffffc0202328:	4505                	li	a0,1
ffffffffc020232a:	6f9c                	ld	a5,24(a5)
ffffffffc020232c:	9782                	jalr	a5
ffffffffc020232e:	842a                	mv	s0,a0
ffffffffc0202330:	a6ffe0ef          	jal	ra,ffffffffc0200d9e <intr_enable>
ffffffffc0202334:	bc99                	j	ffffffffc0201d8a <pmm_init+0x138>
ffffffffc0202336:	6705                	lui	a4,0x1
ffffffffc0202338:	177d                	addi	a4,a4,-1
ffffffffc020233a:	96ba                	add	a3,a3,a4
ffffffffc020233c:	8ff5                	and	a5,a5,a3
ffffffffc020233e:	00c7d713          	srli	a4,a5,0xc
ffffffffc0202342:	1ca77063          	bgeu	a4,a0,ffffffffc0202502 <pmm_init+0x8b0>
ffffffffc0202346:	000b3683          	ld	a3,0(s6)
ffffffffc020234a:	fff80537          	lui	a0,0xfff80
ffffffffc020234e:	972a                	add	a4,a4,a0
ffffffffc0202350:	6a94                	ld	a3,16(a3)
ffffffffc0202352:	8c1d                	sub	s0,s0,a5
ffffffffc0202354:	00671513          	slli	a0,a4,0x6
ffffffffc0202358:	00c45593          	srli	a1,s0,0xc
ffffffffc020235c:	9532                	add	a0,a0,a2
ffffffffc020235e:	9682                	jalr	a3
ffffffffc0202360:	0009b583          	ld	a1,0(s3)
ffffffffc0202364:	bac5                	j	ffffffffc0201d54 <pmm_init+0x102>
ffffffffc0202366:	a3ffe0ef          	jal	ra,ffffffffc0200da4 <intr_disable>
ffffffffc020236a:	000b3783          	ld	a5,0(s6)
ffffffffc020236e:	779c                	ld	a5,40(a5)
ffffffffc0202370:	9782                	jalr	a5
ffffffffc0202372:	8c2a                	mv	s8,a0
ffffffffc0202374:	a2bfe0ef          	jal	ra,ffffffffc0200d9e <intr_enable>
ffffffffc0202378:	b361                	j	ffffffffc0202100 <pmm_init+0x4ae>
ffffffffc020237a:	a2bfe0ef          	jal	ra,ffffffffc0200da4 <intr_disable>
ffffffffc020237e:	000b3783          	ld	a5,0(s6)
ffffffffc0202382:	779c                	ld	a5,40(a5)
ffffffffc0202384:	9782                	jalr	a5
ffffffffc0202386:	8a2a                	mv	s4,a0
ffffffffc0202388:	a17fe0ef          	jal	ra,ffffffffc0200d9e <intr_enable>
ffffffffc020238c:	bb81                	j	ffffffffc02020dc <pmm_init+0x48a>
ffffffffc020238e:	e42a                	sd	a0,8(sp)
ffffffffc0202390:	a15fe0ef          	jal	ra,ffffffffc0200da4 <intr_disable>
ffffffffc0202394:	000b3783          	ld	a5,0(s6)
ffffffffc0202398:	6522                	ld	a0,8(sp)
ffffffffc020239a:	4585                	li	a1,1
ffffffffc020239c:	739c                	ld	a5,32(a5)
ffffffffc020239e:	9782                	jalr	a5
ffffffffc02023a0:	9fffe0ef          	jal	ra,ffffffffc0200d9e <intr_enable>
ffffffffc02023a4:	bb21                	j	ffffffffc02020bc <pmm_init+0x46a>
ffffffffc02023a6:	e42a                	sd	a0,8(sp)
ffffffffc02023a8:	9fdfe0ef          	jal	ra,ffffffffc0200da4 <intr_disable>
ffffffffc02023ac:	000b3783          	ld	a5,0(s6)
ffffffffc02023b0:	6522                	ld	a0,8(sp)
ffffffffc02023b2:	4585                	li	a1,1
ffffffffc02023b4:	739c                	ld	a5,32(a5)
ffffffffc02023b6:	9782                	jalr	a5
ffffffffc02023b8:	9e7fe0ef          	jal	ra,ffffffffc0200d9e <intr_enable>
ffffffffc02023bc:	b9c1                	j	ffffffffc020208c <pmm_init+0x43a>
ffffffffc02023be:	9e7fe0ef          	jal	ra,ffffffffc0200da4 <intr_disable>
ffffffffc02023c2:	000b3783          	ld	a5,0(s6)
ffffffffc02023c6:	4505                	li	a0,1
ffffffffc02023c8:	6f9c                	ld	a5,24(a5)
ffffffffc02023ca:	9782                	jalr	a5
ffffffffc02023cc:	8a2a                	mv	s4,a0
ffffffffc02023ce:	9d1fe0ef          	jal	ra,ffffffffc0200d9e <intr_enable>
ffffffffc02023d2:	bb51                	j	ffffffffc0202166 <pmm_init+0x514>
ffffffffc02023d4:	9d1fe0ef          	jal	ra,ffffffffc0200da4 <intr_disable>
ffffffffc02023d8:	000b3783          	ld	a5,0(s6)
ffffffffc02023dc:	779c                	ld	a5,40(a5)
ffffffffc02023de:	9782                	jalr	a5
ffffffffc02023e0:	842a                	mv	s0,a0
ffffffffc02023e2:	9bdfe0ef          	jal	ra,ffffffffc0200d9e <intr_enable>
ffffffffc02023e6:	b5e1                	j	ffffffffc02022ae <pmm_init+0x65c>
ffffffffc02023e8:	e42a                	sd	a0,8(sp)
ffffffffc02023ea:	9bbfe0ef          	jal	ra,ffffffffc0200da4 <intr_disable>
ffffffffc02023ee:	000b3783          	ld	a5,0(s6)
ffffffffc02023f2:	6522                	ld	a0,8(sp)
ffffffffc02023f4:	4585                	li	a1,1
ffffffffc02023f6:	739c                	ld	a5,32(a5)
ffffffffc02023f8:	9782                	jalr	a5
ffffffffc02023fa:	9a5fe0ef          	jal	ra,ffffffffc0200d9e <intr_enable>
ffffffffc02023fe:	bd41                	j	ffffffffc020228e <pmm_init+0x63c>
ffffffffc0202400:	e42a                	sd	a0,8(sp)
ffffffffc0202402:	9a3fe0ef          	jal	ra,ffffffffc0200da4 <intr_disable>
ffffffffc0202406:	000b3783          	ld	a5,0(s6)
ffffffffc020240a:	6522                	ld	a0,8(sp)
ffffffffc020240c:	4585                	li	a1,1
ffffffffc020240e:	739c                	ld	a5,32(a5)
ffffffffc0202410:	9782                	jalr	a5
ffffffffc0202412:	98dfe0ef          	jal	ra,ffffffffc0200d9e <intr_enable>
ffffffffc0202416:	b5a1                	j	ffffffffc020225e <pmm_init+0x60c>
ffffffffc0202418:	98dfe0ef          	jal	ra,ffffffffc0200da4 <intr_disable>
ffffffffc020241c:	000b3783          	ld	a5,0(s6)
ffffffffc0202420:	4585                	li	a1,1
ffffffffc0202422:	8552                	mv	a0,s4
ffffffffc0202424:	739c                	ld	a5,32(a5)
ffffffffc0202426:	9782                	jalr	a5
ffffffffc0202428:	977fe0ef          	jal	ra,ffffffffc0200d9e <intr_enable>
ffffffffc020242c:	b511                	j	ffffffffc0202230 <pmm_init+0x5de>
ffffffffc020242e:	00011417          	auipc	s0,0x11
ffffffffc0202432:	bd240413          	addi	s0,s0,-1070 # ffffffffc0213000 <boot_page_table_sv39>
ffffffffc0202436:	00011797          	auipc	a5,0x11
ffffffffc020243a:	bca78793          	addi	a5,a5,-1078 # ffffffffc0213000 <boot_page_table_sv39>
ffffffffc020243e:	a0f41de3          	bne	s0,a5,ffffffffc0201e58 <pmm_init+0x206>
ffffffffc0202442:	4581                	li	a1,0
ffffffffc0202444:	6605                	lui	a2,0x1
ffffffffc0202446:	8522                	mv	a0,s0
ffffffffc0202448:	3b7080ef          	jal	ra,ffffffffc020affe <memset>
ffffffffc020244c:	0000e597          	auipc	a1,0xe
ffffffffc0202450:	bb458593          	addi	a1,a1,-1100 # ffffffffc0210000 <bootstackguard>
ffffffffc0202454:	0000f797          	auipc	a5,0xf
ffffffffc0202458:	ba0785a3          	sb	zero,-1109(a5) # ffffffffc0210fff <bootstackguard+0xfff>
ffffffffc020245c:	0000e797          	auipc	a5,0xe
ffffffffc0202460:	ba078223          	sb	zero,-1116(a5) # ffffffffc0210000 <bootstackguard>
ffffffffc0202464:	00093503          	ld	a0,0(s2)
ffffffffc0202468:	2555ec63          	bltu	a1,s5,ffffffffc02026c0 <pmm_init+0xa6e>
ffffffffc020246c:	0009b683          	ld	a3,0(s3)
ffffffffc0202470:	4701                	li	a4,0
ffffffffc0202472:	6605                	lui	a2,0x1
ffffffffc0202474:	40d586b3          	sub	a3,a1,a3
ffffffffc0202478:	956ff0ef          	jal	ra,ffffffffc02015ce <boot_map_segment>
ffffffffc020247c:	00093503          	ld	a0,0(s2)
ffffffffc0202480:	23546363          	bltu	s0,s5,ffffffffc02026a6 <pmm_init+0xa54>
ffffffffc0202484:	0009b683          	ld	a3,0(s3)
ffffffffc0202488:	4701                	li	a4,0
ffffffffc020248a:	6605                	lui	a2,0x1
ffffffffc020248c:	40d406b3          	sub	a3,s0,a3
ffffffffc0202490:	85a2                	mv	a1,s0
ffffffffc0202492:	93cff0ef          	jal	ra,ffffffffc02015ce <boot_map_segment>
ffffffffc0202496:	12000073          	sfence.vma
ffffffffc020249a:	0000a517          	auipc	a0,0xa
ffffffffc020249e:	e3e50513          	addi	a0,a0,-450 # ffffffffc020c2d8 <commands+0xb30>
ffffffffc02024a2:	c89fd0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02024a6:	ba4d                	j	ffffffffc0201e58 <pmm_init+0x206>
ffffffffc02024a8:	0000a697          	auipc	a3,0xa
ffffffffc02024ac:	18068693          	addi	a3,a3,384 # ffffffffc020c628 <commands+0xe80>
ffffffffc02024b0:	00009617          	auipc	a2,0x9
ffffffffc02024b4:	35860613          	addi	a2,a2,856 # ffffffffc020b808 <commands+0x60>
ffffffffc02024b8:	28800593          	li	a1,648
ffffffffc02024bc:	0000a517          	auipc	a0,0xa
ffffffffc02024c0:	c7c50513          	addi	a0,a0,-900 # ffffffffc020c138 <commands+0x990>
ffffffffc02024c4:	d6bfd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02024c8:	86a2                	mv	a3,s0
ffffffffc02024ca:	0000a617          	auipc	a2,0xa
ffffffffc02024ce:	c4660613          	addi	a2,a2,-954 # ffffffffc020c110 <commands+0x968>
ffffffffc02024d2:	28800593          	li	a1,648
ffffffffc02024d6:	0000a517          	auipc	a0,0xa
ffffffffc02024da:	c6250513          	addi	a0,a0,-926 # ffffffffc020c138 <commands+0x990>
ffffffffc02024de:	d51fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02024e2:	0000a697          	auipc	a3,0xa
ffffffffc02024e6:	18668693          	addi	a3,a3,390 # ffffffffc020c668 <commands+0xec0>
ffffffffc02024ea:	00009617          	auipc	a2,0x9
ffffffffc02024ee:	31e60613          	addi	a2,a2,798 # ffffffffc020b808 <commands+0x60>
ffffffffc02024f2:	28900593          	li	a1,649
ffffffffc02024f6:	0000a517          	auipc	a0,0xa
ffffffffc02024fa:	c4250513          	addi	a0,a0,-958 # ffffffffc020c138 <commands+0x990>
ffffffffc02024fe:	d31fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202502:	db5fe0ef          	jal	ra,ffffffffc02012b6 <pa2page.part.0>
ffffffffc0202506:	0000a697          	auipc	a3,0xa
ffffffffc020250a:	f8a68693          	addi	a3,a3,-118 # ffffffffc020c490 <commands+0xce8>
ffffffffc020250e:	00009617          	auipc	a2,0x9
ffffffffc0202512:	2fa60613          	addi	a2,a2,762 # ffffffffc020b808 <commands+0x60>
ffffffffc0202516:	26500593          	li	a1,613
ffffffffc020251a:	0000a517          	auipc	a0,0xa
ffffffffc020251e:	c1e50513          	addi	a0,a0,-994 # ffffffffc020c138 <commands+0x990>
ffffffffc0202522:	d0dfd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202526:	0000a697          	auipc	a3,0xa
ffffffffc020252a:	1ca68693          	addi	a3,a3,458 # ffffffffc020c6f0 <commands+0xf48>
ffffffffc020252e:	00009617          	auipc	a2,0x9
ffffffffc0202532:	2da60613          	addi	a2,a2,730 # ffffffffc020b808 <commands+0x60>
ffffffffc0202536:	29200593          	li	a1,658
ffffffffc020253a:	0000a517          	auipc	a0,0xa
ffffffffc020253e:	bfe50513          	addi	a0,a0,-1026 # ffffffffc020c138 <commands+0x990>
ffffffffc0202542:	cedfd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202546:	0000a697          	auipc	a3,0xa
ffffffffc020254a:	06a68693          	addi	a3,a3,106 # ffffffffc020c5b0 <commands+0xe08>
ffffffffc020254e:	00009617          	auipc	a2,0x9
ffffffffc0202552:	2ba60613          	addi	a2,a2,698 # ffffffffc020b808 <commands+0x60>
ffffffffc0202556:	27100593          	li	a1,625
ffffffffc020255a:	0000a517          	auipc	a0,0xa
ffffffffc020255e:	bde50513          	addi	a0,a0,-1058 # ffffffffc020c138 <commands+0x990>
ffffffffc0202562:	ccdfd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202566:	0000a697          	auipc	a3,0xa
ffffffffc020256a:	01a68693          	addi	a3,a3,26 # ffffffffc020c580 <commands+0xdd8>
ffffffffc020256e:	00009617          	auipc	a2,0x9
ffffffffc0202572:	29a60613          	addi	a2,a2,666 # ffffffffc020b808 <commands+0x60>
ffffffffc0202576:	26700593          	li	a1,615
ffffffffc020257a:	0000a517          	auipc	a0,0xa
ffffffffc020257e:	bbe50513          	addi	a0,a0,-1090 # ffffffffc020c138 <commands+0x990>
ffffffffc0202582:	cadfd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202586:	0000a697          	auipc	a3,0xa
ffffffffc020258a:	e6a68693          	addi	a3,a3,-406 # ffffffffc020c3f0 <commands+0xc48>
ffffffffc020258e:	00009617          	auipc	a2,0x9
ffffffffc0202592:	27a60613          	addi	a2,a2,634 # ffffffffc020b808 <commands+0x60>
ffffffffc0202596:	26600593          	li	a1,614
ffffffffc020259a:	0000a517          	auipc	a0,0xa
ffffffffc020259e:	b9e50513          	addi	a0,a0,-1122 # ffffffffc020c138 <commands+0x990>
ffffffffc02025a2:	c8dfd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02025a6:	0000a697          	auipc	a3,0xa
ffffffffc02025aa:	fc268693          	addi	a3,a3,-62 # ffffffffc020c568 <commands+0xdc0>
ffffffffc02025ae:	00009617          	auipc	a2,0x9
ffffffffc02025b2:	25a60613          	addi	a2,a2,602 # ffffffffc020b808 <commands+0x60>
ffffffffc02025b6:	26b00593          	li	a1,619
ffffffffc02025ba:	0000a517          	auipc	a0,0xa
ffffffffc02025be:	b7e50513          	addi	a0,a0,-1154 # ffffffffc020c138 <commands+0x990>
ffffffffc02025c2:	c6dfd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02025c6:	0000a697          	auipc	a3,0xa
ffffffffc02025ca:	e4268693          	addi	a3,a3,-446 # ffffffffc020c408 <commands+0xc60>
ffffffffc02025ce:	00009617          	auipc	a2,0x9
ffffffffc02025d2:	23a60613          	addi	a2,a2,570 # ffffffffc020b808 <commands+0x60>
ffffffffc02025d6:	26a00593          	li	a1,618
ffffffffc02025da:	0000a517          	auipc	a0,0xa
ffffffffc02025de:	b5e50513          	addi	a0,a0,-1186 # ffffffffc020c138 <commands+0x990>
ffffffffc02025e2:	c4dfd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02025e6:	0000a697          	auipc	a3,0xa
ffffffffc02025ea:	09a68693          	addi	a3,a3,154 # ffffffffc020c680 <commands+0xed8>
ffffffffc02025ee:	00009617          	auipc	a2,0x9
ffffffffc02025f2:	21a60613          	addi	a2,a2,538 # ffffffffc020b808 <commands+0x60>
ffffffffc02025f6:	28c00593          	li	a1,652
ffffffffc02025fa:	0000a517          	auipc	a0,0xa
ffffffffc02025fe:	b3e50513          	addi	a0,a0,-1218 # ffffffffc020c138 <commands+0x990>
ffffffffc0202602:	c2dfd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202606:	0000a697          	auipc	a3,0xa
ffffffffc020260a:	0d268693          	addi	a3,a3,210 # ffffffffc020c6d8 <commands+0xf30>
ffffffffc020260e:	00009617          	auipc	a2,0x9
ffffffffc0202612:	1fa60613          	addi	a2,a2,506 # ffffffffc020b808 <commands+0x60>
ffffffffc0202616:	29100593          	li	a1,657
ffffffffc020261a:	0000a517          	auipc	a0,0xa
ffffffffc020261e:	b1e50513          	addi	a0,a0,-1250 # ffffffffc020c138 <commands+0x990>
ffffffffc0202622:	c0dfd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202626:	0000a697          	auipc	a3,0xa
ffffffffc020262a:	07268693          	addi	a3,a3,114 # ffffffffc020c698 <commands+0xef0>
ffffffffc020262e:	00009617          	auipc	a2,0x9
ffffffffc0202632:	1da60613          	addi	a2,a2,474 # ffffffffc020b808 <commands+0x60>
ffffffffc0202636:	29000593          	li	a1,656
ffffffffc020263a:	0000a517          	auipc	a0,0xa
ffffffffc020263e:	afe50513          	addi	a0,a0,-1282 # ffffffffc020c138 <commands+0x990>
ffffffffc0202642:	bedfd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202646:	0000a697          	auipc	a3,0xa
ffffffffc020264a:	15a68693          	addi	a3,a3,346 # ffffffffc020c7a0 <commands+0xff8>
ffffffffc020264e:	00009617          	auipc	a2,0x9
ffffffffc0202652:	1ba60613          	addi	a2,a2,442 # ffffffffc020b808 <commands+0x60>
ffffffffc0202656:	29a00593          	li	a1,666
ffffffffc020265a:	0000a517          	auipc	a0,0xa
ffffffffc020265e:	ade50513          	addi	a0,a0,-1314 # ffffffffc020c138 <commands+0x990>
ffffffffc0202662:	bcdfd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202666:	0000a697          	auipc	a3,0xa
ffffffffc020266a:	10268693          	addi	a3,a3,258 # ffffffffc020c768 <commands+0xfc0>
ffffffffc020266e:	00009617          	auipc	a2,0x9
ffffffffc0202672:	19a60613          	addi	a2,a2,410 # ffffffffc020b808 <commands+0x60>
ffffffffc0202676:	29700593          	li	a1,663
ffffffffc020267a:	0000a517          	auipc	a0,0xa
ffffffffc020267e:	abe50513          	addi	a0,a0,-1346 # ffffffffc020c138 <commands+0x990>
ffffffffc0202682:	badfd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202686:	0000a697          	auipc	a3,0xa
ffffffffc020268a:	0b268693          	addi	a3,a3,178 # ffffffffc020c738 <commands+0xf90>
ffffffffc020268e:	00009617          	auipc	a2,0x9
ffffffffc0202692:	17a60613          	addi	a2,a2,378 # ffffffffc020b808 <commands+0x60>
ffffffffc0202696:	29300593          	li	a1,659
ffffffffc020269a:	0000a517          	auipc	a0,0xa
ffffffffc020269e:	a9e50513          	addi	a0,a0,-1378 # ffffffffc020c138 <commands+0x990>
ffffffffc02026a2:	b8dfd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02026a6:	86a2                	mv	a3,s0
ffffffffc02026a8:	0000a617          	auipc	a2,0xa
ffffffffc02026ac:	b8860613          	addi	a2,a2,-1144 # ffffffffc020c230 <commands+0xa88>
ffffffffc02026b0:	0dc00593          	li	a1,220
ffffffffc02026b4:	0000a517          	auipc	a0,0xa
ffffffffc02026b8:	a8450513          	addi	a0,a0,-1404 # ffffffffc020c138 <commands+0x990>
ffffffffc02026bc:	b73fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02026c0:	86ae                	mv	a3,a1
ffffffffc02026c2:	0000a617          	auipc	a2,0xa
ffffffffc02026c6:	b6e60613          	addi	a2,a2,-1170 # ffffffffc020c230 <commands+0xa88>
ffffffffc02026ca:	0db00593          	li	a1,219
ffffffffc02026ce:	0000a517          	auipc	a0,0xa
ffffffffc02026d2:	a6a50513          	addi	a0,a0,-1430 # ffffffffc020c138 <commands+0x990>
ffffffffc02026d6:	b59fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02026da:	0000a697          	auipc	a3,0xa
ffffffffc02026de:	c4668693          	addi	a3,a3,-954 # ffffffffc020c320 <commands+0xb78>
ffffffffc02026e2:	00009617          	auipc	a2,0x9
ffffffffc02026e6:	12660613          	addi	a2,a2,294 # ffffffffc020b808 <commands+0x60>
ffffffffc02026ea:	24a00593          	li	a1,586
ffffffffc02026ee:	0000a517          	auipc	a0,0xa
ffffffffc02026f2:	a4a50513          	addi	a0,a0,-1462 # ffffffffc020c138 <commands+0x990>
ffffffffc02026f6:	b39fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02026fa:	0000a697          	auipc	a3,0xa
ffffffffc02026fe:	c0668693          	addi	a3,a3,-1018 # ffffffffc020c300 <commands+0xb58>
ffffffffc0202702:	00009617          	auipc	a2,0x9
ffffffffc0202706:	10660613          	addi	a2,a2,262 # ffffffffc020b808 <commands+0x60>
ffffffffc020270a:	24900593          	li	a1,585
ffffffffc020270e:	0000a517          	auipc	a0,0xa
ffffffffc0202712:	a2a50513          	addi	a0,a0,-1494 # ffffffffc020c138 <commands+0x990>
ffffffffc0202716:	b19fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020271a:	0000a617          	auipc	a2,0xa
ffffffffc020271e:	b7660613          	addi	a2,a2,-1162 # ffffffffc020c290 <commands+0xae8>
ffffffffc0202722:	0aa00593          	li	a1,170
ffffffffc0202726:	0000a517          	auipc	a0,0xa
ffffffffc020272a:	a1250513          	addi	a0,a0,-1518 # ffffffffc020c138 <commands+0x990>
ffffffffc020272e:	b01fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202732:	0000a617          	auipc	a2,0xa
ffffffffc0202736:	a9e60613          	addi	a2,a2,-1378 # ffffffffc020c1d0 <commands+0xa28>
ffffffffc020273a:	06500593          	li	a1,101
ffffffffc020273e:	0000a517          	auipc	a0,0xa
ffffffffc0202742:	9fa50513          	addi	a0,a0,-1542 # ffffffffc020c138 <commands+0x990>
ffffffffc0202746:	ae9fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020274a:	0000a697          	auipc	a3,0xa
ffffffffc020274e:	e9668693          	addi	a3,a3,-362 # ffffffffc020c5e0 <commands+0xe38>
ffffffffc0202752:	00009617          	auipc	a2,0x9
ffffffffc0202756:	0b660613          	addi	a2,a2,182 # ffffffffc020b808 <commands+0x60>
ffffffffc020275a:	2a300593          	li	a1,675
ffffffffc020275e:	0000a517          	auipc	a0,0xa
ffffffffc0202762:	9da50513          	addi	a0,a0,-1574 # ffffffffc020c138 <commands+0x990>
ffffffffc0202766:	ac9fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020276a:	0000a697          	auipc	a3,0xa
ffffffffc020276e:	cb668693          	addi	a3,a3,-842 # ffffffffc020c420 <commands+0xc78>
ffffffffc0202772:	00009617          	auipc	a2,0x9
ffffffffc0202776:	09660613          	addi	a2,a2,150 # ffffffffc020b808 <commands+0x60>
ffffffffc020277a:	25800593          	li	a1,600
ffffffffc020277e:	0000a517          	auipc	a0,0xa
ffffffffc0202782:	9ba50513          	addi	a0,a0,-1606 # ffffffffc020c138 <commands+0x990>
ffffffffc0202786:	aa9fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020278a:	86d6                	mv	a3,s5
ffffffffc020278c:	0000a617          	auipc	a2,0xa
ffffffffc0202790:	98460613          	addi	a2,a2,-1660 # ffffffffc020c110 <commands+0x968>
ffffffffc0202794:	25700593          	li	a1,599
ffffffffc0202798:	0000a517          	auipc	a0,0xa
ffffffffc020279c:	9a050513          	addi	a0,a0,-1632 # ffffffffc020c138 <commands+0x990>
ffffffffc02027a0:	a8ffd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02027a4:	0000a697          	auipc	a3,0xa
ffffffffc02027a8:	dc468693          	addi	a3,a3,-572 # ffffffffc020c568 <commands+0xdc0>
ffffffffc02027ac:	00009617          	auipc	a2,0x9
ffffffffc02027b0:	05c60613          	addi	a2,a2,92 # ffffffffc020b808 <commands+0x60>
ffffffffc02027b4:	26400593          	li	a1,612
ffffffffc02027b8:	0000a517          	auipc	a0,0xa
ffffffffc02027bc:	98050513          	addi	a0,a0,-1664 # ffffffffc020c138 <commands+0x990>
ffffffffc02027c0:	a6ffd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02027c4:	0000a697          	auipc	a3,0xa
ffffffffc02027c8:	d8c68693          	addi	a3,a3,-628 # ffffffffc020c550 <commands+0xda8>
ffffffffc02027cc:	00009617          	auipc	a2,0x9
ffffffffc02027d0:	03c60613          	addi	a2,a2,60 # ffffffffc020b808 <commands+0x60>
ffffffffc02027d4:	26300593          	li	a1,611
ffffffffc02027d8:	0000a517          	auipc	a0,0xa
ffffffffc02027dc:	96050513          	addi	a0,a0,-1696 # ffffffffc020c138 <commands+0x990>
ffffffffc02027e0:	a4ffd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02027e4:	0000a697          	auipc	a3,0xa
ffffffffc02027e8:	d3c68693          	addi	a3,a3,-708 # ffffffffc020c520 <commands+0xd78>
ffffffffc02027ec:	00009617          	auipc	a2,0x9
ffffffffc02027f0:	01c60613          	addi	a2,a2,28 # ffffffffc020b808 <commands+0x60>
ffffffffc02027f4:	26200593          	li	a1,610
ffffffffc02027f8:	0000a517          	auipc	a0,0xa
ffffffffc02027fc:	94050513          	addi	a0,a0,-1728 # ffffffffc020c138 <commands+0x990>
ffffffffc0202800:	a2ffd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202804:	0000a697          	auipc	a3,0xa
ffffffffc0202808:	d0468693          	addi	a3,a3,-764 # ffffffffc020c508 <commands+0xd60>
ffffffffc020280c:	00009617          	auipc	a2,0x9
ffffffffc0202810:	ffc60613          	addi	a2,a2,-4 # ffffffffc020b808 <commands+0x60>
ffffffffc0202814:	26000593          	li	a1,608
ffffffffc0202818:	0000a517          	auipc	a0,0xa
ffffffffc020281c:	92050513          	addi	a0,a0,-1760 # ffffffffc020c138 <commands+0x990>
ffffffffc0202820:	a0ffd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202824:	0000a697          	auipc	a3,0xa
ffffffffc0202828:	cc468693          	addi	a3,a3,-828 # ffffffffc020c4e8 <commands+0xd40>
ffffffffc020282c:	00009617          	auipc	a2,0x9
ffffffffc0202830:	fdc60613          	addi	a2,a2,-36 # ffffffffc020b808 <commands+0x60>
ffffffffc0202834:	25f00593          	li	a1,607
ffffffffc0202838:	0000a517          	auipc	a0,0xa
ffffffffc020283c:	90050513          	addi	a0,a0,-1792 # ffffffffc020c138 <commands+0x990>
ffffffffc0202840:	9effd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202844:	0000a697          	auipc	a3,0xa
ffffffffc0202848:	c9468693          	addi	a3,a3,-876 # ffffffffc020c4d8 <commands+0xd30>
ffffffffc020284c:	00009617          	auipc	a2,0x9
ffffffffc0202850:	fbc60613          	addi	a2,a2,-68 # ffffffffc020b808 <commands+0x60>
ffffffffc0202854:	25e00593          	li	a1,606
ffffffffc0202858:	0000a517          	auipc	a0,0xa
ffffffffc020285c:	8e050513          	addi	a0,a0,-1824 # ffffffffc020c138 <commands+0x990>
ffffffffc0202860:	9cffd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202864:	0000a697          	auipc	a3,0xa
ffffffffc0202868:	c6468693          	addi	a3,a3,-924 # ffffffffc020c4c8 <commands+0xd20>
ffffffffc020286c:	00009617          	auipc	a2,0x9
ffffffffc0202870:	f9c60613          	addi	a2,a2,-100 # ffffffffc020b808 <commands+0x60>
ffffffffc0202874:	25d00593          	li	a1,605
ffffffffc0202878:	0000a517          	auipc	a0,0xa
ffffffffc020287c:	8c050513          	addi	a0,a0,-1856 # ffffffffc020c138 <commands+0x990>
ffffffffc0202880:	9affd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202884:	0000a697          	auipc	a3,0xa
ffffffffc0202888:	c0c68693          	addi	a3,a3,-1012 # ffffffffc020c490 <commands+0xce8>
ffffffffc020288c:	00009617          	auipc	a2,0x9
ffffffffc0202890:	f7c60613          	addi	a2,a2,-132 # ffffffffc020b808 <commands+0x60>
ffffffffc0202894:	25c00593          	li	a1,604
ffffffffc0202898:	0000a517          	auipc	a0,0xa
ffffffffc020289c:	8a050513          	addi	a0,a0,-1888 # ffffffffc020c138 <commands+0x990>
ffffffffc02028a0:	98ffd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02028a4:	0000a697          	auipc	a3,0xa
ffffffffc02028a8:	d3c68693          	addi	a3,a3,-708 # ffffffffc020c5e0 <commands+0xe38>
ffffffffc02028ac:	00009617          	auipc	a2,0x9
ffffffffc02028b0:	f5c60613          	addi	a2,a2,-164 # ffffffffc020b808 <commands+0x60>
ffffffffc02028b4:	27900593          	li	a1,633
ffffffffc02028b8:	0000a517          	auipc	a0,0xa
ffffffffc02028bc:	88050513          	addi	a0,a0,-1920 # ffffffffc020c138 <commands+0x990>
ffffffffc02028c0:	96ffd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02028c4:	0000a617          	auipc	a2,0xa
ffffffffc02028c8:	84c60613          	addi	a2,a2,-1972 # ffffffffc020c110 <commands+0x968>
ffffffffc02028cc:	07100593          	li	a1,113
ffffffffc02028d0:	0000a517          	auipc	a0,0xa
ffffffffc02028d4:	80850513          	addi	a0,a0,-2040 # ffffffffc020c0d8 <commands+0x930>
ffffffffc02028d8:	957fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02028dc:	86a2                	mv	a3,s0
ffffffffc02028de:	0000a617          	auipc	a2,0xa
ffffffffc02028e2:	95260613          	addi	a2,a2,-1710 # ffffffffc020c230 <commands+0xa88>
ffffffffc02028e6:	0ca00593          	li	a1,202
ffffffffc02028ea:	0000a517          	auipc	a0,0xa
ffffffffc02028ee:	84e50513          	addi	a0,a0,-1970 # ffffffffc020c138 <commands+0x990>
ffffffffc02028f2:	93dfd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02028f6:	0000a617          	auipc	a2,0xa
ffffffffc02028fa:	93a60613          	addi	a2,a2,-1734 # ffffffffc020c230 <commands+0xa88>
ffffffffc02028fe:	08100593          	li	a1,129
ffffffffc0202902:	0000a517          	auipc	a0,0xa
ffffffffc0202906:	83650513          	addi	a0,a0,-1994 # ffffffffc020c138 <commands+0x990>
ffffffffc020290a:	925fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020290e:	0000a697          	auipc	a3,0xa
ffffffffc0202912:	b4268693          	addi	a3,a3,-1214 # ffffffffc020c450 <commands+0xca8>
ffffffffc0202916:	00009617          	auipc	a2,0x9
ffffffffc020291a:	ef260613          	addi	a2,a2,-270 # ffffffffc020b808 <commands+0x60>
ffffffffc020291e:	25b00593          	li	a1,603
ffffffffc0202922:	0000a517          	auipc	a0,0xa
ffffffffc0202926:	81650513          	addi	a0,a0,-2026 # ffffffffc020c138 <commands+0x990>
ffffffffc020292a:	905fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020292e:	0000a697          	auipc	a3,0xa
ffffffffc0202932:	a6268693          	addi	a3,a3,-1438 # ffffffffc020c390 <commands+0xbe8>
ffffffffc0202936:	00009617          	auipc	a2,0x9
ffffffffc020293a:	ed260613          	addi	a2,a2,-302 # ffffffffc020b808 <commands+0x60>
ffffffffc020293e:	24f00593          	li	a1,591
ffffffffc0202942:	00009517          	auipc	a0,0x9
ffffffffc0202946:	7f650513          	addi	a0,a0,2038 # ffffffffc020c138 <commands+0x990>
ffffffffc020294a:	8e5fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020294e:	985fe0ef          	jal	ra,ffffffffc02012d2 <pte2page.part.0>
ffffffffc0202952:	0000a697          	auipc	a3,0xa
ffffffffc0202956:	a6e68693          	addi	a3,a3,-1426 # ffffffffc020c3c0 <commands+0xc18>
ffffffffc020295a:	00009617          	auipc	a2,0x9
ffffffffc020295e:	eae60613          	addi	a2,a2,-338 # ffffffffc020b808 <commands+0x60>
ffffffffc0202962:	25200593          	li	a1,594
ffffffffc0202966:	00009517          	auipc	a0,0x9
ffffffffc020296a:	7d250513          	addi	a0,a0,2002 # ffffffffc020c138 <commands+0x990>
ffffffffc020296e:	8c1fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202972:	0000a697          	auipc	a3,0xa
ffffffffc0202976:	9ee68693          	addi	a3,a3,-1554 # ffffffffc020c360 <commands+0xbb8>
ffffffffc020297a:	00009617          	auipc	a2,0x9
ffffffffc020297e:	e8e60613          	addi	a2,a2,-370 # ffffffffc020b808 <commands+0x60>
ffffffffc0202982:	24b00593          	li	a1,587
ffffffffc0202986:	00009517          	auipc	a0,0x9
ffffffffc020298a:	7b250513          	addi	a0,a0,1970 # ffffffffc020c138 <commands+0x990>
ffffffffc020298e:	8a1fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202992:	0000a697          	auipc	a3,0xa
ffffffffc0202996:	a5e68693          	addi	a3,a3,-1442 # ffffffffc020c3f0 <commands+0xc48>
ffffffffc020299a:	00009617          	auipc	a2,0x9
ffffffffc020299e:	e6e60613          	addi	a2,a2,-402 # ffffffffc020b808 <commands+0x60>
ffffffffc02029a2:	25300593          	li	a1,595
ffffffffc02029a6:	00009517          	auipc	a0,0x9
ffffffffc02029aa:	79250513          	addi	a0,a0,1938 # ffffffffc020c138 <commands+0x990>
ffffffffc02029ae:	881fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02029b2:	00009617          	auipc	a2,0x9
ffffffffc02029b6:	75e60613          	addi	a2,a2,1886 # ffffffffc020c110 <commands+0x968>
ffffffffc02029ba:	25600593          	li	a1,598
ffffffffc02029be:	00009517          	auipc	a0,0x9
ffffffffc02029c2:	77a50513          	addi	a0,a0,1914 # ffffffffc020c138 <commands+0x990>
ffffffffc02029c6:	869fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02029ca:	0000a697          	auipc	a3,0xa
ffffffffc02029ce:	a3e68693          	addi	a3,a3,-1474 # ffffffffc020c408 <commands+0xc60>
ffffffffc02029d2:	00009617          	auipc	a2,0x9
ffffffffc02029d6:	e3660613          	addi	a2,a2,-458 # ffffffffc020b808 <commands+0x60>
ffffffffc02029da:	25400593          	li	a1,596
ffffffffc02029de:	00009517          	auipc	a0,0x9
ffffffffc02029e2:	75a50513          	addi	a0,a0,1882 # ffffffffc020c138 <commands+0x990>
ffffffffc02029e6:	849fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02029ea:	86ca                	mv	a3,s2
ffffffffc02029ec:	0000a617          	auipc	a2,0xa
ffffffffc02029f0:	84460613          	addi	a2,a2,-1980 # ffffffffc020c230 <commands+0xa88>
ffffffffc02029f4:	0c600593          	li	a1,198
ffffffffc02029f8:	00009517          	auipc	a0,0x9
ffffffffc02029fc:	74050513          	addi	a0,a0,1856 # ffffffffc020c138 <commands+0x990>
ffffffffc0202a00:	82ffd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202a04:	0000a697          	auipc	a3,0xa
ffffffffc0202a08:	b6468693          	addi	a3,a3,-1180 # ffffffffc020c568 <commands+0xdc0>
ffffffffc0202a0c:	00009617          	auipc	a2,0x9
ffffffffc0202a10:	dfc60613          	addi	a2,a2,-516 # ffffffffc020b808 <commands+0x60>
ffffffffc0202a14:	26f00593          	li	a1,623
ffffffffc0202a18:	00009517          	auipc	a0,0x9
ffffffffc0202a1c:	72050513          	addi	a0,a0,1824 # ffffffffc020c138 <commands+0x990>
ffffffffc0202a20:	80ffd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202a24:	0000a697          	auipc	a3,0xa
ffffffffc0202a28:	b7468693          	addi	a3,a3,-1164 # ffffffffc020c598 <commands+0xdf0>
ffffffffc0202a2c:	00009617          	auipc	a2,0x9
ffffffffc0202a30:	ddc60613          	addi	a2,a2,-548 # ffffffffc020b808 <commands+0x60>
ffffffffc0202a34:	26e00593          	li	a1,622
ffffffffc0202a38:	00009517          	auipc	a0,0x9
ffffffffc0202a3c:	70050513          	addi	a0,a0,1792 # ffffffffc020c138 <commands+0x990>
ffffffffc0202a40:	feefd0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0202a44 <copy_range>:
ffffffffc0202a44:	7159                	addi	sp,sp,-112
ffffffffc0202a46:	00d667b3          	or	a5,a2,a3
ffffffffc0202a4a:	f486                	sd	ra,104(sp)
ffffffffc0202a4c:	f0a2                	sd	s0,96(sp)
ffffffffc0202a4e:	eca6                	sd	s1,88(sp)
ffffffffc0202a50:	e8ca                	sd	s2,80(sp)
ffffffffc0202a52:	e4ce                	sd	s3,72(sp)
ffffffffc0202a54:	e0d2                	sd	s4,64(sp)
ffffffffc0202a56:	fc56                	sd	s5,56(sp)
ffffffffc0202a58:	f85a                	sd	s6,48(sp)
ffffffffc0202a5a:	f45e                	sd	s7,40(sp)
ffffffffc0202a5c:	f062                	sd	s8,32(sp)
ffffffffc0202a5e:	ec66                	sd	s9,24(sp)
ffffffffc0202a60:	e86a                	sd	s10,16(sp)
ffffffffc0202a62:	e46e                	sd	s11,8(sp)
ffffffffc0202a64:	17d2                	slli	a5,a5,0x34
ffffffffc0202a66:	20079f63          	bnez	a5,ffffffffc0202c84 <copy_range+0x240>
ffffffffc0202a6a:	002007b7          	lui	a5,0x200
ffffffffc0202a6e:	8432                	mv	s0,a2
ffffffffc0202a70:	1af66263          	bltu	a2,a5,ffffffffc0202c14 <copy_range+0x1d0>
ffffffffc0202a74:	8936                	mv	s2,a3
ffffffffc0202a76:	18d67f63          	bgeu	a2,a3,ffffffffc0202c14 <copy_range+0x1d0>
ffffffffc0202a7a:	4785                	li	a5,1
ffffffffc0202a7c:	07fe                	slli	a5,a5,0x1f
ffffffffc0202a7e:	18d7eb63          	bltu	a5,a3,ffffffffc0202c14 <copy_range+0x1d0>
ffffffffc0202a82:	5b7d                	li	s6,-1
ffffffffc0202a84:	8aaa                	mv	s5,a0
ffffffffc0202a86:	89ae                	mv	s3,a1
ffffffffc0202a88:	6a05                	lui	s4,0x1
ffffffffc0202a8a:	00094c17          	auipc	s8,0x94
ffffffffc0202a8e:	e0ec0c13          	addi	s8,s8,-498 # ffffffffc0296898 <npage>
ffffffffc0202a92:	00094b97          	auipc	s7,0x94
ffffffffc0202a96:	e0eb8b93          	addi	s7,s7,-498 # ffffffffc02968a0 <pages>
ffffffffc0202a9a:	00cb5b13          	srli	s6,s6,0xc
ffffffffc0202a9e:	00094c97          	auipc	s9,0x94
ffffffffc0202aa2:	e0ac8c93          	addi	s9,s9,-502 # ffffffffc02968a8 <pmm_manager>
ffffffffc0202aa6:	4601                	li	a2,0
ffffffffc0202aa8:	85a2                	mv	a1,s0
ffffffffc0202aaa:	854e                	mv	a0,s3
ffffffffc0202aac:	8fbfe0ef          	jal	ra,ffffffffc02013a6 <get_pte>
ffffffffc0202ab0:	84aa                	mv	s1,a0
ffffffffc0202ab2:	0e050c63          	beqz	a0,ffffffffc0202baa <copy_range+0x166>
ffffffffc0202ab6:	611c                	ld	a5,0(a0)
ffffffffc0202ab8:	8b85                	andi	a5,a5,1
ffffffffc0202aba:	e785                	bnez	a5,ffffffffc0202ae2 <copy_range+0x9e>
ffffffffc0202abc:	9452                	add	s0,s0,s4
ffffffffc0202abe:	ff2464e3          	bltu	s0,s2,ffffffffc0202aa6 <copy_range+0x62>
ffffffffc0202ac2:	4501                	li	a0,0
ffffffffc0202ac4:	70a6                	ld	ra,104(sp)
ffffffffc0202ac6:	7406                	ld	s0,96(sp)
ffffffffc0202ac8:	64e6                	ld	s1,88(sp)
ffffffffc0202aca:	6946                	ld	s2,80(sp)
ffffffffc0202acc:	69a6                	ld	s3,72(sp)
ffffffffc0202ace:	6a06                	ld	s4,64(sp)
ffffffffc0202ad0:	7ae2                	ld	s5,56(sp)
ffffffffc0202ad2:	7b42                	ld	s6,48(sp)
ffffffffc0202ad4:	7ba2                	ld	s7,40(sp)
ffffffffc0202ad6:	7c02                	ld	s8,32(sp)
ffffffffc0202ad8:	6ce2                	ld	s9,24(sp)
ffffffffc0202ada:	6d42                	ld	s10,16(sp)
ffffffffc0202adc:	6da2                	ld	s11,8(sp)
ffffffffc0202ade:	6165                	addi	sp,sp,112
ffffffffc0202ae0:	8082                	ret
ffffffffc0202ae2:	4605                	li	a2,1
ffffffffc0202ae4:	85a2                	mv	a1,s0
ffffffffc0202ae6:	8556                	mv	a0,s5
ffffffffc0202ae8:	8bffe0ef          	jal	ra,ffffffffc02013a6 <get_pte>
ffffffffc0202aec:	c56d                	beqz	a0,ffffffffc0202bd6 <copy_range+0x192>
ffffffffc0202aee:	609c                	ld	a5,0(s1)
ffffffffc0202af0:	0017f713          	andi	a4,a5,1
ffffffffc0202af4:	01f7f493          	andi	s1,a5,31
ffffffffc0202af8:	16070a63          	beqz	a4,ffffffffc0202c6c <copy_range+0x228>
ffffffffc0202afc:	000c3683          	ld	a3,0(s8)
ffffffffc0202b00:	078a                	slli	a5,a5,0x2
ffffffffc0202b02:	00c7d713          	srli	a4,a5,0xc
ffffffffc0202b06:	14d77763          	bgeu	a4,a3,ffffffffc0202c54 <copy_range+0x210>
ffffffffc0202b0a:	000bb783          	ld	a5,0(s7)
ffffffffc0202b0e:	fff806b7          	lui	a3,0xfff80
ffffffffc0202b12:	9736                	add	a4,a4,a3
ffffffffc0202b14:	071a                	slli	a4,a4,0x6
ffffffffc0202b16:	00e78db3          	add	s11,a5,a4
ffffffffc0202b1a:	10002773          	csrr	a4,sstatus
ffffffffc0202b1e:	8b09                	andi	a4,a4,2
ffffffffc0202b20:	e345                	bnez	a4,ffffffffc0202bc0 <copy_range+0x17c>
ffffffffc0202b22:	000cb703          	ld	a4,0(s9)
ffffffffc0202b26:	4505                	li	a0,1
ffffffffc0202b28:	6f18                	ld	a4,24(a4)
ffffffffc0202b2a:	9702                	jalr	a4
ffffffffc0202b2c:	8d2a                	mv	s10,a0
ffffffffc0202b2e:	0c0d8363          	beqz	s11,ffffffffc0202bf4 <copy_range+0x1b0>
ffffffffc0202b32:	100d0163          	beqz	s10,ffffffffc0202c34 <copy_range+0x1f0>
ffffffffc0202b36:	000bb703          	ld	a4,0(s7)
ffffffffc0202b3a:	000805b7          	lui	a1,0x80
ffffffffc0202b3e:	000c3603          	ld	a2,0(s8)
ffffffffc0202b42:	40ed86b3          	sub	a3,s11,a4
ffffffffc0202b46:	8699                	srai	a3,a3,0x6
ffffffffc0202b48:	96ae                	add	a3,a3,a1
ffffffffc0202b4a:	0166f7b3          	and	a5,a3,s6
ffffffffc0202b4e:	06b2                	slli	a3,a3,0xc
ffffffffc0202b50:	08c7f663          	bgeu	a5,a2,ffffffffc0202bdc <copy_range+0x198>
ffffffffc0202b54:	40ed07b3          	sub	a5,s10,a4
ffffffffc0202b58:	00094717          	auipc	a4,0x94
ffffffffc0202b5c:	d5870713          	addi	a4,a4,-680 # ffffffffc02968b0 <va_pa_offset>
ffffffffc0202b60:	6308                	ld	a0,0(a4)
ffffffffc0202b62:	8799                	srai	a5,a5,0x6
ffffffffc0202b64:	97ae                	add	a5,a5,a1
ffffffffc0202b66:	0167f733          	and	a4,a5,s6
ffffffffc0202b6a:	00a685b3          	add	a1,a3,a0
ffffffffc0202b6e:	07b2                	slli	a5,a5,0xc
ffffffffc0202b70:	06c77563          	bgeu	a4,a2,ffffffffc0202bda <copy_range+0x196>
ffffffffc0202b74:	6605                	lui	a2,0x1
ffffffffc0202b76:	953e                	add	a0,a0,a5
ffffffffc0202b78:	4d8080ef          	jal	ra,ffffffffc020b050 <memcpy>
ffffffffc0202b7c:	86a6                	mv	a3,s1
ffffffffc0202b7e:	8622                	mv	a2,s0
ffffffffc0202b80:	85ea                	mv	a1,s10
ffffffffc0202b82:	8556                	mv	a0,s5
ffffffffc0202b84:	fd9fe0ef          	jal	ra,ffffffffc0201b5c <page_insert>
ffffffffc0202b88:	d915                	beqz	a0,ffffffffc0202abc <copy_range+0x78>
ffffffffc0202b8a:	0000a697          	auipc	a3,0xa
ffffffffc0202b8e:	c7e68693          	addi	a3,a3,-898 # ffffffffc020c808 <commands+0x1060>
ffffffffc0202b92:	00009617          	auipc	a2,0x9
ffffffffc0202b96:	c7660613          	addi	a2,a2,-906 # ffffffffc020b808 <commands+0x60>
ffffffffc0202b9a:	1e700593          	li	a1,487
ffffffffc0202b9e:	00009517          	auipc	a0,0x9
ffffffffc0202ba2:	59a50513          	addi	a0,a0,1434 # ffffffffc020c138 <commands+0x990>
ffffffffc0202ba6:	e88fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202baa:	00200637          	lui	a2,0x200
ffffffffc0202bae:	9432                	add	s0,s0,a2
ffffffffc0202bb0:	ffe00637          	lui	a2,0xffe00
ffffffffc0202bb4:	8c71                	and	s0,s0,a2
ffffffffc0202bb6:	f00406e3          	beqz	s0,ffffffffc0202ac2 <copy_range+0x7e>
ffffffffc0202bba:	ef2466e3          	bltu	s0,s2,ffffffffc0202aa6 <copy_range+0x62>
ffffffffc0202bbe:	b711                	j	ffffffffc0202ac2 <copy_range+0x7e>
ffffffffc0202bc0:	9e4fe0ef          	jal	ra,ffffffffc0200da4 <intr_disable>
ffffffffc0202bc4:	000cb703          	ld	a4,0(s9)
ffffffffc0202bc8:	4505                	li	a0,1
ffffffffc0202bca:	6f18                	ld	a4,24(a4)
ffffffffc0202bcc:	9702                	jalr	a4
ffffffffc0202bce:	8d2a                	mv	s10,a0
ffffffffc0202bd0:	9cefe0ef          	jal	ra,ffffffffc0200d9e <intr_enable>
ffffffffc0202bd4:	bfa9                	j	ffffffffc0202b2e <copy_range+0xea>
ffffffffc0202bd6:	5571                	li	a0,-4
ffffffffc0202bd8:	b5f5                	j	ffffffffc0202ac4 <copy_range+0x80>
ffffffffc0202bda:	86be                	mv	a3,a5
ffffffffc0202bdc:	00009617          	auipc	a2,0x9
ffffffffc0202be0:	53460613          	addi	a2,a2,1332 # ffffffffc020c110 <commands+0x968>
ffffffffc0202be4:	07100593          	li	a1,113
ffffffffc0202be8:	00009517          	auipc	a0,0x9
ffffffffc0202bec:	4f050513          	addi	a0,a0,1264 # ffffffffc020c0d8 <commands+0x930>
ffffffffc0202bf0:	e3efd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202bf4:	0000a697          	auipc	a3,0xa
ffffffffc0202bf8:	bf468693          	addi	a3,a3,-1036 # ffffffffc020c7e8 <commands+0x1040>
ffffffffc0202bfc:	00009617          	auipc	a2,0x9
ffffffffc0202c00:	c0c60613          	addi	a2,a2,-1012 # ffffffffc020b808 <commands+0x60>
ffffffffc0202c04:	1ce00593          	li	a1,462
ffffffffc0202c08:	00009517          	auipc	a0,0x9
ffffffffc0202c0c:	53050513          	addi	a0,a0,1328 # ffffffffc020c138 <commands+0x990>
ffffffffc0202c10:	e1efd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202c14:	00009697          	auipc	a3,0x9
ffffffffc0202c18:	58c68693          	addi	a3,a3,1420 # ffffffffc020c1a0 <commands+0x9f8>
ffffffffc0202c1c:	00009617          	auipc	a2,0x9
ffffffffc0202c20:	bec60613          	addi	a2,a2,-1044 # ffffffffc020b808 <commands+0x60>
ffffffffc0202c24:	1b600593          	li	a1,438
ffffffffc0202c28:	00009517          	auipc	a0,0x9
ffffffffc0202c2c:	51050513          	addi	a0,a0,1296 # ffffffffc020c138 <commands+0x990>
ffffffffc0202c30:	dfefd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202c34:	0000a697          	auipc	a3,0xa
ffffffffc0202c38:	bc468693          	addi	a3,a3,-1084 # ffffffffc020c7f8 <commands+0x1050>
ffffffffc0202c3c:	00009617          	auipc	a2,0x9
ffffffffc0202c40:	bcc60613          	addi	a2,a2,-1076 # ffffffffc020b808 <commands+0x60>
ffffffffc0202c44:	1cf00593          	li	a1,463
ffffffffc0202c48:	00009517          	auipc	a0,0x9
ffffffffc0202c4c:	4f050513          	addi	a0,a0,1264 # ffffffffc020c138 <commands+0x990>
ffffffffc0202c50:	ddefd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202c54:	00009617          	auipc	a2,0x9
ffffffffc0202c58:	46460613          	addi	a2,a2,1124 # ffffffffc020c0b8 <commands+0x910>
ffffffffc0202c5c:	06900593          	li	a1,105
ffffffffc0202c60:	00009517          	auipc	a0,0x9
ffffffffc0202c64:	47850513          	addi	a0,a0,1144 # ffffffffc020c0d8 <commands+0x930>
ffffffffc0202c68:	dc6fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202c6c:	00009617          	auipc	a2,0x9
ffffffffc0202c70:	47c60613          	addi	a2,a2,1148 # ffffffffc020c0e8 <commands+0x940>
ffffffffc0202c74:	07f00593          	li	a1,127
ffffffffc0202c78:	00009517          	auipc	a0,0x9
ffffffffc0202c7c:	46050513          	addi	a0,a0,1120 # ffffffffc020c0d8 <commands+0x930>
ffffffffc0202c80:	daefd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202c84:	00009697          	auipc	a3,0x9
ffffffffc0202c88:	4ec68693          	addi	a3,a3,1260 # ffffffffc020c170 <commands+0x9c8>
ffffffffc0202c8c:	00009617          	auipc	a2,0x9
ffffffffc0202c90:	b7c60613          	addi	a2,a2,-1156 # ffffffffc020b808 <commands+0x60>
ffffffffc0202c94:	1b500593          	li	a1,437
ffffffffc0202c98:	00009517          	auipc	a0,0x9
ffffffffc0202c9c:	4a050513          	addi	a0,a0,1184 # ffffffffc020c138 <commands+0x990>
ffffffffc0202ca0:	d8efd0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0202ca4 <pgdir_alloc_page>:
ffffffffc0202ca4:	7179                	addi	sp,sp,-48
ffffffffc0202ca6:	ec26                	sd	s1,24(sp)
ffffffffc0202ca8:	e84a                	sd	s2,16(sp)
ffffffffc0202caa:	e052                	sd	s4,0(sp)
ffffffffc0202cac:	f406                	sd	ra,40(sp)
ffffffffc0202cae:	f022                	sd	s0,32(sp)
ffffffffc0202cb0:	e44e                	sd	s3,8(sp)
ffffffffc0202cb2:	8a2a                	mv	s4,a0
ffffffffc0202cb4:	84ae                	mv	s1,a1
ffffffffc0202cb6:	8932                	mv	s2,a2
ffffffffc0202cb8:	100027f3          	csrr	a5,sstatus
ffffffffc0202cbc:	8b89                	andi	a5,a5,2
ffffffffc0202cbe:	00094997          	auipc	s3,0x94
ffffffffc0202cc2:	bea98993          	addi	s3,s3,-1046 # ffffffffc02968a8 <pmm_manager>
ffffffffc0202cc6:	ef8d                	bnez	a5,ffffffffc0202d00 <pgdir_alloc_page+0x5c>
ffffffffc0202cc8:	0009b783          	ld	a5,0(s3)
ffffffffc0202ccc:	4505                	li	a0,1
ffffffffc0202cce:	6f9c                	ld	a5,24(a5)
ffffffffc0202cd0:	9782                	jalr	a5
ffffffffc0202cd2:	842a                	mv	s0,a0
ffffffffc0202cd4:	cc09                	beqz	s0,ffffffffc0202cee <pgdir_alloc_page+0x4a>
ffffffffc0202cd6:	86ca                	mv	a3,s2
ffffffffc0202cd8:	8626                	mv	a2,s1
ffffffffc0202cda:	85a2                	mv	a1,s0
ffffffffc0202cdc:	8552                	mv	a0,s4
ffffffffc0202cde:	e7ffe0ef          	jal	ra,ffffffffc0201b5c <page_insert>
ffffffffc0202ce2:	e915                	bnez	a0,ffffffffc0202d16 <pgdir_alloc_page+0x72>
ffffffffc0202ce4:	4018                	lw	a4,0(s0)
ffffffffc0202ce6:	fc04                	sd	s1,56(s0)
ffffffffc0202ce8:	4785                	li	a5,1
ffffffffc0202cea:	04f71e63          	bne	a4,a5,ffffffffc0202d46 <pgdir_alloc_page+0xa2>
ffffffffc0202cee:	70a2                	ld	ra,40(sp)
ffffffffc0202cf0:	8522                	mv	a0,s0
ffffffffc0202cf2:	7402                	ld	s0,32(sp)
ffffffffc0202cf4:	64e2                	ld	s1,24(sp)
ffffffffc0202cf6:	6942                	ld	s2,16(sp)
ffffffffc0202cf8:	69a2                	ld	s3,8(sp)
ffffffffc0202cfa:	6a02                	ld	s4,0(sp)
ffffffffc0202cfc:	6145                	addi	sp,sp,48
ffffffffc0202cfe:	8082                	ret
ffffffffc0202d00:	8a4fe0ef          	jal	ra,ffffffffc0200da4 <intr_disable>
ffffffffc0202d04:	0009b783          	ld	a5,0(s3)
ffffffffc0202d08:	4505                	li	a0,1
ffffffffc0202d0a:	6f9c                	ld	a5,24(a5)
ffffffffc0202d0c:	9782                	jalr	a5
ffffffffc0202d0e:	842a                	mv	s0,a0
ffffffffc0202d10:	88efe0ef          	jal	ra,ffffffffc0200d9e <intr_enable>
ffffffffc0202d14:	b7c1                	j	ffffffffc0202cd4 <pgdir_alloc_page+0x30>
ffffffffc0202d16:	100027f3          	csrr	a5,sstatus
ffffffffc0202d1a:	8b89                	andi	a5,a5,2
ffffffffc0202d1c:	eb89                	bnez	a5,ffffffffc0202d2e <pgdir_alloc_page+0x8a>
ffffffffc0202d1e:	0009b783          	ld	a5,0(s3)
ffffffffc0202d22:	8522                	mv	a0,s0
ffffffffc0202d24:	4585                	li	a1,1
ffffffffc0202d26:	739c                	ld	a5,32(a5)
ffffffffc0202d28:	4401                	li	s0,0
ffffffffc0202d2a:	9782                	jalr	a5
ffffffffc0202d2c:	b7c9                	j	ffffffffc0202cee <pgdir_alloc_page+0x4a>
ffffffffc0202d2e:	876fe0ef          	jal	ra,ffffffffc0200da4 <intr_disable>
ffffffffc0202d32:	0009b783          	ld	a5,0(s3)
ffffffffc0202d36:	8522                	mv	a0,s0
ffffffffc0202d38:	4585                	li	a1,1
ffffffffc0202d3a:	739c                	ld	a5,32(a5)
ffffffffc0202d3c:	4401                	li	s0,0
ffffffffc0202d3e:	9782                	jalr	a5
ffffffffc0202d40:	85efe0ef          	jal	ra,ffffffffc0200d9e <intr_enable>
ffffffffc0202d44:	b76d                	j	ffffffffc0202cee <pgdir_alloc_page+0x4a>
ffffffffc0202d46:	0000a697          	auipc	a3,0xa
ffffffffc0202d4a:	ad268693          	addi	a3,a3,-1326 # ffffffffc020c818 <commands+0x1070>
ffffffffc0202d4e:	00009617          	auipc	a2,0x9
ffffffffc0202d52:	aba60613          	addi	a2,a2,-1350 # ffffffffc020b808 <commands+0x60>
ffffffffc0202d56:	23000593          	li	a1,560
ffffffffc0202d5a:	00009517          	auipc	a0,0x9
ffffffffc0202d5e:	3de50513          	addi	a0,a0,990 # ffffffffc020c138 <commands+0x990>
ffffffffc0202d62:	cccfd0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0202d66 <check_vma_overlap.part.0>:
ffffffffc0202d66:	1141                	addi	sp,sp,-16
ffffffffc0202d68:	0000a697          	auipc	a3,0xa
ffffffffc0202d6c:	ac868693          	addi	a3,a3,-1336 # ffffffffc020c830 <commands+0x1088>
ffffffffc0202d70:	00009617          	auipc	a2,0x9
ffffffffc0202d74:	a9860613          	addi	a2,a2,-1384 # ffffffffc020b808 <commands+0x60>
ffffffffc0202d78:	07400593          	li	a1,116
ffffffffc0202d7c:	0000a517          	auipc	a0,0xa
ffffffffc0202d80:	ad450513          	addi	a0,a0,-1324 # ffffffffc020c850 <commands+0x10a8>
ffffffffc0202d84:	e406                	sd	ra,8(sp)
ffffffffc0202d86:	ca8fd0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0202d8a <mm_create>:
ffffffffc0202d8a:	1141                	addi	sp,sp,-16
ffffffffc0202d8c:	05800513          	li	a0,88
ffffffffc0202d90:	e022                	sd	s0,0(sp)
ffffffffc0202d92:	e406                	sd	ra,8(sp)
ffffffffc0202d94:	233000ef          	jal	ra,ffffffffc02037c6 <kmalloc>
ffffffffc0202d98:	842a                	mv	s0,a0
ffffffffc0202d9a:	c115                	beqz	a0,ffffffffc0202dbe <mm_create+0x34>
ffffffffc0202d9c:	e408                	sd	a0,8(s0)
ffffffffc0202d9e:	e008                	sd	a0,0(s0)
ffffffffc0202da0:	00053823          	sd	zero,16(a0)
ffffffffc0202da4:	00053c23          	sd	zero,24(a0)
ffffffffc0202da8:	02052023          	sw	zero,32(a0)
ffffffffc0202dac:	02053423          	sd	zero,40(a0)
ffffffffc0202db0:	02052823          	sw	zero,48(a0)
ffffffffc0202db4:	4585                	li	a1,1
ffffffffc0202db6:	03850513          	addi	a0,a0,56
ffffffffc0202dba:	189010ef          	jal	ra,ffffffffc0204742 <sem_init>
ffffffffc0202dbe:	60a2                	ld	ra,8(sp)
ffffffffc0202dc0:	8522                	mv	a0,s0
ffffffffc0202dc2:	6402                	ld	s0,0(sp)
ffffffffc0202dc4:	0141                	addi	sp,sp,16
ffffffffc0202dc6:	8082                	ret

ffffffffc0202dc8 <find_vma>:
ffffffffc0202dc8:	86aa                	mv	a3,a0
ffffffffc0202dca:	c505                	beqz	a0,ffffffffc0202df2 <find_vma+0x2a>
ffffffffc0202dcc:	6908                	ld	a0,16(a0)
ffffffffc0202dce:	c501                	beqz	a0,ffffffffc0202dd6 <find_vma+0xe>
ffffffffc0202dd0:	651c                	ld	a5,8(a0)
ffffffffc0202dd2:	02f5f263          	bgeu	a1,a5,ffffffffc0202df6 <find_vma+0x2e>
ffffffffc0202dd6:	669c                	ld	a5,8(a3)
ffffffffc0202dd8:	00f68d63          	beq	a3,a5,ffffffffc0202df2 <find_vma+0x2a>
ffffffffc0202ddc:	fe87b703          	ld	a4,-24(a5) # 1fffe8 <_binary_bin_sfs_img_size+0x18ace8>
ffffffffc0202de0:	00e5e663          	bltu	a1,a4,ffffffffc0202dec <find_vma+0x24>
ffffffffc0202de4:	ff07b703          	ld	a4,-16(a5)
ffffffffc0202de8:	00e5ec63          	bltu	a1,a4,ffffffffc0202e00 <find_vma+0x38>
ffffffffc0202dec:	679c                	ld	a5,8(a5)
ffffffffc0202dee:	fef697e3          	bne	a3,a5,ffffffffc0202ddc <find_vma+0x14>
ffffffffc0202df2:	4501                	li	a0,0
ffffffffc0202df4:	8082                	ret
ffffffffc0202df6:	691c                	ld	a5,16(a0)
ffffffffc0202df8:	fcf5ffe3          	bgeu	a1,a5,ffffffffc0202dd6 <find_vma+0xe>
ffffffffc0202dfc:	ea88                	sd	a0,16(a3)
ffffffffc0202dfe:	8082                	ret
ffffffffc0202e00:	fe078513          	addi	a0,a5,-32
ffffffffc0202e04:	ea88                	sd	a0,16(a3)
ffffffffc0202e06:	8082                	ret

ffffffffc0202e08 <insert_vma_struct>:
ffffffffc0202e08:	6590                	ld	a2,8(a1)
ffffffffc0202e0a:	0105b803          	ld	a6,16(a1) # 80010 <_binary_bin_sfs_img_size+0xad10>
ffffffffc0202e0e:	1141                	addi	sp,sp,-16
ffffffffc0202e10:	e406                	sd	ra,8(sp)
ffffffffc0202e12:	87aa                	mv	a5,a0
ffffffffc0202e14:	01066763          	bltu	a2,a6,ffffffffc0202e22 <insert_vma_struct+0x1a>
ffffffffc0202e18:	a085                	j	ffffffffc0202e78 <insert_vma_struct+0x70>
ffffffffc0202e1a:	fe87b703          	ld	a4,-24(a5)
ffffffffc0202e1e:	04e66863          	bltu	a2,a4,ffffffffc0202e6e <insert_vma_struct+0x66>
ffffffffc0202e22:	86be                	mv	a3,a5
ffffffffc0202e24:	679c                	ld	a5,8(a5)
ffffffffc0202e26:	fef51ae3          	bne	a0,a5,ffffffffc0202e1a <insert_vma_struct+0x12>
ffffffffc0202e2a:	02a68463          	beq	a3,a0,ffffffffc0202e52 <insert_vma_struct+0x4a>
ffffffffc0202e2e:	ff06b703          	ld	a4,-16(a3)
ffffffffc0202e32:	fe86b883          	ld	a7,-24(a3)
ffffffffc0202e36:	08e8f163          	bgeu	a7,a4,ffffffffc0202eb8 <insert_vma_struct+0xb0>
ffffffffc0202e3a:	04e66f63          	bltu	a2,a4,ffffffffc0202e98 <insert_vma_struct+0x90>
ffffffffc0202e3e:	00f50a63          	beq	a0,a5,ffffffffc0202e52 <insert_vma_struct+0x4a>
ffffffffc0202e42:	fe87b703          	ld	a4,-24(a5)
ffffffffc0202e46:	05076963          	bltu	a4,a6,ffffffffc0202e98 <insert_vma_struct+0x90>
ffffffffc0202e4a:	ff07b603          	ld	a2,-16(a5)
ffffffffc0202e4e:	02c77363          	bgeu	a4,a2,ffffffffc0202e74 <insert_vma_struct+0x6c>
ffffffffc0202e52:	5118                	lw	a4,32(a0)
ffffffffc0202e54:	e188                	sd	a0,0(a1)
ffffffffc0202e56:	02058613          	addi	a2,a1,32
ffffffffc0202e5a:	e390                	sd	a2,0(a5)
ffffffffc0202e5c:	e690                	sd	a2,8(a3)
ffffffffc0202e5e:	60a2                	ld	ra,8(sp)
ffffffffc0202e60:	f59c                	sd	a5,40(a1)
ffffffffc0202e62:	f194                	sd	a3,32(a1)
ffffffffc0202e64:	0017079b          	addiw	a5,a4,1
ffffffffc0202e68:	d11c                	sw	a5,32(a0)
ffffffffc0202e6a:	0141                	addi	sp,sp,16
ffffffffc0202e6c:	8082                	ret
ffffffffc0202e6e:	fca690e3          	bne	a3,a0,ffffffffc0202e2e <insert_vma_struct+0x26>
ffffffffc0202e72:	bfd1                	j	ffffffffc0202e46 <insert_vma_struct+0x3e>
ffffffffc0202e74:	ef3ff0ef          	jal	ra,ffffffffc0202d66 <check_vma_overlap.part.0>
ffffffffc0202e78:	0000a697          	auipc	a3,0xa
ffffffffc0202e7c:	9e868693          	addi	a3,a3,-1560 # ffffffffc020c860 <commands+0x10b8>
ffffffffc0202e80:	00009617          	auipc	a2,0x9
ffffffffc0202e84:	98860613          	addi	a2,a2,-1656 # ffffffffc020b808 <commands+0x60>
ffffffffc0202e88:	07a00593          	li	a1,122
ffffffffc0202e8c:	0000a517          	auipc	a0,0xa
ffffffffc0202e90:	9c450513          	addi	a0,a0,-1596 # ffffffffc020c850 <commands+0x10a8>
ffffffffc0202e94:	b9afd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202e98:	0000a697          	auipc	a3,0xa
ffffffffc0202e9c:	a0868693          	addi	a3,a3,-1528 # ffffffffc020c8a0 <commands+0x10f8>
ffffffffc0202ea0:	00009617          	auipc	a2,0x9
ffffffffc0202ea4:	96860613          	addi	a2,a2,-1688 # ffffffffc020b808 <commands+0x60>
ffffffffc0202ea8:	07300593          	li	a1,115
ffffffffc0202eac:	0000a517          	auipc	a0,0xa
ffffffffc0202eb0:	9a450513          	addi	a0,a0,-1628 # ffffffffc020c850 <commands+0x10a8>
ffffffffc0202eb4:	b7afd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0202eb8:	0000a697          	auipc	a3,0xa
ffffffffc0202ebc:	9c868693          	addi	a3,a3,-1592 # ffffffffc020c880 <commands+0x10d8>
ffffffffc0202ec0:	00009617          	auipc	a2,0x9
ffffffffc0202ec4:	94860613          	addi	a2,a2,-1720 # ffffffffc020b808 <commands+0x60>
ffffffffc0202ec8:	07200593          	li	a1,114
ffffffffc0202ecc:	0000a517          	auipc	a0,0xa
ffffffffc0202ed0:	98450513          	addi	a0,a0,-1660 # ffffffffc020c850 <commands+0x10a8>
ffffffffc0202ed4:	b5afd0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0202ed8 <mm_destroy>:
ffffffffc0202ed8:	591c                	lw	a5,48(a0)
ffffffffc0202eda:	1141                	addi	sp,sp,-16
ffffffffc0202edc:	e406                	sd	ra,8(sp)
ffffffffc0202ede:	e022                	sd	s0,0(sp)
ffffffffc0202ee0:	e78d                	bnez	a5,ffffffffc0202f0a <mm_destroy+0x32>
ffffffffc0202ee2:	842a                	mv	s0,a0
ffffffffc0202ee4:	6508                	ld	a0,8(a0)
ffffffffc0202ee6:	00a40c63          	beq	s0,a0,ffffffffc0202efe <mm_destroy+0x26>
ffffffffc0202eea:	6118                	ld	a4,0(a0)
ffffffffc0202eec:	651c                	ld	a5,8(a0)
ffffffffc0202eee:	1501                	addi	a0,a0,-32
ffffffffc0202ef0:	e71c                	sd	a5,8(a4)
ffffffffc0202ef2:	e398                	sd	a4,0(a5)
ffffffffc0202ef4:	183000ef          	jal	ra,ffffffffc0203876 <kfree>
ffffffffc0202ef8:	6408                	ld	a0,8(s0)
ffffffffc0202efa:	fea418e3          	bne	s0,a0,ffffffffc0202eea <mm_destroy+0x12>
ffffffffc0202efe:	8522                	mv	a0,s0
ffffffffc0202f00:	6402                	ld	s0,0(sp)
ffffffffc0202f02:	60a2                	ld	ra,8(sp)
ffffffffc0202f04:	0141                	addi	sp,sp,16
ffffffffc0202f06:	1710006f          	j	ffffffffc0203876 <kfree>
ffffffffc0202f0a:	0000a697          	auipc	a3,0xa
ffffffffc0202f0e:	9b668693          	addi	a3,a3,-1610 # ffffffffc020c8c0 <commands+0x1118>
ffffffffc0202f12:	00009617          	auipc	a2,0x9
ffffffffc0202f16:	8f660613          	addi	a2,a2,-1802 # ffffffffc020b808 <commands+0x60>
ffffffffc0202f1a:	09e00593          	li	a1,158
ffffffffc0202f1e:	0000a517          	auipc	a0,0xa
ffffffffc0202f22:	93250513          	addi	a0,a0,-1742 # ffffffffc020c850 <commands+0x10a8>
ffffffffc0202f26:	b08fd0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0202f2a <mm_map>:
ffffffffc0202f2a:	7139                	addi	sp,sp,-64
ffffffffc0202f2c:	f822                	sd	s0,48(sp)
ffffffffc0202f2e:	6405                	lui	s0,0x1
ffffffffc0202f30:	147d                	addi	s0,s0,-1
ffffffffc0202f32:	77fd                	lui	a5,0xfffff
ffffffffc0202f34:	9622                	add	a2,a2,s0
ffffffffc0202f36:	962e                	add	a2,a2,a1
ffffffffc0202f38:	f426                	sd	s1,40(sp)
ffffffffc0202f3a:	fc06                	sd	ra,56(sp)
ffffffffc0202f3c:	00f5f4b3          	and	s1,a1,a5
ffffffffc0202f40:	f04a                	sd	s2,32(sp)
ffffffffc0202f42:	ec4e                	sd	s3,24(sp)
ffffffffc0202f44:	e852                	sd	s4,16(sp)
ffffffffc0202f46:	e456                	sd	s5,8(sp)
ffffffffc0202f48:	002005b7          	lui	a1,0x200
ffffffffc0202f4c:	00f67433          	and	s0,a2,a5
ffffffffc0202f50:	06b4e363          	bltu	s1,a1,ffffffffc0202fb6 <mm_map+0x8c>
ffffffffc0202f54:	0684f163          	bgeu	s1,s0,ffffffffc0202fb6 <mm_map+0x8c>
ffffffffc0202f58:	4785                	li	a5,1
ffffffffc0202f5a:	07fe                	slli	a5,a5,0x1f
ffffffffc0202f5c:	0487ed63          	bltu	a5,s0,ffffffffc0202fb6 <mm_map+0x8c>
ffffffffc0202f60:	89aa                	mv	s3,a0
ffffffffc0202f62:	cd21                	beqz	a0,ffffffffc0202fba <mm_map+0x90>
ffffffffc0202f64:	85a6                	mv	a1,s1
ffffffffc0202f66:	8ab6                	mv	s5,a3
ffffffffc0202f68:	8a3a                	mv	s4,a4
ffffffffc0202f6a:	e5fff0ef          	jal	ra,ffffffffc0202dc8 <find_vma>
ffffffffc0202f6e:	c501                	beqz	a0,ffffffffc0202f76 <mm_map+0x4c>
ffffffffc0202f70:	651c                	ld	a5,8(a0)
ffffffffc0202f72:	0487e263          	bltu	a5,s0,ffffffffc0202fb6 <mm_map+0x8c>
ffffffffc0202f76:	03000513          	li	a0,48
ffffffffc0202f7a:	04d000ef          	jal	ra,ffffffffc02037c6 <kmalloc>
ffffffffc0202f7e:	892a                	mv	s2,a0
ffffffffc0202f80:	5571                	li	a0,-4
ffffffffc0202f82:	02090163          	beqz	s2,ffffffffc0202fa4 <mm_map+0x7a>
ffffffffc0202f86:	854e                	mv	a0,s3
ffffffffc0202f88:	00993423          	sd	s1,8(s2)
ffffffffc0202f8c:	00893823          	sd	s0,16(s2)
ffffffffc0202f90:	01592c23          	sw	s5,24(s2)
ffffffffc0202f94:	85ca                	mv	a1,s2
ffffffffc0202f96:	e73ff0ef          	jal	ra,ffffffffc0202e08 <insert_vma_struct>
ffffffffc0202f9a:	4501                	li	a0,0
ffffffffc0202f9c:	000a0463          	beqz	s4,ffffffffc0202fa4 <mm_map+0x7a>
ffffffffc0202fa0:	012a3023          	sd	s2,0(s4) # 1000 <_binary_bin_swap_img_size-0x6d00>
ffffffffc0202fa4:	70e2                	ld	ra,56(sp)
ffffffffc0202fa6:	7442                	ld	s0,48(sp)
ffffffffc0202fa8:	74a2                	ld	s1,40(sp)
ffffffffc0202faa:	7902                	ld	s2,32(sp)
ffffffffc0202fac:	69e2                	ld	s3,24(sp)
ffffffffc0202fae:	6a42                	ld	s4,16(sp)
ffffffffc0202fb0:	6aa2                	ld	s5,8(sp)
ffffffffc0202fb2:	6121                	addi	sp,sp,64
ffffffffc0202fb4:	8082                	ret
ffffffffc0202fb6:	5575                	li	a0,-3
ffffffffc0202fb8:	b7f5                	j	ffffffffc0202fa4 <mm_map+0x7a>
ffffffffc0202fba:	0000a697          	auipc	a3,0xa
ffffffffc0202fbe:	91e68693          	addi	a3,a3,-1762 # ffffffffc020c8d8 <commands+0x1130>
ffffffffc0202fc2:	00009617          	auipc	a2,0x9
ffffffffc0202fc6:	84660613          	addi	a2,a2,-1978 # ffffffffc020b808 <commands+0x60>
ffffffffc0202fca:	0b300593          	li	a1,179
ffffffffc0202fce:	0000a517          	auipc	a0,0xa
ffffffffc0202fd2:	88250513          	addi	a0,a0,-1918 # ffffffffc020c850 <commands+0x10a8>
ffffffffc0202fd6:	a58fd0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0202fda <dup_mmap>:
ffffffffc0202fda:	7139                	addi	sp,sp,-64
ffffffffc0202fdc:	fc06                	sd	ra,56(sp)
ffffffffc0202fde:	f822                	sd	s0,48(sp)
ffffffffc0202fe0:	f426                	sd	s1,40(sp)
ffffffffc0202fe2:	f04a                	sd	s2,32(sp)
ffffffffc0202fe4:	ec4e                	sd	s3,24(sp)
ffffffffc0202fe6:	e852                	sd	s4,16(sp)
ffffffffc0202fe8:	e456                	sd	s5,8(sp)
ffffffffc0202fea:	c52d                	beqz	a0,ffffffffc0203054 <dup_mmap+0x7a>
ffffffffc0202fec:	892a                	mv	s2,a0
ffffffffc0202fee:	84ae                	mv	s1,a1
ffffffffc0202ff0:	842e                	mv	s0,a1
ffffffffc0202ff2:	e595                	bnez	a1,ffffffffc020301e <dup_mmap+0x44>
ffffffffc0202ff4:	a085                	j	ffffffffc0203054 <dup_mmap+0x7a>
ffffffffc0202ff6:	854a                	mv	a0,s2
ffffffffc0202ff8:	0155b423          	sd	s5,8(a1) # 200008 <_binary_bin_sfs_img_size+0x18ad08>
ffffffffc0202ffc:	0145b823          	sd	s4,16(a1)
ffffffffc0203000:	0135ac23          	sw	s3,24(a1)
ffffffffc0203004:	e05ff0ef          	jal	ra,ffffffffc0202e08 <insert_vma_struct>
ffffffffc0203008:	ff043683          	ld	a3,-16(s0) # ff0 <_binary_bin_swap_img_size-0x6d10>
ffffffffc020300c:	fe843603          	ld	a2,-24(s0)
ffffffffc0203010:	6c8c                	ld	a1,24(s1)
ffffffffc0203012:	01893503          	ld	a0,24(s2)
ffffffffc0203016:	4701                	li	a4,0
ffffffffc0203018:	a2dff0ef          	jal	ra,ffffffffc0202a44 <copy_range>
ffffffffc020301c:	e105                	bnez	a0,ffffffffc020303c <dup_mmap+0x62>
ffffffffc020301e:	6000                	ld	s0,0(s0)
ffffffffc0203020:	02848863          	beq	s1,s0,ffffffffc0203050 <dup_mmap+0x76>
ffffffffc0203024:	03000513          	li	a0,48
ffffffffc0203028:	fe843a83          	ld	s5,-24(s0)
ffffffffc020302c:	ff043a03          	ld	s4,-16(s0)
ffffffffc0203030:	ff842983          	lw	s3,-8(s0)
ffffffffc0203034:	792000ef          	jal	ra,ffffffffc02037c6 <kmalloc>
ffffffffc0203038:	85aa                	mv	a1,a0
ffffffffc020303a:	fd55                	bnez	a0,ffffffffc0202ff6 <dup_mmap+0x1c>
ffffffffc020303c:	5571                	li	a0,-4
ffffffffc020303e:	70e2                	ld	ra,56(sp)
ffffffffc0203040:	7442                	ld	s0,48(sp)
ffffffffc0203042:	74a2                	ld	s1,40(sp)
ffffffffc0203044:	7902                	ld	s2,32(sp)
ffffffffc0203046:	69e2                	ld	s3,24(sp)
ffffffffc0203048:	6a42                	ld	s4,16(sp)
ffffffffc020304a:	6aa2                	ld	s5,8(sp)
ffffffffc020304c:	6121                	addi	sp,sp,64
ffffffffc020304e:	8082                	ret
ffffffffc0203050:	4501                	li	a0,0
ffffffffc0203052:	b7f5                	j	ffffffffc020303e <dup_mmap+0x64>
ffffffffc0203054:	0000a697          	auipc	a3,0xa
ffffffffc0203058:	89468693          	addi	a3,a3,-1900 # ffffffffc020c8e8 <commands+0x1140>
ffffffffc020305c:	00008617          	auipc	a2,0x8
ffffffffc0203060:	7ac60613          	addi	a2,a2,1964 # ffffffffc020b808 <commands+0x60>
ffffffffc0203064:	0cf00593          	li	a1,207
ffffffffc0203068:	00009517          	auipc	a0,0x9
ffffffffc020306c:	7e850513          	addi	a0,a0,2024 # ffffffffc020c850 <commands+0x10a8>
ffffffffc0203070:	9befd0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0203074 <exit_mmap>:
ffffffffc0203074:	1101                	addi	sp,sp,-32
ffffffffc0203076:	ec06                	sd	ra,24(sp)
ffffffffc0203078:	e822                	sd	s0,16(sp)
ffffffffc020307a:	e426                	sd	s1,8(sp)
ffffffffc020307c:	e04a                	sd	s2,0(sp)
ffffffffc020307e:	c531                	beqz	a0,ffffffffc02030ca <exit_mmap+0x56>
ffffffffc0203080:	591c                	lw	a5,48(a0)
ffffffffc0203082:	84aa                	mv	s1,a0
ffffffffc0203084:	e3b9                	bnez	a5,ffffffffc02030ca <exit_mmap+0x56>
ffffffffc0203086:	6500                	ld	s0,8(a0)
ffffffffc0203088:	01853903          	ld	s2,24(a0)
ffffffffc020308c:	02850663          	beq	a0,s0,ffffffffc02030b8 <exit_mmap+0x44>
ffffffffc0203090:	ff043603          	ld	a2,-16(s0)
ffffffffc0203094:	fe843583          	ld	a1,-24(s0)
ffffffffc0203098:	854a                	mv	a0,s2
ffffffffc020309a:	e4efe0ef          	jal	ra,ffffffffc02016e8 <unmap_range>
ffffffffc020309e:	6400                	ld	s0,8(s0)
ffffffffc02030a0:	fe8498e3          	bne	s1,s0,ffffffffc0203090 <exit_mmap+0x1c>
ffffffffc02030a4:	6400                	ld	s0,8(s0)
ffffffffc02030a6:	00848c63          	beq	s1,s0,ffffffffc02030be <exit_mmap+0x4a>
ffffffffc02030aa:	ff043603          	ld	a2,-16(s0)
ffffffffc02030ae:	fe843583          	ld	a1,-24(s0)
ffffffffc02030b2:	854a                	mv	a0,s2
ffffffffc02030b4:	f7afe0ef          	jal	ra,ffffffffc020182e <exit_range>
ffffffffc02030b8:	6400                	ld	s0,8(s0)
ffffffffc02030ba:	fe8498e3          	bne	s1,s0,ffffffffc02030aa <exit_mmap+0x36>
ffffffffc02030be:	60e2                	ld	ra,24(sp)
ffffffffc02030c0:	6442                	ld	s0,16(sp)
ffffffffc02030c2:	64a2                	ld	s1,8(sp)
ffffffffc02030c4:	6902                	ld	s2,0(sp)
ffffffffc02030c6:	6105                	addi	sp,sp,32
ffffffffc02030c8:	8082                	ret
ffffffffc02030ca:	0000a697          	auipc	a3,0xa
ffffffffc02030ce:	83e68693          	addi	a3,a3,-1986 # ffffffffc020c908 <commands+0x1160>
ffffffffc02030d2:	00008617          	auipc	a2,0x8
ffffffffc02030d6:	73660613          	addi	a2,a2,1846 # ffffffffc020b808 <commands+0x60>
ffffffffc02030da:	0e800593          	li	a1,232
ffffffffc02030de:	00009517          	auipc	a0,0x9
ffffffffc02030e2:	77250513          	addi	a0,a0,1906 # ffffffffc020c850 <commands+0x10a8>
ffffffffc02030e6:	948fd0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02030ea <vmm_init>:
ffffffffc02030ea:	7139                	addi	sp,sp,-64
ffffffffc02030ec:	05800513          	li	a0,88
ffffffffc02030f0:	fc06                	sd	ra,56(sp)
ffffffffc02030f2:	f822                	sd	s0,48(sp)
ffffffffc02030f4:	f426                	sd	s1,40(sp)
ffffffffc02030f6:	f04a                	sd	s2,32(sp)
ffffffffc02030f8:	ec4e                	sd	s3,24(sp)
ffffffffc02030fa:	e852                	sd	s4,16(sp)
ffffffffc02030fc:	e456                	sd	s5,8(sp)
ffffffffc02030fe:	6c8000ef          	jal	ra,ffffffffc02037c6 <kmalloc>
ffffffffc0203102:	2e050963          	beqz	a0,ffffffffc02033f4 <vmm_init+0x30a>
ffffffffc0203106:	e508                	sd	a0,8(a0)
ffffffffc0203108:	e108                	sd	a0,0(a0)
ffffffffc020310a:	00053823          	sd	zero,16(a0)
ffffffffc020310e:	00053c23          	sd	zero,24(a0)
ffffffffc0203112:	02052023          	sw	zero,32(a0)
ffffffffc0203116:	02053423          	sd	zero,40(a0)
ffffffffc020311a:	02052823          	sw	zero,48(a0)
ffffffffc020311e:	84aa                	mv	s1,a0
ffffffffc0203120:	4585                	li	a1,1
ffffffffc0203122:	03850513          	addi	a0,a0,56
ffffffffc0203126:	61c010ef          	jal	ra,ffffffffc0204742 <sem_init>
ffffffffc020312a:	03200413          	li	s0,50
ffffffffc020312e:	a811                	j	ffffffffc0203142 <vmm_init+0x58>
ffffffffc0203130:	e500                	sd	s0,8(a0)
ffffffffc0203132:	e91c                	sd	a5,16(a0)
ffffffffc0203134:	00052c23          	sw	zero,24(a0)
ffffffffc0203138:	146d                	addi	s0,s0,-5
ffffffffc020313a:	8526                	mv	a0,s1
ffffffffc020313c:	ccdff0ef          	jal	ra,ffffffffc0202e08 <insert_vma_struct>
ffffffffc0203140:	c80d                	beqz	s0,ffffffffc0203172 <vmm_init+0x88>
ffffffffc0203142:	03000513          	li	a0,48
ffffffffc0203146:	680000ef          	jal	ra,ffffffffc02037c6 <kmalloc>
ffffffffc020314a:	85aa                	mv	a1,a0
ffffffffc020314c:	00240793          	addi	a5,s0,2
ffffffffc0203150:	f165                	bnez	a0,ffffffffc0203130 <vmm_init+0x46>
ffffffffc0203152:	0000a697          	auipc	a3,0xa
ffffffffc0203156:	94e68693          	addi	a3,a3,-1714 # ffffffffc020caa0 <commands+0x12f8>
ffffffffc020315a:	00008617          	auipc	a2,0x8
ffffffffc020315e:	6ae60613          	addi	a2,a2,1710 # ffffffffc020b808 <commands+0x60>
ffffffffc0203162:	12c00593          	li	a1,300
ffffffffc0203166:	00009517          	auipc	a0,0x9
ffffffffc020316a:	6ea50513          	addi	a0,a0,1770 # ffffffffc020c850 <commands+0x10a8>
ffffffffc020316e:	8c0fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203172:	03700413          	li	s0,55
ffffffffc0203176:	1f900913          	li	s2,505
ffffffffc020317a:	a819                	j	ffffffffc0203190 <vmm_init+0xa6>
ffffffffc020317c:	e500                	sd	s0,8(a0)
ffffffffc020317e:	e91c                	sd	a5,16(a0)
ffffffffc0203180:	00052c23          	sw	zero,24(a0)
ffffffffc0203184:	0415                	addi	s0,s0,5
ffffffffc0203186:	8526                	mv	a0,s1
ffffffffc0203188:	c81ff0ef          	jal	ra,ffffffffc0202e08 <insert_vma_struct>
ffffffffc020318c:	03240a63          	beq	s0,s2,ffffffffc02031c0 <vmm_init+0xd6>
ffffffffc0203190:	03000513          	li	a0,48
ffffffffc0203194:	632000ef          	jal	ra,ffffffffc02037c6 <kmalloc>
ffffffffc0203198:	85aa                	mv	a1,a0
ffffffffc020319a:	00240793          	addi	a5,s0,2
ffffffffc020319e:	fd79                	bnez	a0,ffffffffc020317c <vmm_init+0x92>
ffffffffc02031a0:	0000a697          	auipc	a3,0xa
ffffffffc02031a4:	90068693          	addi	a3,a3,-1792 # ffffffffc020caa0 <commands+0x12f8>
ffffffffc02031a8:	00008617          	auipc	a2,0x8
ffffffffc02031ac:	66060613          	addi	a2,a2,1632 # ffffffffc020b808 <commands+0x60>
ffffffffc02031b0:	13300593          	li	a1,307
ffffffffc02031b4:	00009517          	auipc	a0,0x9
ffffffffc02031b8:	69c50513          	addi	a0,a0,1692 # ffffffffc020c850 <commands+0x10a8>
ffffffffc02031bc:	872fd0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02031c0:	649c                	ld	a5,8(s1)
ffffffffc02031c2:	471d                	li	a4,7
ffffffffc02031c4:	1fb00593          	li	a1,507
ffffffffc02031c8:	16f48663          	beq	s1,a5,ffffffffc0203334 <vmm_init+0x24a>
ffffffffc02031cc:	fe87b603          	ld	a2,-24(a5) # ffffffffffffefe8 <end+0x3fd686d8>
ffffffffc02031d0:	ffe70693          	addi	a3,a4,-2
ffffffffc02031d4:	10d61063          	bne	a2,a3,ffffffffc02032d4 <vmm_init+0x1ea>
ffffffffc02031d8:	ff07b683          	ld	a3,-16(a5)
ffffffffc02031dc:	0ed71c63          	bne	a4,a3,ffffffffc02032d4 <vmm_init+0x1ea>
ffffffffc02031e0:	0715                	addi	a4,a4,5
ffffffffc02031e2:	679c                	ld	a5,8(a5)
ffffffffc02031e4:	feb712e3          	bne	a4,a1,ffffffffc02031c8 <vmm_init+0xde>
ffffffffc02031e8:	4a1d                	li	s4,7
ffffffffc02031ea:	4415                	li	s0,5
ffffffffc02031ec:	1f900a93          	li	s5,505
ffffffffc02031f0:	85a2                	mv	a1,s0
ffffffffc02031f2:	8526                	mv	a0,s1
ffffffffc02031f4:	bd5ff0ef          	jal	ra,ffffffffc0202dc8 <find_vma>
ffffffffc02031f8:	892a                	mv	s2,a0
ffffffffc02031fa:	16050d63          	beqz	a0,ffffffffc0203374 <vmm_init+0x28a>
ffffffffc02031fe:	00140593          	addi	a1,s0,1
ffffffffc0203202:	8526                	mv	a0,s1
ffffffffc0203204:	bc5ff0ef          	jal	ra,ffffffffc0202dc8 <find_vma>
ffffffffc0203208:	89aa                	mv	s3,a0
ffffffffc020320a:	14050563          	beqz	a0,ffffffffc0203354 <vmm_init+0x26a>
ffffffffc020320e:	85d2                	mv	a1,s4
ffffffffc0203210:	8526                	mv	a0,s1
ffffffffc0203212:	bb7ff0ef          	jal	ra,ffffffffc0202dc8 <find_vma>
ffffffffc0203216:	16051f63          	bnez	a0,ffffffffc0203394 <vmm_init+0x2aa>
ffffffffc020321a:	00340593          	addi	a1,s0,3
ffffffffc020321e:	8526                	mv	a0,s1
ffffffffc0203220:	ba9ff0ef          	jal	ra,ffffffffc0202dc8 <find_vma>
ffffffffc0203224:	1a051863          	bnez	a0,ffffffffc02033d4 <vmm_init+0x2ea>
ffffffffc0203228:	00440593          	addi	a1,s0,4
ffffffffc020322c:	8526                	mv	a0,s1
ffffffffc020322e:	b9bff0ef          	jal	ra,ffffffffc0202dc8 <find_vma>
ffffffffc0203232:	18051163          	bnez	a0,ffffffffc02033b4 <vmm_init+0x2ca>
ffffffffc0203236:	00893783          	ld	a5,8(s2)
ffffffffc020323a:	0a879d63          	bne	a5,s0,ffffffffc02032f4 <vmm_init+0x20a>
ffffffffc020323e:	01093783          	ld	a5,16(s2)
ffffffffc0203242:	0b479963          	bne	a5,s4,ffffffffc02032f4 <vmm_init+0x20a>
ffffffffc0203246:	0089b783          	ld	a5,8(s3)
ffffffffc020324a:	0c879563          	bne	a5,s0,ffffffffc0203314 <vmm_init+0x22a>
ffffffffc020324e:	0109b783          	ld	a5,16(s3)
ffffffffc0203252:	0d479163          	bne	a5,s4,ffffffffc0203314 <vmm_init+0x22a>
ffffffffc0203256:	0415                	addi	s0,s0,5
ffffffffc0203258:	0a15                	addi	s4,s4,5
ffffffffc020325a:	f9541be3          	bne	s0,s5,ffffffffc02031f0 <vmm_init+0x106>
ffffffffc020325e:	4411                	li	s0,4
ffffffffc0203260:	597d                	li	s2,-1
ffffffffc0203262:	85a2                	mv	a1,s0
ffffffffc0203264:	8526                	mv	a0,s1
ffffffffc0203266:	b63ff0ef          	jal	ra,ffffffffc0202dc8 <find_vma>
ffffffffc020326a:	0004059b          	sext.w	a1,s0
ffffffffc020326e:	c90d                	beqz	a0,ffffffffc02032a0 <vmm_init+0x1b6>
ffffffffc0203270:	6914                	ld	a3,16(a0)
ffffffffc0203272:	6510                	ld	a2,8(a0)
ffffffffc0203274:	00009517          	auipc	a0,0x9
ffffffffc0203278:	7b450513          	addi	a0,a0,1972 # ffffffffc020ca28 <commands+0x1280>
ffffffffc020327c:	eaffc0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0203280:	00009697          	auipc	a3,0x9
ffffffffc0203284:	7d068693          	addi	a3,a3,2000 # ffffffffc020ca50 <commands+0x12a8>
ffffffffc0203288:	00008617          	auipc	a2,0x8
ffffffffc020328c:	58060613          	addi	a2,a2,1408 # ffffffffc020b808 <commands+0x60>
ffffffffc0203290:	15900593          	li	a1,345
ffffffffc0203294:	00009517          	auipc	a0,0x9
ffffffffc0203298:	5bc50513          	addi	a0,a0,1468 # ffffffffc020c850 <commands+0x10a8>
ffffffffc020329c:	f93fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02032a0:	147d                	addi	s0,s0,-1
ffffffffc02032a2:	fd2410e3          	bne	s0,s2,ffffffffc0203262 <vmm_init+0x178>
ffffffffc02032a6:	8526                	mv	a0,s1
ffffffffc02032a8:	c31ff0ef          	jal	ra,ffffffffc0202ed8 <mm_destroy>
ffffffffc02032ac:	00009517          	auipc	a0,0x9
ffffffffc02032b0:	7bc50513          	addi	a0,a0,1980 # ffffffffc020ca68 <commands+0x12c0>
ffffffffc02032b4:	e77fc0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02032b8:	7442                	ld	s0,48(sp)
ffffffffc02032ba:	70e2                	ld	ra,56(sp)
ffffffffc02032bc:	74a2                	ld	s1,40(sp)
ffffffffc02032be:	7902                	ld	s2,32(sp)
ffffffffc02032c0:	69e2                	ld	s3,24(sp)
ffffffffc02032c2:	6a42                	ld	s4,16(sp)
ffffffffc02032c4:	6aa2                	ld	s5,8(sp)
ffffffffc02032c6:	00009517          	auipc	a0,0x9
ffffffffc02032ca:	7c250513          	addi	a0,a0,1986 # ffffffffc020ca88 <commands+0x12e0>
ffffffffc02032ce:	6121                	addi	sp,sp,64
ffffffffc02032d0:	e5bfc06f          	j	ffffffffc020012a <cprintf>
ffffffffc02032d4:	00009697          	auipc	a3,0x9
ffffffffc02032d8:	66c68693          	addi	a3,a3,1644 # ffffffffc020c940 <commands+0x1198>
ffffffffc02032dc:	00008617          	auipc	a2,0x8
ffffffffc02032e0:	52c60613          	addi	a2,a2,1324 # ffffffffc020b808 <commands+0x60>
ffffffffc02032e4:	13d00593          	li	a1,317
ffffffffc02032e8:	00009517          	auipc	a0,0x9
ffffffffc02032ec:	56850513          	addi	a0,a0,1384 # ffffffffc020c850 <commands+0x10a8>
ffffffffc02032f0:	f3ffc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02032f4:	00009697          	auipc	a3,0x9
ffffffffc02032f8:	6d468693          	addi	a3,a3,1748 # ffffffffc020c9c8 <commands+0x1220>
ffffffffc02032fc:	00008617          	auipc	a2,0x8
ffffffffc0203300:	50c60613          	addi	a2,a2,1292 # ffffffffc020b808 <commands+0x60>
ffffffffc0203304:	14e00593          	li	a1,334
ffffffffc0203308:	00009517          	auipc	a0,0x9
ffffffffc020330c:	54850513          	addi	a0,a0,1352 # ffffffffc020c850 <commands+0x10a8>
ffffffffc0203310:	f1ffc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203314:	00009697          	auipc	a3,0x9
ffffffffc0203318:	6e468693          	addi	a3,a3,1764 # ffffffffc020c9f8 <commands+0x1250>
ffffffffc020331c:	00008617          	auipc	a2,0x8
ffffffffc0203320:	4ec60613          	addi	a2,a2,1260 # ffffffffc020b808 <commands+0x60>
ffffffffc0203324:	14f00593          	li	a1,335
ffffffffc0203328:	00009517          	auipc	a0,0x9
ffffffffc020332c:	52850513          	addi	a0,a0,1320 # ffffffffc020c850 <commands+0x10a8>
ffffffffc0203330:	efffc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203334:	00009697          	auipc	a3,0x9
ffffffffc0203338:	5f468693          	addi	a3,a3,1524 # ffffffffc020c928 <commands+0x1180>
ffffffffc020333c:	00008617          	auipc	a2,0x8
ffffffffc0203340:	4cc60613          	addi	a2,a2,1228 # ffffffffc020b808 <commands+0x60>
ffffffffc0203344:	13b00593          	li	a1,315
ffffffffc0203348:	00009517          	auipc	a0,0x9
ffffffffc020334c:	50850513          	addi	a0,a0,1288 # ffffffffc020c850 <commands+0x10a8>
ffffffffc0203350:	edffc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203354:	00009697          	auipc	a3,0x9
ffffffffc0203358:	63468693          	addi	a3,a3,1588 # ffffffffc020c988 <commands+0x11e0>
ffffffffc020335c:	00008617          	auipc	a2,0x8
ffffffffc0203360:	4ac60613          	addi	a2,a2,1196 # ffffffffc020b808 <commands+0x60>
ffffffffc0203364:	14600593          	li	a1,326
ffffffffc0203368:	00009517          	auipc	a0,0x9
ffffffffc020336c:	4e850513          	addi	a0,a0,1256 # ffffffffc020c850 <commands+0x10a8>
ffffffffc0203370:	ebffc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203374:	00009697          	auipc	a3,0x9
ffffffffc0203378:	60468693          	addi	a3,a3,1540 # ffffffffc020c978 <commands+0x11d0>
ffffffffc020337c:	00008617          	auipc	a2,0x8
ffffffffc0203380:	48c60613          	addi	a2,a2,1164 # ffffffffc020b808 <commands+0x60>
ffffffffc0203384:	14400593          	li	a1,324
ffffffffc0203388:	00009517          	auipc	a0,0x9
ffffffffc020338c:	4c850513          	addi	a0,a0,1224 # ffffffffc020c850 <commands+0x10a8>
ffffffffc0203390:	e9ffc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203394:	00009697          	auipc	a3,0x9
ffffffffc0203398:	60468693          	addi	a3,a3,1540 # ffffffffc020c998 <commands+0x11f0>
ffffffffc020339c:	00008617          	auipc	a2,0x8
ffffffffc02033a0:	46c60613          	addi	a2,a2,1132 # ffffffffc020b808 <commands+0x60>
ffffffffc02033a4:	14800593          	li	a1,328
ffffffffc02033a8:	00009517          	auipc	a0,0x9
ffffffffc02033ac:	4a850513          	addi	a0,a0,1192 # ffffffffc020c850 <commands+0x10a8>
ffffffffc02033b0:	e7ffc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02033b4:	00009697          	auipc	a3,0x9
ffffffffc02033b8:	60468693          	addi	a3,a3,1540 # ffffffffc020c9b8 <commands+0x1210>
ffffffffc02033bc:	00008617          	auipc	a2,0x8
ffffffffc02033c0:	44c60613          	addi	a2,a2,1100 # ffffffffc020b808 <commands+0x60>
ffffffffc02033c4:	14c00593          	li	a1,332
ffffffffc02033c8:	00009517          	auipc	a0,0x9
ffffffffc02033cc:	48850513          	addi	a0,a0,1160 # ffffffffc020c850 <commands+0x10a8>
ffffffffc02033d0:	e5ffc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02033d4:	00009697          	auipc	a3,0x9
ffffffffc02033d8:	5d468693          	addi	a3,a3,1492 # ffffffffc020c9a8 <commands+0x1200>
ffffffffc02033dc:	00008617          	auipc	a2,0x8
ffffffffc02033e0:	42c60613          	addi	a2,a2,1068 # ffffffffc020b808 <commands+0x60>
ffffffffc02033e4:	14a00593          	li	a1,330
ffffffffc02033e8:	00009517          	auipc	a0,0x9
ffffffffc02033ec:	46850513          	addi	a0,a0,1128 # ffffffffc020c850 <commands+0x10a8>
ffffffffc02033f0:	e3ffc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02033f4:	00009697          	auipc	a3,0x9
ffffffffc02033f8:	4e468693          	addi	a3,a3,1252 # ffffffffc020c8d8 <commands+0x1130>
ffffffffc02033fc:	00008617          	auipc	a2,0x8
ffffffffc0203400:	40c60613          	addi	a2,a2,1036 # ffffffffc020b808 <commands+0x60>
ffffffffc0203404:	12400593          	li	a1,292
ffffffffc0203408:	00009517          	auipc	a0,0x9
ffffffffc020340c:	44850513          	addi	a0,a0,1096 # ffffffffc020c850 <commands+0x10a8>
ffffffffc0203410:	e1ffc0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0203414 <user_mem_check>:
ffffffffc0203414:	7179                	addi	sp,sp,-48
ffffffffc0203416:	f022                	sd	s0,32(sp)
ffffffffc0203418:	f406                	sd	ra,40(sp)
ffffffffc020341a:	ec26                	sd	s1,24(sp)
ffffffffc020341c:	e84a                	sd	s2,16(sp)
ffffffffc020341e:	e44e                	sd	s3,8(sp)
ffffffffc0203420:	e052                	sd	s4,0(sp)
ffffffffc0203422:	842e                	mv	s0,a1
ffffffffc0203424:	c135                	beqz	a0,ffffffffc0203488 <user_mem_check+0x74>
ffffffffc0203426:	002007b7          	lui	a5,0x200
ffffffffc020342a:	04f5e663          	bltu	a1,a5,ffffffffc0203476 <user_mem_check+0x62>
ffffffffc020342e:	00c584b3          	add	s1,a1,a2
ffffffffc0203432:	0495f263          	bgeu	a1,s1,ffffffffc0203476 <user_mem_check+0x62>
ffffffffc0203436:	4785                	li	a5,1
ffffffffc0203438:	07fe                	slli	a5,a5,0x1f
ffffffffc020343a:	0297ee63          	bltu	a5,s1,ffffffffc0203476 <user_mem_check+0x62>
ffffffffc020343e:	892a                	mv	s2,a0
ffffffffc0203440:	89b6                	mv	s3,a3
ffffffffc0203442:	6a05                	lui	s4,0x1
ffffffffc0203444:	a821                	j	ffffffffc020345c <user_mem_check+0x48>
ffffffffc0203446:	0027f693          	andi	a3,a5,2
ffffffffc020344a:	9752                	add	a4,a4,s4
ffffffffc020344c:	8ba1                	andi	a5,a5,8
ffffffffc020344e:	c685                	beqz	a3,ffffffffc0203476 <user_mem_check+0x62>
ffffffffc0203450:	c399                	beqz	a5,ffffffffc0203456 <user_mem_check+0x42>
ffffffffc0203452:	02e46263          	bltu	s0,a4,ffffffffc0203476 <user_mem_check+0x62>
ffffffffc0203456:	6900                	ld	s0,16(a0)
ffffffffc0203458:	04947663          	bgeu	s0,s1,ffffffffc02034a4 <user_mem_check+0x90>
ffffffffc020345c:	85a2                	mv	a1,s0
ffffffffc020345e:	854a                	mv	a0,s2
ffffffffc0203460:	969ff0ef          	jal	ra,ffffffffc0202dc8 <find_vma>
ffffffffc0203464:	c909                	beqz	a0,ffffffffc0203476 <user_mem_check+0x62>
ffffffffc0203466:	6518                	ld	a4,8(a0)
ffffffffc0203468:	00e46763          	bltu	s0,a4,ffffffffc0203476 <user_mem_check+0x62>
ffffffffc020346c:	4d1c                	lw	a5,24(a0)
ffffffffc020346e:	fc099ce3          	bnez	s3,ffffffffc0203446 <user_mem_check+0x32>
ffffffffc0203472:	8b85                	andi	a5,a5,1
ffffffffc0203474:	f3ed                	bnez	a5,ffffffffc0203456 <user_mem_check+0x42>
ffffffffc0203476:	4501                	li	a0,0
ffffffffc0203478:	70a2                	ld	ra,40(sp)
ffffffffc020347a:	7402                	ld	s0,32(sp)
ffffffffc020347c:	64e2                	ld	s1,24(sp)
ffffffffc020347e:	6942                	ld	s2,16(sp)
ffffffffc0203480:	69a2                	ld	s3,8(sp)
ffffffffc0203482:	6a02                	ld	s4,0(sp)
ffffffffc0203484:	6145                	addi	sp,sp,48
ffffffffc0203486:	8082                	ret
ffffffffc0203488:	c02007b7          	lui	a5,0xc0200
ffffffffc020348c:	4501                	li	a0,0
ffffffffc020348e:	fef5e5e3          	bltu	a1,a5,ffffffffc0203478 <user_mem_check+0x64>
ffffffffc0203492:	962e                	add	a2,a2,a1
ffffffffc0203494:	fec5f2e3          	bgeu	a1,a2,ffffffffc0203478 <user_mem_check+0x64>
ffffffffc0203498:	c8000537          	lui	a0,0xc8000
ffffffffc020349c:	0505                	addi	a0,a0,1
ffffffffc020349e:	00a63533          	sltu	a0,a2,a0
ffffffffc02034a2:	bfd9                	j	ffffffffc0203478 <user_mem_check+0x64>
ffffffffc02034a4:	4505                	li	a0,1
ffffffffc02034a6:	bfc9                	j	ffffffffc0203478 <user_mem_check+0x64>

ffffffffc02034a8 <copy_from_user>:
ffffffffc02034a8:	1101                	addi	sp,sp,-32
ffffffffc02034aa:	e822                	sd	s0,16(sp)
ffffffffc02034ac:	e426                	sd	s1,8(sp)
ffffffffc02034ae:	8432                	mv	s0,a2
ffffffffc02034b0:	84b6                	mv	s1,a3
ffffffffc02034b2:	e04a                	sd	s2,0(sp)
ffffffffc02034b4:	86ba                	mv	a3,a4
ffffffffc02034b6:	892e                	mv	s2,a1
ffffffffc02034b8:	8626                	mv	a2,s1
ffffffffc02034ba:	85a2                	mv	a1,s0
ffffffffc02034bc:	ec06                	sd	ra,24(sp)
ffffffffc02034be:	f57ff0ef          	jal	ra,ffffffffc0203414 <user_mem_check>
ffffffffc02034c2:	c519                	beqz	a0,ffffffffc02034d0 <copy_from_user+0x28>
ffffffffc02034c4:	8626                	mv	a2,s1
ffffffffc02034c6:	85a2                	mv	a1,s0
ffffffffc02034c8:	854a                	mv	a0,s2
ffffffffc02034ca:	387070ef          	jal	ra,ffffffffc020b050 <memcpy>
ffffffffc02034ce:	4505                	li	a0,1
ffffffffc02034d0:	60e2                	ld	ra,24(sp)
ffffffffc02034d2:	6442                	ld	s0,16(sp)
ffffffffc02034d4:	64a2                	ld	s1,8(sp)
ffffffffc02034d6:	6902                	ld	s2,0(sp)
ffffffffc02034d8:	6105                	addi	sp,sp,32
ffffffffc02034da:	8082                	ret

ffffffffc02034dc <copy_to_user>:
ffffffffc02034dc:	1101                	addi	sp,sp,-32
ffffffffc02034de:	e822                	sd	s0,16(sp)
ffffffffc02034e0:	8436                	mv	s0,a3
ffffffffc02034e2:	e04a                	sd	s2,0(sp)
ffffffffc02034e4:	4685                	li	a3,1
ffffffffc02034e6:	8932                	mv	s2,a2
ffffffffc02034e8:	8622                	mv	a2,s0
ffffffffc02034ea:	e426                	sd	s1,8(sp)
ffffffffc02034ec:	ec06                	sd	ra,24(sp)
ffffffffc02034ee:	84ae                	mv	s1,a1
ffffffffc02034f0:	f25ff0ef          	jal	ra,ffffffffc0203414 <user_mem_check>
ffffffffc02034f4:	c519                	beqz	a0,ffffffffc0203502 <copy_to_user+0x26>
ffffffffc02034f6:	8622                	mv	a2,s0
ffffffffc02034f8:	85ca                	mv	a1,s2
ffffffffc02034fa:	8526                	mv	a0,s1
ffffffffc02034fc:	355070ef          	jal	ra,ffffffffc020b050 <memcpy>
ffffffffc0203500:	4505                	li	a0,1
ffffffffc0203502:	60e2                	ld	ra,24(sp)
ffffffffc0203504:	6442                	ld	s0,16(sp)
ffffffffc0203506:	64a2                	ld	s1,8(sp)
ffffffffc0203508:	6902                	ld	s2,0(sp)
ffffffffc020350a:	6105                	addi	sp,sp,32
ffffffffc020350c:	8082                	ret

ffffffffc020350e <copy_string>:
ffffffffc020350e:	7139                	addi	sp,sp,-64
ffffffffc0203510:	ec4e                	sd	s3,24(sp)
ffffffffc0203512:	6985                	lui	s3,0x1
ffffffffc0203514:	99b2                	add	s3,s3,a2
ffffffffc0203516:	77fd                	lui	a5,0xfffff
ffffffffc0203518:	00f9f9b3          	and	s3,s3,a5
ffffffffc020351c:	f426                	sd	s1,40(sp)
ffffffffc020351e:	f04a                	sd	s2,32(sp)
ffffffffc0203520:	e852                	sd	s4,16(sp)
ffffffffc0203522:	e456                	sd	s5,8(sp)
ffffffffc0203524:	fc06                	sd	ra,56(sp)
ffffffffc0203526:	f822                	sd	s0,48(sp)
ffffffffc0203528:	84b2                	mv	s1,a2
ffffffffc020352a:	8aaa                	mv	s5,a0
ffffffffc020352c:	8a2e                	mv	s4,a1
ffffffffc020352e:	8936                	mv	s2,a3
ffffffffc0203530:	40c989b3          	sub	s3,s3,a2
ffffffffc0203534:	a015                	j	ffffffffc0203558 <copy_string+0x4a>
ffffffffc0203536:	241070ef          	jal	ra,ffffffffc020af76 <strnlen>
ffffffffc020353a:	87aa                	mv	a5,a0
ffffffffc020353c:	85a6                	mv	a1,s1
ffffffffc020353e:	8552                	mv	a0,s4
ffffffffc0203540:	8622                	mv	a2,s0
ffffffffc0203542:	0487e363          	bltu	a5,s0,ffffffffc0203588 <copy_string+0x7a>
ffffffffc0203546:	0329f763          	bgeu	s3,s2,ffffffffc0203574 <copy_string+0x66>
ffffffffc020354a:	307070ef          	jal	ra,ffffffffc020b050 <memcpy>
ffffffffc020354e:	9a22                	add	s4,s4,s0
ffffffffc0203550:	94a2                	add	s1,s1,s0
ffffffffc0203552:	40890933          	sub	s2,s2,s0
ffffffffc0203556:	6985                	lui	s3,0x1
ffffffffc0203558:	4681                	li	a3,0
ffffffffc020355a:	85a6                	mv	a1,s1
ffffffffc020355c:	8556                	mv	a0,s5
ffffffffc020355e:	844a                	mv	s0,s2
ffffffffc0203560:	0129f363          	bgeu	s3,s2,ffffffffc0203566 <copy_string+0x58>
ffffffffc0203564:	844e                	mv	s0,s3
ffffffffc0203566:	8622                	mv	a2,s0
ffffffffc0203568:	eadff0ef          	jal	ra,ffffffffc0203414 <user_mem_check>
ffffffffc020356c:	87aa                	mv	a5,a0
ffffffffc020356e:	85a2                	mv	a1,s0
ffffffffc0203570:	8526                	mv	a0,s1
ffffffffc0203572:	f3f1                	bnez	a5,ffffffffc0203536 <copy_string+0x28>
ffffffffc0203574:	4501                	li	a0,0
ffffffffc0203576:	70e2                	ld	ra,56(sp)
ffffffffc0203578:	7442                	ld	s0,48(sp)
ffffffffc020357a:	74a2                	ld	s1,40(sp)
ffffffffc020357c:	7902                	ld	s2,32(sp)
ffffffffc020357e:	69e2                	ld	s3,24(sp)
ffffffffc0203580:	6a42                	ld	s4,16(sp)
ffffffffc0203582:	6aa2                	ld	s5,8(sp)
ffffffffc0203584:	6121                	addi	sp,sp,64
ffffffffc0203586:	8082                	ret
ffffffffc0203588:	00178613          	addi	a2,a5,1 # fffffffffffff001 <end+0x3fd686f1>
ffffffffc020358c:	2c5070ef          	jal	ra,ffffffffc020b050 <memcpy>
ffffffffc0203590:	4505                	li	a0,1
ffffffffc0203592:	b7d5                	j	ffffffffc0203576 <copy_string+0x68>

ffffffffc0203594 <slob_free>:
ffffffffc0203594:	c94d                	beqz	a0,ffffffffc0203646 <slob_free+0xb2>
ffffffffc0203596:	1141                	addi	sp,sp,-16
ffffffffc0203598:	e022                	sd	s0,0(sp)
ffffffffc020359a:	e406                	sd	ra,8(sp)
ffffffffc020359c:	842a                	mv	s0,a0
ffffffffc020359e:	e9c1                	bnez	a1,ffffffffc020362e <slob_free+0x9a>
ffffffffc02035a0:	100027f3          	csrr	a5,sstatus
ffffffffc02035a4:	8b89                	andi	a5,a5,2
ffffffffc02035a6:	4501                	li	a0,0
ffffffffc02035a8:	ebd9                	bnez	a5,ffffffffc020363e <slob_free+0xaa>
ffffffffc02035aa:	0008e617          	auipc	a2,0x8e
ffffffffc02035ae:	aa660613          	addi	a2,a2,-1370 # ffffffffc0291050 <slobfree>
ffffffffc02035b2:	621c                	ld	a5,0(a2)
ffffffffc02035b4:	873e                	mv	a4,a5
ffffffffc02035b6:	679c                	ld	a5,8(a5)
ffffffffc02035b8:	02877a63          	bgeu	a4,s0,ffffffffc02035ec <slob_free+0x58>
ffffffffc02035bc:	00f46463          	bltu	s0,a5,ffffffffc02035c4 <slob_free+0x30>
ffffffffc02035c0:	fef76ae3          	bltu	a4,a5,ffffffffc02035b4 <slob_free+0x20>
ffffffffc02035c4:	400c                	lw	a1,0(s0)
ffffffffc02035c6:	00459693          	slli	a3,a1,0x4
ffffffffc02035ca:	96a2                	add	a3,a3,s0
ffffffffc02035cc:	02d78a63          	beq	a5,a3,ffffffffc0203600 <slob_free+0x6c>
ffffffffc02035d0:	4314                	lw	a3,0(a4)
ffffffffc02035d2:	e41c                	sd	a5,8(s0)
ffffffffc02035d4:	00469793          	slli	a5,a3,0x4
ffffffffc02035d8:	97ba                	add	a5,a5,a4
ffffffffc02035da:	02f40e63          	beq	s0,a5,ffffffffc0203616 <slob_free+0x82>
ffffffffc02035de:	e700                	sd	s0,8(a4)
ffffffffc02035e0:	e218                	sd	a4,0(a2)
ffffffffc02035e2:	e129                	bnez	a0,ffffffffc0203624 <slob_free+0x90>
ffffffffc02035e4:	60a2                	ld	ra,8(sp)
ffffffffc02035e6:	6402                	ld	s0,0(sp)
ffffffffc02035e8:	0141                	addi	sp,sp,16
ffffffffc02035ea:	8082                	ret
ffffffffc02035ec:	fcf764e3          	bltu	a4,a5,ffffffffc02035b4 <slob_free+0x20>
ffffffffc02035f0:	fcf472e3          	bgeu	s0,a5,ffffffffc02035b4 <slob_free+0x20>
ffffffffc02035f4:	400c                	lw	a1,0(s0)
ffffffffc02035f6:	00459693          	slli	a3,a1,0x4
ffffffffc02035fa:	96a2                	add	a3,a3,s0
ffffffffc02035fc:	fcd79ae3          	bne	a5,a3,ffffffffc02035d0 <slob_free+0x3c>
ffffffffc0203600:	4394                	lw	a3,0(a5)
ffffffffc0203602:	679c                	ld	a5,8(a5)
ffffffffc0203604:	9db5                	addw	a1,a1,a3
ffffffffc0203606:	c00c                	sw	a1,0(s0)
ffffffffc0203608:	4314                	lw	a3,0(a4)
ffffffffc020360a:	e41c                	sd	a5,8(s0)
ffffffffc020360c:	00469793          	slli	a5,a3,0x4
ffffffffc0203610:	97ba                	add	a5,a5,a4
ffffffffc0203612:	fcf416e3          	bne	s0,a5,ffffffffc02035de <slob_free+0x4a>
ffffffffc0203616:	401c                	lw	a5,0(s0)
ffffffffc0203618:	640c                	ld	a1,8(s0)
ffffffffc020361a:	e218                	sd	a4,0(a2)
ffffffffc020361c:	9ebd                	addw	a3,a3,a5
ffffffffc020361e:	c314                	sw	a3,0(a4)
ffffffffc0203620:	e70c                	sd	a1,8(a4)
ffffffffc0203622:	d169                	beqz	a0,ffffffffc02035e4 <slob_free+0x50>
ffffffffc0203624:	6402                	ld	s0,0(sp)
ffffffffc0203626:	60a2                	ld	ra,8(sp)
ffffffffc0203628:	0141                	addi	sp,sp,16
ffffffffc020362a:	f74fd06f          	j	ffffffffc0200d9e <intr_enable>
ffffffffc020362e:	25bd                	addiw	a1,a1,15
ffffffffc0203630:	8191                	srli	a1,a1,0x4
ffffffffc0203632:	c10c                	sw	a1,0(a0)
ffffffffc0203634:	100027f3          	csrr	a5,sstatus
ffffffffc0203638:	8b89                	andi	a5,a5,2
ffffffffc020363a:	4501                	li	a0,0
ffffffffc020363c:	d7bd                	beqz	a5,ffffffffc02035aa <slob_free+0x16>
ffffffffc020363e:	f66fd0ef          	jal	ra,ffffffffc0200da4 <intr_disable>
ffffffffc0203642:	4505                	li	a0,1
ffffffffc0203644:	b79d                	j	ffffffffc02035aa <slob_free+0x16>
ffffffffc0203646:	8082                	ret

ffffffffc0203648 <__slob_get_free_pages.constprop.0>:
ffffffffc0203648:	4785                	li	a5,1
ffffffffc020364a:	1141                	addi	sp,sp,-16
ffffffffc020364c:	00a7953b          	sllw	a0,a5,a0
ffffffffc0203650:	e406                	sd	ra,8(sp)
ffffffffc0203652:	c9dfd0ef          	jal	ra,ffffffffc02012ee <alloc_pages>
ffffffffc0203656:	c91d                	beqz	a0,ffffffffc020368c <__slob_get_free_pages.constprop.0+0x44>
ffffffffc0203658:	00093697          	auipc	a3,0x93
ffffffffc020365c:	2486b683          	ld	a3,584(a3) # ffffffffc02968a0 <pages>
ffffffffc0203660:	8d15                	sub	a0,a0,a3
ffffffffc0203662:	8519                	srai	a0,a0,0x6
ffffffffc0203664:	0000c697          	auipc	a3,0xc
ffffffffc0203668:	1446b683          	ld	a3,324(a3) # ffffffffc020f7a8 <nbase>
ffffffffc020366c:	9536                	add	a0,a0,a3
ffffffffc020366e:	00c51793          	slli	a5,a0,0xc
ffffffffc0203672:	83b1                	srli	a5,a5,0xc
ffffffffc0203674:	00093717          	auipc	a4,0x93
ffffffffc0203678:	22473703          	ld	a4,548(a4) # ffffffffc0296898 <npage>
ffffffffc020367c:	0532                	slli	a0,a0,0xc
ffffffffc020367e:	00e7fa63          	bgeu	a5,a4,ffffffffc0203692 <__slob_get_free_pages.constprop.0+0x4a>
ffffffffc0203682:	00093697          	auipc	a3,0x93
ffffffffc0203686:	22e6b683          	ld	a3,558(a3) # ffffffffc02968b0 <va_pa_offset>
ffffffffc020368a:	9536                	add	a0,a0,a3
ffffffffc020368c:	60a2                	ld	ra,8(sp)
ffffffffc020368e:	0141                	addi	sp,sp,16
ffffffffc0203690:	8082                	ret
ffffffffc0203692:	86aa                	mv	a3,a0
ffffffffc0203694:	00009617          	auipc	a2,0x9
ffffffffc0203698:	a7c60613          	addi	a2,a2,-1412 # ffffffffc020c110 <commands+0x968>
ffffffffc020369c:	07100593          	li	a1,113
ffffffffc02036a0:	00009517          	auipc	a0,0x9
ffffffffc02036a4:	a3850513          	addi	a0,a0,-1480 # ffffffffc020c0d8 <commands+0x930>
ffffffffc02036a8:	b87fc0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02036ac <slob_alloc.constprop.0>:
ffffffffc02036ac:	1101                	addi	sp,sp,-32
ffffffffc02036ae:	ec06                	sd	ra,24(sp)
ffffffffc02036b0:	e822                	sd	s0,16(sp)
ffffffffc02036b2:	e426                	sd	s1,8(sp)
ffffffffc02036b4:	e04a                	sd	s2,0(sp)
ffffffffc02036b6:	01050713          	addi	a4,a0,16
ffffffffc02036ba:	6785                	lui	a5,0x1
ffffffffc02036bc:	0cf77363          	bgeu	a4,a5,ffffffffc0203782 <slob_alloc.constprop.0+0xd6>
ffffffffc02036c0:	00f50493          	addi	s1,a0,15
ffffffffc02036c4:	8091                	srli	s1,s1,0x4
ffffffffc02036c6:	2481                	sext.w	s1,s1
ffffffffc02036c8:	10002673          	csrr	a2,sstatus
ffffffffc02036cc:	8a09                	andi	a2,a2,2
ffffffffc02036ce:	e25d                	bnez	a2,ffffffffc0203774 <slob_alloc.constprop.0+0xc8>
ffffffffc02036d0:	0008e917          	auipc	s2,0x8e
ffffffffc02036d4:	98090913          	addi	s2,s2,-1664 # ffffffffc0291050 <slobfree>
ffffffffc02036d8:	00093683          	ld	a3,0(s2)
ffffffffc02036dc:	669c                	ld	a5,8(a3)
ffffffffc02036de:	4398                	lw	a4,0(a5)
ffffffffc02036e0:	08975e63          	bge	a4,s1,ffffffffc020377c <slob_alloc.constprop.0+0xd0>
ffffffffc02036e4:	00f68b63          	beq	a3,a5,ffffffffc02036fa <slob_alloc.constprop.0+0x4e>
ffffffffc02036e8:	6780                	ld	s0,8(a5)
ffffffffc02036ea:	4018                	lw	a4,0(s0)
ffffffffc02036ec:	02975a63          	bge	a4,s1,ffffffffc0203720 <slob_alloc.constprop.0+0x74>
ffffffffc02036f0:	00093683          	ld	a3,0(s2)
ffffffffc02036f4:	87a2                	mv	a5,s0
ffffffffc02036f6:	fef699e3          	bne	a3,a5,ffffffffc02036e8 <slob_alloc.constprop.0+0x3c>
ffffffffc02036fa:	ee31                	bnez	a2,ffffffffc0203756 <slob_alloc.constprop.0+0xaa>
ffffffffc02036fc:	4501                	li	a0,0
ffffffffc02036fe:	f4bff0ef          	jal	ra,ffffffffc0203648 <__slob_get_free_pages.constprop.0>
ffffffffc0203702:	842a                	mv	s0,a0
ffffffffc0203704:	cd05                	beqz	a0,ffffffffc020373c <slob_alloc.constprop.0+0x90>
ffffffffc0203706:	6585                	lui	a1,0x1
ffffffffc0203708:	e8dff0ef          	jal	ra,ffffffffc0203594 <slob_free>
ffffffffc020370c:	10002673          	csrr	a2,sstatus
ffffffffc0203710:	8a09                	andi	a2,a2,2
ffffffffc0203712:	ee05                	bnez	a2,ffffffffc020374a <slob_alloc.constprop.0+0x9e>
ffffffffc0203714:	00093783          	ld	a5,0(s2)
ffffffffc0203718:	6780                	ld	s0,8(a5)
ffffffffc020371a:	4018                	lw	a4,0(s0)
ffffffffc020371c:	fc974ae3          	blt	a4,s1,ffffffffc02036f0 <slob_alloc.constprop.0+0x44>
ffffffffc0203720:	04e48763          	beq	s1,a4,ffffffffc020376e <slob_alloc.constprop.0+0xc2>
ffffffffc0203724:	00449693          	slli	a3,s1,0x4
ffffffffc0203728:	96a2                	add	a3,a3,s0
ffffffffc020372a:	e794                	sd	a3,8(a5)
ffffffffc020372c:	640c                	ld	a1,8(s0)
ffffffffc020372e:	9f05                	subw	a4,a4,s1
ffffffffc0203730:	c298                	sw	a4,0(a3)
ffffffffc0203732:	e68c                	sd	a1,8(a3)
ffffffffc0203734:	c004                	sw	s1,0(s0)
ffffffffc0203736:	00f93023          	sd	a5,0(s2)
ffffffffc020373a:	e20d                	bnez	a2,ffffffffc020375c <slob_alloc.constprop.0+0xb0>
ffffffffc020373c:	60e2                	ld	ra,24(sp)
ffffffffc020373e:	8522                	mv	a0,s0
ffffffffc0203740:	6442                	ld	s0,16(sp)
ffffffffc0203742:	64a2                	ld	s1,8(sp)
ffffffffc0203744:	6902                	ld	s2,0(sp)
ffffffffc0203746:	6105                	addi	sp,sp,32
ffffffffc0203748:	8082                	ret
ffffffffc020374a:	e5afd0ef          	jal	ra,ffffffffc0200da4 <intr_disable>
ffffffffc020374e:	00093783          	ld	a5,0(s2)
ffffffffc0203752:	4605                	li	a2,1
ffffffffc0203754:	b7d1                	j	ffffffffc0203718 <slob_alloc.constprop.0+0x6c>
ffffffffc0203756:	e48fd0ef          	jal	ra,ffffffffc0200d9e <intr_enable>
ffffffffc020375a:	b74d                	j	ffffffffc02036fc <slob_alloc.constprop.0+0x50>
ffffffffc020375c:	e42fd0ef          	jal	ra,ffffffffc0200d9e <intr_enable>
ffffffffc0203760:	60e2                	ld	ra,24(sp)
ffffffffc0203762:	8522                	mv	a0,s0
ffffffffc0203764:	6442                	ld	s0,16(sp)
ffffffffc0203766:	64a2                	ld	s1,8(sp)
ffffffffc0203768:	6902                	ld	s2,0(sp)
ffffffffc020376a:	6105                	addi	sp,sp,32
ffffffffc020376c:	8082                	ret
ffffffffc020376e:	6418                	ld	a4,8(s0)
ffffffffc0203770:	e798                	sd	a4,8(a5)
ffffffffc0203772:	b7d1                	j	ffffffffc0203736 <slob_alloc.constprop.0+0x8a>
ffffffffc0203774:	e30fd0ef          	jal	ra,ffffffffc0200da4 <intr_disable>
ffffffffc0203778:	4605                	li	a2,1
ffffffffc020377a:	bf99                	j	ffffffffc02036d0 <slob_alloc.constprop.0+0x24>
ffffffffc020377c:	843e                	mv	s0,a5
ffffffffc020377e:	87b6                	mv	a5,a3
ffffffffc0203780:	b745                	j	ffffffffc0203720 <slob_alloc.constprop.0+0x74>
ffffffffc0203782:	00009697          	auipc	a3,0x9
ffffffffc0203786:	32e68693          	addi	a3,a3,814 # ffffffffc020cab0 <commands+0x1308>
ffffffffc020378a:	00008617          	auipc	a2,0x8
ffffffffc020378e:	07e60613          	addi	a2,a2,126 # ffffffffc020b808 <commands+0x60>
ffffffffc0203792:	06300593          	li	a1,99
ffffffffc0203796:	00009517          	auipc	a0,0x9
ffffffffc020379a:	33a50513          	addi	a0,a0,826 # ffffffffc020cad0 <commands+0x1328>
ffffffffc020379e:	a91fc0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02037a2 <kmalloc_init>:
ffffffffc02037a2:	1141                	addi	sp,sp,-16
ffffffffc02037a4:	00009517          	auipc	a0,0x9
ffffffffc02037a8:	34450513          	addi	a0,a0,836 # ffffffffc020cae8 <commands+0x1340>
ffffffffc02037ac:	e406                	sd	ra,8(sp)
ffffffffc02037ae:	97dfc0ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02037b2:	60a2                	ld	ra,8(sp)
ffffffffc02037b4:	00009517          	auipc	a0,0x9
ffffffffc02037b8:	34c50513          	addi	a0,a0,844 # ffffffffc020cb00 <commands+0x1358>
ffffffffc02037bc:	0141                	addi	sp,sp,16
ffffffffc02037be:	96dfc06f          	j	ffffffffc020012a <cprintf>

ffffffffc02037c2 <kallocated>:
ffffffffc02037c2:	4501                	li	a0,0
ffffffffc02037c4:	8082                	ret

ffffffffc02037c6 <kmalloc>:
ffffffffc02037c6:	1101                	addi	sp,sp,-32
ffffffffc02037c8:	e04a                	sd	s2,0(sp)
ffffffffc02037ca:	6905                	lui	s2,0x1
ffffffffc02037cc:	e822                	sd	s0,16(sp)
ffffffffc02037ce:	ec06                	sd	ra,24(sp)
ffffffffc02037d0:	e426                	sd	s1,8(sp)
ffffffffc02037d2:	fef90793          	addi	a5,s2,-17 # fef <_binary_bin_swap_img_size-0x6d11>
ffffffffc02037d6:	842a                	mv	s0,a0
ffffffffc02037d8:	04a7f963          	bgeu	a5,a0,ffffffffc020382a <kmalloc+0x64>
ffffffffc02037dc:	4561                	li	a0,24
ffffffffc02037de:	ecfff0ef          	jal	ra,ffffffffc02036ac <slob_alloc.constprop.0>
ffffffffc02037e2:	84aa                	mv	s1,a0
ffffffffc02037e4:	c929                	beqz	a0,ffffffffc0203836 <kmalloc+0x70>
ffffffffc02037e6:	0004079b          	sext.w	a5,s0
ffffffffc02037ea:	4501                	li	a0,0
ffffffffc02037ec:	00f95763          	bge	s2,a5,ffffffffc02037fa <kmalloc+0x34>
ffffffffc02037f0:	6705                	lui	a4,0x1
ffffffffc02037f2:	8785                	srai	a5,a5,0x1
ffffffffc02037f4:	2505                	addiw	a0,a0,1
ffffffffc02037f6:	fef74ee3          	blt	a4,a5,ffffffffc02037f2 <kmalloc+0x2c>
ffffffffc02037fa:	c088                	sw	a0,0(s1)
ffffffffc02037fc:	e4dff0ef          	jal	ra,ffffffffc0203648 <__slob_get_free_pages.constprop.0>
ffffffffc0203800:	e488                	sd	a0,8(s1)
ffffffffc0203802:	842a                	mv	s0,a0
ffffffffc0203804:	c525                	beqz	a0,ffffffffc020386c <kmalloc+0xa6>
ffffffffc0203806:	100027f3          	csrr	a5,sstatus
ffffffffc020380a:	8b89                	andi	a5,a5,2
ffffffffc020380c:	ef8d                	bnez	a5,ffffffffc0203846 <kmalloc+0x80>
ffffffffc020380e:	00093797          	auipc	a5,0x93
ffffffffc0203812:	0aa78793          	addi	a5,a5,170 # ffffffffc02968b8 <bigblocks>
ffffffffc0203816:	6398                	ld	a4,0(a5)
ffffffffc0203818:	e384                	sd	s1,0(a5)
ffffffffc020381a:	e898                	sd	a4,16(s1)
ffffffffc020381c:	60e2                	ld	ra,24(sp)
ffffffffc020381e:	8522                	mv	a0,s0
ffffffffc0203820:	6442                	ld	s0,16(sp)
ffffffffc0203822:	64a2                	ld	s1,8(sp)
ffffffffc0203824:	6902                	ld	s2,0(sp)
ffffffffc0203826:	6105                	addi	sp,sp,32
ffffffffc0203828:	8082                	ret
ffffffffc020382a:	0541                	addi	a0,a0,16
ffffffffc020382c:	e81ff0ef          	jal	ra,ffffffffc02036ac <slob_alloc.constprop.0>
ffffffffc0203830:	01050413          	addi	s0,a0,16
ffffffffc0203834:	f565                	bnez	a0,ffffffffc020381c <kmalloc+0x56>
ffffffffc0203836:	4401                	li	s0,0
ffffffffc0203838:	60e2                	ld	ra,24(sp)
ffffffffc020383a:	8522                	mv	a0,s0
ffffffffc020383c:	6442                	ld	s0,16(sp)
ffffffffc020383e:	64a2                	ld	s1,8(sp)
ffffffffc0203840:	6902                	ld	s2,0(sp)
ffffffffc0203842:	6105                	addi	sp,sp,32
ffffffffc0203844:	8082                	ret
ffffffffc0203846:	d5efd0ef          	jal	ra,ffffffffc0200da4 <intr_disable>
ffffffffc020384a:	00093797          	auipc	a5,0x93
ffffffffc020384e:	06e78793          	addi	a5,a5,110 # ffffffffc02968b8 <bigblocks>
ffffffffc0203852:	6398                	ld	a4,0(a5)
ffffffffc0203854:	e384                	sd	s1,0(a5)
ffffffffc0203856:	e898                	sd	a4,16(s1)
ffffffffc0203858:	d46fd0ef          	jal	ra,ffffffffc0200d9e <intr_enable>
ffffffffc020385c:	6480                	ld	s0,8(s1)
ffffffffc020385e:	60e2                	ld	ra,24(sp)
ffffffffc0203860:	64a2                	ld	s1,8(sp)
ffffffffc0203862:	8522                	mv	a0,s0
ffffffffc0203864:	6442                	ld	s0,16(sp)
ffffffffc0203866:	6902                	ld	s2,0(sp)
ffffffffc0203868:	6105                	addi	sp,sp,32
ffffffffc020386a:	8082                	ret
ffffffffc020386c:	45e1                	li	a1,24
ffffffffc020386e:	8526                	mv	a0,s1
ffffffffc0203870:	d25ff0ef          	jal	ra,ffffffffc0203594 <slob_free>
ffffffffc0203874:	b765                	j	ffffffffc020381c <kmalloc+0x56>

ffffffffc0203876 <kfree>:
ffffffffc0203876:	c179                	beqz	a0,ffffffffc020393c <kfree+0xc6>
ffffffffc0203878:	1101                	addi	sp,sp,-32
ffffffffc020387a:	e822                	sd	s0,16(sp)
ffffffffc020387c:	ec06                	sd	ra,24(sp)
ffffffffc020387e:	e426                	sd	s1,8(sp)
ffffffffc0203880:	03451793          	slli	a5,a0,0x34
ffffffffc0203884:	842a                	mv	s0,a0
ffffffffc0203886:	e7c1                	bnez	a5,ffffffffc020390e <kfree+0x98>
ffffffffc0203888:	100027f3          	csrr	a5,sstatus
ffffffffc020388c:	8b89                	andi	a5,a5,2
ffffffffc020388e:	ebc9                	bnez	a5,ffffffffc0203920 <kfree+0xaa>
ffffffffc0203890:	00093797          	auipc	a5,0x93
ffffffffc0203894:	0287b783          	ld	a5,40(a5) # ffffffffc02968b8 <bigblocks>
ffffffffc0203898:	4601                	li	a2,0
ffffffffc020389a:	cbb5                	beqz	a5,ffffffffc020390e <kfree+0x98>
ffffffffc020389c:	00093697          	auipc	a3,0x93
ffffffffc02038a0:	01c68693          	addi	a3,a3,28 # ffffffffc02968b8 <bigblocks>
ffffffffc02038a4:	a021                	j	ffffffffc02038ac <kfree+0x36>
ffffffffc02038a6:	01048693          	addi	a3,s1,16
ffffffffc02038aa:	c3ad                	beqz	a5,ffffffffc020390c <kfree+0x96>
ffffffffc02038ac:	6798                	ld	a4,8(a5)
ffffffffc02038ae:	84be                	mv	s1,a5
ffffffffc02038b0:	6b9c                	ld	a5,16(a5)
ffffffffc02038b2:	fe871ae3          	bne	a4,s0,ffffffffc02038a6 <kfree+0x30>
ffffffffc02038b6:	e29c                	sd	a5,0(a3)
ffffffffc02038b8:	ee3d                	bnez	a2,ffffffffc0203936 <kfree+0xc0>
ffffffffc02038ba:	c02007b7          	lui	a5,0xc0200
ffffffffc02038be:	4098                	lw	a4,0(s1)
ffffffffc02038c0:	08f46b63          	bltu	s0,a5,ffffffffc0203956 <kfree+0xe0>
ffffffffc02038c4:	00093697          	auipc	a3,0x93
ffffffffc02038c8:	fec6b683          	ld	a3,-20(a3) # ffffffffc02968b0 <va_pa_offset>
ffffffffc02038cc:	8c15                	sub	s0,s0,a3
ffffffffc02038ce:	8031                	srli	s0,s0,0xc
ffffffffc02038d0:	00093797          	auipc	a5,0x93
ffffffffc02038d4:	fc87b783          	ld	a5,-56(a5) # ffffffffc0296898 <npage>
ffffffffc02038d8:	06f47363          	bgeu	s0,a5,ffffffffc020393e <kfree+0xc8>
ffffffffc02038dc:	0000c517          	auipc	a0,0xc
ffffffffc02038e0:	ecc53503          	ld	a0,-308(a0) # ffffffffc020f7a8 <nbase>
ffffffffc02038e4:	8c09                	sub	s0,s0,a0
ffffffffc02038e6:	041a                	slli	s0,s0,0x6
ffffffffc02038e8:	00093517          	auipc	a0,0x93
ffffffffc02038ec:	fb853503          	ld	a0,-72(a0) # ffffffffc02968a0 <pages>
ffffffffc02038f0:	4585                	li	a1,1
ffffffffc02038f2:	9522                	add	a0,a0,s0
ffffffffc02038f4:	00e595bb          	sllw	a1,a1,a4
ffffffffc02038f8:	a35fd0ef          	jal	ra,ffffffffc020132c <free_pages>
ffffffffc02038fc:	6442                	ld	s0,16(sp)
ffffffffc02038fe:	60e2                	ld	ra,24(sp)
ffffffffc0203900:	8526                	mv	a0,s1
ffffffffc0203902:	64a2                	ld	s1,8(sp)
ffffffffc0203904:	45e1                	li	a1,24
ffffffffc0203906:	6105                	addi	sp,sp,32
ffffffffc0203908:	c8dff06f          	j	ffffffffc0203594 <slob_free>
ffffffffc020390c:	e215                	bnez	a2,ffffffffc0203930 <kfree+0xba>
ffffffffc020390e:	ff040513          	addi	a0,s0,-16
ffffffffc0203912:	6442                	ld	s0,16(sp)
ffffffffc0203914:	60e2                	ld	ra,24(sp)
ffffffffc0203916:	64a2                	ld	s1,8(sp)
ffffffffc0203918:	4581                	li	a1,0
ffffffffc020391a:	6105                	addi	sp,sp,32
ffffffffc020391c:	c79ff06f          	j	ffffffffc0203594 <slob_free>
ffffffffc0203920:	c84fd0ef          	jal	ra,ffffffffc0200da4 <intr_disable>
ffffffffc0203924:	00093797          	auipc	a5,0x93
ffffffffc0203928:	f947b783          	ld	a5,-108(a5) # ffffffffc02968b8 <bigblocks>
ffffffffc020392c:	4605                	li	a2,1
ffffffffc020392e:	f7bd                	bnez	a5,ffffffffc020389c <kfree+0x26>
ffffffffc0203930:	c6efd0ef          	jal	ra,ffffffffc0200d9e <intr_enable>
ffffffffc0203934:	bfe9                	j	ffffffffc020390e <kfree+0x98>
ffffffffc0203936:	c68fd0ef          	jal	ra,ffffffffc0200d9e <intr_enable>
ffffffffc020393a:	b741                	j	ffffffffc02038ba <kfree+0x44>
ffffffffc020393c:	8082                	ret
ffffffffc020393e:	00008617          	auipc	a2,0x8
ffffffffc0203942:	77a60613          	addi	a2,a2,1914 # ffffffffc020c0b8 <commands+0x910>
ffffffffc0203946:	06900593          	li	a1,105
ffffffffc020394a:	00008517          	auipc	a0,0x8
ffffffffc020394e:	78e50513          	addi	a0,a0,1934 # ffffffffc020c0d8 <commands+0x930>
ffffffffc0203952:	8ddfc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203956:	86a2                	mv	a3,s0
ffffffffc0203958:	00009617          	auipc	a2,0x9
ffffffffc020395c:	8d860613          	addi	a2,a2,-1832 # ffffffffc020c230 <commands+0xa88>
ffffffffc0203960:	07700593          	li	a1,119
ffffffffc0203964:	00008517          	auipc	a0,0x8
ffffffffc0203968:	77450513          	addi	a0,a0,1908 # ffffffffc020c0d8 <commands+0x930>
ffffffffc020396c:	8c3fc0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0203970 <default_init>:
ffffffffc0203970:	0008e797          	auipc	a5,0x8e
ffffffffc0203974:	e3878793          	addi	a5,a5,-456 # ffffffffc02917a8 <free_area>
ffffffffc0203978:	e79c                	sd	a5,8(a5)
ffffffffc020397a:	e39c                	sd	a5,0(a5)
ffffffffc020397c:	0007a823          	sw	zero,16(a5)
ffffffffc0203980:	8082                	ret

ffffffffc0203982 <default_nr_free_pages>:
ffffffffc0203982:	0008e517          	auipc	a0,0x8e
ffffffffc0203986:	e3656503          	lwu	a0,-458(a0) # ffffffffc02917b8 <free_area+0x10>
ffffffffc020398a:	8082                	ret

ffffffffc020398c <default_check>:
ffffffffc020398c:	715d                	addi	sp,sp,-80
ffffffffc020398e:	e0a2                	sd	s0,64(sp)
ffffffffc0203990:	0008e417          	auipc	s0,0x8e
ffffffffc0203994:	e1840413          	addi	s0,s0,-488 # ffffffffc02917a8 <free_area>
ffffffffc0203998:	641c                	ld	a5,8(s0)
ffffffffc020399a:	e486                	sd	ra,72(sp)
ffffffffc020399c:	fc26                	sd	s1,56(sp)
ffffffffc020399e:	f84a                	sd	s2,48(sp)
ffffffffc02039a0:	f44e                	sd	s3,40(sp)
ffffffffc02039a2:	f052                	sd	s4,32(sp)
ffffffffc02039a4:	ec56                	sd	s5,24(sp)
ffffffffc02039a6:	e85a                	sd	s6,16(sp)
ffffffffc02039a8:	e45e                	sd	s7,8(sp)
ffffffffc02039aa:	e062                	sd	s8,0(sp)
ffffffffc02039ac:	2a878d63          	beq	a5,s0,ffffffffc0203c66 <default_check+0x2da>
ffffffffc02039b0:	4481                	li	s1,0
ffffffffc02039b2:	4901                	li	s2,0
ffffffffc02039b4:	ff07b703          	ld	a4,-16(a5)
ffffffffc02039b8:	8b09                	andi	a4,a4,2
ffffffffc02039ba:	2a070a63          	beqz	a4,ffffffffc0203c6e <default_check+0x2e2>
ffffffffc02039be:	ff87a703          	lw	a4,-8(a5)
ffffffffc02039c2:	679c                	ld	a5,8(a5)
ffffffffc02039c4:	2905                	addiw	s2,s2,1
ffffffffc02039c6:	9cb9                	addw	s1,s1,a4
ffffffffc02039c8:	fe8796e3          	bne	a5,s0,ffffffffc02039b4 <default_check+0x28>
ffffffffc02039cc:	89a6                	mv	s3,s1
ffffffffc02039ce:	99ffd0ef          	jal	ra,ffffffffc020136c <nr_free_pages>
ffffffffc02039d2:	6f351e63          	bne	a0,s3,ffffffffc02040ce <default_check+0x742>
ffffffffc02039d6:	4505                	li	a0,1
ffffffffc02039d8:	917fd0ef          	jal	ra,ffffffffc02012ee <alloc_pages>
ffffffffc02039dc:	8aaa                	mv	s5,a0
ffffffffc02039de:	42050863          	beqz	a0,ffffffffc0203e0e <default_check+0x482>
ffffffffc02039e2:	4505                	li	a0,1
ffffffffc02039e4:	90bfd0ef          	jal	ra,ffffffffc02012ee <alloc_pages>
ffffffffc02039e8:	89aa                	mv	s3,a0
ffffffffc02039ea:	70050263          	beqz	a0,ffffffffc02040ee <default_check+0x762>
ffffffffc02039ee:	4505                	li	a0,1
ffffffffc02039f0:	8fffd0ef          	jal	ra,ffffffffc02012ee <alloc_pages>
ffffffffc02039f4:	8a2a                	mv	s4,a0
ffffffffc02039f6:	48050c63          	beqz	a0,ffffffffc0203e8e <default_check+0x502>
ffffffffc02039fa:	293a8a63          	beq	s5,s3,ffffffffc0203c8e <default_check+0x302>
ffffffffc02039fe:	28aa8863          	beq	s5,a0,ffffffffc0203c8e <default_check+0x302>
ffffffffc0203a02:	28a98663          	beq	s3,a0,ffffffffc0203c8e <default_check+0x302>
ffffffffc0203a06:	000aa783          	lw	a5,0(s5)
ffffffffc0203a0a:	2a079263          	bnez	a5,ffffffffc0203cae <default_check+0x322>
ffffffffc0203a0e:	0009a783          	lw	a5,0(s3) # 1000 <_binary_bin_swap_img_size-0x6d00>
ffffffffc0203a12:	28079e63          	bnez	a5,ffffffffc0203cae <default_check+0x322>
ffffffffc0203a16:	411c                	lw	a5,0(a0)
ffffffffc0203a18:	28079b63          	bnez	a5,ffffffffc0203cae <default_check+0x322>
ffffffffc0203a1c:	00093797          	auipc	a5,0x93
ffffffffc0203a20:	e847b783          	ld	a5,-380(a5) # ffffffffc02968a0 <pages>
ffffffffc0203a24:	40fa8733          	sub	a4,s5,a5
ffffffffc0203a28:	0000c617          	auipc	a2,0xc
ffffffffc0203a2c:	d8063603          	ld	a2,-640(a2) # ffffffffc020f7a8 <nbase>
ffffffffc0203a30:	8719                	srai	a4,a4,0x6
ffffffffc0203a32:	9732                	add	a4,a4,a2
ffffffffc0203a34:	00093697          	auipc	a3,0x93
ffffffffc0203a38:	e646b683          	ld	a3,-412(a3) # ffffffffc0296898 <npage>
ffffffffc0203a3c:	06b2                	slli	a3,a3,0xc
ffffffffc0203a3e:	0732                	slli	a4,a4,0xc
ffffffffc0203a40:	28d77763          	bgeu	a4,a3,ffffffffc0203cce <default_check+0x342>
ffffffffc0203a44:	40f98733          	sub	a4,s3,a5
ffffffffc0203a48:	8719                	srai	a4,a4,0x6
ffffffffc0203a4a:	9732                	add	a4,a4,a2
ffffffffc0203a4c:	0732                	slli	a4,a4,0xc
ffffffffc0203a4e:	4cd77063          	bgeu	a4,a3,ffffffffc0203f0e <default_check+0x582>
ffffffffc0203a52:	40f507b3          	sub	a5,a0,a5
ffffffffc0203a56:	8799                	srai	a5,a5,0x6
ffffffffc0203a58:	97b2                	add	a5,a5,a2
ffffffffc0203a5a:	07b2                	slli	a5,a5,0xc
ffffffffc0203a5c:	30d7f963          	bgeu	a5,a3,ffffffffc0203d6e <default_check+0x3e2>
ffffffffc0203a60:	4505                	li	a0,1
ffffffffc0203a62:	00043c03          	ld	s8,0(s0)
ffffffffc0203a66:	00843b83          	ld	s7,8(s0)
ffffffffc0203a6a:	01042b03          	lw	s6,16(s0)
ffffffffc0203a6e:	e400                	sd	s0,8(s0)
ffffffffc0203a70:	e000                	sd	s0,0(s0)
ffffffffc0203a72:	0008e797          	auipc	a5,0x8e
ffffffffc0203a76:	d407a323          	sw	zero,-698(a5) # ffffffffc02917b8 <free_area+0x10>
ffffffffc0203a7a:	875fd0ef          	jal	ra,ffffffffc02012ee <alloc_pages>
ffffffffc0203a7e:	2c051863          	bnez	a0,ffffffffc0203d4e <default_check+0x3c2>
ffffffffc0203a82:	4585                	li	a1,1
ffffffffc0203a84:	8556                	mv	a0,s5
ffffffffc0203a86:	8a7fd0ef          	jal	ra,ffffffffc020132c <free_pages>
ffffffffc0203a8a:	4585                	li	a1,1
ffffffffc0203a8c:	854e                	mv	a0,s3
ffffffffc0203a8e:	89ffd0ef          	jal	ra,ffffffffc020132c <free_pages>
ffffffffc0203a92:	4585                	li	a1,1
ffffffffc0203a94:	8552                	mv	a0,s4
ffffffffc0203a96:	897fd0ef          	jal	ra,ffffffffc020132c <free_pages>
ffffffffc0203a9a:	4818                	lw	a4,16(s0)
ffffffffc0203a9c:	478d                	li	a5,3
ffffffffc0203a9e:	28f71863          	bne	a4,a5,ffffffffc0203d2e <default_check+0x3a2>
ffffffffc0203aa2:	4505                	li	a0,1
ffffffffc0203aa4:	84bfd0ef          	jal	ra,ffffffffc02012ee <alloc_pages>
ffffffffc0203aa8:	89aa                	mv	s3,a0
ffffffffc0203aaa:	26050263          	beqz	a0,ffffffffc0203d0e <default_check+0x382>
ffffffffc0203aae:	4505                	li	a0,1
ffffffffc0203ab0:	83ffd0ef          	jal	ra,ffffffffc02012ee <alloc_pages>
ffffffffc0203ab4:	8aaa                	mv	s5,a0
ffffffffc0203ab6:	3a050c63          	beqz	a0,ffffffffc0203e6e <default_check+0x4e2>
ffffffffc0203aba:	4505                	li	a0,1
ffffffffc0203abc:	833fd0ef          	jal	ra,ffffffffc02012ee <alloc_pages>
ffffffffc0203ac0:	8a2a                	mv	s4,a0
ffffffffc0203ac2:	38050663          	beqz	a0,ffffffffc0203e4e <default_check+0x4c2>
ffffffffc0203ac6:	4505                	li	a0,1
ffffffffc0203ac8:	827fd0ef          	jal	ra,ffffffffc02012ee <alloc_pages>
ffffffffc0203acc:	36051163          	bnez	a0,ffffffffc0203e2e <default_check+0x4a2>
ffffffffc0203ad0:	4585                	li	a1,1
ffffffffc0203ad2:	854e                	mv	a0,s3
ffffffffc0203ad4:	859fd0ef          	jal	ra,ffffffffc020132c <free_pages>
ffffffffc0203ad8:	641c                	ld	a5,8(s0)
ffffffffc0203ada:	20878a63          	beq	a5,s0,ffffffffc0203cee <default_check+0x362>
ffffffffc0203ade:	4505                	li	a0,1
ffffffffc0203ae0:	80ffd0ef          	jal	ra,ffffffffc02012ee <alloc_pages>
ffffffffc0203ae4:	30a99563          	bne	s3,a0,ffffffffc0203dee <default_check+0x462>
ffffffffc0203ae8:	4505                	li	a0,1
ffffffffc0203aea:	805fd0ef          	jal	ra,ffffffffc02012ee <alloc_pages>
ffffffffc0203aee:	2e051063          	bnez	a0,ffffffffc0203dce <default_check+0x442>
ffffffffc0203af2:	481c                	lw	a5,16(s0)
ffffffffc0203af4:	2a079d63          	bnez	a5,ffffffffc0203dae <default_check+0x422>
ffffffffc0203af8:	854e                	mv	a0,s3
ffffffffc0203afa:	4585                	li	a1,1
ffffffffc0203afc:	01843023          	sd	s8,0(s0)
ffffffffc0203b00:	01743423          	sd	s7,8(s0)
ffffffffc0203b04:	01642823          	sw	s6,16(s0)
ffffffffc0203b08:	825fd0ef          	jal	ra,ffffffffc020132c <free_pages>
ffffffffc0203b0c:	4585                	li	a1,1
ffffffffc0203b0e:	8556                	mv	a0,s5
ffffffffc0203b10:	81dfd0ef          	jal	ra,ffffffffc020132c <free_pages>
ffffffffc0203b14:	4585                	li	a1,1
ffffffffc0203b16:	8552                	mv	a0,s4
ffffffffc0203b18:	815fd0ef          	jal	ra,ffffffffc020132c <free_pages>
ffffffffc0203b1c:	4515                	li	a0,5
ffffffffc0203b1e:	fd0fd0ef          	jal	ra,ffffffffc02012ee <alloc_pages>
ffffffffc0203b22:	89aa                	mv	s3,a0
ffffffffc0203b24:	26050563          	beqz	a0,ffffffffc0203d8e <default_check+0x402>
ffffffffc0203b28:	651c                	ld	a5,8(a0)
ffffffffc0203b2a:	8385                	srli	a5,a5,0x1
ffffffffc0203b2c:	8b85                	andi	a5,a5,1
ffffffffc0203b2e:	54079063          	bnez	a5,ffffffffc020406e <default_check+0x6e2>
ffffffffc0203b32:	4505                	li	a0,1
ffffffffc0203b34:	00043b03          	ld	s6,0(s0)
ffffffffc0203b38:	00843a83          	ld	s5,8(s0)
ffffffffc0203b3c:	e000                	sd	s0,0(s0)
ffffffffc0203b3e:	e400                	sd	s0,8(s0)
ffffffffc0203b40:	faefd0ef          	jal	ra,ffffffffc02012ee <alloc_pages>
ffffffffc0203b44:	50051563          	bnez	a0,ffffffffc020404e <default_check+0x6c2>
ffffffffc0203b48:	08098a13          	addi	s4,s3,128
ffffffffc0203b4c:	8552                	mv	a0,s4
ffffffffc0203b4e:	458d                	li	a1,3
ffffffffc0203b50:	01042b83          	lw	s7,16(s0)
ffffffffc0203b54:	0008e797          	auipc	a5,0x8e
ffffffffc0203b58:	c607a223          	sw	zero,-924(a5) # ffffffffc02917b8 <free_area+0x10>
ffffffffc0203b5c:	fd0fd0ef          	jal	ra,ffffffffc020132c <free_pages>
ffffffffc0203b60:	4511                	li	a0,4
ffffffffc0203b62:	f8cfd0ef          	jal	ra,ffffffffc02012ee <alloc_pages>
ffffffffc0203b66:	4c051463          	bnez	a0,ffffffffc020402e <default_check+0x6a2>
ffffffffc0203b6a:	0889b783          	ld	a5,136(s3)
ffffffffc0203b6e:	8385                	srli	a5,a5,0x1
ffffffffc0203b70:	8b85                	andi	a5,a5,1
ffffffffc0203b72:	48078e63          	beqz	a5,ffffffffc020400e <default_check+0x682>
ffffffffc0203b76:	0909a703          	lw	a4,144(s3)
ffffffffc0203b7a:	478d                	li	a5,3
ffffffffc0203b7c:	48f71963          	bne	a4,a5,ffffffffc020400e <default_check+0x682>
ffffffffc0203b80:	450d                	li	a0,3
ffffffffc0203b82:	f6cfd0ef          	jal	ra,ffffffffc02012ee <alloc_pages>
ffffffffc0203b86:	8c2a                	mv	s8,a0
ffffffffc0203b88:	46050363          	beqz	a0,ffffffffc0203fee <default_check+0x662>
ffffffffc0203b8c:	4505                	li	a0,1
ffffffffc0203b8e:	f60fd0ef          	jal	ra,ffffffffc02012ee <alloc_pages>
ffffffffc0203b92:	42051e63          	bnez	a0,ffffffffc0203fce <default_check+0x642>
ffffffffc0203b96:	418a1c63          	bne	s4,s8,ffffffffc0203fae <default_check+0x622>
ffffffffc0203b9a:	4585                	li	a1,1
ffffffffc0203b9c:	854e                	mv	a0,s3
ffffffffc0203b9e:	f8efd0ef          	jal	ra,ffffffffc020132c <free_pages>
ffffffffc0203ba2:	458d                	li	a1,3
ffffffffc0203ba4:	8552                	mv	a0,s4
ffffffffc0203ba6:	f86fd0ef          	jal	ra,ffffffffc020132c <free_pages>
ffffffffc0203baa:	0089b783          	ld	a5,8(s3)
ffffffffc0203bae:	04098c13          	addi	s8,s3,64
ffffffffc0203bb2:	8385                	srli	a5,a5,0x1
ffffffffc0203bb4:	8b85                	andi	a5,a5,1
ffffffffc0203bb6:	3c078c63          	beqz	a5,ffffffffc0203f8e <default_check+0x602>
ffffffffc0203bba:	0109a703          	lw	a4,16(s3)
ffffffffc0203bbe:	4785                	li	a5,1
ffffffffc0203bc0:	3cf71763          	bne	a4,a5,ffffffffc0203f8e <default_check+0x602>
ffffffffc0203bc4:	008a3783          	ld	a5,8(s4) # 1008 <_binary_bin_swap_img_size-0x6cf8>
ffffffffc0203bc8:	8385                	srli	a5,a5,0x1
ffffffffc0203bca:	8b85                	andi	a5,a5,1
ffffffffc0203bcc:	3a078163          	beqz	a5,ffffffffc0203f6e <default_check+0x5e2>
ffffffffc0203bd0:	010a2703          	lw	a4,16(s4)
ffffffffc0203bd4:	478d                	li	a5,3
ffffffffc0203bd6:	38f71c63          	bne	a4,a5,ffffffffc0203f6e <default_check+0x5e2>
ffffffffc0203bda:	4505                	li	a0,1
ffffffffc0203bdc:	f12fd0ef          	jal	ra,ffffffffc02012ee <alloc_pages>
ffffffffc0203be0:	36a99763          	bne	s3,a0,ffffffffc0203f4e <default_check+0x5c2>
ffffffffc0203be4:	4585                	li	a1,1
ffffffffc0203be6:	f46fd0ef          	jal	ra,ffffffffc020132c <free_pages>
ffffffffc0203bea:	4509                	li	a0,2
ffffffffc0203bec:	f02fd0ef          	jal	ra,ffffffffc02012ee <alloc_pages>
ffffffffc0203bf0:	32aa1f63          	bne	s4,a0,ffffffffc0203f2e <default_check+0x5a2>
ffffffffc0203bf4:	4589                	li	a1,2
ffffffffc0203bf6:	f36fd0ef          	jal	ra,ffffffffc020132c <free_pages>
ffffffffc0203bfa:	4585                	li	a1,1
ffffffffc0203bfc:	8562                	mv	a0,s8
ffffffffc0203bfe:	f2efd0ef          	jal	ra,ffffffffc020132c <free_pages>
ffffffffc0203c02:	4515                	li	a0,5
ffffffffc0203c04:	eeafd0ef          	jal	ra,ffffffffc02012ee <alloc_pages>
ffffffffc0203c08:	89aa                	mv	s3,a0
ffffffffc0203c0a:	48050263          	beqz	a0,ffffffffc020408e <default_check+0x702>
ffffffffc0203c0e:	4505                	li	a0,1
ffffffffc0203c10:	edefd0ef          	jal	ra,ffffffffc02012ee <alloc_pages>
ffffffffc0203c14:	2c051d63          	bnez	a0,ffffffffc0203eee <default_check+0x562>
ffffffffc0203c18:	481c                	lw	a5,16(s0)
ffffffffc0203c1a:	2a079a63          	bnez	a5,ffffffffc0203ece <default_check+0x542>
ffffffffc0203c1e:	4595                	li	a1,5
ffffffffc0203c20:	854e                	mv	a0,s3
ffffffffc0203c22:	01742823          	sw	s7,16(s0)
ffffffffc0203c26:	01643023          	sd	s6,0(s0)
ffffffffc0203c2a:	01543423          	sd	s5,8(s0)
ffffffffc0203c2e:	efefd0ef          	jal	ra,ffffffffc020132c <free_pages>
ffffffffc0203c32:	641c                	ld	a5,8(s0)
ffffffffc0203c34:	00878963          	beq	a5,s0,ffffffffc0203c46 <default_check+0x2ba>
ffffffffc0203c38:	ff87a703          	lw	a4,-8(a5)
ffffffffc0203c3c:	679c                	ld	a5,8(a5)
ffffffffc0203c3e:	397d                	addiw	s2,s2,-1
ffffffffc0203c40:	9c99                	subw	s1,s1,a4
ffffffffc0203c42:	fe879be3          	bne	a5,s0,ffffffffc0203c38 <default_check+0x2ac>
ffffffffc0203c46:	26091463          	bnez	s2,ffffffffc0203eae <default_check+0x522>
ffffffffc0203c4a:	46049263          	bnez	s1,ffffffffc02040ae <default_check+0x722>
ffffffffc0203c4e:	60a6                	ld	ra,72(sp)
ffffffffc0203c50:	6406                	ld	s0,64(sp)
ffffffffc0203c52:	74e2                	ld	s1,56(sp)
ffffffffc0203c54:	7942                	ld	s2,48(sp)
ffffffffc0203c56:	79a2                	ld	s3,40(sp)
ffffffffc0203c58:	7a02                	ld	s4,32(sp)
ffffffffc0203c5a:	6ae2                	ld	s5,24(sp)
ffffffffc0203c5c:	6b42                	ld	s6,16(sp)
ffffffffc0203c5e:	6ba2                	ld	s7,8(sp)
ffffffffc0203c60:	6c02                	ld	s8,0(sp)
ffffffffc0203c62:	6161                	addi	sp,sp,80
ffffffffc0203c64:	8082                	ret
ffffffffc0203c66:	4981                	li	s3,0
ffffffffc0203c68:	4481                	li	s1,0
ffffffffc0203c6a:	4901                	li	s2,0
ffffffffc0203c6c:	b38d                	j	ffffffffc02039ce <default_check+0x42>
ffffffffc0203c6e:	00009697          	auipc	a3,0x9
ffffffffc0203c72:	eb268693          	addi	a3,a3,-334 # ffffffffc020cb20 <commands+0x1378>
ffffffffc0203c76:	00008617          	auipc	a2,0x8
ffffffffc0203c7a:	b9260613          	addi	a2,a2,-1134 # ffffffffc020b808 <commands+0x60>
ffffffffc0203c7e:	0ef00593          	li	a1,239
ffffffffc0203c82:	00009517          	auipc	a0,0x9
ffffffffc0203c86:	eae50513          	addi	a0,a0,-338 # ffffffffc020cb30 <commands+0x1388>
ffffffffc0203c8a:	da4fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203c8e:	00009697          	auipc	a3,0x9
ffffffffc0203c92:	f3a68693          	addi	a3,a3,-198 # ffffffffc020cbc8 <commands+0x1420>
ffffffffc0203c96:	00008617          	auipc	a2,0x8
ffffffffc0203c9a:	b7260613          	addi	a2,a2,-1166 # ffffffffc020b808 <commands+0x60>
ffffffffc0203c9e:	0bc00593          	li	a1,188
ffffffffc0203ca2:	00009517          	auipc	a0,0x9
ffffffffc0203ca6:	e8e50513          	addi	a0,a0,-370 # ffffffffc020cb30 <commands+0x1388>
ffffffffc0203caa:	d84fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203cae:	00009697          	auipc	a3,0x9
ffffffffc0203cb2:	f4268693          	addi	a3,a3,-190 # ffffffffc020cbf0 <commands+0x1448>
ffffffffc0203cb6:	00008617          	auipc	a2,0x8
ffffffffc0203cba:	b5260613          	addi	a2,a2,-1198 # ffffffffc020b808 <commands+0x60>
ffffffffc0203cbe:	0bd00593          	li	a1,189
ffffffffc0203cc2:	00009517          	auipc	a0,0x9
ffffffffc0203cc6:	e6e50513          	addi	a0,a0,-402 # ffffffffc020cb30 <commands+0x1388>
ffffffffc0203cca:	d64fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203cce:	00009697          	auipc	a3,0x9
ffffffffc0203cd2:	f6268693          	addi	a3,a3,-158 # ffffffffc020cc30 <commands+0x1488>
ffffffffc0203cd6:	00008617          	auipc	a2,0x8
ffffffffc0203cda:	b3260613          	addi	a2,a2,-1230 # ffffffffc020b808 <commands+0x60>
ffffffffc0203cde:	0bf00593          	li	a1,191
ffffffffc0203ce2:	00009517          	auipc	a0,0x9
ffffffffc0203ce6:	e4e50513          	addi	a0,a0,-434 # ffffffffc020cb30 <commands+0x1388>
ffffffffc0203cea:	d44fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203cee:	00009697          	auipc	a3,0x9
ffffffffc0203cf2:	fca68693          	addi	a3,a3,-54 # ffffffffc020ccb8 <commands+0x1510>
ffffffffc0203cf6:	00008617          	auipc	a2,0x8
ffffffffc0203cfa:	b1260613          	addi	a2,a2,-1262 # ffffffffc020b808 <commands+0x60>
ffffffffc0203cfe:	0d800593          	li	a1,216
ffffffffc0203d02:	00009517          	auipc	a0,0x9
ffffffffc0203d06:	e2e50513          	addi	a0,a0,-466 # ffffffffc020cb30 <commands+0x1388>
ffffffffc0203d0a:	d24fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203d0e:	00009697          	auipc	a3,0x9
ffffffffc0203d12:	e5a68693          	addi	a3,a3,-422 # ffffffffc020cb68 <commands+0x13c0>
ffffffffc0203d16:	00008617          	auipc	a2,0x8
ffffffffc0203d1a:	af260613          	addi	a2,a2,-1294 # ffffffffc020b808 <commands+0x60>
ffffffffc0203d1e:	0d100593          	li	a1,209
ffffffffc0203d22:	00009517          	auipc	a0,0x9
ffffffffc0203d26:	e0e50513          	addi	a0,a0,-498 # ffffffffc020cb30 <commands+0x1388>
ffffffffc0203d2a:	d04fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203d2e:	00009697          	auipc	a3,0x9
ffffffffc0203d32:	f7a68693          	addi	a3,a3,-134 # ffffffffc020cca8 <commands+0x1500>
ffffffffc0203d36:	00008617          	auipc	a2,0x8
ffffffffc0203d3a:	ad260613          	addi	a2,a2,-1326 # ffffffffc020b808 <commands+0x60>
ffffffffc0203d3e:	0cf00593          	li	a1,207
ffffffffc0203d42:	00009517          	auipc	a0,0x9
ffffffffc0203d46:	dee50513          	addi	a0,a0,-530 # ffffffffc020cb30 <commands+0x1388>
ffffffffc0203d4a:	ce4fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203d4e:	00009697          	auipc	a3,0x9
ffffffffc0203d52:	f4268693          	addi	a3,a3,-190 # ffffffffc020cc90 <commands+0x14e8>
ffffffffc0203d56:	00008617          	auipc	a2,0x8
ffffffffc0203d5a:	ab260613          	addi	a2,a2,-1358 # ffffffffc020b808 <commands+0x60>
ffffffffc0203d5e:	0ca00593          	li	a1,202
ffffffffc0203d62:	00009517          	auipc	a0,0x9
ffffffffc0203d66:	dce50513          	addi	a0,a0,-562 # ffffffffc020cb30 <commands+0x1388>
ffffffffc0203d6a:	cc4fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203d6e:	00009697          	auipc	a3,0x9
ffffffffc0203d72:	f0268693          	addi	a3,a3,-254 # ffffffffc020cc70 <commands+0x14c8>
ffffffffc0203d76:	00008617          	auipc	a2,0x8
ffffffffc0203d7a:	a9260613          	addi	a2,a2,-1390 # ffffffffc020b808 <commands+0x60>
ffffffffc0203d7e:	0c100593          	li	a1,193
ffffffffc0203d82:	00009517          	auipc	a0,0x9
ffffffffc0203d86:	dae50513          	addi	a0,a0,-594 # ffffffffc020cb30 <commands+0x1388>
ffffffffc0203d8a:	ca4fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203d8e:	00009697          	auipc	a3,0x9
ffffffffc0203d92:	f7268693          	addi	a3,a3,-142 # ffffffffc020cd00 <commands+0x1558>
ffffffffc0203d96:	00008617          	auipc	a2,0x8
ffffffffc0203d9a:	a7260613          	addi	a2,a2,-1422 # ffffffffc020b808 <commands+0x60>
ffffffffc0203d9e:	0f700593          	li	a1,247
ffffffffc0203da2:	00009517          	auipc	a0,0x9
ffffffffc0203da6:	d8e50513          	addi	a0,a0,-626 # ffffffffc020cb30 <commands+0x1388>
ffffffffc0203daa:	c84fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203dae:	00009697          	auipc	a3,0x9
ffffffffc0203db2:	f4268693          	addi	a3,a3,-190 # ffffffffc020ccf0 <commands+0x1548>
ffffffffc0203db6:	00008617          	auipc	a2,0x8
ffffffffc0203dba:	a5260613          	addi	a2,a2,-1454 # ffffffffc020b808 <commands+0x60>
ffffffffc0203dbe:	0de00593          	li	a1,222
ffffffffc0203dc2:	00009517          	auipc	a0,0x9
ffffffffc0203dc6:	d6e50513          	addi	a0,a0,-658 # ffffffffc020cb30 <commands+0x1388>
ffffffffc0203dca:	c64fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203dce:	00009697          	auipc	a3,0x9
ffffffffc0203dd2:	ec268693          	addi	a3,a3,-318 # ffffffffc020cc90 <commands+0x14e8>
ffffffffc0203dd6:	00008617          	auipc	a2,0x8
ffffffffc0203dda:	a3260613          	addi	a2,a2,-1486 # ffffffffc020b808 <commands+0x60>
ffffffffc0203dde:	0dc00593          	li	a1,220
ffffffffc0203de2:	00009517          	auipc	a0,0x9
ffffffffc0203de6:	d4e50513          	addi	a0,a0,-690 # ffffffffc020cb30 <commands+0x1388>
ffffffffc0203dea:	c44fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203dee:	00009697          	auipc	a3,0x9
ffffffffc0203df2:	ee268693          	addi	a3,a3,-286 # ffffffffc020ccd0 <commands+0x1528>
ffffffffc0203df6:	00008617          	auipc	a2,0x8
ffffffffc0203dfa:	a1260613          	addi	a2,a2,-1518 # ffffffffc020b808 <commands+0x60>
ffffffffc0203dfe:	0db00593          	li	a1,219
ffffffffc0203e02:	00009517          	auipc	a0,0x9
ffffffffc0203e06:	d2e50513          	addi	a0,a0,-722 # ffffffffc020cb30 <commands+0x1388>
ffffffffc0203e0a:	c24fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203e0e:	00009697          	auipc	a3,0x9
ffffffffc0203e12:	d5a68693          	addi	a3,a3,-678 # ffffffffc020cb68 <commands+0x13c0>
ffffffffc0203e16:	00008617          	auipc	a2,0x8
ffffffffc0203e1a:	9f260613          	addi	a2,a2,-1550 # ffffffffc020b808 <commands+0x60>
ffffffffc0203e1e:	0b800593          	li	a1,184
ffffffffc0203e22:	00009517          	auipc	a0,0x9
ffffffffc0203e26:	d0e50513          	addi	a0,a0,-754 # ffffffffc020cb30 <commands+0x1388>
ffffffffc0203e2a:	c04fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203e2e:	00009697          	auipc	a3,0x9
ffffffffc0203e32:	e6268693          	addi	a3,a3,-414 # ffffffffc020cc90 <commands+0x14e8>
ffffffffc0203e36:	00008617          	auipc	a2,0x8
ffffffffc0203e3a:	9d260613          	addi	a2,a2,-1582 # ffffffffc020b808 <commands+0x60>
ffffffffc0203e3e:	0d500593          	li	a1,213
ffffffffc0203e42:	00009517          	auipc	a0,0x9
ffffffffc0203e46:	cee50513          	addi	a0,a0,-786 # ffffffffc020cb30 <commands+0x1388>
ffffffffc0203e4a:	be4fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203e4e:	00009697          	auipc	a3,0x9
ffffffffc0203e52:	d5a68693          	addi	a3,a3,-678 # ffffffffc020cba8 <commands+0x1400>
ffffffffc0203e56:	00008617          	auipc	a2,0x8
ffffffffc0203e5a:	9b260613          	addi	a2,a2,-1614 # ffffffffc020b808 <commands+0x60>
ffffffffc0203e5e:	0d300593          	li	a1,211
ffffffffc0203e62:	00009517          	auipc	a0,0x9
ffffffffc0203e66:	cce50513          	addi	a0,a0,-818 # ffffffffc020cb30 <commands+0x1388>
ffffffffc0203e6a:	bc4fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203e6e:	00009697          	auipc	a3,0x9
ffffffffc0203e72:	d1a68693          	addi	a3,a3,-742 # ffffffffc020cb88 <commands+0x13e0>
ffffffffc0203e76:	00008617          	auipc	a2,0x8
ffffffffc0203e7a:	99260613          	addi	a2,a2,-1646 # ffffffffc020b808 <commands+0x60>
ffffffffc0203e7e:	0d200593          	li	a1,210
ffffffffc0203e82:	00009517          	auipc	a0,0x9
ffffffffc0203e86:	cae50513          	addi	a0,a0,-850 # ffffffffc020cb30 <commands+0x1388>
ffffffffc0203e8a:	ba4fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203e8e:	00009697          	auipc	a3,0x9
ffffffffc0203e92:	d1a68693          	addi	a3,a3,-742 # ffffffffc020cba8 <commands+0x1400>
ffffffffc0203e96:	00008617          	auipc	a2,0x8
ffffffffc0203e9a:	97260613          	addi	a2,a2,-1678 # ffffffffc020b808 <commands+0x60>
ffffffffc0203e9e:	0ba00593          	li	a1,186
ffffffffc0203ea2:	00009517          	auipc	a0,0x9
ffffffffc0203ea6:	c8e50513          	addi	a0,a0,-882 # ffffffffc020cb30 <commands+0x1388>
ffffffffc0203eaa:	b84fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203eae:	00009697          	auipc	a3,0x9
ffffffffc0203eb2:	fa268693          	addi	a3,a3,-94 # ffffffffc020ce50 <commands+0x16a8>
ffffffffc0203eb6:	00008617          	auipc	a2,0x8
ffffffffc0203eba:	95260613          	addi	a2,a2,-1710 # ffffffffc020b808 <commands+0x60>
ffffffffc0203ebe:	12400593          	li	a1,292
ffffffffc0203ec2:	00009517          	auipc	a0,0x9
ffffffffc0203ec6:	c6e50513          	addi	a0,a0,-914 # ffffffffc020cb30 <commands+0x1388>
ffffffffc0203eca:	b64fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203ece:	00009697          	auipc	a3,0x9
ffffffffc0203ed2:	e2268693          	addi	a3,a3,-478 # ffffffffc020ccf0 <commands+0x1548>
ffffffffc0203ed6:	00008617          	auipc	a2,0x8
ffffffffc0203eda:	93260613          	addi	a2,a2,-1742 # ffffffffc020b808 <commands+0x60>
ffffffffc0203ede:	11900593          	li	a1,281
ffffffffc0203ee2:	00009517          	auipc	a0,0x9
ffffffffc0203ee6:	c4e50513          	addi	a0,a0,-946 # ffffffffc020cb30 <commands+0x1388>
ffffffffc0203eea:	b44fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203eee:	00009697          	auipc	a3,0x9
ffffffffc0203ef2:	da268693          	addi	a3,a3,-606 # ffffffffc020cc90 <commands+0x14e8>
ffffffffc0203ef6:	00008617          	auipc	a2,0x8
ffffffffc0203efa:	91260613          	addi	a2,a2,-1774 # ffffffffc020b808 <commands+0x60>
ffffffffc0203efe:	11700593          	li	a1,279
ffffffffc0203f02:	00009517          	auipc	a0,0x9
ffffffffc0203f06:	c2e50513          	addi	a0,a0,-978 # ffffffffc020cb30 <commands+0x1388>
ffffffffc0203f0a:	b24fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203f0e:	00009697          	auipc	a3,0x9
ffffffffc0203f12:	d4268693          	addi	a3,a3,-702 # ffffffffc020cc50 <commands+0x14a8>
ffffffffc0203f16:	00008617          	auipc	a2,0x8
ffffffffc0203f1a:	8f260613          	addi	a2,a2,-1806 # ffffffffc020b808 <commands+0x60>
ffffffffc0203f1e:	0c000593          	li	a1,192
ffffffffc0203f22:	00009517          	auipc	a0,0x9
ffffffffc0203f26:	c0e50513          	addi	a0,a0,-1010 # ffffffffc020cb30 <commands+0x1388>
ffffffffc0203f2a:	b04fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203f2e:	00009697          	auipc	a3,0x9
ffffffffc0203f32:	ee268693          	addi	a3,a3,-286 # ffffffffc020ce10 <commands+0x1668>
ffffffffc0203f36:	00008617          	auipc	a2,0x8
ffffffffc0203f3a:	8d260613          	addi	a2,a2,-1838 # ffffffffc020b808 <commands+0x60>
ffffffffc0203f3e:	11100593          	li	a1,273
ffffffffc0203f42:	00009517          	auipc	a0,0x9
ffffffffc0203f46:	bee50513          	addi	a0,a0,-1042 # ffffffffc020cb30 <commands+0x1388>
ffffffffc0203f4a:	ae4fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203f4e:	00009697          	auipc	a3,0x9
ffffffffc0203f52:	ea268693          	addi	a3,a3,-350 # ffffffffc020cdf0 <commands+0x1648>
ffffffffc0203f56:	00008617          	auipc	a2,0x8
ffffffffc0203f5a:	8b260613          	addi	a2,a2,-1870 # ffffffffc020b808 <commands+0x60>
ffffffffc0203f5e:	10f00593          	li	a1,271
ffffffffc0203f62:	00009517          	auipc	a0,0x9
ffffffffc0203f66:	bce50513          	addi	a0,a0,-1074 # ffffffffc020cb30 <commands+0x1388>
ffffffffc0203f6a:	ac4fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203f6e:	00009697          	auipc	a3,0x9
ffffffffc0203f72:	e5a68693          	addi	a3,a3,-422 # ffffffffc020cdc8 <commands+0x1620>
ffffffffc0203f76:	00008617          	auipc	a2,0x8
ffffffffc0203f7a:	89260613          	addi	a2,a2,-1902 # ffffffffc020b808 <commands+0x60>
ffffffffc0203f7e:	10d00593          	li	a1,269
ffffffffc0203f82:	00009517          	auipc	a0,0x9
ffffffffc0203f86:	bae50513          	addi	a0,a0,-1106 # ffffffffc020cb30 <commands+0x1388>
ffffffffc0203f8a:	aa4fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203f8e:	00009697          	auipc	a3,0x9
ffffffffc0203f92:	e1268693          	addi	a3,a3,-494 # ffffffffc020cda0 <commands+0x15f8>
ffffffffc0203f96:	00008617          	auipc	a2,0x8
ffffffffc0203f9a:	87260613          	addi	a2,a2,-1934 # ffffffffc020b808 <commands+0x60>
ffffffffc0203f9e:	10c00593          	li	a1,268
ffffffffc0203fa2:	00009517          	auipc	a0,0x9
ffffffffc0203fa6:	b8e50513          	addi	a0,a0,-1138 # ffffffffc020cb30 <commands+0x1388>
ffffffffc0203faa:	a84fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203fae:	00009697          	auipc	a3,0x9
ffffffffc0203fb2:	de268693          	addi	a3,a3,-542 # ffffffffc020cd90 <commands+0x15e8>
ffffffffc0203fb6:	00008617          	auipc	a2,0x8
ffffffffc0203fba:	85260613          	addi	a2,a2,-1966 # ffffffffc020b808 <commands+0x60>
ffffffffc0203fbe:	10700593          	li	a1,263
ffffffffc0203fc2:	00009517          	auipc	a0,0x9
ffffffffc0203fc6:	b6e50513          	addi	a0,a0,-1170 # ffffffffc020cb30 <commands+0x1388>
ffffffffc0203fca:	a64fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203fce:	00009697          	auipc	a3,0x9
ffffffffc0203fd2:	cc268693          	addi	a3,a3,-830 # ffffffffc020cc90 <commands+0x14e8>
ffffffffc0203fd6:	00008617          	auipc	a2,0x8
ffffffffc0203fda:	83260613          	addi	a2,a2,-1998 # ffffffffc020b808 <commands+0x60>
ffffffffc0203fde:	10600593          	li	a1,262
ffffffffc0203fe2:	00009517          	auipc	a0,0x9
ffffffffc0203fe6:	b4e50513          	addi	a0,a0,-1202 # ffffffffc020cb30 <commands+0x1388>
ffffffffc0203fea:	a44fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0203fee:	00009697          	auipc	a3,0x9
ffffffffc0203ff2:	d8268693          	addi	a3,a3,-638 # ffffffffc020cd70 <commands+0x15c8>
ffffffffc0203ff6:	00008617          	auipc	a2,0x8
ffffffffc0203ffa:	81260613          	addi	a2,a2,-2030 # ffffffffc020b808 <commands+0x60>
ffffffffc0203ffe:	10500593          	li	a1,261
ffffffffc0204002:	00009517          	auipc	a0,0x9
ffffffffc0204006:	b2e50513          	addi	a0,a0,-1234 # ffffffffc020cb30 <commands+0x1388>
ffffffffc020400a:	a24fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020400e:	00009697          	auipc	a3,0x9
ffffffffc0204012:	d3268693          	addi	a3,a3,-718 # ffffffffc020cd40 <commands+0x1598>
ffffffffc0204016:	00007617          	auipc	a2,0x7
ffffffffc020401a:	7f260613          	addi	a2,a2,2034 # ffffffffc020b808 <commands+0x60>
ffffffffc020401e:	10400593          	li	a1,260
ffffffffc0204022:	00009517          	auipc	a0,0x9
ffffffffc0204026:	b0e50513          	addi	a0,a0,-1266 # ffffffffc020cb30 <commands+0x1388>
ffffffffc020402a:	a04fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020402e:	00009697          	auipc	a3,0x9
ffffffffc0204032:	cfa68693          	addi	a3,a3,-774 # ffffffffc020cd28 <commands+0x1580>
ffffffffc0204036:	00007617          	auipc	a2,0x7
ffffffffc020403a:	7d260613          	addi	a2,a2,2002 # ffffffffc020b808 <commands+0x60>
ffffffffc020403e:	10300593          	li	a1,259
ffffffffc0204042:	00009517          	auipc	a0,0x9
ffffffffc0204046:	aee50513          	addi	a0,a0,-1298 # ffffffffc020cb30 <commands+0x1388>
ffffffffc020404a:	9e4fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020404e:	00009697          	auipc	a3,0x9
ffffffffc0204052:	c4268693          	addi	a3,a3,-958 # ffffffffc020cc90 <commands+0x14e8>
ffffffffc0204056:	00007617          	auipc	a2,0x7
ffffffffc020405a:	7b260613          	addi	a2,a2,1970 # ffffffffc020b808 <commands+0x60>
ffffffffc020405e:	0fd00593          	li	a1,253
ffffffffc0204062:	00009517          	auipc	a0,0x9
ffffffffc0204066:	ace50513          	addi	a0,a0,-1330 # ffffffffc020cb30 <commands+0x1388>
ffffffffc020406a:	9c4fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020406e:	00009697          	auipc	a3,0x9
ffffffffc0204072:	ca268693          	addi	a3,a3,-862 # ffffffffc020cd10 <commands+0x1568>
ffffffffc0204076:	00007617          	auipc	a2,0x7
ffffffffc020407a:	79260613          	addi	a2,a2,1938 # ffffffffc020b808 <commands+0x60>
ffffffffc020407e:	0f800593          	li	a1,248
ffffffffc0204082:	00009517          	auipc	a0,0x9
ffffffffc0204086:	aae50513          	addi	a0,a0,-1362 # ffffffffc020cb30 <commands+0x1388>
ffffffffc020408a:	9a4fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020408e:	00009697          	auipc	a3,0x9
ffffffffc0204092:	da268693          	addi	a3,a3,-606 # ffffffffc020ce30 <commands+0x1688>
ffffffffc0204096:	00007617          	auipc	a2,0x7
ffffffffc020409a:	77260613          	addi	a2,a2,1906 # ffffffffc020b808 <commands+0x60>
ffffffffc020409e:	11600593          	li	a1,278
ffffffffc02040a2:	00009517          	auipc	a0,0x9
ffffffffc02040a6:	a8e50513          	addi	a0,a0,-1394 # ffffffffc020cb30 <commands+0x1388>
ffffffffc02040aa:	984fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02040ae:	00009697          	auipc	a3,0x9
ffffffffc02040b2:	db268693          	addi	a3,a3,-590 # ffffffffc020ce60 <commands+0x16b8>
ffffffffc02040b6:	00007617          	auipc	a2,0x7
ffffffffc02040ba:	75260613          	addi	a2,a2,1874 # ffffffffc020b808 <commands+0x60>
ffffffffc02040be:	12500593          	li	a1,293
ffffffffc02040c2:	00009517          	auipc	a0,0x9
ffffffffc02040c6:	a6e50513          	addi	a0,a0,-1426 # ffffffffc020cb30 <commands+0x1388>
ffffffffc02040ca:	964fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02040ce:	00009697          	auipc	a3,0x9
ffffffffc02040d2:	a7a68693          	addi	a3,a3,-1414 # ffffffffc020cb48 <commands+0x13a0>
ffffffffc02040d6:	00007617          	auipc	a2,0x7
ffffffffc02040da:	73260613          	addi	a2,a2,1842 # ffffffffc020b808 <commands+0x60>
ffffffffc02040de:	0f200593          	li	a1,242
ffffffffc02040e2:	00009517          	auipc	a0,0x9
ffffffffc02040e6:	a4e50513          	addi	a0,a0,-1458 # ffffffffc020cb30 <commands+0x1388>
ffffffffc02040ea:	944fc0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02040ee:	00009697          	auipc	a3,0x9
ffffffffc02040f2:	a9a68693          	addi	a3,a3,-1382 # ffffffffc020cb88 <commands+0x13e0>
ffffffffc02040f6:	00007617          	auipc	a2,0x7
ffffffffc02040fa:	71260613          	addi	a2,a2,1810 # ffffffffc020b808 <commands+0x60>
ffffffffc02040fe:	0b900593          	li	a1,185
ffffffffc0204102:	00009517          	auipc	a0,0x9
ffffffffc0204106:	a2e50513          	addi	a0,a0,-1490 # ffffffffc020cb30 <commands+0x1388>
ffffffffc020410a:	924fc0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020410e <default_free_pages>:
ffffffffc020410e:	1141                	addi	sp,sp,-16
ffffffffc0204110:	e406                	sd	ra,8(sp)
ffffffffc0204112:	14058463          	beqz	a1,ffffffffc020425a <default_free_pages+0x14c>
ffffffffc0204116:	00659693          	slli	a3,a1,0x6
ffffffffc020411a:	96aa                	add	a3,a3,a0
ffffffffc020411c:	87aa                	mv	a5,a0
ffffffffc020411e:	02d50263          	beq	a0,a3,ffffffffc0204142 <default_free_pages+0x34>
ffffffffc0204122:	6798                	ld	a4,8(a5)
ffffffffc0204124:	8b05                	andi	a4,a4,1
ffffffffc0204126:	10071a63          	bnez	a4,ffffffffc020423a <default_free_pages+0x12c>
ffffffffc020412a:	6798                	ld	a4,8(a5)
ffffffffc020412c:	8b09                	andi	a4,a4,2
ffffffffc020412e:	10071663          	bnez	a4,ffffffffc020423a <default_free_pages+0x12c>
ffffffffc0204132:	0007b423          	sd	zero,8(a5)
ffffffffc0204136:	0007a023          	sw	zero,0(a5)
ffffffffc020413a:	04078793          	addi	a5,a5,64
ffffffffc020413e:	fed792e3          	bne	a5,a3,ffffffffc0204122 <default_free_pages+0x14>
ffffffffc0204142:	2581                	sext.w	a1,a1
ffffffffc0204144:	c90c                	sw	a1,16(a0)
ffffffffc0204146:	00850893          	addi	a7,a0,8
ffffffffc020414a:	4789                	li	a5,2
ffffffffc020414c:	40f8b02f          	amoor.d	zero,a5,(a7)
ffffffffc0204150:	0008d697          	auipc	a3,0x8d
ffffffffc0204154:	65868693          	addi	a3,a3,1624 # ffffffffc02917a8 <free_area>
ffffffffc0204158:	4a98                	lw	a4,16(a3)
ffffffffc020415a:	669c                	ld	a5,8(a3)
ffffffffc020415c:	01850613          	addi	a2,a0,24
ffffffffc0204160:	9db9                	addw	a1,a1,a4
ffffffffc0204162:	ca8c                	sw	a1,16(a3)
ffffffffc0204164:	0ad78463          	beq	a5,a3,ffffffffc020420c <default_free_pages+0xfe>
ffffffffc0204168:	fe878713          	addi	a4,a5,-24
ffffffffc020416c:	0006b803          	ld	a6,0(a3)
ffffffffc0204170:	4581                	li	a1,0
ffffffffc0204172:	00e56a63          	bltu	a0,a4,ffffffffc0204186 <default_free_pages+0x78>
ffffffffc0204176:	6798                	ld	a4,8(a5)
ffffffffc0204178:	04d70c63          	beq	a4,a3,ffffffffc02041d0 <default_free_pages+0xc2>
ffffffffc020417c:	87ba                	mv	a5,a4
ffffffffc020417e:	fe878713          	addi	a4,a5,-24
ffffffffc0204182:	fee57ae3          	bgeu	a0,a4,ffffffffc0204176 <default_free_pages+0x68>
ffffffffc0204186:	c199                	beqz	a1,ffffffffc020418c <default_free_pages+0x7e>
ffffffffc0204188:	0106b023          	sd	a6,0(a3)
ffffffffc020418c:	6398                	ld	a4,0(a5)
ffffffffc020418e:	e390                	sd	a2,0(a5)
ffffffffc0204190:	e710                	sd	a2,8(a4)
ffffffffc0204192:	f11c                	sd	a5,32(a0)
ffffffffc0204194:	ed18                	sd	a4,24(a0)
ffffffffc0204196:	00d70d63          	beq	a4,a3,ffffffffc02041b0 <default_free_pages+0xa2>
ffffffffc020419a:	ff872583          	lw	a1,-8(a4) # ff8 <_binary_bin_swap_img_size-0x6d08>
ffffffffc020419e:	fe870613          	addi	a2,a4,-24
ffffffffc02041a2:	02059813          	slli	a6,a1,0x20
ffffffffc02041a6:	01a85793          	srli	a5,a6,0x1a
ffffffffc02041aa:	97b2                	add	a5,a5,a2
ffffffffc02041ac:	02f50c63          	beq	a0,a5,ffffffffc02041e4 <default_free_pages+0xd6>
ffffffffc02041b0:	711c                	ld	a5,32(a0)
ffffffffc02041b2:	00d78c63          	beq	a5,a3,ffffffffc02041ca <default_free_pages+0xbc>
ffffffffc02041b6:	4910                	lw	a2,16(a0)
ffffffffc02041b8:	fe878693          	addi	a3,a5,-24
ffffffffc02041bc:	02061593          	slli	a1,a2,0x20
ffffffffc02041c0:	01a5d713          	srli	a4,a1,0x1a
ffffffffc02041c4:	972a                	add	a4,a4,a0
ffffffffc02041c6:	04e68a63          	beq	a3,a4,ffffffffc020421a <default_free_pages+0x10c>
ffffffffc02041ca:	60a2                	ld	ra,8(sp)
ffffffffc02041cc:	0141                	addi	sp,sp,16
ffffffffc02041ce:	8082                	ret
ffffffffc02041d0:	e790                	sd	a2,8(a5)
ffffffffc02041d2:	f114                	sd	a3,32(a0)
ffffffffc02041d4:	6798                	ld	a4,8(a5)
ffffffffc02041d6:	ed1c                	sd	a5,24(a0)
ffffffffc02041d8:	02d70763          	beq	a4,a3,ffffffffc0204206 <default_free_pages+0xf8>
ffffffffc02041dc:	8832                	mv	a6,a2
ffffffffc02041de:	4585                	li	a1,1
ffffffffc02041e0:	87ba                	mv	a5,a4
ffffffffc02041e2:	bf71                	j	ffffffffc020417e <default_free_pages+0x70>
ffffffffc02041e4:	491c                	lw	a5,16(a0)
ffffffffc02041e6:	9dbd                	addw	a1,a1,a5
ffffffffc02041e8:	feb72c23          	sw	a1,-8(a4)
ffffffffc02041ec:	57f5                	li	a5,-3
ffffffffc02041ee:	60f8b02f          	amoand.d	zero,a5,(a7)
ffffffffc02041f2:	01853803          	ld	a6,24(a0)
ffffffffc02041f6:	710c                	ld	a1,32(a0)
ffffffffc02041f8:	8532                	mv	a0,a2
ffffffffc02041fa:	00b83423          	sd	a1,8(a6)
ffffffffc02041fe:	671c                	ld	a5,8(a4)
ffffffffc0204200:	0105b023          	sd	a6,0(a1) # 1000 <_binary_bin_swap_img_size-0x6d00>
ffffffffc0204204:	b77d                	j	ffffffffc02041b2 <default_free_pages+0xa4>
ffffffffc0204206:	e290                	sd	a2,0(a3)
ffffffffc0204208:	873e                	mv	a4,a5
ffffffffc020420a:	bf41                	j	ffffffffc020419a <default_free_pages+0x8c>
ffffffffc020420c:	60a2                	ld	ra,8(sp)
ffffffffc020420e:	e390                	sd	a2,0(a5)
ffffffffc0204210:	e790                	sd	a2,8(a5)
ffffffffc0204212:	f11c                	sd	a5,32(a0)
ffffffffc0204214:	ed1c                	sd	a5,24(a0)
ffffffffc0204216:	0141                	addi	sp,sp,16
ffffffffc0204218:	8082                	ret
ffffffffc020421a:	ff87a703          	lw	a4,-8(a5)
ffffffffc020421e:	ff078693          	addi	a3,a5,-16
ffffffffc0204222:	9e39                	addw	a2,a2,a4
ffffffffc0204224:	c910                	sw	a2,16(a0)
ffffffffc0204226:	5775                	li	a4,-3
ffffffffc0204228:	60e6b02f          	amoand.d	zero,a4,(a3)
ffffffffc020422c:	6398                	ld	a4,0(a5)
ffffffffc020422e:	679c                	ld	a5,8(a5)
ffffffffc0204230:	60a2                	ld	ra,8(sp)
ffffffffc0204232:	e71c                	sd	a5,8(a4)
ffffffffc0204234:	e398                	sd	a4,0(a5)
ffffffffc0204236:	0141                	addi	sp,sp,16
ffffffffc0204238:	8082                	ret
ffffffffc020423a:	00009697          	auipc	a3,0x9
ffffffffc020423e:	c3e68693          	addi	a3,a3,-962 # ffffffffc020ce78 <commands+0x16d0>
ffffffffc0204242:	00007617          	auipc	a2,0x7
ffffffffc0204246:	5c660613          	addi	a2,a2,1478 # ffffffffc020b808 <commands+0x60>
ffffffffc020424a:	08200593          	li	a1,130
ffffffffc020424e:	00009517          	auipc	a0,0x9
ffffffffc0204252:	8e250513          	addi	a0,a0,-1822 # ffffffffc020cb30 <commands+0x1388>
ffffffffc0204256:	fd9fb0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020425a:	00009697          	auipc	a3,0x9
ffffffffc020425e:	c1668693          	addi	a3,a3,-1002 # ffffffffc020ce70 <commands+0x16c8>
ffffffffc0204262:	00007617          	auipc	a2,0x7
ffffffffc0204266:	5a660613          	addi	a2,a2,1446 # ffffffffc020b808 <commands+0x60>
ffffffffc020426a:	07f00593          	li	a1,127
ffffffffc020426e:	00009517          	auipc	a0,0x9
ffffffffc0204272:	8c250513          	addi	a0,a0,-1854 # ffffffffc020cb30 <commands+0x1388>
ffffffffc0204276:	fb9fb0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020427a <default_alloc_pages>:
ffffffffc020427a:	c941                	beqz	a0,ffffffffc020430a <default_alloc_pages+0x90>
ffffffffc020427c:	0008d597          	auipc	a1,0x8d
ffffffffc0204280:	52c58593          	addi	a1,a1,1324 # ffffffffc02917a8 <free_area>
ffffffffc0204284:	0105a803          	lw	a6,16(a1)
ffffffffc0204288:	872a                	mv	a4,a0
ffffffffc020428a:	02081793          	slli	a5,a6,0x20
ffffffffc020428e:	9381                	srli	a5,a5,0x20
ffffffffc0204290:	00a7ee63          	bltu	a5,a0,ffffffffc02042ac <default_alloc_pages+0x32>
ffffffffc0204294:	87ae                	mv	a5,a1
ffffffffc0204296:	a801                	j	ffffffffc02042a6 <default_alloc_pages+0x2c>
ffffffffc0204298:	ff87a683          	lw	a3,-8(a5)
ffffffffc020429c:	02069613          	slli	a2,a3,0x20
ffffffffc02042a0:	9201                	srli	a2,a2,0x20
ffffffffc02042a2:	00e67763          	bgeu	a2,a4,ffffffffc02042b0 <default_alloc_pages+0x36>
ffffffffc02042a6:	679c                	ld	a5,8(a5)
ffffffffc02042a8:	feb798e3          	bne	a5,a1,ffffffffc0204298 <default_alloc_pages+0x1e>
ffffffffc02042ac:	4501                	li	a0,0
ffffffffc02042ae:	8082                	ret
ffffffffc02042b0:	0007b883          	ld	a7,0(a5)
ffffffffc02042b4:	0087b303          	ld	t1,8(a5)
ffffffffc02042b8:	fe878513          	addi	a0,a5,-24
ffffffffc02042bc:	00070e1b          	sext.w	t3,a4
ffffffffc02042c0:	0068b423          	sd	t1,8(a7) # 1008 <_binary_bin_swap_img_size-0x6cf8>
ffffffffc02042c4:	01133023          	sd	a7,0(t1) # 80000 <_binary_bin_sfs_img_size+0xad00>
ffffffffc02042c8:	02c77863          	bgeu	a4,a2,ffffffffc02042f8 <default_alloc_pages+0x7e>
ffffffffc02042cc:	071a                	slli	a4,a4,0x6
ffffffffc02042ce:	972a                	add	a4,a4,a0
ffffffffc02042d0:	41c686bb          	subw	a3,a3,t3
ffffffffc02042d4:	cb14                	sw	a3,16(a4)
ffffffffc02042d6:	00870613          	addi	a2,a4,8
ffffffffc02042da:	4689                	li	a3,2
ffffffffc02042dc:	40d6302f          	amoor.d	zero,a3,(a2)
ffffffffc02042e0:	0088b683          	ld	a3,8(a7)
ffffffffc02042e4:	01870613          	addi	a2,a4,24
ffffffffc02042e8:	0105a803          	lw	a6,16(a1)
ffffffffc02042ec:	e290                	sd	a2,0(a3)
ffffffffc02042ee:	00c8b423          	sd	a2,8(a7)
ffffffffc02042f2:	f314                	sd	a3,32(a4)
ffffffffc02042f4:	01173c23          	sd	a7,24(a4)
ffffffffc02042f8:	41c8083b          	subw	a6,a6,t3
ffffffffc02042fc:	0105a823          	sw	a6,16(a1)
ffffffffc0204300:	5775                	li	a4,-3
ffffffffc0204302:	17c1                	addi	a5,a5,-16
ffffffffc0204304:	60e7b02f          	amoand.d	zero,a4,(a5)
ffffffffc0204308:	8082                	ret
ffffffffc020430a:	1141                	addi	sp,sp,-16
ffffffffc020430c:	00009697          	auipc	a3,0x9
ffffffffc0204310:	b6468693          	addi	a3,a3,-1180 # ffffffffc020ce70 <commands+0x16c8>
ffffffffc0204314:	00007617          	auipc	a2,0x7
ffffffffc0204318:	4f460613          	addi	a2,a2,1268 # ffffffffc020b808 <commands+0x60>
ffffffffc020431c:	06100593          	li	a1,97
ffffffffc0204320:	00009517          	auipc	a0,0x9
ffffffffc0204324:	81050513          	addi	a0,a0,-2032 # ffffffffc020cb30 <commands+0x1388>
ffffffffc0204328:	e406                	sd	ra,8(sp)
ffffffffc020432a:	f05fb0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020432e <default_init_memmap>:
ffffffffc020432e:	1141                	addi	sp,sp,-16
ffffffffc0204330:	e406                	sd	ra,8(sp)
ffffffffc0204332:	c5f1                	beqz	a1,ffffffffc02043fe <default_init_memmap+0xd0>
ffffffffc0204334:	00659693          	slli	a3,a1,0x6
ffffffffc0204338:	96aa                	add	a3,a3,a0
ffffffffc020433a:	87aa                	mv	a5,a0
ffffffffc020433c:	00d50f63          	beq	a0,a3,ffffffffc020435a <default_init_memmap+0x2c>
ffffffffc0204340:	6798                	ld	a4,8(a5)
ffffffffc0204342:	8b05                	andi	a4,a4,1
ffffffffc0204344:	cf49                	beqz	a4,ffffffffc02043de <default_init_memmap+0xb0>
ffffffffc0204346:	0007a823          	sw	zero,16(a5)
ffffffffc020434a:	0007b423          	sd	zero,8(a5)
ffffffffc020434e:	0007a023          	sw	zero,0(a5)
ffffffffc0204352:	04078793          	addi	a5,a5,64
ffffffffc0204356:	fed795e3          	bne	a5,a3,ffffffffc0204340 <default_init_memmap+0x12>
ffffffffc020435a:	2581                	sext.w	a1,a1
ffffffffc020435c:	c90c                	sw	a1,16(a0)
ffffffffc020435e:	4789                	li	a5,2
ffffffffc0204360:	00850713          	addi	a4,a0,8
ffffffffc0204364:	40f7302f          	amoor.d	zero,a5,(a4)
ffffffffc0204368:	0008d697          	auipc	a3,0x8d
ffffffffc020436c:	44068693          	addi	a3,a3,1088 # ffffffffc02917a8 <free_area>
ffffffffc0204370:	4a98                	lw	a4,16(a3)
ffffffffc0204372:	669c                	ld	a5,8(a3)
ffffffffc0204374:	01850613          	addi	a2,a0,24
ffffffffc0204378:	9db9                	addw	a1,a1,a4
ffffffffc020437a:	ca8c                	sw	a1,16(a3)
ffffffffc020437c:	04d78a63          	beq	a5,a3,ffffffffc02043d0 <default_init_memmap+0xa2>
ffffffffc0204380:	fe878713          	addi	a4,a5,-24
ffffffffc0204384:	0006b803          	ld	a6,0(a3)
ffffffffc0204388:	4581                	li	a1,0
ffffffffc020438a:	00e56a63          	bltu	a0,a4,ffffffffc020439e <default_init_memmap+0x70>
ffffffffc020438e:	6798                	ld	a4,8(a5)
ffffffffc0204390:	02d70263          	beq	a4,a3,ffffffffc02043b4 <default_init_memmap+0x86>
ffffffffc0204394:	87ba                	mv	a5,a4
ffffffffc0204396:	fe878713          	addi	a4,a5,-24
ffffffffc020439a:	fee57ae3          	bgeu	a0,a4,ffffffffc020438e <default_init_memmap+0x60>
ffffffffc020439e:	c199                	beqz	a1,ffffffffc02043a4 <default_init_memmap+0x76>
ffffffffc02043a0:	0106b023          	sd	a6,0(a3)
ffffffffc02043a4:	6398                	ld	a4,0(a5)
ffffffffc02043a6:	60a2                	ld	ra,8(sp)
ffffffffc02043a8:	e390                	sd	a2,0(a5)
ffffffffc02043aa:	e710                	sd	a2,8(a4)
ffffffffc02043ac:	f11c                	sd	a5,32(a0)
ffffffffc02043ae:	ed18                	sd	a4,24(a0)
ffffffffc02043b0:	0141                	addi	sp,sp,16
ffffffffc02043b2:	8082                	ret
ffffffffc02043b4:	e790                	sd	a2,8(a5)
ffffffffc02043b6:	f114                	sd	a3,32(a0)
ffffffffc02043b8:	6798                	ld	a4,8(a5)
ffffffffc02043ba:	ed1c                	sd	a5,24(a0)
ffffffffc02043bc:	00d70663          	beq	a4,a3,ffffffffc02043c8 <default_init_memmap+0x9a>
ffffffffc02043c0:	8832                	mv	a6,a2
ffffffffc02043c2:	4585                	li	a1,1
ffffffffc02043c4:	87ba                	mv	a5,a4
ffffffffc02043c6:	bfc1                	j	ffffffffc0204396 <default_init_memmap+0x68>
ffffffffc02043c8:	60a2                	ld	ra,8(sp)
ffffffffc02043ca:	e290                	sd	a2,0(a3)
ffffffffc02043cc:	0141                	addi	sp,sp,16
ffffffffc02043ce:	8082                	ret
ffffffffc02043d0:	60a2                	ld	ra,8(sp)
ffffffffc02043d2:	e390                	sd	a2,0(a5)
ffffffffc02043d4:	e790                	sd	a2,8(a5)
ffffffffc02043d6:	f11c                	sd	a5,32(a0)
ffffffffc02043d8:	ed1c                	sd	a5,24(a0)
ffffffffc02043da:	0141                	addi	sp,sp,16
ffffffffc02043dc:	8082                	ret
ffffffffc02043de:	00009697          	auipc	a3,0x9
ffffffffc02043e2:	ac268693          	addi	a3,a3,-1342 # ffffffffc020cea0 <commands+0x16f8>
ffffffffc02043e6:	00007617          	auipc	a2,0x7
ffffffffc02043ea:	42260613          	addi	a2,a2,1058 # ffffffffc020b808 <commands+0x60>
ffffffffc02043ee:	04800593          	li	a1,72
ffffffffc02043f2:	00008517          	auipc	a0,0x8
ffffffffc02043f6:	73e50513          	addi	a0,a0,1854 # ffffffffc020cb30 <commands+0x1388>
ffffffffc02043fa:	e35fb0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02043fe:	00009697          	auipc	a3,0x9
ffffffffc0204402:	a7268693          	addi	a3,a3,-1422 # ffffffffc020ce70 <commands+0x16c8>
ffffffffc0204406:	00007617          	auipc	a2,0x7
ffffffffc020440a:	40260613          	addi	a2,a2,1026 # ffffffffc020b808 <commands+0x60>
ffffffffc020440e:	04500593          	li	a1,69
ffffffffc0204412:	00008517          	auipc	a0,0x8
ffffffffc0204416:	71e50513          	addi	a0,a0,1822 # ffffffffc020cb30 <commands+0x1388>
ffffffffc020441a:	e15fb0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020441e <wait_queue_init>:
ffffffffc020441e:	e508                	sd	a0,8(a0)
ffffffffc0204420:	e108                	sd	a0,0(a0)
ffffffffc0204422:	8082                	ret

ffffffffc0204424 <wait_queue_del>:
ffffffffc0204424:	7198                	ld	a4,32(a1)
ffffffffc0204426:	01858793          	addi	a5,a1,24
ffffffffc020442a:	00e78b63          	beq	a5,a4,ffffffffc0204440 <wait_queue_del+0x1c>
ffffffffc020442e:	6994                	ld	a3,16(a1)
ffffffffc0204430:	00a69863          	bne	a3,a0,ffffffffc0204440 <wait_queue_del+0x1c>
ffffffffc0204434:	6d94                	ld	a3,24(a1)
ffffffffc0204436:	e698                	sd	a4,8(a3)
ffffffffc0204438:	e314                	sd	a3,0(a4)
ffffffffc020443a:	f19c                	sd	a5,32(a1)
ffffffffc020443c:	ed9c                	sd	a5,24(a1)
ffffffffc020443e:	8082                	ret
ffffffffc0204440:	1141                	addi	sp,sp,-16
ffffffffc0204442:	00009697          	auipc	a3,0x9
ffffffffc0204446:	b0e68693          	addi	a3,a3,-1266 # ffffffffc020cf50 <default_pmm_manager+0x88>
ffffffffc020444a:	00007617          	auipc	a2,0x7
ffffffffc020444e:	3be60613          	addi	a2,a2,958 # ffffffffc020b808 <commands+0x60>
ffffffffc0204452:	45f1                	li	a1,28
ffffffffc0204454:	00009517          	auipc	a0,0x9
ffffffffc0204458:	ae450513          	addi	a0,a0,-1308 # ffffffffc020cf38 <default_pmm_manager+0x70>
ffffffffc020445c:	e406                	sd	ra,8(sp)
ffffffffc020445e:	dd1fb0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0204462 <wait_queue_first>:
ffffffffc0204462:	651c                	ld	a5,8(a0)
ffffffffc0204464:	00f50563          	beq	a0,a5,ffffffffc020446e <wait_queue_first+0xc>
ffffffffc0204468:	fe878513          	addi	a0,a5,-24
ffffffffc020446c:	8082                	ret
ffffffffc020446e:	4501                	li	a0,0
ffffffffc0204470:	8082                	ret

ffffffffc0204472 <wait_queue_empty>:
ffffffffc0204472:	651c                	ld	a5,8(a0)
ffffffffc0204474:	40a78533          	sub	a0,a5,a0
ffffffffc0204478:	00153513          	seqz	a0,a0
ffffffffc020447c:	8082                	ret

ffffffffc020447e <wait_in_queue>:
ffffffffc020447e:	711c                	ld	a5,32(a0)
ffffffffc0204480:	0561                	addi	a0,a0,24
ffffffffc0204482:	40a78533          	sub	a0,a5,a0
ffffffffc0204486:	00a03533          	snez	a0,a0
ffffffffc020448a:	8082                	ret

ffffffffc020448c <wakeup_wait>:
ffffffffc020448c:	e689                	bnez	a3,ffffffffc0204496 <wakeup_wait+0xa>
ffffffffc020448e:	6188                	ld	a0,0(a1)
ffffffffc0204490:	c590                	sw	a2,8(a1)
ffffffffc0204492:	4df0206f          	j	ffffffffc0207170 <wakeup_proc>
ffffffffc0204496:	7198                	ld	a4,32(a1)
ffffffffc0204498:	01858793          	addi	a5,a1,24
ffffffffc020449c:	00e78e63          	beq	a5,a4,ffffffffc02044b8 <wakeup_wait+0x2c>
ffffffffc02044a0:	6994                	ld	a3,16(a1)
ffffffffc02044a2:	00d51b63          	bne	a0,a3,ffffffffc02044b8 <wakeup_wait+0x2c>
ffffffffc02044a6:	6d94                	ld	a3,24(a1)
ffffffffc02044a8:	6188                	ld	a0,0(a1)
ffffffffc02044aa:	e698                	sd	a4,8(a3)
ffffffffc02044ac:	e314                	sd	a3,0(a4)
ffffffffc02044ae:	f19c                	sd	a5,32(a1)
ffffffffc02044b0:	ed9c                	sd	a5,24(a1)
ffffffffc02044b2:	c590                	sw	a2,8(a1)
ffffffffc02044b4:	4bd0206f          	j	ffffffffc0207170 <wakeup_proc>
ffffffffc02044b8:	1141                	addi	sp,sp,-16
ffffffffc02044ba:	00009697          	auipc	a3,0x9
ffffffffc02044be:	a9668693          	addi	a3,a3,-1386 # ffffffffc020cf50 <default_pmm_manager+0x88>
ffffffffc02044c2:	00007617          	auipc	a2,0x7
ffffffffc02044c6:	34660613          	addi	a2,a2,838 # ffffffffc020b808 <commands+0x60>
ffffffffc02044ca:	45f1                	li	a1,28
ffffffffc02044cc:	00009517          	auipc	a0,0x9
ffffffffc02044d0:	a6c50513          	addi	a0,a0,-1428 # ffffffffc020cf38 <default_pmm_manager+0x70>
ffffffffc02044d4:	e406                	sd	ra,8(sp)
ffffffffc02044d6:	d59fb0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02044da <wakeup_queue>:
ffffffffc02044da:	651c                	ld	a5,8(a0)
ffffffffc02044dc:	0ca78563          	beq	a5,a0,ffffffffc02045a6 <wakeup_queue+0xcc>
ffffffffc02044e0:	1101                	addi	sp,sp,-32
ffffffffc02044e2:	e822                	sd	s0,16(sp)
ffffffffc02044e4:	e426                	sd	s1,8(sp)
ffffffffc02044e6:	e04a                	sd	s2,0(sp)
ffffffffc02044e8:	ec06                	sd	ra,24(sp)
ffffffffc02044ea:	84aa                	mv	s1,a0
ffffffffc02044ec:	892e                	mv	s2,a1
ffffffffc02044ee:	fe878413          	addi	s0,a5,-24
ffffffffc02044f2:	e23d                	bnez	a2,ffffffffc0204558 <wakeup_queue+0x7e>
ffffffffc02044f4:	6008                	ld	a0,0(s0)
ffffffffc02044f6:	01242423          	sw	s2,8(s0)
ffffffffc02044fa:	477020ef          	jal	ra,ffffffffc0207170 <wakeup_proc>
ffffffffc02044fe:	701c                	ld	a5,32(s0)
ffffffffc0204500:	01840713          	addi	a4,s0,24
ffffffffc0204504:	02e78463          	beq	a5,a4,ffffffffc020452c <wakeup_queue+0x52>
ffffffffc0204508:	6818                	ld	a4,16(s0)
ffffffffc020450a:	02e49163          	bne	s1,a4,ffffffffc020452c <wakeup_queue+0x52>
ffffffffc020450e:	02f48f63          	beq	s1,a5,ffffffffc020454c <wakeup_queue+0x72>
ffffffffc0204512:	fe87b503          	ld	a0,-24(a5)
ffffffffc0204516:	ff27a823          	sw	s2,-16(a5)
ffffffffc020451a:	fe878413          	addi	s0,a5,-24
ffffffffc020451e:	453020ef          	jal	ra,ffffffffc0207170 <wakeup_proc>
ffffffffc0204522:	701c                	ld	a5,32(s0)
ffffffffc0204524:	01840713          	addi	a4,s0,24
ffffffffc0204528:	fee790e3          	bne	a5,a4,ffffffffc0204508 <wakeup_queue+0x2e>
ffffffffc020452c:	00009697          	auipc	a3,0x9
ffffffffc0204530:	a2468693          	addi	a3,a3,-1500 # ffffffffc020cf50 <default_pmm_manager+0x88>
ffffffffc0204534:	00007617          	auipc	a2,0x7
ffffffffc0204538:	2d460613          	addi	a2,a2,724 # ffffffffc020b808 <commands+0x60>
ffffffffc020453c:	02200593          	li	a1,34
ffffffffc0204540:	00009517          	auipc	a0,0x9
ffffffffc0204544:	9f850513          	addi	a0,a0,-1544 # ffffffffc020cf38 <default_pmm_manager+0x70>
ffffffffc0204548:	ce7fb0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020454c:	60e2                	ld	ra,24(sp)
ffffffffc020454e:	6442                	ld	s0,16(sp)
ffffffffc0204550:	64a2                	ld	s1,8(sp)
ffffffffc0204552:	6902                	ld	s2,0(sp)
ffffffffc0204554:	6105                	addi	sp,sp,32
ffffffffc0204556:	8082                	ret
ffffffffc0204558:	6798                	ld	a4,8(a5)
ffffffffc020455a:	02f70763          	beq	a4,a5,ffffffffc0204588 <wakeup_queue+0xae>
ffffffffc020455e:	6814                	ld	a3,16(s0)
ffffffffc0204560:	02d49463          	bne	s1,a3,ffffffffc0204588 <wakeup_queue+0xae>
ffffffffc0204564:	6c14                	ld	a3,24(s0)
ffffffffc0204566:	6008                	ld	a0,0(s0)
ffffffffc0204568:	e698                	sd	a4,8(a3)
ffffffffc020456a:	e314                	sd	a3,0(a4)
ffffffffc020456c:	f01c                	sd	a5,32(s0)
ffffffffc020456e:	ec1c                	sd	a5,24(s0)
ffffffffc0204570:	01242423          	sw	s2,8(s0)
ffffffffc0204574:	3fd020ef          	jal	ra,ffffffffc0207170 <wakeup_proc>
ffffffffc0204578:	6480                	ld	s0,8(s1)
ffffffffc020457a:	fc8489e3          	beq	s1,s0,ffffffffc020454c <wakeup_queue+0x72>
ffffffffc020457e:	6418                	ld	a4,8(s0)
ffffffffc0204580:	87a2                	mv	a5,s0
ffffffffc0204582:	1421                	addi	s0,s0,-24
ffffffffc0204584:	fce79de3          	bne	a5,a4,ffffffffc020455e <wakeup_queue+0x84>
ffffffffc0204588:	00009697          	auipc	a3,0x9
ffffffffc020458c:	9c868693          	addi	a3,a3,-1592 # ffffffffc020cf50 <default_pmm_manager+0x88>
ffffffffc0204590:	00007617          	auipc	a2,0x7
ffffffffc0204594:	27860613          	addi	a2,a2,632 # ffffffffc020b808 <commands+0x60>
ffffffffc0204598:	45f1                	li	a1,28
ffffffffc020459a:	00009517          	auipc	a0,0x9
ffffffffc020459e:	99e50513          	addi	a0,a0,-1634 # ffffffffc020cf38 <default_pmm_manager+0x70>
ffffffffc02045a2:	c8dfb0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02045a6:	8082                	ret

ffffffffc02045a8 <wait_current_set>:
ffffffffc02045a8:	00092797          	auipc	a5,0x92
ffffffffc02045ac:	3187b783          	ld	a5,792(a5) # ffffffffc02968c0 <current>
ffffffffc02045b0:	c39d                	beqz	a5,ffffffffc02045d6 <wait_current_set+0x2e>
ffffffffc02045b2:	01858713          	addi	a4,a1,24
ffffffffc02045b6:	800006b7          	lui	a3,0x80000
ffffffffc02045ba:	ed98                	sd	a4,24(a1)
ffffffffc02045bc:	e19c                	sd	a5,0(a1)
ffffffffc02045be:	c594                	sw	a3,8(a1)
ffffffffc02045c0:	4685                	li	a3,1
ffffffffc02045c2:	c394                	sw	a3,0(a5)
ffffffffc02045c4:	0ec7a623          	sw	a2,236(a5)
ffffffffc02045c8:	611c                	ld	a5,0(a0)
ffffffffc02045ca:	e988                	sd	a0,16(a1)
ffffffffc02045cc:	e118                	sd	a4,0(a0)
ffffffffc02045ce:	e798                	sd	a4,8(a5)
ffffffffc02045d0:	f188                	sd	a0,32(a1)
ffffffffc02045d2:	ed9c                	sd	a5,24(a1)
ffffffffc02045d4:	8082                	ret
ffffffffc02045d6:	1141                	addi	sp,sp,-16
ffffffffc02045d8:	00009697          	auipc	a3,0x9
ffffffffc02045dc:	9b868693          	addi	a3,a3,-1608 # ffffffffc020cf90 <default_pmm_manager+0xc8>
ffffffffc02045e0:	00007617          	auipc	a2,0x7
ffffffffc02045e4:	22860613          	addi	a2,a2,552 # ffffffffc020b808 <commands+0x60>
ffffffffc02045e8:	07400593          	li	a1,116
ffffffffc02045ec:	00009517          	auipc	a0,0x9
ffffffffc02045f0:	94c50513          	addi	a0,a0,-1716 # ffffffffc020cf38 <default_pmm_manager+0x70>
ffffffffc02045f4:	e406                	sd	ra,8(sp)
ffffffffc02045f6:	c39fb0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02045fa <__down.constprop.0>:
ffffffffc02045fa:	715d                	addi	sp,sp,-80
ffffffffc02045fc:	e0a2                	sd	s0,64(sp)
ffffffffc02045fe:	e486                	sd	ra,72(sp)
ffffffffc0204600:	fc26                	sd	s1,56(sp)
ffffffffc0204602:	842a                	mv	s0,a0
ffffffffc0204604:	100027f3          	csrr	a5,sstatus
ffffffffc0204608:	8b89                	andi	a5,a5,2
ffffffffc020460a:	ebb1                	bnez	a5,ffffffffc020465e <__down.constprop.0+0x64>
ffffffffc020460c:	411c                	lw	a5,0(a0)
ffffffffc020460e:	00f05a63          	blez	a5,ffffffffc0204622 <__down.constprop.0+0x28>
ffffffffc0204612:	37fd                	addiw	a5,a5,-1
ffffffffc0204614:	c11c                	sw	a5,0(a0)
ffffffffc0204616:	4501                	li	a0,0
ffffffffc0204618:	60a6                	ld	ra,72(sp)
ffffffffc020461a:	6406                	ld	s0,64(sp)
ffffffffc020461c:	74e2                	ld	s1,56(sp)
ffffffffc020461e:	6161                	addi	sp,sp,80
ffffffffc0204620:	8082                	ret
ffffffffc0204622:	00850413          	addi	s0,a0,8
ffffffffc0204626:	0024                	addi	s1,sp,8
ffffffffc0204628:	10000613          	li	a2,256
ffffffffc020462c:	85a6                	mv	a1,s1
ffffffffc020462e:	8522                	mv	a0,s0
ffffffffc0204630:	f79ff0ef          	jal	ra,ffffffffc02045a8 <wait_current_set>
ffffffffc0204634:	3ef020ef          	jal	ra,ffffffffc0207222 <schedule>
ffffffffc0204638:	100027f3          	csrr	a5,sstatus
ffffffffc020463c:	8b89                	andi	a5,a5,2
ffffffffc020463e:	efb9                	bnez	a5,ffffffffc020469c <__down.constprop.0+0xa2>
ffffffffc0204640:	8526                	mv	a0,s1
ffffffffc0204642:	e3dff0ef          	jal	ra,ffffffffc020447e <wait_in_queue>
ffffffffc0204646:	e531                	bnez	a0,ffffffffc0204692 <__down.constprop.0+0x98>
ffffffffc0204648:	4542                	lw	a0,16(sp)
ffffffffc020464a:	10000793          	li	a5,256
ffffffffc020464e:	fcf515e3          	bne	a0,a5,ffffffffc0204618 <__down.constprop.0+0x1e>
ffffffffc0204652:	60a6                	ld	ra,72(sp)
ffffffffc0204654:	6406                	ld	s0,64(sp)
ffffffffc0204656:	74e2                	ld	s1,56(sp)
ffffffffc0204658:	4501                	li	a0,0
ffffffffc020465a:	6161                	addi	sp,sp,80
ffffffffc020465c:	8082                	ret
ffffffffc020465e:	f46fc0ef          	jal	ra,ffffffffc0200da4 <intr_disable>
ffffffffc0204662:	401c                	lw	a5,0(s0)
ffffffffc0204664:	00f05c63          	blez	a5,ffffffffc020467c <__down.constprop.0+0x82>
ffffffffc0204668:	37fd                	addiw	a5,a5,-1
ffffffffc020466a:	c01c                	sw	a5,0(s0)
ffffffffc020466c:	f32fc0ef          	jal	ra,ffffffffc0200d9e <intr_enable>
ffffffffc0204670:	60a6                	ld	ra,72(sp)
ffffffffc0204672:	6406                	ld	s0,64(sp)
ffffffffc0204674:	74e2                	ld	s1,56(sp)
ffffffffc0204676:	4501                	li	a0,0
ffffffffc0204678:	6161                	addi	sp,sp,80
ffffffffc020467a:	8082                	ret
ffffffffc020467c:	0421                	addi	s0,s0,8
ffffffffc020467e:	0024                	addi	s1,sp,8
ffffffffc0204680:	10000613          	li	a2,256
ffffffffc0204684:	85a6                	mv	a1,s1
ffffffffc0204686:	8522                	mv	a0,s0
ffffffffc0204688:	f21ff0ef          	jal	ra,ffffffffc02045a8 <wait_current_set>
ffffffffc020468c:	f12fc0ef          	jal	ra,ffffffffc0200d9e <intr_enable>
ffffffffc0204690:	b755                	j	ffffffffc0204634 <__down.constprop.0+0x3a>
ffffffffc0204692:	85a6                	mv	a1,s1
ffffffffc0204694:	8522                	mv	a0,s0
ffffffffc0204696:	d8fff0ef          	jal	ra,ffffffffc0204424 <wait_queue_del>
ffffffffc020469a:	b77d                	j	ffffffffc0204648 <__down.constprop.0+0x4e>
ffffffffc020469c:	f08fc0ef          	jal	ra,ffffffffc0200da4 <intr_disable>
ffffffffc02046a0:	8526                	mv	a0,s1
ffffffffc02046a2:	dddff0ef          	jal	ra,ffffffffc020447e <wait_in_queue>
ffffffffc02046a6:	e501                	bnez	a0,ffffffffc02046ae <__down.constprop.0+0xb4>
ffffffffc02046a8:	ef6fc0ef          	jal	ra,ffffffffc0200d9e <intr_enable>
ffffffffc02046ac:	bf71                	j	ffffffffc0204648 <__down.constprop.0+0x4e>
ffffffffc02046ae:	85a6                	mv	a1,s1
ffffffffc02046b0:	8522                	mv	a0,s0
ffffffffc02046b2:	d73ff0ef          	jal	ra,ffffffffc0204424 <wait_queue_del>
ffffffffc02046b6:	bfcd                	j	ffffffffc02046a8 <__down.constprop.0+0xae>

ffffffffc02046b8 <__up.constprop.0>:
ffffffffc02046b8:	1101                	addi	sp,sp,-32
ffffffffc02046ba:	e822                	sd	s0,16(sp)
ffffffffc02046bc:	ec06                	sd	ra,24(sp)
ffffffffc02046be:	e426                	sd	s1,8(sp)
ffffffffc02046c0:	e04a                	sd	s2,0(sp)
ffffffffc02046c2:	842a                	mv	s0,a0
ffffffffc02046c4:	100027f3          	csrr	a5,sstatus
ffffffffc02046c8:	8b89                	andi	a5,a5,2
ffffffffc02046ca:	4901                	li	s2,0
ffffffffc02046cc:	eba1                	bnez	a5,ffffffffc020471c <__up.constprop.0+0x64>
ffffffffc02046ce:	00840493          	addi	s1,s0,8
ffffffffc02046d2:	8526                	mv	a0,s1
ffffffffc02046d4:	d8fff0ef          	jal	ra,ffffffffc0204462 <wait_queue_first>
ffffffffc02046d8:	85aa                	mv	a1,a0
ffffffffc02046da:	cd0d                	beqz	a0,ffffffffc0204714 <__up.constprop.0+0x5c>
ffffffffc02046dc:	6118                	ld	a4,0(a0)
ffffffffc02046de:	10000793          	li	a5,256
ffffffffc02046e2:	0ec72703          	lw	a4,236(a4)
ffffffffc02046e6:	02f71f63          	bne	a4,a5,ffffffffc0204724 <__up.constprop.0+0x6c>
ffffffffc02046ea:	4685                	li	a3,1
ffffffffc02046ec:	10000613          	li	a2,256
ffffffffc02046f0:	8526                	mv	a0,s1
ffffffffc02046f2:	d9bff0ef          	jal	ra,ffffffffc020448c <wakeup_wait>
ffffffffc02046f6:	00091863          	bnez	s2,ffffffffc0204706 <__up.constprop.0+0x4e>
ffffffffc02046fa:	60e2                	ld	ra,24(sp)
ffffffffc02046fc:	6442                	ld	s0,16(sp)
ffffffffc02046fe:	64a2                	ld	s1,8(sp)
ffffffffc0204700:	6902                	ld	s2,0(sp)
ffffffffc0204702:	6105                	addi	sp,sp,32
ffffffffc0204704:	8082                	ret
ffffffffc0204706:	6442                	ld	s0,16(sp)
ffffffffc0204708:	60e2                	ld	ra,24(sp)
ffffffffc020470a:	64a2                	ld	s1,8(sp)
ffffffffc020470c:	6902                	ld	s2,0(sp)
ffffffffc020470e:	6105                	addi	sp,sp,32
ffffffffc0204710:	e8efc06f          	j	ffffffffc0200d9e <intr_enable>
ffffffffc0204714:	401c                	lw	a5,0(s0)
ffffffffc0204716:	2785                	addiw	a5,a5,1
ffffffffc0204718:	c01c                	sw	a5,0(s0)
ffffffffc020471a:	bff1                	j	ffffffffc02046f6 <__up.constprop.0+0x3e>
ffffffffc020471c:	e88fc0ef          	jal	ra,ffffffffc0200da4 <intr_disable>
ffffffffc0204720:	4905                	li	s2,1
ffffffffc0204722:	b775                	j	ffffffffc02046ce <__up.constprop.0+0x16>
ffffffffc0204724:	00009697          	auipc	a3,0x9
ffffffffc0204728:	87c68693          	addi	a3,a3,-1924 # ffffffffc020cfa0 <default_pmm_manager+0xd8>
ffffffffc020472c:	00007617          	auipc	a2,0x7
ffffffffc0204730:	0dc60613          	addi	a2,a2,220 # ffffffffc020b808 <commands+0x60>
ffffffffc0204734:	45e5                	li	a1,25
ffffffffc0204736:	00009517          	auipc	a0,0x9
ffffffffc020473a:	89250513          	addi	a0,a0,-1902 # ffffffffc020cfc8 <default_pmm_manager+0x100>
ffffffffc020473e:	af1fb0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0204742 <sem_init>:
ffffffffc0204742:	c10c                	sw	a1,0(a0)
ffffffffc0204744:	0521                	addi	a0,a0,8
ffffffffc0204746:	cd9ff06f          	j	ffffffffc020441e <wait_queue_init>

ffffffffc020474a <up>:
ffffffffc020474a:	f6fff06f          	j	ffffffffc02046b8 <__up.constprop.0>

ffffffffc020474e <down>:
ffffffffc020474e:	1141                	addi	sp,sp,-16
ffffffffc0204750:	e406                	sd	ra,8(sp)
ffffffffc0204752:	ea9ff0ef          	jal	ra,ffffffffc02045fa <__down.constprop.0>
ffffffffc0204756:	2501                	sext.w	a0,a0
ffffffffc0204758:	e501                	bnez	a0,ffffffffc0204760 <down+0x12>
ffffffffc020475a:	60a2                	ld	ra,8(sp)
ffffffffc020475c:	0141                	addi	sp,sp,16
ffffffffc020475e:	8082                	ret
ffffffffc0204760:	00009697          	auipc	a3,0x9
ffffffffc0204764:	87868693          	addi	a3,a3,-1928 # ffffffffc020cfd8 <default_pmm_manager+0x110>
ffffffffc0204768:	00007617          	auipc	a2,0x7
ffffffffc020476c:	0a060613          	addi	a2,a2,160 # ffffffffc020b808 <commands+0x60>
ffffffffc0204770:	04000593          	li	a1,64
ffffffffc0204774:	00009517          	auipc	a0,0x9
ffffffffc0204778:	85450513          	addi	a0,a0,-1964 # ffffffffc020cfc8 <default_pmm_manager+0x100>
ffffffffc020477c:	ab3fb0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0204780 <copy_path>:
ffffffffc0204780:	7139                	addi	sp,sp,-64
ffffffffc0204782:	f04a                	sd	s2,32(sp)
ffffffffc0204784:	00092917          	auipc	s2,0x92
ffffffffc0204788:	13c90913          	addi	s2,s2,316 # ffffffffc02968c0 <current>
ffffffffc020478c:	00093703          	ld	a4,0(s2)
ffffffffc0204790:	ec4e                	sd	s3,24(sp)
ffffffffc0204792:	89aa                	mv	s3,a0
ffffffffc0204794:	6505                	lui	a0,0x1
ffffffffc0204796:	f426                	sd	s1,40(sp)
ffffffffc0204798:	e852                	sd	s4,16(sp)
ffffffffc020479a:	fc06                	sd	ra,56(sp)
ffffffffc020479c:	f822                	sd	s0,48(sp)
ffffffffc020479e:	e456                	sd	s5,8(sp)
ffffffffc02047a0:	02873a03          	ld	s4,40(a4)
ffffffffc02047a4:	84ae                	mv	s1,a1
ffffffffc02047a6:	820ff0ef          	jal	ra,ffffffffc02037c6 <kmalloc>
ffffffffc02047aa:	c141                	beqz	a0,ffffffffc020482a <copy_path+0xaa>
ffffffffc02047ac:	842a                	mv	s0,a0
ffffffffc02047ae:	040a0563          	beqz	s4,ffffffffc02047f8 <copy_path+0x78>
ffffffffc02047b2:	038a0a93          	addi	s5,s4,56
ffffffffc02047b6:	8556                	mv	a0,s5
ffffffffc02047b8:	f97ff0ef          	jal	ra,ffffffffc020474e <down>
ffffffffc02047bc:	00093783          	ld	a5,0(s2)
ffffffffc02047c0:	cba1                	beqz	a5,ffffffffc0204810 <copy_path+0x90>
ffffffffc02047c2:	43dc                	lw	a5,4(a5)
ffffffffc02047c4:	6685                	lui	a3,0x1
ffffffffc02047c6:	8626                	mv	a2,s1
ffffffffc02047c8:	04fa2823          	sw	a5,80(s4)
ffffffffc02047cc:	85a2                	mv	a1,s0
ffffffffc02047ce:	8552                	mv	a0,s4
ffffffffc02047d0:	d3ffe0ef          	jal	ra,ffffffffc020350e <copy_string>
ffffffffc02047d4:	c529                	beqz	a0,ffffffffc020481e <copy_path+0x9e>
ffffffffc02047d6:	8556                	mv	a0,s5
ffffffffc02047d8:	f73ff0ef          	jal	ra,ffffffffc020474a <up>
ffffffffc02047dc:	040a2823          	sw	zero,80(s4)
ffffffffc02047e0:	0089b023          	sd	s0,0(s3)
ffffffffc02047e4:	4501                	li	a0,0
ffffffffc02047e6:	70e2                	ld	ra,56(sp)
ffffffffc02047e8:	7442                	ld	s0,48(sp)
ffffffffc02047ea:	74a2                	ld	s1,40(sp)
ffffffffc02047ec:	7902                	ld	s2,32(sp)
ffffffffc02047ee:	69e2                	ld	s3,24(sp)
ffffffffc02047f0:	6a42                	ld	s4,16(sp)
ffffffffc02047f2:	6aa2                	ld	s5,8(sp)
ffffffffc02047f4:	6121                	addi	sp,sp,64
ffffffffc02047f6:	8082                	ret
ffffffffc02047f8:	85aa                	mv	a1,a0
ffffffffc02047fa:	6685                	lui	a3,0x1
ffffffffc02047fc:	8626                	mv	a2,s1
ffffffffc02047fe:	4501                	li	a0,0
ffffffffc0204800:	d0ffe0ef          	jal	ra,ffffffffc020350e <copy_string>
ffffffffc0204804:	fd71                	bnez	a0,ffffffffc02047e0 <copy_path+0x60>
ffffffffc0204806:	8522                	mv	a0,s0
ffffffffc0204808:	86eff0ef          	jal	ra,ffffffffc0203876 <kfree>
ffffffffc020480c:	5575                	li	a0,-3
ffffffffc020480e:	bfe1                	j	ffffffffc02047e6 <copy_path+0x66>
ffffffffc0204810:	6685                	lui	a3,0x1
ffffffffc0204812:	8626                	mv	a2,s1
ffffffffc0204814:	85a2                	mv	a1,s0
ffffffffc0204816:	8552                	mv	a0,s4
ffffffffc0204818:	cf7fe0ef          	jal	ra,ffffffffc020350e <copy_string>
ffffffffc020481c:	fd4d                	bnez	a0,ffffffffc02047d6 <copy_path+0x56>
ffffffffc020481e:	8556                	mv	a0,s5
ffffffffc0204820:	f2bff0ef          	jal	ra,ffffffffc020474a <up>
ffffffffc0204824:	040a2823          	sw	zero,80(s4)
ffffffffc0204828:	bff9                	j	ffffffffc0204806 <copy_path+0x86>
ffffffffc020482a:	5571                	li	a0,-4
ffffffffc020482c:	bf6d                	j	ffffffffc02047e6 <copy_path+0x66>

ffffffffc020482e <sysfile_open>:
ffffffffc020482e:	7179                	addi	sp,sp,-48
ffffffffc0204830:	872a                	mv	a4,a0
ffffffffc0204832:	ec26                	sd	s1,24(sp)
ffffffffc0204834:	0028                	addi	a0,sp,8
ffffffffc0204836:	84ae                	mv	s1,a1
ffffffffc0204838:	85ba                	mv	a1,a4
ffffffffc020483a:	f022                	sd	s0,32(sp)
ffffffffc020483c:	f406                	sd	ra,40(sp)
ffffffffc020483e:	f43ff0ef          	jal	ra,ffffffffc0204780 <copy_path>
ffffffffc0204842:	842a                	mv	s0,a0
ffffffffc0204844:	e909                	bnez	a0,ffffffffc0204856 <sysfile_open+0x28>
ffffffffc0204846:	6522                	ld	a0,8(sp)
ffffffffc0204848:	85a6                	mv	a1,s1
ffffffffc020484a:	7ba000ef          	jal	ra,ffffffffc0205004 <file_open>
ffffffffc020484e:	842a                	mv	s0,a0
ffffffffc0204850:	6522                	ld	a0,8(sp)
ffffffffc0204852:	824ff0ef          	jal	ra,ffffffffc0203876 <kfree>
ffffffffc0204856:	70a2                	ld	ra,40(sp)
ffffffffc0204858:	8522                	mv	a0,s0
ffffffffc020485a:	7402                	ld	s0,32(sp)
ffffffffc020485c:	64e2                	ld	s1,24(sp)
ffffffffc020485e:	6145                	addi	sp,sp,48
ffffffffc0204860:	8082                	ret

ffffffffc0204862 <sysfile_close>:
ffffffffc0204862:	0a10006f          	j	ffffffffc0205102 <file_close>

ffffffffc0204866 <sysfile_read>:
ffffffffc0204866:	7159                	addi	sp,sp,-112
ffffffffc0204868:	f0a2                	sd	s0,96(sp)
ffffffffc020486a:	f486                	sd	ra,104(sp)
ffffffffc020486c:	eca6                	sd	s1,88(sp)
ffffffffc020486e:	e8ca                	sd	s2,80(sp)
ffffffffc0204870:	e4ce                	sd	s3,72(sp)
ffffffffc0204872:	e0d2                	sd	s4,64(sp)
ffffffffc0204874:	fc56                	sd	s5,56(sp)
ffffffffc0204876:	f85a                	sd	s6,48(sp)
ffffffffc0204878:	f45e                	sd	s7,40(sp)
ffffffffc020487a:	f062                	sd	s8,32(sp)
ffffffffc020487c:	ec66                	sd	s9,24(sp)
ffffffffc020487e:	4401                	li	s0,0
ffffffffc0204880:	ee19                	bnez	a2,ffffffffc020489e <sysfile_read+0x38>
ffffffffc0204882:	70a6                	ld	ra,104(sp)
ffffffffc0204884:	8522                	mv	a0,s0
ffffffffc0204886:	7406                	ld	s0,96(sp)
ffffffffc0204888:	64e6                	ld	s1,88(sp)
ffffffffc020488a:	6946                	ld	s2,80(sp)
ffffffffc020488c:	69a6                	ld	s3,72(sp)
ffffffffc020488e:	6a06                	ld	s4,64(sp)
ffffffffc0204890:	7ae2                	ld	s5,56(sp)
ffffffffc0204892:	7b42                	ld	s6,48(sp)
ffffffffc0204894:	7ba2                	ld	s7,40(sp)
ffffffffc0204896:	7c02                	ld	s8,32(sp)
ffffffffc0204898:	6ce2                	ld	s9,24(sp)
ffffffffc020489a:	6165                	addi	sp,sp,112
ffffffffc020489c:	8082                	ret
ffffffffc020489e:	00092c97          	auipc	s9,0x92
ffffffffc02048a2:	022c8c93          	addi	s9,s9,34 # ffffffffc02968c0 <current>
ffffffffc02048a6:	000cb783          	ld	a5,0(s9)
ffffffffc02048aa:	84b2                	mv	s1,a2
ffffffffc02048ac:	8b2e                	mv	s6,a1
ffffffffc02048ae:	4601                	li	a2,0
ffffffffc02048b0:	4585                	li	a1,1
ffffffffc02048b2:	0287b903          	ld	s2,40(a5)
ffffffffc02048b6:	8aaa                	mv	s5,a0
ffffffffc02048b8:	6f8000ef          	jal	ra,ffffffffc0204fb0 <file_testfd>
ffffffffc02048bc:	c959                	beqz	a0,ffffffffc0204952 <sysfile_read+0xec>
ffffffffc02048be:	6505                	lui	a0,0x1
ffffffffc02048c0:	f07fe0ef          	jal	ra,ffffffffc02037c6 <kmalloc>
ffffffffc02048c4:	89aa                	mv	s3,a0
ffffffffc02048c6:	c941                	beqz	a0,ffffffffc0204956 <sysfile_read+0xf0>
ffffffffc02048c8:	4b81                	li	s7,0
ffffffffc02048ca:	6a05                	lui	s4,0x1
ffffffffc02048cc:	03890c13          	addi	s8,s2,56
ffffffffc02048d0:	0744ec63          	bltu	s1,s4,ffffffffc0204948 <sysfile_read+0xe2>
ffffffffc02048d4:	e452                	sd	s4,8(sp)
ffffffffc02048d6:	6605                	lui	a2,0x1
ffffffffc02048d8:	0034                	addi	a3,sp,8
ffffffffc02048da:	85ce                	mv	a1,s3
ffffffffc02048dc:	8556                	mv	a0,s5
ffffffffc02048de:	07b000ef          	jal	ra,ffffffffc0205158 <file_read>
ffffffffc02048e2:	66a2                	ld	a3,8(sp)
ffffffffc02048e4:	842a                	mv	s0,a0
ffffffffc02048e6:	ca9d                	beqz	a3,ffffffffc020491c <sysfile_read+0xb6>
ffffffffc02048e8:	00090c63          	beqz	s2,ffffffffc0204900 <sysfile_read+0x9a>
ffffffffc02048ec:	8562                	mv	a0,s8
ffffffffc02048ee:	e61ff0ef          	jal	ra,ffffffffc020474e <down>
ffffffffc02048f2:	000cb783          	ld	a5,0(s9)
ffffffffc02048f6:	cfa1                	beqz	a5,ffffffffc020494e <sysfile_read+0xe8>
ffffffffc02048f8:	43dc                	lw	a5,4(a5)
ffffffffc02048fa:	66a2                	ld	a3,8(sp)
ffffffffc02048fc:	04f92823          	sw	a5,80(s2)
ffffffffc0204900:	864e                	mv	a2,s3
ffffffffc0204902:	85da                	mv	a1,s6
ffffffffc0204904:	854a                	mv	a0,s2
ffffffffc0204906:	bd7fe0ef          	jal	ra,ffffffffc02034dc <copy_to_user>
ffffffffc020490a:	c50d                	beqz	a0,ffffffffc0204934 <sysfile_read+0xce>
ffffffffc020490c:	67a2                	ld	a5,8(sp)
ffffffffc020490e:	04f4e663          	bltu	s1,a5,ffffffffc020495a <sysfile_read+0xf4>
ffffffffc0204912:	9b3e                	add	s6,s6,a5
ffffffffc0204914:	8c9d                	sub	s1,s1,a5
ffffffffc0204916:	9bbe                	add	s7,s7,a5
ffffffffc0204918:	02091263          	bnez	s2,ffffffffc020493c <sysfile_read+0xd6>
ffffffffc020491c:	e401                	bnez	s0,ffffffffc0204924 <sysfile_read+0xbe>
ffffffffc020491e:	67a2                	ld	a5,8(sp)
ffffffffc0204920:	c391                	beqz	a5,ffffffffc0204924 <sysfile_read+0xbe>
ffffffffc0204922:	f4dd                	bnez	s1,ffffffffc02048d0 <sysfile_read+0x6a>
ffffffffc0204924:	854e                	mv	a0,s3
ffffffffc0204926:	f51fe0ef          	jal	ra,ffffffffc0203876 <kfree>
ffffffffc020492a:	f40b8ce3          	beqz	s7,ffffffffc0204882 <sysfile_read+0x1c>
ffffffffc020492e:	000b841b          	sext.w	s0,s7
ffffffffc0204932:	bf81                	j	ffffffffc0204882 <sysfile_read+0x1c>
ffffffffc0204934:	e011                	bnez	s0,ffffffffc0204938 <sysfile_read+0xd2>
ffffffffc0204936:	5475                	li	s0,-3
ffffffffc0204938:	fe0906e3          	beqz	s2,ffffffffc0204924 <sysfile_read+0xbe>
ffffffffc020493c:	8562                	mv	a0,s8
ffffffffc020493e:	e0dff0ef          	jal	ra,ffffffffc020474a <up>
ffffffffc0204942:	04092823          	sw	zero,80(s2)
ffffffffc0204946:	bfd9                	j	ffffffffc020491c <sysfile_read+0xb6>
ffffffffc0204948:	e426                	sd	s1,8(sp)
ffffffffc020494a:	8626                	mv	a2,s1
ffffffffc020494c:	b771                	j	ffffffffc02048d8 <sysfile_read+0x72>
ffffffffc020494e:	66a2                	ld	a3,8(sp)
ffffffffc0204950:	bf45                	j	ffffffffc0204900 <sysfile_read+0x9a>
ffffffffc0204952:	5475                	li	s0,-3
ffffffffc0204954:	b73d                	j	ffffffffc0204882 <sysfile_read+0x1c>
ffffffffc0204956:	5471                	li	s0,-4
ffffffffc0204958:	b72d                	j	ffffffffc0204882 <sysfile_read+0x1c>
ffffffffc020495a:	00008697          	auipc	a3,0x8
ffffffffc020495e:	68e68693          	addi	a3,a3,1678 # ffffffffc020cfe8 <default_pmm_manager+0x120>
ffffffffc0204962:	00007617          	auipc	a2,0x7
ffffffffc0204966:	ea660613          	addi	a2,a2,-346 # ffffffffc020b808 <commands+0x60>
ffffffffc020496a:	05500593          	li	a1,85
ffffffffc020496e:	00008517          	auipc	a0,0x8
ffffffffc0204972:	68a50513          	addi	a0,a0,1674 # ffffffffc020cff8 <default_pmm_manager+0x130>
ffffffffc0204976:	8b9fb0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020497a <sysfile_write>:
ffffffffc020497a:	7159                	addi	sp,sp,-112
ffffffffc020497c:	e8ca                	sd	s2,80(sp)
ffffffffc020497e:	f486                	sd	ra,104(sp)
ffffffffc0204980:	f0a2                	sd	s0,96(sp)
ffffffffc0204982:	eca6                	sd	s1,88(sp)
ffffffffc0204984:	e4ce                	sd	s3,72(sp)
ffffffffc0204986:	e0d2                	sd	s4,64(sp)
ffffffffc0204988:	fc56                	sd	s5,56(sp)
ffffffffc020498a:	f85a                	sd	s6,48(sp)
ffffffffc020498c:	f45e                	sd	s7,40(sp)
ffffffffc020498e:	f062                	sd	s8,32(sp)
ffffffffc0204990:	ec66                	sd	s9,24(sp)
ffffffffc0204992:	4901                	li	s2,0
ffffffffc0204994:	ee19                	bnez	a2,ffffffffc02049b2 <sysfile_write+0x38>
ffffffffc0204996:	70a6                	ld	ra,104(sp)
ffffffffc0204998:	7406                	ld	s0,96(sp)
ffffffffc020499a:	64e6                	ld	s1,88(sp)
ffffffffc020499c:	69a6                	ld	s3,72(sp)
ffffffffc020499e:	6a06                	ld	s4,64(sp)
ffffffffc02049a0:	7ae2                	ld	s5,56(sp)
ffffffffc02049a2:	7b42                	ld	s6,48(sp)
ffffffffc02049a4:	7ba2                	ld	s7,40(sp)
ffffffffc02049a6:	7c02                	ld	s8,32(sp)
ffffffffc02049a8:	6ce2                	ld	s9,24(sp)
ffffffffc02049aa:	854a                	mv	a0,s2
ffffffffc02049ac:	6946                	ld	s2,80(sp)
ffffffffc02049ae:	6165                	addi	sp,sp,112
ffffffffc02049b0:	8082                	ret
ffffffffc02049b2:	00092c17          	auipc	s8,0x92
ffffffffc02049b6:	f0ec0c13          	addi	s8,s8,-242 # ffffffffc02968c0 <current>
ffffffffc02049ba:	000c3783          	ld	a5,0(s8)
ffffffffc02049be:	8432                	mv	s0,a2
ffffffffc02049c0:	89ae                	mv	s3,a1
ffffffffc02049c2:	4605                	li	a2,1
ffffffffc02049c4:	4581                	li	a1,0
ffffffffc02049c6:	7784                	ld	s1,40(a5)
ffffffffc02049c8:	8baa                	mv	s7,a0
ffffffffc02049ca:	5e6000ef          	jal	ra,ffffffffc0204fb0 <file_testfd>
ffffffffc02049ce:	cd59                	beqz	a0,ffffffffc0204a6c <sysfile_write+0xf2>
ffffffffc02049d0:	6505                	lui	a0,0x1
ffffffffc02049d2:	df5fe0ef          	jal	ra,ffffffffc02037c6 <kmalloc>
ffffffffc02049d6:	8a2a                	mv	s4,a0
ffffffffc02049d8:	cd41                	beqz	a0,ffffffffc0204a70 <sysfile_write+0xf6>
ffffffffc02049da:	4c81                	li	s9,0
ffffffffc02049dc:	6a85                	lui	s5,0x1
ffffffffc02049de:	03848b13          	addi	s6,s1,56
ffffffffc02049e2:	05546a63          	bltu	s0,s5,ffffffffc0204a36 <sysfile_write+0xbc>
ffffffffc02049e6:	e456                	sd	s5,8(sp)
ffffffffc02049e8:	c8a9                	beqz	s1,ffffffffc0204a3a <sysfile_write+0xc0>
ffffffffc02049ea:	855a                	mv	a0,s6
ffffffffc02049ec:	d63ff0ef          	jal	ra,ffffffffc020474e <down>
ffffffffc02049f0:	000c3783          	ld	a5,0(s8)
ffffffffc02049f4:	c399                	beqz	a5,ffffffffc02049fa <sysfile_write+0x80>
ffffffffc02049f6:	43dc                	lw	a5,4(a5)
ffffffffc02049f8:	c8bc                	sw	a5,80(s1)
ffffffffc02049fa:	66a2                	ld	a3,8(sp)
ffffffffc02049fc:	4701                	li	a4,0
ffffffffc02049fe:	864e                	mv	a2,s3
ffffffffc0204a00:	85d2                	mv	a1,s4
ffffffffc0204a02:	8526                	mv	a0,s1
ffffffffc0204a04:	aa5fe0ef          	jal	ra,ffffffffc02034a8 <copy_from_user>
ffffffffc0204a08:	c139                	beqz	a0,ffffffffc0204a4e <sysfile_write+0xd4>
ffffffffc0204a0a:	855a                	mv	a0,s6
ffffffffc0204a0c:	d3fff0ef          	jal	ra,ffffffffc020474a <up>
ffffffffc0204a10:	0404a823          	sw	zero,80(s1)
ffffffffc0204a14:	6622                	ld	a2,8(sp)
ffffffffc0204a16:	0034                	addi	a3,sp,8
ffffffffc0204a18:	85d2                	mv	a1,s4
ffffffffc0204a1a:	855e                	mv	a0,s7
ffffffffc0204a1c:	023000ef          	jal	ra,ffffffffc020523e <file_write>
ffffffffc0204a20:	67a2                	ld	a5,8(sp)
ffffffffc0204a22:	892a                	mv	s2,a0
ffffffffc0204a24:	ef85                	bnez	a5,ffffffffc0204a5c <sysfile_write+0xe2>
ffffffffc0204a26:	8552                	mv	a0,s4
ffffffffc0204a28:	e4ffe0ef          	jal	ra,ffffffffc0203876 <kfree>
ffffffffc0204a2c:	f60c85e3          	beqz	s9,ffffffffc0204996 <sysfile_write+0x1c>
ffffffffc0204a30:	000c891b          	sext.w	s2,s9
ffffffffc0204a34:	b78d                	j	ffffffffc0204996 <sysfile_write+0x1c>
ffffffffc0204a36:	e422                	sd	s0,8(sp)
ffffffffc0204a38:	f8cd                	bnez	s1,ffffffffc02049ea <sysfile_write+0x70>
ffffffffc0204a3a:	66a2                	ld	a3,8(sp)
ffffffffc0204a3c:	4701                	li	a4,0
ffffffffc0204a3e:	864e                	mv	a2,s3
ffffffffc0204a40:	85d2                	mv	a1,s4
ffffffffc0204a42:	4501                	li	a0,0
ffffffffc0204a44:	a65fe0ef          	jal	ra,ffffffffc02034a8 <copy_from_user>
ffffffffc0204a48:	f571                	bnez	a0,ffffffffc0204a14 <sysfile_write+0x9a>
ffffffffc0204a4a:	5975                	li	s2,-3
ffffffffc0204a4c:	bfe9                	j	ffffffffc0204a26 <sysfile_write+0xac>
ffffffffc0204a4e:	855a                	mv	a0,s6
ffffffffc0204a50:	cfbff0ef          	jal	ra,ffffffffc020474a <up>
ffffffffc0204a54:	5975                	li	s2,-3
ffffffffc0204a56:	0404a823          	sw	zero,80(s1)
ffffffffc0204a5a:	b7f1                	j	ffffffffc0204a26 <sysfile_write+0xac>
ffffffffc0204a5c:	00f46c63          	bltu	s0,a5,ffffffffc0204a74 <sysfile_write+0xfa>
ffffffffc0204a60:	99be                	add	s3,s3,a5
ffffffffc0204a62:	8c1d                	sub	s0,s0,a5
ffffffffc0204a64:	9cbe                	add	s9,s9,a5
ffffffffc0204a66:	f161                	bnez	a0,ffffffffc0204a26 <sysfile_write+0xac>
ffffffffc0204a68:	fc2d                	bnez	s0,ffffffffc02049e2 <sysfile_write+0x68>
ffffffffc0204a6a:	bf75                	j	ffffffffc0204a26 <sysfile_write+0xac>
ffffffffc0204a6c:	5975                	li	s2,-3
ffffffffc0204a6e:	b725                	j	ffffffffc0204996 <sysfile_write+0x1c>
ffffffffc0204a70:	5971                	li	s2,-4
ffffffffc0204a72:	b715                	j	ffffffffc0204996 <sysfile_write+0x1c>
ffffffffc0204a74:	00008697          	auipc	a3,0x8
ffffffffc0204a78:	57468693          	addi	a3,a3,1396 # ffffffffc020cfe8 <default_pmm_manager+0x120>
ffffffffc0204a7c:	00007617          	auipc	a2,0x7
ffffffffc0204a80:	d8c60613          	addi	a2,a2,-628 # ffffffffc020b808 <commands+0x60>
ffffffffc0204a84:	08a00593          	li	a1,138
ffffffffc0204a88:	00008517          	auipc	a0,0x8
ffffffffc0204a8c:	57050513          	addi	a0,a0,1392 # ffffffffc020cff8 <default_pmm_manager+0x130>
ffffffffc0204a90:	f9efb0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0204a94 <sysfile_seek>:
ffffffffc0204a94:	0910006f          	j	ffffffffc0205324 <file_seek>

ffffffffc0204a98 <sysfile_fstat>:
ffffffffc0204a98:	715d                	addi	sp,sp,-80
ffffffffc0204a9a:	f44e                	sd	s3,40(sp)
ffffffffc0204a9c:	00092997          	auipc	s3,0x92
ffffffffc0204aa0:	e2498993          	addi	s3,s3,-476 # ffffffffc02968c0 <current>
ffffffffc0204aa4:	0009b703          	ld	a4,0(s3)
ffffffffc0204aa8:	fc26                	sd	s1,56(sp)
ffffffffc0204aaa:	84ae                	mv	s1,a1
ffffffffc0204aac:	858a                	mv	a1,sp
ffffffffc0204aae:	e0a2                	sd	s0,64(sp)
ffffffffc0204ab0:	f84a                	sd	s2,48(sp)
ffffffffc0204ab2:	e486                	sd	ra,72(sp)
ffffffffc0204ab4:	02873903          	ld	s2,40(a4)
ffffffffc0204ab8:	f052                	sd	s4,32(sp)
ffffffffc0204aba:	18b000ef          	jal	ra,ffffffffc0205444 <file_fstat>
ffffffffc0204abe:	842a                	mv	s0,a0
ffffffffc0204ac0:	e91d                	bnez	a0,ffffffffc0204af6 <sysfile_fstat+0x5e>
ffffffffc0204ac2:	04090363          	beqz	s2,ffffffffc0204b08 <sysfile_fstat+0x70>
ffffffffc0204ac6:	03890a13          	addi	s4,s2,56
ffffffffc0204aca:	8552                	mv	a0,s4
ffffffffc0204acc:	c83ff0ef          	jal	ra,ffffffffc020474e <down>
ffffffffc0204ad0:	0009b783          	ld	a5,0(s3)
ffffffffc0204ad4:	c3b9                	beqz	a5,ffffffffc0204b1a <sysfile_fstat+0x82>
ffffffffc0204ad6:	43dc                	lw	a5,4(a5)
ffffffffc0204ad8:	02000693          	li	a3,32
ffffffffc0204adc:	860a                	mv	a2,sp
ffffffffc0204ade:	04f92823          	sw	a5,80(s2)
ffffffffc0204ae2:	85a6                	mv	a1,s1
ffffffffc0204ae4:	854a                	mv	a0,s2
ffffffffc0204ae6:	9f7fe0ef          	jal	ra,ffffffffc02034dc <copy_to_user>
ffffffffc0204aea:	c121                	beqz	a0,ffffffffc0204b2a <sysfile_fstat+0x92>
ffffffffc0204aec:	8552                	mv	a0,s4
ffffffffc0204aee:	c5dff0ef          	jal	ra,ffffffffc020474a <up>
ffffffffc0204af2:	04092823          	sw	zero,80(s2)
ffffffffc0204af6:	60a6                	ld	ra,72(sp)
ffffffffc0204af8:	8522                	mv	a0,s0
ffffffffc0204afa:	6406                	ld	s0,64(sp)
ffffffffc0204afc:	74e2                	ld	s1,56(sp)
ffffffffc0204afe:	7942                	ld	s2,48(sp)
ffffffffc0204b00:	79a2                	ld	s3,40(sp)
ffffffffc0204b02:	7a02                	ld	s4,32(sp)
ffffffffc0204b04:	6161                	addi	sp,sp,80
ffffffffc0204b06:	8082                	ret
ffffffffc0204b08:	02000693          	li	a3,32
ffffffffc0204b0c:	860a                	mv	a2,sp
ffffffffc0204b0e:	85a6                	mv	a1,s1
ffffffffc0204b10:	9cdfe0ef          	jal	ra,ffffffffc02034dc <copy_to_user>
ffffffffc0204b14:	f16d                	bnez	a0,ffffffffc0204af6 <sysfile_fstat+0x5e>
ffffffffc0204b16:	5475                	li	s0,-3
ffffffffc0204b18:	bff9                	j	ffffffffc0204af6 <sysfile_fstat+0x5e>
ffffffffc0204b1a:	02000693          	li	a3,32
ffffffffc0204b1e:	860a                	mv	a2,sp
ffffffffc0204b20:	85a6                	mv	a1,s1
ffffffffc0204b22:	854a                	mv	a0,s2
ffffffffc0204b24:	9b9fe0ef          	jal	ra,ffffffffc02034dc <copy_to_user>
ffffffffc0204b28:	f171                	bnez	a0,ffffffffc0204aec <sysfile_fstat+0x54>
ffffffffc0204b2a:	8552                	mv	a0,s4
ffffffffc0204b2c:	c1fff0ef          	jal	ra,ffffffffc020474a <up>
ffffffffc0204b30:	5475                	li	s0,-3
ffffffffc0204b32:	04092823          	sw	zero,80(s2)
ffffffffc0204b36:	b7c1                	j	ffffffffc0204af6 <sysfile_fstat+0x5e>

ffffffffc0204b38 <sysfile_fsync>:
ffffffffc0204b38:	1cd0006f          	j	ffffffffc0205504 <file_fsync>

ffffffffc0204b3c <sysfile_getcwd>:
ffffffffc0204b3c:	715d                	addi	sp,sp,-80
ffffffffc0204b3e:	f44e                	sd	s3,40(sp)
ffffffffc0204b40:	00092997          	auipc	s3,0x92
ffffffffc0204b44:	d8098993          	addi	s3,s3,-640 # ffffffffc02968c0 <current>
ffffffffc0204b48:	0009b783          	ld	a5,0(s3)
ffffffffc0204b4c:	f84a                	sd	s2,48(sp)
ffffffffc0204b4e:	e486                	sd	ra,72(sp)
ffffffffc0204b50:	e0a2                	sd	s0,64(sp)
ffffffffc0204b52:	fc26                	sd	s1,56(sp)
ffffffffc0204b54:	f052                	sd	s4,32(sp)
ffffffffc0204b56:	0287b903          	ld	s2,40(a5)
ffffffffc0204b5a:	cda9                	beqz	a1,ffffffffc0204bb4 <sysfile_getcwd+0x78>
ffffffffc0204b5c:	842e                	mv	s0,a1
ffffffffc0204b5e:	84aa                	mv	s1,a0
ffffffffc0204b60:	04090363          	beqz	s2,ffffffffc0204ba6 <sysfile_getcwd+0x6a>
ffffffffc0204b64:	03890a13          	addi	s4,s2,56
ffffffffc0204b68:	8552                	mv	a0,s4
ffffffffc0204b6a:	be5ff0ef          	jal	ra,ffffffffc020474e <down>
ffffffffc0204b6e:	0009b783          	ld	a5,0(s3)
ffffffffc0204b72:	c781                	beqz	a5,ffffffffc0204b7a <sysfile_getcwd+0x3e>
ffffffffc0204b74:	43dc                	lw	a5,4(a5)
ffffffffc0204b76:	04f92823          	sw	a5,80(s2)
ffffffffc0204b7a:	4685                	li	a3,1
ffffffffc0204b7c:	8622                	mv	a2,s0
ffffffffc0204b7e:	85a6                	mv	a1,s1
ffffffffc0204b80:	854a                	mv	a0,s2
ffffffffc0204b82:	893fe0ef          	jal	ra,ffffffffc0203414 <user_mem_check>
ffffffffc0204b86:	e90d                	bnez	a0,ffffffffc0204bb8 <sysfile_getcwd+0x7c>
ffffffffc0204b88:	5475                	li	s0,-3
ffffffffc0204b8a:	8552                	mv	a0,s4
ffffffffc0204b8c:	bbfff0ef          	jal	ra,ffffffffc020474a <up>
ffffffffc0204b90:	04092823          	sw	zero,80(s2)
ffffffffc0204b94:	60a6                	ld	ra,72(sp)
ffffffffc0204b96:	8522                	mv	a0,s0
ffffffffc0204b98:	6406                	ld	s0,64(sp)
ffffffffc0204b9a:	74e2                	ld	s1,56(sp)
ffffffffc0204b9c:	7942                	ld	s2,48(sp)
ffffffffc0204b9e:	79a2                	ld	s3,40(sp)
ffffffffc0204ba0:	7a02                	ld	s4,32(sp)
ffffffffc0204ba2:	6161                	addi	sp,sp,80
ffffffffc0204ba4:	8082                	ret
ffffffffc0204ba6:	862e                	mv	a2,a1
ffffffffc0204ba8:	4685                	li	a3,1
ffffffffc0204baa:	85aa                	mv	a1,a0
ffffffffc0204bac:	4501                	li	a0,0
ffffffffc0204bae:	867fe0ef          	jal	ra,ffffffffc0203414 <user_mem_check>
ffffffffc0204bb2:	ed09                	bnez	a0,ffffffffc0204bcc <sysfile_getcwd+0x90>
ffffffffc0204bb4:	5475                	li	s0,-3
ffffffffc0204bb6:	bff9                	j	ffffffffc0204b94 <sysfile_getcwd+0x58>
ffffffffc0204bb8:	8622                	mv	a2,s0
ffffffffc0204bba:	4681                	li	a3,0
ffffffffc0204bbc:	85a6                	mv	a1,s1
ffffffffc0204bbe:	850a                	mv	a0,sp
ffffffffc0204bc0:	371000ef          	jal	ra,ffffffffc0205730 <iobuf_init>
ffffffffc0204bc4:	0ec030ef          	jal	ra,ffffffffc0207cb0 <vfs_getcwd>
ffffffffc0204bc8:	842a                	mv	s0,a0
ffffffffc0204bca:	b7c1                	j	ffffffffc0204b8a <sysfile_getcwd+0x4e>
ffffffffc0204bcc:	8622                	mv	a2,s0
ffffffffc0204bce:	4681                	li	a3,0
ffffffffc0204bd0:	85a6                	mv	a1,s1
ffffffffc0204bd2:	850a                	mv	a0,sp
ffffffffc0204bd4:	35d000ef          	jal	ra,ffffffffc0205730 <iobuf_init>
ffffffffc0204bd8:	0d8030ef          	jal	ra,ffffffffc0207cb0 <vfs_getcwd>
ffffffffc0204bdc:	842a                	mv	s0,a0
ffffffffc0204bde:	bf5d                	j	ffffffffc0204b94 <sysfile_getcwd+0x58>

ffffffffc0204be0 <sysfile_getdirentry>:
ffffffffc0204be0:	7139                	addi	sp,sp,-64
ffffffffc0204be2:	e852                	sd	s4,16(sp)
ffffffffc0204be4:	00092a17          	auipc	s4,0x92
ffffffffc0204be8:	cdca0a13          	addi	s4,s4,-804 # ffffffffc02968c0 <current>
ffffffffc0204bec:	000a3703          	ld	a4,0(s4)
ffffffffc0204bf0:	ec4e                	sd	s3,24(sp)
ffffffffc0204bf2:	89aa                	mv	s3,a0
ffffffffc0204bf4:	10800513          	li	a0,264
ffffffffc0204bf8:	f426                	sd	s1,40(sp)
ffffffffc0204bfa:	f04a                	sd	s2,32(sp)
ffffffffc0204bfc:	fc06                	sd	ra,56(sp)
ffffffffc0204bfe:	f822                	sd	s0,48(sp)
ffffffffc0204c00:	e456                	sd	s5,8(sp)
ffffffffc0204c02:	7704                	ld	s1,40(a4)
ffffffffc0204c04:	892e                	mv	s2,a1
ffffffffc0204c06:	bc1fe0ef          	jal	ra,ffffffffc02037c6 <kmalloc>
ffffffffc0204c0a:	c169                	beqz	a0,ffffffffc0204ccc <sysfile_getdirentry+0xec>
ffffffffc0204c0c:	842a                	mv	s0,a0
ffffffffc0204c0e:	c8c1                	beqz	s1,ffffffffc0204c9e <sysfile_getdirentry+0xbe>
ffffffffc0204c10:	03848a93          	addi	s5,s1,56
ffffffffc0204c14:	8556                	mv	a0,s5
ffffffffc0204c16:	b39ff0ef          	jal	ra,ffffffffc020474e <down>
ffffffffc0204c1a:	000a3783          	ld	a5,0(s4)
ffffffffc0204c1e:	c399                	beqz	a5,ffffffffc0204c24 <sysfile_getdirentry+0x44>
ffffffffc0204c20:	43dc                	lw	a5,4(a5)
ffffffffc0204c22:	c8bc                	sw	a5,80(s1)
ffffffffc0204c24:	4705                	li	a4,1
ffffffffc0204c26:	46a1                	li	a3,8
ffffffffc0204c28:	864a                	mv	a2,s2
ffffffffc0204c2a:	85a2                	mv	a1,s0
ffffffffc0204c2c:	8526                	mv	a0,s1
ffffffffc0204c2e:	87bfe0ef          	jal	ra,ffffffffc02034a8 <copy_from_user>
ffffffffc0204c32:	e505                	bnez	a0,ffffffffc0204c5a <sysfile_getdirentry+0x7a>
ffffffffc0204c34:	8556                	mv	a0,s5
ffffffffc0204c36:	b15ff0ef          	jal	ra,ffffffffc020474a <up>
ffffffffc0204c3a:	59f5                	li	s3,-3
ffffffffc0204c3c:	0404a823          	sw	zero,80(s1)
ffffffffc0204c40:	8522                	mv	a0,s0
ffffffffc0204c42:	c35fe0ef          	jal	ra,ffffffffc0203876 <kfree>
ffffffffc0204c46:	70e2                	ld	ra,56(sp)
ffffffffc0204c48:	7442                	ld	s0,48(sp)
ffffffffc0204c4a:	74a2                	ld	s1,40(sp)
ffffffffc0204c4c:	7902                	ld	s2,32(sp)
ffffffffc0204c4e:	6a42                	ld	s4,16(sp)
ffffffffc0204c50:	6aa2                	ld	s5,8(sp)
ffffffffc0204c52:	854e                	mv	a0,s3
ffffffffc0204c54:	69e2                	ld	s3,24(sp)
ffffffffc0204c56:	6121                	addi	sp,sp,64
ffffffffc0204c58:	8082                	ret
ffffffffc0204c5a:	8556                	mv	a0,s5
ffffffffc0204c5c:	aefff0ef          	jal	ra,ffffffffc020474a <up>
ffffffffc0204c60:	854e                	mv	a0,s3
ffffffffc0204c62:	85a2                	mv	a1,s0
ffffffffc0204c64:	0404a823          	sw	zero,80(s1)
ffffffffc0204c68:	14b000ef          	jal	ra,ffffffffc02055b2 <file_getdirentry>
ffffffffc0204c6c:	89aa                	mv	s3,a0
ffffffffc0204c6e:	f969                	bnez	a0,ffffffffc0204c40 <sysfile_getdirentry+0x60>
ffffffffc0204c70:	8556                	mv	a0,s5
ffffffffc0204c72:	addff0ef          	jal	ra,ffffffffc020474e <down>
ffffffffc0204c76:	000a3783          	ld	a5,0(s4)
ffffffffc0204c7a:	c399                	beqz	a5,ffffffffc0204c80 <sysfile_getdirentry+0xa0>
ffffffffc0204c7c:	43dc                	lw	a5,4(a5)
ffffffffc0204c7e:	c8bc                	sw	a5,80(s1)
ffffffffc0204c80:	10800693          	li	a3,264
ffffffffc0204c84:	8622                	mv	a2,s0
ffffffffc0204c86:	85ca                	mv	a1,s2
ffffffffc0204c88:	8526                	mv	a0,s1
ffffffffc0204c8a:	853fe0ef          	jal	ra,ffffffffc02034dc <copy_to_user>
ffffffffc0204c8e:	e111                	bnez	a0,ffffffffc0204c92 <sysfile_getdirentry+0xb2>
ffffffffc0204c90:	59f5                	li	s3,-3
ffffffffc0204c92:	8556                	mv	a0,s5
ffffffffc0204c94:	ab7ff0ef          	jal	ra,ffffffffc020474a <up>
ffffffffc0204c98:	0404a823          	sw	zero,80(s1)
ffffffffc0204c9c:	b755                	j	ffffffffc0204c40 <sysfile_getdirentry+0x60>
ffffffffc0204c9e:	85aa                	mv	a1,a0
ffffffffc0204ca0:	4705                	li	a4,1
ffffffffc0204ca2:	46a1                	li	a3,8
ffffffffc0204ca4:	864a                	mv	a2,s2
ffffffffc0204ca6:	4501                	li	a0,0
ffffffffc0204ca8:	801fe0ef          	jal	ra,ffffffffc02034a8 <copy_from_user>
ffffffffc0204cac:	cd11                	beqz	a0,ffffffffc0204cc8 <sysfile_getdirentry+0xe8>
ffffffffc0204cae:	854e                	mv	a0,s3
ffffffffc0204cb0:	85a2                	mv	a1,s0
ffffffffc0204cb2:	101000ef          	jal	ra,ffffffffc02055b2 <file_getdirentry>
ffffffffc0204cb6:	89aa                	mv	s3,a0
ffffffffc0204cb8:	f541                	bnez	a0,ffffffffc0204c40 <sysfile_getdirentry+0x60>
ffffffffc0204cba:	10800693          	li	a3,264
ffffffffc0204cbe:	8622                	mv	a2,s0
ffffffffc0204cc0:	85ca                	mv	a1,s2
ffffffffc0204cc2:	81bfe0ef          	jal	ra,ffffffffc02034dc <copy_to_user>
ffffffffc0204cc6:	fd2d                	bnez	a0,ffffffffc0204c40 <sysfile_getdirentry+0x60>
ffffffffc0204cc8:	59f5                	li	s3,-3
ffffffffc0204cca:	bf9d                	j	ffffffffc0204c40 <sysfile_getdirentry+0x60>
ffffffffc0204ccc:	59f1                	li	s3,-4
ffffffffc0204cce:	bfa5                	j	ffffffffc0204c46 <sysfile_getdirentry+0x66>

ffffffffc0204cd0 <sysfile_dup>:
ffffffffc0204cd0:	1c90006f          	j	ffffffffc0205698 <file_dup>

ffffffffc0204cd4 <get_fd_array.part.0>:
ffffffffc0204cd4:	1141                	addi	sp,sp,-16
ffffffffc0204cd6:	00008697          	auipc	a3,0x8
ffffffffc0204cda:	33a68693          	addi	a3,a3,826 # ffffffffc020d010 <default_pmm_manager+0x148>
ffffffffc0204cde:	00007617          	auipc	a2,0x7
ffffffffc0204ce2:	b2a60613          	addi	a2,a2,-1238 # ffffffffc020b808 <commands+0x60>
ffffffffc0204ce6:	45d1                	li	a1,20
ffffffffc0204ce8:	00008517          	auipc	a0,0x8
ffffffffc0204cec:	35850513          	addi	a0,a0,856 # ffffffffc020d040 <default_pmm_manager+0x178>
ffffffffc0204cf0:	e406                	sd	ra,8(sp)
ffffffffc0204cf2:	d3cfb0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0204cf6 <fd_array_alloc>:
ffffffffc0204cf6:	00092797          	auipc	a5,0x92
ffffffffc0204cfa:	bca7b783          	ld	a5,-1078(a5) # ffffffffc02968c0 <current>
ffffffffc0204cfe:	1487b783          	ld	a5,328(a5)
ffffffffc0204d02:	1141                	addi	sp,sp,-16
ffffffffc0204d04:	e406                	sd	ra,8(sp)
ffffffffc0204d06:	c3a5                	beqz	a5,ffffffffc0204d66 <fd_array_alloc+0x70>
ffffffffc0204d08:	4b98                	lw	a4,16(a5)
ffffffffc0204d0a:	04e05e63          	blez	a4,ffffffffc0204d66 <fd_array_alloc+0x70>
ffffffffc0204d0e:	775d                	lui	a4,0xffff7
ffffffffc0204d10:	ad970713          	addi	a4,a4,-1319 # ffffffffffff6ad9 <end+0x3fd601c9>
ffffffffc0204d14:	679c                	ld	a5,8(a5)
ffffffffc0204d16:	02e50863          	beq	a0,a4,ffffffffc0204d46 <fd_array_alloc+0x50>
ffffffffc0204d1a:	04700713          	li	a4,71
ffffffffc0204d1e:	04a76263          	bltu	a4,a0,ffffffffc0204d62 <fd_array_alloc+0x6c>
ffffffffc0204d22:	00351713          	slli	a4,a0,0x3
ffffffffc0204d26:	40a70533          	sub	a0,a4,a0
ffffffffc0204d2a:	050e                	slli	a0,a0,0x3
ffffffffc0204d2c:	97aa                	add	a5,a5,a0
ffffffffc0204d2e:	4398                	lw	a4,0(a5)
ffffffffc0204d30:	e71d                	bnez	a4,ffffffffc0204d5e <fd_array_alloc+0x68>
ffffffffc0204d32:	5b88                	lw	a0,48(a5)
ffffffffc0204d34:	e91d                	bnez	a0,ffffffffc0204d6a <fd_array_alloc+0x74>
ffffffffc0204d36:	4705                	li	a4,1
ffffffffc0204d38:	c398                	sw	a4,0(a5)
ffffffffc0204d3a:	0207b423          	sd	zero,40(a5)
ffffffffc0204d3e:	e19c                	sd	a5,0(a1)
ffffffffc0204d40:	60a2                	ld	ra,8(sp)
ffffffffc0204d42:	0141                	addi	sp,sp,16
ffffffffc0204d44:	8082                	ret
ffffffffc0204d46:	6685                	lui	a3,0x1
ffffffffc0204d48:	fc068693          	addi	a3,a3,-64 # fc0 <_binary_bin_swap_img_size-0x6d40>
ffffffffc0204d4c:	96be                	add	a3,a3,a5
ffffffffc0204d4e:	4398                	lw	a4,0(a5)
ffffffffc0204d50:	d36d                	beqz	a4,ffffffffc0204d32 <fd_array_alloc+0x3c>
ffffffffc0204d52:	03878793          	addi	a5,a5,56
ffffffffc0204d56:	fef69ce3          	bne	a3,a5,ffffffffc0204d4e <fd_array_alloc+0x58>
ffffffffc0204d5a:	5529                	li	a0,-22
ffffffffc0204d5c:	b7d5                	j	ffffffffc0204d40 <fd_array_alloc+0x4a>
ffffffffc0204d5e:	5545                	li	a0,-15
ffffffffc0204d60:	b7c5                	j	ffffffffc0204d40 <fd_array_alloc+0x4a>
ffffffffc0204d62:	5575                	li	a0,-3
ffffffffc0204d64:	bff1                	j	ffffffffc0204d40 <fd_array_alloc+0x4a>
ffffffffc0204d66:	f6fff0ef          	jal	ra,ffffffffc0204cd4 <get_fd_array.part.0>
ffffffffc0204d6a:	00008697          	auipc	a3,0x8
ffffffffc0204d6e:	2e668693          	addi	a3,a3,742 # ffffffffc020d050 <default_pmm_manager+0x188>
ffffffffc0204d72:	00007617          	auipc	a2,0x7
ffffffffc0204d76:	a9660613          	addi	a2,a2,-1386 # ffffffffc020b808 <commands+0x60>
ffffffffc0204d7a:	03b00593          	li	a1,59
ffffffffc0204d7e:	00008517          	auipc	a0,0x8
ffffffffc0204d82:	2c250513          	addi	a0,a0,706 # ffffffffc020d040 <default_pmm_manager+0x178>
ffffffffc0204d86:	ca8fb0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0204d8a <fd_array_free>:
ffffffffc0204d8a:	411c                	lw	a5,0(a0)
ffffffffc0204d8c:	1141                	addi	sp,sp,-16
ffffffffc0204d8e:	e022                	sd	s0,0(sp)
ffffffffc0204d90:	e406                	sd	ra,8(sp)
ffffffffc0204d92:	4705                	li	a4,1
ffffffffc0204d94:	842a                	mv	s0,a0
ffffffffc0204d96:	04e78063          	beq	a5,a4,ffffffffc0204dd6 <fd_array_free+0x4c>
ffffffffc0204d9a:	470d                	li	a4,3
ffffffffc0204d9c:	04e79563          	bne	a5,a4,ffffffffc0204de6 <fd_array_free+0x5c>
ffffffffc0204da0:	591c                	lw	a5,48(a0)
ffffffffc0204da2:	c38d                	beqz	a5,ffffffffc0204dc4 <fd_array_free+0x3a>
ffffffffc0204da4:	00008697          	auipc	a3,0x8
ffffffffc0204da8:	2ac68693          	addi	a3,a3,684 # ffffffffc020d050 <default_pmm_manager+0x188>
ffffffffc0204dac:	00007617          	auipc	a2,0x7
ffffffffc0204db0:	a5c60613          	addi	a2,a2,-1444 # ffffffffc020b808 <commands+0x60>
ffffffffc0204db4:	04500593          	li	a1,69
ffffffffc0204db8:	00008517          	auipc	a0,0x8
ffffffffc0204dbc:	28850513          	addi	a0,a0,648 # ffffffffc020d040 <default_pmm_manager+0x178>
ffffffffc0204dc0:	c6efb0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0204dc4:	7408                	ld	a0,40(s0)
ffffffffc0204dc6:	5da030ef          	jal	ra,ffffffffc02083a0 <vfs_close>
ffffffffc0204dca:	60a2                	ld	ra,8(sp)
ffffffffc0204dcc:	00042023          	sw	zero,0(s0)
ffffffffc0204dd0:	6402                	ld	s0,0(sp)
ffffffffc0204dd2:	0141                	addi	sp,sp,16
ffffffffc0204dd4:	8082                	ret
ffffffffc0204dd6:	591c                	lw	a5,48(a0)
ffffffffc0204dd8:	f7f1                	bnez	a5,ffffffffc0204da4 <fd_array_free+0x1a>
ffffffffc0204dda:	60a2                	ld	ra,8(sp)
ffffffffc0204ddc:	00042023          	sw	zero,0(s0)
ffffffffc0204de0:	6402                	ld	s0,0(sp)
ffffffffc0204de2:	0141                	addi	sp,sp,16
ffffffffc0204de4:	8082                	ret
ffffffffc0204de6:	00008697          	auipc	a3,0x8
ffffffffc0204dea:	2a268693          	addi	a3,a3,674 # ffffffffc020d088 <default_pmm_manager+0x1c0>
ffffffffc0204dee:	00007617          	auipc	a2,0x7
ffffffffc0204df2:	a1a60613          	addi	a2,a2,-1510 # ffffffffc020b808 <commands+0x60>
ffffffffc0204df6:	04400593          	li	a1,68
ffffffffc0204dfa:	00008517          	auipc	a0,0x8
ffffffffc0204dfe:	24650513          	addi	a0,a0,582 # ffffffffc020d040 <default_pmm_manager+0x178>
ffffffffc0204e02:	c2cfb0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0204e06 <fd_array_release>:
ffffffffc0204e06:	4118                	lw	a4,0(a0)
ffffffffc0204e08:	1141                	addi	sp,sp,-16
ffffffffc0204e0a:	e406                	sd	ra,8(sp)
ffffffffc0204e0c:	4685                	li	a3,1
ffffffffc0204e0e:	3779                	addiw	a4,a4,-2
ffffffffc0204e10:	04e6e063          	bltu	a3,a4,ffffffffc0204e50 <fd_array_release+0x4a>
ffffffffc0204e14:	5918                	lw	a4,48(a0)
ffffffffc0204e16:	00e05d63          	blez	a4,ffffffffc0204e30 <fd_array_release+0x2a>
ffffffffc0204e1a:	fff7069b          	addiw	a3,a4,-1
ffffffffc0204e1e:	d914                	sw	a3,48(a0)
ffffffffc0204e20:	c681                	beqz	a3,ffffffffc0204e28 <fd_array_release+0x22>
ffffffffc0204e22:	60a2                	ld	ra,8(sp)
ffffffffc0204e24:	0141                	addi	sp,sp,16
ffffffffc0204e26:	8082                	ret
ffffffffc0204e28:	60a2                	ld	ra,8(sp)
ffffffffc0204e2a:	0141                	addi	sp,sp,16
ffffffffc0204e2c:	f5fff06f          	j	ffffffffc0204d8a <fd_array_free>
ffffffffc0204e30:	00008697          	auipc	a3,0x8
ffffffffc0204e34:	2c868693          	addi	a3,a3,712 # ffffffffc020d0f8 <default_pmm_manager+0x230>
ffffffffc0204e38:	00007617          	auipc	a2,0x7
ffffffffc0204e3c:	9d060613          	addi	a2,a2,-1584 # ffffffffc020b808 <commands+0x60>
ffffffffc0204e40:	05600593          	li	a1,86
ffffffffc0204e44:	00008517          	auipc	a0,0x8
ffffffffc0204e48:	1fc50513          	addi	a0,a0,508 # ffffffffc020d040 <default_pmm_manager+0x178>
ffffffffc0204e4c:	be2fb0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0204e50:	00008697          	auipc	a3,0x8
ffffffffc0204e54:	27068693          	addi	a3,a3,624 # ffffffffc020d0c0 <default_pmm_manager+0x1f8>
ffffffffc0204e58:	00007617          	auipc	a2,0x7
ffffffffc0204e5c:	9b060613          	addi	a2,a2,-1616 # ffffffffc020b808 <commands+0x60>
ffffffffc0204e60:	05500593          	li	a1,85
ffffffffc0204e64:	00008517          	auipc	a0,0x8
ffffffffc0204e68:	1dc50513          	addi	a0,a0,476 # ffffffffc020d040 <default_pmm_manager+0x178>
ffffffffc0204e6c:	bc2fb0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0204e70 <fd_array_open.part.0>:
ffffffffc0204e70:	1141                	addi	sp,sp,-16
ffffffffc0204e72:	00008697          	auipc	a3,0x8
ffffffffc0204e76:	29e68693          	addi	a3,a3,670 # ffffffffc020d110 <default_pmm_manager+0x248>
ffffffffc0204e7a:	00007617          	auipc	a2,0x7
ffffffffc0204e7e:	98e60613          	addi	a2,a2,-1650 # ffffffffc020b808 <commands+0x60>
ffffffffc0204e82:	05f00593          	li	a1,95
ffffffffc0204e86:	00008517          	auipc	a0,0x8
ffffffffc0204e8a:	1ba50513          	addi	a0,a0,442 # ffffffffc020d040 <default_pmm_manager+0x178>
ffffffffc0204e8e:	e406                	sd	ra,8(sp)
ffffffffc0204e90:	b9efb0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0204e94 <fd_array_init>:
ffffffffc0204e94:	4781                	li	a5,0
ffffffffc0204e96:	04800713          	li	a4,72
ffffffffc0204e9a:	cd1c                	sw	a5,24(a0)
ffffffffc0204e9c:	02052823          	sw	zero,48(a0)
ffffffffc0204ea0:	00052023          	sw	zero,0(a0)
ffffffffc0204ea4:	2785                	addiw	a5,a5,1
ffffffffc0204ea6:	03850513          	addi	a0,a0,56
ffffffffc0204eaa:	fee798e3          	bne	a5,a4,ffffffffc0204e9a <fd_array_init+0x6>
ffffffffc0204eae:	8082                	ret

ffffffffc0204eb0 <fd_array_close>:
ffffffffc0204eb0:	4118                	lw	a4,0(a0)
ffffffffc0204eb2:	1141                	addi	sp,sp,-16
ffffffffc0204eb4:	e406                	sd	ra,8(sp)
ffffffffc0204eb6:	e022                	sd	s0,0(sp)
ffffffffc0204eb8:	4789                	li	a5,2
ffffffffc0204eba:	04f71a63          	bne	a4,a5,ffffffffc0204f0e <fd_array_close+0x5e>
ffffffffc0204ebe:	591c                	lw	a5,48(a0)
ffffffffc0204ec0:	842a                	mv	s0,a0
ffffffffc0204ec2:	02f05663          	blez	a5,ffffffffc0204eee <fd_array_close+0x3e>
ffffffffc0204ec6:	37fd                	addiw	a5,a5,-1
ffffffffc0204ec8:	470d                	li	a4,3
ffffffffc0204eca:	c118                	sw	a4,0(a0)
ffffffffc0204ecc:	d91c                	sw	a5,48(a0)
ffffffffc0204ece:	0007871b          	sext.w	a4,a5
ffffffffc0204ed2:	c709                	beqz	a4,ffffffffc0204edc <fd_array_close+0x2c>
ffffffffc0204ed4:	60a2                	ld	ra,8(sp)
ffffffffc0204ed6:	6402                	ld	s0,0(sp)
ffffffffc0204ed8:	0141                	addi	sp,sp,16
ffffffffc0204eda:	8082                	ret
ffffffffc0204edc:	7508                	ld	a0,40(a0)
ffffffffc0204ede:	4c2030ef          	jal	ra,ffffffffc02083a0 <vfs_close>
ffffffffc0204ee2:	60a2                	ld	ra,8(sp)
ffffffffc0204ee4:	00042023          	sw	zero,0(s0)
ffffffffc0204ee8:	6402                	ld	s0,0(sp)
ffffffffc0204eea:	0141                	addi	sp,sp,16
ffffffffc0204eec:	8082                	ret
ffffffffc0204eee:	00008697          	auipc	a3,0x8
ffffffffc0204ef2:	20a68693          	addi	a3,a3,522 # ffffffffc020d0f8 <default_pmm_manager+0x230>
ffffffffc0204ef6:	00007617          	auipc	a2,0x7
ffffffffc0204efa:	91260613          	addi	a2,a2,-1774 # ffffffffc020b808 <commands+0x60>
ffffffffc0204efe:	06800593          	li	a1,104
ffffffffc0204f02:	00008517          	auipc	a0,0x8
ffffffffc0204f06:	13e50513          	addi	a0,a0,318 # ffffffffc020d040 <default_pmm_manager+0x178>
ffffffffc0204f0a:	b24fb0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0204f0e:	00008697          	auipc	a3,0x8
ffffffffc0204f12:	15a68693          	addi	a3,a3,346 # ffffffffc020d068 <default_pmm_manager+0x1a0>
ffffffffc0204f16:	00007617          	auipc	a2,0x7
ffffffffc0204f1a:	8f260613          	addi	a2,a2,-1806 # ffffffffc020b808 <commands+0x60>
ffffffffc0204f1e:	06700593          	li	a1,103
ffffffffc0204f22:	00008517          	auipc	a0,0x8
ffffffffc0204f26:	11e50513          	addi	a0,a0,286 # ffffffffc020d040 <default_pmm_manager+0x178>
ffffffffc0204f2a:	b04fb0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0204f2e <fd_array_dup>:
ffffffffc0204f2e:	7179                	addi	sp,sp,-48
ffffffffc0204f30:	e84a                	sd	s2,16(sp)
ffffffffc0204f32:	00052903          	lw	s2,0(a0)
ffffffffc0204f36:	f406                	sd	ra,40(sp)
ffffffffc0204f38:	f022                	sd	s0,32(sp)
ffffffffc0204f3a:	ec26                	sd	s1,24(sp)
ffffffffc0204f3c:	e44e                	sd	s3,8(sp)
ffffffffc0204f3e:	4785                	li	a5,1
ffffffffc0204f40:	04f91663          	bne	s2,a5,ffffffffc0204f8c <fd_array_dup+0x5e>
ffffffffc0204f44:	0005a983          	lw	s3,0(a1)
ffffffffc0204f48:	4789                	li	a5,2
ffffffffc0204f4a:	04f99163          	bne	s3,a5,ffffffffc0204f8c <fd_array_dup+0x5e>
ffffffffc0204f4e:	7584                	ld	s1,40(a1)
ffffffffc0204f50:	699c                	ld	a5,16(a1)
ffffffffc0204f52:	7194                	ld	a3,32(a1)
ffffffffc0204f54:	6598                	ld	a4,8(a1)
ffffffffc0204f56:	842a                	mv	s0,a0
ffffffffc0204f58:	e91c                	sd	a5,16(a0)
ffffffffc0204f5a:	f114                	sd	a3,32(a0)
ffffffffc0204f5c:	e518                	sd	a4,8(a0)
ffffffffc0204f5e:	8526                	mv	a0,s1
ffffffffc0204f60:	082030ef          	jal	ra,ffffffffc0207fe2 <inode_ref_inc>
ffffffffc0204f64:	8526                	mv	a0,s1
ffffffffc0204f66:	088030ef          	jal	ra,ffffffffc0207fee <inode_open_inc>
ffffffffc0204f6a:	401c                	lw	a5,0(s0)
ffffffffc0204f6c:	f404                	sd	s1,40(s0)
ffffffffc0204f6e:	03279f63          	bne	a5,s2,ffffffffc0204fac <fd_array_dup+0x7e>
ffffffffc0204f72:	cc8d                	beqz	s1,ffffffffc0204fac <fd_array_dup+0x7e>
ffffffffc0204f74:	581c                	lw	a5,48(s0)
ffffffffc0204f76:	01342023          	sw	s3,0(s0)
ffffffffc0204f7a:	70a2                	ld	ra,40(sp)
ffffffffc0204f7c:	2785                	addiw	a5,a5,1
ffffffffc0204f7e:	d81c                	sw	a5,48(s0)
ffffffffc0204f80:	7402                	ld	s0,32(sp)
ffffffffc0204f82:	64e2                	ld	s1,24(sp)
ffffffffc0204f84:	6942                	ld	s2,16(sp)
ffffffffc0204f86:	69a2                	ld	s3,8(sp)
ffffffffc0204f88:	6145                	addi	sp,sp,48
ffffffffc0204f8a:	8082                	ret
ffffffffc0204f8c:	00008697          	auipc	a3,0x8
ffffffffc0204f90:	1b468693          	addi	a3,a3,436 # ffffffffc020d140 <default_pmm_manager+0x278>
ffffffffc0204f94:	00007617          	auipc	a2,0x7
ffffffffc0204f98:	87460613          	addi	a2,a2,-1932 # ffffffffc020b808 <commands+0x60>
ffffffffc0204f9c:	07300593          	li	a1,115
ffffffffc0204fa0:	00008517          	auipc	a0,0x8
ffffffffc0204fa4:	0a050513          	addi	a0,a0,160 # ffffffffc020d040 <default_pmm_manager+0x178>
ffffffffc0204fa8:	a86fb0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0204fac:	ec5ff0ef          	jal	ra,ffffffffc0204e70 <fd_array_open.part.0>

ffffffffc0204fb0 <file_testfd>:
ffffffffc0204fb0:	04700793          	li	a5,71
ffffffffc0204fb4:	04a7e263          	bltu	a5,a0,ffffffffc0204ff8 <file_testfd+0x48>
ffffffffc0204fb8:	00092797          	auipc	a5,0x92
ffffffffc0204fbc:	9087b783          	ld	a5,-1784(a5) # ffffffffc02968c0 <current>
ffffffffc0204fc0:	1487b783          	ld	a5,328(a5)
ffffffffc0204fc4:	cf85                	beqz	a5,ffffffffc0204ffc <file_testfd+0x4c>
ffffffffc0204fc6:	4b98                	lw	a4,16(a5)
ffffffffc0204fc8:	02e05a63          	blez	a4,ffffffffc0204ffc <file_testfd+0x4c>
ffffffffc0204fcc:	6798                	ld	a4,8(a5)
ffffffffc0204fce:	00351793          	slli	a5,a0,0x3
ffffffffc0204fd2:	8f89                	sub	a5,a5,a0
ffffffffc0204fd4:	078e                	slli	a5,a5,0x3
ffffffffc0204fd6:	97ba                	add	a5,a5,a4
ffffffffc0204fd8:	4394                	lw	a3,0(a5)
ffffffffc0204fda:	4709                	li	a4,2
ffffffffc0204fdc:	00e69e63          	bne	a3,a4,ffffffffc0204ff8 <file_testfd+0x48>
ffffffffc0204fe0:	4f98                	lw	a4,24(a5)
ffffffffc0204fe2:	00a71b63          	bne	a4,a0,ffffffffc0204ff8 <file_testfd+0x48>
ffffffffc0204fe6:	c199                	beqz	a1,ffffffffc0204fec <file_testfd+0x3c>
ffffffffc0204fe8:	6788                	ld	a0,8(a5)
ffffffffc0204fea:	c901                	beqz	a0,ffffffffc0204ffa <file_testfd+0x4a>
ffffffffc0204fec:	4505                	li	a0,1
ffffffffc0204fee:	c611                	beqz	a2,ffffffffc0204ffa <file_testfd+0x4a>
ffffffffc0204ff0:	6b88                	ld	a0,16(a5)
ffffffffc0204ff2:	00a03533          	snez	a0,a0
ffffffffc0204ff6:	8082                	ret
ffffffffc0204ff8:	4501                	li	a0,0
ffffffffc0204ffa:	8082                	ret
ffffffffc0204ffc:	1141                	addi	sp,sp,-16
ffffffffc0204ffe:	e406                	sd	ra,8(sp)
ffffffffc0205000:	cd5ff0ef          	jal	ra,ffffffffc0204cd4 <get_fd_array.part.0>

ffffffffc0205004 <file_open>:
ffffffffc0205004:	711d                	addi	sp,sp,-96
ffffffffc0205006:	ec86                	sd	ra,88(sp)
ffffffffc0205008:	e8a2                	sd	s0,80(sp)
ffffffffc020500a:	e4a6                	sd	s1,72(sp)
ffffffffc020500c:	e0ca                	sd	s2,64(sp)
ffffffffc020500e:	fc4e                	sd	s3,56(sp)
ffffffffc0205010:	f852                	sd	s4,48(sp)
ffffffffc0205012:	0035f793          	andi	a5,a1,3
ffffffffc0205016:	470d                	li	a4,3
ffffffffc0205018:	0ce78163          	beq	a5,a4,ffffffffc02050da <file_open+0xd6>
ffffffffc020501c:	078e                	slli	a5,a5,0x3
ffffffffc020501e:	00008717          	auipc	a4,0x8
ffffffffc0205022:	39270713          	addi	a4,a4,914 # ffffffffc020d3b0 <CSWTCH.79>
ffffffffc0205026:	892a                	mv	s2,a0
ffffffffc0205028:	00008697          	auipc	a3,0x8
ffffffffc020502c:	37068693          	addi	a3,a3,880 # ffffffffc020d398 <CSWTCH.78>
ffffffffc0205030:	755d                	lui	a0,0xffff7
ffffffffc0205032:	96be                	add	a3,a3,a5
ffffffffc0205034:	84ae                	mv	s1,a1
ffffffffc0205036:	97ba                	add	a5,a5,a4
ffffffffc0205038:	858a                	mv	a1,sp
ffffffffc020503a:	ad950513          	addi	a0,a0,-1319 # ffffffffffff6ad9 <end+0x3fd601c9>
ffffffffc020503e:	0006ba03          	ld	s4,0(a3)
ffffffffc0205042:	0007b983          	ld	s3,0(a5)
ffffffffc0205046:	cb1ff0ef          	jal	ra,ffffffffc0204cf6 <fd_array_alloc>
ffffffffc020504a:	842a                	mv	s0,a0
ffffffffc020504c:	c911                	beqz	a0,ffffffffc0205060 <file_open+0x5c>
ffffffffc020504e:	60e6                	ld	ra,88(sp)
ffffffffc0205050:	8522                	mv	a0,s0
ffffffffc0205052:	6446                	ld	s0,80(sp)
ffffffffc0205054:	64a6                	ld	s1,72(sp)
ffffffffc0205056:	6906                	ld	s2,64(sp)
ffffffffc0205058:	79e2                	ld	s3,56(sp)
ffffffffc020505a:	7a42                	ld	s4,48(sp)
ffffffffc020505c:	6125                	addi	sp,sp,96
ffffffffc020505e:	8082                	ret
ffffffffc0205060:	0030                	addi	a2,sp,8
ffffffffc0205062:	85a6                	mv	a1,s1
ffffffffc0205064:	854a                	mv	a0,s2
ffffffffc0205066:	194030ef          	jal	ra,ffffffffc02081fa <vfs_open>
ffffffffc020506a:	842a                	mv	s0,a0
ffffffffc020506c:	e13d                	bnez	a0,ffffffffc02050d2 <file_open+0xce>
ffffffffc020506e:	6782                	ld	a5,0(sp)
ffffffffc0205070:	0204f493          	andi	s1,s1,32
ffffffffc0205074:	6422                	ld	s0,8(sp)
ffffffffc0205076:	0207b023          	sd	zero,32(a5)
ffffffffc020507a:	c885                	beqz	s1,ffffffffc02050aa <file_open+0xa6>
ffffffffc020507c:	c03d                	beqz	s0,ffffffffc02050e2 <file_open+0xde>
ffffffffc020507e:	783c                	ld	a5,112(s0)
ffffffffc0205080:	c3ad                	beqz	a5,ffffffffc02050e2 <file_open+0xde>
ffffffffc0205082:	779c                	ld	a5,40(a5)
ffffffffc0205084:	cfb9                	beqz	a5,ffffffffc02050e2 <file_open+0xde>
ffffffffc0205086:	8522                	mv	a0,s0
ffffffffc0205088:	00008597          	auipc	a1,0x8
ffffffffc020508c:	14058593          	addi	a1,a1,320 # ffffffffc020d1c8 <default_pmm_manager+0x300>
ffffffffc0205090:	76b020ef          	jal	ra,ffffffffc0207ffa <inode_check>
ffffffffc0205094:	783c                	ld	a5,112(s0)
ffffffffc0205096:	6522                	ld	a0,8(sp)
ffffffffc0205098:	080c                	addi	a1,sp,16
ffffffffc020509a:	779c                	ld	a5,40(a5)
ffffffffc020509c:	9782                	jalr	a5
ffffffffc020509e:	842a                	mv	s0,a0
ffffffffc02050a0:	e515                	bnez	a0,ffffffffc02050cc <file_open+0xc8>
ffffffffc02050a2:	6782                	ld	a5,0(sp)
ffffffffc02050a4:	7722                	ld	a4,40(sp)
ffffffffc02050a6:	6422                	ld	s0,8(sp)
ffffffffc02050a8:	f398                	sd	a4,32(a5)
ffffffffc02050aa:	4394                	lw	a3,0(a5)
ffffffffc02050ac:	f780                	sd	s0,40(a5)
ffffffffc02050ae:	0147b423          	sd	s4,8(a5)
ffffffffc02050b2:	0137b823          	sd	s3,16(a5)
ffffffffc02050b6:	4705                	li	a4,1
ffffffffc02050b8:	02e69363          	bne	a3,a4,ffffffffc02050de <file_open+0xda>
ffffffffc02050bc:	c00d                	beqz	s0,ffffffffc02050de <file_open+0xda>
ffffffffc02050be:	5b98                	lw	a4,48(a5)
ffffffffc02050c0:	4689                	li	a3,2
ffffffffc02050c2:	4f80                	lw	s0,24(a5)
ffffffffc02050c4:	2705                	addiw	a4,a4,1
ffffffffc02050c6:	c394                	sw	a3,0(a5)
ffffffffc02050c8:	db98                	sw	a4,48(a5)
ffffffffc02050ca:	b751                	j	ffffffffc020504e <file_open+0x4a>
ffffffffc02050cc:	6522                	ld	a0,8(sp)
ffffffffc02050ce:	2d2030ef          	jal	ra,ffffffffc02083a0 <vfs_close>
ffffffffc02050d2:	6502                	ld	a0,0(sp)
ffffffffc02050d4:	cb7ff0ef          	jal	ra,ffffffffc0204d8a <fd_array_free>
ffffffffc02050d8:	bf9d                	j	ffffffffc020504e <file_open+0x4a>
ffffffffc02050da:	5475                	li	s0,-3
ffffffffc02050dc:	bf8d                	j	ffffffffc020504e <file_open+0x4a>
ffffffffc02050de:	d93ff0ef          	jal	ra,ffffffffc0204e70 <fd_array_open.part.0>
ffffffffc02050e2:	00008697          	auipc	a3,0x8
ffffffffc02050e6:	09668693          	addi	a3,a3,150 # ffffffffc020d178 <default_pmm_manager+0x2b0>
ffffffffc02050ea:	00006617          	auipc	a2,0x6
ffffffffc02050ee:	71e60613          	addi	a2,a2,1822 # ffffffffc020b808 <commands+0x60>
ffffffffc02050f2:	0b500593          	li	a1,181
ffffffffc02050f6:	00008517          	auipc	a0,0x8
ffffffffc02050fa:	f4a50513          	addi	a0,a0,-182 # ffffffffc020d040 <default_pmm_manager+0x178>
ffffffffc02050fe:	930fb0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0205102 <file_close>:
ffffffffc0205102:	04700713          	li	a4,71
ffffffffc0205106:	04a76563          	bltu	a4,a0,ffffffffc0205150 <file_close+0x4e>
ffffffffc020510a:	00091717          	auipc	a4,0x91
ffffffffc020510e:	7b673703          	ld	a4,1974(a4) # ffffffffc02968c0 <current>
ffffffffc0205112:	14873703          	ld	a4,328(a4)
ffffffffc0205116:	1141                	addi	sp,sp,-16
ffffffffc0205118:	e406                	sd	ra,8(sp)
ffffffffc020511a:	cf0d                	beqz	a4,ffffffffc0205154 <file_close+0x52>
ffffffffc020511c:	4b14                	lw	a3,16(a4)
ffffffffc020511e:	02d05b63          	blez	a3,ffffffffc0205154 <file_close+0x52>
ffffffffc0205122:	6718                	ld	a4,8(a4)
ffffffffc0205124:	87aa                	mv	a5,a0
ffffffffc0205126:	050e                	slli	a0,a0,0x3
ffffffffc0205128:	8d1d                	sub	a0,a0,a5
ffffffffc020512a:	050e                	slli	a0,a0,0x3
ffffffffc020512c:	953a                	add	a0,a0,a4
ffffffffc020512e:	4114                	lw	a3,0(a0)
ffffffffc0205130:	4709                	li	a4,2
ffffffffc0205132:	00e69b63          	bne	a3,a4,ffffffffc0205148 <file_close+0x46>
ffffffffc0205136:	4d18                	lw	a4,24(a0)
ffffffffc0205138:	00f71863          	bne	a4,a5,ffffffffc0205148 <file_close+0x46>
ffffffffc020513c:	d75ff0ef          	jal	ra,ffffffffc0204eb0 <fd_array_close>
ffffffffc0205140:	60a2                	ld	ra,8(sp)
ffffffffc0205142:	4501                	li	a0,0
ffffffffc0205144:	0141                	addi	sp,sp,16
ffffffffc0205146:	8082                	ret
ffffffffc0205148:	60a2                	ld	ra,8(sp)
ffffffffc020514a:	5575                	li	a0,-3
ffffffffc020514c:	0141                	addi	sp,sp,16
ffffffffc020514e:	8082                	ret
ffffffffc0205150:	5575                	li	a0,-3
ffffffffc0205152:	8082                	ret
ffffffffc0205154:	b81ff0ef          	jal	ra,ffffffffc0204cd4 <get_fd_array.part.0>

ffffffffc0205158 <file_read>:
ffffffffc0205158:	715d                	addi	sp,sp,-80
ffffffffc020515a:	e486                	sd	ra,72(sp)
ffffffffc020515c:	e0a2                	sd	s0,64(sp)
ffffffffc020515e:	fc26                	sd	s1,56(sp)
ffffffffc0205160:	f84a                	sd	s2,48(sp)
ffffffffc0205162:	f44e                	sd	s3,40(sp)
ffffffffc0205164:	f052                	sd	s4,32(sp)
ffffffffc0205166:	0006b023          	sd	zero,0(a3)
ffffffffc020516a:	04700793          	li	a5,71
ffffffffc020516e:	0aa7e463          	bltu	a5,a0,ffffffffc0205216 <file_read+0xbe>
ffffffffc0205172:	00091797          	auipc	a5,0x91
ffffffffc0205176:	74e7b783          	ld	a5,1870(a5) # ffffffffc02968c0 <current>
ffffffffc020517a:	1487b783          	ld	a5,328(a5)
ffffffffc020517e:	cfd1                	beqz	a5,ffffffffc020521a <file_read+0xc2>
ffffffffc0205180:	4b98                	lw	a4,16(a5)
ffffffffc0205182:	08e05c63          	blez	a4,ffffffffc020521a <file_read+0xc2>
ffffffffc0205186:	6780                	ld	s0,8(a5)
ffffffffc0205188:	00351793          	slli	a5,a0,0x3
ffffffffc020518c:	8f89                	sub	a5,a5,a0
ffffffffc020518e:	078e                	slli	a5,a5,0x3
ffffffffc0205190:	943e                	add	s0,s0,a5
ffffffffc0205192:	00042983          	lw	s3,0(s0)
ffffffffc0205196:	4789                	li	a5,2
ffffffffc0205198:	06f99f63          	bne	s3,a5,ffffffffc0205216 <file_read+0xbe>
ffffffffc020519c:	4c1c                	lw	a5,24(s0)
ffffffffc020519e:	06a79c63          	bne	a5,a0,ffffffffc0205216 <file_read+0xbe>
ffffffffc02051a2:	641c                	ld	a5,8(s0)
ffffffffc02051a4:	cbad                	beqz	a5,ffffffffc0205216 <file_read+0xbe>
ffffffffc02051a6:	581c                	lw	a5,48(s0)
ffffffffc02051a8:	8a36                	mv	s4,a3
ffffffffc02051aa:	7014                	ld	a3,32(s0)
ffffffffc02051ac:	2785                	addiw	a5,a5,1
ffffffffc02051ae:	850a                	mv	a0,sp
ffffffffc02051b0:	d81c                	sw	a5,48(s0)
ffffffffc02051b2:	57e000ef          	jal	ra,ffffffffc0205730 <iobuf_init>
ffffffffc02051b6:	02843903          	ld	s2,40(s0)
ffffffffc02051ba:	84aa                	mv	s1,a0
ffffffffc02051bc:	06090163          	beqz	s2,ffffffffc020521e <file_read+0xc6>
ffffffffc02051c0:	07093783          	ld	a5,112(s2)
ffffffffc02051c4:	cfa9                	beqz	a5,ffffffffc020521e <file_read+0xc6>
ffffffffc02051c6:	6f9c                	ld	a5,24(a5)
ffffffffc02051c8:	cbb9                	beqz	a5,ffffffffc020521e <file_read+0xc6>
ffffffffc02051ca:	00008597          	auipc	a1,0x8
ffffffffc02051ce:	05658593          	addi	a1,a1,86 # ffffffffc020d220 <default_pmm_manager+0x358>
ffffffffc02051d2:	854a                	mv	a0,s2
ffffffffc02051d4:	627020ef          	jal	ra,ffffffffc0207ffa <inode_check>
ffffffffc02051d8:	07093783          	ld	a5,112(s2)
ffffffffc02051dc:	7408                	ld	a0,40(s0)
ffffffffc02051de:	85a6                	mv	a1,s1
ffffffffc02051e0:	6f9c                	ld	a5,24(a5)
ffffffffc02051e2:	9782                	jalr	a5
ffffffffc02051e4:	689c                	ld	a5,16(s1)
ffffffffc02051e6:	6c94                	ld	a3,24(s1)
ffffffffc02051e8:	4018                	lw	a4,0(s0)
ffffffffc02051ea:	84aa                	mv	s1,a0
ffffffffc02051ec:	8f95                	sub	a5,a5,a3
ffffffffc02051ee:	03370063          	beq	a4,s3,ffffffffc020520e <file_read+0xb6>
ffffffffc02051f2:	00fa3023          	sd	a5,0(s4)
ffffffffc02051f6:	8522                	mv	a0,s0
ffffffffc02051f8:	c0fff0ef          	jal	ra,ffffffffc0204e06 <fd_array_release>
ffffffffc02051fc:	60a6                	ld	ra,72(sp)
ffffffffc02051fe:	6406                	ld	s0,64(sp)
ffffffffc0205200:	7942                	ld	s2,48(sp)
ffffffffc0205202:	79a2                	ld	s3,40(sp)
ffffffffc0205204:	7a02                	ld	s4,32(sp)
ffffffffc0205206:	8526                	mv	a0,s1
ffffffffc0205208:	74e2                	ld	s1,56(sp)
ffffffffc020520a:	6161                	addi	sp,sp,80
ffffffffc020520c:	8082                	ret
ffffffffc020520e:	7018                	ld	a4,32(s0)
ffffffffc0205210:	973e                	add	a4,a4,a5
ffffffffc0205212:	f018                	sd	a4,32(s0)
ffffffffc0205214:	bff9                	j	ffffffffc02051f2 <file_read+0x9a>
ffffffffc0205216:	54f5                	li	s1,-3
ffffffffc0205218:	b7d5                	j	ffffffffc02051fc <file_read+0xa4>
ffffffffc020521a:	abbff0ef          	jal	ra,ffffffffc0204cd4 <get_fd_array.part.0>
ffffffffc020521e:	00008697          	auipc	a3,0x8
ffffffffc0205222:	fb268693          	addi	a3,a3,-78 # ffffffffc020d1d0 <default_pmm_manager+0x308>
ffffffffc0205226:	00006617          	auipc	a2,0x6
ffffffffc020522a:	5e260613          	addi	a2,a2,1506 # ffffffffc020b808 <commands+0x60>
ffffffffc020522e:	0de00593          	li	a1,222
ffffffffc0205232:	00008517          	auipc	a0,0x8
ffffffffc0205236:	e0e50513          	addi	a0,a0,-498 # ffffffffc020d040 <default_pmm_manager+0x178>
ffffffffc020523a:	ff5fa0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020523e <file_write>:
ffffffffc020523e:	715d                	addi	sp,sp,-80
ffffffffc0205240:	e486                	sd	ra,72(sp)
ffffffffc0205242:	e0a2                	sd	s0,64(sp)
ffffffffc0205244:	fc26                	sd	s1,56(sp)
ffffffffc0205246:	f84a                	sd	s2,48(sp)
ffffffffc0205248:	f44e                	sd	s3,40(sp)
ffffffffc020524a:	f052                	sd	s4,32(sp)
ffffffffc020524c:	0006b023          	sd	zero,0(a3)
ffffffffc0205250:	04700793          	li	a5,71
ffffffffc0205254:	0aa7e463          	bltu	a5,a0,ffffffffc02052fc <file_write+0xbe>
ffffffffc0205258:	00091797          	auipc	a5,0x91
ffffffffc020525c:	6687b783          	ld	a5,1640(a5) # ffffffffc02968c0 <current>
ffffffffc0205260:	1487b783          	ld	a5,328(a5)
ffffffffc0205264:	cfd1                	beqz	a5,ffffffffc0205300 <file_write+0xc2>
ffffffffc0205266:	4b98                	lw	a4,16(a5)
ffffffffc0205268:	08e05c63          	blez	a4,ffffffffc0205300 <file_write+0xc2>
ffffffffc020526c:	6780                	ld	s0,8(a5)
ffffffffc020526e:	00351793          	slli	a5,a0,0x3
ffffffffc0205272:	8f89                	sub	a5,a5,a0
ffffffffc0205274:	078e                	slli	a5,a5,0x3
ffffffffc0205276:	943e                	add	s0,s0,a5
ffffffffc0205278:	00042983          	lw	s3,0(s0)
ffffffffc020527c:	4789                	li	a5,2
ffffffffc020527e:	06f99f63          	bne	s3,a5,ffffffffc02052fc <file_write+0xbe>
ffffffffc0205282:	4c1c                	lw	a5,24(s0)
ffffffffc0205284:	06a79c63          	bne	a5,a0,ffffffffc02052fc <file_write+0xbe>
ffffffffc0205288:	681c                	ld	a5,16(s0)
ffffffffc020528a:	cbad                	beqz	a5,ffffffffc02052fc <file_write+0xbe>
ffffffffc020528c:	581c                	lw	a5,48(s0)
ffffffffc020528e:	8a36                	mv	s4,a3
ffffffffc0205290:	7014                	ld	a3,32(s0)
ffffffffc0205292:	2785                	addiw	a5,a5,1
ffffffffc0205294:	850a                	mv	a0,sp
ffffffffc0205296:	d81c                	sw	a5,48(s0)
ffffffffc0205298:	498000ef          	jal	ra,ffffffffc0205730 <iobuf_init>
ffffffffc020529c:	02843903          	ld	s2,40(s0)
ffffffffc02052a0:	84aa                	mv	s1,a0
ffffffffc02052a2:	06090163          	beqz	s2,ffffffffc0205304 <file_write+0xc6>
ffffffffc02052a6:	07093783          	ld	a5,112(s2)
ffffffffc02052aa:	cfa9                	beqz	a5,ffffffffc0205304 <file_write+0xc6>
ffffffffc02052ac:	739c                	ld	a5,32(a5)
ffffffffc02052ae:	cbb9                	beqz	a5,ffffffffc0205304 <file_write+0xc6>
ffffffffc02052b0:	00008597          	auipc	a1,0x8
ffffffffc02052b4:	fc858593          	addi	a1,a1,-56 # ffffffffc020d278 <default_pmm_manager+0x3b0>
ffffffffc02052b8:	854a                	mv	a0,s2
ffffffffc02052ba:	541020ef          	jal	ra,ffffffffc0207ffa <inode_check>
ffffffffc02052be:	07093783          	ld	a5,112(s2)
ffffffffc02052c2:	7408                	ld	a0,40(s0)
ffffffffc02052c4:	85a6                	mv	a1,s1
ffffffffc02052c6:	739c                	ld	a5,32(a5)
ffffffffc02052c8:	9782                	jalr	a5
ffffffffc02052ca:	689c                	ld	a5,16(s1)
ffffffffc02052cc:	6c94                	ld	a3,24(s1)
ffffffffc02052ce:	4018                	lw	a4,0(s0)
ffffffffc02052d0:	84aa                	mv	s1,a0
ffffffffc02052d2:	8f95                	sub	a5,a5,a3
ffffffffc02052d4:	03370063          	beq	a4,s3,ffffffffc02052f4 <file_write+0xb6>
ffffffffc02052d8:	00fa3023          	sd	a5,0(s4)
ffffffffc02052dc:	8522                	mv	a0,s0
ffffffffc02052de:	b29ff0ef          	jal	ra,ffffffffc0204e06 <fd_array_release>
ffffffffc02052e2:	60a6                	ld	ra,72(sp)
ffffffffc02052e4:	6406                	ld	s0,64(sp)
ffffffffc02052e6:	7942                	ld	s2,48(sp)
ffffffffc02052e8:	79a2                	ld	s3,40(sp)
ffffffffc02052ea:	7a02                	ld	s4,32(sp)
ffffffffc02052ec:	8526                	mv	a0,s1
ffffffffc02052ee:	74e2                	ld	s1,56(sp)
ffffffffc02052f0:	6161                	addi	sp,sp,80
ffffffffc02052f2:	8082                	ret
ffffffffc02052f4:	7018                	ld	a4,32(s0)
ffffffffc02052f6:	973e                	add	a4,a4,a5
ffffffffc02052f8:	f018                	sd	a4,32(s0)
ffffffffc02052fa:	bff9                	j	ffffffffc02052d8 <file_write+0x9a>
ffffffffc02052fc:	54f5                	li	s1,-3
ffffffffc02052fe:	b7d5                	j	ffffffffc02052e2 <file_write+0xa4>
ffffffffc0205300:	9d5ff0ef          	jal	ra,ffffffffc0204cd4 <get_fd_array.part.0>
ffffffffc0205304:	00008697          	auipc	a3,0x8
ffffffffc0205308:	f2468693          	addi	a3,a3,-220 # ffffffffc020d228 <default_pmm_manager+0x360>
ffffffffc020530c:	00006617          	auipc	a2,0x6
ffffffffc0205310:	4fc60613          	addi	a2,a2,1276 # ffffffffc020b808 <commands+0x60>
ffffffffc0205314:	0f800593          	li	a1,248
ffffffffc0205318:	00008517          	auipc	a0,0x8
ffffffffc020531c:	d2850513          	addi	a0,a0,-728 # ffffffffc020d040 <default_pmm_manager+0x178>
ffffffffc0205320:	f0ffa0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0205324 <file_seek>:
ffffffffc0205324:	7139                	addi	sp,sp,-64
ffffffffc0205326:	fc06                	sd	ra,56(sp)
ffffffffc0205328:	f822                	sd	s0,48(sp)
ffffffffc020532a:	f426                	sd	s1,40(sp)
ffffffffc020532c:	f04a                	sd	s2,32(sp)
ffffffffc020532e:	04700793          	li	a5,71
ffffffffc0205332:	08a7e863          	bltu	a5,a0,ffffffffc02053c2 <file_seek+0x9e>
ffffffffc0205336:	00091797          	auipc	a5,0x91
ffffffffc020533a:	58a7b783          	ld	a5,1418(a5) # ffffffffc02968c0 <current>
ffffffffc020533e:	1487b783          	ld	a5,328(a5)
ffffffffc0205342:	cfdd                	beqz	a5,ffffffffc0205400 <file_seek+0xdc>
ffffffffc0205344:	4b98                	lw	a4,16(a5)
ffffffffc0205346:	0ae05d63          	blez	a4,ffffffffc0205400 <file_seek+0xdc>
ffffffffc020534a:	6780                	ld	s0,8(a5)
ffffffffc020534c:	00351793          	slli	a5,a0,0x3
ffffffffc0205350:	8f89                	sub	a5,a5,a0
ffffffffc0205352:	078e                	slli	a5,a5,0x3
ffffffffc0205354:	943e                	add	s0,s0,a5
ffffffffc0205356:	4018                	lw	a4,0(s0)
ffffffffc0205358:	4789                	li	a5,2
ffffffffc020535a:	06f71463          	bne	a4,a5,ffffffffc02053c2 <file_seek+0x9e>
ffffffffc020535e:	4c1c                	lw	a5,24(s0)
ffffffffc0205360:	06a79163          	bne	a5,a0,ffffffffc02053c2 <file_seek+0x9e>
ffffffffc0205364:	581c                	lw	a5,48(s0)
ffffffffc0205366:	4685                	li	a3,1
ffffffffc0205368:	892e                	mv	s2,a1
ffffffffc020536a:	2785                	addiw	a5,a5,1
ffffffffc020536c:	d81c                	sw	a5,48(s0)
ffffffffc020536e:	02d60063          	beq	a2,a3,ffffffffc020538e <file_seek+0x6a>
ffffffffc0205372:	06e60063          	beq	a2,a4,ffffffffc02053d2 <file_seek+0xae>
ffffffffc0205376:	54f5                	li	s1,-3
ffffffffc0205378:	ce11                	beqz	a2,ffffffffc0205394 <file_seek+0x70>
ffffffffc020537a:	8522                	mv	a0,s0
ffffffffc020537c:	a8bff0ef          	jal	ra,ffffffffc0204e06 <fd_array_release>
ffffffffc0205380:	70e2                	ld	ra,56(sp)
ffffffffc0205382:	7442                	ld	s0,48(sp)
ffffffffc0205384:	7902                	ld	s2,32(sp)
ffffffffc0205386:	8526                	mv	a0,s1
ffffffffc0205388:	74a2                	ld	s1,40(sp)
ffffffffc020538a:	6121                	addi	sp,sp,64
ffffffffc020538c:	8082                	ret
ffffffffc020538e:	701c                	ld	a5,32(s0)
ffffffffc0205390:	00f58933          	add	s2,a1,a5
ffffffffc0205394:	7404                	ld	s1,40(s0)
ffffffffc0205396:	c4bd                	beqz	s1,ffffffffc0205404 <file_seek+0xe0>
ffffffffc0205398:	78bc                	ld	a5,112(s1)
ffffffffc020539a:	c7ad                	beqz	a5,ffffffffc0205404 <file_seek+0xe0>
ffffffffc020539c:	6fbc                	ld	a5,88(a5)
ffffffffc020539e:	c3bd                	beqz	a5,ffffffffc0205404 <file_seek+0xe0>
ffffffffc02053a0:	8526                	mv	a0,s1
ffffffffc02053a2:	00008597          	auipc	a1,0x8
ffffffffc02053a6:	f2e58593          	addi	a1,a1,-210 # ffffffffc020d2d0 <default_pmm_manager+0x408>
ffffffffc02053aa:	451020ef          	jal	ra,ffffffffc0207ffa <inode_check>
ffffffffc02053ae:	78bc                	ld	a5,112(s1)
ffffffffc02053b0:	7408                	ld	a0,40(s0)
ffffffffc02053b2:	85ca                	mv	a1,s2
ffffffffc02053b4:	6fbc                	ld	a5,88(a5)
ffffffffc02053b6:	9782                	jalr	a5
ffffffffc02053b8:	84aa                	mv	s1,a0
ffffffffc02053ba:	f161                	bnez	a0,ffffffffc020537a <file_seek+0x56>
ffffffffc02053bc:	03243023          	sd	s2,32(s0)
ffffffffc02053c0:	bf6d                	j	ffffffffc020537a <file_seek+0x56>
ffffffffc02053c2:	70e2                	ld	ra,56(sp)
ffffffffc02053c4:	7442                	ld	s0,48(sp)
ffffffffc02053c6:	54f5                	li	s1,-3
ffffffffc02053c8:	7902                	ld	s2,32(sp)
ffffffffc02053ca:	8526                	mv	a0,s1
ffffffffc02053cc:	74a2                	ld	s1,40(sp)
ffffffffc02053ce:	6121                	addi	sp,sp,64
ffffffffc02053d0:	8082                	ret
ffffffffc02053d2:	7404                	ld	s1,40(s0)
ffffffffc02053d4:	c8a1                	beqz	s1,ffffffffc0205424 <file_seek+0x100>
ffffffffc02053d6:	78bc                	ld	a5,112(s1)
ffffffffc02053d8:	c7b1                	beqz	a5,ffffffffc0205424 <file_seek+0x100>
ffffffffc02053da:	779c                	ld	a5,40(a5)
ffffffffc02053dc:	c7a1                	beqz	a5,ffffffffc0205424 <file_seek+0x100>
ffffffffc02053de:	8526                	mv	a0,s1
ffffffffc02053e0:	00008597          	auipc	a1,0x8
ffffffffc02053e4:	de858593          	addi	a1,a1,-536 # ffffffffc020d1c8 <default_pmm_manager+0x300>
ffffffffc02053e8:	413020ef          	jal	ra,ffffffffc0207ffa <inode_check>
ffffffffc02053ec:	78bc                	ld	a5,112(s1)
ffffffffc02053ee:	7408                	ld	a0,40(s0)
ffffffffc02053f0:	858a                	mv	a1,sp
ffffffffc02053f2:	779c                	ld	a5,40(a5)
ffffffffc02053f4:	9782                	jalr	a5
ffffffffc02053f6:	84aa                	mv	s1,a0
ffffffffc02053f8:	f149                	bnez	a0,ffffffffc020537a <file_seek+0x56>
ffffffffc02053fa:	67e2                	ld	a5,24(sp)
ffffffffc02053fc:	993e                	add	s2,s2,a5
ffffffffc02053fe:	bf59                	j	ffffffffc0205394 <file_seek+0x70>
ffffffffc0205400:	8d5ff0ef          	jal	ra,ffffffffc0204cd4 <get_fd_array.part.0>
ffffffffc0205404:	00008697          	auipc	a3,0x8
ffffffffc0205408:	e7c68693          	addi	a3,a3,-388 # ffffffffc020d280 <default_pmm_manager+0x3b8>
ffffffffc020540c:	00006617          	auipc	a2,0x6
ffffffffc0205410:	3fc60613          	addi	a2,a2,1020 # ffffffffc020b808 <commands+0x60>
ffffffffc0205414:	11a00593          	li	a1,282
ffffffffc0205418:	00008517          	auipc	a0,0x8
ffffffffc020541c:	c2850513          	addi	a0,a0,-984 # ffffffffc020d040 <default_pmm_manager+0x178>
ffffffffc0205420:	e0ffa0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0205424:	00008697          	auipc	a3,0x8
ffffffffc0205428:	d5468693          	addi	a3,a3,-684 # ffffffffc020d178 <default_pmm_manager+0x2b0>
ffffffffc020542c:	00006617          	auipc	a2,0x6
ffffffffc0205430:	3dc60613          	addi	a2,a2,988 # ffffffffc020b808 <commands+0x60>
ffffffffc0205434:	11200593          	li	a1,274
ffffffffc0205438:	00008517          	auipc	a0,0x8
ffffffffc020543c:	c0850513          	addi	a0,a0,-1016 # ffffffffc020d040 <default_pmm_manager+0x178>
ffffffffc0205440:	deffa0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0205444 <file_fstat>:
ffffffffc0205444:	1101                	addi	sp,sp,-32
ffffffffc0205446:	ec06                	sd	ra,24(sp)
ffffffffc0205448:	e822                	sd	s0,16(sp)
ffffffffc020544a:	e426                	sd	s1,8(sp)
ffffffffc020544c:	e04a                	sd	s2,0(sp)
ffffffffc020544e:	04700793          	li	a5,71
ffffffffc0205452:	06a7ef63          	bltu	a5,a0,ffffffffc02054d0 <file_fstat+0x8c>
ffffffffc0205456:	00091797          	auipc	a5,0x91
ffffffffc020545a:	46a7b783          	ld	a5,1130(a5) # ffffffffc02968c0 <current>
ffffffffc020545e:	1487b783          	ld	a5,328(a5)
ffffffffc0205462:	cfd9                	beqz	a5,ffffffffc0205500 <file_fstat+0xbc>
ffffffffc0205464:	4b98                	lw	a4,16(a5)
ffffffffc0205466:	08e05d63          	blez	a4,ffffffffc0205500 <file_fstat+0xbc>
ffffffffc020546a:	6780                	ld	s0,8(a5)
ffffffffc020546c:	00351793          	slli	a5,a0,0x3
ffffffffc0205470:	8f89                	sub	a5,a5,a0
ffffffffc0205472:	078e                	slli	a5,a5,0x3
ffffffffc0205474:	943e                	add	s0,s0,a5
ffffffffc0205476:	4018                	lw	a4,0(s0)
ffffffffc0205478:	4789                	li	a5,2
ffffffffc020547a:	04f71b63          	bne	a4,a5,ffffffffc02054d0 <file_fstat+0x8c>
ffffffffc020547e:	4c1c                	lw	a5,24(s0)
ffffffffc0205480:	04a79863          	bne	a5,a0,ffffffffc02054d0 <file_fstat+0x8c>
ffffffffc0205484:	581c                	lw	a5,48(s0)
ffffffffc0205486:	02843903          	ld	s2,40(s0)
ffffffffc020548a:	2785                	addiw	a5,a5,1
ffffffffc020548c:	d81c                	sw	a5,48(s0)
ffffffffc020548e:	04090963          	beqz	s2,ffffffffc02054e0 <file_fstat+0x9c>
ffffffffc0205492:	07093783          	ld	a5,112(s2)
ffffffffc0205496:	c7a9                	beqz	a5,ffffffffc02054e0 <file_fstat+0x9c>
ffffffffc0205498:	779c                	ld	a5,40(a5)
ffffffffc020549a:	c3b9                	beqz	a5,ffffffffc02054e0 <file_fstat+0x9c>
ffffffffc020549c:	84ae                	mv	s1,a1
ffffffffc020549e:	854a                	mv	a0,s2
ffffffffc02054a0:	00008597          	auipc	a1,0x8
ffffffffc02054a4:	d2858593          	addi	a1,a1,-728 # ffffffffc020d1c8 <default_pmm_manager+0x300>
ffffffffc02054a8:	353020ef          	jal	ra,ffffffffc0207ffa <inode_check>
ffffffffc02054ac:	07093783          	ld	a5,112(s2)
ffffffffc02054b0:	7408                	ld	a0,40(s0)
ffffffffc02054b2:	85a6                	mv	a1,s1
ffffffffc02054b4:	779c                	ld	a5,40(a5)
ffffffffc02054b6:	9782                	jalr	a5
ffffffffc02054b8:	87aa                	mv	a5,a0
ffffffffc02054ba:	8522                	mv	a0,s0
ffffffffc02054bc:	843e                	mv	s0,a5
ffffffffc02054be:	949ff0ef          	jal	ra,ffffffffc0204e06 <fd_array_release>
ffffffffc02054c2:	60e2                	ld	ra,24(sp)
ffffffffc02054c4:	8522                	mv	a0,s0
ffffffffc02054c6:	6442                	ld	s0,16(sp)
ffffffffc02054c8:	64a2                	ld	s1,8(sp)
ffffffffc02054ca:	6902                	ld	s2,0(sp)
ffffffffc02054cc:	6105                	addi	sp,sp,32
ffffffffc02054ce:	8082                	ret
ffffffffc02054d0:	5475                	li	s0,-3
ffffffffc02054d2:	60e2                	ld	ra,24(sp)
ffffffffc02054d4:	8522                	mv	a0,s0
ffffffffc02054d6:	6442                	ld	s0,16(sp)
ffffffffc02054d8:	64a2                	ld	s1,8(sp)
ffffffffc02054da:	6902                	ld	s2,0(sp)
ffffffffc02054dc:	6105                	addi	sp,sp,32
ffffffffc02054de:	8082                	ret
ffffffffc02054e0:	00008697          	auipc	a3,0x8
ffffffffc02054e4:	c9868693          	addi	a3,a3,-872 # ffffffffc020d178 <default_pmm_manager+0x2b0>
ffffffffc02054e8:	00006617          	auipc	a2,0x6
ffffffffc02054ec:	32060613          	addi	a2,a2,800 # ffffffffc020b808 <commands+0x60>
ffffffffc02054f0:	12c00593          	li	a1,300
ffffffffc02054f4:	00008517          	auipc	a0,0x8
ffffffffc02054f8:	b4c50513          	addi	a0,a0,-1204 # ffffffffc020d040 <default_pmm_manager+0x178>
ffffffffc02054fc:	d33fa0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0205500:	fd4ff0ef          	jal	ra,ffffffffc0204cd4 <get_fd_array.part.0>

ffffffffc0205504 <file_fsync>:
ffffffffc0205504:	1101                	addi	sp,sp,-32
ffffffffc0205506:	ec06                	sd	ra,24(sp)
ffffffffc0205508:	e822                	sd	s0,16(sp)
ffffffffc020550a:	e426                	sd	s1,8(sp)
ffffffffc020550c:	04700793          	li	a5,71
ffffffffc0205510:	06a7e863          	bltu	a5,a0,ffffffffc0205580 <file_fsync+0x7c>
ffffffffc0205514:	00091797          	auipc	a5,0x91
ffffffffc0205518:	3ac7b783          	ld	a5,940(a5) # ffffffffc02968c0 <current>
ffffffffc020551c:	1487b783          	ld	a5,328(a5)
ffffffffc0205520:	c7d9                	beqz	a5,ffffffffc02055ae <file_fsync+0xaa>
ffffffffc0205522:	4b98                	lw	a4,16(a5)
ffffffffc0205524:	08e05563          	blez	a4,ffffffffc02055ae <file_fsync+0xaa>
ffffffffc0205528:	6780                	ld	s0,8(a5)
ffffffffc020552a:	00351793          	slli	a5,a0,0x3
ffffffffc020552e:	8f89                	sub	a5,a5,a0
ffffffffc0205530:	078e                	slli	a5,a5,0x3
ffffffffc0205532:	943e                	add	s0,s0,a5
ffffffffc0205534:	4018                	lw	a4,0(s0)
ffffffffc0205536:	4789                	li	a5,2
ffffffffc0205538:	04f71463          	bne	a4,a5,ffffffffc0205580 <file_fsync+0x7c>
ffffffffc020553c:	4c1c                	lw	a5,24(s0)
ffffffffc020553e:	04a79163          	bne	a5,a0,ffffffffc0205580 <file_fsync+0x7c>
ffffffffc0205542:	581c                	lw	a5,48(s0)
ffffffffc0205544:	7404                	ld	s1,40(s0)
ffffffffc0205546:	2785                	addiw	a5,a5,1
ffffffffc0205548:	d81c                	sw	a5,48(s0)
ffffffffc020554a:	c0b1                	beqz	s1,ffffffffc020558e <file_fsync+0x8a>
ffffffffc020554c:	78bc                	ld	a5,112(s1)
ffffffffc020554e:	c3a1                	beqz	a5,ffffffffc020558e <file_fsync+0x8a>
ffffffffc0205550:	7b9c                	ld	a5,48(a5)
ffffffffc0205552:	cf95                	beqz	a5,ffffffffc020558e <file_fsync+0x8a>
ffffffffc0205554:	00008597          	auipc	a1,0x8
ffffffffc0205558:	dd458593          	addi	a1,a1,-556 # ffffffffc020d328 <default_pmm_manager+0x460>
ffffffffc020555c:	8526                	mv	a0,s1
ffffffffc020555e:	29d020ef          	jal	ra,ffffffffc0207ffa <inode_check>
ffffffffc0205562:	78bc                	ld	a5,112(s1)
ffffffffc0205564:	7408                	ld	a0,40(s0)
ffffffffc0205566:	7b9c                	ld	a5,48(a5)
ffffffffc0205568:	9782                	jalr	a5
ffffffffc020556a:	87aa                	mv	a5,a0
ffffffffc020556c:	8522                	mv	a0,s0
ffffffffc020556e:	843e                	mv	s0,a5
ffffffffc0205570:	897ff0ef          	jal	ra,ffffffffc0204e06 <fd_array_release>
ffffffffc0205574:	60e2                	ld	ra,24(sp)
ffffffffc0205576:	8522                	mv	a0,s0
ffffffffc0205578:	6442                	ld	s0,16(sp)
ffffffffc020557a:	64a2                	ld	s1,8(sp)
ffffffffc020557c:	6105                	addi	sp,sp,32
ffffffffc020557e:	8082                	ret
ffffffffc0205580:	5475                	li	s0,-3
ffffffffc0205582:	60e2                	ld	ra,24(sp)
ffffffffc0205584:	8522                	mv	a0,s0
ffffffffc0205586:	6442                	ld	s0,16(sp)
ffffffffc0205588:	64a2                	ld	s1,8(sp)
ffffffffc020558a:	6105                	addi	sp,sp,32
ffffffffc020558c:	8082                	ret
ffffffffc020558e:	00008697          	auipc	a3,0x8
ffffffffc0205592:	d4a68693          	addi	a3,a3,-694 # ffffffffc020d2d8 <default_pmm_manager+0x410>
ffffffffc0205596:	00006617          	auipc	a2,0x6
ffffffffc020559a:	27260613          	addi	a2,a2,626 # ffffffffc020b808 <commands+0x60>
ffffffffc020559e:	13a00593          	li	a1,314
ffffffffc02055a2:	00008517          	auipc	a0,0x8
ffffffffc02055a6:	a9e50513          	addi	a0,a0,-1378 # ffffffffc020d040 <default_pmm_manager+0x178>
ffffffffc02055aa:	c85fa0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02055ae:	f26ff0ef          	jal	ra,ffffffffc0204cd4 <get_fd_array.part.0>

ffffffffc02055b2 <file_getdirentry>:
ffffffffc02055b2:	715d                	addi	sp,sp,-80
ffffffffc02055b4:	e486                	sd	ra,72(sp)
ffffffffc02055b6:	e0a2                	sd	s0,64(sp)
ffffffffc02055b8:	fc26                	sd	s1,56(sp)
ffffffffc02055ba:	f84a                	sd	s2,48(sp)
ffffffffc02055bc:	f44e                	sd	s3,40(sp)
ffffffffc02055be:	04700793          	li	a5,71
ffffffffc02055c2:	0aa7e063          	bltu	a5,a0,ffffffffc0205662 <file_getdirentry+0xb0>
ffffffffc02055c6:	00091797          	auipc	a5,0x91
ffffffffc02055ca:	2fa7b783          	ld	a5,762(a5) # ffffffffc02968c0 <current>
ffffffffc02055ce:	1487b783          	ld	a5,328(a5)
ffffffffc02055d2:	c3e9                	beqz	a5,ffffffffc0205694 <file_getdirentry+0xe2>
ffffffffc02055d4:	4b98                	lw	a4,16(a5)
ffffffffc02055d6:	0ae05f63          	blez	a4,ffffffffc0205694 <file_getdirentry+0xe2>
ffffffffc02055da:	6780                	ld	s0,8(a5)
ffffffffc02055dc:	00351793          	slli	a5,a0,0x3
ffffffffc02055e0:	8f89                	sub	a5,a5,a0
ffffffffc02055e2:	078e                	slli	a5,a5,0x3
ffffffffc02055e4:	943e                	add	s0,s0,a5
ffffffffc02055e6:	4018                	lw	a4,0(s0)
ffffffffc02055e8:	4789                	li	a5,2
ffffffffc02055ea:	06f71c63          	bne	a4,a5,ffffffffc0205662 <file_getdirentry+0xb0>
ffffffffc02055ee:	4c1c                	lw	a5,24(s0)
ffffffffc02055f0:	06a79963          	bne	a5,a0,ffffffffc0205662 <file_getdirentry+0xb0>
ffffffffc02055f4:	581c                	lw	a5,48(s0)
ffffffffc02055f6:	6194                	ld	a3,0(a1)
ffffffffc02055f8:	84ae                	mv	s1,a1
ffffffffc02055fa:	2785                	addiw	a5,a5,1
ffffffffc02055fc:	10000613          	li	a2,256
ffffffffc0205600:	d81c                	sw	a5,48(s0)
ffffffffc0205602:	05a1                	addi	a1,a1,8
ffffffffc0205604:	850a                	mv	a0,sp
ffffffffc0205606:	12a000ef          	jal	ra,ffffffffc0205730 <iobuf_init>
ffffffffc020560a:	02843983          	ld	s3,40(s0)
ffffffffc020560e:	892a                	mv	s2,a0
ffffffffc0205610:	06098263          	beqz	s3,ffffffffc0205674 <file_getdirentry+0xc2>
ffffffffc0205614:	0709b783          	ld	a5,112(s3)
ffffffffc0205618:	cfb1                	beqz	a5,ffffffffc0205674 <file_getdirentry+0xc2>
ffffffffc020561a:	63bc                	ld	a5,64(a5)
ffffffffc020561c:	cfa1                	beqz	a5,ffffffffc0205674 <file_getdirentry+0xc2>
ffffffffc020561e:	854e                	mv	a0,s3
ffffffffc0205620:	00008597          	auipc	a1,0x8
ffffffffc0205624:	d6858593          	addi	a1,a1,-664 # ffffffffc020d388 <default_pmm_manager+0x4c0>
ffffffffc0205628:	1d3020ef          	jal	ra,ffffffffc0207ffa <inode_check>
ffffffffc020562c:	0709b783          	ld	a5,112(s3)
ffffffffc0205630:	7408                	ld	a0,40(s0)
ffffffffc0205632:	85ca                	mv	a1,s2
ffffffffc0205634:	63bc                	ld	a5,64(a5)
ffffffffc0205636:	9782                	jalr	a5
ffffffffc0205638:	89aa                	mv	s3,a0
ffffffffc020563a:	e909                	bnez	a0,ffffffffc020564c <file_getdirentry+0x9a>
ffffffffc020563c:	609c                	ld	a5,0(s1)
ffffffffc020563e:	01093683          	ld	a3,16(s2)
ffffffffc0205642:	01893703          	ld	a4,24(s2)
ffffffffc0205646:	97b6                	add	a5,a5,a3
ffffffffc0205648:	8f99                	sub	a5,a5,a4
ffffffffc020564a:	e09c                	sd	a5,0(s1)
ffffffffc020564c:	8522                	mv	a0,s0
ffffffffc020564e:	fb8ff0ef          	jal	ra,ffffffffc0204e06 <fd_array_release>
ffffffffc0205652:	60a6                	ld	ra,72(sp)
ffffffffc0205654:	6406                	ld	s0,64(sp)
ffffffffc0205656:	74e2                	ld	s1,56(sp)
ffffffffc0205658:	7942                	ld	s2,48(sp)
ffffffffc020565a:	854e                	mv	a0,s3
ffffffffc020565c:	79a2                	ld	s3,40(sp)
ffffffffc020565e:	6161                	addi	sp,sp,80
ffffffffc0205660:	8082                	ret
ffffffffc0205662:	60a6                	ld	ra,72(sp)
ffffffffc0205664:	6406                	ld	s0,64(sp)
ffffffffc0205666:	59f5                	li	s3,-3
ffffffffc0205668:	74e2                	ld	s1,56(sp)
ffffffffc020566a:	7942                	ld	s2,48(sp)
ffffffffc020566c:	854e                	mv	a0,s3
ffffffffc020566e:	79a2                	ld	s3,40(sp)
ffffffffc0205670:	6161                	addi	sp,sp,80
ffffffffc0205672:	8082                	ret
ffffffffc0205674:	00008697          	auipc	a3,0x8
ffffffffc0205678:	cbc68693          	addi	a3,a3,-836 # ffffffffc020d330 <default_pmm_manager+0x468>
ffffffffc020567c:	00006617          	auipc	a2,0x6
ffffffffc0205680:	18c60613          	addi	a2,a2,396 # ffffffffc020b808 <commands+0x60>
ffffffffc0205684:	14a00593          	li	a1,330
ffffffffc0205688:	00008517          	auipc	a0,0x8
ffffffffc020568c:	9b850513          	addi	a0,a0,-1608 # ffffffffc020d040 <default_pmm_manager+0x178>
ffffffffc0205690:	b9ffa0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0205694:	e40ff0ef          	jal	ra,ffffffffc0204cd4 <get_fd_array.part.0>

ffffffffc0205698 <file_dup>:
ffffffffc0205698:	04700713          	li	a4,71
ffffffffc020569c:	06a76463          	bltu	a4,a0,ffffffffc0205704 <file_dup+0x6c>
ffffffffc02056a0:	00091717          	auipc	a4,0x91
ffffffffc02056a4:	22073703          	ld	a4,544(a4) # ffffffffc02968c0 <current>
ffffffffc02056a8:	14873703          	ld	a4,328(a4)
ffffffffc02056ac:	1101                	addi	sp,sp,-32
ffffffffc02056ae:	ec06                	sd	ra,24(sp)
ffffffffc02056b0:	e822                	sd	s0,16(sp)
ffffffffc02056b2:	cb39                	beqz	a4,ffffffffc0205708 <file_dup+0x70>
ffffffffc02056b4:	4b14                	lw	a3,16(a4)
ffffffffc02056b6:	04d05963          	blez	a3,ffffffffc0205708 <file_dup+0x70>
ffffffffc02056ba:	6700                	ld	s0,8(a4)
ffffffffc02056bc:	00351713          	slli	a4,a0,0x3
ffffffffc02056c0:	8f09                	sub	a4,a4,a0
ffffffffc02056c2:	070e                	slli	a4,a4,0x3
ffffffffc02056c4:	943a                	add	s0,s0,a4
ffffffffc02056c6:	4014                	lw	a3,0(s0)
ffffffffc02056c8:	4709                	li	a4,2
ffffffffc02056ca:	02e69863          	bne	a3,a4,ffffffffc02056fa <file_dup+0x62>
ffffffffc02056ce:	4c18                	lw	a4,24(s0)
ffffffffc02056d0:	02a71563          	bne	a4,a0,ffffffffc02056fa <file_dup+0x62>
ffffffffc02056d4:	852e                	mv	a0,a1
ffffffffc02056d6:	002c                	addi	a1,sp,8
ffffffffc02056d8:	e1eff0ef          	jal	ra,ffffffffc0204cf6 <fd_array_alloc>
ffffffffc02056dc:	c509                	beqz	a0,ffffffffc02056e6 <file_dup+0x4e>
ffffffffc02056de:	60e2                	ld	ra,24(sp)
ffffffffc02056e0:	6442                	ld	s0,16(sp)
ffffffffc02056e2:	6105                	addi	sp,sp,32
ffffffffc02056e4:	8082                	ret
ffffffffc02056e6:	6522                	ld	a0,8(sp)
ffffffffc02056e8:	85a2                	mv	a1,s0
ffffffffc02056ea:	845ff0ef          	jal	ra,ffffffffc0204f2e <fd_array_dup>
ffffffffc02056ee:	67a2                	ld	a5,8(sp)
ffffffffc02056f0:	60e2                	ld	ra,24(sp)
ffffffffc02056f2:	6442                	ld	s0,16(sp)
ffffffffc02056f4:	4f88                	lw	a0,24(a5)
ffffffffc02056f6:	6105                	addi	sp,sp,32
ffffffffc02056f8:	8082                	ret
ffffffffc02056fa:	60e2                	ld	ra,24(sp)
ffffffffc02056fc:	6442                	ld	s0,16(sp)
ffffffffc02056fe:	5575                	li	a0,-3
ffffffffc0205700:	6105                	addi	sp,sp,32
ffffffffc0205702:	8082                	ret
ffffffffc0205704:	5575                	li	a0,-3
ffffffffc0205706:	8082                	ret
ffffffffc0205708:	dccff0ef          	jal	ra,ffffffffc0204cd4 <get_fd_array.part.0>

ffffffffc020570c <iobuf_skip.part.0>:
ffffffffc020570c:	1141                	addi	sp,sp,-16
ffffffffc020570e:	00008697          	auipc	a3,0x8
ffffffffc0205712:	cba68693          	addi	a3,a3,-838 # ffffffffc020d3c8 <CSWTCH.79+0x18>
ffffffffc0205716:	00006617          	auipc	a2,0x6
ffffffffc020571a:	0f260613          	addi	a2,a2,242 # ffffffffc020b808 <commands+0x60>
ffffffffc020571e:	04a00593          	li	a1,74
ffffffffc0205722:	00008517          	auipc	a0,0x8
ffffffffc0205726:	cbe50513          	addi	a0,a0,-834 # ffffffffc020d3e0 <CSWTCH.79+0x30>
ffffffffc020572a:	e406                	sd	ra,8(sp)
ffffffffc020572c:	b03fa0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0205730 <iobuf_init>:
ffffffffc0205730:	e10c                	sd	a1,0(a0)
ffffffffc0205732:	e514                	sd	a3,8(a0)
ffffffffc0205734:	ed10                	sd	a2,24(a0)
ffffffffc0205736:	e910                	sd	a2,16(a0)
ffffffffc0205738:	8082                	ret

ffffffffc020573a <iobuf_move>:
ffffffffc020573a:	7179                	addi	sp,sp,-48
ffffffffc020573c:	ec26                	sd	s1,24(sp)
ffffffffc020573e:	6d04                	ld	s1,24(a0)
ffffffffc0205740:	f022                	sd	s0,32(sp)
ffffffffc0205742:	e84a                	sd	s2,16(sp)
ffffffffc0205744:	e44e                	sd	s3,8(sp)
ffffffffc0205746:	f406                	sd	ra,40(sp)
ffffffffc0205748:	842a                	mv	s0,a0
ffffffffc020574a:	8932                	mv	s2,a2
ffffffffc020574c:	852e                	mv	a0,a1
ffffffffc020574e:	89ba                	mv	s3,a4
ffffffffc0205750:	00967363          	bgeu	a2,s1,ffffffffc0205756 <iobuf_move+0x1c>
ffffffffc0205754:	84b2                	mv	s1,a2
ffffffffc0205756:	c495                	beqz	s1,ffffffffc0205782 <iobuf_move+0x48>
ffffffffc0205758:	600c                	ld	a1,0(s0)
ffffffffc020575a:	c681                	beqz	a3,ffffffffc0205762 <iobuf_move+0x28>
ffffffffc020575c:	87ae                	mv	a5,a1
ffffffffc020575e:	85aa                	mv	a1,a0
ffffffffc0205760:	853e                	mv	a0,a5
ffffffffc0205762:	8626                	mv	a2,s1
ffffffffc0205764:	0ad050ef          	jal	ra,ffffffffc020b010 <memmove>
ffffffffc0205768:	6c1c                	ld	a5,24(s0)
ffffffffc020576a:	0297ea63          	bltu	a5,s1,ffffffffc020579e <iobuf_move+0x64>
ffffffffc020576e:	6014                	ld	a3,0(s0)
ffffffffc0205770:	6418                	ld	a4,8(s0)
ffffffffc0205772:	8f85                	sub	a5,a5,s1
ffffffffc0205774:	96a6                	add	a3,a3,s1
ffffffffc0205776:	9726                	add	a4,a4,s1
ffffffffc0205778:	e014                	sd	a3,0(s0)
ffffffffc020577a:	e418                	sd	a4,8(s0)
ffffffffc020577c:	ec1c                	sd	a5,24(s0)
ffffffffc020577e:	40990933          	sub	s2,s2,s1
ffffffffc0205782:	00098463          	beqz	s3,ffffffffc020578a <iobuf_move+0x50>
ffffffffc0205786:	0099b023          	sd	s1,0(s3)
ffffffffc020578a:	4501                	li	a0,0
ffffffffc020578c:	00091b63          	bnez	s2,ffffffffc02057a2 <iobuf_move+0x68>
ffffffffc0205790:	70a2                	ld	ra,40(sp)
ffffffffc0205792:	7402                	ld	s0,32(sp)
ffffffffc0205794:	64e2                	ld	s1,24(sp)
ffffffffc0205796:	6942                	ld	s2,16(sp)
ffffffffc0205798:	69a2                	ld	s3,8(sp)
ffffffffc020579a:	6145                	addi	sp,sp,48
ffffffffc020579c:	8082                	ret
ffffffffc020579e:	f6fff0ef          	jal	ra,ffffffffc020570c <iobuf_skip.part.0>
ffffffffc02057a2:	5571                	li	a0,-4
ffffffffc02057a4:	b7f5                	j	ffffffffc0205790 <iobuf_move+0x56>

ffffffffc02057a6 <iobuf_skip>:
ffffffffc02057a6:	6d1c                	ld	a5,24(a0)
ffffffffc02057a8:	00b7eb63          	bltu	a5,a1,ffffffffc02057be <iobuf_skip+0x18>
ffffffffc02057ac:	6114                	ld	a3,0(a0)
ffffffffc02057ae:	6518                	ld	a4,8(a0)
ffffffffc02057b0:	8f8d                	sub	a5,a5,a1
ffffffffc02057b2:	96ae                	add	a3,a3,a1
ffffffffc02057b4:	95ba                	add	a1,a1,a4
ffffffffc02057b6:	e114                	sd	a3,0(a0)
ffffffffc02057b8:	e50c                	sd	a1,8(a0)
ffffffffc02057ba:	ed1c                	sd	a5,24(a0)
ffffffffc02057bc:	8082                	ret
ffffffffc02057be:	1141                	addi	sp,sp,-16
ffffffffc02057c0:	e406                	sd	ra,8(sp)
ffffffffc02057c2:	f4bff0ef          	jal	ra,ffffffffc020570c <iobuf_skip.part.0>

ffffffffc02057c6 <fs_init>:
ffffffffc02057c6:	1141                	addi	sp,sp,-16
ffffffffc02057c8:	e406                	sd	ra,8(sp)
ffffffffc02057ca:	411020ef          	jal	ra,ffffffffc02083da <vfs_init>
ffffffffc02057ce:	648030ef          	jal	ra,ffffffffc0208e16 <dev_init>
ffffffffc02057d2:	60a2                	ld	ra,8(sp)
ffffffffc02057d4:	0141                	addi	sp,sp,16
ffffffffc02057d6:	6800306f          	j	ffffffffc0208e56 <sfs_init>

ffffffffc02057da <fs_cleanup>:
ffffffffc02057da:	13a0206f          	j	ffffffffc0207914 <vfs_cleanup>

ffffffffc02057de <lock_files>:
ffffffffc02057de:	0561                	addi	a0,a0,24
ffffffffc02057e0:	f6ffe06f          	j	ffffffffc020474e <down>

ffffffffc02057e4 <unlock_files>:
ffffffffc02057e4:	0561                	addi	a0,a0,24
ffffffffc02057e6:	f65fe06f          	j	ffffffffc020474a <up>

ffffffffc02057ea <files_create>:
ffffffffc02057ea:	1141                	addi	sp,sp,-16
ffffffffc02057ec:	6505                	lui	a0,0x1
ffffffffc02057ee:	e022                	sd	s0,0(sp)
ffffffffc02057f0:	e406                	sd	ra,8(sp)
ffffffffc02057f2:	fd5fd0ef          	jal	ra,ffffffffc02037c6 <kmalloc>
ffffffffc02057f6:	842a                	mv	s0,a0
ffffffffc02057f8:	cd19                	beqz	a0,ffffffffc0205816 <files_create+0x2c>
ffffffffc02057fa:	03050793          	addi	a5,a0,48 # 1030 <_binary_bin_swap_img_size-0x6cd0>
ffffffffc02057fe:	00043023          	sd	zero,0(s0)
ffffffffc0205802:	0561                	addi	a0,a0,24
ffffffffc0205804:	e41c                	sd	a5,8(s0)
ffffffffc0205806:	00042823          	sw	zero,16(s0)
ffffffffc020580a:	4585                	li	a1,1
ffffffffc020580c:	f37fe0ef          	jal	ra,ffffffffc0204742 <sem_init>
ffffffffc0205810:	6408                	ld	a0,8(s0)
ffffffffc0205812:	e82ff0ef          	jal	ra,ffffffffc0204e94 <fd_array_init>
ffffffffc0205816:	60a2                	ld	ra,8(sp)
ffffffffc0205818:	8522                	mv	a0,s0
ffffffffc020581a:	6402                	ld	s0,0(sp)
ffffffffc020581c:	0141                	addi	sp,sp,16
ffffffffc020581e:	8082                	ret

ffffffffc0205820 <files_destroy>:
ffffffffc0205820:	7179                	addi	sp,sp,-48
ffffffffc0205822:	f406                	sd	ra,40(sp)
ffffffffc0205824:	f022                	sd	s0,32(sp)
ffffffffc0205826:	ec26                	sd	s1,24(sp)
ffffffffc0205828:	e84a                	sd	s2,16(sp)
ffffffffc020582a:	e44e                	sd	s3,8(sp)
ffffffffc020582c:	c52d                	beqz	a0,ffffffffc0205896 <files_destroy+0x76>
ffffffffc020582e:	491c                	lw	a5,16(a0)
ffffffffc0205830:	89aa                	mv	s3,a0
ffffffffc0205832:	e3b5                	bnez	a5,ffffffffc0205896 <files_destroy+0x76>
ffffffffc0205834:	6108                	ld	a0,0(a0)
ffffffffc0205836:	c119                	beqz	a0,ffffffffc020583c <files_destroy+0x1c>
ffffffffc0205838:	079020ef          	jal	ra,ffffffffc02080b0 <inode_ref_dec>
ffffffffc020583c:	0089b403          	ld	s0,8(s3)
ffffffffc0205840:	6485                	lui	s1,0x1
ffffffffc0205842:	fc048493          	addi	s1,s1,-64 # fc0 <_binary_bin_swap_img_size-0x6d40>
ffffffffc0205846:	94a2                	add	s1,s1,s0
ffffffffc0205848:	4909                	li	s2,2
ffffffffc020584a:	401c                	lw	a5,0(s0)
ffffffffc020584c:	03278063          	beq	a5,s2,ffffffffc020586c <files_destroy+0x4c>
ffffffffc0205850:	e39d                	bnez	a5,ffffffffc0205876 <files_destroy+0x56>
ffffffffc0205852:	03840413          	addi	s0,s0,56
ffffffffc0205856:	fe849ae3          	bne	s1,s0,ffffffffc020584a <files_destroy+0x2a>
ffffffffc020585a:	7402                	ld	s0,32(sp)
ffffffffc020585c:	70a2                	ld	ra,40(sp)
ffffffffc020585e:	64e2                	ld	s1,24(sp)
ffffffffc0205860:	6942                	ld	s2,16(sp)
ffffffffc0205862:	854e                	mv	a0,s3
ffffffffc0205864:	69a2                	ld	s3,8(sp)
ffffffffc0205866:	6145                	addi	sp,sp,48
ffffffffc0205868:	80efe06f          	j	ffffffffc0203876 <kfree>
ffffffffc020586c:	8522                	mv	a0,s0
ffffffffc020586e:	e42ff0ef          	jal	ra,ffffffffc0204eb0 <fd_array_close>
ffffffffc0205872:	401c                	lw	a5,0(s0)
ffffffffc0205874:	bff1                	j	ffffffffc0205850 <files_destroy+0x30>
ffffffffc0205876:	00008697          	auipc	a3,0x8
ffffffffc020587a:	bba68693          	addi	a3,a3,-1094 # ffffffffc020d430 <CSWTCH.79+0x80>
ffffffffc020587e:	00006617          	auipc	a2,0x6
ffffffffc0205882:	f8a60613          	addi	a2,a2,-118 # ffffffffc020b808 <commands+0x60>
ffffffffc0205886:	03d00593          	li	a1,61
ffffffffc020588a:	00008517          	auipc	a0,0x8
ffffffffc020588e:	b9650513          	addi	a0,a0,-1130 # ffffffffc020d420 <CSWTCH.79+0x70>
ffffffffc0205892:	99dfa0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0205896:	00008697          	auipc	a3,0x8
ffffffffc020589a:	b5a68693          	addi	a3,a3,-1190 # ffffffffc020d3f0 <CSWTCH.79+0x40>
ffffffffc020589e:	00006617          	auipc	a2,0x6
ffffffffc02058a2:	f6a60613          	addi	a2,a2,-150 # ffffffffc020b808 <commands+0x60>
ffffffffc02058a6:	03300593          	li	a1,51
ffffffffc02058aa:	00008517          	auipc	a0,0x8
ffffffffc02058ae:	b7650513          	addi	a0,a0,-1162 # ffffffffc020d420 <CSWTCH.79+0x70>
ffffffffc02058b2:	97dfa0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02058b6 <files_closeall>:
ffffffffc02058b6:	1101                	addi	sp,sp,-32
ffffffffc02058b8:	ec06                	sd	ra,24(sp)
ffffffffc02058ba:	e822                	sd	s0,16(sp)
ffffffffc02058bc:	e426                	sd	s1,8(sp)
ffffffffc02058be:	e04a                	sd	s2,0(sp)
ffffffffc02058c0:	c129                	beqz	a0,ffffffffc0205902 <files_closeall+0x4c>
ffffffffc02058c2:	491c                	lw	a5,16(a0)
ffffffffc02058c4:	02f05f63          	blez	a5,ffffffffc0205902 <files_closeall+0x4c>
ffffffffc02058c8:	6504                	ld	s1,8(a0)
ffffffffc02058ca:	6785                	lui	a5,0x1
ffffffffc02058cc:	fc078793          	addi	a5,a5,-64 # fc0 <_binary_bin_swap_img_size-0x6d40>
ffffffffc02058d0:	07048413          	addi	s0,s1,112
ffffffffc02058d4:	4909                	li	s2,2
ffffffffc02058d6:	94be                	add	s1,s1,a5
ffffffffc02058d8:	a029                	j	ffffffffc02058e2 <files_closeall+0x2c>
ffffffffc02058da:	03840413          	addi	s0,s0,56
ffffffffc02058de:	00848c63          	beq	s1,s0,ffffffffc02058f6 <files_closeall+0x40>
ffffffffc02058e2:	401c                	lw	a5,0(s0)
ffffffffc02058e4:	ff279be3          	bne	a5,s2,ffffffffc02058da <files_closeall+0x24>
ffffffffc02058e8:	8522                	mv	a0,s0
ffffffffc02058ea:	03840413          	addi	s0,s0,56
ffffffffc02058ee:	dc2ff0ef          	jal	ra,ffffffffc0204eb0 <fd_array_close>
ffffffffc02058f2:	fe8498e3          	bne	s1,s0,ffffffffc02058e2 <files_closeall+0x2c>
ffffffffc02058f6:	60e2                	ld	ra,24(sp)
ffffffffc02058f8:	6442                	ld	s0,16(sp)
ffffffffc02058fa:	64a2                	ld	s1,8(sp)
ffffffffc02058fc:	6902                	ld	s2,0(sp)
ffffffffc02058fe:	6105                	addi	sp,sp,32
ffffffffc0205900:	8082                	ret
ffffffffc0205902:	00007697          	auipc	a3,0x7
ffffffffc0205906:	70e68693          	addi	a3,a3,1806 # ffffffffc020d010 <default_pmm_manager+0x148>
ffffffffc020590a:	00006617          	auipc	a2,0x6
ffffffffc020590e:	efe60613          	addi	a2,a2,-258 # ffffffffc020b808 <commands+0x60>
ffffffffc0205912:	04500593          	li	a1,69
ffffffffc0205916:	00008517          	auipc	a0,0x8
ffffffffc020591a:	b0a50513          	addi	a0,a0,-1270 # ffffffffc020d420 <CSWTCH.79+0x70>
ffffffffc020591e:	911fa0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0205922 <dup_files>:
ffffffffc0205922:	7179                	addi	sp,sp,-48
ffffffffc0205924:	f406                	sd	ra,40(sp)
ffffffffc0205926:	f022                	sd	s0,32(sp)
ffffffffc0205928:	ec26                	sd	s1,24(sp)
ffffffffc020592a:	e84a                	sd	s2,16(sp)
ffffffffc020592c:	e44e                	sd	s3,8(sp)
ffffffffc020592e:	e052                	sd	s4,0(sp)
ffffffffc0205930:	c52d                	beqz	a0,ffffffffc020599a <dup_files+0x78>
ffffffffc0205932:	842e                	mv	s0,a1
ffffffffc0205934:	c1bd                	beqz	a1,ffffffffc020599a <dup_files+0x78>
ffffffffc0205936:	491c                	lw	a5,16(a0)
ffffffffc0205938:	84aa                	mv	s1,a0
ffffffffc020593a:	e3c1                	bnez	a5,ffffffffc02059ba <dup_files+0x98>
ffffffffc020593c:	499c                	lw	a5,16(a1)
ffffffffc020593e:	06f05e63          	blez	a5,ffffffffc02059ba <dup_files+0x98>
ffffffffc0205942:	6188                	ld	a0,0(a1)
ffffffffc0205944:	e088                	sd	a0,0(s1)
ffffffffc0205946:	c119                	beqz	a0,ffffffffc020594c <dup_files+0x2a>
ffffffffc0205948:	69a020ef          	jal	ra,ffffffffc0207fe2 <inode_ref_inc>
ffffffffc020594c:	6400                	ld	s0,8(s0)
ffffffffc020594e:	6905                	lui	s2,0x1
ffffffffc0205950:	fc090913          	addi	s2,s2,-64 # fc0 <_binary_bin_swap_img_size-0x6d40>
ffffffffc0205954:	6484                	ld	s1,8(s1)
ffffffffc0205956:	9922                	add	s2,s2,s0
ffffffffc0205958:	4989                	li	s3,2
ffffffffc020595a:	4a05                	li	s4,1
ffffffffc020595c:	a039                	j	ffffffffc020596a <dup_files+0x48>
ffffffffc020595e:	03840413          	addi	s0,s0,56
ffffffffc0205962:	03848493          	addi	s1,s1,56
ffffffffc0205966:	02890163          	beq	s2,s0,ffffffffc0205988 <dup_files+0x66>
ffffffffc020596a:	401c                	lw	a5,0(s0)
ffffffffc020596c:	ff3799e3          	bne	a5,s3,ffffffffc020595e <dup_files+0x3c>
ffffffffc0205970:	0144a023          	sw	s4,0(s1)
ffffffffc0205974:	85a2                	mv	a1,s0
ffffffffc0205976:	8526                	mv	a0,s1
ffffffffc0205978:	03840413          	addi	s0,s0,56
ffffffffc020597c:	db2ff0ef          	jal	ra,ffffffffc0204f2e <fd_array_dup>
ffffffffc0205980:	03848493          	addi	s1,s1,56
ffffffffc0205984:	fe8913e3          	bne	s2,s0,ffffffffc020596a <dup_files+0x48>
ffffffffc0205988:	70a2                	ld	ra,40(sp)
ffffffffc020598a:	7402                	ld	s0,32(sp)
ffffffffc020598c:	64e2                	ld	s1,24(sp)
ffffffffc020598e:	6942                	ld	s2,16(sp)
ffffffffc0205990:	69a2                	ld	s3,8(sp)
ffffffffc0205992:	6a02                	ld	s4,0(sp)
ffffffffc0205994:	4501                	li	a0,0
ffffffffc0205996:	6145                	addi	sp,sp,48
ffffffffc0205998:	8082                	ret
ffffffffc020599a:	00007697          	auipc	a3,0x7
ffffffffc020599e:	f4e68693          	addi	a3,a3,-178 # ffffffffc020c8e8 <commands+0x1140>
ffffffffc02059a2:	00006617          	auipc	a2,0x6
ffffffffc02059a6:	e6660613          	addi	a2,a2,-410 # ffffffffc020b808 <commands+0x60>
ffffffffc02059aa:	05300593          	li	a1,83
ffffffffc02059ae:	00008517          	auipc	a0,0x8
ffffffffc02059b2:	a7250513          	addi	a0,a0,-1422 # ffffffffc020d420 <CSWTCH.79+0x70>
ffffffffc02059b6:	879fa0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02059ba:	00008697          	auipc	a3,0x8
ffffffffc02059be:	a8e68693          	addi	a3,a3,-1394 # ffffffffc020d448 <CSWTCH.79+0x98>
ffffffffc02059c2:	00006617          	auipc	a2,0x6
ffffffffc02059c6:	e4660613          	addi	a2,a2,-442 # ffffffffc020b808 <commands+0x60>
ffffffffc02059ca:	05400593          	li	a1,84
ffffffffc02059ce:	00008517          	auipc	a0,0x8
ffffffffc02059d2:	a5250513          	addi	a0,a0,-1454 # ffffffffc020d420 <CSWTCH.79+0x70>
ffffffffc02059d6:	859fa0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02059da <kernel_thread_entry>:
ffffffffc02059da:	8526                	mv	a0,s1
ffffffffc02059dc:	9402                	jalr	s0
ffffffffc02059de:	690000ef          	jal	ra,ffffffffc020606e <do_exit>

ffffffffc02059e2 <switch_to>:
ffffffffc02059e2:	00153023          	sd	ra,0(a0)
ffffffffc02059e6:	00253423          	sd	sp,8(a0)
ffffffffc02059ea:	e900                	sd	s0,16(a0)
ffffffffc02059ec:	ed04                	sd	s1,24(a0)
ffffffffc02059ee:	03253023          	sd	s2,32(a0)
ffffffffc02059f2:	03353423          	sd	s3,40(a0)
ffffffffc02059f6:	03453823          	sd	s4,48(a0)
ffffffffc02059fa:	03553c23          	sd	s5,56(a0)
ffffffffc02059fe:	05653023          	sd	s6,64(a0)
ffffffffc0205a02:	05753423          	sd	s7,72(a0)
ffffffffc0205a06:	05853823          	sd	s8,80(a0)
ffffffffc0205a0a:	05953c23          	sd	s9,88(a0)
ffffffffc0205a0e:	07a53023          	sd	s10,96(a0)
ffffffffc0205a12:	07b53423          	sd	s11,104(a0)
ffffffffc0205a16:	0005b083          	ld	ra,0(a1)
ffffffffc0205a1a:	0085b103          	ld	sp,8(a1)
ffffffffc0205a1e:	6980                	ld	s0,16(a1)
ffffffffc0205a20:	6d84                	ld	s1,24(a1)
ffffffffc0205a22:	0205b903          	ld	s2,32(a1)
ffffffffc0205a26:	0285b983          	ld	s3,40(a1)
ffffffffc0205a2a:	0305ba03          	ld	s4,48(a1)
ffffffffc0205a2e:	0385ba83          	ld	s5,56(a1)
ffffffffc0205a32:	0405bb03          	ld	s6,64(a1)
ffffffffc0205a36:	0485bb83          	ld	s7,72(a1)
ffffffffc0205a3a:	0505bc03          	ld	s8,80(a1)
ffffffffc0205a3e:	0585bc83          	ld	s9,88(a1)
ffffffffc0205a42:	0605bd03          	ld	s10,96(a1)
ffffffffc0205a46:	0685bd83          	ld	s11,104(a1)
ffffffffc0205a4a:	8082                	ret

ffffffffc0205a4c <alloc_proc>:
ffffffffc0205a4c:	1141                	addi	sp,sp,-16
ffffffffc0205a4e:	15000513          	li	a0,336
ffffffffc0205a52:	e022                	sd	s0,0(sp)
ffffffffc0205a54:	e406                	sd	ra,8(sp)
ffffffffc0205a56:	d71fd0ef          	jal	ra,ffffffffc02037c6 <kmalloc>
ffffffffc0205a5a:	842a                	mv	s0,a0
ffffffffc0205a5c:	c141                	beqz	a0,ffffffffc0205adc <alloc_proc+0x90>
ffffffffc0205a5e:	57fd                	li	a5,-1
ffffffffc0205a60:	1782                	slli	a5,a5,0x20
ffffffffc0205a62:	e11c                	sd	a5,0(a0)
ffffffffc0205a64:	07000613          	li	a2,112
ffffffffc0205a68:	4581                	li	a1,0
ffffffffc0205a6a:	00052423          	sw	zero,8(a0)
ffffffffc0205a6e:	00053823          	sd	zero,16(a0)
ffffffffc0205a72:	00053c23          	sd	zero,24(a0)
ffffffffc0205a76:	02053023          	sd	zero,32(a0)
ffffffffc0205a7a:	02053423          	sd	zero,40(a0)
ffffffffc0205a7e:	14053423          	sd	zero,328(a0)
ffffffffc0205a82:	03050513          	addi	a0,a0,48
ffffffffc0205a86:	578050ef          	jal	ra,ffffffffc020affe <memset>
ffffffffc0205a8a:	00091797          	auipc	a5,0x91
ffffffffc0205a8e:	dfe7b783          	ld	a5,-514(a5) # ffffffffc0296888 <boot_pgdir_pa>
ffffffffc0205a92:	f45c                	sd	a5,168(s0)
ffffffffc0205a94:	0a043023          	sd	zero,160(s0)
ffffffffc0205a98:	0a042823          	sw	zero,176(s0)
ffffffffc0205a9c:	463d                	li	a2,15
ffffffffc0205a9e:	4581                	li	a1,0
ffffffffc0205aa0:	0b440513          	addi	a0,s0,180
ffffffffc0205aa4:	55a050ef          	jal	ra,ffffffffc020affe <memset>
ffffffffc0205aa8:	11040793          	addi	a5,s0,272
ffffffffc0205aac:	0e042623          	sw	zero,236(s0)
ffffffffc0205ab0:	0e043c23          	sd	zero,248(s0)
ffffffffc0205ab4:	10043023          	sd	zero,256(s0)
ffffffffc0205ab8:	0e043823          	sd	zero,240(s0)
ffffffffc0205abc:	10043423          	sd	zero,264(s0)
ffffffffc0205ac0:	10f43c23          	sd	a5,280(s0)
ffffffffc0205ac4:	10f43823          	sd	a5,272(s0)
ffffffffc0205ac8:	12042023          	sw	zero,288(s0)
ffffffffc0205acc:	12043423          	sd	zero,296(s0)
ffffffffc0205ad0:	12043823          	sd	zero,304(s0)
ffffffffc0205ad4:	12043c23          	sd	zero,312(s0)
ffffffffc0205ad8:	14043023          	sd	zero,320(s0)
ffffffffc0205adc:	60a2                	ld	ra,8(sp)
ffffffffc0205ade:	8522                	mv	a0,s0
ffffffffc0205ae0:	6402                	ld	s0,0(sp)
ffffffffc0205ae2:	0141                	addi	sp,sp,16
ffffffffc0205ae4:	8082                	ret

ffffffffc0205ae6 <forkret>:
ffffffffc0205ae6:	00091797          	auipc	a5,0x91
ffffffffc0205aea:	dda7b783          	ld	a5,-550(a5) # ffffffffc02968c0 <current>
ffffffffc0205aee:	73c8                	ld	a0,160(a5)
ffffffffc0205af0:	fc2fb06f          	j	ffffffffc02012b2 <forkrets>

ffffffffc0205af4 <put_pgdir.isra.0>:
ffffffffc0205af4:	1141                	addi	sp,sp,-16
ffffffffc0205af6:	e406                	sd	ra,8(sp)
ffffffffc0205af8:	c02007b7          	lui	a5,0xc0200
ffffffffc0205afc:	02f56e63          	bltu	a0,a5,ffffffffc0205b38 <put_pgdir.isra.0+0x44>
ffffffffc0205b00:	00091697          	auipc	a3,0x91
ffffffffc0205b04:	db06b683          	ld	a3,-592(a3) # ffffffffc02968b0 <va_pa_offset>
ffffffffc0205b08:	8d15                	sub	a0,a0,a3
ffffffffc0205b0a:	8131                	srli	a0,a0,0xc
ffffffffc0205b0c:	00091797          	auipc	a5,0x91
ffffffffc0205b10:	d8c7b783          	ld	a5,-628(a5) # ffffffffc0296898 <npage>
ffffffffc0205b14:	02f57f63          	bgeu	a0,a5,ffffffffc0205b52 <put_pgdir.isra.0+0x5e>
ffffffffc0205b18:	0000a697          	auipc	a3,0xa
ffffffffc0205b1c:	c906b683          	ld	a3,-880(a3) # ffffffffc020f7a8 <nbase>
ffffffffc0205b20:	60a2                	ld	ra,8(sp)
ffffffffc0205b22:	8d15                	sub	a0,a0,a3
ffffffffc0205b24:	00091797          	auipc	a5,0x91
ffffffffc0205b28:	d7c7b783          	ld	a5,-644(a5) # ffffffffc02968a0 <pages>
ffffffffc0205b2c:	051a                	slli	a0,a0,0x6
ffffffffc0205b2e:	4585                	li	a1,1
ffffffffc0205b30:	953e                	add	a0,a0,a5
ffffffffc0205b32:	0141                	addi	sp,sp,16
ffffffffc0205b34:	ff8fb06f          	j	ffffffffc020132c <free_pages>
ffffffffc0205b38:	86aa                	mv	a3,a0
ffffffffc0205b3a:	00006617          	auipc	a2,0x6
ffffffffc0205b3e:	6f660613          	addi	a2,a2,1782 # ffffffffc020c230 <commands+0xa88>
ffffffffc0205b42:	07700593          	li	a1,119
ffffffffc0205b46:	00006517          	auipc	a0,0x6
ffffffffc0205b4a:	59250513          	addi	a0,a0,1426 # ffffffffc020c0d8 <commands+0x930>
ffffffffc0205b4e:	ee0fa0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0205b52:	00006617          	auipc	a2,0x6
ffffffffc0205b56:	56660613          	addi	a2,a2,1382 # ffffffffc020c0b8 <commands+0x910>
ffffffffc0205b5a:	06900593          	li	a1,105
ffffffffc0205b5e:	00006517          	auipc	a0,0x6
ffffffffc0205b62:	57a50513          	addi	a0,a0,1402 # ffffffffc020c0d8 <commands+0x930>
ffffffffc0205b66:	ec8fa0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0205b6a <proc_run>:
ffffffffc0205b6a:	7179                	addi	sp,sp,-48
ffffffffc0205b6c:	ec4a                	sd	s2,24(sp)
ffffffffc0205b6e:	00091917          	auipc	s2,0x91
ffffffffc0205b72:	d5290913          	addi	s2,s2,-686 # ffffffffc02968c0 <current>
ffffffffc0205b76:	f026                	sd	s1,32(sp)
ffffffffc0205b78:	00093483          	ld	s1,0(s2)
ffffffffc0205b7c:	f406                	sd	ra,40(sp)
ffffffffc0205b7e:	e84e                	sd	s3,16(sp)
ffffffffc0205b80:	02a48a63          	beq	s1,a0,ffffffffc0205bb4 <proc_run+0x4a>
ffffffffc0205b84:	100027f3          	csrr	a5,sstatus
ffffffffc0205b88:	8b89                	andi	a5,a5,2
ffffffffc0205b8a:	4981                	li	s3,0
ffffffffc0205b8c:	e3a9                	bnez	a5,ffffffffc0205bce <proc_run+0x64>
ffffffffc0205b8e:	755c                	ld	a5,168(a0)
ffffffffc0205b90:	577d                	li	a4,-1
ffffffffc0205b92:	177e                	slli	a4,a4,0x3f
ffffffffc0205b94:	83b1                	srli	a5,a5,0xc
ffffffffc0205b96:	00a93023          	sd	a0,0(s2)
ffffffffc0205b9a:	8fd9                	or	a5,a5,a4
ffffffffc0205b9c:	18079073          	csrw	satp,a5
ffffffffc0205ba0:	12000073          	sfence.vma
ffffffffc0205ba4:	03050593          	addi	a1,a0,48
ffffffffc0205ba8:	03048513          	addi	a0,s1,48
ffffffffc0205bac:	e37ff0ef          	jal	ra,ffffffffc02059e2 <switch_to>
ffffffffc0205bb0:	00099863          	bnez	s3,ffffffffc0205bc0 <proc_run+0x56>
ffffffffc0205bb4:	70a2                	ld	ra,40(sp)
ffffffffc0205bb6:	7482                	ld	s1,32(sp)
ffffffffc0205bb8:	6962                	ld	s2,24(sp)
ffffffffc0205bba:	69c2                	ld	s3,16(sp)
ffffffffc0205bbc:	6145                	addi	sp,sp,48
ffffffffc0205bbe:	8082                	ret
ffffffffc0205bc0:	70a2                	ld	ra,40(sp)
ffffffffc0205bc2:	7482                	ld	s1,32(sp)
ffffffffc0205bc4:	6962                	ld	s2,24(sp)
ffffffffc0205bc6:	69c2                	ld	s3,16(sp)
ffffffffc0205bc8:	6145                	addi	sp,sp,48
ffffffffc0205bca:	9d4fb06f          	j	ffffffffc0200d9e <intr_enable>
ffffffffc0205bce:	e42a                	sd	a0,8(sp)
ffffffffc0205bd0:	9d4fb0ef          	jal	ra,ffffffffc0200da4 <intr_disable>
ffffffffc0205bd4:	6522                	ld	a0,8(sp)
ffffffffc0205bd6:	4985                	li	s3,1
ffffffffc0205bd8:	bf5d                	j	ffffffffc0205b8e <proc_run+0x24>

ffffffffc0205bda <do_fork>:
ffffffffc0205bda:	7119                	addi	sp,sp,-128
ffffffffc0205bdc:	f0ca                	sd	s2,96(sp)
ffffffffc0205bde:	00091917          	auipc	s2,0x91
ffffffffc0205be2:	cfa90913          	addi	s2,s2,-774 # ffffffffc02968d8 <nr_process>
ffffffffc0205be6:	00092783          	lw	a5,0(s2)
ffffffffc0205bea:	ecce                	sd	s3,88(sp)
ffffffffc0205bec:	fc86                	sd	ra,120(sp)
ffffffffc0205bee:	f8a2                	sd	s0,112(sp)
ffffffffc0205bf0:	f4a6                	sd	s1,104(sp)
ffffffffc0205bf2:	e8d2                	sd	s4,80(sp)
ffffffffc0205bf4:	e4d6                	sd	s5,72(sp)
ffffffffc0205bf6:	e0da                	sd	s6,64(sp)
ffffffffc0205bf8:	fc5e                	sd	s7,56(sp)
ffffffffc0205bfa:	f862                	sd	s8,48(sp)
ffffffffc0205bfc:	f466                	sd	s9,40(sp)
ffffffffc0205bfe:	f06a                	sd	s10,32(sp)
ffffffffc0205c00:	ec6e                	sd	s11,24(sp)
ffffffffc0205c02:	6985                	lui	s3,0x1
ffffffffc0205c04:	e432                	sd	a2,8(sp)
ffffffffc0205c06:	3737d763          	bge	a5,s3,ffffffffc0205f74 <do_fork+0x39a>
ffffffffc0205c0a:	8a2a                	mv	s4,a0
ffffffffc0205c0c:	8aae                	mv	s5,a1
ffffffffc0205c0e:	e3fff0ef          	jal	ra,ffffffffc0205a4c <alloc_proc>
ffffffffc0205c12:	842a                	mv	s0,a0
ffffffffc0205c14:	34050963          	beqz	a0,ffffffffc0205f66 <do_fork+0x38c>
ffffffffc0205c18:	00091b17          	auipc	s6,0x91
ffffffffc0205c1c:	ca8b0b13          	addi	s6,s6,-856 # ffffffffc02968c0 <current>
ffffffffc0205c20:	000b3783          	ld	a5,0(s6)
ffffffffc0205c24:	0ec7a703          	lw	a4,236(a5)
ffffffffc0205c28:	f11c                	sd	a5,32(a0)
ffffffffc0205c2a:	3c071a63          	bnez	a4,ffffffffc0205ffe <do_fork+0x424>
ffffffffc0205c2e:	4509                	li	a0,2
ffffffffc0205c30:	ebefb0ef          	jal	ra,ffffffffc02012ee <alloc_pages>
ffffffffc0205c34:	32050663          	beqz	a0,ffffffffc0205f60 <do_fork+0x386>
ffffffffc0205c38:	00091c17          	auipc	s8,0x91
ffffffffc0205c3c:	c68c0c13          	addi	s8,s8,-920 # ffffffffc02968a0 <pages>
ffffffffc0205c40:	000c3683          	ld	a3,0(s8)
ffffffffc0205c44:	0000ab97          	auipc	s7,0xa
ffffffffc0205c48:	b64bbb83          	ld	s7,-1180(s7) # ffffffffc020f7a8 <nbase>
ffffffffc0205c4c:	00091c97          	auipc	s9,0x91
ffffffffc0205c50:	c4cc8c93          	addi	s9,s9,-948 # ffffffffc0296898 <npage>
ffffffffc0205c54:	40d506b3          	sub	a3,a0,a3
ffffffffc0205c58:	8699                	srai	a3,a3,0x6
ffffffffc0205c5a:	96de                	add	a3,a3,s7
ffffffffc0205c5c:	000cb703          	ld	a4,0(s9)
ffffffffc0205c60:	00c69793          	slli	a5,a3,0xc
ffffffffc0205c64:	83b1                	srli	a5,a5,0xc
ffffffffc0205c66:	06b2                	slli	a3,a3,0xc
ffffffffc0205c68:	30e7fb63          	bgeu	a5,a4,ffffffffc0205f7e <do_fork+0x3a4>
ffffffffc0205c6c:	000b3603          	ld	a2,0(s6)
ffffffffc0205c70:	00091d17          	auipc	s10,0x91
ffffffffc0205c74:	c40d0d13          	addi	s10,s10,-960 # ffffffffc02968b0 <va_pa_offset>
ffffffffc0205c78:	000d3783          	ld	a5,0(s10)
ffffffffc0205c7c:	14863d83          	ld	s11,328(a2)
ffffffffc0205c80:	96be                	add	a3,a3,a5
ffffffffc0205c82:	e814                	sd	a3,16(s0)
ffffffffc0205c84:	340d8d63          	beqz	s11,ffffffffc0205fde <do_fork+0x404>
ffffffffc0205c88:	80098993          	addi	s3,s3,-2048 # 800 <_binary_bin_swap_img_size-0x7500>
ffffffffc0205c8c:	013a79b3          	and	s3,s4,s3
ffffffffc0205c90:	1c098a63          	beqz	s3,ffffffffc0205e64 <do_fork+0x28a>
ffffffffc0205c94:	010da703          	lw	a4,16(s11)
ffffffffc0205c98:	7604                	ld	s1,40(a2)
ffffffffc0205c9a:	2705                	addiw	a4,a4,1
ffffffffc0205c9c:	00eda823          	sw	a4,16(s11)
ffffffffc0205ca0:	15b43423          	sd	s11,328(s0)
ffffffffc0205ca4:	c095                	beqz	s1,ffffffffc0205cc8 <do_fork+0xee>
ffffffffc0205ca6:	100a7a13          	andi	s4,s4,256
ffffffffc0205caa:	1c0a0963          	beqz	s4,ffffffffc0205e7c <do_fork+0x2a2>
ffffffffc0205cae:	5898                	lw	a4,48(s1)
ffffffffc0205cb0:	6c94                	ld	a3,24(s1)
ffffffffc0205cb2:	c0200637          	lui	a2,0xc0200
ffffffffc0205cb6:	2705                	addiw	a4,a4,1
ffffffffc0205cb8:	d898                	sw	a4,48(s1)
ffffffffc0205cba:	f404                	sd	s1,40(s0)
ffffffffc0205cbc:	2ec6e963          	bltu	a3,a2,ffffffffc0205fae <do_fork+0x3d4>
ffffffffc0205cc0:	000d3783          	ld	a5,0(s10)
ffffffffc0205cc4:	8e9d                	sub	a3,a3,a5
ffffffffc0205cc6:	f454                	sd	a3,168(s0)
ffffffffc0205cc8:	6818                	ld	a4,16(s0)
ffffffffc0205cca:	6622                	ld	a2,8(sp)
ffffffffc0205ccc:	6789                	lui	a5,0x2
ffffffffc0205cce:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_bin_swap_img_size-0x5e20>
ffffffffc0205cd2:	973e                	add	a4,a4,a5
ffffffffc0205cd4:	f058                	sd	a4,160(s0)
ffffffffc0205cd6:	87ba                	mv	a5,a4
ffffffffc0205cd8:	12060893          	addi	a7,a2,288 # ffffffffc0200120 <vcprintf+0x1c>
ffffffffc0205cdc:	00063803          	ld	a6,0(a2)
ffffffffc0205ce0:	6608                	ld	a0,8(a2)
ffffffffc0205ce2:	6a0c                	ld	a1,16(a2)
ffffffffc0205ce4:	6e14                	ld	a3,24(a2)
ffffffffc0205ce6:	0107b023          	sd	a6,0(a5)
ffffffffc0205cea:	e788                	sd	a0,8(a5)
ffffffffc0205cec:	eb8c                	sd	a1,16(a5)
ffffffffc0205cee:	ef94                	sd	a3,24(a5)
ffffffffc0205cf0:	02060613          	addi	a2,a2,32
ffffffffc0205cf4:	02078793          	addi	a5,a5,32
ffffffffc0205cf8:	ff1612e3          	bne	a2,a7,ffffffffc0205cdc <do_fork+0x102>
ffffffffc0205cfc:	04073823          	sd	zero,80(a4)
ffffffffc0205d00:	120a8f63          	beqz	s5,ffffffffc0205e3e <do_fork+0x264>
ffffffffc0205d04:	01573823          	sd	s5,16(a4)
ffffffffc0205d08:	00000797          	auipc	a5,0x0
ffffffffc0205d0c:	dde78793          	addi	a5,a5,-546 # ffffffffc0205ae6 <forkret>
ffffffffc0205d10:	f81c                	sd	a5,48(s0)
ffffffffc0205d12:	fc18                	sd	a4,56(s0)
ffffffffc0205d14:	100027f3          	csrr	a5,sstatus
ffffffffc0205d18:	8b89                	andi	a5,a5,2
ffffffffc0205d1a:	4981                	li	s3,0
ffffffffc0205d1c:	14079063          	bnez	a5,ffffffffc0205e5c <do_fork+0x282>
ffffffffc0205d20:	0008b817          	auipc	a6,0x8b
ffffffffc0205d24:	33880813          	addi	a6,a6,824 # ffffffffc0291058 <last_pid.1>
ffffffffc0205d28:	00082783          	lw	a5,0(a6)
ffffffffc0205d2c:	6709                	lui	a4,0x2
ffffffffc0205d2e:	0017851b          	addiw	a0,a5,1
ffffffffc0205d32:	00a82023          	sw	a0,0(a6)
ffffffffc0205d36:	08e55d63          	bge	a0,a4,ffffffffc0205dd0 <do_fork+0x1f6>
ffffffffc0205d3a:	0008b317          	auipc	t1,0x8b
ffffffffc0205d3e:	32230313          	addi	t1,t1,802 # ffffffffc029105c <next_safe.0>
ffffffffc0205d42:	00032783          	lw	a5,0(t1)
ffffffffc0205d46:	00090497          	auipc	s1,0x90
ffffffffc0205d4a:	a7a48493          	addi	s1,s1,-1414 # ffffffffc02957c0 <proc_list>
ffffffffc0205d4e:	08f55963          	bge	a0,a5,ffffffffc0205de0 <do_fork+0x206>
ffffffffc0205d52:	c048                	sw	a0,4(s0)
ffffffffc0205d54:	45a9                	li	a1,10
ffffffffc0205d56:	2501                	sext.w	a0,a0
ffffffffc0205d58:	78c050ef          	jal	ra,ffffffffc020b4e4 <hash32>
ffffffffc0205d5c:	02051793          	slli	a5,a0,0x20
ffffffffc0205d60:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0205d64:	0008c797          	auipc	a5,0x8c
ffffffffc0205d68:	a5c78793          	addi	a5,a5,-1444 # ffffffffc02917c0 <hash_list>
ffffffffc0205d6c:	953e                	add	a0,a0,a5
ffffffffc0205d6e:	650c                	ld	a1,8(a0)
ffffffffc0205d70:	7014                	ld	a3,32(s0)
ffffffffc0205d72:	0d840793          	addi	a5,s0,216
ffffffffc0205d76:	e19c                	sd	a5,0(a1)
ffffffffc0205d78:	6490                	ld	a2,8(s1)
ffffffffc0205d7a:	e51c                	sd	a5,8(a0)
ffffffffc0205d7c:	7af8                	ld	a4,240(a3)
ffffffffc0205d7e:	0c840793          	addi	a5,s0,200
ffffffffc0205d82:	f06c                	sd	a1,224(s0)
ffffffffc0205d84:	ec68                	sd	a0,216(s0)
ffffffffc0205d86:	e21c                	sd	a5,0(a2)
ffffffffc0205d88:	e49c                	sd	a5,8(s1)
ffffffffc0205d8a:	e870                	sd	a2,208(s0)
ffffffffc0205d8c:	e464                	sd	s1,200(s0)
ffffffffc0205d8e:	0e043c23          	sd	zero,248(s0)
ffffffffc0205d92:	10e43023          	sd	a4,256(s0)
ffffffffc0205d96:	c311                	beqz	a4,ffffffffc0205d9a <do_fork+0x1c0>
ffffffffc0205d98:	ff60                	sd	s0,248(a4)
ffffffffc0205d9a:	00092783          	lw	a5,0(s2)
ffffffffc0205d9e:	fae0                	sd	s0,240(a3)
ffffffffc0205da0:	2785                	addiw	a5,a5,1
ffffffffc0205da2:	00f92023          	sw	a5,0(s2)
ffffffffc0205da6:	14099663          	bnez	s3,ffffffffc0205ef2 <do_fork+0x318>
ffffffffc0205daa:	8522                	mv	a0,s0
ffffffffc0205dac:	3c4010ef          	jal	ra,ffffffffc0207170 <wakeup_proc>
ffffffffc0205db0:	4048                	lw	a0,4(s0)
ffffffffc0205db2:	70e6                	ld	ra,120(sp)
ffffffffc0205db4:	7446                	ld	s0,112(sp)
ffffffffc0205db6:	74a6                	ld	s1,104(sp)
ffffffffc0205db8:	7906                	ld	s2,96(sp)
ffffffffc0205dba:	69e6                	ld	s3,88(sp)
ffffffffc0205dbc:	6a46                	ld	s4,80(sp)
ffffffffc0205dbe:	6aa6                	ld	s5,72(sp)
ffffffffc0205dc0:	6b06                	ld	s6,64(sp)
ffffffffc0205dc2:	7be2                	ld	s7,56(sp)
ffffffffc0205dc4:	7c42                	ld	s8,48(sp)
ffffffffc0205dc6:	7ca2                	ld	s9,40(sp)
ffffffffc0205dc8:	7d02                	ld	s10,32(sp)
ffffffffc0205dca:	6de2                	ld	s11,24(sp)
ffffffffc0205dcc:	6109                	addi	sp,sp,128
ffffffffc0205dce:	8082                	ret
ffffffffc0205dd0:	4785                	li	a5,1
ffffffffc0205dd2:	00f82023          	sw	a5,0(a6)
ffffffffc0205dd6:	4505                	li	a0,1
ffffffffc0205dd8:	0008b317          	auipc	t1,0x8b
ffffffffc0205ddc:	28430313          	addi	t1,t1,644 # ffffffffc029105c <next_safe.0>
ffffffffc0205de0:	00090497          	auipc	s1,0x90
ffffffffc0205de4:	9e048493          	addi	s1,s1,-1568 # ffffffffc02957c0 <proc_list>
ffffffffc0205de8:	0084be03          	ld	t3,8(s1)
ffffffffc0205dec:	6789                	lui	a5,0x2
ffffffffc0205dee:	00f32023          	sw	a5,0(t1)
ffffffffc0205df2:	86aa                	mv	a3,a0
ffffffffc0205df4:	4581                	li	a1,0
ffffffffc0205df6:	6e89                	lui	t4,0x2
ffffffffc0205df8:	169e0963          	beq	t3,s1,ffffffffc0205f6a <do_fork+0x390>
ffffffffc0205dfc:	88ae                	mv	a7,a1
ffffffffc0205dfe:	87f2                	mv	a5,t3
ffffffffc0205e00:	6609                	lui	a2,0x2
ffffffffc0205e02:	a811                	j	ffffffffc0205e16 <do_fork+0x23c>
ffffffffc0205e04:	00e6d663          	bge	a3,a4,ffffffffc0205e10 <do_fork+0x236>
ffffffffc0205e08:	00c75463          	bge	a4,a2,ffffffffc0205e10 <do_fork+0x236>
ffffffffc0205e0c:	863a                	mv	a2,a4
ffffffffc0205e0e:	4885                	li	a7,1
ffffffffc0205e10:	679c                	ld	a5,8(a5)
ffffffffc0205e12:	00978d63          	beq	a5,s1,ffffffffc0205e2c <do_fork+0x252>
ffffffffc0205e16:	f3c7a703          	lw	a4,-196(a5) # 1f3c <_binary_bin_swap_img_size-0x5dc4>
ffffffffc0205e1a:	fed715e3          	bne	a4,a3,ffffffffc0205e04 <do_fork+0x22a>
ffffffffc0205e1e:	2685                	addiw	a3,a3,1
ffffffffc0205e20:	0cc6dc63          	bge	a3,a2,ffffffffc0205ef8 <do_fork+0x31e>
ffffffffc0205e24:	679c                	ld	a5,8(a5)
ffffffffc0205e26:	4585                	li	a1,1
ffffffffc0205e28:	fe9797e3          	bne	a5,s1,ffffffffc0205e16 <do_fork+0x23c>
ffffffffc0205e2c:	c581                	beqz	a1,ffffffffc0205e34 <do_fork+0x25a>
ffffffffc0205e2e:	00d82023          	sw	a3,0(a6)
ffffffffc0205e32:	8536                	mv	a0,a3
ffffffffc0205e34:	f0088fe3          	beqz	a7,ffffffffc0205d52 <do_fork+0x178>
ffffffffc0205e38:	00c32023          	sw	a2,0(t1)
ffffffffc0205e3c:	bf19                	j	ffffffffc0205d52 <do_fork+0x178>
ffffffffc0205e3e:	8aba                	mv	s5,a4
ffffffffc0205e40:	01573823          	sd	s5,16(a4) # 2010 <_binary_bin_swap_img_size-0x5cf0>
ffffffffc0205e44:	00000797          	auipc	a5,0x0
ffffffffc0205e48:	ca278793          	addi	a5,a5,-862 # ffffffffc0205ae6 <forkret>
ffffffffc0205e4c:	f81c                	sd	a5,48(s0)
ffffffffc0205e4e:	fc18                	sd	a4,56(s0)
ffffffffc0205e50:	100027f3          	csrr	a5,sstatus
ffffffffc0205e54:	8b89                	andi	a5,a5,2
ffffffffc0205e56:	4981                	li	s3,0
ffffffffc0205e58:	ec0784e3          	beqz	a5,ffffffffc0205d20 <do_fork+0x146>
ffffffffc0205e5c:	f49fa0ef          	jal	ra,ffffffffc0200da4 <intr_disable>
ffffffffc0205e60:	4985                	li	s3,1
ffffffffc0205e62:	bd7d                	j	ffffffffc0205d20 <do_fork+0x146>
ffffffffc0205e64:	987ff0ef          	jal	ra,ffffffffc02057ea <files_create>
ffffffffc0205e68:	89aa                	mv	s3,a0
ffffffffc0205e6a:	c561                	beqz	a0,ffffffffc0205f32 <do_fork+0x358>
ffffffffc0205e6c:	85ee                	mv	a1,s11
ffffffffc0205e6e:	ab5ff0ef          	jal	ra,ffffffffc0205922 <dup_files>
ffffffffc0205e72:	ed4d                	bnez	a0,ffffffffc0205f2c <do_fork+0x352>
ffffffffc0205e74:	000b3603          	ld	a2,0(s6)
ffffffffc0205e78:	8dce                	mv	s11,s3
ffffffffc0205e7a:	bd29                	j	ffffffffc0205c94 <do_fork+0xba>
ffffffffc0205e7c:	f0ffc0ef          	jal	ra,ffffffffc0202d8a <mm_create>
ffffffffc0205e80:	8a2a                	mv	s4,a0
ffffffffc0205e82:	c951                	beqz	a0,ffffffffc0205f16 <do_fork+0x33c>
ffffffffc0205e84:	4505                	li	a0,1
ffffffffc0205e86:	c68fb0ef          	jal	ra,ffffffffc02012ee <alloc_pages>
ffffffffc0205e8a:	c159                	beqz	a0,ffffffffc0205f10 <do_fork+0x336>
ffffffffc0205e8c:	000c3683          	ld	a3,0(s8)
ffffffffc0205e90:	000cb603          	ld	a2,0(s9)
ffffffffc0205e94:	40d506b3          	sub	a3,a0,a3
ffffffffc0205e98:	8699                	srai	a3,a3,0x6
ffffffffc0205e9a:	96de                	add	a3,a3,s7
ffffffffc0205e9c:	00c69713          	slli	a4,a3,0xc
ffffffffc0205ea0:	8331                	srli	a4,a4,0xc
ffffffffc0205ea2:	06b2                	slli	a3,a3,0xc
ffffffffc0205ea4:	0cc77d63          	bgeu	a4,a2,ffffffffc0205f7e <do_fork+0x3a4>
ffffffffc0205ea8:	000d3983          	ld	s3,0(s10)
ffffffffc0205eac:	6605                	lui	a2,0x1
ffffffffc0205eae:	00091597          	auipc	a1,0x91
ffffffffc0205eb2:	9e25b583          	ld	a1,-1566(a1) # ffffffffc0296890 <boot_pgdir_va>
ffffffffc0205eb6:	99b6                	add	s3,s3,a3
ffffffffc0205eb8:	854e                	mv	a0,s3
ffffffffc0205eba:	196050ef          	jal	ra,ffffffffc020b050 <memcpy>
ffffffffc0205ebe:	03848d93          	addi	s11,s1,56
ffffffffc0205ec2:	013a3c23          	sd	s3,24(s4)
ffffffffc0205ec6:	856e                	mv	a0,s11
ffffffffc0205ec8:	887fe0ef          	jal	ra,ffffffffc020474e <down>
ffffffffc0205ecc:	000b3703          	ld	a4,0(s6)
ffffffffc0205ed0:	c319                	beqz	a4,ffffffffc0205ed6 <do_fork+0x2fc>
ffffffffc0205ed2:	4358                	lw	a4,4(a4)
ffffffffc0205ed4:	c8b8                	sw	a4,80(s1)
ffffffffc0205ed6:	85a6                	mv	a1,s1
ffffffffc0205ed8:	8552                	mv	a0,s4
ffffffffc0205eda:	900fd0ef          	jal	ra,ffffffffc0202fda <dup_mmap>
ffffffffc0205ede:	89aa                	mv	s3,a0
ffffffffc0205ee0:	856e                	mv	a0,s11
ffffffffc0205ee2:	869fe0ef          	jal	ra,ffffffffc020474a <up>
ffffffffc0205ee6:	0404a823          	sw	zero,80(s1)
ffffffffc0205eea:	00099c63          	bnez	s3,ffffffffc0205f02 <do_fork+0x328>
ffffffffc0205eee:	84d2                	mv	s1,s4
ffffffffc0205ef0:	bb7d                	j	ffffffffc0205cae <do_fork+0xd4>
ffffffffc0205ef2:	eadfa0ef          	jal	ra,ffffffffc0200d9e <intr_enable>
ffffffffc0205ef6:	bd55                	j	ffffffffc0205daa <do_fork+0x1d0>
ffffffffc0205ef8:	01d6c363          	blt	a3,t4,ffffffffc0205efe <do_fork+0x324>
ffffffffc0205efc:	4685                	li	a3,1
ffffffffc0205efe:	4585                	li	a1,1
ffffffffc0205f00:	bde5                	j	ffffffffc0205df8 <do_fork+0x21e>
ffffffffc0205f02:	8552                	mv	a0,s4
ffffffffc0205f04:	970fd0ef          	jal	ra,ffffffffc0203074 <exit_mmap>
ffffffffc0205f08:	018a3503          	ld	a0,24(s4)
ffffffffc0205f0c:	be9ff0ef          	jal	ra,ffffffffc0205af4 <put_pgdir.isra.0>
ffffffffc0205f10:	8552                	mv	a0,s4
ffffffffc0205f12:	fc7fc0ef          	jal	ra,ffffffffc0202ed8 <mm_destroy>
ffffffffc0205f16:	14843503          	ld	a0,328(s0)
ffffffffc0205f1a:	cd01                	beqz	a0,ffffffffc0205f32 <do_fork+0x358>
ffffffffc0205f1c:	491c                	lw	a5,16(a0)
ffffffffc0205f1e:	fff7871b          	addiw	a4,a5,-1
ffffffffc0205f22:	c918                	sw	a4,16(a0)
ffffffffc0205f24:	e719                	bnez	a4,ffffffffc0205f32 <do_fork+0x358>
ffffffffc0205f26:	8fbff0ef          	jal	ra,ffffffffc0205820 <files_destroy>
ffffffffc0205f2a:	a021                	j	ffffffffc0205f32 <do_fork+0x358>
ffffffffc0205f2c:	854e                	mv	a0,s3
ffffffffc0205f2e:	8f3ff0ef          	jal	ra,ffffffffc0205820 <files_destroy>
ffffffffc0205f32:	6814                	ld	a3,16(s0)
ffffffffc0205f34:	c02007b7          	lui	a5,0xc0200
ffffffffc0205f38:	04f6ef63          	bltu	a3,a5,ffffffffc0205f96 <do_fork+0x3bc>
ffffffffc0205f3c:	000d3783          	ld	a5,0(s10)
ffffffffc0205f40:	000cb703          	ld	a4,0(s9)
ffffffffc0205f44:	40f687b3          	sub	a5,a3,a5
ffffffffc0205f48:	83b1                	srli	a5,a5,0xc
ffffffffc0205f4a:	06e7fe63          	bgeu	a5,a4,ffffffffc0205fc6 <do_fork+0x3ec>
ffffffffc0205f4e:	000c3503          	ld	a0,0(s8)
ffffffffc0205f52:	417787b3          	sub	a5,a5,s7
ffffffffc0205f56:	079a                	slli	a5,a5,0x6
ffffffffc0205f58:	4589                	li	a1,2
ffffffffc0205f5a:	953e                	add	a0,a0,a5
ffffffffc0205f5c:	bd0fb0ef          	jal	ra,ffffffffc020132c <free_pages>
ffffffffc0205f60:	8522                	mv	a0,s0
ffffffffc0205f62:	915fd0ef          	jal	ra,ffffffffc0203876 <kfree>
ffffffffc0205f66:	5571                	li	a0,-4
ffffffffc0205f68:	b5a9                	j	ffffffffc0205db2 <do_fork+0x1d8>
ffffffffc0205f6a:	c599                	beqz	a1,ffffffffc0205f78 <do_fork+0x39e>
ffffffffc0205f6c:	00d82023          	sw	a3,0(a6)
ffffffffc0205f70:	8536                	mv	a0,a3
ffffffffc0205f72:	b3c5                	j	ffffffffc0205d52 <do_fork+0x178>
ffffffffc0205f74:	556d                	li	a0,-5
ffffffffc0205f76:	bd35                	j	ffffffffc0205db2 <do_fork+0x1d8>
ffffffffc0205f78:	00082503          	lw	a0,0(a6)
ffffffffc0205f7c:	bbd9                	j	ffffffffc0205d52 <do_fork+0x178>
ffffffffc0205f7e:	00006617          	auipc	a2,0x6
ffffffffc0205f82:	19260613          	addi	a2,a2,402 # ffffffffc020c110 <commands+0x968>
ffffffffc0205f86:	07100593          	li	a1,113
ffffffffc0205f8a:	00006517          	auipc	a0,0x6
ffffffffc0205f8e:	14e50513          	addi	a0,a0,334 # ffffffffc020c0d8 <commands+0x930>
ffffffffc0205f92:	a9cfa0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0205f96:	00006617          	auipc	a2,0x6
ffffffffc0205f9a:	29a60613          	addi	a2,a2,666 # ffffffffc020c230 <commands+0xa88>
ffffffffc0205f9e:	07700593          	li	a1,119
ffffffffc0205fa2:	00006517          	auipc	a0,0x6
ffffffffc0205fa6:	13650513          	addi	a0,a0,310 # ffffffffc020c0d8 <commands+0x930>
ffffffffc0205faa:	a84fa0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0205fae:	00006617          	auipc	a2,0x6
ffffffffc0205fb2:	28260613          	addi	a2,a2,642 # ffffffffc020c230 <commands+0xa88>
ffffffffc0205fb6:	1af00593          	li	a1,431
ffffffffc0205fba:	00007517          	auipc	a0,0x7
ffffffffc0205fbe:	4de50513          	addi	a0,a0,1246 # ffffffffc020d498 <CSWTCH.79+0xe8>
ffffffffc0205fc2:	a6cfa0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0205fc6:	00006617          	auipc	a2,0x6
ffffffffc0205fca:	0f260613          	addi	a2,a2,242 # ffffffffc020c0b8 <commands+0x910>
ffffffffc0205fce:	06900593          	li	a1,105
ffffffffc0205fd2:	00006517          	auipc	a0,0x6
ffffffffc0205fd6:	10650513          	addi	a0,a0,262 # ffffffffc020c0d8 <commands+0x930>
ffffffffc0205fda:	a54fa0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0205fde:	00007697          	auipc	a3,0x7
ffffffffc0205fe2:	4d268693          	addi	a3,a3,1234 # ffffffffc020d4b0 <CSWTCH.79+0x100>
ffffffffc0205fe6:	00006617          	auipc	a2,0x6
ffffffffc0205fea:	82260613          	addi	a2,a2,-2014 # ffffffffc020b808 <commands+0x60>
ffffffffc0205fee:	1cf00593          	li	a1,463
ffffffffc0205ff2:	00007517          	auipc	a0,0x7
ffffffffc0205ff6:	4a650513          	addi	a0,a0,1190 # ffffffffc020d498 <CSWTCH.79+0xe8>
ffffffffc0205ffa:	a34fa0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0205ffe:	00007697          	auipc	a3,0x7
ffffffffc0206002:	47a68693          	addi	a3,a3,1146 # ffffffffc020d478 <CSWTCH.79+0xc8>
ffffffffc0206006:	00006617          	auipc	a2,0x6
ffffffffc020600a:	80260613          	addi	a2,a2,-2046 # ffffffffc020b808 <commands+0x60>
ffffffffc020600e:	23000593          	li	a1,560
ffffffffc0206012:	00007517          	auipc	a0,0x7
ffffffffc0206016:	48650513          	addi	a0,a0,1158 # ffffffffc020d498 <CSWTCH.79+0xe8>
ffffffffc020601a:	a14fa0ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020601e <kernel_thread>:
ffffffffc020601e:	7129                	addi	sp,sp,-320
ffffffffc0206020:	fa22                	sd	s0,304(sp)
ffffffffc0206022:	f626                	sd	s1,296(sp)
ffffffffc0206024:	f24a                	sd	s2,288(sp)
ffffffffc0206026:	84ae                	mv	s1,a1
ffffffffc0206028:	892a                	mv	s2,a0
ffffffffc020602a:	8432                	mv	s0,a2
ffffffffc020602c:	4581                	li	a1,0
ffffffffc020602e:	12000613          	li	a2,288
ffffffffc0206032:	850a                	mv	a0,sp
ffffffffc0206034:	fe06                	sd	ra,312(sp)
ffffffffc0206036:	7c9040ef          	jal	ra,ffffffffc020affe <memset>
ffffffffc020603a:	e0ca                	sd	s2,64(sp)
ffffffffc020603c:	e4a6                	sd	s1,72(sp)
ffffffffc020603e:	100027f3          	csrr	a5,sstatus
ffffffffc0206042:	edd7f793          	andi	a5,a5,-291
ffffffffc0206046:	1207e793          	ori	a5,a5,288
ffffffffc020604a:	e23e                	sd	a5,256(sp)
ffffffffc020604c:	860a                	mv	a2,sp
ffffffffc020604e:	10046513          	ori	a0,s0,256
ffffffffc0206052:	00000797          	auipc	a5,0x0
ffffffffc0206056:	98878793          	addi	a5,a5,-1656 # ffffffffc02059da <kernel_thread_entry>
ffffffffc020605a:	4581                	li	a1,0
ffffffffc020605c:	e63e                	sd	a5,264(sp)
ffffffffc020605e:	b7dff0ef          	jal	ra,ffffffffc0205bda <do_fork>
ffffffffc0206062:	70f2                	ld	ra,312(sp)
ffffffffc0206064:	7452                	ld	s0,304(sp)
ffffffffc0206066:	74b2                	ld	s1,296(sp)
ffffffffc0206068:	7912                	ld	s2,288(sp)
ffffffffc020606a:	6131                	addi	sp,sp,320
ffffffffc020606c:	8082                	ret

ffffffffc020606e <do_exit>:
ffffffffc020606e:	7179                	addi	sp,sp,-48
ffffffffc0206070:	f022                	sd	s0,32(sp)
ffffffffc0206072:	00091417          	auipc	s0,0x91
ffffffffc0206076:	84e40413          	addi	s0,s0,-1970 # ffffffffc02968c0 <current>
ffffffffc020607a:	601c                	ld	a5,0(s0)
ffffffffc020607c:	f406                	sd	ra,40(sp)
ffffffffc020607e:	ec26                	sd	s1,24(sp)
ffffffffc0206080:	e84a                	sd	s2,16(sp)
ffffffffc0206082:	e44e                	sd	s3,8(sp)
ffffffffc0206084:	e052                	sd	s4,0(sp)
ffffffffc0206086:	00091717          	auipc	a4,0x91
ffffffffc020608a:	84273703          	ld	a4,-1982(a4) # ffffffffc02968c8 <idleproc>
ffffffffc020608e:	0ee78763          	beq	a5,a4,ffffffffc020617c <do_exit+0x10e>
ffffffffc0206092:	00091497          	auipc	s1,0x91
ffffffffc0206096:	83e48493          	addi	s1,s1,-1986 # ffffffffc02968d0 <initproc>
ffffffffc020609a:	6098                	ld	a4,0(s1)
ffffffffc020609c:	10e78763          	beq	a5,a4,ffffffffc02061aa <do_exit+0x13c>
ffffffffc02060a0:	0287b983          	ld	s3,40(a5)
ffffffffc02060a4:	892a                	mv	s2,a0
ffffffffc02060a6:	02098e63          	beqz	s3,ffffffffc02060e2 <do_exit+0x74>
ffffffffc02060aa:	00090797          	auipc	a5,0x90
ffffffffc02060ae:	7de7b783          	ld	a5,2014(a5) # ffffffffc0296888 <boot_pgdir_pa>
ffffffffc02060b2:	577d                	li	a4,-1
ffffffffc02060b4:	177e                	slli	a4,a4,0x3f
ffffffffc02060b6:	83b1                	srli	a5,a5,0xc
ffffffffc02060b8:	8fd9                	or	a5,a5,a4
ffffffffc02060ba:	18079073          	csrw	satp,a5
ffffffffc02060be:	0309a783          	lw	a5,48(s3)
ffffffffc02060c2:	fff7871b          	addiw	a4,a5,-1
ffffffffc02060c6:	02e9a823          	sw	a4,48(s3)
ffffffffc02060ca:	c769                	beqz	a4,ffffffffc0206194 <do_exit+0x126>
ffffffffc02060cc:	601c                	ld	a5,0(s0)
ffffffffc02060ce:	1487b503          	ld	a0,328(a5)
ffffffffc02060d2:	0207b423          	sd	zero,40(a5)
ffffffffc02060d6:	c511                	beqz	a0,ffffffffc02060e2 <do_exit+0x74>
ffffffffc02060d8:	491c                	lw	a5,16(a0)
ffffffffc02060da:	fff7871b          	addiw	a4,a5,-1
ffffffffc02060de:	c918                	sw	a4,16(a0)
ffffffffc02060e0:	cb59                	beqz	a4,ffffffffc0206176 <do_exit+0x108>
ffffffffc02060e2:	601c                	ld	a5,0(s0)
ffffffffc02060e4:	470d                	li	a4,3
ffffffffc02060e6:	c398                	sw	a4,0(a5)
ffffffffc02060e8:	0f27a423          	sw	s2,232(a5)
ffffffffc02060ec:	100027f3          	csrr	a5,sstatus
ffffffffc02060f0:	8b89                	andi	a5,a5,2
ffffffffc02060f2:	4a01                	li	s4,0
ffffffffc02060f4:	e7f9                	bnez	a5,ffffffffc02061c2 <do_exit+0x154>
ffffffffc02060f6:	6018                	ld	a4,0(s0)
ffffffffc02060f8:	800007b7          	lui	a5,0x80000
ffffffffc02060fc:	0785                	addi	a5,a5,1
ffffffffc02060fe:	7308                	ld	a0,32(a4)
ffffffffc0206100:	0ec52703          	lw	a4,236(a0)
ffffffffc0206104:	0cf70363          	beq	a4,a5,ffffffffc02061ca <do_exit+0x15c>
ffffffffc0206108:	6018                	ld	a4,0(s0)
ffffffffc020610a:	7b7c                	ld	a5,240(a4)
ffffffffc020610c:	c3a1                	beqz	a5,ffffffffc020614c <do_exit+0xde>
ffffffffc020610e:	800009b7          	lui	s3,0x80000
ffffffffc0206112:	490d                	li	s2,3
ffffffffc0206114:	0985                	addi	s3,s3,1
ffffffffc0206116:	a021                	j	ffffffffc020611e <do_exit+0xb0>
ffffffffc0206118:	6018                	ld	a4,0(s0)
ffffffffc020611a:	7b7c                	ld	a5,240(a4)
ffffffffc020611c:	cb85                	beqz	a5,ffffffffc020614c <do_exit+0xde>
ffffffffc020611e:	1007b683          	ld	a3,256(a5) # ffffffff80000100 <_binary_bin_sfs_img_size+0xffffffff7ff8ae00>
ffffffffc0206122:	6088                	ld	a0,0(s1)
ffffffffc0206124:	fb74                	sd	a3,240(a4)
ffffffffc0206126:	7978                	ld	a4,240(a0)
ffffffffc0206128:	0e07bc23          	sd	zero,248(a5)
ffffffffc020612c:	10e7b023          	sd	a4,256(a5)
ffffffffc0206130:	c311                	beqz	a4,ffffffffc0206134 <do_exit+0xc6>
ffffffffc0206132:	ff7c                	sd	a5,248(a4)
ffffffffc0206134:	4398                	lw	a4,0(a5)
ffffffffc0206136:	f388                	sd	a0,32(a5)
ffffffffc0206138:	f97c                	sd	a5,240(a0)
ffffffffc020613a:	fd271fe3          	bne	a4,s2,ffffffffc0206118 <do_exit+0xaa>
ffffffffc020613e:	0ec52783          	lw	a5,236(a0)
ffffffffc0206142:	fd379be3          	bne	a5,s3,ffffffffc0206118 <do_exit+0xaa>
ffffffffc0206146:	02a010ef          	jal	ra,ffffffffc0207170 <wakeup_proc>
ffffffffc020614a:	b7f9                	j	ffffffffc0206118 <do_exit+0xaa>
ffffffffc020614c:	020a1263          	bnez	s4,ffffffffc0206170 <do_exit+0x102>
ffffffffc0206150:	0d2010ef          	jal	ra,ffffffffc0207222 <schedule>
ffffffffc0206154:	601c                	ld	a5,0(s0)
ffffffffc0206156:	00007617          	auipc	a2,0x7
ffffffffc020615a:	39260613          	addi	a2,a2,914 # ffffffffc020d4e8 <CSWTCH.79+0x138>
ffffffffc020615e:	29c00593          	li	a1,668
ffffffffc0206162:	43d4                	lw	a3,4(a5)
ffffffffc0206164:	00007517          	auipc	a0,0x7
ffffffffc0206168:	33450513          	addi	a0,a0,820 # ffffffffc020d498 <CSWTCH.79+0xe8>
ffffffffc020616c:	8c2fa0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0206170:	c2ffa0ef          	jal	ra,ffffffffc0200d9e <intr_enable>
ffffffffc0206174:	bff1                	j	ffffffffc0206150 <do_exit+0xe2>
ffffffffc0206176:	eaaff0ef          	jal	ra,ffffffffc0205820 <files_destroy>
ffffffffc020617a:	b7a5                	j	ffffffffc02060e2 <do_exit+0x74>
ffffffffc020617c:	00007617          	auipc	a2,0x7
ffffffffc0206180:	34c60613          	addi	a2,a2,844 # ffffffffc020d4c8 <CSWTCH.79+0x118>
ffffffffc0206184:	26700593          	li	a1,615
ffffffffc0206188:	00007517          	auipc	a0,0x7
ffffffffc020618c:	31050513          	addi	a0,a0,784 # ffffffffc020d498 <CSWTCH.79+0xe8>
ffffffffc0206190:	89efa0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0206194:	854e                	mv	a0,s3
ffffffffc0206196:	edffc0ef          	jal	ra,ffffffffc0203074 <exit_mmap>
ffffffffc020619a:	0189b503          	ld	a0,24(s3) # ffffffff80000018 <_binary_bin_sfs_img_size+0xffffffff7ff8ad18>
ffffffffc020619e:	957ff0ef          	jal	ra,ffffffffc0205af4 <put_pgdir.isra.0>
ffffffffc02061a2:	854e                	mv	a0,s3
ffffffffc02061a4:	d35fc0ef          	jal	ra,ffffffffc0202ed8 <mm_destroy>
ffffffffc02061a8:	b715                	j	ffffffffc02060cc <do_exit+0x5e>
ffffffffc02061aa:	00007617          	auipc	a2,0x7
ffffffffc02061ae:	32e60613          	addi	a2,a2,814 # ffffffffc020d4d8 <CSWTCH.79+0x128>
ffffffffc02061b2:	26b00593          	li	a1,619
ffffffffc02061b6:	00007517          	auipc	a0,0x7
ffffffffc02061ba:	2e250513          	addi	a0,a0,738 # ffffffffc020d498 <CSWTCH.79+0xe8>
ffffffffc02061be:	870fa0ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02061c2:	be3fa0ef          	jal	ra,ffffffffc0200da4 <intr_disable>
ffffffffc02061c6:	4a05                	li	s4,1
ffffffffc02061c8:	b73d                	j	ffffffffc02060f6 <do_exit+0x88>
ffffffffc02061ca:	7a7000ef          	jal	ra,ffffffffc0207170 <wakeup_proc>
ffffffffc02061ce:	bf2d                	j	ffffffffc0206108 <do_exit+0x9a>

ffffffffc02061d0 <do_wait.part.0>:
ffffffffc02061d0:	715d                	addi	sp,sp,-80
ffffffffc02061d2:	f84a                	sd	s2,48(sp)
ffffffffc02061d4:	f44e                	sd	s3,40(sp)
ffffffffc02061d6:	80000937          	lui	s2,0x80000
ffffffffc02061da:	6989                	lui	s3,0x2
ffffffffc02061dc:	fc26                	sd	s1,56(sp)
ffffffffc02061de:	f052                	sd	s4,32(sp)
ffffffffc02061e0:	ec56                	sd	s5,24(sp)
ffffffffc02061e2:	e85a                	sd	s6,16(sp)
ffffffffc02061e4:	e45e                	sd	s7,8(sp)
ffffffffc02061e6:	e486                	sd	ra,72(sp)
ffffffffc02061e8:	e0a2                	sd	s0,64(sp)
ffffffffc02061ea:	84aa                	mv	s1,a0
ffffffffc02061ec:	8a2e                	mv	s4,a1
ffffffffc02061ee:	00090b97          	auipc	s7,0x90
ffffffffc02061f2:	6d2b8b93          	addi	s7,s7,1746 # ffffffffc02968c0 <current>
ffffffffc02061f6:	00050b1b          	sext.w	s6,a0
ffffffffc02061fa:	fff50a9b          	addiw	s5,a0,-1
ffffffffc02061fe:	19f9                	addi	s3,s3,-2
ffffffffc0206200:	0905                	addi	s2,s2,1
ffffffffc0206202:	ccbd                	beqz	s1,ffffffffc0206280 <do_wait.part.0+0xb0>
ffffffffc0206204:	0359e863          	bltu	s3,s5,ffffffffc0206234 <do_wait.part.0+0x64>
ffffffffc0206208:	45a9                	li	a1,10
ffffffffc020620a:	855a                	mv	a0,s6
ffffffffc020620c:	2d8050ef          	jal	ra,ffffffffc020b4e4 <hash32>
ffffffffc0206210:	02051793          	slli	a5,a0,0x20
ffffffffc0206214:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0206218:	0008b797          	auipc	a5,0x8b
ffffffffc020621c:	5a878793          	addi	a5,a5,1448 # ffffffffc02917c0 <hash_list>
ffffffffc0206220:	953e                	add	a0,a0,a5
ffffffffc0206222:	842a                	mv	s0,a0
ffffffffc0206224:	a029                	j	ffffffffc020622e <do_wait.part.0+0x5e>
ffffffffc0206226:	f2c42783          	lw	a5,-212(s0)
ffffffffc020622a:	02978163          	beq	a5,s1,ffffffffc020624c <do_wait.part.0+0x7c>
ffffffffc020622e:	6400                	ld	s0,8(s0)
ffffffffc0206230:	fe851be3          	bne	a0,s0,ffffffffc0206226 <do_wait.part.0+0x56>
ffffffffc0206234:	5579                	li	a0,-2
ffffffffc0206236:	60a6                	ld	ra,72(sp)
ffffffffc0206238:	6406                	ld	s0,64(sp)
ffffffffc020623a:	74e2                	ld	s1,56(sp)
ffffffffc020623c:	7942                	ld	s2,48(sp)
ffffffffc020623e:	79a2                	ld	s3,40(sp)
ffffffffc0206240:	7a02                	ld	s4,32(sp)
ffffffffc0206242:	6ae2                	ld	s5,24(sp)
ffffffffc0206244:	6b42                	ld	s6,16(sp)
ffffffffc0206246:	6ba2                	ld	s7,8(sp)
ffffffffc0206248:	6161                	addi	sp,sp,80
ffffffffc020624a:	8082                	ret
ffffffffc020624c:	000bb683          	ld	a3,0(s7)
ffffffffc0206250:	f4843783          	ld	a5,-184(s0)
ffffffffc0206254:	fed790e3          	bne	a5,a3,ffffffffc0206234 <do_wait.part.0+0x64>
ffffffffc0206258:	f2842703          	lw	a4,-216(s0)
ffffffffc020625c:	478d                	li	a5,3
ffffffffc020625e:	0ef70b63          	beq	a4,a5,ffffffffc0206354 <do_wait.part.0+0x184>
ffffffffc0206262:	4785                	li	a5,1
ffffffffc0206264:	c29c                	sw	a5,0(a3)
ffffffffc0206266:	0f26a623          	sw	s2,236(a3)
ffffffffc020626a:	7b9000ef          	jal	ra,ffffffffc0207222 <schedule>
ffffffffc020626e:	000bb783          	ld	a5,0(s7)
ffffffffc0206272:	0b07a783          	lw	a5,176(a5)
ffffffffc0206276:	8b85                	andi	a5,a5,1
ffffffffc0206278:	d7c9                	beqz	a5,ffffffffc0206202 <do_wait.part.0+0x32>
ffffffffc020627a:	555d                	li	a0,-9
ffffffffc020627c:	df3ff0ef          	jal	ra,ffffffffc020606e <do_exit>
ffffffffc0206280:	000bb683          	ld	a3,0(s7)
ffffffffc0206284:	7ae0                	ld	s0,240(a3)
ffffffffc0206286:	d45d                	beqz	s0,ffffffffc0206234 <do_wait.part.0+0x64>
ffffffffc0206288:	470d                	li	a4,3
ffffffffc020628a:	a021                	j	ffffffffc0206292 <do_wait.part.0+0xc2>
ffffffffc020628c:	10043403          	ld	s0,256(s0)
ffffffffc0206290:	d869                	beqz	s0,ffffffffc0206262 <do_wait.part.0+0x92>
ffffffffc0206292:	401c                	lw	a5,0(s0)
ffffffffc0206294:	fee79ce3          	bne	a5,a4,ffffffffc020628c <do_wait.part.0+0xbc>
ffffffffc0206298:	00090797          	auipc	a5,0x90
ffffffffc020629c:	6307b783          	ld	a5,1584(a5) # ffffffffc02968c8 <idleproc>
ffffffffc02062a0:	0c878963          	beq	a5,s0,ffffffffc0206372 <do_wait.part.0+0x1a2>
ffffffffc02062a4:	00090797          	auipc	a5,0x90
ffffffffc02062a8:	62c7b783          	ld	a5,1580(a5) # ffffffffc02968d0 <initproc>
ffffffffc02062ac:	0cf40363          	beq	s0,a5,ffffffffc0206372 <do_wait.part.0+0x1a2>
ffffffffc02062b0:	000a0663          	beqz	s4,ffffffffc02062bc <do_wait.part.0+0xec>
ffffffffc02062b4:	0e842783          	lw	a5,232(s0)
ffffffffc02062b8:	00fa2023          	sw	a5,0(s4)
ffffffffc02062bc:	100027f3          	csrr	a5,sstatus
ffffffffc02062c0:	8b89                	andi	a5,a5,2
ffffffffc02062c2:	4581                	li	a1,0
ffffffffc02062c4:	e7c1                	bnez	a5,ffffffffc020634c <do_wait.part.0+0x17c>
ffffffffc02062c6:	6c70                	ld	a2,216(s0)
ffffffffc02062c8:	7074                	ld	a3,224(s0)
ffffffffc02062ca:	10043703          	ld	a4,256(s0)
ffffffffc02062ce:	7c7c                	ld	a5,248(s0)
ffffffffc02062d0:	e614                	sd	a3,8(a2)
ffffffffc02062d2:	e290                	sd	a2,0(a3)
ffffffffc02062d4:	6470                	ld	a2,200(s0)
ffffffffc02062d6:	6874                	ld	a3,208(s0)
ffffffffc02062d8:	e614                	sd	a3,8(a2)
ffffffffc02062da:	e290                	sd	a2,0(a3)
ffffffffc02062dc:	c319                	beqz	a4,ffffffffc02062e2 <do_wait.part.0+0x112>
ffffffffc02062de:	ff7c                	sd	a5,248(a4)
ffffffffc02062e0:	7c7c                	ld	a5,248(s0)
ffffffffc02062e2:	c3b5                	beqz	a5,ffffffffc0206346 <do_wait.part.0+0x176>
ffffffffc02062e4:	10e7b023          	sd	a4,256(a5)
ffffffffc02062e8:	00090717          	auipc	a4,0x90
ffffffffc02062ec:	5f070713          	addi	a4,a4,1520 # ffffffffc02968d8 <nr_process>
ffffffffc02062f0:	431c                	lw	a5,0(a4)
ffffffffc02062f2:	37fd                	addiw	a5,a5,-1
ffffffffc02062f4:	c31c                	sw	a5,0(a4)
ffffffffc02062f6:	e5a9                	bnez	a1,ffffffffc0206340 <do_wait.part.0+0x170>
ffffffffc02062f8:	6814                	ld	a3,16(s0)
ffffffffc02062fa:	c02007b7          	lui	a5,0xc0200
ffffffffc02062fe:	04f6ee63          	bltu	a3,a5,ffffffffc020635a <do_wait.part.0+0x18a>
ffffffffc0206302:	00090797          	auipc	a5,0x90
ffffffffc0206306:	5ae7b783          	ld	a5,1454(a5) # ffffffffc02968b0 <va_pa_offset>
ffffffffc020630a:	8e9d                	sub	a3,a3,a5
ffffffffc020630c:	82b1                	srli	a3,a3,0xc
ffffffffc020630e:	00090797          	auipc	a5,0x90
ffffffffc0206312:	58a7b783          	ld	a5,1418(a5) # ffffffffc0296898 <npage>
ffffffffc0206316:	06f6fa63          	bgeu	a3,a5,ffffffffc020638a <do_wait.part.0+0x1ba>
ffffffffc020631a:	00009517          	auipc	a0,0x9
ffffffffc020631e:	48e53503          	ld	a0,1166(a0) # ffffffffc020f7a8 <nbase>
ffffffffc0206322:	8e89                	sub	a3,a3,a0
ffffffffc0206324:	069a                	slli	a3,a3,0x6
ffffffffc0206326:	00090517          	auipc	a0,0x90
ffffffffc020632a:	57a53503          	ld	a0,1402(a0) # ffffffffc02968a0 <pages>
ffffffffc020632e:	9536                	add	a0,a0,a3
ffffffffc0206330:	4589                	li	a1,2
ffffffffc0206332:	ffbfa0ef          	jal	ra,ffffffffc020132c <free_pages>
ffffffffc0206336:	8522                	mv	a0,s0
ffffffffc0206338:	d3efd0ef          	jal	ra,ffffffffc0203876 <kfree>
ffffffffc020633c:	4501                	li	a0,0
ffffffffc020633e:	bde5                	j	ffffffffc0206236 <do_wait.part.0+0x66>
ffffffffc0206340:	a5ffa0ef          	jal	ra,ffffffffc0200d9e <intr_enable>
ffffffffc0206344:	bf55                	j	ffffffffc02062f8 <do_wait.part.0+0x128>
ffffffffc0206346:	701c                	ld	a5,32(s0)
ffffffffc0206348:	fbf8                	sd	a4,240(a5)
ffffffffc020634a:	bf79                	j	ffffffffc02062e8 <do_wait.part.0+0x118>
ffffffffc020634c:	a59fa0ef          	jal	ra,ffffffffc0200da4 <intr_disable>
ffffffffc0206350:	4585                	li	a1,1
ffffffffc0206352:	bf95                	j	ffffffffc02062c6 <do_wait.part.0+0xf6>
ffffffffc0206354:	f2840413          	addi	s0,s0,-216
ffffffffc0206358:	b781                	j	ffffffffc0206298 <do_wait.part.0+0xc8>
ffffffffc020635a:	00006617          	auipc	a2,0x6
ffffffffc020635e:	ed660613          	addi	a2,a2,-298 # ffffffffc020c230 <commands+0xa88>
ffffffffc0206362:	07700593          	li	a1,119
ffffffffc0206366:	00006517          	auipc	a0,0x6
ffffffffc020636a:	d7250513          	addi	a0,a0,-654 # ffffffffc020c0d8 <commands+0x930>
ffffffffc020636e:	ec1f90ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0206372:	00007617          	auipc	a2,0x7
ffffffffc0206376:	19660613          	addi	a2,a2,406 # ffffffffc020d508 <CSWTCH.79+0x158>
ffffffffc020637a:	43a00593          	li	a1,1082
ffffffffc020637e:	00007517          	auipc	a0,0x7
ffffffffc0206382:	11a50513          	addi	a0,a0,282 # ffffffffc020d498 <CSWTCH.79+0xe8>
ffffffffc0206386:	ea9f90ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020638a:	00006617          	auipc	a2,0x6
ffffffffc020638e:	d2e60613          	addi	a2,a2,-722 # ffffffffc020c0b8 <commands+0x910>
ffffffffc0206392:	06900593          	li	a1,105
ffffffffc0206396:	00006517          	auipc	a0,0x6
ffffffffc020639a:	d4250513          	addi	a0,a0,-702 # ffffffffc020c0d8 <commands+0x930>
ffffffffc020639e:	e91f90ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02063a2 <init_main>:
ffffffffc02063a2:	1141                	addi	sp,sp,-16
ffffffffc02063a4:	00007517          	auipc	a0,0x7
ffffffffc02063a8:	18450513          	addi	a0,a0,388 # ffffffffc020d528 <CSWTCH.79+0x178>
ffffffffc02063ac:	e406                	sd	ra,8(sp)
ffffffffc02063ae:	046020ef          	jal	ra,ffffffffc02083f4 <vfs_set_bootfs>
ffffffffc02063b2:	e179                	bnez	a0,ffffffffc0206478 <init_main+0xd6>
ffffffffc02063b4:	fb9fa0ef          	jal	ra,ffffffffc020136c <nr_free_pages>
ffffffffc02063b8:	c0afd0ef          	jal	ra,ffffffffc02037c2 <kallocated>
ffffffffc02063bc:	4601                	li	a2,0
ffffffffc02063be:	4581                	li	a1,0
ffffffffc02063c0:	00001517          	auipc	a0,0x1
ffffffffc02063c4:	95c50513          	addi	a0,a0,-1700 # ffffffffc0206d1c <user_main>
ffffffffc02063c8:	c57ff0ef          	jal	ra,ffffffffc020601e <kernel_thread>
ffffffffc02063cc:	00a04563          	bgtz	a0,ffffffffc02063d6 <init_main+0x34>
ffffffffc02063d0:	a841                	j	ffffffffc0206460 <init_main+0xbe>
ffffffffc02063d2:	651000ef          	jal	ra,ffffffffc0207222 <schedule>
ffffffffc02063d6:	4581                	li	a1,0
ffffffffc02063d8:	4501                	li	a0,0
ffffffffc02063da:	df7ff0ef          	jal	ra,ffffffffc02061d0 <do_wait.part.0>
ffffffffc02063de:	d975                	beqz	a0,ffffffffc02063d2 <init_main+0x30>
ffffffffc02063e0:	bfaff0ef          	jal	ra,ffffffffc02057da <fs_cleanup>
ffffffffc02063e4:	00007517          	auipc	a0,0x7
ffffffffc02063e8:	18c50513          	addi	a0,a0,396 # ffffffffc020d570 <CSWTCH.79+0x1c0>
ffffffffc02063ec:	d3ff90ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02063f0:	00090797          	auipc	a5,0x90
ffffffffc02063f4:	4e07b783          	ld	a5,1248(a5) # ffffffffc02968d0 <initproc>
ffffffffc02063f8:	7bf8                	ld	a4,240(a5)
ffffffffc02063fa:	e339                	bnez	a4,ffffffffc0206440 <init_main+0x9e>
ffffffffc02063fc:	7ff8                	ld	a4,248(a5)
ffffffffc02063fe:	e329                	bnez	a4,ffffffffc0206440 <init_main+0x9e>
ffffffffc0206400:	1007b703          	ld	a4,256(a5)
ffffffffc0206404:	ef15                	bnez	a4,ffffffffc0206440 <init_main+0x9e>
ffffffffc0206406:	00090697          	auipc	a3,0x90
ffffffffc020640a:	4d26a683          	lw	a3,1234(a3) # ffffffffc02968d8 <nr_process>
ffffffffc020640e:	4709                	li	a4,2
ffffffffc0206410:	0ce69163          	bne	a3,a4,ffffffffc02064d2 <init_main+0x130>
ffffffffc0206414:	0008f717          	auipc	a4,0x8f
ffffffffc0206418:	3ac70713          	addi	a4,a4,940 # ffffffffc02957c0 <proc_list>
ffffffffc020641c:	6714                	ld	a3,8(a4)
ffffffffc020641e:	0c878793          	addi	a5,a5,200
ffffffffc0206422:	08d79863          	bne	a5,a3,ffffffffc02064b2 <init_main+0x110>
ffffffffc0206426:	6318                	ld	a4,0(a4)
ffffffffc0206428:	06e79563          	bne	a5,a4,ffffffffc0206492 <init_main+0xf0>
ffffffffc020642c:	00007517          	auipc	a0,0x7
ffffffffc0206430:	22c50513          	addi	a0,a0,556 # ffffffffc020d658 <CSWTCH.79+0x2a8>
ffffffffc0206434:	cf7f90ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0206438:	60a2                	ld	ra,8(sp)
ffffffffc020643a:	4501                	li	a0,0
ffffffffc020643c:	0141                	addi	sp,sp,16
ffffffffc020643e:	8082                	ret
ffffffffc0206440:	00007697          	auipc	a3,0x7
ffffffffc0206444:	15868693          	addi	a3,a3,344 # ffffffffc020d598 <CSWTCH.79+0x1e8>
ffffffffc0206448:	00005617          	auipc	a2,0x5
ffffffffc020644c:	3c060613          	addi	a2,a2,960 # ffffffffc020b808 <commands+0x60>
ffffffffc0206450:	4b000593          	li	a1,1200
ffffffffc0206454:	00007517          	auipc	a0,0x7
ffffffffc0206458:	04450513          	addi	a0,a0,68 # ffffffffc020d498 <CSWTCH.79+0xe8>
ffffffffc020645c:	dd3f90ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0206460:	00007617          	auipc	a2,0x7
ffffffffc0206464:	0f060613          	addi	a2,a2,240 # ffffffffc020d550 <CSWTCH.79+0x1a0>
ffffffffc0206468:	4a300593          	li	a1,1187
ffffffffc020646c:	00007517          	auipc	a0,0x7
ffffffffc0206470:	02c50513          	addi	a0,a0,44 # ffffffffc020d498 <CSWTCH.79+0xe8>
ffffffffc0206474:	dbbf90ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0206478:	86aa                	mv	a3,a0
ffffffffc020647a:	00007617          	auipc	a2,0x7
ffffffffc020647e:	0b660613          	addi	a2,a2,182 # ffffffffc020d530 <CSWTCH.79+0x180>
ffffffffc0206482:	49b00593          	li	a1,1179
ffffffffc0206486:	00007517          	auipc	a0,0x7
ffffffffc020648a:	01250513          	addi	a0,a0,18 # ffffffffc020d498 <CSWTCH.79+0xe8>
ffffffffc020648e:	da1f90ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0206492:	00007697          	auipc	a3,0x7
ffffffffc0206496:	19668693          	addi	a3,a3,406 # ffffffffc020d628 <CSWTCH.79+0x278>
ffffffffc020649a:	00005617          	auipc	a2,0x5
ffffffffc020649e:	36e60613          	addi	a2,a2,878 # ffffffffc020b808 <commands+0x60>
ffffffffc02064a2:	4b300593          	li	a1,1203
ffffffffc02064a6:	00007517          	auipc	a0,0x7
ffffffffc02064aa:	ff250513          	addi	a0,a0,-14 # ffffffffc020d498 <CSWTCH.79+0xe8>
ffffffffc02064ae:	d81f90ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02064b2:	00007697          	auipc	a3,0x7
ffffffffc02064b6:	14668693          	addi	a3,a3,326 # ffffffffc020d5f8 <CSWTCH.79+0x248>
ffffffffc02064ba:	00005617          	auipc	a2,0x5
ffffffffc02064be:	34e60613          	addi	a2,a2,846 # ffffffffc020b808 <commands+0x60>
ffffffffc02064c2:	4b200593          	li	a1,1202
ffffffffc02064c6:	00007517          	auipc	a0,0x7
ffffffffc02064ca:	fd250513          	addi	a0,a0,-46 # ffffffffc020d498 <CSWTCH.79+0xe8>
ffffffffc02064ce:	d61f90ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02064d2:	00007697          	auipc	a3,0x7
ffffffffc02064d6:	11668693          	addi	a3,a3,278 # ffffffffc020d5e8 <CSWTCH.79+0x238>
ffffffffc02064da:	00005617          	auipc	a2,0x5
ffffffffc02064de:	32e60613          	addi	a2,a2,814 # ffffffffc020b808 <commands+0x60>
ffffffffc02064e2:	4b100593          	li	a1,1201
ffffffffc02064e6:	00007517          	auipc	a0,0x7
ffffffffc02064ea:	fb250513          	addi	a0,a0,-78 # ffffffffc020d498 <CSWTCH.79+0xe8>
ffffffffc02064ee:	d41f90ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02064f2 <do_execve>:
ffffffffc02064f2:	d9010113          	addi	sp,sp,-624
ffffffffc02064f6:	25413023          	sd	s4,576(sp)
ffffffffc02064fa:	00090a17          	auipc	s4,0x90
ffffffffc02064fe:	3c6a0a13          	addi	s4,s4,966 # ffffffffc02968c0 <current>
ffffffffc0206502:	000a3683          	ld	a3,0(s4)
ffffffffc0206506:	fff5871b          	addiw	a4,a1,-1
ffffffffc020650a:	23713423          	sd	s7,552(sp)
ffffffffc020650e:	26113423          	sd	ra,616(sp)
ffffffffc0206512:	26813023          	sd	s0,608(sp)
ffffffffc0206516:	24913c23          	sd	s1,600(sp)
ffffffffc020651a:	25213823          	sd	s2,592(sp)
ffffffffc020651e:	25313423          	sd	s3,584(sp)
ffffffffc0206522:	23513c23          	sd	s5,568(sp)
ffffffffc0206526:	23613823          	sd	s6,560(sp)
ffffffffc020652a:	23813023          	sd	s8,544(sp)
ffffffffc020652e:	21913c23          	sd	s9,536(sp)
ffffffffc0206532:	21a13823          	sd	s10,528(sp)
ffffffffc0206536:	21b13423          	sd	s11,520(sp)
ffffffffc020653a:	d03a                	sw	a4,32(sp)
ffffffffc020653c:	47fd                	li	a5,31
ffffffffc020653e:	0286bb83          	ld	s7,40(a3)
ffffffffc0206542:	5ee7e863          	bltu	a5,a4,ffffffffc0206b32 <do_execve+0x640>
ffffffffc0206546:	842e                	mv	s0,a1
ffffffffc0206548:	84aa                	mv	s1,a0
ffffffffc020654a:	8c32                	mv	s8,a2
ffffffffc020654c:	4581                	li	a1,0
ffffffffc020654e:	4641                	li	a2,16
ffffffffc0206550:	18a8                	addi	a0,sp,120
ffffffffc0206552:	2ad040ef          	jal	ra,ffffffffc020affe <memset>
ffffffffc0206556:	000b8c63          	beqz	s7,ffffffffc020656e <do_execve+0x7c>
ffffffffc020655a:	038b8513          	addi	a0,s7,56
ffffffffc020655e:	9f0fe0ef          	jal	ra,ffffffffc020474e <down>
ffffffffc0206562:	000a3783          	ld	a5,0(s4)
ffffffffc0206566:	c781                	beqz	a5,ffffffffc020656e <do_execve+0x7c>
ffffffffc0206568:	43dc                	lw	a5,4(a5)
ffffffffc020656a:	04fba823          	sw	a5,80(s7)
ffffffffc020656e:	24048263          	beqz	s1,ffffffffc02067b2 <do_execve+0x2c0>
ffffffffc0206572:	46c1                	li	a3,16
ffffffffc0206574:	8626                	mv	a2,s1
ffffffffc0206576:	18ac                	addi	a1,sp,120
ffffffffc0206578:	855e                	mv	a0,s7
ffffffffc020657a:	f95fc0ef          	jal	ra,ffffffffc020350e <copy_string>
ffffffffc020657e:	6a050f63          	beqz	a0,ffffffffc0206c3c <do_execve+0x74a>
ffffffffc0206582:	00341d93          	slli	s11,s0,0x3
ffffffffc0206586:	4681                	li	a3,0
ffffffffc0206588:	866e                	mv	a2,s11
ffffffffc020658a:	85e2                	mv	a1,s8
ffffffffc020658c:	855e                	mv	a0,s7
ffffffffc020658e:	e87fc0ef          	jal	ra,ffffffffc0203414 <user_mem_check>
ffffffffc0206592:	89e2                	mv	s3,s8
ffffffffc0206594:	6a050063          	beqz	a0,ffffffffc0206c34 <do_execve+0x742>
ffffffffc0206598:	10010b13          	addi	s6,sp,256
ffffffffc020659c:	8ada                	mv	s5,s6
ffffffffc020659e:	4901                	li	s2,0
ffffffffc02065a0:	6505                	lui	a0,0x1
ffffffffc02065a2:	a24fd0ef          	jal	ra,ffffffffc02037c6 <kmalloc>
ffffffffc02065a6:	84aa                	mv	s1,a0
ffffffffc02065a8:	18050063          	beqz	a0,ffffffffc0206728 <do_execve+0x236>
ffffffffc02065ac:	0009b603          	ld	a2,0(s3) # 2000 <_binary_bin_swap_img_size-0x5d00>
ffffffffc02065b0:	85aa                	mv	a1,a0
ffffffffc02065b2:	6685                	lui	a3,0x1
ffffffffc02065b4:	855e                	mv	a0,s7
ffffffffc02065b6:	f59fc0ef          	jal	ra,ffffffffc020350e <copy_string>
ffffffffc02065ba:	1e050763          	beqz	a0,ffffffffc02067a8 <do_execve+0x2b6>
ffffffffc02065be:	009ab023          	sd	s1,0(s5) # 1000 <_binary_bin_swap_img_size-0x6d00>
ffffffffc02065c2:	2905                	addiw	s2,s2,1
ffffffffc02065c4:	0aa1                	addi	s5,s5,8
ffffffffc02065c6:	09a1                	addi	s3,s3,8
ffffffffc02065c8:	fd241ce3          	bne	s0,s2,ffffffffc02065a0 <do_execve+0xae>
ffffffffc02065cc:	000c3483          	ld	s1,0(s8)
ffffffffc02065d0:	100b8963          	beqz	s7,ffffffffc02066e2 <do_execve+0x1f0>
ffffffffc02065d4:	038b8513          	addi	a0,s7,56
ffffffffc02065d8:	972fe0ef          	jal	ra,ffffffffc020474a <up>
ffffffffc02065dc:	000a3783          	ld	a5,0(s4)
ffffffffc02065e0:	040ba823          	sw	zero,80(s7)
ffffffffc02065e4:	1487b503          	ld	a0,328(a5)
ffffffffc02065e8:	aceff0ef          	jal	ra,ffffffffc02058b6 <files_closeall>
ffffffffc02065ec:	8526                	mv	a0,s1
ffffffffc02065ee:	4581                	li	a1,0
ffffffffc02065f0:	a3efe0ef          	jal	ra,ffffffffc020482e <sysfile_open>
ffffffffc02065f4:	84aa                	mv	s1,a0
ffffffffc02065f6:	0a054f63          	bltz	a0,ffffffffc02066b4 <do_execve+0x1c2>
ffffffffc02065fa:	00090797          	auipc	a5,0x90
ffffffffc02065fe:	28e7b783          	ld	a5,654(a5) # ffffffffc0296888 <boot_pgdir_pa>
ffffffffc0206602:	577d                	li	a4,-1
ffffffffc0206604:	177e                	slli	a4,a4,0x3f
ffffffffc0206606:	83b1                	srli	a5,a5,0xc
ffffffffc0206608:	8fd9                	or	a5,a5,a4
ffffffffc020660a:	18079073          	csrw	satp,a5
ffffffffc020660e:	030ba783          	lw	a5,48(s7)
ffffffffc0206612:	fff7871b          	addiw	a4,a5,-1
ffffffffc0206616:	02eba823          	sw	a4,48(s7)
ffffffffc020661a:	1a070863          	beqz	a4,ffffffffc02067ca <do_execve+0x2d8>
ffffffffc020661e:	000a3783          	ld	a5,0(s4)
ffffffffc0206622:	0207b423          	sd	zero,40(a5)
ffffffffc0206626:	f64fc0ef          	jal	ra,ffffffffc0202d8a <mm_create>
ffffffffc020662a:	892a                	mv	s2,a0
ffffffffc020662c:	0e050c63          	beqz	a0,ffffffffc0206724 <do_execve+0x232>
ffffffffc0206630:	4505                	li	a0,1
ffffffffc0206632:	cbdfa0ef          	jal	ra,ffffffffc02012ee <alloc_pages>
ffffffffc0206636:	0e050463          	beqz	a0,ffffffffc020671e <do_execve+0x22c>
ffffffffc020663a:	00090c17          	auipc	s8,0x90
ffffffffc020663e:	266c0c13          	addi	s8,s8,614 # ffffffffc02968a0 <pages>
ffffffffc0206642:	000c3683          	ld	a3,0(s8)
ffffffffc0206646:	00009717          	auipc	a4,0x9
ffffffffc020664a:	16273703          	ld	a4,354(a4) # ffffffffc020f7a8 <nbase>
ffffffffc020664e:	00090c97          	auipc	s9,0x90
ffffffffc0206652:	24ac8c93          	addi	s9,s9,586 # ffffffffc0296898 <npage>
ffffffffc0206656:	40d506b3          	sub	a3,a0,a3
ffffffffc020665a:	8699                	srai	a3,a3,0x6
ffffffffc020665c:	96ba                	add	a3,a3,a4
ffffffffc020665e:	f43a                	sd	a4,40(sp)
ffffffffc0206660:	000cb783          	ld	a5,0(s9)
ffffffffc0206664:	577d                	li	a4,-1
ffffffffc0206666:	8331                	srli	a4,a4,0xc
ffffffffc0206668:	ec3a                	sd	a4,24(sp)
ffffffffc020666a:	8f75                	and	a4,a4,a3
ffffffffc020666c:	06b2                	slli	a3,a3,0xc
ffffffffc020666e:	5ef77d63          	bgeu	a4,a5,ffffffffc0206c68 <do_execve+0x776>
ffffffffc0206672:	00090797          	auipc	a5,0x90
ffffffffc0206676:	23e78793          	addi	a5,a5,574 # ffffffffc02968b0 <va_pa_offset>
ffffffffc020667a:	0007b983          	ld	s3,0(a5)
ffffffffc020667e:	6605                	lui	a2,0x1
ffffffffc0206680:	00090597          	auipc	a1,0x90
ffffffffc0206684:	2105b583          	ld	a1,528(a1) # ffffffffc0296890 <boot_pgdir_va>
ffffffffc0206688:	99b6                	add	s3,s3,a3
ffffffffc020668a:	854e                	mv	a0,s3
ffffffffc020668c:	1c5040ef          	jal	ra,ffffffffc020b050 <memcpy>
ffffffffc0206690:	4601                	li	a2,0
ffffffffc0206692:	01393c23          	sd	s3,24(s2) # ffffffff80000018 <_binary_bin_sfs_img_size+0xffffffff7ff8ad18>
ffffffffc0206696:	4581                	li	a1,0
ffffffffc0206698:	8526                	mv	a0,s1
ffffffffc020669a:	bfafe0ef          	jal	ra,ffffffffc0204a94 <sysfile_seek>
ffffffffc020669e:	8aaa                	mv	s5,a0
ffffffffc02066a0:	14050063          	beqz	a0,ffffffffc02067e0 <do_execve+0x2ee>
ffffffffc02066a4:	01893503          	ld	a0,24(s2)
ffffffffc02066a8:	84d6                	mv	s1,s5
ffffffffc02066aa:	c4aff0ef          	jal	ra,ffffffffc0205af4 <put_pgdir.isra.0>
ffffffffc02066ae:	854a                	mv	a0,s2
ffffffffc02066b0:	829fc0ef          	jal	ra,ffffffffc0202ed8 <mm_destroy>
ffffffffc02066b4:	7702                	ld	a4,32(sp)
ffffffffc02066b6:	fff40793          	addi	a5,s0,-1
ffffffffc02066ba:	ff0b0413          	addi	s0,s6,-16
ffffffffc02066be:	02071693          	slli	a3,a4,0x20
ffffffffc02066c2:	078e                	slli	a5,a5,0x3
ffffffffc02066c4:	946e                	add	s0,s0,s11
ffffffffc02066c6:	01d6d713          	srli	a4,a3,0x1d
ffffffffc02066ca:	9b3e                	add	s6,s6,a5
ffffffffc02066cc:	8c19                	sub	s0,s0,a4
ffffffffc02066ce:	000b3503          	ld	a0,0(s6)
ffffffffc02066d2:	1b61                	addi	s6,s6,-8
ffffffffc02066d4:	9a2fd0ef          	jal	ra,ffffffffc0203876 <kfree>
ffffffffc02066d8:	ff641be3          	bne	s0,s6,ffffffffc02066ce <do_execve+0x1dc>
ffffffffc02066dc:	8526                	mv	a0,s1
ffffffffc02066de:	991ff0ef          	jal	ra,ffffffffc020606e <do_exit>
ffffffffc02066e2:	000a3783          	ld	a5,0(s4)
ffffffffc02066e6:	1487b503          	ld	a0,328(a5)
ffffffffc02066ea:	9ccff0ef          	jal	ra,ffffffffc02058b6 <files_closeall>
ffffffffc02066ee:	8526                	mv	a0,s1
ffffffffc02066f0:	4581                	li	a1,0
ffffffffc02066f2:	93cfe0ef          	jal	ra,ffffffffc020482e <sysfile_open>
ffffffffc02066f6:	84aa                	mv	s1,a0
ffffffffc02066f8:	fa054ee3          	bltz	a0,ffffffffc02066b4 <do_execve+0x1c2>
ffffffffc02066fc:	000a3783          	ld	a5,0(s4)
ffffffffc0206700:	779c                	ld	a5,40(a5)
ffffffffc0206702:	f20782e3          	beqz	a5,ffffffffc0206626 <do_execve+0x134>
ffffffffc0206706:	00007617          	auipc	a2,0x7
ffffffffc020670a:	f8260613          	addi	a2,a2,-126 # ffffffffc020d688 <CSWTCH.79+0x2d8>
ffffffffc020670e:	2ce00593          	li	a1,718
ffffffffc0206712:	00007517          	auipc	a0,0x7
ffffffffc0206716:	d8650513          	addi	a0,a0,-634 # ffffffffc020d498 <CSWTCH.79+0xe8>
ffffffffc020671a:	b15f90ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020671e:	854a                	mv	a0,s2
ffffffffc0206720:	fb8fc0ef          	jal	ra,ffffffffc0202ed8 <mm_destroy>
ffffffffc0206724:	54f1                	li	s1,-4
ffffffffc0206726:	b779                	j	ffffffffc02066b4 <do_execve+0x1c2>
ffffffffc0206728:	5af1                	li	s5,-4
ffffffffc020672a:	02090963          	beqz	s2,ffffffffc020675c <do_execve+0x26a>
ffffffffc020672e:	ff0b0693          	addi	a3,s6,-16
ffffffffc0206732:	fff90793          	addi	a5,s2,-1
ffffffffc0206736:	00391713          	slli	a4,s2,0x3
ffffffffc020673a:	397d                	addiw	s2,s2,-1
ffffffffc020673c:	9736                	add	a4,a4,a3
ffffffffc020673e:	02091693          	slli	a3,s2,0x20
ffffffffc0206742:	078e                	slli	a5,a5,0x3
ffffffffc0206744:	01d6d913          	srli	s2,a3,0x1d
ffffffffc0206748:	9b3e                	add	s6,s6,a5
ffffffffc020674a:	41270933          	sub	s2,a4,s2
ffffffffc020674e:	000b3503          	ld	a0,0(s6)
ffffffffc0206752:	1b61                	addi	s6,s6,-8
ffffffffc0206754:	922fd0ef          	jal	ra,ffffffffc0203876 <kfree>
ffffffffc0206758:	ff691be3          	bne	s2,s6,ffffffffc020674e <do_execve+0x25c>
ffffffffc020675c:	000b8863          	beqz	s7,ffffffffc020676c <do_execve+0x27a>
ffffffffc0206760:	038b8513          	addi	a0,s7,56
ffffffffc0206764:	fe7fd0ef          	jal	ra,ffffffffc020474a <up>
ffffffffc0206768:	040ba823          	sw	zero,80(s7)
ffffffffc020676c:	26813083          	ld	ra,616(sp)
ffffffffc0206770:	26013403          	ld	s0,608(sp)
ffffffffc0206774:	25813483          	ld	s1,600(sp)
ffffffffc0206778:	25013903          	ld	s2,592(sp)
ffffffffc020677c:	24813983          	ld	s3,584(sp)
ffffffffc0206780:	24013a03          	ld	s4,576(sp)
ffffffffc0206784:	23013b03          	ld	s6,560(sp)
ffffffffc0206788:	22813b83          	ld	s7,552(sp)
ffffffffc020678c:	22013c03          	ld	s8,544(sp)
ffffffffc0206790:	21813c83          	ld	s9,536(sp)
ffffffffc0206794:	21013d03          	ld	s10,528(sp)
ffffffffc0206798:	20813d83          	ld	s11,520(sp)
ffffffffc020679c:	8556                	mv	a0,s5
ffffffffc020679e:	23813a83          	ld	s5,568(sp)
ffffffffc02067a2:	27010113          	addi	sp,sp,624
ffffffffc02067a6:	8082                	ret
ffffffffc02067a8:	8526                	mv	a0,s1
ffffffffc02067aa:	8ccfd0ef          	jal	ra,ffffffffc0203876 <kfree>
ffffffffc02067ae:	5af5                	li	s5,-3
ffffffffc02067b0:	bfad                	j	ffffffffc020672a <do_execve+0x238>
ffffffffc02067b2:	000a3783          	ld	a5,0(s4)
ffffffffc02067b6:	00007617          	auipc	a2,0x7
ffffffffc02067ba:	ec260613          	addi	a2,a2,-318 # ffffffffc020d678 <CSWTCH.79+0x2c8>
ffffffffc02067be:	45c1                	li	a1,16
ffffffffc02067c0:	43d4                	lw	a3,4(a5)
ffffffffc02067c2:	18a8                	addi	a0,sp,120
ffffffffc02067c4:	4d3040ef          	jal	ra,ffffffffc020b496 <snprintf>
ffffffffc02067c8:	bb6d                	j	ffffffffc0206582 <do_execve+0x90>
ffffffffc02067ca:	855e                	mv	a0,s7
ffffffffc02067cc:	8a9fc0ef          	jal	ra,ffffffffc0203074 <exit_mmap>
ffffffffc02067d0:	018bb503          	ld	a0,24(s7)
ffffffffc02067d4:	b20ff0ef          	jal	ra,ffffffffc0205af4 <put_pgdir.isra.0>
ffffffffc02067d8:	855e                	mv	a0,s7
ffffffffc02067da:	efefc0ef          	jal	ra,ffffffffc0202ed8 <mm_destroy>
ffffffffc02067de:	b581                	j	ffffffffc020661e <do_execve+0x12c>
ffffffffc02067e0:	04000613          	li	a2,64
ffffffffc02067e4:	018c                	addi	a1,sp,192
ffffffffc02067e6:	8526                	mv	a0,s1
ffffffffc02067e8:	87efe0ef          	jal	ra,ffffffffc0204866 <sysfile_read>
ffffffffc02067ec:	04000793          	li	a5,64
ffffffffc02067f0:	00f50863          	beq	a0,a5,ffffffffc0206800 <do_execve+0x30e>
ffffffffc02067f4:	00050a9b          	sext.w	s5,a0
ffffffffc02067f8:	ea0546e3          	bltz	a0,ffffffffc02066a4 <do_execve+0x1b2>
ffffffffc02067fc:	5afd                	li	s5,-1
ffffffffc02067fe:	b55d                	j	ffffffffc02066a4 <do_execve+0x1b2>
ffffffffc0206800:	470e                	lw	a4,192(sp)
ffffffffc0206802:	464c47b7          	lui	a5,0x464c4
ffffffffc0206806:	57f78793          	addi	a5,a5,1407 # 464c457f <_binary_bin_sfs_img_size+0x4644f27f>
ffffffffc020680a:	30f71463          	bne	a4,a5,ffffffffc0206b12 <do_execve+0x620>
ffffffffc020680e:	0f815783          	lhu	a5,248(sp)
ffffffffc0206812:	ec82                	sd	zero,88(sp)
ffffffffc0206814:	e882                	sd	zero,80(sp)
ffffffffc0206816:	18078163          	beqz	a5,ffffffffc0206998 <do_execve+0x4a6>
ffffffffc020681a:	e0ee                	sd	s11,64(sp)
ffffffffc020681c:	e44a                	sd	s2,8(sp)
ffffffffc020681e:	f4d6                	sd	s5,104(sp)
ffffffffc0206820:	e4a2                	sd	s0,72(sp)
ffffffffc0206822:	758e                	ld	a1,224(sp)
ffffffffc0206824:	67c6                	ld	a5,80(sp)
ffffffffc0206826:	4601                	li	a2,0
ffffffffc0206828:	8526                	mv	a0,s1
ffffffffc020682a:	95be                	add	a1,a1,a5
ffffffffc020682c:	a68fe0ef          	jal	ra,ffffffffc0204a94 <sysfile_seek>
ffffffffc0206830:	e82a                	sd	a0,16(sp)
ffffffffc0206832:	12051c63          	bnez	a0,ffffffffc020696a <do_execve+0x478>
ffffffffc0206836:	03800613          	li	a2,56
ffffffffc020683a:	012c                	addi	a1,sp,136
ffffffffc020683c:	8526                	mv	a0,s1
ffffffffc020683e:	828fe0ef          	jal	ra,ffffffffc0204866 <sysfile_read>
ffffffffc0206842:	03800793          	li	a5,56
ffffffffc0206846:	12f50663          	beq	a0,a5,ffffffffc0206972 <do_execve+0x480>
ffffffffc020684a:	6d86                	ld	s11,64(sp)
ffffffffc020684c:	6922                	ld	s2,8(sp)
ffffffffc020684e:	6426                	ld	s0,72(sp)
ffffffffc0206850:	89aa                	mv	s3,a0
ffffffffc0206852:	00054363          	bltz	a0,ffffffffc0206858 <do_execve+0x366>
ffffffffc0206856:	59fd                	li	s3,-1
ffffffffc0206858:	0009879b          	sext.w	a5,s3
ffffffffc020685c:	e83e                	sd	a5,16(sp)
ffffffffc020685e:	854a                	mv	a0,s2
ffffffffc0206860:	815fc0ef          	jal	ra,ffffffffc0203074 <exit_mmap>
ffffffffc0206864:	01893503          	ld	a0,24(s2)
ffffffffc0206868:	64c2                	ld	s1,16(sp)
ffffffffc020686a:	a8aff0ef          	jal	ra,ffffffffc0205af4 <put_pgdir.isra.0>
ffffffffc020686e:	854a                	mv	a0,s2
ffffffffc0206870:	e68fc0ef          	jal	ra,ffffffffc0202ed8 <mm_destroy>
ffffffffc0206874:	b581                	j	ffffffffc02066b4 <do_execve+0x1c2>
ffffffffc0206876:	764a                	ld	a2,176(sp)
ffffffffc0206878:	77aa                	ld	a5,168(sp)
ffffffffc020687a:	3ef66063          	bltu	a2,a5,ffffffffc0206c5a <do_execve+0x768>
ffffffffc020687e:	47ba                	lw	a5,140(sp)
ffffffffc0206880:	0017f693          	andi	a3,a5,1
ffffffffc0206884:	c291                	beqz	a3,ffffffffc0206888 <do_execve+0x396>
ffffffffc0206886:	4691                	li	a3,4
ffffffffc0206888:	0027f713          	andi	a4,a5,2
ffffffffc020688c:	8b91                	andi	a5,a5,4
ffffffffc020688e:	28071b63          	bnez	a4,ffffffffc0206b24 <do_execve+0x632>
ffffffffc0206892:	4745                	li	a4,17
ffffffffc0206894:	f0ba                	sd	a4,96(sp)
ffffffffc0206896:	c789                	beqz	a5,ffffffffc02068a0 <do_execve+0x3ae>
ffffffffc0206898:	47cd                	li	a5,19
ffffffffc020689a:	0016e693          	ori	a3,a3,1
ffffffffc020689e:	f0be                	sd	a5,96(sp)
ffffffffc02068a0:	0026f793          	andi	a5,a3,2
ffffffffc02068a4:	28079463          	bnez	a5,ffffffffc0206b2c <do_execve+0x63a>
ffffffffc02068a8:	0046f793          	andi	a5,a3,4
ffffffffc02068ac:	c789                	beqz	a5,ffffffffc02068b6 <do_execve+0x3c4>
ffffffffc02068ae:	7786                	ld	a5,96(sp)
ffffffffc02068b0:	0087e793          	ori	a5,a5,8
ffffffffc02068b4:	f0be                	sd	a5,96(sp)
ffffffffc02068b6:	65ea                	ld	a1,152(sp)
ffffffffc02068b8:	6522                	ld	a0,8(sp)
ffffffffc02068ba:	4701                	li	a4,0
ffffffffc02068bc:	e6efc0ef          	jal	ra,ffffffffc0202f2a <mm_map>
ffffffffc02068c0:	e82a                	sd	a0,16(sp)
ffffffffc02068c2:	e545                	bnez	a0,ffffffffc020696a <do_execve+0x478>
ffffffffc02068c4:	6dea                	ld	s11,152(sp)
ffffffffc02068c6:	7d2a                	ld	s10,168(sp)
ffffffffc02068c8:	77fd                	lui	a5,0xfffff
ffffffffc02068ca:	00fdfab3          	and	s5,s11,a5
ffffffffc02068ce:	9d6e                	add	s10,s10,s11
ffffffffc02068d0:	39adf063          	bgeu	s11,s10,ffffffffc0206c50 <do_execve+0x75e>
ffffffffc02068d4:	57f1                	li	a5,-4
ffffffffc02068d6:	7986                	ld	s3,96(sp)
ffffffffc02068d8:	e83e                	sd	a5,16(sp)
ffffffffc02068da:	8956                	mv	s2,s5
ffffffffc02068dc:	846e                	mv	s0,s11
ffffffffc02068de:	a015                	j	ffffffffc0206902 <do_execve+0x410>
ffffffffc02068e0:	7742                	ld	a4,48(sp)
ffffffffc02068e2:	77e2                	ld	a5,56(sp)
ffffffffc02068e4:	41240933          	sub	s2,s0,s2
ffffffffc02068e8:	865e                	mv	a2,s7
ffffffffc02068ea:	00f705b3          	add	a1,a4,a5
ffffffffc02068ee:	95ca                	add	a1,a1,s2
ffffffffc02068f0:	8526                	mv	a0,s1
ffffffffc02068f2:	f75fd0ef          	jal	ra,ffffffffc0204866 <sysfile_read>
ffffffffc02068f6:	f4ab9ae3          	bne	s7,a0,ffffffffc020684a <do_execve+0x358>
ffffffffc02068fa:	945e                	add	s0,s0,s7
ffffffffc02068fc:	27a47363          	bgeu	s0,s10,ffffffffc0206b62 <do_execve+0x670>
ffffffffc0206900:	8956                	mv	s2,s5
ffffffffc0206902:	67a2                	ld	a5,8(sp)
ffffffffc0206904:	864e                	mv	a2,s3
ffffffffc0206906:	85ca                	mv	a1,s2
ffffffffc0206908:	6f88                	ld	a0,24(a5)
ffffffffc020690a:	b9afc0ef          	jal	ra,ffffffffc0202ca4 <pgdir_alloc_page>
ffffffffc020690e:	8daa                	mv	s11,a0
ffffffffc0206910:	22050363          	beqz	a0,ffffffffc0206b36 <do_execve+0x644>
ffffffffc0206914:	6785                	lui	a5,0x1
ffffffffc0206916:	00f90ab3          	add	s5,s2,a5
ffffffffc020691a:	408d0bb3          	sub	s7,s10,s0
ffffffffc020691e:	015d6463          	bltu	s10,s5,ffffffffc0206926 <do_execve+0x434>
ffffffffc0206922:	408a8bb3          	sub	s7,s5,s0
ffffffffc0206926:	000c3583          	ld	a1,0(s8)
ffffffffc020692a:	77a2                	ld	a5,40(sp)
ffffffffc020692c:	000cb603          	ld	a2,0(s9)
ffffffffc0206930:	40bd85b3          	sub	a1,s11,a1
ffffffffc0206934:	8599                	srai	a1,a1,0x6
ffffffffc0206936:	95be                	add	a1,a1,a5
ffffffffc0206938:	67e2                	ld	a5,24(sp)
ffffffffc020693a:	00f5f533          	and	a0,a1,a5
ffffffffc020693e:	00c59793          	slli	a5,a1,0xc
ffffffffc0206942:	f83e                	sd	a5,48(sp)
ffffffffc0206944:	32c57163          	bgeu	a0,a2,ffffffffc0206c66 <do_execve+0x774>
ffffffffc0206948:	65ca                	ld	a1,144(sp)
ffffffffc020694a:	636a                	ld	t1,152(sp)
ffffffffc020694c:	00090797          	auipc	a5,0x90
ffffffffc0206950:	f6478793          	addi	a5,a5,-156 # ffffffffc02968b0 <va_pa_offset>
ffffffffc0206954:	639c                	ld	a5,0(a5)
ffffffffc0206956:	406585b3          	sub	a1,a1,t1
ffffffffc020695a:	4601                	li	a2,0
ffffffffc020695c:	8526                	mv	a0,s1
ffffffffc020695e:	95a2                	add	a1,a1,s0
ffffffffc0206960:	fc3e                	sd	a5,56(sp)
ffffffffc0206962:	932fe0ef          	jal	ra,ffffffffc0204a94 <sysfile_seek>
ffffffffc0206966:	e82a                	sd	a0,16(sp)
ffffffffc0206968:	dd25                	beqz	a0,ffffffffc02068e0 <do_execve+0x3ee>
ffffffffc020696a:	6d86                	ld	s11,64(sp)
ffffffffc020696c:	6922                	ld	s2,8(sp)
ffffffffc020696e:	6426                	ld	s0,72(sp)
ffffffffc0206970:	b5fd                	j	ffffffffc020685e <do_execve+0x36c>
ffffffffc0206972:	47aa                	lw	a5,136(sp)
ffffffffc0206974:	4705                	li	a4,1
ffffffffc0206976:	f0e780e3          	beq	a5,a4,ffffffffc0206876 <do_execve+0x384>
ffffffffc020697a:	6766                	ld	a4,88(sp)
ffffffffc020697c:	66c6                	ld	a3,80(sp)
ffffffffc020697e:	0f815783          	lhu	a5,248(sp)
ffffffffc0206982:	2705                	addiw	a4,a4,1
ffffffffc0206984:	03868693          	addi	a3,a3,56 # 1038 <_binary_bin_swap_img_size-0x6cc8>
ffffffffc0206988:	ecba                	sd	a4,88(sp)
ffffffffc020698a:	e8b6                	sd	a3,80(sp)
ffffffffc020698c:	e8f74be3          	blt	a4,a5,ffffffffc0206822 <do_execve+0x330>
ffffffffc0206990:	6d86                	ld	s11,64(sp)
ffffffffc0206992:	6922                	ld	s2,8(sp)
ffffffffc0206994:	7aa6                	ld	s5,104(sp)
ffffffffc0206996:	6426                	ld	s0,72(sp)
ffffffffc0206998:	4701                	li	a4,0
ffffffffc020699a:	46ad                	li	a3,11
ffffffffc020699c:	00100637          	lui	a2,0x100
ffffffffc02069a0:	7ff005b7          	lui	a1,0x7ff00
ffffffffc02069a4:	854a                	mv	a0,s2
ffffffffc02069a6:	d84fc0ef          	jal	ra,ffffffffc0202f2a <mm_map>
ffffffffc02069aa:	e82a                	sd	a0,16(sp)
ffffffffc02069ac:	ea0519e3          	bnez	a0,ffffffffc020685e <do_execve+0x36c>
ffffffffc02069b0:	01893503          	ld	a0,24(s2)
ffffffffc02069b4:	467d                	li	a2,31
ffffffffc02069b6:	7ffff5b7          	lui	a1,0x7ffff
ffffffffc02069ba:	aeafc0ef          	jal	ra,ffffffffc0202ca4 <pgdir_alloc_page>
ffffffffc02069be:	30050163          	beqz	a0,ffffffffc0206cc0 <do_execve+0x7ce>
ffffffffc02069c2:	01893503          	ld	a0,24(s2)
ffffffffc02069c6:	467d                	li	a2,31
ffffffffc02069c8:	7fffe5b7          	lui	a1,0x7fffe
ffffffffc02069cc:	ad8fc0ef          	jal	ra,ffffffffc0202ca4 <pgdir_alloc_page>
ffffffffc02069d0:	2c050863          	beqz	a0,ffffffffc0206ca0 <do_execve+0x7ae>
ffffffffc02069d4:	01893503          	ld	a0,24(s2)
ffffffffc02069d8:	467d                	li	a2,31
ffffffffc02069da:	7fffd5b7          	lui	a1,0x7fffd
ffffffffc02069de:	ac6fc0ef          	jal	ra,ffffffffc0202ca4 <pgdir_alloc_page>
ffffffffc02069e2:	28050f63          	beqz	a0,ffffffffc0206c80 <do_execve+0x78e>
ffffffffc02069e6:	01893503          	ld	a0,24(s2)
ffffffffc02069ea:	467d                	li	a2,31
ffffffffc02069ec:	7fffc5b7          	lui	a1,0x7fffc
ffffffffc02069f0:	ab4fc0ef          	jal	ra,ffffffffc0202ca4 <pgdir_alloc_page>
ffffffffc02069f4:	30050263          	beqz	a0,ffffffffc0206cf8 <do_execve+0x806>
ffffffffc02069f8:	03092783          	lw	a5,48(s2)
ffffffffc02069fc:	000a3703          	ld	a4,0(s4)
ffffffffc0206a00:	01893683          	ld	a3,24(s2)
ffffffffc0206a04:	2785                	addiw	a5,a5,1
ffffffffc0206a06:	02f92823          	sw	a5,48(s2)
ffffffffc0206a0a:	03273423          	sd	s2,40(a4)
ffffffffc0206a0e:	c02007b7          	lui	a5,0xc0200
ffffffffc0206a12:	2cf6e763          	bltu	a3,a5,ffffffffc0206ce0 <do_execve+0x7ee>
ffffffffc0206a16:	00090797          	auipc	a5,0x90
ffffffffc0206a1a:	e9a78793          	addi	a5,a5,-358 # ffffffffc02968b0 <va_pa_offset>
ffffffffc0206a1e:	639c                	ld	a5,0(a5)
ffffffffc0206a20:	8e9d                	sub	a3,a3,a5
ffffffffc0206a22:	f754                	sd	a3,168(a4)
ffffffffc0206a24:	577d                	li	a4,-1
ffffffffc0206a26:	00c6d793          	srli	a5,a3,0xc
ffffffffc0206a2a:	177e                	slli	a4,a4,0x3f
ffffffffc0206a2c:	8fd9                	or	a5,a5,a4
ffffffffc0206a2e:	18079073          	csrw	satp,a5
ffffffffc0206a32:	4985                	li	s3,1
ffffffffc0206a34:	008d8c13          	addi	s8,s11,8
ffffffffc0206a38:	02016903          	lwu	s2,32(sp)
ffffffffc0206a3c:	09fe                	slli	s3,s3,0x1f
ffffffffc0206a3e:	00fc7793          	andi	a5,s8,15
ffffffffc0206a42:	418989b3          	sub	s3,s3,s8
ffffffffc0206a46:	40f989b3          	sub	s3,s3,a5
ffffffffc0206a4a:	ff0b0493          	addi	s1,s6,-16
ffffffffc0206a4e:	41898c33          	sub	s8,s3,s8
ffffffffc0206a52:	01b48cb3          	add	s9,s1,s11
ffffffffc0206a56:	00391793          	slli	a5,s2,0x3
ffffffffc0206a5a:	416c0d33          	sub	s10,s8,s6
ffffffffc0206a5e:	ff8d8b93          	addi	s7,s11,-8
ffffffffc0206a62:	40fc8cb3          	sub	s9,s9,a5
ffffffffc0206a66:	e422                	sd	s0,8(sp)
ffffffffc0206a68:	9bda                	add	s7,s7,s6
ffffffffc0206a6a:	846a                	mv	s0,s10
ffffffffc0206a6c:	8d66                	mv	s10,s9
ffffffffc0206a6e:	000bbc83          	ld	s9,0(s7)
ffffffffc0206a72:	8566                	mv	a0,s9
ffffffffc0206a74:	4e8040ef          	jal	ra,ffffffffc020af5c <strlen>
ffffffffc0206a78:	fff54793          	not	a5,a0
ffffffffc0206a7c:	99be                	add	s3,s3,a5
ffffffffc0206a7e:	85e6                	mv	a1,s9
ffffffffc0206a80:	854e                	mv	a0,s3
ffffffffc0206a82:	510040ef          	jal	ra,ffffffffc020af92 <strcpy>
ffffffffc0206a86:	017407b3          	add	a5,s0,s7
ffffffffc0206a8a:	0137b023          	sd	s3,0(a5)
ffffffffc0206a8e:	1be1                	addi	s7,s7,-8
ffffffffc0206a90:	fd7d1fe3          	bne	s10,s7,ffffffffc0206a6e <do_execve+0x57c>
ffffffffc0206a94:	000a3783          	ld	a5,0(s4)
ffffffffc0206a98:	01bc0733          	add	a4,s8,s11
ffffffffc0206a9c:	00073023          	sd	zero,0(a4)
ffffffffc0206aa0:	0a07b983          	ld	s3,160(a5)
ffffffffc0206aa4:	12000613          	li	a2,288
ffffffffc0206aa8:	4581                	li	a1,0
ffffffffc0206aaa:	854e                	mv	a0,s3
ffffffffc0206aac:	6422                	ld	s0,8(sp)
ffffffffc0206aae:	1009bb83          	ld	s7,256(s3)
ffffffffc0206ab2:	54c040ef          	jal	ra,ffffffffc020affe <memset>
ffffffffc0206ab6:	67ee                	ld	a5,216(sp)
ffffffffc0206ab8:	ff0c7713          	andi	a4,s8,-16
ffffffffc0206abc:	edfbfb93          	andi	s7,s7,-289
ffffffffc0206ac0:	00e9b823          	sd	a4,16(s3)
ffffffffc0206ac4:	10f9b423          	sd	a5,264(s3)
ffffffffc0206ac8:	1179b023          	sd	s7,256(s3)
ffffffffc0206acc:	0489b823          	sd	s0,80(s3)
ffffffffc0206ad0:	0589bc23          	sd	s8,88(s3)
ffffffffc0206ad4:	fff40793          	addi	a5,s0,-1
ffffffffc0206ad8:	078e                	slli	a5,a5,0x3
ffffffffc0206ada:	01b48433          	add	s0,s1,s11
ffffffffc0206ade:	090e                	slli	s2,s2,0x3
ffffffffc0206ae0:	9b3e                	add	s6,s6,a5
ffffffffc0206ae2:	41240433          	sub	s0,s0,s2
ffffffffc0206ae6:	000b3503          	ld	a0,0(s6)
ffffffffc0206aea:	1b61                	addi	s6,s6,-8
ffffffffc0206aec:	d8bfc0ef          	jal	ra,ffffffffc0203876 <kfree>
ffffffffc0206af0:	fe8b1be3          	bne	s6,s0,ffffffffc0206ae6 <do_execve+0x5f4>
ffffffffc0206af4:	000a3403          	ld	s0,0(s4)
ffffffffc0206af8:	4641                	li	a2,16
ffffffffc0206afa:	4581                	li	a1,0
ffffffffc0206afc:	0b440413          	addi	s0,s0,180
ffffffffc0206b00:	8522                	mv	a0,s0
ffffffffc0206b02:	4fc040ef          	jal	ra,ffffffffc020affe <memset>
ffffffffc0206b06:	463d                	li	a2,15
ffffffffc0206b08:	18ac                	addi	a1,sp,120
ffffffffc0206b0a:	8522                	mv	a0,s0
ffffffffc0206b0c:	544040ef          	jal	ra,ffffffffc020b050 <memcpy>
ffffffffc0206b10:	b9b1                	j	ffffffffc020676c <do_execve+0x27a>
ffffffffc0206b12:	01893503          	ld	a0,24(s2)
ffffffffc0206b16:	54e1                	li	s1,-8
ffffffffc0206b18:	fddfe0ef          	jal	ra,ffffffffc0205af4 <put_pgdir.isra.0>
ffffffffc0206b1c:	854a                	mv	a0,s2
ffffffffc0206b1e:	bbafc0ef          	jal	ra,ffffffffc0202ed8 <mm_destroy>
ffffffffc0206b22:	be49                	j	ffffffffc02066b4 <do_execve+0x1c2>
ffffffffc0206b24:	0026e693          	ori	a3,a3,2
ffffffffc0206b28:	d60798e3          	bnez	a5,ffffffffc0206898 <do_execve+0x3a6>
ffffffffc0206b2c:	47dd                	li	a5,23
ffffffffc0206b2e:	f0be                	sd	a5,96(sp)
ffffffffc0206b30:	bba5                	j	ffffffffc02068a8 <do_execve+0x3b6>
ffffffffc0206b32:	5af5                	li	s5,-3
ffffffffc0206b34:	b925                	j	ffffffffc020676c <do_execve+0x27a>
ffffffffc0206b36:	6d86                	ld	s11,64(sp)
ffffffffc0206b38:	6922                	ld	s2,8(sp)
ffffffffc0206b3a:	7aa6                	ld	s5,104(sp)
ffffffffc0206b3c:	6426                	ld	s0,72(sp)
ffffffffc0206b3e:	854a                	mv	a0,s2
ffffffffc0206b40:	d34fc0ef          	jal	ra,ffffffffc0203074 <exit_mmap>
ffffffffc0206b44:	01893503          	ld	a0,24(s2)
ffffffffc0206b48:	fadfe0ef          	jal	ra,ffffffffc0205af4 <put_pgdir.isra.0>
ffffffffc0206b4c:	854a                	mv	a0,s2
ffffffffc0206b4e:	b8afc0ef          	jal	ra,ffffffffc0202ed8 <mm_destroy>
ffffffffc0206b52:	67c2                	ld	a5,16(sp)
ffffffffc0206b54:	1c079263          	bnez	a5,ffffffffc0206d18 <do_execve+0x826>
ffffffffc0206b58:	02016903          	lwu	s2,32(sp)
ffffffffc0206b5c:	ff0b0493          	addi	s1,s6,-16
ffffffffc0206b60:	bf95                	j	ffffffffc0206ad4 <do_execve+0x5e2>
ffffffffc0206b62:	69ea                	ld	s3,152(sp)
ffffffffc0206b64:	f86e                	sd	s11,48(sp)
ffffffffc0206b66:	8da2                	mv	s11,s0
ffffffffc0206b68:	8456                	mv	s0,s5
ffffffffc0206b6a:	76ca                	ld	a3,176(sp)
ffffffffc0206b6c:	99b6                	add	s3,s3,a3
ffffffffc0206b6e:	048dfb63          	bgeu	s11,s0,ffffffffc0206bc4 <do_execve+0x6d2>
ffffffffc0206b72:	e13df4e3          	bgeu	s11,s3,ffffffffc020697a <do_execve+0x488>
ffffffffc0206b76:	6785                	lui	a5,0x1
ffffffffc0206b78:	00fd8533          	add	a0,s11,a5
ffffffffc0206b7c:	8d01                	sub	a0,a0,s0
ffffffffc0206b7e:	41b98933          	sub	s2,s3,s11
ffffffffc0206b82:	0089e463          	bltu	s3,s0,ffffffffc0206b8a <do_execve+0x698>
ffffffffc0206b86:	41b40933          	sub	s2,s0,s11
ffffffffc0206b8a:	77c2                	ld	a5,48(sp)
ffffffffc0206b8c:	000c3683          	ld	a3,0(s8)
ffffffffc0206b90:	000cb603          	ld	a2,0(s9)
ffffffffc0206b94:	40d786b3          	sub	a3,a5,a3
ffffffffc0206b98:	77a2                	ld	a5,40(sp)
ffffffffc0206b9a:	8699                	srai	a3,a3,0x6
ffffffffc0206b9c:	96be                	add	a3,a3,a5
ffffffffc0206b9e:	67e2                	ld	a5,24(sp)
ffffffffc0206ba0:	00f6f5b3          	and	a1,a3,a5
ffffffffc0206ba4:	06b2                	slli	a3,a3,0xc
ffffffffc0206ba6:	0cc5f163          	bgeu	a1,a2,ffffffffc0206c68 <do_execve+0x776>
ffffffffc0206baa:	00090797          	auipc	a5,0x90
ffffffffc0206bae:	d0678793          	addi	a5,a5,-762 # ffffffffc02968b0 <va_pa_offset>
ffffffffc0206bb2:	0007b803          	ld	a6,0(a5)
ffffffffc0206bb6:	864a                	mv	a2,s2
ffffffffc0206bb8:	4581                	li	a1,0
ffffffffc0206bba:	96c2                	add	a3,a3,a6
ffffffffc0206bbc:	9536                	add	a0,a0,a3
ffffffffc0206bbe:	440040ef          	jal	ra,ffffffffc020affe <memset>
ffffffffc0206bc2:	9dca                	add	s11,s11,s2
ffffffffc0206bc4:	db3dfbe3          	bgeu	s11,s3,ffffffffc020697a <do_execve+0x488>
ffffffffc0206bc8:	6922                	ld	s2,8(sp)
ffffffffc0206bca:	7a86                	ld	s5,96(sp)
ffffffffc0206bcc:	7d22                	ld	s10,40(sp)
ffffffffc0206bce:	a0a9                	j	ffffffffc0206c18 <do_execve+0x726>
ffffffffc0206bd0:	6785                	lui	a5,0x1
ffffffffc0206bd2:	408d8533          	sub	a0,s11,s0
ffffffffc0206bd6:	943e                	add	s0,s0,a5
ffffffffc0206bd8:	41b98633          	sub	a2,s3,s11
ffffffffc0206bdc:	0089e463          	bltu	s3,s0,ffffffffc0206be4 <do_execve+0x6f2>
ffffffffc0206be0:	41b40633          	sub	a2,s0,s11
ffffffffc0206be4:	000c3783          	ld	a5,0(s8)
ffffffffc0206be8:	66e2                	ld	a3,24(sp)
ffffffffc0206bea:	000cb703          	ld	a4,0(s9)
ffffffffc0206bee:	40fb87b3          	sub	a5,s7,a5
ffffffffc0206bf2:	8799                	srai	a5,a5,0x6
ffffffffc0206bf4:	97ea                	add	a5,a5,s10
ffffffffc0206bf6:	8efd                	and	a3,a3,a5
ffffffffc0206bf8:	07b2                	slli	a5,a5,0xc
ffffffffc0206bfa:	06e6f663          	bgeu	a3,a4,ffffffffc0206c66 <do_execve+0x774>
ffffffffc0206bfe:	00090717          	auipc	a4,0x90
ffffffffc0206c02:	cb270713          	addi	a4,a4,-846 # ffffffffc02968b0 <va_pa_offset>
ffffffffc0206c06:	6318                	ld	a4,0(a4)
ffffffffc0206c08:	9db2                	add	s11,s11,a2
ffffffffc0206c0a:	4581                	li	a1,0
ffffffffc0206c0c:	97ba                	add	a5,a5,a4
ffffffffc0206c0e:	953e                	add	a0,a0,a5
ffffffffc0206c10:	3ee040ef          	jal	ra,ffffffffc020affe <memset>
ffffffffc0206c14:	013dfe63          	bgeu	s11,s3,ffffffffc0206c30 <do_execve+0x73e>
ffffffffc0206c18:	01893503          	ld	a0,24(s2)
ffffffffc0206c1c:	8656                	mv	a2,s5
ffffffffc0206c1e:	85a2                	mv	a1,s0
ffffffffc0206c20:	884fc0ef          	jal	ra,ffffffffc0202ca4 <pgdir_alloc_page>
ffffffffc0206c24:	8baa                	mv	s7,a0
ffffffffc0206c26:	f54d                	bnez	a0,ffffffffc0206bd0 <do_execve+0x6de>
ffffffffc0206c28:	6d86                	ld	s11,64(sp)
ffffffffc0206c2a:	7aa6                	ld	s5,104(sp)
ffffffffc0206c2c:	6426                	ld	s0,72(sp)
ffffffffc0206c2e:	bf01                	j	ffffffffc0206b3e <do_execve+0x64c>
ffffffffc0206c30:	f85e                	sd	s7,48(sp)
ffffffffc0206c32:	b3a1                	j	ffffffffc020697a <do_execve+0x488>
ffffffffc0206c34:	5af5                	li	s5,-3
ffffffffc0206c36:	b20b95e3          	bnez	s7,ffffffffc0206760 <do_execve+0x26e>
ffffffffc0206c3a:	be0d                	j	ffffffffc020676c <do_execve+0x27a>
ffffffffc0206c3c:	ee0b8be3          	beqz	s7,ffffffffc0206b32 <do_execve+0x640>
ffffffffc0206c40:	038b8513          	addi	a0,s7,56
ffffffffc0206c44:	b07fd0ef          	jal	ra,ffffffffc020474a <up>
ffffffffc0206c48:	5af5                	li	s5,-3
ffffffffc0206c4a:	040ba823          	sw	zero,80(s7)
ffffffffc0206c4e:	be39                	j	ffffffffc020676c <do_execve+0x27a>
ffffffffc0206c50:	57f1                	li	a5,-4
ffffffffc0206c52:	89ee                	mv	s3,s11
ffffffffc0206c54:	8456                	mv	s0,s5
ffffffffc0206c56:	e83e                	sd	a5,16(sp)
ffffffffc0206c58:	bf09                	j	ffffffffc0206b6a <do_execve+0x678>
ffffffffc0206c5a:	57e1                	li	a5,-8
ffffffffc0206c5c:	6d86                	ld	s11,64(sp)
ffffffffc0206c5e:	6922                	ld	s2,8(sp)
ffffffffc0206c60:	6426                	ld	s0,72(sp)
ffffffffc0206c62:	e83e                	sd	a5,16(sp)
ffffffffc0206c64:	beed                	j	ffffffffc020685e <do_execve+0x36c>
ffffffffc0206c66:	86be                	mv	a3,a5
ffffffffc0206c68:	00005617          	auipc	a2,0x5
ffffffffc0206c6c:	4a860613          	addi	a2,a2,1192 # ffffffffc020c110 <commands+0x968>
ffffffffc0206c70:	07100593          	li	a1,113
ffffffffc0206c74:	00005517          	auipc	a0,0x5
ffffffffc0206c78:	46450513          	addi	a0,a0,1124 # ffffffffc020c0d8 <commands+0x930>
ffffffffc0206c7c:	db2f90ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0206c80:	00007697          	auipc	a3,0x7
ffffffffc0206c84:	ac068693          	addi	a3,a3,-1344 # ffffffffc020d740 <CSWTCH.79+0x390>
ffffffffc0206c88:	00005617          	auipc	a2,0x5
ffffffffc0206c8c:	b8060613          	addi	a2,a2,-1152 # ffffffffc020b808 <commands+0x60>
ffffffffc0206c90:	34b00593          	li	a1,843
ffffffffc0206c94:	00007517          	auipc	a0,0x7
ffffffffc0206c98:	80450513          	addi	a0,a0,-2044 # ffffffffc020d498 <CSWTCH.79+0xe8>
ffffffffc0206c9c:	d92f90ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0206ca0:	00007697          	auipc	a3,0x7
ffffffffc0206ca4:	a5868693          	addi	a3,a3,-1448 # ffffffffc020d6f8 <CSWTCH.79+0x348>
ffffffffc0206ca8:	00005617          	auipc	a2,0x5
ffffffffc0206cac:	b6060613          	addi	a2,a2,-1184 # ffffffffc020b808 <commands+0x60>
ffffffffc0206cb0:	34a00593          	li	a1,842
ffffffffc0206cb4:	00006517          	auipc	a0,0x6
ffffffffc0206cb8:	7e450513          	addi	a0,a0,2020 # ffffffffc020d498 <CSWTCH.79+0xe8>
ffffffffc0206cbc:	d72f90ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0206cc0:	00007697          	auipc	a3,0x7
ffffffffc0206cc4:	9f068693          	addi	a3,a3,-1552 # ffffffffc020d6b0 <CSWTCH.79+0x300>
ffffffffc0206cc8:	00005617          	auipc	a2,0x5
ffffffffc0206ccc:	b4060613          	addi	a2,a2,-1216 # ffffffffc020b808 <commands+0x60>
ffffffffc0206cd0:	34900593          	li	a1,841
ffffffffc0206cd4:	00006517          	auipc	a0,0x6
ffffffffc0206cd8:	7c450513          	addi	a0,a0,1988 # ffffffffc020d498 <CSWTCH.79+0xe8>
ffffffffc0206cdc:	d52f90ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0206ce0:	00005617          	auipc	a2,0x5
ffffffffc0206ce4:	55060613          	addi	a2,a2,1360 # ffffffffc020c230 <commands+0xa88>
ffffffffc0206ce8:	35100593          	li	a1,849
ffffffffc0206cec:	00006517          	auipc	a0,0x6
ffffffffc0206cf0:	7ac50513          	addi	a0,a0,1964 # ffffffffc020d498 <CSWTCH.79+0xe8>
ffffffffc0206cf4:	d3af90ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0206cf8:	00007697          	auipc	a3,0x7
ffffffffc0206cfc:	a9068693          	addi	a3,a3,-1392 # ffffffffc020d788 <CSWTCH.79+0x3d8>
ffffffffc0206d00:	00005617          	auipc	a2,0x5
ffffffffc0206d04:	b0860613          	addi	a2,a2,-1272 # ffffffffc020b808 <commands+0x60>
ffffffffc0206d08:	34c00593          	li	a1,844
ffffffffc0206d0c:	00006517          	auipc	a0,0x6
ffffffffc0206d10:	78c50513          	addi	a0,a0,1932 # ffffffffc020d498 <CSWTCH.79+0xe8>
ffffffffc0206d14:	d1af90ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0206d18:	64c2                	ld	s1,16(sp)
ffffffffc0206d1a:	ba69                	j	ffffffffc02066b4 <do_execve+0x1c2>

ffffffffc0206d1c <user_main>:
ffffffffc0206d1c:	7179                	addi	sp,sp,-48
ffffffffc0206d1e:	e84a                	sd	s2,16(sp)
ffffffffc0206d20:	00090917          	auipc	s2,0x90
ffffffffc0206d24:	ba090913          	addi	s2,s2,-1120 # ffffffffc02968c0 <current>
ffffffffc0206d28:	00093783          	ld	a5,0(s2)
ffffffffc0206d2c:	00007617          	auipc	a2,0x7
ffffffffc0206d30:	aa460613          	addi	a2,a2,-1372 # ffffffffc020d7d0 <CSWTCH.79+0x420>
ffffffffc0206d34:	00007517          	auipc	a0,0x7
ffffffffc0206d38:	aa450513          	addi	a0,a0,-1372 # ffffffffc020d7d8 <CSWTCH.79+0x428>
ffffffffc0206d3c:	43cc                	lw	a1,4(a5)
ffffffffc0206d3e:	f406                	sd	ra,40(sp)
ffffffffc0206d40:	f022                	sd	s0,32(sp)
ffffffffc0206d42:	ec26                	sd	s1,24(sp)
ffffffffc0206d44:	e032                	sd	a2,0(sp)
ffffffffc0206d46:	e402                	sd	zero,8(sp)
ffffffffc0206d48:	be2f90ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0206d4c:	6782                	ld	a5,0(sp)
ffffffffc0206d4e:	cfb9                	beqz	a5,ffffffffc0206dac <user_main+0x90>
ffffffffc0206d50:	003c                	addi	a5,sp,8
ffffffffc0206d52:	4401                	li	s0,0
ffffffffc0206d54:	6398                	ld	a4,0(a5)
ffffffffc0206d56:	0405                	addi	s0,s0,1
ffffffffc0206d58:	07a1                	addi	a5,a5,8
ffffffffc0206d5a:	ff6d                	bnez	a4,ffffffffc0206d54 <user_main+0x38>
ffffffffc0206d5c:	00093783          	ld	a5,0(s2)
ffffffffc0206d60:	12000613          	li	a2,288
ffffffffc0206d64:	6b84                	ld	s1,16(a5)
ffffffffc0206d66:	73cc                	ld	a1,160(a5)
ffffffffc0206d68:	6789                	lui	a5,0x2
ffffffffc0206d6a:	ee078793          	addi	a5,a5,-288 # 1ee0 <_binary_bin_swap_img_size-0x5e20>
ffffffffc0206d6e:	94be                	add	s1,s1,a5
ffffffffc0206d70:	8526                	mv	a0,s1
ffffffffc0206d72:	2de040ef          	jal	ra,ffffffffc020b050 <memcpy>
ffffffffc0206d76:	00093783          	ld	a5,0(s2)
ffffffffc0206d7a:	860a                	mv	a2,sp
ffffffffc0206d7c:	0004059b          	sext.w	a1,s0
ffffffffc0206d80:	f3c4                	sd	s1,160(a5)
ffffffffc0206d82:	00007517          	auipc	a0,0x7
ffffffffc0206d86:	a4e50513          	addi	a0,a0,-1458 # ffffffffc020d7d0 <CSWTCH.79+0x420>
ffffffffc0206d8a:	f68ff0ef          	jal	ra,ffffffffc02064f2 <do_execve>
ffffffffc0206d8e:	8126                	mv	sp,s1
ffffffffc0206d90:	cc8fa06f          	j	ffffffffc0201258 <__trapret>
ffffffffc0206d94:	00007617          	auipc	a2,0x7
ffffffffc0206d98:	a6c60613          	addi	a2,a2,-1428 # ffffffffc020d800 <CSWTCH.79+0x450>
ffffffffc0206d9c:	49100593          	li	a1,1169
ffffffffc0206da0:	00006517          	auipc	a0,0x6
ffffffffc0206da4:	6f850513          	addi	a0,a0,1784 # ffffffffc020d498 <CSWTCH.79+0xe8>
ffffffffc0206da8:	c86f90ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0206dac:	4401                	li	s0,0
ffffffffc0206dae:	b77d                	j	ffffffffc0206d5c <user_main+0x40>

ffffffffc0206db0 <do_yield>:
ffffffffc0206db0:	00090797          	auipc	a5,0x90
ffffffffc0206db4:	b107b783          	ld	a5,-1264(a5) # ffffffffc02968c0 <current>
ffffffffc0206db8:	4705                	li	a4,1
ffffffffc0206dba:	ef98                	sd	a4,24(a5)
ffffffffc0206dbc:	4501                	li	a0,0
ffffffffc0206dbe:	8082                	ret

ffffffffc0206dc0 <do_wait>:
ffffffffc0206dc0:	1101                	addi	sp,sp,-32
ffffffffc0206dc2:	e822                	sd	s0,16(sp)
ffffffffc0206dc4:	e426                	sd	s1,8(sp)
ffffffffc0206dc6:	ec06                	sd	ra,24(sp)
ffffffffc0206dc8:	842e                	mv	s0,a1
ffffffffc0206dca:	84aa                	mv	s1,a0
ffffffffc0206dcc:	c999                	beqz	a1,ffffffffc0206de2 <do_wait+0x22>
ffffffffc0206dce:	00090797          	auipc	a5,0x90
ffffffffc0206dd2:	af27b783          	ld	a5,-1294(a5) # ffffffffc02968c0 <current>
ffffffffc0206dd6:	7788                	ld	a0,40(a5)
ffffffffc0206dd8:	4685                	li	a3,1
ffffffffc0206dda:	4611                	li	a2,4
ffffffffc0206ddc:	e38fc0ef          	jal	ra,ffffffffc0203414 <user_mem_check>
ffffffffc0206de0:	c909                	beqz	a0,ffffffffc0206df2 <do_wait+0x32>
ffffffffc0206de2:	85a2                	mv	a1,s0
ffffffffc0206de4:	6442                	ld	s0,16(sp)
ffffffffc0206de6:	60e2                	ld	ra,24(sp)
ffffffffc0206de8:	8526                	mv	a0,s1
ffffffffc0206dea:	64a2                	ld	s1,8(sp)
ffffffffc0206dec:	6105                	addi	sp,sp,32
ffffffffc0206dee:	be2ff06f          	j	ffffffffc02061d0 <do_wait.part.0>
ffffffffc0206df2:	60e2                	ld	ra,24(sp)
ffffffffc0206df4:	6442                	ld	s0,16(sp)
ffffffffc0206df6:	64a2                	ld	s1,8(sp)
ffffffffc0206df8:	5575                	li	a0,-3
ffffffffc0206dfa:	6105                	addi	sp,sp,32
ffffffffc0206dfc:	8082                	ret

ffffffffc0206dfe <do_kill>:
ffffffffc0206dfe:	1141                	addi	sp,sp,-16
ffffffffc0206e00:	6789                	lui	a5,0x2
ffffffffc0206e02:	e406                	sd	ra,8(sp)
ffffffffc0206e04:	e022                	sd	s0,0(sp)
ffffffffc0206e06:	fff5071b          	addiw	a4,a0,-1
ffffffffc0206e0a:	17f9                	addi	a5,a5,-2
ffffffffc0206e0c:	02e7e963          	bltu	a5,a4,ffffffffc0206e3e <do_kill+0x40>
ffffffffc0206e10:	842a                	mv	s0,a0
ffffffffc0206e12:	45a9                	li	a1,10
ffffffffc0206e14:	2501                	sext.w	a0,a0
ffffffffc0206e16:	6ce040ef          	jal	ra,ffffffffc020b4e4 <hash32>
ffffffffc0206e1a:	02051793          	slli	a5,a0,0x20
ffffffffc0206e1e:	01c7d513          	srli	a0,a5,0x1c
ffffffffc0206e22:	0008b797          	auipc	a5,0x8b
ffffffffc0206e26:	99e78793          	addi	a5,a5,-1634 # ffffffffc02917c0 <hash_list>
ffffffffc0206e2a:	953e                	add	a0,a0,a5
ffffffffc0206e2c:	87aa                	mv	a5,a0
ffffffffc0206e2e:	a029                	j	ffffffffc0206e38 <do_kill+0x3a>
ffffffffc0206e30:	f2c7a703          	lw	a4,-212(a5)
ffffffffc0206e34:	00870b63          	beq	a4,s0,ffffffffc0206e4a <do_kill+0x4c>
ffffffffc0206e38:	679c                	ld	a5,8(a5)
ffffffffc0206e3a:	fef51be3          	bne	a0,a5,ffffffffc0206e30 <do_kill+0x32>
ffffffffc0206e3e:	5475                	li	s0,-3
ffffffffc0206e40:	60a2                	ld	ra,8(sp)
ffffffffc0206e42:	8522                	mv	a0,s0
ffffffffc0206e44:	6402                	ld	s0,0(sp)
ffffffffc0206e46:	0141                	addi	sp,sp,16
ffffffffc0206e48:	8082                	ret
ffffffffc0206e4a:	fd87a703          	lw	a4,-40(a5)
ffffffffc0206e4e:	00177693          	andi	a3,a4,1
ffffffffc0206e52:	e295                	bnez	a3,ffffffffc0206e76 <do_kill+0x78>
ffffffffc0206e54:	4bd4                	lw	a3,20(a5)
ffffffffc0206e56:	00176713          	ori	a4,a4,1
ffffffffc0206e5a:	fce7ac23          	sw	a4,-40(a5)
ffffffffc0206e5e:	4401                	li	s0,0
ffffffffc0206e60:	fe06d0e3          	bgez	a3,ffffffffc0206e40 <do_kill+0x42>
ffffffffc0206e64:	f2878513          	addi	a0,a5,-216
ffffffffc0206e68:	308000ef          	jal	ra,ffffffffc0207170 <wakeup_proc>
ffffffffc0206e6c:	60a2                	ld	ra,8(sp)
ffffffffc0206e6e:	8522                	mv	a0,s0
ffffffffc0206e70:	6402                	ld	s0,0(sp)
ffffffffc0206e72:	0141                	addi	sp,sp,16
ffffffffc0206e74:	8082                	ret
ffffffffc0206e76:	545d                	li	s0,-9
ffffffffc0206e78:	b7e1                	j	ffffffffc0206e40 <do_kill+0x42>

ffffffffc0206e7a <proc_init>:
ffffffffc0206e7a:	1101                	addi	sp,sp,-32
ffffffffc0206e7c:	e426                	sd	s1,8(sp)
ffffffffc0206e7e:	0008f797          	auipc	a5,0x8f
ffffffffc0206e82:	94278793          	addi	a5,a5,-1726 # ffffffffc02957c0 <proc_list>
ffffffffc0206e86:	ec06                	sd	ra,24(sp)
ffffffffc0206e88:	e822                	sd	s0,16(sp)
ffffffffc0206e8a:	e04a                	sd	s2,0(sp)
ffffffffc0206e8c:	0008b497          	auipc	s1,0x8b
ffffffffc0206e90:	93448493          	addi	s1,s1,-1740 # ffffffffc02917c0 <hash_list>
ffffffffc0206e94:	e79c                	sd	a5,8(a5)
ffffffffc0206e96:	e39c                	sd	a5,0(a5)
ffffffffc0206e98:	0008f717          	auipc	a4,0x8f
ffffffffc0206e9c:	92870713          	addi	a4,a4,-1752 # ffffffffc02957c0 <proc_list>
ffffffffc0206ea0:	87a6                	mv	a5,s1
ffffffffc0206ea2:	e79c                	sd	a5,8(a5)
ffffffffc0206ea4:	e39c                	sd	a5,0(a5)
ffffffffc0206ea6:	07c1                	addi	a5,a5,16
ffffffffc0206ea8:	fef71de3          	bne	a4,a5,ffffffffc0206ea2 <proc_init+0x28>
ffffffffc0206eac:	ba1fe0ef          	jal	ra,ffffffffc0205a4c <alloc_proc>
ffffffffc0206eb0:	00090917          	auipc	s2,0x90
ffffffffc0206eb4:	a1890913          	addi	s2,s2,-1512 # ffffffffc02968c8 <idleproc>
ffffffffc0206eb8:	00a93023          	sd	a0,0(s2)
ffffffffc0206ebc:	842a                	mv	s0,a0
ffffffffc0206ebe:	12050863          	beqz	a0,ffffffffc0206fee <proc_init+0x174>
ffffffffc0206ec2:	4789                	li	a5,2
ffffffffc0206ec4:	e11c                	sd	a5,0(a0)
ffffffffc0206ec6:	0000a797          	auipc	a5,0xa
ffffffffc0206eca:	13a78793          	addi	a5,a5,314 # ffffffffc0211000 <bootstack>
ffffffffc0206ece:	e91c                	sd	a5,16(a0)
ffffffffc0206ed0:	4785                	li	a5,1
ffffffffc0206ed2:	ed1c                	sd	a5,24(a0)
ffffffffc0206ed4:	917fe0ef          	jal	ra,ffffffffc02057ea <files_create>
ffffffffc0206ed8:	14a43423          	sd	a0,328(s0)
ffffffffc0206edc:	0e050d63          	beqz	a0,ffffffffc0206fd6 <proc_init+0x15c>
ffffffffc0206ee0:	00093403          	ld	s0,0(s2)
ffffffffc0206ee4:	4641                	li	a2,16
ffffffffc0206ee6:	4581                	li	a1,0
ffffffffc0206ee8:	14843703          	ld	a4,328(s0)
ffffffffc0206eec:	0b440413          	addi	s0,s0,180
ffffffffc0206ef0:	8522                	mv	a0,s0
ffffffffc0206ef2:	4b1c                	lw	a5,16(a4)
ffffffffc0206ef4:	2785                	addiw	a5,a5,1
ffffffffc0206ef6:	cb1c                	sw	a5,16(a4)
ffffffffc0206ef8:	106040ef          	jal	ra,ffffffffc020affe <memset>
ffffffffc0206efc:	463d                	li	a2,15
ffffffffc0206efe:	00007597          	auipc	a1,0x7
ffffffffc0206f02:	96258593          	addi	a1,a1,-1694 # ffffffffc020d860 <CSWTCH.79+0x4b0>
ffffffffc0206f06:	8522                	mv	a0,s0
ffffffffc0206f08:	148040ef          	jal	ra,ffffffffc020b050 <memcpy>
ffffffffc0206f0c:	00090717          	auipc	a4,0x90
ffffffffc0206f10:	9cc70713          	addi	a4,a4,-1588 # ffffffffc02968d8 <nr_process>
ffffffffc0206f14:	431c                	lw	a5,0(a4)
ffffffffc0206f16:	00093683          	ld	a3,0(s2)
ffffffffc0206f1a:	4601                	li	a2,0
ffffffffc0206f1c:	2785                	addiw	a5,a5,1
ffffffffc0206f1e:	4581                	li	a1,0
ffffffffc0206f20:	fffff517          	auipc	a0,0xfffff
ffffffffc0206f24:	48250513          	addi	a0,a0,1154 # ffffffffc02063a2 <init_main>
ffffffffc0206f28:	c31c                	sw	a5,0(a4)
ffffffffc0206f2a:	00090797          	auipc	a5,0x90
ffffffffc0206f2e:	98d7bb23          	sd	a3,-1642(a5) # ffffffffc02968c0 <current>
ffffffffc0206f32:	8ecff0ef          	jal	ra,ffffffffc020601e <kernel_thread>
ffffffffc0206f36:	842a                	mv	s0,a0
ffffffffc0206f38:	08a05363          	blez	a0,ffffffffc0206fbe <proc_init+0x144>
ffffffffc0206f3c:	6789                	lui	a5,0x2
ffffffffc0206f3e:	fff5071b          	addiw	a4,a0,-1
ffffffffc0206f42:	17f9                	addi	a5,a5,-2
ffffffffc0206f44:	2501                	sext.w	a0,a0
ffffffffc0206f46:	02e7e363          	bltu	a5,a4,ffffffffc0206f6c <proc_init+0xf2>
ffffffffc0206f4a:	45a9                	li	a1,10
ffffffffc0206f4c:	598040ef          	jal	ra,ffffffffc020b4e4 <hash32>
ffffffffc0206f50:	02051793          	slli	a5,a0,0x20
ffffffffc0206f54:	01c7d693          	srli	a3,a5,0x1c
ffffffffc0206f58:	96a6                	add	a3,a3,s1
ffffffffc0206f5a:	87b6                	mv	a5,a3
ffffffffc0206f5c:	a029                	j	ffffffffc0206f66 <proc_init+0xec>
ffffffffc0206f5e:	f2c7a703          	lw	a4,-212(a5) # 1f2c <_binary_bin_swap_img_size-0x5dd4>
ffffffffc0206f62:	04870b63          	beq	a4,s0,ffffffffc0206fb8 <proc_init+0x13e>
ffffffffc0206f66:	679c                	ld	a5,8(a5)
ffffffffc0206f68:	fef69be3          	bne	a3,a5,ffffffffc0206f5e <proc_init+0xe4>
ffffffffc0206f6c:	4781                	li	a5,0
ffffffffc0206f6e:	0b478493          	addi	s1,a5,180
ffffffffc0206f72:	4641                	li	a2,16
ffffffffc0206f74:	4581                	li	a1,0
ffffffffc0206f76:	00090417          	auipc	s0,0x90
ffffffffc0206f7a:	95a40413          	addi	s0,s0,-1702 # ffffffffc02968d0 <initproc>
ffffffffc0206f7e:	8526                	mv	a0,s1
ffffffffc0206f80:	e01c                	sd	a5,0(s0)
ffffffffc0206f82:	07c040ef          	jal	ra,ffffffffc020affe <memset>
ffffffffc0206f86:	463d                	li	a2,15
ffffffffc0206f88:	00007597          	auipc	a1,0x7
ffffffffc0206f8c:	90058593          	addi	a1,a1,-1792 # ffffffffc020d888 <CSWTCH.79+0x4d8>
ffffffffc0206f90:	8526                	mv	a0,s1
ffffffffc0206f92:	0be040ef          	jal	ra,ffffffffc020b050 <memcpy>
ffffffffc0206f96:	00093783          	ld	a5,0(s2)
ffffffffc0206f9a:	c7d1                	beqz	a5,ffffffffc0207026 <proc_init+0x1ac>
ffffffffc0206f9c:	43dc                	lw	a5,4(a5)
ffffffffc0206f9e:	e7c1                	bnez	a5,ffffffffc0207026 <proc_init+0x1ac>
ffffffffc0206fa0:	601c                	ld	a5,0(s0)
ffffffffc0206fa2:	c3b5                	beqz	a5,ffffffffc0207006 <proc_init+0x18c>
ffffffffc0206fa4:	43d8                	lw	a4,4(a5)
ffffffffc0206fa6:	4785                	li	a5,1
ffffffffc0206fa8:	04f71f63          	bne	a4,a5,ffffffffc0207006 <proc_init+0x18c>
ffffffffc0206fac:	60e2                	ld	ra,24(sp)
ffffffffc0206fae:	6442                	ld	s0,16(sp)
ffffffffc0206fb0:	64a2                	ld	s1,8(sp)
ffffffffc0206fb2:	6902                	ld	s2,0(sp)
ffffffffc0206fb4:	6105                	addi	sp,sp,32
ffffffffc0206fb6:	8082                	ret
ffffffffc0206fb8:	f2878793          	addi	a5,a5,-216
ffffffffc0206fbc:	bf4d                	j	ffffffffc0206f6e <proc_init+0xf4>
ffffffffc0206fbe:	00007617          	auipc	a2,0x7
ffffffffc0206fc2:	8aa60613          	addi	a2,a2,-1878 # ffffffffc020d868 <CSWTCH.79+0x4b8>
ffffffffc0206fc6:	4dd00593          	li	a1,1245
ffffffffc0206fca:	00006517          	auipc	a0,0x6
ffffffffc0206fce:	4ce50513          	addi	a0,a0,1230 # ffffffffc020d498 <CSWTCH.79+0xe8>
ffffffffc0206fd2:	a5cf90ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0206fd6:	00007617          	auipc	a2,0x7
ffffffffc0206fda:	86260613          	addi	a2,a2,-1950 # ffffffffc020d838 <CSWTCH.79+0x488>
ffffffffc0206fde:	4d100593          	li	a1,1233
ffffffffc0206fe2:	00006517          	auipc	a0,0x6
ffffffffc0206fe6:	4b650513          	addi	a0,a0,1206 # ffffffffc020d498 <CSWTCH.79+0xe8>
ffffffffc0206fea:	a44f90ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0206fee:	00007617          	auipc	a2,0x7
ffffffffc0206ff2:	83260613          	addi	a2,a2,-1998 # ffffffffc020d820 <CSWTCH.79+0x470>
ffffffffc0206ff6:	4c700593          	li	a1,1223
ffffffffc0206ffa:	00006517          	auipc	a0,0x6
ffffffffc0206ffe:	49e50513          	addi	a0,a0,1182 # ffffffffc020d498 <CSWTCH.79+0xe8>
ffffffffc0207002:	a2cf90ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0207006:	00007697          	auipc	a3,0x7
ffffffffc020700a:	8b268693          	addi	a3,a3,-1870 # ffffffffc020d8b8 <CSWTCH.79+0x508>
ffffffffc020700e:	00004617          	auipc	a2,0x4
ffffffffc0207012:	7fa60613          	addi	a2,a2,2042 # ffffffffc020b808 <commands+0x60>
ffffffffc0207016:	4e400593          	li	a1,1252
ffffffffc020701a:	00006517          	auipc	a0,0x6
ffffffffc020701e:	47e50513          	addi	a0,a0,1150 # ffffffffc020d498 <CSWTCH.79+0xe8>
ffffffffc0207022:	a0cf90ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0207026:	00007697          	auipc	a3,0x7
ffffffffc020702a:	86a68693          	addi	a3,a3,-1942 # ffffffffc020d890 <CSWTCH.79+0x4e0>
ffffffffc020702e:	00004617          	auipc	a2,0x4
ffffffffc0207032:	7da60613          	addi	a2,a2,2010 # ffffffffc020b808 <commands+0x60>
ffffffffc0207036:	4e300593          	li	a1,1251
ffffffffc020703a:	00006517          	auipc	a0,0x6
ffffffffc020703e:	45e50513          	addi	a0,a0,1118 # ffffffffc020d498 <CSWTCH.79+0xe8>
ffffffffc0207042:	9ecf90ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0207046 <cpu_idle>:
ffffffffc0207046:	1141                	addi	sp,sp,-16
ffffffffc0207048:	e022                	sd	s0,0(sp)
ffffffffc020704a:	e406                	sd	ra,8(sp)
ffffffffc020704c:	00090417          	auipc	s0,0x90
ffffffffc0207050:	87440413          	addi	s0,s0,-1932 # ffffffffc02968c0 <current>
ffffffffc0207054:	6018                	ld	a4,0(s0)
ffffffffc0207056:	6f1c                	ld	a5,24(a4)
ffffffffc0207058:	dffd                	beqz	a5,ffffffffc0207056 <cpu_idle+0x10>
ffffffffc020705a:	1c8000ef          	jal	ra,ffffffffc0207222 <schedule>
ffffffffc020705e:	bfdd                	j	ffffffffc0207054 <cpu_idle+0xe>

ffffffffc0207060 <lab6_set_priority>:
ffffffffc0207060:	1141                	addi	sp,sp,-16
ffffffffc0207062:	e022                	sd	s0,0(sp)
ffffffffc0207064:	85aa                	mv	a1,a0
ffffffffc0207066:	842a                	mv	s0,a0
ffffffffc0207068:	00007517          	auipc	a0,0x7
ffffffffc020706c:	87850513          	addi	a0,a0,-1928 # ffffffffc020d8e0 <CSWTCH.79+0x530>
ffffffffc0207070:	e406                	sd	ra,8(sp)
ffffffffc0207072:	8b8f90ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0207076:	00090797          	auipc	a5,0x90
ffffffffc020707a:	84a7b783          	ld	a5,-1974(a5) # ffffffffc02968c0 <current>
ffffffffc020707e:	e801                	bnez	s0,ffffffffc020708e <lab6_set_priority+0x2e>
ffffffffc0207080:	60a2                	ld	ra,8(sp)
ffffffffc0207082:	6402                	ld	s0,0(sp)
ffffffffc0207084:	4705                	li	a4,1
ffffffffc0207086:	14e7a223          	sw	a4,324(a5)
ffffffffc020708a:	0141                	addi	sp,sp,16
ffffffffc020708c:	8082                	ret
ffffffffc020708e:	60a2                	ld	ra,8(sp)
ffffffffc0207090:	1487a223          	sw	s0,324(a5)
ffffffffc0207094:	6402                	ld	s0,0(sp)
ffffffffc0207096:	0141                	addi	sp,sp,16
ffffffffc0207098:	8082                	ret

ffffffffc020709a <do_sleep>:
ffffffffc020709a:	c539                	beqz	a0,ffffffffc02070e8 <do_sleep+0x4e>
ffffffffc020709c:	7179                	addi	sp,sp,-48
ffffffffc020709e:	f022                	sd	s0,32(sp)
ffffffffc02070a0:	f406                	sd	ra,40(sp)
ffffffffc02070a2:	842a                	mv	s0,a0
ffffffffc02070a4:	100027f3          	csrr	a5,sstatus
ffffffffc02070a8:	8b89                	andi	a5,a5,2
ffffffffc02070aa:	e3a9                	bnez	a5,ffffffffc02070ec <do_sleep+0x52>
ffffffffc02070ac:	00090797          	auipc	a5,0x90
ffffffffc02070b0:	8147b783          	ld	a5,-2028(a5) # ffffffffc02968c0 <current>
ffffffffc02070b4:	0818                	addi	a4,sp,16
ffffffffc02070b6:	c02a                	sw	a0,0(sp)
ffffffffc02070b8:	ec3a                	sd	a4,24(sp)
ffffffffc02070ba:	e83a                	sd	a4,16(sp)
ffffffffc02070bc:	e43e                	sd	a5,8(sp)
ffffffffc02070be:	4705                	li	a4,1
ffffffffc02070c0:	c398                	sw	a4,0(a5)
ffffffffc02070c2:	80000737          	lui	a4,0x80000
ffffffffc02070c6:	840a                	mv	s0,sp
ffffffffc02070c8:	0709                	addi	a4,a4,2
ffffffffc02070ca:	0ee7a623          	sw	a4,236(a5)
ffffffffc02070ce:	8522                	mv	a0,s0
ffffffffc02070d0:	212000ef          	jal	ra,ffffffffc02072e2 <add_timer>
ffffffffc02070d4:	14e000ef          	jal	ra,ffffffffc0207222 <schedule>
ffffffffc02070d8:	8522                	mv	a0,s0
ffffffffc02070da:	2d0000ef          	jal	ra,ffffffffc02073aa <del_timer>
ffffffffc02070de:	70a2                	ld	ra,40(sp)
ffffffffc02070e0:	7402                	ld	s0,32(sp)
ffffffffc02070e2:	4501                	li	a0,0
ffffffffc02070e4:	6145                	addi	sp,sp,48
ffffffffc02070e6:	8082                	ret
ffffffffc02070e8:	4501                	li	a0,0
ffffffffc02070ea:	8082                	ret
ffffffffc02070ec:	cb9f90ef          	jal	ra,ffffffffc0200da4 <intr_disable>
ffffffffc02070f0:	0008f797          	auipc	a5,0x8f
ffffffffc02070f4:	7d07b783          	ld	a5,2000(a5) # ffffffffc02968c0 <current>
ffffffffc02070f8:	0818                	addi	a4,sp,16
ffffffffc02070fa:	c022                	sw	s0,0(sp)
ffffffffc02070fc:	e43e                	sd	a5,8(sp)
ffffffffc02070fe:	ec3a                	sd	a4,24(sp)
ffffffffc0207100:	e83a                	sd	a4,16(sp)
ffffffffc0207102:	4705                	li	a4,1
ffffffffc0207104:	c398                	sw	a4,0(a5)
ffffffffc0207106:	80000737          	lui	a4,0x80000
ffffffffc020710a:	0709                	addi	a4,a4,2
ffffffffc020710c:	840a                	mv	s0,sp
ffffffffc020710e:	8522                	mv	a0,s0
ffffffffc0207110:	0ee7a623          	sw	a4,236(a5)
ffffffffc0207114:	1ce000ef          	jal	ra,ffffffffc02072e2 <add_timer>
ffffffffc0207118:	c87f90ef          	jal	ra,ffffffffc0200d9e <intr_enable>
ffffffffc020711c:	bf65                	j	ffffffffc02070d4 <do_sleep+0x3a>

ffffffffc020711e <sched_init>:
ffffffffc020711e:	1141                	addi	sp,sp,-16
ffffffffc0207120:	0008a717          	auipc	a4,0x8a
ffffffffc0207124:	f0070713          	addi	a4,a4,-256 # ffffffffc0291020 <default_sched_class>
ffffffffc0207128:	e022                	sd	s0,0(sp)
ffffffffc020712a:	e406                	sd	ra,8(sp)
ffffffffc020712c:	0008e797          	auipc	a5,0x8e
ffffffffc0207130:	6c478793          	addi	a5,a5,1732 # ffffffffc02957f0 <timer_list>
ffffffffc0207134:	6714                	ld	a3,8(a4)
ffffffffc0207136:	0008e517          	auipc	a0,0x8e
ffffffffc020713a:	69a50513          	addi	a0,a0,1690 # ffffffffc02957d0 <__rq>
ffffffffc020713e:	e79c                	sd	a5,8(a5)
ffffffffc0207140:	e39c                	sd	a5,0(a5)
ffffffffc0207142:	4795                	li	a5,5
ffffffffc0207144:	c95c                	sw	a5,20(a0)
ffffffffc0207146:	0008f417          	auipc	s0,0x8f
ffffffffc020714a:	7a240413          	addi	s0,s0,1954 # ffffffffc02968e8 <sched_class>
ffffffffc020714e:	0008f797          	auipc	a5,0x8f
ffffffffc0207152:	78a7b923          	sd	a0,1938(a5) # ffffffffc02968e0 <rq>
ffffffffc0207156:	e018                	sd	a4,0(s0)
ffffffffc0207158:	9682                	jalr	a3
ffffffffc020715a:	601c                	ld	a5,0(s0)
ffffffffc020715c:	6402                	ld	s0,0(sp)
ffffffffc020715e:	60a2                	ld	ra,8(sp)
ffffffffc0207160:	638c                	ld	a1,0(a5)
ffffffffc0207162:	00006517          	auipc	a0,0x6
ffffffffc0207166:	79650513          	addi	a0,a0,1942 # ffffffffc020d8f8 <CSWTCH.79+0x548>
ffffffffc020716a:	0141                	addi	sp,sp,16
ffffffffc020716c:	fbff806f          	j	ffffffffc020012a <cprintf>

ffffffffc0207170 <wakeup_proc>:
ffffffffc0207170:	4118                	lw	a4,0(a0)
ffffffffc0207172:	1101                	addi	sp,sp,-32
ffffffffc0207174:	ec06                	sd	ra,24(sp)
ffffffffc0207176:	e822                	sd	s0,16(sp)
ffffffffc0207178:	e426                	sd	s1,8(sp)
ffffffffc020717a:	478d                	li	a5,3
ffffffffc020717c:	08f70363          	beq	a4,a5,ffffffffc0207202 <wakeup_proc+0x92>
ffffffffc0207180:	842a                	mv	s0,a0
ffffffffc0207182:	100027f3          	csrr	a5,sstatus
ffffffffc0207186:	8b89                	andi	a5,a5,2
ffffffffc0207188:	4481                	li	s1,0
ffffffffc020718a:	e7bd                	bnez	a5,ffffffffc02071f8 <wakeup_proc+0x88>
ffffffffc020718c:	4789                	li	a5,2
ffffffffc020718e:	04f70863          	beq	a4,a5,ffffffffc02071de <wakeup_proc+0x6e>
ffffffffc0207192:	c01c                	sw	a5,0(s0)
ffffffffc0207194:	0e042623          	sw	zero,236(s0)
ffffffffc0207198:	0008f797          	auipc	a5,0x8f
ffffffffc020719c:	7287b783          	ld	a5,1832(a5) # ffffffffc02968c0 <current>
ffffffffc02071a0:	02878363          	beq	a5,s0,ffffffffc02071c6 <wakeup_proc+0x56>
ffffffffc02071a4:	0008f797          	auipc	a5,0x8f
ffffffffc02071a8:	7247b783          	ld	a5,1828(a5) # ffffffffc02968c8 <idleproc>
ffffffffc02071ac:	00f40d63          	beq	s0,a5,ffffffffc02071c6 <wakeup_proc+0x56>
ffffffffc02071b0:	0008f797          	auipc	a5,0x8f
ffffffffc02071b4:	7387b783          	ld	a5,1848(a5) # ffffffffc02968e8 <sched_class>
ffffffffc02071b8:	6b9c                	ld	a5,16(a5)
ffffffffc02071ba:	85a2                	mv	a1,s0
ffffffffc02071bc:	0008f517          	auipc	a0,0x8f
ffffffffc02071c0:	72453503          	ld	a0,1828(a0) # ffffffffc02968e0 <rq>
ffffffffc02071c4:	9782                	jalr	a5
ffffffffc02071c6:	e491                	bnez	s1,ffffffffc02071d2 <wakeup_proc+0x62>
ffffffffc02071c8:	60e2                	ld	ra,24(sp)
ffffffffc02071ca:	6442                	ld	s0,16(sp)
ffffffffc02071cc:	64a2                	ld	s1,8(sp)
ffffffffc02071ce:	6105                	addi	sp,sp,32
ffffffffc02071d0:	8082                	ret
ffffffffc02071d2:	6442                	ld	s0,16(sp)
ffffffffc02071d4:	60e2                	ld	ra,24(sp)
ffffffffc02071d6:	64a2                	ld	s1,8(sp)
ffffffffc02071d8:	6105                	addi	sp,sp,32
ffffffffc02071da:	bc5f906f          	j	ffffffffc0200d9e <intr_enable>
ffffffffc02071de:	00006617          	auipc	a2,0x6
ffffffffc02071e2:	76a60613          	addi	a2,a2,1898 # ffffffffc020d948 <CSWTCH.79+0x598>
ffffffffc02071e6:	05200593          	li	a1,82
ffffffffc02071ea:	00006517          	auipc	a0,0x6
ffffffffc02071ee:	74650513          	addi	a0,a0,1862 # ffffffffc020d930 <CSWTCH.79+0x580>
ffffffffc02071f2:	8a4f90ef          	jal	ra,ffffffffc0200296 <__warn>
ffffffffc02071f6:	bfc1                	j	ffffffffc02071c6 <wakeup_proc+0x56>
ffffffffc02071f8:	badf90ef          	jal	ra,ffffffffc0200da4 <intr_disable>
ffffffffc02071fc:	4018                	lw	a4,0(s0)
ffffffffc02071fe:	4485                	li	s1,1
ffffffffc0207200:	b771                	j	ffffffffc020718c <wakeup_proc+0x1c>
ffffffffc0207202:	00006697          	auipc	a3,0x6
ffffffffc0207206:	70e68693          	addi	a3,a3,1806 # ffffffffc020d910 <CSWTCH.79+0x560>
ffffffffc020720a:	00004617          	auipc	a2,0x4
ffffffffc020720e:	5fe60613          	addi	a2,a2,1534 # ffffffffc020b808 <commands+0x60>
ffffffffc0207212:	04300593          	li	a1,67
ffffffffc0207216:	00006517          	auipc	a0,0x6
ffffffffc020721a:	71a50513          	addi	a0,a0,1818 # ffffffffc020d930 <CSWTCH.79+0x580>
ffffffffc020721e:	810f90ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0207222 <schedule>:
ffffffffc0207222:	7179                	addi	sp,sp,-48
ffffffffc0207224:	f406                	sd	ra,40(sp)
ffffffffc0207226:	f022                	sd	s0,32(sp)
ffffffffc0207228:	ec26                	sd	s1,24(sp)
ffffffffc020722a:	e84a                	sd	s2,16(sp)
ffffffffc020722c:	e44e                	sd	s3,8(sp)
ffffffffc020722e:	e052                	sd	s4,0(sp)
ffffffffc0207230:	100027f3          	csrr	a5,sstatus
ffffffffc0207234:	8b89                	andi	a5,a5,2
ffffffffc0207236:	4a01                	li	s4,0
ffffffffc0207238:	e3cd                	bnez	a5,ffffffffc02072da <schedule+0xb8>
ffffffffc020723a:	0008f497          	auipc	s1,0x8f
ffffffffc020723e:	68648493          	addi	s1,s1,1670 # ffffffffc02968c0 <current>
ffffffffc0207242:	608c                	ld	a1,0(s1)
ffffffffc0207244:	0008f997          	auipc	s3,0x8f
ffffffffc0207248:	6a498993          	addi	s3,s3,1700 # ffffffffc02968e8 <sched_class>
ffffffffc020724c:	0008f917          	auipc	s2,0x8f
ffffffffc0207250:	69490913          	addi	s2,s2,1684 # ffffffffc02968e0 <rq>
ffffffffc0207254:	4194                	lw	a3,0(a1)
ffffffffc0207256:	0005bc23          	sd	zero,24(a1)
ffffffffc020725a:	4709                	li	a4,2
ffffffffc020725c:	0009b783          	ld	a5,0(s3)
ffffffffc0207260:	00093503          	ld	a0,0(s2)
ffffffffc0207264:	04e68e63          	beq	a3,a4,ffffffffc02072c0 <schedule+0x9e>
ffffffffc0207268:	739c                	ld	a5,32(a5)
ffffffffc020726a:	9782                	jalr	a5
ffffffffc020726c:	842a                	mv	s0,a0
ffffffffc020726e:	c521                	beqz	a0,ffffffffc02072b6 <schedule+0x94>
ffffffffc0207270:	0009b783          	ld	a5,0(s3)
ffffffffc0207274:	00093503          	ld	a0,0(s2)
ffffffffc0207278:	85a2                	mv	a1,s0
ffffffffc020727a:	6f9c                	ld	a5,24(a5)
ffffffffc020727c:	9782                	jalr	a5
ffffffffc020727e:	441c                	lw	a5,8(s0)
ffffffffc0207280:	6098                	ld	a4,0(s1)
ffffffffc0207282:	2785                	addiw	a5,a5,1
ffffffffc0207284:	c41c                	sw	a5,8(s0)
ffffffffc0207286:	00870563          	beq	a4,s0,ffffffffc0207290 <schedule+0x6e>
ffffffffc020728a:	8522                	mv	a0,s0
ffffffffc020728c:	8dffe0ef          	jal	ra,ffffffffc0205b6a <proc_run>
ffffffffc0207290:	000a1a63          	bnez	s4,ffffffffc02072a4 <schedule+0x82>
ffffffffc0207294:	70a2                	ld	ra,40(sp)
ffffffffc0207296:	7402                	ld	s0,32(sp)
ffffffffc0207298:	64e2                	ld	s1,24(sp)
ffffffffc020729a:	6942                	ld	s2,16(sp)
ffffffffc020729c:	69a2                	ld	s3,8(sp)
ffffffffc020729e:	6a02                	ld	s4,0(sp)
ffffffffc02072a0:	6145                	addi	sp,sp,48
ffffffffc02072a2:	8082                	ret
ffffffffc02072a4:	7402                	ld	s0,32(sp)
ffffffffc02072a6:	70a2                	ld	ra,40(sp)
ffffffffc02072a8:	64e2                	ld	s1,24(sp)
ffffffffc02072aa:	6942                	ld	s2,16(sp)
ffffffffc02072ac:	69a2                	ld	s3,8(sp)
ffffffffc02072ae:	6a02                	ld	s4,0(sp)
ffffffffc02072b0:	6145                	addi	sp,sp,48
ffffffffc02072b2:	aedf906f          	j	ffffffffc0200d9e <intr_enable>
ffffffffc02072b6:	0008f417          	auipc	s0,0x8f
ffffffffc02072ba:	61243403          	ld	s0,1554(s0) # ffffffffc02968c8 <idleproc>
ffffffffc02072be:	b7c1                	j	ffffffffc020727e <schedule+0x5c>
ffffffffc02072c0:	0008f717          	auipc	a4,0x8f
ffffffffc02072c4:	60873703          	ld	a4,1544(a4) # ffffffffc02968c8 <idleproc>
ffffffffc02072c8:	fae580e3          	beq	a1,a4,ffffffffc0207268 <schedule+0x46>
ffffffffc02072cc:	6b9c                	ld	a5,16(a5)
ffffffffc02072ce:	9782                	jalr	a5
ffffffffc02072d0:	0009b783          	ld	a5,0(s3)
ffffffffc02072d4:	00093503          	ld	a0,0(s2)
ffffffffc02072d8:	bf41                	j	ffffffffc0207268 <schedule+0x46>
ffffffffc02072da:	acbf90ef          	jal	ra,ffffffffc0200da4 <intr_disable>
ffffffffc02072de:	4a05                	li	s4,1
ffffffffc02072e0:	bfa9                	j	ffffffffc020723a <schedule+0x18>

ffffffffc02072e2 <add_timer>:
ffffffffc02072e2:	1141                	addi	sp,sp,-16
ffffffffc02072e4:	e022                	sd	s0,0(sp)
ffffffffc02072e6:	e406                	sd	ra,8(sp)
ffffffffc02072e8:	842a                	mv	s0,a0
ffffffffc02072ea:	100027f3          	csrr	a5,sstatus
ffffffffc02072ee:	8b89                	andi	a5,a5,2
ffffffffc02072f0:	4501                	li	a0,0
ffffffffc02072f2:	eba5                	bnez	a5,ffffffffc0207362 <add_timer+0x80>
ffffffffc02072f4:	401c                	lw	a5,0(s0)
ffffffffc02072f6:	cbb5                	beqz	a5,ffffffffc020736a <add_timer+0x88>
ffffffffc02072f8:	6418                	ld	a4,8(s0)
ffffffffc02072fa:	cb25                	beqz	a4,ffffffffc020736a <add_timer+0x88>
ffffffffc02072fc:	6c18                	ld	a4,24(s0)
ffffffffc02072fe:	01040593          	addi	a1,s0,16
ffffffffc0207302:	08e59463          	bne	a1,a4,ffffffffc020738a <add_timer+0xa8>
ffffffffc0207306:	0008e617          	auipc	a2,0x8e
ffffffffc020730a:	4ea60613          	addi	a2,a2,1258 # ffffffffc02957f0 <timer_list>
ffffffffc020730e:	6618                	ld	a4,8(a2)
ffffffffc0207310:	00c71863          	bne	a4,a2,ffffffffc0207320 <add_timer+0x3e>
ffffffffc0207314:	a80d                	j	ffffffffc0207346 <add_timer+0x64>
ffffffffc0207316:	6718                	ld	a4,8(a4)
ffffffffc0207318:	9f95                	subw	a5,a5,a3
ffffffffc020731a:	c01c                	sw	a5,0(s0)
ffffffffc020731c:	02c70563          	beq	a4,a2,ffffffffc0207346 <add_timer+0x64>
ffffffffc0207320:	ff072683          	lw	a3,-16(a4)
ffffffffc0207324:	fed7f9e3          	bgeu	a5,a3,ffffffffc0207316 <add_timer+0x34>
ffffffffc0207328:	40f687bb          	subw	a5,a3,a5
ffffffffc020732c:	fef72823          	sw	a5,-16(a4)
ffffffffc0207330:	631c                	ld	a5,0(a4)
ffffffffc0207332:	e30c                	sd	a1,0(a4)
ffffffffc0207334:	e78c                	sd	a1,8(a5)
ffffffffc0207336:	ec18                	sd	a4,24(s0)
ffffffffc0207338:	e81c                	sd	a5,16(s0)
ffffffffc020733a:	c105                	beqz	a0,ffffffffc020735a <add_timer+0x78>
ffffffffc020733c:	6402                	ld	s0,0(sp)
ffffffffc020733e:	60a2                	ld	ra,8(sp)
ffffffffc0207340:	0141                	addi	sp,sp,16
ffffffffc0207342:	a5df906f          	j	ffffffffc0200d9e <intr_enable>
ffffffffc0207346:	0008e717          	auipc	a4,0x8e
ffffffffc020734a:	4aa70713          	addi	a4,a4,1194 # ffffffffc02957f0 <timer_list>
ffffffffc020734e:	631c                	ld	a5,0(a4)
ffffffffc0207350:	e30c                	sd	a1,0(a4)
ffffffffc0207352:	e78c                	sd	a1,8(a5)
ffffffffc0207354:	ec18                	sd	a4,24(s0)
ffffffffc0207356:	e81c                	sd	a5,16(s0)
ffffffffc0207358:	f175                	bnez	a0,ffffffffc020733c <add_timer+0x5a>
ffffffffc020735a:	60a2                	ld	ra,8(sp)
ffffffffc020735c:	6402                	ld	s0,0(sp)
ffffffffc020735e:	0141                	addi	sp,sp,16
ffffffffc0207360:	8082                	ret
ffffffffc0207362:	a43f90ef          	jal	ra,ffffffffc0200da4 <intr_disable>
ffffffffc0207366:	4505                	li	a0,1
ffffffffc0207368:	b771                	j	ffffffffc02072f4 <add_timer+0x12>
ffffffffc020736a:	00006697          	auipc	a3,0x6
ffffffffc020736e:	5fe68693          	addi	a3,a3,1534 # ffffffffc020d968 <CSWTCH.79+0x5b8>
ffffffffc0207372:	00004617          	auipc	a2,0x4
ffffffffc0207376:	49660613          	addi	a2,a2,1174 # ffffffffc020b808 <commands+0x60>
ffffffffc020737a:	07a00593          	li	a1,122
ffffffffc020737e:	00006517          	auipc	a0,0x6
ffffffffc0207382:	5b250513          	addi	a0,a0,1458 # ffffffffc020d930 <CSWTCH.79+0x580>
ffffffffc0207386:	ea9f80ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020738a:	00006697          	auipc	a3,0x6
ffffffffc020738e:	60e68693          	addi	a3,a3,1550 # ffffffffc020d998 <CSWTCH.79+0x5e8>
ffffffffc0207392:	00004617          	auipc	a2,0x4
ffffffffc0207396:	47660613          	addi	a2,a2,1142 # ffffffffc020b808 <commands+0x60>
ffffffffc020739a:	07b00593          	li	a1,123
ffffffffc020739e:	00006517          	auipc	a0,0x6
ffffffffc02073a2:	59250513          	addi	a0,a0,1426 # ffffffffc020d930 <CSWTCH.79+0x580>
ffffffffc02073a6:	e89f80ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02073aa <del_timer>:
ffffffffc02073aa:	1101                	addi	sp,sp,-32
ffffffffc02073ac:	e822                	sd	s0,16(sp)
ffffffffc02073ae:	ec06                	sd	ra,24(sp)
ffffffffc02073b0:	e426                	sd	s1,8(sp)
ffffffffc02073b2:	842a                	mv	s0,a0
ffffffffc02073b4:	100027f3          	csrr	a5,sstatus
ffffffffc02073b8:	8b89                	andi	a5,a5,2
ffffffffc02073ba:	01050493          	addi	s1,a0,16
ffffffffc02073be:	eb9d                	bnez	a5,ffffffffc02073f4 <del_timer+0x4a>
ffffffffc02073c0:	6d1c                	ld	a5,24(a0)
ffffffffc02073c2:	02978463          	beq	a5,s1,ffffffffc02073ea <del_timer+0x40>
ffffffffc02073c6:	4114                	lw	a3,0(a0)
ffffffffc02073c8:	6918                	ld	a4,16(a0)
ffffffffc02073ca:	ce81                	beqz	a3,ffffffffc02073e2 <del_timer+0x38>
ffffffffc02073cc:	0008e617          	auipc	a2,0x8e
ffffffffc02073d0:	42460613          	addi	a2,a2,1060 # ffffffffc02957f0 <timer_list>
ffffffffc02073d4:	00c78763          	beq	a5,a2,ffffffffc02073e2 <del_timer+0x38>
ffffffffc02073d8:	ff07a603          	lw	a2,-16(a5)
ffffffffc02073dc:	9eb1                	addw	a3,a3,a2
ffffffffc02073de:	fed7a823          	sw	a3,-16(a5)
ffffffffc02073e2:	e71c                	sd	a5,8(a4)
ffffffffc02073e4:	e398                	sd	a4,0(a5)
ffffffffc02073e6:	ec04                	sd	s1,24(s0)
ffffffffc02073e8:	e804                	sd	s1,16(s0)
ffffffffc02073ea:	60e2                	ld	ra,24(sp)
ffffffffc02073ec:	6442                	ld	s0,16(sp)
ffffffffc02073ee:	64a2                	ld	s1,8(sp)
ffffffffc02073f0:	6105                	addi	sp,sp,32
ffffffffc02073f2:	8082                	ret
ffffffffc02073f4:	9b1f90ef          	jal	ra,ffffffffc0200da4 <intr_disable>
ffffffffc02073f8:	6c1c                	ld	a5,24(s0)
ffffffffc02073fa:	02978463          	beq	a5,s1,ffffffffc0207422 <del_timer+0x78>
ffffffffc02073fe:	4014                	lw	a3,0(s0)
ffffffffc0207400:	6818                	ld	a4,16(s0)
ffffffffc0207402:	ce81                	beqz	a3,ffffffffc020741a <del_timer+0x70>
ffffffffc0207404:	0008e617          	auipc	a2,0x8e
ffffffffc0207408:	3ec60613          	addi	a2,a2,1004 # ffffffffc02957f0 <timer_list>
ffffffffc020740c:	00c78763          	beq	a5,a2,ffffffffc020741a <del_timer+0x70>
ffffffffc0207410:	ff07a603          	lw	a2,-16(a5)
ffffffffc0207414:	9eb1                	addw	a3,a3,a2
ffffffffc0207416:	fed7a823          	sw	a3,-16(a5)
ffffffffc020741a:	e71c                	sd	a5,8(a4)
ffffffffc020741c:	e398                	sd	a4,0(a5)
ffffffffc020741e:	ec04                	sd	s1,24(s0)
ffffffffc0207420:	e804                	sd	s1,16(s0)
ffffffffc0207422:	6442                	ld	s0,16(sp)
ffffffffc0207424:	60e2                	ld	ra,24(sp)
ffffffffc0207426:	64a2                	ld	s1,8(sp)
ffffffffc0207428:	6105                	addi	sp,sp,32
ffffffffc020742a:	975f906f          	j	ffffffffc0200d9e <intr_enable>

ffffffffc020742e <run_timer_list>:
ffffffffc020742e:	7139                	addi	sp,sp,-64
ffffffffc0207430:	fc06                	sd	ra,56(sp)
ffffffffc0207432:	f822                	sd	s0,48(sp)
ffffffffc0207434:	f426                	sd	s1,40(sp)
ffffffffc0207436:	f04a                	sd	s2,32(sp)
ffffffffc0207438:	ec4e                	sd	s3,24(sp)
ffffffffc020743a:	e852                	sd	s4,16(sp)
ffffffffc020743c:	e456                	sd	s5,8(sp)
ffffffffc020743e:	e05a                	sd	s6,0(sp)
ffffffffc0207440:	100027f3          	csrr	a5,sstatus
ffffffffc0207444:	8b89                	andi	a5,a5,2
ffffffffc0207446:	4b01                	li	s6,0
ffffffffc0207448:	efe9                	bnez	a5,ffffffffc0207522 <run_timer_list+0xf4>
ffffffffc020744a:	0008e997          	auipc	s3,0x8e
ffffffffc020744e:	3a698993          	addi	s3,s3,934 # ffffffffc02957f0 <timer_list>
ffffffffc0207452:	0089b403          	ld	s0,8(s3)
ffffffffc0207456:	07340a63          	beq	s0,s3,ffffffffc02074ca <run_timer_list+0x9c>
ffffffffc020745a:	ff042783          	lw	a5,-16(s0)
ffffffffc020745e:	ff040913          	addi	s2,s0,-16
ffffffffc0207462:	0e078763          	beqz	a5,ffffffffc0207550 <run_timer_list+0x122>
ffffffffc0207466:	fff7871b          	addiw	a4,a5,-1
ffffffffc020746a:	fee42823          	sw	a4,-16(s0)
ffffffffc020746e:	ef31                	bnez	a4,ffffffffc02074ca <run_timer_list+0x9c>
ffffffffc0207470:	00006a97          	auipc	s5,0x6
ffffffffc0207474:	590a8a93          	addi	s5,s5,1424 # ffffffffc020da00 <CSWTCH.79+0x650>
ffffffffc0207478:	00006a17          	auipc	s4,0x6
ffffffffc020747c:	4b8a0a13          	addi	s4,s4,1208 # ffffffffc020d930 <CSWTCH.79+0x580>
ffffffffc0207480:	a005                	j	ffffffffc02074a0 <run_timer_list+0x72>
ffffffffc0207482:	0a07d763          	bgez	a5,ffffffffc0207530 <run_timer_list+0x102>
ffffffffc0207486:	8526                	mv	a0,s1
ffffffffc0207488:	ce9ff0ef          	jal	ra,ffffffffc0207170 <wakeup_proc>
ffffffffc020748c:	854a                	mv	a0,s2
ffffffffc020748e:	f1dff0ef          	jal	ra,ffffffffc02073aa <del_timer>
ffffffffc0207492:	03340c63          	beq	s0,s3,ffffffffc02074ca <run_timer_list+0x9c>
ffffffffc0207496:	ff042783          	lw	a5,-16(s0)
ffffffffc020749a:	ff040913          	addi	s2,s0,-16
ffffffffc020749e:	e795                	bnez	a5,ffffffffc02074ca <run_timer_list+0x9c>
ffffffffc02074a0:	00893483          	ld	s1,8(s2)
ffffffffc02074a4:	6400                	ld	s0,8(s0)
ffffffffc02074a6:	0ec4a783          	lw	a5,236(s1)
ffffffffc02074aa:	ffe1                	bnez	a5,ffffffffc0207482 <run_timer_list+0x54>
ffffffffc02074ac:	40d4                	lw	a3,4(s1)
ffffffffc02074ae:	8656                	mv	a2,s5
ffffffffc02074b0:	0ba00593          	li	a1,186
ffffffffc02074b4:	8552                	mv	a0,s4
ffffffffc02074b6:	de1f80ef          	jal	ra,ffffffffc0200296 <__warn>
ffffffffc02074ba:	8526                	mv	a0,s1
ffffffffc02074bc:	cb5ff0ef          	jal	ra,ffffffffc0207170 <wakeup_proc>
ffffffffc02074c0:	854a                	mv	a0,s2
ffffffffc02074c2:	ee9ff0ef          	jal	ra,ffffffffc02073aa <del_timer>
ffffffffc02074c6:	fd3418e3          	bne	s0,s3,ffffffffc0207496 <run_timer_list+0x68>
ffffffffc02074ca:	0008f597          	auipc	a1,0x8f
ffffffffc02074ce:	3f65b583          	ld	a1,1014(a1) # ffffffffc02968c0 <current>
ffffffffc02074d2:	c18d                	beqz	a1,ffffffffc02074f4 <run_timer_list+0xc6>
ffffffffc02074d4:	0008f797          	auipc	a5,0x8f
ffffffffc02074d8:	3f47b783          	ld	a5,1012(a5) # ffffffffc02968c8 <idleproc>
ffffffffc02074dc:	04f58763          	beq	a1,a5,ffffffffc020752a <run_timer_list+0xfc>
ffffffffc02074e0:	0008f797          	auipc	a5,0x8f
ffffffffc02074e4:	4087b783          	ld	a5,1032(a5) # ffffffffc02968e8 <sched_class>
ffffffffc02074e8:	779c                	ld	a5,40(a5)
ffffffffc02074ea:	0008f517          	auipc	a0,0x8f
ffffffffc02074ee:	3f653503          	ld	a0,1014(a0) # ffffffffc02968e0 <rq>
ffffffffc02074f2:	9782                	jalr	a5
ffffffffc02074f4:	000b1c63          	bnez	s6,ffffffffc020750c <run_timer_list+0xde>
ffffffffc02074f8:	70e2                	ld	ra,56(sp)
ffffffffc02074fa:	7442                	ld	s0,48(sp)
ffffffffc02074fc:	74a2                	ld	s1,40(sp)
ffffffffc02074fe:	7902                	ld	s2,32(sp)
ffffffffc0207500:	69e2                	ld	s3,24(sp)
ffffffffc0207502:	6a42                	ld	s4,16(sp)
ffffffffc0207504:	6aa2                	ld	s5,8(sp)
ffffffffc0207506:	6b02                	ld	s6,0(sp)
ffffffffc0207508:	6121                	addi	sp,sp,64
ffffffffc020750a:	8082                	ret
ffffffffc020750c:	7442                	ld	s0,48(sp)
ffffffffc020750e:	70e2                	ld	ra,56(sp)
ffffffffc0207510:	74a2                	ld	s1,40(sp)
ffffffffc0207512:	7902                	ld	s2,32(sp)
ffffffffc0207514:	69e2                	ld	s3,24(sp)
ffffffffc0207516:	6a42                	ld	s4,16(sp)
ffffffffc0207518:	6aa2                	ld	s5,8(sp)
ffffffffc020751a:	6b02                	ld	s6,0(sp)
ffffffffc020751c:	6121                	addi	sp,sp,64
ffffffffc020751e:	881f906f          	j	ffffffffc0200d9e <intr_enable>
ffffffffc0207522:	883f90ef          	jal	ra,ffffffffc0200da4 <intr_disable>
ffffffffc0207526:	4b05                	li	s6,1
ffffffffc0207528:	b70d                	j	ffffffffc020744a <run_timer_list+0x1c>
ffffffffc020752a:	4785                	li	a5,1
ffffffffc020752c:	ed9c                	sd	a5,24(a1)
ffffffffc020752e:	b7d9                	j	ffffffffc02074f4 <run_timer_list+0xc6>
ffffffffc0207530:	00006697          	auipc	a3,0x6
ffffffffc0207534:	4a868693          	addi	a3,a3,1192 # ffffffffc020d9d8 <CSWTCH.79+0x628>
ffffffffc0207538:	00004617          	auipc	a2,0x4
ffffffffc020753c:	2d060613          	addi	a2,a2,720 # ffffffffc020b808 <commands+0x60>
ffffffffc0207540:	0b600593          	li	a1,182
ffffffffc0207544:	00006517          	auipc	a0,0x6
ffffffffc0207548:	3ec50513          	addi	a0,a0,1004 # ffffffffc020d930 <CSWTCH.79+0x580>
ffffffffc020754c:	ce3f80ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0207550:	00006697          	auipc	a3,0x6
ffffffffc0207554:	47068693          	addi	a3,a3,1136 # ffffffffc020d9c0 <CSWTCH.79+0x610>
ffffffffc0207558:	00004617          	auipc	a2,0x4
ffffffffc020755c:	2b060613          	addi	a2,a2,688 # ffffffffc020b808 <commands+0x60>
ffffffffc0207560:	0ae00593          	li	a1,174
ffffffffc0207564:	00006517          	auipc	a0,0x6
ffffffffc0207568:	3cc50513          	addi	a0,a0,972 # ffffffffc020d930 <CSWTCH.79+0x580>
ffffffffc020756c:	cc3f80ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0207570 <RR_init>:
ffffffffc0207570:	e508                	sd	a0,8(a0)
ffffffffc0207572:	e108                	sd	a0,0(a0)
ffffffffc0207574:	00052823          	sw	zero,16(a0)
ffffffffc0207578:	8082                	ret

ffffffffc020757a <RR_pick_next>:
ffffffffc020757a:	651c                	ld	a5,8(a0)
ffffffffc020757c:	00f50563          	beq	a0,a5,ffffffffc0207586 <RR_pick_next+0xc>
ffffffffc0207580:	ef078513          	addi	a0,a5,-272
ffffffffc0207584:	8082                	ret
ffffffffc0207586:	4501                	li	a0,0
ffffffffc0207588:	8082                	ret

ffffffffc020758a <RR_proc_tick>:
ffffffffc020758a:	1205a783          	lw	a5,288(a1)
ffffffffc020758e:	00f05563          	blez	a5,ffffffffc0207598 <RR_proc_tick+0xe>
ffffffffc0207592:	37fd                	addiw	a5,a5,-1
ffffffffc0207594:	12f5a023          	sw	a5,288(a1)
ffffffffc0207598:	e399                	bnez	a5,ffffffffc020759e <RR_proc_tick+0x14>
ffffffffc020759a:	4785                	li	a5,1
ffffffffc020759c:	ed9c                	sd	a5,24(a1)
ffffffffc020759e:	8082                	ret

ffffffffc02075a0 <RR_dequeue>:
ffffffffc02075a0:	1185b703          	ld	a4,280(a1)
ffffffffc02075a4:	11058793          	addi	a5,a1,272
ffffffffc02075a8:	02e78363          	beq	a5,a4,ffffffffc02075ce <RR_dequeue+0x2e>
ffffffffc02075ac:	1085b683          	ld	a3,264(a1)
ffffffffc02075b0:	00a69f63          	bne	a3,a0,ffffffffc02075ce <RR_dequeue+0x2e>
ffffffffc02075b4:	1105b503          	ld	a0,272(a1)
ffffffffc02075b8:	4a90                	lw	a2,16(a3)
ffffffffc02075ba:	e518                	sd	a4,8(a0)
ffffffffc02075bc:	e308                	sd	a0,0(a4)
ffffffffc02075be:	10f5bc23          	sd	a5,280(a1)
ffffffffc02075c2:	10f5b823          	sd	a5,272(a1)
ffffffffc02075c6:	fff6079b          	addiw	a5,a2,-1
ffffffffc02075ca:	ca9c                	sw	a5,16(a3)
ffffffffc02075cc:	8082                	ret
ffffffffc02075ce:	1141                	addi	sp,sp,-16
ffffffffc02075d0:	00006697          	auipc	a3,0x6
ffffffffc02075d4:	45068693          	addi	a3,a3,1104 # ffffffffc020da20 <CSWTCH.79+0x670>
ffffffffc02075d8:	00004617          	auipc	a2,0x4
ffffffffc02075dc:	23060613          	addi	a2,a2,560 # ffffffffc020b808 <commands+0x60>
ffffffffc02075e0:	03c00593          	li	a1,60
ffffffffc02075e4:	00006517          	auipc	a0,0x6
ffffffffc02075e8:	47450513          	addi	a0,a0,1140 # ffffffffc020da58 <CSWTCH.79+0x6a8>
ffffffffc02075ec:	e406                	sd	ra,8(sp)
ffffffffc02075ee:	c41f80ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02075f2 <RR_enqueue>:
ffffffffc02075f2:	1185b703          	ld	a4,280(a1)
ffffffffc02075f6:	11058793          	addi	a5,a1,272
ffffffffc02075fa:	02e79d63          	bne	a5,a4,ffffffffc0207634 <RR_enqueue+0x42>
ffffffffc02075fe:	6118                	ld	a4,0(a0)
ffffffffc0207600:	1205a683          	lw	a3,288(a1)
ffffffffc0207604:	e11c                	sd	a5,0(a0)
ffffffffc0207606:	e71c                	sd	a5,8(a4)
ffffffffc0207608:	10a5bc23          	sd	a0,280(a1)
ffffffffc020760c:	10e5b823          	sd	a4,272(a1)
ffffffffc0207610:	495c                	lw	a5,20(a0)
ffffffffc0207612:	ea89                	bnez	a3,ffffffffc0207624 <RR_enqueue+0x32>
ffffffffc0207614:	12f5a023          	sw	a5,288(a1)
ffffffffc0207618:	491c                	lw	a5,16(a0)
ffffffffc020761a:	10a5b423          	sd	a0,264(a1)
ffffffffc020761e:	2785                	addiw	a5,a5,1
ffffffffc0207620:	c91c                	sw	a5,16(a0)
ffffffffc0207622:	8082                	ret
ffffffffc0207624:	fed7c8e3          	blt	a5,a3,ffffffffc0207614 <RR_enqueue+0x22>
ffffffffc0207628:	491c                	lw	a5,16(a0)
ffffffffc020762a:	10a5b423          	sd	a0,264(a1)
ffffffffc020762e:	2785                	addiw	a5,a5,1
ffffffffc0207630:	c91c                	sw	a5,16(a0)
ffffffffc0207632:	8082                	ret
ffffffffc0207634:	1141                	addi	sp,sp,-16
ffffffffc0207636:	00006697          	auipc	a3,0x6
ffffffffc020763a:	44268693          	addi	a3,a3,1090 # ffffffffc020da78 <CSWTCH.79+0x6c8>
ffffffffc020763e:	00004617          	auipc	a2,0x4
ffffffffc0207642:	1ca60613          	addi	a2,a2,458 # ffffffffc020b808 <commands+0x60>
ffffffffc0207646:	02800593          	li	a1,40
ffffffffc020764a:	00006517          	auipc	a0,0x6
ffffffffc020764e:	40e50513          	addi	a0,a0,1038 # ffffffffc020da58 <CSWTCH.79+0x6a8>
ffffffffc0207652:	e406                	sd	ra,8(sp)
ffffffffc0207654:	bdbf80ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0207658 <sys_getpid>:
ffffffffc0207658:	0008f797          	auipc	a5,0x8f
ffffffffc020765c:	2687b783          	ld	a5,616(a5) # ffffffffc02968c0 <current>
ffffffffc0207660:	43c8                	lw	a0,4(a5)
ffffffffc0207662:	8082                	ret

ffffffffc0207664 <sys_pgdir>:
ffffffffc0207664:	4501                	li	a0,0
ffffffffc0207666:	8082                	ret

ffffffffc0207668 <sys_gettime>:
ffffffffc0207668:	0008f797          	auipc	a5,0x8f
ffffffffc020766c:	2087b783          	ld	a5,520(a5) # ffffffffc0296870 <ticks>
ffffffffc0207670:	0027951b          	slliw	a0,a5,0x2
ffffffffc0207674:	9d3d                	addw	a0,a0,a5
ffffffffc0207676:	0015151b          	slliw	a0,a0,0x1
ffffffffc020767a:	8082                	ret

ffffffffc020767c <sys_lab6_set_priority>:
ffffffffc020767c:	4108                	lw	a0,0(a0)
ffffffffc020767e:	1141                	addi	sp,sp,-16
ffffffffc0207680:	e406                	sd	ra,8(sp)
ffffffffc0207682:	9dfff0ef          	jal	ra,ffffffffc0207060 <lab6_set_priority>
ffffffffc0207686:	60a2                	ld	ra,8(sp)
ffffffffc0207688:	4501                	li	a0,0
ffffffffc020768a:	0141                	addi	sp,sp,16
ffffffffc020768c:	8082                	ret

ffffffffc020768e <sys_dup>:
ffffffffc020768e:	450c                	lw	a1,8(a0)
ffffffffc0207690:	4108                	lw	a0,0(a0)
ffffffffc0207692:	e3efd06f          	j	ffffffffc0204cd0 <sysfile_dup>

ffffffffc0207696 <sys_getdirentry>:
ffffffffc0207696:	650c                	ld	a1,8(a0)
ffffffffc0207698:	4108                	lw	a0,0(a0)
ffffffffc020769a:	d46fd06f          	j	ffffffffc0204be0 <sysfile_getdirentry>

ffffffffc020769e <sys_getcwd>:
ffffffffc020769e:	650c                	ld	a1,8(a0)
ffffffffc02076a0:	6108                	ld	a0,0(a0)
ffffffffc02076a2:	c9afd06f          	j	ffffffffc0204b3c <sysfile_getcwd>

ffffffffc02076a6 <sys_fsync>:
ffffffffc02076a6:	4108                	lw	a0,0(a0)
ffffffffc02076a8:	c90fd06f          	j	ffffffffc0204b38 <sysfile_fsync>

ffffffffc02076ac <sys_fstat>:
ffffffffc02076ac:	650c                	ld	a1,8(a0)
ffffffffc02076ae:	4108                	lw	a0,0(a0)
ffffffffc02076b0:	be8fd06f          	j	ffffffffc0204a98 <sysfile_fstat>

ffffffffc02076b4 <sys_seek>:
ffffffffc02076b4:	4910                	lw	a2,16(a0)
ffffffffc02076b6:	650c                	ld	a1,8(a0)
ffffffffc02076b8:	4108                	lw	a0,0(a0)
ffffffffc02076ba:	bdafd06f          	j	ffffffffc0204a94 <sysfile_seek>

ffffffffc02076be <sys_write>:
ffffffffc02076be:	6910                	ld	a2,16(a0)
ffffffffc02076c0:	650c                	ld	a1,8(a0)
ffffffffc02076c2:	4108                	lw	a0,0(a0)
ffffffffc02076c4:	ab6fd06f          	j	ffffffffc020497a <sysfile_write>

ffffffffc02076c8 <sys_read>:
ffffffffc02076c8:	6910                	ld	a2,16(a0)
ffffffffc02076ca:	650c                	ld	a1,8(a0)
ffffffffc02076cc:	4108                	lw	a0,0(a0)
ffffffffc02076ce:	998fd06f          	j	ffffffffc0204866 <sysfile_read>

ffffffffc02076d2 <sys_close>:
ffffffffc02076d2:	4108                	lw	a0,0(a0)
ffffffffc02076d4:	98efd06f          	j	ffffffffc0204862 <sysfile_close>

ffffffffc02076d8 <sys_open>:
ffffffffc02076d8:	450c                	lw	a1,8(a0)
ffffffffc02076da:	6108                	ld	a0,0(a0)
ffffffffc02076dc:	952fd06f          	j	ffffffffc020482e <sysfile_open>

ffffffffc02076e0 <sys_putc>:
ffffffffc02076e0:	4108                	lw	a0,0(a0)
ffffffffc02076e2:	1141                	addi	sp,sp,-16
ffffffffc02076e4:	e406                	sd	ra,8(sp)
ffffffffc02076e6:	a81f80ef          	jal	ra,ffffffffc0200166 <cputchar>
ffffffffc02076ea:	60a2                	ld	ra,8(sp)
ffffffffc02076ec:	4501                	li	a0,0
ffffffffc02076ee:	0141                	addi	sp,sp,16
ffffffffc02076f0:	8082                	ret

ffffffffc02076f2 <sys_kill>:
ffffffffc02076f2:	4108                	lw	a0,0(a0)
ffffffffc02076f4:	f0aff06f          	j	ffffffffc0206dfe <do_kill>

ffffffffc02076f8 <sys_sleep>:
ffffffffc02076f8:	4108                	lw	a0,0(a0)
ffffffffc02076fa:	9a1ff06f          	j	ffffffffc020709a <do_sleep>

ffffffffc02076fe <sys_yield>:
ffffffffc02076fe:	eb2ff06f          	j	ffffffffc0206db0 <do_yield>

ffffffffc0207702 <sys_exec>:
ffffffffc0207702:	6910                	ld	a2,16(a0)
ffffffffc0207704:	450c                	lw	a1,8(a0)
ffffffffc0207706:	6108                	ld	a0,0(a0)
ffffffffc0207708:	debfe06f          	j	ffffffffc02064f2 <do_execve>

ffffffffc020770c <sys_wait>:
ffffffffc020770c:	650c                	ld	a1,8(a0)
ffffffffc020770e:	4108                	lw	a0,0(a0)
ffffffffc0207710:	eb0ff06f          	j	ffffffffc0206dc0 <do_wait>

ffffffffc0207714 <sys_fork>:
ffffffffc0207714:	0008f797          	auipc	a5,0x8f
ffffffffc0207718:	1ac7b783          	ld	a5,428(a5) # ffffffffc02968c0 <current>
ffffffffc020771c:	73d0                	ld	a2,160(a5)
ffffffffc020771e:	4501                	li	a0,0
ffffffffc0207720:	6a0c                	ld	a1,16(a2)
ffffffffc0207722:	cb8fe06f          	j	ffffffffc0205bda <do_fork>

ffffffffc0207726 <sys_exit>:
ffffffffc0207726:	4108                	lw	a0,0(a0)
ffffffffc0207728:	947fe06f          	j	ffffffffc020606e <do_exit>

ffffffffc020772c <syscall>:
ffffffffc020772c:	715d                	addi	sp,sp,-80
ffffffffc020772e:	fc26                	sd	s1,56(sp)
ffffffffc0207730:	0008f497          	auipc	s1,0x8f
ffffffffc0207734:	19048493          	addi	s1,s1,400 # ffffffffc02968c0 <current>
ffffffffc0207738:	6098                	ld	a4,0(s1)
ffffffffc020773a:	e0a2                	sd	s0,64(sp)
ffffffffc020773c:	f84a                	sd	s2,48(sp)
ffffffffc020773e:	7340                	ld	s0,160(a4)
ffffffffc0207740:	e486                	sd	ra,72(sp)
ffffffffc0207742:	0ff00793          	li	a5,255
ffffffffc0207746:	05042903          	lw	s2,80(s0)
ffffffffc020774a:	0327ee63          	bltu	a5,s2,ffffffffc0207786 <syscall+0x5a>
ffffffffc020774e:	00391713          	slli	a4,s2,0x3
ffffffffc0207752:	00006797          	auipc	a5,0x6
ffffffffc0207756:	39e78793          	addi	a5,a5,926 # ffffffffc020daf0 <syscalls>
ffffffffc020775a:	97ba                	add	a5,a5,a4
ffffffffc020775c:	639c                	ld	a5,0(a5)
ffffffffc020775e:	c785                	beqz	a5,ffffffffc0207786 <syscall+0x5a>
ffffffffc0207760:	6c28                	ld	a0,88(s0)
ffffffffc0207762:	702c                	ld	a1,96(s0)
ffffffffc0207764:	7430                	ld	a2,104(s0)
ffffffffc0207766:	7834                	ld	a3,112(s0)
ffffffffc0207768:	7c38                	ld	a4,120(s0)
ffffffffc020776a:	e42a                	sd	a0,8(sp)
ffffffffc020776c:	e82e                	sd	a1,16(sp)
ffffffffc020776e:	ec32                	sd	a2,24(sp)
ffffffffc0207770:	f036                	sd	a3,32(sp)
ffffffffc0207772:	f43a                	sd	a4,40(sp)
ffffffffc0207774:	0028                	addi	a0,sp,8
ffffffffc0207776:	9782                	jalr	a5
ffffffffc0207778:	60a6                	ld	ra,72(sp)
ffffffffc020777a:	e828                	sd	a0,80(s0)
ffffffffc020777c:	6406                	ld	s0,64(sp)
ffffffffc020777e:	74e2                	ld	s1,56(sp)
ffffffffc0207780:	7942                	ld	s2,48(sp)
ffffffffc0207782:	6161                	addi	sp,sp,80
ffffffffc0207784:	8082                	ret
ffffffffc0207786:	8522                	mv	a0,s0
ffffffffc0207788:	80bf90ef          	jal	ra,ffffffffc0200f92 <print_trapframe>
ffffffffc020778c:	609c                	ld	a5,0(s1)
ffffffffc020778e:	86ca                	mv	a3,s2
ffffffffc0207790:	00006617          	auipc	a2,0x6
ffffffffc0207794:	31860613          	addi	a2,a2,792 # ffffffffc020daa8 <CSWTCH.79+0x6f8>
ffffffffc0207798:	43d8                	lw	a4,4(a5)
ffffffffc020779a:	0d800593          	li	a1,216
ffffffffc020779e:	0b478793          	addi	a5,a5,180
ffffffffc02077a2:	00006517          	auipc	a0,0x6
ffffffffc02077a6:	33650513          	addi	a0,a0,822 # ffffffffc020dad8 <CSWTCH.79+0x728>
ffffffffc02077aa:	a85f80ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02077ae <vfs_do_add>:
ffffffffc02077ae:	7139                	addi	sp,sp,-64
ffffffffc02077b0:	fc06                	sd	ra,56(sp)
ffffffffc02077b2:	f822                	sd	s0,48(sp)
ffffffffc02077b4:	f426                	sd	s1,40(sp)
ffffffffc02077b6:	f04a                	sd	s2,32(sp)
ffffffffc02077b8:	ec4e                	sd	s3,24(sp)
ffffffffc02077ba:	e852                	sd	s4,16(sp)
ffffffffc02077bc:	e456                	sd	s5,8(sp)
ffffffffc02077be:	e05a                	sd	s6,0(sp)
ffffffffc02077c0:	0e050b63          	beqz	a0,ffffffffc02078b6 <vfs_do_add+0x108>
ffffffffc02077c4:	842a                	mv	s0,a0
ffffffffc02077c6:	8a2e                	mv	s4,a1
ffffffffc02077c8:	8b32                	mv	s6,a2
ffffffffc02077ca:	8ab6                	mv	s5,a3
ffffffffc02077cc:	c5cd                	beqz	a1,ffffffffc0207876 <vfs_do_add+0xc8>
ffffffffc02077ce:	4db8                	lw	a4,88(a1)
ffffffffc02077d0:	6785                	lui	a5,0x1
ffffffffc02077d2:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc02077d6:	0af71163          	bne	a4,a5,ffffffffc0207878 <vfs_do_add+0xca>
ffffffffc02077da:	8522                	mv	a0,s0
ffffffffc02077dc:	780030ef          	jal	ra,ffffffffc020af5c <strlen>
ffffffffc02077e0:	47fd                	li	a5,31
ffffffffc02077e2:	0ca7e663          	bltu	a5,a0,ffffffffc02078ae <vfs_do_add+0x100>
ffffffffc02077e6:	8522                	mv	a0,s0
ffffffffc02077e8:	8cbf80ef          	jal	ra,ffffffffc02000b2 <strdup>
ffffffffc02077ec:	84aa                	mv	s1,a0
ffffffffc02077ee:	c171                	beqz	a0,ffffffffc02078b2 <vfs_do_add+0x104>
ffffffffc02077f0:	03000513          	li	a0,48
ffffffffc02077f4:	fd3fb0ef          	jal	ra,ffffffffc02037c6 <kmalloc>
ffffffffc02077f8:	89aa                	mv	s3,a0
ffffffffc02077fa:	c92d                	beqz	a0,ffffffffc020786c <vfs_do_add+0xbe>
ffffffffc02077fc:	0008e517          	auipc	a0,0x8e
ffffffffc0207800:	01450513          	addi	a0,a0,20 # ffffffffc0295810 <vdev_list_sem>
ffffffffc0207804:	0008e917          	auipc	s2,0x8e
ffffffffc0207808:	ffc90913          	addi	s2,s2,-4 # ffffffffc0295800 <vdev_list>
ffffffffc020780c:	f43fc0ef          	jal	ra,ffffffffc020474e <down>
ffffffffc0207810:	844a                	mv	s0,s2
ffffffffc0207812:	a039                	j	ffffffffc0207820 <vfs_do_add+0x72>
ffffffffc0207814:	fe043503          	ld	a0,-32(s0)
ffffffffc0207818:	85a6                	mv	a1,s1
ffffffffc020781a:	78a030ef          	jal	ra,ffffffffc020afa4 <strcmp>
ffffffffc020781e:	cd2d                	beqz	a0,ffffffffc0207898 <vfs_do_add+0xea>
ffffffffc0207820:	6400                	ld	s0,8(s0)
ffffffffc0207822:	ff2419e3          	bne	s0,s2,ffffffffc0207814 <vfs_do_add+0x66>
ffffffffc0207826:	6418                	ld	a4,8(s0)
ffffffffc0207828:	02098793          	addi	a5,s3,32
ffffffffc020782c:	0099b023          	sd	s1,0(s3)
ffffffffc0207830:	0149b423          	sd	s4,8(s3)
ffffffffc0207834:	0159bc23          	sd	s5,24(s3)
ffffffffc0207838:	0169b823          	sd	s6,16(s3)
ffffffffc020783c:	e31c                	sd	a5,0(a4)
ffffffffc020783e:	0289b023          	sd	s0,32(s3)
ffffffffc0207842:	02e9b423          	sd	a4,40(s3)
ffffffffc0207846:	0008e517          	auipc	a0,0x8e
ffffffffc020784a:	fca50513          	addi	a0,a0,-54 # ffffffffc0295810 <vdev_list_sem>
ffffffffc020784e:	e41c                	sd	a5,8(s0)
ffffffffc0207850:	4401                	li	s0,0
ffffffffc0207852:	ef9fc0ef          	jal	ra,ffffffffc020474a <up>
ffffffffc0207856:	70e2                	ld	ra,56(sp)
ffffffffc0207858:	8522                	mv	a0,s0
ffffffffc020785a:	7442                	ld	s0,48(sp)
ffffffffc020785c:	74a2                	ld	s1,40(sp)
ffffffffc020785e:	7902                	ld	s2,32(sp)
ffffffffc0207860:	69e2                	ld	s3,24(sp)
ffffffffc0207862:	6a42                	ld	s4,16(sp)
ffffffffc0207864:	6aa2                	ld	s5,8(sp)
ffffffffc0207866:	6b02                	ld	s6,0(sp)
ffffffffc0207868:	6121                	addi	sp,sp,64
ffffffffc020786a:	8082                	ret
ffffffffc020786c:	5471                	li	s0,-4
ffffffffc020786e:	8526                	mv	a0,s1
ffffffffc0207870:	806fc0ef          	jal	ra,ffffffffc0203876 <kfree>
ffffffffc0207874:	b7cd                	j	ffffffffc0207856 <vfs_do_add+0xa8>
ffffffffc0207876:	d2b5                	beqz	a3,ffffffffc02077da <vfs_do_add+0x2c>
ffffffffc0207878:	00007697          	auipc	a3,0x7
ffffffffc020787c:	aa068693          	addi	a3,a3,-1376 # ffffffffc020e318 <syscalls+0x828>
ffffffffc0207880:	00004617          	auipc	a2,0x4
ffffffffc0207884:	f8860613          	addi	a2,a2,-120 # ffffffffc020b808 <commands+0x60>
ffffffffc0207888:	08f00593          	li	a1,143
ffffffffc020788c:	00007517          	auipc	a0,0x7
ffffffffc0207890:	a7450513          	addi	a0,a0,-1420 # ffffffffc020e300 <syscalls+0x810>
ffffffffc0207894:	99bf80ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0207898:	0008e517          	auipc	a0,0x8e
ffffffffc020789c:	f7850513          	addi	a0,a0,-136 # ffffffffc0295810 <vdev_list_sem>
ffffffffc02078a0:	eabfc0ef          	jal	ra,ffffffffc020474a <up>
ffffffffc02078a4:	854e                	mv	a0,s3
ffffffffc02078a6:	fd1fb0ef          	jal	ra,ffffffffc0203876 <kfree>
ffffffffc02078aa:	5425                	li	s0,-23
ffffffffc02078ac:	b7c9                	j	ffffffffc020786e <vfs_do_add+0xc0>
ffffffffc02078ae:	5451                	li	s0,-12
ffffffffc02078b0:	b75d                	j	ffffffffc0207856 <vfs_do_add+0xa8>
ffffffffc02078b2:	5471                	li	s0,-4
ffffffffc02078b4:	b74d                	j	ffffffffc0207856 <vfs_do_add+0xa8>
ffffffffc02078b6:	00007697          	auipc	a3,0x7
ffffffffc02078ba:	a3a68693          	addi	a3,a3,-1478 # ffffffffc020e2f0 <syscalls+0x800>
ffffffffc02078be:	00004617          	auipc	a2,0x4
ffffffffc02078c2:	f4a60613          	addi	a2,a2,-182 # ffffffffc020b808 <commands+0x60>
ffffffffc02078c6:	08e00593          	li	a1,142
ffffffffc02078ca:	00007517          	auipc	a0,0x7
ffffffffc02078ce:	a3650513          	addi	a0,a0,-1482 # ffffffffc020e300 <syscalls+0x810>
ffffffffc02078d2:	95df80ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02078d6 <find_mount.part.0>:
ffffffffc02078d6:	1141                	addi	sp,sp,-16
ffffffffc02078d8:	00007697          	auipc	a3,0x7
ffffffffc02078dc:	a1868693          	addi	a3,a3,-1512 # ffffffffc020e2f0 <syscalls+0x800>
ffffffffc02078e0:	00004617          	auipc	a2,0x4
ffffffffc02078e4:	f2860613          	addi	a2,a2,-216 # ffffffffc020b808 <commands+0x60>
ffffffffc02078e8:	0cd00593          	li	a1,205
ffffffffc02078ec:	00007517          	auipc	a0,0x7
ffffffffc02078f0:	a1450513          	addi	a0,a0,-1516 # ffffffffc020e300 <syscalls+0x810>
ffffffffc02078f4:	e406                	sd	ra,8(sp)
ffffffffc02078f6:	939f80ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02078fa <vfs_devlist_init>:
ffffffffc02078fa:	0008e797          	auipc	a5,0x8e
ffffffffc02078fe:	f0678793          	addi	a5,a5,-250 # ffffffffc0295800 <vdev_list>
ffffffffc0207902:	4585                	li	a1,1
ffffffffc0207904:	0008e517          	auipc	a0,0x8e
ffffffffc0207908:	f0c50513          	addi	a0,a0,-244 # ffffffffc0295810 <vdev_list_sem>
ffffffffc020790c:	e79c                	sd	a5,8(a5)
ffffffffc020790e:	e39c                	sd	a5,0(a5)
ffffffffc0207910:	e33fc06f          	j	ffffffffc0204742 <sem_init>

ffffffffc0207914 <vfs_cleanup>:
ffffffffc0207914:	1101                	addi	sp,sp,-32
ffffffffc0207916:	e426                	sd	s1,8(sp)
ffffffffc0207918:	0008e497          	auipc	s1,0x8e
ffffffffc020791c:	ee848493          	addi	s1,s1,-280 # ffffffffc0295800 <vdev_list>
ffffffffc0207920:	649c                	ld	a5,8(s1)
ffffffffc0207922:	ec06                	sd	ra,24(sp)
ffffffffc0207924:	e822                	sd	s0,16(sp)
ffffffffc0207926:	02978e63          	beq	a5,s1,ffffffffc0207962 <vfs_cleanup+0x4e>
ffffffffc020792a:	0008e517          	auipc	a0,0x8e
ffffffffc020792e:	ee650513          	addi	a0,a0,-282 # ffffffffc0295810 <vdev_list_sem>
ffffffffc0207932:	e1dfc0ef          	jal	ra,ffffffffc020474e <down>
ffffffffc0207936:	6480                	ld	s0,8(s1)
ffffffffc0207938:	00940b63          	beq	s0,s1,ffffffffc020794e <vfs_cleanup+0x3a>
ffffffffc020793c:	ff043783          	ld	a5,-16(s0)
ffffffffc0207940:	853e                	mv	a0,a5
ffffffffc0207942:	c399                	beqz	a5,ffffffffc0207948 <vfs_cleanup+0x34>
ffffffffc0207944:	6bfc                	ld	a5,208(a5)
ffffffffc0207946:	9782                	jalr	a5
ffffffffc0207948:	6400                	ld	s0,8(s0)
ffffffffc020794a:	fe9419e3          	bne	s0,s1,ffffffffc020793c <vfs_cleanup+0x28>
ffffffffc020794e:	6442                	ld	s0,16(sp)
ffffffffc0207950:	60e2                	ld	ra,24(sp)
ffffffffc0207952:	64a2                	ld	s1,8(sp)
ffffffffc0207954:	0008e517          	auipc	a0,0x8e
ffffffffc0207958:	ebc50513          	addi	a0,a0,-324 # ffffffffc0295810 <vdev_list_sem>
ffffffffc020795c:	6105                	addi	sp,sp,32
ffffffffc020795e:	dedfc06f          	j	ffffffffc020474a <up>
ffffffffc0207962:	60e2                	ld	ra,24(sp)
ffffffffc0207964:	6442                	ld	s0,16(sp)
ffffffffc0207966:	64a2                	ld	s1,8(sp)
ffffffffc0207968:	6105                	addi	sp,sp,32
ffffffffc020796a:	8082                	ret

ffffffffc020796c <vfs_get_root>:
ffffffffc020796c:	7179                	addi	sp,sp,-48
ffffffffc020796e:	f406                	sd	ra,40(sp)
ffffffffc0207970:	f022                	sd	s0,32(sp)
ffffffffc0207972:	ec26                	sd	s1,24(sp)
ffffffffc0207974:	e84a                	sd	s2,16(sp)
ffffffffc0207976:	e44e                	sd	s3,8(sp)
ffffffffc0207978:	e052                	sd	s4,0(sp)
ffffffffc020797a:	c541                	beqz	a0,ffffffffc0207a02 <vfs_get_root+0x96>
ffffffffc020797c:	0008e917          	auipc	s2,0x8e
ffffffffc0207980:	e8490913          	addi	s2,s2,-380 # ffffffffc0295800 <vdev_list>
ffffffffc0207984:	00893783          	ld	a5,8(s2)
ffffffffc0207988:	07278b63          	beq	a5,s2,ffffffffc02079fe <vfs_get_root+0x92>
ffffffffc020798c:	89aa                	mv	s3,a0
ffffffffc020798e:	0008e517          	auipc	a0,0x8e
ffffffffc0207992:	e8250513          	addi	a0,a0,-382 # ffffffffc0295810 <vdev_list_sem>
ffffffffc0207996:	8a2e                	mv	s4,a1
ffffffffc0207998:	844a                	mv	s0,s2
ffffffffc020799a:	db5fc0ef          	jal	ra,ffffffffc020474e <down>
ffffffffc020799e:	a801                	j	ffffffffc02079ae <vfs_get_root+0x42>
ffffffffc02079a0:	fe043583          	ld	a1,-32(s0)
ffffffffc02079a4:	854e                	mv	a0,s3
ffffffffc02079a6:	5fe030ef          	jal	ra,ffffffffc020afa4 <strcmp>
ffffffffc02079aa:	84aa                	mv	s1,a0
ffffffffc02079ac:	c505                	beqz	a0,ffffffffc02079d4 <vfs_get_root+0x68>
ffffffffc02079ae:	6400                	ld	s0,8(s0)
ffffffffc02079b0:	ff2418e3          	bne	s0,s2,ffffffffc02079a0 <vfs_get_root+0x34>
ffffffffc02079b4:	54cd                	li	s1,-13
ffffffffc02079b6:	0008e517          	auipc	a0,0x8e
ffffffffc02079ba:	e5a50513          	addi	a0,a0,-422 # ffffffffc0295810 <vdev_list_sem>
ffffffffc02079be:	d8dfc0ef          	jal	ra,ffffffffc020474a <up>
ffffffffc02079c2:	70a2                	ld	ra,40(sp)
ffffffffc02079c4:	7402                	ld	s0,32(sp)
ffffffffc02079c6:	6942                	ld	s2,16(sp)
ffffffffc02079c8:	69a2                	ld	s3,8(sp)
ffffffffc02079ca:	6a02                	ld	s4,0(sp)
ffffffffc02079cc:	8526                	mv	a0,s1
ffffffffc02079ce:	64e2                	ld	s1,24(sp)
ffffffffc02079d0:	6145                	addi	sp,sp,48
ffffffffc02079d2:	8082                	ret
ffffffffc02079d4:	ff043503          	ld	a0,-16(s0)
ffffffffc02079d8:	c519                	beqz	a0,ffffffffc02079e6 <vfs_get_root+0x7a>
ffffffffc02079da:	617c                	ld	a5,192(a0)
ffffffffc02079dc:	9782                	jalr	a5
ffffffffc02079de:	c519                	beqz	a0,ffffffffc02079ec <vfs_get_root+0x80>
ffffffffc02079e0:	00aa3023          	sd	a0,0(s4)
ffffffffc02079e4:	bfc9                	j	ffffffffc02079b6 <vfs_get_root+0x4a>
ffffffffc02079e6:	ff843783          	ld	a5,-8(s0)
ffffffffc02079ea:	c399                	beqz	a5,ffffffffc02079f0 <vfs_get_root+0x84>
ffffffffc02079ec:	54c9                	li	s1,-14
ffffffffc02079ee:	b7e1                	j	ffffffffc02079b6 <vfs_get_root+0x4a>
ffffffffc02079f0:	fe843503          	ld	a0,-24(s0)
ffffffffc02079f4:	5ee000ef          	jal	ra,ffffffffc0207fe2 <inode_ref_inc>
ffffffffc02079f8:	fe843503          	ld	a0,-24(s0)
ffffffffc02079fc:	b7cd                	j	ffffffffc02079de <vfs_get_root+0x72>
ffffffffc02079fe:	54cd                	li	s1,-13
ffffffffc0207a00:	b7c9                	j	ffffffffc02079c2 <vfs_get_root+0x56>
ffffffffc0207a02:	00007697          	auipc	a3,0x7
ffffffffc0207a06:	8ee68693          	addi	a3,a3,-1810 # ffffffffc020e2f0 <syscalls+0x800>
ffffffffc0207a0a:	00004617          	auipc	a2,0x4
ffffffffc0207a0e:	dfe60613          	addi	a2,a2,-514 # ffffffffc020b808 <commands+0x60>
ffffffffc0207a12:	04500593          	li	a1,69
ffffffffc0207a16:	00007517          	auipc	a0,0x7
ffffffffc0207a1a:	8ea50513          	addi	a0,a0,-1814 # ffffffffc020e300 <syscalls+0x810>
ffffffffc0207a1e:	811f80ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0207a22 <vfs_get_devname>:
ffffffffc0207a22:	0008e697          	auipc	a3,0x8e
ffffffffc0207a26:	dde68693          	addi	a3,a3,-546 # ffffffffc0295800 <vdev_list>
ffffffffc0207a2a:	87b6                	mv	a5,a3
ffffffffc0207a2c:	e511                	bnez	a0,ffffffffc0207a38 <vfs_get_devname+0x16>
ffffffffc0207a2e:	a829                	j	ffffffffc0207a48 <vfs_get_devname+0x26>
ffffffffc0207a30:	ff07b703          	ld	a4,-16(a5)
ffffffffc0207a34:	00a70763          	beq	a4,a0,ffffffffc0207a42 <vfs_get_devname+0x20>
ffffffffc0207a38:	679c                	ld	a5,8(a5)
ffffffffc0207a3a:	fed79be3          	bne	a5,a3,ffffffffc0207a30 <vfs_get_devname+0xe>
ffffffffc0207a3e:	4501                	li	a0,0
ffffffffc0207a40:	8082                	ret
ffffffffc0207a42:	fe07b503          	ld	a0,-32(a5)
ffffffffc0207a46:	8082                	ret
ffffffffc0207a48:	1141                	addi	sp,sp,-16
ffffffffc0207a4a:	00007697          	auipc	a3,0x7
ffffffffc0207a4e:	92e68693          	addi	a3,a3,-1746 # ffffffffc020e378 <syscalls+0x888>
ffffffffc0207a52:	00004617          	auipc	a2,0x4
ffffffffc0207a56:	db660613          	addi	a2,a2,-586 # ffffffffc020b808 <commands+0x60>
ffffffffc0207a5a:	06a00593          	li	a1,106
ffffffffc0207a5e:	00007517          	auipc	a0,0x7
ffffffffc0207a62:	8a250513          	addi	a0,a0,-1886 # ffffffffc020e300 <syscalls+0x810>
ffffffffc0207a66:	e406                	sd	ra,8(sp)
ffffffffc0207a68:	fc6f80ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0207a6c <vfs_add_dev>:
ffffffffc0207a6c:	86b2                	mv	a3,a2
ffffffffc0207a6e:	4601                	li	a2,0
ffffffffc0207a70:	d3fff06f          	j	ffffffffc02077ae <vfs_do_add>

ffffffffc0207a74 <vfs_mount>:
ffffffffc0207a74:	7179                	addi	sp,sp,-48
ffffffffc0207a76:	e84a                	sd	s2,16(sp)
ffffffffc0207a78:	892a                	mv	s2,a0
ffffffffc0207a7a:	0008e517          	auipc	a0,0x8e
ffffffffc0207a7e:	d9650513          	addi	a0,a0,-618 # ffffffffc0295810 <vdev_list_sem>
ffffffffc0207a82:	e44e                	sd	s3,8(sp)
ffffffffc0207a84:	f406                	sd	ra,40(sp)
ffffffffc0207a86:	f022                	sd	s0,32(sp)
ffffffffc0207a88:	ec26                	sd	s1,24(sp)
ffffffffc0207a8a:	89ae                	mv	s3,a1
ffffffffc0207a8c:	cc3fc0ef          	jal	ra,ffffffffc020474e <down>
ffffffffc0207a90:	08090a63          	beqz	s2,ffffffffc0207b24 <vfs_mount+0xb0>
ffffffffc0207a94:	0008e497          	auipc	s1,0x8e
ffffffffc0207a98:	d6c48493          	addi	s1,s1,-660 # ffffffffc0295800 <vdev_list>
ffffffffc0207a9c:	6480                	ld	s0,8(s1)
ffffffffc0207a9e:	00941663          	bne	s0,s1,ffffffffc0207aaa <vfs_mount+0x36>
ffffffffc0207aa2:	a8ad                	j	ffffffffc0207b1c <vfs_mount+0xa8>
ffffffffc0207aa4:	6400                	ld	s0,8(s0)
ffffffffc0207aa6:	06940b63          	beq	s0,s1,ffffffffc0207b1c <vfs_mount+0xa8>
ffffffffc0207aaa:	ff843783          	ld	a5,-8(s0)
ffffffffc0207aae:	dbfd                	beqz	a5,ffffffffc0207aa4 <vfs_mount+0x30>
ffffffffc0207ab0:	fe043503          	ld	a0,-32(s0)
ffffffffc0207ab4:	85ca                	mv	a1,s2
ffffffffc0207ab6:	4ee030ef          	jal	ra,ffffffffc020afa4 <strcmp>
ffffffffc0207aba:	f56d                	bnez	a0,ffffffffc0207aa4 <vfs_mount+0x30>
ffffffffc0207abc:	ff043783          	ld	a5,-16(s0)
ffffffffc0207ac0:	e3a5                	bnez	a5,ffffffffc0207b20 <vfs_mount+0xac>
ffffffffc0207ac2:	fe043783          	ld	a5,-32(s0)
ffffffffc0207ac6:	c3c9                	beqz	a5,ffffffffc0207b48 <vfs_mount+0xd4>
ffffffffc0207ac8:	ff843783          	ld	a5,-8(s0)
ffffffffc0207acc:	cfb5                	beqz	a5,ffffffffc0207b48 <vfs_mount+0xd4>
ffffffffc0207ace:	fe843503          	ld	a0,-24(s0)
ffffffffc0207ad2:	c939                	beqz	a0,ffffffffc0207b28 <vfs_mount+0xb4>
ffffffffc0207ad4:	4d38                	lw	a4,88(a0)
ffffffffc0207ad6:	6785                	lui	a5,0x1
ffffffffc0207ad8:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0207adc:	04f71663          	bne	a4,a5,ffffffffc0207b28 <vfs_mount+0xb4>
ffffffffc0207ae0:	ff040593          	addi	a1,s0,-16
ffffffffc0207ae4:	9982                	jalr	s3
ffffffffc0207ae6:	84aa                	mv	s1,a0
ffffffffc0207ae8:	ed01                	bnez	a0,ffffffffc0207b00 <vfs_mount+0x8c>
ffffffffc0207aea:	ff043783          	ld	a5,-16(s0)
ffffffffc0207aee:	cfad                	beqz	a5,ffffffffc0207b68 <vfs_mount+0xf4>
ffffffffc0207af0:	fe043583          	ld	a1,-32(s0)
ffffffffc0207af4:	00007517          	auipc	a0,0x7
ffffffffc0207af8:	91450513          	addi	a0,a0,-1772 # ffffffffc020e408 <syscalls+0x918>
ffffffffc0207afc:	e2ef80ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc0207b00:	0008e517          	auipc	a0,0x8e
ffffffffc0207b04:	d1050513          	addi	a0,a0,-752 # ffffffffc0295810 <vdev_list_sem>
ffffffffc0207b08:	c43fc0ef          	jal	ra,ffffffffc020474a <up>
ffffffffc0207b0c:	70a2                	ld	ra,40(sp)
ffffffffc0207b0e:	7402                	ld	s0,32(sp)
ffffffffc0207b10:	6942                	ld	s2,16(sp)
ffffffffc0207b12:	69a2                	ld	s3,8(sp)
ffffffffc0207b14:	8526                	mv	a0,s1
ffffffffc0207b16:	64e2                	ld	s1,24(sp)
ffffffffc0207b18:	6145                	addi	sp,sp,48
ffffffffc0207b1a:	8082                	ret
ffffffffc0207b1c:	54cd                	li	s1,-13
ffffffffc0207b1e:	b7cd                	j	ffffffffc0207b00 <vfs_mount+0x8c>
ffffffffc0207b20:	54c5                	li	s1,-15
ffffffffc0207b22:	bff9                	j	ffffffffc0207b00 <vfs_mount+0x8c>
ffffffffc0207b24:	db3ff0ef          	jal	ra,ffffffffc02078d6 <find_mount.part.0>
ffffffffc0207b28:	00007697          	auipc	a3,0x7
ffffffffc0207b2c:	89068693          	addi	a3,a3,-1904 # ffffffffc020e3b8 <syscalls+0x8c8>
ffffffffc0207b30:	00004617          	auipc	a2,0x4
ffffffffc0207b34:	cd860613          	addi	a2,a2,-808 # ffffffffc020b808 <commands+0x60>
ffffffffc0207b38:	0ed00593          	li	a1,237
ffffffffc0207b3c:	00006517          	auipc	a0,0x6
ffffffffc0207b40:	7c450513          	addi	a0,a0,1988 # ffffffffc020e300 <syscalls+0x810>
ffffffffc0207b44:	eeaf80ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0207b48:	00007697          	auipc	a3,0x7
ffffffffc0207b4c:	84068693          	addi	a3,a3,-1984 # ffffffffc020e388 <syscalls+0x898>
ffffffffc0207b50:	00004617          	auipc	a2,0x4
ffffffffc0207b54:	cb860613          	addi	a2,a2,-840 # ffffffffc020b808 <commands+0x60>
ffffffffc0207b58:	0eb00593          	li	a1,235
ffffffffc0207b5c:	00006517          	auipc	a0,0x6
ffffffffc0207b60:	7a450513          	addi	a0,a0,1956 # ffffffffc020e300 <syscalls+0x810>
ffffffffc0207b64:	ecaf80ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0207b68:	00007697          	auipc	a3,0x7
ffffffffc0207b6c:	88868693          	addi	a3,a3,-1912 # ffffffffc020e3f0 <syscalls+0x900>
ffffffffc0207b70:	00004617          	auipc	a2,0x4
ffffffffc0207b74:	c9860613          	addi	a2,a2,-872 # ffffffffc020b808 <commands+0x60>
ffffffffc0207b78:	0ef00593          	li	a1,239
ffffffffc0207b7c:	00006517          	auipc	a0,0x6
ffffffffc0207b80:	78450513          	addi	a0,a0,1924 # ffffffffc020e300 <syscalls+0x810>
ffffffffc0207b84:	eaaf80ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0207b88 <vfs_get_curdir>:
ffffffffc0207b88:	0008f797          	auipc	a5,0x8f
ffffffffc0207b8c:	d387b783          	ld	a5,-712(a5) # ffffffffc02968c0 <current>
ffffffffc0207b90:	1487b783          	ld	a5,328(a5)
ffffffffc0207b94:	1101                	addi	sp,sp,-32
ffffffffc0207b96:	e426                	sd	s1,8(sp)
ffffffffc0207b98:	6384                	ld	s1,0(a5)
ffffffffc0207b9a:	ec06                	sd	ra,24(sp)
ffffffffc0207b9c:	e822                	sd	s0,16(sp)
ffffffffc0207b9e:	cc81                	beqz	s1,ffffffffc0207bb6 <vfs_get_curdir+0x2e>
ffffffffc0207ba0:	842a                	mv	s0,a0
ffffffffc0207ba2:	8526                	mv	a0,s1
ffffffffc0207ba4:	43e000ef          	jal	ra,ffffffffc0207fe2 <inode_ref_inc>
ffffffffc0207ba8:	4501                	li	a0,0
ffffffffc0207baa:	e004                	sd	s1,0(s0)
ffffffffc0207bac:	60e2                	ld	ra,24(sp)
ffffffffc0207bae:	6442                	ld	s0,16(sp)
ffffffffc0207bb0:	64a2                	ld	s1,8(sp)
ffffffffc0207bb2:	6105                	addi	sp,sp,32
ffffffffc0207bb4:	8082                	ret
ffffffffc0207bb6:	5541                	li	a0,-16
ffffffffc0207bb8:	bfd5                	j	ffffffffc0207bac <vfs_get_curdir+0x24>

ffffffffc0207bba <vfs_set_curdir>:
ffffffffc0207bba:	7139                	addi	sp,sp,-64
ffffffffc0207bbc:	f04a                	sd	s2,32(sp)
ffffffffc0207bbe:	0008f917          	auipc	s2,0x8f
ffffffffc0207bc2:	d0290913          	addi	s2,s2,-766 # ffffffffc02968c0 <current>
ffffffffc0207bc6:	00093783          	ld	a5,0(s2)
ffffffffc0207bca:	f822                	sd	s0,48(sp)
ffffffffc0207bcc:	842a                	mv	s0,a0
ffffffffc0207bce:	1487b503          	ld	a0,328(a5)
ffffffffc0207bd2:	ec4e                	sd	s3,24(sp)
ffffffffc0207bd4:	fc06                	sd	ra,56(sp)
ffffffffc0207bd6:	f426                	sd	s1,40(sp)
ffffffffc0207bd8:	c07fd0ef          	jal	ra,ffffffffc02057de <lock_files>
ffffffffc0207bdc:	00093783          	ld	a5,0(s2)
ffffffffc0207be0:	1487b503          	ld	a0,328(a5)
ffffffffc0207be4:	00053983          	ld	s3,0(a0)
ffffffffc0207be8:	07340963          	beq	s0,s3,ffffffffc0207c5a <vfs_set_curdir+0xa0>
ffffffffc0207bec:	cc39                	beqz	s0,ffffffffc0207c4a <vfs_set_curdir+0x90>
ffffffffc0207bee:	783c                	ld	a5,112(s0)
ffffffffc0207bf0:	c7bd                	beqz	a5,ffffffffc0207c5e <vfs_set_curdir+0xa4>
ffffffffc0207bf2:	6bbc                	ld	a5,80(a5)
ffffffffc0207bf4:	c7ad                	beqz	a5,ffffffffc0207c5e <vfs_set_curdir+0xa4>
ffffffffc0207bf6:	00007597          	auipc	a1,0x7
ffffffffc0207bfa:	88a58593          	addi	a1,a1,-1910 # ffffffffc020e480 <syscalls+0x990>
ffffffffc0207bfe:	8522                	mv	a0,s0
ffffffffc0207c00:	3fa000ef          	jal	ra,ffffffffc0207ffa <inode_check>
ffffffffc0207c04:	783c                	ld	a5,112(s0)
ffffffffc0207c06:	006c                	addi	a1,sp,12
ffffffffc0207c08:	8522                	mv	a0,s0
ffffffffc0207c0a:	6bbc                	ld	a5,80(a5)
ffffffffc0207c0c:	9782                	jalr	a5
ffffffffc0207c0e:	84aa                	mv	s1,a0
ffffffffc0207c10:	e901                	bnez	a0,ffffffffc0207c20 <vfs_set_curdir+0x66>
ffffffffc0207c12:	47b2                	lw	a5,12(sp)
ffffffffc0207c14:	669d                	lui	a3,0x7
ffffffffc0207c16:	6709                	lui	a4,0x2
ffffffffc0207c18:	8ff5                	and	a5,a5,a3
ffffffffc0207c1a:	54b9                	li	s1,-18
ffffffffc0207c1c:	02e78063          	beq	a5,a4,ffffffffc0207c3c <vfs_set_curdir+0x82>
ffffffffc0207c20:	00093783          	ld	a5,0(s2)
ffffffffc0207c24:	1487b503          	ld	a0,328(a5)
ffffffffc0207c28:	bbdfd0ef          	jal	ra,ffffffffc02057e4 <unlock_files>
ffffffffc0207c2c:	70e2                	ld	ra,56(sp)
ffffffffc0207c2e:	7442                	ld	s0,48(sp)
ffffffffc0207c30:	7902                	ld	s2,32(sp)
ffffffffc0207c32:	69e2                	ld	s3,24(sp)
ffffffffc0207c34:	8526                	mv	a0,s1
ffffffffc0207c36:	74a2                	ld	s1,40(sp)
ffffffffc0207c38:	6121                	addi	sp,sp,64
ffffffffc0207c3a:	8082                	ret
ffffffffc0207c3c:	8522                	mv	a0,s0
ffffffffc0207c3e:	3a4000ef          	jal	ra,ffffffffc0207fe2 <inode_ref_inc>
ffffffffc0207c42:	00093783          	ld	a5,0(s2)
ffffffffc0207c46:	1487b503          	ld	a0,328(a5)
ffffffffc0207c4a:	e100                	sd	s0,0(a0)
ffffffffc0207c4c:	4481                	li	s1,0
ffffffffc0207c4e:	fc098de3          	beqz	s3,ffffffffc0207c28 <vfs_set_curdir+0x6e>
ffffffffc0207c52:	854e                	mv	a0,s3
ffffffffc0207c54:	45c000ef          	jal	ra,ffffffffc02080b0 <inode_ref_dec>
ffffffffc0207c58:	b7e1                	j	ffffffffc0207c20 <vfs_set_curdir+0x66>
ffffffffc0207c5a:	4481                	li	s1,0
ffffffffc0207c5c:	b7f1                	j	ffffffffc0207c28 <vfs_set_curdir+0x6e>
ffffffffc0207c5e:	00006697          	auipc	a3,0x6
ffffffffc0207c62:	7ba68693          	addi	a3,a3,1978 # ffffffffc020e418 <syscalls+0x928>
ffffffffc0207c66:	00004617          	auipc	a2,0x4
ffffffffc0207c6a:	ba260613          	addi	a2,a2,-1118 # ffffffffc020b808 <commands+0x60>
ffffffffc0207c6e:	04300593          	li	a1,67
ffffffffc0207c72:	00006517          	auipc	a0,0x6
ffffffffc0207c76:	7f650513          	addi	a0,a0,2038 # ffffffffc020e468 <syscalls+0x978>
ffffffffc0207c7a:	db4f80ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0207c7e <vfs_chdir>:
ffffffffc0207c7e:	1101                	addi	sp,sp,-32
ffffffffc0207c80:	002c                	addi	a1,sp,8
ffffffffc0207c82:	e822                	sd	s0,16(sp)
ffffffffc0207c84:	ec06                	sd	ra,24(sp)
ffffffffc0207c86:	21e000ef          	jal	ra,ffffffffc0207ea4 <vfs_lookup>
ffffffffc0207c8a:	842a                	mv	s0,a0
ffffffffc0207c8c:	c511                	beqz	a0,ffffffffc0207c98 <vfs_chdir+0x1a>
ffffffffc0207c8e:	60e2                	ld	ra,24(sp)
ffffffffc0207c90:	8522                	mv	a0,s0
ffffffffc0207c92:	6442                	ld	s0,16(sp)
ffffffffc0207c94:	6105                	addi	sp,sp,32
ffffffffc0207c96:	8082                	ret
ffffffffc0207c98:	6522                	ld	a0,8(sp)
ffffffffc0207c9a:	f21ff0ef          	jal	ra,ffffffffc0207bba <vfs_set_curdir>
ffffffffc0207c9e:	842a                	mv	s0,a0
ffffffffc0207ca0:	6522                	ld	a0,8(sp)
ffffffffc0207ca2:	40e000ef          	jal	ra,ffffffffc02080b0 <inode_ref_dec>
ffffffffc0207ca6:	60e2                	ld	ra,24(sp)
ffffffffc0207ca8:	8522                	mv	a0,s0
ffffffffc0207caa:	6442                	ld	s0,16(sp)
ffffffffc0207cac:	6105                	addi	sp,sp,32
ffffffffc0207cae:	8082                	ret

ffffffffc0207cb0 <vfs_getcwd>:
ffffffffc0207cb0:	0008f797          	auipc	a5,0x8f
ffffffffc0207cb4:	c107b783          	ld	a5,-1008(a5) # ffffffffc02968c0 <current>
ffffffffc0207cb8:	1487b783          	ld	a5,328(a5)
ffffffffc0207cbc:	7179                	addi	sp,sp,-48
ffffffffc0207cbe:	ec26                	sd	s1,24(sp)
ffffffffc0207cc0:	6384                	ld	s1,0(a5)
ffffffffc0207cc2:	f406                	sd	ra,40(sp)
ffffffffc0207cc4:	f022                	sd	s0,32(sp)
ffffffffc0207cc6:	e84a                	sd	s2,16(sp)
ffffffffc0207cc8:	ccbd                	beqz	s1,ffffffffc0207d46 <vfs_getcwd+0x96>
ffffffffc0207cca:	892a                	mv	s2,a0
ffffffffc0207ccc:	8526                	mv	a0,s1
ffffffffc0207cce:	314000ef          	jal	ra,ffffffffc0207fe2 <inode_ref_inc>
ffffffffc0207cd2:	74a8                	ld	a0,104(s1)
ffffffffc0207cd4:	c93d                	beqz	a0,ffffffffc0207d4a <vfs_getcwd+0x9a>
ffffffffc0207cd6:	d4dff0ef          	jal	ra,ffffffffc0207a22 <vfs_get_devname>
ffffffffc0207cda:	842a                	mv	s0,a0
ffffffffc0207cdc:	280030ef          	jal	ra,ffffffffc020af5c <strlen>
ffffffffc0207ce0:	862a                	mv	a2,a0
ffffffffc0207ce2:	85a2                	mv	a1,s0
ffffffffc0207ce4:	4701                	li	a4,0
ffffffffc0207ce6:	4685                	li	a3,1
ffffffffc0207ce8:	854a                	mv	a0,s2
ffffffffc0207cea:	a51fd0ef          	jal	ra,ffffffffc020573a <iobuf_move>
ffffffffc0207cee:	842a                	mv	s0,a0
ffffffffc0207cf0:	c919                	beqz	a0,ffffffffc0207d06 <vfs_getcwd+0x56>
ffffffffc0207cf2:	8526                	mv	a0,s1
ffffffffc0207cf4:	3bc000ef          	jal	ra,ffffffffc02080b0 <inode_ref_dec>
ffffffffc0207cf8:	70a2                	ld	ra,40(sp)
ffffffffc0207cfa:	8522                	mv	a0,s0
ffffffffc0207cfc:	7402                	ld	s0,32(sp)
ffffffffc0207cfe:	64e2                	ld	s1,24(sp)
ffffffffc0207d00:	6942                	ld	s2,16(sp)
ffffffffc0207d02:	6145                	addi	sp,sp,48
ffffffffc0207d04:	8082                	ret
ffffffffc0207d06:	03a00793          	li	a5,58
ffffffffc0207d0a:	4701                	li	a4,0
ffffffffc0207d0c:	4685                	li	a3,1
ffffffffc0207d0e:	4605                	li	a2,1
ffffffffc0207d10:	00f10593          	addi	a1,sp,15
ffffffffc0207d14:	854a                	mv	a0,s2
ffffffffc0207d16:	00f107a3          	sb	a5,15(sp)
ffffffffc0207d1a:	a21fd0ef          	jal	ra,ffffffffc020573a <iobuf_move>
ffffffffc0207d1e:	842a                	mv	s0,a0
ffffffffc0207d20:	f969                	bnez	a0,ffffffffc0207cf2 <vfs_getcwd+0x42>
ffffffffc0207d22:	78bc                	ld	a5,112(s1)
ffffffffc0207d24:	c3b9                	beqz	a5,ffffffffc0207d6a <vfs_getcwd+0xba>
ffffffffc0207d26:	7f9c                	ld	a5,56(a5)
ffffffffc0207d28:	c3a9                	beqz	a5,ffffffffc0207d6a <vfs_getcwd+0xba>
ffffffffc0207d2a:	00006597          	auipc	a1,0x6
ffffffffc0207d2e:	7ce58593          	addi	a1,a1,1998 # ffffffffc020e4f8 <syscalls+0xa08>
ffffffffc0207d32:	8526                	mv	a0,s1
ffffffffc0207d34:	2c6000ef          	jal	ra,ffffffffc0207ffa <inode_check>
ffffffffc0207d38:	78bc                	ld	a5,112(s1)
ffffffffc0207d3a:	85ca                	mv	a1,s2
ffffffffc0207d3c:	8526                	mv	a0,s1
ffffffffc0207d3e:	7f9c                	ld	a5,56(a5)
ffffffffc0207d40:	9782                	jalr	a5
ffffffffc0207d42:	842a                	mv	s0,a0
ffffffffc0207d44:	b77d                	j	ffffffffc0207cf2 <vfs_getcwd+0x42>
ffffffffc0207d46:	5441                	li	s0,-16
ffffffffc0207d48:	bf45                	j	ffffffffc0207cf8 <vfs_getcwd+0x48>
ffffffffc0207d4a:	00006697          	auipc	a3,0x6
ffffffffc0207d4e:	73e68693          	addi	a3,a3,1854 # ffffffffc020e488 <syscalls+0x998>
ffffffffc0207d52:	00004617          	auipc	a2,0x4
ffffffffc0207d56:	ab660613          	addi	a2,a2,-1354 # ffffffffc020b808 <commands+0x60>
ffffffffc0207d5a:	06e00593          	li	a1,110
ffffffffc0207d5e:	00006517          	auipc	a0,0x6
ffffffffc0207d62:	70a50513          	addi	a0,a0,1802 # ffffffffc020e468 <syscalls+0x978>
ffffffffc0207d66:	cc8f80ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0207d6a:	00006697          	auipc	a3,0x6
ffffffffc0207d6e:	73668693          	addi	a3,a3,1846 # ffffffffc020e4a0 <syscalls+0x9b0>
ffffffffc0207d72:	00004617          	auipc	a2,0x4
ffffffffc0207d76:	a9660613          	addi	a2,a2,-1386 # ffffffffc020b808 <commands+0x60>
ffffffffc0207d7a:	07800593          	li	a1,120
ffffffffc0207d7e:	00006517          	auipc	a0,0x6
ffffffffc0207d82:	6ea50513          	addi	a0,a0,1770 # ffffffffc020e468 <syscalls+0x978>
ffffffffc0207d86:	ca8f80ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0207d8a <get_device>:
ffffffffc0207d8a:	7179                	addi	sp,sp,-48
ffffffffc0207d8c:	ec26                	sd	s1,24(sp)
ffffffffc0207d8e:	e84a                	sd	s2,16(sp)
ffffffffc0207d90:	f406                	sd	ra,40(sp)
ffffffffc0207d92:	f022                	sd	s0,32(sp)
ffffffffc0207d94:	00054303          	lbu	t1,0(a0)
ffffffffc0207d98:	892e                	mv	s2,a1
ffffffffc0207d9a:	84b2                	mv	s1,a2
ffffffffc0207d9c:	02030463          	beqz	t1,ffffffffc0207dc4 <get_device+0x3a>
ffffffffc0207da0:	00150413          	addi	s0,a0,1
ffffffffc0207da4:	86a2                	mv	a3,s0
ffffffffc0207da6:	879a                	mv	a5,t1
ffffffffc0207da8:	4701                	li	a4,0
ffffffffc0207daa:	03a00813          	li	a6,58
ffffffffc0207dae:	02f00893          	li	a7,47
ffffffffc0207db2:	03078363          	beq	a5,a6,ffffffffc0207dd8 <get_device+0x4e>
ffffffffc0207db6:	05178a63          	beq	a5,a7,ffffffffc0207e0a <get_device+0x80>
ffffffffc0207dba:	0006c783          	lbu	a5,0(a3)
ffffffffc0207dbe:	2705                	addiw	a4,a4,1
ffffffffc0207dc0:	0685                	addi	a3,a3,1
ffffffffc0207dc2:	fbe5                	bnez	a5,ffffffffc0207db2 <get_device+0x28>
ffffffffc0207dc4:	7402                	ld	s0,32(sp)
ffffffffc0207dc6:	00a93023          	sd	a0,0(s2)
ffffffffc0207dca:	70a2                	ld	ra,40(sp)
ffffffffc0207dcc:	6942                	ld	s2,16(sp)
ffffffffc0207dce:	8526                	mv	a0,s1
ffffffffc0207dd0:	64e2                	ld	s1,24(sp)
ffffffffc0207dd2:	6145                	addi	sp,sp,48
ffffffffc0207dd4:	db5ff06f          	j	ffffffffc0207b88 <vfs_get_curdir>
ffffffffc0207dd8:	cb15                	beqz	a4,ffffffffc0207e0c <get_device+0x82>
ffffffffc0207dda:	00e507b3          	add	a5,a0,a4
ffffffffc0207dde:	0705                	addi	a4,a4,1
ffffffffc0207de0:	00078023          	sb	zero,0(a5)
ffffffffc0207de4:	972a                	add	a4,a4,a0
ffffffffc0207de6:	02f00613          	li	a2,47
ffffffffc0207dea:	00074783          	lbu	a5,0(a4) # 2000 <_binary_bin_swap_img_size-0x5d00>
ffffffffc0207dee:	86ba                	mv	a3,a4
ffffffffc0207df0:	0705                	addi	a4,a4,1
ffffffffc0207df2:	fec78ce3          	beq	a5,a2,ffffffffc0207dea <get_device+0x60>
ffffffffc0207df6:	7402                	ld	s0,32(sp)
ffffffffc0207df8:	70a2                	ld	ra,40(sp)
ffffffffc0207dfa:	00d93023          	sd	a3,0(s2)
ffffffffc0207dfe:	85a6                	mv	a1,s1
ffffffffc0207e00:	6942                	ld	s2,16(sp)
ffffffffc0207e02:	64e2                	ld	s1,24(sp)
ffffffffc0207e04:	6145                	addi	sp,sp,48
ffffffffc0207e06:	b67ff06f          	j	ffffffffc020796c <vfs_get_root>
ffffffffc0207e0a:	ff4d                	bnez	a4,ffffffffc0207dc4 <get_device+0x3a>
ffffffffc0207e0c:	02f00793          	li	a5,47
ffffffffc0207e10:	04f30563          	beq	t1,a5,ffffffffc0207e5a <get_device+0xd0>
ffffffffc0207e14:	03a00793          	li	a5,58
ffffffffc0207e18:	06f31663          	bne	t1,a5,ffffffffc0207e84 <get_device+0xfa>
ffffffffc0207e1c:	0028                	addi	a0,sp,8
ffffffffc0207e1e:	d6bff0ef          	jal	ra,ffffffffc0207b88 <vfs_get_curdir>
ffffffffc0207e22:	e515                	bnez	a0,ffffffffc0207e4e <get_device+0xc4>
ffffffffc0207e24:	67a2                	ld	a5,8(sp)
ffffffffc0207e26:	77a8                	ld	a0,104(a5)
ffffffffc0207e28:	cd15                	beqz	a0,ffffffffc0207e64 <get_device+0xda>
ffffffffc0207e2a:	617c                	ld	a5,192(a0)
ffffffffc0207e2c:	9782                	jalr	a5
ffffffffc0207e2e:	87aa                	mv	a5,a0
ffffffffc0207e30:	6522                	ld	a0,8(sp)
ffffffffc0207e32:	e09c                	sd	a5,0(s1)
ffffffffc0207e34:	27c000ef          	jal	ra,ffffffffc02080b0 <inode_ref_dec>
ffffffffc0207e38:	02f00713          	li	a4,47
ffffffffc0207e3c:	a011                	j	ffffffffc0207e40 <get_device+0xb6>
ffffffffc0207e3e:	0405                	addi	s0,s0,1
ffffffffc0207e40:	00044783          	lbu	a5,0(s0)
ffffffffc0207e44:	fee78de3          	beq	a5,a4,ffffffffc0207e3e <get_device+0xb4>
ffffffffc0207e48:	00893023          	sd	s0,0(s2)
ffffffffc0207e4c:	4501                	li	a0,0
ffffffffc0207e4e:	70a2                	ld	ra,40(sp)
ffffffffc0207e50:	7402                	ld	s0,32(sp)
ffffffffc0207e52:	64e2                	ld	s1,24(sp)
ffffffffc0207e54:	6942                	ld	s2,16(sp)
ffffffffc0207e56:	6145                	addi	sp,sp,48
ffffffffc0207e58:	8082                	ret
ffffffffc0207e5a:	8526                	mv	a0,s1
ffffffffc0207e5c:	616000ef          	jal	ra,ffffffffc0208472 <vfs_get_bootfs>
ffffffffc0207e60:	dd61                	beqz	a0,ffffffffc0207e38 <get_device+0xae>
ffffffffc0207e62:	b7f5                	j	ffffffffc0207e4e <get_device+0xc4>
ffffffffc0207e64:	00006697          	auipc	a3,0x6
ffffffffc0207e68:	62468693          	addi	a3,a3,1572 # ffffffffc020e488 <syscalls+0x998>
ffffffffc0207e6c:	00004617          	auipc	a2,0x4
ffffffffc0207e70:	99c60613          	addi	a2,a2,-1636 # ffffffffc020b808 <commands+0x60>
ffffffffc0207e74:	03900593          	li	a1,57
ffffffffc0207e78:	00006517          	auipc	a0,0x6
ffffffffc0207e7c:	6a050513          	addi	a0,a0,1696 # ffffffffc020e518 <syscalls+0xa28>
ffffffffc0207e80:	baef80ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0207e84:	00006697          	auipc	a3,0x6
ffffffffc0207e88:	68468693          	addi	a3,a3,1668 # ffffffffc020e508 <syscalls+0xa18>
ffffffffc0207e8c:	00004617          	auipc	a2,0x4
ffffffffc0207e90:	97c60613          	addi	a2,a2,-1668 # ffffffffc020b808 <commands+0x60>
ffffffffc0207e94:	03300593          	li	a1,51
ffffffffc0207e98:	00006517          	auipc	a0,0x6
ffffffffc0207e9c:	68050513          	addi	a0,a0,1664 # ffffffffc020e518 <syscalls+0xa28>
ffffffffc0207ea0:	b8ef80ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0207ea4 <vfs_lookup>:
ffffffffc0207ea4:	7139                	addi	sp,sp,-64
ffffffffc0207ea6:	f426                	sd	s1,40(sp)
ffffffffc0207ea8:	0830                	addi	a2,sp,24
ffffffffc0207eaa:	84ae                	mv	s1,a1
ffffffffc0207eac:	002c                	addi	a1,sp,8
ffffffffc0207eae:	f822                	sd	s0,48(sp)
ffffffffc0207eb0:	fc06                	sd	ra,56(sp)
ffffffffc0207eb2:	f04a                	sd	s2,32(sp)
ffffffffc0207eb4:	e42a                	sd	a0,8(sp)
ffffffffc0207eb6:	ed5ff0ef          	jal	ra,ffffffffc0207d8a <get_device>
ffffffffc0207eba:	842a                	mv	s0,a0
ffffffffc0207ebc:	ed1d                	bnez	a0,ffffffffc0207efa <vfs_lookup+0x56>
ffffffffc0207ebe:	67a2                	ld	a5,8(sp)
ffffffffc0207ec0:	6962                	ld	s2,24(sp)
ffffffffc0207ec2:	0007c783          	lbu	a5,0(a5)
ffffffffc0207ec6:	c3a9                	beqz	a5,ffffffffc0207f08 <vfs_lookup+0x64>
ffffffffc0207ec8:	04090963          	beqz	s2,ffffffffc0207f1a <vfs_lookup+0x76>
ffffffffc0207ecc:	07093783          	ld	a5,112(s2)
ffffffffc0207ed0:	c7a9                	beqz	a5,ffffffffc0207f1a <vfs_lookup+0x76>
ffffffffc0207ed2:	7bbc                	ld	a5,112(a5)
ffffffffc0207ed4:	c3b9                	beqz	a5,ffffffffc0207f1a <vfs_lookup+0x76>
ffffffffc0207ed6:	854a                	mv	a0,s2
ffffffffc0207ed8:	00006597          	auipc	a1,0x6
ffffffffc0207edc:	6a858593          	addi	a1,a1,1704 # ffffffffc020e580 <syscalls+0xa90>
ffffffffc0207ee0:	11a000ef          	jal	ra,ffffffffc0207ffa <inode_check>
ffffffffc0207ee4:	07093783          	ld	a5,112(s2)
ffffffffc0207ee8:	65a2                	ld	a1,8(sp)
ffffffffc0207eea:	6562                	ld	a0,24(sp)
ffffffffc0207eec:	7bbc                	ld	a5,112(a5)
ffffffffc0207eee:	8626                	mv	a2,s1
ffffffffc0207ef0:	9782                	jalr	a5
ffffffffc0207ef2:	842a                	mv	s0,a0
ffffffffc0207ef4:	6562                	ld	a0,24(sp)
ffffffffc0207ef6:	1ba000ef          	jal	ra,ffffffffc02080b0 <inode_ref_dec>
ffffffffc0207efa:	70e2                	ld	ra,56(sp)
ffffffffc0207efc:	8522                	mv	a0,s0
ffffffffc0207efe:	7442                	ld	s0,48(sp)
ffffffffc0207f00:	74a2                	ld	s1,40(sp)
ffffffffc0207f02:	7902                	ld	s2,32(sp)
ffffffffc0207f04:	6121                	addi	sp,sp,64
ffffffffc0207f06:	8082                	ret
ffffffffc0207f08:	70e2                	ld	ra,56(sp)
ffffffffc0207f0a:	8522                	mv	a0,s0
ffffffffc0207f0c:	7442                	ld	s0,48(sp)
ffffffffc0207f0e:	0124b023          	sd	s2,0(s1)
ffffffffc0207f12:	74a2                	ld	s1,40(sp)
ffffffffc0207f14:	7902                	ld	s2,32(sp)
ffffffffc0207f16:	6121                	addi	sp,sp,64
ffffffffc0207f18:	8082                	ret
ffffffffc0207f1a:	00006697          	auipc	a3,0x6
ffffffffc0207f1e:	61668693          	addi	a3,a3,1558 # ffffffffc020e530 <syscalls+0xa40>
ffffffffc0207f22:	00004617          	auipc	a2,0x4
ffffffffc0207f26:	8e660613          	addi	a2,a2,-1818 # ffffffffc020b808 <commands+0x60>
ffffffffc0207f2a:	04f00593          	li	a1,79
ffffffffc0207f2e:	00006517          	auipc	a0,0x6
ffffffffc0207f32:	5ea50513          	addi	a0,a0,1514 # ffffffffc020e518 <syscalls+0xa28>
ffffffffc0207f36:	af8f80ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0207f3a <vfs_lookup_parent>:
ffffffffc0207f3a:	7139                	addi	sp,sp,-64
ffffffffc0207f3c:	f822                	sd	s0,48(sp)
ffffffffc0207f3e:	f426                	sd	s1,40(sp)
ffffffffc0207f40:	842e                	mv	s0,a1
ffffffffc0207f42:	84b2                	mv	s1,a2
ffffffffc0207f44:	002c                	addi	a1,sp,8
ffffffffc0207f46:	0830                	addi	a2,sp,24
ffffffffc0207f48:	fc06                	sd	ra,56(sp)
ffffffffc0207f4a:	e42a                	sd	a0,8(sp)
ffffffffc0207f4c:	e3fff0ef          	jal	ra,ffffffffc0207d8a <get_device>
ffffffffc0207f50:	e509                	bnez	a0,ffffffffc0207f5a <vfs_lookup_parent+0x20>
ffffffffc0207f52:	67a2                	ld	a5,8(sp)
ffffffffc0207f54:	e09c                	sd	a5,0(s1)
ffffffffc0207f56:	67e2                	ld	a5,24(sp)
ffffffffc0207f58:	e01c                	sd	a5,0(s0)
ffffffffc0207f5a:	70e2                	ld	ra,56(sp)
ffffffffc0207f5c:	7442                	ld	s0,48(sp)
ffffffffc0207f5e:	74a2                	ld	s1,40(sp)
ffffffffc0207f60:	6121                	addi	sp,sp,64
ffffffffc0207f62:	8082                	ret

ffffffffc0207f64 <__alloc_inode>:
ffffffffc0207f64:	1141                	addi	sp,sp,-16
ffffffffc0207f66:	e022                	sd	s0,0(sp)
ffffffffc0207f68:	842a                	mv	s0,a0
ffffffffc0207f6a:	07800513          	li	a0,120
ffffffffc0207f6e:	e406                	sd	ra,8(sp)
ffffffffc0207f70:	857fb0ef          	jal	ra,ffffffffc02037c6 <kmalloc>
ffffffffc0207f74:	c111                	beqz	a0,ffffffffc0207f78 <__alloc_inode+0x14>
ffffffffc0207f76:	cd20                	sw	s0,88(a0)
ffffffffc0207f78:	60a2                	ld	ra,8(sp)
ffffffffc0207f7a:	6402                	ld	s0,0(sp)
ffffffffc0207f7c:	0141                	addi	sp,sp,16
ffffffffc0207f7e:	8082                	ret

ffffffffc0207f80 <inode_init>:
ffffffffc0207f80:	4785                	li	a5,1
ffffffffc0207f82:	06052023          	sw	zero,96(a0)
ffffffffc0207f86:	f92c                	sd	a1,112(a0)
ffffffffc0207f88:	f530                	sd	a2,104(a0)
ffffffffc0207f8a:	cd7c                	sw	a5,92(a0)
ffffffffc0207f8c:	8082                	ret

ffffffffc0207f8e <inode_kill>:
ffffffffc0207f8e:	4d78                	lw	a4,92(a0)
ffffffffc0207f90:	1141                	addi	sp,sp,-16
ffffffffc0207f92:	e406                	sd	ra,8(sp)
ffffffffc0207f94:	e719                	bnez	a4,ffffffffc0207fa2 <inode_kill+0x14>
ffffffffc0207f96:	513c                	lw	a5,96(a0)
ffffffffc0207f98:	e78d                	bnez	a5,ffffffffc0207fc2 <inode_kill+0x34>
ffffffffc0207f9a:	60a2                	ld	ra,8(sp)
ffffffffc0207f9c:	0141                	addi	sp,sp,16
ffffffffc0207f9e:	8d9fb06f          	j	ffffffffc0203876 <kfree>
ffffffffc0207fa2:	00006697          	auipc	a3,0x6
ffffffffc0207fa6:	5e668693          	addi	a3,a3,1510 # ffffffffc020e588 <syscalls+0xa98>
ffffffffc0207faa:	00004617          	auipc	a2,0x4
ffffffffc0207fae:	85e60613          	addi	a2,a2,-1954 # ffffffffc020b808 <commands+0x60>
ffffffffc0207fb2:	02900593          	li	a1,41
ffffffffc0207fb6:	00006517          	auipc	a0,0x6
ffffffffc0207fba:	5f250513          	addi	a0,a0,1522 # ffffffffc020e5a8 <syscalls+0xab8>
ffffffffc0207fbe:	a70f80ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0207fc2:	00006697          	auipc	a3,0x6
ffffffffc0207fc6:	5fe68693          	addi	a3,a3,1534 # ffffffffc020e5c0 <syscalls+0xad0>
ffffffffc0207fca:	00004617          	auipc	a2,0x4
ffffffffc0207fce:	83e60613          	addi	a2,a2,-1986 # ffffffffc020b808 <commands+0x60>
ffffffffc0207fd2:	02a00593          	li	a1,42
ffffffffc0207fd6:	00006517          	auipc	a0,0x6
ffffffffc0207fda:	5d250513          	addi	a0,a0,1490 # ffffffffc020e5a8 <syscalls+0xab8>
ffffffffc0207fde:	a50f80ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0207fe2 <inode_ref_inc>:
ffffffffc0207fe2:	4d7c                	lw	a5,92(a0)
ffffffffc0207fe4:	2785                	addiw	a5,a5,1
ffffffffc0207fe6:	cd7c                	sw	a5,92(a0)
ffffffffc0207fe8:	0007851b          	sext.w	a0,a5
ffffffffc0207fec:	8082                	ret

ffffffffc0207fee <inode_open_inc>:
ffffffffc0207fee:	513c                	lw	a5,96(a0)
ffffffffc0207ff0:	2785                	addiw	a5,a5,1
ffffffffc0207ff2:	d13c                	sw	a5,96(a0)
ffffffffc0207ff4:	0007851b          	sext.w	a0,a5
ffffffffc0207ff8:	8082                	ret

ffffffffc0207ffa <inode_check>:
ffffffffc0207ffa:	1141                	addi	sp,sp,-16
ffffffffc0207ffc:	e406                	sd	ra,8(sp)
ffffffffc0207ffe:	c90d                	beqz	a0,ffffffffc0208030 <inode_check+0x36>
ffffffffc0208000:	793c                	ld	a5,112(a0)
ffffffffc0208002:	c79d                	beqz	a5,ffffffffc0208030 <inode_check+0x36>
ffffffffc0208004:	6398                	ld	a4,0(a5)
ffffffffc0208006:	4625d7b7          	lui	a5,0x4625d
ffffffffc020800a:	0786                	slli	a5,a5,0x1
ffffffffc020800c:	47678793          	addi	a5,a5,1142 # 4625d476 <_binary_bin_sfs_img_size+0x461e8176>
ffffffffc0208010:	08f71063          	bne	a4,a5,ffffffffc0208090 <inode_check+0x96>
ffffffffc0208014:	4d78                	lw	a4,92(a0)
ffffffffc0208016:	513c                	lw	a5,96(a0)
ffffffffc0208018:	04f74c63          	blt	a4,a5,ffffffffc0208070 <inode_check+0x76>
ffffffffc020801c:	0407ca63          	bltz	a5,ffffffffc0208070 <inode_check+0x76>
ffffffffc0208020:	66c1                	lui	a3,0x10
ffffffffc0208022:	02d75763          	bge	a4,a3,ffffffffc0208050 <inode_check+0x56>
ffffffffc0208026:	02d7d563          	bge	a5,a3,ffffffffc0208050 <inode_check+0x56>
ffffffffc020802a:	60a2                	ld	ra,8(sp)
ffffffffc020802c:	0141                	addi	sp,sp,16
ffffffffc020802e:	8082                	ret
ffffffffc0208030:	00006697          	auipc	a3,0x6
ffffffffc0208034:	5b068693          	addi	a3,a3,1456 # ffffffffc020e5e0 <syscalls+0xaf0>
ffffffffc0208038:	00003617          	auipc	a2,0x3
ffffffffc020803c:	7d060613          	addi	a2,a2,2000 # ffffffffc020b808 <commands+0x60>
ffffffffc0208040:	06e00593          	li	a1,110
ffffffffc0208044:	00006517          	auipc	a0,0x6
ffffffffc0208048:	56450513          	addi	a0,a0,1380 # ffffffffc020e5a8 <syscalls+0xab8>
ffffffffc020804c:	9e2f80ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0208050:	00006697          	auipc	a3,0x6
ffffffffc0208054:	61068693          	addi	a3,a3,1552 # ffffffffc020e660 <syscalls+0xb70>
ffffffffc0208058:	00003617          	auipc	a2,0x3
ffffffffc020805c:	7b060613          	addi	a2,a2,1968 # ffffffffc020b808 <commands+0x60>
ffffffffc0208060:	07200593          	li	a1,114
ffffffffc0208064:	00006517          	auipc	a0,0x6
ffffffffc0208068:	54450513          	addi	a0,a0,1348 # ffffffffc020e5a8 <syscalls+0xab8>
ffffffffc020806c:	9c2f80ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0208070:	00006697          	auipc	a3,0x6
ffffffffc0208074:	5c068693          	addi	a3,a3,1472 # ffffffffc020e630 <syscalls+0xb40>
ffffffffc0208078:	00003617          	auipc	a2,0x3
ffffffffc020807c:	79060613          	addi	a2,a2,1936 # ffffffffc020b808 <commands+0x60>
ffffffffc0208080:	07100593          	li	a1,113
ffffffffc0208084:	00006517          	auipc	a0,0x6
ffffffffc0208088:	52450513          	addi	a0,a0,1316 # ffffffffc020e5a8 <syscalls+0xab8>
ffffffffc020808c:	9a2f80ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0208090:	00006697          	auipc	a3,0x6
ffffffffc0208094:	57868693          	addi	a3,a3,1400 # ffffffffc020e608 <syscalls+0xb18>
ffffffffc0208098:	00003617          	auipc	a2,0x3
ffffffffc020809c:	77060613          	addi	a2,a2,1904 # ffffffffc020b808 <commands+0x60>
ffffffffc02080a0:	06f00593          	li	a1,111
ffffffffc02080a4:	00006517          	auipc	a0,0x6
ffffffffc02080a8:	50450513          	addi	a0,a0,1284 # ffffffffc020e5a8 <syscalls+0xab8>
ffffffffc02080ac:	982f80ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02080b0 <inode_ref_dec>:
ffffffffc02080b0:	4d7c                	lw	a5,92(a0)
ffffffffc02080b2:	1101                	addi	sp,sp,-32
ffffffffc02080b4:	ec06                	sd	ra,24(sp)
ffffffffc02080b6:	e822                	sd	s0,16(sp)
ffffffffc02080b8:	e426                	sd	s1,8(sp)
ffffffffc02080ba:	e04a                	sd	s2,0(sp)
ffffffffc02080bc:	06f05e63          	blez	a5,ffffffffc0208138 <inode_ref_dec+0x88>
ffffffffc02080c0:	fff7849b          	addiw	s1,a5,-1
ffffffffc02080c4:	cd64                	sw	s1,92(a0)
ffffffffc02080c6:	842a                	mv	s0,a0
ffffffffc02080c8:	e09d                	bnez	s1,ffffffffc02080ee <inode_ref_dec+0x3e>
ffffffffc02080ca:	793c                	ld	a5,112(a0)
ffffffffc02080cc:	c7b1                	beqz	a5,ffffffffc0208118 <inode_ref_dec+0x68>
ffffffffc02080ce:	0487b903          	ld	s2,72(a5)
ffffffffc02080d2:	04090363          	beqz	s2,ffffffffc0208118 <inode_ref_dec+0x68>
ffffffffc02080d6:	00006597          	auipc	a1,0x6
ffffffffc02080da:	63a58593          	addi	a1,a1,1594 # ffffffffc020e710 <syscalls+0xc20>
ffffffffc02080de:	f1dff0ef          	jal	ra,ffffffffc0207ffa <inode_check>
ffffffffc02080e2:	8522                	mv	a0,s0
ffffffffc02080e4:	9902                	jalr	s2
ffffffffc02080e6:	c501                	beqz	a0,ffffffffc02080ee <inode_ref_dec+0x3e>
ffffffffc02080e8:	57c5                	li	a5,-15
ffffffffc02080ea:	00f51963          	bne	a0,a5,ffffffffc02080fc <inode_ref_dec+0x4c>
ffffffffc02080ee:	60e2                	ld	ra,24(sp)
ffffffffc02080f0:	6442                	ld	s0,16(sp)
ffffffffc02080f2:	6902                	ld	s2,0(sp)
ffffffffc02080f4:	8526                	mv	a0,s1
ffffffffc02080f6:	64a2                	ld	s1,8(sp)
ffffffffc02080f8:	6105                	addi	sp,sp,32
ffffffffc02080fa:	8082                	ret
ffffffffc02080fc:	85aa                	mv	a1,a0
ffffffffc02080fe:	00006517          	auipc	a0,0x6
ffffffffc0208102:	61a50513          	addi	a0,a0,1562 # ffffffffc020e718 <syscalls+0xc28>
ffffffffc0208106:	824f80ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc020810a:	60e2                	ld	ra,24(sp)
ffffffffc020810c:	6442                	ld	s0,16(sp)
ffffffffc020810e:	6902                	ld	s2,0(sp)
ffffffffc0208110:	8526                	mv	a0,s1
ffffffffc0208112:	64a2                	ld	s1,8(sp)
ffffffffc0208114:	6105                	addi	sp,sp,32
ffffffffc0208116:	8082                	ret
ffffffffc0208118:	00006697          	auipc	a3,0x6
ffffffffc020811c:	5a868693          	addi	a3,a3,1448 # ffffffffc020e6c0 <syscalls+0xbd0>
ffffffffc0208120:	00003617          	auipc	a2,0x3
ffffffffc0208124:	6e860613          	addi	a2,a2,1768 # ffffffffc020b808 <commands+0x60>
ffffffffc0208128:	04400593          	li	a1,68
ffffffffc020812c:	00006517          	auipc	a0,0x6
ffffffffc0208130:	47c50513          	addi	a0,a0,1148 # ffffffffc020e5a8 <syscalls+0xab8>
ffffffffc0208134:	8faf80ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0208138:	00006697          	auipc	a3,0x6
ffffffffc020813c:	56868693          	addi	a3,a3,1384 # ffffffffc020e6a0 <syscalls+0xbb0>
ffffffffc0208140:	00003617          	auipc	a2,0x3
ffffffffc0208144:	6c860613          	addi	a2,a2,1736 # ffffffffc020b808 <commands+0x60>
ffffffffc0208148:	03f00593          	li	a1,63
ffffffffc020814c:	00006517          	auipc	a0,0x6
ffffffffc0208150:	45c50513          	addi	a0,a0,1116 # ffffffffc020e5a8 <syscalls+0xab8>
ffffffffc0208154:	8daf80ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0208158 <inode_open_dec>:
ffffffffc0208158:	513c                	lw	a5,96(a0)
ffffffffc020815a:	1101                	addi	sp,sp,-32
ffffffffc020815c:	ec06                	sd	ra,24(sp)
ffffffffc020815e:	e822                	sd	s0,16(sp)
ffffffffc0208160:	e426                	sd	s1,8(sp)
ffffffffc0208162:	e04a                	sd	s2,0(sp)
ffffffffc0208164:	06f05b63          	blez	a5,ffffffffc02081da <inode_open_dec+0x82>
ffffffffc0208168:	fff7849b          	addiw	s1,a5,-1
ffffffffc020816c:	d124                	sw	s1,96(a0)
ffffffffc020816e:	842a                	mv	s0,a0
ffffffffc0208170:	e085                	bnez	s1,ffffffffc0208190 <inode_open_dec+0x38>
ffffffffc0208172:	793c                	ld	a5,112(a0)
ffffffffc0208174:	c3b9                	beqz	a5,ffffffffc02081ba <inode_open_dec+0x62>
ffffffffc0208176:	0107b903          	ld	s2,16(a5)
ffffffffc020817a:	04090063          	beqz	s2,ffffffffc02081ba <inode_open_dec+0x62>
ffffffffc020817e:	00006597          	auipc	a1,0x6
ffffffffc0208182:	62a58593          	addi	a1,a1,1578 # ffffffffc020e7a8 <syscalls+0xcb8>
ffffffffc0208186:	e75ff0ef          	jal	ra,ffffffffc0207ffa <inode_check>
ffffffffc020818a:	8522                	mv	a0,s0
ffffffffc020818c:	9902                	jalr	s2
ffffffffc020818e:	e901                	bnez	a0,ffffffffc020819e <inode_open_dec+0x46>
ffffffffc0208190:	60e2                	ld	ra,24(sp)
ffffffffc0208192:	6442                	ld	s0,16(sp)
ffffffffc0208194:	6902                	ld	s2,0(sp)
ffffffffc0208196:	8526                	mv	a0,s1
ffffffffc0208198:	64a2                	ld	s1,8(sp)
ffffffffc020819a:	6105                	addi	sp,sp,32
ffffffffc020819c:	8082                	ret
ffffffffc020819e:	85aa                	mv	a1,a0
ffffffffc02081a0:	00006517          	auipc	a0,0x6
ffffffffc02081a4:	61050513          	addi	a0,a0,1552 # ffffffffc020e7b0 <syscalls+0xcc0>
ffffffffc02081a8:	f83f70ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc02081ac:	60e2                	ld	ra,24(sp)
ffffffffc02081ae:	6442                	ld	s0,16(sp)
ffffffffc02081b0:	6902                	ld	s2,0(sp)
ffffffffc02081b2:	8526                	mv	a0,s1
ffffffffc02081b4:	64a2                	ld	s1,8(sp)
ffffffffc02081b6:	6105                	addi	sp,sp,32
ffffffffc02081b8:	8082                	ret
ffffffffc02081ba:	00006697          	auipc	a3,0x6
ffffffffc02081be:	59e68693          	addi	a3,a3,1438 # ffffffffc020e758 <syscalls+0xc68>
ffffffffc02081c2:	00003617          	auipc	a2,0x3
ffffffffc02081c6:	64660613          	addi	a2,a2,1606 # ffffffffc020b808 <commands+0x60>
ffffffffc02081ca:	06100593          	li	a1,97
ffffffffc02081ce:	00006517          	auipc	a0,0x6
ffffffffc02081d2:	3da50513          	addi	a0,a0,986 # ffffffffc020e5a8 <syscalls+0xab8>
ffffffffc02081d6:	858f80ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02081da:	00006697          	auipc	a3,0x6
ffffffffc02081de:	55e68693          	addi	a3,a3,1374 # ffffffffc020e738 <syscalls+0xc48>
ffffffffc02081e2:	00003617          	auipc	a2,0x3
ffffffffc02081e6:	62660613          	addi	a2,a2,1574 # ffffffffc020b808 <commands+0x60>
ffffffffc02081ea:	05c00593          	li	a1,92
ffffffffc02081ee:	00006517          	auipc	a0,0x6
ffffffffc02081f2:	3ba50513          	addi	a0,a0,954 # ffffffffc020e5a8 <syscalls+0xab8>
ffffffffc02081f6:	838f80ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02081fa <vfs_open>:
ffffffffc02081fa:	711d                	addi	sp,sp,-96
ffffffffc02081fc:	e4a6                	sd	s1,72(sp)
ffffffffc02081fe:	e0ca                	sd	s2,64(sp)
ffffffffc0208200:	fc4e                	sd	s3,56(sp)
ffffffffc0208202:	ec86                	sd	ra,88(sp)
ffffffffc0208204:	e8a2                	sd	s0,80(sp)
ffffffffc0208206:	f852                	sd	s4,48(sp)
ffffffffc0208208:	f456                	sd	s5,40(sp)
ffffffffc020820a:	0035f793          	andi	a5,a1,3
ffffffffc020820e:	84ae                	mv	s1,a1
ffffffffc0208210:	892a                	mv	s2,a0
ffffffffc0208212:	89b2                	mv	s3,a2
ffffffffc0208214:	0e078663          	beqz	a5,ffffffffc0208300 <vfs_open+0x106>
ffffffffc0208218:	470d                	li	a4,3
ffffffffc020821a:	0105fa93          	andi	s5,a1,16
ffffffffc020821e:	0ce78f63          	beq	a5,a4,ffffffffc02082fc <vfs_open+0x102>
ffffffffc0208222:	002c                	addi	a1,sp,8
ffffffffc0208224:	854a                	mv	a0,s2
ffffffffc0208226:	c7fff0ef          	jal	ra,ffffffffc0207ea4 <vfs_lookup>
ffffffffc020822a:	842a                	mv	s0,a0
ffffffffc020822c:	0044fa13          	andi	s4,s1,4
ffffffffc0208230:	e159                	bnez	a0,ffffffffc02082b6 <vfs_open+0xbc>
ffffffffc0208232:	00c4f793          	andi	a5,s1,12
ffffffffc0208236:	4731                	li	a4,12
ffffffffc0208238:	0ee78263          	beq	a5,a4,ffffffffc020831c <vfs_open+0x122>
ffffffffc020823c:	6422                	ld	s0,8(sp)
ffffffffc020823e:	12040163          	beqz	s0,ffffffffc0208360 <vfs_open+0x166>
ffffffffc0208242:	783c                	ld	a5,112(s0)
ffffffffc0208244:	cff1                	beqz	a5,ffffffffc0208320 <vfs_open+0x126>
ffffffffc0208246:	679c                	ld	a5,8(a5)
ffffffffc0208248:	cfe1                	beqz	a5,ffffffffc0208320 <vfs_open+0x126>
ffffffffc020824a:	8522                	mv	a0,s0
ffffffffc020824c:	00006597          	auipc	a1,0x6
ffffffffc0208250:	65458593          	addi	a1,a1,1620 # ffffffffc020e8a0 <syscalls+0xdb0>
ffffffffc0208254:	da7ff0ef          	jal	ra,ffffffffc0207ffa <inode_check>
ffffffffc0208258:	783c                	ld	a5,112(s0)
ffffffffc020825a:	6522                	ld	a0,8(sp)
ffffffffc020825c:	85a6                	mv	a1,s1
ffffffffc020825e:	679c                	ld	a5,8(a5)
ffffffffc0208260:	9782                	jalr	a5
ffffffffc0208262:	842a                	mv	s0,a0
ffffffffc0208264:	6522                	ld	a0,8(sp)
ffffffffc0208266:	e845                	bnez	s0,ffffffffc0208316 <vfs_open+0x11c>
ffffffffc0208268:	015a6a33          	or	s4,s4,s5
ffffffffc020826c:	d83ff0ef          	jal	ra,ffffffffc0207fee <inode_open_inc>
ffffffffc0208270:	020a0663          	beqz	s4,ffffffffc020829c <vfs_open+0xa2>
ffffffffc0208274:	64a2                	ld	s1,8(sp)
ffffffffc0208276:	c4e9                	beqz	s1,ffffffffc0208340 <vfs_open+0x146>
ffffffffc0208278:	78bc                	ld	a5,112(s1)
ffffffffc020827a:	c3f9                	beqz	a5,ffffffffc0208340 <vfs_open+0x146>
ffffffffc020827c:	73bc                	ld	a5,96(a5)
ffffffffc020827e:	c3e9                	beqz	a5,ffffffffc0208340 <vfs_open+0x146>
ffffffffc0208280:	00006597          	auipc	a1,0x6
ffffffffc0208284:	68058593          	addi	a1,a1,1664 # ffffffffc020e900 <syscalls+0xe10>
ffffffffc0208288:	8526                	mv	a0,s1
ffffffffc020828a:	d71ff0ef          	jal	ra,ffffffffc0207ffa <inode_check>
ffffffffc020828e:	78bc                	ld	a5,112(s1)
ffffffffc0208290:	6522                	ld	a0,8(sp)
ffffffffc0208292:	4581                	li	a1,0
ffffffffc0208294:	73bc                	ld	a5,96(a5)
ffffffffc0208296:	9782                	jalr	a5
ffffffffc0208298:	87aa                	mv	a5,a0
ffffffffc020829a:	e92d                	bnez	a0,ffffffffc020830c <vfs_open+0x112>
ffffffffc020829c:	67a2                	ld	a5,8(sp)
ffffffffc020829e:	00f9b023          	sd	a5,0(s3)
ffffffffc02082a2:	60e6                	ld	ra,88(sp)
ffffffffc02082a4:	8522                	mv	a0,s0
ffffffffc02082a6:	6446                	ld	s0,80(sp)
ffffffffc02082a8:	64a6                	ld	s1,72(sp)
ffffffffc02082aa:	6906                	ld	s2,64(sp)
ffffffffc02082ac:	79e2                	ld	s3,56(sp)
ffffffffc02082ae:	7a42                	ld	s4,48(sp)
ffffffffc02082b0:	7aa2                	ld	s5,40(sp)
ffffffffc02082b2:	6125                	addi	sp,sp,96
ffffffffc02082b4:	8082                	ret
ffffffffc02082b6:	57c1                	li	a5,-16
ffffffffc02082b8:	fef515e3          	bne	a0,a5,ffffffffc02082a2 <vfs_open+0xa8>
ffffffffc02082bc:	fe0a03e3          	beqz	s4,ffffffffc02082a2 <vfs_open+0xa8>
ffffffffc02082c0:	0810                	addi	a2,sp,16
ffffffffc02082c2:	082c                	addi	a1,sp,24
ffffffffc02082c4:	854a                	mv	a0,s2
ffffffffc02082c6:	c75ff0ef          	jal	ra,ffffffffc0207f3a <vfs_lookup_parent>
ffffffffc02082ca:	842a                	mv	s0,a0
ffffffffc02082cc:	f979                	bnez	a0,ffffffffc02082a2 <vfs_open+0xa8>
ffffffffc02082ce:	6462                	ld	s0,24(sp)
ffffffffc02082d0:	c845                	beqz	s0,ffffffffc0208380 <vfs_open+0x186>
ffffffffc02082d2:	783c                	ld	a5,112(s0)
ffffffffc02082d4:	c7d5                	beqz	a5,ffffffffc0208380 <vfs_open+0x186>
ffffffffc02082d6:	77bc                	ld	a5,104(a5)
ffffffffc02082d8:	c7c5                	beqz	a5,ffffffffc0208380 <vfs_open+0x186>
ffffffffc02082da:	8522                	mv	a0,s0
ffffffffc02082dc:	00006597          	auipc	a1,0x6
ffffffffc02082e0:	55c58593          	addi	a1,a1,1372 # ffffffffc020e838 <syscalls+0xd48>
ffffffffc02082e4:	d17ff0ef          	jal	ra,ffffffffc0207ffa <inode_check>
ffffffffc02082e8:	783c                	ld	a5,112(s0)
ffffffffc02082ea:	65c2                	ld	a1,16(sp)
ffffffffc02082ec:	6562                	ld	a0,24(sp)
ffffffffc02082ee:	77bc                	ld	a5,104(a5)
ffffffffc02082f0:	4034d613          	srai	a2,s1,0x3
ffffffffc02082f4:	0034                	addi	a3,sp,8
ffffffffc02082f6:	8a05                	andi	a2,a2,1
ffffffffc02082f8:	9782                	jalr	a5
ffffffffc02082fa:	b789                	j	ffffffffc020823c <vfs_open+0x42>
ffffffffc02082fc:	5475                	li	s0,-3
ffffffffc02082fe:	b755                	j	ffffffffc02082a2 <vfs_open+0xa8>
ffffffffc0208300:	0105fa93          	andi	s5,a1,16
ffffffffc0208304:	5475                	li	s0,-3
ffffffffc0208306:	f80a9ee3          	bnez	s5,ffffffffc02082a2 <vfs_open+0xa8>
ffffffffc020830a:	bf21                	j	ffffffffc0208222 <vfs_open+0x28>
ffffffffc020830c:	6522                	ld	a0,8(sp)
ffffffffc020830e:	843e                	mv	s0,a5
ffffffffc0208310:	e49ff0ef          	jal	ra,ffffffffc0208158 <inode_open_dec>
ffffffffc0208314:	6522                	ld	a0,8(sp)
ffffffffc0208316:	d9bff0ef          	jal	ra,ffffffffc02080b0 <inode_ref_dec>
ffffffffc020831a:	b761                	j	ffffffffc02082a2 <vfs_open+0xa8>
ffffffffc020831c:	5425                	li	s0,-23
ffffffffc020831e:	b751                	j	ffffffffc02082a2 <vfs_open+0xa8>
ffffffffc0208320:	00006697          	auipc	a3,0x6
ffffffffc0208324:	53068693          	addi	a3,a3,1328 # ffffffffc020e850 <syscalls+0xd60>
ffffffffc0208328:	00003617          	auipc	a2,0x3
ffffffffc020832c:	4e060613          	addi	a2,a2,1248 # ffffffffc020b808 <commands+0x60>
ffffffffc0208330:	03300593          	li	a1,51
ffffffffc0208334:	00006517          	auipc	a0,0x6
ffffffffc0208338:	4ec50513          	addi	a0,a0,1260 # ffffffffc020e820 <syscalls+0xd30>
ffffffffc020833c:	ef3f70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0208340:	00006697          	auipc	a3,0x6
ffffffffc0208344:	56868693          	addi	a3,a3,1384 # ffffffffc020e8a8 <syscalls+0xdb8>
ffffffffc0208348:	00003617          	auipc	a2,0x3
ffffffffc020834c:	4c060613          	addi	a2,a2,1216 # ffffffffc020b808 <commands+0x60>
ffffffffc0208350:	03a00593          	li	a1,58
ffffffffc0208354:	00006517          	auipc	a0,0x6
ffffffffc0208358:	4cc50513          	addi	a0,a0,1228 # ffffffffc020e820 <syscalls+0xd30>
ffffffffc020835c:	ed3f70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0208360:	00006697          	auipc	a3,0x6
ffffffffc0208364:	4e068693          	addi	a3,a3,1248 # ffffffffc020e840 <syscalls+0xd50>
ffffffffc0208368:	00003617          	auipc	a2,0x3
ffffffffc020836c:	4a060613          	addi	a2,a2,1184 # ffffffffc020b808 <commands+0x60>
ffffffffc0208370:	03100593          	li	a1,49
ffffffffc0208374:	00006517          	auipc	a0,0x6
ffffffffc0208378:	4ac50513          	addi	a0,a0,1196 # ffffffffc020e820 <syscalls+0xd30>
ffffffffc020837c:	eb3f70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0208380:	00006697          	auipc	a3,0x6
ffffffffc0208384:	45068693          	addi	a3,a3,1104 # ffffffffc020e7d0 <syscalls+0xce0>
ffffffffc0208388:	00003617          	auipc	a2,0x3
ffffffffc020838c:	48060613          	addi	a2,a2,1152 # ffffffffc020b808 <commands+0x60>
ffffffffc0208390:	02c00593          	li	a1,44
ffffffffc0208394:	00006517          	auipc	a0,0x6
ffffffffc0208398:	48c50513          	addi	a0,a0,1164 # ffffffffc020e820 <syscalls+0xd30>
ffffffffc020839c:	e93f70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02083a0 <vfs_close>:
ffffffffc02083a0:	1141                	addi	sp,sp,-16
ffffffffc02083a2:	e406                	sd	ra,8(sp)
ffffffffc02083a4:	e022                	sd	s0,0(sp)
ffffffffc02083a6:	842a                	mv	s0,a0
ffffffffc02083a8:	db1ff0ef          	jal	ra,ffffffffc0208158 <inode_open_dec>
ffffffffc02083ac:	8522                	mv	a0,s0
ffffffffc02083ae:	d03ff0ef          	jal	ra,ffffffffc02080b0 <inode_ref_dec>
ffffffffc02083b2:	60a2                	ld	ra,8(sp)
ffffffffc02083b4:	6402                	ld	s0,0(sp)
ffffffffc02083b6:	4501                	li	a0,0
ffffffffc02083b8:	0141                	addi	sp,sp,16
ffffffffc02083ba:	8082                	ret

ffffffffc02083bc <__alloc_fs>:
ffffffffc02083bc:	1141                	addi	sp,sp,-16
ffffffffc02083be:	e022                	sd	s0,0(sp)
ffffffffc02083c0:	842a                	mv	s0,a0
ffffffffc02083c2:	0d800513          	li	a0,216
ffffffffc02083c6:	e406                	sd	ra,8(sp)
ffffffffc02083c8:	bfefb0ef          	jal	ra,ffffffffc02037c6 <kmalloc>
ffffffffc02083cc:	c119                	beqz	a0,ffffffffc02083d2 <__alloc_fs+0x16>
ffffffffc02083ce:	0a852823          	sw	s0,176(a0)
ffffffffc02083d2:	60a2                	ld	ra,8(sp)
ffffffffc02083d4:	6402                	ld	s0,0(sp)
ffffffffc02083d6:	0141                	addi	sp,sp,16
ffffffffc02083d8:	8082                	ret

ffffffffc02083da <vfs_init>:
ffffffffc02083da:	1141                	addi	sp,sp,-16
ffffffffc02083dc:	4585                	li	a1,1
ffffffffc02083de:	0008d517          	auipc	a0,0x8d
ffffffffc02083e2:	44a50513          	addi	a0,a0,1098 # ffffffffc0295828 <bootfs_sem>
ffffffffc02083e6:	e406                	sd	ra,8(sp)
ffffffffc02083e8:	b5afc0ef          	jal	ra,ffffffffc0204742 <sem_init>
ffffffffc02083ec:	60a2                	ld	ra,8(sp)
ffffffffc02083ee:	0141                	addi	sp,sp,16
ffffffffc02083f0:	d0aff06f          	j	ffffffffc02078fa <vfs_devlist_init>

ffffffffc02083f4 <vfs_set_bootfs>:
ffffffffc02083f4:	7179                	addi	sp,sp,-48
ffffffffc02083f6:	f022                	sd	s0,32(sp)
ffffffffc02083f8:	f406                	sd	ra,40(sp)
ffffffffc02083fa:	ec26                	sd	s1,24(sp)
ffffffffc02083fc:	e402                	sd	zero,8(sp)
ffffffffc02083fe:	842a                	mv	s0,a0
ffffffffc0208400:	c915                	beqz	a0,ffffffffc0208434 <vfs_set_bootfs+0x40>
ffffffffc0208402:	03a00593          	li	a1,58
ffffffffc0208406:	3e3020ef          	jal	ra,ffffffffc020afe8 <strchr>
ffffffffc020840a:	c135                	beqz	a0,ffffffffc020846e <vfs_set_bootfs+0x7a>
ffffffffc020840c:	00154783          	lbu	a5,1(a0)
ffffffffc0208410:	efb9                	bnez	a5,ffffffffc020846e <vfs_set_bootfs+0x7a>
ffffffffc0208412:	8522                	mv	a0,s0
ffffffffc0208414:	86bff0ef          	jal	ra,ffffffffc0207c7e <vfs_chdir>
ffffffffc0208418:	842a                	mv	s0,a0
ffffffffc020841a:	c519                	beqz	a0,ffffffffc0208428 <vfs_set_bootfs+0x34>
ffffffffc020841c:	70a2                	ld	ra,40(sp)
ffffffffc020841e:	8522                	mv	a0,s0
ffffffffc0208420:	7402                	ld	s0,32(sp)
ffffffffc0208422:	64e2                	ld	s1,24(sp)
ffffffffc0208424:	6145                	addi	sp,sp,48
ffffffffc0208426:	8082                	ret
ffffffffc0208428:	0028                	addi	a0,sp,8
ffffffffc020842a:	f5eff0ef          	jal	ra,ffffffffc0207b88 <vfs_get_curdir>
ffffffffc020842e:	842a                	mv	s0,a0
ffffffffc0208430:	f575                	bnez	a0,ffffffffc020841c <vfs_set_bootfs+0x28>
ffffffffc0208432:	6422                	ld	s0,8(sp)
ffffffffc0208434:	0008d517          	auipc	a0,0x8d
ffffffffc0208438:	3f450513          	addi	a0,a0,1012 # ffffffffc0295828 <bootfs_sem>
ffffffffc020843c:	b12fc0ef          	jal	ra,ffffffffc020474e <down>
ffffffffc0208440:	0008e797          	auipc	a5,0x8e
ffffffffc0208444:	4b078793          	addi	a5,a5,1200 # ffffffffc02968f0 <bootfs_node>
ffffffffc0208448:	6384                	ld	s1,0(a5)
ffffffffc020844a:	0008d517          	auipc	a0,0x8d
ffffffffc020844e:	3de50513          	addi	a0,a0,990 # ffffffffc0295828 <bootfs_sem>
ffffffffc0208452:	e380                	sd	s0,0(a5)
ffffffffc0208454:	4401                	li	s0,0
ffffffffc0208456:	af4fc0ef          	jal	ra,ffffffffc020474a <up>
ffffffffc020845a:	d0e9                	beqz	s1,ffffffffc020841c <vfs_set_bootfs+0x28>
ffffffffc020845c:	8526                	mv	a0,s1
ffffffffc020845e:	c53ff0ef          	jal	ra,ffffffffc02080b0 <inode_ref_dec>
ffffffffc0208462:	70a2                	ld	ra,40(sp)
ffffffffc0208464:	8522                	mv	a0,s0
ffffffffc0208466:	7402                	ld	s0,32(sp)
ffffffffc0208468:	64e2                	ld	s1,24(sp)
ffffffffc020846a:	6145                	addi	sp,sp,48
ffffffffc020846c:	8082                	ret
ffffffffc020846e:	5475                	li	s0,-3
ffffffffc0208470:	b775                	j	ffffffffc020841c <vfs_set_bootfs+0x28>

ffffffffc0208472 <vfs_get_bootfs>:
ffffffffc0208472:	1101                	addi	sp,sp,-32
ffffffffc0208474:	e426                	sd	s1,8(sp)
ffffffffc0208476:	0008e497          	auipc	s1,0x8e
ffffffffc020847a:	47a48493          	addi	s1,s1,1146 # ffffffffc02968f0 <bootfs_node>
ffffffffc020847e:	609c                	ld	a5,0(s1)
ffffffffc0208480:	ec06                	sd	ra,24(sp)
ffffffffc0208482:	e822                	sd	s0,16(sp)
ffffffffc0208484:	c3a1                	beqz	a5,ffffffffc02084c4 <vfs_get_bootfs+0x52>
ffffffffc0208486:	842a                	mv	s0,a0
ffffffffc0208488:	0008d517          	auipc	a0,0x8d
ffffffffc020848c:	3a050513          	addi	a0,a0,928 # ffffffffc0295828 <bootfs_sem>
ffffffffc0208490:	abefc0ef          	jal	ra,ffffffffc020474e <down>
ffffffffc0208494:	6084                	ld	s1,0(s1)
ffffffffc0208496:	c08d                	beqz	s1,ffffffffc02084b8 <vfs_get_bootfs+0x46>
ffffffffc0208498:	8526                	mv	a0,s1
ffffffffc020849a:	b49ff0ef          	jal	ra,ffffffffc0207fe2 <inode_ref_inc>
ffffffffc020849e:	0008d517          	auipc	a0,0x8d
ffffffffc02084a2:	38a50513          	addi	a0,a0,906 # ffffffffc0295828 <bootfs_sem>
ffffffffc02084a6:	aa4fc0ef          	jal	ra,ffffffffc020474a <up>
ffffffffc02084aa:	4501                	li	a0,0
ffffffffc02084ac:	e004                	sd	s1,0(s0)
ffffffffc02084ae:	60e2                	ld	ra,24(sp)
ffffffffc02084b0:	6442                	ld	s0,16(sp)
ffffffffc02084b2:	64a2                	ld	s1,8(sp)
ffffffffc02084b4:	6105                	addi	sp,sp,32
ffffffffc02084b6:	8082                	ret
ffffffffc02084b8:	0008d517          	auipc	a0,0x8d
ffffffffc02084bc:	37050513          	addi	a0,a0,880 # ffffffffc0295828 <bootfs_sem>
ffffffffc02084c0:	a8afc0ef          	jal	ra,ffffffffc020474a <up>
ffffffffc02084c4:	5541                	li	a0,-16
ffffffffc02084c6:	b7e5                	j	ffffffffc02084ae <vfs_get_bootfs+0x3c>

ffffffffc02084c8 <stdin_open>:
ffffffffc02084c8:	4501                	li	a0,0
ffffffffc02084ca:	e191                	bnez	a1,ffffffffc02084ce <stdin_open+0x6>
ffffffffc02084cc:	8082                	ret
ffffffffc02084ce:	5575                	li	a0,-3
ffffffffc02084d0:	8082                	ret

ffffffffc02084d2 <stdin_close>:
ffffffffc02084d2:	4501                	li	a0,0
ffffffffc02084d4:	8082                	ret

ffffffffc02084d6 <stdin_ioctl>:
ffffffffc02084d6:	5575                	li	a0,-3
ffffffffc02084d8:	8082                	ret

ffffffffc02084da <stdin_io>:
ffffffffc02084da:	7135                	addi	sp,sp,-160
ffffffffc02084dc:	ed06                	sd	ra,152(sp)
ffffffffc02084de:	e922                	sd	s0,144(sp)
ffffffffc02084e0:	e526                	sd	s1,136(sp)
ffffffffc02084e2:	e14a                	sd	s2,128(sp)
ffffffffc02084e4:	fcce                	sd	s3,120(sp)
ffffffffc02084e6:	f8d2                	sd	s4,112(sp)
ffffffffc02084e8:	f4d6                	sd	s5,104(sp)
ffffffffc02084ea:	f0da                	sd	s6,96(sp)
ffffffffc02084ec:	ecde                	sd	s7,88(sp)
ffffffffc02084ee:	e8e2                	sd	s8,80(sp)
ffffffffc02084f0:	e4e6                	sd	s9,72(sp)
ffffffffc02084f2:	e0ea                	sd	s10,64(sp)
ffffffffc02084f4:	fc6e                	sd	s11,56(sp)
ffffffffc02084f6:	14061163          	bnez	a2,ffffffffc0208638 <stdin_io+0x15e>
ffffffffc02084fa:	0005bd83          	ld	s11,0(a1)
ffffffffc02084fe:	0185bd03          	ld	s10,24(a1)
ffffffffc0208502:	8b2e                	mv	s6,a1
ffffffffc0208504:	100027f3          	csrr	a5,sstatus
ffffffffc0208508:	8b89                	andi	a5,a5,2
ffffffffc020850a:	10079e63          	bnez	a5,ffffffffc0208626 <stdin_io+0x14c>
ffffffffc020850e:	4401                	li	s0,0
ffffffffc0208510:	100d0963          	beqz	s10,ffffffffc0208622 <stdin_io+0x148>
ffffffffc0208514:	0008e997          	auipc	s3,0x8e
ffffffffc0208518:	3e498993          	addi	s3,s3,996 # ffffffffc02968f8 <p_rpos>
ffffffffc020851c:	0009b783          	ld	a5,0(s3)
ffffffffc0208520:	800004b7          	lui	s1,0x80000
ffffffffc0208524:	6c85                	lui	s9,0x1
ffffffffc0208526:	4a81                	li	s5,0
ffffffffc0208528:	0008ea17          	auipc	s4,0x8e
ffffffffc020852c:	3d8a0a13          	addi	s4,s4,984 # ffffffffc0296900 <p_wpos>
ffffffffc0208530:	0491                	addi	s1,s1,4
ffffffffc0208532:	0008d917          	auipc	s2,0x8d
ffffffffc0208536:	30e90913          	addi	s2,s2,782 # ffffffffc0295840 <__wait_queue>
ffffffffc020853a:	1cfd                	addi	s9,s9,-1
ffffffffc020853c:	000a3703          	ld	a4,0(s4)
ffffffffc0208540:	000a8c1b          	sext.w	s8,s5
ffffffffc0208544:	8be2                	mv	s7,s8
ffffffffc0208546:	02e7d763          	bge	a5,a4,ffffffffc0208574 <stdin_io+0x9a>
ffffffffc020854a:	a859                	j	ffffffffc02085e0 <stdin_io+0x106>
ffffffffc020854c:	cd7fe0ef          	jal	ra,ffffffffc0207222 <schedule>
ffffffffc0208550:	100027f3          	csrr	a5,sstatus
ffffffffc0208554:	8b89                	andi	a5,a5,2
ffffffffc0208556:	4401                	li	s0,0
ffffffffc0208558:	ef8d                	bnez	a5,ffffffffc0208592 <stdin_io+0xb8>
ffffffffc020855a:	0028                	addi	a0,sp,8
ffffffffc020855c:	f23fb0ef          	jal	ra,ffffffffc020447e <wait_in_queue>
ffffffffc0208560:	e121                	bnez	a0,ffffffffc02085a0 <stdin_io+0xc6>
ffffffffc0208562:	47c2                	lw	a5,16(sp)
ffffffffc0208564:	04979563          	bne	a5,s1,ffffffffc02085ae <stdin_io+0xd4>
ffffffffc0208568:	0009b783          	ld	a5,0(s3)
ffffffffc020856c:	000a3703          	ld	a4,0(s4)
ffffffffc0208570:	06e7c863          	blt	a5,a4,ffffffffc02085e0 <stdin_io+0x106>
ffffffffc0208574:	8626                	mv	a2,s1
ffffffffc0208576:	002c                	addi	a1,sp,8
ffffffffc0208578:	854a                	mv	a0,s2
ffffffffc020857a:	82efc0ef          	jal	ra,ffffffffc02045a8 <wait_current_set>
ffffffffc020857e:	d479                	beqz	s0,ffffffffc020854c <stdin_io+0x72>
ffffffffc0208580:	81ff80ef          	jal	ra,ffffffffc0200d9e <intr_enable>
ffffffffc0208584:	c9ffe0ef          	jal	ra,ffffffffc0207222 <schedule>
ffffffffc0208588:	100027f3          	csrr	a5,sstatus
ffffffffc020858c:	8b89                	andi	a5,a5,2
ffffffffc020858e:	4401                	li	s0,0
ffffffffc0208590:	d7e9                	beqz	a5,ffffffffc020855a <stdin_io+0x80>
ffffffffc0208592:	813f80ef          	jal	ra,ffffffffc0200da4 <intr_disable>
ffffffffc0208596:	0028                	addi	a0,sp,8
ffffffffc0208598:	4405                	li	s0,1
ffffffffc020859a:	ee5fb0ef          	jal	ra,ffffffffc020447e <wait_in_queue>
ffffffffc020859e:	d171                	beqz	a0,ffffffffc0208562 <stdin_io+0x88>
ffffffffc02085a0:	002c                	addi	a1,sp,8
ffffffffc02085a2:	854a                	mv	a0,s2
ffffffffc02085a4:	e81fb0ef          	jal	ra,ffffffffc0204424 <wait_queue_del>
ffffffffc02085a8:	47c2                	lw	a5,16(sp)
ffffffffc02085aa:	fa978fe3          	beq	a5,s1,ffffffffc0208568 <stdin_io+0x8e>
ffffffffc02085ae:	e435                	bnez	s0,ffffffffc020861a <stdin_io+0x140>
ffffffffc02085b0:	060b8963          	beqz	s7,ffffffffc0208622 <stdin_io+0x148>
ffffffffc02085b4:	018b3783          	ld	a5,24(s6)
ffffffffc02085b8:	41578ab3          	sub	s5,a5,s5
ffffffffc02085bc:	015b3c23          	sd	s5,24(s6)
ffffffffc02085c0:	60ea                	ld	ra,152(sp)
ffffffffc02085c2:	644a                	ld	s0,144(sp)
ffffffffc02085c4:	64aa                	ld	s1,136(sp)
ffffffffc02085c6:	690a                	ld	s2,128(sp)
ffffffffc02085c8:	79e6                	ld	s3,120(sp)
ffffffffc02085ca:	7a46                	ld	s4,112(sp)
ffffffffc02085cc:	7aa6                	ld	s5,104(sp)
ffffffffc02085ce:	7b06                	ld	s6,96(sp)
ffffffffc02085d0:	6c46                	ld	s8,80(sp)
ffffffffc02085d2:	6ca6                	ld	s9,72(sp)
ffffffffc02085d4:	6d06                	ld	s10,64(sp)
ffffffffc02085d6:	7de2                	ld	s11,56(sp)
ffffffffc02085d8:	855e                	mv	a0,s7
ffffffffc02085da:	6be6                	ld	s7,88(sp)
ffffffffc02085dc:	610d                	addi	sp,sp,160
ffffffffc02085de:	8082                	ret
ffffffffc02085e0:	43f7d713          	srai	a4,a5,0x3f
ffffffffc02085e4:	03475693          	srli	a3,a4,0x34
ffffffffc02085e8:	00d78733          	add	a4,a5,a3
ffffffffc02085ec:	01977733          	and	a4,a4,s9
ffffffffc02085f0:	8f15                	sub	a4,a4,a3
ffffffffc02085f2:	0008d697          	auipc	a3,0x8d
ffffffffc02085f6:	25e68693          	addi	a3,a3,606 # ffffffffc0295850 <stdin_buffer>
ffffffffc02085fa:	9736                	add	a4,a4,a3
ffffffffc02085fc:	00074683          	lbu	a3,0(a4)
ffffffffc0208600:	0785                	addi	a5,a5,1
ffffffffc0208602:	015d8733          	add	a4,s11,s5
ffffffffc0208606:	00d70023          	sb	a3,0(a4)
ffffffffc020860a:	00f9b023          	sd	a5,0(s3)
ffffffffc020860e:	0a85                	addi	s5,s5,1
ffffffffc0208610:	001c0b9b          	addiw	s7,s8,1
ffffffffc0208614:	f3aae4e3          	bltu	s5,s10,ffffffffc020853c <stdin_io+0x62>
ffffffffc0208618:	dc51                	beqz	s0,ffffffffc02085b4 <stdin_io+0xda>
ffffffffc020861a:	f84f80ef          	jal	ra,ffffffffc0200d9e <intr_enable>
ffffffffc020861e:	f80b9be3          	bnez	s7,ffffffffc02085b4 <stdin_io+0xda>
ffffffffc0208622:	4b81                	li	s7,0
ffffffffc0208624:	bf71                	j	ffffffffc02085c0 <stdin_io+0xe6>
ffffffffc0208626:	f7ef80ef          	jal	ra,ffffffffc0200da4 <intr_disable>
ffffffffc020862a:	4405                	li	s0,1
ffffffffc020862c:	ee0d14e3          	bnez	s10,ffffffffc0208514 <stdin_io+0x3a>
ffffffffc0208630:	f6ef80ef          	jal	ra,ffffffffc0200d9e <intr_enable>
ffffffffc0208634:	4b81                	li	s7,0
ffffffffc0208636:	b769                	j	ffffffffc02085c0 <stdin_io+0xe6>
ffffffffc0208638:	5bf5                	li	s7,-3
ffffffffc020863a:	b759                	j	ffffffffc02085c0 <stdin_io+0xe6>

ffffffffc020863c <dev_stdin_write>:
ffffffffc020863c:	e111                	bnez	a0,ffffffffc0208640 <dev_stdin_write+0x4>
ffffffffc020863e:	8082                	ret
ffffffffc0208640:	1101                	addi	sp,sp,-32
ffffffffc0208642:	e822                	sd	s0,16(sp)
ffffffffc0208644:	ec06                	sd	ra,24(sp)
ffffffffc0208646:	e426                	sd	s1,8(sp)
ffffffffc0208648:	842a                	mv	s0,a0
ffffffffc020864a:	100027f3          	csrr	a5,sstatus
ffffffffc020864e:	8b89                	andi	a5,a5,2
ffffffffc0208650:	4481                	li	s1,0
ffffffffc0208652:	e3c1                	bnez	a5,ffffffffc02086d2 <dev_stdin_write+0x96>
ffffffffc0208654:	0008e597          	auipc	a1,0x8e
ffffffffc0208658:	2ac58593          	addi	a1,a1,684 # ffffffffc0296900 <p_wpos>
ffffffffc020865c:	6198                	ld	a4,0(a1)
ffffffffc020865e:	6605                	lui	a2,0x1
ffffffffc0208660:	fff60513          	addi	a0,a2,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc0208664:	43f75693          	srai	a3,a4,0x3f
ffffffffc0208668:	92d1                	srli	a3,a3,0x34
ffffffffc020866a:	00d707b3          	add	a5,a4,a3
ffffffffc020866e:	8fe9                	and	a5,a5,a0
ffffffffc0208670:	8f95                	sub	a5,a5,a3
ffffffffc0208672:	0008d697          	auipc	a3,0x8d
ffffffffc0208676:	1de68693          	addi	a3,a3,478 # ffffffffc0295850 <stdin_buffer>
ffffffffc020867a:	97b6                	add	a5,a5,a3
ffffffffc020867c:	00878023          	sb	s0,0(a5)
ffffffffc0208680:	0008e797          	auipc	a5,0x8e
ffffffffc0208684:	2787b783          	ld	a5,632(a5) # ffffffffc02968f8 <p_rpos>
ffffffffc0208688:	40f707b3          	sub	a5,a4,a5
ffffffffc020868c:	00c7d463          	bge	a5,a2,ffffffffc0208694 <dev_stdin_write+0x58>
ffffffffc0208690:	0705                	addi	a4,a4,1
ffffffffc0208692:	e198                	sd	a4,0(a1)
ffffffffc0208694:	0008d517          	auipc	a0,0x8d
ffffffffc0208698:	1ac50513          	addi	a0,a0,428 # ffffffffc0295840 <__wait_queue>
ffffffffc020869c:	dd7fb0ef          	jal	ra,ffffffffc0204472 <wait_queue_empty>
ffffffffc02086a0:	cd09                	beqz	a0,ffffffffc02086ba <dev_stdin_write+0x7e>
ffffffffc02086a2:	e491                	bnez	s1,ffffffffc02086ae <dev_stdin_write+0x72>
ffffffffc02086a4:	60e2                	ld	ra,24(sp)
ffffffffc02086a6:	6442                	ld	s0,16(sp)
ffffffffc02086a8:	64a2                	ld	s1,8(sp)
ffffffffc02086aa:	6105                	addi	sp,sp,32
ffffffffc02086ac:	8082                	ret
ffffffffc02086ae:	6442                	ld	s0,16(sp)
ffffffffc02086b0:	60e2                	ld	ra,24(sp)
ffffffffc02086b2:	64a2                	ld	s1,8(sp)
ffffffffc02086b4:	6105                	addi	sp,sp,32
ffffffffc02086b6:	ee8f806f          	j	ffffffffc0200d9e <intr_enable>
ffffffffc02086ba:	800005b7          	lui	a1,0x80000
ffffffffc02086be:	4605                	li	a2,1
ffffffffc02086c0:	0591                	addi	a1,a1,4
ffffffffc02086c2:	0008d517          	auipc	a0,0x8d
ffffffffc02086c6:	17e50513          	addi	a0,a0,382 # ffffffffc0295840 <__wait_queue>
ffffffffc02086ca:	e11fb0ef          	jal	ra,ffffffffc02044da <wakeup_queue>
ffffffffc02086ce:	d8f9                	beqz	s1,ffffffffc02086a4 <dev_stdin_write+0x68>
ffffffffc02086d0:	bff9                	j	ffffffffc02086ae <dev_stdin_write+0x72>
ffffffffc02086d2:	ed2f80ef          	jal	ra,ffffffffc0200da4 <intr_disable>
ffffffffc02086d6:	4485                	li	s1,1
ffffffffc02086d8:	bfb5                	j	ffffffffc0208654 <dev_stdin_write+0x18>

ffffffffc02086da <dev_init_stdin>:
ffffffffc02086da:	1141                	addi	sp,sp,-16
ffffffffc02086dc:	e406                	sd	ra,8(sp)
ffffffffc02086de:	e022                	sd	s0,0(sp)
ffffffffc02086e0:	74a000ef          	jal	ra,ffffffffc0208e2a <dev_create_inode>
ffffffffc02086e4:	c93d                	beqz	a0,ffffffffc020875a <dev_init_stdin+0x80>
ffffffffc02086e6:	4d38                	lw	a4,88(a0)
ffffffffc02086e8:	6785                	lui	a5,0x1
ffffffffc02086ea:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc02086ee:	842a                	mv	s0,a0
ffffffffc02086f0:	08f71e63          	bne	a4,a5,ffffffffc020878c <dev_init_stdin+0xb2>
ffffffffc02086f4:	4785                	li	a5,1
ffffffffc02086f6:	e41c                	sd	a5,8(s0)
ffffffffc02086f8:	00000797          	auipc	a5,0x0
ffffffffc02086fc:	dd078793          	addi	a5,a5,-560 # ffffffffc02084c8 <stdin_open>
ffffffffc0208700:	e81c                	sd	a5,16(s0)
ffffffffc0208702:	00000797          	auipc	a5,0x0
ffffffffc0208706:	dd078793          	addi	a5,a5,-560 # ffffffffc02084d2 <stdin_close>
ffffffffc020870a:	ec1c                	sd	a5,24(s0)
ffffffffc020870c:	00000797          	auipc	a5,0x0
ffffffffc0208710:	dce78793          	addi	a5,a5,-562 # ffffffffc02084da <stdin_io>
ffffffffc0208714:	f01c                	sd	a5,32(s0)
ffffffffc0208716:	00000797          	auipc	a5,0x0
ffffffffc020871a:	dc078793          	addi	a5,a5,-576 # ffffffffc02084d6 <stdin_ioctl>
ffffffffc020871e:	f41c                	sd	a5,40(s0)
ffffffffc0208720:	0008d517          	auipc	a0,0x8d
ffffffffc0208724:	12050513          	addi	a0,a0,288 # ffffffffc0295840 <__wait_queue>
ffffffffc0208728:	00043023          	sd	zero,0(s0)
ffffffffc020872c:	0008e797          	auipc	a5,0x8e
ffffffffc0208730:	1c07ba23          	sd	zero,468(a5) # ffffffffc0296900 <p_wpos>
ffffffffc0208734:	0008e797          	auipc	a5,0x8e
ffffffffc0208738:	1c07b223          	sd	zero,452(a5) # ffffffffc02968f8 <p_rpos>
ffffffffc020873c:	ce3fb0ef          	jal	ra,ffffffffc020441e <wait_queue_init>
ffffffffc0208740:	4601                	li	a2,0
ffffffffc0208742:	85a2                	mv	a1,s0
ffffffffc0208744:	00006517          	auipc	a0,0x6
ffffffffc0208748:	20c50513          	addi	a0,a0,524 # ffffffffc020e950 <syscalls+0xe60>
ffffffffc020874c:	b20ff0ef          	jal	ra,ffffffffc0207a6c <vfs_add_dev>
ffffffffc0208750:	e10d                	bnez	a0,ffffffffc0208772 <dev_init_stdin+0x98>
ffffffffc0208752:	60a2                	ld	ra,8(sp)
ffffffffc0208754:	6402                	ld	s0,0(sp)
ffffffffc0208756:	0141                	addi	sp,sp,16
ffffffffc0208758:	8082                	ret
ffffffffc020875a:	00006617          	auipc	a2,0x6
ffffffffc020875e:	1b660613          	addi	a2,a2,438 # ffffffffc020e910 <syscalls+0xe20>
ffffffffc0208762:	07500593          	li	a1,117
ffffffffc0208766:	00006517          	auipc	a0,0x6
ffffffffc020876a:	1ca50513          	addi	a0,a0,458 # ffffffffc020e930 <syscalls+0xe40>
ffffffffc020876e:	ac1f70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0208772:	86aa                	mv	a3,a0
ffffffffc0208774:	00006617          	auipc	a2,0x6
ffffffffc0208778:	1e460613          	addi	a2,a2,484 # ffffffffc020e958 <syscalls+0xe68>
ffffffffc020877c:	07b00593          	li	a1,123
ffffffffc0208780:	00006517          	auipc	a0,0x6
ffffffffc0208784:	1b050513          	addi	a0,a0,432 # ffffffffc020e930 <syscalls+0xe40>
ffffffffc0208788:	aa7f70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020878c:	00006697          	auipc	a3,0x6
ffffffffc0208790:	c2c68693          	addi	a3,a3,-980 # ffffffffc020e3b8 <syscalls+0x8c8>
ffffffffc0208794:	00003617          	auipc	a2,0x3
ffffffffc0208798:	07460613          	addi	a2,a2,116 # ffffffffc020b808 <commands+0x60>
ffffffffc020879c:	07700593          	li	a1,119
ffffffffc02087a0:	00006517          	auipc	a0,0x6
ffffffffc02087a4:	19050513          	addi	a0,a0,400 # ffffffffc020e930 <syscalls+0xe40>
ffffffffc02087a8:	a87f70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02087ac <disk0_open>:
ffffffffc02087ac:	4501                	li	a0,0
ffffffffc02087ae:	8082                	ret

ffffffffc02087b0 <disk0_close>:
ffffffffc02087b0:	4501                	li	a0,0
ffffffffc02087b2:	8082                	ret

ffffffffc02087b4 <disk0_ioctl>:
ffffffffc02087b4:	5531                	li	a0,-20
ffffffffc02087b6:	8082                	ret

ffffffffc02087b8 <disk0_io>:
ffffffffc02087b8:	659c                	ld	a5,8(a1)
ffffffffc02087ba:	7159                	addi	sp,sp,-112
ffffffffc02087bc:	eca6                	sd	s1,88(sp)
ffffffffc02087be:	f45e                	sd	s7,40(sp)
ffffffffc02087c0:	6d84                	ld	s1,24(a1)
ffffffffc02087c2:	6b85                	lui	s7,0x1
ffffffffc02087c4:	1bfd                	addi	s7,s7,-1
ffffffffc02087c6:	e4ce                	sd	s3,72(sp)
ffffffffc02087c8:	43f7d993          	srai	s3,a5,0x3f
ffffffffc02087cc:	0179f9b3          	and	s3,s3,s7
ffffffffc02087d0:	99be                	add	s3,s3,a5
ffffffffc02087d2:	8fc5                	or	a5,a5,s1
ffffffffc02087d4:	f486                	sd	ra,104(sp)
ffffffffc02087d6:	f0a2                	sd	s0,96(sp)
ffffffffc02087d8:	e8ca                	sd	s2,80(sp)
ffffffffc02087da:	e0d2                	sd	s4,64(sp)
ffffffffc02087dc:	fc56                	sd	s5,56(sp)
ffffffffc02087de:	f85a                	sd	s6,48(sp)
ffffffffc02087e0:	f062                	sd	s8,32(sp)
ffffffffc02087e2:	ec66                	sd	s9,24(sp)
ffffffffc02087e4:	e86a                	sd	s10,16(sp)
ffffffffc02087e6:	0177f7b3          	and	a5,a5,s7
ffffffffc02087ea:	10079d63          	bnez	a5,ffffffffc0208904 <disk0_io+0x14c>
ffffffffc02087ee:	40c9d993          	srai	s3,s3,0xc
ffffffffc02087f2:	00c4d713          	srli	a4,s1,0xc
ffffffffc02087f6:	2981                	sext.w	s3,s3
ffffffffc02087f8:	2701                	sext.w	a4,a4
ffffffffc02087fa:	00e987bb          	addw	a5,s3,a4
ffffffffc02087fe:	6114                	ld	a3,0(a0)
ffffffffc0208800:	1782                	slli	a5,a5,0x20
ffffffffc0208802:	9381                	srli	a5,a5,0x20
ffffffffc0208804:	10f6e063          	bltu	a3,a5,ffffffffc0208904 <disk0_io+0x14c>
ffffffffc0208808:	4501                	li	a0,0
ffffffffc020880a:	ef19                	bnez	a4,ffffffffc0208828 <disk0_io+0x70>
ffffffffc020880c:	70a6                	ld	ra,104(sp)
ffffffffc020880e:	7406                	ld	s0,96(sp)
ffffffffc0208810:	64e6                	ld	s1,88(sp)
ffffffffc0208812:	6946                	ld	s2,80(sp)
ffffffffc0208814:	69a6                	ld	s3,72(sp)
ffffffffc0208816:	6a06                	ld	s4,64(sp)
ffffffffc0208818:	7ae2                	ld	s5,56(sp)
ffffffffc020881a:	7b42                	ld	s6,48(sp)
ffffffffc020881c:	7ba2                	ld	s7,40(sp)
ffffffffc020881e:	7c02                	ld	s8,32(sp)
ffffffffc0208820:	6ce2                	ld	s9,24(sp)
ffffffffc0208822:	6d42                	ld	s10,16(sp)
ffffffffc0208824:	6165                	addi	sp,sp,112
ffffffffc0208826:	8082                	ret
ffffffffc0208828:	0008e517          	auipc	a0,0x8e
ffffffffc020882c:	02850513          	addi	a0,a0,40 # ffffffffc0296850 <disk0_sem>
ffffffffc0208830:	8b2e                	mv	s6,a1
ffffffffc0208832:	8c32                	mv	s8,a2
ffffffffc0208834:	0008ea97          	auipc	s5,0x8e
ffffffffc0208838:	0d4a8a93          	addi	s5,s5,212 # ffffffffc0296908 <disk0_buffer>
ffffffffc020883c:	f13fb0ef          	jal	ra,ffffffffc020474e <down>
ffffffffc0208840:	6c91                	lui	s9,0x4
ffffffffc0208842:	e4b9                	bnez	s1,ffffffffc0208890 <disk0_io+0xd8>
ffffffffc0208844:	a845                	j	ffffffffc02088f4 <disk0_io+0x13c>
ffffffffc0208846:	00c4d413          	srli	s0,s1,0xc
ffffffffc020884a:	0034169b          	slliw	a3,s0,0x3
ffffffffc020884e:	00068d1b          	sext.w	s10,a3
ffffffffc0208852:	1682                	slli	a3,a3,0x20
ffffffffc0208854:	2401                	sext.w	s0,s0
ffffffffc0208856:	9281                	srli	a3,a3,0x20
ffffffffc0208858:	8926                	mv	s2,s1
ffffffffc020885a:	00399a1b          	slliw	s4,s3,0x3
ffffffffc020885e:	862e                	mv	a2,a1
ffffffffc0208860:	4509                	li	a0,2
ffffffffc0208862:	85d2                	mv	a1,s4
ffffffffc0208864:	dcdf70ef          	jal	ra,ffffffffc0200630 <ide_read_secs>
ffffffffc0208868:	e165                	bnez	a0,ffffffffc0208948 <disk0_io+0x190>
ffffffffc020886a:	000ab583          	ld	a1,0(s5)
ffffffffc020886e:	0038                	addi	a4,sp,8
ffffffffc0208870:	4685                	li	a3,1
ffffffffc0208872:	864a                	mv	a2,s2
ffffffffc0208874:	855a                	mv	a0,s6
ffffffffc0208876:	ec5fc0ef          	jal	ra,ffffffffc020573a <iobuf_move>
ffffffffc020887a:	67a2                	ld	a5,8(sp)
ffffffffc020887c:	09279663          	bne	a5,s2,ffffffffc0208908 <disk0_io+0x150>
ffffffffc0208880:	017977b3          	and	a5,s2,s7
ffffffffc0208884:	e3d1                	bnez	a5,ffffffffc0208908 <disk0_io+0x150>
ffffffffc0208886:	412484b3          	sub	s1,s1,s2
ffffffffc020888a:	013409bb          	addw	s3,s0,s3
ffffffffc020888e:	c0bd                	beqz	s1,ffffffffc02088f4 <disk0_io+0x13c>
ffffffffc0208890:	000ab583          	ld	a1,0(s5)
ffffffffc0208894:	000c1b63          	bnez	s8,ffffffffc02088aa <disk0_io+0xf2>
ffffffffc0208898:	fb94e7e3          	bltu	s1,s9,ffffffffc0208846 <disk0_io+0x8e>
ffffffffc020889c:	02000693          	li	a3,32
ffffffffc02088a0:	02000d13          	li	s10,32
ffffffffc02088a4:	4411                	li	s0,4
ffffffffc02088a6:	6911                	lui	s2,0x4
ffffffffc02088a8:	bf4d                	j	ffffffffc020885a <disk0_io+0xa2>
ffffffffc02088aa:	0038                	addi	a4,sp,8
ffffffffc02088ac:	4681                	li	a3,0
ffffffffc02088ae:	6611                	lui	a2,0x4
ffffffffc02088b0:	855a                	mv	a0,s6
ffffffffc02088b2:	e89fc0ef          	jal	ra,ffffffffc020573a <iobuf_move>
ffffffffc02088b6:	6422                	ld	s0,8(sp)
ffffffffc02088b8:	c825                	beqz	s0,ffffffffc0208928 <disk0_io+0x170>
ffffffffc02088ba:	0684e763          	bltu	s1,s0,ffffffffc0208928 <disk0_io+0x170>
ffffffffc02088be:	017477b3          	and	a5,s0,s7
ffffffffc02088c2:	e3bd                	bnez	a5,ffffffffc0208928 <disk0_io+0x170>
ffffffffc02088c4:	8031                	srli	s0,s0,0xc
ffffffffc02088c6:	0034179b          	slliw	a5,s0,0x3
ffffffffc02088ca:	000ab603          	ld	a2,0(s5)
ffffffffc02088ce:	0039991b          	slliw	s2,s3,0x3
ffffffffc02088d2:	02079693          	slli	a3,a5,0x20
ffffffffc02088d6:	9281                	srli	a3,a3,0x20
ffffffffc02088d8:	85ca                	mv	a1,s2
ffffffffc02088da:	4509                	li	a0,2
ffffffffc02088dc:	2401                	sext.w	s0,s0
ffffffffc02088de:	00078a1b          	sext.w	s4,a5
ffffffffc02088e2:	de5f70ef          	jal	ra,ffffffffc02006c6 <ide_write_secs>
ffffffffc02088e6:	e151                	bnez	a0,ffffffffc020896a <disk0_io+0x1b2>
ffffffffc02088e8:	6922                	ld	s2,8(sp)
ffffffffc02088ea:	013409bb          	addw	s3,s0,s3
ffffffffc02088ee:	412484b3          	sub	s1,s1,s2
ffffffffc02088f2:	fcd9                	bnez	s1,ffffffffc0208890 <disk0_io+0xd8>
ffffffffc02088f4:	0008e517          	auipc	a0,0x8e
ffffffffc02088f8:	f5c50513          	addi	a0,a0,-164 # ffffffffc0296850 <disk0_sem>
ffffffffc02088fc:	e4ffb0ef          	jal	ra,ffffffffc020474a <up>
ffffffffc0208900:	4501                	li	a0,0
ffffffffc0208902:	b729                	j	ffffffffc020880c <disk0_io+0x54>
ffffffffc0208904:	5575                	li	a0,-3
ffffffffc0208906:	b719                	j	ffffffffc020880c <disk0_io+0x54>
ffffffffc0208908:	00006697          	auipc	a3,0x6
ffffffffc020890c:	16868693          	addi	a3,a3,360 # ffffffffc020ea70 <syscalls+0xf80>
ffffffffc0208910:	00003617          	auipc	a2,0x3
ffffffffc0208914:	ef860613          	addi	a2,a2,-264 # ffffffffc020b808 <commands+0x60>
ffffffffc0208918:	06200593          	li	a1,98
ffffffffc020891c:	00006517          	auipc	a0,0x6
ffffffffc0208920:	09c50513          	addi	a0,a0,156 # ffffffffc020e9b8 <syscalls+0xec8>
ffffffffc0208924:	90bf70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0208928:	00006697          	auipc	a3,0x6
ffffffffc020892c:	05068693          	addi	a3,a3,80 # ffffffffc020e978 <syscalls+0xe88>
ffffffffc0208930:	00003617          	auipc	a2,0x3
ffffffffc0208934:	ed860613          	addi	a2,a2,-296 # ffffffffc020b808 <commands+0x60>
ffffffffc0208938:	05700593          	li	a1,87
ffffffffc020893c:	00006517          	auipc	a0,0x6
ffffffffc0208940:	07c50513          	addi	a0,a0,124 # ffffffffc020e9b8 <syscalls+0xec8>
ffffffffc0208944:	8ebf70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0208948:	88aa                	mv	a7,a0
ffffffffc020894a:	886a                	mv	a6,s10
ffffffffc020894c:	87a2                	mv	a5,s0
ffffffffc020894e:	8752                	mv	a4,s4
ffffffffc0208950:	86ce                	mv	a3,s3
ffffffffc0208952:	00006617          	auipc	a2,0x6
ffffffffc0208956:	0d660613          	addi	a2,a2,214 # ffffffffc020ea28 <syscalls+0xf38>
ffffffffc020895a:	02d00593          	li	a1,45
ffffffffc020895e:	00006517          	auipc	a0,0x6
ffffffffc0208962:	05a50513          	addi	a0,a0,90 # ffffffffc020e9b8 <syscalls+0xec8>
ffffffffc0208966:	8c9f70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020896a:	88aa                	mv	a7,a0
ffffffffc020896c:	8852                	mv	a6,s4
ffffffffc020896e:	87a2                	mv	a5,s0
ffffffffc0208970:	874a                	mv	a4,s2
ffffffffc0208972:	86ce                	mv	a3,s3
ffffffffc0208974:	00006617          	auipc	a2,0x6
ffffffffc0208978:	06460613          	addi	a2,a2,100 # ffffffffc020e9d8 <syscalls+0xee8>
ffffffffc020897c:	03700593          	li	a1,55
ffffffffc0208980:	00006517          	auipc	a0,0x6
ffffffffc0208984:	03850513          	addi	a0,a0,56 # ffffffffc020e9b8 <syscalls+0xec8>
ffffffffc0208988:	8a7f70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020898c <dev_init_disk0>:
ffffffffc020898c:	1101                	addi	sp,sp,-32
ffffffffc020898e:	ec06                	sd	ra,24(sp)
ffffffffc0208990:	e822                	sd	s0,16(sp)
ffffffffc0208992:	e426                	sd	s1,8(sp)
ffffffffc0208994:	496000ef          	jal	ra,ffffffffc0208e2a <dev_create_inode>
ffffffffc0208998:	c541                	beqz	a0,ffffffffc0208a20 <dev_init_disk0+0x94>
ffffffffc020899a:	4d38                	lw	a4,88(a0)
ffffffffc020899c:	6485                	lui	s1,0x1
ffffffffc020899e:	23448793          	addi	a5,s1,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc02089a2:	842a                	mv	s0,a0
ffffffffc02089a4:	0cf71f63          	bne	a4,a5,ffffffffc0208a82 <dev_init_disk0+0xf6>
ffffffffc02089a8:	4509                	li	a0,2
ffffffffc02089aa:	c3bf70ef          	jal	ra,ffffffffc02005e4 <ide_device_valid>
ffffffffc02089ae:	cd55                	beqz	a0,ffffffffc0208a6a <dev_init_disk0+0xde>
ffffffffc02089b0:	4509                	li	a0,2
ffffffffc02089b2:	c57f70ef          	jal	ra,ffffffffc0200608 <ide_device_size>
ffffffffc02089b6:	00355793          	srli	a5,a0,0x3
ffffffffc02089ba:	e01c                	sd	a5,0(s0)
ffffffffc02089bc:	00000797          	auipc	a5,0x0
ffffffffc02089c0:	df078793          	addi	a5,a5,-528 # ffffffffc02087ac <disk0_open>
ffffffffc02089c4:	e81c                	sd	a5,16(s0)
ffffffffc02089c6:	00000797          	auipc	a5,0x0
ffffffffc02089ca:	dea78793          	addi	a5,a5,-534 # ffffffffc02087b0 <disk0_close>
ffffffffc02089ce:	ec1c                	sd	a5,24(s0)
ffffffffc02089d0:	00000797          	auipc	a5,0x0
ffffffffc02089d4:	de878793          	addi	a5,a5,-536 # ffffffffc02087b8 <disk0_io>
ffffffffc02089d8:	f01c                	sd	a5,32(s0)
ffffffffc02089da:	00000797          	auipc	a5,0x0
ffffffffc02089de:	dda78793          	addi	a5,a5,-550 # ffffffffc02087b4 <disk0_ioctl>
ffffffffc02089e2:	f41c                	sd	a5,40(s0)
ffffffffc02089e4:	4585                	li	a1,1
ffffffffc02089e6:	0008e517          	auipc	a0,0x8e
ffffffffc02089ea:	e6a50513          	addi	a0,a0,-406 # ffffffffc0296850 <disk0_sem>
ffffffffc02089ee:	e404                	sd	s1,8(s0)
ffffffffc02089f0:	d53fb0ef          	jal	ra,ffffffffc0204742 <sem_init>
ffffffffc02089f4:	6511                	lui	a0,0x4
ffffffffc02089f6:	dd1fa0ef          	jal	ra,ffffffffc02037c6 <kmalloc>
ffffffffc02089fa:	0008e797          	auipc	a5,0x8e
ffffffffc02089fe:	f0a7b723          	sd	a0,-242(a5) # ffffffffc0296908 <disk0_buffer>
ffffffffc0208a02:	c921                	beqz	a0,ffffffffc0208a52 <dev_init_disk0+0xc6>
ffffffffc0208a04:	4605                	li	a2,1
ffffffffc0208a06:	85a2                	mv	a1,s0
ffffffffc0208a08:	00006517          	auipc	a0,0x6
ffffffffc0208a0c:	0f850513          	addi	a0,a0,248 # ffffffffc020eb00 <syscalls+0x1010>
ffffffffc0208a10:	85cff0ef          	jal	ra,ffffffffc0207a6c <vfs_add_dev>
ffffffffc0208a14:	e115                	bnez	a0,ffffffffc0208a38 <dev_init_disk0+0xac>
ffffffffc0208a16:	60e2                	ld	ra,24(sp)
ffffffffc0208a18:	6442                	ld	s0,16(sp)
ffffffffc0208a1a:	64a2                	ld	s1,8(sp)
ffffffffc0208a1c:	6105                	addi	sp,sp,32
ffffffffc0208a1e:	8082                	ret
ffffffffc0208a20:	00006617          	auipc	a2,0x6
ffffffffc0208a24:	08060613          	addi	a2,a2,128 # ffffffffc020eaa0 <syscalls+0xfb0>
ffffffffc0208a28:	08700593          	li	a1,135
ffffffffc0208a2c:	00006517          	auipc	a0,0x6
ffffffffc0208a30:	f8c50513          	addi	a0,a0,-116 # ffffffffc020e9b8 <syscalls+0xec8>
ffffffffc0208a34:	ffaf70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0208a38:	86aa                	mv	a3,a0
ffffffffc0208a3a:	00006617          	auipc	a2,0x6
ffffffffc0208a3e:	0ce60613          	addi	a2,a2,206 # ffffffffc020eb08 <syscalls+0x1018>
ffffffffc0208a42:	08d00593          	li	a1,141
ffffffffc0208a46:	00006517          	auipc	a0,0x6
ffffffffc0208a4a:	f7250513          	addi	a0,a0,-142 # ffffffffc020e9b8 <syscalls+0xec8>
ffffffffc0208a4e:	fe0f70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0208a52:	00006617          	auipc	a2,0x6
ffffffffc0208a56:	08e60613          	addi	a2,a2,142 # ffffffffc020eae0 <syscalls+0xff0>
ffffffffc0208a5a:	07f00593          	li	a1,127
ffffffffc0208a5e:	00006517          	auipc	a0,0x6
ffffffffc0208a62:	f5a50513          	addi	a0,a0,-166 # ffffffffc020e9b8 <syscalls+0xec8>
ffffffffc0208a66:	fc8f70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0208a6a:	00006617          	auipc	a2,0x6
ffffffffc0208a6e:	05660613          	addi	a2,a2,86 # ffffffffc020eac0 <syscalls+0xfd0>
ffffffffc0208a72:	07300593          	li	a1,115
ffffffffc0208a76:	00006517          	auipc	a0,0x6
ffffffffc0208a7a:	f4250513          	addi	a0,a0,-190 # ffffffffc020e9b8 <syscalls+0xec8>
ffffffffc0208a7e:	fb0f70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0208a82:	00006697          	auipc	a3,0x6
ffffffffc0208a86:	93668693          	addi	a3,a3,-1738 # ffffffffc020e3b8 <syscalls+0x8c8>
ffffffffc0208a8a:	00003617          	auipc	a2,0x3
ffffffffc0208a8e:	d7e60613          	addi	a2,a2,-642 # ffffffffc020b808 <commands+0x60>
ffffffffc0208a92:	08900593          	li	a1,137
ffffffffc0208a96:	00006517          	auipc	a0,0x6
ffffffffc0208a9a:	f2250513          	addi	a0,a0,-222 # ffffffffc020e9b8 <syscalls+0xec8>
ffffffffc0208a9e:	f90f70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0208aa2 <stdout_open>:
ffffffffc0208aa2:	4785                	li	a5,1
ffffffffc0208aa4:	4501                	li	a0,0
ffffffffc0208aa6:	00f59363          	bne	a1,a5,ffffffffc0208aac <stdout_open+0xa>
ffffffffc0208aaa:	8082                	ret
ffffffffc0208aac:	5575                	li	a0,-3
ffffffffc0208aae:	8082                	ret

ffffffffc0208ab0 <stdout_close>:
ffffffffc0208ab0:	4501                	li	a0,0
ffffffffc0208ab2:	8082                	ret

ffffffffc0208ab4 <stdout_ioctl>:
ffffffffc0208ab4:	5575                	li	a0,-3
ffffffffc0208ab6:	8082                	ret

ffffffffc0208ab8 <stdout_io>:
ffffffffc0208ab8:	ca05                	beqz	a2,ffffffffc0208ae8 <stdout_io+0x30>
ffffffffc0208aba:	6d9c                	ld	a5,24(a1)
ffffffffc0208abc:	1101                	addi	sp,sp,-32
ffffffffc0208abe:	e822                	sd	s0,16(sp)
ffffffffc0208ac0:	e426                	sd	s1,8(sp)
ffffffffc0208ac2:	ec06                	sd	ra,24(sp)
ffffffffc0208ac4:	6180                	ld	s0,0(a1)
ffffffffc0208ac6:	84ae                	mv	s1,a1
ffffffffc0208ac8:	cb91                	beqz	a5,ffffffffc0208adc <stdout_io+0x24>
ffffffffc0208aca:	00044503          	lbu	a0,0(s0)
ffffffffc0208ace:	0405                	addi	s0,s0,1
ffffffffc0208ad0:	e96f70ef          	jal	ra,ffffffffc0200166 <cputchar>
ffffffffc0208ad4:	6c9c                	ld	a5,24(s1)
ffffffffc0208ad6:	17fd                	addi	a5,a5,-1
ffffffffc0208ad8:	ec9c                	sd	a5,24(s1)
ffffffffc0208ada:	fbe5                	bnez	a5,ffffffffc0208aca <stdout_io+0x12>
ffffffffc0208adc:	60e2                	ld	ra,24(sp)
ffffffffc0208ade:	6442                	ld	s0,16(sp)
ffffffffc0208ae0:	64a2                	ld	s1,8(sp)
ffffffffc0208ae2:	4501                	li	a0,0
ffffffffc0208ae4:	6105                	addi	sp,sp,32
ffffffffc0208ae6:	8082                	ret
ffffffffc0208ae8:	5575                	li	a0,-3
ffffffffc0208aea:	8082                	ret

ffffffffc0208aec <dev_init_stdout>:
ffffffffc0208aec:	1141                	addi	sp,sp,-16
ffffffffc0208aee:	e406                	sd	ra,8(sp)
ffffffffc0208af0:	33a000ef          	jal	ra,ffffffffc0208e2a <dev_create_inode>
ffffffffc0208af4:	c939                	beqz	a0,ffffffffc0208b4a <dev_init_stdout+0x5e>
ffffffffc0208af6:	4d38                	lw	a4,88(a0)
ffffffffc0208af8:	6785                	lui	a5,0x1
ffffffffc0208afa:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208afe:	85aa                	mv	a1,a0
ffffffffc0208b00:	06f71e63          	bne	a4,a5,ffffffffc0208b7c <dev_init_stdout+0x90>
ffffffffc0208b04:	4785                	li	a5,1
ffffffffc0208b06:	e51c                	sd	a5,8(a0)
ffffffffc0208b08:	00000797          	auipc	a5,0x0
ffffffffc0208b0c:	f9a78793          	addi	a5,a5,-102 # ffffffffc0208aa2 <stdout_open>
ffffffffc0208b10:	e91c                	sd	a5,16(a0)
ffffffffc0208b12:	00000797          	auipc	a5,0x0
ffffffffc0208b16:	f9e78793          	addi	a5,a5,-98 # ffffffffc0208ab0 <stdout_close>
ffffffffc0208b1a:	ed1c                	sd	a5,24(a0)
ffffffffc0208b1c:	00000797          	auipc	a5,0x0
ffffffffc0208b20:	f9c78793          	addi	a5,a5,-100 # ffffffffc0208ab8 <stdout_io>
ffffffffc0208b24:	f11c                	sd	a5,32(a0)
ffffffffc0208b26:	00000797          	auipc	a5,0x0
ffffffffc0208b2a:	f8e78793          	addi	a5,a5,-114 # ffffffffc0208ab4 <stdout_ioctl>
ffffffffc0208b2e:	00053023          	sd	zero,0(a0)
ffffffffc0208b32:	f51c                	sd	a5,40(a0)
ffffffffc0208b34:	4601                	li	a2,0
ffffffffc0208b36:	00006517          	auipc	a0,0x6
ffffffffc0208b3a:	03250513          	addi	a0,a0,50 # ffffffffc020eb68 <syscalls+0x1078>
ffffffffc0208b3e:	f2ffe0ef          	jal	ra,ffffffffc0207a6c <vfs_add_dev>
ffffffffc0208b42:	e105                	bnez	a0,ffffffffc0208b62 <dev_init_stdout+0x76>
ffffffffc0208b44:	60a2                	ld	ra,8(sp)
ffffffffc0208b46:	0141                	addi	sp,sp,16
ffffffffc0208b48:	8082                	ret
ffffffffc0208b4a:	00006617          	auipc	a2,0x6
ffffffffc0208b4e:	fde60613          	addi	a2,a2,-34 # ffffffffc020eb28 <syscalls+0x1038>
ffffffffc0208b52:	03700593          	li	a1,55
ffffffffc0208b56:	00006517          	auipc	a0,0x6
ffffffffc0208b5a:	ff250513          	addi	a0,a0,-14 # ffffffffc020eb48 <syscalls+0x1058>
ffffffffc0208b5e:	ed0f70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0208b62:	86aa                	mv	a3,a0
ffffffffc0208b64:	00006617          	auipc	a2,0x6
ffffffffc0208b68:	00c60613          	addi	a2,a2,12 # ffffffffc020eb70 <syscalls+0x1080>
ffffffffc0208b6c:	03d00593          	li	a1,61
ffffffffc0208b70:	00006517          	auipc	a0,0x6
ffffffffc0208b74:	fd850513          	addi	a0,a0,-40 # ffffffffc020eb48 <syscalls+0x1058>
ffffffffc0208b78:	eb6f70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0208b7c:	00006697          	auipc	a3,0x6
ffffffffc0208b80:	83c68693          	addi	a3,a3,-1988 # ffffffffc020e3b8 <syscalls+0x8c8>
ffffffffc0208b84:	00003617          	auipc	a2,0x3
ffffffffc0208b88:	c8460613          	addi	a2,a2,-892 # ffffffffc020b808 <commands+0x60>
ffffffffc0208b8c:	03900593          	li	a1,57
ffffffffc0208b90:	00006517          	auipc	a0,0x6
ffffffffc0208b94:	fb850513          	addi	a0,a0,-72 # ffffffffc020eb48 <syscalls+0x1058>
ffffffffc0208b98:	e96f70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0208b9c <dev_lookup>:
ffffffffc0208b9c:	0005c783          	lbu	a5,0(a1) # ffffffff80000000 <_binary_bin_sfs_img_size+0xffffffff7ff8ad00>
ffffffffc0208ba0:	e385                	bnez	a5,ffffffffc0208bc0 <dev_lookup+0x24>
ffffffffc0208ba2:	1101                	addi	sp,sp,-32
ffffffffc0208ba4:	e822                	sd	s0,16(sp)
ffffffffc0208ba6:	e426                	sd	s1,8(sp)
ffffffffc0208ba8:	ec06                	sd	ra,24(sp)
ffffffffc0208baa:	84aa                	mv	s1,a0
ffffffffc0208bac:	8432                	mv	s0,a2
ffffffffc0208bae:	c34ff0ef          	jal	ra,ffffffffc0207fe2 <inode_ref_inc>
ffffffffc0208bb2:	60e2                	ld	ra,24(sp)
ffffffffc0208bb4:	e004                	sd	s1,0(s0)
ffffffffc0208bb6:	6442                	ld	s0,16(sp)
ffffffffc0208bb8:	64a2                	ld	s1,8(sp)
ffffffffc0208bba:	4501                	li	a0,0
ffffffffc0208bbc:	6105                	addi	sp,sp,32
ffffffffc0208bbe:	8082                	ret
ffffffffc0208bc0:	5541                	li	a0,-16
ffffffffc0208bc2:	8082                	ret

ffffffffc0208bc4 <dev_fstat>:
ffffffffc0208bc4:	1101                	addi	sp,sp,-32
ffffffffc0208bc6:	e426                	sd	s1,8(sp)
ffffffffc0208bc8:	84ae                	mv	s1,a1
ffffffffc0208bca:	e822                	sd	s0,16(sp)
ffffffffc0208bcc:	02000613          	li	a2,32
ffffffffc0208bd0:	842a                	mv	s0,a0
ffffffffc0208bd2:	4581                	li	a1,0
ffffffffc0208bd4:	8526                	mv	a0,s1
ffffffffc0208bd6:	ec06                	sd	ra,24(sp)
ffffffffc0208bd8:	426020ef          	jal	ra,ffffffffc020affe <memset>
ffffffffc0208bdc:	c429                	beqz	s0,ffffffffc0208c26 <dev_fstat+0x62>
ffffffffc0208bde:	783c                	ld	a5,112(s0)
ffffffffc0208be0:	c3b9                	beqz	a5,ffffffffc0208c26 <dev_fstat+0x62>
ffffffffc0208be2:	6bbc                	ld	a5,80(a5)
ffffffffc0208be4:	c3a9                	beqz	a5,ffffffffc0208c26 <dev_fstat+0x62>
ffffffffc0208be6:	00006597          	auipc	a1,0x6
ffffffffc0208bea:	89a58593          	addi	a1,a1,-1894 # ffffffffc020e480 <syscalls+0x990>
ffffffffc0208bee:	8522                	mv	a0,s0
ffffffffc0208bf0:	c0aff0ef          	jal	ra,ffffffffc0207ffa <inode_check>
ffffffffc0208bf4:	783c                	ld	a5,112(s0)
ffffffffc0208bf6:	85a6                	mv	a1,s1
ffffffffc0208bf8:	8522                	mv	a0,s0
ffffffffc0208bfa:	6bbc                	ld	a5,80(a5)
ffffffffc0208bfc:	9782                	jalr	a5
ffffffffc0208bfe:	ed19                	bnez	a0,ffffffffc0208c1c <dev_fstat+0x58>
ffffffffc0208c00:	4c38                	lw	a4,88(s0)
ffffffffc0208c02:	6785                	lui	a5,0x1
ffffffffc0208c04:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208c08:	02f71f63          	bne	a4,a5,ffffffffc0208c46 <dev_fstat+0x82>
ffffffffc0208c0c:	6018                	ld	a4,0(s0)
ffffffffc0208c0e:	641c                	ld	a5,8(s0)
ffffffffc0208c10:	4685                	li	a3,1
ffffffffc0208c12:	e494                	sd	a3,8(s1)
ffffffffc0208c14:	02e787b3          	mul	a5,a5,a4
ffffffffc0208c18:	e898                	sd	a4,16(s1)
ffffffffc0208c1a:	ec9c                	sd	a5,24(s1)
ffffffffc0208c1c:	60e2                	ld	ra,24(sp)
ffffffffc0208c1e:	6442                	ld	s0,16(sp)
ffffffffc0208c20:	64a2                	ld	s1,8(sp)
ffffffffc0208c22:	6105                	addi	sp,sp,32
ffffffffc0208c24:	8082                	ret
ffffffffc0208c26:	00005697          	auipc	a3,0x5
ffffffffc0208c2a:	7f268693          	addi	a3,a3,2034 # ffffffffc020e418 <syscalls+0x928>
ffffffffc0208c2e:	00003617          	auipc	a2,0x3
ffffffffc0208c32:	bda60613          	addi	a2,a2,-1062 # ffffffffc020b808 <commands+0x60>
ffffffffc0208c36:	04200593          	li	a1,66
ffffffffc0208c3a:	00006517          	auipc	a0,0x6
ffffffffc0208c3e:	f5650513          	addi	a0,a0,-170 # ffffffffc020eb90 <syscalls+0x10a0>
ffffffffc0208c42:	decf70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0208c46:	00005697          	auipc	a3,0x5
ffffffffc0208c4a:	77268693          	addi	a3,a3,1906 # ffffffffc020e3b8 <syscalls+0x8c8>
ffffffffc0208c4e:	00003617          	auipc	a2,0x3
ffffffffc0208c52:	bba60613          	addi	a2,a2,-1094 # ffffffffc020b808 <commands+0x60>
ffffffffc0208c56:	04500593          	li	a1,69
ffffffffc0208c5a:	00006517          	auipc	a0,0x6
ffffffffc0208c5e:	f3650513          	addi	a0,a0,-202 # ffffffffc020eb90 <syscalls+0x10a0>
ffffffffc0208c62:	dccf70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0208c66 <dev_ioctl>:
ffffffffc0208c66:	c909                	beqz	a0,ffffffffc0208c78 <dev_ioctl+0x12>
ffffffffc0208c68:	4d34                	lw	a3,88(a0)
ffffffffc0208c6a:	6705                	lui	a4,0x1
ffffffffc0208c6c:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208c70:	00e69463          	bne	a3,a4,ffffffffc0208c78 <dev_ioctl+0x12>
ffffffffc0208c74:	751c                	ld	a5,40(a0)
ffffffffc0208c76:	8782                	jr	a5
ffffffffc0208c78:	1141                	addi	sp,sp,-16
ffffffffc0208c7a:	00005697          	auipc	a3,0x5
ffffffffc0208c7e:	73e68693          	addi	a3,a3,1854 # ffffffffc020e3b8 <syscalls+0x8c8>
ffffffffc0208c82:	00003617          	auipc	a2,0x3
ffffffffc0208c86:	b8660613          	addi	a2,a2,-1146 # ffffffffc020b808 <commands+0x60>
ffffffffc0208c8a:	03500593          	li	a1,53
ffffffffc0208c8e:	00006517          	auipc	a0,0x6
ffffffffc0208c92:	f0250513          	addi	a0,a0,-254 # ffffffffc020eb90 <syscalls+0x10a0>
ffffffffc0208c96:	e406                	sd	ra,8(sp)
ffffffffc0208c98:	d96f70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0208c9c <dev_tryseek>:
ffffffffc0208c9c:	c51d                	beqz	a0,ffffffffc0208cca <dev_tryseek+0x2e>
ffffffffc0208c9e:	4d38                	lw	a4,88(a0)
ffffffffc0208ca0:	6785                	lui	a5,0x1
ffffffffc0208ca2:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208ca6:	02f71263          	bne	a4,a5,ffffffffc0208cca <dev_tryseek+0x2e>
ffffffffc0208caa:	611c                	ld	a5,0(a0)
ffffffffc0208cac:	cf89                	beqz	a5,ffffffffc0208cc6 <dev_tryseek+0x2a>
ffffffffc0208cae:	6518                	ld	a4,8(a0)
ffffffffc0208cb0:	02e5f6b3          	remu	a3,a1,a4
ffffffffc0208cb4:	ea89                	bnez	a3,ffffffffc0208cc6 <dev_tryseek+0x2a>
ffffffffc0208cb6:	0005c863          	bltz	a1,ffffffffc0208cc6 <dev_tryseek+0x2a>
ffffffffc0208cba:	02e787b3          	mul	a5,a5,a4
ffffffffc0208cbe:	00f5f463          	bgeu	a1,a5,ffffffffc0208cc6 <dev_tryseek+0x2a>
ffffffffc0208cc2:	4501                	li	a0,0
ffffffffc0208cc4:	8082                	ret
ffffffffc0208cc6:	5575                	li	a0,-3
ffffffffc0208cc8:	8082                	ret
ffffffffc0208cca:	1141                	addi	sp,sp,-16
ffffffffc0208ccc:	00005697          	auipc	a3,0x5
ffffffffc0208cd0:	6ec68693          	addi	a3,a3,1772 # ffffffffc020e3b8 <syscalls+0x8c8>
ffffffffc0208cd4:	00003617          	auipc	a2,0x3
ffffffffc0208cd8:	b3460613          	addi	a2,a2,-1228 # ffffffffc020b808 <commands+0x60>
ffffffffc0208cdc:	05f00593          	li	a1,95
ffffffffc0208ce0:	00006517          	auipc	a0,0x6
ffffffffc0208ce4:	eb050513          	addi	a0,a0,-336 # ffffffffc020eb90 <syscalls+0x10a0>
ffffffffc0208ce8:	e406                	sd	ra,8(sp)
ffffffffc0208cea:	d44f70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0208cee <dev_gettype>:
ffffffffc0208cee:	c10d                	beqz	a0,ffffffffc0208d10 <dev_gettype+0x22>
ffffffffc0208cf0:	4d38                	lw	a4,88(a0)
ffffffffc0208cf2:	6785                	lui	a5,0x1
ffffffffc0208cf4:	23478793          	addi	a5,a5,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208cf8:	00f71c63          	bne	a4,a5,ffffffffc0208d10 <dev_gettype+0x22>
ffffffffc0208cfc:	6118                	ld	a4,0(a0)
ffffffffc0208cfe:	6795                	lui	a5,0x5
ffffffffc0208d00:	c701                	beqz	a4,ffffffffc0208d08 <dev_gettype+0x1a>
ffffffffc0208d02:	c19c                	sw	a5,0(a1)
ffffffffc0208d04:	4501                	li	a0,0
ffffffffc0208d06:	8082                	ret
ffffffffc0208d08:	6791                	lui	a5,0x4
ffffffffc0208d0a:	c19c                	sw	a5,0(a1)
ffffffffc0208d0c:	4501                	li	a0,0
ffffffffc0208d0e:	8082                	ret
ffffffffc0208d10:	1141                	addi	sp,sp,-16
ffffffffc0208d12:	00005697          	auipc	a3,0x5
ffffffffc0208d16:	6a668693          	addi	a3,a3,1702 # ffffffffc020e3b8 <syscalls+0x8c8>
ffffffffc0208d1a:	00003617          	auipc	a2,0x3
ffffffffc0208d1e:	aee60613          	addi	a2,a2,-1298 # ffffffffc020b808 <commands+0x60>
ffffffffc0208d22:	05300593          	li	a1,83
ffffffffc0208d26:	00006517          	auipc	a0,0x6
ffffffffc0208d2a:	e6a50513          	addi	a0,a0,-406 # ffffffffc020eb90 <syscalls+0x10a0>
ffffffffc0208d2e:	e406                	sd	ra,8(sp)
ffffffffc0208d30:	cfef70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0208d34 <dev_write>:
ffffffffc0208d34:	c911                	beqz	a0,ffffffffc0208d48 <dev_write+0x14>
ffffffffc0208d36:	4d34                	lw	a3,88(a0)
ffffffffc0208d38:	6705                	lui	a4,0x1
ffffffffc0208d3a:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208d3e:	00e69563          	bne	a3,a4,ffffffffc0208d48 <dev_write+0x14>
ffffffffc0208d42:	711c                	ld	a5,32(a0)
ffffffffc0208d44:	4605                	li	a2,1
ffffffffc0208d46:	8782                	jr	a5
ffffffffc0208d48:	1141                	addi	sp,sp,-16
ffffffffc0208d4a:	00005697          	auipc	a3,0x5
ffffffffc0208d4e:	66e68693          	addi	a3,a3,1646 # ffffffffc020e3b8 <syscalls+0x8c8>
ffffffffc0208d52:	00003617          	auipc	a2,0x3
ffffffffc0208d56:	ab660613          	addi	a2,a2,-1354 # ffffffffc020b808 <commands+0x60>
ffffffffc0208d5a:	02c00593          	li	a1,44
ffffffffc0208d5e:	00006517          	auipc	a0,0x6
ffffffffc0208d62:	e3250513          	addi	a0,a0,-462 # ffffffffc020eb90 <syscalls+0x10a0>
ffffffffc0208d66:	e406                	sd	ra,8(sp)
ffffffffc0208d68:	cc6f70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0208d6c <dev_read>:
ffffffffc0208d6c:	c911                	beqz	a0,ffffffffc0208d80 <dev_read+0x14>
ffffffffc0208d6e:	4d34                	lw	a3,88(a0)
ffffffffc0208d70:	6705                	lui	a4,0x1
ffffffffc0208d72:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208d76:	00e69563          	bne	a3,a4,ffffffffc0208d80 <dev_read+0x14>
ffffffffc0208d7a:	711c                	ld	a5,32(a0)
ffffffffc0208d7c:	4601                	li	a2,0
ffffffffc0208d7e:	8782                	jr	a5
ffffffffc0208d80:	1141                	addi	sp,sp,-16
ffffffffc0208d82:	00005697          	auipc	a3,0x5
ffffffffc0208d86:	63668693          	addi	a3,a3,1590 # ffffffffc020e3b8 <syscalls+0x8c8>
ffffffffc0208d8a:	00003617          	auipc	a2,0x3
ffffffffc0208d8e:	a7e60613          	addi	a2,a2,-1410 # ffffffffc020b808 <commands+0x60>
ffffffffc0208d92:	02300593          	li	a1,35
ffffffffc0208d96:	00006517          	auipc	a0,0x6
ffffffffc0208d9a:	dfa50513          	addi	a0,a0,-518 # ffffffffc020eb90 <syscalls+0x10a0>
ffffffffc0208d9e:	e406                	sd	ra,8(sp)
ffffffffc0208da0:	c8ef70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0208da4 <dev_close>:
ffffffffc0208da4:	c909                	beqz	a0,ffffffffc0208db6 <dev_close+0x12>
ffffffffc0208da6:	4d34                	lw	a3,88(a0)
ffffffffc0208da8:	6705                	lui	a4,0x1
ffffffffc0208daa:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208dae:	00e69463          	bne	a3,a4,ffffffffc0208db6 <dev_close+0x12>
ffffffffc0208db2:	6d1c                	ld	a5,24(a0)
ffffffffc0208db4:	8782                	jr	a5
ffffffffc0208db6:	1141                	addi	sp,sp,-16
ffffffffc0208db8:	00005697          	auipc	a3,0x5
ffffffffc0208dbc:	60068693          	addi	a3,a3,1536 # ffffffffc020e3b8 <syscalls+0x8c8>
ffffffffc0208dc0:	00003617          	auipc	a2,0x3
ffffffffc0208dc4:	a4860613          	addi	a2,a2,-1464 # ffffffffc020b808 <commands+0x60>
ffffffffc0208dc8:	45e9                	li	a1,26
ffffffffc0208dca:	00006517          	auipc	a0,0x6
ffffffffc0208dce:	dc650513          	addi	a0,a0,-570 # ffffffffc020eb90 <syscalls+0x10a0>
ffffffffc0208dd2:	e406                	sd	ra,8(sp)
ffffffffc0208dd4:	c5af70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0208dd8 <dev_open>:
ffffffffc0208dd8:	03c5f713          	andi	a4,a1,60
ffffffffc0208ddc:	eb11                	bnez	a4,ffffffffc0208df0 <dev_open+0x18>
ffffffffc0208dde:	c919                	beqz	a0,ffffffffc0208df4 <dev_open+0x1c>
ffffffffc0208de0:	4d34                	lw	a3,88(a0)
ffffffffc0208de2:	6705                	lui	a4,0x1
ffffffffc0208de4:	23470713          	addi	a4,a4,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208de8:	00e69663          	bne	a3,a4,ffffffffc0208df4 <dev_open+0x1c>
ffffffffc0208dec:	691c                	ld	a5,16(a0)
ffffffffc0208dee:	8782                	jr	a5
ffffffffc0208df0:	5575                	li	a0,-3
ffffffffc0208df2:	8082                	ret
ffffffffc0208df4:	1141                	addi	sp,sp,-16
ffffffffc0208df6:	00005697          	auipc	a3,0x5
ffffffffc0208dfa:	5c268693          	addi	a3,a3,1474 # ffffffffc020e3b8 <syscalls+0x8c8>
ffffffffc0208dfe:	00003617          	auipc	a2,0x3
ffffffffc0208e02:	a0a60613          	addi	a2,a2,-1526 # ffffffffc020b808 <commands+0x60>
ffffffffc0208e06:	45c5                	li	a1,17
ffffffffc0208e08:	00006517          	auipc	a0,0x6
ffffffffc0208e0c:	d8850513          	addi	a0,a0,-632 # ffffffffc020eb90 <syscalls+0x10a0>
ffffffffc0208e10:	e406                	sd	ra,8(sp)
ffffffffc0208e12:	c1cf70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0208e16 <dev_init>:
ffffffffc0208e16:	1141                	addi	sp,sp,-16
ffffffffc0208e18:	e406                	sd	ra,8(sp)
ffffffffc0208e1a:	8c1ff0ef          	jal	ra,ffffffffc02086da <dev_init_stdin>
ffffffffc0208e1e:	ccfff0ef          	jal	ra,ffffffffc0208aec <dev_init_stdout>
ffffffffc0208e22:	60a2                	ld	ra,8(sp)
ffffffffc0208e24:	0141                	addi	sp,sp,16
ffffffffc0208e26:	b67ff06f          	j	ffffffffc020898c <dev_init_disk0>

ffffffffc0208e2a <dev_create_inode>:
ffffffffc0208e2a:	6505                	lui	a0,0x1
ffffffffc0208e2c:	1141                	addi	sp,sp,-16
ffffffffc0208e2e:	23450513          	addi	a0,a0,564 # 1234 <_binary_bin_swap_img_size-0x6acc>
ffffffffc0208e32:	e022                	sd	s0,0(sp)
ffffffffc0208e34:	e406                	sd	ra,8(sp)
ffffffffc0208e36:	92eff0ef          	jal	ra,ffffffffc0207f64 <__alloc_inode>
ffffffffc0208e3a:	842a                	mv	s0,a0
ffffffffc0208e3c:	c901                	beqz	a0,ffffffffc0208e4c <dev_create_inode+0x22>
ffffffffc0208e3e:	4601                	li	a2,0
ffffffffc0208e40:	00006597          	auipc	a1,0x6
ffffffffc0208e44:	d6858593          	addi	a1,a1,-664 # ffffffffc020eba8 <dev_node_ops>
ffffffffc0208e48:	938ff0ef          	jal	ra,ffffffffc0207f80 <inode_init>
ffffffffc0208e4c:	60a2                	ld	ra,8(sp)
ffffffffc0208e4e:	8522                	mv	a0,s0
ffffffffc0208e50:	6402                	ld	s0,0(sp)
ffffffffc0208e52:	0141                	addi	sp,sp,16
ffffffffc0208e54:	8082                	ret

ffffffffc0208e56 <sfs_init>:
ffffffffc0208e56:	1141                	addi	sp,sp,-16
ffffffffc0208e58:	00006517          	auipc	a0,0x6
ffffffffc0208e5c:	ca850513          	addi	a0,a0,-856 # ffffffffc020eb00 <syscalls+0x1010>
ffffffffc0208e60:	e406                	sd	ra,8(sp)
ffffffffc0208e62:	361010ef          	jal	ra,ffffffffc020a9c2 <sfs_mount>
ffffffffc0208e66:	e501                	bnez	a0,ffffffffc0208e6e <sfs_init+0x18>
ffffffffc0208e68:	60a2                	ld	ra,8(sp)
ffffffffc0208e6a:	0141                	addi	sp,sp,16
ffffffffc0208e6c:	8082                	ret
ffffffffc0208e6e:	86aa                	mv	a3,a0
ffffffffc0208e70:	00006617          	auipc	a2,0x6
ffffffffc0208e74:	db860613          	addi	a2,a2,-584 # ffffffffc020ec28 <dev_node_ops+0x80>
ffffffffc0208e78:	45c1                	li	a1,16
ffffffffc0208e7a:	00006517          	auipc	a0,0x6
ffffffffc0208e7e:	dce50513          	addi	a0,a0,-562 # ffffffffc020ec48 <dev_node_ops+0xa0>
ffffffffc0208e82:	bacf70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0208e86 <lock_sfs_fs>:
ffffffffc0208e86:	05050513          	addi	a0,a0,80
ffffffffc0208e8a:	8c5fb06f          	j	ffffffffc020474e <down>

ffffffffc0208e8e <lock_sfs_io>:
ffffffffc0208e8e:	06850513          	addi	a0,a0,104
ffffffffc0208e92:	8bdfb06f          	j	ffffffffc020474e <down>

ffffffffc0208e96 <unlock_sfs_fs>:
ffffffffc0208e96:	05050513          	addi	a0,a0,80
ffffffffc0208e9a:	8b1fb06f          	j	ffffffffc020474a <up>

ffffffffc0208e9e <unlock_sfs_io>:
ffffffffc0208e9e:	06850513          	addi	a0,a0,104
ffffffffc0208ea2:	8a9fb06f          	j	ffffffffc020474a <up>

ffffffffc0208ea6 <sfs_opendir>:
ffffffffc0208ea6:	0235f593          	andi	a1,a1,35
ffffffffc0208eaa:	4501                	li	a0,0
ffffffffc0208eac:	e191                	bnez	a1,ffffffffc0208eb0 <sfs_opendir+0xa>
ffffffffc0208eae:	8082                	ret
ffffffffc0208eb0:	553d                	li	a0,-17
ffffffffc0208eb2:	8082                	ret

ffffffffc0208eb4 <sfs_openfile>:
ffffffffc0208eb4:	4501                	li	a0,0
ffffffffc0208eb6:	8082                	ret

ffffffffc0208eb8 <sfs_gettype>:
ffffffffc0208eb8:	1141                	addi	sp,sp,-16
ffffffffc0208eba:	e406                	sd	ra,8(sp)
ffffffffc0208ebc:	c939                	beqz	a0,ffffffffc0208f12 <sfs_gettype+0x5a>
ffffffffc0208ebe:	4d34                	lw	a3,88(a0)
ffffffffc0208ec0:	6785                	lui	a5,0x1
ffffffffc0208ec2:	23578713          	addi	a4,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc0208ec6:	04e69663          	bne	a3,a4,ffffffffc0208f12 <sfs_gettype+0x5a>
ffffffffc0208eca:	6114                	ld	a3,0(a0)
ffffffffc0208ecc:	4709                	li	a4,2
ffffffffc0208ece:	0046d683          	lhu	a3,4(a3)
ffffffffc0208ed2:	02e68a63          	beq	a3,a4,ffffffffc0208f06 <sfs_gettype+0x4e>
ffffffffc0208ed6:	470d                	li	a4,3
ffffffffc0208ed8:	02e68163          	beq	a3,a4,ffffffffc0208efa <sfs_gettype+0x42>
ffffffffc0208edc:	4705                	li	a4,1
ffffffffc0208ede:	00e68f63          	beq	a3,a4,ffffffffc0208efc <sfs_gettype+0x44>
ffffffffc0208ee2:	00006617          	auipc	a2,0x6
ffffffffc0208ee6:	dce60613          	addi	a2,a2,-562 # ffffffffc020ecb0 <dev_node_ops+0x108>
ffffffffc0208eea:	39500593          	li	a1,917
ffffffffc0208eee:	00006517          	auipc	a0,0x6
ffffffffc0208ef2:	daa50513          	addi	a0,a0,-598 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc0208ef6:	b38f70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0208efa:	678d                	lui	a5,0x3
ffffffffc0208efc:	60a2                	ld	ra,8(sp)
ffffffffc0208efe:	c19c                	sw	a5,0(a1)
ffffffffc0208f00:	4501                	li	a0,0
ffffffffc0208f02:	0141                	addi	sp,sp,16
ffffffffc0208f04:	8082                	ret
ffffffffc0208f06:	60a2                	ld	ra,8(sp)
ffffffffc0208f08:	6789                	lui	a5,0x2
ffffffffc0208f0a:	c19c                	sw	a5,0(a1)
ffffffffc0208f0c:	4501                	li	a0,0
ffffffffc0208f0e:	0141                	addi	sp,sp,16
ffffffffc0208f10:	8082                	ret
ffffffffc0208f12:	00006697          	auipc	a3,0x6
ffffffffc0208f16:	d4e68693          	addi	a3,a3,-690 # ffffffffc020ec60 <dev_node_ops+0xb8>
ffffffffc0208f1a:	00003617          	auipc	a2,0x3
ffffffffc0208f1e:	8ee60613          	addi	a2,a2,-1810 # ffffffffc020b808 <commands+0x60>
ffffffffc0208f22:	38900593          	li	a1,905
ffffffffc0208f26:	00006517          	auipc	a0,0x6
ffffffffc0208f2a:	d7250513          	addi	a0,a0,-654 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc0208f2e:	b00f70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0208f32 <sfs_fsync>:
ffffffffc0208f32:	7179                	addi	sp,sp,-48
ffffffffc0208f34:	ec26                	sd	s1,24(sp)
ffffffffc0208f36:	7524                	ld	s1,104(a0)
ffffffffc0208f38:	f406                	sd	ra,40(sp)
ffffffffc0208f3a:	f022                	sd	s0,32(sp)
ffffffffc0208f3c:	e84a                	sd	s2,16(sp)
ffffffffc0208f3e:	e44e                	sd	s3,8(sp)
ffffffffc0208f40:	c4bd                	beqz	s1,ffffffffc0208fae <sfs_fsync+0x7c>
ffffffffc0208f42:	0b04a783          	lw	a5,176(s1)
ffffffffc0208f46:	e7a5                	bnez	a5,ffffffffc0208fae <sfs_fsync+0x7c>
ffffffffc0208f48:	4d38                	lw	a4,88(a0)
ffffffffc0208f4a:	6785                	lui	a5,0x1
ffffffffc0208f4c:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc0208f50:	842a                	mv	s0,a0
ffffffffc0208f52:	06f71e63          	bne	a4,a5,ffffffffc0208fce <sfs_fsync+0x9c>
ffffffffc0208f56:	691c                	ld	a5,16(a0)
ffffffffc0208f58:	4901                	li	s2,0
ffffffffc0208f5a:	eb89                	bnez	a5,ffffffffc0208f6c <sfs_fsync+0x3a>
ffffffffc0208f5c:	70a2                	ld	ra,40(sp)
ffffffffc0208f5e:	7402                	ld	s0,32(sp)
ffffffffc0208f60:	64e2                	ld	s1,24(sp)
ffffffffc0208f62:	69a2                	ld	s3,8(sp)
ffffffffc0208f64:	854a                	mv	a0,s2
ffffffffc0208f66:	6942                	ld	s2,16(sp)
ffffffffc0208f68:	6145                	addi	sp,sp,48
ffffffffc0208f6a:	8082                	ret
ffffffffc0208f6c:	02050993          	addi	s3,a0,32
ffffffffc0208f70:	854e                	mv	a0,s3
ffffffffc0208f72:	fdcfb0ef          	jal	ra,ffffffffc020474e <down>
ffffffffc0208f76:	681c                	ld	a5,16(s0)
ffffffffc0208f78:	ef81                	bnez	a5,ffffffffc0208f90 <sfs_fsync+0x5e>
ffffffffc0208f7a:	854e                	mv	a0,s3
ffffffffc0208f7c:	fcefb0ef          	jal	ra,ffffffffc020474a <up>
ffffffffc0208f80:	70a2                	ld	ra,40(sp)
ffffffffc0208f82:	7402                	ld	s0,32(sp)
ffffffffc0208f84:	64e2                	ld	s1,24(sp)
ffffffffc0208f86:	69a2                	ld	s3,8(sp)
ffffffffc0208f88:	854a                	mv	a0,s2
ffffffffc0208f8a:	6942                	ld	s2,16(sp)
ffffffffc0208f8c:	6145                	addi	sp,sp,48
ffffffffc0208f8e:	8082                	ret
ffffffffc0208f90:	4414                	lw	a3,8(s0)
ffffffffc0208f92:	600c                	ld	a1,0(s0)
ffffffffc0208f94:	00043823          	sd	zero,16(s0)
ffffffffc0208f98:	4701                	li	a4,0
ffffffffc0208f9a:	04000613          	li	a2,64
ffffffffc0208f9e:	8526                	mv	a0,s1
ffffffffc0208fa0:	60d010ef          	jal	ra,ffffffffc020adac <sfs_wbuf>
ffffffffc0208fa4:	892a                	mv	s2,a0
ffffffffc0208fa6:	d971                	beqz	a0,ffffffffc0208f7a <sfs_fsync+0x48>
ffffffffc0208fa8:	4785                	li	a5,1
ffffffffc0208faa:	e81c                	sd	a5,16(s0)
ffffffffc0208fac:	b7f9                	j	ffffffffc0208f7a <sfs_fsync+0x48>
ffffffffc0208fae:	00006697          	auipc	a3,0x6
ffffffffc0208fb2:	d1a68693          	addi	a3,a3,-742 # ffffffffc020ecc8 <dev_node_ops+0x120>
ffffffffc0208fb6:	00003617          	auipc	a2,0x3
ffffffffc0208fba:	85260613          	addi	a2,a2,-1966 # ffffffffc020b808 <commands+0x60>
ffffffffc0208fbe:	2cd00593          	li	a1,717
ffffffffc0208fc2:	00006517          	auipc	a0,0x6
ffffffffc0208fc6:	cd650513          	addi	a0,a0,-810 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc0208fca:	a64f70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0208fce:	00006697          	auipc	a3,0x6
ffffffffc0208fd2:	c9268693          	addi	a3,a3,-878 # ffffffffc020ec60 <dev_node_ops+0xb8>
ffffffffc0208fd6:	00003617          	auipc	a2,0x3
ffffffffc0208fda:	83260613          	addi	a2,a2,-1998 # ffffffffc020b808 <commands+0x60>
ffffffffc0208fde:	2ce00593          	li	a1,718
ffffffffc0208fe2:	00006517          	auipc	a0,0x6
ffffffffc0208fe6:	cb650513          	addi	a0,a0,-842 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc0208fea:	a44f70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0208fee <sfs_fstat>:
ffffffffc0208fee:	1101                	addi	sp,sp,-32
ffffffffc0208ff0:	e426                	sd	s1,8(sp)
ffffffffc0208ff2:	84ae                	mv	s1,a1
ffffffffc0208ff4:	e822                	sd	s0,16(sp)
ffffffffc0208ff6:	02000613          	li	a2,32
ffffffffc0208ffa:	842a                	mv	s0,a0
ffffffffc0208ffc:	4581                	li	a1,0
ffffffffc0208ffe:	8526                	mv	a0,s1
ffffffffc0209000:	ec06                	sd	ra,24(sp)
ffffffffc0209002:	7fd010ef          	jal	ra,ffffffffc020affe <memset>
ffffffffc0209006:	c439                	beqz	s0,ffffffffc0209054 <sfs_fstat+0x66>
ffffffffc0209008:	783c                	ld	a5,112(s0)
ffffffffc020900a:	c7a9                	beqz	a5,ffffffffc0209054 <sfs_fstat+0x66>
ffffffffc020900c:	6bbc                	ld	a5,80(a5)
ffffffffc020900e:	c3b9                	beqz	a5,ffffffffc0209054 <sfs_fstat+0x66>
ffffffffc0209010:	00005597          	auipc	a1,0x5
ffffffffc0209014:	47058593          	addi	a1,a1,1136 # ffffffffc020e480 <syscalls+0x990>
ffffffffc0209018:	8522                	mv	a0,s0
ffffffffc020901a:	fe1fe0ef          	jal	ra,ffffffffc0207ffa <inode_check>
ffffffffc020901e:	783c                	ld	a5,112(s0)
ffffffffc0209020:	85a6                	mv	a1,s1
ffffffffc0209022:	8522                	mv	a0,s0
ffffffffc0209024:	6bbc                	ld	a5,80(a5)
ffffffffc0209026:	9782                	jalr	a5
ffffffffc0209028:	e10d                	bnez	a0,ffffffffc020904a <sfs_fstat+0x5c>
ffffffffc020902a:	4c38                	lw	a4,88(s0)
ffffffffc020902c:	6785                	lui	a5,0x1
ffffffffc020902e:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc0209032:	04f71163          	bne	a4,a5,ffffffffc0209074 <sfs_fstat+0x86>
ffffffffc0209036:	601c                	ld	a5,0(s0)
ffffffffc0209038:	0067d683          	lhu	a3,6(a5)
ffffffffc020903c:	0087e703          	lwu	a4,8(a5)
ffffffffc0209040:	0007e783          	lwu	a5,0(a5)
ffffffffc0209044:	e494                	sd	a3,8(s1)
ffffffffc0209046:	e898                	sd	a4,16(s1)
ffffffffc0209048:	ec9c                	sd	a5,24(s1)
ffffffffc020904a:	60e2                	ld	ra,24(sp)
ffffffffc020904c:	6442                	ld	s0,16(sp)
ffffffffc020904e:	64a2                	ld	s1,8(sp)
ffffffffc0209050:	6105                	addi	sp,sp,32
ffffffffc0209052:	8082                	ret
ffffffffc0209054:	00005697          	auipc	a3,0x5
ffffffffc0209058:	3c468693          	addi	a3,a3,964 # ffffffffc020e418 <syscalls+0x928>
ffffffffc020905c:	00002617          	auipc	a2,0x2
ffffffffc0209060:	7ac60613          	addi	a2,a2,1964 # ffffffffc020b808 <commands+0x60>
ffffffffc0209064:	2be00593          	li	a1,702
ffffffffc0209068:	00006517          	auipc	a0,0x6
ffffffffc020906c:	c3050513          	addi	a0,a0,-976 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc0209070:	9bef70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0209074:	00006697          	auipc	a3,0x6
ffffffffc0209078:	bec68693          	addi	a3,a3,-1044 # ffffffffc020ec60 <dev_node_ops+0xb8>
ffffffffc020907c:	00002617          	auipc	a2,0x2
ffffffffc0209080:	78c60613          	addi	a2,a2,1932 # ffffffffc020b808 <commands+0x60>
ffffffffc0209084:	2c100593          	li	a1,705
ffffffffc0209088:	00006517          	auipc	a0,0x6
ffffffffc020908c:	c1050513          	addi	a0,a0,-1008 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc0209090:	99ef70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0209094 <sfs_tryseek>:
ffffffffc0209094:	080007b7          	lui	a5,0x8000
ffffffffc0209098:	04f5fd63          	bgeu	a1,a5,ffffffffc02090f2 <sfs_tryseek+0x5e>
ffffffffc020909c:	1101                	addi	sp,sp,-32
ffffffffc020909e:	e822                	sd	s0,16(sp)
ffffffffc02090a0:	ec06                	sd	ra,24(sp)
ffffffffc02090a2:	e426                	sd	s1,8(sp)
ffffffffc02090a4:	842a                	mv	s0,a0
ffffffffc02090a6:	c921                	beqz	a0,ffffffffc02090f6 <sfs_tryseek+0x62>
ffffffffc02090a8:	4d38                	lw	a4,88(a0)
ffffffffc02090aa:	6785                	lui	a5,0x1
ffffffffc02090ac:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc02090b0:	04f71363          	bne	a4,a5,ffffffffc02090f6 <sfs_tryseek+0x62>
ffffffffc02090b4:	611c                	ld	a5,0(a0)
ffffffffc02090b6:	84ae                	mv	s1,a1
ffffffffc02090b8:	0007e783          	lwu	a5,0(a5)
ffffffffc02090bc:	02b7d563          	bge	a5,a1,ffffffffc02090e6 <sfs_tryseek+0x52>
ffffffffc02090c0:	793c                	ld	a5,112(a0)
ffffffffc02090c2:	cbb1                	beqz	a5,ffffffffc0209116 <sfs_tryseek+0x82>
ffffffffc02090c4:	73bc                	ld	a5,96(a5)
ffffffffc02090c6:	cba1                	beqz	a5,ffffffffc0209116 <sfs_tryseek+0x82>
ffffffffc02090c8:	00006597          	auipc	a1,0x6
ffffffffc02090cc:	83858593          	addi	a1,a1,-1992 # ffffffffc020e900 <syscalls+0xe10>
ffffffffc02090d0:	f2bfe0ef          	jal	ra,ffffffffc0207ffa <inode_check>
ffffffffc02090d4:	783c                	ld	a5,112(s0)
ffffffffc02090d6:	8522                	mv	a0,s0
ffffffffc02090d8:	6442                	ld	s0,16(sp)
ffffffffc02090da:	60e2                	ld	ra,24(sp)
ffffffffc02090dc:	73bc                	ld	a5,96(a5)
ffffffffc02090de:	85a6                	mv	a1,s1
ffffffffc02090e0:	64a2                	ld	s1,8(sp)
ffffffffc02090e2:	6105                	addi	sp,sp,32
ffffffffc02090e4:	8782                	jr	a5
ffffffffc02090e6:	60e2                	ld	ra,24(sp)
ffffffffc02090e8:	6442                	ld	s0,16(sp)
ffffffffc02090ea:	64a2                	ld	s1,8(sp)
ffffffffc02090ec:	4501                	li	a0,0
ffffffffc02090ee:	6105                	addi	sp,sp,32
ffffffffc02090f0:	8082                	ret
ffffffffc02090f2:	5575                	li	a0,-3
ffffffffc02090f4:	8082                	ret
ffffffffc02090f6:	00006697          	auipc	a3,0x6
ffffffffc02090fa:	b6a68693          	addi	a3,a3,-1174 # ffffffffc020ec60 <dev_node_ops+0xb8>
ffffffffc02090fe:	00002617          	auipc	a2,0x2
ffffffffc0209102:	70a60613          	addi	a2,a2,1802 # ffffffffc020b808 <commands+0x60>
ffffffffc0209106:	3a000593          	li	a1,928
ffffffffc020910a:	00006517          	auipc	a0,0x6
ffffffffc020910e:	b8e50513          	addi	a0,a0,-1138 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc0209112:	91cf70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0209116:	00005697          	auipc	a3,0x5
ffffffffc020911a:	79268693          	addi	a3,a3,1938 # ffffffffc020e8a8 <syscalls+0xdb8>
ffffffffc020911e:	00002617          	auipc	a2,0x2
ffffffffc0209122:	6ea60613          	addi	a2,a2,1770 # ffffffffc020b808 <commands+0x60>
ffffffffc0209126:	3a200593          	li	a1,930
ffffffffc020912a:	00006517          	auipc	a0,0x6
ffffffffc020912e:	b6e50513          	addi	a0,a0,-1170 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc0209132:	8fcf70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0209136 <sfs_close>:
ffffffffc0209136:	1141                	addi	sp,sp,-16
ffffffffc0209138:	e406                	sd	ra,8(sp)
ffffffffc020913a:	e022                	sd	s0,0(sp)
ffffffffc020913c:	c11d                	beqz	a0,ffffffffc0209162 <sfs_close+0x2c>
ffffffffc020913e:	793c                	ld	a5,112(a0)
ffffffffc0209140:	842a                	mv	s0,a0
ffffffffc0209142:	c385                	beqz	a5,ffffffffc0209162 <sfs_close+0x2c>
ffffffffc0209144:	7b9c                	ld	a5,48(a5)
ffffffffc0209146:	cf91                	beqz	a5,ffffffffc0209162 <sfs_close+0x2c>
ffffffffc0209148:	00004597          	auipc	a1,0x4
ffffffffc020914c:	1e058593          	addi	a1,a1,480 # ffffffffc020d328 <default_pmm_manager+0x460>
ffffffffc0209150:	eabfe0ef          	jal	ra,ffffffffc0207ffa <inode_check>
ffffffffc0209154:	783c                	ld	a5,112(s0)
ffffffffc0209156:	8522                	mv	a0,s0
ffffffffc0209158:	6402                	ld	s0,0(sp)
ffffffffc020915a:	60a2                	ld	ra,8(sp)
ffffffffc020915c:	7b9c                	ld	a5,48(a5)
ffffffffc020915e:	0141                	addi	sp,sp,16
ffffffffc0209160:	8782                	jr	a5
ffffffffc0209162:	00004697          	auipc	a3,0x4
ffffffffc0209166:	17668693          	addi	a3,a3,374 # ffffffffc020d2d8 <default_pmm_manager+0x410>
ffffffffc020916a:	00002617          	auipc	a2,0x2
ffffffffc020916e:	69e60613          	addi	a2,a2,1694 # ffffffffc020b808 <commands+0x60>
ffffffffc0209172:	21c00593          	li	a1,540
ffffffffc0209176:	00006517          	auipc	a0,0x6
ffffffffc020917a:	b2250513          	addi	a0,a0,-1246 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc020917e:	8b0f70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0209182 <sfs_io.part.0>:
ffffffffc0209182:	1141                	addi	sp,sp,-16
ffffffffc0209184:	00006697          	auipc	a3,0x6
ffffffffc0209188:	adc68693          	addi	a3,a3,-1316 # ffffffffc020ec60 <dev_node_ops+0xb8>
ffffffffc020918c:	00002617          	auipc	a2,0x2
ffffffffc0209190:	67c60613          	addi	a2,a2,1660 # ffffffffc020b808 <commands+0x60>
ffffffffc0209194:	29d00593          	li	a1,669
ffffffffc0209198:	00006517          	auipc	a0,0x6
ffffffffc020919c:	b0050513          	addi	a0,a0,-1280 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc02091a0:	e406                	sd	ra,8(sp)
ffffffffc02091a2:	88cf70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02091a6 <sfs_block_free>:
ffffffffc02091a6:	1101                	addi	sp,sp,-32
ffffffffc02091a8:	e426                	sd	s1,8(sp)
ffffffffc02091aa:	ec06                	sd	ra,24(sp)
ffffffffc02091ac:	e822                	sd	s0,16(sp)
ffffffffc02091ae:	4154                	lw	a3,4(a0)
ffffffffc02091b0:	84ae                	mv	s1,a1
ffffffffc02091b2:	c595                	beqz	a1,ffffffffc02091de <sfs_block_free+0x38>
ffffffffc02091b4:	02d5f563          	bgeu	a1,a3,ffffffffc02091de <sfs_block_free+0x38>
ffffffffc02091b8:	842a                	mv	s0,a0
ffffffffc02091ba:	7d08                	ld	a0,56(a0)
ffffffffc02091bc:	1b7010ef          	jal	ra,ffffffffc020ab72 <bitmap_test>
ffffffffc02091c0:	ed05                	bnez	a0,ffffffffc02091f8 <sfs_block_free+0x52>
ffffffffc02091c2:	7c08                	ld	a0,56(s0)
ffffffffc02091c4:	85a6                	mv	a1,s1
ffffffffc02091c6:	1d5010ef          	jal	ra,ffffffffc020ab9a <bitmap_free>
ffffffffc02091ca:	441c                	lw	a5,8(s0)
ffffffffc02091cc:	4705                	li	a4,1
ffffffffc02091ce:	60e2                	ld	ra,24(sp)
ffffffffc02091d0:	2785                	addiw	a5,a5,1
ffffffffc02091d2:	e038                	sd	a4,64(s0)
ffffffffc02091d4:	c41c                	sw	a5,8(s0)
ffffffffc02091d6:	6442                	ld	s0,16(sp)
ffffffffc02091d8:	64a2                	ld	s1,8(sp)
ffffffffc02091da:	6105                	addi	sp,sp,32
ffffffffc02091dc:	8082                	ret
ffffffffc02091de:	8726                	mv	a4,s1
ffffffffc02091e0:	00006617          	auipc	a2,0x6
ffffffffc02091e4:	b1860613          	addi	a2,a2,-1256 # ffffffffc020ecf8 <dev_node_ops+0x150>
ffffffffc02091e8:	05300593          	li	a1,83
ffffffffc02091ec:	00006517          	auipc	a0,0x6
ffffffffc02091f0:	aac50513          	addi	a0,a0,-1364 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc02091f4:	83af70ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02091f8:	00006697          	auipc	a3,0x6
ffffffffc02091fc:	b3868693          	addi	a3,a3,-1224 # ffffffffc020ed30 <dev_node_ops+0x188>
ffffffffc0209200:	00002617          	auipc	a2,0x2
ffffffffc0209204:	60860613          	addi	a2,a2,1544 # ffffffffc020b808 <commands+0x60>
ffffffffc0209208:	06a00593          	li	a1,106
ffffffffc020920c:	00006517          	auipc	a0,0x6
ffffffffc0209210:	a8c50513          	addi	a0,a0,-1396 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc0209214:	81af70ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0209218 <sfs_reclaim>:
ffffffffc0209218:	1101                	addi	sp,sp,-32
ffffffffc020921a:	e426                	sd	s1,8(sp)
ffffffffc020921c:	7524                	ld	s1,104(a0)
ffffffffc020921e:	ec06                	sd	ra,24(sp)
ffffffffc0209220:	e822                	sd	s0,16(sp)
ffffffffc0209222:	e04a                	sd	s2,0(sp)
ffffffffc0209224:	0e048a63          	beqz	s1,ffffffffc0209318 <sfs_reclaim+0x100>
ffffffffc0209228:	0b04a783          	lw	a5,176(s1)
ffffffffc020922c:	0e079663          	bnez	a5,ffffffffc0209318 <sfs_reclaim+0x100>
ffffffffc0209230:	4d38                	lw	a4,88(a0)
ffffffffc0209232:	6785                	lui	a5,0x1
ffffffffc0209234:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc0209238:	842a                	mv	s0,a0
ffffffffc020923a:	10f71f63          	bne	a4,a5,ffffffffc0209358 <sfs_reclaim+0x140>
ffffffffc020923e:	8526                	mv	a0,s1
ffffffffc0209240:	c47ff0ef          	jal	ra,ffffffffc0208e86 <lock_sfs_fs>
ffffffffc0209244:	4c1c                	lw	a5,24(s0)
ffffffffc0209246:	0ef05963          	blez	a5,ffffffffc0209338 <sfs_reclaim+0x120>
ffffffffc020924a:	fff7871b          	addiw	a4,a5,-1
ffffffffc020924e:	cc18                	sw	a4,24(s0)
ffffffffc0209250:	eb59                	bnez	a4,ffffffffc02092e6 <sfs_reclaim+0xce>
ffffffffc0209252:	05c42903          	lw	s2,92(s0)
ffffffffc0209256:	08091863          	bnez	s2,ffffffffc02092e6 <sfs_reclaim+0xce>
ffffffffc020925a:	601c                	ld	a5,0(s0)
ffffffffc020925c:	0067d783          	lhu	a5,6(a5)
ffffffffc0209260:	e785                	bnez	a5,ffffffffc0209288 <sfs_reclaim+0x70>
ffffffffc0209262:	783c                	ld	a5,112(s0)
ffffffffc0209264:	10078a63          	beqz	a5,ffffffffc0209378 <sfs_reclaim+0x160>
ffffffffc0209268:	73bc                	ld	a5,96(a5)
ffffffffc020926a:	10078763          	beqz	a5,ffffffffc0209378 <sfs_reclaim+0x160>
ffffffffc020926e:	00005597          	auipc	a1,0x5
ffffffffc0209272:	69258593          	addi	a1,a1,1682 # ffffffffc020e900 <syscalls+0xe10>
ffffffffc0209276:	8522                	mv	a0,s0
ffffffffc0209278:	d83fe0ef          	jal	ra,ffffffffc0207ffa <inode_check>
ffffffffc020927c:	783c                	ld	a5,112(s0)
ffffffffc020927e:	4581                	li	a1,0
ffffffffc0209280:	8522                	mv	a0,s0
ffffffffc0209282:	73bc                	ld	a5,96(a5)
ffffffffc0209284:	9782                	jalr	a5
ffffffffc0209286:	e559                	bnez	a0,ffffffffc0209314 <sfs_reclaim+0xfc>
ffffffffc0209288:	681c                	ld	a5,16(s0)
ffffffffc020928a:	c39d                	beqz	a5,ffffffffc02092b0 <sfs_reclaim+0x98>
ffffffffc020928c:	783c                	ld	a5,112(s0)
ffffffffc020928e:	10078563          	beqz	a5,ffffffffc0209398 <sfs_reclaim+0x180>
ffffffffc0209292:	7b9c                	ld	a5,48(a5)
ffffffffc0209294:	10078263          	beqz	a5,ffffffffc0209398 <sfs_reclaim+0x180>
ffffffffc0209298:	8522                	mv	a0,s0
ffffffffc020929a:	00004597          	auipc	a1,0x4
ffffffffc020929e:	08e58593          	addi	a1,a1,142 # ffffffffc020d328 <default_pmm_manager+0x460>
ffffffffc02092a2:	d59fe0ef          	jal	ra,ffffffffc0207ffa <inode_check>
ffffffffc02092a6:	783c                	ld	a5,112(s0)
ffffffffc02092a8:	8522                	mv	a0,s0
ffffffffc02092aa:	7b9c                	ld	a5,48(a5)
ffffffffc02092ac:	9782                	jalr	a5
ffffffffc02092ae:	e13d                	bnez	a0,ffffffffc0209314 <sfs_reclaim+0xfc>
ffffffffc02092b0:	7c18                	ld	a4,56(s0)
ffffffffc02092b2:	603c                	ld	a5,64(s0)
ffffffffc02092b4:	8526                	mv	a0,s1
ffffffffc02092b6:	e71c                	sd	a5,8(a4)
ffffffffc02092b8:	e398                	sd	a4,0(a5)
ffffffffc02092ba:	6438                	ld	a4,72(s0)
ffffffffc02092bc:	683c                	ld	a5,80(s0)
ffffffffc02092be:	e71c                	sd	a5,8(a4)
ffffffffc02092c0:	e398                	sd	a4,0(a5)
ffffffffc02092c2:	bd5ff0ef          	jal	ra,ffffffffc0208e96 <unlock_sfs_fs>
ffffffffc02092c6:	6008                	ld	a0,0(s0)
ffffffffc02092c8:	00655783          	lhu	a5,6(a0)
ffffffffc02092cc:	cb85                	beqz	a5,ffffffffc02092fc <sfs_reclaim+0xe4>
ffffffffc02092ce:	da8fa0ef          	jal	ra,ffffffffc0203876 <kfree>
ffffffffc02092d2:	8522                	mv	a0,s0
ffffffffc02092d4:	cbbfe0ef          	jal	ra,ffffffffc0207f8e <inode_kill>
ffffffffc02092d8:	60e2                	ld	ra,24(sp)
ffffffffc02092da:	6442                	ld	s0,16(sp)
ffffffffc02092dc:	64a2                	ld	s1,8(sp)
ffffffffc02092de:	854a                	mv	a0,s2
ffffffffc02092e0:	6902                	ld	s2,0(sp)
ffffffffc02092e2:	6105                	addi	sp,sp,32
ffffffffc02092e4:	8082                	ret
ffffffffc02092e6:	5945                	li	s2,-15
ffffffffc02092e8:	8526                	mv	a0,s1
ffffffffc02092ea:	badff0ef          	jal	ra,ffffffffc0208e96 <unlock_sfs_fs>
ffffffffc02092ee:	60e2                	ld	ra,24(sp)
ffffffffc02092f0:	6442                	ld	s0,16(sp)
ffffffffc02092f2:	64a2                	ld	s1,8(sp)
ffffffffc02092f4:	854a                	mv	a0,s2
ffffffffc02092f6:	6902                	ld	s2,0(sp)
ffffffffc02092f8:	6105                	addi	sp,sp,32
ffffffffc02092fa:	8082                	ret
ffffffffc02092fc:	440c                	lw	a1,8(s0)
ffffffffc02092fe:	8526                	mv	a0,s1
ffffffffc0209300:	ea7ff0ef          	jal	ra,ffffffffc02091a6 <sfs_block_free>
ffffffffc0209304:	6008                	ld	a0,0(s0)
ffffffffc0209306:	5d4c                	lw	a1,60(a0)
ffffffffc0209308:	d1f9                	beqz	a1,ffffffffc02092ce <sfs_reclaim+0xb6>
ffffffffc020930a:	8526                	mv	a0,s1
ffffffffc020930c:	e9bff0ef          	jal	ra,ffffffffc02091a6 <sfs_block_free>
ffffffffc0209310:	6008                	ld	a0,0(s0)
ffffffffc0209312:	bf75                	j	ffffffffc02092ce <sfs_reclaim+0xb6>
ffffffffc0209314:	892a                	mv	s2,a0
ffffffffc0209316:	bfc9                	j	ffffffffc02092e8 <sfs_reclaim+0xd0>
ffffffffc0209318:	00006697          	auipc	a3,0x6
ffffffffc020931c:	9b068693          	addi	a3,a3,-1616 # ffffffffc020ecc8 <dev_node_ops+0x120>
ffffffffc0209320:	00002617          	auipc	a2,0x2
ffffffffc0209324:	4e860613          	addi	a2,a2,1256 # ffffffffc020b808 <commands+0x60>
ffffffffc0209328:	35e00593          	li	a1,862
ffffffffc020932c:	00006517          	auipc	a0,0x6
ffffffffc0209330:	96c50513          	addi	a0,a0,-1684 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc0209334:	efbf60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0209338:	00006697          	auipc	a3,0x6
ffffffffc020933c:	a1868693          	addi	a3,a3,-1512 # ffffffffc020ed50 <dev_node_ops+0x1a8>
ffffffffc0209340:	00002617          	auipc	a2,0x2
ffffffffc0209344:	4c860613          	addi	a2,a2,1224 # ffffffffc020b808 <commands+0x60>
ffffffffc0209348:	36400593          	li	a1,868
ffffffffc020934c:	00006517          	auipc	a0,0x6
ffffffffc0209350:	94c50513          	addi	a0,a0,-1716 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc0209354:	edbf60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0209358:	00006697          	auipc	a3,0x6
ffffffffc020935c:	90868693          	addi	a3,a3,-1784 # ffffffffc020ec60 <dev_node_ops+0xb8>
ffffffffc0209360:	00002617          	auipc	a2,0x2
ffffffffc0209364:	4a860613          	addi	a2,a2,1192 # ffffffffc020b808 <commands+0x60>
ffffffffc0209368:	35f00593          	li	a1,863
ffffffffc020936c:	00006517          	auipc	a0,0x6
ffffffffc0209370:	92c50513          	addi	a0,a0,-1748 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc0209374:	ebbf60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0209378:	00005697          	auipc	a3,0x5
ffffffffc020937c:	53068693          	addi	a3,a3,1328 # ffffffffc020e8a8 <syscalls+0xdb8>
ffffffffc0209380:	00002617          	auipc	a2,0x2
ffffffffc0209384:	48860613          	addi	a2,a2,1160 # ffffffffc020b808 <commands+0x60>
ffffffffc0209388:	36900593          	li	a1,873
ffffffffc020938c:	00006517          	auipc	a0,0x6
ffffffffc0209390:	90c50513          	addi	a0,a0,-1780 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc0209394:	e9bf60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0209398:	00004697          	auipc	a3,0x4
ffffffffc020939c:	f4068693          	addi	a3,a3,-192 # ffffffffc020d2d8 <default_pmm_manager+0x410>
ffffffffc02093a0:	00002617          	auipc	a2,0x2
ffffffffc02093a4:	46860613          	addi	a2,a2,1128 # ffffffffc020b808 <commands+0x60>
ffffffffc02093a8:	36e00593          	li	a1,878
ffffffffc02093ac:	00006517          	auipc	a0,0x6
ffffffffc02093b0:	8ec50513          	addi	a0,a0,-1812 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc02093b4:	e7bf60ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02093b8 <sfs_block_alloc>:
ffffffffc02093b8:	1101                	addi	sp,sp,-32
ffffffffc02093ba:	e822                	sd	s0,16(sp)
ffffffffc02093bc:	842a                	mv	s0,a0
ffffffffc02093be:	7d08                	ld	a0,56(a0)
ffffffffc02093c0:	e426                	sd	s1,8(sp)
ffffffffc02093c2:	ec06                	sd	ra,24(sp)
ffffffffc02093c4:	84ae                	mv	s1,a1
ffffffffc02093c6:	73c010ef          	jal	ra,ffffffffc020ab02 <bitmap_alloc>
ffffffffc02093ca:	e90d                	bnez	a0,ffffffffc02093fc <sfs_block_alloc+0x44>
ffffffffc02093cc:	441c                	lw	a5,8(s0)
ffffffffc02093ce:	cbad                	beqz	a5,ffffffffc0209440 <sfs_block_alloc+0x88>
ffffffffc02093d0:	37fd                	addiw	a5,a5,-1
ffffffffc02093d2:	c41c                	sw	a5,8(s0)
ffffffffc02093d4:	408c                	lw	a1,0(s1)
ffffffffc02093d6:	4785                	li	a5,1
ffffffffc02093d8:	e03c                	sd	a5,64(s0)
ffffffffc02093da:	4054                	lw	a3,4(s0)
ffffffffc02093dc:	c58d                	beqz	a1,ffffffffc0209406 <sfs_block_alloc+0x4e>
ffffffffc02093de:	02d5f463          	bgeu	a1,a3,ffffffffc0209406 <sfs_block_alloc+0x4e>
ffffffffc02093e2:	7c08                	ld	a0,56(s0)
ffffffffc02093e4:	78e010ef          	jal	ra,ffffffffc020ab72 <bitmap_test>
ffffffffc02093e8:	ed05                	bnez	a0,ffffffffc0209420 <sfs_block_alloc+0x68>
ffffffffc02093ea:	8522                	mv	a0,s0
ffffffffc02093ec:	6442                	ld	s0,16(sp)
ffffffffc02093ee:	408c                	lw	a1,0(s1)
ffffffffc02093f0:	60e2                	ld	ra,24(sp)
ffffffffc02093f2:	64a2                	ld	s1,8(sp)
ffffffffc02093f4:	4605                	li	a2,1
ffffffffc02093f6:	6105                	addi	sp,sp,32
ffffffffc02093f8:	3050106f          	j	ffffffffc020aefc <sfs_clear_block>
ffffffffc02093fc:	60e2                	ld	ra,24(sp)
ffffffffc02093fe:	6442                	ld	s0,16(sp)
ffffffffc0209400:	64a2                	ld	s1,8(sp)
ffffffffc0209402:	6105                	addi	sp,sp,32
ffffffffc0209404:	8082                	ret
ffffffffc0209406:	872e                	mv	a4,a1
ffffffffc0209408:	00006617          	auipc	a2,0x6
ffffffffc020940c:	8f060613          	addi	a2,a2,-1808 # ffffffffc020ecf8 <dev_node_ops+0x150>
ffffffffc0209410:	05300593          	li	a1,83
ffffffffc0209414:	00006517          	auipc	a0,0x6
ffffffffc0209418:	88450513          	addi	a0,a0,-1916 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc020941c:	e13f60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0209420:	00006697          	auipc	a3,0x6
ffffffffc0209424:	96868693          	addi	a3,a3,-1688 # ffffffffc020ed88 <dev_node_ops+0x1e0>
ffffffffc0209428:	00002617          	auipc	a2,0x2
ffffffffc020942c:	3e060613          	addi	a2,a2,992 # ffffffffc020b808 <commands+0x60>
ffffffffc0209430:	06100593          	li	a1,97
ffffffffc0209434:	00006517          	auipc	a0,0x6
ffffffffc0209438:	86450513          	addi	a0,a0,-1948 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc020943c:	df3f60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0209440:	00006697          	auipc	a3,0x6
ffffffffc0209444:	92868693          	addi	a3,a3,-1752 # ffffffffc020ed68 <dev_node_ops+0x1c0>
ffffffffc0209448:	00002617          	auipc	a2,0x2
ffffffffc020944c:	3c060613          	addi	a2,a2,960 # ffffffffc020b808 <commands+0x60>
ffffffffc0209450:	05f00593          	li	a1,95
ffffffffc0209454:	00006517          	auipc	a0,0x6
ffffffffc0209458:	84450513          	addi	a0,a0,-1980 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc020945c:	dd3f60ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0209460 <sfs_bmap_load_nolock>:
ffffffffc0209460:	7159                	addi	sp,sp,-112
ffffffffc0209462:	f85a                	sd	s6,48(sp)
ffffffffc0209464:	0005bb03          	ld	s6,0(a1)
ffffffffc0209468:	f45e                	sd	s7,40(sp)
ffffffffc020946a:	f486                	sd	ra,104(sp)
ffffffffc020946c:	008b2b83          	lw	s7,8(s6)
ffffffffc0209470:	f0a2                	sd	s0,96(sp)
ffffffffc0209472:	eca6                	sd	s1,88(sp)
ffffffffc0209474:	e8ca                	sd	s2,80(sp)
ffffffffc0209476:	e4ce                	sd	s3,72(sp)
ffffffffc0209478:	e0d2                	sd	s4,64(sp)
ffffffffc020947a:	fc56                	sd	s5,56(sp)
ffffffffc020947c:	f062                	sd	s8,32(sp)
ffffffffc020947e:	ec66                	sd	s9,24(sp)
ffffffffc0209480:	18cbe363          	bltu	s7,a2,ffffffffc0209606 <sfs_bmap_load_nolock+0x1a6>
ffffffffc0209484:	47ad                	li	a5,11
ffffffffc0209486:	8aae                	mv	s5,a1
ffffffffc0209488:	8432                	mv	s0,a2
ffffffffc020948a:	84aa                	mv	s1,a0
ffffffffc020948c:	89b6                	mv	s3,a3
ffffffffc020948e:	04c7f563          	bgeu	a5,a2,ffffffffc02094d8 <sfs_bmap_load_nolock+0x78>
ffffffffc0209492:	ff46071b          	addiw	a4,a2,-12
ffffffffc0209496:	0007069b          	sext.w	a3,a4
ffffffffc020949a:	3ff00793          	li	a5,1023
ffffffffc020949e:	1ad7e163          	bltu	a5,a3,ffffffffc0209640 <sfs_bmap_load_nolock+0x1e0>
ffffffffc02094a2:	03cb2a03          	lw	s4,60(s6)
ffffffffc02094a6:	02071793          	slli	a5,a4,0x20
ffffffffc02094aa:	c602                	sw	zero,12(sp)
ffffffffc02094ac:	c452                	sw	s4,8(sp)
ffffffffc02094ae:	01e7dc13          	srli	s8,a5,0x1e
ffffffffc02094b2:	0e0a1e63          	bnez	s4,ffffffffc02095ae <sfs_bmap_load_nolock+0x14e>
ffffffffc02094b6:	0acb8663          	beq	s7,a2,ffffffffc0209562 <sfs_bmap_load_nolock+0x102>
ffffffffc02094ba:	4a01                	li	s4,0
ffffffffc02094bc:	40d4                	lw	a3,4(s1)
ffffffffc02094be:	8752                	mv	a4,s4
ffffffffc02094c0:	00006617          	auipc	a2,0x6
ffffffffc02094c4:	83860613          	addi	a2,a2,-1992 # ffffffffc020ecf8 <dev_node_ops+0x150>
ffffffffc02094c8:	05300593          	li	a1,83
ffffffffc02094cc:	00005517          	auipc	a0,0x5
ffffffffc02094d0:	7cc50513          	addi	a0,a0,1996 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc02094d4:	d5bf60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02094d8:	02061793          	slli	a5,a2,0x20
ffffffffc02094dc:	01e7da13          	srli	s4,a5,0x1e
ffffffffc02094e0:	9a5a                	add	s4,s4,s6
ffffffffc02094e2:	00ca2583          	lw	a1,12(s4)
ffffffffc02094e6:	c22e                	sw	a1,4(sp)
ffffffffc02094e8:	ed99                	bnez	a1,ffffffffc0209506 <sfs_bmap_load_nolock+0xa6>
ffffffffc02094ea:	fccb98e3          	bne	s7,a2,ffffffffc02094ba <sfs_bmap_load_nolock+0x5a>
ffffffffc02094ee:	004c                	addi	a1,sp,4
ffffffffc02094f0:	ec9ff0ef          	jal	ra,ffffffffc02093b8 <sfs_block_alloc>
ffffffffc02094f4:	892a                	mv	s2,a0
ffffffffc02094f6:	e921                	bnez	a0,ffffffffc0209546 <sfs_bmap_load_nolock+0xe6>
ffffffffc02094f8:	4592                	lw	a1,4(sp)
ffffffffc02094fa:	4705                	li	a4,1
ffffffffc02094fc:	00ba2623          	sw	a1,12(s4)
ffffffffc0209500:	00eab823          	sd	a4,16(s5)
ffffffffc0209504:	d9dd                	beqz	a1,ffffffffc02094ba <sfs_bmap_load_nolock+0x5a>
ffffffffc0209506:	40d4                	lw	a3,4(s1)
ffffffffc0209508:	10d5ff63          	bgeu	a1,a3,ffffffffc0209626 <sfs_bmap_load_nolock+0x1c6>
ffffffffc020950c:	7c88                	ld	a0,56(s1)
ffffffffc020950e:	664010ef          	jal	ra,ffffffffc020ab72 <bitmap_test>
ffffffffc0209512:	18051363          	bnez	a0,ffffffffc0209698 <sfs_bmap_load_nolock+0x238>
ffffffffc0209516:	4a12                	lw	s4,4(sp)
ffffffffc0209518:	fa0a02e3          	beqz	s4,ffffffffc02094bc <sfs_bmap_load_nolock+0x5c>
ffffffffc020951c:	40dc                	lw	a5,4(s1)
ffffffffc020951e:	f8fa7fe3          	bgeu	s4,a5,ffffffffc02094bc <sfs_bmap_load_nolock+0x5c>
ffffffffc0209522:	7c88                	ld	a0,56(s1)
ffffffffc0209524:	85d2                	mv	a1,s4
ffffffffc0209526:	64c010ef          	jal	ra,ffffffffc020ab72 <bitmap_test>
ffffffffc020952a:	12051763          	bnez	a0,ffffffffc0209658 <sfs_bmap_load_nolock+0x1f8>
ffffffffc020952e:	008b9763          	bne	s7,s0,ffffffffc020953c <sfs_bmap_load_nolock+0xdc>
ffffffffc0209532:	008b2783          	lw	a5,8(s6)
ffffffffc0209536:	2785                	addiw	a5,a5,1
ffffffffc0209538:	00fb2423          	sw	a5,8(s6)
ffffffffc020953c:	4901                	li	s2,0
ffffffffc020953e:	00098463          	beqz	s3,ffffffffc0209546 <sfs_bmap_load_nolock+0xe6>
ffffffffc0209542:	0149a023          	sw	s4,0(s3)
ffffffffc0209546:	70a6                	ld	ra,104(sp)
ffffffffc0209548:	7406                	ld	s0,96(sp)
ffffffffc020954a:	64e6                	ld	s1,88(sp)
ffffffffc020954c:	69a6                	ld	s3,72(sp)
ffffffffc020954e:	6a06                	ld	s4,64(sp)
ffffffffc0209550:	7ae2                	ld	s5,56(sp)
ffffffffc0209552:	7b42                	ld	s6,48(sp)
ffffffffc0209554:	7ba2                	ld	s7,40(sp)
ffffffffc0209556:	7c02                	ld	s8,32(sp)
ffffffffc0209558:	6ce2                	ld	s9,24(sp)
ffffffffc020955a:	854a                	mv	a0,s2
ffffffffc020955c:	6946                	ld	s2,80(sp)
ffffffffc020955e:	6165                	addi	sp,sp,112
ffffffffc0209560:	8082                	ret
ffffffffc0209562:	002c                	addi	a1,sp,8
ffffffffc0209564:	e55ff0ef          	jal	ra,ffffffffc02093b8 <sfs_block_alloc>
ffffffffc0209568:	892a                	mv	s2,a0
ffffffffc020956a:	00c10c93          	addi	s9,sp,12
ffffffffc020956e:	fd61                	bnez	a0,ffffffffc0209546 <sfs_bmap_load_nolock+0xe6>
ffffffffc0209570:	85e6                	mv	a1,s9
ffffffffc0209572:	8526                	mv	a0,s1
ffffffffc0209574:	e45ff0ef          	jal	ra,ffffffffc02093b8 <sfs_block_alloc>
ffffffffc0209578:	892a                	mv	s2,a0
ffffffffc020957a:	e925                	bnez	a0,ffffffffc02095ea <sfs_bmap_load_nolock+0x18a>
ffffffffc020957c:	46a2                	lw	a3,8(sp)
ffffffffc020957e:	85e6                	mv	a1,s9
ffffffffc0209580:	8762                	mv	a4,s8
ffffffffc0209582:	4611                	li	a2,4
ffffffffc0209584:	8526                	mv	a0,s1
ffffffffc0209586:	027010ef          	jal	ra,ffffffffc020adac <sfs_wbuf>
ffffffffc020958a:	45b2                	lw	a1,12(sp)
ffffffffc020958c:	892a                	mv	s2,a0
ffffffffc020958e:	e939                	bnez	a0,ffffffffc02095e4 <sfs_bmap_load_nolock+0x184>
ffffffffc0209590:	03cb2683          	lw	a3,60(s6)
ffffffffc0209594:	4722                	lw	a4,8(sp)
ffffffffc0209596:	c22e                	sw	a1,4(sp)
ffffffffc0209598:	f6d706e3          	beq	a4,a3,ffffffffc0209504 <sfs_bmap_load_nolock+0xa4>
ffffffffc020959c:	eef1                	bnez	a3,ffffffffc0209678 <sfs_bmap_load_nolock+0x218>
ffffffffc020959e:	02eb2e23          	sw	a4,60(s6)
ffffffffc02095a2:	4705                	li	a4,1
ffffffffc02095a4:	00eab823          	sd	a4,16(s5)
ffffffffc02095a8:	f00589e3          	beqz	a1,ffffffffc02094ba <sfs_bmap_load_nolock+0x5a>
ffffffffc02095ac:	bfa9                	j	ffffffffc0209506 <sfs_bmap_load_nolock+0xa6>
ffffffffc02095ae:	00c10c93          	addi	s9,sp,12
ffffffffc02095b2:	8762                	mv	a4,s8
ffffffffc02095b4:	86d2                	mv	a3,s4
ffffffffc02095b6:	4611                	li	a2,4
ffffffffc02095b8:	85e6                	mv	a1,s9
ffffffffc02095ba:	772010ef          	jal	ra,ffffffffc020ad2c <sfs_rbuf>
ffffffffc02095be:	892a                	mv	s2,a0
ffffffffc02095c0:	f159                	bnez	a0,ffffffffc0209546 <sfs_bmap_load_nolock+0xe6>
ffffffffc02095c2:	45b2                	lw	a1,12(sp)
ffffffffc02095c4:	e995                	bnez	a1,ffffffffc02095f8 <sfs_bmap_load_nolock+0x198>
ffffffffc02095c6:	fa8b85e3          	beq	s7,s0,ffffffffc0209570 <sfs_bmap_load_nolock+0x110>
ffffffffc02095ca:	03cb2703          	lw	a4,60(s6)
ffffffffc02095ce:	47a2                	lw	a5,8(sp)
ffffffffc02095d0:	c202                	sw	zero,4(sp)
ffffffffc02095d2:	eee784e3          	beq	a5,a4,ffffffffc02094ba <sfs_bmap_load_nolock+0x5a>
ffffffffc02095d6:	e34d                	bnez	a4,ffffffffc0209678 <sfs_bmap_load_nolock+0x218>
ffffffffc02095d8:	02fb2e23          	sw	a5,60(s6)
ffffffffc02095dc:	4785                	li	a5,1
ffffffffc02095de:	00fab823          	sd	a5,16(s5)
ffffffffc02095e2:	bde1                	j	ffffffffc02094ba <sfs_bmap_load_nolock+0x5a>
ffffffffc02095e4:	8526                	mv	a0,s1
ffffffffc02095e6:	bc1ff0ef          	jal	ra,ffffffffc02091a6 <sfs_block_free>
ffffffffc02095ea:	45a2                	lw	a1,8(sp)
ffffffffc02095ec:	f4ba0de3          	beq	s4,a1,ffffffffc0209546 <sfs_bmap_load_nolock+0xe6>
ffffffffc02095f0:	8526                	mv	a0,s1
ffffffffc02095f2:	bb5ff0ef          	jal	ra,ffffffffc02091a6 <sfs_block_free>
ffffffffc02095f6:	bf81                	j	ffffffffc0209546 <sfs_bmap_load_nolock+0xe6>
ffffffffc02095f8:	03cb2683          	lw	a3,60(s6)
ffffffffc02095fc:	4722                	lw	a4,8(sp)
ffffffffc02095fe:	c22e                	sw	a1,4(sp)
ffffffffc0209600:	f8e69ee3          	bne	a3,a4,ffffffffc020959c <sfs_bmap_load_nolock+0x13c>
ffffffffc0209604:	b709                	j	ffffffffc0209506 <sfs_bmap_load_nolock+0xa6>
ffffffffc0209606:	00005697          	auipc	a3,0x5
ffffffffc020960a:	7aa68693          	addi	a3,a3,1962 # ffffffffc020edb0 <dev_node_ops+0x208>
ffffffffc020960e:	00002617          	auipc	a2,0x2
ffffffffc0209612:	1fa60613          	addi	a2,a2,506 # ffffffffc020b808 <commands+0x60>
ffffffffc0209616:	16400593          	li	a1,356
ffffffffc020961a:	00005517          	auipc	a0,0x5
ffffffffc020961e:	67e50513          	addi	a0,a0,1662 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc0209622:	c0df60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0209626:	872e                	mv	a4,a1
ffffffffc0209628:	00005617          	auipc	a2,0x5
ffffffffc020962c:	6d060613          	addi	a2,a2,1744 # ffffffffc020ecf8 <dev_node_ops+0x150>
ffffffffc0209630:	05300593          	li	a1,83
ffffffffc0209634:	00005517          	auipc	a0,0x5
ffffffffc0209638:	66450513          	addi	a0,a0,1636 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc020963c:	bf3f60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0209640:	00005617          	auipc	a2,0x5
ffffffffc0209644:	7a060613          	addi	a2,a2,1952 # ffffffffc020ede0 <dev_node_ops+0x238>
ffffffffc0209648:	11e00593          	li	a1,286
ffffffffc020964c:	00005517          	auipc	a0,0x5
ffffffffc0209650:	64c50513          	addi	a0,a0,1612 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc0209654:	bdbf60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0209658:	00005697          	auipc	a3,0x5
ffffffffc020965c:	6d868693          	addi	a3,a3,1752 # ffffffffc020ed30 <dev_node_ops+0x188>
ffffffffc0209660:	00002617          	auipc	a2,0x2
ffffffffc0209664:	1a860613          	addi	a2,a2,424 # ffffffffc020b808 <commands+0x60>
ffffffffc0209668:	16b00593          	li	a1,363
ffffffffc020966c:	00005517          	auipc	a0,0x5
ffffffffc0209670:	62c50513          	addi	a0,a0,1580 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc0209674:	bbbf60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0209678:	00005697          	auipc	a3,0x5
ffffffffc020967c:	75068693          	addi	a3,a3,1872 # ffffffffc020edc8 <dev_node_ops+0x220>
ffffffffc0209680:	00002617          	auipc	a2,0x2
ffffffffc0209684:	18860613          	addi	a2,a2,392 # ffffffffc020b808 <commands+0x60>
ffffffffc0209688:	11800593          	li	a1,280
ffffffffc020968c:	00005517          	auipc	a0,0x5
ffffffffc0209690:	60c50513          	addi	a0,a0,1548 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc0209694:	b9bf60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0209698:	00005697          	auipc	a3,0x5
ffffffffc020969c:	77868693          	addi	a3,a3,1912 # ffffffffc020ee10 <dev_node_ops+0x268>
ffffffffc02096a0:	00002617          	auipc	a2,0x2
ffffffffc02096a4:	16860613          	addi	a2,a2,360 # ffffffffc020b808 <commands+0x60>
ffffffffc02096a8:	12100593          	li	a1,289
ffffffffc02096ac:	00005517          	auipc	a0,0x5
ffffffffc02096b0:	5ec50513          	addi	a0,a0,1516 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc02096b4:	b7bf60ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02096b8 <sfs_io_nolock>:
ffffffffc02096b8:	7175                	addi	sp,sp,-144
ffffffffc02096ba:	ecd6                	sd	s5,88(sp)
ffffffffc02096bc:	8aae                	mv	s5,a1
ffffffffc02096be:	618c                	ld	a1,0(a1)
ffffffffc02096c0:	e506                	sd	ra,136(sp)
ffffffffc02096c2:	e122                	sd	s0,128(sp)
ffffffffc02096c4:	0045d883          	lhu	a7,4(a1)
ffffffffc02096c8:	fca6                	sd	s1,120(sp)
ffffffffc02096ca:	f8ca                	sd	s2,112(sp)
ffffffffc02096cc:	f4ce                	sd	s3,104(sp)
ffffffffc02096ce:	f0d2                	sd	s4,96(sp)
ffffffffc02096d0:	e8da                	sd	s6,80(sp)
ffffffffc02096d2:	e4de                	sd	s7,72(sp)
ffffffffc02096d4:	e0e2                	sd	s8,64(sp)
ffffffffc02096d6:	fc66                	sd	s9,56(sp)
ffffffffc02096d8:	f86a                	sd	s10,48(sp)
ffffffffc02096da:	f46e                	sd	s11,40(sp)
ffffffffc02096dc:	4809                	li	a6,2
ffffffffc02096de:	1b088163          	beq	a7,a6,ffffffffc0209880 <sfs_io_nolock+0x1c8>
ffffffffc02096e2:	00073b03          	ld	s6,0(a4)
ffffffffc02096e6:	8bba                	mv	s7,a4
ffffffffc02096e8:	000bb023          	sd	zero,0(s7) # 1000 <_binary_bin_swap_img_size-0x6d00>
ffffffffc02096ec:	08000737          	lui	a4,0x8000
ffffffffc02096f0:	89b6                	mv	s3,a3
ffffffffc02096f2:	84b6                	mv	s1,a3
ffffffffc02096f4:	9b36                	add	s6,s6,a3
ffffffffc02096f6:	18e6f363          	bgeu	a3,a4,ffffffffc020987c <sfs_io_nolock+0x1c4>
ffffffffc02096fa:	18db4163          	blt	s6,a3,ffffffffc020987c <sfs_io_nolock+0x1c4>
ffffffffc02096fe:	892a                	mv	s2,a0
ffffffffc0209700:	4501                	li	a0,0
ffffffffc0209702:	0f668063          	beq	a3,s6,ffffffffc02097e2 <sfs_io_nolock+0x12a>
ffffffffc0209706:	8db2                	mv	s11,a2
ffffffffc0209708:	01677463          	bgeu	a4,s6,ffffffffc0209710 <sfs_io_nolock+0x58>
ffffffffc020970c:	08000b37          	lui	s6,0x8000
ffffffffc0209710:	cbe5                	beqz	a5,ffffffffc0209800 <sfs_io_nolock+0x148>
ffffffffc0209712:	00001797          	auipc	a5,0x1
ffffffffc0209716:	69a78793          	addi	a5,a5,1690 # ffffffffc020adac <sfs_wbuf>
ffffffffc020971a:	00001c97          	auipc	s9,0x1
ffffffffc020971e:	5b2c8c93          	addi	s9,s9,1458 # ffffffffc020accc <sfs_wblock>
ffffffffc0209722:	e43e                	sd	a5,8(sp)
ffffffffc0209724:	6785                	lui	a5,0x1
ffffffffc0209726:	fff78413          	addi	s0,a5,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc020972a:	0089f433          	and	s0,s3,s0
ffffffffc020972e:	8a22                	mv	s4,s0
ffffffffc0209730:	cc15                	beqz	s0,ffffffffc020976c <sfs_io_nolock+0xb4>
ffffffffc0209732:	40c9d613          	srai	a2,s3,0xc
ffffffffc0209736:	40cb5693          	srai	a3,s6,0xc
ffffffffc020973a:	413b0433          	sub	s0,s6,s3
ffffffffc020973e:	00d60463          	beq	a2,a3,ffffffffc0209746 <sfs_io_nolock+0x8e>
ffffffffc0209742:	41478433          	sub	s0,a5,s4
ffffffffc0209746:	0874                	addi	a3,sp,28
ffffffffc0209748:	2601                	sext.w	a2,a2
ffffffffc020974a:	85d6                	mv	a1,s5
ffffffffc020974c:	854a                	mv	a0,s2
ffffffffc020974e:	d13ff0ef          	jal	ra,ffffffffc0209460 <sfs_bmap_load_nolock>
ffffffffc0209752:	e17d                	bnez	a0,ffffffffc0209838 <sfs_io_nolock+0x180>
ffffffffc0209754:	46f2                	lw	a3,28(sp)
ffffffffc0209756:	67a2                	ld	a5,8(sp)
ffffffffc0209758:	8752                	mv	a4,s4
ffffffffc020975a:	8622                	mv	a2,s0
ffffffffc020975c:	85ee                	mv	a1,s11
ffffffffc020975e:	854a                	mv	a0,s2
ffffffffc0209760:	9782                	jalr	a5
ffffffffc0209762:	e979                	bnez	a0,ffffffffc0209838 <sfs_io_nolock+0x180>
ffffffffc0209764:	9da2                	add	s11,s11,s0
ffffffffc0209766:	00898d33          	add	s10,s3,s0
ffffffffc020976a:	a011                	j	ffffffffc020976e <sfs_io_nolock+0xb6>
ffffffffc020976c:	8d4e                	mv	s10,s3
ffffffffc020976e:	6705                	lui	a4,0x1
ffffffffc0209770:	fff70c13          	addi	s8,a4,-1 # fff <_binary_bin_swap_img_size-0x6d01>
ffffffffc0209774:	018d06b3          	add	a3,s10,s8
ffffffffc0209778:	0d66d263          	bge	a3,s6,ffffffffc020983c <sfs_io_nolock+0x184>
ffffffffc020977c:	40eb0a33          	sub	s4,s6,a4
ffffffffc0209780:	41aa0a33          	sub	s4,s4,s10
ffffffffc0209784:	00ca5a13          	srli	s4,s4,0xc
ffffffffc0209788:	0a05                	addi	s4,s4,1
ffffffffc020978a:	0a32                	slli	s4,s4,0xc
ffffffffc020978c:	9a6e                	add	s4,s4,s11
ffffffffc020978e:	6485                	lui	s1,0x1
ffffffffc0209790:	a821                	j	ffffffffc02097a8 <sfs_io_nolock+0xf0>
ffffffffc0209792:	4672                	lw	a2,28(sp)
ffffffffc0209794:	4685                	li	a3,1
ffffffffc0209796:	85ee                	mv	a1,s11
ffffffffc0209798:	854a                	mv	a0,s2
ffffffffc020979a:	9c82                	jalr	s9
ffffffffc020979c:	e11d                	bnez	a0,ffffffffc02097c2 <sfs_io_nolock+0x10a>
ffffffffc020979e:	9da6                	add	s11,s11,s1
ffffffffc02097a0:	9d26                	add	s10,s10,s1
ffffffffc02097a2:	9426                	add	s0,s0,s1
ffffffffc02097a4:	09ba0d63          	beq	s4,s11,ffffffffc020983e <sfs_io_nolock+0x186>
ffffffffc02097a8:	43fd5613          	srai	a2,s10,0x3f
ffffffffc02097ac:	01867633          	and	a2,a2,s8
ffffffffc02097b0:	966a                	add	a2,a2,s10
ffffffffc02097b2:	8631                	srai	a2,a2,0xc
ffffffffc02097b4:	0874                	addi	a3,sp,28
ffffffffc02097b6:	2601                	sext.w	a2,a2
ffffffffc02097b8:	85d6                	mv	a1,s5
ffffffffc02097ba:	854a                	mv	a0,s2
ffffffffc02097bc:	ca5ff0ef          	jal	ra,ffffffffc0209460 <sfs_bmap_load_nolock>
ffffffffc02097c0:	d969                	beqz	a0,ffffffffc0209792 <sfs_io_nolock+0xda>
ffffffffc02097c2:	008984b3          	add	s1,s3,s0
ffffffffc02097c6:	000ab783          	ld	a5,0(s5)
ffffffffc02097ca:	008bb023          	sd	s0,0(s7)
ffffffffc02097ce:	0007e703          	lwu	a4,0(a5)
ffffffffc02097d2:	00977863          	bgeu	a4,s1,ffffffffc02097e2 <sfs_io_nolock+0x12a>
ffffffffc02097d6:	0089843b          	addw	s0,s3,s0
ffffffffc02097da:	c380                	sw	s0,0(a5)
ffffffffc02097dc:	4785                	li	a5,1
ffffffffc02097de:	00fab823          	sd	a5,16(s5)
ffffffffc02097e2:	60aa                	ld	ra,136(sp)
ffffffffc02097e4:	640a                	ld	s0,128(sp)
ffffffffc02097e6:	74e6                	ld	s1,120(sp)
ffffffffc02097e8:	7946                	ld	s2,112(sp)
ffffffffc02097ea:	79a6                	ld	s3,104(sp)
ffffffffc02097ec:	7a06                	ld	s4,96(sp)
ffffffffc02097ee:	6ae6                	ld	s5,88(sp)
ffffffffc02097f0:	6b46                	ld	s6,80(sp)
ffffffffc02097f2:	6ba6                	ld	s7,72(sp)
ffffffffc02097f4:	6c06                	ld	s8,64(sp)
ffffffffc02097f6:	7ce2                	ld	s9,56(sp)
ffffffffc02097f8:	7d42                	ld	s10,48(sp)
ffffffffc02097fa:	7da2                	ld	s11,40(sp)
ffffffffc02097fc:	6149                	addi	sp,sp,144
ffffffffc02097fe:	8082                	ret
ffffffffc0209800:	0005e783          	lwu	a5,0(a1)
ffffffffc0209804:	4501                	li	a0,0
ffffffffc0209806:	fcf9dee3          	bge	s3,a5,ffffffffc02097e2 <sfs_io_nolock+0x12a>
ffffffffc020980a:	0167cc63          	blt	a5,s6,ffffffffc0209822 <sfs_io_nolock+0x16a>
ffffffffc020980e:	00001797          	auipc	a5,0x1
ffffffffc0209812:	51e78793          	addi	a5,a5,1310 # ffffffffc020ad2c <sfs_rbuf>
ffffffffc0209816:	00001c97          	auipc	s9,0x1
ffffffffc020981a:	456c8c93          	addi	s9,s9,1110 # ffffffffc020ac6c <sfs_rblock>
ffffffffc020981e:	e43e                	sd	a5,8(sp)
ffffffffc0209820:	b711                	j	ffffffffc0209724 <sfs_io_nolock+0x6c>
ffffffffc0209822:	8b3e                	mv	s6,a5
ffffffffc0209824:	00001797          	auipc	a5,0x1
ffffffffc0209828:	50878793          	addi	a5,a5,1288 # ffffffffc020ad2c <sfs_rbuf>
ffffffffc020982c:	00001c97          	auipc	s9,0x1
ffffffffc0209830:	440c8c93          	addi	s9,s9,1088 # ffffffffc020ac6c <sfs_rblock>
ffffffffc0209834:	e43e                	sd	a5,8(sp)
ffffffffc0209836:	b5fd                	j	ffffffffc0209724 <sfs_io_nolock+0x6c>
ffffffffc0209838:	4401                	li	s0,0
ffffffffc020983a:	b771                	j	ffffffffc02097c6 <sfs_io_nolock+0x10e>
ffffffffc020983c:	8a6e                	mv	s4,s11
ffffffffc020983e:	016d4663          	blt	s10,s6,ffffffffc020984a <sfs_io_nolock+0x192>
ffffffffc0209842:	008984b3          	add	s1,s3,s0
ffffffffc0209846:	4501                	li	a0,0
ffffffffc0209848:	bfbd                	j	ffffffffc02097c6 <sfs_io_nolock+0x10e>
ffffffffc020984a:	43fd5613          	srai	a2,s10,0x3f
ffffffffc020984e:	1652                	slli	a2,a2,0x34
ffffffffc0209850:	9251                	srli	a2,a2,0x34
ffffffffc0209852:	966a                	add	a2,a2,s10
ffffffffc0209854:	8631                	srai	a2,a2,0xc
ffffffffc0209856:	0874                	addi	a3,sp,28
ffffffffc0209858:	2601                	sext.w	a2,a2
ffffffffc020985a:	85d6                	mv	a1,s5
ffffffffc020985c:	854a                	mv	a0,s2
ffffffffc020985e:	c03ff0ef          	jal	ra,ffffffffc0209460 <sfs_bmap_load_nolock>
ffffffffc0209862:	f125                	bnez	a0,ffffffffc02097c2 <sfs_io_nolock+0x10a>
ffffffffc0209864:	46f2                	lw	a3,28(sp)
ffffffffc0209866:	67a2                	ld	a5,8(sp)
ffffffffc0209868:	41ab0b33          	sub	s6,s6,s10
ffffffffc020986c:	4701                	li	a4,0
ffffffffc020986e:	865a                	mv	a2,s6
ffffffffc0209870:	85d2                	mv	a1,s4
ffffffffc0209872:	854a                	mv	a0,s2
ffffffffc0209874:	9782                	jalr	a5
ffffffffc0209876:	f531                	bnez	a0,ffffffffc02097c2 <sfs_io_nolock+0x10a>
ffffffffc0209878:	945a                	add	s0,s0,s6
ffffffffc020987a:	b7a1                	j	ffffffffc02097c2 <sfs_io_nolock+0x10a>
ffffffffc020987c:	5575                	li	a0,-3
ffffffffc020987e:	b795                	j	ffffffffc02097e2 <sfs_io_nolock+0x12a>
ffffffffc0209880:	00005697          	auipc	a3,0x5
ffffffffc0209884:	5b868693          	addi	a3,a3,1464 # ffffffffc020ee38 <dev_node_ops+0x290>
ffffffffc0209888:	00002617          	auipc	a2,0x2
ffffffffc020988c:	f8060613          	addi	a2,a2,-128 # ffffffffc020b808 <commands+0x60>
ffffffffc0209890:	22b00593          	li	a1,555
ffffffffc0209894:	00005517          	auipc	a0,0x5
ffffffffc0209898:	40450513          	addi	a0,a0,1028 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc020989c:	993f60ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc02098a0 <sfs_read>:
ffffffffc02098a0:	7139                	addi	sp,sp,-64
ffffffffc02098a2:	f04a                	sd	s2,32(sp)
ffffffffc02098a4:	06853903          	ld	s2,104(a0)
ffffffffc02098a8:	fc06                	sd	ra,56(sp)
ffffffffc02098aa:	f822                	sd	s0,48(sp)
ffffffffc02098ac:	f426                	sd	s1,40(sp)
ffffffffc02098ae:	ec4e                	sd	s3,24(sp)
ffffffffc02098b0:	04090f63          	beqz	s2,ffffffffc020990e <sfs_read+0x6e>
ffffffffc02098b4:	0b092783          	lw	a5,176(s2) # 40b0 <_binary_bin_swap_img_size-0x3c50>
ffffffffc02098b8:	ebb9                	bnez	a5,ffffffffc020990e <sfs_read+0x6e>
ffffffffc02098ba:	4d38                	lw	a4,88(a0)
ffffffffc02098bc:	6785                	lui	a5,0x1
ffffffffc02098be:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc02098c2:	842a                	mv	s0,a0
ffffffffc02098c4:	06f71563          	bne	a4,a5,ffffffffc020992e <sfs_read+0x8e>
ffffffffc02098c8:	02050993          	addi	s3,a0,32
ffffffffc02098cc:	854e                	mv	a0,s3
ffffffffc02098ce:	84ae                	mv	s1,a1
ffffffffc02098d0:	e7ffa0ef          	jal	ra,ffffffffc020474e <down>
ffffffffc02098d4:	0184b803          	ld	a6,24(s1) # 1018 <_binary_bin_swap_img_size-0x6ce8>
ffffffffc02098d8:	6494                	ld	a3,8(s1)
ffffffffc02098da:	6090                	ld	a2,0(s1)
ffffffffc02098dc:	85a2                	mv	a1,s0
ffffffffc02098de:	4781                	li	a5,0
ffffffffc02098e0:	0038                	addi	a4,sp,8
ffffffffc02098e2:	854a                	mv	a0,s2
ffffffffc02098e4:	e442                	sd	a6,8(sp)
ffffffffc02098e6:	dd3ff0ef          	jal	ra,ffffffffc02096b8 <sfs_io_nolock>
ffffffffc02098ea:	65a2                	ld	a1,8(sp)
ffffffffc02098ec:	842a                	mv	s0,a0
ffffffffc02098ee:	ed81                	bnez	a1,ffffffffc0209906 <sfs_read+0x66>
ffffffffc02098f0:	854e                	mv	a0,s3
ffffffffc02098f2:	e59fa0ef          	jal	ra,ffffffffc020474a <up>
ffffffffc02098f6:	70e2                	ld	ra,56(sp)
ffffffffc02098f8:	8522                	mv	a0,s0
ffffffffc02098fa:	7442                	ld	s0,48(sp)
ffffffffc02098fc:	74a2                	ld	s1,40(sp)
ffffffffc02098fe:	7902                	ld	s2,32(sp)
ffffffffc0209900:	69e2                	ld	s3,24(sp)
ffffffffc0209902:	6121                	addi	sp,sp,64
ffffffffc0209904:	8082                	ret
ffffffffc0209906:	8526                	mv	a0,s1
ffffffffc0209908:	e9ffb0ef          	jal	ra,ffffffffc02057a6 <iobuf_skip>
ffffffffc020990c:	b7d5                	j	ffffffffc02098f0 <sfs_read+0x50>
ffffffffc020990e:	00005697          	auipc	a3,0x5
ffffffffc0209912:	3ba68693          	addi	a3,a3,954 # ffffffffc020ecc8 <dev_node_ops+0x120>
ffffffffc0209916:	00002617          	auipc	a2,0x2
ffffffffc020991a:	ef260613          	addi	a2,a2,-270 # ffffffffc020b808 <commands+0x60>
ffffffffc020991e:	29c00593          	li	a1,668
ffffffffc0209922:	00005517          	auipc	a0,0x5
ffffffffc0209926:	37650513          	addi	a0,a0,886 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc020992a:	905f60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020992e:	855ff0ef          	jal	ra,ffffffffc0209182 <sfs_io.part.0>

ffffffffc0209932 <sfs_write>:
ffffffffc0209932:	7139                	addi	sp,sp,-64
ffffffffc0209934:	f04a                	sd	s2,32(sp)
ffffffffc0209936:	06853903          	ld	s2,104(a0)
ffffffffc020993a:	fc06                	sd	ra,56(sp)
ffffffffc020993c:	f822                	sd	s0,48(sp)
ffffffffc020993e:	f426                	sd	s1,40(sp)
ffffffffc0209940:	ec4e                	sd	s3,24(sp)
ffffffffc0209942:	04090f63          	beqz	s2,ffffffffc02099a0 <sfs_write+0x6e>
ffffffffc0209946:	0b092783          	lw	a5,176(s2)
ffffffffc020994a:	ebb9                	bnez	a5,ffffffffc02099a0 <sfs_write+0x6e>
ffffffffc020994c:	4d38                	lw	a4,88(a0)
ffffffffc020994e:	6785                	lui	a5,0x1
ffffffffc0209950:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc0209954:	842a                	mv	s0,a0
ffffffffc0209956:	06f71563          	bne	a4,a5,ffffffffc02099c0 <sfs_write+0x8e>
ffffffffc020995a:	02050993          	addi	s3,a0,32
ffffffffc020995e:	854e                	mv	a0,s3
ffffffffc0209960:	84ae                	mv	s1,a1
ffffffffc0209962:	dedfa0ef          	jal	ra,ffffffffc020474e <down>
ffffffffc0209966:	0184b803          	ld	a6,24(s1)
ffffffffc020996a:	6494                	ld	a3,8(s1)
ffffffffc020996c:	6090                	ld	a2,0(s1)
ffffffffc020996e:	85a2                	mv	a1,s0
ffffffffc0209970:	4785                	li	a5,1
ffffffffc0209972:	0038                	addi	a4,sp,8
ffffffffc0209974:	854a                	mv	a0,s2
ffffffffc0209976:	e442                	sd	a6,8(sp)
ffffffffc0209978:	d41ff0ef          	jal	ra,ffffffffc02096b8 <sfs_io_nolock>
ffffffffc020997c:	65a2                	ld	a1,8(sp)
ffffffffc020997e:	842a                	mv	s0,a0
ffffffffc0209980:	ed81                	bnez	a1,ffffffffc0209998 <sfs_write+0x66>
ffffffffc0209982:	854e                	mv	a0,s3
ffffffffc0209984:	dc7fa0ef          	jal	ra,ffffffffc020474a <up>
ffffffffc0209988:	70e2                	ld	ra,56(sp)
ffffffffc020998a:	8522                	mv	a0,s0
ffffffffc020998c:	7442                	ld	s0,48(sp)
ffffffffc020998e:	74a2                	ld	s1,40(sp)
ffffffffc0209990:	7902                	ld	s2,32(sp)
ffffffffc0209992:	69e2                	ld	s3,24(sp)
ffffffffc0209994:	6121                	addi	sp,sp,64
ffffffffc0209996:	8082                	ret
ffffffffc0209998:	8526                	mv	a0,s1
ffffffffc020999a:	e0dfb0ef          	jal	ra,ffffffffc02057a6 <iobuf_skip>
ffffffffc020999e:	b7d5                	j	ffffffffc0209982 <sfs_write+0x50>
ffffffffc02099a0:	00005697          	auipc	a3,0x5
ffffffffc02099a4:	32868693          	addi	a3,a3,808 # ffffffffc020ecc8 <dev_node_ops+0x120>
ffffffffc02099a8:	00002617          	auipc	a2,0x2
ffffffffc02099ac:	e6060613          	addi	a2,a2,-416 # ffffffffc020b808 <commands+0x60>
ffffffffc02099b0:	29c00593          	li	a1,668
ffffffffc02099b4:	00005517          	auipc	a0,0x5
ffffffffc02099b8:	2e450513          	addi	a0,a0,740 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc02099bc:	873f60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc02099c0:	fc2ff0ef          	jal	ra,ffffffffc0209182 <sfs_io.part.0>

ffffffffc02099c4 <sfs_dirent_read_nolock>:
ffffffffc02099c4:	6198                	ld	a4,0(a1)
ffffffffc02099c6:	7179                	addi	sp,sp,-48
ffffffffc02099c8:	f406                	sd	ra,40(sp)
ffffffffc02099ca:	00475883          	lhu	a7,4(a4)
ffffffffc02099ce:	f022                	sd	s0,32(sp)
ffffffffc02099d0:	ec26                	sd	s1,24(sp)
ffffffffc02099d2:	4809                	li	a6,2
ffffffffc02099d4:	05089b63          	bne	a7,a6,ffffffffc0209a2a <sfs_dirent_read_nolock+0x66>
ffffffffc02099d8:	4718                	lw	a4,8(a4)
ffffffffc02099da:	87b2                	mv	a5,a2
ffffffffc02099dc:	2601                	sext.w	a2,a2
ffffffffc02099de:	04e7f663          	bgeu	a5,a4,ffffffffc0209a2a <sfs_dirent_read_nolock+0x66>
ffffffffc02099e2:	84b6                	mv	s1,a3
ffffffffc02099e4:	0074                	addi	a3,sp,12
ffffffffc02099e6:	842a                	mv	s0,a0
ffffffffc02099e8:	a79ff0ef          	jal	ra,ffffffffc0209460 <sfs_bmap_load_nolock>
ffffffffc02099ec:	c511                	beqz	a0,ffffffffc02099f8 <sfs_dirent_read_nolock+0x34>
ffffffffc02099ee:	70a2                	ld	ra,40(sp)
ffffffffc02099f0:	7402                	ld	s0,32(sp)
ffffffffc02099f2:	64e2                	ld	s1,24(sp)
ffffffffc02099f4:	6145                	addi	sp,sp,48
ffffffffc02099f6:	8082                	ret
ffffffffc02099f8:	45b2                	lw	a1,12(sp)
ffffffffc02099fa:	4054                	lw	a3,4(s0)
ffffffffc02099fc:	c5b9                	beqz	a1,ffffffffc0209a4a <sfs_dirent_read_nolock+0x86>
ffffffffc02099fe:	04d5f663          	bgeu	a1,a3,ffffffffc0209a4a <sfs_dirent_read_nolock+0x86>
ffffffffc0209a02:	7c08                	ld	a0,56(s0)
ffffffffc0209a04:	16e010ef          	jal	ra,ffffffffc020ab72 <bitmap_test>
ffffffffc0209a08:	ed31                	bnez	a0,ffffffffc0209a64 <sfs_dirent_read_nolock+0xa0>
ffffffffc0209a0a:	46b2                	lw	a3,12(sp)
ffffffffc0209a0c:	4701                	li	a4,0
ffffffffc0209a0e:	10400613          	li	a2,260
ffffffffc0209a12:	85a6                	mv	a1,s1
ffffffffc0209a14:	8522                	mv	a0,s0
ffffffffc0209a16:	316010ef          	jal	ra,ffffffffc020ad2c <sfs_rbuf>
ffffffffc0209a1a:	f971                	bnez	a0,ffffffffc02099ee <sfs_dirent_read_nolock+0x2a>
ffffffffc0209a1c:	100481a3          	sb	zero,259(s1)
ffffffffc0209a20:	70a2                	ld	ra,40(sp)
ffffffffc0209a22:	7402                	ld	s0,32(sp)
ffffffffc0209a24:	64e2                	ld	s1,24(sp)
ffffffffc0209a26:	6145                	addi	sp,sp,48
ffffffffc0209a28:	8082                	ret
ffffffffc0209a2a:	00005697          	auipc	a3,0x5
ffffffffc0209a2e:	42e68693          	addi	a3,a3,1070 # ffffffffc020ee58 <dev_node_ops+0x2b0>
ffffffffc0209a32:	00002617          	auipc	a2,0x2
ffffffffc0209a36:	dd660613          	addi	a2,a2,-554 # ffffffffc020b808 <commands+0x60>
ffffffffc0209a3a:	18e00593          	li	a1,398
ffffffffc0209a3e:	00005517          	auipc	a0,0x5
ffffffffc0209a42:	25a50513          	addi	a0,a0,602 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc0209a46:	fe8f60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0209a4a:	872e                	mv	a4,a1
ffffffffc0209a4c:	00005617          	auipc	a2,0x5
ffffffffc0209a50:	2ac60613          	addi	a2,a2,684 # ffffffffc020ecf8 <dev_node_ops+0x150>
ffffffffc0209a54:	05300593          	li	a1,83
ffffffffc0209a58:	00005517          	auipc	a0,0x5
ffffffffc0209a5c:	24050513          	addi	a0,a0,576 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc0209a60:	fcef60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0209a64:	00005697          	auipc	a3,0x5
ffffffffc0209a68:	2cc68693          	addi	a3,a3,716 # ffffffffc020ed30 <dev_node_ops+0x188>
ffffffffc0209a6c:	00002617          	auipc	a2,0x2
ffffffffc0209a70:	d9c60613          	addi	a2,a2,-612 # ffffffffc020b808 <commands+0x60>
ffffffffc0209a74:	19500593          	li	a1,405
ffffffffc0209a78:	00005517          	auipc	a0,0x5
ffffffffc0209a7c:	22050513          	addi	a0,a0,544 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc0209a80:	faef60ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0209a84 <sfs_getdirentry>:
ffffffffc0209a84:	715d                	addi	sp,sp,-80
ffffffffc0209a86:	ec56                	sd	s5,24(sp)
ffffffffc0209a88:	8aaa                	mv	s5,a0
ffffffffc0209a8a:	10400513          	li	a0,260
ffffffffc0209a8e:	e85a                	sd	s6,16(sp)
ffffffffc0209a90:	e486                	sd	ra,72(sp)
ffffffffc0209a92:	e0a2                	sd	s0,64(sp)
ffffffffc0209a94:	fc26                	sd	s1,56(sp)
ffffffffc0209a96:	f84a                	sd	s2,48(sp)
ffffffffc0209a98:	f44e                	sd	s3,40(sp)
ffffffffc0209a9a:	f052                	sd	s4,32(sp)
ffffffffc0209a9c:	e45e                	sd	s7,8(sp)
ffffffffc0209a9e:	e062                	sd	s8,0(sp)
ffffffffc0209aa0:	8b2e                	mv	s6,a1
ffffffffc0209aa2:	d25f90ef          	jal	ra,ffffffffc02037c6 <kmalloc>
ffffffffc0209aa6:	cd61                	beqz	a0,ffffffffc0209b7e <sfs_getdirentry+0xfa>
ffffffffc0209aa8:	068abb83          	ld	s7,104(s5)
ffffffffc0209aac:	0c0b8b63          	beqz	s7,ffffffffc0209b82 <sfs_getdirentry+0xfe>
ffffffffc0209ab0:	0b0ba783          	lw	a5,176(s7)
ffffffffc0209ab4:	e7f9                	bnez	a5,ffffffffc0209b82 <sfs_getdirentry+0xfe>
ffffffffc0209ab6:	058aa703          	lw	a4,88(s5)
ffffffffc0209aba:	6785                	lui	a5,0x1
ffffffffc0209abc:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc0209ac0:	0ef71163          	bne	a4,a5,ffffffffc0209ba2 <sfs_getdirentry+0x11e>
ffffffffc0209ac4:	008b3983          	ld	s3,8(s6) # 8000008 <_binary_bin_sfs_img_size+0x7f8ad08>
ffffffffc0209ac8:	892a                	mv	s2,a0
ffffffffc0209aca:	0a09c163          	bltz	s3,ffffffffc0209b6c <sfs_getdirentry+0xe8>
ffffffffc0209ace:	0ff9f793          	zext.b	a5,s3
ffffffffc0209ad2:	efc9                	bnez	a5,ffffffffc0209b6c <sfs_getdirentry+0xe8>
ffffffffc0209ad4:	000ab783          	ld	a5,0(s5)
ffffffffc0209ad8:	0089d993          	srli	s3,s3,0x8
ffffffffc0209adc:	2981                	sext.w	s3,s3
ffffffffc0209ade:	479c                	lw	a5,8(a5)
ffffffffc0209ae0:	0937eb63          	bltu	a5,s3,ffffffffc0209b76 <sfs_getdirentry+0xf2>
ffffffffc0209ae4:	020a8c13          	addi	s8,s5,32
ffffffffc0209ae8:	8562                	mv	a0,s8
ffffffffc0209aea:	c65fa0ef          	jal	ra,ffffffffc020474e <down>
ffffffffc0209aee:	000ab783          	ld	a5,0(s5)
ffffffffc0209af2:	0087aa03          	lw	s4,8(a5)
ffffffffc0209af6:	07405663          	blez	s4,ffffffffc0209b62 <sfs_getdirentry+0xde>
ffffffffc0209afa:	4481                	li	s1,0
ffffffffc0209afc:	a811                	j	ffffffffc0209b10 <sfs_getdirentry+0x8c>
ffffffffc0209afe:	00092783          	lw	a5,0(s2)
ffffffffc0209b02:	c781                	beqz	a5,ffffffffc0209b0a <sfs_getdirentry+0x86>
ffffffffc0209b04:	02098263          	beqz	s3,ffffffffc0209b28 <sfs_getdirentry+0xa4>
ffffffffc0209b08:	39fd                	addiw	s3,s3,-1
ffffffffc0209b0a:	2485                	addiw	s1,s1,1
ffffffffc0209b0c:	049a0b63          	beq	s4,s1,ffffffffc0209b62 <sfs_getdirentry+0xde>
ffffffffc0209b10:	86ca                	mv	a3,s2
ffffffffc0209b12:	8626                	mv	a2,s1
ffffffffc0209b14:	85d6                	mv	a1,s5
ffffffffc0209b16:	855e                	mv	a0,s7
ffffffffc0209b18:	eadff0ef          	jal	ra,ffffffffc02099c4 <sfs_dirent_read_nolock>
ffffffffc0209b1c:	842a                	mv	s0,a0
ffffffffc0209b1e:	d165                	beqz	a0,ffffffffc0209afe <sfs_getdirentry+0x7a>
ffffffffc0209b20:	8562                	mv	a0,s8
ffffffffc0209b22:	c29fa0ef          	jal	ra,ffffffffc020474a <up>
ffffffffc0209b26:	a831                	j	ffffffffc0209b42 <sfs_getdirentry+0xbe>
ffffffffc0209b28:	8562                	mv	a0,s8
ffffffffc0209b2a:	c21fa0ef          	jal	ra,ffffffffc020474a <up>
ffffffffc0209b2e:	4701                	li	a4,0
ffffffffc0209b30:	4685                	li	a3,1
ffffffffc0209b32:	10000613          	li	a2,256
ffffffffc0209b36:	00490593          	addi	a1,s2,4
ffffffffc0209b3a:	855a                	mv	a0,s6
ffffffffc0209b3c:	bfffb0ef          	jal	ra,ffffffffc020573a <iobuf_move>
ffffffffc0209b40:	842a                	mv	s0,a0
ffffffffc0209b42:	854a                	mv	a0,s2
ffffffffc0209b44:	d33f90ef          	jal	ra,ffffffffc0203876 <kfree>
ffffffffc0209b48:	60a6                	ld	ra,72(sp)
ffffffffc0209b4a:	8522                	mv	a0,s0
ffffffffc0209b4c:	6406                	ld	s0,64(sp)
ffffffffc0209b4e:	74e2                	ld	s1,56(sp)
ffffffffc0209b50:	7942                	ld	s2,48(sp)
ffffffffc0209b52:	79a2                	ld	s3,40(sp)
ffffffffc0209b54:	7a02                	ld	s4,32(sp)
ffffffffc0209b56:	6ae2                	ld	s5,24(sp)
ffffffffc0209b58:	6b42                	ld	s6,16(sp)
ffffffffc0209b5a:	6ba2                	ld	s7,8(sp)
ffffffffc0209b5c:	6c02                	ld	s8,0(sp)
ffffffffc0209b5e:	6161                	addi	sp,sp,80
ffffffffc0209b60:	8082                	ret
ffffffffc0209b62:	8562                	mv	a0,s8
ffffffffc0209b64:	5441                	li	s0,-16
ffffffffc0209b66:	be5fa0ef          	jal	ra,ffffffffc020474a <up>
ffffffffc0209b6a:	bfe1                	j	ffffffffc0209b42 <sfs_getdirentry+0xbe>
ffffffffc0209b6c:	854a                	mv	a0,s2
ffffffffc0209b6e:	d09f90ef          	jal	ra,ffffffffc0203876 <kfree>
ffffffffc0209b72:	5475                	li	s0,-3
ffffffffc0209b74:	bfd1                	j	ffffffffc0209b48 <sfs_getdirentry+0xc4>
ffffffffc0209b76:	d01f90ef          	jal	ra,ffffffffc0203876 <kfree>
ffffffffc0209b7a:	5441                	li	s0,-16
ffffffffc0209b7c:	b7f1                	j	ffffffffc0209b48 <sfs_getdirentry+0xc4>
ffffffffc0209b7e:	5471                	li	s0,-4
ffffffffc0209b80:	b7e1                	j	ffffffffc0209b48 <sfs_getdirentry+0xc4>
ffffffffc0209b82:	00005697          	auipc	a3,0x5
ffffffffc0209b86:	14668693          	addi	a3,a3,326 # ffffffffc020ecc8 <dev_node_ops+0x120>
ffffffffc0209b8a:	00002617          	auipc	a2,0x2
ffffffffc0209b8e:	c7e60613          	addi	a2,a2,-898 # ffffffffc020b808 <commands+0x60>
ffffffffc0209b92:	34000593          	li	a1,832
ffffffffc0209b96:	00005517          	auipc	a0,0x5
ffffffffc0209b9a:	10250513          	addi	a0,a0,258 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc0209b9e:	e90f60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0209ba2:	00005697          	auipc	a3,0x5
ffffffffc0209ba6:	0be68693          	addi	a3,a3,190 # ffffffffc020ec60 <dev_node_ops+0xb8>
ffffffffc0209baa:	00002617          	auipc	a2,0x2
ffffffffc0209bae:	c5e60613          	addi	a2,a2,-930 # ffffffffc020b808 <commands+0x60>
ffffffffc0209bb2:	34100593          	li	a1,833
ffffffffc0209bb6:	00005517          	auipc	a0,0x5
ffffffffc0209bba:	0e250513          	addi	a0,a0,226 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc0209bbe:	e70f60ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0209bc2 <sfs_dirent_search_nolock.constprop.0>:
ffffffffc0209bc2:	715d                	addi	sp,sp,-80
ffffffffc0209bc4:	f052                	sd	s4,32(sp)
ffffffffc0209bc6:	8a2a                	mv	s4,a0
ffffffffc0209bc8:	8532                	mv	a0,a2
ffffffffc0209bca:	f44e                	sd	s3,40(sp)
ffffffffc0209bcc:	e85a                	sd	s6,16(sp)
ffffffffc0209bce:	e45e                	sd	s7,8(sp)
ffffffffc0209bd0:	e486                	sd	ra,72(sp)
ffffffffc0209bd2:	e0a2                	sd	s0,64(sp)
ffffffffc0209bd4:	fc26                	sd	s1,56(sp)
ffffffffc0209bd6:	f84a                	sd	s2,48(sp)
ffffffffc0209bd8:	ec56                	sd	s5,24(sp)
ffffffffc0209bda:	e062                	sd	s8,0(sp)
ffffffffc0209bdc:	8b32                	mv	s6,a2
ffffffffc0209bde:	89ae                	mv	s3,a1
ffffffffc0209be0:	8bb6                	mv	s7,a3
ffffffffc0209be2:	37a010ef          	jal	ra,ffffffffc020af5c <strlen>
ffffffffc0209be6:	0ff00793          	li	a5,255
ffffffffc0209bea:	06a7ef63          	bltu	a5,a0,ffffffffc0209c68 <sfs_dirent_search_nolock.constprop.0+0xa6>
ffffffffc0209bee:	10400513          	li	a0,260
ffffffffc0209bf2:	bd5f90ef          	jal	ra,ffffffffc02037c6 <kmalloc>
ffffffffc0209bf6:	892a                	mv	s2,a0
ffffffffc0209bf8:	c535                	beqz	a0,ffffffffc0209c64 <sfs_dirent_search_nolock.constprop.0+0xa2>
ffffffffc0209bfa:	0009b783          	ld	a5,0(s3)
ffffffffc0209bfe:	0087aa83          	lw	s5,8(a5)
ffffffffc0209c02:	05505a63          	blez	s5,ffffffffc0209c56 <sfs_dirent_search_nolock.constprop.0+0x94>
ffffffffc0209c06:	4481                	li	s1,0
ffffffffc0209c08:	00450c13          	addi	s8,a0,4
ffffffffc0209c0c:	a829                	j	ffffffffc0209c26 <sfs_dirent_search_nolock.constprop.0+0x64>
ffffffffc0209c0e:	00092783          	lw	a5,0(s2)
ffffffffc0209c12:	c799                	beqz	a5,ffffffffc0209c20 <sfs_dirent_search_nolock.constprop.0+0x5e>
ffffffffc0209c14:	85e2                	mv	a1,s8
ffffffffc0209c16:	855a                	mv	a0,s6
ffffffffc0209c18:	38c010ef          	jal	ra,ffffffffc020afa4 <strcmp>
ffffffffc0209c1c:	842a                	mv	s0,a0
ffffffffc0209c1e:	cd15                	beqz	a0,ffffffffc0209c5a <sfs_dirent_search_nolock.constprop.0+0x98>
ffffffffc0209c20:	2485                	addiw	s1,s1,1
ffffffffc0209c22:	029a8a63          	beq	s5,s1,ffffffffc0209c56 <sfs_dirent_search_nolock.constprop.0+0x94>
ffffffffc0209c26:	86ca                	mv	a3,s2
ffffffffc0209c28:	8626                	mv	a2,s1
ffffffffc0209c2a:	85ce                	mv	a1,s3
ffffffffc0209c2c:	8552                	mv	a0,s4
ffffffffc0209c2e:	d97ff0ef          	jal	ra,ffffffffc02099c4 <sfs_dirent_read_nolock>
ffffffffc0209c32:	842a                	mv	s0,a0
ffffffffc0209c34:	dd69                	beqz	a0,ffffffffc0209c0e <sfs_dirent_search_nolock.constprop.0+0x4c>
ffffffffc0209c36:	854a                	mv	a0,s2
ffffffffc0209c38:	c3ff90ef          	jal	ra,ffffffffc0203876 <kfree>
ffffffffc0209c3c:	60a6                	ld	ra,72(sp)
ffffffffc0209c3e:	8522                	mv	a0,s0
ffffffffc0209c40:	6406                	ld	s0,64(sp)
ffffffffc0209c42:	74e2                	ld	s1,56(sp)
ffffffffc0209c44:	7942                	ld	s2,48(sp)
ffffffffc0209c46:	79a2                	ld	s3,40(sp)
ffffffffc0209c48:	7a02                	ld	s4,32(sp)
ffffffffc0209c4a:	6ae2                	ld	s5,24(sp)
ffffffffc0209c4c:	6b42                	ld	s6,16(sp)
ffffffffc0209c4e:	6ba2                	ld	s7,8(sp)
ffffffffc0209c50:	6c02                	ld	s8,0(sp)
ffffffffc0209c52:	6161                	addi	sp,sp,80
ffffffffc0209c54:	8082                	ret
ffffffffc0209c56:	5441                	li	s0,-16
ffffffffc0209c58:	bff9                	j	ffffffffc0209c36 <sfs_dirent_search_nolock.constprop.0+0x74>
ffffffffc0209c5a:	00092783          	lw	a5,0(s2)
ffffffffc0209c5e:	00fba023          	sw	a5,0(s7)
ffffffffc0209c62:	bfd1                	j	ffffffffc0209c36 <sfs_dirent_search_nolock.constprop.0+0x74>
ffffffffc0209c64:	5471                	li	s0,-4
ffffffffc0209c66:	bfd9                	j	ffffffffc0209c3c <sfs_dirent_search_nolock.constprop.0+0x7a>
ffffffffc0209c68:	00005697          	auipc	a3,0x5
ffffffffc0209c6c:	24068693          	addi	a3,a3,576 # ffffffffc020eea8 <dev_node_ops+0x300>
ffffffffc0209c70:	00002617          	auipc	a2,0x2
ffffffffc0209c74:	b9860613          	addi	a2,a2,-1128 # ffffffffc020b808 <commands+0x60>
ffffffffc0209c78:	1ba00593          	li	a1,442
ffffffffc0209c7c:	00005517          	auipc	a0,0x5
ffffffffc0209c80:	01c50513          	addi	a0,a0,28 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc0209c84:	daaf60ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0209c88 <sfs_truncfile>:
ffffffffc0209c88:	7175                	addi	sp,sp,-144
ffffffffc0209c8a:	e506                	sd	ra,136(sp)
ffffffffc0209c8c:	e122                	sd	s0,128(sp)
ffffffffc0209c8e:	fca6                	sd	s1,120(sp)
ffffffffc0209c90:	f8ca                	sd	s2,112(sp)
ffffffffc0209c92:	f4ce                	sd	s3,104(sp)
ffffffffc0209c94:	f0d2                	sd	s4,96(sp)
ffffffffc0209c96:	ecd6                	sd	s5,88(sp)
ffffffffc0209c98:	e8da                	sd	s6,80(sp)
ffffffffc0209c9a:	e4de                	sd	s7,72(sp)
ffffffffc0209c9c:	e0e2                	sd	s8,64(sp)
ffffffffc0209c9e:	fc66                	sd	s9,56(sp)
ffffffffc0209ca0:	f86a                	sd	s10,48(sp)
ffffffffc0209ca2:	f46e                	sd	s11,40(sp)
ffffffffc0209ca4:	080007b7          	lui	a5,0x8000
ffffffffc0209ca8:	16b7e463          	bltu	a5,a1,ffffffffc0209e10 <sfs_truncfile+0x188>
ffffffffc0209cac:	06853c83          	ld	s9,104(a0)
ffffffffc0209cb0:	89aa                	mv	s3,a0
ffffffffc0209cb2:	160c8163          	beqz	s9,ffffffffc0209e14 <sfs_truncfile+0x18c>
ffffffffc0209cb6:	0b0ca783          	lw	a5,176(s9)
ffffffffc0209cba:	14079d63          	bnez	a5,ffffffffc0209e14 <sfs_truncfile+0x18c>
ffffffffc0209cbe:	4d38                	lw	a4,88(a0)
ffffffffc0209cc0:	6405                	lui	s0,0x1
ffffffffc0209cc2:	23540793          	addi	a5,s0,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc0209cc6:	16f71763          	bne	a4,a5,ffffffffc0209e34 <sfs_truncfile+0x1ac>
ffffffffc0209cca:	00053a83          	ld	s5,0(a0)
ffffffffc0209cce:	147d                	addi	s0,s0,-1
ffffffffc0209cd0:	942e                	add	s0,s0,a1
ffffffffc0209cd2:	000ae783          	lwu	a5,0(s5)
ffffffffc0209cd6:	8031                	srli	s0,s0,0xc
ffffffffc0209cd8:	8a2e                	mv	s4,a1
ffffffffc0209cda:	2401                	sext.w	s0,s0
ffffffffc0209cdc:	02b79763          	bne	a5,a1,ffffffffc0209d0a <sfs_truncfile+0x82>
ffffffffc0209ce0:	008aa783          	lw	a5,8(s5)
ffffffffc0209ce4:	4901                	li	s2,0
ffffffffc0209ce6:	18879763          	bne	a5,s0,ffffffffc0209e74 <sfs_truncfile+0x1ec>
ffffffffc0209cea:	60aa                	ld	ra,136(sp)
ffffffffc0209cec:	640a                	ld	s0,128(sp)
ffffffffc0209cee:	74e6                	ld	s1,120(sp)
ffffffffc0209cf0:	79a6                	ld	s3,104(sp)
ffffffffc0209cf2:	7a06                	ld	s4,96(sp)
ffffffffc0209cf4:	6ae6                	ld	s5,88(sp)
ffffffffc0209cf6:	6b46                	ld	s6,80(sp)
ffffffffc0209cf8:	6ba6                	ld	s7,72(sp)
ffffffffc0209cfa:	6c06                	ld	s8,64(sp)
ffffffffc0209cfc:	7ce2                	ld	s9,56(sp)
ffffffffc0209cfe:	7d42                	ld	s10,48(sp)
ffffffffc0209d00:	7da2                	ld	s11,40(sp)
ffffffffc0209d02:	854a                	mv	a0,s2
ffffffffc0209d04:	7946                	ld	s2,112(sp)
ffffffffc0209d06:	6149                	addi	sp,sp,144
ffffffffc0209d08:	8082                	ret
ffffffffc0209d0a:	02050b13          	addi	s6,a0,32
ffffffffc0209d0e:	855a                	mv	a0,s6
ffffffffc0209d10:	a3ffa0ef          	jal	ra,ffffffffc020474e <down>
ffffffffc0209d14:	008aa483          	lw	s1,8(s5)
ffffffffc0209d18:	0a84e663          	bltu	s1,s0,ffffffffc0209dc4 <sfs_truncfile+0x13c>
ffffffffc0209d1c:	0c947163          	bgeu	s0,s1,ffffffffc0209dde <sfs_truncfile+0x156>
ffffffffc0209d20:	4dad                	li	s11,11
ffffffffc0209d22:	4b85                	li	s7,1
ffffffffc0209d24:	a09d                	j	ffffffffc0209d8a <sfs_truncfile+0x102>
ffffffffc0209d26:	ff37091b          	addiw	s2,a4,-13
ffffffffc0209d2a:	0009079b          	sext.w	a5,s2
ffffffffc0209d2e:	3ff00713          	li	a4,1023
ffffffffc0209d32:	04f76563          	bltu	a4,a5,ffffffffc0209d7c <sfs_truncfile+0xf4>
ffffffffc0209d36:	03cd2c03          	lw	s8,60(s10)
ffffffffc0209d3a:	040c0163          	beqz	s8,ffffffffc0209d7c <sfs_truncfile+0xf4>
ffffffffc0209d3e:	004ca783          	lw	a5,4(s9)
ffffffffc0209d42:	18fc7963          	bgeu	s8,a5,ffffffffc0209ed4 <sfs_truncfile+0x24c>
ffffffffc0209d46:	038cb503          	ld	a0,56(s9)
ffffffffc0209d4a:	85e2                	mv	a1,s8
ffffffffc0209d4c:	627000ef          	jal	ra,ffffffffc020ab72 <bitmap_test>
ffffffffc0209d50:	16051263          	bnez	a0,ffffffffc0209eb4 <sfs_truncfile+0x22c>
ffffffffc0209d54:	02091793          	slli	a5,s2,0x20
ffffffffc0209d58:	01e7d713          	srli	a4,a5,0x1e
ffffffffc0209d5c:	86e2                	mv	a3,s8
ffffffffc0209d5e:	4611                	li	a2,4
ffffffffc0209d60:	082c                	addi	a1,sp,24
ffffffffc0209d62:	8566                	mv	a0,s9
ffffffffc0209d64:	e43a                	sd	a4,8(sp)
ffffffffc0209d66:	ce02                	sw	zero,28(sp)
ffffffffc0209d68:	7c5000ef          	jal	ra,ffffffffc020ad2c <sfs_rbuf>
ffffffffc0209d6c:	892a                	mv	s2,a0
ffffffffc0209d6e:	e141                	bnez	a0,ffffffffc0209dee <sfs_truncfile+0x166>
ffffffffc0209d70:	47e2                	lw	a5,24(sp)
ffffffffc0209d72:	6722                	ld	a4,8(sp)
ffffffffc0209d74:	e3c9                	bnez	a5,ffffffffc0209df6 <sfs_truncfile+0x16e>
ffffffffc0209d76:	008d2603          	lw	a2,8(s10)
ffffffffc0209d7a:	367d                	addiw	a2,a2,-1
ffffffffc0209d7c:	00cd2423          	sw	a2,8(s10)
ffffffffc0209d80:	0179b823          	sd	s7,16(s3)
ffffffffc0209d84:	34fd                	addiw	s1,s1,-1
ffffffffc0209d86:	04940a63          	beq	s0,s1,ffffffffc0209dda <sfs_truncfile+0x152>
ffffffffc0209d8a:	0009bd03          	ld	s10,0(s3)
ffffffffc0209d8e:	008d2703          	lw	a4,8(s10)
ffffffffc0209d92:	c369                	beqz	a4,ffffffffc0209e54 <sfs_truncfile+0x1cc>
ffffffffc0209d94:	fff7079b          	addiw	a5,a4,-1
ffffffffc0209d98:	0007861b          	sext.w	a2,a5
ffffffffc0209d9c:	f8cde5e3          	bltu	s11,a2,ffffffffc0209d26 <sfs_truncfile+0x9e>
ffffffffc0209da0:	02079713          	slli	a4,a5,0x20
ffffffffc0209da4:	01e75793          	srli	a5,a4,0x1e
ffffffffc0209da8:	00fd0933          	add	s2,s10,a5
ffffffffc0209dac:	00c92583          	lw	a1,12(s2)
ffffffffc0209db0:	d5f1                	beqz	a1,ffffffffc0209d7c <sfs_truncfile+0xf4>
ffffffffc0209db2:	8566                	mv	a0,s9
ffffffffc0209db4:	bf2ff0ef          	jal	ra,ffffffffc02091a6 <sfs_block_free>
ffffffffc0209db8:	00092623          	sw	zero,12(s2)
ffffffffc0209dbc:	008d2603          	lw	a2,8(s10)
ffffffffc0209dc0:	367d                	addiw	a2,a2,-1
ffffffffc0209dc2:	bf6d                	j	ffffffffc0209d7c <sfs_truncfile+0xf4>
ffffffffc0209dc4:	4681                	li	a3,0
ffffffffc0209dc6:	8626                	mv	a2,s1
ffffffffc0209dc8:	85ce                	mv	a1,s3
ffffffffc0209dca:	8566                	mv	a0,s9
ffffffffc0209dcc:	e94ff0ef          	jal	ra,ffffffffc0209460 <sfs_bmap_load_nolock>
ffffffffc0209dd0:	892a                	mv	s2,a0
ffffffffc0209dd2:	ed11                	bnez	a0,ffffffffc0209dee <sfs_truncfile+0x166>
ffffffffc0209dd4:	2485                	addiw	s1,s1,1
ffffffffc0209dd6:	fe9417e3          	bne	s0,s1,ffffffffc0209dc4 <sfs_truncfile+0x13c>
ffffffffc0209dda:	008aa483          	lw	s1,8(s5)
ffffffffc0209dde:	0a941b63          	bne	s0,s1,ffffffffc0209e94 <sfs_truncfile+0x20c>
ffffffffc0209de2:	014aa023          	sw	s4,0(s5)
ffffffffc0209de6:	4785                	li	a5,1
ffffffffc0209de8:	00f9b823          	sd	a5,16(s3)
ffffffffc0209dec:	4901                	li	s2,0
ffffffffc0209dee:	855a                	mv	a0,s6
ffffffffc0209df0:	95bfa0ef          	jal	ra,ffffffffc020474a <up>
ffffffffc0209df4:	bddd                	j	ffffffffc0209cea <sfs_truncfile+0x62>
ffffffffc0209df6:	86e2                	mv	a3,s8
ffffffffc0209df8:	4611                	li	a2,4
ffffffffc0209dfa:	086c                	addi	a1,sp,28
ffffffffc0209dfc:	8566                	mv	a0,s9
ffffffffc0209dfe:	7af000ef          	jal	ra,ffffffffc020adac <sfs_wbuf>
ffffffffc0209e02:	892a                	mv	s2,a0
ffffffffc0209e04:	f56d                	bnez	a0,ffffffffc0209dee <sfs_truncfile+0x166>
ffffffffc0209e06:	45e2                	lw	a1,24(sp)
ffffffffc0209e08:	8566                	mv	a0,s9
ffffffffc0209e0a:	b9cff0ef          	jal	ra,ffffffffc02091a6 <sfs_block_free>
ffffffffc0209e0e:	b7a5                	j	ffffffffc0209d76 <sfs_truncfile+0xee>
ffffffffc0209e10:	5975                	li	s2,-3
ffffffffc0209e12:	bde1                	j	ffffffffc0209cea <sfs_truncfile+0x62>
ffffffffc0209e14:	00005697          	auipc	a3,0x5
ffffffffc0209e18:	eb468693          	addi	a3,a3,-332 # ffffffffc020ecc8 <dev_node_ops+0x120>
ffffffffc0209e1c:	00002617          	auipc	a2,0x2
ffffffffc0209e20:	9ec60613          	addi	a2,a2,-1556 # ffffffffc020b808 <commands+0x60>
ffffffffc0209e24:	3af00593          	li	a1,943
ffffffffc0209e28:	00005517          	auipc	a0,0x5
ffffffffc0209e2c:	e7050513          	addi	a0,a0,-400 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc0209e30:	bfef60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0209e34:	00005697          	auipc	a3,0x5
ffffffffc0209e38:	e2c68693          	addi	a3,a3,-468 # ffffffffc020ec60 <dev_node_ops+0xb8>
ffffffffc0209e3c:	00002617          	auipc	a2,0x2
ffffffffc0209e40:	9cc60613          	addi	a2,a2,-1588 # ffffffffc020b808 <commands+0x60>
ffffffffc0209e44:	3b000593          	li	a1,944
ffffffffc0209e48:	00005517          	auipc	a0,0x5
ffffffffc0209e4c:	e5050513          	addi	a0,a0,-432 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc0209e50:	bdef60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0209e54:	00005697          	auipc	a3,0x5
ffffffffc0209e58:	09468693          	addi	a3,a3,148 # ffffffffc020eee8 <dev_node_ops+0x340>
ffffffffc0209e5c:	00002617          	auipc	a2,0x2
ffffffffc0209e60:	9ac60613          	addi	a2,a2,-1620 # ffffffffc020b808 <commands+0x60>
ffffffffc0209e64:	17b00593          	li	a1,379
ffffffffc0209e68:	00005517          	auipc	a0,0x5
ffffffffc0209e6c:	e3050513          	addi	a0,a0,-464 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc0209e70:	bbef60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0209e74:	00005697          	auipc	a3,0x5
ffffffffc0209e78:	05c68693          	addi	a3,a3,92 # ffffffffc020eed0 <dev_node_ops+0x328>
ffffffffc0209e7c:	00002617          	auipc	a2,0x2
ffffffffc0209e80:	98c60613          	addi	a2,a2,-1652 # ffffffffc020b808 <commands+0x60>
ffffffffc0209e84:	3b700593          	li	a1,951
ffffffffc0209e88:	00005517          	auipc	a0,0x5
ffffffffc0209e8c:	e1050513          	addi	a0,a0,-496 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc0209e90:	b9ef60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0209e94:	00005697          	auipc	a3,0x5
ffffffffc0209e98:	0a468693          	addi	a3,a3,164 # ffffffffc020ef38 <dev_node_ops+0x390>
ffffffffc0209e9c:	00002617          	auipc	a2,0x2
ffffffffc0209ea0:	96c60613          	addi	a2,a2,-1684 # ffffffffc020b808 <commands+0x60>
ffffffffc0209ea4:	3d000593          	li	a1,976
ffffffffc0209ea8:	00005517          	auipc	a0,0x5
ffffffffc0209eac:	df050513          	addi	a0,a0,-528 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc0209eb0:	b7ef60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0209eb4:	00005697          	auipc	a3,0x5
ffffffffc0209eb8:	04c68693          	addi	a3,a3,76 # ffffffffc020ef00 <dev_node_ops+0x358>
ffffffffc0209ebc:	00002617          	auipc	a2,0x2
ffffffffc0209ec0:	94c60613          	addi	a2,a2,-1716 # ffffffffc020b808 <commands+0x60>
ffffffffc0209ec4:	12b00593          	li	a1,299
ffffffffc0209ec8:	00005517          	auipc	a0,0x5
ffffffffc0209ecc:	dd050513          	addi	a0,a0,-560 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc0209ed0:	b5ef60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc0209ed4:	8762                	mv	a4,s8
ffffffffc0209ed6:	86be                	mv	a3,a5
ffffffffc0209ed8:	00005617          	auipc	a2,0x5
ffffffffc0209edc:	e2060613          	addi	a2,a2,-480 # ffffffffc020ecf8 <dev_node_ops+0x150>
ffffffffc0209ee0:	05300593          	li	a1,83
ffffffffc0209ee4:	00005517          	auipc	a0,0x5
ffffffffc0209ee8:	db450513          	addi	a0,a0,-588 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc0209eec:	b42f60ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc0209ef0 <sfs_load_inode>:
ffffffffc0209ef0:	7139                	addi	sp,sp,-64
ffffffffc0209ef2:	fc06                	sd	ra,56(sp)
ffffffffc0209ef4:	f822                	sd	s0,48(sp)
ffffffffc0209ef6:	f426                	sd	s1,40(sp)
ffffffffc0209ef8:	f04a                	sd	s2,32(sp)
ffffffffc0209efa:	84b2                	mv	s1,a2
ffffffffc0209efc:	892a                	mv	s2,a0
ffffffffc0209efe:	ec4e                	sd	s3,24(sp)
ffffffffc0209f00:	e852                	sd	s4,16(sp)
ffffffffc0209f02:	89ae                	mv	s3,a1
ffffffffc0209f04:	e456                	sd	s5,8(sp)
ffffffffc0209f06:	f81fe0ef          	jal	ra,ffffffffc0208e86 <lock_sfs_fs>
ffffffffc0209f0a:	45a9                	li	a1,10
ffffffffc0209f0c:	8526                	mv	a0,s1
ffffffffc0209f0e:	0a893403          	ld	s0,168(s2)
ffffffffc0209f12:	5d2010ef          	jal	ra,ffffffffc020b4e4 <hash32>
ffffffffc0209f16:	02051793          	slli	a5,a0,0x20
ffffffffc0209f1a:	01c7d713          	srli	a4,a5,0x1c
ffffffffc0209f1e:	9722                	add	a4,a4,s0
ffffffffc0209f20:	843a                	mv	s0,a4
ffffffffc0209f22:	a029                	j	ffffffffc0209f2c <sfs_load_inode+0x3c>
ffffffffc0209f24:	fc042783          	lw	a5,-64(s0)
ffffffffc0209f28:	10978863          	beq	a5,s1,ffffffffc020a038 <sfs_load_inode+0x148>
ffffffffc0209f2c:	6400                	ld	s0,8(s0)
ffffffffc0209f2e:	fe871be3          	bne	a4,s0,ffffffffc0209f24 <sfs_load_inode+0x34>
ffffffffc0209f32:	04000513          	li	a0,64
ffffffffc0209f36:	891f90ef          	jal	ra,ffffffffc02037c6 <kmalloc>
ffffffffc0209f3a:	8aaa                	mv	s5,a0
ffffffffc0209f3c:	16050563          	beqz	a0,ffffffffc020a0a6 <sfs_load_inode+0x1b6>
ffffffffc0209f40:	00492683          	lw	a3,4(s2)
ffffffffc0209f44:	18048363          	beqz	s1,ffffffffc020a0ca <sfs_load_inode+0x1da>
ffffffffc0209f48:	18d4f163          	bgeu	s1,a3,ffffffffc020a0ca <sfs_load_inode+0x1da>
ffffffffc0209f4c:	03893503          	ld	a0,56(s2)
ffffffffc0209f50:	85a6                	mv	a1,s1
ffffffffc0209f52:	421000ef          	jal	ra,ffffffffc020ab72 <bitmap_test>
ffffffffc0209f56:	18051763          	bnez	a0,ffffffffc020a0e4 <sfs_load_inode+0x1f4>
ffffffffc0209f5a:	4701                	li	a4,0
ffffffffc0209f5c:	86a6                	mv	a3,s1
ffffffffc0209f5e:	04000613          	li	a2,64
ffffffffc0209f62:	85d6                	mv	a1,s5
ffffffffc0209f64:	854a                	mv	a0,s2
ffffffffc0209f66:	5c7000ef          	jal	ra,ffffffffc020ad2c <sfs_rbuf>
ffffffffc0209f6a:	842a                	mv	s0,a0
ffffffffc0209f6c:	0e051563          	bnez	a0,ffffffffc020a056 <sfs_load_inode+0x166>
ffffffffc0209f70:	006ad783          	lhu	a5,6(s5)
ffffffffc0209f74:	12078b63          	beqz	a5,ffffffffc020a0aa <sfs_load_inode+0x1ba>
ffffffffc0209f78:	6405                	lui	s0,0x1
ffffffffc0209f7a:	23540513          	addi	a0,s0,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc0209f7e:	fe7fd0ef          	jal	ra,ffffffffc0207f64 <__alloc_inode>
ffffffffc0209f82:	8a2a                	mv	s4,a0
ffffffffc0209f84:	c961                	beqz	a0,ffffffffc020a054 <sfs_load_inode+0x164>
ffffffffc0209f86:	004ad683          	lhu	a3,4(s5)
ffffffffc0209f8a:	4785                	li	a5,1
ffffffffc0209f8c:	0cf69c63          	bne	a3,a5,ffffffffc020a064 <sfs_load_inode+0x174>
ffffffffc0209f90:	864a                	mv	a2,s2
ffffffffc0209f92:	00005597          	auipc	a1,0x5
ffffffffc0209f96:	0b658593          	addi	a1,a1,182 # ffffffffc020f048 <sfs_node_fileops>
ffffffffc0209f9a:	fe7fd0ef          	jal	ra,ffffffffc0207f80 <inode_init>
ffffffffc0209f9e:	058a2783          	lw	a5,88(s4)
ffffffffc0209fa2:	23540413          	addi	s0,s0,565
ffffffffc0209fa6:	0e879063          	bne	a5,s0,ffffffffc020a086 <sfs_load_inode+0x196>
ffffffffc0209faa:	4785                	li	a5,1
ffffffffc0209fac:	00fa2c23          	sw	a5,24(s4)
ffffffffc0209fb0:	015a3023          	sd	s5,0(s4)
ffffffffc0209fb4:	009a2423          	sw	s1,8(s4)
ffffffffc0209fb8:	000a3823          	sd	zero,16(s4)
ffffffffc0209fbc:	4585                	li	a1,1
ffffffffc0209fbe:	020a0513          	addi	a0,s4,32
ffffffffc0209fc2:	f80fa0ef          	jal	ra,ffffffffc0204742 <sem_init>
ffffffffc0209fc6:	058a2703          	lw	a4,88(s4)
ffffffffc0209fca:	6785                	lui	a5,0x1
ffffffffc0209fcc:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc0209fd0:	14f71663          	bne	a4,a5,ffffffffc020a11c <sfs_load_inode+0x22c>
ffffffffc0209fd4:	0a093703          	ld	a4,160(s2)
ffffffffc0209fd8:	038a0793          	addi	a5,s4,56
ffffffffc0209fdc:	008a2503          	lw	a0,8(s4)
ffffffffc0209fe0:	e31c                	sd	a5,0(a4)
ffffffffc0209fe2:	0af93023          	sd	a5,160(s2)
ffffffffc0209fe6:	09890793          	addi	a5,s2,152
ffffffffc0209fea:	0a893403          	ld	s0,168(s2)
ffffffffc0209fee:	45a9                	li	a1,10
ffffffffc0209ff0:	04ea3023          	sd	a4,64(s4)
ffffffffc0209ff4:	02fa3c23          	sd	a5,56(s4)
ffffffffc0209ff8:	4ec010ef          	jal	ra,ffffffffc020b4e4 <hash32>
ffffffffc0209ffc:	02051713          	slli	a4,a0,0x20
ffffffffc020a000:	01c75793          	srli	a5,a4,0x1c
ffffffffc020a004:	97a2                	add	a5,a5,s0
ffffffffc020a006:	6798                	ld	a4,8(a5)
ffffffffc020a008:	048a0693          	addi	a3,s4,72
ffffffffc020a00c:	e314                	sd	a3,0(a4)
ffffffffc020a00e:	e794                	sd	a3,8(a5)
ffffffffc020a010:	04ea3823          	sd	a4,80(s4)
ffffffffc020a014:	04fa3423          	sd	a5,72(s4)
ffffffffc020a018:	854a                	mv	a0,s2
ffffffffc020a01a:	e7dfe0ef          	jal	ra,ffffffffc0208e96 <unlock_sfs_fs>
ffffffffc020a01e:	4401                	li	s0,0
ffffffffc020a020:	0149b023          	sd	s4,0(s3)
ffffffffc020a024:	70e2                	ld	ra,56(sp)
ffffffffc020a026:	8522                	mv	a0,s0
ffffffffc020a028:	7442                	ld	s0,48(sp)
ffffffffc020a02a:	74a2                	ld	s1,40(sp)
ffffffffc020a02c:	7902                	ld	s2,32(sp)
ffffffffc020a02e:	69e2                	ld	s3,24(sp)
ffffffffc020a030:	6a42                	ld	s4,16(sp)
ffffffffc020a032:	6aa2                	ld	s5,8(sp)
ffffffffc020a034:	6121                	addi	sp,sp,64
ffffffffc020a036:	8082                	ret
ffffffffc020a038:	fb840a13          	addi	s4,s0,-72
ffffffffc020a03c:	8552                	mv	a0,s4
ffffffffc020a03e:	fa5fd0ef          	jal	ra,ffffffffc0207fe2 <inode_ref_inc>
ffffffffc020a042:	4785                	li	a5,1
ffffffffc020a044:	fcf51ae3          	bne	a0,a5,ffffffffc020a018 <sfs_load_inode+0x128>
ffffffffc020a048:	fd042783          	lw	a5,-48(s0)
ffffffffc020a04c:	2785                	addiw	a5,a5,1
ffffffffc020a04e:	fcf42823          	sw	a5,-48(s0)
ffffffffc020a052:	b7d9                	j	ffffffffc020a018 <sfs_load_inode+0x128>
ffffffffc020a054:	5471                	li	s0,-4
ffffffffc020a056:	8556                	mv	a0,s5
ffffffffc020a058:	81ff90ef          	jal	ra,ffffffffc0203876 <kfree>
ffffffffc020a05c:	854a                	mv	a0,s2
ffffffffc020a05e:	e39fe0ef          	jal	ra,ffffffffc0208e96 <unlock_sfs_fs>
ffffffffc020a062:	b7c9                	j	ffffffffc020a024 <sfs_load_inode+0x134>
ffffffffc020a064:	4789                	li	a5,2
ffffffffc020a066:	08f69f63          	bne	a3,a5,ffffffffc020a104 <sfs_load_inode+0x214>
ffffffffc020a06a:	864a                	mv	a2,s2
ffffffffc020a06c:	00005597          	auipc	a1,0x5
ffffffffc020a070:	f5c58593          	addi	a1,a1,-164 # ffffffffc020efc8 <sfs_node_dirops>
ffffffffc020a074:	f0dfd0ef          	jal	ra,ffffffffc0207f80 <inode_init>
ffffffffc020a078:	058a2703          	lw	a4,88(s4)
ffffffffc020a07c:	6785                	lui	a5,0x1
ffffffffc020a07e:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a082:	f2f704e3          	beq	a4,a5,ffffffffc0209faa <sfs_load_inode+0xba>
ffffffffc020a086:	00005697          	auipc	a3,0x5
ffffffffc020a08a:	bda68693          	addi	a3,a3,-1062 # ffffffffc020ec60 <dev_node_ops+0xb8>
ffffffffc020a08e:	00001617          	auipc	a2,0x1
ffffffffc020a092:	77a60613          	addi	a2,a2,1914 # ffffffffc020b808 <commands+0x60>
ffffffffc020a096:	07700593          	li	a1,119
ffffffffc020a09a:	00005517          	auipc	a0,0x5
ffffffffc020a09e:	bfe50513          	addi	a0,a0,-1026 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc020a0a2:	98cf60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020a0a6:	5471                	li	s0,-4
ffffffffc020a0a8:	bf55                	j	ffffffffc020a05c <sfs_load_inode+0x16c>
ffffffffc020a0aa:	00005697          	auipc	a3,0x5
ffffffffc020a0ae:	ea668693          	addi	a3,a3,-346 # ffffffffc020ef50 <dev_node_ops+0x3a8>
ffffffffc020a0b2:	00001617          	auipc	a2,0x1
ffffffffc020a0b6:	75660613          	addi	a2,a2,1878 # ffffffffc020b808 <commands+0x60>
ffffffffc020a0ba:	0ad00593          	li	a1,173
ffffffffc020a0be:	00005517          	auipc	a0,0x5
ffffffffc020a0c2:	bda50513          	addi	a0,a0,-1062 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc020a0c6:	968f60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020a0ca:	8726                	mv	a4,s1
ffffffffc020a0cc:	00005617          	auipc	a2,0x5
ffffffffc020a0d0:	c2c60613          	addi	a2,a2,-980 # ffffffffc020ecf8 <dev_node_ops+0x150>
ffffffffc020a0d4:	05300593          	li	a1,83
ffffffffc020a0d8:	00005517          	auipc	a0,0x5
ffffffffc020a0dc:	bc050513          	addi	a0,a0,-1088 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc020a0e0:	94ef60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020a0e4:	00005697          	auipc	a3,0x5
ffffffffc020a0e8:	c4c68693          	addi	a3,a3,-948 # ffffffffc020ed30 <dev_node_ops+0x188>
ffffffffc020a0ec:	00001617          	auipc	a2,0x1
ffffffffc020a0f0:	71c60613          	addi	a2,a2,1820 # ffffffffc020b808 <commands+0x60>
ffffffffc020a0f4:	0a800593          	li	a1,168
ffffffffc020a0f8:	00005517          	auipc	a0,0x5
ffffffffc020a0fc:	ba050513          	addi	a0,a0,-1120 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc020a100:	92ef60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020a104:	00005617          	auipc	a2,0x5
ffffffffc020a108:	bac60613          	addi	a2,a2,-1108 # ffffffffc020ecb0 <dev_node_ops+0x108>
ffffffffc020a10c:	02e00593          	li	a1,46
ffffffffc020a110:	00005517          	auipc	a0,0x5
ffffffffc020a114:	b8850513          	addi	a0,a0,-1144 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc020a118:	916f60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020a11c:	00005697          	auipc	a3,0x5
ffffffffc020a120:	b4468693          	addi	a3,a3,-1212 # ffffffffc020ec60 <dev_node_ops+0xb8>
ffffffffc020a124:	00001617          	auipc	a2,0x1
ffffffffc020a128:	6e460613          	addi	a2,a2,1764 # ffffffffc020b808 <commands+0x60>
ffffffffc020a12c:	0b100593          	li	a1,177
ffffffffc020a130:	00005517          	auipc	a0,0x5
ffffffffc020a134:	b6850513          	addi	a0,a0,-1176 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc020a138:	8f6f60ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020a13c <sfs_lookup>:
ffffffffc020a13c:	7139                	addi	sp,sp,-64
ffffffffc020a13e:	ec4e                	sd	s3,24(sp)
ffffffffc020a140:	06853983          	ld	s3,104(a0)
ffffffffc020a144:	fc06                	sd	ra,56(sp)
ffffffffc020a146:	f822                	sd	s0,48(sp)
ffffffffc020a148:	f426                	sd	s1,40(sp)
ffffffffc020a14a:	f04a                	sd	s2,32(sp)
ffffffffc020a14c:	e852                	sd	s4,16(sp)
ffffffffc020a14e:	0a098c63          	beqz	s3,ffffffffc020a206 <sfs_lookup+0xca>
ffffffffc020a152:	0b09a783          	lw	a5,176(s3)
ffffffffc020a156:	ebc5                	bnez	a5,ffffffffc020a206 <sfs_lookup+0xca>
ffffffffc020a158:	0005c783          	lbu	a5,0(a1)
ffffffffc020a15c:	84ae                	mv	s1,a1
ffffffffc020a15e:	c7c1                	beqz	a5,ffffffffc020a1e6 <sfs_lookup+0xaa>
ffffffffc020a160:	02f00713          	li	a4,47
ffffffffc020a164:	08e78163          	beq	a5,a4,ffffffffc020a1e6 <sfs_lookup+0xaa>
ffffffffc020a168:	842a                	mv	s0,a0
ffffffffc020a16a:	8a32                	mv	s4,a2
ffffffffc020a16c:	e77fd0ef          	jal	ra,ffffffffc0207fe2 <inode_ref_inc>
ffffffffc020a170:	4c38                	lw	a4,88(s0)
ffffffffc020a172:	6785                	lui	a5,0x1
ffffffffc020a174:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a178:	0af71763          	bne	a4,a5,ffffffffc020a226 <sfs_lookup+0xea>
ffffffffc020a17c:	6018                	ld	a4,0(s0)
ffffffffc020a17e:	4789                	li	a5,2
ffffffffc020a180:	00475703          	lhu	a4,4(a4)
ffffffffc020a184:	04f71c63          	bne	a4,a5,ffffffffc020a1dc <sfs_lookup+0xa0>
ffffffffc020a188:	02040913          	addi	s2,s0,32
ffffffffc020a18c:	854a                	mv	a0,s2
ffffffffc020a18e:	dc0fa0ef          	jal	ra,ffffffffc020474e <down>
ffffffffc020a192:	8626                	mv	a2,s1
ffffffffc020a194:	0054                	addi	a3,sp,4
ffffffffc020a196:	85a2                	mv	a1,s0
ffffffffc020a198:	854e                	mv	a0,s3
ffffffffc020a19a:	a29ff0ef          	jal	ra,ffffffffc0209bc2 <sfs_dirent_search_nolock.constprop.0>
ffffffffc020a19e:	84aa                	mv	s1,a0
ffffffffc020a1a0:	854a                	mv	a0,s2
ffffffffc020a1a2:	da8fa0ef          	jal	ra,ffffffffc020474a <up>
ffffffffc020a1a6:	cc89                	beqz	s1,ffffffffc020a1c0 <sfs_lookup+0x84>
ffffffffc020a1a8:	8522                	mv	a0,s0
ffffffffc020a1aa:	f07fd0ef          	jal	ra,ffffffffc02080b0 <inode_ref_dec>
ffffffffc020a1ae:	70e2                	ld	ra,56(sp)
ffffffffc020a1b0:	7442                	ld	s0,48(sp)
ffffffffc020a1b2:	7902                	ld	s2,32(sp)
ffffffffc020a1b4:	69e2                	ld	s3,24(sp)
ffffffffc020a1b6:	6a42                	ld	s4,16(sp)
ffffffffc020a1b8:	8526                	mv	a0,s1
ffffffffc020a1ba:	74a2                	ld	s1,40(sp)
ffffffffc020a1bc:	6121                	addi	sp,sp,64
ffffffffc020a1be:	8082                	ret
ffffffffc020a1c0:	4612                	lw	a2,4(sp)
ffffffffc020a1c2:	002c                	addi	a1,sp,8
ffffffffc020a1c4:	854e                	mv	a0,s3
ffffffffc020a1c6:	d2bff0ef          	jal	ra,ffffffffc0209ef0 <sfs_load_inode>
ffffffffc020a1ca:	84aa                	mv	s1,a0
ffffffffc020a1cc:	8522                	mv	a0,s0
ffffffffc020a1ce:	ee3fd0ef          	jal	ra,ffffffffc02080b0 <inode_ref_dec>
ffffffffc020a1d2:	fcf1                	bnez	s1,ffffffffc020a1ae <sfs_lookup+0x72>
ffffffffc020a1d4:	67a2                	ld	a5,8(sp)
ffffffffc020a1d6:	00fa3023          	sd	a5,0(s4)
ffffffffc020a1da:	bfd1                	j	ffffffffc020a1ae <sfs_lookup+0x72>
ffffffffc020a1dc:	8522                	mv	a0,s0
ffffffffc020a1de:	ed3fd0ef          	jal	ra,ffffffffc02080b0 <inode_ref_dec>
ffffffffc020a1e2:	54b9                	li	s1,-18
ffffffffc020a1e4:	b7e9                	j	ffffffffc020a1ae <sfs_lookup+0x72>
ffffffffc020a1e6:	00005697          	auipc	a3,0x5
ffffffffc020a1ea:	d8268693          	addi	a3,a3,-638 # ffffffffc020ef68 <dev_node_ops+0x3c0>
ffffffffc020a1ee:	00001617          	auipc	a2,0x1
ffffffffc020a1f2:	61a60613          	addi	a2,a2,1562 # ffffffffc020b808 <commands+0x60>
ffffffffc020a1f6:	3e100593          	li	a1,993
ffffffffc020a1fa:	00005517          	auipc	a0,0x5
ffffffffc020a1fe:	a9e50513          	addi	a0,a0,-1378 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc020a202:	82cf60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020a206:	00005697          	auipc	a3,0x5
ffffffffc020a20a:	ac268693          	addi	a3,a3,-1342 # ffffffffc020ecc8 <dev_node_ops+0x120>
ffffffffc020a20e:	00001617          	auipc	a2,0x1
ffffffffc020a212:	5fa60613          	addi	a2,a2,1530 # ffffffffc020b808 <commands+0x60>
ffffffffc020a216:	3e000593          	li	a1,992
ffffffffc020a21a:	00005517          	auipc	a0,0x5
ffffffffc020a21e:	a7e50513          	addi	a0,a0,-1410 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc020a222:	80cf60ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020a226:	00005697          	auipc	a3,0x5
ffffffffc020a22a:	a3a68693          	addi	a3,a3,-1478 # ffffffffc020ec60 <dev_node_ops+0xb8>
ffffffffc020a22e:	00001617          	auipc	a2,0x1
ffffffffc020a232:	5da60613          	addi	a2,a2,1498 # ffffffffc020b808 <commands+0x60>
ffffffffc020a236:	3e300593          	li	a1,995
ffffffffc020a23a:	00005517          	auipc	a0,0x5
ffffffffc020a23e:	a5e50513          	addi	a0,a0,-1442 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc020a242:	fedf50ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020a246 <sfs_namefile>:
ffffffffc020a246:	6d98                	ld	a4,24(a1)
ffffffffc020a248:	7175                	addi	sp,sp,-144
ffffffffc020a24a:	e506                	sd	ra,136(sp)
ffffffffc020a24c:	e122                	sd	s0,128(sp)
ffffffffc020a24e:	fca6                	sd	s1,120(sp)
ffffffffc020a250:	f8ca                	sd	s2,112(sp)
ffffffffc020a252:	f4ce                	sd	s3,104(sp)
ffffffffc020a254:	f0d2                	sd	s4,96(sp)
ffffffffc020a256:	ecd6                	sd	s5,88(sp)
ffffffffc020a258:	e8da                	sd	s6,80(sp)
ffffffffc020a25a:	e4de                	sd	s7,72(sp)
ffffffffc020a25c:	e0e2                	sd	s8,64(sp)
ffffffffc020a25e:	fc66                	sd	s9,56(sp)
ffffffffc020a260:	f86a                	sd	s10,48(sp)
ffffffffc020a262:	f46e                	sd	s11,40(sp)
ffffffffc020a264:	e42e                	sd	a1,8(sp)
ffffffffc020a266:	4789                	li	a5,2
ffffffffc020a268:	1ae7f363          	bgeu	a5,a4,ffffffffc020a40e <sfs_namefile+0x1c8>
ffffffffc020a26c:	89aa                	mv	s3,a0
ffffffffc020a26e:	10400513          	li	a0,260
ffffffffc020a272:	d54f90ef          	jal	ra,ffffffffc02037c6 <kmalloc>
ffffffffc020a276:	842a                	mv	s0,a0
ffffffffc020a278:	18050b63          	beqz	a0,ffffffffc020a40e <sfs_namefile+0x1c8>
ffffffffc020a27c:	0689b483          	ld	s1,104(s3)
ffffffffc020a280:	1e048963          	beqz	s1,ffffffffc020a472 <sfs_namefile+0x22c>
ffffffffc020a284:	0b04a783          	lw	a5,176(s1)
ffffffffc020a288:	1e079563          	bnez	a5,ffffffffc020a472 <sfs_namefile+0x22c>
ffffffffc020a28c:	0589ac83          	lw	s9,88(s3)
ffffffffc020a290:	6785                	lui	a5,0x1
ffffffffc020a292:	23578793          	addi	a5,a5,565 # 1235 <_binary_bin_swap_img_size-0x6acb>
ffffffffc020a296:	1afc9e63          	bne	s9,a5,ffffffffc020a452 <sfs_namefile+0x20c>
ffffffffc020a29a:	6722                	ld	a4,8(sp)
ffffffffc020a29c:	854e                	mv	a0,s3
ffffffffc020a29e:	8ace                	mv	s5,s3
ffffffffc020a2a0:	6f1c                	ld	a5,24(a4)
ffffffffc020a2a2:	00073b03          	ld	s6,0(a4)
ffffffffc020a2a6:	02098a13          	addi	s4,s3,32
ffffffffc020a2aa:	ffe78b93          	addi	s7,a5,-2
ffffffffc020a2ae:	9b3e                	add	s6,s6,a5
ffffffffc020a2b0:	00005d17          	auipc	s10,0x5
ffffffffc020a2b4:	cd8d0d13          	addi	s10,s10,-808 # ffffffffc020ef88 <dev_node_ops+0x3e0>
ffffffffc020a2b8:	d2bfd0ef          	jal	ra,ffffffffc0207fe2 <inode_ref_inc>
ffffffffc020a2bc:	00440c13          	addi	s8,s0,4
ffffffffc020a2c0:	e066                	sd	s9,0(sp)
ffffffffc020a2c2:	8552                	mv	a0,s4
ffffffffc020a2c4:	c8afa0ef          	jal	ra,ffffffffc020474e <down>
ffffffffc020a2c8:	0854                	addi	a3,sp,20
ffffffffc020a2ca:	866a                	mv	a2,s10
ffffffffc020a2cc:	85d6                	mv	a1,s5
ffffffffc020a2ce:	8526                	mv	a0,s1
ffffffffc020a2d0:	8f3ff0ef          	jal	ra,ffffffffc0209bc2 <sfs_dirent_search_nolock.constprop.0>
ffffffffc020a2d4:	8daa                	mv	s11,a0
ffffffffc020a2d6:	8552                	mv	a0,s4
ffffffffc020a2d8:	c72fa0ef          	jal	ra,ffffffffc020474a <up>
ffffffffc020a2dc:	020d8863          	beqz	s11,ffffffffc020a30c <sfs_namefile+0xc6>
ffffffffc020a2e0:	854e                	mv	a0,s3
ffffffffc020a2e2:	dcffd0ef          	jal	ra,ffffffffc02080b0 <inode_ref_dec>
ffffffffc020a2e6:	8522                	mv	a0,s0
ffffffffc020a2e8:	d8ef90ef          	jal	ra,ffffffffc0203876 <kfree>
ffffffffc020a2ec:	60aa                	ld	ra,136(sp)
ffffffffc020a2ee:	640a                	ld	s0,128(sp)
ffffffffc020a2f0:	74e6                	ld	s1,120(sp)
ffffffffc020a2f2:	7946                	ld	s2,112(sp)
ffffffffc020a2f4:	79a6                	ld	s3,104(sp)
ffffffffc020a2f6:	7a06                	ld	s4,96(sp)
ffffffffc020a2f8:	6ae6                	ld	s5,88(sp)
ffffffffc020a2fa:	6b46                	ld	s6,80(sp)
ffffffffc020a2fc:	6ba6                	ld	s7,72(sp)
ffffffffc020a2fe:	6c06                	ld	s8,64(sp)
ffffffffc020a300:	7ce2                	ld	s9,56(sp)
ffffffffc020a302:	7d42                	ld	s10,48(sp)
ffffffffc020a304:	856e                	mv	a0,s11
ffffffffc020a306:	7da2                	ld	s11,40(sp)
ffffffffc020a308:	6149                	addi	sp,sp,144
ffffffffc020a30a:	8082                	ret
ffffffffc020a30c:	4652                	lw	a2,20(sp)
ffffffffc020a30e:	082c                	addi	a1,sp,24
ffffffffc020a310:	8526                	mv	a0,s1
ffffffffc020a312:	bdfff0ef          	jal	ra,ffffffffc0209ef0 <sfs_load_inode>
ffffffffc020a316:	8daa                	mv	s11,a0
ffffffffc020a318:	f561                	bnez	a0,ffffffffc020a2e0 <sfs_namefile+0x9a>
ffffffffc020a31a:	854e                	mv	a0,s3
ffffffffc020a31c:	008aa903          	lw	s2,8(s5)
ffffffffc020a320:	d91fd0ef          	jal	ra,ffffffffc02080b0 <inode_ref_dec>
ffffffffc020a324:	6ce2                	ld	s9,24(sp)
ffffffffc020a326:	0b3c8463          	beq	s9,s3,ffffffffc020a3ce <sfs_namefile+0x188>
ffffffffc020a32a:	100c8463          	beqz	s9,ffffffffc020a432 <sfs_namefile+0x1ec>
ffffffffc020a32e:	058ca703          	lw	a4,88(s9)
ffffffffc020a332:	6782                	ld	a5,0(sp)
ffffffffc020a334:	0ef71f63          	bne	a4,a5,ffffffffc020a432 <sfs_namefile+0x1ec>
ffffffffc020a338:	008ca703          	lw	a4,8(s9)
ffffffffc020a33c:	8ae6                	mv	s5,s9
ffffffffc020a33e:	0d270a63          	beq	a4,s2,ffffffffc020a412 <sfs_namefile+0x1cc>
ffffffffc020a342:	000cb703          	ld	a4,0(s9)
ffffffffc020a346:	4789                	li	a5,2
ffffffffc020a348:	00475703          	lhu	a4,4(a4)
ffffffffc020a34c:	0cf71363          	bne	a4,a5,ffffffffc020a412 <sfs_namefile+0x1cc>
ffffffffc020a350:	020c8a13          	addi	s4,s9,32
ffffffffc020a354:	8552                	mv	a0,s4
ffffffffc020a356:	bf8fa0ef          	jal	ra,ffffffffc020474e <down>
ffffffffc020a35a:	000cb703          	ld	a4,0(s9)
ffffffffc020a35e:	00872983          	lw	s3,8(a4)
ffffffffc020a362:	01304963          	bgtz	s3,ffffffffc020a374 <sfs_namefile+0x12e>
ffffffffc020a366:	a899                	j	ffffffffc020a3bc <sfs_namefile+0x176>
ffffffffc020a368:	4018                	lw	a4,0(s0)
ffffffffc020a36a:	01270e63          	beq	a4,s2,ffffffffc020a386 <sfs_namefile+0x140>
ffffffffc020a36e:	2d85                	addiw	s11,s11,1
ffffffffc020a370:	05b98663          	beq	s3,s11,ffffffffc020a3bc <sfs_namefile+0x176>
ffffffffc020a374:	86a2                	mv	a3,s0
ffffffffc020a376:	866e                	mv	a2,s11
ffffffffc020a378:	85e6                	mv	a1,s9
ffffffffc020a37a:	8526                	mv	a0,s1
ffffffffc020a37c:	e48ff0ef          	jal	ra,ffffffffc02099c4 <sfs_dirent_read_nolock>
ffffffffc020a380:	872a                	mv	a4,a0
ffffffffc020a382:	d17d                	beqz	a0,ffffffffc020a368 <sfs_namefile+0x122>
ffffffffc020a384:	a82d                	j	ffffffffc020a3be <sfs_namefile+0x178>
ffffffffc020a386:	8552                	mv	a0,s4
ffffffffc020a388:	bc2fa0ef          	jal	ra,ffffffffc020474a <up>
ffffffffc020a38c:	8562                	mv	a0,s8
ffffffffc020a38e:	3cf000ef          	jal	ra,ffffffffc020af5c <strlen>
ffffffffc020a392:	00150793          	addi	a5,a0,1
ffffffffc020a396:	862a                	mv	a2,a0
ffffffffc020a398:	06fbe863          	bltu	s7,a5,ffffffffc020a408 <sfs_namefile+0x1c2>
ffffffffc020a39c:	fff64913          	not	s2,a2
ffffffffc020a3a0:	995a                	add	s2,s2,s6
ffffffffc020a3a2:	85e2                	mv	a1,s8
ffffffffc020a3a4:	854a                	mv	a0,s2
ffffffffc020a3a6:	40fb8bb3          	sub	s7,s7,a5
ffffffffc020a3aa:	4a7000ef          	jal	ra,ffffffffc020b050 <memcpy>
ffffffffc020a3ae:	02f00793          	li	a5,47
ffffffffc020a3b2:	fefb0fa3          	sb	a5,-1(s6)
ffffffffc020a3b6:	89e6                	mv	s3,s9
ffffffffc020a3b8:	8b4a                	mv	s6,s2
ffffffffc020a3ba:	b721                	j	ffffffffc020a2c2 <sfs_namefile+0x7c>
ffffffffc020a3bc:	5741                	li	a4,-16
ffffffffc020a3be:	8552                	mv	a0,s4
ffffffffc020a3c0:	e03a                	sd	a4,0(sp)
ffffffffc020a3c2:	b88fa0ef          	jal	ra,ffffffffc020474a <up>
ffffffffc020a3c6:	6702                	ld	a4,0(sp)
ffffffffc020a3c8:	89e6                	mv	s3,s9
ffffffffc020a3ca:	8dba                	mv	s11,a4
ffffffffc020a3cc:	bf11                	j	ffffffffc020a2e0 <sfs_namefile+0x9a>
ffffffffc020a3ce:	854e                	mv	a0,s3
ffffffffc020a3d0:	ce1fd0ef          	jal	ra,ffffffffc02080b0 <inode_ref_dec>
ffffffffc020a3d4:	64a2                	ld	s1,8(sp)
ffffffffc020a3d6:	85da                	mv	a1,s6
ffffffffc020a3d8:	6c98                	ld	a4,24(s1)
ffffffffc020a3da:	6088                	ld	a0,0(s1)
ffffffffc020a3dc:	1779                	addi	a4,a4,-2
ffffffffc020a3de:	41770bb3          	sub	s7,a4,s7
ffffffffc020a3e2:	865e                	mv	a2,s7
ffffffffc020a3e4:	0505                	addi	a0,a0,1
ffffffffc020a3e6:	42b000ef          	jal	ra,ffffffffc020b010 <memmove>
ffffffffc020a3ea:	02f00713          	li	a4,47
ffffffffc020a3ee:	fee50fa3          	sb	a4,-1(a0)
ffffffffc020a3f2:	955e                	add	a0,a0,s7
ffffffffc020a3f4:	00050023          	sb	zero,0(a0)
ffffffffc020a3f8:	85de                	mv	a1,s7
ffffffffc020a3fa:	8526                	mv	a0,s1
ffffffffc020a3fc:	baafb0ef          	jal	ra,ffffffffc02057a6 <iobuf_skip>
ffffffffc020a400:	8522                	mv	a0,s0
ffffffffc020a402:	c74f90ef          	jal	ra,ffffffffc0203876 <kfree>
ffffffffc020a406:	b5dd                	j	ffffffffc020a2ec <sfs_namefile+0xa6>
ffffffffc020a408:	89e6                	mv	s3,s9
ffffffffc020a40a:	5df1                	li	s11,-4
ffffffffc020a40c:	bdd1                	j	ffffffffc020a2e0 <sfs_namefile+0x9a>
ffffffffc020a40e:	5df1                	li	s11,-4
ffffffffc020a410:	bdf1                	j	ffffffffc020a2ec <sfs_namefile+0xa6>
ffffffffc020a412:	00005697          	auipc	a3,0x5
ffffffffc020a416:	b7e68693          	addi	a3,a3,-1154 # ffffffffc020ef90 <dev_node_ops+0x3e8>
ffffffffc020a41a:	00001617          	auipc	a2,0x1
ffffffffc020a41e:	3ee60613          	addi	a2,a2,1006 # ffffffffc020b808 <commands+0x60>
ffffffffc020a422:	2ff00593          	li	a1,767
ffffffffc020a426:	00005517          	auipc	a0,0x5
ffffffffc020a42a:	87250513          	addi	a0,a0,-1934 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc020a42e:	e01f50ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020a432:	00005697          	auipc	a3,0x5
ffffffffc020a436:	82e68693          	addi	a3,a3,-2002 # ffffffffc020ec60 <dev_node_ops+0xb8>
ffffffffc020a43a:	00001617          	auipc	a2,0x1
ffffffffc020a43e:	3ce60613          	addi	a2,a2,974 # ffffffffc020b808 <commands+0x60>
ffffffffc020a442:	2fe00593          	li	a1,766
ffffffffc020a446:	00005517          	auipc	a0,0x5
ffffffffc020a44a:	85250513          	addi	a0,a0,-1966 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc020a44e:	de1f50ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020a452:	00005697          	auipc	a3,0x5
ffffffffc020a456:	80e68693          	addi	a3,a3,-2034 # ffffffffc020ec60 <dev_node_ops+0xb8>
ffffffffc020a45a:	00001617          	auipc	a2,0x1
ffffffffc020a45e:	3ae60613          	addi	a2,a2,942 # ffffffffc020b808 <commands+0x60>
ffffffffc020a462:	2eb00593          	li	a1,747
ffffffffc020a466:	00005517          	auipc	a0,0x5
ffffffffc020a46a:	83250513          	addi	a0,a0,-1998 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc020a46e:	dc1f50ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020a472:	00005697          	auipc	a3,0x5
ffffffffc020a476:	85668693          	addi	a3,a3,-1962 # ffffffffc020ecc8 <dev_node_ops+0x120>
ffffffffc020a47a:	00001617          	auipc	a2,0x1
ffffffffc020a47e:	38e60613          	addi	a2,a2,910 # ffffffffc020b808 <commands+0x60>
ffffffffc020a482:	2ea00593          	li	a1,746
ffffffffc020a486:	00005517          	auipc	a0,0x5
ffffffffc020a48a:	81250513          	addi	a0,a0,-2030 # ffffffffc020ec98 <dev_node_ops+0xf0>
ffffffffc020a48e:	da1f50ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020a492 <sfs_unmount>:
ffffffffc020a492:	1141                	addi	sp,sp,-16
ffffffffc020a494:	e406                	sd	ra,8(sp)
ffffffffc020a496:	e022                	sd	s0,0(sp)
ffffffffc020a498:	cd1d                	beqz	a0,ffffffffc020a4d6 <sfs_unmount+0x44>
ffffffffc020a49a:	0b052783          	lw	a5,176(a0)
ffffffffc020a49e:	842a                	mv	s0,a0
ffffffffc020a4a0:	eb9d                	bnez	a5,ffffffffc020a4d6 <sfs_unmount+0x44>
ffffffffc020a4a2:	7158                	ld	a4,160(a0)
ffffffffc020a4a4:	09850793          	addi	a5,a0,152
ffffffffc020a4a8:	02f71563          	bne	a4,a5,ffffffffc020a4d2 <sfs_unmount+0x40>
ffffffffc020a4ac:	613c                	ld	a5,64(a0)
ffffffffc020a4ae:	e7a1                	bnez	a5,ffffffffc020a4f6 <sfs_unmount+0x64>
ffffffffc020a4b0:	7d08                	ld	a0,56(a0)
ffffffffc020a4b2:	73a000ef          	jal	ra,ffffffffc020abec <bitmap_destroy>
ffffffffc020a4b6:	6428                	ld	a0,72(s0)
ffffffffc020a4b8:	bbef90ef          	jal	ra,ffffffffc0203876 <kfree>
ffffffffc020a4bc:	7448                	ld	a0,168(s0)
ffffffffc020a4be:	bb8f90ef          	jal	ra,ffffffffc0203876 <kfree>
ffffffffc020a4c2:	8522                	mv	a0,s0
ffffffffc020a4c4:	bb2f90ef          	jal	ra,ffffffffc0203876 <kfree>
ffffffffc020a4c8:	4501                	li	a0,0
ffffffffc020a4ca:	60a2                	ld	ra,8(sp)
ffffffffc020a4cc:	6402                	ld	s0,0(sp)
ffffffffc020a4ce:	0141                	addi	sp,sp,16
ffffffffc020a4d0:	8082                	ret
ffffffffc020a4d2:	5545                	li	a0,-15
ffffffffc020a4d4:	bfdd                	j	ffffffffc020a4ca <sfs_unmount+0x38>
ffffffffc020a4d6:	00004697          	auipc	a3,0x4
ffffffffc020a4da:	7f268693          	addi	a3,a3,2034 # ffffffffc020ecc8 <dev_node_ops+0x120>
ffffffffc020a4de:	00001617          	auipc	a2,0x1
ffffffffc020a4e2:	32a60613          	addi	a2,a2,810 # ffffffffc020b808 <commands+0x60>
ffffffffc020a4e6:	04100593          	li	a1,65
ffffffffc020a4ea:	00005517          	auipc	a0,0x5
ffffffffc020a4ee:	bde50513          	addi	a0,a0,-1058 # ffffffffc020f0c8 <sfs_node_fileops+0x80>
ffffffffc020a4f2:	d3df50ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020a4f6:	00005697          	auipc	a3,0x5
ffffffffc020a4fa:	bea68693          	addi	a3,a3,-1046 # ffffffffc020f0e0 <sfs_node_fileops+0x98>
ffffffffc020a4fe:	00001617          	auipc	a2,0x1
ffffffffc020a502:	30a60613          	addi	a2,a2,778 # ffffffffc020b808 <commands+0x60>
ffffffffc020a506:	04500593          	li	a1,69
ffffffffc020a50a:	00005517          	auipc	a0,0x5
ffffffffc020a50e:	bbe50513          	addi	a0,a0,-1090 # ffffffffc020f0c8 <sfs_node_fileops+0x80>
ffffffffc020a512:	d1df50ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020a516 <sfs_cleanup>:
ffffffffc020a516:	1101                	addi	sp,sp,-32
ffffffffc020a518:	ec06                	sd	ra,24(sp)
ffffffffc020a51a:	e822                	sd	s0,16(sp)
ffffffffc020a51c:	e426                	sd	s1,8(sp)
ffffffffc020a51e:	e04a                	sd	s2,0(sp)
ffffffffc020a520:	c525                	beqz	a0,ffffffffc020a588 <sfs_cleanup+0x72>
ffffffffc020a522:	0b052783          	lw	a5,176(a0)
ffffffffc020a526:	84aa                	mv	s1,a0
ffffffffc020a528:	e3a5                	bnez	a5,ffffffffc020a588 <sfs_cleanup+0x72>
ffffffffc020a52a:	4158                	lw	a4,4(a0)
ffffffffc020a52c:	4514                	lw	a3,8(a0)
ffffffffc020a52e:	00c50913          	addi	s2,a0,12
ffffffffc020a532:	85ca                	mv	a1,s2
ffffffffc020a534:	40d7063b          	subw	a2,a4,a3
ffffffffc020a538:	00005517          	auipc	a0,0x5
ffffffffc020a53c:	bc050513          	addi	a0,a0,-1088 # ffffffffc020f0f8 <sfs_node_fileops+0xb0>
ffffffffc020a540:	bebf50ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc020a544:	02000413          	li	s0,32
ffffffffc020a548:	a019                	j	ffffffffc020a54e <sfs_cleanup+0x38>
ffffffffc020a54a:	347d                	addiw	s0,s0,-1
ffffffffc020a54c:	c819                	beqz	s0,ffffffffc020a562 <sfs_cleanup+0x4c>
ffffffffc020a54e:	7cdc                	ld	a5,184(s1)
ffffffffc020a550:	8526                	mv	a0,s1
ffffffffc020a552:	9782                	jalr	a5
ffffffffc020a554:	f97d                	bnez	a0,ffffffffc020a54a <sfs_cleanup+0x34>
ffffffffc020a556:	60e2                	ld	ra,24(sp)
ffffffffc020a558:	6442                	ld	s0,16(sp)
ffffffffc020a55a:	64a2                	ld	s1,8(sp)
ffffffffc020a55c:	6902                	ld	s2,0(sp)
ffffffffc020a55e:	6105                	addi	sp,sp,32
ffffffffc020a560:	8082                	ret
ffffffffc020a562:	6442                	ld	s0,16(sp)
ffffffffc020a564:	60e2                	ld	ra,24(sp)
ffffffffc020a566:	64a2                	ld	s1,8(sp)
ffffffffc020a568:	86ca                	mv	a3,s2
ffffffffc020a56a:	6902                	ld	s2,0(sp)
ffffffffc020a56c:	872a                	mv	a4,a0
ffffffffc020a56e:	00005617          	auipc	a2,0x5
ffffffffc020a572:	baa60613          	addi	a2,a2,-1110 # ffffffffc020f118 <sfs_node_fileops+0xd0>
ffffffffc020a576:	05f00593          	li	a1,95
ffffffffc020a57a:	00005517          	auipc	a0,0x5
ffffffffc020a57e:	b4e50513          	addi	a0,a0,-1202 # ffffffffc020f0c8 <sfs_node_fileops+0x80>
ffffffffc020a582:	6105                	addi	sp,sp,32
ffffffffc020a584:	d13f506f          	j	ffffffffc0200296 <__warn>
ffffffffc020a588:	00004697          	auipc	a3,0x4
ffffffffc020a58c:	74068693          	addi	a3,a3,1856 # ffffffffc020ecc8 <dev_node_ops+0x120>
ffffffffc020a590:	00001617          	auipc	a2,0x1
ffffffffc020a594:	27860613          	addi	a2,a2,632 # ffffffffc020b808 <commands+0x60>
ffffffffc020a598:	05400593          	li	a1,84
ffffffffc020a59c:	00005517          	auipc	a0,0x5
ffffffffc020a5a0:	b2c50513          	addi	a0,a0,-1236 # ffffffffc020f0c8 <sfs_node_fileops+0x80>
ffffffffc020a5a4:	c8bf50ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020a5a8 <sfs_sync>:
ffffffffc020a5a8:	7179                	addi	sp,sp,-48
ffffffffc020a5aa:	f406                	sd	ra,40(sp)
ffffffffc020a5ac:	f022                	sd	s0,32(sp)
ffffffffc020a5ae:	ec26                	sd	s1,24(sp)
ffffffffc020a5b0:	e84a                	sd	s2,16(sp)
ffffffffc020a5b2:	e44e                	sd	s3,8(sp)
ffffffffc020a5b4:	e052                	sd	s4,0(sp)
ffffffffc020a5b6:	cd4d                	beqz	a0,ffffffffc020a670 <sfs_sync+0xc8>
ffffffffc020a5b8:	0b052783          	lw	a5,176(a0)
ffffffffc020a5bc:	8a2a                	mv	s4,a0
ffffffffc020a5be:	ebcd                	bnez	a5,ffffffffc020a670 <sfs_sync+0xc8>
ffffffffc020a5c0:	8c7fe0ef          	jal	ra,ffffffffc0208e86 <lock_sfs_fs>
ffffffffc020a5c4:	0a0a3403          	ld	s0,160(s4)
ffffffffc020a5c8:	098a0913          	addi	s2,s4,152
ffffffffc020a5cc:	02890763          	beq	s2,s0,ffffffffc020a5fa <sfs_sync+0x52>
ffffffffc020a5d0:	00003997          	auipc	s3,0x3
ffffffffc020a5d4:	d5898993          	addi	s3,s3,-680 # ffffffffc020d328 <default_pmm_manager+0x460>
ffffffffc020a5d8:	7c1c                	ld	a5,56(s0)
ffffffffc020a5da:	fc840493          	addi	s1,s0,-56
ffffffffc020a5de:	cbb5                	beqz	a5,ffffffffc020a652 <sfs_sync+0xaa>
ffffffffc020a5e0:	7b9c                	ld	a5,48(a5)
ffffffffc020a5e2:	cba5                	beqz	a5,ffffffffc020a652 <sfs_sync+0xaa>
ffffffffc020a5e4:	85ce                	mv	a1,s3
ffffffffc020a5e6:	8526                	mv	a0,s1
ffffffffc020a5e8:	a13fd0ef          	jal	ra,ffffffffc0207ffa <inode_check>
ffffffffc020a5ec:	7c1c                	ld	a5,56(s0)
ffffffffc020a5ee:	8526                	mv	a0,s1
ffffffffc020a5f0:	7b9c                	ld	a5,48(a5)
ffffffffc020a5f2:	9782                	jalr	a5
ffffffffc020a5f4:	6400                	ld	s0,8(s0)
ffffffffc020a5f6:	fe8911e3          	bne	s2,s0,ffffffffc020a5d8 <sfs_sync+0x30>
ffffffffc020a5fa:	8552                	mv	a0,s4
ffffffffc020a5fc:	89bfe0ef          	jal	ra,ffffffffc0208e96 <unlock_sfs_fs>
ffffffffc020a600:	040a3783          	ld	a5,64(s4)
ffffffffc020a604:	4501                	li	a0,0
ffffffffc020a606:	eb89                	bnez	a5,ffffffffc020a618 <sfs_sync+0x70>
ffffffffc020a608:	70a2                	ld	ra,40(sp)
ffffffffc020a60a:	7402                	ld	s0,32(sp)
ffffffffc020a60c:	64e2                	ld	s1,24(sp)
ffffffffc020a60e:	6942                	ld	s2,16(sp)
ffffffffc020a610:	69a2                	ld	s3,8(sp)
ffffffffc020a612:	6a02                	ld	s4,0(sp)
ffffffffc020a614:	6145                	addi	sp,sp,48
ffffffffc020a616:	8082                	ret
ffffffffc020a618:	040a3023          	sd	zero,64(s4)
ffffffffc020a61c:	8552                	mv	a0,s4
ffffffffc020a61e:	023000ef          	jal	ra,ffffffffc020ae40 <sfs_sync_super>
ffffffffc020a622:	cd01                	beqz	a0,ffffffffc020a63a <sfs_sync+0x92>
ffffffffc020a624:	70a2                	ld	ra,40(sp)
ffffffffc020a626:	7402                	ld	s0,32(sp)
ffffffffc020a628:	4785                	li	a5,1
ffffffffc020a62a:	04fa3023          	sd	a5,64(s4)
ffffffffc020a62e:	64e2                	ld	s1,24(sp)
ffffffffc020a630:	6942                	ld	s2,16(sp)
ffffffffc020a632:	69a2                	ld	s3,8(sp)
ffffffffc020a634:	6a02                	ld	s4,0(sp)
ffffffffc020a636:	6145                	addi	sp,sp,48
ffffffffc020a638:	8082                	ret
ffffffffc020a63a:	8552                	mv	a0,s4
ffffffffc020a63c:	04b000ef          	jal	ra,ffffffffc020ae86 <sfs_sync_freemap>
ffffffffc020a640:	f175                	bnez	a0,ffffffffc020a624 <sfs_sync+0x7c>
ffffffffc020a642:	70a2                	ld	ra,40(sp)
ffffffffc020a644:	7402                	ld	s0,32(sp)
ffffffffc020a646:	64e2                	ld	s1,24(sp)
ffffffffc020a648:	6942                	ld	s2,16(sp)
ffffffffc020a64a:	69a2                	ld	s3,8(sp)
ffffffffc020a64c:	6a02                	ld	s4,0(sp)
ffffffffc020a64e:	6145                	addi	sp,sp,48
ffffffffc020a650:	8082                	ret
ffffffffc020a652:	00003697          	auipc	a3,0x3
ffffffffc020a656:	c8668693          	addi	a3,a3,-890 # ffffffffc020d2d8 <default_pmm_manager+0x410>
ffffffffc020a65a:	00001617          	auipc	a2,0x1
ffffffffc020a65e:	1ae60613          	addi	a2,a2,430 # ffffffffc020b808 <commands+0x60>
ffffffffc020a662:	45ed                	li	a1,27
ffffffffc020a664:	00005517          	auipc	a0,0x5
ffffffffc020a668:	a6450513          	addi	a0,a0,-1436 # ffffffffc020f0c8 <sfs_node_fileops+0x80>
ffffffffc020a66c:	bc3f50ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020a670:	00004697          	auipc	a3,0x4
ffffffffc020a674:	65868693          	addi	a3,a3,1624 # ffffffffc020ecc8 <dev_node_ops+0x120>
ffffffffc020a678:	00001617          	auipc	a2,0x1
ffffffffc020a67c:	19060613          	addi	a2,a2,400 # ffffffffc020b808 <commands+0x60>
ffffffffc020a680:	45d5                	li	a1,21
ffffffffc020a682:	00005517          	auipc	a0,0x5
ffffffffc020a686:	a4650513          	addi	a0,a0,-1466 # ffffffffc020f0c8 <sfs_node_fileops+0x80>
ffffffffc020a68a:	ba5f50ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020a68e <sfs_get_root>:
ffffffffc020a68e:	1101                	addi	sp,sp,-32
ffffffffc020a690:	ec06                	sd	ra,24(sp)
ffffffffc020a692:	cd09                	beqz	a0,ffffffffc020a6ac <sfs_get_root+0x1e>
ffffffffc020a694:	0b052783          	lw	a5,176(a0)
ffffffffc020a698:	eb91                	bnez	a5,ffffffffc020a6ac <sfs_get_root+0x1e>
ffffffffc020a69a:	4605                	li	a2,1
ffffffffc020a69c:	002c                	addi	a1,sp,8
ffffffffc020a69e:	853ff0ef          	jal	ra,ffffffffc0209ef0 <sfs_load_inode>
ffffffffc020a6a2:	e50d                	bnez	a0,ffffffffc020a6cc <sfs_get_root+0x3e>
ffffffffc020a6a4:	60e2                	ld	ra,24(sp)
ffffffffc020a6a6:	6522                	ld	a0,8(sp)
ffffffffc020a6a8:	6105                	addi	sp,sp,32
ffffffffc020a6aa:	8082                	ret
ffffffffc020a6ac:	00004697          	auipc	a3,0x4
ffffffffc020a6b0:	61c68693          	addi	a3,a3,1564 # ffffffffc020ecc8 <dev_node_ops+0x120>
ffffffffc020a6b4:	00001617          	auipc	a2,0x1
ffffffffc020a6b8:	15460613          	addi	a2,a2,340 # ffffffffc020b808 <commands+0x60>
ffffffffc020a6bc:	03600593          	li	a1,54
ffffffffc020a6c0:	00005517          	auipc	a0,0x5
ffffffffc020a6c4:	a0850513          	addi	a0,a0,-1528 # ffffffffc020f0c8 <sfs_node_fileops+0x80>
ffffffffc020a6c8:	b67f50ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020a6cc:	86aa                	mv	a3,a0
ffffffffc020a6ce:	00005617          	auipc	a2,0x5
ffffffffc020a6d2:	a6a60613          	addi	a2,a2,-1430 # ffffffffc020f138 <sfs_node_fileops+0xf0>
ffffffffc020a6d6:	03700593          	li	a1,55
ffffffffc020a6da:	00005517          	auipc	a0,0x5
ffffffffc020a6de:	9ee50513          	addi	a0,a0,-1554 # ffffffffc020f0c8 <sfs_node_fileops+0x80>
ffffffffc020a6e2:	b4df50ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020a6e6 <sfs_do_mount>:
ffffffffc020a6e6:	6518                	ld	a4,8(a0)
ffffffffc020a6e8:	7171                	addi	sp,sp,-176
ffffffffc020a6ea:	f506                	sd	ra,168(sp)
ffffffffc020a6ec:	f122                	sd	s0,160(sp)
ffffffffc020a6ee:	ed26                	sd	s1,152(sp)
ffffffffc020a6f0:	e94a                	sd	s2,144(sp)
ffffffffc020a6f2:	e54e                	sd	s3,136(sp)
ffffffffc020a6f4:	e152                	sd	s4,128(sp)
ffffffffc020a6f6:	fcd6                	sd	s5,120(sp)
ffffffffc020a6f8:	f8da                	sd	s6,112(sp)
ffffffffc020a6fa:	f4de                	sd	s7,104(sp)
ffffffffc020a6fc:	f0e2                	sd	s8,96(sp)
ffffffffc020a6fe:	ece6                	sd	s9,88(sp)
ffffffffc020a700:	e8ea                	sd	s10,80(sp)
ffffffffc020a702:	e4ee                	sd	s11,72(sp)
ffffffffc020a704:	6785                	lui	a5,0x1
ffffffffc020a706:	24f71663          	bne	a4,a5,ffffffffc020a952 <sfs_do_mount+0x26c>
ffffffffc020a70a:	892a                	mv	s2,a0
ffffffffc020a70c:	4501                	li	a0,0
ffffffffc020a70e:	8aae                	mv	s5,a1
ffffffffc020a710:	cadfd0ef          	jal	ra,ffffffffc02083bc <__alloc_fs>
ffffffffc020a714:	842a                	mv	s0,a0
ffffffffc020a716:	24050463          	beqz	a0,ffffffffc020a95e <sfs_do_mount+0x278>
ffffffffc020a71a:	0b052b03          	lw	s6,176(a0)
ffffffffc020a71e:	260b1263          	bnez	s6,ffffffffc020a982 <sfs_do_mount+0x29c>
ffffffffc020a722:	03253823          	sd	s2,48(a0)
ffffffffc020a726:	6505                	lui	a0,0x1
ffffffffc020a728:	89ef90ef          	jal	ra,ffffffffc02037c6 <kmalloc>
ffffffffc020a72c:	e428                	sd	a0,72(s0)
ffffffffc020a72e:	84aa                	mv	s1,a0
ffffffffc020a730:	16050363          	beqz	a0,ffffffffc020a896 <sfs_do_mount+0x1b0>
ffffffffc020a734:	85aa                	mv	a1,a0
ffffffffc020a736:	4681                	li	a3,0
ffffffffc020a738:	6605                	lui	a2,0x1
ffffffffc020a73a:	1008                	addi	a0,sp,32
ffffffffc020a73c:	ff5fa0ef          	jal	ra,ffffffffc0205730 <iobuf_init>
ffffffffc020a740:	02093783          	ld	a5,32(s2)
ffffffffc020a744:	85aa                	mv	a1,a0
ffffffffc020a746:	4601                	li	a2,0
ffffffffc020a748:	854a                	mv	a0,s2
ffffffffc020a74a:	9782                	jalr	a5
ffffffffc020a74c:	8a2a                	mv	s4,a0
ffffffffc020a74e:	10051e63          	bnez	a0,ffffffffc020a86a <sfs_do_mount+0x184>
ffffffffc020a752:	408c                	lw	a1,0(s1)
ffffffffc020a754:	2f8dc637          	lui	a2,0x2f8dc
ffffffffc020a758:	e2a60613          	addi	a2,a2,-470 # 2f8dbe2a <_binary_bin_sfs_img_size+0x2f866b2a>
ffffffffc020a75c:	14c59863          	bne	a1,a2,ffffffffc020a8ac <sfs_do_mount+0x1c6>
ffffffffc020a760:	40dc                	lw	a5,4(s1)
ffffffffc020a762:	00093603          	ld	a2,0(s2)
ffffffffc020a766:	02079713          	slli	a4,a5,0x20
ffffffffc020a76a:	9301                	srli	a4,a4,0x20
ffffffffc020a76c:	12e66763          	bltu	a2,a4,ffffffffc020a89a <sfs_do_mount+0x1b4>
ffffffffc020a770:	020485a3          	sb	zero,43(s1)
ffffffffc020a774:	0084af03          	lw	t5,8(s1)
ffffffffc020a778:	00c4ae83          	lw	t4,12(s1)
ffffffffc020a77c:	0104ae03          	lw	t3,16(s1)
ffffffffc020a780:	0144a303          	lw	t1,20(s1)
ffffffffc020a784:	0184a883          	lw	a7,24(s1)
ffffffffc020a788:	01c4a803          	lw	a6,28(s1)
ffffffffc020a78c:	5090                	lw	a2,32(s1)
ffffffffc020a78e:	50d4                	lw	a3,36(s1)
ffffffffc020a790:	5498                	lw	a4,40(s1)
ffffffffc020a792:	6511                	lui	a0,0x4
ffffffffc020a794:	c00c                	sw	a1,0(s0)
ffffffffc020a796:	c05c                	sw	a5,4(s0)
ffffffffc020a798:	01e42423          	sw	t5,8(s0)
ffffffffc020a79c:	01d42623          	sw	t4,12(s0)
ffffffffc020a7a0:	01c42823          	sw	t3,16(s0)
ffffffffc020a7a4:	00642a23          	sw	t1,20(s0)
ffffffffc020a7a8:	01142c23          	sw	a7,24(s0)
ffffffffc020a7ac:	01042e23          	sw	a6,28(s0)
ffffffffc020a7b0:	d010                	sw	a2,32(s0)
ffffffffc020a7b2:	d054                	sw	a3,36(s0)
ffffffffc020a7b4:	d418                	sw	a4,40(s0)
ffffffffc020a7b6:	810f90ef          	jal	ra,ffffffffc02037c6 <kmalloc>
ffffffffc020a7ba:	f448                	sd	a0,168(s0)
ffffffffc020a7bc:	8c2a                	mv	s8,a0
ffffffffc020a7be:	18050c63          	beqz	a0,ffffffffc020a956 <sfs_do_mount+0x270>
ffffffffc020a7c2:	6711                	lui	a4,0x4
ffffffffc020a7c4:	87aa                	mv	a5,a0
ffffffffc020a7c6:	972a                	add	a4,a4,a0
ffffffffc020a7c8:	e79c                	sd	a5,8(a5)
ffffffffc020a7ca:	e39c                	sd	a5,0(a5)
ffffffffc020a7cc:	07c1                	addi	a5,a5,16
ffffffffc020a7ce:	fee79de3          	bne	a5,a4,ffffffffc020a7c8 <sfs_do_mount+0xe2>
ffffffffc020a7d2:	0044eb83          	lwu	s7,4(s1)
ffffffffc020a7d6:	67a1                	lui	a5,0x8
ffffffffc020a7d8:	fff78993          	addi	s3,a5,-1 # 7fff <_binary_bin_swap_img_size+0x2ff>
ffffffffc020a7dc:	9bce                	add	s7,s7,s3
ffffffffc020a7de:	77e1                	lui	a5,0xffff8
ffffffffc020a7e0:	00fbfbb3          	and	s7,s7,a5
ffffffffc020a7e4:	2b81                	sext.w	s7,s7
ffffffffc020a7e6:	855e                	mv	a0,s7
ffffffffc020a7e8:	20a000ef          	jal	ra,ffffffffc020a9f2 <bitmap_create>
ffffffffc020a7ec:	fc08                	sd	a0,56(s0)
ffffffffc020a7ee:	8d2a                	mv	s10,a0
ffffffffc020a7f0:	14050f63          	beqz	a0,ffffffffc020a94e <sfs_do_mount+0x268>
ffffffffc020a7f4:	0044e783          	lwu	a5,4(s1)
ffffffffc020a7f8:	082c                	addi	a1,sp,24
ffffffffc020a7fa:	97ce                	add	a5,a5,s3
ffffffffc020a7fc:	00f7d713          	srli	a4,a5,0xf
ffffffffc020a800:	e43a                	sd	a4,8(sp)
ffffffffc020a802:	40f7d993          	srai	s3,a5,0xf
ffffffffc020a806:	400000ef          	jal	ra,ffffffffc020ac06 <bitmap_getdata>
ffffffffc020a80a:	14050c63          	beqz	a0,ffffffffc020a962 <sfs_do_mount+0x27c>
ffffffffc020a80e:	00c9979b          	slliw	a5,s3,0xc
ffffffffc020a812:	66e2                	ld	a3,24(sp)
ffffffffc020a814:	1782                	slli	a5,a5,0x20
ffffffffc020a816:	9381                	srli	a5,a5,0x20
ffffffffc020a818:	14d79563          	bne	a5,a3,ffffffffc020a962 <sfs_do_mount+0x27c>
ffffffffc020a81c:	6722                	ld	a4,8(sp)
ffffffffc020a81e:	6d89                	lui	s11,0x2
ffffffffc020a820:	89aa                	mv	s3,a0
ffffffffc020a822:	00c71c93          	slli	s9,a4,0xc
ffffffffc020a826:	9caa                	add	s9,s9,a0
ffffffffc020a828:	40ad8dbb          	subw	s11,s11,a0
ffffffffc020a82c:	e711                	bnez	a4,ffffffffc020a838 <sfs_do_mount+0x152>
ffffffffc020a82e:	a079                	j	ffffffffc020a8bc <sfs_do_mount+0x1d6>
ffffffffc020a830:	6785                	lui	a5,0x1
ffffffffc020a832:	99be                	add	s3,s3,a5
ffffffffc020a834:	093c8463          	beq	s9,s3,ffffffffc020a8bc <sfs_do_mount+0x1d6>
ffffffffc020a838:	013d86bb          	addw	a3,s11,s3
ffffffffc020a83c:	1682                	slli	a3,a3,0x20
ffffffffc020a83e:	6605                	lui	a2,0x1
ffffffffc020a840:	85ce                	mv	a1,s3
ffffffffc020a842:	9281                	srli	a3,a3,0x20
ffffffffc020a844:	1008                	addi	a0,sp,32
ffffffffc020a846:	eebfa0ef          	jal	ra,ffffffffc0205730 <iobuf_init>
ffffffffc020a84a:	02093783          	ld	a5,32(s2)
ffffffffc020a84e:	85aa                	mv	a1,a0
ffffffffc020a850:	4601                	li	a2,0
ffffffffc020a852:	854a                	mv	a0,s2
ffffffffc020a854:	9782                	jalr	a5
ffffffffc020a856:	dd69                	beqz	a0,ffffffffc020a830 <sfs_do_mount+0x14a>
ffffffffc020a858:	e42a                	sd	a0,8(sp)
ffffffffc020a85a:	856a                	mv	a0,s10
ffffffffc020a85c:	390000ef          	jal	ra,ffffffffc020abec <bitmap_destroy>
ffffffffc020a860:	67a2                	ld	a5,8(sp)
ffffffffc020a862:	8a3e                	mv	s4,a5
ffffffffc020a864:	8562                	mv	a0,s8
ffffffffc020a866:	810f90ef          	jal	ra,ffffffffc0203876 <kfree>
ffffffffc020a86a:	8526                	mv	a0,s1
ffffffffc020a86c:	80af90ef          	jal	ra,ffffffffc0203876 <kfree>
ffffffffc020a870:	8522                	mv	a0,s0
ffffffffc020a872:	804f90ef          	jal	ra,ffffffffc0203876 <kfree>
ffffffffc020a876:	70aa                	ld	ra,168(sp)
ffffffffc020a878:	740a                	ld	s0,160(sp)
ffffffffc020a87a:	64ea                	ld	s1,152(sp)
ffffffffc020a87c:	694a                	ld	s2,144(sp)
ffffffffc020a87e:	69aa                	ld	s3,136(sp)
ffffffffc020a880:	7ae6                	ld	s5,120(sp)
ffffffffc020a882:	7b46                	ld	s6,112(sp)
ffffffffc020a884:	7ba6                	ld	s7,104(sp)
ffffffffc020a886:	7c06                	ld	s8,96(sp)
ffffffffc020a888:	6ce6                	ld	s9,88(sp)
ffffffffc020a88a:	6d46                	ld	s10,80(sp)
ffffffffc020a88c:	6da6                	ld	s11,72(sp)
ffffffffc020a88e:	8552                	mv	a0,s4
ffffffffc020a890:	6a0a                	ld	s4,128(sp)
ffffffffc020a892:	614d                	addi	sp,sp,176
ffffffffc020a894:	8082                	ret
ffffffffc020a896:	5a71                	li	s4,-4
ffffffffc020a898:	bfe1                	j	ffffffffc020a870 <sfs_do_mount+0x18a>
ffffffffc020a89a:	85be                	mv	a1,a5
ffffffffc020a89c:	00005517          	auipc	a0,0x5
ffffffffc020a8a0:	8f450513          	addi	a0,a0,-1804 # ffffffffc020f190 <sfs_node_fileops+0x148>
ffffffffc020a8a4:	887f50ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc020a8a8:	5a75                	li	s4,-3
ffffffffc020a8aa:	b7c1                	j	ffffffffc020a86a <sfs_do_mount+0x184>
ffffffffc020a8ac:	00005517          	auipc	a0,0x5
ffffffffc020a8b0:	8ac50513          	addi	a0,a0,-1876 # ffffffffc020f158 <sfs_node_fileops+0x110>
ffffffffc020a8b4:	877f50ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc020a8b8:	5a75                	li	s4,-3
ffffffffc020a8ba:	bf45                	j	ffffffffc020a86a <sfs_do_mount+0x184>
ffffffffc020a8bc:	00442903          	lw	s2,4(s0)
ffffffffc020a8c0:	4481                	li	s1,0
ffffffffc020a8c2:	080b8c63          	beqz	s7,ffffffffc020a95a <sfs_do_mount+0x274>
ffffffffc020a8c6:	85a6                	mv	a1,s1
ffffffffc020a8c8:	856a                	mv	a0,s10
ffffffffc020a8ca:	2a8000ef          	jal	ra,ffffffffc020ab72 <bitmap_test>
ffffffffc020a8ce:	c111                	beqz	a0,ffffffffc020a8d2 <sfs_do_mount+0x1ec>
ffffffffc020a8d0:	2b05                	addiw	s6,s6,1
ffffffffc020a8d2:	2485                	addiw	s1,s1,1
ffffffffc020a8d4:	fe9b99e3          	bne	s7,s1,ffffffffc020a8c6 <sfs_do_mount+0x1e0>
ffffffffc020a8d8:	441c                	lw	a5,8(s0)
ffffffffc020a8da:	0d679463          	bne	a5,s6,ffffffffc020a9a2 <sfs_do_mount+0x2bc>
ffffffffc020a8de:	4585                	li	a1,1
ffffffffc020a8e0:	05040513          	addi	a0,s0,80
ffffffffc020a8e4:	04043023          	sd	zero,64(s0)
ffffffffc020a8e8:	e5bf90ef          	jal	ra,ffffffffc0204742 <sem_init>
ffffffffc020a8ec:	4585                	li	a1,1
ffffffffc020a8ee:	06840513          	addi	a0,s0,104
ffffffffc020a8f2:	e51f90ef          	jal	ra,ffffffffc0204742 <sem_init>
ffffffffc020a8f6:	4585                	li	a1,1
ffffffffc020a8f8:	08040513          	addi	a0,s0,128
ffffffffc020a8fc:	e47f90ef          	jal	ra,ffffffffc0204742 <sem_init>
ffffffffc020a900:	09840793          	addi	a5,s0,152
ffffffffc020a904:	f05c                	sd	a5,160(s0)
ffffffffc020a906:	ec5c                	sd	a5,152(s0)
ffffffffc020a908:	874a                	mv	a4,s2
ffffffffc020a90a:	86da                	mv	a3,s6
ffffffffc020a90c:	4169063b          	subw	a2,s2,s6
ffffffffc020a910:	00c40593          	addi	a1,s0,12
ffffffffc020a914:	00005517          	auipc	a0,0x5
ffffffffc020a918:	90c50513          	addi	a0,a0,-1780 # ffffffffc020f220 <sfs_node_fileops+0x1d8>
ffffffffc020a91c:	80ff50ef          	jal	ra,ffffffffc020012a <cprintf>
ffffffffc020a920:	00000797          	auipc	a5,0x0
ffffffffc020a924:	c8878793          	addi	a5,a5,-888 # ffffffffc020a5a8 <sfs_sync>
ffffffffc020a928:	fc5c                	sd	a5,184(s0)
ffffffffc020a92a:	00000797          	auipc	a5,0x0
ffffffffc020a92e:	d6478793          	addi	a5,a5,-668 # ffffffffc020a68e <sfs_get_root>
ffffffffc020a932:	e07c                	sd	a5,192(s0)
ffffffffc020a934:	00000797          	auipc	a5,0x0
ffffffffc020a938:	b5e78793          	addi	a5,a5,-1186 # ffffffffc020a492 <sfs_unmount>
ffffffffc020a93c:	e47c                	sd	a5,200(s0)
ffffffffc020a93e:	00000797          	auipc	a5,0x0
ffffffffc020a942:	bd878793          	addi	a5,a5,-1064 # ffffffffc020a516 <sfs_cleanup>
ffffffffc020a946:	e87c                	sd	a5,208(s0)
ffffffffc020a948:	008ab023          	sd	s0,0(s5)
ffffffffc020a94c:	b72d                	j	ffffffffc020a876 <sfs_do_mount+0x190>
ffffffffc020a94e:	5a71                	li	s4,-4
ffffffffc020a950:	bf11                	j	ffffffffc020a864 <sfs_do_mount+0x17e>
ffffffffc020a952:	5a49                	li	s4,-14
ffffffffc020a954:	b70d                	j	ffffffffc020a876 <sfs_do_mount+0x190>
ffffffffc020a956:	5a71                	li	s4,-4
ffffffffc020a958:	bf09                	j	ffffffffc020a86a <sfs_do_mount+0x184>
ffffffffc020a95a:	4b01                	li	s6,0
ffffffffc020a95c:	bfb5                	j	ffffffffc020a8d8 <sfs_do_mount+0x1f2>
ffffffffc020a95e:	5a71                	li	s4,-4
ffffffffc020a960:	bf19                	j	ffffffffc020a876 <sfs_do_mount+0x190>
ffffffffc020a962:	00005697          	auipc	a3,0x5
ffffffffc020a966:	85e68693          	addi	a3,a3,-1954 # ffffffffc020f1c0 <sfs_node_fileops+0x178>
ffffffffc020a96a:	00001617          	auipc	a2,0x1
ffffffffc020a96e:	e9e60613          	addi	a2,a2,-354 # ffffffffc020b808 <commands+0x60>
ffffffffc020a972:	08300593          	li	a1,131
ffffffffc020a976:	00004517          	auipc	a0,0x4
ffffffffc020a97a:	75250513          	addi	a0,a0,1874 # ffffffffc020f0c8 <sfs_node_fileops+0x80>
ffffffffc020a97e:	8b1f50ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020a982:	00004697          	auipc	a3,0x4
ffffffffc020a986:	34668693          	addi	a3,a3,838 # ffffffffc020ecc8 <dev_node_ops+0x120>
ffffffffc020a98a:	00001617          	auipc	a2,0x1
ffffffffc020a98e:	e7e60613          	addi	a2,a2,-386 # ffffffffc020b808 <commands+0x60>
ffffffffc020a992:	0a300593          	li	a1,163
ffffffffc020a996:	00004517          	auipc	a0,0x4
ffffffffc020a99a:	73250513          	addi	a0,a0,1842 # ffffffffc020f0c8 <sfs_node_fileops+0x80>
ffffffffc020a99e:	891f50ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020a9a2:	00005697          	auipc	a3,0x5
ffffffffc020a9a6:	84e68693          	addi	a3,a3,-1970 # ffffffffc020f1f0 <sfs_node_fileops+0x1a8>
ffffffffc020a9aa:	00001617          	auipc	a2,0x1
ffffffffc020a9ae:	e5e60613          	addi	a2,a2,-418 # ffffffffc020b808 <commands+0x60>
ffffffffc020a9b2:	0e000593          	li	a1,224
ffffffffc020a9b6:	00004517          	auipc	a0,0x4
ffffffffc020a9ba:	71250513          	addi	a0,a0,1810 # ffffffffc020f0c8 <sfs_node_fileops+0x80>
ffffffffc020a9be:	871f50ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020a9c2 <sfs_mount>:
ffffffffc020a9c2:	00000597          	auipc	a1,0x0
ffffffffc020a9c6:	d2458593          	addi	a1,a1,-732 # ffffffffc020a6e6 <sfs_do_mount>
ffffffffc020a9ca:	8aafd06f          	j	ffffffffc0207a74 <vfs_mount>

ffffffffc020a9ce <bitmap_translate.part.0>:
ffffffffc020a9ce:	1141                	addi	sp,sp,-16
ffffffffc020a9d0:	00005697          	auipc	a3,0x5
ffffffffc020a9d4:	87068693          	addi	a3,a3,-1936 # ffffffffc020f240 <sfs_node_fileops+0x1f8>
ffffffffc020a9d8:	00001617          	auipc	a2,0x1
ffffffffc020a9dc:	e3060613          	addi	a2,a2,-464 # ffffffffc020b808 <commands+0x60>
ffffffffc020a9e0:	04c00593          	li	a1,76
ffffffffc020a9e4:	00005517          	auipc	a0,0x5
ffffffffc020a9e8:	87450513          	addi	a0,a0,-1932 # ffffffffc020f258 <sfs_node_fileops+0x210>
ffffffffc020a9ec:	e406                	sd	ra,8(sp)
ffffffffc020a9ee:	841f50ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020a9f2 <bitmap_create>:
ffffffffc020a9f2:	7139                	addi	sp,sp,-64
ffffffffc020a9f4:	fc06                	sd	ra,56(sp)
ffffffffc020a9f6:	f822                	sd	s0,48(sp)
ffffffffc020a9f8:	f426                	sd	s1,40(sp)
ffffffffc020a9fa:	f04a                	sd	s2,32(sp)
ffffffffc020a9fc:	ec4e                	sd	s3,24(sp)
ffffffffc020a9fe:	e852                	sd	s4,16(sp)
ffffffffc020aa00:	e456                	sd	s5,8(sp)
ffffffffc020aa02:	c14d                	beqz	a0,ffffffffc020aaa4 <bitmap_create+0xb2>
ffffffffc020aa04:	842a                	mv	s0,a0
ffffffffc020aa06:	4541                	li	a0,16
ffffffffc020aa08:	dbff80ef          	jal	ra,ffffffffc02037c6 <kmalloc>
ffffffffc020aa0c:	84aa                	mv	s1,a0
ffffffffc020aa0e:	cd25                	beqz	a0,ffffffffc020aa86 <bitmap_create+0x94>
ffffffffc020aa10:	02041a13          	slli	s4,s0,0x20
ffffffffc020aa14:	020a5a13          	srli	s4,s4,0x20
ffffffffc020aa18:	01fa0793          	addi	a5,s4,31
ffffffffc020aa1c:	0057d993          	srli	s3,a5,0x5
ffffffffc020aa20:	00299a93          	slli	s5,s3,0x2
ffffffffc020aa24:	8556                	mv	a0,s5
ffffffffc020aa26:	894e                	mv	s2,s3
ffffffffc020aa28:	d9ff80ef          	jal	ra,ffffffffc02037c6 <kmalloc>
ffffffffc020aa2c:	c53d                	beqz	a0,ffffffffc020aa9a <bitmap_create+0xa8>
ffffffffc020aa2e:	0134a223          	sw	s3,4(s1)
ffffffffc020aa32:	c080                	sw	s0,0(s1)
ffffffffc020aa34:	8656                	mv	a2,s5
ffffffffc020aa36:	0ff00593          	li	a1,255
ffffffffc020aa3a:	5c4000ef          	jal	ra,ffffffffc020affe <memset>
ffffffffc020aa3e:	e488                	sd	a0,8(s1)
ffffffffc020aa40:	0996                	slli	s3,s3,0x5
ffffffffc020aa42:	053a0263          	beq	s4,s3,ffffffffc020aa86 <bitmap_create+0x94>
ffffffffc020aa46:	fff9079b          	addiw	a5,s2,-1
ffffffffc020aa4a:	0057969b          	slliw	a3,a5,0x5
ffffffffc020aa4e:	0054561b          	srliw	a2,s0,0x5
ffffffffc020aa52:	40d4073b          	subw	a4,s0,a3
ffffffffc020aa56:	0054541b          	srliw	s0,s0,0x5
ffffffffc020aa5a:	08f61463          	bne	a2,a5,ffffffffc020aae2 <bitmap_create+0xf0>
ffffffffc020aa5e:	fff7069b          	addiw	a3,a4,-1
ffffffffc020aa62:	47f9                	li	a5,30
ffffffffc020aa64:	04d7ef63          	bltu	a5,a3,ffffffffc020aac2 <bitmap_create+0xd0>
ffffffffc020aa68:	1402                	slli	s0,s0,0x20
ffffffffc020aa6a:	8079                	srli	s0,s0,0x1e
ffffffffc020aa6c:	9522                	add	a0,a0,s0
ffffffffc020aa6e:	411c                	lw	a5,0(a0)
ffffffffc020aa70:	4585                	li	a1,1
ffffffffc020aa72:	02000613          	li	a2,32
ffffffffc020aa76:	00e596bb          	sllw	a3,a1,a4
ffffffffc020aa7a:	8fb5                	xor	a5,a5,a3
ffffffffc020aa7c:	2705                	addiw	a4,a4,1
ffffffffc020aa7e:	2781                	sext.w	a5,a5
ffffffffc020aa80:	fec71be3          	bne	a4,a2,ffffffffc020aa76 <bitmap_create+0x84>
ffffffffc020aa84:	c11c                	sw	a5,0(a0)
ffffffffc020aa86:	70e2                	ld	ra,56(sp)
ffffffffc020aa88:	7442                	ld	s0,48(sp)
ffffffffc020aa8a:	7902                	ld	s2,32(sp)
ffffffffc020aa8c:	69e2                	ld	s3,24(sp)
ffffffffc020aa8e:	6a42                	ld	s4,16(sp)
ffffffffc020aa90:	6aa2                	ld	s5,8(sp)
ffffffffc020aa92:	8526                	mv	a0,s1
ffffffffc020aa94:	74a2                	ld	s1,40(sp)
ffffffffc020aa96:	6121                	addi	sp,sp,64
ffffffffc020aa98:	8082                	ret
ffffffffc020aa9a:	8526                	mv	a0,s1
ffffffffc020aa9c:	ddbf80ef          	jal	ra,ffffffffc0203876 <kfree>
ffffffffc020aaa0:	4481                	li	s1,0
ffffffffc020aaa2:	b7d5                	j	ffffffffc020aa86 <bitmap_create+0x94>
ffffffffc020aaa4:	00004697          	auipc	a3,0x4
ffffffffc020aaa8:	7cc68693          	addi	a3,a3,1996 # ffffffffc020f270 <sfs_node_fileops+0x228>
ffffffffc020aaac:	00001617          	auipc	a2,0x1
ffffffffc020aab0:	d5c60613          	addi	a2,a2,-676 # ffffffffc020b808 <commands+0x60>
ffffffffc020aab4:	45d5                	li	a1,21
ffffffffc020aab6:	00004517          	auipc	a0,0x4
ffffffffc020aaba:	7a250513          	addi	a0,a0,1954 # ffffffffc020f258 <sfs_node_fileops+0x210>
ffffffffc020aabe:	f70f50ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020aac2:	00004697          	auipc	a3,0x4
ffffffffc020aac6:	7ee68693          	addi	a3,a3,2030 # ffffffffc020f2b0 <sfs_node_fileops+0x268>
ffffffffc020aaca:	00001617          	auipc	a2,0x1
ffffffffc020aace:	d3e60613          	addi	a2,a2,-706 # ffffffffc020b808 <commands+0x60>
ffffffffc020aad2:	02b00593          	li	a1,43
ffffffffc020aad6:	00004517          	auipc	a0,0x4
ffffffffc020aada:	78250513          	addi	a0,a0,1922 # ffffffffc020f258 <sfs_node_fileops+0x210>
ffffffffc020aade:	f50f50ef          	jal	ra,ffffffffc020022e <__panic>
ffffffffc020aae2:	00004697          	auipc	a3,0x4
ffffffffc020aae6:	7b668693          	addi	a3,a3,1974 # ffffffffc020f298 <sfs_node_fileops+0x250>
ffffffffc020aaea:	00001617          	auipc	a2,0x1
ffffffffc020aaee:	d1e60613          	addi	a2,a2,-738 # ffffffffc020b808 <commands+0x60>
ffffffffc020aaf2:	02a00593          	li	a1,42
ffffffffc020aaf6:	00004517          	auipc	a0,0x4
ffffffffc020aafa:	76250513          	addi	a0,a0,1890 # ffffffffc020f258 <sfs_node_fileops+0x210>
ffffffffc020aafe:	f30f50ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020ab02 <bitmap_alloc>:
ffffffffc020ab02:	4150                	lw	a2,4(a0)
ffffffffc020ab04:	651c                	ld	a5,8(a0)
ffffffffc020ab06:	c231                	beqz	a2,ffffffffc020ab4a <bitmap_alloc+0x48>
ffffffffc020ab08:	4701                	li	a4,0
ffffffffc020ab0a:	a029                	j	ffffffffc020ab14 <bitmap_alloc+0x12>
ffffffffc020ab0c:	2705                	addiw	a4,a4,1
ffffffffc020ab0e:	0791                	addi	a5,a5,4
ffffffffc020ab10:	02e60d63          	beq	a2,a4,ffffffffc020ab4a <bitmap_alloc+0x48>
ffffffffc020ab14:	4394                	lw	a3,0(a5)
ffffffffc020ab16:	dafd                	beqz	a3,ffffffffc020ab0c <bitmap_alloc+0xa>
ffffffffc020ab18:	4501                	li	a0,0
ffffffffc020ab1a:	4885                	li	a7,1
ffffffffc020ab1c:	8e36                	mv	t3,a3
ffffffffc020ab1e:	02000313          	li	t1,32
ffffffffc020ab22:	a021                	j	ffffffffc020ab2a <bitmap_alloc+0x28>
ffffffffc020ab24:	2505                	addiw	a0,a0,1
ffffffffc020ab26:	02650463          	beq	a0,t1,ffffffffc020ab4e <bitmap_alloc+0x4c>
ffffffffc020ab2a:	00a8983b          	sllw	a6,a7,a0
ffffffffc020ab2e:	0106f633          	and	a2,a3,a6
ffffffffc020ab32:	2601                	sext.w	a2,a2
ffffffffc020ab34:	da65                	beqz	a2,ffffffffc020ab24 <bitmap_alloc+0x22>
ffffffffc020ab36:	010e4833          	xor	a6,t3,a6
ffffffffc020ab3a:	0057171b          	slliw	a4,a4,0x5
ffffffffc020ab3e:	9f29                	addw	a4,a4,a0
ffffffffc020ab40:	0107a023          	sw	a6,0(a5)
ffffffffc020ab44:	c198                	sw	a4,0(a1)
ffffffffc020ab46:	4501                	li	a0,0
ffffffffc020ab48:	8082                	ret
ffffffffc020ab4a:	5571                	li	a0,-4
ffffffffc020ab4c:	8082                	ret
ffffffffc020ab4e:	1141                	addi	sp,sp,-16
ffffffffc020ab50:	00002697          	auipc	a3,0x2
ffffffffc020ab54:	a5868693          	addi	a3,a3,-1448 # ffffffffc020c5a8 <commands+0xe00>
ffffffffc020ab58:	00001617          	auipc	a2,0x1
ffffffffc020ab5c:	cb060613          	addi	a2,a2,-848 # ffffffffc020b808 <commands+0x60>
ffffffffc020ab60:	04300593          	li	a1,67
ffffffffc020ab64:	00004517          	auipc	a0,0x4
ffffffffc020ab68:	6f450513          	addi	a0,a0,1780 # ffffffffc020f258 <sfs_node_fileops+0x210>
ffffffffc020ab6c:	e406                	sd	ra,8(sp)
ffffffffc020ab6e:	ec0f50ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020ab72 <bitmap_test>:
ffffffffc020ab72:	411c                	lw	a5,0(a0)
ffffffffc020ab74:	00f5ff63          	bgeu	a1,a5,ffffffffc020ab92 <bitmap_test+0x20>
ffffffffc020ab78:	651c                	ld	a5,8(a0)
ffffffffc020ab7a:	0055d71b          	srliw	a4,a1,0x5
ffffffffc020ab7e:	070a                	slli	a4,a4,0x2
ffffffffc020ab80:	97ba                	add	a5,a5,a4
ffffffffc020ab82:	4388                	lw	a0,0(a5)
ffffffffc020ab84:	4785                	li	a5,1
ffffffffc020ab86:	00b795bb          	sllw	a1,a5,a1
ffffffffc020ab8a:	8d6d                	and	a0,a0,a1
ffffffffc020ab8c:	1502                	slli	a0,a0,0x20
ffffffffc020ab8e:	9101                	srli	a0,a0,0x20
ffffffffc020ab90:	8082                	ret
ffffffffc020ab92:	1141                	addi	sp,sp,-16
ffffffffc020ab94:	e406                	sd	ra,8(sp)
ffffffffc020ab96:	e39ff0ef          	jal	ra,ffffffffc020a9ce <bitmap_translate.part.0>

ffffffffc020ab9a <bitmap_free>:
ffffffffc020ab9a:	411c                	lw	a5,0(a0)
ffffffffc020ab9c:	1141                	addi	sp,sp,-16
ffffffffc020ab9e:	e406                	sd	ra,8(sp)
ffffffffc020aba0:	02f5f463          	bgeu	a1,a5,ffffffffc020abc8 <bitmap_free+0x2e>
ffffffffc020aba4:	651c                	ld	a5,8(a0)
ffffffffc020aba6:	0055d71b          	srliw	a4,a1,0x5
ffffffffc020abaa:	070a                	slli	a4,a4,0x2
ffffffffc020abac:	97ba                	add	a5,a5,a4
ffffffffc020abae:	4398                	lw	a4,0(a5)
ffffffffc020abb0:	4685                	li	a3,1
ffffffffc020abb2:	00b695bb          	sllw	a1,a3,a1
ffffffffc020abb6:	00b776b3          	and	a3,a4,a1
ffffffffc020abba:	2681                	sext.w	a3,a3
ffffffffc020abbc:	ea81                	bnez	a3,ffffffffc020abcc <bitmap_free+0x32>
ffffffffc020abbe:	60a2                	ld	ra,8(sp)
ffffffffc020abc0:	8f4d                	or	a4,a4,a1
ffffffffc020abc2:	c398                	sw	a4,0(a5)
ffffffffc020abc4:	0141                	addi	sp,sp,16
ffffffffc020abc6:	8082                	ret
ffffffffc020abc8:	e07ff0ef          	jal	ra,ffffffffc020a9ce <bitmap_translate.part.0>
ffffffffc020abcc:	00004697          	auipc	a3,0x4
ffffffffc020abd0:	70c68693          	addi	a3,a3,1804 # ffffffffc020f2d8 <sfs_node_fileops+0x290>
ffffffffc020abd4:	00001617          	auipc	a2,0x1
ffffffffc020abd8:	c3460613          	addi	a2,a2,-972 # ffffffffc020b808 <commands+0x60>
ffffffffc020abdc:	05f00593          	li	a1,95
ffffffffc020abe0:	00004517          	auipc	a0,0x4
ffffffffc020abe4:	67850513          	addi	a0,a0,1656 # ffffffffc020f258 <sfs_node_fileops+0x210>
ffffffffc020abe8:	e46f50ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020abec <bitmap_destroy>:
ffffffffc020abec:	1141                	addi	sp,sp,-16
ffffffffc020abee:	e022                	sd	s0,0(sp)
ffffffffc020abf0:	842a                	mv	s0,a0
ffffffffc020abf2:	6508                	ld	a0,8(a0)
ffffffffc020abf4:	e406                	sd	ra,8(sp)
ffffffffc020abf6:	c81f80ef          	jal	ra,ffffffffc0203876 <kfree>
ffffffffc020abfa:	8522                	mv	a0,s0
ffffffffc020abfc:	6402                	ld	s0,0(sp)
ffffffffc020abfe:	60a2                	ld	ra,8(sp)
ffffffffc020ac00:	0141                	addi	sp,sp,16
ffffffffc020ac02:	c75f806f          	j	ffffffffc0203876 <kfree>

ffffffffc020ac06 <bitmap_getdata>:
ffffffffc020ac06:	c589                	beqz	a1,ffffffffc020ac10 <bitmap_getdata+0xa>
ffffffffc020ac08:	00456783          	lwu	a5,4(a0)
ffffffffc020ac0c:	078a                	slli	a5,a5,0x2
ffffffffc020ac0e:	e19c                	sd	a5,0(a1)
ffffffffc020ac10:	6508                	ld	a0,8(a0)
ffffffffc020ac12:	8082                	ret

ffffffffc020ac14 <sfs_rwblock_nolock>:
ffffffffc020ac14:	7139                	addi	sp,sp,-64
ffffffffc020ac16:	f822                	sd	s0,48(sp)
ffffffffc020ac18:	f426                	sd	s1,40(sp)
ffffffffc020ac1a:	fc06                	sd	ra,56(sp)
ffffffffc020ac1c:	842a                	mv	s0,a0
ffffffffc020ac1e:	84b6                	mv	s1,a3
ffffffffc020ac20:	e211                	bnez	a2,ffffffffc020ac24 <sfs_rwblock_nolock+0x10>
ffffffffc020ac22:	e715                	bnez	a4,ffffffffc020ac4e <sfs_rwblock_nolock+0x3a>
ffffffffc020ac24:	405c                	lw	a5,4(s0)
ffffffffc020ac26:	02f67463          	bgeu	a2,a5,ffffffffc020ac4e <sfs_rwblock_nolock+0x3a>
ffffffffc020ac2a:	00c6169b          	slliw	a3,a2,0xc
ffffffffc020ac2e:	1682                	slli	a3,a3,0x20
ffffffffc020ac30:	6605                	lui	a2,0x1
ffffffffc020ac32:	9281                	srli	a3,a3,0x20
ffffffffc020ac34:	850a                	mv	a0,sp
ffffffffc020ac36:	afbfa0ef          	jal	ra,ffffffffc0205730 <iobuf_init>
ffffffffc020ac3a:	85aa                	mv	a1,a0
ffffffffc020ac3c:	7808                	ld	a0,48(s0)
ffffffffc020ac3e:	8626                	mv	a2,s1
ffffffffc020ac40:	7118                	ld	a4,32(a0)
ffffffffc020ac42:	9702                	jalr	a4
ffffffffc020ac44:	70e2                	ld	ra,56(sp)
ffffffffc020ac46:	7442                	ld	s0,48(sp)
ffffffffc020ac48:	74a2                	ld	s1,40(sp)
ffffffffc020ac4a:	6121                	addi	sp,sp,64
ffffffffc020ac4c:	8082                	ret
ffffffffc020ac4e:	00004697          	auipc	a3,0x4
ffffffffc020ac52:	69a68693          	addi	a3,a3,1690 # ffffffffc020f2e8 <sfs_node_fileops+0x2a0>
ffffffffc020ac56:	00001617          	auipc	a2,0x1
ffffffffc020ac5a:	bb260613          	addi	a2,a2,-1102 # ffffffffc020b808 <commands+0x60>
ffffffffc020ac5e:	45d5                	li	a1,21
ffffffffc020ac60:	00004517          	auipc	a0,0x4
ffffffffc020ac64:	6c050513          	addi	a0,a0,1728 # ffffffffc020f320 <sfs_node_fileops+0x2d8>
ffffffffc020ac68:	dc6f50ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020ac6c <sfs_rblock>:
ffffffffc020ac6c:	7139                	addi	sp,sp,-64
ffffffffc020ac6e:	ec4e                	sd	s3,24(sp)
ffffffffc020ac70:	89b6                	mv	s3,a3
ffffffffc020ac72:	f822                	sd	s0,48(sp)
ffffffffc020ac74:	f04a                	sd	s2,32(sp)
ffffffffc020ac76:	e852                	sd	s4,16(sp)
ffffffffc020ac78:	fc06                	sd	ra,56(sp)
ffffffffc020ac7a:	f426                	sd	s1,40(sp)
ffffffffc020ac7c:	e456                	sd	s5,8(sp)
ffffffffc020ac7e:	8a2a                	mv	s4,a0
ffffffffc020ac80:	892e                	mv	s2,a1
ffffffffc020ac82:	8432                	mv	s0,a2
ffffffffc020ac84:	a0afe0ef          	jal	ra,ffffffffc0208e8e <lock_sfs_io>
ffffffffc020ac88:	04098063          	beqz	s3,ffffffffc020acc8 <sfs_rblock+0x5c>
ffffffffc020ac8c:	013409bb          	addw	s3,s0,s3
ffffffffc020ac90:	6a85                	lui	s5,0x1
ffffffffc020ac92:	a021                	j	ffffffffc020ac9a <sfs_rblock+0x2e>
ffffffffc020ac94:	9956                	add	s2,s2,s5
ffffffffc020ac96:	02898963          	beq	s3,s0,ffffffffc020acc8 <sfs_rblock+0x5c>
ffffffffc020ac9a:	8622                	mv	a2,s0
ffffffffc020ac9c:	85ca                	mv	a1,s2
ffffffffc020ac9e:	4705                	li	a4,1
ffffffffc020aca0:	4681                	li	a3,0
ffffffffc020aca2:	8552                	mv	a0,s4
ffffffffc020aca4:	f71ff0ef          	jal	ra,ffffffffc020ac14 <sfs_rwblock_nolock>
ffffffffc020aca8:	84aa                	mv	s1,a0
ffffffffc020acaa:	2405                	addiw	s0,s0,1
ffffffffc020acac:	d565                	beqz	a0,ffffffffc020ac94 <sfs_rblock+0x28>
ffffffffc020acae:	8552                	mv	a0,s4
ffffffffc020acb0:	9eefe0ef          	jal	ra,ffffffffc0208e9e <unlock_sfs_io>
ffffffffc020acb4:	70e2                	ld	ra,56(sp)
ffffffffc020acb6:	7442                	ld	s0,48(sp)
ffffffffc020acb8:	7902                	ld	s2,32(sp)
ffffffffc020acba:	69e2                	ld	s3,24(sp)
ffffffffc020acbc:	6a42                	ld	s4,16(sp)
ffffffffc020acbe:	6aa2                	ld	s5,8(sp)
ffffffffc020acc0:	8526                	mv	a0,s1
ffffffffc020acc2:	74a2                	ld	s1,40(sp)
ffffffffc020acc4:	6121                	addi	sp,sp,64
ffffffffc020acc6:	8082                	ret
ffffffffc020acc8:	4481                	li	s1,0
ffffffffc020acca:	b7d5                	j	ffffffffc020acae <sfs_rblock+0x42>

ffffffffc020accc <sfs_wblock>:
ffffffffc020accc:	7139                	addi	sp,sp,-64
ffffffffc020acce:	ec4e                	sd	s3,24(sp)
ffffffffc020acd0:	89b6                	mv	s3,a3
ffffffffc020acd2:	f822                	sd	s0,48(sp)
ffffffffc020acd4:	f04a                	sd	s2,32(sp)
ffffffffc020acd6:	e852                	sd	s4,16(sp)
ffffffffc020acd8:	fc06                	sd	ra,56(sp)
ffffffffc020acda:	f426                	sd	s1,40(sp)
ffffffffc020acdc:	e456                	sd	s5,8(sp)
ffffffffc020acde:	8a2a                	mv	s4,a0
ffffffffc020ace0:	892e                	mv	s2,a1
ffffffffc020ace2:	8432                	mv	s0,a2
ffffffffc020ace4:	9aafe0ef          	jal	ra,ffffffffc0208e8e <lock_sfs_io>
ffffffffc020ace8:	04098063          	beqz	s3,ffffffffc020ad28 <sfs_wblock+0x5c>
ffffffffc020acec:	013409bb          	addw	s3,s0,s3
ffffffffc020acf0:	6a85                	lui	s5,0x1
ffffffffc020acf2:	a021                	j	ffffffffc020acfa <sfs_wblock+0x2e>
ffffffffc020acf4:	9956                	add	s2,s2,s5
ffffffffc020acf6:	02898963          	beq	s3,s0,ffffffffc020ad28 <sfs_wblock+0x5c>
ffffffffc020acfa:	8622                	mv	a2,s0
ffffffffc020acfc:	85ca                	mv	a1,s2
ffffffffc020acfe:	4705                	li	a4,1
ffffffffc020ad00:	4685                	li	a3,1
ffffffffc020ad02:	8552                	mv	a0,s4
ffffffffc020ad04:	f11ff0ef          	jal	ra,ffffffffc020ac14 <sfs_rwblock_nolock>
ffffffffc020ad08:	84aa                	mv	s1,a0
ffffffffc020ad0a:	2405                	addiw	s0,s0,1
ffffffffc020ad0c:	d565                	beqz	a0,ffffffffc020acf4 <sfs_wblock+0x28>
ffffffffc020ad0e:	8552                	mv	a0,s4
ffffffffc020ad10:	98efe0ef          	jal	ra,ffffffffc0208e9e <unlock_sfs_io>
ffffffffc020ad14:	70e2                	ld	ra,56(sp)
ffffffffc020ad16:	7442                	ld	s0,48(sp)
ffffffffc020ad18:	7902                	ld	s2,32(sp)
ffffffffc020ad1a:	69e2                	ld	s3,24(sp)
ffffffffc020ad1c:	6a42                	ld	s4,16(sp)
ffffffffc020ad1e:	6aa2                	ld	s5,8(sp)
ffffffffc020ad20:	8526                	mv	a0,s1
ffffffffc020ad22:	74a2                	ld	s1,40(sp)
ffffffffc020ad24:	6121                	addi	sp,sp,64
ffffffffc020ad26:	8082                	ret
ffffffffc020ad28:	4481                	li	s1,0
ffffffffc020ad2a:	b7d5                	j	ffffffffc020ad0e <sfs_wblock+0x42>

ffffffffc020ad2c <sfs_rbuf>:
ffffffffc020ad2c:	7179                	addi	sp,sp,-48
ffffffffc020ad2e:	f406                	sd	ra,40(sp)
ffffffffc020ad30:	f022                	sd	s0,32(sp)
ffffffffc020ad32:	ec26                	sd	s1,24(sp)
ffffffffc020ad34:	e84a                	sd	s2,16(sp)
ffffffffc020ad36:	e44e                	sd	s3,8(sp)
ffffffffc020ad38:	e052                	sd	s4,0(sp)
ffffffffc020ad3a:	6785                	lui	a5,0x1
ffffffffc020ad3c:	04f77863          	bgeu	a4,a5,ffffffffc020ad8c <sfs_rbuf+0x60>
ffffffffc020ad40:	84ba                	mv	s1,a4
ffffffffc020ad42:	9732                	add	a4,a4,a2
ffffffffc020ad44:	89b2                	mv	s3,a2
ffffffffc020ad46:	04e7e363          	bltu	a5,a4,ffffffffc020ad8c <sfs_rbuf+0x60>
ffffffffc020ad4a:	8936                	mv	s2,a3
ffffffffc020ad4c:	842a                	mv	s0,a0
ffffffffc020ad4e:	8a2e                	mv	s4,a1
ffffffffc020ad50:	93efe0ef          	jal	ra,ffffffffc0208e8e <lock_sfs_io>
ffffffffc020ad54:	642c                	ld	a1,72(s0)
ffffffffc020ad56:	864a                	mv	a2,s2
ffffffffc020ad58:	4705                	li	a4,1
ffffffffc020ad5a:	4681                	li	a3,0
ffffffffc020ad5c:	8522                	mv	a0,s0
ffffffffc020ad5e:	eb7ff0ef          	jal	ra,ffffffffc020ac14 <sfs_rwblock_nolock>
ffffffffc020ad62:	892a                	mv	s2,a0
ffffffffc020ad64:	cd09                	beqz	a0,ffffffffc020ad7e <sfs_rbuf+0x52>
ffffffffc020ad66:	8522                	mv	a0,s0
ffffffffc020ad68:	936fe0ef          	jal	ra,ffffffffc0208e9e <unlock_sfs_io>
ffffffffc020ad6c:	70a2                	ld	ra,40(sp)
ffffffffc020ad6e:	7402                	ld	s0,32(sp)
ffffffffc020ad70:	64e2                	ld	s1,24(sp)
ffffffffc020ad72:	69a2                	ld	s3,8(sp)
ffffffffc020ad74:	6a02                	ld	s4,0(sp)
ffffffffc020ad76:	854a                	mv	a0,s2
ffffffffc020ad78:	6942                	ld	s2,16(sp)
ffffffffc020ad7a:	6145                	addi	sp,sp,48
ffffffffc020ad7c:	8082                	ret
ffffffffc020ad7e:	642c                	ld	a1,72(s0)
ffffffffc020ad80:	864e                	mv	a2,s3
ffffffffc020ad82:	8552                	mv	a0,s4
ffffffffc020ad84:	95a6                	add	a1,a1,s1
ffffffffc020ad86:	2ca000ef          	jal	ra,ffffffffc020b050 <memcpy>
ffffffffc020ad8a:	bff1                	j	ffffffffc020ad66 <sfs_rbuf+0x3a>
ffffffffc020ad8c:	00004697          	auipc	a3,0x4
ffffffffc020ad90:	5ac68693          	addi	a3,a3,1452 # ffffffffc020f338 <sfs_node_fileops+0x2f0>
ffffffffc020ad94:	00001617          	auipc	a2,0x1
ffffffffc020ad98:	a7460613          	addi	a2,a2,-1420 # ffffffffc020b808 <commands+0x60>
ffffffffc020ad9c:	05500593          	li	a1,85
ffffffffc020ada0:	00004517          	auipc	a0,0x4
ffffffffc020ada4:	58050513          	addi	a0,a0,1408 # ffffffffc020f320 <sfs_node_fileops+0x2d8>
ffffffffc020ada8:	c86f50ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020adac <sfs_wbuf>:
ffffffffc020adac:	7139                	addi	sp,sp,-64
ffffffffc020adae:	fc06                	sd	ra,56(sp)
ffffffffc020adb0:	f822                	sd	s0,48(sp)
ffffffffc020adb2:	f426                	sd	s1,40(sp)
ffffffffc020adb4:	f04a                	sd	s2,32(sp)
ffffffffc020adb6:	ec4e                	sd	s3,24(sp)
ffffffffc020adb8:	e852                	sd	s4,16(sp)
ffffffffc020adba:	e456                	sd	s5,8(sp)
ffffffffc020adbc:	6785                	lui	a5,0x1
ffffffffc020adbe:	06f77163          	bgeu	a4,a5,ffffffffc020ae20 <sfs_wbuf+0x74>
ffffffffc020adc2:	893a                	mv	s2,a4
ffffffffc020adc4:	9732                	add	a4,a4,a2
ffffffffc020adc6:	8a32                	mv	s4,a2
ffffffffc020adc8:	04e7ec63          	bltu	a5,a4,ffffffffc020ae20 <sfs_wbuf+0x74>
ffffffffc020adcc:	842a                	mv	s0,a0
ffffffffc020adce:	89b6                	mv	s3,a3
ffffffffc020add0:	8aae                	mv	s5,a1
ffffffffc020add2:	8bcfe0ef          	jal	ra,ffffffffc0208e8e <lock_sfs_io>
ffffffffc020add6:	642c                	ld	a1,72(s0)
ffffffffc020add8:	4705                	li	a4,1
ffffffffc020adda:	4681                	li	a3,0
ffffffffc020addc:	864e                	mv	a2,s3
ffffffffc020adde:	8522                	mv	a0,s0
ffffffffc020ade0:	e35ff0ef          	jal	ra,ffffffffc020ac14 <sfs_rwblock_nolock>
ffffffffc020ade4:	84aa                	mv	s1,a0
ffffffffc020ade6:	cd11                	beqz	a0,ffffffffc020ae02 <sfs_wbuf+0x56>
ffffffffc020ade8:	8522                	mv	a0,s0
ffffffffc020adea:	8b4fe0ef          	jal	ra,ffffffffc0208e9e <unlock_sfs_io>
ffffffffc020adee:	70e2                	ld	ra,56(sp)
ffffffffc020adf0:	7442                	ld	s0,48(sp)
ffffffffc020adf2:	7902                	ld	s2,32(sp)
ffffffffc020adf4:	69e2                	ld	s3,24(sp)
ffffffffc020adf6:	6a42                	ld	s4,16(sp)
ffffffffc020adf8:	6aa2                	ld	s5,8(sp)
ffffffffc020adfa:	8526                	mv	a0,s1
ffffffffc020adfc:	74a2                	ld	s1,40(sp)
ffffffffc020adfe:	6121                	addi	sp,sp,64
ffffffffc020ae00:	8082                	ret
ffffffffc020ae02:	6428                	ld	a0,72(s0)
ffffffffc020ae04:	8652                	mv	a2,s4
ffffffffc020ae06:	85d6                	mv	a1,s5
ffffffffc020ae08:	954a                	add	a0,a0,s2
ffffffffc020ae0a:	246000ef          	jal	ra,ffffffffc020b050 <memcpy>
ffffffffc020ae0e:	642c                	ld	a1,72(s0)
ffffffffc020ae10:	4705                	li	a4,1
ffffffffc020ae12:	4685                	li	a3,1
ffffffffc020ae14:	864e                	mv	a2,s3
ffffffffc020ae16:	8522                	mv	a0,s0
ffffffffc020ae18:	dfdff0ef          	jal	ra,ffffffffc020ac14 <sfs_rwblock_nolock>
ffffffffc020ae1c:	84aa                	mv	s1,a0
ffffffffc020ae1e:	b7e9                	j	ffffffffc020ade8 <sfs_wbuf+0x3c>
ffffffffc020ae20:	00004697          	auipc	a3,0x4
ffffffffc020ae24:	51868693          	addi	a3,a3,1304 # ffffffffc020f338 <sfs_node_fileops+0x2f0>
ffffffffc020ae28:	00001617          	auipc	a2,0x1
ffffffffc020ae2c:	9e060613          	addi	a2,a2,-1568 # ffffffffc020b808 <commands+0x60>
ffffffffc020ae30:	06b00593          	li	a1,107
ffffffffc020ae34:	00004517          	auipc	a0,0x4
ffffffffc020ae38:	4ec50513          	addi	a0,a0,1260 # ffffffffc020f320 <sfs_node_fileops+0x2d8>
ffffffffc020ae3c:	bf2f50ef          	jal	ra,ffffffffc020022e <__panic>

ffffffffc020ae40 <sfs_sync_super>:
ffffffffc020ae40:	1101                	addi	sp,sp,-32
ffffffffc020ae42:	ec06                	sd	ra,24(sp)
ffffffffc020ae44:	e822                	sd	s0,16(sp)
ffffffffc020ae46:	e426                	sd	s1,8(sp)
ffffffffc020ae48:	842a                	mv	s0,a0
ffffffffc020ae4a:	844fe0ef          	jal	ra,ffffffffc0208e8e <lock_sfs_io>
ffffffffc020ae4e:	6428                	ld	a0,72(s0)
ffffffffc020ae50:	6605                	lui	a2,0x1
ffffffffc020ae52:	4581                	li	a1,0
ffffffffc020ae54:	1aa000ef          	jal	ra,ffffffffc020affe <memset>
ffffffffc020ae58:	6428                	ld	a0,72(s0)
ffffffffc020ae5a:	85a2                	mv	a1,s0
ffffffffc020ae5c:	02c00613          	li	a2,44
ffffffffc020ae60:	1f0000ef          	jal	ra,ffffffffc020b050 <memcpy>
ffffffffc020ae64:	642c                	ld	a1,72(s0)
ffffffffc020ae66:	4701                	li	a4,0
ffffffffc020ae68:	4685                	li	a3,1
ffffffffc020ae6a:	4601                	li	a2,0
ffffffffc020ae6c:	8522                	mv	a0,s0
ffffffffc020ae6e:	da7ff0ef          	jal	ra,ffffffffc020ac14 <sfs_rwblock_nolock>
ffffffffc020ae72:	84aa                	mv	s1,a0
ffffffffc020ae74:	8522                	mv	a0,s0
ffffffffc020ae76:	828fe0ef          	jal	ra,ffffffffc0208e9e <unlock_sfs_io>
ffffffffc020ae7a:	60e2                	ld	ra,24(sp)
ffffffffc020ae7c:	6442                	ld	s0,16(sp)
ffffffffc020ae7e:	8526                	mv	a0,s1
ffffffffc020ae80:	64a2                	ld	s1,8(sp)
ffffffffc020ae82:	6105                	addi	sp,sp,32
ffffffffc020ae84:	8082                	ret

ffffffffc020ae86 <sfs_sync_freemap>:
ffffffffc020ae86:	7139                	addi	sp,sp,-64
ffffffffc020ae88:	ec4e                	sd	s3,24(sp)
ffffffffc020ae8a:	e852                	sd	s4,16(sp)
ffffffffc020ae8c:	00456983          	lwu	s3,4(a0)
ffffffffc020ae90:	8a2a                	mv	s4,a0
ffffffffc020ae92:	7d08                	ld	a0,56(a0)
ffffffffc020ae94:	67a1                	lui	a5,0x8
ffffffffc020ae96:	17fd                	addi	a5,a5,-1
ffffffffc020ae98:	4581                	li	a1,0
ffffffffc020ae9a:	f822                	sd	s0,48(sp)
ffffffffc020ae9c:	fc06                	sd	ra,56(sp)
ffffffffc020ae9e:	f426                	sd	s1,40(sp)
ffffffffc020aea0:	f04a                	sd	s2,32(sp)
ffffffffc020aea2:	e456                	sd	s5,8(sp)
ffffffffc020aea4:	99be                	add	s3,s3,a5
ffffffffc020aea6:	d61ff0ef          	jal	ra,ffffffffc020ac06 <bitmap_getdata>
ffffffffc020aeaa:	00f9d993          	srli	s3,s3,0xf
ffffffffc020aeae:	842a                	mv	s0,a0
ffffffffc020aeb0:	8552                	mv	a0,s4
ffffffffc020aeb2:	fddfd0ef          	jal	ra,ffffffffc0208e8e <lock_sfs_io>
ffffffffc020aeb6:	04098163          	beqz	s3,ffffffffc020aef8 <sfs_sync_freemap+0x72>
ffffffffc020aeba:	09b2                	slli	s3,s3,0xc
ffffffffc020aebc:	99a2                	add	s3,s3,s0
ffffffffc020aebe:	4909                	li	s2,2
ffffffffc020aec0:	6a85                	lui	s5,0x1
ffffffffc020aec2:	a021                	j	ffffffffc020aeca <sfs_sync_freemap+0x44>
ffffffffc020aec4:	2905                	addiw	s2,s2,1
ffffffffc020aec6:	02898963          	beq	s3,s0,ffffffffc020aef8 <sfs_sync_freemap+0x72>
ffffffffc020aeca:	85a2                	mv	a1,s0
ffffffffc020aecc:	864a                	mv	a2,s2
ffffffffc020aece:	4705                	li	a4,1
ffffffffc020aed0:	4685                	li	a3,1
ffffffffc020aed2:	8552                	mv	a0,s4
ffffffffc020aed4:	d41ff0ef          	jal	ra,ffffffffc020ac14 <sfs_rwblock_nolock>
ffffffffc020aed8:	84aa                	mv	s1,a0
ffffffffc020aeda:	9456                	add	s0,s0,s5
ffffffffc020aedc:	d565                	beqz	a0,ffffffffc020aec4 <sfs_sync_freemap+0x3e>
ffffffffc020aede:	8552                	mv	a0,s4
ffffffffc020aee0:	fbffd0ef          	jal	ra,ffffffffc0208e9e <unlock_sfs_io>
ffffffffc020aee4:	70e2                	ld	ra,56(sp)
ffffffffc020aee6:	7442                	ld	s0,48(sp)
ffffffffc020aee8:	7902                	ld	s2,32(sp)
ffffffffc020aeea:	69e2                	ld	s3,24(sp)
ffffffffc020aeec:	6a42                	ld	s4,16(sp)
ffffffffc020aeee:	6aa2                	ld	s5,8(sp)
ffffffffc020aef0:	8526                	mv	a0,s1
ffffffffc020aef2:	74a2                	ld	s1,40(sp)
ffffffffc020aef4:	6121                	addi	sp,sp,64
ffffffffc020aef6:	8082                	ret
ffffffffc020aef8:	4481                	li	s1,0
ffffffffc020aefa:	b7d5                	j	ffffffffc020aede <sfs_sync_freemap+0x58>

ffffffffc020aefc <sfs_clear_block>:
ffffffffc020aefc:	7179                	addi	sp,sp,-48
ffffffffc020aefe:	f022                	sd	s0,32(sp)
ffffffffc020af00:	e84a                	sd	s2,16(sp)
ffffffffc020af02:	e44e                	sd	s3,8(sp)
ffffffffc020af04:	f406                	sd	ra,40(sp)
ffffffffc020af06:	89b2                	mv	s3,a2
ffffffffc020af08:	ec26                	sd	s1,24(sp)
ffffffffc020af0a:	892a                	mv	s2,a0
ffffffffc020af0c:	842e                	mv	s0,a1
ffffffffc020af0e:	f81fd0ef          	jal	ra,ffffffffc0208e8e <lock_sfs_io>
ffffffffc020af12:	04893503          	ld	a0,72(s2)
ffffffffc020af16:	6605                	lui	a2,0x1
ffffffffc020af18:	4581                	li	a1,0
ffffffffc020af1a:	0e4000ef          	jal	ra,ffffffffc020affe <memset>
ffffffffc020af1e:	02098d63          	beqz	s3,ffffffffc020af58 <sfs_clear_block+0x5c>
ffffffffc020af22:	013409bb          	addw	s3,s0,s3
ffffffffc020af26:	a019                	j	ffffffffc020af2c <sfs_clear_block+0x30>
ffffffffc020af28:	02898863          	beq	s3,s0,ffffffffc020af58 <sfs_clear_block+0x5c>
ffffffffc020af2c:	04893583          	ld	a1,72(s2)
ffffffffc020af30:	8622                	mv	a2,s0
ffffffffc020af32:	4705                	li	a4,1
ffffffffc020af34:	4685                	li	a3,1
ffffffffc020af36:	854a                	mv	a0,s2
ffffffffc020af38:	cddff0ef          	jal	ra,ffffffffc020ac14 <sfs_rwblock_nolock>
ffffffffc020af3c:	84aa                	mv	s1,a0
ffffffffc020af3e:	2405                	addiw	s0,s0,1
ffffffffc020af40:	d565                	beqz	a0,ffffffffc020af28 <sfs_clear_block+0x2c>
ffffffffc020af42:	854a                	mv	a0,s2
ffffffffc020af44:	f5bfd0ef          	jal	ra,ffffffffc0208e9e <unlock_sfs_io>
ffffffffc020af48:	70a2                	ld	ra,40(sp)
ffffffffc020af4a:	7402                	ld	s0,32(sp)
ffffffffc020af4c:	6942                	ld	s2,16(sp)
ffffffffc020af4e:	69a2                	ld	s3,8(sp)
ffffffffc020af50:	8526                	mv	a0,s1
ffffffffc020af52:	64e2                	ld	s1,24(sp)
ffffffffc020af54:	6145                	addi	sp,sp,48
ffffffffc020af56:	8082                	ret
ffffffffc020af58:	4481                	li	s1,0
ffffffffc020af5a:	b7e5                	j	ffffffffc020af42 <sfs_clear_block+0x46>

ffffffffc020af5c <strlen>:
ffffffffc020af5c:	00054783          	lbu	a5,0(a0)
ffffffffc020af60:	872a                	mv	a4,a0
ffffffffc020af62:	4501                	li	a0,0
ffffffffc020af64:	cb81                	beqz	a5,ffffffffc020af74 <strlen+0x18>
ffffffffc020af66:	0505                	addi	a0,a0,1
ffffffffc020af68:	00a707b3          	add	a5,a4,a0
ffffffffc020af6c:	0007c783          	lbu	a5,0(a5) # 8000 <_binary_bin_swap_img_size+0x300>
ffffffffc020af70:	fbfd                	bnez	a5,ffffffffc020af66 <strlen+0xa>
ffffffffc020af72:	8082                	ret
ffffffffc020af74:	8082                	ret

ffffffffc020af76 <strnlen>:
ffffffffc020af76:	4781                	li	a5,0
ffffffffc020af78:	e589                	bnez	a1,ffffffffc020af82 <strnlen+0xc>
ffffffffc020af7a:	a811                	j	ffffffffc020af8e <strnlen+0x18>
ffffffffc020af7c:	0785                	addi	a5,a5,1
ffffffffc020af7e:	00f58863          	beq	a1,a5,ffffffffc020af8e <strnlen+0x18>
ffffffffc020af82:	00f50733          	add	a4,a0,a5
ffffffffc020af86:	00074703          	lbu	a4,0(a4) # 4000 <_binary_bin_swap_img_size-0x3d00>
ffffffffc020af8a:	fb6d                	bnez	a4,ffffffffc020af7c <strnlen+0x6>
ffffffffc020af8c:	85be                	mv	a1,a5
ffffffffc020af8e:	852e                	mv	a0,a1
ffffffffc020af90:	8082                	ret

ffffffffc020af92 <strcpy>:
ffffffffc020af92:	87aa                	mv	a5,a0
ffffffffc020af94:	0005c703          	lbu	a4,0(a1)
ffffffffc020af98:	0785                	addi	a5,a5,1
ffffffffc020af9a:	0585                	addi	a1,a1,1
ffffffffc020af9c:	fee78fa3          	sb	a4,-1(a5)
ffffffffc020afa0:	fb75                	bnez	a4,ffffffffc020af94 <strcpy+0x2>
ffffffffc020afa2:	8082                	ret

ffffffffc020afa4 <strcmp>:
ffffffffc020afa4:	00054783          	lbu	a5,0(a0)
ffffffffc020afa8:	0005c703          	lbu	a4,0(a1)
ffffffffc020afac:	cb89                	beqz	a5,ffffffffc020afbe <strcmp+0x1a>
ffffffffc020afae:	0505                	addi	a0,a0,1
ffffffffc020afb0:	0585                	addi	a1,a1,1
ffffffffc020afb2:	fee789e3          	beq	a5,a4,ffffffffc020afa4 <strcmp>
ffffffffc020afb6:	0007851b          	sext.w	a0,a5
ffffffffc020afba:	9d19                	subw	a0,a0,a4
ffffffffc020afbc:	8082                	ret
ffffffffc020afbe:	4501                	li	a0,0
ffffffffc020afc0:	bfed                	j	ffffffffc020afba <strcmp+0x16>

ffffffffc020afc2 <strncmp>:
ffffffffc020afc2:	c20d                	beqz	a2,ffffffffc020afe4 <strncmp+0x22>
ffffffffc020afc4:	962e                	add	a2,a2,a1
ffffffffc020afc6:	a031                	j	ffffffffc020afd2 <strncmp+0x10>
ffffffffc020afc8:	0505                	addi	a0,a0,1
ffffffffc020afca:	00e79a63          	bne	a5,a4,ffffffffc020afde <strncmp+0x1c>
ffffffffc020afce:	00b60b63          	beq	a2,a1,ffffffffc020afe4 <strncmp+0x22>
ffffffffc020afd2:	00054783          	lbu	a5,0(a0)
ffffffffc020afd6:	0585                	addi	a1,a1,1
ffffffffc020afd8:	fff5c703          	lbu	a4,-1(a1)
ffffffffc020afdc:	f7f5                	bnez	a5,ffffffffc020afc8 <strncmp+0x6>
ffffffffc020afde:	40e7853b          	subw	a0,a5,a4
ffffffffc020afe2:	8082                	ret
ffffffffc020afe4:	4501                	li	a0,0
ffffffffc020afe6:	8082                	ret

ffffffffc020afe8 <strchr>:
ffffffffc020afe8:	00054783          	lbu	a5,0(a0)
ffffffffc020afec:	c799                	beqz	a5,ffffffffc020affa <strchr+0x12>
ffffffffc020afee:	00f58763          	beq	a1,a5,ffffffffc020affc <strchr+0x14>
ffffffffc020aff2:	00154783          	lbu	a5,1(a0)
ffffffffc020aff6:	0505                	addi	a0,a0,1
ffffffffc020aff8:	fbfd                	bnez	a5,ffffffffc020afee <strchr+0x6>
ffffffffc020affa:	4501                	li	a0,0
ffffffffc020affc:	8082                	ret

ffffffffc020affe <memset>:
ffffffffc020affe:	ca01                	beqz	a2,ffffffffc020b00e <memset+0x10>
ffffffffc020b000:	962a                	add	a2,a2,a0
ffffffffc020b002:	87aa                	mv	a5,a0
ffffffffc020b004:	0785                	addi	a5,a5,1
ffffffffc020b006:	feb78fa3          	sb	a1,-1(a5)
ffffffffc020b00a:	fec79de3          	bne	a5,a2,ffffffffc020b004 <memset+0x6>
ffffffffc020b00e:	8082                	ret

ffffffffc020b010 <memmove>:
ffffffffc020b010:	02a5f263          	bgeu	a1,a0,ffffffffc020b034 <memmove+0x24>
ffffffffc020b014:	00c587b3          	add	a5,a1,a2
ffffffffc020b018:	00f57e63          	bgeu	a0,a5,ffffffffc020b034 <memmove+0x24>
ffffffffc020b01c:	00c50733          	add	a4,a0,a2
ffffffffc020b020:	c615                	beqz	a2,ffffffffc020b04c <memmove+0x3c>
ffffffffc020b022:	fff7c683          	lbu	a3,-1(a5)
ffffffffc020b026:	17fd                	addi	a5,a5,-1
ffffffffc020b028:	177d                	addi	a4,a4,-1
ffffffffc020b02a:	00d70023          	sb	a3,0(a4)
ffffffffc020b02e:	fef59ae3          	bne	a1,a5,ffffffffc020b022 <memmove+0x12>
ffffffffc020b032:	8082                	ret
ffffffffc020b034:	00c586b3          	add	a3,a1,a2
ffffffffc020b038:	87aa                	mv	a5,a0
ffffffffc020b03a:	ca11                	beqz	a2,ffffffffc020b04e <memmove+0x3e>
ffffffffc020b03c:	0005c703          	lbu	a4,0(a1)
ffffffffc020b040:	0585                	addi	a1,a1,1
ffffffffc020b042:	0785                	addi	a5,a5,1
ffffffffc020b044:	fee78fa3          	sb	a4,-1(a5)
ffffffffc020b048:	fed59ae3          	bne	a1,a3,ffffffffc020b03c <memmove+0x2c>
ffffffffc020b04c:	8082                	ret
ffffffffc020b04e:	8082                	ret

ffffffffc020b050 <memcpy>:
ffffffffc020b050:	ca19                	beqz	a2,ffffffffc020b066 <memcpy+0x16>
ffffffffc020b052:	962e                	add	a2,a2,a1
ffffffffc020b054:	87aa                	mv	a5,a0
ffffffffc020b056:	0005c703          	lbu	a4,0(a1)
ffffffffc020b05a:	0585                	addi	a1,a1,1
ffffffffc020b05c:	0785                	addi	a5,a5,1
ffffffffc020b05e:	fee78fa3          	sb	a4,-1(a5)
ffffffffc020b062:	fec59ae3          	bne	a1,a2,ffffffffc020b056 <memcpy+0x6>
ffffffffc020b066:	8082                	ret

ffffffffc020b068 <printnum>:
ffffffffc020b068:	02071893          	slli	a7,a4,0x20
ffffffffc020b06c:	7139                	addi	sp,sp,-64
ffffffffc020b06e:	0208d893          	srli	a7,a7,0x20
ffffffffc020b072:	e456                	sd	s5,8(sp)
ffffffffc020b074:	0316fab3          	remu	s5,a3,a7
ffffffffc020b078:	f822                	sd	s0,48(sp)
ffffffffc020b07a:	f426                	sd	s1,40(sp)
ffffffffc020b07c:	f04a                	sd	s2,32(sp)
ffffffffc020b07e:	ec4e                	sd	s3,24(sp)
ffffffffc020b080:	fc06                	sd	ra,56(sp)
ffffffffc020b082:	e852                	sd	s4,16(sp)
ffffffffc020b084:	84aa                	mv	s1,a0
ffffffffc020b086:	89ae                	mv	s3,a1
ffffffffc020b088:	8932                	mv	s2,a2
ffffffffc020b08a:	fff7841b          	addiw	s0,a5,-1
ffffffffc020b08e:	2a81                	sext.w	s5,s5
ffffffffc020b090:	0516f163          	bgeu	a3,a7,ffffffffc020b0d2 <printnum+0x6a>
ffffffffc020b094:	8a42                	mv	s4,a6
ffffffffc020b096:	00805863          	blez	s0,ffffffffc020b0a6 <printnum+0x3e>
ffffffffc020b09a:	347d                	addiw	s0,s0,-1
ffffffffc020b09c:	864e                	mv	a2,s3
ffffffffc020b09e:	85ca                	mv	a1,s2
ffffffffc020b0a0:	8552                	mv	a0,s4
ffffffffc020b0a2:	9482                	jalr	s1
ffffffffc020b0a4:	f87d                	bnez	s0,ffffffffc020b09a <printnum+0x32>
ffffffffc020b0a6:	1a82                	slli	s5,s5,0x20
ffffffffc020b0a8:	00004797          	auipc	a5,0x4
ffffffffc020b0ac:	2d878793          	addi	a5,a5,728 # ffffffffc020f380 <sfs_node_fileops+0x338>
ffffffffc020b0b0:	020ada93          	srli	s5,s5,0x20
ffffffffc020b0b4:	9abe                	add	s5,s5,a5
ffffffffc020b0b6:	7442                	ld	s0,48(sp)
ffffffffc020b0b8:	000ac503          	lbu	a0,0(s5) # 1000 <_binary_bin_swap_img_size-0x6d00>
ffffffffc020b0bc:	70e2                	ld	ra,56(sp)
ffffffffc020b0be:	6a42                	ld	s4,16(sp)
ffffffffc020b0c0:	6aa2                	ld	s5,8(sp)
ffffffffc020b0c2:	864e                	mv	a2,s3
ffffffffc020b0c4:	85ca                	mv	a1,s2
ffffffffc020b0c6:	69e2                	ld	s3,24(sp)
ffffffffc020b0c8:	7902                	ld	s2,32(sp)
ffffffffc020b0ca:	87a6                	mv	a5,s1
ffffffffc020b0cc:	74a2                	ld	s1,40(sp)
ffffffffc020b0ce:	6121                	addi	sp,sp,64
ffffffffc020b0d0:	8782                	jr	a5
ffffffffc020b0d2:	0316d6b3          	divu	a3,a3,a7
ffffffffc020b0d6:	87a2                	mv	a5,s0
ffffffffc020b0d8:	f91ff0ef          	jal	ra,ffffffffc020b068 <printnum>
ffffffffc020b0dc:	b7e9                	j	ffffffffc020b0a6 <printnum+0x3e>

ffffffffc020b0de <sprintputch>:
ffffffffc020b0de:	499c                	lw	a5,16(a1)
ffffffffc020b0e0:	6198                	ld	a4,0(a1)
ffffffffc020b0e2:	6594                	ld	a3,8(a1)
ffffffffc020b0e4:	2785                	addiw	a5,a5,1
ffffffffc020b0e6:	c99c                	sw	a5,16(a1)
ffffffffc020b0e8:	00d77763          	bgeu	a4,a3,ffffffffc020b0f6 <sprintputch+0x18>
ffffffffc020b0ec:	00170793          	addi	a5,a4,1
ffffffffc020b0f0:	e19c                	sd	a5,0(a1)
ffffffffc020b0f2:	00a70023          	sb	a0,0(a4)
ffffffffc020b0f6:	8082                	ret

ffffffffc020b0f8 <vprintfmt>:
ffffffffc020b0f8:	7119                	addi	sp,sp,-128
ffffffffc020b0fa:	f4a6                	sd	s1,104(sp)
ffffffffc020b0fc:	f0ca                	sd	s2,96(sp)
ffffffffc020b0fe:	ecce                	sd	s3,88(sp)
ffffffffc020b100:	e8d2                	sd	s4,80(sp)
ffffffffc020b102:	e4d6                	sd	s5,72(sp)
ffffffffc020b104:	e0da                	sd	s6,64(sp)
ffffffffc020b106:	fc5e                	sd	s7,56(sp)
ffffffffc020b108:	ec6e                	sd	s11,24(sp)
ffffffffc020b10a:	fc86                	sd	ra,120(sp)
ffffffffc020b10c:	f8a2                	sd	s0,112(sp)
ffffffffc020b10e:	f862                	sd	s8,48(sp)
ffffffffc020b110:	f466                	sd	s9,40(sp)
ffffffffc020b112:	f06a                	sd	s10,32(sp)
ffffffffc020b114:	89aa                	mv	s3,a0
ffffffffc020b116:	892e                	mv	s2,a1
ffffffffc020b118:	84b2                	mv	s1,a2
ffffffffc020b11a:	8db6                	mv	s11,a3
ffffffffc020b11c:	8aba                	mv	s5,a4
ffffffffc020b11e:	02500a13          	li	s4,37
ffffffffc020b122:	5bfd                	li	s7,-1
ffffffffc020b124:	00004b17          	auipc	s6,0x4
ffffffffc020b128:	288b0b13          	addi	s6,s6,648 # ffffffffc020f3ac <sfs_node_fileops+0x364>
ffffffffc020b12c:	000dc503          	lbu	a0,0(s11) # 2000 <_binary_bin_swap_img_size-0x5d00>
ffffffffc020b130:	001d8413          	addi	s0,s11,1
ffffffffc020b134:	01450b63          	beq	a0,s4,ffffffffc020b14a <vprintfmt+0x52>
ffffffffc020b138:	c129                	beqz	a0,ffffffffc020b17a <vprintfmt+0x82>
ffffffffc020b13a:	864a                	mv	a2,s2
ffffffffc020b13c:	85a6                	mv	a1,s1
ffffffffc020b13e:	0405                	addi	s0,s0,1
ffffffffc020b140:	9982                	jalr	s3
ffffffffc020b142:	fff44503          	lbu	a0,-1(s0)
ffffffffc020b146:	ff4519e3          	bne	a0,s4,ffffffffc020b138 <vprintfmt+0x40>
ffffffffc020b14a:	00044583          	lbu	a1,0(s0)
ffffffffc020b14e:	02000813          	li	a6,32
ffffffffc020b152:	4d01                	li	s10,0
ffffffffc020b154:	4301                	li	t1,0
ffffffffc020b156:	5cfd                	li	s9,-1
ffffffffc020b158:	5c7d                	li	s8,-1
ffffffffc020b15a:	05500513          	li	a0,85
ffffffffc020b15e:	48a5                	li	a7,9
ffffffffc020b160:	fdd5861b          	addiw	a2,a1,-35
ffffffffc020b164:	0ff67613          	zext.b	a2,a2
ffffffffc020b168:	00140d93          	addi	s11,s0,1
ffffffffc020b16c:	04c56263          	bltu	a0,a2,ffffffffc020b1b0 <vprintfmt+0xb8>
ffffffffc020b170:	060a                	slli	a2,a2,0x2
ffffffffc020b172:	965a                	add	a2,a2,s6
ffffffffc020b174:	4214                	lw	a3,0(a2)
ffffffffc020b176:	96da                	add	a3,a3,s6
ffffffffc020b178:	8682                	jr	a3
ffffffffc020b17a:	70e6                	ld	ra,120(sp)
ffffffffc020b17c:	7446                	ld	s0,112(sp)
ffffffffc020b17e:	74a6                	ld	s1,104(sp)
ffffffffc020b180:	7906                	ld	s2,96(sp)
ffffffffc020b182:	69e6                	ld	s3,88(sp)
ffffffffc020b184:	6a46                	ld	s4,80(sp)
ffffffffc020b186:	6aa6                	ld	s5,72(sp)
ffffffffc020b188:	6b06                	ld	s6,64(sp)
ffffffffc020b18a:	7be2                	ld	s7,56(sp)
ffffffffc020b18c:	7c42                	ld	s8,48(sp)
ffffffffc020b18e:	7ca2                	ld	s9,40(sp)
ffffffffc020b190:	7d02                	ld	s10,32(sp)
ffffffffc020b192:	6de2                	ld	s11,24(sp)
ffffffffc020b194:	6109                	addi	sp,sp,128
ffffffffc020b196:	8082                	ret
ffffffffc020b198:	882e                	mv	a6,a1
ffffffffc020b19a:	00144583          	lbu	a1,1(s0)
ffffffffc020b19e:	846e                	mv	s0,s11
ffffffffc020b1a0:	00140d93          	addi	s11,s0,1
ffffffffc020b1a4:	fdd5861b          	addiw	a2,a1,-35
ffffffffc020b1a8:	0ff67613          	zext.b	a2,a2
ffffffffc020b1ac:	fcc572e3          	bgeu	a0,a2,ffffffffc020b170 <vprintfmt+0x78>
ffffffffc020b1b0:	864a                	mv	a2,s2
ffffffffc020b1b2:	85a6                	mv	a1,s1
ffffffffc020b1b4:	02500513          	li	a0,37
ffffffffc020b1b8:	9982                	jalr	s3
ffffffffc020b1ba:	fff44783          	lbu	a5,-1(s0)
ffffffffc020b1be:	8da2                	mv	s11,s0
ffffffffc020b1c0:	f74786e3          	beq	a5,s4,ffffffffc020b12c <vprintfmt+0x34>
ffffffffc020b1c4:	ffedc783          	lbu	a5,-2(s11)
ffffffffc020b1c8:	1dfd                	addi	s11,s11,-1
ffffffffc020b1ca:	ff479de3          	bne	a5,s4,ffffffffc020b1c4 <vprintfmt+0xcc>
ffffffffc020b1ce:	bfb9                	j	ffffffffc020b12c <vprintfmt+0x34>
ffffffffc020b1d0:	fd058c9b          	addiw	s9,a1,-48
ffffffffc020b1d4:	00144583          	lbu	a1,1(s0)
ffffffffc020b1d8:	846e                	mv	s0,s11
ffffffffc020b1da:	fd05869b          	addiw	a3,a1,-48
ffffffffc020b1de:	0005861b          	sext.w	a2,a1
ffffffffc020b1e2:	02d8e463          	bltu	a7,a3,ffffffffc020b20a <vprintfmt+0x112>
ffffffffc020b1e6:	00144583          	lbu	a1,1(s0)
ffffffffc020b1ea:	002c969b          	slliw	a3,s9,0x2
ffffffffc020b1ee:	0196873b          	addw	a4,a3,s9
ffffffffc020b1f2:	0017171b          	slliw	a4,a4,0x1
ffffffffc020b1f6:	9f31                	addw	a4,a4,a2
ffffffffc020b1f8:	fd05869b          	addiw	a3,a1,-48
ffffffffc020b1fc:	0405                	addi	s0,s0,1
ffffffffc020b1fe:	fd070c9b          	addiw	s9,a4,-48
ffffffffc020b202:	0005861b          	sext.w	a2,a1
ffffffffc020b206:	fed8f0e3          	bgeu	a7,a3,ffffffffc020b1e6 <vprintfmt+0xee>
ffffffffc020b20a:	f40c5be3          	bgez	s8,ffffffffc020b160 <vprintfmt+0x68>
ffffffffc020b20e:	8c66                	mv	s8,s9
ffffffffc020b210:	5cfd                	li	s9,-1
ffffffffc020b212:	b7b9                	j	ffffffffc020b160 <vprintfmt+0x68>
ffffffffc020b214:	fffc4693          	not	a3,s8
ffffffffc020b218:	96fd                	srai	a3,a3,0x3f
ffffffffc020b21a:	00dc77b3          	and	a5,s8,a3
ffffffffc020b21e:	00144583          	lbu	a1,1(s0)
ffffffffc020b222:	00078c1b          	sext.w	s8,a5
ffffffffc020b226:	846e                	mv	s0,s11
ffffffffc020b228:	bf25                	j	ffffffffc020b160 <vprintfmt+0x68>
ffffffffc020b22a:	000aac83          	lw	s9,0(s5)
ffffffffc020b22e:	00144583          	lbu	a1,1(s0)
ffffffffc020b232:	0aa1                	addi	s5,s5,8
ffffffffc020b234:	846e                	mv	s0,s11
ffffffffc020b236:	bfd1                	j	ffffffffc020b20a <vprintfmt+0x112>
ffffffffc020b238:	4705                	li	a4,1
ffffffffc020b23a:	008a8613          	addi	a2,s5,8
ffffffffc020b23e:	00674463          	blt	a4,t1,ffffffffc020b246 <vprintfmt+0x14e>
ffffffffc020b242:	1c030c63          	beqz	t1,ffffffffc020b41a <vprintfmt+0x322>
ffffffffc020b246:	000ab683          	ld	a3,0(s5)
ffffffffc020b24a:	4741                	li	a4,16
ffffffffc020b24c:	8ab2                	mv	s5,a2
ffffffffc020b24e:	2801                	sext.w	a6,a6
ffffffffc020b250:	87e2                	mv	a5,s8
ffffffffc020b252:	8626                	mv	a2,s1
ffffffffc020b254:	85ca                	mv	a1,s2
ffffffffc020b256:	854e                	mv	a0,s3
ffffffffc020b258:	e11ff0ef          	jal	ra,ffffffffc020b068 <printnum>
ffffffffc020b25c:	bdc1                	j	ffffffffc020b12c <vprintfmt+0x34>
ffffffffc020b25e:	000aa503          	lw	a0,0(s5)
ffffffffc020b262:	864a                	mv	a2,s2
ffffffffc020b264:	85a6                	mv	a1,s1
ffffffffc020b266:	0aa1                	addi	s5,s5,8
ffffffffc020b268:	9982                	jalr	s3
ffffffffc020b26a:	b5c9                	j	ffffffffc020b12c <vprintfmt+0x34>
ffffffffc020b26c:	4705                	li	a4,1
ffffffffc020b26e:	008a8613          	addi	a2,s5,8
ffffffffc020b272:	00674463          	blt	a4,t1,ffffffffc020b27a <vprintfmt+0x182>
ffffffffc020b276:	18030d63          	beqz	t1,ffffffffc020b410 <vprintfmt+0x318>
ffffffffc020b27a:	000ab683          	ld	a3,0(s5)
ffffffffc020b27e:	4729                	li	a4,10
ffffffffc020b280:	8ab2                	mv	s5,a2
ffffffffc020b282:	b7f1                	j	ffffffffc020b24e <vprintfmt+0x156>
ffffffffc020b284:	00144583          	lbu	a1,1(s0)
ffffffffc020b288:	4d05                	li	s10,1
ffffffffc020b28a:	846e                	mv	s0,s11
ffffffffc020b28c:	bdd1                	j	ffffffffc020b160 <vprintfmt+0x68>
ffffffffc020b28e:	864a                	mv	a2,s2
ffffffffc020b290:	85a6                	mv	a1,s1
ffffffffc020b292:	02500513          	li	a0,37
ffffffffc020b296:	9982                	jalr	s3
ffffffffc020b298:	bd51                	j	ffffffffc020b12c <vprintfmt+0x34>
ffffffffc020b29a:	00144583          	lbu	a1,1(s0)
ffffffffc020b29e:	2305                	addiw	t1,t1,1
ffffffffc020b2a0:	846e                	mv	s0,s11
ffffffffc020b2a2:	bd7d                	j	ffffffffc020b160 <vprintfmt+0x68>
ffffffffc020b2a4:	4705                	li	a4,1
ffffffffc020b2a6:	008a8613          	addi	a2,s5,8
ffffffffc020b2aa:	00674463          	blt	a4,t1,ffffffffc020b2b2 <vprintfmt+0x1ba>
ffffffffc020b2ae:	14030c63          	beqz	t1,ffffffffc020b406 <vprintfmt+0x30e>
ffffffffc020b2b2:	000ab683          	ld	a3,0(s5)
ffffffffc020b2b6:	4721                	li	a4,8
ffffffffc020b2b8:	8ab2                	mv	s5,a2
ffffffffc020b2ba:	bf51                	j	ffffffffc020b24e <vprintfmt+0x156>
ffffffffc020b2bc:	03000513          	li	a0,48
ffffffffc020b2c0:	864a                	mv	a2,s2
ffffffffc020b2c2:	85a6                	mv	a1,s1
ffffffffc020b2c4:	e042                	sd	a6,0(sp)
ffffffffc020b2c6:	9982                	jalr	s3
ffffffffc020b2c8:	864a                	mv	a2,s2
ffffffffc020b2ca:	85a6                	mv	a1,s1
ffffffffc020b2cc:	07800513          	li	a0,120
ffffffffc020b2d0:	9982                	jalr	s3
ffffffffc020b2d2:	0aa1                	addi	s5,s5,8
ffffffffc020b2d4:	6802                	ld	a6,0(sp)
ffffffffc020b2d6:	4741                	li	a4,16
ffffffffc020b2d8:	ff8ab683          	ld	a3,-8(s5)
ffffffffc020b2dc:	bf8d                	j	ffffffffc020b24e <vprintfmt+0x156>
ffffffffc020b2de:	000ab403          	ld	s0,0(s5)
ffffffffc020b2e2:	008a8793          	addi	a5,s5,8
ffffffffc020b2e6:	e03e                	sd	a5,0(sp)
ffffffffc020b2e8:	14040c63          	beqz	s0,ffffffffc020b440 <vprintfmt+0x348>
ffffffffc020b2ec:	11805063          	blez	s8,ffffffffc020b3ec <vprintfmt+0x2f4>
ffffffffc020b2f0:	02d00693          	li	a3,45
ffffffffc020b2f4:	0cd81963          	bne	a6,a3,ffffffffc020b3c6 <vprintfmt+0x2ce>
ffffffffc020b2f8:	00044683          	lbu	a3,0(s0)
ffffffffc020b2fc:	0006851b          	sext.w	a0,a3
ffffffffc020b300:	ce8d                	beqz	a3,ffffffffc020b33a <vprintfmt+0x242>
ffffffffc020b302:	00140a93          	addi	s5,s0,1
ffffffffc020b306:	05e00413          	li	s0,94
ffffffffc020b30a:	000cc563          	bltz	s9,ffffffffc020b314 <vprintfmt+0x21c>
ffffffffc020b30e:	3cfd                	addiw	s9,s9,-1
ffffffffc020b310:	037c8363          	beq	s9,s7,ffffffffc020b336 <vprintfmt+0x23e>
ffffffffc020b314:	864a                	mv	a2,s2
ffffffffc020b316:	85a6                	mv	a1,s1
ffffffffc020b318:	100d0663          	beqz	s10,ffffffffc020b424 <vprintfmt+0x32c>
ffffffffc020b31c:	3681                	addiw	a3,a3,-32
ffffffffc020b31e:	10d47363          	bgeu	s0,a3,ffffffffc020b424 <vprintfmt+0x32c>
ffffffffc020b322:	03f00513          	li	a0,63
ffffffffc020b326:	9982                	jalr	s3
ffffffffc020b328:	000ac683          	lbu	a3,0(s5)
ffffffffc020b32c:	3c7d                	addiw	s8,s8,-1
ffffffffc020b32e:	0a85                	addi	s5,s5,1
ffffffffc020b330:	0006851b          	sext.w	a0,a3
ffffffffc020b334:	faf9                	bnez	a3,ffffffffc020b30a <vprintfmt+0x212>
ffffffffc020b336:	01805a63          	blez	s8,ffffffffc020b34a <vprintfmt+0x252>
ffffffffc020b33a:	3c7d                	addiw	s8,s8,-1
ffffffffc020b33c:	864a                	mv	a2,s2
ffffffffc020b33e:	85a6                	mv	a1,s1
ffffffffc020b340:	02000513          	li	a0,32
ffffffffc020b344:	9982                	jalr	s3
ffffffffc020b346:	fe0c1ae3          	bnez	s8,ffffffffc020b33a <vprintfmt+0x242>
ffffffffc020b34a:	6a82                	ld	s5,0(sp)
ffffffffc020b34c:	b3c5                	j	ffffffffc020b12c <vprintfmt+0x34>
ffffffffc020b34e:	4705                	li	a4,1
ffffffffc020b350:	008a8d13          	addi	s10,s5,8
ffffffffc020b354:	00674463          	blt	a4,t1,ffffffffc020b35c <vprintfmt+0x264>
ffffffffc020b358:	0a030463          	beqz	t1,ffffffffc020b400 <vprintfmt+0x308>
ffffffffc020b35c:	000ab403          	ld	s0,0(s5)
ffffffffc020b360:	0c044463          	bltz	s0,ffffffffc020b428 <vprintfmt+0x330>
ffffffffc020b364:	86a2                	mv	a3,s0
ffffffffc020b366:	8aea                	mv	s5,s10
ffffffffc020b368:	4729                	li	a4,10
ffffffffc020b36a:	b5d5                	j	ffffffffc020b24e <vprintfmt+0x156>
ffffffffc020b36c:	000aa783          	lw	a5,0(s5)
ffffffffc020b370:	46e1                	li	a3,24
ffffffffc020b372:	0aa1                	addi	s5,s5,8
ffffffffc020b374:	41f7d71b          	sraiw	a4,a5,0x1f
ffffffffc020b378:	8fb9                	xor	a5,a5,a4
ffffffffc020b37a:	40e7873b          	subw	a4,a5,a4
ffffffffc020b37e:	02e6c663          	blt	a3,a4,ffffffffc020b3aa <vprintfmt+0x2b2>
ffffffffc020b382:	00371793          	slli	a5,a4,0x3
ffffffffc020b386:	00004697          	auipc	a3,0x4
ffffffffc020b38a:	35a68693          	addi	a3,a3,858 # ffffffffc020f6e0 <error_string>
ffffffffc020b38e:	97b6                	add	a5,a5,a3
ffffffffc020b390:	639c                	ld	a5,0(a5)
ffffffffc020b392:	cf81                	beqz	a5,ffffffffc020b3aa <vprintfmt+0x2b2>
ffffffffc020b394:	873e                	mv	a4,a5
ffffffffc020b396:	00000697          	auipc	a3,0x0
ffffffffc020b39a:	19268693          	addi	a3,a3,402 # ffffffffc020b528 <etext+0x2e>
ffffffffc020b39e:	8626                	mv	a2,s1
ffffffffc020b3a0:	85ca                	mv	a1,s2
ffffffffc020b3a2:	854e                	mv	a0,s3
ffffffffc020b3a4:	0d4000ef          	jal	ra,ffffffffc020b478 <printfmt>
ffffffffc020b3a8:	b351                	j	ffffffffc020b12c <vprintfmt+0x34>
ffffffffc020b3aa:	00004697          	auipc	a3,0x4
ffffffffc020b3ae:	ff668693          	addi	a3,a3,-10 # ffffffffc020f3a0 <sfs_node_fileops+0x358>
ffffffffc020b3b2:	8626                	mv	a2,s1
ffffffffc020b3b4:	85ca                	mv	a1,s2
ffffffffc020b3b6:	854e                	mv	a0,s3
ffffffffc020b3b8:	0c0000ef          	jal	ra,ffffffffc020b478 <printfmt>
ffffffffc020b3bc:	bb85                	j	ffffffffc020b12c <vprintfmt+0x34>
ffffffffc020b3be:	00004417          	auipc	s0,0x4
ffffffffc020b3c2:	fda40413          	addi	s0,s0,-38 # ffffffffc020f398 <sfs_node_fileops+0x350>
ffffffffc020b3c6:	85e6                	mv	a1,s9
ffffffffc020b3c8:	8522                	mv	a0,s0
ffffffffc020b3ca:	e442                	sd	a6,8(sp)
ffffffffc020b3cc:	babff0ef          	jal	ra,ffffffffc020af76 <strnlen>
ffffffffc020b3d0:	40ac0c3b          	subw	s8,s8,a0
ffffffffc020b3d4:	01805c63          	blez	s8,ffffffffc020b3ec <vprintfmt+0x2f4>
ffffffffc020b3d8:	6822                	ld	a6,8(sp)
ffffffffc020b3da:	00080a9b          	sext.w	s5,a6
ffffffffc020b3de:	3c7d                	addiw	s8,s8,-1
ffffffffc020b3e0:	864a                	mv	a2,s2
ffffffffc020b3e2:	85a6                	mv	a1,s1
ffffffffc020b3e4:	8556                	mv	a0,s5
ffffffffc020b3e6:	9982                	jalr	s3
ffffffffc020b3e8:	fe0c1be3          	bnez	s8,ffffffffc020b3de <vprintfmt+0x2e6>
ffffffffc020b3ec:	00044683          	lbu	a3,0(s0)
ffffffffc020b3f0:	00140a93          	addi	s5,s0,1
ffffffffc020b3f4:	0006851b          	sext.w	a0,a3
ffffffffc020b3f8:	daa9                	beqz	a3,ffffffffc020b34a <vprintfmt+0x252>
ffffffffc020b3fa:	05e00413          	li	s0,94
ffffffffc020b3fe:	b731                	j	ffffffffc020b30a <vprintfmt+0x212>
ffffffffc020b400:	000aa403          	lw	s0,0(s5)
ffffffffc020b404:	bfb1                	j	ffffffffc020b360 <vprintfmt+0x268>
ffffffffc020b406:	000ae683          	lwu	a3,0(s5)
ffffffffc020b40a:	4721                	li	a4,8
ffffffffc020b40c:	8ab2                	mv	s5,a2
ffffffffc020b40e:	b581                	j	ffffffffc020b24e <vprintfmt+0x156>
ffffffffc020b410:	000ae683          	lwu	a3,0(s5)
ffffffffc020b414:	4729                	li	a4,10
ffffffffc020b416:	8ab2                	mv	s5,a2
ffffffffc020b418:	bd1d                	j	ffffffffc020b24e <vprintfmt+0x156>
ffffffffc020b41a:	000ae683          	lwu	a3,0(s5)
ffffffffc020b41e:	4741                	li	a4,16
ffffffffc020b420:	8ab2                	mv	s5,a2
ffffffffc020b422:	b535                	j	ffffffffc020b24e <vprintfmt+0x156>
ffffffffc020b424:	9982                	jalr	s3
ffffffffc020b426:	b709                	j	ffffffffc020b328 <vprintfmt+0x230>
ffffffffc020b428:	864a                	mv	a2,s2
ffffffffc020b42a:	85a6                	mv	a1,s1
ffffffffc020b42c:	02d00513          	li	a0,45
ffffffffc020b430:	e042                	sd	a6,0(sp)
ffffffffc020b432:	9982                	jalr	s3
ffffffffc020b434:	6802                	ld	a6,0(sp)
ffffffffc020b436:	8aea                	mv	s5,s10
ffffffffc020b438:	408006b3          	neg	a3,s0
ffffffffc020b43c:	4729                	li	a4,10
ffffffffc020b43e:	bd01                	j	ffffffffc020b24e <vprintfmt+0x156>
ffffffffc020b440:	03805163          	blez	s8,ffffffffc020b462 <vprintfmt+0x36a>
ffffffffc020b444:	02d00693          	li	a3,45
ffffffffc020b448:	f6d81be3          	bne	a6,a3,ffffffffc020b3be <vprintfmt+0x2c6>
ffffffffc020b44c:	00004417          	auipc	s0,0x4
ffffffffc020b450:	f4c40413          	addi	s0,s0,-180 # ffffffffc020f398 <sfs_node_fileops+0x350>
ffffffffc020b454:	02800693          	li	a3,40
ffffffffc020b458:	02800513          	li	a0,40
ffffffffc020b45c:	00140a93          	addi	s5,s0,1
ffffffffc020b460:	b55d                	j	ffffffffc020b306 <vprintfmt+0x20e>
ffffffffc020b462:	00004a97          	auipc	s5,0x4
ffffffffc020b466:	f37a8a93          	addi	s5,s5,-201 # ffffffffc020f399 <sfs_node_fileops+0x351>
ffffffffc020b46a:	02800513          	li	a0,40
ffffffffc020b46e:	02800693          	li	a3,40
ffffffffc020b472:	05e00413          	li	s0,94
ffffffffc020b476:	bd51                	j	ffffffffc020b30a <vprintfmt+0x212>

ffffffffc020b478 <printfmt>:
ffffffffc020b478:	7139                	addi	sp,sp,-64
ffffffffc020b47a:	02010313          	addi	t1,sp,32
ffffffffc020b47e:	f03a                	sd	a4,32(sp)
ffffffffc020b480:	871a                	mv	a4,t1
ffffffffc020b482:	ec06                	sd	ra,24(sp)
ffffffffc020b484:	f43e                	sd	a5,40(sp)
ffffffffc020b486:	f842                	sd	a6,48(sp)
ffffffffc020b488:	fc46                	sd	a7,56(sp)
ffffffffc020b48a:	e41a                	sd	t1,8(sp)
ffffffffc020b48c:	c6dff0ef          	jal	ra,ffffffffc020b0f8 <vprintfmt>
ffffffffc020b490:	60e2                	ld	ra,24(sp)
ffffffffc020b492:	6121                	addi	sp,sp,64
ffffffffc020b494:	8082                	ret

ffffffffc020b496 <snprintf>:
ffffffffc020b496:	711d                	addi	sp,sp,-96
ffffffffc020b498:	15fd                	addi	a1,a1,-1
ffffffffc020b49a:	03810313          	addi	t1,sp,56
ffffffffc020b49e:	95aa                	add	a1,a1,a0
ffffffffc020b4a0:	f406                	sd	ra,40(sp)
ffffffffc020b4a2:	fc36                	sd	a3,56(sp)
ffffffffc020b4a4:	e0ba                	sd	a4,64(sp)
ffffffffc020b4a6:	e4be                	sd	a5,72(sp)
ffffffffc020b4a8:	e8c2                	sd	a6,80(sp)
ffffffffc020b4aa:	ecc6                	sd	a7,88(sp)
ffffffffc020b4ac:	e01a                	sd	t1,0(sp)
ffffffffc020b4ae:	e42a                	sd	a0,8(sp)
ffffffffc020b4b0:	e82e                	sd	a1,16(sp)
ffffffffc020b4b2:	cc02                	sw	zero,24(sp)
ffffffffc020b4b4:	c515                	beqz	a0,ffffffffc020b4e0 <snprintf+0x4a>
ffffffffc020b4b6:	02a5e563          	bltu	a1,a0,ffffffffc020b4e0 <snprintf+0x4a>
ffffffffc020b4ba:	75dd                	lui	a1,0xffff7
ffffffffc020b4bc:	86b2                	mv	a3,a2
ffffffffc020b4be:	00000517          	auipc	a0,0x0
ffffffffc020b4c2:	c2050513          	addi	a0,a0,-992 # ffffffffc020b0de <sprintputch>
ffffffffc020b4c6:	871a                	mv	a4,t1
ffffffffc020b4c8:	0030                	addi	a2,sp,8
ffffffffc020b4ca:	ad958593          	addi	a1,a1,-1319 # ffffffffffff6ad9 <end+0x3fd601c9>
ffffffffc020b4ce:	c2bff0ef          	jal	ra,ffffffffc020b0f8 <vprintfmt>
ffffffffc020b4d2:	67a2                	ld	a5,8(sp)
ffffffffc020b4d4:	00078023          	sb	zero,0(a5)
ffffffffc020b4d8:	4562                	lw	a0,24(sp)
ffffffffc020b4da:	70a2                	ld	ra,40(sp)
ffffffffc020b4dc:	6125                	addi	sp,sp,96
ffffffffc020b4de:	8082                	ret
ffffffffc020b4e0:	5575                	li	a0,-3
ffffffffc020b4e2:	bfe5                	j	ffffffffc020b4da <snprintf+0x44>

ffffffffc020b4e4 <hash32>:
ffffffffc020b4e4:	9e3707b7          	lui	a5,0x9e370
ffffffffc020b4e8:	2785                	addiw	a5,a5,1
ffffffffc020b4ea:	02a7853b          	mulw	a0,a5,a0
ffffffffc020b4ee:	02000793          	li	a5,32
ffffffffc020b4f2:	9f8d                	subw	a5,a5,a1
ffffffffc020b4f4:	00f5553b          	srlw	a0,a0,a5
ffffffffc020b4f8:	8082                	ret
