pageextension 59114 "TP Get Shipment Lines" extends "Get Shipment Lines"
{
    layout
    {

        addafter("Document No.")
        {
            field("Order No."; Rec."Order No.")
            {
                ApplicationArea = all;
            }
            field("Salesperson Code"; Rec."Salesperson Code")
            {
                ApplicationArea = all;
            }
            field("Order Type"; Rec."Order Type")
            {
                ApplicationArea = all;
            }
            field(PostedWhseDocNo; PostedWhseDocNo)
            {
                Caption = 'Posted Warehouse Shipment No.';
                ApplicationArea = all;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        PostedWhseDocNo := GetPostedWhseDocNo(Rec."Order No.", Rec."Order Line No.")
    end;

    procedure GetPostedWhseDocNo(SourceNo: Code[20]; SourceLineNo: Integer): Code[20];
    var
        PostedWhseLine: Record "Posted Whse. Shipment Line";
    begin
        PostedWhseLine.SetRange("Source No.", SourceNo);
        PostedWhseLine.SetRange("Source Line No.", SourceLineNo);
        IF PostedWhseLine.FindFirst() then
            exit(PostedWhseLine."No.")
        else
            exit('')
    end;

    var
        PostedWhseDocNo: Code[20];
}
