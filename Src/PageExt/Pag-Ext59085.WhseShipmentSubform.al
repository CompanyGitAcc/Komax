pageextension 59085 "TP Whse. Shipment Subform" extends "Whse. Shipment Subform"
{
    layout
    {
        modify("Location Code")
        {
            Editable = false;
        }
        modify("Bin Code")
        {
            Visible = true;
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
            }
        }
        addafter("Bin Code")
        {
            field("Item Reference No."; Rec."Item Reference No.")
            {
                ApplicationArea = all;
            }
        }
        addafter(Description)
        {
            field("Description 2"; Rec."Description 2")
            {
                ApplicationArea = all;
            }
            field("Description 3"; Rec."Description 3")
            {
                ApplicationArea = all;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        WarehouseShipmentLine: Record "Warehouse Shipment Line";
        SalesLine: Record "Sales Line";
    begin
        TotalQuantity := 0;
        TotalAmount2 := 0;
        WarehouseShipmentLine.Reset();
        WarehouseShipmentLine.SetRange("No.", Rec."No.");
        if WarehouseShipmentLine.FindFirst() then
            repeat
                TotalQuantity := TotalQuantity + WarehouseShipmentLine."Qty. to Ship";
                if SalesLine.get(SalesLine."Document Type"::Order, WarehouseShipmentLine."Source No.", WarehouseShipmentLine."Source Line No.") then begin
                    TotalAmount2 := TotalAmount2 + WarehouseShipmentLine."Qty. to Ship" * SalesLine."Unit Price";
                end;
            until WarehouseShipmentLine.Next() = 0;
    end;

    var
        TotalQuantity: Integer;
        TotalAmount2: Decimal;
}
