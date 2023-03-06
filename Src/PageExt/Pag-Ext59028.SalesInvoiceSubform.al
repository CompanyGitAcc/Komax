pageextension 59028 "TP Sales Invoice Subform" extends "Sales Invoice Subform"
{
    layout
    {
        modify("Description 2")
        {
            Visible = true;
        }
        addafter("Description 2")
        {
            field("VAT %"; Rec."VAT %")
            {
                ApplicationArea = all;
            }
            field(Remark; REC.Remark)
            {
                ApplicationArea = all;
            }
            field(SO; SO)
            {
                ApplicationArea = all;
            }
            field("Shipment Line No."; Rec."Shipment Line No.")
            {
                ApplicationArea = all;
            }
        }

    }

    trigger OnAfterGetRecord()
    var
        SalesHeader: Record "Sales Header";
        SalesShptLine: Record "Sales Shipment Line";
    begin
        so := '';
        if SalesShptLine.get(Rec."Shipment No.", Rec."Shipment Line No.") then begin
            so := SalesShptLine."Order No.";
        end;
    end;

    var
        SO: Code[20];
}
