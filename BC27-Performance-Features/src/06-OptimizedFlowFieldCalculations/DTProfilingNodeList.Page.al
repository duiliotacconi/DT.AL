// Page to display profiling nodes
page 55028 "DT Profiling Node List"
{
    Caption = 'Profiling Nodes';
    PageType = List;
    SourceTable = "DT Profiling Node";
    SourceTableTemporary = true;
    UsageCategory = Lists;
    ApplicationArea = All;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Node ID"; Rec."Node ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Unique identifier for the profiling node';
                }

                field("Function Name"; Rec."Function Name")
                {
                    ApplicationArea = All;
                    Width = 50;
                    ToolTip = 'Function or method name captured by the profiler';
                }

                field("Object Type"; Rec."Object Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Type of AL object';
                }

                field("Object Name"; Rec."Object Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Name of AL object';
                }

                field("Object ID"; Rec."Object ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'ID of AL object';
                }

                field("Hit Count"; Rec."Hit Count")
                {
                    ApplicationArea = All;
                    Style = Strong;
                    ToolTip = 'Number of times this node was executed';
                }

                field("Is SQL"; Rec."Is SQL")
                {
                    ApplicationArea = All;
                    ToolTip = 'Indicates whether this is a SQL statement';
                }

                field("Line Number"; Rec."Line Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Line number in the source code';
                }
            }
        }
        area(factboxes)
        {
            part(SQLDetails; "DT Profiling Node FactBox")
            {
                ApplicationArea = All;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.SQLDetails.Page.UpdateData(Rec);
    end;

    procedure SetData(var TempProfilingNode: Record "DT Profiling Node" temporary)
    begin
        if TempProfilingNode.FindSet() then
            repeat
                Rec := TempProfilingNode;
                Rec.Insert();
            until TempProfilingNode.Next() = 0;

        if Rec.FindFirst() then;
    end;
}
