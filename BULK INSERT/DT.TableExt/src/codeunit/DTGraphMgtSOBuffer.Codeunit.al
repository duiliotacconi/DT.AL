codeunit 50496 "DT Graph Mgt - S.O. Buffer"
{
    [EventSubscriber(ObjectType::Table, Database::"DT SL With Ext and Subs", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertSalesLine(var Rec: Record "DT SL With Ext and Subs"; RunTrigger: Boolean)
    begin
        UpdateCompletelyShipped(Rec);
    end;

    local procedure UpdateCompletelyShipped(var SalesLine: Record "DT SL With Ext and Subs")
    var
        SearchSalesLine: Record "DT SL With Ext and Subs";
        SalesOrderEntityBuffer: Record "Sales Order Entity Buffer";
        CompletelyShipped: Boolean;
    begin
        SearchSalesLine.ReadIsolation := IsolationLevel::ReadUncommitted;
        SearchSalesLine.CopyFilters(SalesLine);
        SearchSalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SearchSalesLine.SetRange("Document No.", SalesLine."Document No.");
        SearchSalesLine.SetFilter(Type, '<>%1', SalesLine.Type::" ");
        SearchSalesLine.SetRange("Location Code", SalesLine."Location Code");
        SearchSalesLine.SetRange("Completely Shipped", false);

        CompletelyShipped := SearchSalesLine.IsEmpty();

        if not SalesOrderEntityBuffer.Get(SalesLine."Document No.") then
            exit;

        if SalesOrderEntityBuffer."Completely Shipped" <> CompletelyShipped then begin
            SalesOrderEntityBuffer."Completely Shipped" := CompletelyShipped;
            SalesOrderEntityBuffer.Modify(true);
        end;
    end;

}