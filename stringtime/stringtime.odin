package stringtime

import "core:time/datetime"
import "core:fmt"

iso8601_compact_string :: string

datetime_to_YYYYMMDDTHHMMSSZ :: proc(dt: datetime.DateTime, buffer: []byte) -> iso8601_compact_string {
  i8601: iso8601_compact_string
  buffer := buffer
  i8601 = iso8601_compact_string(fmt.bprintf(buffer[:], "%04d%02d%02dT%02d%02d%02dZ", 
                                                        dt.year, dt.month, dt.day,
                                                        dt.hour, dt.minute ,dt.second))                                                     
  return i8601
}