import day02/report.{type Report, Level, is_report_safe}
import error.{type AocError, FileError, Parsing}
import gleam/int
import gleam/list
import gleam/result
import gleam/string
import simplifile

fn from_line(line: String) -> Result(Report, AocError) {
  line
  |> string.split(" ")
  |> list.try_map(fn(str: String) {
    str
    |> string.trim
    |> int.parse
    |> result.replace_error(Parsing)
  })
  |> result.map(Level)
}

fn parse_file(path: String) -> Result(List(Report), AocError) {
  use content <- result.try(
    path |> simplifile.read |> result.replace_error(FileError),
  )
  use line <- list.try_map(content |> string.trim |> string.split("\n"))
  line |> from_line
}

pub fn solution1(path) -> Result(Int, AocError) {
  use safe_levels <- result.map({
    use reports <- result.map(path |> parse_file)
    use report <- list.map(reports)
    report
    |> fn(r) { r }
    |> is_report_safe(False)
  })

  use acc, safe <- list.fold(safe_levels, 0)
  case safe {
    True -> acc + 1
    False -> acc
  }
}

pub fn solution2(path) {
  use safe_levels <- result.map({
    use reports <- result.map(path |> parse_file)
    use report <- list.map(reports)
    report
    |> is_report_safe(True)
  })

  use acc, safe <- list.fold(safe_levels, 0)
  case safe {
    True -> acc + 1
    False -> acc
  }
}

pub fn solutions() -> Result(#(Int, Int), AocError) {
  let path = "./input/day02/1.txt"
  use sol1 <- result.try(path |> solution1)
  use sol2 <- result.map(path |> solution2)

  #(sol1, sol2)
}
