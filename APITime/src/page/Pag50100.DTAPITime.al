page 50100 "DT API Time"
{
    APIVersion = 'v2.0';
    Caption = 'dtapitime', locked = true;
    DelayedInsert = true;
    APIPublisher = 'dt';
    APIGroup = 'Demo';
    EntityName = 'timeZoneEntry';
    EntitySetName = 'timeZoneEntries';
    EntityCaption = 'timeZoneEntry';
    EntitySetCaption = 'timeZoneEntries';
    ODataKeyFields = SystemId;
    PageType = API;
    SourceTable = "API TimeZone Test";
    InsertAllowed = true;
    ModifyAllowed = true;
    DeleteAllowed = false;
    ChangeTrackingAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(id; Rec.SystemId)
                {
                    Caption = 'id', Locked = true;
                    ApplicationArea = All;
                }
                field(desc; Rec.Description)
                {
                    Caption = 'description', Locked = true;
                    ApplicationArea = All;
                }
            }
        }
    }
}