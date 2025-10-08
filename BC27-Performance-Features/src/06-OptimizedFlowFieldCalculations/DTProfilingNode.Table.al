// Table to store profiling nodes from alcpuprofile
table 55019 "DT Profiling Node"
{
    Caption = 'Profiling Node';
    TableType = Temporary;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }

        field(10; "Node ID"; Integer)
        {
            Caption = 'Node ID';
        }

        field(20; "Function Name"; Text[250])
        {
            Caption = 'Function Name';
        }

        field(30; "Object Type"; Text[50])
        {
            Caption = 'Object Type';
        }

        field(40; "Object Name"; Text[100])
        {
            Caption = 'Object Name';
        }

        field(50; "Object ID"; Integer)
        {
            Caption = 'Object ID';
        }

        field(60; "Hit Count"; Integer)
        {
            Caption = 'Hit Count';
        }

        field(70; "Is SQL"; Boolean)
        {
            Caption = 'Is SQL';
        }

        field(80; "SQL Statement"; Text[2048])
        {
            Caption = 'SQL Statement';
        }

        field(90; "Line Number"; Integer)
        {
            Caption = 'Line Number';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }

        key(HitCount; "Hit Count")
        {
        }
    }
}
