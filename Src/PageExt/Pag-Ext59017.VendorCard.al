pageextension 59017 "TP Vendor Card" extends "Vendor Card"
{
    layout
    {
        addafter("Name 2")
        {
            field("Short Name"; Rec."Short Name")
            {
                ApplicationArea = all;
            }
        }
        modify("Name 2")
        {
            Visible = true;
            Importance = Promoted;
        }
    }

    actions
    {
        moveafter("F&unctions"; OrderAddresses)
    }
}
