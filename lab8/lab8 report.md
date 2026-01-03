## 练习1: 完成读文件操作的实现（需要编码）

### 1. 实验内容

首先了解打开文件的处理流程，然后参考本实验后续的文件读写操作的过程分析，填写在 kern/fs/sfs/sfs_inode.c中 的sfs_io_nolock()函数，实现读文件中数据的代码。

---

### 2. 设计思路

#### （1）按块读取的基本思想

SFS 文件系统以磁盘块（block）为最小存储单位，而用户请求的读操作往往：

- 起始位置不在块边界
- 结束位置不在块边界
- 跨越多个磁盘块

因此，文件读取不能简单地一次完成，而需要分块处理。

---

#### （2）文件读取的三种情况

整个读取过程可以分为三部分：

1. **第一个块（可能未对齐）**  
   - 读取位置位于块中间  
   - 需要计算块内偏移  
   - 只能读取该块的剩余部分  
```
blkoff = pos % SFS_BLKSIZE;
    if (blkoff != 0) {
        size = (endpos / SFS_BLKSIZE != (uint32_t)(pos / SFS_BLKSIZE)) ?
               (SFS_BLKSIZE - blkoff) : (size_t)(endpos - pos);

        if ((ret = sfs_bmap_load_nolock(sfs, sin, (uint32_t)(pos / SFS_BLKSIZE), &ino)) != 0) {
            goto out;
        }
        if ((ret = sfs_buf_op(sfs, p, size, ino, blkoff)) != 0) {
            goto out;
        }

        p   += size;
        pos += size;
        alen += size;
    }
```

2. **中间的完整块**  
   - 完整覆盖磁盘块  
   - 可以直接整块读取，效率最高  
```
while (pos + SFS_BLKSIZE <= endpos) {
        if ((ret = sfs_bmap_load_nolock(sfs, sin, (uint32_t)(pos / SFS_BLKSIZE), &ino)) != 0) {
            goto out;
        }
        if ((ret = sfs_block_op(sfs, p, ino, 1)) != 0) {
            goto out;
        }

        p   += SFS_BLKSIZE;
        pos += SFS_BLKSIZE;
        alen += SFS_BLKSIZE;
    }
```

3. **最后一个块（可能未对齐）**  
   - 剩余数据不足一个完整块  
   - 从块起始位置读取部分数据  
```
if (pos < endpos) {
        size = (size_t)(endpos - pos);

        if ((ret = sfs_bmap_load_nolock(sfs, sin, (uint32_t)(pos / SFS_BLKSIZE), &ino)) != 0) {
            goto out;
        }
        if ((ret = sfs_buf_op(sfs, p, size, ino, 0)) != 0) {
            goto out;
        }

        alen += size;
    }
```

---
## 练习2: 完成基于文件系统的执行程序机制的实现（需要编码）

### 1. 实验内容
改写proc.c中的load_icode函数和其他相关函数，实现基于文件系统的执行程序机制。执行：make qemu。如果能看看到sh用户程序的执行界面，则基本成功了。如果在sh用户界面上可以执行exit, hello（更多用户程序放在user目录下）等其他放置在sfs文件系统中的其他执行程序，则可以认为本实验基本成功。

### 2. 关键实现步骤分析
#### （1）tlb刷新
在lab4的代码部分增加tlb刷新函数
```
if (proc != current)
    {
	bool intr_flag;
        struct proc_struct *prev = current;

        local_intr_save(intr_flag);
        {
            current = proc;
            lsatp(proc->pgdir);
            flush_tlb();
            switch_to(&(prev->context), &(proc->context));
        }
        local_intr_restore(intr_flag); 
    }
```
#### （2）进程地址空间的初始化
在加载用户程序之前，需要确保当前进程没有已有的地址空间：
```
if (current->mm != NULL) {
        panic("load_icode: current->mm must be empty.\n");
    }

    int ret = -E_NO_MEM;
    struct mm_struct *mm;
    
    //(1) Create a new mm for current process
    if ((mm = mm_create()) == NULL) {
        goto bad_mm;
    }
    
    //(2) Create a new PDT, and mm->pgdir = kernel virtual addr of PDT
    if (setup_pgdir(mm) != 0) {
        goto bad_pgdir_cleanup_mm;
    }
```

#### （3）从文件中读取 ELF 文件头
与 LAB5 直接访问内存中二进制不同，LAB8 中程序存储在文件系统中，因此：
需要通过文件描述符 fd
使用 load_icode_read() 从文件中读取 ELF Header
读取完成后，通过检查 ELF 魔数来验证文件是否合法，避免加载非 ELF 格式的文件。
```
struct elfhdr __elf, *elf = &__elf;
    if ((ret = load_icode_read(fd, elf, sizeof(struct elfhdr), 0)) != 0) {
        goto bad_elf_cleanup_pgdir;
    }
    
    //(3.2) Check if this is a valid ELF file

    if (elf->e_magic != ELF_MAGIC) {
        ret = -E_INVAL_ELF;
        goto bad_elf_cleanup_pgdir;
    }
    
    //(3.3) Read program headers

    struct proghdr __ph, *ph = &__ph;
    uint32_t vm_flags, perm;
    
    for (int i = 0; i < elf->e_phnum; i++) {
        off_t phoff = elf->e_phoff + i * sizeof(struct proghdr);
        if ((ret = load_icode_read(fd, ph, sizeof(struct proghdr), phoff)) != 0) {
            goto bad_cleanup_mmap;
        }
```

