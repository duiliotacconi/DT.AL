// Optimized FlowField Calculations Demo for BC 27
// This codeunit demonstrates the improved FlowField calculation performance using SetAutoCalcFields

codeunit 55007 "DT FlowField Optimization Demo"
{
    var
        NodesExtractedMsg: Label '%1 profiling nodes extracted and displayed.', Comment = '%1 = Number of profiling nodes';
        CustomerNoFormatLbl: Label 'CUST%1', Locked = true;
        CustomerNameFormatLbl: Label 'Test Customer %1', Locked = true;

    trigger OnRun()
    begin
        DemoOptimizedFlowFields();
    end;

    local procedure DemoOptimizedFlowFields()
    var
        TempProfilingNode: Record "DT Profiling Node" temporary;
        SystemProfilingNode: Record "Profiling Node";
        SamplingPerformanceProfiler: Codeunit "Sampling Performance Profiler";
        ProfilingNodePage: Page "DT Profiling Node List";
        NodeCount: Integer;
    begin
        // Create test data
        CreateTestCustomerData();

        // Start performance profiler to capture SQL queries with faster sampling
        // Using enum ordinal 0 for fastest sampling interval (typically 50ms)
        SamplingPerformanceProfiler.Start("Sampling Interval".FromInteger(0));

        // Calculate FlowFields using SetAutoCalcFields (BC 27 optimization)
        CalculateFlowFieldsWithSetAutoCalc();

        // Stop profiler and get profiling nodes
        SamplingPerformanceProfiler.Stop();
        SamplingPerformanceProfiler.GetProfilingNodes(SystemProfilingNode);

        // Commit to close any write transactions before opening modal pages
        Commit();

        // Parse profiling nodes from the system profiling node record
        NodeCount := ParseProfilingNodes(SystemProfilingNode, TempProfilingNode);

        // Display profiling nodes
        if NodeCount > 0 then begin
            ProfilingNodePage.SetData(TempProfilingNode);
            ProfilingNodePage.RunModal();
            Message(NodesExtractedMsg, NodeCount);
        end;
    end;

    local procedure CreateTestCustomerData()
    var
        TestCustomer: Record "DT Customer Demo";
        SalesEntry: Record "DT Sales Entry";
        i, j : Integer;
        TotalCustomers: Integer;
        RandomDays: Integer;
    begin
        TotalCustomers := 1000;

        // Clear existing test data using Truncate for better performance
        TestCustomer.Truncate();
        SalesEntry.Truncate();

        // Commit after truncate to avoid transaction issues
        Commit();

        // Create test customers
        for i := 1 to TotalCustomers do begin
            TestCustomer.Init();
            TestCustomer."Customer No." := StrSubstNo(CustomerNoFormatLbl, Format(i, 4, '<Integer,4><Filler Character,0>'));
            TestCustomer.Name := StrSubstNo(CustomerNameFormatLbl, i);
            TestCustomer.Insert();

            // Create sales entries for each customer
            for j := 1 to Random(100) + 20 do begin
                SalesEntry.Init();
                SalesEntry."Entry No." := 0; // Auto-increment
                SalesEntry."Customer No." := TestCustomer."Customer No.";
                RandomDays := Random(365);
                SalesEntry."Posting Date" := WorkDate() - RandomDays;
                SalesEntry.Amount := Random(10000);
                SalesEntry."Document Type" := SalesEntry."Document Type"::Invoice;
                SalesEntry.Insert(true);
            end;
        end;
    end;

    local procedure CalculateFlowFieldsWithSetAutoCalc()
    var
        Customer: Record "DT Customer Demo";
    begin
        // BC 27 Optimization: Use SetAutoCalcFields to calculate all FlowFields at once
        // This reduces SQL roundtrips by batching FlowField calculations
        Customer.Reset();
        Customer.SetAutoCalcFields("No. of Sales Entries", "Last Sales Date");

        if Customer.FindSet() then
            repeat
            // FlowFields are automatically calculated when record is read
            // No need for individual CalcFields calls - BC 27 optimizes this!
            until Customer.Next() = 0;
    end;

    local procedure ParseProfilingNodes(var SystemProfilingNode: Record "Profiling Node"; var TempProfilingNode: Record "DT Profiling Node") NodeCount: Integer
    var
        FieldRef: FieldRef;
        RecRef: RecordRef;
    begin
        // Parse nodes into our temporary table
        NodeCount := 0;
        if SystemProfilingNode.FindSet() then
            repeat
                NodeCount += 1;
                TempProfilingNode.Init();
                TempProfilingNode."Entry No." := NodeCount; // Manual increment for temporary table

                // Use RecordRef to get field values dynamically
                RecRef.GetTable(SystemProfilingNode);

                // Try to get Node ID
                if RecRef.FieldExist(1) then begin
                    FieldRef := RecRef.Field(1);
                    TempProfilingNode."Node ID" := FieldRef.Value;
                end;

                // Try to get Function Name/Method
                if RecRef.FieldExist(10) then begin
                    FieldRef := RecRef.Field(10);
                    TempProfilingNode."Function Name" := CopyStr(Format(FieldRef.Value), 1, MaxStrLen(TempProfilingNode."Function Name"));

                    // Check if this is a SQL node
                    if StrPos(UpperCase(Format(FieldRef.Value)), 'SELECT') > 0 then begin
                        TempProfilingNode."Is SQL" := true;
                        TempProfilingNode."SQL Statement" := CopyStr(Format(FieldRef.Value), 1, MaxStrLen(TempProfilingNode."SQL Statement"));
                    end;
                end;

                // Try to get Object Type
                if RecRef.FieldExist(20) then begin
                    FieldRef := RecRef.Field(20);
                    TempProfilingNode."Object Type" := CopyStr(Format(FieldRef.Value), 1, MaxStrLen(TempProfilingNode."Object Type"));
                end;

                // Try to get Object Name
                if RecRef.FieldExist(30) then begin
                    FieldRef := RecRef.Field(30);
                    TempProfilingNode."Object Name" := CopyStr(Format(FieldRef.Value), 1, MaxStrLen(TempProfilingNode."Object Name"));
                end;

                // Try to get Object ID
                if RecRef.FieldExist(40) then begin
                    FieldRef := RecRef.Field(40);
                    Evaluate(TempProfilingNode."Object ID", Format(FieldRef.Value));
                end;

                // Try to get Hit Count  
                if RecRef.FieldExist(50) then begin
                    FieldRef := RecRef.Field(50);
                    Evaluate(TempProfilingNode."Hit Count", Format(FieldRef.Value));
                end;

                TempProfilingNode.Insert();
            until SystemProfilingNode.Next() = 0;
    end;
}
