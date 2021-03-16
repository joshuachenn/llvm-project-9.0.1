# RUN: llvm-mc %s -triple=mips-unknown-linux -show-encoding -mcpu=mips32r2 | \
# RUN:   FileCheck %s --check-prefixes=CHECK,O32
# RUN: llvm-mc %s -triple=mips-unknown-linux -show-encoding -mcpu=mips32r6 | \
# RUN:   FileCheck %s --check-prefixes=CHECK,O32
# RUN: llvm-mc %s -triple=mips64-unknown-linux -show-encoding -mcpu=mips64r2 -target-abi=n32 | \
# RUN:   FileCheck %s --check-prefixes=CHECK,N32
# RUN: llvm-mc %s -triple=mips64-unknown-linux -show-encoding -mcpu=mips64r6 -target-abi=n32 | \
# RUN:   FileCheck %s --check-prefixes=CHECK,N32

# N64 should be acceptable too but we cannot convert la to dla yet.

la $5, 0x00000001 # CHECK: addiu $5, $zero, 1      # encoding: [0x24,0x05,0x00,0x01]
la $5, 0x00000002 # CHECK: addiu $5, $zero, 2      # encoding: [0x24,0x05,0x00,0x02]
la $5, 0x00004000 # CHECK: addiu $5, $zero, 16384  # encoding: [0x24,0x05,0x40,0x00]
la $5, 0x00008000 # CHECK: ori   $5, $zero, 32768  # encoding: [0x34,0x05,0x80,0x00]
la $5, 0xffffffff # CHECK: addiu $5, $zero, -1     # encoding: [0x24,0x05,0xff,0xff]
la $5, 0xfffffffe # CHECK: addiu $5, $zero, -2     # encoding: [0x24,0x05,0xff,0xfe]
la $5, 0xffffc000 # CHECK: addiu $5, $zero, -16384 # encoding: [0x24,0x05,0xc0,0x00]
la $5, 0xffff8000 # CHECK: addiu $5, $zero, -32768 # encoding: [0x24,0x05,0x80,0x00]

la $5, 0x00010000 # CHECK: lui $5, 1      # encoding: [0x3c,0x05,0x00,0x01]
la $5, 0x00020000 # CHECK: lui $5, 2      # encoding: [0x3c,0x05,0x00,0x02]
la $5, 0x40000000 # CHECK: lui $5, 16384  # encoding: [0x3c,0x05,0x40,0x00]
la $5, 0x80000000 # CHECK: lui $5, 32768  # encoding: [0x3c,0x05,0x80,0x00]
la $5, 0xffff0000 # CHECK: lui $5, 65535  # encoding: [0x3c,0x05,0xff,0xff]
la $5, 0xfffe0000 # CHECK: lui $5, 65534  # encoding: [0x3c,0x05,0xff,0xfe]
la $5, 0xc0000000 # CHECK: lui $5, 49152  # encoding: [0x3c,0x05,0xc0,0x00]
la $5, 0x80000000 # CHECK: lui $5, 32768  # encoding: [0x3c,0x05,0x80,0x00]

la $5, 0x00010001 # CHECK: lui $5, 1        # encoding: [0x3c,0x05,0x00,0x01]
                  # CHECK: ori $5, $5, 1    # encoding: [0x34,0xa5,0x00,0x01]
la $5, 0x00020001 # CHECK: lui $5, 2        # encoding: [0x3c,0x05,0x00,0x02]
                  # CHECK: ori $5, $5, 1    # encoding: [0x34,0xa5,0x00,0x01]
la $5, 0x40000001 # CHECK: lui $5, 16384    # encoding: [0x3c,0x05,0x40,0x00]
                  # CHECK: ori $5, $5, 1    # encoding: [0x34,0xa5,0x00,0x01]
la $5, 0x80000001 # CHECK: lui $5, 32768    # encoding: [0x3c,0x05,0x80,0x00]
                  # CHECK: ori $5, $5, 1    # encoding: [0x34,0xa5,0x00,0x01]
