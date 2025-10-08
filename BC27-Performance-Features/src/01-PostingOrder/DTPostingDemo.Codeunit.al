// Posting Order Performance Demo
// This codeunit demonstrates the improved posting order in BC 27
// In Codeunit 80 "Sales-Post" and Codeunit 90 "Purch.-Post", 
// BC 27 uses SetCurrentKey(Type, "Line No.") for optimized posting order

codeunit 55001 "DT Posting Demo"
{
    var
        SalesOrderPostedSuccessfullyMsg: Label 'Sales Order posted successfully!';

    trigger OnRun()
    begin
        DemoPostingOrder();
    end;

    procedure DemoPostingOrder()
    var
        SalesHeader: Record "Sales Header";
        Customer: Record Customer;
    begin
        // Find or create test customer
        if not Customer.Get('DEMO-CUST') then
            CreateTestCustomer(Customer);

        // Create sales order with mixed line types
        CreateSalesOrderWithMixedLines(SalesHeader, Customer."No.");

        // Show the created lines before posting
        ShowCreatedLines(SalesHeader);

        // Set Ship option for posting
        SalesHeader.Ship := true;
        SalesHeader.Invoice := true;
        SalesHeader.Modify();

        // Post the sales order - event subscriber will show the posting order
        Codeunit.Run(Codeunit::"Sales-Post", SalesHeader);

        Message(SalesOrderPostedSuccessfullyMsg);
    end;

    local procedure CreateTestCustomer(var Customer: Record Customer)
    var
        GenBusPostingGroup: Code[20];
    begin
        GenBusPostingGroup := FindGenBusPostingGroup();

        Customer.Init();
        Customer."No." := 'DEMO-CUST';
        Customer.Name := 'Demo Customer for Posting Order';
        Customer."Customer Posting Group" := FindCustomerPostingGroup();
        Customer."Gen. Bus. Posting Group" := GenBusPostingGroup;
        Customer.Insert(true);

        // Ensure posting setup exists
        EnsureGeneralPostingSetup(GenBusPostingGroup);
    end;

    local procedure CreateSalesOrderWithMixedLines(var SalesHeader: Record "Sales Header"; CustomerNo: Code[20])
    var
        SalesLine: Record "Sales Line";
        Item: Record Item;
        GLAccount: Record "G/L Account";
        Resource: Record Resource;
        LineNo: Integer;
    begin
        // Create Sales Header
        SalesHeader.Init();
        SalesHeader."Document Type" := SalesHeader."Document Type"::Order;
        SalesHeader.Insert(true);
        SalesHeader.Validate("Sell-to Customer No.", CustomerNo);
        SalesHeader.Modify(true);

        LineNo := 10000;

        // Create lines in mixed order to demonstrate sorting
        // Line 1: Item
        if FindOrCreateItem(Item, 'ITEM-001') then
            CreateSalesLine(SalesHeader, LineNo, SalesLine.Type::Item, Item."No.", 1);
        LineNo += 10000;

        // Line 2: G/L Account
        if FindGLAccount(GLAccount) then
            CreateSalesLine(SalesHeader, LineNo, SalesLine.Type::"G/L Account", GLAccount."No.", 0);
        LineNo += 10000;

        // Line 3: Item
        if FindOrCreateItem(Item, 'ITEM-002') then
            CreateSalesLine(SalesHeader, LineNo, SalesLine.Type::Item, Item."No.", 2);
        LineNo += 10000;

        // Line 4: Resource
        if FindOrCreateResource(Resource) then
            CreateSalesLine(SalesHeader, LineNo, SalesLine.Type::Resource, Resource."No.", 0);
        LineNo += 10000;

        // Line 5: Item
        if FindOrCreateItem(Item, 'ITEM-003') then
            CreateSalesLine(SalesHeader, LineNo, SalesLine.Type::Item, Item."No.", 3);
        LineNo += 10000;

        // Line 6: G/L Account
        if FindGLAccount(GLAccount) then
            CreateSalesLine(SalesHeader, LineNo, SalesLine.Type::"G/L Account", GLAccount."No.", 0);
        LineNo += 10000;

        // Line 7: Item
        if FindOrCreateItem(Item, 'ITEM-004') then
            CreateSalesLine(SalesHeader, LineNo, SalesLine.Type::Item, Item."No.", 1);
        LineNo += 10000;

        // Line 8: Resource
        if FindOrCreateResource(Resource) then
            CreateSalesLine(SalesHeader, LineNo, SalesLine.Type::Resource, Resource."No.", 0);
        LineNo += 10000;

        // Line 9: G/L Account
        if FindGLAccount(GLAccount) then
            CreateSalesLine(SalesHeader, LineNo, SalesLine.Type::"G/L Account", GLAccount."No.", 0);
        LineNo += 10000;

        // Line 10: Item
        if FindOrCreateItem(Item, 'ITEM-005') then
            CreateSalesLine(SalesHeader, LineNo, SalesLine.Type::Item, Item."No.", 2);
    end;

    local procedure CreateSalesLine(SalesHeader: Record "Sales Header"; LineNo: Integer; LineType: Enum "Sales Line Type"; No: Code[20]; Quantity: Decimal)
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.Init();
        SalesLine."Document Type" := SalesHeader."Document Type";
        SalesLine."Document No." := SalesHeader."No.";
        SalesLine."Line No." := LineNo;
        SalesLine.Insert(true);
        SalesLine.Validate(Type, LineType);
        SalesLine.Validate("No.", No);
        if Quantity > 0 then
            SalesLine.Validate(Quantity, Quantity);
        SalesLine.Validate("Unit Price", 100);
        SalesLine.Modify(true);
    end;

    local procedure FindOrCreateItem(var Item: Record Item; ItemNo: Code[20]): Boolean
    var
        ItemUnitOfMeasure: Record "Item Unit of Measure";
        UoMCode: Code[10];
    begin
        if Item.Get(ItemNo) then
            exit(true);

        // Find a valid unit of measure
        UoMCode := FindUnitOfMeasure();

        Item.Init();
        Item."No." := ItemNo;
        Item.Description := 'Demo Item ' + ItemNo;
        Item."Base Unit of Measure" := UoMCode;
        Item."Gen. Prod. Posting Group" := FindGenProdPostingGroup();
        Item."Inventory Posting Group" := FindInventoryPostingGroup();
        Item.Type := Item.Type::Inventory;
        if Item.Insert(true) then
            // Create Item Unit of Measure record
            if not ItemUnitOfMeasure.Get(Item."No.", UoMCode) then begin
                ItemUnitOfMeasure.Init();
                ItemUnitOfMeasure."Item No." := Item."No.";
                ItemUnitOfMeasure.Code := UoMCode;
                ItemUnitOfMeasure."Qty. per Unit of Measure" := 1;
                ItemUnitOfMeasure.Insert(true);
            end;
        exit(true);
    end;

    local procedure FindOrCreateResource(var Resource: Record Resource): Boolean
    begin
        Resource.SetRange(Blocked, false);
        if Resource.FindFirst() then
            exit(true);

        Resource.Init();
        Resource."No." := 'RES-001';
        Resource.Name := 'Demo Resource';
        Resource."Gen. Prod. Posting Group" := FindGenProdPostingGroup();
        Resource."Unit Price" := 100;
        Resource.Insert(true);
        exit(true);
    end;

    local procedure FindGLAccount(var GLAccount: Record "G/L Account"): Boolean
    begin
        GLAccount.SetRange("Direct Posting", true);
        GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
        GLAccount.SetFilter("Gen. Prod. Posting Group", '<>%1', '');
        exit(GLAccount.FindFirst());
    end;

    local procedure FindCustomerPostingGroup(): Code[20]
    var
        CustomerPostingGroup: Record "Customer Posting Group";
    begin
        if CustomerPostingGroup.FindFirst() then
            exit(CustomerPostingGroup.Code);
    end;

    local procedure FindGenBusPostingGroup(): Code[20]
    var
        GenBusinessPostingGroup: Record "Gen. Business Posting Group";
    begin
        if GenBusinessPostingGroup.FindFirst() then
            exit(GenBusinessPostingGroup.Code);
    end;

    local procedure FindGenProdPostingGroup(): Code[20]
    var
        GenProductPostingGroup: Record "Gen. Product Posting Group";
    begin
        if GenProductPostingGroup.FindFirst() then
            exit(GenProductPostingGroup.Code);
    end;

    local procedure FindInventoryPostingGroup(): Code[20]
    var
        InventoryPostingGroup: Record "Inventory Posting Group";
    begin
        if InventoryPostingGroup.FindFirst() then
            exit(InventoryPostingGroup.Code);
    end;

    local procedure FindUnitOfMeasure(): Code[10]
    var
        UnitOfMeasure: Record "Unit of Measure";
    begin
        if UnitOfMeasure.FindFirst() then
            exit(UnitOfMeasure.Code);
        exit('PCS');
    end;

    local procedure EnsureGeneralPostingSetup(GenBusPostingGroup: Code[20])
    var
        GeneralPostingSetup: Record "General Posting Setup";
        GLAccount: Record "G/L Account";
        GenProdPostingGroup: Code[20];
        SalesAccountNo: Code[20];
        COGSAccountNo: Code[20];
    begin
        GenProdPostingGroup := FindGenProdPostingGroup();

        // Find suitable GL Accounts for Sales and COGS
        GLAccount.SetRange("Direct Posting", true);
        GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
        if GLAccount.FindSet() then begin
            SalesAccountNo := GLAccount."No.";
            if GLAccount.Next() <> 0 then
                COGSAccountNo := GLAccount."No."
            else
                COGSAccountNo := SalesAccountNo;
        end else
            exit; // Cannot setup without GL Accounts

        // Check if posting setup exists, if not create it
        if not GeneralPostingSetup.Get(GenBusPostingGroup, GenProdPostingGroup) then begin
            GeneralPostingSetup.Init();
            GeneralPostingSetup."Gen. Bus. Posting Group" := GenBusPostingGroup;
            GeneralPostingSetup."Gen. Prod. Posting Group" := GenProdPostingGroup;
            GeneralPostingSetup."Sales Account" := SalesAccountNo;
            GeneralPostingSetup."COGS Account" := COGSAccountNo;
            GeneralPostingSetup."Sales Credit Memo Account" := SalesAccountNo;
            GeneralPostingSetup.Insert(true);
        end else begin
            // Update if missing accounts
            if GeneralPostingSetup."Sales Account" = '' then begin
                GeneralPostingSetup."Sales Account" := SalesAccountNo;
                GeneralPostingSetup.Modify(true);
            end;
            if GeneralPostingSetup."COGS Account" = '' then begin
                GeneralPostingSetup."COGS Account" := COGSAccountNo;
                GeneralPostingSetup.Modify(true);
            end;
        end;
    end;

    local procedure ShowCreatedLines(SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        LinesMessage: Text;
        Counter: Integer;
        LineNoLbl: Label 'Line No.';
        TypeLbl: Label 'Type';
        NoLbl: Label 'No.';
        LinesCreatedForLbl: Label 'Lines created for %1 %2:', Comment = '%1 = Document Type, %2 = Document No.';
        LineItemLbl: Label '%1.', Comment = '%1 = Counter';
    begin
        // Build message showing created lines ordered by Line No.
        LinesMessage := StrSubstNo(LinesCreatedForLbl, SalesHeader."Document Type", SalesHeader."No.");
        LinesMessage += '\ ';
        LinesMessage += '\ ';

        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetCurrentKey("Document Type", "Document No.", "Line No.");

        if SalesLine.FindSet() then
            repeat
                Counter += 1;
                LinesMessage += StrSubstNo(LineItemLbl, Counter) + ' ' +
                               LineNoLbl + ': ' + Format(SalesLine."Line No.") + ', ' +
                               TypeLbl + ': ' + Format(SalesLine.Type) + ', ' +
                               NoLbl + ': ' + SalesLine."No.";
                LinesMessage += '\ ';
                LinesMessage += '\ ';
            until SalesLine.Next() = 0;

        Message(LinesMessage);
    end;
}