// Rec.Truncate Demo for BC 27
// This codeunit demonstrates the new Rec.Truncate method for faster data cleanup
// References:
// - https://yzhums.com/67343/
// - https://demiliani.com/2025/08/04/dynamics-365-business-central-finally-well-have-truncate-table-in-saas/
// - AA0475: Truncate can only be used on normal tables without media fields and outside of try functions

codeunit 55006 "DT Rec Truncate Demo"
{
    trigger OnRun()
    begin
        DemoRecTruncateFeature();
    end;

    local procedure DemoRecTruncateFeature()
    var
        RecordCountInput: Page "DT Truncate Record Count";
        RecordCount: Integer;
        TestFiltering: Boolean;
        FilterFrom: Integer;
        FilterTo: Integer;
    begin
        // Ask user for number of records to create
        if RecordCountInput.RunModal() = Action::OK then begin
            RecordCount := RecordCountInput.GetRecordCount();
            TestFiltering := RecordCountInput.GetTestFiltering();
            FilterFrom := RecordCountInput.GetFilterFrom();
            FilterTo := RecordCountInput.GetFilterTo();
        end else
            exit; // User cancelled

        if RecordCount <= 0 then
            Error(RecordCountMustBeGreaterThanZeroErr);

        if TestFiltering then
            Message(TestingWithRecordsFilteringMsg, RecordCount, FilterFrom, FilterTo)
        else
            Message(TestingWithRecordsMsg, RecordCount);

        if TestFiltering then
            RunFilteredDeletionTest(RecordCount, FilterFrom, FilterTo)
        else
            RunFullDeletionTest(RecordCount);

        // Demonstrate proper usage
        DemoProperTruncateUsage();
    end;

    local procedure RunFullDeletionTest(RecordCount: Integer)
    var
        TestTable: Record "DT Truncate Demo Table";
        StartTime: DateTime;
        EndTime: DateTime;
        TruncateTime: Duration;
        DeleteAllTime: Duration;
    begin
        // Create test data
        CreateTestData(RecordCount);

        // Test traditional DeleteAll performance (full table)
        TestTable.Reset();
        StartTime := CurrentDateTime;
        TestTable.DeleteAll();
        EndTime := CurrentDateTime;
        DeleteAllTime := EndTime - StartTime;

        // Recreate test data for Truncate test
        CreateTestData(RecordCount);

        // Test new Truncate performance (full table)
        TestTable.Reset();
        StartTime := CurrentDateTime;
        TestTable.Truncate(); // New BC 27 method - only works on full table
        EndTime := CurrentDateTime;
        TruncateTime := EndTime - StartTime;

        // Display performance comparison
        Message(PerformanceComparisonFullTableMsg,
            RecordCount, DeleteAllTime, TruncateTime);
    end;

    local procedure RunFilteredDeletionTest(RecordCount: Integer; FilterFrom: Integer; FilterTo: Integer)
    var
        TestTable: Record "DT Truncate Demo Table";
        StartTime: DateTime;
        EndTime: DateTime;
        DeleteAllFilteredTime: Duration;
        TruncateFilteredTime: Duration;
        FilteredRecordCount: Integer;
        ImprovementPct: Decimal;
    begin
        // Create test data
        CreateTestData(RecordCount);

        // Test DeleteAll with filter
        TestTable.Reset();
        TestTable.SetRange("Entry No.", FilterFrom, FilterTo);
        FilteredRecordCount := TestTable.Count();
        StartTime := CurrentDateTime;
        TestTable.DeleteAll();
        EndTime := CurrentDateTime;
        DeleteAllFilteredTime := EndTime - StartTime;

        // Recreate test data
        CreateTestData(RecordCount);

        // Test Truncate with filter
        TestTable.Reset();
        TestTable.SetRange("Entry No.", FilterFrom, FilterTo);
        StartTime := CurrentDateTime;
        TestTable.Truncate(); // BC 27: Truncate CAN be used with filters!
        EndTime := CurrentDateTime;
        TruncateFilteredTime := EndTime - StartTime;

        // Calculate improvement percentage
        if DeleteAllFilteredTime <> 0 then
            ImprovementPct := Round((DeleteAllFilteredTime - TruncateFilteredTime) / DeleteAllFilteredTime * 100, 1)
        else
            ImprovementPct := 0;

        // Display performance comparison with appropriate message
        if ImprovementPct < 0 then
            Message(PerformanceComparisonFilteringSlowerMsg,
                RecordCount, FilterFrom, FilterTo, FilteredRecordCount,
                DeleteAllFilteredTime, TruncateFilteredTime, Abs(ImprovementPct))
        else
            Message(PerformanceComparisonFilteringMsg,
                RecordCount, FilterFrom, FilterTo, FilteredRecordCount,
                DeleteAllFilteredTime, TruncateFilteredTime, ImprovementPct);
    end;

    local procedure CreateTestData(RecordCount: Integer)
    var
        TestRecord: Record "DT Truncate Demo Table";
        i: Integer;
    begin
        // Clear existing data first
        TestRecord.DeleteAll();

        for i := 1 to RecordCount do begin
            TestRecord.Init();
            TestRecord."Entry No." := i;
            TestRecord.Description := StrSubstNo(TestRecordDescriptionLbl, i);
            TestRecord."Created Date" := WorkDate();
            TestRecord."Amount" := Random(10000);
            TestRecord."Status" := TestRecord."Status"::Active;
            TestRecord.Insert();
        end;
    end;

    local procedure DemoProperTruncateUsage()
    var
        TestTable: Record "DT Truncate Demo Table";
    begin
        // Demonstrate when Truncate can be used vs when it cannot

        // 1. Truncate can be used on normal tables
        TestTable.Truncate(); // ✓ Valid - normal table without media fields

        // 2. Truncate with RecordRef
        DemoRecordRefTruncate();

        // 3. Show logging of truncate operations
        LogTruncateOperation('Truncate Demo Table', TestTable.Count());

        Message(TruncateOperationsCompletedMsg);
    end;

    local procedure DemoRecordRefTruncate()
    var
        RecRef: RecordRef;
    begin
        // Demonstrate Truncate with RecordRef
        RecRef.Open(Database::"DT Truncate Demo Table");
        RecRef.Truncate(); // Truncate via RecordRef
        RecRef.Close();
    end;

    local procedure LogTruncateOperation(TableName: Text; RecordsAffected: Integer)
    var
        LogEntry: Record "DT Truncate Log Table";
    begin
        LogEntry.Init();
        LogEntry."Entry No." := 0; // Will be auto-assigned
        LogEntry."Table Name" := CopyStr(TableName, 1, MaxStrLen(LogEntry."Table Name"));
        LogEntry."Operation DateTime" := CurrentDateTime;
        LogEntry."Records Affected" := RecordsAffected;
        LogEntry."Operation Type" := LogEntry."Operation Type"::Truncate;
        LogEntry."User ID" := CopyStr(UserId, 1, MaxStrLen(LogEntry."User ID"));
        LogEntry.Insert(true);
    end;

    // This procedure demonstrates what NOT to do with Truncate
    // [TryFunction] - AA0475: Truncate cannot be used inside try functions
    // local procedure InvalidTruncateUsage(): Boolean
    // var
    //     TestTable: Record "Truncate Demo Table";
    // begin
    //     TestTable.Truncate(); // This would cause AA0475 error
    //     exit(true);
    // end;

    var
        RecordCountMustBeGreaterThanZeroErr: Label 'Number of records must be greater than 0.';
        TestingWithRecordsMsg: Label 'Testing with %1 records...', Comment = '%1 = Record count';
        TestingWithRecordsFilteringMsg: Label 'Testing with %1 records (filtering from %2 to %3)...', Comment = '%1 = Record count, %2 = Filter From value, %3 = Filter To value';
        PerformanceComparisonFullTableMsg: Label 'Performance comparison for %1 records (FULL TABLE):\\ \\DeleteAll: %2 ms\\Truncate: %3 ms\\ \\Note: Truncate is optimized for full table deletion.', Comment = '%1 = Record count, %2 = DeleteAll time in milliseconds, %3 = Truncate time in milliseconds';
        PerformanceComparisonFilteringMsg: Label 'Performance comparison with FILTERING:\\ \\Total records created: %1\\Filtered records (%2 to %3): %4\\ \\DeleteAll with filter: %5 ms\\Truncate with filter: %6 ms\\ \\Improvement: %7%\\ \\Note: Truncate works with filters and is faster!', Comment = '%1 = Total records, %2 = Filter From, %3 = Filter To, %4 = Filtered record count, %5 = DeleteAll time, %6 = Truncate time, %7 = Improvement percentage';
        PerformanceComparisonFilteringSlowerMsg: Label 'Performance comparison with FILTERING:\\ \\Total records created: %1\\Filtered records (%2 to %3): %4\\ \\DeleteAll with filter: %5 ms\\Truncate with filter: %6 ms\\ \\Performance degradation: %7%\\ \\WARNING: In this case, Truncate with filters is SLOWER than DeleteAll!\\Consider using DeleteAll for filtered deletions when deleting a small subset of records.', Comment = '%1 = Total records, %2 = Filter From, %3 = Filter To, %4 = Filtered record count, %5 = DeleteAll time, %6 = Truncate time, %7 = Degradation percentage';
        TruncateOperationsCompletedMsg: Label 'Truncate operations completed.\\ \\Truncate is NOT possible when:\\ \\• Table is not a SQL table\\ \\• Table is a system table\\ \\• Used inside try functions\\ \\• Security filters are active\\ \\• There are subscribers to OnBeforeDelete/OnAfterDelete\\ \\• Table has Media fields\\ \\• Too many rows are Marked\\ \\• There are filters on FlowFields\\ \\Always test performance with your specific data patterns.';
        TestRecordDescriptionLbl: Label 'Test Record %1', Locked = true;
}