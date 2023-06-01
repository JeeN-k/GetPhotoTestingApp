import Foundation

let testData: [[Int]] = [[1, 0, 0, 1], [0, 1, 1, 0], [0, 0, 0, 0], [1, 0, 0, 1]]

func updateMatrix(_ mat: [[Int]]) -> [[Int]] {
    let rows = mat.count
    let cols = mat[0].count
    var result = Array(repeating: Array(repeating: Int.max, count: cols), count: rows)
    var queue = [(Int, Int)]()

    for i in 0..<rows {
        for j in 0..<cols {
            if mat[i][j] == 1 {
                result[i][j] = 0
                queue.append((i, j))
            }
        }
    }
    
    let dirs = [(0, 1), (0, -1), (1, 0), (-1, 0)]
    while !queue.isEmpty {
        let curr = queue.removeFirst() // Получаем первую ячейку из очереди
        let currRow = curr.0
        let currCol = curr.1
        // Проходим по всем направлениям движения
        for dir in dirs {
            // Перемещаемся на соседнюю ячейку
            let newRow = currRow + dir.0
            let newCol = currCol + dir.1
            // Проверяем на то, что ячейка внутри границы матрицы
            if newRow >= 0 && newRow < rows && newCol >= 0 && newCol < cols {
                // Если новое расстояние меньше текущего, то обновляем значение в матрице расстояний
                if result[newRow][newCol] > result[currRow][currCol] + 1 {
                    result[newRow][newCol] = result[currRow][currCol] + 1
                    // Добавляем обновленную ячейку в очередь для дальнейшего BFS
                    queue.append((newRow, newCol))
                }
            }
        }
    }
    return result
}

let matr = updateMatrix(testData)
print(matr)
