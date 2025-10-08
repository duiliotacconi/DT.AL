// LockTimeout Feature Demo for BC 27
// This codeunit demonstrates the new Database.LockTimeoutDuration method introduced in BC 27
// Reference: https://yzhums.com/67858/

codeunit 55003 "DT LockTimeout Demo"
{
    var
        NoItemsFoundErr: Label 'No items found. Please create at least one item to run this demo.';
        LockTimeoutMustBeGreaterThanZeroErr: Label 'Lock timeout must be greater than 0 seconds.';
        ItemNotFoundErr: Label 'Item %1 not found.', Comment = '%1 = Item No.';
        FailedToStartBackgroundSessionErr: Label 'Failed to start background session.';
        OperationSucceededMsg: Label 'Operation succeeded!\\ \\Original timeout duration: %1 seconds\\New timeout duration: %2 seconds\\Elapsed time: %3 seconds', Comment = '%1 = Original timeout, %2 = New timeout, %3 = Elapsed time';
        DemoWillLbl: Label 'This demo will:';
        Step1Lbl: Label '1. Start a background session that locks an Item record for 15 seconds';
        Step2Lbl: Label '2. Allow you to set Database.LockTimeoutDuration (BC 27 feature)';
        Step3Lbl: Label '3. Try to access the locked record';
        ExamplesLbl: Label 'Examples:';
        TimeoutLessThan15Lbl: Label '- Timeout < 15 sec → Lock timeout error';
        TimeoutGreaterThan15Lbl: Label '- Timeout > 15 sec → Should succeed (lock released after 15 sec)';
        ContinueQst: Label 'Do you want to continue?';

    trigger OnRun()
    begin
        StartLockTimeoutDemo();
    end;

    procedure StartLockTimeoutDemo()
    var
        Item: Record Item;
        LockTimeoutInput: Page "DT Lock Timeout Input";
        ConfirmText: Text;
        LockTimeoutSeconds: Integer;
    begin
        // Ensure we have at least one item to lock
        if not Item.FindFirst() then
            Error(NoItemsFoundErr);

        ConfirmText := DemoWillLbl + '\ ' +
                       Step1Lbl + '\ ' +
                       Step2Lbl + '\ ' +
                       Step3Lbl + '\ ' +
                       '\ ' +
                       ExamplesLbl + '\ ' +
                       TimeoutLessThan15Lbl + '\ ' +
                       TimeoutGreaterThan15Lbl + '\ ' +
                       '\ ' +
                       ContinueQst;

        if not Confirm(ConfirmText, false) then
            exit;

        // Ask user to input lock timeout in seconds  
        if LockTimeoutInput.RunModal() = Action::OK then
            LockTimeoutSeconds := LockTimeoutInput.GetTimeout()
        else
            exit; // User cancelled

        if LockTimeoutSeconds <= 0 then
            Error(LockTimeoutMustBeGreaterThanZeroErr);

        // Start background session that will hold the lock for 15 seconds
        StartBackgroundSessionAndLockItem(Item."No.");

        // Now try to access the locked item with the specified timeout
        TryAccessLockedItemWithTimeout(Item."No.", LockTimeoutSeconds);
    end;

    local procedure StartBackgroundSessionAndLockItem(ItemNo: Code[20])
    var
        Item: Record Item;
        SessionId: Integer;
    begin
        // Get the item record to pass to the background session
        if not Item.Get(ItemNo) then
            Error(ItemNotFoundErr, ItemNo);

        // Start a background session that will lock the item for 15 seconds
        if not StartSession(SessionId, Codeunit::"DT LockTimeout Management", CompanyName(), Item) then
            Error(FailedToStartBackgroundSessionErr);

        // Give the background session time to acquire the lock
        Sleep(2000);
    end;

    local procedure TryAccessLockedItemWithTimeout(ItemNo: Code[20]; TimeoutSeconds: Integer)
    var
        Item: Record Item;
        ItemCard: Page "Item Card";
        StartTime: DateTime;
        ElapsedSeconds: Integer;
        OriginalTimeout: Integer;
    begin
        StartTime := CurrentDateTime();

        // Store the original lock timeout duration
        OriginalTimeout := Database.LockTimeoutDuration();

        // Set lock timeout duration (BC 27 feature)
        // This allows increasing/lowering lock timeout instead of only disabling/enabling it
        Database.LockTimeoutDuration(TimeoutSeconds);

        // Try to access and modify the locked record
        // Lock the table FIRST, then get the specific record
        Item.LockTable();
        Item.Get(ItemNo);
        Item.Description := 'Modified at ' + Format(CurrentDateTime());
        Item.Modify();

        ElapsedSeconds := (CurrentDateTime() - StartTime) div 1000;

        Message(OperationSucceededMsg, OriginalTimeout, TimeoutSeconds, ElapsedSeconds);

        // Show the item card to showcase the modification
        Item.Get(ItemNo);
        ItemCard.SetRecord(Item);
        ItemCard.Run();
    end;
}