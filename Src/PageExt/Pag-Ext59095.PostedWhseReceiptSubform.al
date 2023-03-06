pageextension 59095 "TP Posted Whse. Rece. Subform" extends "Posted Whse. Receipt Subform"
{
    layout
    {
        addafter(Quantity)
        {
            field("Location Code"; REC."Location Code")
            {
                ApplicationArea = ALL;
            }
            field("Unit Price"; Rec."Unit Price")
            {
                ApplicationArea = ALL;
            }
            field("Amount Including VAT"; Rec."Amount Including VAT")
            {
                ApplicationArea = ALL;
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
                field(TotalAmount2; TotalAmount2)
                {
                    Caption = 'TotalAmount';
                    ApplicationArea = all;
                    Editable = false;
                }
            }
        }
        modify("Qty. Cross-Docked")
        {
            Visible = true;
        }
        modify("Qty. Cross-Docked (Base)")
        {
            Visible = true;
        }


        modify("Description 2")
        {
            Visible = true;
        }

        addafter("Item No.")
        {
            field(ItemReferenceNo; ItemReferenceNo)
            {
                Caption = 'Item Reference No.';
                ApplicationArea = all;
            }
        }
    }


    trigger OnAfterGetCurrRecord()
    var
        WarehouseReceiptLine: Record "Posted Whse. Receipt Line";
        PurchaseLine: Record "Purchase Line";
    begin
        TotalQuantity := 0;
        TotalAmount2 := 0;
        WarehouseReceiptLine.Reset();
        WarehouseReceiptLine.SetRange("No.", Rec."No.");
        if WarehouseReceiptLine.FindFirst() then
            repeat
                TotalQuantity := TotalQuantity + WarehouseReceiptLine.Quantity;
                if PurchaseLine.get(PurchaseLine."Document Type"::Order, WarehouseReceiptLine."Source No.", WarehouseReceiptLine."Source Line No.") then begin
                    TotalAmount2 := TotalAmount2 + WarehouseReceiptLine.Quantity * PurchaseLine."Direct Unit Cost";
                end;
            until WarehouseReceiptLine.Next() = 0;

        if Rec."Source Document" = Rec."Source Document"::"Purchase Order" then begin
            if PurchaseHeader.get(PurchaseHeader."Document Type"::Order, Rec."Source No.") then begin
                ItemReference.Reset();
                ItemReference.SetRange("Reference Type No.", PurchaseHeader."Buy-from Vendor No.");
                ItemReference.SetRange("Item No.", Rec."Item No.");
                if ItemReference.FindFirst() then
                    ItemReferenceNo := ItemReference."Reference No.";
            end;
        end;

        if Rec."Source Document" = Rec."Source Document"::"Sales Return Order" then begin
            if SalesHeader.get(SalesHeader."Document Type"::Order, Rec."Source No.") then begin
                ItemReference.Reset();
                ItemReference.SetRange("Reference Type No.", SalesHeader."Sell-to Customer No.");
                ItemReference.SetRange("Item No.", Rec."Item No.");
                if ItemReference.FindFirst() then
                    ItemReferenceNo := ItemReference."Reference No.";
            end;
        end;
    end;

    var
        TotalQuantity: Integer;
        TotalAmount2: Decimal;
        ItemReferenceNo: Code[20];
        ItemReference: Record "Item Reference";
        PurchaseHeader: Record "Purchase Header";
        SalesHeader: Record "Sales Header";
}
