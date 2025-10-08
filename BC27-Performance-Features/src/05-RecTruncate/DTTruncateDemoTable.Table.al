// Table for demonstrating Truncate functionality
table 55013 "DT Truncate Demo Table"
{
    Caption = 'Truncate Demo Table';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }

        field(10; Description; Text[100])
        {
            Caption = 'Description';
        }

        field(20; "Created Date"; Date)
        {
            Caption = 'Created Date';
        }

        field(30; Amount; Decimal)
        {
            Caption = 'Amount';
        }

        field(40; Status; Enum "DT Truncate Status")
        {
            Caption = 'Status';
        }

        field(50; "Last Modified"; DateTime)
        {
            Caption = 'Last Modified';
        }

        // Note: No media fields - this makes the table eligible for Truncate
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }

        key(Status; Status, "Created Date")
        {
        }
    }

    trigger OnInsert()
    begin
        "Last Modified" := CurrentDateTime;
    end;

    trigger OnModify()
    begin
        "Last Modified" := CurrentDateTime;
    end;
}
