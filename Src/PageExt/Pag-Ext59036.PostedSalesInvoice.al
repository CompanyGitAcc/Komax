pageextension 59036 "TP Posted Sales Invoice" extends "Posted Sales Invoice"
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
            field("Order Type"; REc."Order Type")
            {
                ApplicationArea = all;
            }
        }
        addlast("Bill-to")
        {
            field("Bill-to Department"; Rec."Bill-to Department")
            {
                ApplicationArea = all;
            }
        }

        modify("Order No.")
        {
            Visible = true;
        }
        movebefore("External Document No."; "Order No.")
    }
    var
        TPUtilities: Codeunit "TP Utilities";
}
