page 55029 "DT Profiling Node FactBox"
{
    PageType = CardPart;
    SourceTable = "DT Profiling Node";
    SourceTableTemporary = true;
    Caption = 'Details';

    layout
    {
        area(content)
        {
            field("SQL Statement"; Rec."SQL Statement")
            {
                ApplicationArea = All;
                Caption = 'SQL Statement';
                MultiLine = true;
                ToolTip = 'Displays the SQL Server statement captured by the performance profiler';
                Editable = false;
                ShowCaption = true;
            }
        }
    }

    procedure UpdateData(var SourceRecord: Record "DT Profiling Node")
    begin
        Rec.Reset();
        Rec.DeleteAll();

        if SourceRecord."Entry No." <> 0 then begin
            Rec := SourceRecord;
            Rec.Insert();
            if Rec.FindFirst() then;
        end;

        CurrPage.Update(false);
    end;
}
