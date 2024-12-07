import gleam/list
import gleam/result

pub fn at(l: List(a), index) -> Result(a, Nil) {
  case l {
    [item, ..] if index == 0 -> Ok(item)
    [_, ..rest] -> at(rest, index - 1)
    [] -> Error(Nil)
  }
}

pub fn without(l: List(a), index: Int) -> List(a) {
  let #(a, b) = l |> list.split(index)
  let b = case b {
    [_, ..rest] -> rest
    [] -> l
  }
  list.flatten([a, b])
}

pub fn is_increasing(l: List(Int)) -> Bool {
  result.unwrap(
    {
      use first <- result.map(l |> list.first)

      use acc, item <- list.fold(l, #(first, 0))
      case acc.0 < item {
        True -> #(item, acc.1 + 1)
        False -> #(item, acc.1 - 1)
      }
    },
    #(0, -1),
  ).1
  > 0
}