la $5, 0x00010002 # CHECK: lui $5, 1        # encoding: [0x3c,0x05,0x00,0x01]
                  # CHECK: ori $5, $5, 2    # encoding: [0x34,0xa5,0x00,0x02]
la $5, 0x00020002 # CHECK: lui $5, 2        # encoding: [0x3c,0x05,0x00,0x02]
                  # CHECK: ori $5, $5, 2    # encoding: [0x34,0xa5,0x00,0x02]
la $5, 0x40000002 # CHECK: lui $5, 16384    # encoding: [0x3c,0x05,0x40,0x00]
                  # CHECK: ori $5, $5, 2    # encoding: [0x34,0xa5,0x00,0x02]
la $5, 0x80000002 # CHECK: lui $5, 32768    # encoding: [0x3c,0x05,0x80,0x00]
                  # CHECK: ori $5, $5, 2    # encoding: [0x34,0xa5,0x00,0x02]
la $5, 0x00014000 # CHECK: lui $5, 1        # encoding: [0x3c,0x05,0x00,0x01]
                  # CHECK: ori $5, $5, 16384    # encoding: [0x34,0xa5,0x40,0x00]
la $5, 0x00024000 # CHECK: lui $5, 2            # encoding: [0x3c,0x05,0x00,0x02]
                  # CHECK: ori $5, $5, 16384    # encoding: [0x34,0xa5,0x40,0x00]
la $5, 0x40004000 # CHECK: lui $5, 16384        # encoding: [0x3c,0x05,0x40,0x00]
                  # CHECK: ori $5, $5, 16384    # encoding: [0x34,0xa5,0x40,0x00]
la $5, 0x80004000 # CHECK: lui $5, 32768        # encoding: [0x3c,0x05,0x80,0x00]
                  # CHECK: ori $5, $5, 16384    # encoding: [0x34,0xa5,0x40,0x00]
la $5, 0x00018000 # CHECK: lui $5, 1            # encoding: [0x3c,0x05,0x00,0x01]
                  # CHECK: ori $5, $5, 32768    # encoding: [0x34,0xa5,0x80,0x00]
la $5, 0x00028000 # CHECK: lui $5, 2            # encoding: [0x3c,0x05,0x00,0x02]
                  # CHECK: ori $5, $5, 32768    # encoding: [0x34,0xa5,0x80,0x00]
la $5, 0x40008000 # CHECK: lui $5, 16384        # encoding: [0x3c,0x05,0x40,0x00]
                  # CHECK: ori $5, $5, 32768    # encoding: [0x34,0xa5,0x80,0x00]
la $5, 0x80008000 # CHECK: lui $5, 32768        # encoding: [0x3c,0x05,0x80,0x00]
                  # CHECK: ori $5, $5, 32768    # encoding: [0x34,0xa5,0x80,0x00]
la $5, 0xffff4000 # CHECK: lui $5, 65535        # encoding: [0x3c,0x05,0xff,0xff]
                  # CHECK: ori $5, $5, 16384    # encoding: [0x34,0xa5,0x40,0x00]
la $5, 0xfffe8000 # CHECK: lui $5, 65534        # encoding: [0x3c,0x05,0xff,0xfe]
                  # CHECK: ori $5, $5, 32768    # encoding: [0x34,0xa5,0x80,0x00]
la $5, 0xc0008000 # CHECK: lui $5, 49152        # encoding: [0x3c,0x05,0xc0,0x00]
                  # CHECK: ori $5, $5, 32768    # encoding: [0x34,0xa5,0x80,0x00]
la $5, 0x80008000 # CHECK: lui $5, 32768        # encoding: [0x3c,0x05,0x80,0x00]
                  # CHECK: ori $5, $5, 32768    # encoding: [0x34,0xa5,0x80,0x00]

