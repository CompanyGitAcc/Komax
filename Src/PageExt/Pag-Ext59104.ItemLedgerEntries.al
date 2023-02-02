pageextension 59104 "TP Item Ledger Entries" extends "Item Ledger Entries"
{
    PromotedActionCategories = 'New,Process,Report,Entry,Print';

    layout
    {
        // addafter("Location Code")
        // {
        //     field(PostedWhseDocNo; PostedWhseDocNo)
        //     {
        //         Caption = 'PostedWhseShipmentLineNo';
        //         ApplicationArea = all;
        //     }
        // }
        modify("Cost Amount (Expected)")
        {
            Visible = true;
        }
    }

    actions
    {
        addlast(processing)
        {

        }

    }

    views
    {
        addfirst
        {
            view("Other Stock IN")
            {
                Caption = 'Other Stock IN';
                Filters = where("Entry Type" = const("Positive Adjmt."));
                OrderBy = descending("Entry No.");
            }
            view("Other Stock Out")
            {
                Caption = 'Other Stock Out';
                Filters = where("Entry Type" = const("Negative Adjmt."));
                OrderBy = descending("Entry No.");
            }
            view(Transfer)
            {
                Caption = 'Transfer';
                Filters = where("Entry Type" = const("Transfer"));
                OrderBy = descending("Entry No.");
            }
            view(Sales)
            {
                Caption = 'Sales';
                Filters = where("Entry Type" = const("Sale"));
                OrderBy = descending("Entry No.");
            }
            view(Purchase)
            {
                Caption = 'Purchase';
                Filters = where("Entry Type" = const("Purchase"));
                OrderBy = descending("Entry No.");
            }
            view(Assembly)
            {
                Caption = 'Assembly';
                Filters = where("Entry Type" = filter("Assembly Consumption" | "Assembly Output"));
                OrderBy = descending("Entry No.");
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        // if Rec."Entry Type" = Rec."Entry Type"::Sale then begin
        //     PostedWhseShipmentLine.Reset();
        //     PostedWhseShipmentLine.SetRange("Posted Source No.", Rec."Document No.");
        //     if PostedWhseShipmentLine.FindFirst() then begin
        //         PostedWhseDocNo := PostedWhseShipmentLine."No.";
        //     end else begin
        //         PostedWhseDocNo := '';
        //     end;
        // end else begin
        //     PostedWhseDocNo := '';
        // end;

        // if Rec."Entry Type" = Rec."Entry Type"::Purchase then begin
        //     PostedWhseReceiptLine.Reset();
        //     PostedWhseReceiptLine.SetRange("Posted Source No.", Rec."Document No.");
        //     if PostedWhseReceiptLine.FindFirst() then begin
        //         PostedWhseDocNo := PostedWhseReceiptLine."No.";
        //     end else begin
        //         PostedWhseDocNo := '';
        //     end;
        // end else begin
        //     if Rec."Entry Type" <> Rec."Entry Type"::Sale then
        //         PostedWhseDocNo := '';
        // end;

    end;

    var
        PostedWhseDocNo: Code[20];
        PostedWhseShipmentLine: Record "Posted Whse. Shipment Line";
        PostedWhseReceiptLine: Record "Posted Whse. Receipt Line";

}
