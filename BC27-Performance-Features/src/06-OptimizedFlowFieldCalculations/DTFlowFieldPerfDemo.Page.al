// Page to display FlowField performance results
page 55023 "DT FlowField Perf Demo"
{
    Caption = 'FlowField Performance Demo';
    PageType = List;
    SourceTable = "DT Customer Demo";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique customer number.';
                }

                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer name.';
                }

                field("No. of Sales Entries"; Rec."No. of Sales Entries")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total number of sales entries for this customer (FlowField).';
                }

                field("Last Sales Date"; Rec."Last Sales Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date of the last sales transaction for this customer (FlowField).';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(RunFlowFieldDemo)
            {
                Caption = 'Run FlowField Performance Demo';
                ApplicationArea = All;
                Image = ExecuteBatch;
                ToolTip = 'Runs the FlowField optimization demo to show BC 27 SetAutoCalcFields performance improvements.';

                trigger OnAction()
                var
                    FlowFieldDemo: Codeunit "DT FlowField Optimization Demo";
                begin
                    FlowFieldDemo.Run();
                    CurrPage.Update(false);
                end;
            }
        }
    }
}