la $5, 0x00000001($6) # CHECK: addiu $5, $6, 1         # encoding: [0x24,0xc5,0x00,0x01]
la $5, 0x00000002($6) # CHECK: addiu $5, $6, 2         # encoding: [0x24,0xc5,0x00,0x02]
la $5, 0x00004000($6) # CHECK: addiu $5, $6, 16384     # encoding: [0x24,0xc5,0x40,0x00]
la $5, 0x00008000($6) # CHECK: ori   $5, $zero, 32768  # encoding: [0x34,0x05,0x80,0x00]
                      # CHECK: addu $5, $5, $6         # encoding: [0x00,0xa6,0x28,0x21]
la $5, 0xffffffff($6) # CHECK: addiu $5, $6, -1        # encoding: [0x24,0xc5,0xff,0xff]
la $5, 0xfffffffe($6) # CHECK: addiu $5, $6, -2        # encoding: [0x24,0xc5,0xff,0xfe]
la $5, 0xffffc000($6) # CHECK: addiu $5, $6, -16384    # encoding: [0x24,0xc5,0xc0,0x00]
la $5, 0xffff8000($6) # CHECK: addiu $5, $6, -32768    # encoding: [0x24,0xc5,0x80,0x00]

la $5, 0x00010000($6) # CHECK: lui $5, 1       # encoding: [0x3c,0x05,0x00,0x01]
                      # CHECK: addu $5, $5, $6 # encoding: [0x00,0xa6,0x28,0x21]
la $5, 0x00020000($6) # CHECK: lui $5, 2       # encoding: [0x3c,0x05,0x00,0x02]
                      # CHECK: addu $5, $5, $6 # encoding: [0x00,0xa6,0x28,0x21]
la $5, 0x40000000($6) # CHECK: lui $5, 16384   # encoding: [0x3c,0x05,0x40,0x00]
                      # CHECK: addu $5, $5, $6 # encoding: [0x00,0xa6,0x28,0x21]
la $5, 0x80000000($6) # CHECK: lui $5, 32768   # encoding: [0x3c,0x05,0x80,0x00]
                      # CHECK: addu $5, $5, $6 # encoding: [0x00,0xa6,0x28,0x21]
la $5, 0xffff0000($6) # CHECK: lui $5, 65535   # encoding: [0x3c,0x05,0xff,0xff]
                      # CHECK: addu $5, $5, $6 # encoding: [0x00,0xa6,0x28,0x21]
la $5, 0xfffe0000($6) # CHECK: lui $5, 65534   # encoding: [0x3c,0x05,0xff,0xfe]
                      # CHECK: addu $5, $5, $6 # encoding: [0x00,0xa6,0x28,0x21]
la $5, 0xc0000000($6) # CHECK: lui $5, 49152   # encoding: [0x3c,0x05,0xc0,0x00]
                      # CHECK: addu $5, $5, $6 # encoding: [0x00,0xa6,0x28,0x21]
la $5, 0x80000000($6) # CHECK: lui $5, 32768   # encoding: [0x3c,0x05,0x80,0x00]
                      # CHECK: addu $5, $5, $6 # encoding: [0x00,0xa6,0x28,0x21]

la $5, 0x00010001($6) # CHECK: lui $5, 1         # encoding: [0x3c,0x05,0x00,0x01]
                      # CHECK: ori $5, $5, 1     # encoding: [0x34,0xa5,0x00,0x01]
                      # CHECK: addu $5, $5, $6   # encoding: [0x00,0xa6,0x28,0x21]
la $5, 0x00020001($6) # CHECK: lui $5, 2         # encoding: [0x3c,0x05,0x00,0x02]
                      # CHECK: ori $5, $5, 1     # encoding: [0x34,0xa5,0x00,0x01]
                      # CHECK: addu $5, $5, $6   # encoding: [0x00,0xa6,0x28,0x21]
la $5, 0x40000001($6) # CHECK: lui $5, 16384     # encoding: [0x3c,0x05,0x40,0x00]
                      # CHECK: ori $5, $5, 1     # encoding: [0x34,0xa5,0x00,0x01]
                      # CHECK: addu $5, $5, $6   # encoding: [0x00,0xa6,0x28,0x21]
