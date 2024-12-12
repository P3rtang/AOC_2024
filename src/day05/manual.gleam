import error
import gleam/int
import gleam/option.{Some}
import gleam/regexp
import gleam/result
import gleam/string
import list

pub type Rule {
  Rule(before: Int, after: Int)
}

pub fn rule_from(str: String) -> Result(Rule, error.AocError) {
  let assert Ok(re) = regexp.from_string("([0-9]+)\\|([0-9]+)")

  let match = str |> regexp.scan(with: re)

  case match {
    [regexp.Match(_, [Some(a), Some(b)])] -> {
      {
        use a <- result.try(a |> int.parse)
        use b <- result.map(b |> int.parse)
        Rule(a, b)
      }
      |> result.replace_error(error.Parsing)
    }
    _ -> Error(error.Parsing)
  }
}

pub type Manual {
  Pages(pages: List(Int))
}

pub fn manual_from(str: String) -> Result(Manual, error.AocError) {
  str
  |> string.split(",")
  |> list.map(string.trim)
  |> list.try_map(int.parse)
  |> result.map(Pages)
  |> result.replace_error(error.Parsing)
}

pub fn apply_rule(manual: Manual, rule: Rule) -> Bool {
  let Pages(pages) = manual
  let Rule(page_a, page_b) = rule

  let a_index =
    pages
    |> list.index_map(fn(item, idx) { #(idx, item) })
    |> list.find(fn(item) { item.1 == page_a })
    |> result.map(fn(item) { item.0 })
    |> result.unwrap(-1)

  let b_index =
    pages
    |> list.index_map(fn(item, idx) { #(idx, item) })
    |> list.find(fn(item) { item.1 == page_b })
    |> result.map(fn(item) { item.0 })
    |> result.unwrap(pages |> list.length)

  a_index <= b_index
}

pub fn get_middle(manual: Manual) -> option.Option(Int) {
  let Pages(pages) = manual

  case { pages |> list.length } % 2 == 1 {
    True -> pages |> list.at({ pages |> list.length } / 2)
    False -> option.None
  }
}
