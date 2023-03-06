page 50096 "TP Cust Statistics Report"
{

    Caption = 'Cust Statistics Report';
    UsageCategory = Lists;
    RefreshOnActivate = true;
    PageType = Worksheet;
    SourceTable = "Customer Item Sales Buffer";
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
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Customer Code"; Rec."Customer Code")
                {
                    ApplicationArea = All;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = All;
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = All;
                }
                field("Golden Tax Invoice No."; Rec."Golden Tax Invoice No.")
                {
                    ApplicationArea = All;
                }
                field("Sales Order No."; Rec."Sales Order No.")
                {
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    var
                        SalesOrderPage: Page "Sales Order";
                        SalesHeader: Record "Sales Header";
                    begin
                        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
                        SalesHeader.SetRange("No.", Rec."Sales Order No.");
                        SalesOrderPage.SetTableView(SalesHeader);
                        SalesOrderPage.RunModal();
                    end;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Invoiced Quantity"; Rec."Invoiced Quantity")
                {
                    ApplicationArea = All;
                }
                field("Sales Amount"; Rec."Sales Amount")
                {
                    ApplicationArea = All;
                }
                field("Machine Model"; Rec."Machine Model")
                {
                    ApplicationArea = All;
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
        }
    }
    trigger OnOpenPage()

    begin
    end;

    trigger OnAfterGetRecord()
    begin

    end;

    procedure CalcData()
    var
        ValueEntry: Record "Value Entry";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        window: Dialog;
        ItemLedgerEntry: Record "Item Ledger Entry";
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesHeader: Record "Sales Header";
    begin
        window.Open('#1########');
        Rec.Reset();
        if Rec.FindFirst() then
            Rec.DeleteAll();

        ValueEntry.reset;
        ValueEntry.SetRange("Posting Date", BeginDate, EndDate);
        ValueEntry.SetFilter("Source Type", 'Customer');
        ValueEntry.SetFilter("Item Ledger Entry Type", '<>%1', ValueEntry."Item Ledger Entry Type"::" ");
        ValueEntry.SetFilter("Document Type", 'Sales Invoice|Sales Credit Memo');
        if CustNoFilter <> '' then
            ValueEntry.SetRange("Source No.", CustNoFilter);
        if ItemNoFilter <> '' then
            ValueEntry.SetRange("Item No.", ItemNoFilter);
        if ValueEntry.FindFirst() then
            repeat
                window.Update(1, Format(ValueEntry."Entry No."));
                if Rec.get(ValueEntry."Source No.", ValueEntry."Document No.", ValueEntry."Item No.") then begin
                    ValueEntry."Sales Amount (Actual)" := ValueEntry."Sales Amount (Actual)" + Rec."Sales Amount";
                    ValueEntry.Modify();
                end else begin
                    Rec.Init();
                    Rec."Posting Date" := ValueEntry."Posting Date";
                    Rec."Customer Code" := ValueEntry."Source No.";
                    Rec."Document No." := ValueEntry."Document No.";
                    if SalesInvoiceLine.get(ValueEntry."Document No.", ValueEntry."Document Line No.") then
                        Rec."Sales Order No." := SalesInvoiceLine."Order No.";
                    if SalesCrMemoLine.get(ValueEntry."Document No.", ValueEntry."Document Line No.") then
                        Rec."Sales Order No." := SalesCrMemoLine."Order No.";
                    Rec."Item No." := ValueEntry."Item No.";
                    Rec."Sales Amount" := ValueEntry."Sales Amount (Actual)";
                    Rec."Invoiced Quantity" := Abs(ValueEntry."Invoiced Quantity");
                    Rec."External Document No." := ValueEntry."External Document No.";
                    // Rec."Document Type" := ValueEntry."Document Type";
                    // Rec."Customer Name" := ValueEntry."Customer Name";
                    // Rec."Golden Tax Invoice No." := ValueEntry."Customer Name";
                    Rec.Description := ValueEntry.Description;
                    if SalesHeader.get(SalesHeader."Document Type"::Order, Rec."Sales Order No.") then begin
                        Rec."Machine Model" := SalesHeader."Machine Model";
                        Rec."Document Type" := SalesHeader."Order Type";
                        Rec."Order Date" := SalesHeader."Order Date";
                    end;
                    Rec.Insert();
                end;

            until ValueEntry.Next() = 0;

        SalesCrMemoLine.reset;
        SalesCrMemoLine.SetRange("Posting Date", BeginDate, EndDate);
        if CustNoFilter <> '' then
            SalesCrMemoLine.SetRange("Sell-to Customer No.", CustNoFilter);
        if ItemNoFilter <> '' then
            SalesCrMemoLine.SetRange("No.", ItemNoFilter);
        if SalesCrMemoLine.FindFirst() then
            repeat
                window.Update(1, SalesCrMemoLine."No.");
                if SalesCrMemoLine.Quantity <> 0 then begin
                    Rec.Init();
                    // Rec.TransferFields(SalesCrMemoLine);
                    // Rec."Document No." := SalesCrMemoLine."Document No.";
                    // Rec."Line No." := SalesCrMemoLine."Line No.";

                    Rec."Posting Date" := SalesCrMemoLine."Posting Date";
                    Rec."Customer Code" := SalesCrMemoLine."Sell-to Customer No.";
                    Rec."Document No." := SalesCrMemoLine."Document No.";
                    Rec."Item No." := SalesCrMemoLine."No.";
                    Rec."Sales Amount" := SalesCrMemoLine.Amount;
                    Rec."Invoiced Quantity" := SalesCrMemoLine.Quantity;
                    if SalesCrMemoHeader.get(SalesCrMemoLine."Document No.") then begin
                        Rec."External Document No." := SalesCrMemoHeader."External Document No.";
                        Rec."Document Type" := SalesCrMemoHeader."Order Type";
                        Rec."Machine Model" := SalesCrMemoHeader."Machine Model";
                    end;

                    if Rec.Insert() then;
                end;
            until SalesCrMemoLine.Next() = 0;

        Window.Close();
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
}