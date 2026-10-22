package ticket

import "core:fmt"
import "core:encoding/json"
import "core:os"
import "core:log"
import "base:runtime"
import "core:time"
import "core:time/datetime"
import "core:strings"
import "core:path/filepath"
import "../stringtime"

TICKET_PATH :: "tickets"

Ticket_Struct :: struct {
    iso8601_created: stringtime.iso8601_compact_string,
    iso8601_updated: stringtime.iso8601_compact_string,
    creator_id : int,
    status: Status,
    title: string,
    description: string,
}

Status :: enum uint {
    Open,
    Attending,
    Closed,
    Reopened
}

display :: proc(ticket: Ticket_Struct) { 
    fmt.printfln( """
                %-20s: %-40s
                %-20s: %-40s
                %-20s: %-40v
                %-20s: %-40d
                %-20s: %-40s
                """,
                "Title", ticket.title,
                "Description", ticket.description,
                "Date Created", ticket.iso8601_created,
                "Creator", ticket.creator_id,
                "Status", ticket.status
)
}

create :: proc(title: string, desc: string, creator_id: int) -> (new_ticket: ^Ticket_Struct) {
    b1 := make([]byte, 16)
    t := new(Ticket_Struct)
    time_now := time.now()
    datetime_now, _ := time.time_to_datetime(time.now())
    t.creator_id = creator_id;
    t.description = desc
    t.title = title
    t.status = Status.Open
    t.iso8601_created = strings.clone(stringtime.datetime_to_YYYYMMDDTHHMMSSZ(datetime_now, b1))
    t.iso8601_updated = t.iso8601_created
    
    json_data, err := json.marshal(t^, json.Marshal_Options{pretty = true, use_enum_names = true})  
    if err != nil {
        log.fatal(err)
        os.exit(1)
    }

    dirpath, dperr := filepath.join([]string{TICKET_PATH, t.iso8601_created})
    if dperr != nil {
        log.fatal(dperr)
        os.exit(1)
    }

    derr := os.make_directory_all(dirpath)
    if derr != nil {
        log.fatal(derr)
        os.exit(1)
    }

    filename, cerr := strings.concatenate([]string{t.iso8601_created, ".json"})
    if cerr != nil {
        log.fatal(cerr)
        os.exit(1)
    }

    path, jerr := filepath.join([]string{dirpath, filename})
    if jerr != nil {
        log.fatal(jerr)
        os.exit(1)
    }

    writeerr := os.write_entire_file(path, json_data)
    if writeerr != nil {
        log.fatal(writeerr)
        os.exit(1)
    }
    
    delete(b1)
    return t
}

