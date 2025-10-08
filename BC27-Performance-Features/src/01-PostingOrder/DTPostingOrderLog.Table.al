// Temporary table to log posting order
table 55017 "DT Posting Order Log"
{
    TableType = Temporary;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }

        field(10; "Line Type"; Enum "Sales Line Type")
        {
            Caption = 'Line Type';
        }

        field(20; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }

        field(30; Description; Text[100])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}
