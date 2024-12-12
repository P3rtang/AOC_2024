import list as l
import gleam/dict.{type Dict}
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result

pub type Grid(a) {
  Grid(items: List(a), cols: Int, rows: Int)
}

pub fn at(content: Grid(a), col, row) -> Option(a) {
  let Grid(items, cols, _) = content
  items |> l.at(cols * row + col)
}

fn check_equal(content: List(List(a))) -> Bool {
  let length =
    content |> list.first |> result.map(list.length) |> result.unwrap(0)
  use acc, l <- list.fold(content, True)
  acc && l |> list.length == length
}

pub fn to_grid(content: List(List(a))) -> Result(Grid(a), Nil) {
  let rows = content |> list.length
  let cols =
    content |> list.first |> result.map(list.length) |> result.unwrap(0)

  case content |> check_equal {
    True -> Ok(Grid(content |> list.flatten, cols, rows))
    False -> Error(Nil)
  }
}

pub fn to_list(grid: Grid(a)) -> List(List(a)) {
  let Grid(_, cols, rows) = grid

  use acc, y <- list.fold(list.range(0, rows - 1), [])
  let sub_list = {
    use acc, x <- list.fold(list.range(0, cols - 1), [])
    case grid |> at(x, y) {
      Some(a) -> acc |> list.append([a])
      None -> acc
    }
  }
  acc |> list.append([sub_list])
}

pub fn rotate(content: Grid(a)) -> Grid(a) {
  let Grid(_items, cols, rows) = content

  let items = {
    use acc, x <- list.fold(list.range(0, cols - 1), [])
    let sub_list = {
      use acc, y <- list.fold(list.range(0, rows - 1), [])
      case content |> at(x, y) {
        Some(a) -> acc |> list.append([a])
        None -> acc
      }
    }
    acc |> list.append(sub_list)
  }

  Grid(items, cols: rows, rows: cols)
}

pub fn to_diag_map(content: Grid(a)) -> Dict(Int, List(a)) {
  let Grid(_, rows, cols) = content
  use acc, row <- list.fold(list.range(0, rows - 1), dict.new())
  let sub_grid = {
    use sub_acc, col <- list.fold(list.range(0, cols - 1), dict.new())

    let append = fn(entry) {
      case entry, content |> at(col, row) {
        Some(entry), Some(item) -> entry |> list.append([item])
        None, Some(item) -> [item]
        _, None -> {
          []
        }
      }
    }

    dict.upsert(sub_acc, col + row, append)
  }
  use one, other <- dict.combine(acc, sub_grid)
  one |> list.append(other)
}
