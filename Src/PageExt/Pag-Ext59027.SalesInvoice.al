pageextension 59027 "TP Sales Invoice" extends "Sales Invoice"
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
        }
        modify("Posting Description")
        {
            Visible = true;
        }
        movelast(General; "Posting Description")

        addbefore("External Document No.")
        {
            field("Order NO."; Rec."Order NO.")
            {
                ApplicationArea = all;
            }
        }
    }
    var
        TPUtilities: Codeunit "TP Utilities";
}
