permissionset 55000 "DT BC27 Perf"
{
    Assignable = true;
    Caption = 'BC27 Performance Features';

    Permissions =
        // Main Page
        page "DT BC27 Performance Features" = X,

        // Posting Order Demo
        codeunit "DT Posting Demo" = X,
        codeunit "DT Posting Order Subscriber" = X,
        table "DT Posting Order Log" = X,

        // SQL Profiler Demo
        codeunit "DT SQL Calls Profiler Demo" = X,

        // LockTimeout Demo
        codeunit "DT LockTimeout Demo" = X,
        codeunit "DT LockTimeout Management" = X,
        page "DT Lock Timeout Input" = X,

        // Sequential GUID Demo
        codeunit "DT Sequential Guid Demo" = X,
        tabledata "DT Guid Performance Test Table" = RIMD,
        table "DT Guid Performance Test Table" = X,
        page "DT GUID Performance Test" = X,
        page "DT Guid Record Count Input" = X,

        // Rec Truncate Demo
        codeunit "DT Rec Truncate Demo" = X,
        tabledata "DT Truncate Demo Table" = RIMD,
        table "DT Truncate Demo Table" = X,
        tabledata "DT Truncate Log Table" = RIMD,
        table "DT Truncate Log Table" = X,
        page "DT Truncate Perf Monitor" = X,
        page "DT Truncate Record Count" = X,

        // FlowField Demo
        codeunit "DT FlowField Optimization Demo" = X,
        tabledata "DT Customer Demo" = RIMD,
        table "DT Customer Demo" = X,
        tabledata "DT Sales Entry" = RIMD,
        table "DT Sales Entry" = X,
        table "DT Profiling Node" = X,
        page "DT FlowField Perf Demo" = X,
        page "DT Profiling Node List" = X,
        page "DT Profiling Node FactBox" = X;
}
