import Foundation

public extension Int {
    var roman: String? {
        
        if self < 1 || self > 3999 {
            return nil;
        }

        var result = ""
        
        let conversionMap   =
            [(1000, "M"),
             (900, "CM"),
             (500, "D"),
             (400, "CD"),
             (100, "C"),
             (90, "XC"),
             (50, "L"),
             (40, "XL"),
             (10, "X"),
             (9, "IX"),
             (5, "V"),
             (4, "IV"),
             (1, "I")]
        var temp = self
        for map in conversionMap where (map.0 <= temp) {
            let multiplyer = temp/map.0
            temp -= map.0*multiplyer
            result += String(repeating: map.1, count: multiplyer)
        }
        
        return result
    }
}
