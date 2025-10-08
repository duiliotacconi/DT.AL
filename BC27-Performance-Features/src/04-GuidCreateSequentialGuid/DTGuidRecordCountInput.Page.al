page 55025 "DT Guid Record Count Input"
{
    Caption = 'Enter Number of Records';
    PageType = StandardDialog;

    layout
    {
        area(Content)
        {
            group(Input)
            {
                Caption = 'Performance Test Parameters';

                field(RecordCount; RecordCount)
                {
                    ApplicationArea = All;
                    Caption = 'Number of Records';
                    ToolTip = 'Enter the number of records to insert for the performance test.';
                    MinValue = 1;

                    trigger OnValidate()
                    begin
                        if RecordCount <= 0 then
                            Error(RecordCountMustBeGreaterThanZeroErr);
                    end;
                }
            }

            group(Info)
            {
                Caption = 'Information';
                InstructionalText = 'The demo will create this many records with standard GUIDs and sequential GUIDs to compare performance.';
            }
        }
    }

    var
        RecordCount: Integer;
        RecordCountMustBeGreaterThanZeroErr: Label 'Number of records must be greater than 0.';

    trigger OnOpenPage()
    begin
        // Let RecordCount remain at its default
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = Action::OK then
            if RecordCount <= 0 then begin
                Message(RecordCountMustBeGreaterThanZeroErr);
                exit(false);
            end;
    end;

    procedure GetRecordCount(): Integer
    begin
        exit(RecordCount);
    end;
}
