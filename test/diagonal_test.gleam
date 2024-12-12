import day04/diagonal.{type Grid, Grid, at, rotate, to_diag_map}
import gleam/dict
import gleam/option.{Some}
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

fn test_grid() {
  Grid([1, 2, 3, 4, 5, 6, 7, 8, 9], cols: 3, rows: 3)
}

fn test_grid_2() {
  Grid([1, 2, 3, 4, 5, 6], cols: 2, rows: 3)
}

pub fn grid_at_test() {
  should.equal(test_grid() |> at(0, 1), Some(4))
}

pub fn grid_diag_map_test() {
  let expect =
    dict.from_list([
      #(0, [1]),
      #(1, [2, 4]),
      #(2, [3, 5, 7]),
      #(3, [6, 8]),
      #(4, [9]),
    ])

  test_grid() |> to_diag_map |> should.equal(expect)
}

pub fn grid_rotate_test() {
  let expect = Grid([1, 3, 5, 2, 4, 6], cols: 3, rows: 2)
  test_grid_2() |> rotate |> should.equal(expect)
}
