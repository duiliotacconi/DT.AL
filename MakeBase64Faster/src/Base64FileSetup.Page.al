namespace DefaultPublisher.MakeBase64Faster;

page 50102 "Base64 File Setup"
{
    Caption = 'Base64 File Setup';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Base64 File Setup";
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(Methods)
            {
                Caption = 'Conversion Method';

                field("Encode Method"; Rec."Encode Method")
                {
                    ToolTip = 'Specifies whether files are encoded with the legacy text-based overload or the new stream-based overload.';
                }
                field("Decode Method"; Rec."Decode Method")
                {
                    ToolTip = 'Specifies whether files are decoded with the legacy text-based overload or the new stream-based overload.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.GetSetup();
    end;
}
