// Sales entries table for FlowField calculations
table 55016 "DT Sales Entry"
{
    Caption = 'Sales Entry';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }

        field(10; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
        }

        field(20; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }

        field(30; Amount; Decimal)
        {
            Caption = 'Amount';
        }

        field(40; "Document Type"; Enum "DT Document Type")
        {
            Caption = 'Document Type';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }

        key(CustomerDate; "Customer No.", "Posting Date")
        {
            SumIndexFields = Amount;
            MaintainSIFTIndex = true;
        }
    }
}
