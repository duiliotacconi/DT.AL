// Test table for GUID performance comparison
table 55012 "DT Guid Performance Test Table"
{
    Caption = 'GUID Performance Test Table';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Record ID"; Guid)
        {
            Caption = 'Record ID';
        }

        field(10; "Record Type"; Enum "DT Guid Record Type")
        {
            Caption = 'Record Type';
        }

        field(20; Description; Text[100])
        {
            Caption = 'Description';
        }

        field(30; "Creation Time"; DateTime)
        {
            Caption = 'Creation Time';
        }

        field(40; "Performance Notes"; Text[250])
        {
            Caption = 'Performance Notes';
        }
    }

    keys
    {
        key(PK; "Record ID")
        {
            Clustered = true;
        }

        key(CreationTime; "Creation Time")
        {
        }

        key(RecordType; "Record Type", "Creation Time")
        {
        }
    }
}