la $5, 0x80000001($6) # CHECK: lui $5, 32768     # encoding: [0x3c,0x05,0x80,0x00]
                      # CHECK: ori $5, $5, 1     # encoding: [0x34,0xa5,0x00,0x01]
                      # CHECK: addu $5, $5, $6   # encoding: [0x00,0xa6,0x28,0x21]
la $5, 0x00010002($6) # CHECK: lui $5, 1         # encoding: [0x3c,0x05,0x00,0x01]
                      # CHECK: ori $5, $5, 2     # encoding: [0x34,0xa5,0x00,0x02]
                      # CHECK: addu $5, $5, $6   # encoding: [0x00,0xa6,0x28,0x21]
la $5, 0x00020002($6) # CHECK: lui $5, 2         # encoding: [0x3c,0x05,0x00,0x02]
                      # CHECK: ori $5, $5, 2     # encoding: [0x34,0xa5,0x00,0x02]
                      # CHECK: addu $5, $5, $6   # encoding: [0x00,0xa6,0x28,0x21]
la $5, 0x40000002($6) # CHECK: lui $5, 16384     # encoding: [0x3c,0x05,0x40,0x00]
                      # CHECK: ori $5, $5, 2     # encoding: [0x34,0xa5,0x00,0x02]
                      # CHECK: addu $5, $5, $6   # encoding: [0x00,0xa6,0x28,0x21]
la $5, 0x80000002($6) # CHECK: lui $5, 32768     # encoding: [0x3c,0x05,0x80,0x00]
                      # CHECK: ori $5, $5, 2     # encoding: [0x34,0xa5,0x00,0x02]
                      # CHECK: addu $5, $5, $6   # encoding: [0x00,0xa6,0x28,0x21]
la $5, 0x00014000($6) # CHECK: lui $5, 1         # encoding: [0x3c,0x05,0x00,0x01]
                      # CHECK: ori $5, $5, 16384 # encoding: [0x34,0xa5,0x40,0x00]
                      # CHECK: addu $5, $5, $6   # encoding: [0x00,0xa6,0x28,0x21]
la $5, 0x00024000($6) # CHECK: lui $5, 2         # encoding: [0x3c,0x05,0x00,0x02]
                      # CHECK: ori $5, $5, 16384 # encoding: [0x34,0xa5,0x40,0x00]
                      # CHECK: addu $5, $5, $6   # encoding: [0x00,0xa6,0x28,0x21]
la $5, 0x40004000($6) # CHECK: lui $5, 16384     # encoding: [0x3c,0x05,0x40,0x00]
                      # CHECK: ori $5, $5, 16384 # encoding: [0x34,0xa5,0x40,0x00]
                      # CHECK: addu $5, $5, $6   # encoding: [0x00,0xa6,0x28,0x21]
la $5, 0x80004000($6) # CHECK: lui $5, 32768     # encoding: [0x3c,0x05,0x80,0x00]
                      # CHECK: ori $5, $5, 16384 # encoding: [0x34,0xa5,0x40,0x00]
                      # CHECK: addu $5, $5, $6   # encoding: [0x00,0xa6,0x28,0x21]
la $5, 0x00018000($6) # CHECK: lui $5, 1         # encoding: [0x3c,0x05,0x00,0x01]
                      # CHECK: ori $5, $5, 32768 # encoding: [0x34,0xa5,0x80,0x00]
                      # CHECK: addu $5, $5, $6   # encoding: [0x00,0xa6,0x28,0x21]
la $5, 0x00028000($6) # CHECK: lui $5, 2         # encoding: [0x3c,0x05,0x00,0x02]
                      # CHECK: ori $5, $5, 32768 # encoding: [0x34,0xa5,0x80,0x00]
                      # CHECK: addu $5, $5, $6   # encoding: [0x00,0xa6,0x28,0x21]
la $5, 0x40008000($6) # CHECK: lui $5, 16384     # encoding: [0x3c,0x05,0x40,0x00]
                      # CHECK: ori $5, $5, 32768 # encoding: [0x34,0xa5,0x80,0x00]
                      # CHECK: addu $5, $5, $6   # encoding: [0x00,0xa6,0x28,0x21]
