import Support
import Device

@main
struct Game {
    static func main() {
        p0.pin_cnf[21].modify { rw in
            rw.raw.dir = 1
        }
        p0.pin_cnf[28].modify { rw in
            rw.raw.dir = 1
        }

        var isOn = false
        while true {
            p0.out.modify { rw in
                rw.raw.pin21 = isOn ? 1 : 0
            }
            for _ in 0..<4000_000 {
                nop()
            }
            isOn = !isOn
        }
    }
}