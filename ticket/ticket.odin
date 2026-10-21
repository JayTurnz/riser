package ticket

import "core:fmt"
import "core:encoding/json"
import "core:os"
import "core:log"
import "base:runtime"

Ticket_Struct :: struct {
    id : int,
    title: string,
    creator_id : int,
    status: Status,
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
                %-20s: %-40v
                %-20s: %-40d
                %-20s: %-40s
                """,
                "Title", ticket.title,
                "ID", ticket.id,
                "Creator", ticket.creator_id,
                "Status", ticket.status
)
}
