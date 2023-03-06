pageextension 59092 "TP Whse. Receipt Subform" extends "Whse. Receipt Subform"
{
    layout
    {
        modify("Location Code")
        {
            Visible = true;
            Editable = false;
        }
        addafter("Over-Receipt Code")
        {
            field("Line No."; Rec."Line No.")
            {
                ApplicationArea = all;
            }
        }
        addafter(Control1)
        {
            group(group)
            {
                ShowCaption = false;
                field(TotalQuantity; TotalQuantity)
                {
                    Caption = 'TotalQuantity';
                    ApplicationArea = all;
                    Editable = false;
                }
                // field(TotalAmount2; TotalAmount2)
                // {
                //     Caption = 'TotalAmount';
                //     ApplicationArea = all;
                //     Editable = false;
                // }
            }
        }

        addafter(Description)
        {
            field("Description 2"; Rec."Description 2")
            {
                ApplicationArea = all;
            }
        }

        addafter("Item No.")
        {
            field(ItemReferenceNo; ItemReferenceNo)
            {
                Caption = 'Item Reference No.';
                ApplicationArea = all;
            }
        }
        modify("Qty. Received")
        {
            trigger OnAfterValidate()
            begin

            end;
        }
    }

    trigger OnAfterGetRecord()
    var
        WarehouseReceiptLine: Record "Warehouse Receipt Line";
        PurchaseLine: Record "Purchase Line";
    begin
        ItemReferenceNo := '';
        TotalQuantity := 0;
        TotalAmount2 := 0;
        WarehouseReceiptLine.Reset();
        WarehouseReceiptLine.SetRange("No.", Rec."No.");
        if WarehouseReceiptLine.FindFirst() then
            repeat
                TotalQuantity := TotalQuantity + WarehouseReceiptLine."Qty. to Receive";
                if PurchaseLine.get(PurchaseLine."Document Type"::Order, WarehouseReceiptLine."Source No.", WarehouseReceiptLine."Source Line No.") then begin
                    TotalAmount2 := TotalAmount2 + WarehouseReceiptLine."Qty. to Receive" * PurchaseLine."Direct Unit Cost";
                end;
            until WarehouseReceiptLine.Next() = 0;

        if Rec."Source Document" = Rec."Source Document"::"Purchase Order" then begin
            if PurchaseHeader.get(PurchaseHeader."Document Type"::Order, Rec."Source No.") then begin
                ItemReference.Reset();
                ItemReference.SetRange("Reference Type No.", PurchaseHeader."Buy-from Vendor No.");
                ItemReference.SetRange("Item No.", Rec."Item No.");
                if ItemReference.FindFirst() then begin
                    ItemReferenceNo := ItemReference."Reference No.";
                end;
            end;
        end;

        if Rec."Source Document" = Rec."Source Document"::"Sales Return Order" then begin
            if SalesHeader.get(SalesHeader."Document Type"::Order, Rec."Source No.") then begin
                ItemReference.Reset();
                ItemReference.SetRange("Reference Type No.", SalesHeader."Sell-to Customer No.");
                ItemReference.SetRange("Item No.", Rec."Item No.");
                if ItemReference.FindFirst() then begin
                    ItemReferenceNo := ItemReference."Reference No.";
                end;
            end;
        end;
    end;

    var
        TotalQuantity: Decimal;
        TotalAmount2: Decimal;
        ItemReferenceNo: Code[20];
        ItemReference: Record "Item Reference";
        PurchaseHeader: Record "Purchase Header";
        SalesHeader: Record "Sales Header";
}
