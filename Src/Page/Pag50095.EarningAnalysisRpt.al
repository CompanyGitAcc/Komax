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

                field(Description; Rec.Description)
                {
                    Caption = 'Description';
                    ApplicationArea = All;
                }
                field(ProdLine; ProdLine)
                {
                    Caption = 'Product Line';
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
                field("Sales Amount"; Rec."Unit Price" * Rec.Quantity)
                {
                    Caption = 'Sales Amount';
                    BlankZero = true;
                    ApplicationArea = All;
                }
                // field(ItemChargeAmount; ItemChargeAmount)
                // {
                //     Caption = 'Item Charge Amount';
                //     BlankZero = true;
                //     ApplicationArea = All;
                // }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Caption = 'Prod. Line';
                    ApplicationArea = all;
                }
                field("Posting Group"; Rec."Posting Group")
                {
                    ApplicationArea = all;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = all;
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = all;
                }
                field(Discount; rec."Line Discount Amount")
                {
                    Caption = 'Discount';
                    BlankZero = true;
                    ApplicationArea = All;
                }
                field("Unit Cost"; round(Rec."Unit Cost" * Rec.Quantity, 0.01))
                {
                    Caption = 'Cost of Sale';
                    BlankZero = true;
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
    var
        SalesInvLine: Record "Sales Invoice Line";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        Item: Record Item;
    begin
        ProdLine := '';
        if item.get(Rec."No.") then begin
            ProdLine := Item."Global Dimension 5 Code";
        end;
    end;

    procedure CalcData()
    var
        SalesInvHeader: Record "Sales Invoice Header";
        SalesInvLine: Record "Sales Invoice Line";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        window: Dialog;
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        window.Open('#1########');
        Rec.Reset();
        if Rec.FindFirst() then
            Rec.DeleteAll();

        SalesInvLine.reset;
        SalesInvLine.SetRange("Posting Date", BeginDate, EndDate);
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
                    if SalesInvHeader.get(SalesInvLine."Document No.") then begin
                        if SalesInvHeader."Currency Factor" = 0 then
                            SalesInvHeader."Currency Factor" := 1;
                        if SalesInvHeader."Prices Including VAT" = true then
                            Rec."Unit Price" := SalesInvLine."Unit Price" / SalesInvHeader."Currency Factor" / ((100 + SalesInvLine."VAT %") / 100)
                        else
                            Rec."Unit Price" := SalesInvLine."Unit Price" / SalesInvHeader."Currency Factor";
                        Rec."Line Amount" := Round(Rec."Unit Price" * Rec.Quantity, 0.01);
                    end;
                    Rec.Insert();
                end;
            until SalesInvLine.Next() = 0;

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
                    Rec.TransferFields(SalesCrMemoLine);
                    // Rec."Document No." := SalesCrMemoLine."Document No.";
                    // Rec."Line No." := SalesCrMemoLine."Line No.";   
                    if SalesCrMemoHeader.get(SalesCrMemoLine."Document No.") then begin
                        Rec.Quantity := -1 * Rec.Quantity;
                        if SalesCrMemoHeader."Currency Factor" = 0 then
                            SalesCrMemoHeader."Currency Factor" := 1;
                        if SalesCrMemoHeader."Prices Including VAT" = true then
                            Rec."Unit Price" := SalesCrMemoLine."Unit Price" / SalesCrMemoHeader."Currency Factor" / ((100 + SalesCrMemoLine."VAT %") / 100)
                        else
                            Rec."Unit Price" := SalesCrMemoLine."Unit Price" / SalesCrMemoHeader."Currency Factor";
                        Rec."Line Amount" := Round(Rec."Unit Price" * Rec.Quantity, 0.01);
                    end;
                    Rec.Insert();
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
