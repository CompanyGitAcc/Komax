page 50095 "TP Earning Analysis Report"
{
    Caption = 'Earning Analysis Report';
    UsageCategory = Lists;
    RefreshOnActivate = true;
    PageType = Worksheet;
    SourceTable = "Sales Invoice Line";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            //筛选条件
            group(Filters)
            {

                Caption = 'Filters';
                field(BeginDate; BeginDate)
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                    end;
                }

                field(EndDate; EndDate)
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        if EndDate < BeginDate then
                            error('The end date cannot be later than the begin date');
                    end;
                }

                field(CustNoFilter; CustNoFilter)
                {
                    Caption = 'Customer No.';
                    ApplicationArea = all;
                    TableRelation = Customer;
                }
                field(ItemNoFilter; ItemNoFilter)
                {
                    Caption = 'Item No.';
                    ApplicationArea = all;
                    TableRelation = Item;
                }
            }


            repeater(General)
            {
                Editable = false;
                //报表要显示的字段
                field(Code; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Customer No."; rec."Sell-to Customer No.")
                {
                    ApplicationArea = All;
                }

                field("Customer Name"; Rec."Sell-to Customer Name")
                {
                    Caption = 'Customer Name';
                    ApplicationArea = All;
                }
                field("Invoice No."; Rec."Document No.")
                {
                    Caption = 'Invoice No.';
                    ApplicationArea = All;
                }

                field(GTNo; GTNo)
                {
                    Caption = 'Golden Tax No.';
                    ApplicationArea = All;
                }
                field("Item No."; Rec."No.")
                {
                    Caption = 'In AMT';
                    ApplicationArea = All;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;
                }

                field(Description; Rec.Description)
                {
                    Caption = 'Description';
                    ApplicationArea = All;
                }
                field("Order Type"; Rec."Order Type")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    Caption = 'Quantity';
                    BlankZero = true;
                    ApplicationArea = All;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    Caption = 'Unit Price';
                    BlankZero = true;
                    ApplicationArea = All;
                }
                field("Amount"; Rec."Amount")
                {
                    Caption = 'Amount';
                    BlankZero = true;
                    ApplicationArea = All;
                }

                field("Sales Amount"; Rec."Sales Amount")
                {
                    Caption = 'Sales Amount'; //Value Entry - Sales Amount
                    BlankZero = true;
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Discount Amount"; Rec."Line Discount Amount")
                {
                    ApplicationArea = All;
                }
                field("Item Charge Amount"; Rec."Item Charge Amount")
                {
                    BlankZero = true;
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Cost Of Sales"; Rec."Cost Of Sales")
                {
                    BlankZero = true;
                    ApplicationArea = All;
                }
                field("Cost ACIE"; Rec."Cost ACIE")
                {
                    BlankZero = true;
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Caption = 'Prod. Line';
                    ApplicationArea = all;
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ApplicationArea = all;
                }
                field(Description1; Description1)
                {
                    ApplicationArea = all;
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = all;
                }
                field(Description2; Description2)
                {
                    ApplicationArea = all;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = all;
                }
                field(Description3; Description3)
                {
                    ApplicationArea = all;
                }
                field("Posting Group"; Rec."Posting Group")
                {
                    ApplicationArea = all;
                }
                field(Description4; Description4)
                {
                    ApplicationArea = all;
                }
                field(ProductGroupCode; ProductGroupCode)
                {
                    ApplicationArea = all;
                    Caption = 'Product Group Code';
                }
                field(Description5; Description5)
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Calculate")
            {
                Caption = 'Calculate';
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;

                trigger OnAction()
                begin
                    CalcData();
                end;
            }

            action("Check")
            {
                Caption = 'Check Data';
                Image = Confirm;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = all;
                trigger OnAction()
                var
                    CheckReport: Page "Earning Report Check";
                    CustLedgerEntry: Record "Cust. Ledger Entry";
                begin
                    CustLedgerEntry.SetRange("Posting Date", BeginDate, EndDate);
                    CheckReport.SetTableView(CustLedgerEntry);
                    CheckReport.RunModal();
                    Clear(CheckReport);
                end;
            }

        }
    }
    trigger OnOpenPage()

    begin
    end;

    trigger OnAfterGetRecord()
    var
        SalesInvLine: Record "Sales Invoice Line";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        Item: Record Item;
    begin
        ProdLine := '';
        if item.get(Rec."No.") then begin
            ProdLine := Item."Global Dimension 5 Code";
            ProductGroupCode := Item."Product Group";
            if ProductGroup.get(Item."Item Category Code", Item."Product Group") then
                Description5 := ProductGroup.Description;
        end;
        if ItemCategory.get(Rec."Item Category Code") then
            Description1 := ItemCategory.Description
        else
            Description1 := '';
        if GenBusPostingGroup.get(Rec."Gen. Bus. Posting Group") then
            Description2 := GenBusPostingGroup.Description
        else
            Description2 := '';
        if GenProPostingGroup.get(Rec."Gen. Prod. Posting Group") then
            Description3 := GenProPostingGroup.Description
        else
            Description3 := '';
        if InventoryPostingGroup.get(Rec."Posting Group") then
            Description4 := InventoryPostingGroup.Description
        else
            Description4 := '';
    end;

    procedure CalcData()
    var
        SalesInvHeader: Record "Sales Invoice Header";
        SalesInvLine: Record "Sales Invoice Line";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        window: Dialog;
        ItemLedgerEntry: Record "Item Ledger Entry";
        ValueEntries: Record "Value Entry";
        SalesInvLine2: Record "Sales Invoice Line";
    begin
        window.Open('#1########');
        Rec.Reset();
        if Rec.FindFirst() then
            Rec.DeleteAll();
        SalesInvLine.reset;
        SalesInvLine.SetRange("Posting Date", BeginDate, EndDate);
        SalesInvLine.SetFilter(Quantity, '<>%1', 0);
        if CustNoFilter <> '' then
            SalesInvLine.SetRange("Sell-to Customer No.", CustNoFilter);
        if ItemNoFilter <> '' then
            SalesInvLine.SetRange("No.", ItemNoFilter);
        if SalesInvLine.FindFirst() then
            repeat
                window.Update(1, SalesInvLine."No.");
                if SalesInvLine.Quantity <> 0 then begin
                    Rec.Init();
                    Rec := SalesInvLine;
                    //++to be deleted
                    if SalesInvHeader.get(SalesInvLine."Document No.") then begin
                        if SalesInvHeader."Currency Factor" = 0 then
                            SalesInvHeader."Currency Factor" := 1;
                        if SalesInvHeader."Prices Including VAT" = true then
                            Rec."Line Discount Amount" := SalesInvLine."Line Discount Amount" / SalesInvHeader."Currency Factor" / ((100 + SalesInvLine."VAT %") / 100)
                        else
                            Rec."Line Discount Amount" := SalesInvLine."Line Discount Amount" / SalesInvHeader."Currency Factor";
                        Rec."Amount" := SalesInvLine."Amount" / SalesInvHeader."Currency Factor";
                        Rec."External Document No." := SalesInvHeader."External Document No.";
                        Rec."Order Type" := SalesInvHeader."Order Type";
                    end;
                    //--to be deleted

                    CalcAmounts(SalesInvLine, Rec."Sales Amount", Rec."Cost Of Sales", rec."Cost ACIE", Rec."Item Charge Amount");
                    Rec."Unit Price" := Rec."Sales Amount" / Rec.Quantity;
                    Rec.Insert();
                end;
            until SalesInvLine.Next() = 0;

        SalesCrMemoLine.reset;
        SalesCrMemoLine.SetRange("Posting Date", BeginDate, EndDate);
        SalesCrMemoLine.SetFilter(Quantity, '<>%1', 0);
        if CustNoFilter <> '' then
            SalesCrMemoLine.SetRange("Sell-to Customer No.", CustNoFilter);
        if ItemNoFilter <> '' then
            SalesCrMemoLine.SetRange("No.", ItemNoFilter);
        if SalesCrMemoLine.FindFirst() then
            repeat
                window.Update(1, SalesCrMemoLine."No.");
                if SalesCrMemoLine.Quantity <> 0 then begin
                    Rec.Init();
                    Rec.TransferFields(SalesCrMemoLine);
                    //++to be deleted
                    if SalesCrMemoHeader.get(SalesCrMemoLine."Document No.") then begin
                        Rec.Quantity := -1 * Rec.Quantity;
                        if SalesCrMemoHeader."Currency Factor" = 0 then
                            SalesCrMemoHeader."Currency Factor" := 1;
                        if SalesCrMemoHeader."Prices Including VAT" = true then
                            Rec."Line Discount Amount" := -1 * SalesCrMemoLine."Line Discount Amount" / SalesCrMemoHeader."Currency Factor" / ((100 + SalesCrMemoLine."VAT %") / 100)
                        else
                            Rec."Line Discount Amount" := -1 * SalesCrMemoLine."Line Discount Amount" / SalesCrMemoHeader."Currency Factor";
                        Rec."Amount" := -1 * SalesCrMemoLine."Amount" / SalesCrMemoHeader."Currency Factor";
                        Rec."External Document No." := SalesInvHeader."External Document No.";
                        Rec."Order Type" := SalesInvHeader."Order Type";
                    end;
                    //--to be deleted                    
                    CalcAmounts2(SalesCrMemoLine, Rec."Sales Amount", Rec."Cost Of Sales", rec."Cost ACIE", Rec."Item Charge Amount"); //"Unit Cost (LCY)"= Cost ACIE; Amount= Item Assign Amount
                    Rec."Unit Price" := Rec."Sales Amount" / Rec.Quantity;
                    Rec.Insert();
                end;
            until SalesCrMemoLine.Next() = 0;

        //2023/3/5 add adjust entry
        ValueEntries.Reset();
        ValueEntries.SetRange(Adjustment, true);
        ValueEntries.SetRange("Posting Date", BeginDate, EndDate);
        ValueEntries.SetRange("Item Ledger Entry Type", ValueEntries."Item Ledger Entry Type"::Sale);
        ValueEntries.SetRange("Document Type", ValueEntries."Document Type"::"Sales Invoice");
        if ValueEntries.FindFirst() then
            repeat
                if SalesInvLine2.get(ValueEntries."Document No.", ValueEntries."Document Line No.") then begin
                    if (SalesInvLine2."Posting Date" < BeginDate) Or (SalesInvLine2."Posting Date" > EndDate) then begin
                        Rec.Init();
                        Rec."Posting Date" := ValueEntries."Posting Date";
                        Rec."Sell-to Customer No." := SalesInvLine2."Sell-to Customer No.";
                        rec."Sell-to Customer Name" := SalesInvLine2."Sell-to Customer Name";
                        Rec."Document No." := SalesInvLine2."Document No.";
                        Rec."Line No." := SalesInvLine2."Line No.";
                        Rec."No." := ValueEntries."Item No.";
                        Rec.Description := ValueEntries.Description;
                        Rec.Quantity := ValueEntries."Valued Quantity";
                        Rec."Cost Of Sales" := -1 * ValueEntries."Cost Amount (Actual)";
                        Rec."Item Category Code" := SalesInvLine2."Item Category Code";
                        Rec."Gen. Bus. Posting Group" := SalesInvLine2."Gen. Bus. Posting Group";
                        Rec."Gen. Prod. Posting Group" := SalesInvLine2."Gen. Prod. Posting Group";
                        rec."Posting Group" := SalesInvLine2."Posting Group";
                        Rec.Insert();
                    end;
                end;
            until ValueEntries.Next() = 0;

        Window.Close();
    end;

    procedure CalcAmounts(SalesInvLine: Record "Sales Invoice Line"; var SalesAmount: Decimal; var CostSales: Decimal; var CostACIE: Decimal; var ItemChargeAmt: Decimal)
    var
        ValueEntry: Record "Value Entry";
        ValueEntry2: Record "Value Entry";
    begin
        ValueEntry.RESET;
        ValueEntry.SETFILTER(ValueEntry."Posting Date", '%1..%2', BeginDate, EndDate);
        ValueEntry.SETRANGE(ValueEntry."Document No.", SalesInvLine."Document No.");
        ValueEntry.SETRANGE(ValueEntry."Document Line No.", SalesInvLine."Line No.");
        ValueEntry.SETRANGE("Item Ledger Entry Type", ValueEntry."Item Ledger Entry Type"::Sale);
        ValueEntry.SETFILTER("Document Type", '2|4');
        ValueEntry.SETRANGE(ValueEntry."Item No.", SalesInvLine."No.");
        IF ValueEntry.FindFirst() THEN
            REPEAT
                IF ValueEntry.Adjustment THEN BEGIN
                    CostACIE := CostACIE + (-ValueEntry."Cost Amount (Actual)");
                END;
                if ValueEntry.Adjustment = false then
                    SalesAmount := SalesAmount + ValueEntry."Sales Amount (Actual)";
                // else
                //     if ValueEntry."Cost Amount (Actual)" < 0 then //Important!!!
                //         SalesAmount := SalesAmount - ValueEntry."Sales Amount (Actual)";
                CostSales := CostSales + (-ValueEntry."Cost Amount (Actual)");
                IF (ValueEntry."Sales Amount (Actual)" <> 0) AND (ValueEntry."Item Charge No." = '') THEN BEGIN
                    ValueEntry2.RESET;
                    ValueEntry2.SETRANGE(ValueEntry2."Item Ledger Entry No.", ValueEntry."Item Ledger Entry No.");
                    ValueEntry2.SETFILTER(ValueEntry2."Item Charge No.", '<>%1', '');
                    IF ValueEntry2.FIND('-') THEN
                        REPEAT
                            ItemChargeAmt := ItemChargeAmt + ValueEntry2."Sales Amount (Actual)";
                        UNTIL ValueEntry2.NEXT = 0;
                END;
            UNTIL ValueEntry.NEXT = 0;
    end;

    procedure CalcAmounts2(SalesCrMemoLine: Record "Sales Cr.Memo Line"; var SalesAmount: Decimal; var CostSales: Decimal; var CostACIE: Decimal; var ItemChargeAmt: Decimal)
    var
        ValueEntry: Record "Value Entry";
        ValueEntry2: Record "Value Entry";
    begin
        ValueEntry.RESET;
        ValueEntry.SETFILTER(ValueEntry."Posting Date", '%1..%2', BeginDate, EndDate);
        ValueEntry.SETRANGE(ValueEntry."Document No.", SalesCrMemoLine."Document No.");
        ValueEntry.SETRANGE(ValueEntry."Document Line No.", SalesCrMemoLine."Line No.");
        ValueEntry.SETRANGE("Item Ledger Entry Type", ValueEntry."Item Ledger Entry Type"::Sale);
        ValueEntry.SETFILTER("Document Type", '2|4');
        ValueEntry.SETRANGE(ValueEntry."Item No.", SalesCrMemoLine."No.");
        IF ValueEntry.FindFirst() THEN
            REPEAT
                IF ValueEntry.Adjustment THEN BEGIN
                    CostACIE := CostACIE + (-ValueEntry."Cost Amount (Actual)");
                END;
                if ValueEntry.Adjustment = false then
                    SalesAmount := SalesAmount + ValueEntry."Sales Amount (Actual)";
                CostSales := CostSales + (-ValueEntry."Cost Amount (Actual)");
                IF (ValueEntry."Sales Amount (Actual)" <> 0) AND (ValueEntry."Item Charge No." = '') THEN BEGIN
                    ValueEntry2.RESET;
                    ValueEntry2.SETRANGE(ValueEntry2."Item Ledger Entry No.", ValueEntry."Item Ledger Entry No.");
                    ValueEntry2.SETFILTER(ValueEntry2."Item Charge No.", '<>%1', '');
                    IF ValueEntry2.FIND('-') THEN
                        REPEAT
                            ItemChargeAmt := ItemChargeAmt + ValueEntry2."Sales Amount (Actual)";
                        UNTIL ValueEntry2.NEXT = 0;
                END;
            UNTIL ValueEntry.NEXT = 0;
    end;

    var
        BeginDate: Date;
        EndDate: Date;
        SalesInvLineCode: Code[20];
        CustNoFilter: Code[20];
        ItemNoFilter: Code[20];
        GTNo: Code[20];
        ProdLine: Text[30];
        ItemChargeAmount: Decimal;
        CostOfSale: Decimal;
        Description1: Text[100];
        Description2: Text[100];
        Description3: Text[100];
        Description4: Text[100];
        Description5: Text[100];
        ItemCategory: Record "Item Category";
        GenBusPostingGroup: Record "Gen. Business Posting Group";
        GenProPostingGroup: Record "Gen. Product Posting Group";
        InventoryPostingGroup: Record "Inventory Posting Group";
        ProductGroupCode: Code[20];
        ProductGroup: Record "TP Product Group";
        ExternalDocumentNo: Code[35];
        OrderType: Enum "Sales Order Type";

}
