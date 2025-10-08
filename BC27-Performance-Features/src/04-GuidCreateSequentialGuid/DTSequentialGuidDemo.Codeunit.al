// Guid.CreateSequentialGuid Demo for BC 27
// This codeunit demonstrates the new Guid.CreateSequentialGuid method
// which creates GUIDs that are more performant when used in table keys

codeunit 55005 "DT Sequential Guid Demo"
{
    var
        RecordCountMustBeGreaterThanZeroErr: Label 'Number of records must be greater than 0.';
        TestingWithRecordsMsg: Label 'Testing with %1 records...', Comment = '%1 = Number of records';
        PerformanceComparisonMsg: Label 'Performance comparison with %1 records:\\ \\Standard GUID: %2 ms\\Sequential GUID: %3 ms\\ \\Improvement: %4%', Comment = '%1 = Record count, %2 = Standard GUID time, %3 = Sequential GUID time, %4 = Improvement percentage';
        GuidComparisonMsg: Label 'Hooray!\\ \\GUID Comparison (4 consecutive records):\\ \\Standard GUIDs (random order):\\%1\\ \\Sequential GUIDs (ordered):\\%2\\ \\Sequential GUIDs are more performant for database indexing!', Comment = '%1 = Standard GUIDs list, %2 = Sequential GUIDs list';
        StandardGuidRecordLbl: Label 'Standard GUID Record %1', Comment = '%1 = Record number';
        SequentialGuidRecordLbl: Label 'Sequential GUID Record %1', Comment = '%1 = Record number';

    trigger OnRun()
    begin
        DemoSequentialGuidFeature();
    end;

    local procedure DemoSequentialGuidFeature()
    var
        TestTable: Record "DT Guid Performance Test Table";
        RecordCountInput: Page "DT Guid Record Count Input";
        StartTime: DateTime;
        EndTime: DateTime;
        StandardTime: Duration;
        SequentialTime: Duration;
        RecordCount: Integer;
    begin
        // Ask user for number of records to insert
        if RecordCountInput.RunModal() = Action::OK then
            RecordCount := RecordCountInput.GetRecordCount()
        else
            exit; // User cancelled

        if RecordCount <= 0 then
            Error(RecordCountMustBeGreaterThanZeroErr);

        Message(TestingWithRecordsMsg, RecordCount);

        // Clear test table
        TestTable.DeleteAll();

        // Test standard GUID performance
        StartTime := CurrentDateTime;
        CreateRecordsWithStandardGuid(RecordCount);
        EndTime := CurrentDateTime;
        StandardTime := EndTime - StartTime;

        // Test sequential GUID performance (don't delete - we need both for comparison)
        StartTime := CurrentDateTime;
        CreateRecordsWithSequentialGuid(RecordCount);
        EndTime := CurrentDateTime;
        SequentialTime := EndTime - StartTime;

        // Display results
        Message(PerformanceComparisonMsg,
            RecordCount, StandardTime, SequentialTime,
            Round((StandardTime - SequentialTime) / StandardTime * 100, 1));

        // Demonstrate both methods
        DemonstrateGuidCreation();
    end;

    local procedure CreateRecordsWithStandardGuid(RecordCount: Integer)
    var
        TestRecord: Record "DT Guid Performance Test Table";
        i: Integer;
    begin
        for i := 1 to RecordCount do begin
            TestRecord.Init();
            TestRecord."Record ID" := CreateGuid(); // Standard GUID creation
            TestRecord."Record Type" := TestRecord."Record Type"::Standard;
            TestRecord."Creation Time" := CurrentDateTime;
            TestRecord.Description := StrSubstNo(StandardGuidRecordLbl, i);
            TestRecord.Insert();
        end;
    end;

    local procedure CreateRecordsWithSequentialGuid(RecordCount: Integer)
    var
        TestRecord: Record "DT Guid Performance Test Table";
        i: Integer;
    begin
        for i := 1 to RecordCount do begin
            TestRecord.Init();
            TestRecord."Record ID" := Guid.CreateSequentialGuid(); // New BC 27 method
            TestRecord."Record Type" := TestRecord."Record Type"::Sequential;
            TestRecord."Creation Time" := CurrentDateTime;
            TestRecord.Description := StrSubstNo(SequentialGuidRecordLbl, i);
            TestRecord.Insert();
        end;
    end;

    local procedure DemonstrateGuidCreation()
    var
        TestTable: Record "DT Guid Performance Test Table";
        StandardGuids: Text;
        SequentialGuids: Text;
        i: Integer;
    begin
        // Clear and create 4 records with Standard GUIDs
        TestTable.Reset();
        TestTable.SetRange("Record Type", TestTable."Record Type"::Standard);
        if TestTable.FindSet() then begin
            StandardGuids := '';
            for i := 1 to 4 do begin
                if StandardGuids <> '' then
                    StandardGuids += @'
';
                StandardGuids += Format(TestTable."Record ID");
                if TestTable.Next() = 0 then
                    break;
            end;
        end;

        // Get 4 records with Sequential GUIDs
        TestTable.Reset();
        TestTable.SetRange("Record Type", TestTable."Record Type"::Sequential);
        if TestTable.FindSet() then begin
            SequentialGuids := '';
            for i := 1 to 4 do begin
                if SequentialGuids <> '' then
                    SequentialGuids += @'
';
                SequentialGuids += Format(TestTable."Record ID");
                if TestTable.Next() = 0 then
                    break;
            end;
        end;

        Message(GuidComparisonMsg, StandardGuids, SequentialGuids);
    end;
}