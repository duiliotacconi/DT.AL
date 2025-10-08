// Page to monitor truncate operations
page 55022 "DT Truncate Perf Monitor"
{
    Caption = 'Truncate Performance Monitor';
    PageType = List;
    SourceTable = "DT Truncate Log Table";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the entry number of the log record.';
                }

                field("Table Name"; Rec."Table Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the table where the operation was performed.';
                }

                field("Operation DateTime"; Rec."Operation DateTime")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date and time when the operation was executed.';
                }

                field("Records Affected"; Rec."Records Affected")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of records affected by the operation.';
                }

                field("Operation Type"; Rec."Operation Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of operation (DeleteAll or Truncate).';
                }

                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the user who executed the operation.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(RunTruncateDemo)
            {
                Caption = 'Run Truncate Demo';
                ApplicationArea = All;
                Image = ExecuteBatch;
                ToolTip = 'Runs the Truncate demonstration to compare performance between DeleteAll and Truncate methods.';

                trigger OnAction()
                var
                    RecTruncateDemo: Codeunit "DT Rec Truncate Demo";
                begin
                    RecTruncateDemo.Run();
                end;
            }
        }
    }
}
