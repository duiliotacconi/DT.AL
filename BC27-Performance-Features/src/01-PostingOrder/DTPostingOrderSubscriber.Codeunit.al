// Event Subscriber to monitor posting order in BC 27
// Demonstrates how SetCurrentKey(Type, "Line No.") sorts lines during posting

codeunit 55008 "DT Posting Order Subscriber"
{
    SingleInstance = true;

    var
        TempPostingOrderLog: Record "DT Posting Order Log" temporary;
        IsMonitoring: Boolean;
        MonitoringDocNo: Code[20];
        EntryNo: Integer;
        NoLinesCapturedMsg: Label 'No lines were captured in the temp table.';
        TotalLinesProcessedMsg: Label 'Total lines processed: %1\\ \\Legacy Posting Feature: %2\\ \\%3', Comment = '%1 = Record count, %2 = Feature status, %3 = Log message';
        LogMessageEmptyMsg: Label 'LogMessage is empty but RecordCount = %1', Comment = '%1 = Record count';
        LineProcessedLbl: Label 'Line processed %1:', Comment = '%1 = Counter';
        TypeLbl: Label 'Type';
        LineNoLbl: Label 'Line No.';
        DescriptionLbl: Label 'Description';

    // Subscribe to the event that fires when each sales line is being processed for shipment
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnPostSalesLineOnBeforePostSalesLine', '', false, false)]
    local procedure OnPostSalesLineOnBeforePostSalesLine(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line")
    begin
        // Only monitor our demo orders
        if SalesHeader."Sell-to Customer No." <> 'DEMO-CUST' then
            exit;

        // Initialize monitoring on first line
        if not IsMonitoring then begin
            IsMonitoring := true;
            MonitoringDocNo := SalesHeader."No.";
            TempPostingOrderLog.DeleteAll();
            EntryNo := 0;
        end;

        // Record the line being processed in temp table
        EntryNo += 1;
        TempPostingOrderLog.Init();
        TempPostingOrderLog."Entry No." := EntryNo;
        TempPostingOrderLog."Line Type" := SalesLine.Type;
        TempPostingOrderLog."Line No." := SalesLine."Line No.";
        TempPostingOrderLog.Description := SalesLine.Description;
        TempPostingOrderLog.Insert();
    end;

    // Subscribe to event after posting completes to show the summary
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    local procedure OnAfterPostSalesDoc(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20]; CommitIsSuppressed: Boolean)
    var
        LogMessage: Text;
        Counter: Integer;
        RecordCount: Integer;
        FeatureStatus: Text;
    begin
        // Only show result for monitored documents
        if not IsMonitoring then
            exit;

        if SalesHeader."No." <> MonitoringDocNo then
            exit;

        // Build message from temp table
        Counter := 0;
        RecordCount := TempPostingOrderLog.Count();

        if RecordCount = 0 then begin
            Message(NoLinesCapturedMsg);
            IsMonitoring := false;
            MonitoringDocNo := '';
            exit;
        end;

        if TempPostingOrderLog.FindSet() then
            repeat
                Counter += 1;
                if LogMessage <> '' then
                    LogMessage += @'
';
                LogMessage += StrSubstNo(LineProcessedLbl, Counter) + ' ' +
                             TypeLbl + ': ' + Format(TempPostingOrderLog."Line Type") + ', ' +
                             LineNoLbl + ': ' + Format(TempPostingOrderLog."Line No.") + ', ' +
                             DescriptionLbl + ': ' + TempPostingOrderLog.Description;
            until TempPostingOrderLog.Next() = 0;

        // Check legacy posting feature status
        FeatureStatus := GetLegacyPostingFeatureStatus();

        // Show the actual posting order
        if LogMessage <> '' then
            Message(TotalLinesProcessedMsg, RecordCount, FeatureStatus, LogMessage)
        else
            Message(LogMessageEmptyMsg, RecordCount);

        // Reset monitoring and clear temp table after message is displayed
        TempPostingOrderLog.DeleteAll();
        IsMonitoring := false;
        MonitoringDocNo := '';
        EntryNo := 0;
    end;

    local procedure GetLegacyPostingFeatureStatus(): Text
    var
        InventorySetup: Record "Inventory Setup";
    begin
        InventorySetup.Get();
        // Check if legacy posting is enabled
        // When UseLegacyPosting() returns true, legacy posting order is used
        // When false, new optimized posting order with SetCurrentKey(Type, "Line No.") is used
        if InventorySetup.UseLegacyPosting() then
            exit('Legacy Posting ENABLED (Old posting order)')
        else
            exit('Legacy Posting DISABLED (New optimized posting order)');
    end;
}
