// Customer table with FlowFields for demonstration
table 55015 "DT Customer Demo"
{
    Caption = 'Customer Demo';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
        }

        field(10; Name; Text[100])
        {
            Caption = 'Name';
        }

        // FlowField demonstrations
        field(101; "No. of Sales Entries"; Integer)
        {
            Caption = 'No. of Sales Entries';
            FieldClass = FlowField;
            CalcFormula = count("DT Sales Entry" where("Customer No." = field("Customer No.")));
            Editable = false;
        }

        field(103; "Last Sales Date"; Date)
        {
            Caption = 'Last Sales Date';
            FieldClass = FlowField;
            CalcFormula = max("DT Sales Entry"."Posting Date" where("Customer No." = field("Customer No.")));
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Customer No.")
        {
            Clustered = true;
        }
    }
}
