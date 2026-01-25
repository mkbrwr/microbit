How to debug: 
% pyocd gdbserver --frequency 100000 ### 100Khz for stability, can be increased

In another terminal:
% lldb .build/release/microbit
(lldb) list microbit.swift:21 ### list debug information
   21  	            p0.out.modify { rw in
   22  	                rw.raw.pin21 = isOn ? 1 : 0
   23  	            }
   24  	            for _ in 0..<4000_000 {
   25  	                nop()
   26  	            }
   27  	            isOn = !isOn
   28  	            counter += 1
   29  	            serialPutc(UInt8(counter))
   30  	        }
   31  	    }
(lldb) b microbit.swift:21 ### set breakpoint
(lldb) gdb-remote localhost:3333 ### connect to pyOCD gdb server
Process 1 stopped
* thread #1, stop reason = signal SIGTRAP
    frame #0: 0x00002ac4 microbit`specialized IndexingIterator.next() at <compiler-generated>:0
note: This address is not associated with a specific line of code. This may be due to compiler optimizations.
Target 0: (microbit) stopped.
(lldb) b
Current breakpoints:
4: file = 'microbit.swift', line = 21, exact_match = 0, locations = 2, resolved = 2, hit count = 0
  4.1: where = microbit`static Application.main() + 150 at microbit.swift:21:13, address = 0x00002446, resolved, hit count = 0 
  4.2: where = microbit`closure #3 in static Application.main() + 18 at microbit.swift:22:32, address = 0x00002962, resolved, hit count = 0 
(lldb) c ### continue execution 
Process 1 resuming
Process 1 stopped
* thread #1, stop reason = breakpoint 4.1
    frame #0: 0x00002446 microbit`static Application.main() at microbit.swift:21:13
   18  	        var isOn = false
   19  	        var counter = 48
   20  	        while true {
-> 21  	            p0.out.modify { rw in
   22  	                rw.raw.pin21 = isOn ? 1 : 0
   23  	            }
   24  	            for _ in 0..<4000_000 {
Target 0: (microbit) stopped.
