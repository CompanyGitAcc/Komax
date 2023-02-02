pageextension 59088 "TP Posted Whse. Shpt. Subform" extends "Posted Whse. Shipment Subform"
{
    layout
    {
        addafter(Quantity)
        {
            field("Location Code"; REC."Location Code")
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
            }
        }
        addafter("Bin Code")
        {
            field("Item Reference No."; Rec."Item Reference No.")
            {
                ApplicationArea = all;
            }
        }

        modify("Description 2")
        {
            Visible = true;
        }

    }

    trigger OnAfterGetCurrRecord()
    var
        WarehouseShipmentLine: Record "Posted Whse. Shipment Line";
        SalesLine: Record "Sales Line";
    begin
        TotalQuantity := 0;
        TotalAmount2 := 0;
        WarehouseShipmentLine.Reset();
        WarehouseShipmentLine.SetRange("No.", Rec."No.");
        if WarehouseShipmentLine.FindFirst() then
            repeat
                TotalQuantity := TotalQuantity + WarehouseShipmentLine.Quantity;
                if SalesLine.get(SalesLine."Document Type"::Order, WarehouseShipmentLine."Source No.", WarehouseShipmentLine."Source Line No.") then begin
                    TotalAmount2 := TotalAmount2 + WarehouseShipmentLine.Quantity * SalesLine."Unit Price";
                end;
            until WarehouseShipmentLine.Next() = 0;
    end;

    var
        TotalQuantity: Integer;
        TotalAmount2: Decimal;
}