#### （4）逐个加载程序段（Program Header）

ELF 文件中可能包含多个程序段，代码通过遍历 Program Header 表，对每一个段进行处理：
对于每一个可加载段，执行以下操作：
（1）建立虚拟内存区域（VMA）
（2）加载 TEXT / DATA 段内容
（3）构建 BSS 段

```
if (ph->p_type != ELF_PT_LOAD) {
            continue;
        }
        if (ph->p_filesz > ph->p_memsz) {
            ret = -E_INVAL_ELF;
            goto bad_cleanup_mmap;
        }
        
        //(3.5) Setup VMA for this segment
        vm_flags = 0;
        perm = PTE_U | PTE_V;
        if (ph->p_flags & ELF_PF_X) vm_flags |= VM_EXEC;
        if (ph->p_flags & ELF_PF_W) vm_flags |= VM_WRITE;
        if (ph->p_flags & ELF_PF_R) vm_flags |= VM_READ;
        
        // Set RISC-V page permissions
        if (vm_flags & VM_READ) perm |= PTE_R;
        if (vm_flags & VM_WRITE) perm |= (PTE_W | PTE_R);
        if (vm_flags & VM_EXEC) perm |= PTE_X;
        
        if ((ret = mm_map(mm, ph->p_va, ph->p_memsz, vm_flags, NULL)) != 0) {
            goto bad_cleanup_mmap;
        }
        
        //(3.6) Allocate memory and load segment content
        size_t off, size;
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
        
        ret = -E_NO_MEM;
        
        //(3.6.1) Load TEXT/DATA from file
        end = ph->p_va + ph->p_filesz;
        while (start < end) {
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL) {
                goto bad_cleanup_mmap;
            }
            off = start - la;
            size = PGSIZE - off;
            if (end < la + PGSIZE) {
                size = end - start;
            }
            if ((ret = load_icode_read(fd, page2kva(page) + off, size, ph->p_offset + (start - ph->p_va))) != 0) {
                goto bad_cleanup_mmap;
            }
            start += size;
            la += PGSIZE;
        }
        
        //(3.6.2) Build BSS section (zero-filled)
        end = ph->p_va + ph->p_memsz;
        if (start < la) {
            if (start < end) {
                off = start - (la - PGSIZE);
                size = PGSIZE - off;
                if (end < la) {
                    size = end - start;
                }
                memset(page2kva(page) + off, 0, size);
                start += size;
            }
        }
        while (start < end) {
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL) {
                goto bad_cleanup_mmap;
            }
            off = start - la;
            size = PGSIZE - off;
            if (end < la + PGSIZE) {
                size = end - start;
            }
            memset(page2kva(page) + off, 0, size);
            start += size;
            la += PGSIZE;
        }
    }
```

#### （5）建立用户栈
程序段加载完成后，需要为用户进程建立运行时栈空间：
```
vm_flags = VM_READ | VM_WRITE | VM_STACK;
    if ((ret = mm_map(mm, USTACKTOP - USTACKSIZE, USTACKSIZE, vm_flags, NULL)) != 0) {
        goto bad_cleanup_mmap;
    }
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - PGSIZE, PTE_USER) != NULL);
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 2 * PGSIZE, PTE_USER) != NULL);
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 3 * PGSIZE, PTE_USER) != NULL);
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP - 4 * PGSIZE, PTE_USER) != NULL);
```
#### （6）切换到新的地址空间
```
mm_count_inc(mm);
    current->mm = mm;
    current->pgdir = PADDR(mm->pgdir);
    lsatp(PADDR(mm->pgdir));
```
#### （7）构建 argc / argv 并放入用户栈
```
uintptr_t stacktop = USTACKTOP;
    
    // Copy argument strings to user stack
    char **uargv = (char **)(stacktop - (argc + 1) * sizeof(char *));
    stacktop = (uintptr_t)uargv - ((stacktop - (uintptr_t)uargv) & 0xF); // 16-byte align
    
    // Reserve space for argv pointers
    uargv = (char **)(stacktop - (argc + 1) * sizeof(char *));
    
    // Copy each argument string
    for (int i = argc - 1; i >= 0; i--) {
        size_t len = strlen(kargv[i]) + 1;
        stacktop -= len;
        strcpy((char *)stacktop, kargv[i]);
        uargv[i] = (char *)stacktop;
    }
    uargv[argc] = NULL;
    
    // Align stack pointer
    stacktop = (uintptr_t)uargv;
    stacktop &= ~0xF; // 16-byte alignment for RISC-V
```
#### （8）初始化 trapframe 并进入用户态
```
struct trapframe *tf = current->tf;
    uintptr_t sstatus = tf->status;
    memset(tf, 0, sizeof(struct trapframe));
    
    tf->gpr.sp = stacktop;
    tf->epc = elf->e_entry;
    tf->status = sstatus & ~(SSTATUS_SPP | SSTATUS_SPIE);
    
    // Setup argc and argv in registers (RISC-V calling convention)
    tf->gpr.a0 = argc;
    tf->gpr.a1 = (uintptr_t)uargv;
```
---