la $5, 0x80008000($6) # CHECK: lui $5, 32768     # encoding: [0x3c,0x05,0x80,0x00]
                      # CHECK: ori $5, $5, 32768 # encoding: [0x34,0xa5,0x80,0x00]
                      # CHECK: addu $5, $5, $6   # encoding: [0x00,0xa6,0x28,0x21]
la $5, 0xffff4000($6) # CHECK: lui $5, 65535     # encoding: [0x3c,0x05,0xff,0xff]
                      # CHECK: ori $5, $5, 16384 # encoding: [0x34,0xa5,0x40,0x00]
                      # CHECK: addu $5, $5, $6   # encoding: [0x00,0xa6,0x28,0x21]
la $5, 0xfffe8000($6) # CHECK: lui $5, 65534     # encoding: [0x3c,0x05,0xff,0xfe]
                      # CHECK: ori $5, $5, 32768 # encoding: [0x34,0xa5,0x80,0x00]
                      # CHECK: addu $5, $5, $6   # encoding: [0x00,0xa6,0x28,0x21]
la $5, 0xc0008000($6) # CHECK: lui $5, 49152     # encoding: [0x3c,0x05,0xc0,0x00]
                      # CHECK: ori $5, $5, 32768 # encoding: [0x34,0xa5,0x80,0x00]
                      # CHECK: addu $5, $5, $6   # encoding: [0x00,0xa6,0x28,0x21]
la $5, 0x80008000($6) # CHECK: lui $5, 32768     # encoding: [0x3c,0x05,0x80,0x00]
                      # CHECK: ori $5, $5, 32768 # encoding: [0x34,0xa5,0x80,0x00]
                      # CHECK: addu $5, $5, $6   # encoding: [0x00,0xa6,0x28,0x21]

la $6, 0x00000001($6) # CHECK: addiu $6, $6, 1         # encoding: [0x24,0xc6,0x00,0x01]
la $6, 0x00000002($6) # CHECK: addiu $6, $6, 2         # encoding: [0x24,0xc6,0x00,0x02]
la $6, 0x00004000($6) # CHECK: addiu $6, $6, 16384     # encoding: [0x24,0xc6,0x40,0x00]
la $6, 0x00008000($6) # CHECK: ori   $1, $zero, 32768  # encoding: [0x34,0x01,0x80,0x00]
                      # CHECK: addu $6, $1, $6         # encoding: [0x00,0x26,0x30,0x21]
la $6, 0xffffffff($6) # CHECK: addiu $6, $6, -1        # encoding: [0x24,0xc6,0xff,0xff]
la $6, 0xfffffffe($6) # CHECK: addiu $6, $6, -2        # encoding: [0x24,0xc6,0xff,0xfe]
la $6, 0xffffc000($6) # CHECK: addiu $6, $6, -16384    # encoding: [0x24,0xc6,0xc0,0x00]
la $6, 0xffff8000($6) # CHECK: addiu $6, $6, -32768    # encoding: [0x24,0xc6,0x80,0x00]

la $6, 0x00010000($6) # CHECK: lui $1, 1       # encoding: [0x3c,0x01,0x00,0x01]
                      # CHECK: addu $6, $1, $6 # encoding: [0x00,0x26,0x30,0x21]
la $6, 0x00020000($6) # CHECK: lui $1, 2       # encoding: [0x3c,0x01,0x00,0x02]
                      # CHECK: addu $6, $1, $6 # encoding: [0x00,0x26,0x30,0x21]
la $6, 0x40000000($6) # CHECK: lui $1, 16384   # encoding: [0x3c,0x01,0x40,0x00]
                      # CHECK: addu $6, $1, $6 # encoding: [0x00,0x26,0x30,0x21]
la $6, 0x80000000($6) # CHECK: lui $1, 32768   # encoding: [0x3c,0x01,0x80,0x00]
                      # CHECK: addu $6, $1, $6 # encoding: [0x00,0x26,0x30,0x21]
