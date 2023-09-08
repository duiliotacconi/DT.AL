page 50101 "DT Time Zone Entries"
{
    //(7ac3575a-b929-ed11-9dc4-6045bd8e515f)/timezoneEntries
    Caption = 'Time Zone Entries';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "API TimeZone Test";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.") { }
                field(Description; rec.Description) { }
                field("DateTime"; rec.DateTime) { }
                field("DateTime ISO8601 (UTC)"; rec."DateTime ISO8601 (UTC)") { }
                field("Time as Text (UTC)"; Rec."Time as Text (UTC)") { }
                field("Time as Integer (UTC)"; Rec."Time as Integer (UTC)") { }
                field("Date as Date"; Rec."Date as Date") { }
                field("Time as Time"; Rec."Time as Time") { }
            }
        }
    }

}