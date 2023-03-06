pageextension 59111 "TP Sales Shipment Lines" extends "Sales Shipment Lines"
{
    layout
    {
        addafter("Sell-to Customer No.")
        {
            field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
            {
                ApplicationArea = all;
            }
            field("Order Date"; Rec."Order Date")
            {
                ApplicationArea = all;
            }
            field("Order Type"; Rec."Order Type")
            {
                ApplicationArea = all;
            }
            field("External Document No."; Rec."External Document No.")
            {
                ApplicationArea = all;
                Visible = true;
            }
            // field("Komax Reason Code"; Rec."Komax Reason Code")
            // {
            //     ApplicationArea = all;
            // }
        }
        // addafter("Unit of Measure Code")
        // {
        //     field("Unit of Measure Short Desc."; Rec."Unit of Measure Short Desc.")
        //     {
        //         ApplicationArea = all;
        //     }
        // }
        addbefore("Sell-to Customer No.")
        {
            field("Sales Order No"; Rec."Order No.")
            {
                ApplicationArea = all;
            }
        }
        moveafter("Order Type"; "Document No.")
        moveafter("Document No."; "No.")
        moveafter("No."; Description)
        moveafter(Description; "Location Code")
        moveafter("Location Code"; Quantity)
        moveafter(Quantity; "Shipment Date")
        modify("Shipment Date")
        {
            Visible = false;
        }
        modify("Unit of Measure Code")
        {
            Visible = false;
        }
        modify("Quantity Invoiced")
        {
            Visible = false;
        }
        modify("Document No.")
        {
            Visible = true;
            HideValue = false;
        }
        addafter(Quantity)
        {
            field("Posting Date 2"; Rec."Posting Date 2")
            {
                ApplicationArea = all;
                Caption = 'Shipment Date';
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SETRANGE(Type, Rec.Type::Item);
        //SETFILTER("No.",'<>%1','');
        Rec.SETFILTER(Quantity, '<>%1', 0);
    end;

    trigger OnAfterGetRecord()
    begin
        Grcd_ShipHeader.RESET;
        Grcd_ShipHeader.SETRANGE(Grcd_ShipHeader."No.", Rec."Document No.");
        IF Grcd_ShipHeader.FIND('-') THEN BEGIN
            CustomerName := Grcd_ShipHeader."Sell-to Customer Name 2";
            PostingDate := Grcd_ShipHeader."Posting Date";
            OrderDate := Grcd_ShipHeader."Order Date";
            OrderType := Grcd_ShipHeader."Order Type";
        END
        ELSE BEGIN
            CustomerName := '';
            PostingDate := Rec."Posting Date";
            OrderDate := 0D;
            Evaluate(OrderType, '');
        END;
    end;

    var
        OrderDate: Date;

        Grcd_SalesHeader: Record "Sales Header";
        Grcd_ShipHeader: Record "Sales Shipment Header";
        PostingDate: Date;
        CustomerName: Text[80];
        ExportToExcel: Boolean;
        TempExcelBuffer: Record "Excel Buffer";
        RowNo: Integer;
        OrderType: Enum "Sales Order Type";
}
