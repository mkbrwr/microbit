# Microbit Debugging Guide

## How to Debug

### Step 1: Start the PyOCD GDB Server

Run the following command in your terminal:

```bash
pyocd gdbserver --frequency 100000
```

> **Note:** Using 100kHz frequency for stability. This can be increased if needed.

### Step 2: Connect with LLDB

In another terminal, start LLDB with your microbit executable:

```bash
lldb .build/release/microbit
```

### Step 3: Debug Commands

#### List Source Code

```lldb
(lldb) list microbit.swift:21
```

**Output:**
```
   21      p0.out.modify { rw in
   22          rw.raw.pin21 = isOn ? 1 : 0
   23      }
   24      for _ in 0..<4000_000 {
   25          nop()
   26      }
   27      isOn = !isOn
   28      counter += 1
   29      serialPutc(UInt8(counter))
   30      }
   31  }
```

#### Set Breakpoint

```lldb
(lldb) b microbit.swift:21
```

#### Connect to PyOCD GDB Server

```lldb
(lldb) gdb-remote localhost:3333
```

**Output:**
```
Process 1 stopped
* thread #1, stop reason = signal SIGTRAP
    frame #0: 0x00002ac4 microbit`specialized IndexingIterator.next() at <compiler-generated>:0
note: This address is not associated with a specific line of code. This may be due to compiler optimizations.
Target 0: (microbit) stopped.
```

#### View Current Breakpoints

```lldb
(lldb) b
```

**Output:**
```
Current breakpoints:
4: file = 'microbit.swift', line = 21, exact_match = 0, locations = 2, resolved = 2, hit count = 0
  4.1: where = microbit`static Application.main() + 150 at microbit.swift:21:13, address = 0x00002446, resolved, hit count = 0 
  4.2: where = microbit`closure #3 in static Application.main() + 18 at microbit.swift:22:32, address = 0x00002962, resolved, hit count = 0
```

#### Continue Execution

```lldb
(lldb) c
```

**Output:**
```
Process 1 resuming
Process 1 stopped
* thread #1, stop reason = breakpoint 4.1
    frame #0: 0x00002446 microbit`static Application.main() at microbit.swift:21:13
   18      var isOn = false
   19      var counter = 48
   20      while true {
-> 21          p0.out.modify { rw in
   22              rw.raw.pin21 = isOn ? 1 : 0
   23          }
   24          for _ in 0..<4000_000 {
Target 0: (microbit) stopped.
```

## Quick Reference

| Command | Description |
|---------|-------------|
| `list <file>:<line>` | Display source code at specified location |
| `b <file>:<line>` | Set breakpoint at specified location |
| `gdb-remote <host>:<port>` | Connect to remote GDB server |
| `c` | Continue execution |
| `b` | List all breakpoints |
| `n` | Step over (next line) |
| `s` | Step into |
| `finish` | Step out |
