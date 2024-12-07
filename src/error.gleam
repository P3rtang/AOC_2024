pub type AocError {
  FileError
  Parsing
  LineSize
}

pub fn to_string(error: AocError) -> String {
  case error {
    FileError -> "Error reading file"
    Parsing -> "Error parsing line"
    LineSize -> "Parsed line has an incorrect length"
  }
}
