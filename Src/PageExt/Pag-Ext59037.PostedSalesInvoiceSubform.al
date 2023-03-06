pageextension 59037 "TP Posted Sales Inv. Subform" extends "Posted Sales Invoice Subform"
{
    layout
    {
        addafter(Description)
        {
            field("Order No."; Rec."Order No.")
            {
                ApplicationArea = all;
            }
            field("Order Line No."; Rec."Order Line No.")
            {
                ApplicationArea = all;
            }
            field(ExtDocNo; ExtDocNo)
            {
                Caption = 'External Document No.';
                ApplicationArea = all;
            }
        }
        modify("Location Code")
        {
            Visible = true;
        }
        addlast(Control1)
        {
            // field(Commision; REC.Commision)
            // {
            //     ApplicationArea = ALL;
            // }
            // field("Unit of Measure Short Desc."; REC."Unit of Measure Short Desc.")
            // {
            //     ApplicationArea = ALL;
            // }
            // field("Drop Vendor No."; REC."Drop Vendor No.")
            // {
            //     ApplicationArea = ALL;
            // }
            // field("Komax Reason Code"; REC."Komax Reason Code")
            // {
            //     ApplicationArea = ALL;
            // }
            // field("Sales Type"; REC."Sales Type")
            // {
            //     ApplicationArea = ALL;
            // }
            // field("Sales Commision (%)"; REC."Sales Commision (%)")
            // {
            //     ApplicationArea = ALL;
            // }
        }

    }
    trigger OnAfterGetRecord()
    var
        SalesHeader: Record "Sales Header";
    begin
        ExtDocNo := '';
        IF SalesHeader.get(SalesHeader."Document Type"::Order, Rec."Order No.") then begin
            ExtDocNo := SalesHeader."External Document No.";
        end;
    end;

    var
        ExtDocNo: Code[35];
}
