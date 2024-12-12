import list
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn list_without_test() {
  [1, 2, 3, 4, 5, 6]
  |> list.without(3)
  |> should.equal([1, 2, 3, 5, 6])

  [1, 2, 3, 4, 5, 6]
  |> list.without(4)
  |> should.not_equal([1, 2, 3, 5, 6])
}
