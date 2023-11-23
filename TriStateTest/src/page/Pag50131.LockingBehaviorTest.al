page 50131 "Locking Behavior Test"
{
    Caption = 'Locking Behavior Test';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(INPUT)
            {
                field(ReadIsolationType; ReadIsolationType)
                {
                    Caption = 'Read Isolation Level';
                    ApplicationArea = All;
                }
                field(NewShelfNo; NewShelfNo)
                {
                    Caption = 'NEW Item Shelf No.';
                    ApplicationArea = All;
                }
            }
            group(OUTPUT)
            {
                field(Result; Result)
                {
                    Caption = 'Result';
                    ApplicationArea = All;
                    MultiLine = true;
                }
                field(ElapsedTime; ElapsedTime)
                {
                    Caption = 'Duration';
                    ApplicationArea = All;
                }
            }
            group("Tri State Locking Status")
            {
                field(TriStateLockingStatus; TriStateLockingStatus)
                {
                    ShowCaption = false;
                    Editable = false;
                    Enabled = false;
                    MultiLine = true;
                    Style = Strong;
                    ApplicationArea = All;
                }
                field(CurrentSessionId; CurrentSessionId)
                {
                    Caption = 'Session Id';
                    Editable = false;
                    Enabled = false;
                    Style = Attention;
                    ApplicationArea = All;
                }

            }

        }
    }

    actions
    {
        area(Processing)
        {
            action(UpdateItemShelfNo)
            {
                Caption = 'UPDATE Shelf No.';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = UpdateDescription;

                trigger OnAction()
                var
                    Item: Record "Item";
                    OldValue: Text;
                    NewValue: Text;
                begin
                    StartDateTime := CurrentDateTime;
                    if Item.FindSet() then
                        repeat
                            if Item."No." = '1928-S' then begin
                                OldValue := Item."Shelf No.";
                                Item."Shelf No." := NewShelfNo;
                                Item.Modify();
                            end;
                        until Item.Next() = 0;

                    Sleep(9000); //Wait 9 seconds
                    Result := 'UPDATE Transaction Ended. OLD: [' + OldValue + '] - NEW: [' + NewShelfNo + ']';
                    ElapsedTime := CurrentDateTime - StartDateTime;
                    ReadIsolationType := ReadIsolationType::Default;

                    CurrPage.Update();
                end;
            }
            action(ItemReadLoop)
            {
                Caption = 'READ loop';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = RelatedInformation;

                trigger OnAction()
                var
                    Item: Record "Item";
                begin
                    Result := '';
                    StartDateTime := CurrentDateTime;

                    case ReadIsolationType of
                        ReadIsolationType::ReadUncommitted:
                            Item.ReadIsolation := IsolationLevel::ReadUncommitted;
                        ReadIsolationType::ReadCommitted:
                            Item.ReadIsolation := IsolationLevel::ReadCommitted;
                        ReadIsolationType::RepeatableRead:
                            Item.ReadIsolation := IsolationLevel::RepeatableRead;
                        ReadIsolationType::Updlock:
                            Item.ReadIsolation := IsolationLevel::UpdLock;
                        else
                            Item.ReadIsolation := IsolationLevel::Default;
                    end;

                    if Item.FindSet() then
                    repeat
                        //just reading all Items with a specific isolation level
                        if Item."No." = '1928-S' then
                            Result := UpperCase(Format(Item.ReadIsolation)) + ' ' +
                                Format(Item."No.") + ': ' + Item."Shelf No.";
                    until Item.Next() = 0;
                    ElapsedTime := CurrentDateTime - StartDateTime;

                    CurrPage.Update();
                end;

            }

            action(ResetShelfNo)
            {
                Caption = 'RESET Shelf No.';
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Restore;

                trigger OnAction()
                var
                    Item: Record "Item";
                begin
                    if Item.Get('1928-S') then begin
                        Item."Shelf No." := 'OLDVALUE';
                        Item.Modify();
                    end;
                    Clear(Result);
                    Clear(ElapsedTime);

                    CurrPage.Update();
                end;
            }

        }
    }

    trigger OnOpenPage()
    begin
        GetTriStateEnabledFromFeatureManagement();
        NewShelfNo := 'ABC123';
        CurrentSessionId := SessionId();
    end;

    local procedure GetTriStateEnabledFromFeatureManagement();
    var
        FeatureManagement: Record "Feature Key";
    begin
        FeatureManagement.Reset();
        if FeatureManagement.Get('TriStateLocking') then
            TriStateLockingStatus := UpperCase(FeatureManagement.Description + ' : ' +
                Format(FeatureManagement.Enabled))
        else
            TriStateLockingStatus := 'There is no Tri State Locking in Feature Management';
    end;

    var
        ReadIsolationType: Enum ReadIsolationLevelType;
        NewShelfNo: Code[10];
        Result: Text;
        StartDateTime: DateTime;
        ElapsedTime: Duration;
        TriStateLockingStatus: Text;
        CurrentSessionId : Integer;

}