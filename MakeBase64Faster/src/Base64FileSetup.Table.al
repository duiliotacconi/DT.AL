namespace DefaultPublisher.MakeBase64Faster;

table 50102 "Base64 File Setup"
{
    Caption = 'Base64 File Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Encode Method"; Enum "Base64 Test Method")
        {
            Caption = 'Encode Method';
            InitValue = "Stream-based (new)";
        }
        field(3; "Decode Method"; Enum "Base64 Test Method")
        {
            Caption = 'Decode Method';
            InitValue = "Stream-based (new)";
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    procedure GetSetup()
    begin
        if Rec.Get() then
            exit;
        Rec.Init();
        Rec.Insert();
    end;
}
