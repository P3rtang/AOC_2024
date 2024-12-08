import error
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{Some}
import gleam/regexp as regex
import gleam/result
import gleam/string
import simplifile

pub fn get_substr(str: String, regex_str) -> List(#(Int, Int)) {
  let assert Ok(re) = regex.from_string(regex_str)
  use acc, regex.Match(_, match) <- list.fold(re |> regex.scan(str), [])

  case match {
    [Some(a), Some(b)] -> {
      {
        use a <- result.try(int.parse(a))
        use b <- result.map(int.parse(b))
        acc |> list.append([#(a, b)])
      }
      |> result.unwrap(acc)
    }
    _ -> acc
  }
}

fn solution1(path) {
  use content <- result.map(
    path |> simplifile.read |> result.replace_error(error.FileError),
  )
  use acc, item <- list.fold(
    content |> string.trim_end |> get_substr("mul\\(([0-9]*?),([0-9]*?)\\)"),
    0,
  )
  acc + item.0 * item.1
}

fn split_do(content, do_parts) {
  case content |> string.split_once("do()") {
    Ok(#(a, b)) -> {
      let b = split_do(b, do_parts)
      let a = case a |> string.split_once("don't()") {
        Ok(#(a, _)) -> do_parts |> list.append([a])
        Error(_) -> do_parts |> list.append([a])
      }
      a |> list.append(b)
    }
    Error(_) -> {
      case content |> string.split_once("don't()") {
        Ok(#(a, _)) -> do_parts |> list.append([a])
        Error(_) -> do_parts |> list.append([content])
      }
    }
  }
}

fn solution2(path) {
  use content <- result.map(
    path |> simplifile.read |> result.replace_error(error.FileError),
  )

  let content = content |> split_do([]) |> string.join("")

  use acc, item <- list.fold(
    content |> string.trim_end |> get_substr("mul\\(([0-9]*?),([0-9]*?)\\)"),
    0,
  )
  acc + item.0 * item.1
}

pub fn solutions() -> Result(#(Int, Int), error.AocError) {
  let path = "./input/day03/1.txt"
  use sol1 <- result.try(path |> solution1)
  use sol2 <- result.map(path |> solution2)

  #(sol1, sol2)
}
