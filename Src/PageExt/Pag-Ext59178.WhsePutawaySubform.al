pageextension 59178 "TP Whse. Put-away Subform" extends "Whse. Put-away Subform"
{
    layout
    {
        addafter("Item No.")
        {
            field(ItemReferenceNo; ItemReferenceNo)
            {
                Caption = 'Item Reference No.';
                ApplicationArea = all;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        ItemReferenceNo := '';

        if Rec."Source Document" = Rec."Source Document"::"Purchase Order" then begin
            if PurchaseHeader.get(PurchaseHeader."Document Type"::Order, Rec."Source No.") then begin
                ItemReference.Reset();
                ItemReference.SetRange("Reference Type No.", PurchaseHeader."Buy-from Vendor No.");
                ItemReference.SetRange("Item No.", Rec."Item No.");
                if ItemReference.FindFirst() then begin
                    ItemReferenceNo := ItemReference."Reference No.";
                end;
            end;
        end;

        if Rec."Source Document" = Rec."Source Document"::"Sales Return Order" then begin
            if SalesHeader.get(SalesHeader."Document Type"::Order, Rec."Source No.") then begin
                ItemReference.Reset();
                ItemReference.SetRange("Reference Type No.", SalesHeader."Sell-to Customer No.");
                ItemReference.SetRange("Item No.", Rec."Item No.");
                if ItemReference.FindFirst() then begin
                    ItemReferenceNo := ItemReference."Reference No.";
                end;
            end;
        end;
    end;

    var
        ItemReferenceNo: Code[20];
        ItemReference: Record "Item Reference";
        PurchaseHeader: Record "Purchase Header";
        SalesHeader: Record "Sales Header";
}
