package main

import "core:fmt"
import "core:encoding/json"
import "core:os"
import "base:runtime"
import "core:log"
import "ticket"
import "core:path/filepath"

main :: proc() {
    context.logger = log.create_console_logger()
    joined, join_err := filepath.join([]string{"/home", "jordan", "kbts", "riser","test.json"})
    if join_err != nil {
        log.fatal(join_err)
        os.exit(1)
    }
    data, read_err := os.read_entire_file(joined, context.allocator)
    if read_err != nil {
        log.fatal(read_err)
        os.exit(1)
    }
    defer delete(data)
    
    new_ticket: ticket.Ticket_Struct
    unmarsh_err := json.unmarshal(data, &new_ticket)
    if unmarsh_err != nil {
        log.fatal(unmarsh_err)
        os.exit(1)
    }
    // fmt.println(new_ticket) 
    ticket.display(new_ticket)
}

