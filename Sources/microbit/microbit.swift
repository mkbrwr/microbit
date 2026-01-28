import Support
import MMIO

@main
struct Application {
    static func main() {
        let arr = [1, 2, 3]
        p0.pin_cnf[21].write { w in
            w.dir = .Output
        }
        p0.pin_cnf[28].write { w in
            w.dir = .Output
        }
        enableClock()
        serialInit()

        var isOn = false
        var counter = 48
        while true {
            p0.out.modify { rw in
                rw.raw.pin21 = isOn ? 1 : 0
            }
            for _ in 0..<400_000 {
                nop()
            }
            isOn = !isOn

            counter += 1
            for i in arr {
                serialPutc(UInt8(counter + i))
            }
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
            rw.baudrate_field = .Baud115200
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
        uart0.txd.write { w in
            w.raw.txd_field = UInt32(char)
        }
        while uart0.events_ncts.read().events_ncts_field == .Generated {}
    }
}