la $6, 0xffff0000($6) # CHECK: lui $1, 65535   # encoding: [0x3c,0x01,0xff,0xff]
                      # CHECK: addu $6, $1, $6 # encoding: [0x00,0x26,0x30,0x21]
la $6, 0xfffe0000($6) # CHECK: lui $1, 65534   # encoding: [0x3c,0x01,0xff,0xfe]
                      # CHECK: addu $6, $1, $6 # encoding: [0x00,0x26,0x30,0x21]
la $6, 0xc0000000($6) # CHECK: lui $1, 49152   # encoding: [0x3c,0x01,0xc0,0x00]
                      # CHECK: addu $6, $1, $6 # encoding: [0x00,0x26,0x30,0x21]
la $6, 0x80000000($6) # CHECK: lui $1, 32768   # encoding: [0x3c,0x01,0x80,0x00]
                      # CHECK: addu $6, $1, $6 # encoding: [0x00,0x26,0x30,0x21]

la $6, 0x00010001($6) # CHECK: lui $1, 1         # encoding: [0x3c,0x01,0x00,0x01]
                      # CHECK: ori $1, $1, 1     # encoding: [0x34,0x21,0x00,0x01]
                      # CHECK: addu $6, $1, $6   # encoding: [0x00,0x26,0x30,0x21]
la $6, 0x00020001($6) # CHECK: lui $1, 2         # encoding: [0x3c,0x01,0x00,0x02]
                      # CHECK: ori $1, $1, 1     # encoding: [0x34,0x21,0x00,0x01]
                      # CHECK: addu $6, $1, $6   # encoding: [0x00,0x26,0x30,0x21]
la $6, 0x40000001($6) # CHECK: lui $1, 16384     # encoding: [0x3c,0x01,0x40,0x00]
                      # CHECK: ori $1, $1, 1     # encoding: [0x34,0x21,0x00,0x01]
                      # CHECK: addu $6, $1, $6   # encoding: [0x00,0x26,0x30,0x21]
la $6, 0x80000001($6) # CHECK: lui $1, 32768     # encoding: [0x3c,0x01,0x80,0x00]
                      # CHECK: ori $1, $1, 1     # encoding: [0x34,0x21,0x00,0x01]
                      # CHECK: addu $6, $1, $6   # encoding: [0x00,0x26,0x30,0x21]
la $6, 0x00010002($6) # CHECK: lui $1, 1         # encoding: [0x3c,0x01,0x00,0x01]
                      # CHECK: ori $1, $1, 2     # encoding: [0x34,0x21,0x00,0x02]
                      # CHECK: addu $6, $1, $6   # encoding: [0x00,0x26,0x30,0x21]
la $6, 0x00020002($6) # CHECK: lui $1, 2         # encoding: [0x3c,0x01,0x00,0x02]
                      # CHECK: ori $1, $1, 2     # encoding: [0x34,0x21,0x00,0x02]
                      # CHECK: addu $6, $1, $6   # encoding: [0x00,0x26,0x30,0x21]
la $6, 0x40000002($6) # CHECK: lui $1, 16384     # encoding: [0x3c,0x01,0x40,0x00]
                      # CHECK: ori $1, $1, 2     # encoding: [0x34,0x21,0x00,0x02]
                      # CHECK: addu $6, $1, $6   # encoding: [0x00,0x26,0x30,0x21]
la $6, 0x80000002($6) # CHECK: lui $1, 32768     # encoding: [0x3c,0x01,0x80,0x00]
                      # CHECK: ori $1, $1, 2     # encoding: [0x34,0x21,0x00,0x02]
                      # CHECK: addu $6, $1, $6   # encoding: [0x00,0x26,0x30,0x21]
la $6, 0x00014000($6) # CHECK: lui $1, 1         # encoding: [0x3c,0x01,0x00,0x01]
                      # CHECK: ori $1, $1, 16384 # encoding: [0x34,0x21,0x40,0x00]
                      # CHECK: addu $6, $1, $6   # encoding: [0x00,0x26,0x30,0x21]
