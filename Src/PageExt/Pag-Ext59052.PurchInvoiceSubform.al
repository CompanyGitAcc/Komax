pageextension 59052 "TP Purch. Invoice Subform" extends "Purch. Invoice Subform"
{
    layout
    {
        addafter(Description)
        {
            field("PO No."; Rec."PO No.")
            {
                ApplicationArea = all;
            }
        }
    }
}
