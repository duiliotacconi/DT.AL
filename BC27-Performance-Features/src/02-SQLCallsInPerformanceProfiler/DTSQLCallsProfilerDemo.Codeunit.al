// SQL Calls in Performance Profiler Demo
// This codeunit demonstrates how to use the Sampling Performance Profiler in BC 27
// to collect profiler data and view SQL call information
// Reference: https://learn.microsoft.com/en-us/dynamics365/release-plan/2025wave2/smb/dynamics365-business-central/view-sql-call-information-performance-profiles

codeunit 55002 "DT SQL Calls Profiler Demo"
{
    var
        ProfileDownloadedSuccessfullyMsg: Label 'Profile downloaded successfully!\\You can open it in Visual Studio Code with the AL Profiler extension\\to view SQL statements, execution times, and row counts.';
        ProfileDownloadCancelledMsg: Label 'Profile download cancelled or failed.';
        ProfileFileNameFormatLbl: Label 'Profile_%1.alcpuprofile', Locked = true;

    trigger OnRun()
    begin
        DemoSQLCallsTracking();
    end;

    procedure DemoSQLCallsTracking()
    var
        SamplingPerformanceProfiler: Codeunit "Sampling Performance Profiler";
    begin
        // Start the performance profiler
        SamplingPerformanceProfiler.Start();

        // Execute a scenario while profiling
        RunDemoScenario();

        // Stop the profiler and download the profile
        SamplingPerformanceProfiler.Stop();

        // Download the profile data
        DownloadProfile();
    end;

    local procedure DownloadProfile()
    var
        SamplingPerformanceProfiler: Codeunit "Sampling Performance Profiler";
        InStr: InStream;
        FileName: Text;
    begin
        FileName := StrSubstNo(ProfileFileNameFormatLbl, Format(CurrentDateTime, 0, '<Year4><Month,2><Day,2>_<Hours24><Minutes,2><Seconds,2>'));

        // Get the profile data as an InStream
        InStr := SamplingPerformanceProfiler.GetData();

        if DownloadFromStream(InStr, 'Download Profile', '', 'Profile Files (*.alcpuprofile)|*.alcpuprofile', FileName) then
            Message(ProfileDownloadedSuccessfullyMsg)
        else
            Message(ProfileDownloadCancelledMsg);
    end;

    local procedure RunDemoScenario()
    begin
        // Execute various database operations while profiling
        DemoSimpleSelect();
        DemoComplexJoin();
        DemoFilteredQuery();
        DemoAggregation();
    end;

    local procedure DemoSimpleSelect()
    var
        Customer: Record Customer;
    begin
        // Simple SELECT operation
        if Customer.FindSet() then
            repeat
            // This will generate simple SQL SELECT statements visible in profiler
            until Customer.Next() = 0;
    end;

    local procedure DemoComplexJoin()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        // Complex JOIN operation
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        if SalesHeader.FindFirst() then begin
            SalesLine.SetRange("Document Type", SalesHeader."Document Type");
            SalesLine.SetRange("Document No.", SalesHeader."No.");
            if SalesLine.FindSet() then
                repeat
                // This creates JOIN operations visible in the profiler
                until SalesLine.Next() = 0;
        end;
    end;

    local procedure DemoFilteredQuery()
    var
        Item: Record Item;
    begin
        // Filtered queries with different complexity
        Item.SetFilter("Unit Price", '>%1', 100);
        Item.SetRange(Blocked, false);
        Item.SetRange(Type, Item.Type::Inventory);

        if Item.FindSet() then
            repeat
            // Complex filtered queries visible in profiler
            until Item.Next() = 0;
    end;

    local procedure DemoAggregation()
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        TotalQuantity: Decimal;
    begin
        // Aggregation operations
        ItemLedgerEntry.SetCurrentKey("Item No.", "Posting Date");
        ItemLedgerEntry.SetRange("Posting Date", CalcDate('<-1M>', WorkDate()), WorkDate());

        if ItemLedgerEntry.FindSet() then
            repeat
                TotalQuantity += ItemLedgerEntry.Quantity;
            until ItemLedgerEntry.Next() = 0;

        // Use the result to avoid unused variable warning
        if TotalQuantity <> 0 then;
    end;
}