import day04/diagonal
import error
import gleam/dict
import gleam/int
import gleam/list
import gleam/result
import gleam/string
import simplifile

fn to_list(str: String) -> List(String) {
  str |> to_list_rec([]) |> list.reverse
}

fn to_list_rec(str: String, l: List(String)) -> List(String) {
  case str |> string.pop_grapheme {
    Ok(#(a, rest)) -> to_list_rec(rest, [a, ..l])
    Error(_) -> l
  }
}

fn to_string(l: List(String)) -> String {
  use acc, char <- list.fold(l, "")
  acc <> char
}

fn check_equal(content: List(String)) -> Bool {
  let length =
    content |> list.first |> result.map(string.length) |> result.unwrap(0)
  use line <- list.all(content)
  line |> string.length == length
}

pub type Direction {
  Left
  Right
}

pub fn diagonal(
  content: List(String),
  direction: Direction,
) -> Result(List(String), error.AocError) {
  let content = case direction {
    Left -> content
    Right -> content |> list.reverse
  }

  let list_length = content |> list.length
  let str_length =
    content |> list.first |> result.map(string.length) |> result.unwrap(0)

  let grid =
    diagonal.Grid(
      content |> list.map(to_list) |> list.flatten,
      cols: str_length,
      rows: list_length,
    )

  case content |> check_equal {
    False -> Error(error.LineSize)
    True -> {
      grid |> diagonal.to_diag_map |> dict.values |> list.map(to_string) |> Ok
    }
  }
}

fn count_xmas(content: List(String)) -> Int {
  use acc, line <- list.fold(content, 0)
  acc
  + {
    line
    |> string.split("XMAS")
    |> list.fold(-1, fn(acc, _) { acc |> int.add(1) })
  }
  + {
    line
    |> string.split("SAMX")
    |> list.fold(-1, fn(acc, _) { acc |> int.add(1) })
  }
}

pub fn solution1(path) -> Result(Int, error.AocError) {
  use input <- result.try(
    path |> simplifile.read |> result.replace_error(error.FileError),
  )

  let input =
    input
    |> string.trim
    |> string.split("\n")

  let hor = input |> count_xmas
  use grid <- result.try(
    input
    |> list.map(to_list)
    |> diagonal.to_grid
    |> result.replace_error(error.LineSize),
  )
  let ver =
    grid
    |> diagonal.rotate
    |> diagonal.to_list
    |> list.map(to_string)
    |> count_xmas

  use left <- result.try(
    input
    |> diagonal(Left)
    |> result.map(count_xmas),
  )

  use right <- result.map(
    input
    |> diagonal(Right)
    |> result.map(count_xmas),
  )

  hor + ver + left + right
}

pub fn solution2(path) -> Result(Int, error.AocError) {
  use input <- result.try(
    path |> simplifile.read |> result.replace_error(error.FileError),
  )

  let input =
    input
    |> string.trim
    |> string.split("\n")

  use left <- result.try(
    input
    |> diagonal(Left)
    |> result.map(count_xmas),
  )

  use right <- result.map(
    input
    |> diagonal(Right)
    |> result.map(count_xmas),
  )

  left + right
}

pub fn solutions() -> Result(#(Int, Int), error.AocError) {
  let path = "./input/day04/1.txt"

  use sol1 <- result.try(path |> solution1)
  use sol2 <- result.map(path |> solution2)

  #(sol1, sol2)
}
