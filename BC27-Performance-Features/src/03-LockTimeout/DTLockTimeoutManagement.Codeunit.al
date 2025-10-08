// Management codeunit for LockTimeout functionality
// This codeunit runs in a background session and holds a lock on an Item record
codeunit 55004 "DT LockTimeout Management"
{
    TableNo = Item;

    trigger OnRun()
    begin
        HoldLockOnItem(Rec);
    end;

    local procedure HoldLockOnItem(var Item: Record Item)
    var
        ItemToLock: Record Item;
    begin
        // Get and lock the item record with an exclusive lock
        if ItemToLock.Get(Item."No.") then begin
            // Lock the table to get an exclusive lock
            ItemToLock.LockTable();

            // Modify the record to ensure we have a write lock
            ItemToLock.Description := 'Locked by background session at ' + Format(CurrentDateTime());
            ItemToLock.Modify();

            // Sleep for 15 seconds BEFORE committing to hold the lock
            // This keeps the transaction open and the lock held
            Sleep(15000);

            // Now release the lock by modifying again
            ItemToLock.Description := 'Released by background session at ' + Format(CurrentDateTime());
            ItemToLock.Modify();

            // Commit to release the lock
            Commit();
        end;
    end;
}