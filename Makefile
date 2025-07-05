AS := i386-elf-as
LD := i386-elf-ld

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
	grub-mkrescue -o $@ $(build)/isodir \
		--compress=xz \
		--modules="multiboot normal configfile" \
		--fonts="" --themes=""

$(build)/os.bin: $(build)/boot.o $(build)/kernel.o
	mkdir -p $(dir $@)
	$(LD) $(LDFLAGS) -o $@ $^

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
