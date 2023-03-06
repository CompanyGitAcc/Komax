pageextension 59051 "TP Purchase Invoice" extends "Purchase Invoice"
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
        modify("Document Date")
        {
            Importance = Promoted;
        }
        addafter("Buy-from Vendor Name")
        {
            field("Buy-from Vendor Name 2"; Rec."Buy-from Vendor Name 2")
            {
                ApplicationArea = all;
            }
        }
    }
    var
        TPUtilities: Codeunit "TP Utilities";
}
