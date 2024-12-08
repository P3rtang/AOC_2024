import gleam/bool
import gleam/int
import gleam/list
import gleam/option
import list as l

pub type Report {
  Level(val: List(Int))
}

pub fn is_report_safe(report: Report, has_dampener) -> Bool {
  let Level(value) = report
  let is_increasing = value |> l.is_increasing

  let is_safe = fn(value) {
    use chunk, index <- list.map2(
      { value |> chunk([]) }.1,
      list.range(value |> list.length |> int.subtract(1), 0),
    )
    #(chunk |> is_chunk_safe(is_increasing), index)
  }

  let all_safe = fn(value) {
    list.fold(is_safe(value), option.None, fn(acc, item) {
      case item.0 {
        True -> acc
        False -> option.Some(item.1)
      }
    })
  }

  case all_safe(value) {
    option.None -> True
    option.Some(idx) if has_dampener -> {
      value
      |> l.without(int.min(idx - 1, 0))
      |> all_safe
      |> option.is_none
      || value
      |> l.without(idx)
      |> all_safe
      |> option.is_none
    }
    _ -> False
  }
}

fn chunk(l: List(Int), chunks: List(Chunk)) -> #(List(Int), List(Chunk)) {
  case l {
    [a, b, ..rest] -> chunk([b, ..rest], [Chunk(#(a, b)), ..chunks])
    _ -> #([], chunks)
  }
}

type Chunk {
  Chunk(val: #(Int, Int))
}

fn is_chunk_safe(chunk: Chunk, is_increasing) -> Bool {
  let Chunk(chunk) = chunk

  let is_safe = fn(a, b) -> Bool {
    bool.exclusive_nor(a < b, is_increasing)
    && a != b
    && int.absolute_value(a - b) <= 3
  }

  is_safe(chunk.0, chunk.1)
}
