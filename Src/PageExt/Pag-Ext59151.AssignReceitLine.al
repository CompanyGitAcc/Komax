pageextension 59151 "TP Purch. Receipt Lines" extends "Purch. Receipt Lines"
{
    layout
    {

        addafter("Document No.")
        {
            field(PostedWhseDocNo; PostedWhseDocNo)
            {
                Caption = 'Posted Warehouse Receipt No.';
                ApplicationArea = all;
            }
            field("Posted Invoice No."; Rec."Posted Invoice No.")
            {
                Caption = 'Posted Invoice No.';
                ApplicationArea = all;
            }
            field(VendInvNo; VendInvNo)
            {
                Caption = 'Vendor Invoice No.';
                ApplicationArea = all;
            }
        }
        modify("Order No.")
        {
            Visible = true;
        }

    }

    trigger OnAfterGetRecord()
    var
        PurchInvHeader: Record "Purch. Inv. Header";
    begin
        PostedWhseDocNo := GetPostedWhseDocNo(Rec."Document No.", Rec."Order Line No.");
        Rec.CalcFields("Posted Invoice No.");
        If PurchInvHeader.Get(Rec."Posted Invoice No.") then
            VendInvNo := PurchInvHeader."Vendor Invoice No."
        else
            VendInvNo := '';
    end;

    procedure GetPostedWhseDocNo(SourceNo: Code[20]; SourceLineNo: Integer): Code[20];
    var
        PostedWhseLine: Record "Posted Whse. Receipt Line";
    begin
        PostedWhseLine.SetRange("Posted Source No.", SourceNo);
        // PostedWhseLine.SetRange("Source Line No.", SourceLineNo);
        IF PostedWhseLine.FindFirst() then
            exit(PostedWhseLine."No.")
        else
            exit('')
    end;

    var
        PostedWhseDocNo: Code[20];
        VendInvNo: Code[20];
}
