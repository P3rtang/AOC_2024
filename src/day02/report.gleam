import day02/list as l
import gleam/bool
import gleam/int
import gleam/io
import gleam/list
import gleam/option

pub type Report {
  Level(val: List(Int))
}

pub fn is_report_safe(report: Report) -> Bool {
  let Level(value) = report
  let is_increasing = value |> l.is_increasing

  let is_safe = fn(value) {
    use chunk, index <- list.map2(
      chunk(value, [], is_increasing).1,
      list.range(0, value |> list.length),
    )
    #(is_chunk_safe(chunk), index)
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
    option.Some(idx) -> {
      value
      |> io.debug
      |> l.without(idx)
      |> io.debug
      |> fn(val) { all_safe(val) |> option.is_none }
      || value
      |> l.without(idx + 1)
      |> fn(val) { all_safe(val) |> option.is_none }
    }
  }
}

fn chunk(
  l: List(Int),
  chunks: List(ReportChunk),
  is_increasing,
) -> #(List(Int), List(ReportChunk)) {
  case l {
    [a, b, ..rest] ->
      chunk(
        [b, ..rest],
        [Chunk(#(a, b), is_increasing), ..chunks],
        is_increasing,
      )
    _ -> #([], chunks)
  }
}

pub type ReportChunk {
  Chunk(val: #(Int, Int), is_increasing: Bool)
}

fn is_chunk_safe(chunk: ReportChunk) -> Bool {
  let Chunk(chunk, is_increasing) = chunk

  let is_safe = fn(a, b) -> Bool {
    bool.exclusive_nor(a < b, is_increasing)
    && a != b
    && int.absolute_value(a - b) <= 3
  }

  is_safe(chunk.0, chunk.1)
}
