import day05/manual
import error
import gleam/option.{None, Some}
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn rule_from_string_test() {
  let rule = "14|18" |> manual.rule_from
  should.equal(rule, Ok(manual.Rule(14, 18)))

  let rule = "a|18" |> manual.rule_from
  should.equal(rule, Error(error.Parsing))

  let rule = "18" |> manual.rule_from
  should.equal(rule, Error(error.Parsing))

  let rule = "|" |> manual.rule_from
  should.equal(rule, Error(error.Parsing))
}

pub fn manual_from_string_test() {
  let pages = "75,47,61,53,29" |> manual.manual_from
  should.equal(pages, Ok(manual.Pages([75, 47, 61, 53, 29])))

  let pages = "75,a,61,53,29" |> manual.manual_from
  should.equal(pages, Error(error.Parsing))

  let pages = "75, 47, 61, 53, 29" |> manual.manual_from
  should.equal(pages, Ok(manual.Pages([75, 47, 61, 53, 29])))
}

pub fn apply_rule_test() {
  let assert Ok(rule) = "47|53" |> manual.rule_from
  let assert Ok(pages) = "75,47,61,53,29" |> manual.manual_from

  should.be_true(pages |> manual.apply_rule(rule))

  let assert Ok(rule) = "47|75" |> manual.rule_from
  let assert Ok(pages) = "75,47,61,53,29" |> manual.manual_from

  should.be_false(pages |> manual.apply_rule(rule))

  let assert Ok(rule) = "47|28" |> manual.rule_from
  let assert Ok(pages) = "75,47,61,53,29" |> manual.manual_from

  should.be_true(pages |> manual.apply_rule(rule))

  let assert Ok(rule) = "28|53" |> manual.rule_from
  let assert Ok(pages) = "75,47,61,53,29" |> manual.manual_from

  should.be_true(pages |> manual.apply_rule(rule))
}

pub fn manual_get_middle_test() {
  let assert Ok(pages) = "75,47,61,53,29" |> manual.manual_from
  should.equal(pages |> manual.get_middle, Some(61))

  let assert Ok(pages) = "75,61,53,29" |> manual.manual_from
  should.equal(pages |> manual.get_middle, None)
}
