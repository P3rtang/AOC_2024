import gleam/dict
import gleam/int
import gleam/list
import gleam/option
import gleam/result
import gleam/string
import simplifile

pub fn parse_line(line: String) {
  use #(a, b) <- result.try(
    line
    |> string.trim_end
    |> string.split_once(on: " "),
  )

  use a_id <- result.try(int.parse(string.trim(a)))
  use b_id <- result.try(int.parse(string.trim(b)))

  Ok(#(a_id, b_id))
}

pub fn get_lists(content) {
  let content = string.trim_end(content)

  use list <- result.try({
    use line <- list.try_map(string.split(content, on: "\n"))
    parse_line(line)
  })

  let a_list =
    list.map(list, fn(entry) { entry.0 })
    |> list.sort(by: int.compare)

  let b_list =
    list.map(list, fn(entry) { entry.1 })
    |> list.sort(by: int.compare)

  Ok(#(a_list, b_list))
}

pub fn solution_1(input) {
  use content <- result.try(
    result.map_error(simplifile.read(from: input), fn(_) { Nil }),
  )

  use #(a_list, b_list) <- result.map(get_lists(content))

  list.map2(a_list, b_list, fn(a, b) { int.absolute_value(a - b) })
  |> list.fold(0, int.add)
}

pub fn solution_2(input) {
  use l <- result.map({
    use content <- result.try(
      result.map_error(simplifile.read(from: input), fn(_) { Nil }),
    )

    use #(a_list, b_list) <- result.try(get_lists(content))

    let map = {
      use map, entry <- list.fold(b_list, dict.new())
      use a <- dict.upsert(map, entry)
      case a {
        option.Some(i) -> i + 1
        option.None -> 1
      }
    }

    use entry <- list.try_map(a_list)
    let value = result.unwrap(dict.get(map, entry), or: 0)
    Ok(entry * value)
  })
  l |> int.sum
}

pub fn solutions() {
  let input = "./input/day01/1.txt"
  use sol_1 <- result.try(solution_1(input))
  use sol_2 <- result.map(solution_2(input))
  #(sol_1, sol_2)
}
