pageextension 59042 "TP Posted Sales Credit Memo" extends "Posted Sales Credit Memo"
{
    layout
    {
        addlast(General)
        {
            field(SystemCreatedBy; TPUtilities.GetCreatedByName(Rec.SystemCreatedBy))
            {
                Caption = 'Created By';
            }
            field(SystemCreatedAt; Rec.SystemCreatedAt)
            {
                Caption = 'Created At';
            }
            field("Order Type"; Rec."Order Type")
            {
                ApplicationArea = all;
            }
            field("Sales Commision (%)"; Rec."Sales Commision (%)")
            {
                ApplicationArea = all;
            }
        }
    }
    var
        TPUtilities: Codeunit "TP Utilities";
}