la $6, 0x00024000($6) # CHECK: lui $1, 2         # encoding: [0x3c,0x01,0x00,0x02]
                      # CHECK: ori $1, $1, 16384 # encoding: [0x34,0x21,0x40,0x00]
                      # CHECK: addu $6, $1, $6   # encoding: [0x00,0x26,0x30,0x21]
la $6, 0x40004000($6) # CHECK: lui $1, 16384     # encoding: [0x3c,0x01,0x40,0x00]
                      # CHECK: ori $1, $1, 16384 # encoding: [0x34,0x21,0x40,0x00]
                      # CHECK: addu $6, $1, $6   # encoding: [0x00,0x26,0x30,0x21]
la $6, 0x80004000($6) # CHECK: lui $1, 32768     # encoding: [0x3c,0x01,0x80,0x00]
                      # CHECK: ori $1, $1, 16384 # encoding: [0x34,0x21,0x40,0x00]
                      # CHECK: addu $6, $1, $6   # encoding: [0x00,0x26,0x30,0x21]
la $6, 0x00018000($6) # CHECK: lui $1, 1         # encoding: [0x3c,0x01,0x00,0x01]
                      # CHECK: ori $1, $1, 32768 # encoding: [0x34,0x21,0x80,0x00]
                      # CHECK: addu $6, $1, $6   # encoding: [0x00,0x26,0x30,0x21]
la $6, 0x00028000($6) # CHECK: lui $1, 2         # encoding: [0x3c,0x01,0x00,0x02]
                      # CHECK: ori $1, $1, 32768 # encoding: [0x34,0x21,0x80,0x00]
                      # CHECK: addu $6, $1, $6   # encoding: [0x00,0x26,0x30,0x21]
la $6, 0x40008000($6) # CHECK: lui $1, 16384     # encoding: [0x3c,0x01,0x40,0x00]
                      # CHECK: ori $1, $1, 32768 # encoding: [0x34,0x21,0x80,0x00]
                      # CHECK: addu $6, $1, $6   # encoding: [0x00,0x26,0x30,0x21]
la $6, 0x80008000($6) # CHECK: lui $1, 32768     # encoding: [0x3c,0x01,0x80,0x00]
                      # CHECK: ori $1, $1, 32768 # encoding: [0x34,0x21,0x80,0x00]
                      # CHECK: addu $6, $1, $6   # encoding: [0x00,0x26,0x30,0x21]
la $6, 0xffff4000($6) # CHECK: lui $1, 65535     # encoding: [0x3c,0x01,0xff,0xff]
                      # CHECK: ori $1, $1, 16384 # encoding: [0x34,0x21,0x40,0x00]
                      # CHECK: addu $6, $1, $6   # encoding: [0x00,0x26,0x30,0x21]
la $6, 0xfffe8000($6) # CHECK: lui $1, 65534     # encoding: [0x3c,0x01,0xff,0xfe]
                      # CHECK: ori $1, $1, 32768 # encoding: [0x34,0x21,0x80,0x00]
                      # CHECK: addu $6, $1, $6   # encoding: [0x00,0x26,0x30,0x21]
la $6, 0xc0008000($6) # CHECK: lui $1, 49152     # encoding: [0x3c,0x01,0xc0,0x00]
                      # CHECK: ori $1, $1, 32768 # encoding: [0x34,0x21,0x80,0x00]
                      # CHECK: addu $6, $1, $6   # encoding: [0x00,0x26,0x30,0x21]
la $6, 0x80008000($6) # CHECK: lui $1, 32768     # encoding: [0x3c,0x01,0x80,0x00]
                      # CHECK: ori $1, $1, 32768 # encoding: [0x34,0x21,0x80,0x00]
                      # CHECK: addu $6, $1, $6   # encoding: [0x00,0x26,0x30,0x21]

la $5, symbol         # CHECK: lui $5, %hi(symbol)       # encoding: [0x3c,0x05,A,A]
                      # CHECK:                           #   fixup A - offset: 0, value: %hi(symbol), kind: fixup_Mips_HI16
                      # CHECK: addiu $5, $5, %lo(symbol) # encoding: [0x24,0xa5,A,A]
                      # CHECK:                           #   fixup A - offset: 0, value: %lo(symbol), kind: fixup_Mips_LO16
