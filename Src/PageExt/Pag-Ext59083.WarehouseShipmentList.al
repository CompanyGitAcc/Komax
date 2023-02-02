pageextension 59083 "TP Warehouse Shipment List" extends "Warehouse Shipment List"
{
    layout
    {
        //     //Warehouse Ship-to
        // addafter("Location Code")
        // {
        //     field("Ship-to Type"; Rec."Ship-to Type")
        //     {
        //         ApplicationArea = all;
        //     }
        //     field("Ship-to No."; Rec."Ship-to No.")
        //     {
        //         ApplicationArea = all;
        //     }
        //     field(Name; Rec."Ship-to Name")
        //     {
        //         ApplicationArea = all;
        //     }
        //     field("Ship-to Address Code"; Rec."Ship-to Address Code")
        //     {
        //         Visible = false;
        //         ApplicationArea = all;
        //     }
        //     field(Address; Rec."Ship-to Address")
        //     {
        //         Visible = false;
        //         ApplicationArea = all;
        //     }
        //     field("Phone No."; Rec."Ship-to Phone No.")
        //     {
        //         Visible = false;
        //         ApplicationArea = all;
        //     }
        //     field(Contact; Rec."Ship-to Contact")
        //     {
        //         Visible = false;
        //         ApplicationArea = all;
        //     }
        // }
        modify("Posting Date")
        {
            Visible = true;
        }

        addafter("No.")
        {
            field("Source No."; Rec."Source No.")
            {
                Caption = 'Source No.';
                ApplicationArea = all;
            }
            field("Customer No."; Rec."Customer No.")
            {
                ApplicationArea = all;
            }
        }

        addlast(Control1)
        {
            field(TotalQuantity; TotalQuantity)
            {
                Caption = 'TotalQuantity';
                ApplicationArea = all;
            }
            field(TotalAmount2; TotalAmount2)
            {
                Caption = 'TotalAmount2';
                ApplicationArea = all;
            }
        }
    }

    var
        SourceNo: Code[20];
        WarehouseShipmentLine: Record "Warehouse Shipment Line";
        SalesLine: Record "Sales Line";

    trigger OnAfterGetRecord()
    begin
        // WarehouseShipmentLine.Reset();
        // WarehouseShipmentLine.SetRange("No.", Rec."No.");
        // if WarehouseShipmentLine.FindFirst() then begin
        //     SourceNo := WarehouseShipmentLine."Source No.";
        // end else
        //     SourceNo := '';

        TotalQuantity := 0;
        TotalAmount2 := 0;
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
