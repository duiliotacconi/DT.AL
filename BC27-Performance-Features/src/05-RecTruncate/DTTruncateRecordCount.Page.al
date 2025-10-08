page 55026 "DT Truncate Record Count"
{
    Caption = 'Truncate Performance Test Setup';
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
                    ToolTip = 'Enter the number of records to create for the performance test.';
                    MinValue = 1;

                    trigger OnValidate()
                    begin
                        if RecordCount <= 0 then
                            Error(RecordCountMustBeGreaterThanZeroErr);
                    end;
                }

                field(TestFiltering; TestFiltering)
                {
                    ApplicationArea = All;
                    Caption = 'Test with Filtering';
                    ToolTip = 'Enable to test both Truncate and DeleteAll with filters to compare performance.';

                    trigger OnValidate()
                    begin
                        FilterFromEnabled := TestFiltering;
                        FilterToEnabled := TestFiltering;
                    end;
                }

                field(FilterFrom; FilterFrom)
                {
                    ApplicationArea = All;
                    Caption = 'Filter From Entry No.';
                    ToolTip = 'Starting entry number for the filter range. Only used when filtering is enabled.';
                    Enabled = FilterFromEnabled;
                    MinValue = 1;

                    trigger OnValidate()
                    begin
                        if TestFiltering and (FilterFrom <= 0) then
                            Error(FilterFromMustBeGreaterThanZeroErr);
                        if TestFiltering and (FilterTo > 0) and (FilterFrom > FilterTo) then
                            Error(FilterFromMustBeLessOrEqualFilterToErr);
                    end;
                }

                field(FilterTo; FilterTo)
                {
                    ApplicationArea = All;
                    Caption = 'Filter To Entry No.';
                    ToolTip = 'Ending entry number for the filter range. Only used when filtering is enabled.';
                    Enabled = FilterToEnabled;
                    MinValue = 1;

                    trigger OnValidate()
                    begin
                        if TestFiltering and (FilterTo <= 0) then
                            Error(FilterToMustBeGreaterThanZeroErr);
                        if TestFiltering and (FilterFrom > 0) and (FilterFrom > FilterTo) then
                            Error(FilterFromMustBeLessOrEqualFilterToErr);
                    end;
                }
            }

            group(Info)
            {
                Caption = 'Information';
                InstructionalText = 'Without filtering: compares DeleteAll() vs Truncate() on full table. With filtering: compares DeleteAll() vs Truncate() on filtered records.';
            }
        }
    }

    var
        RecordCount: Integer;
        TestFiltering: Boolean;
        FilterFrom: Integer;
        FilterTo: Integer;
        FilterFromEnabled: Boolean;
        FilterToEnabled: Boolean;
        RecordCountMustBeGreaterThanZeroErr: Label 'Number of records must be greater than 0.';
        FilterFromMustBeGreaterThanZeroErr: Label 'Filter From must be greater than 0.';
        FilterToMustBeGreaterThanZeroErr: Label 'Filter To must be greater than 0.';
        FilterFromMustBeLessOrEqualFilterToErr: Label 'Filter From must be less than or equal to Filter To.';
        BothFiltersMustBeGreaterThanZeroErr: Label 'Both Filter From and Filter To must be greater than 0 when filtering is enabled.';
        FilterToCannotExceedRecordCountErr: Label 'Filter To cannot exceed the total number of records (%1).', Comment = '%1 = Total record count';

    trigger OnOpenPage()
    begin
        // No default values - let user decide
        FilterFromEnabled := false;
        FilterToEnabled := false;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = Action::OK then begin
            if RecordCount <= 0 then begin
                Message(RecordCountMustBeGreaterThanZeroErr);
                exit(false);
            end;
            if TestFiltering then begin
                if (FilterFrom <= 0) or (FilterTo <= 0) then begin
                    Message(BothFiltersMustBeGreaterThanZeroErr);
                    exit(false);
                end;
                if FilterFrom > FilterTo then begin
                    Message(FilterFromMustBeLessOrEqualFilterToErr);
                    exit(false);
                end;
                if FilterTo > RecordCount then begin
                    Message(FilterToCannotExceedRecordCountErr, RecordCount);
                    exit(false);
                end;
            end;
        end;
    end;

    procedure GetRecordCount(): Integer
    begin
        exit(RecordCount);
    end;

    procedure GetTestFiltering(): Boolean
    begin
        exit(TestFiltering);
    end;

    procedure GetFilterFrom(): Integer
    begin
        exit(FilterFrom);
    end;

    procedure GetFilterTo(): Integer
    begin
        exit(FilterTo);
    end;
}
