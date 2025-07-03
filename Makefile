CC := i686-elf-gcc
AS := i686-elf-as

CFLAGS := -std=gnu99 -ffreestanding -O2 -nostdlib -Wall -Wextra
LDFLAGS := -T linker.ld

build = .build

.PHONY: all
all: os.iso

.PHONY: run-vm
run-vm: os.iso
	qemu-system-i386 -cdrom os.iso

os.iso: $(build)/os.iso
	cp $< $@

$(build)/isodir/boot/grub/grub.cfg: grub.cfg
	mkdir -p $(dir $@)
	cp $< $@

$(build)/isodir/boot/os.bin: $(build)/os.bin
	mkdir -p $(dir $@)
	cp $< $@

$(build)/os.iso: \
	    $(build)/os.bin \
		$(build)/isodir/boot/grub/grub.cfg \
		$(build)/isodir/boot/os.bin
	grub-mkrescue -o $@ $(build)/isodir

$(build)/os.bin: $(build)/boot.o $(build)/kernel.o
	mkdir -p $(dir $@)
	$(CC) $(LDFLAGS) -o $@ $(CFLAGS) $^ -lgcc

$(build)/boot.o: boot.s
	mkdir -p $(dir $@)
	$(AS) $< -o $@

$(build)/kernel.o: kernel.c
	mkdir -p $(dir $@)
	$(CC) -c $< -o $@ $(CFLAGS)


fclean:
	$(RM) -r $(build)
	$(RM) os.iso


.PHONY: re
.NOTPARALLEL: re
re: fclean all
