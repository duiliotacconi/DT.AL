// Log table for tracking truncate operations
table 55014 "DT Truncate Log Table"
{
    Caption = 'Truncate Log Table';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }

        field(10; "Table Name"; Text[30])
        {
            Caption = 'Table Name';
        }

        field(20; "Operation DateTime"; DateTime)
        {
            Caption = 'Operation DateTime';
        }

        field(30; "Records Affected"; Integer)
        {
            Caption = 'Records Affected';
        }

        field(40; "Operation Type"; Enum "DT Truncate Operation Type")
        {
            Caption = 'Operation Type';
        }

        field(50; "User ID"; Text[50])
        {
            Caption = 'User ID';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }

        key(DateTime; "Operation DateTime")
        {
        }
    }
}
