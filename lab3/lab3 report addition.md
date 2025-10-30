
---

# 扩展练习Challenge2 ：理解上下文切换机制

## 1.csrw sscratch, sp；csrrw s0, sscratch, x0实现的操作和目的

首先我们先分析csrw sscratch, sp 。这条操作将当前的栈指针sp写入了CSR寄存器sscratch。而在RISC-V的异常处理机制中，sscratch是一个“陷入前的临时保存寄存器”，trap 向量代码通常用它来区分 trap 是从用户态（user mode）还是从内核态（supervisor mode）发生的。当 trap 从用户态进入内核态时，sscratch 通常事先设为 0，这样陷入处理例程可以知道是从用户态进入的。当 trap 发生在内核态时，此时 sscratch 可能保存内核栈指针或其他上下文。

所以这行代码的作用是暂时把当前栈指针保存到 sscratch，以便在异常入口中有地方保存和区分不同来源的 trap。

然后分析csrrw s0, sscratch, x0。在分析完上一行代码后，这段代码的作用就很显而易见了，首先代码从 sscratch 读出内容（之前写入的 sp）到 s0，同时把x0写入sscratch（x0恒为0）。
翻译成高级语言也就是一段赋值表达式：s0 = sscratch; sscratch = 0。这个操作实现了把陷入前的sp临时保存到s0，同时清空了sscratch，防止在中断嵌套时混淆。

这行代码在实际中的目的是如果在 trap 处理中又发生了新的 trap（比如页错误、定时中断），处理器会再次跳转到陷阱入口。此时通过检查 sscratch 是否为 0，可以区分“trap 来自用户态”（sscratch ≠ 0）还是“trap 来自内核态”（sscratch = 0）。

## 2.保存后不还原的原因和意义

stval，scause等CSR寄存器属于陷入状态寄存器，它们是由硬件自动填充的“异常上下文”，用于告诉内核 trap 发生的原因和位置。而保存他们的目的是为了把硬件自动填写的 trap 原因、出错地址、返回地址等信息 保存到内核栈中，以便之后的 C 函数（如 trap()）可以读取、分析并作出处理。由此可知，我们保存的目的只是为了记录当时出错的状态以便后续的读取和处理，这也就解释了为什么我们不会在restore中恢复他们，因为这些寄存器属于 trap 时刻的状态，是只读信息（或说 trap 现场快照），恢复它们没有意义。而真正有意义且值得恢复的只有sstatus和sepc，这两个寄存器分别决定了返回后是否返回到用户态和返回后的指令地址，恢复他们有助于让系统回到中断发生的位置和状态向后运行。

---

# 扩展练习Challenge3 ：完善异常中断

代码如下：

CAUSE_ILLEGAL_INSTRUCTION中：
```c
        cprintf("Exception type: Illegal instruction\n");
    	cprintf("Illegal instruction caught at 0x%08x\n", tf->epc);
        tf->epc += 4;
        break;
```

CAUSE_BREAKPOINT中
```
        cprintf("Exception type: breakpoint\n");
        cprintf("ebreak caught at 0x%08x\n", tf->epc);
        tf->epc += 2; //ebreak占两个字节
```

在`kern_init`函数中，`intr_enable();`之后写入两行

```c
asm("mret");
asm("ebreak");
```

这两行代码会触发上文中的两个异常，以此来测试。

测试结果如下
```
Exception type: Illegal instruction
Illegal instruction caught at 0xc020009c
Exception type: breakpoint
ebreak caught at 0xc02000a0
```
