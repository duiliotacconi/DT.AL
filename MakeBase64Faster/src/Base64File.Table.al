namespace DefaultPublisher.MakeBase64Faster;

table 50101 "Base64 File"
{
    Caption = 'Base64 File';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "File Name"; Text[250])
        {
            Caption = 'File Name';
        }
        field(3; "Original Size (Bytes)"; Integer)
        {
            Caption = 'Original Size (Bytes)';
        }
        field(4; "Base64 Length"; Integer)
        {
            Caption = 'Base64 Length';
        }
        field(5; "Encode Time (ms)"; Decimal)
        {
            Caption = 'Encode Time (ms)';
            DecimalPlaces = 0 : 3;
        }
        field(6; "Decode Time (ms)"; Decimal)
        {
            Caption = 'Decode Time (ms)';
            DecimalPlaces = 0 : 3;
        }
        field(7; "Encode Method"; Enum "Base64 Test Method")
        {
            Caption = 'Encode Method';
        }
        field(8; "Decode Method"; Enum "Base64 Test Method")
        {
            Caption = 'Decode Method';
        }
        field(10; "Base64 Data"; Blob)
        {
            Caption = 'Base64 Data';
            SubType = Memo;
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
