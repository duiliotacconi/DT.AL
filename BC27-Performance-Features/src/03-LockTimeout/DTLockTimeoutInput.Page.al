page 55024 "DT Lock Timeout Input"
{
    Caption = 'Enter Lock Timeout Duration';
    PageType = StandardDialog;

    layout
    {
        area(Content)
        {
            group(Input)
            {
                Caption = 'Lock Timeout Duration';

                field(TimeoutSeconds; TimeoutSeconds)
                {
                    ApplicationArea = All;
                    Caption = 'Timeout (seconds)';
                    ToolTip = 'Enter the lock timeout duration in seconds.';
                    MinValue = 1;

                    trigger OnValidate()
                    begin
                        if TimeoutSeconds <= 0 then
                            Error(TimeoutMustBeGreaterThanZeroErr);
                    end;
                }
            }

            group(Info)
            {
                Caption = 'Information';
                InstructionalText = 'Background holds lock for 15 seconds. Values < 15 will timeout, values > 15 should succeed.';
            }
        }
    }

    var
        TimeoutSeconds: Integer;
        TimeoutMustBeGreaterThanZeroErr: Label 'Timeout must be greater than 0 seconds.';

    trigger OnOpenPage()
    begin
        // Let TimeoutSeconds remain at its default (0 or whatever was set)
        // This will show the current application timeout setting
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = Action::OK then
            if TimeoutSeconds <= 0 then begin
                Message(TimeoutMustBeGreaterThanZeroErr);
                exit(false);
            end;
    end;

    procedure GetTimeout(): Integer
    begin
        exit(TimeoutSeconds);
    end;
}
