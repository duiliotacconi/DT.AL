// Page to display GUID performance results
page 55021 "DT GUID Performance Test"
{
    Caption = 'GUID Performance Test';
    PageType = List;
    SourceTable = "DT Guid Performance Test Table";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Record ID"; Rec."Record ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique record identifier (GUID).';
                }

                field("Record Type"; Rec."Record Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of GUID generation used (Standard or Sequential).';
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the test record.';
                }

                field("Creation Time"; Rec."Creation Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the timestamp when the record was created.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(RunPerformanceTest)
            {
                Caption = 'Run Performance Test';
                ApplicationArea = All;
                Image = ExecuteBatch;
                ToolTip = 'Runs the GUID performance test to compare standard GUIDs vs sequential GUIDs.';

                trigger OnAction()
                var
                    SequentialGuidDemo: Codeunit "DT Sequential Guid Demo";
                begin
                    SequentialGuidDemo.Run();
                end;
            }
        }
    }
}