pageextension 59162 "TP Sales Orders" extends "Sales Orders"
{
    layout
    {
        addafter(Description)
        {
            field("Order Date"; Rec."Order Date")
            {
                ApplicationArea = all;
            }
        }
        addafter(Quantity)
        {
            field("Qty. Shipped Not Invoiced"; Rec."Qty. Shipped Not Invoiced")
            {
                ApplicationArea = all;
            }
        }
        addafter("Sell-to Customer No.")
        {
            field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
            {
                ApplicationArea = all;
            }
            field("Sell-to Customer Name 2"; Rec."Sell-to Customer Name 2")
            {
                ApplicationArea = all;
            }
            field("Order Type"; Rec."Order Type")
            {
                ApplicationArea = all;
            }
            field("Salesperson Code"; Rec."Salesperson Code")
            {
                ApplicationArea = all;
            }
            field("Sales Person"; Rec."Sales Person")
            {
                ApplicationArea = all;
            }
            field(Machinemodel; Machinemodel)
            {
                Caption = 'Machine Model';
                ApplicationArea = all;
            }
        }
        addafter(Amount)
        {
            field(MaterialShipNotInvoicedInclVAT; MaterialShipNotInvoicedInclVAT)
            {
                Caption = 'Material Shipped Not Invoiced Inc. VAT';
                ApplicationArea = all;
            }
            field(OutstandingAmountInclVAT; OutstandingAmountInclVAT)
            {
                Caption = 'Outstanding Amount Inc. VAT';
                ApplicationArea = all;
            }
            field(UnitPriceExclVAT; UnitPriceExclVAT)
            {
                Caption = 'Unit Price Exc. VAT';
                ApplicationArea = all;
            }
            field(UnitPriceIncVAT; UnitPriceIncVAT)
            {
                Caption = 'Unit Price Inc. VAT';
                ApplicationArea = all;
            }
            field(UnitPriceDiscounted; UnitPriceDiscounted)
            {
                Caption = 'Unit Price Discounted';
                ApplicationArea = all;
            }

        }
        modify("Unit Price")
        {
            Visible = false;
        }
        modify("Line Discount %")
        {
            Visible = false;
        }
        addafter("Document No.")
        {
            field(OrderStatus; Rec.OrderStatus)
            {
                ApplicationArea = all;
            }
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = all;
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        SalesHeader: Record "Sales Header";
        Customer: Record Customer;
    begin
        UnitPriceDiscounted := 0;

        SalesHeader.RESET;
        SalesHeader.SETRANGE(SalesHeader."No.", Rec."Document No.");
        IF SalesHeader.FIND('-') THEN BEGIN
            IF SalesHeader."Prices Including VAT" THEN BEGIN
                UnitPriceIncVAT := Rec."Unit Price";
                UnitPriceExclVAT := Rec."Unit Price" / (1 + Rec."VAT %" / 100);
                IF Rec.Quantity <> 0 THEN BEGIN
                    UnitPriceDiscounted := ROUND(Rec."Line Amount" / Rec.Quantity, 0.000001, '=');
                END;
                MaterialShipNotInvoicedInclVAT := Rec."Shipped Not Invoiced";
                OutstandingAmountInclVAT := Rec."Outstanding Amount";
            END
            ELSE BEGIN
                UnitPriceIncVAT := Rec."Unit Price" * (1 + Rec."VAT %" / 100);
                UnitPriceExclVAT := Rec."Unit Price";
                IF Rec.Quantity <> 0 THEN BEGIN
                    UnitPriceDiscounted := ROUND((Rec."Line Amount" / Rec.Quantity) * (1 + Rec."VAT %" / 100), 0.000001, '=');
                END;
                MaterialShipNotInvoicedInclVAT := ROUND(UnitPriceDiscounted * Rec."Qty. Shipped Not Invoiced", 0.01, '=');
                OutstandingAmountInclVAT := ROUND(UnitPriceDiscounted * Rec."Outstanding Quantity", 0.01, '=');
            END;

            VAT := Rec."Amount Including VAT" - Rec.Amount;
            AmountExclVAT := Rec.Amount;
            OrderType := FORMAT(SalesHeader."Order Type");

            IF Customer.GET(SalesHeader."Sell-to Customer No.") THEN BEGIN
                CustomerName := Customer.Name;
                CustomerName2 := Customer."Name 2";
            END
            ELSE BEGIN
                CustomerName := '';
                CustomerName2 := '';
            END;
        END;

        SalesHeader.RESET;
        SalesHeader.SETRANGE("Document Type", Rec."Document Type");
        SalesHeader.SETRANGE("No.", Rec."Document No.");
        IF SalesHeader.FINDFIRST THEN BEGIN
            Machinemodel := SalesHeader."Machine Model";

        END;
    end;

    var
        MaterialShipNotInvoicedInclVAT: Decimal;
        OutstandingAmountInclVAT: Decimal;
        UnitPriceIncVAT: Decimal;
        UnitPriceExclVAT: Decimal;
        VAT: Decimal;
        AmountExclVAT: Decimal;
        OrderType: Text;
        CustomerName: Text[100];
        CustomerName2: Text[100];
        Machinemodel: Code[30];
        UnitPriceDiscounted: Decimal;
}
