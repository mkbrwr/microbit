/// Clock control
nonisolated(unsafe) public let clock = CLOCK(unsafeAddress: 0x40000000)

/// GPIO Port 1
nonisolated(unsafe) public let p0 = P0(unsafeAddress: 0x50000000)

/// GPIO Port 2
nonisolated(unsafe) public let p1 = P1(unsafeAddress: 0x50000300)

/// Universal Asynchronous Receiver/Transmitter
nonisolated(unsafe) public let uart0 = UART0(unsafeAddress: 0x40002000)
