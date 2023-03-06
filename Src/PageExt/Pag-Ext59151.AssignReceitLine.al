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
            field("Vendor Invoice No."; Rec."Vendor Invoice No.")
            {
                ApplicationArea = all;
            }
            // field(VendInvNo; VendInvNo)
            // {
            //     Caption = 'Vendor Invoice No.';
            //     ApplicationArea = all;
            // }
            field("Posting Date"; Rec."Posting Date")
            {
                ApplicationArea = all;
            }
        }
        modify("Order No.")
        {
            Visible = true;
        }

    }

    trigger OnOpenPage()
    var
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchRceiptLine: Record "Purch. Rcpt. Line";
    begin
        PurchRceiptLine.Reset();
        PurchRceiptLine.SetRange(Type, PurchRceiptLine.Type::Item);
        PurchRceiptLine.Setfilter("Quantity Invoiced", '<>0');
        PurchRceiptLine.SetRange("Vendor Invoice No.", '');
        if PurchRceiptLine.FindFirst() then
            repeat
                PurchRceiptLine.CalcFields("Posted Invoice No.");
                If PurchInvHeader.Get(PurchRceiptLine."Posted Invoice No.") then
                    PurchRceiptLine."Vendor Invoice No." := PurchInvHeader."Vendor Invoice No."
                else
                    PurchRceiptLine."Vendor Invoice No." := '';
                PurchRceiptLine.Modify();
            until PurchRceiptLine.Next() = 0;
        Commit();
    end;

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
        VendInvNo: Code[100];
}
