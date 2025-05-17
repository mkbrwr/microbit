import Device
import Support

@main
struct Application {
    static func main() {
        p0.pin_cnf[21].modify { rw in
            rw.raw.dir = 1
        }
        p0.pin_cnf[28].modify { rw in
            rw.raw.dir = 1
        }

        enableClock()
        serialInit()

        var isOn = false
        var counter = 48
        while true {
            p0.out.modify { rw in
                rw.raw.pin21 = isOn ? 1 : 0
            }
            for _ in 0..<4000_000 {
                nop()
            }
            isOn = !isOn
            counter += 1
            serialPutc(UInt8(counter))
        }
    }

    static func enableClock() {
        clock.tasks_hfclkstop.modify { r, w in
            w.tasks_hfclkstop_field = .Trigger
        }
        clock.tasks_hfclkstart.modify { r, w in
            w.tasks_hfclkstart_field = .Trigger
        }
        while clock.events_hfclkstarted.read().events_hfclkstarted_field != .Generated {}
    }

    static func serialInit() {
        uart0.enable.write { rw in
            rw.enable_field = .Disabled
        }
        uart0.baudrate.write { rw in
            rw.baudrate_field = .Baud9600
        }
        uart0.config.modify { rw in
            rw.parity = .Excluded
        }
        uart0.psel.txd.modify { rw in
            rw.raw.port = 0
            rw.raw.pin = 6
            rw.connect = .Connected
        }
        uart0.enable.write { rw in
            rw.enable_field = .Enabled
        }

        uart0.tasks_starttx.modify { r, w in
            w.tasks_starttx_field = .Trigger
        }
    }

    static func serialPutc(_ char: UInt8) {
        uart0.txd.modify { r, w in
            w.raw.txd_field = UInt32(char)
        }
        while uart0.events_txdrdy.read().events_txdrdy_field == .NotGenerated {}
    }
}
