// Main page for BC 27 Performance Features Demo
page 55020 "DT BC27 Performance Features"
{
    Caption = 'BC27 Performance Features Demo';
    PageType = Card;
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'BC 27 Performance Features Demonstration';

                field(Welcome; WelcomeLbl)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                    Style = Strong;
                }

                field(Description; DescriptionLbl)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                }
            }

            group(ApplicationFeatures)
            {
                Caption = 'Application Features';

                field(InventoryPostingInfo; InventoryPostingInfoLbl)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                }

                field(SQLCallsInfo; SQLCallsInfoLbl)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                }
            }

            group(DeveloperFeatures)
            {
                Caption = 'Developer Features';

                field(LockTimeoutInfo; LockTimeoutInfoLbl)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                }

                field(SequentialGuidInfo; SequentialGuidInfoLbl)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                }

                field(TruncateInfo; TruncateInfoLbl)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                }
            }

            group(ServerFeatures)
            {
                Caption = 'Server Team Features';

                field(FlowFieldInfo; FlowFieldInfoLbl)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ShowCaption = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(ApplicationDemos)
            {
                Caption = 'Application';

                action(InventoryPostingDemo)
                {
                    Caption = 'Posting Order Demo';
                    ApplicationArea = All;
                    Image = ItemAvailability;
                    ToolTip = 'Demonstrates the posting order optimization in BC 27 for sales documents.';

                    trigger OnAction()
                    var
                        InventoryDemo: Codeunit "DT Posting Demo";
                    begin
                        InventoryDemo.Run();
                    end;
                }

                action(SQLCallsDemo)
                {
                    Caption = 'SQL Calls Profiler Demo';
                    ApplicationArea = All;
                    Image = Database;
                    ToolTip = 'Demonstrates how SQL calls are now visible in the Performance Profiler in BC 27.';

                    trigger OnAction()
                    var
                        SQLDemo: Codeunit "DT SQL Calls Profiler Demo";
                    begin
                        SQLDemo.Run();
                    end;
                }
            }

            group(DeveloperDemos)
            {
                Caption = 'Developer';

                action(LockTimeoutDemo)
                {
                    Caption = 'LockTimeout Demo';
                    ApplicationArea = All;
                    Image = Lock;
                    ToolTip = 'Demonstrates the Database.LockTimeoutDuration feature introduced in BC 27.';

                    trigger OnAction()
                    var
                        LockDemo: Codeunit "DT LockTimeout Demo";
                    begin
                        LockDemo.Run();
                    end;
                }

                action(SequentialGuidDemo)
                {
                    Caption = 'Sequential GUID Demo';
                    ApplicationArea = All;
                    Image = CreateForm;
                    ToolTip = 'Demonstrates the Guid.CreateSequentialGuid() method for improved database performance in BC 27.';

                    trigger OnAction()
                    var
                        GuidDemo: Codeunit "DT Sequential Guid Demo";
                    begin
                        GuidDemo.Run();
                    end;
                }

                action(TruncateDemo)
                {
                    Caption = 'Rec.Truncate Demo';
                    ApplicationArea = All;
                    Image = DeleteAllBreakpoints;
                    ToolTip = 'Demonstrates the Record.Truncate() method for fast table cleanup in BC 27.';

                    trigger OnAction()
                    var
                        TruncateDemo: Codeunit "DT Rec Truncate Demo";
                    begin
                        TruncateDemo.Run();
                    end;
                }
            }

            group(ServerDemos)
            {
                Caption = 'SQL Optimization';

                action(FlowFieldDemo)
                {
                    Caption = 'FlowField Optimization Demo';
                    ApplicationArea = All;
                    Image = Calculate;
                    ToolTip = 'Demonstrates FlowField calculation optimizations with SetAutoCalcFields in BC 27.';

                    trigger OnAction()
                    var
                        FlowFieldDemo: Codeunit "DT FlowField Optimization Demo";
                    begin
                        FlowFieldDemo.Run();
                    end;
                }
            }
        }

        area(navigation)
        {
            group(Lists)
            {
                Caption = 'Demo Data Lists';

                action(GUIDPerformanceTest)
                {
                    Caption = 'GUID Performance Test';
                    ApplicationArea = All;
                    Image = Table;
                    RunObject = page "DT GUID Performance Test";
                    ToolTip = 'Opens the list of GUID performance test records.';
                }

                action(TruncateMonitor)
                {
                    Caption = 'Truncate Performance Monitor';
                    ApplicationArea = All;
                    Image = Log;
                    RunObject = page "DT Truncate Perf Monitor";
                    ToolTip = 'Opens the log of truncate operations.';
                }

                action(FlowFieldDemo2)
                {
                    Caption = 'FlowField Performance Demo';
                    ApplicationArea = All;
                    Image = ShowList;
                    RunObject = page "DT FlowField Perf Demo";
                    ToolTip = 'Opens the FlowField performance demonstration page.';
                }
            }
        }
    }

    var
        WelcomeLbl: Label 'Welcome to the BC 27 Performance Features Demo!';
        DescriptionLbl: Label 'This app demonstrates the new performance features introduced in Business Central 27.';
        InventoryPostingInfoLbl: Label 'Posting Order: Improved posting sequence for better performance';
        SQLCallsInfoLbl: Label 'SQL Calls in Performance Profiler: View detailed SQL execution information';
        LockTimeoutInfoLbl: Label 'LockTimeout: Better handling of database lock timeouts';
        SequentialGuidInfoLbl: Label 'Guid.CreateSequentialGuid: More performant GUID generation for database keys';
        TruncateInfoLbl: Label 'Rec.Truncate: Faster data cleanup for large tables';
        FlowFieldInfoLbl: Label 'Optimized FlowField Calculations: Improved performance for FlowField operations';
}