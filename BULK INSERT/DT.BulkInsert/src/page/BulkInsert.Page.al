namespace DuilioTacconi.DT.BulkInsert;

using Microsoft.Inventory.Intrastat;
using Microsoft.Sales.Document;
page 50776 "Bulk Insert"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;    
    
    actions
    {
        area(Processing)
        {
            action(InsertSaleLine)
            {
                ApplicationArea = All;
                
                trigger OnAction()
                var
                    SalesLine : Record "Sales Line";
                begin
                    SalesLine.Reset();
                    iterationNo := 0;
                    for iterationNo := 1 to 10000 do
                    begin
                        SalesLine."Document Type" := SalesLine."Document Type"::Order;
                        SalesLine."Document No." := 'DT9999';
                        SalesLine."Line No." := iterationNo;
                        SalesLine.Type := SalesLine.Type::" ";
                        SalesLine.Description := 'HUGE Record Definition ' + (Format(iterationNo));
                        SalesLine.Insert(false);
                    end;
                    Message('I am done.');
                end;            
            }
            action(InsertDTSalesLines)
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    TableWith_VERYHUGE_RecordDefinition : Record "DT Sales Line";
                begin
                    TableWith_VERYHUGE_RecordDefinition.Reset();
                    iterationNo := 0;
                    for iterationNo := 1 to 10000 do
                    begin
                        TableWith_VERYHUGE_RecordDefinition."Document Type" := TableWith_VERYHUGE_RecordDefinition."Document Type"::Order;
                        TableWith_VERYHUGE_RecordDefinition."Document No." := 'DT9999';
                        TableWith_VERYHUGE_RecordDefinition."Line No." := iterationNo;
                        TableWith_VERYHUGE_RecordDefinition.Type := TableWith_VERYHUGE_RecordDefinition.Type::" ";
                        TableWith_VERYHUGE_RecordDefinition.Description := 'HUGE Record Definition ' + (Format(iterationNo));
                        TableWith_VERYHUGE_RecordDefinition.Insert(false);
                    end;
                    Message('I am done.');
                end;            
            }
            action(InsertDTSalesLinesWithExt)
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    TableWith_VERYHUGE_RecordDefinition_WITH_EXT : Record "DT Sales Line With Ext";
                begin
                    TableWith_VERYHUGE_RecordDefinition_WITH_EXT.Reset();
                    iterationNo := 0;
                    for iterationNo := 1 to 10000 do
                    begin
                        TableWith_VERYHUGE_RecordDefinition_WITH_EXT."Document Type" := TableWith_VERYHUGE_RecordDefinition_WITH_EXT."Document Type"::Order;
                        TableWith_VERYHUGE_RecordDefinition_WITH_EXT."Document No." := 'DT9999';
                        TableWith_VERYHUGE_RecordDefinition_WITH_EXT."Line No." := iterationNo;
                        TableWith_VERYHUGE_RecordDefinition_WITH_EXT.Type := TableWith_VERYHUGE_RecordDefinition_WITH_EXT.Type::" ";
                        TableWith_VERYHUGE_RecordDefinition_WITH_EXT.Description := 'HUGE Record Definition ' + (Format(iterationNo));
                        TableWith_VERYHUGE_RecordDefinition_WITH_EXT.Insert(false);
                    end;
                    Message('I am done.');
                end;            
            }

            action(InsertDTSalesLinesWithExtAndSubs)
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    TableWith_VERYHUGE_RecordDefinition_WITH_EXT_AND_SUBS : Record "DT SL With Ext and Subs";
                begin
                    TableWith_VERYHUGE_RecordDefinition_WITH_EXT_AND_SUBS.Reset();
                    iterationNo := 0;
                    for iterationNo := 1 to 10000 do
                    begin
                        TableWith_VERYHUGE_RecordDefinition_WITH_EXT_AND_SUBS."Document Type" := TableWith_VERYHUGE_RecordDefinition_WITH_EXT_AND_SUBS."Document Type"::Order;
                        TableWith_VERYHUGE_RecordDefinition_WITH_EXT_AND_SUBS."Document No." := 'DT9999';
                        TableWith_VERYHUGE_RecordDefinition_WITH_EXT_AND_SUBS."Line No." := iterationNo;
                        TableWith_VERYHUGE_RecordDefinition_WITH_EXT_AND_SUBS.Type := TableWith_VERYHUGE_RecordDefinition_WITH_EXT_AND_SUBS.Type::" ";
                        TableWith_VERYHUGE_RecordDefinition_WITH_EXT_AND_SUBS.Description := 'HUGE Record Definition ' + (Format(iterationNo));
                        TableWith_VERYHUGE_RecordDefinition_WITH_EXT_AND_SUBS.Insert(false);
                    end;
                    Message('I am done.');
                end;            
            }

            action(InsertAreas)
            {
                ApplicationArea = All;
                
                trigger OnAction()
                var
                    TableWith_SMALL_RecordDefinition : Record "Area";
                begin
                    TableWith_SMALL_RecordDefinition.Reset();
                    iterationNo := 0;
                    for iterationNo := 1 to 25000 do
                    begin
                        TableWith_SMALL_RecordDefinition.Code := Format(iterationNo);
                        TableWith_SMALL_RecordDefinition.Text := 'SMALL Record Definition ' + Format(iterationNo);
                        TableWith_SMALL_RecordDefinition.Insert(false);
                    end;
                    Message('I am done.');
                end;            
            }
            action(InsertAreasWithExt)
            {
                ApplicationArea = All;
                trigger OnAction()
                var
                    TableWith_SMALL_RecordDefinition_WITH_EXT : Record "Area With Ext";
                begin
                    TableWith_SMALL_RecordDefinition_WITH_EXT.Reset();
                    iterationNo := 0;
                    for iterationNo := 1 to 25000 do
                    begin
                        TableWith_SMALL_RecordDefinition_WITH_EXT.Code := Format(iterationNo);
                        TableWith_SMALL_RecordDefinition_WITH_EXT.Text := 'SMALL Record Definition ' + Format(iterationNo);
                        TableWith_SMALL_RecordDefinition_WITH_EXT.Insert(false);
                    end;
                    Message('I am done.');
                end;            
            }

            action(DeleteAll)
            {
                ApplicationArea = All;
                
                trigger OnAction()
                var
                    TableWith_SMALL_RecordDefinition : Record "Area";
                    TableWith_SMALL_RecordDefinition_WITH_EXT : Record "Area With Ext";
                    SalesLine : Record "Sales Line";
                    TableWith_VERYHUGE_RecordDefinition : Record "DT Sales Line";
                    TableWith_VERYHUGE_RecordDefinition_WITH_EXT : Record "DT Sales Line With Ext";
                    TableWith_VERYHUGE_RecordDefinition_WITH_EXT_AND_SUBS : Record "DT SL With Ext and Subs";
                begin
                    SalesLine.Reset();
                    SalesLine.setrange("Document Type",SalesLine."Document Type"::Order);
                    SalesLine.setrange("Document No.",'DT9999');
                    SalesLine.DeleteAll();

                    TableWith_VERYHUGE_RecordDefinition.Reset();
                    TableWith_VERYHUGE_RecordDefinition.setrange("Document Type",TableWith_VERYHUGE_RecordDefinition."Document Type"::Order);
                    TableWith_VERYHUGE_RecordDefinition.setrange("Document No.",'DT9999');
                    TableWith_VERYHUGE_RecordDefinition.DeleteAll();

                    TableWith_VERYHUGE_RecordDefinition_WITH_EXT.Reset();
                    TableWith_VERYHUGE_RecordDefinition_WITH_EXT.setrange("Document Type",TableWith_VERYHUGE_RecordDefinition_WITH_EXT."Document Type"::Order);
                    TableWith_VERYHUGE_RecordDefinition_WITH_EXT.setrange("Document No.",'DT9999');
                    TableWith_VERYHUGE_RecordDefinition_WITH_EXT.DeleteAll();

                    TableWith_VERYHUGE_RecordDefinition_WITH_EXT_AND_SUBS.Reset();
                    TableWith_VERYHUGE_RecordDefinition_WITH_EXT_AND_SUBS.setrange("Document Type",TableWith_VERYHUGE_RecordDefinition_WITH_EXT_AND_SUBS."Document Type"::Order);
                    TableWith_VERYHUGE_RecordDefinition_WITH_EXT_AND_SUBS.setrange("Document No.",'DT9999');
                    TableWith_VERYHUGE_RecordDefinition_WITH_EXT_AND_SUBS.DeleteAll();

                    TableWith_SMALL_RecordDefinition.Reset();
                    TableWith_SMALL_RecordDefinition.DeleteAll();

                    TableWith_SMALL_RecordDefinition_WITH_EXT.Reset();
                    TableWith_SMALL_RecordDefinition_WITH_EXT.DeleteAll();

                    Message('I am done.');
                end;            
            }

        }
    }
            var
                iterationNo : Integer;
                iterationText : text[4];
}