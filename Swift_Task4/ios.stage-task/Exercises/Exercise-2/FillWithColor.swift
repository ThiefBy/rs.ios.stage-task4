import Foundation

final class FillWithColor {
    
    func fillWithColor(_ image: [[Int]], _ row: Int, _ column: Int, _ newColor: Int) -> [[Int]] {
        if row < 0 || column < 0{
            return image
        }
        
        if image.count < 1
            || image[0].count > 50
            || row >= image.count
            || column >= image[row].count
            || newColor >= 65536
        {
            return image
        }
        
        var result = image;
        var baseColor = image[row][column]
        
        fill(&result, row, column, newColor, baseColor)
        
        print("Result: \(result)")
        return result
    }

    private func fill( _ image: inout [[Int]], _ row: Int, _ column: Int, _ newColor: Int, _ baseColor: Int) {
        if row < 0 || column < 0 {
            return
        }
        
        if row >= image.count{
            return
        }
        
        if column >= image[row].count  {
            return
        }
        
        let target = image[row][column]
        if target == newColor || target != baseColor {
            return
        }

        print("Color row:\(row), column:\(column)")
        image[row][column] = newColor
        
        fill(&image, row + 1, column, newColor, baseColor)
        fill(&image, row - 1, column, newColor, baseColor)
        fill(&image, row, column+1, newColor, baseColor)
        fill(&image, row, column-1, newColor, baseColor)
    }
}
