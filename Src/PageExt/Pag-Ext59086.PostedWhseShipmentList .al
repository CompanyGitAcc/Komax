pageextension 59086 "TP Posted Whse. Shipment List" extends "Posted Whse. Shipment List"
{
    layout
    {
        // addafter("Location Code")
        // {
        //     field("Location Name"; Rec."Location Name")
        //     {
        //         ApplicationArea = ALL;
        //     }
        //     field(PrintCount; PrintCount2)
        //     {
        //         ApplicationArea = ALL;
        //     }
        //     field("Ship-to Type"; Rec."Ship-to Type")
        //     {
        //         ApplicationArea = all;
        //     }
        //     field("Customer No."; Rec."Ship-to No.")
        //     {
        //         ApplicationArea = all;
        //     }
        //     field("Ship-to Address"; Rec."Ship-to Address Code")
        //     {
        //         Visible = false;
        //         ApplicationArea = all;
        //     }
        //     field(Name; Rec."Ship-to Name")
        //     {
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
        WarehouseShipmentLine: Record "Posted Whse. Shipment Line";
        SalesLine: Record "Sales Line";
        TotalQuantity: Integer;
        TotalAmount2: Decimal;
        PrintCount2: Integer;

    trigger OnAfterGetRecord()
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
}
