pageextension 59115 "TP Get Receipt Lines" extends "Get Receipt Lines"
{
    layout
    {

        addafter("Document No.")
        {
            field("Order No."; Rec."Order No.")
            {
                ApplicationArea = all;
            }
            field(PostedWhseDocNo; PostedWhseDocNo)
            {
                Caption = 'Posted Warehouse Receipt No.';
                ApplicationArea = all;
            }
        }
        addafter(Quantity)
        {
            field("PO Qty."; Rec."PO Qty.")
            {
                ApplicationArea = all;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        PostedWhseDocNo := GetPostedWhseDocNo(Rec."Document No.", Rec."Order Line No.")
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
}