la $5, symbol($6)     # CHECK: lui $5, %hi(symbol)       # encoding: [0x3c,0x05,A,A]
                      # CHECK:                           #   fixup A - offset: 0, value: %hi(symbol), kind: fixup_Mips_HI16
                      # CHECK: addiu $5, $5, %lo(symbol) # encoding: [0x24,0xa5,A,A]
                      # CHECK:                           #   fixup A - offset: 0, value: %lo(symbol), kind: fixup_Mips_LO16
                      # CHECK: addu $5, $5, $6           # encoding: [0x00,0xa6,0x28,0x21]
la $6, symbol($6)     # CHECK: lui $1, %hi(symbol)       # encoding: [0x3c,0x01,A,A]
                      # CHECK:                           #   fixup A - offset: 0, value: %hi(symbol), kind: fixup_Mips_HI16
                      # CHECK: addiu $1, $1, %lo(symbol) # encoding: [0x24,0x21,A,A]
                      # CHECK:                           #   fixup A - offset: 0, value: %lo(symbol), kind: fixup_Mips_LO16
                      # CHECK: addu $6, $1, $6           # encoding: [0x00,0x26,0x30,0x21]
la $5, symbol+8       # CHECK: lui $5, %hi(symbol+8)       # encoding: [0x3c,0x05,A,A]
                      # CHECK:                             #   fixup A - offset: 0, value: %hi(symbol+8), kind: fixup_Mips_HI16
                      # CHECK: addiu $5, $5, %lo(symbol+8) # encoding: [0x24,0xa5,A,A]
                      # CHECK:                             #   fixup A - offset: 0, value: %lo(symbol+8), kind: fixup_Mips_LO16
la $5, symbol+8($6)   # CHECK: lui $5, %hi(symbol+8)       # encoding: [0x3c,0x05,A,A]
                      # CHECK:                             #   fixup A - offset: 0, value: %hi(symbol+8), kind: fixup_Mips_HI16
                      # CHECK: addiu $5, $5, %lo(symbol+8) # encoding: [0x24,0xa5,A,A]
                      # CHECK:                             #   fixup A - offset: 0, value: %lo(symbol+8), kind: fixup_Mips_LO16
                      # CHECK: addu $5, $5, $6             # encoding: [0x00,0xa6,0x28,0x21]
la $6, symbol+8($6)   # CHECK: lui $1, %hi(symbol+8)       # encoding: [0x3c,0x01,A,A]
                      # CHECK:                             #   fixup A - offset: 0, value: %hi(symbol+8), kind: fixup_Mips_HI16
                      # CHECK: addiu $1, $1, %lo(symbol+8) # encoding: [0x24,0x21,A,A]
                      # CHECK:                             #   fixup A - offset: 0, value: %lo(symbol+8), kind: fixup_Mips_LO16
                      # CHECK: addu $6, $1, $6             # encoding: [0x00,0x26,0x30,0x21]
la $5, 1f             # O32: lui $5, %hi($tmp0)            # encoding: [0x3c,0x05,A,A]
                      # O32:                               #   fixup A - offset: 0, value: %hi($tmp0), kind: fixup_Mips_HI16
                      # O32: addiu $5, $5, %lo($tmp0)      # encoding: [0x24,0xa5,A,A]
                      # O32:                               #   fixup A - offset: 0, value: %lo($tmp0), kind: fixup_Mips_LO16
                      # N32: lui $5, %hi(.Ltmp0)           # encoding: [0x3c,0x05,A,A]
                      # N32:                               #   fixup A - offset: 0, value: %hi(.Ltmp0), kind: fixup_Mips_HI16
                      # N32: addiu $5, $5, %lo(.Ltmp0)     # encoding: [0x24,0xa5,A,A]
                      # N32:                               #   fixup A - offset: 0, value: %lo(.Ltmp0), kind: fixup_Mips_LO16
1:
