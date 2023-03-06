pageextension 59105 "TP Vendor Ledger Entries" extends "Vendor Ledger Entries"
{
    layout
    {
        modify("External Document No.")
        {
            Visible = true;
        }
        addafter(Description)
        {
            field("Order No."; Rec."Order No.") { ApplicationArea = all; }
            field("Advance Payment"; Rec."Advance Payment") { ApplicationArea = all; }
        }

        addlast(Control1)
        {
            field("Vendor Posting Group"; Rec."Vendor Posting Group")
            {
                ApplicationArea = all;
            }
            field(SystemCreatedBy; TPUtilities.GetCreatedByName(Rec.SystemCreatedBy))
            {
                Caption = 'Created By';
            }
        }
        modify(Reversed)
        {
            Visible = true;
        }
        addfirst(Control1)
        {
            field("Document Date"; Rec."Document Date")
            {
                ApplicationArea = all;
            }
        }
    }

    var
        TPUtilities: Codeunit "TP Utilities";
}
