// import day01/solution as day01
import day02/solution as day02
import error
import gleam/dict
import gleam/int
import gleam/io
import gleam/option
import gleam/string
import tempo/duration

const ansi_escape = "\u{001b}"

const solutions = [#(1, #(2_285_373, 21_142_653)), #(2, #(407, -1))]

pub fn check_solution(
  day: Int,
  solution: #(Int, Int),
) -> option.Option(#(Bool, Bool)) {
  case
    dict.from_list(solutions)
    |> dict.get(day)
  {
    Ok(answer) if answer.1 != -1 ->
      #(answer.0 == solution.0, answer.1 == solution.1) |> option.Some
    _ -> option.None
  }
}

pub fn timer(func: fn() -> a) -> #(a, Int) {
  let clock = duration.start_monotonic()
  let solution = func()
  let dur =
    clock
    |> duration.stop_monotonic
    |> duration.as_milliseconds

  #(solution, dur)
}

pub fn print_solution(
  day,
  func: fn() -> Result(#(Int, Int), error.AocError),
) -> Nil {
  io.println(
    string.repeat("-", 12)
    <> " Day "
    <> int.to_string(day)
    |> string.pad_start(to: 2, with: " ")
    <> " "
    <> string.repeat("-", 12),
  )

  let color = fn(correct: Bool) -> String {
    case correct {
      True -> "32"
      False -> "31"
    }
  }

  let description = fn(correct: Bool) -> String {
    case correct {
      True -> "Correct"
      False -> "Incorrect"
    }
  }

  case func |> timer {
    #(Ok(#(sol_1, sol_2)), dur) -> {
      case check_solution(day, #(sol_1, sol_2)) {
        option.Some(check) -> {
          io.print("Solution 1: " <> int.to_string(sol_1))
          io.println(
            "\t"
            <> ansi_escape
            <> "["
            <> color(check.0)
            <> "m"
            <> description(check.0)
            <> ansi_escape
            <> "[0m",
          )
          io.print("Solution 2: " <> int.to_string(sol_2))
          io.println(
            "\t"
            <> ansi_escape
            <> "["
            <> color(check.1)
            <> "m"
            <> description(check.1)
            <> ansi_escape
            <> "[0m",
          )
        }
        option.None -> {
          io.println("Solution 1: " <> int.to_string(sol_1))
          io.println("Solution 2: " <> int.to_string(sol_2))
        }
      }
      io.println("\n" <> "Took " <> int.to_string(dur) <> "ms")
    }
    #(Error(err), _) -> err |> error.to_string |> io.println
  }
  // string.repeat("-", 32) |> io.println
  io.println("")
}

pub fn main() {
  // print_solution(1, day01.solutions)
  print_solution(2, day02.solutions)
}
