table 50100 "API TimeZone Test"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
            AutoIncrement = true;
            Editable = false;
        }
        field(3; "Time as Text (UTC)"; Text[100])
        {
            Caption = 'Time as Text (UTC)';
            DataClassification = CustomerContent;
        }
        field(4; "Time as Integer (UTC)"; Integer)
        {
            Caption = 'Time as Integer (UTC)';
            DataClassification = CustomerContent;
        }

        field(5; "DateTime"; DateTime)
        {
            Caption = 'DateTime';
            DataClassification = CustomerContent;
        }
        field(6; "Description"; Text[100])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }

        field(8; "DateTime ISO8601 (UTC)"; Text[50])
        {
            Caption = 'DateTime ISO8601 (UTC)';
            DataClassification = CustomerContent;
        }

        field(9; "Date as Date"; Date)
        {
            Caption = 'Date as Date';
            DataClassification = CustomerContent;
        }
        field(10; "Time as Time"; Time)
        {
            Caption = 'Time as Time';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
        TypeHelper: Codeunit "Type Helper";
    begin
        "DateTime" := CurrentDateTime;
        "DateTime ISO8601 (UTC)" := TypeHelper.GetCurrUTCDateTimeISO8601();
        "Time as Text (UTC)" := ExtractTime("DateTime ISO8601 (UTC)");
        "Time as Integer (UTC)" := GetTimeAsInteger("Time as Text (UTC)");
        "Time as Time" := Time();
        "Date as Date" := Today();
    end;

    procedure ExtractTime(utcDateTimeText: Text): Text
    var
        TPos: Integer;
        ZPos: Integer;
    begin
        TPos := StrPos(utcDateTimeText, 'T');
        ZPos := StrPos(utcDateTimeText, 'Z');
        if (TPos = 0) or (ZPos = 0) then
            exit('');
        exit(CopyStr(utcDateTimeText, TPos + 1, (strlen(utcDateTimeText) - Tpos - 1)))
    end;

    procedure GetTimeAsInteger(TimeAsText: Text): Integer
    var
        HH: Text;
        MM: Text;
        SS: Text;
        HHint: Integer;
        MMint: Integer;
        SSint: Integer;
        TimeAsInteger: Integer;
    begin
        if strlen(TimeAsText) < 8 then
            exit;

        HH := CopyStr(TimeAsText, 1, 2);
        MM := CopyStr(TimeAsText, 4, 2);
        SS := CopyStr(TimeAsText, 7, 2);

        if not Evaluate(HHint, HH) then
            exit;
        TimeAsInteger := HHint * 10000;

        if not Evaluate(MMint, MM) then
            exit;
        TimeAsInteger += MMint * 100;

        if not Evaluate(SSint, SS) then
            exit;
        TimeAsInteger += SSint;

        exit(TimeAsInteger);

    end;


}